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

  Note: this example could be improved by adding error handling and/or
    handling of properly closing stdin in case of timeout.
---
(*
`Async` is Jane Street's concurrent programming library, similar to `Lwt` but with
different design choices and better integration with `Core`/`Base` libraries.

`'a Deferred.t` is Async's equivalent to Lwt's promises - it represents a value
that will be available in the future.
*)
open Async

let (let*) = Async.(>>=)

(*
Attempts to read a line from standard input.
`Reader.read_line` returns \`Ok string when successful, or
\`Eof when end-of-file is reached.

Note: `Core.Lazy.force` is needed because stdin is initialized lazily
to allow for customization before first use.
*)
let read_name () : string option Deferred.t =
  let* s =
    Reader.read_line (Core.Lazy.force Reader.stdin)
  in
  match s with
  | `Eof -> Deferred.return (Some "")
  | `Ok str -> Deferred.return (Some str)

(*
`Async.after` creates a deferred that completes after specified duration
(in this case, 6 seconds).
*)
let timeout () : string option Deferred.t =
  let* () = after (Core.sec 6.0) in
  Deferred.return None

(*
We create two concurrent operations: reading input and timeout, then use
`Deferred.any` to race them against each other, and handle
the result with `Async.upon` (similar to .then in JavaScript promises).
*)
let () =
  print_endline "Enter your name (don't take too long)";
  let race =
    Deferred.any [ read_name (); timeout () ]
  in
  upon race (fun r ->
    (match r with
    | Some n -> Async_unix.Print.printf "Hello %s\n" n
    | None -> Async_unix.Print.print_endline "Too slow!");
(*
The explicit `Async.exit` is needed because the Async event-loop
(`Scheduler.go`) never returns.
*)
    ignore (Async.exit 0));
  Core.never_returns (Scheduler.go ())
