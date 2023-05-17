
let exe = Sys.argv.(0)
let usage = Printf.sprintf "%s <file> --workspace <workspace>" exe
let input_files = ref []
let workspace_path = ref ""

let options = Arg.align [
  "--workspace",
  Arg.Set_string workspace_path,
  "PATH Relative path to the Dune workspace for better locations";
]

let set_file file = input_files := file :: !input_files

let parse () =
  Arg.parse options set_file usage ;
  match !input_files with
  | [ input_file ] -> input_file, !workspace_path
  | _ -> 
      Arg.usage options usage ;
      exit 2

module Process = struct
  open Lwt.Infix
  
  let pp_args =
    let sep = Fmt.(const string) " " in
    Fmt.(array ~sep (quote string))

  let pp_cmd f = function
    | "", args -> pp_args f args
    | bin, args -> Fmt.pf f "(%S, %a)" bin pp_args args

  let pp_status f = function
    | Unix.WEXITED x -> Fmt.pf f "exited with status %d" x
    | Unix.WSIGNALED x -> Fmt.pf f "failed with signal %d" x
    | Unix.WSTOPPED x -> Fmt.pf f "stopped with signal %d" x

  let check_status cmd = function
    | Unix.WEXITED 0 -> ()
    | status -> Fmt.failwith "%a %a" pp_cmd cmd pp_status status
  
  let exec cmd =
    let proc = Lwt_process.open_process_none cmd in
    proc#status >|= check_status cmd
end

(* This is a wrapper around `dream_eml` that outputs the generated file on stdout so it can be used by dune. *)
let main () =    
  let input_file, workspace_path = parse () in
  let open Lwt.Syntax in
  let* () = Process.exec ("dream_eml", [| "dream_eml"; input_file; "--workspace"; workspace_path|]) in
  let* () = Process.exec ("cat", [| input_file ^ ".ml" |]) in
  Lwt.return ()

let () = Lwt_main.run (main ())
