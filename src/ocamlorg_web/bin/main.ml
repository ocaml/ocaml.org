(** Main entry point for our application. *)

module Opam_repository = Ocamlorg_package__Opam_repository
let offline = ref false

let () = Arg.parse [ ("-offline", Arg.Set offline, "")] (fun _ -> ()) ""

let _ = Opam_repository.is_offline (!offline)

let () = Ocamlorg_web.run ()


