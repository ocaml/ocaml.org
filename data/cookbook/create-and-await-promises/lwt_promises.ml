---
packages:
- name: lwt
  tested_version: 5.7.0
  used_libraries:
  - lwt
  - lwt.unix
discussion: |
    There is [extensive
    documentation](https://ocaml.org/p/lwt/latest/doc/index.html)
    available for Lwt - it is worth spending some time reading before
    diving into using this package.

    Lwt does not offer multi-core parallelism, but does support a high level of single-core concurrency and is widely used.

    The dune file for this recipe, with the ppx rewriter would look something like this:
    ```sexp
    (executable
     (public_name lwt_promises)
     (name main)
     (libraries lwt lwt.unix)
     (preprocess
      (pps lwt_ppx)))
    ```
---
(*
   A type of `int Lwt.t` represent a promise of an int. The `bind` waits for a
   promise to be fulfilled then calls the provided function with its value. We
   re-wrap the result of that function in another (already fulfilled) promise.

   This second variant of `read_name` does exactly the same but using Lwt's
   custom let bindings. This is how you will commonly see Lwt code written. It
   relies on a ppx rewriter.

   The `Lwt_unix` library provides the operating-system (not just "unix") and scheduling modules for Lwt.
   The types of `read_name` and `timeout` need to match - they will be placed in a list together.

   To run the event-loop we use a single `Lwt_main.run` which processes a single top-level promise.
   We `pick` the first resolved promise from a list and cancel the others.
   In this recipe that is either text the user typed or `None` from the timeout.
*)
let _read_name () : string option Lwt.t =
  let name_promise : string Lwt.t = Lwt_io.(read_line stdin) in
  Lwt.bind name_promise (fun name -> Lwt.return (Some name))


let read_name () =
  let%lwt name = Lwt_io.(read_line stdin) in
  Lwt.return (Some name)


let timeout () =
  let%lwt () = Lwt_unix.sleep 6.0 in
  Lwt.return None


let () =
  print_endline "Enter your name (but don't take too long)";
  let first_resolved : string option =
    Lwt_main.run (Lwt.pick [ read_name (); timeout () ])
  in
  match first_resolved with
  | Some name -> Printf.printf "Hello %s\n" name
  | None -> print_endline "Too slow!"
