---
id: ocaml-bytecode-compiler
title: Introduction to OCaml's Bytecode Compiler
description: |
  This page will give you a brief introduction to OCaml's Bytecode Compiler
category: "Tooling"
---

Like in C/C++, we can just add OCaml code to a file, compile it and run it as an executable.

# Storing Code in Files

Create a new directory named `hello-ocaml` and navigate to the directory:

```
$ mkdir hello-ocaml

$ cd hello-ocaml
```

Next, create a file named `hello.ml` and add the following code with your favorite text editor:

```
let _ = print_endline "Hello OCaml!"
```

**Note:** There are no double semicolons ;; at the end of that line of code.

The *let _ =* signifies that we don't care to give a name to the code on the right-hand side of *=*, hence the `_`.

Now, we are ready to run the code. Save the file and return to the command line. Let's compile the code:

```
ocamlc -o hello hello.ml
```

The compiler is named `ocamlc`. The `-o hello` option tells the compiler to name the output executable as `hello`. The executable `hello` contains compiled OCaml bytecode. In addition, two other files are produced, `hello.cmi and hello.cmo`. We don’t need to worry about those files for now. 

Now let's run the executable and see what happens:

```
$ ./hello
```

Voilà! It says, `Hello OCaml!`. Congratulations.

We can change the string or add more content, save the file, recompile, and rerun.

We can clean up the generated files by:

```
$ rm hello hello.cmi hello.cmo
```