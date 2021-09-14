(** Main entry point for our application. *)

let () =
  Printexc.record_backtrace true;
  Ocamlorg_web.run ()
