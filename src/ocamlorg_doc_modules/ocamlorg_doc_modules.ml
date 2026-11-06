let format_version = 1
let magic = "DMI1"
let header_size = 64
let package_entry = 16
let key_entry = 16

type package = { name : string; version : string; modules : string list }

module Writer = struct
  let add_u32 b n =
    if n < 0 || n > 0xFFFF_FFFF then invalid_arg "Ocamlorg_doc_modules: u32";
    Buffer.add_int32_le b (Int32.of_int (n land 0xFFFF_FFFF))

  let to_string packages =
    let packages =
      List.sort (fun a b -> String.compare a.name b.name) packages
      |> Array.of_list
    in
    Array.iteri
      (fun i p ->
        if i > 0 && String.equal packages.(i - 1).name p.name then
          invalid_arg ("Ocamlorg_doc_modules: duplicate package " ^ p.name))
      packages;
    let np = Array.length packages in
    (* lowercased path -> package indices *)
    let tbl = Hashtbl.create 100_000 in
    Array.iteri
      (fun i p ->
        List.iter
          (fun m ->
            let k = String.lowercase_ascii m in
            let prev = Option.value ~default:[] (Hashtbl.find_opt tbl k) in
            Hashtbl.replace tbl k (i :: prev))
          p.modules)
      packages;
    let keys =
      Hashtbl.fold
        (fun k l acc -> (k, List.sort_uniq Int.compare l) :: acc)
        tbl []
      |> List.sort (fun (a, _) (b, _) -> String.compare a b)
      |> Array.of_list
    in
    let nk = Array.length keys in
    let npost = Array.fold_left (fun n (_, l) -> n + List.length l) 0 keys in
    let off_pkgs = header_size in
    let off_keys = off_pkgs + (np * package_entry) in
    let off_post = off_keys + (nk * key_entry) in
    let off_str = off_post + (4 * npost) in
    (* strings, recording absolute offsets *)
    let strings = Buffer.create (1024 * 1024) in
    let add_string s =
      let o = off_str + Buffer.length strings in
      Buffer.add_string strings s;
      (o, String.length s)
    in
    let pkg_refs =
      Array.map (fun p -> (add_string p.name, add_string p.version)) packages
    in
    let key_refs = Array.map (fun (k, _) -> add_string k) keys in
    let body = Buffer.create (off_str - header_size + Buffer.length strings) in
    Array.iter
      (fun ((no, nl), (vo, vl)) ->
        add_u32 body no;
        add_u32 body nl;
        add_u32 body vo;
        add_u32 body vl)
      pkg_refs;
    let first = ref 0 in
    Array.iteri
      (fun i (_, l) ->
        let ko, kl = key_refs.(i) in
        let count = List.length l in
        add_u32 body ko;
        add_u32 body kl;
        add_u32 body !first;
        add_u32 body count;
        first := !first + count)
      keys;
    Array.iter (fun (_, l) -> List.iter (add_u32 body) l) keys;
    Buffer.add_buffer body strings;
    let body = Buffer.contents body in
    let header = Buffer.create header_size in
    Buffer.add_string header magic;
    List.iter (add_u32 header)
      [
        format_version;
        np;
        nk;
        off_pkgs;
        off_keys;
        off_post;
        off_str;
        String.length body;
      ];
    Buffer.add_string header (Digest.string body);
    Buffer.add_string header
      (String.make (header_size - Buffer.length header) '\000');
    Buffer.contents header ^ body
end

module Reader = struct
  type bytes_ =
    (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t

  type t = {
    ba : bytes_;
    len : int;
    np : int;
    nk : int;
    off_pkgs : int;
    off_keys : int;
    off_post : int;
    off_str : int;
    npost : int;
  }

  exception Damaged

  let get = Bigarray.Array1.unsafe_get

  (* Callers check [off + 4 <= dim] first. *)
  let u32 ba off =
    Char.code (get ba off)
    lor (Char.code (get ba (off + 1)) lsl 8)
    lor (Char.code (get ba (off + 2)) lsl 16)
    lor (Char.code (get ba (off + 3)) lsl 24)

  let of_bigarray ba =
    let len = Bigarray.Array1.dim ba in
    let ( let* ) = Result.bind in
    let check cond msg = if cond then Ok () else Error msg in
    let* () = check (len >= header_size) "shorter than the header" in
    let* () =
      check
        (String.init 4 (fun i -> get ba i) = magic)
        "not a doc-modules index (bad magic)"
    in
    let version = u32 ba 4 in
    let* () =
      check (version = format_version)
        (Printf.sprintf "format version %d, expected %d" version format_version)
    in
    let np = u32 ba 8 and nk = u32 ba 12 in
    let off_pkgs = u32 ba 16 and off_keys = u32 ba 20 in
    let off_post = u32 ba 24 and off_str = u32 ba 28 in
    let body_len = u32 ba 32 in
    let* () = check (len = header_size + body_len) "truncated or padded" in
    let* () =
      check
        (off_pkgs = header_size
        && off_keys = off_pkgs + (np * package_entry)
        && off_post = off_keys + (nk * key_entry)
        && off_post <= off_str && off_str <= len
        && (off_str - off_post) mod 4 = 0)
        "inconsistent section offsets"
    in
    Ok
      {
        ba;
        len;
        np;
        nk;
        off_pkgs;
        off_keys;
        off_post;
        off_str;
        npost = (off_str - off_post) / 4;
      }

  let of_string s =
    let ba =
      Bigarray.Array1.create Bigarray.char Bigarray.c_layout (String.length s)
    in
    String.iteri (fun i c -> Bigarray.Array1.unsafe_set ba i c) s;
    of_bigarray ba

  let map_file path =
    match Unix.openfile path [ Unix.O_RDONLY ] 0 with
    | exception Unix.Unix_error (e, _, _) -> Error (Unix.error_message e)
    | fd -> (
        match
          Fun.protect
            ~finally:(fun () -> Unix.close fd)
            (fun () ->
              Bigarray.array1_of_genarray
                (Unix.map_file fd Bigarray.char Bigarray.c_layout false [| -1 |]))
        with
        | ba -> of_bigarray ba
        | exception Unix.Unix_error (e, _, _) -> Error (Unix.error_message e)
        | exception (Invalid_argument _ | Failure _) ->
            Error "cannot map the file")

  let package_count t = t.np
  let key_count t = t.nk

  (* A string reference, checked against the string area. *)
  let string_ref t off =
    let o = u32 t.ba off and l = u32 t.ba (off + 4) in
    if o < t.off_str || o + l > t.len then raise Damaged;
    (o, l)

  let read_string t (o, l) = String.init l (fun i -> get t.ba (o + i))
  let key_ref t i = string_ref t (t.off_keys + (i * key_entry))
  let name_ref t i = string_ref t (t.off_pkgs + (i * package_entry))
  let version_ref t i = string_ref t (t.off_pkgs + (i * package_entry) + 8)

  (* The lookup path allocates nothing but its result: top-level functions with
     plain arguments (no closures, no tuples). *)

  (* Compare bytes [o + i, o + l) with [q.[i], ...], as String.compare. *)
  let rec compare_from ba o l q ql i =
    if i = l || i = ql then Int.compare l ql
    else
      let c = Char.compare (get ba (o + i)) (String.unsafe_get q i) in
      if c <> 0 then c else compare_from ba o l q ql (i + 1)

  (* Compare key [i] with [q]. *)
  let compare_key t i q =
    let e = t.off_keys + (i * key_entry) in
    let o = u32 t.ba e and l = u32 t.ba (e + 4) in
    if o < t.off_str || o + l > t.len then raise Damaged;
    compare_from t.ba o l q (String.length q) 0

  let rec search t q lo hi =
    if lo >= hi then -1
    else
      let mid = (lo + hi) / 2 in
      let c = compare_key t mid q in
      if c = 0 then mid
      else if c < 0 then search t q (mid + 1) hi
      else search t q lo mid

  let name_at t p =
    if p >= t.np then raise Damaged;
    let e = t.off_pkgs + (p * package_entry) in
    let o = u32 t.ba e and l = u32 t.ba (e + 4) in
    if o < t.off_str || o + l > t.len then raise Damaged;
    let b = Bytes.create l in
    for i = 0 to l - 1 do
      Bytes.unsafe_set b i (get t.ba (o + i))
    done;
    Bytes.unsafe_to_string b

  let rec collect t first j acc =
    if j < 0 then acc
    else
      let p = u32 t.ba (t.off_post + (4 * (first + j))) in
      collect t first (j - 1) (name_at t p :: acc)

  let providers t path =
    let q = String.lowercase_ascii path in
    match search t q 0 t.nk with
    | -1 -> []
    | i ->
        let e = t.off_keys + (i * key_entry) in
        let first = u32 t.ba (e + 8) and count = u32 t.ba (e + 12) in
        if first + count > t.npost then [] else collect t first (count - 1) []
    | exception Damaged -> []

  let packages t =
    try
      List.init t.np (fun i ->
          (read_string t (name_ref t i), read_string t (version_ref t i)))
    with Damaged -> []

  let verify t =
    let body =
      String.init (t.len - header_size) (fun i -> get t.ba (header_size + i))
    in
    let stored = String.init 16 (fun i -> get t.ba (36 + i)) in
    if not (String.equal (Digest.string body) stored) then
      Error "MD5 mismatch: the body is damaged"
    else
      try
        let prev = ref None in
        for i = 0 to t.np - 1 do
          let name = read_string t (name_ref t i) in
          ignore (version_ref t i);
          (match !prev with
          | Some p when String.compare p name >= 0 ->
              failwith ("packages not sorted at " ^ name)
          | _ -> ());
          prev := Some name
        done;
        let prev = ref None and next_first = ref 0 in
        for i = 0 to t.nk - 1 do
          let key = read_string t (key_ref t i) in
          (match !prev with
          | Some p when String.compare p key >= 0 ->
              failwith ("keys not sorted at " ^ key)
          | _ -> ());
          prev := Some key;
          let e = t.off_keys + (i * key_entry) in
          let first = u32 t.ba (e + 8) and count = u32 t.ba (e + 12) in
          if first <> !next_first || count = 0 then
            failwith ("postings not contiguous at " ^ key);
          next_first := first + count;
          let last = ref (-1) in
          for j = first to first + count - 1 do
            let p = u32 t.ba (t.off_post + (4 * j)) in
            if p >= t.np || p <= !last then failwith ("bad posting for " ^ key);
            last := p
          done
        done;
        if !next_first <> t.npost then failwith "unused postings";
        Ok ()
      with
      | Damaged -> Error "a string reference is out of bounds"
      | Failure m -> Error m
end
