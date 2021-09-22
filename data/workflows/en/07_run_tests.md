---
title: "Running tests"
---

> **TL;DR**
> 
> Add a `test` stanza in your dune file and run the tests with `dune build @runtest`.

Tests are created using Dune's `test` stanza. The `test` stanza is a simple convenience wrapper that will create an executable and add it to the list of of tests of the `@runtest` target.

For instance, if you add a test in your dune file:

```
(test
 (name dummy_test)
 (modules dummy_test))
```

with a module `dummy_test.ml`:

```ocaml
let () = exit 1
```

Running `dune build @runtest` will fail with the following output:

```
  dummy_test alias src/ocamlorg_web/test/runtest (exit 1)
```

This means that the test failed because the executable exited with the status code `1`.

The output is not very descriptive. If we want to create unit tests suites, with several tests per files, and different kind of assertions, we'll want to use a test framework such as Alcotest.

Let's modify our dummy test to link to Alcotest:

```
(test
 (name dummy_test)
 (modules dummy_test)
 (libraries alcotest))
```

With the following module:

```
open Alcotest

let test_hello_with_name name () =
  let greeting = "Hello " ^ name ^ "!" in
  let expected = Printf.sprintf "Hello %s!" name in
  check string "same string" greeting expected

let suite =
  [ "can greet Tom", `Quick, test_hello_with_name "Tom"
  ; "can greet John", `Quick, test_hello_with_name "John"
  ]

let () =
  Alcotest.run "Dummy" [ "Greeting", suite ]
```

If we run `dune build @runtest` again, the test should be successful and ouput the following:


```
Testing `Dummy'.
This run has ID `B5926D16-0DD4-4C97-8C7A-5AFE1F5DF31B'.

  [OK]          Greeting          0   can greet Tom.
  [OK]          Greeting          1   can greet John.

Full test results in `_build/default/_build/_tests/Dummy'.
Test Successful in 0.000s. 2 tests run.
```
