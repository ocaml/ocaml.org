let print = {|let () = print_endline "Welcome to the OCaml Playground"|}

let adts =
  {|(* 
  Welcome to OCaml Play, the official OCaml playground!

  You don't need to install anything - just write your code
  and see the results appear in the Output panel.

  It's also compatible with OCaml 5: you can use the new
  Domain module and effect handlers. Below is a naive example
  that calculates the Fibonacci sequence in parallel.
  
  Happy hacking!
*)

let num_domains = 2
let n = 20

let rec fib n =
  if n < 2 then 1
  else fib (n-1) + fib (n-2)

let rec fib_par n d =
  if d <= 1 then fib n
  else
    let a = fib_par (n-1) (d-1) in
    let b = Domain.spawn (fun _ -> fib_par (n-2) (d-1)) in
    a + Domain.join b

let () =
  let res = fib_par n num_domains in
  Printf.printf "fib(%d) = %d\n" n res

(*
  For a more in-depth, realistic example of how to use
  parallel computation, take a lot at
  https://v2.ocaml.org/releases/5.0/manual/parallelism.html#s:par_iterators

  A better, single-threaded implementation that calculates
  the Fibonacci sequence uses memoization, and you can read about it at
  https://cs3110.github.io/textbook/chapters/ds/memoization.html#fibonacci
*)
|}
