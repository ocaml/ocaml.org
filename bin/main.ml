(** Main entry point for our application. *)

let () = 
  match Ocamlorg_web.run () with 
    | Ok () -> () 
    | Error (`Msg m) -> failwith m
