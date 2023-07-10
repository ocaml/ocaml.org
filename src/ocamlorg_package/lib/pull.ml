(* A value to tell if the Opam_repository.pull () function was called. *)
let pull = ref false

(* Returns true if Opam_repository.pull () was called. *)
let is_pull () = !pull
