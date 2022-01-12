module String = struct
  include Stdlib.String

  let contains_s s1 s2 =
    try
      let len = String.length s2 in
      for i = 0 to String.length s1 - len do
        if String.sub s1 i len = s2 then raise Exit
      done;
      false
    with
    | Exit ->
      true
end

module List = struct
  include Stdlib.List

  let take n xs =
    let rec aux i acc = function
      | [] ->
        acc
      | _ when i = 0 ->
        acc
      | y :: ys ->
        aux (i - 1) (y :: acc) ys
    in
    aux n [] xs |> List.rev

  let skip n xs =
    let rec aux i = function
      | [] ->
        []
      | l when i = 0 ->
        l
      | _ :: ys ->
        aux (i - 1) ys
    in
    aux n xs
end

module Unix = struct
  include Unix

  let rec mkdir_p ?perm dir =
    let mkdir_idempotent ?(perm = 0o777) dir =
      match Unix.mkdir dir perm with
      | () ->
        ()
      (* [mkdir] on MacOSX returns [EISDIR] instead of [EEXIST] if the directory
         already exists. *)
      | exception Unix.Unix_error ((EEXIST | EISDIR), _, _) ->
        ()
    in
    match mkdir_idempotent ?perm dir with
    | () ->
      ()
    | exception (Unix.Unix_error (ENOENT, _, _) as exn) ->
      let parent = Filename.dirname dir in
      if String.equal parent dir then
        raise exn
      else (
        mkdir_p ?perm parent;
        mkdir_idempotent ?perm dir)

  let read_file path =
    let ic = open_in path in
    Fun.protect
      (fun () ->
        let length = in_channel_length ic in
        let buffer = Bytes.create length in
        really_input ic buffer 0 length;
        Bytes.to_string buffer)
      ~finally:(fun () -> close_in ic)

  let write_file file content =
    let oc = open_out file in
    Fun.protect
      (fun () -> output_string oc content)
      ~finally:(fun () -> close_out oc)
end
