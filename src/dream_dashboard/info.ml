let () = Printexc.record_backtrace true

open Import

let ocaml_version = Sys.ocaml_version

let version () =
  let open Build_info.V1 in
  match version () with
  | None -> "dev"
  | Some version -> Version.to_string version

let dream_version () =
  let open Build_info.V1 in
  match Statically_linked_libraries.find ~name:"dream" with
  | None -> "unknown"
  | Some library -> (
      match Statically_linked_library.version library with
      | None -> "dev"
      | Some version -> Version.to_string version)

let uptime () =
  match Luv.Resource.uptime () with
  | Ok x -> x
  | Error err ->
      Logs.err (fun m ->
          m "An error occured when reading the uptime: %s"
            (Luv.Error.strerror err));
      0.

type platform = Darwin | Freebsd | Linux | Openbsd | Sunos | Win32 | Android

type arch =
  | Arm
  | Arm64
  | Ia32
  | Mips
  | Mipsel
  | Ppc
  | Ppc64
  | S390
  | S390x
  | X32
  | X64

let platform_of_string = function
  | "darwin" -> Darwin
  | "freebsd" -> Freebsd
  | "linux" -> Linux
  | "openbsd" -> Openbsd
  | "sunos" -> Sunos
  | "win32" -> Win32
  | "android" -> Android
  | platform ->
      print_endline (Printf.sprintf "Unsupported architecture %s" platform);
      assert false

let arch_of_string = function
  | "arm" -> Arm
  | "arm64" -> Arm64
  | "ia32" -> Ia32
  | "mips" -> Mips
  | "mipsel" -> Mipsel
  | "ppc" -> Ppc
  | "ppc64" -> Ppc64
  | "s390" -> S390
  | "s390x" -> S390x
  | "x86_32" | "x32" -> X32
  | "x86_64" | "x64" -> X64
  | arch ->
      print_endline (Printf.sprintf "Unsupported architecture %s" arch);
      assert false

let arch_string =
  let open Result.Syntax in
  let@ () = handle_sys_error in
  let+ uname = Luv.System_info.uname () in
  uname.Luv.System_info.Uname.machine

let arch = arch_of_string arch_string

let platform_string =
  let open Result.Syntax in
  let@ () = handle_sys_error in
  let+ uname = Luv.System_info.uname () in
  String.lowercase_ascii uname.Luv.System_info.Uname.sysname

let platform = platform_of_string platform_string

let sysname () =
  let open Result.Syntax in
  let@ () = handle_sys_error in
  let+ uname = Luv.System_info.uname () in
  uname.Luv.System_info.Uname.sysname

let os_release () =
  let open Result.Syntax in
  let@ () = handle_sys_error in
  let+ uname = Luv.System_info.uname () in
  uname.Luv.System_info.Uname.release

let os_version () =
  let open Result.Syntax in
  let@ () = handle_sys_error in
  let+ uname = Luv.System_info.uname () in
  uname.Luv.System_info.Uname.version

let os_machine () =
  let open Result.Syntax in
  let@ () = handle_sys_error in
  let+ uname = Luv.System_info.uname () in
  uname.Luv.System_info.Uname.machine

let cpu_count =
  try
    match Sys.os_type with
    | "Win32" -> int_of_string (Sys.getenv "NUMBER_OF_PROCESSORS")
    | _ -> (
        let i = Unix.open_process_in "getconf _NPROCESSORS_ONLN" in
        let close () = ignore (Unix.close_process_in i) in
        let ib = Scanf.Scanning.from_channel i in
        try
          Scanf.bscanf ib "%d" (fun n ->
              close ();
              n)
        with e ->
          close ();
          raise e)
  with
  | Not_found | Sys_error _ | Failure _ | Scanf.Scan_failure _ | End_of_file
  | Unix.Unix_error (_, _, _)
  ->
    1

let open_fds () =
  let h = Unix.opendir "/proc/self/fd" in
  Fun.protect
    ~finally:(fun () -> Unix.closedir h)
    (fun () ->
      let rec inner count =
        try
          let name = Unix.readdir h in
          match name with
          | "." -> inner count
          | ".." -> inner count
          | _ -> inner (count + 1)
        with End_of_file -> count
      in
      inner 0)
