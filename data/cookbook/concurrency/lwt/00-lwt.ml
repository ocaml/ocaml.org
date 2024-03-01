---
packages:
- name: lwt
  version: 5.7.0
libraries:
- lwt
- lwt.unix
discussion: |
  - **Understanding `Lwt`:** Lwt is a scheduler which permits concurrent execution of promises on a single thread. Promise switching are performed at each long IO (using the `Lwt_io` module), timing pause (`Lwt_unix.sleep`) or explicit promise switching (`Lwt.pause ()`). Promises are typically composed with the `Lwt.bind` function. More details about the monad `bind` function is given in the [monad section](/docs/monads). The `let` operators are detailed in the [operator section](/docs/operators). We can refer to [the Lwt manual](https://ocsigen.org/lwt/latest/manual/manual).
  - **Alternative Libraries:** Lwt is perhaps the most used concurrent library (It is used in Ocsigen, Dream for example). `async` is a similar library. With OCaml 5, the multithreading permits the definition of the `eio` library which doesn't need monads. Other schedulers are `miou`, `riot` (with Erlang style message passing).
---

(* Some useful `let` operators. The construction `let* a = <Lwt promise> in b` means schedule the Lwt promise, wait for its result, then excute `b` where all occurence of `a` are replaced by the result. The construction `let*? a = <promise> in b` has the same result, but when the Lwt promise has finished, it continues if the result is `Ok x` (then `a` are replaced by `x`), and stops if `Error err`. *)
let ( let* ) = Lwt.bind
let ( let*? ) = Lwt_result.bind

(* `both` schedules two promises concurently. *)
let task n =
  let* () = Lwt_io.printf "Task %d - first line\n" n in
  let* () = Lwt.pause () in
  let* () = Lwt_io.printf "Task %d - second line\n" n in
  Lwt.return n
let (_result1, _result2) =
  Lwt_main.run @@ Lwt.both (task 1) (task 2)

(* When having a promise function which should be scheduled multiple times with different values, `iter_p`, `iter_s`, `map_p`, `map_s` schedule one promise per item from a given list. The `_s` versions schedule the promises sequentialy, and `_p` in parallel. `iter_*` return `()` (and expect task which return a unit Lwt) while `map_*`return the list of results. *)
let _result_list =
  Lwt_main.run @@ Lwt_list.map_p task [1; 2; 3] 
let _result_list =
  Lwt_main.run @@ Lwt_list.map_s task [1; 2; 3]
let task' n =
  let* _result = task n in
  Lwt return ()
let () =
  Lwt_main.run @@ Lwt_list.iter_p task' [1; 2; 3] 
let () =
  Lwt_main.run @@ Lwt_list.iter_s task' [1; 2; 3] 

(* `sleep seconds` pauses for then given seconds number.  *)
let () =
  Lwt_main.run @@ Lwt_unix.sleep 1.
