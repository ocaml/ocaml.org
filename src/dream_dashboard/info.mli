(** This module provides some system information *)

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

val ocaml_version : string
(** [ocaml_version] is the version of the OCaml compiler used to compile the
    project. *)

val version : unit -> string
(** [version ()] returns the version of the dashboard library. *)

val dream_version : unit -> string
(** [dream_version ()] returns the version of Dream that was statically linked
    when building the project. *)

val uptime : unit -> float
(** [uptime ()] returns the uptime of the system in seconds. *)

val arch : arch
(** [arch] is the CPU architecture the binary is running on. *)

val platform : platform
(** [platform] is the operating system type the binary is running on. *)

val os_version : unit -> string
(** [os_version] is the version of the operating system the binary is running
    on. *)

val os_machine : unit -> string
(** ??? *)

val os_release : unit -> string
(** ??? *)

val sysname : unit -> string
(** ??? *)

val cpu_count : int
(** ??? *)

val open_fds : unit -> int
(** ??? *)
