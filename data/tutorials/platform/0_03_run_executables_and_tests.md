---
id: "running-executables-and-tests-with-dune"
title: "Running Executables and Tests with Dune"
short_title: "Running Executables and Tests"
description: |
  How to run executables and tests with Dune
category: "Projects"
language: English
---

## Running Executables

> **TL;DR**
> 
> Add an `executable` stanza in your `dune` file and run the executable with `dune exec <executable_path>.exe` or `dune exec <public_name>`.

To tell Dune to produce an executable, you can use the executable stanza:

```dune
(executable
 (name <executable_name>)
 (public_name <public_name>)
 (libraries <libraries...>))
```

The `<executable_name>` is the name of the executable used internally in the project.
The `<public_name>` is the name of the installed binary when installing the package.
Finally, `<libraries...>` is the list of libraries to link to the executable.

Once Dune has produced the executable with `dune build`, you can execute it with `dune exec <executable_path>.exe` or `dune exec <public_name>`.

For instance, if you've put your `dune` file in `bin/dune` with the following content:

```dune
(executable
 (name main)
 (public_name my-app)
 (libraries))
```

You can run it with `dune exec bin/main.exe` or `dune exec my-app`.

## Automatic Recompiling on File Changes

Compiling a project with `dune exec <executable_path>.exe` can take time, especially with many files. To speed this up, you can use `dune build --watch`, which automatically recompiles files as they change.

Keep in mind:

* `dune build --watch` monitors files and triggers necessary recompilation.
* Dune locks the build directory, so you can't run two Dune commands simultaneously.
* To run the application, stop the watch process (Ctrl-C) or execute the app directly with `_build\default\<executable_path>.exe`.
## Running Tests

> **TL;DR**
> 
> Add a `test` stanza in your `dune` file and run the tests with `dune test`.

Tests are created using Dune's `test` stanza. The `test` stanza is a simple convenience wrapper that will create an executable and add it to the list of tests of the `@runtest` target.

For instance, if you add a test in your dune file:

```dune
(test
 (name dummy_test)
 (modules dummy_test))
```

with a module `dummy_test.ml`:

```ocaml
let () = exit 1
```

Running `dune test` will fail with the following output:

```
  dummy_test alias src/ocamlorg_web/test/runtest (exit 1)
```

This means that the test failed because the executable exited with the status code `1`.

The output is not very descriptive. If we want to create suites of unit tests, with several tests per files, and different kind of assertions, we will want to use a test framework such as Alcotest.

Let's modify our dummy test to link to Alcotest:

```dune
(test
 (name dummy_test)
 (modules dummy_test)
 (libraries alcotest))
```

With the following module:

```ocaml
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

If we run `dune test` again, the test should be successful and output the following:


```
Testing `Dummy'.
This run has ID `B5926D16-0DD4-4C97-8C7A-5AFE1F5DF31B'.

  [OK]          Greeting          0   can greet Tom.
  [OK]          Greeting          1   can greet John.

Full test results in `_build/default/_build/_tests/Dummy'.
Test Successful in 0.000s. 2 tests run.
```
