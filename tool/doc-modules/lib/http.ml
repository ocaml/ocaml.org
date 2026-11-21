(* GET requests to the documentation backend, within the load limits agreed with
   its admins: one kept-alive connection, sequential requests started at most
   [rate] per second, gzip-encoded responses, and ETag revalidation by the
   caller (If-None-Match). Every request is bounded by [max_time] seconds.

   The backend's ETags depend on the encoding ("...-gzip"), so every request
   asks for gzip, and only gzip, for revalidations to match. *)

type response = {
  status : int;
  body : string;  (** decoded *)
  etag : string option;
  last_modified : string option;
  bytes : int;  (** as transferred *)
}

module C = Cohttp_lwt_unix

type t = {
  ctx : C.Net.ctx;
  interval : float;
  max_time : float;
  mutable conn : C.Connection.t option;
  mutable next : float;  (** earliest start of the next request *)
  mutable requests : int;
}

let create ~rate ~max_time =
  {
    ctx = Lazy.force C.Net.default_ctx;
    interval = 1. /. rate;
    max_time;
    conn = None;
    next = 0.;
    requests = 0;
  }

let requests t = t.requests

let close t =
  Option.iter C.Connection.close t.conn;
  t.conn <- None

let gunzip s =
  let i = De.bigstring_create De.io_buffer_size in
  let o = De.bigstring_create De.io_buffer_size in
  let out = Buffer.create (4 * String.length s) in
  let pos = ref 0 in
  let refill buf =
    let len = min (String.length s - !pos) De.io_buffer_size in
    for k = 0 to len - 1 do
      Bigarray.Array1.unsafe_set buf k (String.unsafe_get s (!pos + k))
    done;
    pos := !pos + len;
    len
  in
  let flush buf len =
    for k = 0 to len - 1 do
      Buffer.add_char out (Bigarray.Array1.unsafe_get buf k)
    done
  in
  match Gz.Higher.uncompress ~refill ~flush i o with
  | Ok _ -> Ok (Buffer.contents out)
  | Error (`Msg m) -> Error ("gzip: " ^ m)

let user_agent = "ocaml.org-doc-modules (https://github.com/ocaml/ocaml.org)"

let connection t uri =
  let open Lwt.Syntax in
  match t.conn with
  | Some c when not (C.Connection.is_closed c) -> Lwt.return (c, true)
  | _ ->
      close t;
      let* endp = C.Net.resolve ~ctx:t.ctx uri in
      let* c = C.Connection.connect ~ctx:t.ctx endp in
      t.conn <- Some c;
      Lwt.return (c, false)

(* One exchange. A request on a reused connection that fails before any response
   (the backend closed the idle connection) is sent again on a new one, unless
   the request was abandoned ([live] false: its time is up, and the failure is
   the timeout closing the connection), which must not be retried: the retry
   would run unbounded, uncounted and outside the rate limit. *)
let rec exchange t uri headers ~live ~retry =
  let open Lwt.Syntax in
  let* c, reused = connection t uri in
  Lwt.catch
    (fun () ->
      let* response, body = C.Connection.call c ~headers `GET uri in
      let* raw = Cohttp_lwt.Body.to_string body in
      Lwt.return (response, raw))
    (fun e ->
      close t;
      match e with
      | Lwt.Canceled -> Lwt.reraise e
      | _ when reused && retry && !live ->
          exchange t uri headers ~live ~retry:false
      | _ -> Lwt.reraise e)

let decode response raw =
  let h = Cohttp.Response.headers response in
  let status = Cohttp.Code.code_of_status (Cohttp.Response.status response) in
  let declared =
    Option.bind (Cohttp.Header.get h "content-length") int_of_string_opt
  in
  match declared with
  | Some n when n <> String.length raw ->
      Error
        (Printf.sprintf "truncated body: %d of %d bytes" (String.length raw) n)
  | _ -> (
      let body =
        match Cohttp.Header.get h "content-encoding" with
        | Some "gzip" when raw <> "" -> gunzip raw
        | Some ("gzip" | "identity") | None -> Ok raw
        | Some e -> Error ("unexpected content-encoding " ^ e)
      in
      match body with
      | Error e -> Error e
      | Ok body ->
          Ok
            {
              status;
              body;
              etag = Cohttp.Header.get h "etag";
              last_modified = Cohttp.Header.get h "last-modified";
              bytes = String.length raw;
            })

let get t ?etag uri =
  let open Lwt.Syntax in
  let* () =
    let now = Unix.gettimeofday () in
    if t.next > now then Lwt_unix.sleep (t.next -. now) else Lwt.return_unit
  in
  t.next <- Unix.gettimeofday () +. t.interval;
  t.requests <- t.requests + 1;
  let headers =
    Cohttp.Header.of_list
      ([ ("Accept-Encoding", "gzip"); ("User-Agent", user_agent) ]
      @ match etag with Some e -> [ ("If-None-Match", e) ] | None -> [])
  in
  let live = ref true in
  let fetch () =
    Lwt.catch
      (fun () ->
        let* response, raw = exchange t uri headers ~live ~retry:true in
        Lwt.return (decode response raw))
      (fun e -> Lwt.return (Error (Printexc.to_string e)))
  in
  let timeout () =
    let* () = Lwt_unix.sleep t.max_time in
    live := false;
    close t;
    Lwt.return (Error (Printf.sprintf "timed out after %gs" t.max_time))
  in
  let* r = Lwt.pick [ fetch (); timeout () ] in
  (match r with Error _ -> close t | Ok _ -> ());
  Lwt.return r
