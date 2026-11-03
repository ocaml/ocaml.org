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

let env extra =
  Array.append (Unix.environment ())
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
