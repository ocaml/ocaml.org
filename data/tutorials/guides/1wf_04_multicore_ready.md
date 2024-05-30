---
id: multicore-transition
title: Transitioning to Multicore with ThreadSanitizer
short_title: Transitioning to Multicore with TSan
description: >
  Learn to make your OCaml code multicore ready with ThreadSanitizer
category: "Guides"
---

The 5.0 release brought Multicore, `Domain`-based parallelism to the
OCaml language. Parallel `Domain`s performing uncoordinated operations
on shared mutable memory locations may however cause data races. Such
issues will unfortunately not
[(yet)](https://blog.janestreet.com/oxidizing-ocaml-parallelism/) be
caught by OCaml's strong type system, meaning they may go unnoticed
when introducing parallelism into an existing OCaml code base. In this
guide, we will therefore study a step-wise workflow that utilises the
[ThreadSanitizer (TSan)](https://ocaml.org/manual/latest/tsan.html)
tool to help make your OCaml code 5.x ready.

**Note:** TSan support for OCaml is currently available for the x86_64 architecture, on FreeBSD, Linux and macOS, and for the arm64 architecture on Linux and macOS. Building OCaml with TSan support requires at least GCC 11 or Clang 14 installed as your C compiler. Note that TSan data race reports with GCC 11 are known to result in poor stack trace reporting (no line numbers), which is fixed in GCC 12.

## An Example Application

Consider a little bank library with the following signature in
`bank.mli`:

``` ocaml
type t
(** a collective type representing a bank *)

val init : num_accounts:int -> init_balance:int -> t
(** [init ~num_accounts ~init_balance] creates a bank with [num_accounts] each
    containing [init_balance]. *)

val transfer : t -> src_acc:int -> dst_acc:int -> amount:int -> unit
(** [transfer t ~src_acc ~dst_acc ~amount] moves [amount] from account
    [src_acc] to account [dst_acc].
    @raise Invalid_argument if amount is not positive,
    if [src_acc] and [dst_acc] are the same, or if [src_acc] contains
    insufficient funds. *)

val iter_accounts : t -> (account:int -> balance:int -> unit) -> unit
(** [iter_accounts t f] applies [f] to each account from [t]
    one after another. *)
```

Underneath the hood, the library may have been implemented in various
ways. Consider the following thread-unsafe implementation in `bank.ml`:

``` ocaml
type t = int array

let init ~num_accounts ~init_balance =
  Array.make num_accounts init_balance

let transfer t ~src_acc ~dst_acc ~amount =
  begin
    if amount <= 0 then raise (Invalid_argument "Amount has to be positive");
    if src_acc = dst_acc then raise (Invalid_argument "Cannot transfer to yourself");
    if t.(src_acc) < amount then raise (Invalid_argument "Not enough money on account");
    t.(src_acc) <- t.(src_acc) - amount;
    t.(dst_acc) <- t.(dst_acc) + amount;
  end

let iter_accounts t f = (* inspect the bank accounts *)
  Array.iteri (fun account balance -> f ~account ~balance) t;
```


## A Proposed Workflow

Now if we want to see if this code is Multicore ready for OCaml 5.x,
we can utilise the following workflow:

0. Install TSan
1. Write a parallel test runner
2. Run tests under TSan
3. If TSan complains about data races, address the reported issue and
   go to step 2.


## Following the Workflow

We will now go through the proposed workflow for our example
application.


### Install the Instrumenting TSan Compiler (Step 0)

TSan is included in OCaml starting from OCaml 5.2, but has to be explicitly enabled. You can install a TSan switch as follows:
``` shell
opam switch create my_switch_name ocaml-option-tsan
```


### Write a Parallel Test Runner (Step 1)

For a start, we can test our library under parallel usage by running
two `Domain`s in parallel. Here's a quick little test runner in
`bank_test.ml` utilising this idea:
``` ocaml
let num_accounts = 7

let money_shuffle t = (* simulate an economy *)
  for i = 1 to 10 do
    Unix.sleepf 0.1 ; (* wait for a network request *)
    let src_acc = i mod num_accounts in
    let dst_acc = (i*3+1) mod num_accounts in
    try Bank.transfer t ~src_acc ~dst_acc ~amount:1 (* transfer $1 *)
    with Invalid_argument _ -> ()
  done

let print_balances t = (* inspect the bank accounts *)
  for _ = 1 to 12 do
    let sum = ref 0 in
    Bank.iter_accounts t
      (fun ~account ~balance -> Format.printf "%i %3i " account balance; sum := !sum + balance);
    Format.printf "  total = %i @." !sum;
    Unix.sleepf 0.1;
  done

let _ =
  let t = Bank.init ~num_accounts ~init_balance:100 in
  (* run the simulation and the debug view in parallel *)
  [| Domain.spawn (fun () -> money_shuffle t);
     Domain.spawn (fun () -> print_balances t);
  |]
  |> Array.iter Domain.join
```

The runner creates a bank with 7 accounts containing $100
each and then runs two loops in parallel with:
- One transfering money with `money_shuffle`
- Another one repeatedly printing the account balances with `print_balances`:

``` shell
$ opam switch 5.1.0
$ opam exec -- dune runtest
0 100 1 100 2 100 3 100 4 100 5 100 6 100   total = 700
0 100 1 100 2 100 3 100 4 100 5 100 6 100   total = 700
0 100 1  99 2 100 3 100 4 101 5 100 6 100   total = 700
0 101 1  99 2  99 3 100 4 101 5 100 6 100   total = 700
0 101 1  99 2  99 3 100 4 100 5 100 6 101   total = 700
0 101 1  99 2 100 3 100 4 100 5  99 6 101   total = 700
0 101 1  99 2 100 3 100 4 100 5 100 6 100   total = 700
0 100 1 100 2 100 3 100 4 100 5 100 6 100   total = 700
0 100 1  99 2 100 3 100 4 101 5 100 6 100   total = 700
0 101 1  99 2  99 3 100 4 101 5 100 6 100   total = 700
0 101 1  99 2  99 3 100 4 101 5 100 6 100   total = 700
0 101 1  99 2  99 3 100 4 101 5 100 6 100   total = 700
```

From the above run under a regular `5.1.0` compiler, one may get the
impression that everything is OK, as the balances sum to a total of
$700 as expected, indicating that no money is lost.


### Run the Parallel Tests Under TSan (Step 2)

Let us now perform the same test run under TSan. Doing so is as simple
as follows and immediately complains about races:

``` shell
$ opam switch 5.1.0+tsan
$ opam exec -- dune runtest
File "test/dune", line 2, characters 7-16:
2 |  (name bank_test)
           ^^^^^^^^^
0 100 1 100 2 100 3 100 4 100 5 100 6 100   total = 700
0 100 1 100 2 100 3 100 4 100 5 100 6 100   total = 700
0 100 1  99 2 100 3 100 4 101 5 100 6 100   total = 700
0 101 1  99 2  99 3 100 4 101 5 100 6 100   total = 700
0 101 1  99 2  99 3 100 4 101 5 100 6 100   total = 700
0 101 1  99 2  99 3 100 4 100 5 100 6 101   total = 700
0 101 1  99 2 100 3 100 4 100 5  99 6 101   total = 700
0 101 1  99 2 100 3 100 4 100 5 100 6 100   total = 700
0 100 1 100 2 100 3 100 4 100 5 100 6 100   total = 700
0 100 1  99 2 100 3 100 4 101 5 100 6 100   total = 700
0 101 1  99 2  99 3 100 4 101 5 100 6 100   total = 700
0 101 1  99 2  99 3 100 4 101 5 100 6 100   total = 700
==================
WARNING: ThreadSanitizer: data race (pid=26148)
  Write of size 8 at 0x7f5b0c0fd6d8 by thread T4 (mutexes: write M85):
    #0 camlBank.transfer_322 lib/bank.ml:11 (bank_test.exe+0x6de4d)
    #1 camlDune__exe__Bank_test.money_shuffle_270 test/bank_test.ml:8 (bank_test.exe+0x6d7c5)
    #2 camlStdlib__Domain.body_703 /home/opam/.opam/5.1.0+tsan/.opam-switch/build/ocaml-variants.5.1.0+tsan/stdlib/domain.ml:202 (bank_test.exe+0xb06b0)
    #3 caml_start_program <null> (bank_test.exe+0x13fdfb)
    #4 caml_callback_exn runtime/callback.c:197 (bank_test.exe+0x106053)
    #5 caml_callback runtime/callback.c:293 (bank_test.exe+0x106b70)
    #6 domain_thread_func runtime/domain.c:1102 (bank_test.exe+0x10a2b1)

  Previous read of size 8 at 0x7f5b0c0fd6d8 by thread T1 (mutexes: write M81):
    #0 camlStdlib__Array.iteri_367 /home/opam/.opam/5.1.0+tsan/.opam-switch/build/ocaml-variants.5.1.0+tsan/stdlib/array.ml:136 (bank_test.exe+0xa0f36)
    #1 camlDune__exe__Bank_test.print_balances_496 test/bank_test.ml:15 (bank_test.exe+0x6d8f4)
    #2 camlStdlib__Domain.body_703 /home/opam/.opam/5.1.0+tsan/.opam-switch/build/ocaml-variants.5.1.0+tsan/stdlib/domain.ml:202 (bank_test.exe+0xb06b0)
    #3 caml_start_program <null> (bank_test.exe+0x13fdfb)
    #4 caml_callback_exn runtime/callback.c:197 (bank_test.exe+0x106053)
    #5 caml_callback runtime/callback.c:293 (bank_test.exe+0x106b70)
    #6 domain_thread_func runtime/domain.c:1102 (bank_test.exe+0x10a2b1)

  [...]
```

Notice we obtain a back trace of the two racing accesses, with
- A write in one `Domain` coming from the array assignment in
  `Bank.transfer` 
- A read in another `Domain` coming from a call to
  `Stdlib.Array.iteri` to read and print the array entries in
  `print_balances`.


### Address the Reported Races and Rerun the Tests (Steps 3 and 2)

One way to address the reported races is to add a `Mutex`, ensuring
exclusive access to the underlying array. A first attempt could be
to wrap `transfer` and `iter_accounts` with `lock`-`unlock` calls as
follows:

``` ocaml
let lock = Mutex.create () (* addition *)

let transfer t ~src_acc ~dst_acc ~amount =
  begin
    Mutex.lock lock; (* addition *)
    if amount <= 0 then raise (Invalid_argument "Amount has to be positive");
    if src_acc = dst_acc then raise (Invalid_argument "Cannot transfer to yourself");
    if t.(src_acc) < amount then raise (Invalid_argument "Not enough money on account");
    t.(src_acc) <- t.(src_acc) - amount;
    t.(dst_acc) <- t.(dst_acc) + amount;
    Mutex.unlock lock; (* addition *)
  end

let iter_accounts t f = (* inspect the bank accounts *)
  Mutex.lock lock; (* addition *)
  Array.iteri (fun account balance -> f ~account ~balance) t;
  Mutex.unlock lock (* addition *)
```

Rerunning our tests, we obtain:

``` shell
$ opam exec -- dune runtest
File "test/dune", line 2, characters 7-16:
2 |  (name bank_test)
           ^^^^^^^^^
0 100 1 100 2 100 3 100 4 100 5 100 6 100   total = 700
0 100 1 100 2 100 3 100 4 100 5 100 6 100   total = 700
0 100 1  99 2 100 3 100 4 101 5 100 6 100   total = 700
0 101 1  99 2  99 3 100 4 101 5 100 6 100   total = 700
Fatal error: exception Sys_error("Mutex.lock: Resource deadlock avoided")
```

How come we may hit a resource deadlock error when adding just two
pairs of `Mutex.lock` and `Mutex.unlock` calls?


### Address the Reported Races and Rerun the Tests, Take 2 (Steps 3 and 2)

Oh, wait! When raising an exception in `transfer`, we forgot to unlock
the `Mutex` again. Let's adapt the function to do so:

``` ocaml
let transfer t ~src_acc ~dst_acc ~amount =
  begin
    if amount <= 0 then raise (Invalid_argument "Amount has to be positive");
    if src_acc = dst_acc then raise (Invalid_argument "Cannot transfer to yourself");
    Mutex.lock lock; (* addition *)
    if t.(src_acc) < amount
    then (Mutex.unlock lock; (* addition *)
          raise (Invalid_argument "Not enough money on account"));
    t.(src_acc) <- t.(src_acc) - amount;
    t.(dst_acc) <- t.(dst_acc) + amount;
    Mutex.unlock lock; (* addition *)
  end
```

We can now rerun our tests under TSan to confirm the fix:
``` shell
$ opam exec -- dune runtest
0 100 1 100 2 100 3 100 4 100 5 100 6 100   total = 700
0 100 1 100 2 100 3 100 4 100 5 100 6 100   total = 700
0 100 1  99 2 100 3 100 4 101 5 100 6 100   total = 700
0 101 1  99 2  99 3 100 4 101 5 100 6 100   total = 700
0 101 1  99 2  99 3 100 4 101 5 100 6 100   total = 700
0 101 1  99 2 100 3 100 4 100 5  99 6 101   total = 700
0 101 1  99 2 100 3 100 4 100 5 100 6 100   total = 700
0 100 1 100 2 100 3 100 4 100 5 100 6 100   total = 700
0 100 1  99 2 100 3 100 4 101 5 100 6 100   total = 700
0 101 1  99 2  99 3 100 4 101 5 100 6 100   total = 700
0 101 1  99 2  99 3 100 4 101 5 100 6 100   total = 700
0 101 1  99 2  99 3 100 4 101 5 100 6 100   total = 700
```

This works well and TSan no longer complains, so our little library is
ready for OCaml 5.x parallelism, hurrah!


### Final Remarks and a Word of Warning

The programming pattern of 'always-having-to-do-something-at-the-end'
that we encountered with the missing `Mutex.unlock` is a recurring
one for which OCaml offers a dedicate function:
```ocaml
 Fun.protect : finally:(unit -> unit) -> (unit -> 'a) -> 'a
```
Using `Fun.protect`, we could have written our final fix as follows:
```ocaml
let transfer t ~src_acc ~dst_acc ~amount =
  begin
    if amount <= 0 then raise (Invalid_argument "Amount has to be positive");
    if src_acc = dst_acc then raise (Invalid_argument "Cannot transfer to yourself");
    Mutex.lock lock; (* addition *)
    Fun.protect ~finally:(fun () -> Mutex.unlock lock) (* addition *)
      (fun () ->
         begin
           if t.(src_acc) < amount
           then raise (Invalid_argument "Not enough money on account");
           t.(src_acc) <- t.(src_acc) - amount;
           t.(dst_acc) <- t.(dst_acc) + amount;
         end)
  end
```

Admittedly, using a `Mutex` to ensure exclusive access may be a bit
heavy if performance is a concern. If this is the case, one option is
to replace the underlying `array` with a lock-free data structure,
such as the [`Hashtbl`
from`Kcas_data`](https://ocaml-multicore.github.io/kcas/doc/kcas_data/Kcas_data/Hashtbl/index.html).

As a final word of warning, `Domain`s are so fast that in a too
simple test runner, one `Domain` may complete before the second has
even started up yet! This is problematic, as there will be no apparent
parallelism for TSan to observe and check. In the above example, the
calls to `Unix.sleepf` help ensure that the test runner is indeed
parallel. A useful alternative trick is to coordinate on an [`Atomic`](/manual/api/Atomic.html)
to make sure both `Domain`s are up and running before the parallel
test code proceeds. To do so, we can adapt our parallel test runner as
follows:

```ocaml
let _ =
  let wait = Atomic.make 2 in
  let t = Bank.init ~num_accounts ~init_balance:100 in
  (* run the simulation and the debug view in parallel *)
  [| Domain.spawn (fun () ->
         Atomic.decr wait; while Atomic.get wait > 0 do () done; money_shuffle t);
     Domain.spawn (fun () ->
         Atomic.decr wait; while Atomic.get wait > 0 do () done; print_balances t);
  |]
  |> Array.iter Domain.join
```

With that warning in mind and TSan in hand, you should now be equipped
to hunt for data races.
