---
id: multicore-transition
title: Transitioning to Multicore with TSan
description: >
  Learn to make your OCaml code multicore ready with ThreadSanitizer
category: "Guides"
---


# Transitioning to Multicore with ThreadSanitizer

The 5.0 release brought multicore `Domain`-based parallelism to the
OCaml language, and with it new opportunities for data races. In this
guide, we will study a step-wise workflow that utilizes the
ThreadSanitizer (TSan) tool to help make your OCaml code 5.x ready.

**Note:** TSan is currently only supported under Linux with AMD/Intel
cpus. It furthermore requires at least gcc 11 or Clang 11 and the
`libunwind` library.


## An example application

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

Underneath the hood the library may have been implemented in various
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


## A proposed workflow

Now if we want to see if this code is multicore ready for OCaml 5.x,
we can utilize the following workflow:

0. Install TSan
1. Write a parallel test runner
2. Run tests under TSan
3. If TSan complains about data races, address the reported issue and
   go to step 2.


## Following the workflow

We will now go through the proposed workflow for our example
application.


### Install the instrumenting TSan compiler (Step 0)

For now, convenient `5.1.0~rc3+tsan` and `5.0.0+tsan` opam switches are available
until TSan is officially included with the forthcoming 5.2.0 OCaml
release. You can install such a TSan switch as follows:

``` shell
opam switch create 5.1.0~rc3+tsan
```


### Write a parallel test runner (Step 1)

For a start we can test our library under parallel usage, by running
two `Domain`s in parallel. Here's a quick little test runner in
`bank_test.ml` utilizing this idea:
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
  |> Array.iter Domain.join;
```

The runner creates a bank with 7 accounts containing $100
each, and then runs two loops in parallel with
- one transfering money with `money_shuffle` and
- another one repeatedly printing the account balances with `print_balances`:

``` shell
$ opam switch 5.1.0
$ dune runtest
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
impression that everything is OK as the balances sum to a total of
$700 as expected, indicating that no money is lost.


### Run the parallel tests under TSan (Step 2)

Let us now perform the same test run under TSan. Doing so is as simple
as follows and immediately complains about races:

``` shell
$ opam switch 5.1.0~rc3+tsan
$ dune runtest
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
    #2 camlStdlib__Domain.body_703 /home/opam/.opam/5.1.0~rc3+tsan/.opam-switch/build/ocaml-variants.5.1.0~rc3+tsan/stdlib/domain.ml:202 (bank_test.exe+0xb06b0)
    #3 caml_start_program <null> (bank_test.exe+0x13fdfb)
    #4 caml_callback_exn runtime/callback.c:197 (bank_test.exe+0x106053)
    #5 caml_callback runtime/callback.c:293 (bank_test.exe+0x106b70)
    #6 domain_thread_func runtime/domain.c:1102 (bank_test.exe+0x10a2b1)

  Previous read of size 8 at 0x7f5b0c0fd6d8 by thread T1 (mutexes: write M81):
    #0 camlStdlib__Array.iteri_367 /home/opam/.opam/5.1.0~rc3+tsan/.opam-switch/build/ocaml-variants.5.1.0~rc3+tsan/stdlib/array.ml:136 (bank_test.exe+0xa0f36)
    #1 camlDune__exe__Bank_test.print_balances_496 test/bank_test.ml:15 (bank_test.exe+0x6d8f4)
    #2 camlStdlib__Domain.body_703 /home/opam/.opam/5.1.0~rc3+tsan/.opam-switch/build/ocaml-variants.5.1.0~rc3+tsan/stdlib/domain.ml:202 (bank_test.exe+0xb06b0)
    #3 caml_start_program <null> (bank_test.exe+0x13fdfb)
    #4 caml_callback_exn runtime/callback.c:197 (bank_test.exe+0x106053)
    #5 caml_callback runtime/callback.c:293 (bank_test.exe+0x106b70)
    #6 domain_thread_func runtime/domain.c:1102 (bank_test.exe+0x10a2b1)

  [...]
```

Notice we obtain a back trace of the two racing accesses, with
- a write in one `Domain` coming from the array assignment in
  `Bank.transfer` and
- a read in another `Domain` coming from a call to
  `Stdlib.Array.iteri` to read and print the array entries in
  `print_balances`.


### Address the reported races and rerun the tests (Steps 3 and 2)

One way to address the reported races is to add a `Mutex` ensuring
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
$ dune runtest
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


### Address the reported races and rerun the tests, take 2 (Steps 3 and 2)

Oh, wait! When raising an exception in `transfer` we forgot to unlock
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
$ dune runtest
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

Admittedly, using a `Mutex` to ensure exclusive access may be a bit
heavy if performance is a concern.  If this is the case, one option is
to replace the underlying `array` with a lock-free data structure,
such as the [`Hashtbl`
from`Kcas_data`](https://ocaml-multicore.github.io/kcas/doc/kcas_data/Kcas_data/Hashtbl/index.html). 
