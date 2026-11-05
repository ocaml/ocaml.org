(* Running external commands (git, docker) from Lwt. *)

open Lwt.Syntax

exception Failed of string

let show argv = String.concat " " argv

let check argv = function
  | Unix.WEXITED 0 -> ()
  | Unix.WEXITED n ->
      raise (Failed (Printf.sprintf "%s: exit %d" (show argv) n))
  | Unix.WSIGNALED n | Unix.WSTOPPED n ->
      raise (Failed (Printf.sprintf "%s: signal %d" (show argv) n))

(* The current environment with [extra] set. Keys of [extra] are removed from
   the inherited environment first: with a duplicate, glibc [getenv] and Go
   (docker compose) keep the first, so an exported [SIM_IMAGE] in the shell
   would otherwise win over the image [sim] was asked to run. *)
let env extra =
  let overridden kv =
    match String.index_opt kv '=' with
    | Some i -> List.mem_assoc (String.sub kv 0 i) extra
    | None -> false
  in
  Array.append
    (Array.of_list
       (List.filter
          (fun kv -> not (overridden kv))
          (Array.to_list (Unix.environment ()))))
    (Array.of_list (List.map (fun (k, v) -> k ^ "=" ^ v) extra))

(* Run [argv] and return its standard output; raise [Failed] on a non-zero
   exit. *)
let read ?(extra_env = []) argv =
  let cmd = ("", Array.of_list argv) in
  Lwt_process.with_process_in ~env:(env extra_env) cmd (fun p ->
      let* out = Lwt_io.read p#stdout in
      let+ status = p#close in
      check argv status;
      out)

let run ?(extra_env = []) argv =
  let+ status =
    Lwt_process.exec ~env:(env extra_env) ("", Array.of_list argv)
  in
  check argv status

let lines s = String.split_on_char '\n' s |> List.filter (( <> ) "")
