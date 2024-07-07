---
packages:
- name: async
  tested_version: 0.17.0
  used_libraries:
  - async
discussion: |
  [Async](https://dev.realworldocaml.org/concurrent-programming.html) is
  part of Jane Street's set of libraries and depends on `Base` and `Core`.
  If you are already using `Core` you may well prefer `Async` over `Lwt`
  for its better "fit".

  Like `Lwt` it does not offer multi-core parallelism, but does offer effective I/O concurrency.
  Also like `Lwt` it is structured around monads with operators and `let`
  bindings to make writing concurrent code more natural (via `ppx_let`)
---
(*
  `Async` provides promises via its
  [Deferred](https://ocaml.org/p/async_kernel/v0.17.0/doc/Async_kernel/Deferred/index.html)
  module.

  Reading from stdin might result in `Eof` (End-of-file) so our result should capture that.

  `Deferred`, `Reader` come from `open Async`. Note that `stdin` is defined
  lazily so we need to `force` it before use.

  Likewise `let%map` and `after` are from `Async`. The no-op `map` is to wait
  for the timeout promise to resolve.

<br>
  We `race` our two promises against each other and return the first that resolves.

  With `upon` we execute a function after resolving the promise, but only for its
  side-effects.

  The explicit `Async.exit` is needed because the async event-loop
  (`Scheduler.go`) never returns.
*)
open Async

type name_read_result = Timeout | Empty | Name of string

let read_name () : name_read_result Deferred.t =
  Reader.read_line (Core.Lazy.force Reader.stdin) >>| fun s ->
  match s with `Eof -> Empty | `Ok str -> Name str

let timeout () : name_read_result Deferred.t =
  let%map () = after (Core.sec 3.0) in
  Timeout

let () =
  print_endline "Enter your name (but don't take too long)";
  let race = Deferred.any [ read_name (); timeout () ] in
  upon race (fun r ->
      (match r with
      | Empty -> Async_unix.Print.print_endline "Empty name"
      | Timeout -> Async_unix.Print.print_endline "Too slow!"
      | Name n -> Async_unix.Print.printf "Hello %s\n" n);
      ignore (Async.exit 0));
  Core.never_returns (Scheduler.go ())
