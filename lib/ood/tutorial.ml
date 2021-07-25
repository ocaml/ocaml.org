
type difficulty =
  [ `Beginner
  | `Intermediate
  | `Advanced
  ]

type t =
  { title : string
  ; slug : string
  ; description : string
  ; date : string
  ; tags : string list
  ; users : difficulty list
  ; body_md : string
  ; toc_html : string
  ; body_html : string
  }
  
let all = 
[
  { title = {js|Up and Running with OCaml|js}
  ; slug = {js|up-and-running-with-ocaml|js}
  ; description = {js|Help you install OCaml, the Dune build system, and support for your favourite text editor or IDE.
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["getting-started"]
  ; users = [`Beginner]
  ; body_md = {js|
This page will help you install OCaml, the Dune build system, and support for
your favourite text editor or IDE. These instructions work on Windows, Unix
systems like Linux, and macOS.

## Installing OCaml

There are two procedures: one for Unix-like systems, and one for Windows.

### For Linux and macOS

We will install OCaml using opam, the OCaml package manager.  We will also use
opam when we wish to install third-party OCaml libraries.

**For macOS**

```
# Homebrew
brew install opam

# MacPort
port install opam
```

**For Linux** the preferred way is to use your system's package manager on
Linux (e.g `apt-get install opam` or similar). [Details of all installation
methods.](https://opam.ocaml.org/doc/Install.html)

Then, we install an OCaml compiler:

```
# environment setup
opam init
eval `opam env`

# install given version of the compiler
opam switch create 4.11.1
eval `opam env`
```

Now, OCaml is up and running:

```
$ which ocaml
/Users/frank/.opam/4.11.1/bin/ocaml

$ ocaml -version
The OCaml toplevel, version 4.11.1
```

**For either Linux or macOS** as an alternative, a binary distribution of opam is
available:

```
sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
```

### For Windows

We use the [OCaml for Windows](https://fdopen.github.io/opam-repository-mingw/)
installer which comes in 32bit and 64bit versions. This installer gives you
opam and OCaml installations all in one go. It is used from within a Cygwin
environment, but the executables produced have no dependency on Cygwin at all.

## The OCaml top level

OCaml comes with two compilers: for native code, and for byte code. We shall
use one of those in a moment. But first, let's use OCaml's top level (sometimes
known as a REPL in other languages):

```
$ ocaml
        OCaml version 4.11.1

# 1 + 2 * 3;;
- : int = 7

```

We typed the phrase `1 + 2 * 3` and then signalled to OCaml that we had
finished by typing `;;` followed by the Enter key. OCaml calculated the
result, `7` and its type `int` and showed them to us. We exit by running the
built-in `exit` function with exit code 0:

```
$ ocaml
        OCaml version 4.11.1

# 1 + 2 * 3;;
- : int = 7
# exit 0;;
$
```

There are two ways to improve your experience with the OCaml top level: you can
install the popular [`rlwrap`](https://github.com/hanslub42/rlwrap) on your
system and invoke `rlwrap ocaml` instead of `ocaml` to get line-editing
facilities inside the OCaml top level, or you can install the alternative top
level `utop` using opam:

```
$ opam install utop
```

We run it by typing `utop` instead of `ocaml`. You can read more about
[utop](https://github.com/ocaml-community/utop).

## Installing the Dune build system

Dune is a build system for OCaml. It takes care of all the low level details of
OCaml compilation. We install it with opam:

```
$ opam install dune
The following actions will be performed:
  - install dune 2.7.1

<><> Gathering sources ><><><><><><><><><><><><><><><><><><><><><><><><>
[default] https://opam.ocaml.org/2.0.7/archives/dune.2.7.1+opam.tar.gz
downloaded

<><> Processing actions <><><><><><><><><><><><><><><><><><><><><><><><>
-> installed dune.2.7.1
Done.
```

## A first project

Let's begin the simplest project with Dune and OCaml. We create a new directory
and ask `dune` to initialise a new project:

```
$ mkdir helloworld
$ cd helloworld/
$ dune init exe helloworld
Success: initialized executable component named helloworld
```

Building our program is as simple as typing `dune build`:

```
$ dune build
Info: Creating file dune-project with this contents:
| (lang dune 2.7)
Done: 8/11 (jobs: 1)
```

When we change our program, we type `dune build` again to make a new
executable. We can run the executable with `dune exec` (it's called
`helloworld.exe` even when we're not using Windows):

```
$ dune exec ./helloworld.exe
Hello, World!        
```

Let's look at the contents of our new directory. Dune has added the
`helloworld.ml` file, which is our OCaml program. It has also added our `dune`
file, which tells dune how to build the program, and a `_build` subdirectory,
which is dune's working space.

```
$ ls
_build		dune		helloworld.ml
```

The `helloworld.exe` executable is stored inside the `_build/default` subdirectory, so
it's easier to run with `dune exec`. To ship the executable, we can just copy
it from inside `_build/default` to somewhere else.

Here is the contents of the automatically-generated `dune` file. When we want
to add components to your project, such as third-party libraries, we edit this
file.

```
(executable
 (name helloworld))
```

## Editor support for OCaml

For **Visual Studio Code**, and other editors support the Language Server
Protocol, the OCaml language server can be installed with opam:

```
$ opam install ocaml-lsp-server
```

Now, we install the OCaml Platform Visual Studio Code extension from the Visual
Studio Marketplace.

Upon first loading an OCaml source file, you may be prompted to select the
toolchain in use: pick OCaml the version of OCaml you are using, e.g. 4.11.1
from the list. Now, help is available by hovering over symbols in your program:

![Visual Studio Code](/tutorials/vscode.png "")

**On Windows**, we must launch Visual Studio Code from within the Cygwin window,
rather than by clicking on its icon (otherwise, the language server will not be
found):

```
$ /cygdrive/c/Users/Frank\\ Smith/AppData/Local/Programs/Microsoft\\ VS\\ Code/Code.exe
```

**For Vim and Emacs**, install the [Merlin](https://github.com/ocaml/merlin)
system using opam:

```
$ opam install merlin
```

The installation procedure will print instructions on how to link Merlin with
your editor.

**On Windows**, when using Vim, the default cygwin Vim will not work with
Merlin. You will need install Vim separately. In addition to the usual
instructions printed when installing Merlin, you may need to set the PATH in
Vim:

```
let $PATH .= ";".substitute(system('opam config var bin'),'\\n$','','''')
```
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#installing-ocaml">Installing OCaml</a>
</li>
<li><a href="#the-ocaml-top-level">The OCaml top level</a>
</li>
<li><a href="#installing-the-dune-build-system">Installing the Dune build system</a>
</li>
<li><a href="#a-first-project">A first project</a>
</li>
<li><a href="#editor-support-for-ocaml">Editor support for OCaml</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<p>This page will help you install OCaml, the Dune build system, and support for
your favourite text editor or IDE. These instructions work on Windows, Unix
systems like Linux, and macOS.</p>
<h2 id="installing-ocaml">Installing OCaml</h2>
<p>There are two procedures: one for Unix-like systems, and one for Windows.</p>
<h3 id="for-linux-and-macos">For Linux and macOS</h3>
<p>We will install OCaml using opam, the OCaml package manager.  We will also use
opam when we wish to install third-party OCaml libraries.</p>
<p><strong>For macOS</strong></p>
<pre><code># Homebrew
brew install opam

# MacPort
port install opam
</code></pre>
<p><strong>For Linux</strong> the preferred way is to use your system's package manager on
Linux (e.g <code>apt-get install opam</code> or similar). <a href="https://opam.ocaml.org/doc/Install.html">Details of all installation
methods.</a></p>
<p>Then, we install an OCaml compiler:</p>
<pre><code># environment setup
opam init
eval `opam env`

# install given version of the compiler
opam switch create 4.11.1
eval `opam env`
</code></pre>
<p>Now, OCaml is up and running:</p>
<pre><code>$ which ocaml
/Users/frank/.opam/4.11.1/bin/ocaml

$ ocaml -version
The OCaml toplevel, version 4.11.1
</code></pre>
<p><strong>For either Linux or macOS</strong> as an alternative, a binary distribution of opam is
available:</p>
<pre><code>sh &lt;(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
</code></pre>
<h3 id="for-windows">For Windows</h3>
<p>We use the <a href="https://fdopen.github.io/opam-repository-mingw/">OCaml for Windows</a>
installer which comes in 32bit and 64bit versions. This installer gives you
opam and OCaml installations all in one go. It is used from within a Cygwin
environment, but the executables produced have no dependency on Cygwin at all.</p>
<h2 id="the-ocaml-top-level">The OCaml top level</h2>
<p>OCaml comes with two compilers: for native code, and for byte code. We shall
use one of those in a moment. But first, let's use OCaml's top level (sometimes
known as a REPL in other languages):</p>
<pre><code>$ ocaml
        OCaml version 4.11.1

# 1 + 2 * 3;;
- : int = 7

</code></pre>
<p>We typed the phrase <code>1 + 2 * 3</code> and then signalled to OCaml that we had
finished by typing <code>;;</code> followed by the Enter key. OCaml calculated the
result, <code>7</code> and its type <code>int</code> and showed them to us. We exit by running the
built-in <code>exit</code> function with exit code 0:</p>
<pre><code>$ ocaml
        OCaml version 4.11.1

# 1 + 2 * 3;;
- : int = 7
# exit 0;;
$
</code></pre>
<p>There are two ways to improve your experience with the OCaml top level: you can
install the popular <a href="https://github.com/hanslub42/rlwrap"><code>rlwrap</code></a> on your
system and invoke <code>rlwrap ocaml</code> instead of <code>ocaml</code> to get line-editing
facilities inside the OCaml top level, or you can install the alternative top
level <code>utop</code> using opam:</p>
<pre><code>$ opam install utop
</code></pre>
<p>We run it by typing <code>utop</code> instead of <code>ocaml</code>. You can read more about
<a href="https://github.com/ocaml-community/utop">utop</a>.</p>
<h2 id="installing-the-dune-build-system">Installing the Dune build system</h2>
<p>Dune is a build system for OCaml. It takes care of all the low level details of
OCaml compilation. We install it with opam:</p>
<pre><code>$ opam install dune
The following actions will be performed:
  - install dune 2.7.1

&lt;&gt;&lt;&gt; Gathering sources &gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
[default] https://opam.ocaml.org/2.0.7/archives/dune.2.7.1+opam.tar.gz
downloaded

&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
-&gt; installed dune.2.7.1
Done.
</code></pre>
<h2 id="a-first-project">A first project</h2>
<p>Let's begin the simplest project with Dune and OCaml. We create a new directory
and ask <code>dune</code> to initialise a new project:</p>
<pre><code>$ mkdir helloworld
$ cd helloworld/
$ dune init exe helloworld
Success: initialized executable component named helloworld
</code></pre>
<p>Building our program is as simple as typing <code>dune build</code>:</p>
<pre><code>$ dune build
Info: Creating file dune-project with this contents:
| (lang dune 2.7)
Done: 8/11 (jobs: 1)
</code></pre>
<p>When we change our program, we type <code>dune build</code> again to make a new
executable. We can run the executable with <code>dune exec</code> (it's called
<code>helloworld.exe</code> even when we're not using Windows):</p>
<pre><code>$ dune exec ./helloworld.exe
Hello, World!        
</code></pre>
<p>Let's look at the contents of our new directory. Dune has added the
<code>helloworld.ml</code> file, which is our OCaml program. It has also added our <code>dune</code>
file, which tells dune how to build the program, and a <code>_build</code> subdirectory,
which is dune's working space.</p>
<pre><code>$ ls
_build		dune		helloworld.ml
</code></pre>
<p>The <code>helloworld.exe</code> executable is stored inside the <code>_build/default</code> subdirectory, so
it's easier to run with <code>dune exec</code>. To ship the executable, we can just copy
it from inside <code>_build/default</code> to somewhere else.</p>
<p>Here is the contents of the automatically-generated <code>dune</code> file. When we want
to add components to your project, such as third-party libraries, we edit this
file.</p>
<pre><code>(executable
 (name helloworld))
</code></pre>
<h2 id="editor-support-for-ocaml">Editor support for OCaml</h2>
<p>For <strong>Visual Studio Code</strong>, and other editors support the Language Server
Protocol, the OCaml language server can be installed with opam:</p>
<pre><code>$ opam install ocaml-lsp-server
</code></pre>
<p>Now, we install the OCaml Platform Visual Studio Code extension from the Visual
Studio Marketplace.</p>
<p>Upon first loading an OCaml source file, you may be prompted to select the
toolchain in use: pick OCaml the version of OCaml you are using, e.g. 4.11.1
from the list. Now, help is available by hovering over symbols in your program:</p>
<p><img src="/tutorials/vscode.png" alt="Visual Studio Code" title="" /></p>
<p><strong>On Windows</strong>, we must launch Visual Studio Code from within the Cygwin window,
rather than by clicking on its icon (otherwise, the language server will not be
found):</p>
<pre><code>$ /cygdrive/c/Users/Frank\\ Smith/AppData/Local/Programs/Microsoft\\ VS\\ Code/Code.exe
</code></pre>
<p><strong>For Vim and Emacs</strong>, install the <a href="https://github.com/ocaml/merlin">Merlin</a>
system using opam:</p>
<pre><code>$ opam install merlin
</code></pre>
<p>The installation procedure will print instructions on how to link Merlin with
your editor.</p>
<p><strong>On Windows</strong>, when using Vim, the default cygwin Vim will not work with
Merlin. You will need install Vim separately. In addition to the usual
instructions printed when installing Merlin, you may need to set the PATH in
Vim:</p>
<pre><code>let $PATH .= &quot;;&quot;.substitute(system('opam config var bin'),'\\n$','','''')
</code></pre>
|js}
  };
 
  { title = {js|A First Hour with OCaml|js}
  ; slug = {js|a-first-hour-with-ocaml|js}
  ; description = {js|Discover the OCaml programming language in this longer tutorial that takes you from absolute beginner to someone who is able to write programs in OCaml.
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["getting-started"]
  ; users = [`Beginner]
  ; body_md = {js|
You may follow along with this tutorial with just a basic OCaml installation,
as described in [Up and Running](up_and_running.html).

Alternatively, you may follow almost all of it by running OCaml in your browser
using [TryOCaml](https://try.ocamlpro.com), with no installation required!!!

## Running OCaml code

The easiest way to get started is to run an interactive session in
your browser thanks to [TryOCaml](https://try.ocamlpro.com).

To install OCaml on your computer, see the [Install](/docs/install.html) documentation.

To quickly try small OCaml expressions, you can use an interactive
toplevel, or REPL (Read–Eval–Print Loop). The `ocaml` command provides
a very basic toplevel (you should install `rlwrap` through your system
package manager and run `rlwrap ocaml` to get history navigation).

The recommended alternative REPL [utop](https://github.com/diml/utop) may be
installed through [OPAM](/docs/install.html#OPAM) or your system package
manager. It has the same basic interface but is much more convenient to use
(history navigation, auto-completion, etc.).

Use `;;` to indicate that you've finished entering each expression and prompt OCaml to evaluate it. Here is what running `ocaml` looks like:

```console
$ ocaml
        OCaml version OCaml version 4.12.0

# 1 + 1;;
- : int = 2
```

This is how running the same code looks when using `utop`:

```console
───────┬─────────────────────────────────────────────────────────────┬────
       │ Welcome to utop version 2.7.0 (using OCaml version 4.12.0)! │     
       └─────────────────────────────────────────────────────────────┘     

Type #utop_help for help about using utop.

─( 10:12:16 )─< command 0 >───────────────────────────────────────────────
utop # 1 + 1;;
- : int = 2
```

## Comments

OCaml comments are delimited by `(*` and `*)`, like this:

```ocaml
(* This is a single-line comment. *)

(* This is a
   multi-line
   comment.
*)
```

In other words, the commenting convention is very similar to original C
(`/* ... */`). There is no single-line comment syntax (like
`# ...` in Python or `// ...` in C99/C++/Java).

OCaml counts nested `(* ... *)` blocks, and this allows you to comment
out regions of code very easily:

```ocaml
(* This code is broken ...

(* Primality test. *)
let is_prime n =
  (* note to self: ask about this on the mailing lists *) XXX

*)
```

## Calling functions

Let's say you've written a function — we'll call it `repeated` — which
takes a string `s` and a number `n`, and returns a new string which
contains original `s` repeated `n` times.

In most C-derived languages a call to this function will look like this:

```C
repeated ("hello", 3)  /* this is C code */
```

This means "call the function `repeated` with two arguments, first
argument the string hello and second argument the number 3".

OCaml, in common with other functional languages, writes and brackets
function calls differently, and this is the cause of many mistakes. Here
is the same function call in OCaml:

```ocaml
let repeated a b = a ^ (Int.to_string b);;
repeated "hello" 3  (* this is OCaml code *)
```

Note — **no** brackets, and **no** comma between the arguments.

The syntax `repeated ("hello", 3)` **is** meaningful in OCaml. It means
"call the function `repeated` with ONE argument, that argument being a
'pair' structure of two elements". Of course that would be a mistake,
because the `repeated` function is expecting two arguments, not one, and
the first argument should be a string, not a pair. But let's not worry
about pairs ("tuples") just yet. Instead, just remember that it's a
mistake to put the brackets and commas in around function call
arguments.

Let's have another function — `prompt_string` — which takes a string to
prompt and returns the string entered by the user. We want to pass this
string into `repeated`. Here are the C and OCaml versions:

```C
/* C code: */
repeated (prompt_string ("Name please: "), 3)
```

```ocaml
let prompt_string p = "";;
(* OCaml code: *)
repeated (prompt_string "Name please: ") 3
```

Take a careful look at the bracketing and the missing comma. In the
OCaml version, the brackets enclose the first argument of repeated
because that argument is the result of another function call. In general
the rule is: "bracket around the whole function call — don't put
brackets around the arguments to a function call". Here are some more
examples:

```ocaml
let f a b c = "";;
let g a = "";;
let f2 a = "";;
let g2 a b = "";;
f 5 (g "hello") 3;;    (* f has three arguments, g has one argument *)
f2 (g2 3 4)            (* f2 has one argument, g2 has two arguments *)
```

```ocaml
# repeated ("hello", 3)     (* OCaml will spot the mistake *)
Line 1, characters 10-22:
Error: This expression has type 'a * 'b
       but an expression was expected of type string
```

## Defining a function

We all know how to define a function (or static method, in Java)
in our existing languages. How do we do it in OCaml?

The OCaml syntax is pleasantly concise. Here's a function which takes
two floating point numbers and calculates the average:

```ocaml
let average a b =
  (a +. b) /. 2.0
```

Type this into the OCaml interactive toplevel (on Unix, type the command `ocaml`
from the shell) and you'll see this:

```ocaml
# let average a b =
    (a +. b) /. 2.0;;
val average : float -> float -> float = <fun>
```

If you look at the function definition closely, and also at what OCaml
prints back at you, you'll have a number of questions:

* What are those periods in `+.` and `/.` for?
* What does `float -> float -> float` mean?

I'll answer those questions in the next sections, but first I want to go
and define the same function in C (the Java definition would be fairly
similar to C), and hopefully that should raise even more questions.
Here's our C version of `average`:

```C
double average (double a, double b)
{
  return (a + b) / 2;
}
```

Now look at our much shorter OCaml definition above. Hopefully you'll be
asking:

* Why don't we have to define the types of `a` and `b` in the OCaml
  version? How does OCaml know what the types are (indeed, *does*
  OCaml know what the types are, or is OCaml completely dynamically
  typed?).
* In C, the `2` is implicitly converted into a `double`, can't OCaml
  do the same thing?
* What is the OCaml way to write `return`?

OK, let's get some answers.

* OCaml is a strongly *statically typed* language (in other words,
  there's nothing dynamic going on between int, float and string).
* OCaml uses *type inference* to work out the types, so you don't have
  to.  If you use the OCaml interactive toplevel as above, then OCaml
  will tell you
  its inferred type for your function.
* OCaml doesn't do any implicit casting. If you want a float, you have
  to write `2.0` because `2` is an integer. OCaml does **no automatic
  conversion** between int, float, string or any other type.
* As a side-effect of type inference in OCaml, functions (including
  operators) can't have overloaded definitions. OCaml defines `+` as
  the *integer* addition function. To add floats, use `+.` (note the
  trailing period). Similarly, use `-.`, `*.`, `/.` for other float
  operations.
* OCaml doesn't have a `return` keyword — the last expression in a
  function becomes the result of the function automatically.

We will present more details in the following sections and chapters.

## Basic types

The basic types in OCaml are:

```text
OCaml type  Range

int         31-bit signed int (roughly +/- 1 billion) on 32-bit
            processors, or 63-bit signed int on 64-bit processors
float       IEEE double-precision floating point, equivalent to C's double
bool        A boolean, written either 'true' or 'false'
char        An 8-bit character
string      A string
unit        Written as ()
```

OCaml uses one of the bits in an `int` internally in order to be able to
automatically manage the memory use (garbage collection). This is why
the basic `int` is 31 bits, not 32 bits (63 bits if you're using a 64
bit platform). In practice this isn't an issue except in a few
specialised cases. For example if you're counting things in a loop, then
OCaml limits you to counting up to 1 billion instead of 2 billion. However if you need to do things
such as processing 32 bit types (eg. you're writing crypto code or a
network stack), OCaml provides a `nativeint` type which matches the
native integer type for your platform.

OCaml doesn't have a basic unsigned integer type, but you can get the
same effect using `nativeint`. OCaml doesn't have built-in single-precision 
floating point numbers.

OCaml provides a `char` type which is used for characters, written `'x'`
for example. Unfortunately the `char` type does not support Unicode or
UTF-8, There are [comprehensive Unicode libraries](https://github.com/yoriyuki/Camomile)
which provide this functionality.

Strings are not just lists of characters. They have their own, more
efficient internal representation. Strings are immutable.

The `unit` type is sort of like `void` in C, but we'll talk about it
more below.

## Implicit vs. explicit casts

In C-derived languages ints get promoted to floats in certain
circumstances. For example if you write `1 + 2.5` then the first
argument (which is an integer) is promoted to a floating point number,
and the result is also a floating point number. It's as if you had
written `((double) 1) + 2.5`, but all done implicitly.

OCaml never does implicit casts like this. In OCaml, `1 + 2.5` is a type
error. The `+` operator in OCaml requires two ints as arguments, and
here we're giving it an int and a float, so it reports this error:

```ocaml
# 1 + 2.5;;
Line 1, characters 5-8:
Error: This expression has type float but an expression was expected of type
         int
```

To add two floats together you need to use a different operator, `+.`
(note the trailing period).

OCaml doesn't promote ints to floats automatically so this is also an
error:

```ocaml
# 1 +. 2.5
Line 1, characters 1-2:
Error: This expression has type int but an expression was expected of type
         float
  Hint: Did you mean `1.'?
```

Here OCaml is now complaining about the first argument.

What if you actually want to add an integer and a floating point number
together? (Say they are stored as `i` and `f`). In OCaml you need to
explicitly cast:

```ocaml
let i = 1;;
let f = 2.0;;
float_of_int i +. f
```

`float_of_int` is a function which takes an `int` and returns a `float`.
There are a whole load of these functions, called such things as
`int_of_float`, `char_of_int`, `int_of_char`, `string_of_int` and so on,
and they mostly do what you expect.

Since converting an `int` to a `float` is a particularly common
operation, the `float_of_int` function has a shorter alias: the above
example could simply have been written

```ocaml
float i +. f
```

(Note that it is perfectly valid in OCaml for a type and a
function to have the same name.)

### Is implicit or explicit casting better?

You might think that these explicit casts are ugly, time-consuming even,
and you have a point, but there are at least two arguments in their
favour. Firstly, OCaml needs this explicit casting to be able to do type
inference (see below), and type inference is such a wonderful
time-saving feature that it easily offsets the extra keyboarding of
explicit casts. Secondly, if you've spent time debugging C programs
you'll know that (a) implicit casts cause errors which are hard to find,
and (b) much of the time you're sitting there trying to work out where
the implicit casts happen. Making the casts explicit helps you in
debugging. Thirdly, some casts (particularly int <-> float) are
actually very expensive operations. You do yourself no favours by hiding
them.

## Ordinary functions and recursive functions

Unlike in C-derived languages, a function isn't recursive unless you
explicitly say so by using `let rec` instead of just `let`. Here's an
example of a recursive function:

```ocaml
# let rec range a b =
    if a > b then []
    else a :: range (a + 1) b
val range : int -> int -> int list = <fun>
```

Notice that `range` calls itself.

The only difference between `let` and `let rec` is in the scoping of the
function name. If the above function had been defined with just `let`,
then the call to `range` would have tried to look for an existing
(previously defined) function called `range`, not the
currently-being-defined function. Using `let` (without `rec`) allows you
to re-define a value in terms of the previous definition. For example:

```ocaml
# let positive_sum a b = 
    let a = max a 0
    and b = max b 0 in
    a + b
val positive_sum : int -> int -> int = <fun>
```

This redefinition hides the previous "bindings" of `a` and `b` from the
function definition. In some situations coders prefer this pattern to
using a new variable name (`let a_pos = max a 0`) as it makes the old
binding inaccessible, so that only the latest values of `a` and `b` are
accessible.

There is no performance difference between functions defined using `let`
and functions defined using `let rec`, so if you prefer you could always
use the `let rec` form and get the same semantics as C-like languages.

## Types of functions

Because of type inference you will rarely if ever need to explicitly
write down the type of your functions. However, OCaml often prints out
what it thinks are the types of your functions, so you need to know the
syntax for this. For a function `f` which takes arguments `arg1`,
`arg2`, ... `argn`, and returns type `rettype`, the compiler will print:

```
f : arg1 -> arg2 -> ... -> argn -> rettype
```

The arrow syntax looks strange now, but when we come to so-called
"currying" later you'll see why it was chosen. For now I'll just give
you some examples.

Our function `repeated` which takes a string and an integer and returns
a string has type:

```ocaml
# repeated
- : string -> int -> string = <fun>
```

Our function `average` which takes two floats and returns a float has
type:

```ocaml
# average
- : float -> float -> float = <fun>
```

The OCaml standard `int_of_char` casting function:

```ocaml
# int_of_char
- : char -> int = <fun>
```

If a function returns nothing (`void` for C and Java programmers), then
we write that it returns the `unit` type. Here, for instance, is the
OCaml equivalent of C's *[fputc(3)](https://pubs.opengroup.org/onlinepubs/009695399/functions/fputc.html)*:

```ocaml
# output_char
- : out_channel -> char -> unit = <fun>
```

### Polymorphic functions

Now for something a bit stranger. What about a function which takes
*anything* as an argument? Here's an odd function which takes an
argument, but just ignores it and always returns 3:

```ocaml
let give_me_a_three x = 3
```

What is the type of this function? In OCaml we use a special placeholder
to mean "any type you fancy". It's a single quote character followed by
a letter. The type of the above function would normally be written:

```ocaml
# give_me_a_three
- : 'a -> int = <fun>
```

where `'a` (pronounced alpha) really does mean any type. You can, for example, call this
function as `give_me_a_three "foo"` or `give_me_a_three 2.0` and both
are quite valid expressions in OCaml.

It won't be clear yet why polymorphic functions are useful, but they are
very useful and very common, and so we'll discuss them later on. (Hint:
polymorphism is kind of like templates in C++ or generics in Java).

## Type inference

So the theme of this tutorial is that functional languages have many
really cool features, and OCaml is a language which has all of these
really cool features stuffed into it at once, thus making it a very
practical language for real programmers to use. But the odd thing is
that most of these cool features have nothing to do with "functional
programming" at all. In fact, I've come to the first really cool
feature, and I still haven't talked about why functional programming is
called "functional". Anyway, here's the first really cool feature: type
inference.

Simply put: you don't need to declare the types of your functions and
variables, because OCaml will just figure them out for you!

In addition OCaml goes on to check all your types match up (even across
different files).

But OCaml is also a practical language, and for this reason it contains
backdoors into the type system allowing you to bypass this checking on
the rare occasions that it is sensible to do this. Only gurus will
probably need to bypass the type checking.

Let's go back to the `average` function which we typed into the OCaml
interactive toplevel:

```ocaml
# let average a b =
    (a +. b) /. 2.0
val average : float -> float -> float = <fun>
```

OCaml worked out all on its own that the function takes
two `float` arguments and returns a `float`!

How did it do this? Firstly it looks at where `a` and `b` are used,
namely in the expression `(a +. b)`. Now, `+.` is itself a function
which always takes two `float` arguments, so by simple deduction, `a`
and `b` must both also have type `float`.

Secondly, the `/.` function returns a `float`, and this is the same as
the return value of the `average` function, so `average` must return a
`float`. The conclusion is that `average` has this type signature:

```ocaml
# average
- : float -> float -> float = <fun>
```

Type inference is obviously easy for such a short program, but it works
even for large programs, and it's a major time-saving feature because it
removes a whole class of errors which cause segfaults,
`NullPointerException`s and `ClassCastException`s in other languages (or
important but often ignored runtime warnings).
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#running-ocaml-code">Running OCaml code</a>
</li>
<li><a href="#comments">Comments</a>
</li>
<li><a href="#calling-functions">Calling functions</a>
</li>
<li><a href="#defining-a-function">Defining a function</a>
</li>
<li><a href="#basic-types">Basic types</a>
</li>
<li><a href="#implicit-vs-explicit-casts">Implicit vs. explicit casts</a>
</li>
<li><a href="#ordinary-functions-and-recursive-functions">Ordinary functions and recursive functions</a>
</li>
<li><a href="#types-of-functions">Types of functions</a>
</li>
<li><a href="#type-inference">Type inference</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<p>You may follow along with this tutorial with just a basic OCaml installation,
as described in <a href="up_and_running.html">Up and Running</a>.</p>
<p>Alternatively, you may follow almost all of it by running OCaml in your browser
using <a href="https://try.ocamlpro.com">TryOCaml</a>, with no installation required!!!</p>
<h2 id="running-ocaml-code">Running OCaml code</h2>
<p>The easiest way to get started is to run an interactive session in
your browser thanks to <a href="https://try.ocamlpro.com">TryOCaml</a>.</p>
<p>To install OCaml on your computer, see the <a href="/docs/install.html">Install</a> documentation.</p>
<p>To quickly try small OCaml expressions, you can use an interactive
toplevel, or REPL (Read–Eval–Print Loop). The <code>ocaml</code> command provides
a very basic toplevel (you should install <code>rlwrap</code> through your system
package manager and run <code>rlwrap ocaml</code> to get history navigation).</p>
<p>The recommended alternative REPL <a href="https://github.com/diml/utop">utop</a> may be
installed through <a href="/docs/install.html#OPAM">OPAM</a> or your system package
manager. It has the same basic interface but is much more convenient to use
(history navigation, auto-completion, etc.).</p>
<p>Use <code>;;</code> to indicate that you've finished entering each expression and prompt OCaml to evaluate it. Here is what running <code>ocaml</code> looks like:</p>
<pre><code class="language-console">$ ocaml
        OCaml version OCaml version 4.12.0

# 1 + 1;;
- : int = 2
</code></pre>
<p>This is how running the same code looks when using <code>utop</code>:</p>
<pre><code class="language-console">───────┬─────────────────────────────────────────────────────────────┬────
       │ Welcome to utop version 2.7.0 (using OCaml version 4.12.0)! │     
       └─────────────────────────────────────────────────────────────┘     

Type #utop_help for help about using utop.

─( 10:12:16 )─&lt; command 0 &gt;───────────────────────────────────────────────
utop # 1 + 1;;
- : int = 2
</code></pre>
<h2 id="comments">Comments</h2>
<p>OCaml comments are delimited by <code>(*</code> and <code>*)</code>, like this:</p>
<pre><code class="language-ocaml">(* This is a single-line comment. *)

(* This is a
   multi-line
   comment.
*)
</code></pre>
<p>In other words, the commenting convention is very similar to original C
(<code>/* ... */</code>). There is no single-line comment syntax (like
<code># ...</code> in Python or <code>// ...</code> in C99/C++/Java).</p>
<p>OCaml counts nested <code>(* ... *)</code> blocks, and this allows you to comment
out regions of code very easily:</p>
<pre><code class="language-ocaml">(* This code is broken ...

(* Primality test. *)
let is_prime n =
  (* note to self: ask about this on the mailing lists *) XXX

*)
</code></pre>
<h2 id="calling-functions">Calling functions</h2>
<p>Let's say you've written a function — we'll call it <code>repeated</code> — which
takes a string <code>s</code> and a number <code>n</code>, and returns a new string which
contains original <code>s</code> repeated <code>n</code> times.</p>
<p>In most C-derived languages a call to this function will look like this:</p>
<pre><code class="language-C">repeated (&quot;hello&quot;, 3)  /* this is C code */
</code></pre>
<p>This means &quot;call the function <code>repeated</code> with two arguments, first
argument the string hello and second argument the number 3&quot;.</p>
<p>OCaml, in common with other functional languages, writes and brackets
function calls differently, and this is the cause of many mistakes. Here
is the same function call in OCaml:</p>
<pre><code class="language-ocaml">let repeated a b = a ^ (Int.to_string b);;
repeated &quot;hello&quot; 3  (* this is OCaml code *)
</code></pre>
<p>Note — <strong>no</strong> brackets, and <strong>no</strong> comma between the arguments.</p>
<p>The syntax <code>repeated (&quot;hello&quot;, 3)</code> <strong>is</strong> meaningful in OCaml. It means
&quot;call the function <code>repeated</code> with ONE argument, that argument being a
'pair' structure of two elements&quot;. Of course that would be a mistake,
because the <code>repeated</code> function is expecting two arguments, not one, and
the first argument should be a string, not a pair. But let's not worry
about pairs (&quot;tuples&quot;) just yet. Instead, just remember that it's a
mistake to put the brackets and commas in around function call
arguments.</p>
<p>Let's have another function — <code>prompt_string</code> — which takes a string to
prompt and returns the string entered by the user. We want to pass this
string into <code>repeated</code>. Here are the C and OCaml versions:</p>
<pre><code class="language-C">/* C code: */
repeated (prompt_string (&quot;Name please: &quot;), 3)
</code></pre>
<pre><code class="language-ocaml">let prompt_string p = &quot;&quot;;;
(* OCaml code: *)
repeated (prompt_string &quot;Name please: &quot;) 3
</code></pre>
<p>Take a careful look at the bracketing and the missing comma. In the
OCaml version, the brackets enclose the first argument of repeated
because that argument is the result of another function call. In general
the rule is: &quot;bracket around the whole function call — don't put
brackets around the arguments to a function call&quot;. Here are some more
examples:</p>
<pre><code class="language-ocaml">let f a b c = &quot;&quot;;;
let g a = &quot;&quot;;;
let f2 a = &quot;&quot;;;
let g2 a b = &quot;&quot;;;
f 5 (g &quot;hello&quot;) 3;;    (* f has three arguments, g has one argument *)
f2 (g2 3 4)            (* f2 has one argument, g2 has two arguments *)
</code></pre>
<pre><code class="language-ocaml"># repeated (&quot;hello&quot;, 3)     (* OCaml will spot the mistake *)
Line 1, characters 10-22:
Error: This expression has type 'a * 'b
       but an expression was expected of type string
</code></pre>
<h2 id="defining-a-function">Defining a function</h2>
<p>We all know how to define a function (or static method, in Java)
in our existing languages. How do we do it in OCaml?</p>
<p>The OCaml syntax is pleasantly concise. Here's a function which takes
two floating point numbers and calculates the average:</p>
<pre><code class="language-ocaml">let average a b =
  (a +. b) /. 2.0
</code></pre>
<p>Type this into the OCaml interactive toplevel (on Unix, type the command <code>ocaml</code>
from the shell) and you'll see this:</p>
<pre><code class="language-ocaml"># let average a b =
    (a +. b) /. 2.0;;
val average : float -&gt; float -&gt; float = &lt;fun&gt;
</code></pre>
<p>If you look at the function definition closely, and also at what OCaml
prints back at you, you'll have a number of questions:</p>
<ul>
<li>What are those periods in <code>+.</code> and <code>/.</code> for?
</li>
<li>What does <code>float -&gt; float -&gt; float</code> mean?
</li>
</ul>
<p>I'll answer those questions in the next sections, but first I want to go
and define the same function in C (the Java definition would be fairly
similar to C), and hopefully that should raise even more questions.
Here's our C version of <code>average</code>:</p>
<pre><code class="language-C">double average (double a, double b)
{
  return (a + b) / 2;
}
</code></pre>
<p>Now look at our much shorter OCaml definition above. Hopefully you'll be
asking:</p>
<ul>
<li>Why don't we have to define the types of <code>a</code> and <code>b</code> in the OCaml
version? How does OCaml know what the types are (indeed, <em>does</em>
OCaml know what the types are, or is OCaml completely dynamically
typed?).
</li>
<li>In C, the <code>2</code> is implicitly converted into a <code>double</code>, can't OCaml
do the same thing?
</li>
<li>What is the OCaml way to write <code>return</code>?
</li>
</ul>
<p>OK, let's get some answers.</p>
<ul>
<li>OCaml is a strongly <em>statically typed</em> language (in other words,
there's nothing dynamic going on between int, float and string).
</li>
<li>OCaml uses <em>type inference</em> to work out the types, so you don't have
to.  If you use the OCaml interactive toplevel as above, then OCaml
will tell you
its inferred type for your function.
</li>
<li>OCaml doesn't do any implicit casting. If you want a float, you have
to write <code>2.0</code> because <code>2</code> is an integer. OCaml does <strong>no automatic
conversion</strong> between int, float, string or any other type.
</li>
<li>As a side-effect of type inference in OCaml, functions (including
operators) can't have overloaded definitions. OCaml defines <code>+</code> as
the <em>integer</em> addition function. To add floats, use <code>+.</code> (note the
trailing period). Similarly, use <code>-.</code>, <code>*.</code>, <code>/.</code> for other float
operations.
</li>
<li>OCaml doesn't have a <code>return</code> keyword — the last expression in a
function becomes the result of the function automatically.
</li>
</ul>
<p>We will present more details in the following sections and chapters.</p>
<h2 id="basic-types">Basic types</h2>
<p>The basic types in OCaml are:</p>
<pre><code class="language-text">OCaml type  Range

int         31-bit signed int (roughly +/- 1 billion) on 32-bit
            processors, or 63-bit signed int on 64-bit processors
float       IEEE double-precision floating point, equivalent to C's double
bool        A boolean, written either 'true' or 'false'
char        An 8-bit character
string      A string
unit        Written as ()
</code></pre>
<p>OCaml uses one of the bits in an <code>int</code> internally in order to be able to
automatically manage the memory use (garbage collection). This is why
the basic <code>int</code> is 31 bits, not 32 bits (63 bits if you're using a 64
bit platform). In practice this isn't an issue except in a few
specialised cases. For example if you're counting things in a loop, then
OCaml limits you to counting up to 1 billion instead of 2 billion. However if you need to do things
such as processing 32 bit types (eg. you're writing crypto code or a
network stack), OCaml provides a <code>nativeint</code> type which matches the
native integer type for your platform.</p>
<p>OCaml doesn't have a basic unsigned integer type, but you can get the
same effect using <code>nativeint</code>. OCaml doesn't have built-in single-precision
floating point numbers.</p>
<p>OCaml provides a <code>char</code> type which is used for characters, written <code>'x'</code>
for example. Unfortunately the <code>char</code> type does not support Unicode or
UTF-8, There are <a href="https://github.com/yoriyuki/Camomile">comprehensive Unicode libraries</a>
which provide this functionality.</p>
<p>Strings are not just lists of characters. They have their own, more
efficient internal representation. Strings are immutable.</p>
<p>The <code>unit</code> type is sort of like <code>void</code> in C, but we'll talk about it
more below.</p>
<h2 id="implicit-vs-explicit-casts">Implicit vs. explicit casts</h2>
<p>In C-derived languages ints get promoted to floats in certain
circumstances. For example if you write <code>1 + 2.5</code> then the first
argument (which is an integer) is promoted to a floating point number,
and the result is also a floating point number. It's as if you had
written <code>((double) 1) + 2.5</code>, but all done implicitly.</p>
<p>OCaml never does implicit casts like this. In OCaml, <code>1 + 2.5</code> is a type
error. The <code>+</code> operator in OCaml requires two ints as arguments, and
here we're giving it an int and a float, so it reports this error:</p>
<pre><code class="language-ocaml"># 1 + 2.5;;
Line 1, characters 5-8:
Error: This expression has type float but an expression was expected of type
         int
</code></pre>
<p>To add two floats together you need to use a different operator, <code>+.</code>
(note the trailing period).</p>
<p>OCaml doesn't promote ints to floats automatically so this is also an
error:</p>
<pre><code class="language-ocaml"># 1 +. 2.5
Line 1, characters 1-2:
Error: This expression has type int but an expression was expected of type
         float
  Hint: Did you mean `1.'?
</code></pre>
<p>Here OCaml is now complaining about the first argument.</p>
<p>What if you actually want to add an integer and a floating point number
together? (Say they are stored as <code>i</code> and <code>f</code>). In OCaml you need to
explicitly cast:</p>
<pre><code class="language-ocaml">let i = 1;;
let f = 2.0;;
float_of_int i +. f
</code></pre>
<p><code>float_of_int</code> is a function which takes an <code>int</code> and returns a <code>float</code>.
There are a whole load of these functions, called such things as
<code>int_of_float</code>, <code>char_of_int</code>, <code>int_of_char</code>, <code>string_of_int</code> and so on,
and they mostly do what you expect.</p>
<p>Since converting an <code>int</code> to a <code>float</code> is a particularly common
operation, the <code>float_of_int</code> function has a shorter alias: the above
example could simply have been written</p>
<pre><code class="language-ocaml">float i +. f
</code></pre>
<p>(Note that it is perfectly valid in OCaml for a type and a
function to have the same name.)</p>
<h3 id="is-implicit-or-explicit-casting-better">Is implicit or explicit casting better?</h3>
<p>You might think that these explicit casts are ugly, time-consuming even,
and you have a point, but there are at least two arguments in their
favour. Firstly, OCaml needs this explicit casting to be able to do type
inference (see below), and type inference is such a wonderful
time-saving feature that it easily offsets the extra keyboarding of
explicit casts. Secondly, if you've spent time debugging C programs
you'll know that (a) implicit casts cause errors which are hard to find,
and (b) much of the time you're sitting there trying to work out where
the implicit casts happen. Making the casts explicit helps you in
debugging. Thirdly, some casts (particularly int &lt;-&gt; float) are
actually very expensive operations. You do yourself no favours by hiding
them.</p>
<h2 id="ordinary-functions-and-recursive-functions">Ordinary functions and recursive functions</h2>
<p>Unlike in C-derived languages, a function isn't recursive unless you
explicitly say so by using <code>let rec</code> instead of just <code>let</code>. Here's an
example of a recursive function:</p>
<pre><code class="language-ocaml"># let rec range a b =
    if a &gt; b then []
    else a :: range (a + 1) b
val range : int -&gt; int -&gt; int list = &lt;fun&gt;
</code></pre>
<p>Notice that <code>range</code> calls itself.</p>
<p>The only difference between <code>let</code> and <code>let rec</code> is in the scoping of the
function name. If the above function had been defined with just <code>let</code>,
then the call to <code>range</code> would have tried to look for an existing
(previously defined) function called <code>range</code>, not the
currently-being-defined function. Using <code>let</code> (without <code>rec</code>) allows you
to re-define a value in terms of the previous definition. For example:</p>
<pre><code class="language-ocaml"># let positive_sum a b = 
    let a = max a 0
    and b = max b 0 in
    a + b
val positive_sum : int -&gt; int -&gt; int = &lt;fun&gt;
</code></pre>
<p>This redefinition hides the previous &quot;bindings&quot; of <code>a</code> and <code>b</code> from the
function definition. In some situations coders prefer this pattern to
using a new variable name (<code>let a_pos = max a 0</code>) as it makes the old
binding inaccessible, so that only the latest values of <code>a</code> and <code>b</code> are
accessible.</p>
<p>There is no performance difference between functions defined using <code>let</code>
and functions defined using <code>let rec</code>, so if you prefer you could always
use the <code>let rec</code> form and get the same semantics as C-like languages.</p>
<h2 id="types-of-functions">Types of functions</h2>
<p>Because of type inference you will rarely if ever need to explicitly
write down the type of your functions. However, OCaml often prints out
what it thinks are the types of your functions, so you need to know the
syntax for this. For a function <code>f</code> which takes arguments <code>arg1</code>,
<code>arg2</code>, ... <code>argn</code>, and returns type <code>rettype</code>, the compiler will print:</p>
<pre><code>f : arg1 -&gt; arg2 -&gt; ... -&gt; argn -&gt; rettype
</code></pre>
<p>The arrow syntax looks strange now, but when we come to so-called
&quot;currying&quot; later you'll see why it was chosen. For now I'll just give
you some examples.</p>
<p>Our function <code>repeated</code> which takes a string and an integer and returns
a string has type:</p>
<pre><code class="language-ocaml"># repeated
- : string -&gt; int -&gt; string = &lt;fun&gt;
</code></pre>
<p>Our function <code>average</code> which takes two floats and returns a float has
type:</p>
<pre><code class="language-ocaml"># average
- : float -&gt; float -&gt; float = &lt;fun&gt;
</code></pre>
<p>The OCaml standard <code>int_of_char</code> casting function:</p>
<pre><code class="language-ocaml"># int_of_char
- : char -&gt; int = &lt;fun&gt;
</code></pre>
<p>If a function returns nothing (<code>void</code> for C and Java programmers), then
we write that it returns the <code>unit</code> type. Here, for instance, is the
OCaml equivalent of C's <em><a href="https://pubs.opengroup.org/onlinepubs/009695399/functions/fputc.html">fputc(3)</a></em>:</p>
<pre><code class="language-ocaml"># output_char
- : out_channel -&gt; char -&gt; unit = &lt;fun&gt;
</code></pre>
<h3 id="polymorphic-functions">Polymorphic functions</h3>
<p>Now for something a bit stranger. What about a function which takes
<em>anything</em> as an argument? Here's an odd function which takes an
argument, but just ignores it and always returns 3:</p>
<pre><code class="language-ocaml">let give_me_a_three x = 3
</code></pre>
<p>What is the type of this function? In OCaml we use a special placeholder
to mean &quot;any type you fancy&quot;. It's a single quote character followed by
a letter. The type of the above function would normally be written:</p>
<pre><code class="language-ocaml"># give_me_a_three
- : 'a -&gt; int = &lt;fun&gt;
</code></pre>
<p>where <code>'a</code> (pronounced alpha) really does mean any type. You can, for example, call this
function as <code>give_me_a_three &quot;foo&quot;</code> or <code>give_me_a_three 2.0</code> and both
are quite valid expressions in OCaml.</p>
<p>It won't be clear yet why polymorphic functions are useful, but they are
very useful and very common, and so we'll discuss them later on. (Hint:
polymorphism is kind of like templates in C++ or generics in Java).</p>
<h2 id="type-inference">Type inference</h2>
<p>So the theme of this tutorial is that functional languages have many
really cool features, and OCaml is a language which has all of these
really cool features stuffed into it at once, thus making it a very
practical language for real programmers to use. But the odd thing is
that most of these cool features have nothing to do with &quot;functional
programming&quot; at all. In fact, I've come to the first really cool
feature, and I still haven't talked about why functional programming is
called &quot;functional&quot;. Anyway, here's the first really cool feature: type
inference.</p>
<p>Simply put: you don't need to declare the types of your functions and
variables, because OCaml will just figure them out for you!</p>
<p>In addition OCaml goes on to check all your types match up (even across
different files).</p>
<p>But OCaml is also a practical language, and for this reason it contains
backdoors into the type system allowing you to bypass this checking on
the rare occasions that it is sensible to do this. Only gurus will
probably need to bypass the type checking.</p>
<p>Let's go back to the <code>average</code> function which we typed into the OCaml
interactive toplevel:</p>
<pre><code class="language-ocaml"># let average a b =
    (a +. b) /. 2.0
val average : float -&gt; float -&gt; float = &lt;fun&gt;
</code></pre>
<p>OCaml worked out all on its own that the function takes
two <code>float</code> arguments and returns a <code>float</code>!</p>
<p>How did it do this? Firstly it looks at where <code>a</code> and <code>b</code> are used,
namely in the expression <code>(a +. b)</code>. Now, <code>+.</code> is itself a function
which always takes two <code>float</code> arguments, so by simple deduction, <code>a</code>
and <code>b</code> must both also have type <code>float</code>.</p>
<p>Secondly, the <code>/.</code> function returns a <code>float</code>, and this is the same as
the return value of the <code>average</code> function, so <code>average</code> must return a
<code>float</code>. The conclusion is that <code>average</code> has this type signature:</p>
<pre><code class="language-ocaml"># average
- : float -&gt; float -&gt; float = &lt;fun&gt;
</code></pre>
<p>Type inference is obviously easy for such a short program, but it works
even for large programs, and it's a major time-saving feature because it
removes a whole class of errors which cause segfaults,
<code>NullPointerException</code>s and <code>ClassCastException</code>s in other languages (or
important but often ignored runtime warnings).</p>
|js}
  };
 
  { title = {js|OCaml Programming Guidelines|js}
  ; slug = {js|ocaml-programming-guidelines|js}
  ; description = {js|Opinionated guidelines for writing OCaml code
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["getting-started"]
  ; users = [`Beginner; `Intermediate; `Advanced]
  ; body_md = {js|
This is a set of reasonable guidelines for formatting OCaml
programs—guidelines which reflect the consensus among veteran OCaml
programmers. Nevertheless, all detailed notifications of possible errors
or omissions will be noted with pleasure. To send your comments using
[GitHub issues](https://github.com/ocaml/ocaml.org/issues?state=open).
<br />
Original translation from French: [Ruchira
Datta](mailto:datta@math.berkeley.edu).

Thanks to all those who have already participated in the critique of
this page: Daniel de Rauglaudre, Luc Maranget, Jacques Garrigue, Damien
Doligez, Xavier Leroy, Bruno Verlyck, Bruno Petazzoni, Francois Maltey,
Basile Starynkevitch, Toby Moth, Pierre Lescanne.

## General guidelines to write programs
###  Be simple and readable
The time you spend typing the programs is negligible compared to the
time spent reading them. That's the reason why you save a lot of time if
you work hard to optimize readability.

All the time you are "wasting" to get a simpler program today, will
return a hundred times in the future during the uncountably many
modifications and readings of the program (starting with the first
debugging).

> 
> **Writing programs law**: A program is written once, modified ten
> times, and read 100 times. So simplify its writing, always keep future
> modifications in mind, and never jeopardize readability.
> 

## Program formatting guidelines
###  Lexical conventions
> 
> **Pseudo spaces law**: never hesitate to separate words of your
> programs with spaces; the space bar is the easiest key to find on the
> keyboard, press it as often as necessary!
> 

####  Delimiters
A space should always follow a delimiter symbol, and spaces should
surround operator symbols. It has been a great step forward in
typography to separate words by spaces to make written texts easier to
read. Do the same in your programs if you want them to be readable.

####  How to write pairs
A tuple is parenthesized and the commas therein (delimiters) are each
followed by a space: `(1, 2)`, `let   triplet = (x, y, z)`...

* **Commonly accepted exceptions**:
    * **Definition of the components of a pair**: In place of
 `let (x, y) =       ...`, you can write `let x, y = ...`.

> **Justification**: The point is to define several values
> simultaneously, not to construct a tuple. Moreover, the
> pattern is set off nicely between `let` and `=`.

- **Matching several values simultaneously**: It's okay to omit
  parentheses around n-tuples when matching several values
  simultaneously.

        match x, y with
        | 1, _ -> ...
        | x, 1 -> ...
        | x, y -> ...

  > **Justification**: The point is to match several values in
  > parallel, not to construct a tuple. Moreover, the expressions
  > being matched are set off by `match` and `with`, while the
  > patterns are set off nicely by `|` and `->`.


####  How to write lists
Write `x :: l` with spaces around the `::` (since `::` is an infix
operator, hence surrounded by spaces) and `[1; 2; 3]` (since `;` is a
delimiter, hence followed by a space).

####  How to write operator symbols
Be careful to keep operator symbols well separated by spaces: not only
will your formulas be more readable, but you will avoid confusion with
multi-character operators. (Obvious exceptions to this rule: the symbols
`!` and `.` are not separated from their arguments.)<br />
Example: write `x + 1` or `x + !y`.

 
> **Justification**: If you left out the spaces then `x+1` would be
> understood, but `x+!y` would change its meaning since `+!` would
> be interpreted as a multi-character operator.
> 
> **Criticism**: The absence of spaces around an operator improves the
> readability of formulas when you use it to reflect the relative
> precedences of operators. For example `x*y + 2*z` makes it very
> obvious that multiplication takes precedence over addition.
> 
> **Response**: This is a bad idea, a chimera, because nothing in the
> language ensures that the spaces properly reflect the meaning of the
> formula. For example `x * z-1` means `(x * z) - 1`, and not
> `x * (z - 1)` as the proposed interpretation of spaces would seem to
> suggest. Besides, the problem of multi-character symbols would keep
> you from using this convention in a uniform way: you couldn't leave
> out the spaces around the multiplication to write `x*!y + 2*!z`.
> Finally, this playing with the spaces is a subtle and flimsy
> convention, a subliminal message which is difficult to grasp on
> reading. If you want to make the precedences obvious, use the
> expressive means brought to you by the language: write parentheses.
> 
> **Additional justification**: Systematically surrounding operators
> with spaces simplify the treatment of infix operators which are no
> more a complex particular case; in effect, whereas you can write `(+)`
> without spaces, you evidently cannot write `(*)` since `(*` is read as
> the beginning of a comment. You must write at least one space as in
> “`( *)`”, although an extra space after `*` is definitively preferable
> if you want to avoid that `*)` could be read, in some contexts, as the
> end of a comment. All those difficulties are easily avoided if you
> adopt the simple rule proposed here: keep operator symbols well
> separated by spaces.<br />
> In fact you will quickly feel that this rule is not so difficult to
> follow: the space bar is the greatest and best situated key of the
> keyboard, it is the easiest to enter and you cannot miss it!


####  How to write long character strings
Indent long character strings with the convention in force at that line
plus an indication of string continuation at the end of each line (a `\\`
character at the end of the line that omits white spaces on the
beginning of next line):
<!-- $MDX skip -->
```ocaml
let universal_declaration =
  "-1- Programs are born and remain free and equal under the law;\\n\\
   distinctions can only be based on the common good." in
  ...
```

## Indentation of programs
> 
> **Landin's pseudo law**: Treat the indentation of your programs as if
> it determines the meaning of your programs.
> 

I would add to this law: carefully treat the indentation of programs
because in some cases it really gives the meaning of the program!

The indentation of programs is an art which excites many strong
opinions. Here several indentation styles are given which are drawn from
experience and which have not been severely criticized.

When a justification for the adopted style has seemed obvious to me, I
have indicated it. On the other hand, criticisms are also noted.

So each time, you have to choose between the different styles
suggested.<br />
 The only absolute rule is the first below.

###  Consistency of indentation
Choose a generally accepted style of indentation, then use it
systematically throughout the whole application.

###  Width of the page
The page is 80 columns wide.

> **Justification**: This width makes it possible to read the code on
> all displays and to print it in a legible font on a standard sheet.
 

###  Height of the page
A function should always fit within one screenful (of about 70 lines),
or in exceptional cases two, at the very most three. To go beyond this
is unreasonable.

 
> **Justification**: When a function goes beyond one screenful, it's
> time to divide it into subproblems and handle them independently.
> Beyond a screenful, one gets lost in the code. The indentation is not
> readable and is difficult to keep correct.


###  How much to indent
The change in indentation between successive lines of the program is
generally 1 or 2 spaces. Pick an amount to indent and stick with it
throughout the program.

###  Using tab stops
Using the tab character (ASCII character 9) is absolutely *not*
recommended.


> **Justification**: Between one display and another, the indentation of
> the program changes completely; it can also become completely wrong,
> if the programmer used both tabulations and spaces to indent the
> program.
> 
> **Criticism**: The purpose of using tabulations is just to allow the
> readers of the program to indent more or less by changing the tabs
> stops. The overall indentation remains correct and the reader is glad
> to easily customize the indentation amount.
> 
> **Answer**: It seems almost impossible to use this method since you
> should always use tabulations to indent, which is hard and unnatural.
 

###  How to indent global `let ... ;;` definitions
The body of a function defined globally in a module is generally
indented normally. However, it's okay to treat this case specially to
set off the definition better.

With a regular indentation of 1 or 2 spaces:

<!-- $MDX skip -->
```ocaml
let f x = function
  | C ->
  | D ->
  ...

let g x =
  let tmp =
    match x with
    | C -> 1
    | x -> 0 in
  tmp + 1
```
> 
> **Justification**: No exception to the amount of indentation.
> 

Other conventions are acceptable, for example:

* The body is left-justified in the case of pattern-matching.

<!-- $MDX skip -->
```ocaml
let f x = function
| C ->
| D ->
...
```
> 
> **Justification**: The vertical bars separating the patterns stop
> when the definition is done, so it's still easy to pass on to the
> following definition.
> 
> **Criticism**: An unpleasant exception to the normal indentation.
> 


* The body is justified just under the name of the defined function.

<!-- $MDX skip -->
```ocaml
let f x =
    let tmp = ... in
    try g x with
    | Not_found ->
    ...
```
> 
> **Justification**: The first line of the definition is set off
> nicely, so it's easier to pass from definition to definition.
> 
> **Criticism**: You run into the right margin too quickly.
> 


###  How to indent `let ... in` constructs
The expression following a definition introduced by `let` is indented to
the same level as the keyword `let`, and the keyword `in` which
introduces it is written at the end of the line:

<!-- $MDX skip -->
```ocaml
let expr1 = ... in
expr1 + expr1
```

In the case of a series of `let` definitions, the preceding rule implies
that these definitions should be placed at the same indentation level:

<!-- $MDX skip -->
```ocaml
let expr1 = ... in
let n = ... in
...
```
> 
> **Justification**: It is suggested that a series of “let ... in”
> constructs is analogous to a set of assumptions in a mathematical
> text, whence the same indentation level for all the assumptions.
> 

Variation: some write the keyword `in` alone on one line to set apart
the final expression of the computation:

<!-- $MDX skip -->
```ocaml
let e1 = ... in
let e2 = ... in
let new_expr =
  let e1' = derive_expression e1
  and e2' = derive_expression e2 in
  Add_expression e1' e2'
in
Mult_expression (new_expr, new_expr)
```
> 
> **Criticism**: Lack of consistency.
> 

###  How to indent `if ... then   ... else ... `
####  Multiple branches
Write conditions with multiple branches at the same level of
indentation:

<!-- $MDX skip -->
```ocaml
if cond1 ...
if cond2 ...
if cond3 ...
```
> 
> **Justification**: Analogous treatment to pattern-matching clauses,
> all aligned to the same tab stop.
> 

If the sizes of the conditions and the expressions allow, write for
example:

<!-- $MDX skip -->
```ocaml
if cond1 then e1 else
if cond2 then e2 else
if cond3 then e3 else
e4

```
If expressions in the branches of multiple conditions have to be
enclosed (when they include statements for instance), write:

<!-- $MDX skip -->
```ocaml
if cond then begin
    e1
  end else
if cond2 then begin
    e2
  end else
if cond3 then ...
```
Some suggest another method for multiple conditionals, starting each
line by the keyword `else`:

<!-- $MDX skip -->
```ocaml
if cond1 ...
else if cond2 ...
else if cond3 ...
```
> 
> **Justification**: `elsif` is a keyword in many languages, so use
> indentation and `else if` to bring it to mind. Moreover, you do not
> have to look to the end of line to know whether the condition is
> continued or another test is performed.
> 
> **Criticism**: Lack of consistency in the treatment of all the
> conditions. Why a special case for the first condition?
> 

Yet again, choose your style and use it systematically.

####  Single branches
Several styles are possible for single branches, according to the size
of the expressions in question and especially the presence of `begin`
`end` or `(` `)` delimiters for these expressions.

In the case of delimiting the branches of a conditional, several styles
are used:

> `(` at end of line:
> 
> ```ocaml
> if cond then (
>   e1
> ) else (
>   e2
> )
> ```
> Or alternatively first `begin` at beginning of line:
> 
> ```ocaml
> if cond then
>   begin
>     e1
>   end else begin
>     e2
>   end
> ```

In fact the indentation of conditionals depends on the sizes of the
expressions which make them up.

> 
> If `cond`, `e1` and `e2` are small, simply write them on one line:
> 
> ```ocaml
> if cond then e1 else e2
> ```
> If the expressions making up a conditional are purely functional
> (without side effects), we advocate binding them within the
> conditional with `let e = ... in` when they're too big to fit on a
> line.
> 
> > 
> > **Justification**: This way you get back the simple indentation on
> > one line which is the most readable. As a side benefit, the naming
> > acts as an aid to comprehension.
> > 
> 
> So now we consider the case in which the expressions in question do
> have side effects, which keeps us from simply binding them with a
> `let e = ... in`.
> 
> > 
> > If `e1` and `cond` are small, but `e2` large:
> > 
> > ```ocaml
> > if cond then e1 else
> >   e2
> > ```
> > 
> > If `e1` and `cond` are large and `e2` small:
> > 
> > ```ocaml
> > if cond then
> >   e1
> > else e2
> > ```
> > 
> > If all the expressions are large:
> > 
> > ```ocaml
> > if cond then
> >   e1
> > else
> >   e2
> > ```
> > 
> > If there are `( )` delimiters:
> > 
> > ```ocaml
> > if cond then (
> >   e1
> > ) else (
> >   e2
> > )
> > ```
> > 
> > A mixture where `e1` requires `( )` but `e2` is small:
> > 
> > ```ocaml
> > if cond then (
> >     e1
> > ) else e2
> > ```

###  How to indent pattern-matching constructs
####  General principles
All the pattern-matching clauses are introduced by a vertical bar,
*including* the first one.

> 
> **Criticism**: The first vertical bar is not mandatory: hence, there
> is no need to write it.
> 
> **Answer to criticism**: If you omit the first bar the indentation
> seems unnatural : the first case gets an indentation that is greater
> than a normal new line would necessitate. It is thus a useless
> exception to the correct indentation rule. It also insists not to use
> the same syntax for the whole set of clauses, writing the first clause
> as an exception with a slightly different syntax. Last, aesthetic
> value is doubtful (some people would say “awful” instead of
> “doubtful”).
> 

Align all the pattern-matching clauses at the level of the vertical bar
which begins each clause, *including* the first one.

If an expression in a clause is too large to fit on the line, you must
break the line immediately after the arrow of the corresponding clause.
Then indent normally, starting from the beginning of the pattern of the
clause.

Arrows of pattern matching clauses should not be aligned.

####  `match` or `try`
For a `match` or a `try` align the clauses with the beginning of the
construct:

<!-- $MDX skip -->
```ocaml
match lam with
| Abs (x, body) -> 1 + size_lambda body
| App (lam1, lam2) -> size_lambda lam1 + size_lambda lam2
| Var v -> 1

try f x with
| Not_found -> ...
| Failure "not yet implemented" -> ...
```
Put the keyword `with` at the end of the line. If the preceding
expression extends beyond one line, put `with` on a line by itself:

<!-- $MDX skip -->
```ocaml
try
  let y = f x in
  if ...
with
| Not_found -> ...
| Failure "not yet implemented" -> ...
```
> 
> **Justification**: The keyword `with`, on a line by itself shows that
> the program enters the pattern matching part of the construct.
> 

####  Indenting expressions inside clauses
If the expression on the right of the pattern matching arrow is too
large, cut the line after the arrow.

<!-- $MDX skip -->
```ocaml
match lam with
| Abs (x, body) ->
   1 + size_lambda body
| App (lam1, lam2) ->
   size_lambda lam1 + size_lambda lam2
| Var v ->
```
Some programmers generalize this rule to all clauses, as soon as one
expressions overflows. They will then indent the last clause like this:

<!-- $MDX skip -->
```ocaml
| Var v ->
   1
```
Other programmers go one step further and apply this rule systematically
to any clause of any pattern matching.

<!-- $MDX skip -->
```ocaml
let rec fib = function
  | 0 ->
     1
  | 1 ->
     1
  | n ->
     fib (n - 1) + fib ( n - 2)
```
> 
> **Criticism**: May be not compact enough; for simple pattern matchings
> (or simple clauses in complex matchings), the rule does not add any
> good to readability.
> 
> **Justification**: I don't see any good reason for this rule, unless
> you are paid proportionally to the number of lines of code: in this
> case use this rule to get more money without adding more bugs in your
> OCaml programs!
> 

####  Pattern matching in anonymous functions
Similarly to `match` or `try`, pattern matching of anonymous functions,
starting by `function`, are indented with respect to the `function`
keyword:

<!-- $MDX skip -->
```ocaml
map
  (function
   | Abs (x, body) -> 1 + size_lambda 0 body
   | App (lam1, lam2) -> size_lambda (size_lambda 0 lam1) lam2
   | Var v -> 1)
  lambda_list
```
####  Pattern matching in named functions
Pattern-matching in functions defined by `let` or `let rec` gives rise
to several reasonable styles which obey the preceding rules for pattern
matching (the one for anonymous functions being evidently excepted). See
above for recommended styles.

<!-- $MDX skip -->
```ocaml
let rec size_lambda accu = function
  | Abs (x, body) -> size_lambda (succ accu) body
  | App (lam1, lam2) -> size_lambda (size_lambda accu lam1) lam2
  | Var v -> succ accu

let rec size_lambda accu = function
| Abs (x, body) -> size_lambda (succ accu) body
| App (lam1, lam2) -> size_lambda (size_lambda accu lam1) lam2
| Var v -> succ accu
```
###  Bad indentation of pattern-matching constructs
####  No *beastly* indentation of functions and case analyses.
This consists in indenting normally under the keyword `match` or
`function` which has previously been pushed to the right. Don't write:

<!-- $MDX skip -->
```ocaml
let rec f x = function
              | [] -> ...
              ...
```
but choose to indent the line under the `let` keyword:

<!-- $MDX skip -->
```ocaml
let rec f x = function
  | [] -> ...
  ...
```
> 
> **Justification**: You bump into the margin. The aesthetic value is
> doubtful...
> 

####  No *beastly* alignment of the `->` symbols in pattern-matching clauses.
Careful alignment of the arrows of a pattern matching is considered bad
practice, as exemplify in the following fragment:

<!-- $MDX skip -->
```ocaml
let f = function
  | C1          -> 1
  | Long_name _ -> 2
  | _           -> 3
```
> 
> **Justification**: This makes it harder to maintain the program (the
> addition of a supplementary case can lead the indentations of all the
> lines to change and so ... we often give up alignment at that time,
> then it is better not to align the arrows in the first place!).
> 

###  How to indent function calls
####  Indentation to the function's name:
No problem arises except for functions with many arguments&mdash;or very
complicated arguments as well&mdash;which can't fit on the same line. You
must indent the expressions with respect to the name of the function (1
or 2 spaces according to the chosen convention). Write small arguments
on the same line, and change lines at the start of an argument.

As far as possible, avoid arguments which consist of complex
expressions: in these cases define the “large” argument by a `let`
construction.

> 
> **Justification**: No indentation problem; if the name given to the
> expressions is meaningful, the code is more readable as well.
> 
> **Additional justification**: If the evaluation of the arguments
> produces side effects, the `let` binding is in fact necessary to
> explicitly define the order of evaluation.
> 

####  Naming complex arguments:
In place of

<!-- $MDX skip -->
```ocaml
let temp =
  f x y z
    “large
    expression”
    “other large
    expression” in
...
```
write

<!-- $MDX skip -->
```ocaml
let t =
  “large
  expression”
and u =
  “other large
  expression” in
let temp =
  f x y z t u in
...
```
####  Naming anonymous functions:
In the case of an iterator whose argument is a complex function, define
the function by a `let` binding as well. In place of

<!-- $MDX skip -->
```ocaml
List.map
  (function x ->
    blabla
    blabla
    blabla)
  l
```
write

<!-- $MDX skip -->
```ocaml
let f x =
  blabla
  blabla
  blabla in
List.map f l
```
> 
> **Justification**: Much clearer, in particular if the name given to
> the function is meaningful.
> 

###  How to indent operations
When an operator takes complex arguments, or in the presence of multiple
calls to the same operator, start the next the line with the operator,
and don't indent the rest of the operation. For example:

<!-- $MDX skip -->
```ocaml
x + y + z
+ t + u
```
> 
> **Justification**: When the operator starts the line, it is clear that
> the operation continues on this line.
> 

In the case of a “large expression” in such an operation sequence,
to define the “large expression” with the help of a `let in`
construction is preferable to having to indent the line. In place of

<!-- $MDX skip -->
```ocaml
x + y + z
+ “large
  expression”
```
write

<!-- $MDX skip -->
```ocaml
let t =
  “large
   expression” in
x + y + z + t
```
You most certainly must bind those expressions too large to be written
in one operation in the case of a combination of operators. In place of
the unreadable expression

<!-- $MDX skip -->
```ocaml
(x + y + z * t)
/ (“large
    expression”)
```
write

<!-- $MDX skip -->
```ocaml
let u =
  “large
  expression” in
(x + y + z * t) / u
```
These guidelines extend to all operators. For example:

<!-- $MDX skip -->
```ocaml
let u =
  “large
  expression” in
x :: y
:: z + 1 :: t :: u
```
## Programming guidelines
###  How to program
> 
> *Always put your handiwork back on the bench,<br />
>  and then polish it and re-polish it.*
> 

####  Write simple and clear programs
When this is done, reread, simplify and clarify. At every stage of
creation, use your head!

####  Subdivide your programs into little functions
Small functions are easier to master.

####  Factor out snippets of repeated code by defining them in separate functions
The sharing of code obtained in this way facilitates maintenance since
every correction or improvement automatically spreads throughout the
program. Besides, the simple act of isolating and naming a snippet of
code sometimes lets you identify an unsuspected feature.

####  Never copy-paste code when programming
Pasting code almost surely indicates introducing a default of code
sharing and neglecting to identify and write a useful auxiliary
function; hence, it means that some code sharing is lost in the program.
Losing code sharing implies that you will have more problems afterwards
for maintenance: a bug in the pasted code has to be corrected at each
occurrence of the bug in each copy of the code!

Moreover, it is difficult to identify that the same set of 10 lines of
code is repeated 20 times throughout the program. By contrast, if an
auxiliary function defines those 10 lines, it is fairly easy to see and
find where those lines are used: that's simply where the function is
called. If code is copy-pasted all over the place then the program is
more difficult to understand.

In conclusion, copy-pasting code leads to programs that are more
difficult to read and more difficult to maintain: it has to be banished.

###  How to comment programs
####  Don't hesitate to comment when there's a difficulty
####  If there's no difficulty, there's no point in commenting
####  Avoid comments in the bodies of functions
####  Prefer one comment at the beginning of the function...
...which explains how the algorithm that is used works. Once more, if
there is no difficulty, there is no point in commenting.

####  Avoid nocuous comments
A *nocuous* comment is a comment that does not add any value, i.e. no
non-trivial information. The nocuous comment is evidently not of
interest; it is a nuisance since it uselessly distracts the reader. It
is often used to fulfill some strange criteria related to the so-called
*software metrology*, for instance the ratio *number of comments* /
*number of lines of code* that perfectly measures a ratio that I don't
know the theoretical or practical interpretation. Absolutely avoid
nocuous comments.

An example of what to avoid: the following comment uses technical words
and is thus masquerade into a real comment when it has no additional
information of interest;

<!-- $MDX skip -->
```ocaml
(*
  Function print_lambda:
  print a lambda-expression given as argument.

  Arguments: lam, any lambda-expression.
  Returns: nothing.

  Remark: print_lambda can only be used for its side effect.
*)
let rec print_lambda lam =
  match lam with
  | Var s -> printf "%s" s
  | Abs l -> printf "\\\\ %a" print_lambda l
  | App (l1, l2) ->
     printf "(%a %a)" print_lambda l1 print_lambda l2
```
####  Usage in module interface
The function's usage must appear in the interface of the module which
exports it, not in the program which implements it. Choose comments as
in the OCaml system's interface modules, which will subsequently allow
the documentation of the interface module to be extracted automatically
if need be.

####  Use assertions
Use assertions as much as possible: they let you avoid verbose comments,
while allowing a useful verification upon execution.

For example, the conditions for the arguments of a function to be valid
are usefully verified by assertions.

<!-- $MDX skip -->
```ocaml
let f x =
  assert (x >= 0);
  ...
```
Note as well that an assertion is often preferable to a comment because
it's more trustworthy: an assertion is forced to be pertinent because it
is verified upon each execution, while a comment can quickly become
obsolete and then becomes actually detrimental to the comprehension of
the program.

####  Comments line by line in imperative code
When writing difficult code, and particularly in case of highly
imperative code with a lot of memory modifications (physical mutations
in data structures), it is sometime mandatory to comment inside the body
of functions to explain the implementation of the algorithm encoded
here, or to follow successive modifications of invariants that the
function must maintain. Once more, if there is some difficulty
commenting is mandatory, for each program line if necessary.

###  How to choose identifiers
It's hard to choose identifiers whose name evokes the meaning of the
corresponding portion of the program. This is why you must devote
particular care to this, emphasizing clarity and regularity of
nomenclature.

####  Don't use abbreviations for global names
Global identifiers (including especially the names of functions) can be
long, because it's important to understand what purpose they serve far
from their definition.

####  Separate words by underscores: (`int_of_string`, not `intOfString`)
Case modifications are meaningful in OCaml: in effect capitalized words
are reserved for constructors and module names in OCaml; in contrast
regular variables (functions or identifiers) must start by a lowercase
letter. Those rules prevent proper usage of case modification for words
separation in identifiers: the first word starts the identifier, hence
it must be lower case and it is forbidden to choose `IntOfString` as the
name of a function.

####  Always give the same name to function arguments which have the same meaning
If necessary, make this nomenclature explicit in a comment at the top of
the file); if there are several arguments with the same meaning then
attach numeral suffixes to them.

####  Local identifiers can be brief, and should be reused from one function to another
This augments regularity of style. Avoid using identifiers whose
appearance can lead to confusion such as `l` or `O`, easy to confuse
with `1` and `0`.

Example:

<!-- $MDX skip -->
```ocaml
let add_expression expr1 expr2 = ...
let print_expression expr = ...
```
An exception to the recommendation not to use capitalization to separate
words within identifiers is tolerated in the case of interfacing with
existing libraries which use this naming convention: this lets OCaml
users of the library to orient themselves in the original library
documentation more easily.

###  When to use parentheses within an expression
Parentheses are meaningful: they indicate the necessity of using an
unusual precedence. So they should be used wisely and not sprinkled
randomly throughout programs. To this end, you should know the usual
precedences, that is, the combinations of operations which do not
require parentheses. Quite fortunately this is not complicated if you
know a little mathematics or strive to follow the following rules:

####  Arithmetic operators: the same rules as in mathematics
For example: `1 + 2 * x` means `1 + (2 * x)`.

####  Function application: the same rules as those in mathematics for usage of *trigonometric functions*
In mathematics you write `sin x` to mean `sin (x)`. In the same way
`sin x + cos x` means `(sin x) + (cos x)` not `sin (x + (cos x))`. Use
the same conventions in OCaml: write `f x + g x` to mean
`(f x) + (g x)`.<br />
This convention generalizes **to all (infix) operators**: `f x :: g x`
means `(f x) :: (g x)`, `f x @ g x` means `(f x) @ (g x)`, and
`failwith s ^ s'` means `(failwith s) ^ s'`, *not* `failwith (s ^ s')`.

####  Comparisons and boolean operators
Comparisons are infix operators, so the preceding rules apply. This is
why `f x < g x` means `(f x) < (g x)`. For type reasons (no other
sensible interpretation) the expression `f x < x + 2` means
`(f x) < (x + 2)`. In the same way `f x < x + 2 && x > 3` means
`((f x) < (x + 2)) && (x > 3)`.

####  The relative precedences of the boolean operators are those of mathematics
Although mathematicians have a tendency to overuse parens in this case,
the boolean “or” operator is analogous to addition and the “and”
to multiplication. So, just as `1 + 2 * x` means `1 + (2 * x)`,
`true || false && x` means `true || (false && x)`.

###  How to delimit constructs in programs
When it is necessary to delimit syntactic constructs in programs, use as
delimiters the keywords `begin` and `end` rather than parentheses.
However using parentheses is acceptable if you do it in a consistent,
that is, systematic, way.

This explicit delimiting of constructs essentially concerns
pattern-matching constructs or sequences embedded within
`if then     else` constructs.

####  `match` construct in a `match` construct
When a `match ... with` or `try ... with` construct appears in a
pattern-matching clause, it is absolutely necessary to delimit this
embedded construct (otherwise subsequent clauses of the enclosing
pattern-matching construct will automatically be associated with the
enclosed pattern-matching construct). For example:

<!-- $MDX skip -->
```ocaml
match x with
| 1 ->
  begin match y with
  | ...
  end
| 2 ->
...
```
####  Sequences inside branches of `if`
In the same way, a sequence which appears in the `then` or `else` part
of a conditional must be delimited:

<!-- $MDX skip -->
```ocaml
if cond then begin
  e1;
  e2
end else begin
  e3;
  e4
end
```
###  How to use modules
####  Subdividing into modules
You must subdivide your programs into coherent modules.

For each module, you must explicitly write an interface.

For each interface, you must document the things defined by the module:
functions, types, exceptions, etc.

####  Opening modules
Avoid `open` directives, using instead the qualified identifier
notation. Thus you will prefer short but meaningful module names.

> 
> **Justification**: The use of unqualified identifiers is ambiguous and
> gives rise to difficult-to-detect semantic errors.
> 

<!-- $MDX skip -->
```ocaml
let lim = String.length name - 1 in
...
let lim = Array.length v - 1 in
...
... List.map succ ...
... Array.map succ ...
```
####  When to use open modules rather than leaving them closed
You can consider it normal to open a module which modifies the
environment, and brings other versions of an important set of functions.
For example, the `Format` module provides automatically indented
printing. This module redefines the usual printing functions
`print_string`, `print_int`, `print_float`, etc. So when you use
`Format`, open it systematically at the top of the file.<br />
If you don't open `Format` you could miss the qualification of a
printing function, and this could be perfectly silent, since many of
`Format`'s functions have a counterpart in the default environment
(`Pervasives`). Mixing printing functions from `Format` and `Pervasives`
leads to subtle bugs in the display, that are difficult to trace. For
instance:

<!-- $MDX skip -->
```ocaml
let f () =
  Format.print_string "Hello World!"; print_newline ()
```
is bogus since it does not call `Format.print_newline` to flush the
pretty-printer queue and output `"Hello World!"`. Instead
`"Hello World!"` is stuck into the pretty-printer queue, while
`Pervasives.print_newline` outputs a carriage return on the standard
output ... If `Format` is printing on a file and standard output is the
terminal, the user will have a bad time finding that a carriage return
is missing in the file (and the display of material on the file is
strange, since boxes that should be closed by `Format.print_newline` are
still open), while a spurious carriage return appeared on the screen!

For the same reason, open large libraries such as the one with
arbitrary-precision integers so as not to burden the program which uses
them.

<!-- $MDX skip -->
```ocaml
open Num

let rec fib n =
  if n <= 2 then Int 1 else fib (n - 1) +/ fib (n - 2)
```
> 
> **Justification**: The program would be less readable if you had to
> qualify all the identifiers.
> 

In a program where type definitions are shared, it is good to gather
these definitions into one or more module(s) without implementations
(containing only types). Then it's acceptable to systematically open the
module which exports the shared type definitions.

###  Pattern-matching
####  Never be afraid of over-using pattern-matching!
####  On the other hand, be careful to avoid non-exhaustive pattern-matching constructs
Complete them with care, without using a “catch-all” clause such as
`| _ -> ...` or `| x -> ...` when it's possible to do without it (for
example when matching a concrete type defined within the program). See
also the next section: compiler warnings.

###  Compiler warnings
Compiler warnings are meant to prevent potential errors; this is why you
absolutely must heed them and correct your programs if compiling them
produces such warnings. Besides, programs whose compilation produces
warnings have an odor of amateurism which certainly doesn't suit your
own work!

####  Pattern-matching warnings
Warnings about pattern-matching must be treated with the upmost care:

* Those concerning useless clauses should of course be eliminated.


* For non-exhaustive pattern-matching you must complete the
 corresponding pattern-matching construct, without adding a default
 case “catch-all”, such as `| _ -> ... `, but with an explicit
 list of the constructors not examined by the rest of the construct,
 for example `| Cn _ | Cn1 _ -> ... `.

> 
> **Justification**: It's not really any more complicated to write
> it this way, and this allows the program to evolve more safely. In
> effect the addition of a new constructor to the datatype being
> matched will produce an alert anew, which will allow the
> programmer to add a clause corresponding to the new constructor if
> that is warranted. On the contrary, the “catch-all” clause
> will make the function compile silently and it might be thought
> that the function is correct as the new constructor will be
> handled by the default case.
> 


* Non-exhaustive pattern-matches induced by clauses with guards must
 also be corrected. A typical case consists in suppressing a
 redundant guard.

####  De-structuring `let` bindings
\\[Translator's note: a “de-structuring `let` binding” is one which
binds several names to several expressions simultaneously. You pack all
the names you want bound into a collection such as a tuple or a list,
and you correspondingly pack all the expressions into a collective
expression. When the `let` binding is evaluated, it unpacks the
collections on both sides and binds each expression to its corresponding
name. For example, `let x, y = 1, 2` is a de-structuring `let` binding
which performs both the bindings `let x = 1` and `let y = 2`
simultaneously.\\]<br />
The `let` binding is not limited to simple identifier definitions: you
can use it with more complex or simpler patterns. For instance

* `let` with complex patterns:<br />
 `let [x; y] as l = ...`<br />
 simultaneously defines a list `l` and its two elements `x` and `y`.
* `let` with simple pattern:<br />
 `let _ = ...` does not define anything, it just evaluate the
 expression on the right hand side of the `=` symbol.

####  The de-structuring `let` must be exhaustive
Only use de-structuring `let` bindings in the case where the
pattern-matching is exhaustive (the pattern can never fail to match).
Typically, you will thus be limited to definitions of product types
(tuples or records) or definitions of variant type with a single case.
In any other case, you should use an explicit `match   ... with`
construct.

* `let ... in`: de-structuring `let` that give a warning must be
 replaced by an explicit pattern matching. For instance, instead of
 `let [x; y] as l = List.map succ     (l1 @ l2) in expression` write:

<!-- $MDX skip -->
```ocaml
match List.map succ (l1 @ l2) with
| [x; y] as l -> expression
| _ -> assert false
```


* Global definition with de-structuring lets should be rewritten with
 explicit pattern matching and tuples:

<!-- $MDX skip -->
```ocaml
let x, y, l =
  match List.map succ (l1 @ l2) with
  | [x; y] as l -> x, y, l
  | _ -> assert false
```


> 
> **Justification**: There is no way to make the pattern-matching
> exhaustive if you use general de-structuring `let` bindings.
> 

####  Sequence warnings and `let _ = ...`
When the compiler emits a warning about the type of an expression in a
sequence, you have to explicitly indicate that you want to ignore the
result of this expression. To this end:

* use a vacuous binding and suppress the sequence warning of

<!-- $MDX skip -->
```ocaml
List.map f l;
print_newline ()
```
write
<!-- $MDX skip -->
```ocaml
let _ = List.map f l in
print_newline ()
```


* you can also use the predefined function `ignore : 'a     -> unit`
 that ignores its argument to return `unit`.

<!-- $MDX skip -->
```ocaml
ignore (List.map f l);
print_newline ()
```


* In any case, the best way to suppress this warning is to understand
 why it is emitted by the compiler: the compiler warns you because
 your code computes a result that is useless since this result is
 just deleted after computation. Hence, if useful at all, this
 computation is performed only for its side-effects; hence it should
 return unit.<br />
 Most of the time, the warning indicates the use of the wrong
 function, a probable confusion between the side-effect only version
 of a function (which is a procedure whose result is irrelevant) with
 its functional counterpart (whose result is meaningful).<br />
 In the example mentioned above, the first situation prevailed, and
 the programmer should have called `iter` instead of `map`, and
 simply write

<!-- $MDX skip -->
```ocaml
List.iter f l;
print_newline ()
```
In actual programs, the suitable (side-effect only) function may not
exist and has to be written: very often, a careful separation of the
procedural part from the functional part of the function at hand
elegantly solves the problem, and the resulting program just looks
better afterwards! For instance, you would turn the problematic
definition:
<!-- $MDX skip -->
```ocaml
let add x y =
  if x > 1 then print_int x;
  print_newline ();
  x + y;;
```
into the clearer separate definitions and change old calls to `add`
accordingly.



In any case, use the `let _ = ...` construction exactly in those cases
where you want to ignore a result. Don't systematically replace
sequences with this construction.

> 
> **Justification**: Sequences are much clearer! Compare `e1; e2; e3` to
> 
> ```ocaml
> let _ = e1 in
> let _ = e2 in
> e3
> ```

###  The `hd` and `tl` functions
Don't use the `hd` and `tl` functions, but pattern-match the list
argument explicitly.

> 
> **Justification**: This is just as brief as and much clearer than
> using `hd` and `tl` which must of necessity be protected by
> `try... with...` to catch the exception which might be raised by these
> functions.
> 

###  Loops
####  `for` loops
To simply traverse an array or a string, use a `for` loop.

<!-- $MDX skip -->
```ocaml
for i = 0 to Array.length v - 1 do
  ...
done
```
If the loop is complex or returns a result, use a recursive function.

<!-- $MDX skip -->
```ocaml
let find_index e v =
  let rec loop i =
    if i >= Array.length v then raise Not_found else
    if v.(i) = e then i else loop (i + 1) in
  loop 0;;
```
> 
> **Justification**: The recursive function lets you code any loop
> whatsoever simply, even a complex one, for example with multiple exit
> points or with strange index steps (steps depending on a data value
> for example).
> 
> Besides, the recursive loop avoids the use of mutables whose value can
> be modified in any part of the body of the loop whatsoever (or even
> outside): on the contrary the recursive loop explicitly takes as
> arguments the values susceptible to change during the recursive calls.
> 

####  `while` loops
> 
> **While loops law**: Beware: usually a while loop is wrong, unless its
> loop invariant has been explicitly written.
> 

The main use of the `while` loop is the infinite loop
`while true do     ...`. You get out of it through an exception,
generally on termination of the program.

Other `while` loops are hard to use, unless they come from canned
programs from algorithms courses where they were proved.

> 
> **Justification**: `while` loops require one or more mutables in order
> that the loop condition change value and the loop finally terminate.
> To prove their correctness, you must therefore discover the loop
> invariants, an interesting but difficult sport.
> 

###  Exceptions
Don't be afraid to define your own exceptions in your programs, but on
the other hand use as much as possible the exceptions predefined by the
system. For example, every search function which fails should raise the
predefined exception `Not_found`. Be careful to handle the exceptions
which may be raised by a function call with the help of a
`try ... with`.

Handling all exceptions by `try     ... with _ ->` is usually reserved
for the main function of the program. If you need to catch all
exceptions to maintain an invariant of an algorithm, be careful to name
the exception and re-raise it, after having reset the invariant.
Typically:
<!-- $MDX skip -->
```ocaml
let ic = open_in ...
and oc = open_out ... in
try
  treatment ic oc;
  close_in ic; close_out oc
with x -> close_in ic; close_out oc; raise x
```
> 
> **Justification**: `try ... with _     ->` silently catches all
> exceptions, even those which have nothing to do with the computation
> at hand (for example an interruption will be captured and the
> computation will continue anyway!).
> 

###  Data structures
One of the great strengths of OCaml is the power of the data structures
which can be defined and the simplicity of manipulating them. So you
must take advantage of this to the fullest extent; don't hesitate to
define your own data structures. In particular, don't systematically
represent enumerations by whole numbers, nor enumerations with two cases
by booleans. Examples:

```ocaml
type figure =
   | Triangle | Square | Circle | Parallelogram
type convexity =
   | Convex | Concave | Other
type type_of_definition =
   | Recursive | Non_recursive
```
> 
> **Justification**: A boolean value often prevents intuitive
> understanding of the corresponding code. For example, if
> `type_of_definition` is coded by a boolean, what does `true` signify?
> A “normal” definition (that is, non-recursive) or a recursive
> definition?
> 
> In the case of an enumerated type encode by an integer, it is very
> difficult to limit the range of acceptable integers: one must define
> construction functions that will ensure the mandatory invariants of
> the program (and verify afterwards that no values has been built
> directly), or add assertions in the program and guards in pattern
> matchings. This is not good practice, when the definition of a sum
> type elegantly solves this problem, with the additional benefit of
> firing the full power of pattern matching and compiler's verifications
> of exhaustiveness.
> 
> **Criticism**: For binary enumerations, one can systematically define
> predicates whose names carry the semantics of the boolean that
> implements the type. For instance, we can adopt the convention that a
> predicate ends by the letter `p`. Then, in place of defining a new sum
> type for `type_of_definition`, we will use a predicate function
> `recursivep` that returns true if the definition is recursive.
> 
> **Answer**: This method is specific to binary enumeration and cannot
> be easily extended; moreover it is not well suited to pattern
> matching. For instance, for definitions encoded by
> `| Let of bool * string * expression` a typical pattern matching would
> look like:
> 
> ```ocaml
> | Let (_, v, e) as def ->
>    if recursivep def then code_for_recursive_case
>    else code_for_non_recursive_case
> ```
> 
> or, if `recursivep` can be applied to booleans:
> 
> ```ocaml
> | Let (b, v, e) ->
>    if recursivep b then code_for_recursive_case
>    else code_for_non_recursive_case
> ```
> 
> contrast with an explicit encoding:
> 
> ```ocaml
> | Let (Recursive, v, e) -> code_for_recursive_case
> | Let (Non_recursive, v, e) -> code_for_non_recursive_case
> ```
> 
> The difference between the two programs is subtle and you may think
> that this is just a matter of taste; however the explicit encoding is
> definitively more robust to modifications and fits better with the
> language.
> 

*A contrario*, it is not necessary to systematically define new types
for boolean flags, when the interpretation of constructors `true` and
`false` is clear. The usefulness of the definition of the following
types is then questionable:
<!-- $MDX skip -->
```ocaml
type switch = On | Off
type bit = One | Zero
```
The same objection is admissible for enumerated types represented as
integers, when those integers have an evident interpretation with
respect to the data to be represented.

###  When to use mutables
Mutable values are useful and sometimes indispensable to simple and
clear programming. Nevertheless, you must use them with discernment:
OCaml's normal data structures are immutable. They are to be preferred
for the clarity and safety of programming which they allow.

###  Iterators
OCaml's iterators are a powerful and useful feature. However you should
not overuse them, nor *a contrario* neglect them: they are provided to
you by libraries and have every chance of being correct and
well-thought-out by the author of the library. So it's useless to
reinvent them.

So write
<!-- $MDX skip -->
```ocaml
let square_elements elements = List.map square elements
```
rather than:
<!-- $MDX skip -->
```ocaml
let rec square_elements = function
  | [] -> []
  | elem :: elements -> square elem :: square_elements elements
```
On the other hand avoid writing:
<!-- $MDX skip -->
```ocaml
let iterator f x l =
  List.fold_right (List.fold_left f) [List.map x l] l
```
even though you get:
<!-- $MDX skip -->
```ocaml
  let iterator f x l =
    List.fold_right (List.fold_left f) [List.map x l] l;;
  iterator (fun l x -> x :: l) (fun l -> List.rev l) [[1; 2; 3]]
```
In case of express need, you must be careful to add an explanatory
comment: in my opinion it's absolutely necessary!

###  How to optimize programs
> 
> **Pseudo law of optimization**: No optimization *a priori*.<br />
>  No optimization *a posteriori* either.
> 

Above all program simply and clearly. Don't start optimizing until the
program bottleneck has been identified (in general a few routines). Then
optimization consists above all of changing *the complexity* of the
algorithm used. This often happens through redefining the data
structures being manipulated and completely rewriting the part of the
program which poses a problem.

> 
> **Justification**: Clarity and correctness of programs take
> precedence. Besides, in a substantial program, it is practically
> impossible to identify *a priori* the parts of the program whose
> efficiency is of prime importance.
> 

###  How to choose between classes and modules
You should use OCaml classes when you need inheritance, that is,
incremental refinement of data and their functionality.

You should use conventional data structures (in particular, variant
types) when you need pattern-matching.

You should use modules when the data structures are fixed and their
functionality is equally fixed or it's enough to add new functions in
the programs which use them.

###  Clarity of OCaml code
The OCaml language includes powerful constructs which allow simple and
clear programming. The main problem to obtain crystal clear programs it
to use them appropriately.

The language features numerous programming styles (or programming
paradigms): imperative programming (based on the notion of state and
assignment), functional programming (based on the notion of function,
function results, and calculus), object oriented programming (based of
the notion of objects encapsulating a state and some procedures or
methods that can modify the state). The first work of the programmer is
to choose the programming paradigm that fits the best the problem at
hand. When using one of those programming paradigms, the difficulty is
to use the language construct that expresses in the most natural and
easiest way the computation that implements the algorithm.

####  Style dangers
Concerning programming styles, one can usually observe the two
symmetrical problematic behaviors: on the one hand, the “all
imperative” way (*systematic* usage of loops and assignment), and on
the other hand the “purely functional” way (*never* use loops nor
assignments); the “100% object” style will certainly appear in the
next future, but (fortunately) it is too new to be discussed here.

* **The “Too much imperative” danger**:
    * It is a bad idea to use imperative style to code a function that
 is *naturally* recursive. For instance, to compute the length of
 a list, you should not write:
<!-- $MDX skip -->
```ocaml
let list_length l =
  let l = ref l in
  let res = ref 0 in
  while !l <> [] do
    incr res; l := List.tl !l
  done;
  !res;;
```
in place of the following recursive function, so simple and
clear:
<!-- $MDX skip -->
```ocaml
let rec list_length = function
  | [] -> 0
  | _ :: l -> 1 + list_length l
```
(For those that would contest the equivalence of those two
versions, see the [note below](#Imperativeandfunctionalversionsoflistlength)).


* Another common “over imperative error” in the imperative world is
  not to systematically choose the simple `for` loop to iter on the
  element of a vector, but instead to use a complex `while` loop, with
  one or two references (too many useless assignments, too many
  opportunity for errors).

* This category of programmer feels that the `mutable` keyword in
  the record type definitions should be implicit.

* **The “Too much functional” danger**:
    * The programmer that adheres to this dogma avoids
 using arrays and assignment. In the most severe case, one
 observes a complete denial of writing any imperative
 construction, even in case it is evidently the most elegant way
 to solve the problem.
    * Characteristic symptoms: systematic rewriting of `for` loops
 with recursive functions, usage of lists in contexts where
 imperative data structures seem to be mandatory to anyone,
 passing numerous global parameters of the problem to every
 functions, even if a global reference would be perfect to avoid
 these spurious parameters that are mainly invariants that must
 be passed all over the place.
    * This programmer feels that the `mutable` keyword in the record
 type definitions should be suppressed from the language.

####  OCaml code generally considered unreadable
The OCaml language includes powerful constructs which allow simple and
clear programming. However the power of these constructs also lets you
write uselessly complicated code, to the point where you get a perfectly
unreadable program.

Here are a number of known ways:

* Use useless (hence novice for readability) `if then else`, as in
<!-- $MDX skip -->
```ocaml
let flush_ps () =
  if not !psused then psused := true
```
or (more subtle)
<!-- $MDX skip -->
```ocaml
let sync b =
  if !last_is_dvi <> b then last_is_dvi := b
```


* Code one construct with another. For example code a `let ... in` by
 the application of an anonymous function to an argument. You would
 write<br />
<!-- $MDX skip -->
```ocaml
(fun x y -> x + y)
   e1 e2
```
instead of simply writing
<!-- $MDX skip -->
```ocaml
let x = e1
and y = e2 in
x + y
```


* Systematically code sequences with `let in` bindings.


* Mix computations and side effects, particularly in function calls.
 Recall that the order of evaluation of arguments in a function call
 is unspecified, which implies that you must not mix side effects and
 computations in function calls. However, when there is only one
 argument you might take advantage of this to perform a side effect
 within the argument, which is extremely troublesome for the reader
 albeit without danger to the program semantics. To be absolutely
 forbidden.


* Misuse of iterators and higher-order functions (i.e. over- or
 under-use). For example it's better to use `List.map` or
 `List.iter` than to write their equivalents in-line using specific
 recursive functions of your own. Even worse, you don't use
 `List.map` or `List.iter` but write their equivalents in terms of
 `List.fold_right` and `List.fold_left`.


* Another efficient way to write unreadable code is to mix all or some
 of these methods. For example:
<!-- $MDX skip -->
```ocaml
(fun u -> print_string "world"; print_string u)
  (let temp = print_string "Hello"; "!" in
   ((fun x -> print_string x; flush stdout) " ";
    temp));;
```


If you naturally write the program `print_string "Hello world!"` in this
way, you can without a doubt submit your work to the [Obfuscated OCaml
Contest](mailto:Pierre.Weis@inria.fr).

## Managing program development
We give here tips from veteran OCaml programmers, which have served in
developing the compilers which are good examples of large complex
programs developed by small teams.

###  How to edit programs
Many developers nurture a kind of veneration towards the Emacs editor
(gnu-emacs in general) which they use to write their programs. The
editor interfaces well with the language since it is capable of syntax
coloring OCaml source code (rendering different categories of words in
color, coloring keywords for example).

The following two commands are considered indispensable:

* `CTRL-C-CTRL-C` or `Meta-X compile`: launches re-compilation from
 within the editor (using the `make` command).
* `` CTRL-X-` ``: puts the cursor in the file and at the exact place
 where the OCaml compiler has signaled an error.

Developers describe thus how to use these features: `CTRL-C-CTRL-C`
combination recompiles the whole application; in case of errors, a
succession of `` CTRL-X-` `` commands permits correction of all the
errors signaled; the cycle begins again with a new re-compilation
launched by `CTRL-C-CTRL-C`.

####  Other emacs tricks
The `ESC-/` command (dynamic-abbrev-expand) automatically completes the
word in front of the cursor with one of the words present in one of the
files being edited. Thus this lets you always choose meaningful
identifiers without the tedium of having to type extended names in your
programs: the `ESC-/` easily completes the identifier after typing the
first letters. In case it brings up the wrong completion, each
subsequent `ESC-/` proposes an alternate completion.

Under Unix, the `CTRL-C-CTRL-C` or `Meta-X     compile` combination,
followed by `` CTRL-X-` `` is also used to find all occurrences of a
certain string in a OCaml program. Instead of launching `make` to
recompile, you launch the `grep` command; then all the “error
messages” from `grep` are compatible with the `` CTRL-X-` `` usage
which automatically takes you to the file and the place where the string
is found.

###  How to edit with the interactive system
Under Unix: use the line editor `ledit` which offers great editing
capabilities “à la emacs” (including `ESC-/`!), as well as a history
mechanism which lets you retrieve previously typed commands and even
retrieve commands from one session in another. `ledit` is written in
OCaml and can be freely down-loaded
[here](ftp://ftp.inria.fr/INRIA/Projects/cristal/caml-light/bazar-ocaml/ledit.tar.gz).

###  How to compile
The `make` utility is indispensable for managing the compilation and
re-compilation of programs. Sample `make` files can be found on [The
Hump](https://caml.inria.fr//cgi-bin/hump.en.cgi). You can also consult
the `Makefiles` for the OCaml compilers.

###  How to develop as a team: version control
Users of the [Git](https://git-scm.com/) software version control system
never run out of good things to say about the productivity gains it
brings. This system supports managing development by a team of
programmers while imposing consistency among them, and also maintains a
log of changes made to the software.<br />
 Git also supports simultaneous development by several teams, possibly
dispersed among several sites linked on the Net.

An anonymous Git read-only mirror [contains the working sources of the
OCaml compilers](https://github.com/ocaml/ocaml), and the sources of
other software related to OCaml.

##  Notes
###  Imperative and functional versions of `list_length`
The two versions of `list_length` are not completely equivalent in term
of complexity, since the imperative version uses a constant amount of
stack room to execute, whereas the functional version needs to store
return addresses of suspended recursive calls (whose maximum number is
equal to the length of the list argument). If you want to retrieve a
constant space requirement to run the functional program you just have
to write a function that is recursive in its tail (or *tail-rec*), that
is a function that just ends by a recursive call (which is not the case
here since a call to `+` has to be perform after the recursive call has
returned). Just use an accumulator for intermediate results, as in:
<!-- $MDX skip -->
```ocaml
let list_length l =
  let rec loop accu = function
    | [] -> accu
    | _ :: l -> loop (accu + 1) l in
  loop 0 l
```
This way, you get a program that has the same computational properties
as the imperative program with the additional clarity and natural
look of an algorithm that performs pattern matching and recursive
calls to handle an argument that belongs to a recursive sum data type.

|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#general-guidelines-to-write-programs">General guidelines to write programs</a>
</li>
<li><a href="#program-formatting-guidelines">Program formatting guidelines</a>
</li>
<li><a href="#indentation-of-programs">Indentation of programs</a>
</li>
<li><a href="#programming-guidelines">Programming guidelines</a>
</li>
<li><a href="#managing-program-development">Managing program development</a>
</li>
<li><a href="#notes">Notes</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<p>This is a set of reasonable guidelines for formatting OCaml
programs—guidelines which reflect the consensus among veteran OCaml
programmers. Nevertheless, all detailed notifications of possible errors
or omissions will be noted with pleasure. To send your comments using
<a href="https://github.com/ocaml/ocaml.org/issues?state=open">GitHub issues</a>.
<br />
Original translation from French: <a href="mailto:datta@math.berkeley.edu">Ruchira
Datta</a>.</p>
<p>Thanks to all those who have already participated in the critique of
this page: Daniel de Rauglaudre, Luc Maranget, Jacques Garrigue, Damien
Doligez, Xavier Leroy, Bruno Verlyck, Bruno Petazzoni, Francois Maltey,
Basile Starynkevitch, Toby Moth, Pierre Lescanne.</p>
<h2 id="general-guidelines-to-write-programs">General guidelines to write programs</h2>
<h3 id="be-simple-and-readable">Be simple and readable</h3>
<p>The time you spend typing the programs is negligible compared to the
time spent reading them. That's the reason why you save a lot of time if
you work hard to optimize readability.</p>
<p>All the time you are &quot;wasting&quot; to get a simpler program today, will
return a hundred times in the future during the uncountably many
modifications and readings of the program (starting with the first
debugging).</p>
<blockquote>
<p><strong>Writing programs law</strong>: A program is written once, modified ten
times, and read 100 times. So simplify its writing, always keep future
modifications in mind, and never jeopardize readability.</p>
</blockquote>
<h2 id="program-formatting-guidelines">Program formatting guidelines</h2>
<h3 id="lexical-conventions">Lexical conventions</h3>
<blockquote>
<p><strong>Pseudo spaces law</strong>: never hesitate to separate words of your
programs with spaces; the space bar is the easiest key to find on the
keyboard, press it as often as necessary!</p>
</blockquote>
<h4 id="delimiters">Delimiters</h4>
<p>A space should always follow a delimiter symbol, and spaces should
surround operator symbols. It has been a great step forward in
typography to separate words by spaces to make written texts easier to
read. Do the same in your programs if you want them to be readable.</p>
<h4 id="how-to-write-pairs">How to write pairs</h4>
<p>A tuple is parenthesized and the commas therein (delimiters) are each
followed by a space: <code>(1, 2)</code>, <code>let   triplet = (x, y, z)</code>...</p>
<ul>
<li><strong>Commonly accepted exceptions</strong>:
<ul>
<li><strong>Definition of the components of a pair</strong>: In place of
<code>let (x, y) =       ...</code>, you can write <code>let x, y = ...</code>.
</li>
</ul>
</li>
</ul>
<blockquote>
<p><strong>Justification</strong>: The point is to define several values
simultaneously, not to construct a tuple. Moreover, the
pattern is set off nicely between <code>let</code> and <code>=</code>.</p>
</blockquote>
<ul>
<li>
<p><strong>Matching several values simultaneously</strong>: It's okay to omit
parentheses around n-tuples when matching several values
simultaneously.</p>
<pre><code>  match x, y with
  | 1, _ -&gt; ...
  | x, 1 -&gt; ...
  | x, y -&gt; ...
</code></pre>
<blockquote>
<p><strong>Justification</strong>: The point is to match several values in
parallel, not to construct a tuple. Moreover, the expressions
being matched are set off by <code>match</code> and <code>with</code>, while the
patterns are set off nicely by <code>|</code> and <code>-&gt;</code>.</p>
</blockquote>
</li>
</ul>
<h4 id="how-to-write-lists">How to write lists</h4>
<p>Write <code>x :: l</code> with spaces around the <code>::</code> (since <code>::</code> is an infix
operator, hence surrounded by spaces) and <code>[1; 2; 3]</code> (since <code>;</code> is a
delimiter, hence followed by a space).</p>
<h4 id="how-to-write-operator-symbols">How to write operator symbols</h4>
<p>Be careful to keep operator symbols well separated by spaces: not only
will your formulas be more readable, but you will avoid confusion with
multi-character operators. (Obvious exceptions to this rule: the symbols
<code>!</code> and <code>.</code> are not separated from their arguments.)<br />
Example: write <code>x + 1</code> or <code>x + !y</code>.</p>
<blockquote>
<p><strong>Justification</strong>: If you left out the spaces then <code>x+1</code> would be
understood, but <code>x+!y</code> would change its meaning since <code>+!</code> would
be interpreted as a multi-character operator.</p>
<p><strong>Criticism</strong>: The absence of spaces around an operator improves the
readability of formulas when you use it to reflect the relative
precedences of operators. For example <code>x*y + 2*z</code> makes it very
obvious that multiplication takes precedence over addition.</p>
<p><strong>Response</strong>: This is a bad idea, a chimera, because nothing in the
language ensures that the spaces properly reflect the meaning of the
formula. For example <code>x * z-1</code> means <code>(x * z) - 1</code>, and not
<code>x * (z - 1)</code> as the proposed interpretation of spaces would seem to
suggest. Besides, the problem of multi-character symbols would keep
you from using this convention in a uniform way: you couldn't leave
out the spaces around the multiplication to write <code>x*!y + 2*!z</code>.
Finally, this playing with the spaces is a subtle and flimsy
convention, a subliminal message which is difficult to grasp on
reading. If you want to make the precedences obvious, use the
expressive means brought to you by the language: write parentheses.</p>
<p><strong>Additional justification</strong>: Systematically surrounding operators
with spaces simplify the treatment of infix operators which are no
more a complex particular case; in effect, whereas you can write <code>(+)</code>
without spaces, you evidently cannot write <code>(*)</code> since <code>(*</code> is read as
the beginning of a comment. You must write at least one space as in
“<code>( *)</code>”, although an extra space after <code>*</code> is definitively preferable
if you want to avoid that <code>*)</code> could be read, in some contexts, as the
end of a comment. All those difficulties are easily avoided if you
adopt the simple rule proposed here: keep operator symbols well
separated by spaces.<br />
In fact you will quickly feel that this rule is not so difficult to
follow: the space bar is the greatest and best situated key of the
keyboard, it is the easiest to enter and you cannot miss it!</p>
</blockquote>
<h4 id="how-to-write-long-character-strings">How to write long character strings</h4>
<p>Indent long character strings with the convention in force at that line
plus an indication of string continuation at the end of each line (a <code>\\</code>
character at the end of the line that omits white spaces on the
beginning of next line):</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let universal_declaration =
  &quot;-1- Programs are born and remain free and equal under the law;\\n\\
   distinctions can only be based on the common good.&quot; in
  ...
</code></pre>
<h2 id="indentation-of-programs">Indentation of programs</h2>
<blockquote>
<p><strong>Landin's pseudo law</strong>: Treat the indentation of your programs as if
it determines the meaning of your programs.</p>
</blockquote>
<p>I would add to this law: carefully treat the indentation of programs
because in some cases it really gives the meaning of the program!</p>
<p>The indentation of programs is an art which excites many strong
opinions. Here several indentation styles are given which are drawn from
experience and which have not been severely criticized.</p>
<p>When a justification for the adopted style has seemed obvious to me, I
have indicated it. On the other hand, criticisms are also noted.</p>
<p>So each time, you have to choose between the different styles
suggested.<br />
The only absolute rule is the first below.</p>
<h3 id="consistency-of-indentation">Consistency of indentation</h3>
<p>Choose a generally accepted style of indentation, then use it
systematically throughout the whole application.</p>
<h3 id="width-of-the-page">Width of the page</h3>
<p>The page is 80 columns wide.</p>
<blockquote>
<p><strong>Justification</strong>: This width makes it possible to read the code on
all displays and to print it in a legible font on a standard sheet.</p>
</blockquote>
<h3 id="height-of-the-page">Height of the page</h3>
<p>A function should always fit within one screenful (of about 70 lines),
or in exceptional cases two, at the very most three. To go beyond this
is unreasonable.</p>
<blockquote>
<p><strong>Justification</strong>: When a function goes beyond one screenful, it's
time to divide it into subproblems and handle them independently.
Beyond a screenful, one gets lost in the code. The indentation is not
readable and is difficult to keep correct.</p>
</blockquote>
<h3 id="how-much-to-indent">How much to indent</h3>
<p>The change in indentation between successive lines of the program is
generally 1 or 2 spaces. Pick an amount to indent and stick with it
throughout the program.</p>
<h3 id="using-tab-stops">Using tab stops</h3>
<p>Using the tab character (ASCII character 9) is absolutely <em>not</em>
recommended.</p>
<blockquote>
<p><strong>Justification</strong>: Between one display and another, the indentation of
the program changes completely; it can also become completely wrong,
if the programmer used both tabulations and spaces to indent the
program.</p>
<p><strong>Criticism</strong>: The purpose of using tabulations is just to allow the
readers of the program to indent more or less by changing the tabs
stops. The overall indentation remains correct and the reader is glad
to easily customize the indentation amount.</p>
<p><strong>Answer</strong>: It seems almost impossible to use this method since you
should always use tabulations to indent, which is hard and unnatural.</p>
</blockquote>
<h3 id="how-to-indent-global-let---definitions">How to indent global <code>let ... ;;</code> definitions</h3>
<p>The body of a function defined globally in a module is generally
indented normally. However, it's okay to treat this case specially to
set off the definition better.</p>
<p>With a regular indentation of 1 or 2 spaces:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let f x = function
  | C -&gt;
  | D -&gt;
  ...

let g x =
  let tmp =
    match x with
    | C -&gt; 1
    | x -&gt; 0 in
  tmp + 1
</code></pre>
<blockquote>
<p><strong>Justification</strong>: No exception to the amount of indentation.</p>
</blockquote>
<p>Other conventions are acceptable, for example:</p>
<ul>
<li>The body is left-justified in the case of pattern-matching.
</li>
</ul>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let f x = function
| C -&gt;
| D -&gt;
...
</code></pre>
<blockquote>
<p><strong>Justification</strong>: The vertical bars separating the patterns stop
when the definition is done, so it's still easy to pass on to the
following definition.</p>
<p><strong>Criticism</strong>: An unpleasant exception to the normal indentation.</p>
</blockquote>
<ul>
<li>The body is justified just under the name of the defined function.
</li>
</ul>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let f x =
    let tmp = ... in
    try g x with
    | Not_found -&gt;
    ...
</code></pre>
<blockquote>
<p><strong>Justification</strong>: The first line of the definition is set off
nicely, so it's easier to pass from definition to definition.</p>
<p><strong>Criticism</strong>: You run into the right margin too quickly.</p>
</blockquote>
<h3 id="how-to-indent-let--in-constructs">How to indent <code>let ... in</code> constructs</h3>
<p>The expression following a definition introduced by <code>let</code> is indented to
the same level as the keyword <code>let</code>, and the keyword <code>in</code> which
introduces it is written at the end of the line:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let expr1 = ... in
expr1 + expr1
</code></pre>
<p>In the case of a series of <code>let</code> definitions, the preceding rule implies
that these definitions should be placed at the same indentation level:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let expr1 = ... in
let n = ... in
...
</code></pre>
<blockquote>
<p><strong>Justification</strong>: It is suggested that a series of “let ... in”
constructs is analogous to a set of assumptions in a mathematical
text, whence the same indentation level for all the assumptions.</p>
</blockquote>
<p>Variation: some write the keyword <code>in</code> alone on one line to set apart
the final expression of the computation:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let e1 = ... in
let e2 = ... in
let new_expr =
  let e1' = derive_expression e1
  and e2' = derive_expression e2 in
  Add_expression e1' e2'
in
Mult_expression (new_expr, new_expr)
</code></pre>
<blockquote>
<p><strong>Criticism</strong>: Lack of consistency.</p>
</blockquote>
<h3 id="how-to-indent-if--then----else--">How to indent <code>if ... then   ... else ... </code></h3>
<h4 id="multiple-branches">Multiple branches</h4>
<p>Write conditions with multiple branches at the same level of
indentation:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">if cond1 ...
if cond2 ...
if cond3 ...
</code></pre>
<blockquote>
<p><strong>Justification</strong>: Analogous treatment to pattern-matching clauses,
all aligned to the same tab stop.</p>
</blockquote>
<p>If the sizes of the conditions and the expressions allow, write for
example:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">if cond1 then e1 else
if cond2 then e2 else
if cond3 then e3 else
e4

</code></pre>
<p>If expressions in the branches of multiple conditions have to be
enclosed (when they include statements for instance), write:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">if cond then begin
    e1
  end else
if cond2 then begin
    e2
  end else
if cond3 then ...
</code></pre>
<p>Some suggest another method for multiple conditionals, starting each
line by the keyword <code>else</code>:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">if cond1 ...
else if cond2 ...
else if cond3 ...
</code></pre>
<blockquote>
<p><strong>Justification</strong>: <code>elsif</code> is a keyword in many languages, so use
indentation and <code>else if</code> to bring it to mind. Moreover, you do not
have to look to the end of line to know whether the condition is
continued or another test is performed.</p>
<p><strong>Criticism</strong>: Lack of consistency in the treatment of all the
conditions. Why a special case for the first condition?</p>
</blockquote>
<p>Yet again, choose your style and use it systematically.</p>
<h4 id="single-branches">Single branches</h4>
<p>Several styles are possible for single branches, according to the size
of the expressions in question and especially the presence of <code>begin</code>
<code>end</code> or <code>(</code> <code>)</code> delimiters for these expressions.</p>
<p>In the case of delimiting the branches of a conditional, several styles
are used:</p>
<blockquote>
<p><code>(</code> at end of line:</p>
<pre><code class="language-ocaml">if cond then (
  e1
) else (
  e2
)
</code></pre>
<p>Or alternatively first <code>begin</code> at beginning of line:</p>
<pre><code class="language-ocaml">if cond then
  begin
    e1
  end else begin
    e2
  end
</code></pre>
</blockquote>
<p>In fact the indentation of conditionals depends on the sizes of the
expressions which make them up.</p>
<blockquote>
<p>If <code>cond</code>, <code>e1</code> and <code>e2</code> are small, simply write them on one line:</p>
<pre><code class="language-ocaml">if cond then e1 else e2
</code></pre>
<p>If the expressions making up a conditional are purely functional
(without side effects), we advocate binding them within the
conditional with <code>let e = ... in</code> when they're too big to fit on a
line.</p>
<blockquote>
<p><strong>Justification</strong>: This way you get back the simple indentation on
one line which is the most readable. As a side benefit, the naming
acts as an aid to comprehension.</p>
</blockquote>
<p>So now we consider the case in which the expressions in question do
have side effects, which keeps us from simply binding them with a
<code>let e = ... in</code>.</p>
<blockquote>
<p>If <code>e1</code> and <code>cond</code> are small, but <code>e2</code> large:</p>
<pre><code class="language-ocaml">if cond then e1 else
  e2
</code></pre>
<p>If <code>e1</code> and <code>cond</code> are large and <code>e2</code> small:</p>
<pre><code class="language-ocaml">if cond then
  e1
else e2
</code></pre>
<p>If all the expressions are large:</p>
<pre><code class="language-ocaml">if cond then
  e1
else
  e2
</code></pre>
<p>If there are <code>( )</code> delimiters:</p>
<pre><code class="language-ocaml">if cond then (
  e1
) else (
  e2
)
</code></pre>
<p>A mixture where <code>e1</code> requires <code>( )</code> but <code>e2</code> is small:</p>
<pre><code class="language-ocaml">if cond then (
    e1
) else e2
</code></pre>
</blockquote>
</blockquote>
<h3 id="how-to-indent-pattern-matching-constructs">How to indent pattern-matching constructs</h3>
<h4 id="general-principles">General principles</h4>
<p>All the pattern-matching clauses are introduced by a vertical bar,
<em>including</em> the first one.</p>
<blockquote>
<p><strong>Criticism</strong>: The first vertical bar is not mandatory: hence, there
is no need to write it.</p>
<p><strong>Answer to criticism</strong>: If you omit the first bar the indentation
seems unnatural : the first case gets an indentation that is greater
than a normal new line would necessitate. It is thus a useless
exception to the correct indentation rule. It also insists not to use
the same syntax for the whole set of clauses, writing the first clause
as an exception with a slightly different syntax. Last, aesthetic
value is doubtful (some people would say “awful” instead of
“doubtful”).</p>
</blockquote>
<p>Align all the pattern-matching clauses at the level of the vertical bar
which begins each clause, <em>including</em> the first one.</p>
<p>If an expression in a clause is too large to fit on the line, you must
break the line immediately after the arrow of the corresponding clause.
Then indent normally, starting from the beginning of the pattern of the
clause.</p>
<p>Arrows of pattern matching clauses should not be aligned.</p>
<h4 id="match-or-try"><code>match</code> or <code>try</code></h4>
<p>For a <code>match</code> or a <code>try</code> align the clauses with the beginning of the
construct:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">match lam with
| Abs (x, body) -&gt; 1 + size_lambda body
| App (lam1, lam2) -&gt; size_lambda lam1 + size_lambda lam2
| Var v -&gt; 1

try f x with
| Not_found -&gt; ...
| Failure &quot;not yet implemented&quot; -&gt; ...
</code></pre>
<p>Put the keyword <code>with</code> at the end of the line. If the preceding
expression extends beyond one line, put <code>with</code> on a line by itself:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">try
  let y = f x in
  if ...
with
| Not_found -&gt; ...
| Failure &quot;not yet implemented&quot; -&gt; ...
</code></pre>
<blockquote>
<p><strong>Justification</strong>: The keyword <code>with</code>, on a line by itself shows that
the program enters the pattern matching part of the construct.</p>
</blockquote>
<h4 id="indenting-expressions-inside-clauses">Indenting expressions inside clauses</h4>
<p>If the expression on the right of the pattern matching arrow is too
large, cut the line after the arrow.</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">match lam with
| Abs (x, body) -&gt;
   1 + size_lambda body
| App (lam1, lam2) -&gt;
   size_lambda lam1 + size_lambda lam2
| Var v -&gt;
</code></pre>
<p>Some programmers generalize this rule to all clauses, as soon as one
expressions overflows. They will then indent the last clause like this:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">| Var v -&gt;
   1
</code></pre>
<p>Other programmers go one step further and apply this rule systematically
to any clause of any pattern matching.</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let rec fib = function
  | 0 -&gt;
     1
  | 1 -&gt;
     1
  | n -&gt;
     fib (n - 1) + fib ( n - 2)
</code></pre>
<blockquote>
<p><strong>Criticism</strong>: May be not compact enough; for simple pattern matchings
(or simple clauses in complex matchings), the rule does not add any
good to readability.</p>
<p><strong>Justification</strong>: I don't see any good reason for this rule, unless
you are paid proportionally to the number of lines of code: in this
case use this rule to get more money without adding more bugs in your
OCaml programs!</p>
</blockquote>
<h4 id="pattern-matching-in-anonymous-functions">Pattern matching in anonymous functions</h4>
<p>Similarly to <code>match</code> or <code>try</code>, pattern matching of anonymous functions,
starting by <code>function</code>, are indented with respect to the <code>function</code>
keyword:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">map
  (function
   | Abs (x, body) -&gt; 1 + size_lambda 0 body
   | App (lam1, lam2) -&gt; size_lambda (size_lambda 0 lam1) lam2
   | Var v -&gt; 1)
  lambda_list
</code></pre>
<h4 id="pattern-matching-in-named-functions">Pattern matching in named functions</h4>
<p>Pattern-matching in functions defined by <code>let</code> or <code>let rec</code> gives rise
to several reasonable styles which obey the preceding rules for pattern
matching (the one for anonymous functions being evidently excepted). See
above for recommended styles.</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let rec size_lambda accu = function
  | Abs (x, body) -&gt; size_lambda (succ accu) body
  | App (lam1, lam2) -&gt; size_lambda (size_lambda accu lam1) lam2
  | Var v -&gt; succ accu

let rec size_lambda accu = function
| Abs (x, body) -&gt; size_lambda (succ accu) body
| App (lam1, lam2) -&gt; size_lambda (size_lambda accu lam1) lam2
| Var v -&gt; succ accu
</code></pre>
<h3 id="bad-indentation-of-pattern-matching-constructs">Bad indentation of pattern-matching constructs</h3>
<h4 id="no-beastly-indentation-of-functions-and-case-analyses">No <em>beastly</em> indentation of functions and case analyses.</h4>
<p>This consists in indenting normally under the keyword <code>match</code> or
<code>function</code> which has previously been pushed to the right. Don't write:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let rec f x = function
              | [] -&gt; ...
              ...
</code></pre>
<p>but choose to indent the line under the <code>let</code> keyword:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let rec f x = function
  | [] -&gt; ...
  ...
</code></pre>
<blockquote>
<p><strong>Justification</strong>: You bump into the margin. The aesthetic value is
doubtful...</p>
</blockquote>
<h4 id="no-beastly-alignment-of-the---symbols-in-pattern-matching-clauses">No <em>beastly</em> alignment of the <code>-&gt;</code> symbols in pattern-matching clauses.</h4>
<p>Careful alignment of the arrows of a pattern matching is considered bad
practice, as exemplify in the following fragment:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let f = function
  | C1          -&gt; 1
  | Long_name _ -&gt; 2
  | _           -&gt; 3
</code></pre>
<blockquote>
<p><strong>Justification</strong>: This makes it harder to maintain the program (the
addition of a supplementary case can lead the indentations of all the
lines to change and so ... we often give up alignment at that time,
then it is better not to align the arrows in the first place!).</p>
</blockquote>
<h3 id="how-to-indent-function-calls">How to indent function calls</h3>
<h4 id="indentation-to-the-functions-name">Indentation to the function's name:</h4>
<p>No problem arises except for functions with many arguments—or very
complicated arguments as well—which can't fit on the same line. You
must indent the expressions with respect to the name of the function (1
or 2 spaces according to the chosen convention). Write small arguments
on the same line, and change lines at the start of an argument.</p>
<p>As far as possible, avoid arguments which consist of complex
expressions: in these cases define the “large” argument by a <code>let</code>
construction.</p>
<blockquote>
<p><strong>Justification</strong>: No indentation problem; if the name given to the
expressions is meaningful, the code is more readable as well.</p>
<p><strong>Additional justification</strong>: If the evaluation of the arguments
produces side effects, the <code>let</code> binding is in fact necessary to
explicitly define the order of evaluation.</p>
</blockquote>
<h4 id="naming-complex-arguments">Naming complex arguments:</h4>
<p>In place of</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let temp =
  f x y z
    “large
    expression”
    “other large
    expression” in
...
</code></pre>
<p>write</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let t =
  “large
  expression”
and u =
  “other large
  expression” in
let temp =
  f x y z t u in
...
</code></pre>
<h4 id="naming-anonymous-functions">Naming anonymous functions:</h4>
<p>In the case of an iterator whose argument is a complex function, define
the function by a <code>let</code> binding as well. In place of</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">List.map
  (function x -&gt;
    blabla
    blabla
    blabla)
  l
</code></pre>
<p>write</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let f x =
  blabla
  blabla
  blabla in
List.map f l
</code></pre>
<blockquote>
<p><strong>Justification</strong>: Much clearer, in particular if the name given to
the function is meaningful.</p>
</blockquote>
<h3 id="how-to-indent-operations">How to indent operations</h3>
<p>When an operator takes complex arguments, or in the presence of multiple
calls to the same operator, start the next the line with the operator,
and don't indent the rest of the operation. For example:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">x + y + z
+ t + u
</code></pre>
<blockquote>
<p><strong>Justification</strong>: When the operator starts the line, it is clear that
the operation continues on this line.</p>
</blockquote>
<p>In the case of a “large expression” in such an operation sequence,
to define the “large expression” with the help of a <code>let in</code>
construction is preferable to having to indent the line. In place of</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">x + y + z
+ “large
  expression”
</code></pre>
<p>write</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let t =
  “large
   expression” in
x + y + z + t
</code></pre>
<p>You most certainly must bind those expressions too large to be written
in one operation in the case of a combination of operators. In place of
the unreadable expression</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">(x + y + z * t)
/ (“large
    expression”)
</code></pre>
<p>write</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let u =
  “large
  expression” in
(x + y + z * t) / u
</code></pre>
<p>These guidelines extend to all operators. For example:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let u =
  “large
  expression” in
x :: y
:: z + 1 :: t :: u
</code></pre>
<h2 id="programming-guidelines">Programming guidelines</h2>
<h3 id="how-to-program">How to program</h3>
<blockquote>
<p><em>Always put your handiwork back on the bench,<br />
and then polish it and re-polish it.</em></p>
</blockquote>
<h4 id="write-simple-and-clear-programs">Write simple and clear programs</h4>
<p>When this is done, reread, simplify and clarify. At every stage of
creation, use your head!</p>
<h4 id="subdivide-your-programs-into-little-functions">Subdivide your programs into little functions</h4>
<p>Small functions are easier to master.</p>
<h4 id="factor-out-snippets-of-repeated-code-by-defining-them-in-separate-functions">Factor out snippets of repeated code by defining them in separate functions</h4>
<p>The sharing of code obtained in this way facilitates maintenance since
every correction or improvement automatically spreads throughout the
program. Besides, the simple act of isolating and naming a snippet of
code sometimes lets you identify an unsuspected feature.</p>
<h4 id="never-copy-paste-code-when-programming">Never copy-paste code when programming</h4>
<p>Pasting code almost surely indicates introducing a default of code
sharing and neglecting to identify and write a useful auxiliary
function; hence, it means that some code sharing is lost in the program.
Losing code sharing implies that you will have more problems afterwards
for maintenance: a bug in the pasted code has to be corrected at each
occurrence of the bug in each copy of the code!</p>
<p>Moreover, it is difficult to identify that the same set of 10 lines of
code is repeated 20 times throughout the program. By contrast, if an
auxiliary function defines those 10 lines, it is fairly easy to see and
find where those lines are used: that's simply where the function is
called. If code is copy-pasted all over the place then the program is
more difficult to understand.</p>
<p>In conclusion, copy-pasting code leads to programs that are more
difficult to read and more difficult to maintain: it has to be banished.</p>
<h3 id="how-to-comment-programs">How to comment programs</h3>
<h4 id="dont-hesitate-to-comment-when-theres-a-difficulty">Don't hesitate to comment when there's a difficulty</h4>
<h4 id="if-theres-no-difficulty-theres-no-point-in-commenting">If there's no difficulty, there's no point in commenting</h4>
<h4 id="avoid-comments-in-the-bodies-of-functions">Avoid comments in the bodies of functions</h4>
<h4 id="prefer-one-comment-at-the-beginning-of-the-function">Prefer one comment at the beginning of the function...</h4>
<p>...which explains how the algorithm that is used works. Once more, if
there is no difficulty, there is no point in commenting.</p>
<h4 id="avoid-nocuous-comments">Avoid nocuous comments</h4>
<p>A <em>nocuous</em> comment is a comment that does not add any value, i.e. no
non-trivial information. The nocuous comment is evidently not of
interest; it is a nuisance since it uselessly distracts the reader. It
is often used to fulfill some strange criteria related to the so-called
<em>software metrology</em>, for instance the ratio <em>number of comments</em> /
<em>number of lines of code</em> that perfectly measures a ratio that I don't
know the theoretical or practical interpretation. Absolutely avoid
nocuous comments.</p>
<p>An example of what to avoid: the following comment uses technical words
and is thus masquerade into a real comment when it has no additional
information of interest;</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">(*
  Function print_lambda:
  print a lambda-expression given as argument.

  Arguments: lam, any lambda-expression.
  Returns: nothing.

  Remark: print_lambda can only be used for its side effect.
*)
let rec print_lambda lam =
  match lam with
  | Var s -&gt; printf &quot;%s&quot; s
  | Abs l -&gt; printf &quot;\\\\ %a&quot; print_lambda l
  | App (l1, l2) -&gt;
     printf &quot;(%a %a)&quot; print_lambda l1 print_lambda l2
</code></pre>
<h4 id="usage-in-module-interface">Usage in module interface</h4>
<p>The function's usage must appear in the interface of the module which
exports it, not in the program which implements it. Choose comments as
in the OCaml system's interface modules, which will subsequently allow
the documentation of the interface module to be extracted automatically
if need be.</p>
<h4 id="use-assertions">Use assertions</h4>
<p>Use assertions as much as possible: they let you avoid verbose comments,
while allowing a useful verification upon execution.</p>
<p>For example, the conditions for the arguments of a function to be valid
are usefully verified by assertions.</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let f x =
  assert (x &gt;= 0);
  ...
</code></pre>
<p>Note as well that an assertion is often preferable to a comment because
it's more trustworthy: an assertion is forced to be pertinent because it
is verified upon each execution, while a comment can quickly become
obsolete and then becomes actually detrimental to the comprehension of
the program.</p>
<h4 id="comments-line-by-line-in-imperative-code">Comments line by line in imperative code</h4>
<p>When writing difficult code, and particularly in case of highly
imperative code with a lot of memory modifications (physical mutations
in data structures), it is sometime mandatory to comment inside the body
of functions to explain the implementation of the algorithm encoded
here, or to follow successive modifications of invariants that the
function must maintain. Once more, if there is some difficulty
commenting is mandatory, for each program line if necessary.</p>
<h3 id="how-to-choose-identifiers">How to choose identifiers</h3>
<p>It's hard to choose identifiers whose name evokes the meaning of the
corresponding portion of the program. This is why you must devote
particular care to this, emphasizing clarity and regularity of
nomenclature.</p>
<h4 id="dont-use-abbreviations-for-global-names">Don't use abbreviations for global names</h4>
<p>Global identifiers (including especially the names of functions) can be
long, because it's important to understand what purpose they serve far
from their definition.</p>
<h4 id="separate-words-by-underscores-intofstring-not-intofstring">Separate words by underscores: (<code>int_of_string</code>, not <code>intOfString</code>)</h4>
<p>Case modifications are meaningful in OCaml: in effect capitalized words
are reserved for constructors and module names in OCaml; in contrast
regular variables (functions or identifiers) must start by a lowercase
letter. Those rules prevent proper usage of case modification for words
separation in identifiers: the first word starts the identifier, hence
it must be lower case and it is forbidden to choose <code>IntOfString</code> as the
name of a function.</p>
<h4 id="always-give-the-same-name-to-function-arguments-which-have-the-same-meaning">Always give the same name to function arguments which have the same meaning</h4>
<p>If necessary, make this nomenclature explicit in a comment at the top of
the file); if there are several arguments with the same meaning then
attach numeral suffixes to them.</p>
<h4 id="local-identifiers-can-be-brief-and-should-be-reused-from-one-function-to-another">Local identifiers can be brief, and should be reused from one function to another</h4>
<p>This augments regularity of style. Avoid using identifiers whose
appearance can lead to confusion such as <code>l</code> or <code>O</code>, easy to confuse
with <code>1</code> and <code>0</code>.</p>
<p>Example:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let add_expression expr1 expr2 = ...
let print_expression expr = ...
</code></pre>
<p>An exception to the recommendation not to use capitalization to separate
words within identifiers is tolerated in the case of interfacing with
existing libraries which use this naming convention: this lets OCaml
users of the library to orient themselves in the original library
documentation more easily.</p>
<h3 id="when-to-use-parentheses-within-an-expression">When to use parentheses within an expression</h3>
<p>Parentheses are meaningful: they indicate the necessity of using an
unusual precedence. So they should be used wisely and not sprinkled
randomly throughout programs. To this end, you should know the usual
precedences, that is, the combinations of operations which do not
require parentheses. Quite fortunately this is not complicated if you
know a little mathematics or strive to follow the following rules:</p>
<h4 id="arithmetic-operators-the-same-rules-as-in-mathematics">Arithmetic operators: the same rules as in mathematics</h4>
<p>For example: <code>1 + 2 * x</code> means <code>1 + (2 * x)</code>.</p>
<h4 id="function-application-the-same-rules-as-those-in-mathematics-for-usage-of-trigonometric-functions">Function application: the same rules as those in mathematics for usage of <em>trigonometric functions</em></h4>
<p>In mathematics you write <code>sin x</code> to mean <code>sin (x)</code>. In the same way
<code>sin x + cos x</code> means <code>(sin x) + (cos x)</code> not <code>sin (x + (cos x))</code>. Use
the same conventions in OCaml: write <code>f x + g x</code> to mean
<code>(f x) + (g x)</code>.<br />
This convention generalizes <strong>to all (infix) operators</strong>: <code>f x :: g x</code>
means <code>(f x) :: (g x)</code>, <code>f x @ g x</code> means <code>(f x) @ (g x)</code>, and
<code>failwith s ^ s'</code> means <code>(failwith s) ^ s'</code>, <em>not</em> <code>failwith (s ^ s')</code>.</p>
<h4 id="comparisons-and-boolean-operators">Comparisons and boolean operators</h4>
<p>Comparisons are infix operators, so the preceding rules apply. This is
why <code>f x &lt; g x</code> means <code>(f x) &lt; (g x)</code>. For type reasons (no other
sensible interpretation) the expression <code>f x &lt; x + 2</code> means
<code>(f x) &lt; (x + 2)</code>. In the same way <code>f x &lt; x + 2 &amp;&amp; x &gt; 3</code> means
<code>((f x) &lt; (x + 2)) &amp;&amp; (x &gt; 3)</code>.</p>
<h4 id="the-relative-precedences-of-the-boolean-operators-are-those-of-mathematics">The relative precedences of the boolean operators are those of mathematics</h4>
<p>Although mathematicians have a tendency to overuse parens in this case,
the boolean “or” operator is analogous to addition and the “and”
to multiplication. So, just as <code>1 + 2 * x</code> means <code>1 + (2 * x)</code>,
<code>true || false &amp;&amp; x</code> means <code>true || (false &amp;&amp; x)</code>.</p>
<h3 id="how-to-delimit-constructs-in-programs">How to delimit constructs in programs</h3>
<p>When it is necessary to delimit syntactic constructs in programs, use as
delimiters the keywords <code>begin</code> and <code>end</code> rather than parentheses.
However using parentheses is acceptable if you do it in a consistent,
that is, systematic, way.</p>
<p>This explicit delimiting of constructs essentially concerns
pattern-matching constructs or sequences embedded within
<code>if then     else</code> constructs.</p>
<h4 id="match-construct-in-a-match-construct"><code>match</code> construct in a <code>match</code> construct</h4>
<p>When a <code>match ... with</code> or <code>try ... with</code> construct appears in a
pattern-matching clause, it is absolutely necessary to delimit this
embedded construct (otherwise subsequent clauses of the enclosing
pattern-matching construct will automatically be associated with the
enclosed pattern-matching construct). For example:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">match x with
| 1 -&gt;
  begin match y with
  | ...
  end
| 2 -&gt;
...
</code></pre>
<h4 id="sequences-inside-branches-of-if">Sequences inside branches of <code>if</code></h4>
<p>In the same way, a sequence which appears in the <code>then</code> or <code>else</code> part
of a conditional must be delimited:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">if cond then begin
  e1;
  e2
end else begin
  e3;
  e4
end
</code></pre>
<h3 id="how-to-use-modules">How to use modules</h3>
<h4 id="subdividing-into-modules">Subdividing into modules</h4>
<p>You must subdivide your programs into coherent modules.</p>
<p>For each module, you must explicitly write an interface.</p>
<p>For each interface, you must document the things defined by the module:
functions, types, exceptions, etc.</p>
<h4 id="opening-modules">Opening modules</h4>
<p>Avoid <code>open</code> directives, using instead the qualified identifier
notation. Thus you will prefer short but meaningful module names.</p>
<blockquote>
<p><strong>Justification</strong>: The use of unqualified identifiers is ambiguous and
gives rise to difficult-to-detect semantic errors.</p>
</blockquote>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let lim = String.length name - 1 in
...
let lim = Array.length v - 1 in
...
... List.map succ ...
... Array.map succ ...
</code></pre>
<h4 id="when-to-use-open-modules-rather-than-leaving-them-closed">When to use open modules rather than leaving them closed</h4>
<p>You can consider it normal to open a module which modifies the
environment, and brings other versions of an important set of functions.
For example, the <code>Format</code> module provides automatically indented
printing. This module redefines the usual printing functions
<code>print_string</code>, <code>print_int</code>, <code>print_float</code>, etc. So when you use
<code>Format</code>, open it systematically at the top of the file.<br />
If you don't open <code>Format</code> you could miss the qualification of a
printing function, and this could be perfectly silent, since many of
<code>Format</code>'s functions have a counterpart in the default environment
(<code>Pervasives</code>). Mixing printing functions from <code>Format</code> and <code>Pervasives</code>
leads to subtle bugs in the display, that are difficult to trace. For
instance:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let f () =
  Format.print_string &quot;Hello World!&quot;; print_newline ()
</code></pre>
<p>is bogus since it does not call <code>Format.print_newline</code> to flush the
pretty-printer queue and output <code>&quot;Hello World!&quot;</code>. Instead
<code>&quot;Hello World!&quot;</code> is stuck into the pretty-printer queue, while
<code>Pervasives.print_newline</code> outputs a carriage return on the standard
output ... If <code>Format</code> is printing on a file and standard output is the
terminal, the user will have a bad time finding that a carriage return
is missing in the file (and the display of material on the file is
strange, since boxes that should be closed by <code>Format.print_newline</code> are
still open), while a spurious carriage return appeared on the screen!</p>
<p>For the same reason, open large libraries such as the one with
arbitrary-precision integers so as not to burden the program which uses
them.</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">open Num

let rec fib n =
  if n &lt;= 2 then Int 1 else fib (n - 1) +/ fib (n - 2)
</code></pre>
<blockquote>
<p><strong>Justification</strong>: The program would be less readable if you had to
qualify all the identifiers.</p>
</blockquote>
<p>In a program where type definitions are shared, it is good to gather
these definitions into one or more module(s) without implementations
(containing only types). Then it's acceptable to systematically open the
module which exports the shared type definitions.</p>
<h3 id="pattern-matching">Pattern-matching</h3>
<h4 id="never-be-afraid-of-over-using-pattern-matching">Never be afraid of over-using pattern-matching!</h4>
<h4 id="on-the-other-hand-be-careful-to-avoid-non-exhaustive-pattern-matching-constructs">On the other hand, be careful to avoid non-exhaustive pattern-matching constructs</h4>
<p>Complete them with care, without using a “catch-all” clause such as
<code>| _ -&gt; ...</code> or <code>| x -&gt; ...</code> when it's possible to do without it (for
example when matching a concrete type defined within the program). See
also the next section: compiler warnings.</p>
<h3 id="compiler-warnings">Compiler warnings</h3>
<p>Compiler warnings are meant to prevent potential errors; this is why you
absolutely must heed them and correct your programs if compiling them
produces such warnings. Besides, programs whose compilation produces
warnings have an odor of amateurism which certainly doesn't suit your
own work!</p>
<h4 id="pattern-matching-warnings">Pattern-matching warnings</h4>
<p>Warnings about pattern-matching must be treated with the upmost care:</p>
<ul>
<li>
<p>Those concerning useless clauses should of course be eliminated.</p>
</li>
<li>
<p>For non-exhaustive pattern-matching you must complete the
corresponding pattern-matching construct, without adding a default
case “catch-all”, such as <code>| _ -&gt; ... </code>, but with an explicit
list of the constructors not examined by the rest of the construct,
for example <code>| Cn _ | Cn1 _ -&gt; ... </code>.</p>
</li>
</ul>
<blockquote>
<p><strong>Justification</strong>: It's not really any more complicated to write
it this way, and this allows the program to evolve more safely. In
effect the addition of a new constructor to the datatype being
matched will produce an alert anew, which will allow the
programmer to add a clause corresponding to the new constructor if
that is warranted. On the contrary, the “catch-all” clause
will make the function compile silently and it might be thought
that the function is correct as the new constructor will be
handled by the default case.</p>
</blockquote>
<ul>
<li>Non-exhaustive pattern-matches induced by clauses with guards must
also be corrected. A typical case consists in suppressing a
redundant guard.
</li>
</ul>
<h4 id="de-structuring-let-bindings">De-structuring <code>let</code> bindings</h4>
<p>[Translator's note: a “de-structuring <code>let</code> binding” is one which
binds several names to several expressions simultaneously. You pack all
the names you want bound into a collection such as a tuple or a list,
and you correspondingly pack all the expressions into a collective
expression. When the <code>let</code> binding is evaluated, it unpacks the
collections on both sides and binds each expression to its corresponding
name. For example, <code>let x, y = 1, 2</code> is a de-structuring <code>let</code> binding
which performs both the bindings <code>let x = 1</code> and <code>let y = 2</code>
simultaneously.]<br />
The <code>let</code> binding is not limited to simple identifier definitions: you
can use it with more complex or simpler patterns. For instance</p>
<ul>
<li><code>let</code> with complex patterns:<br />
<code>let [x; y] as l = ...</code><br />
simultaneously defines a list <code>l</code> and its two elements <code>x</code> and <code>y</code>.
</li>
<li><code>let</code> with simple pattern:<br />
<code>let _ = ...</code> does not define anything, it just evaluate the
expression on the right hand side of the <code>=</code> symbol.
</li>
</ul>
<h4 id="the-de-structuring-let-must-be-exhaustive">The de-structuring <code>let</code> must be exhaustive</h4>
<p>Only use de-structuring <code>let</code> bindings in the case where the
pattern-matching is exhaustive (the pattern can never fail to match).
Typically, you will thus be limited to definitions of product types
(tuples or records) or definitions of variant type with a single case.
In any other case, you should use an explicit <code>match   ... with</code>
construct.</p>
<ul>
<li><code>let ... in</code>: de-structuring <code>let</code> that give a warning must be
replaced by an explicit pattern matching. For instance, instead of
<code>let [x; y] as l = List.map succ     (l1 @ l2) in expression</code> write:
</li>
</ul>
<!-- $MDX skip -->
<pre><code class="language-ocaml">match List.map succ (l1 @ l2) with
| [x; y] as l -&gt; expression
| _ -&gt; assert false
</code></pre>
<ul>
<li>Global definition with de-structuring lets should be rewritten with
explicit pattern matching and tuples:
</li>
</ul>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let x, y, l =
  match List.map succ (l1 @ l2) with
  | [x; y] as l -&gt; x, y, l
  | _ -&gt; assert false
</code></pre>
<blockquote>
<p><strong>Justification</strong>: There is no way to make the pattern-matching
exhaustive if you use general de-structuring <code>let</code> bindings.</p>
</blockquote>
<h4 id="sequence-warnings-and-let---">Sequence warnings and <code>let _ = ...</code></h4>
<p>When the compiler emits a warning about the type of an expression in a
sequence, you have to explicitly indicate that you want to ignore the
result of this expression. To this end:</p>
<ul>
<li>use a vacuous binding and suppress the sequence warning of
</li>
</ul>
<!-- $MDX skip -->
<pre><code class="language-ocaml">List.map f l;
print_newline ()
</code></pre>
<p>write</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let _ = List.map f l in
print_newline ()
</code></pre>
<ul>
<li>you can also use the predefined function <code>ignore : 'a     -&gt; unit</code>
that ignores its argument to return <code>unit</code>.
</li>
</ul>
<!-- $MDX skip -->
<pre><code class="language-ocaml">ignore (List.map f l);
print_newline ()
</code></pre>
<ul>
<li>In any case, the best way to suppress this warning is to understand
why it is emitted by the compiler: the compiler warns you because
your code computes a result that is useless since this result is
just deleted after computation. Hence, if useful at all, this
computation is performed only for its side-effects; hence it should
return unit.<br />
Most of the time, the warning indicates the use of the wrong
function, a probable confusion between the side-effect only version
of a function (which is a procedure whose result is irrelevant) with
its functional counterpart (whose result is meaningful).<br />
In the example mentioned above, the first situation prevailed, and
the programmer should have called <code>iter</code> instead of <code>map</code>, and
simply write
</li>
</ul>
<!-- $MDX skip -->
<pre><code class="language-ocaml">List.iter f l;
print_newline ()
</code></pre>
<p>In actual programs, the suitable (side-effect only) function may not
exist and has to be written: very often, a careful separation of the
procedural part from the functional part of the function at hand
elegantly solves the problem, and the resulting program just looks
better afterwards! For instance, you would turn the problematic
definition:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let add x y =
  if x &gt; 1 then print_int x;
  print_newline ();
  x + y;;
</code></pre>
<p>into the clearer separate definitions and change old calls to <code>add</code>
accordingly.</p>
<p>In any case, use the <code>let _ = ...</code> construction exactly in those cases
where you want to ignore a result. Don't systematically replace
sequences with this construction.</p>
<blockquote>
<p><strong>Justification</strong>: Sequences are much clearer! Compare <code>e1; e2; e3</code> to</p>
<pre><code class="language-ocaml">let _ = e1 in
let _ = e2 in
e3
</code></pre>
</blockquote>
<h3 id="the-hd-and-tl-functions">The <code>hd</code> and <code>tl</code> functions</h3>
<p>Don't use the <code>hd</code> and <code>tl</code> functions, but pattern-match the list
argument explicitly.</p>
<blockquote>
<p><strong>Justification</strong>: This is just as brief as and much clearer than
using <code>hd</code> and <code>tl</code> which must of necessity be protected by
<code>try... with...</code> to catch the exception which might be raised by these
functions.</p>
</blockquote>
<h3 id="loops">Loops</h3>
<h4 id="for-loops"><code>for</code> loops</h4>
<p>To simply traverse an array or a string, use a <code>for</code> loop.</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">for i = 0 to Array.length v - 1 do
  ...
done
</code></pre>
<p>If the loop is complex or returns a result, use a recursive function.</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let find_index e v =
  let rec loop i =
    if i &gt;= Array.length v then raise Not_found else
    if v.(i) = e then i else loop (i + 1) in
  loop 0;;
</code></pre>
<blockquote>
<p><strong>Justification</strong>: The recursive function lets you code any loop
whatsoever simply, even a complex one, for example with multiple exit
points or with strange index steps (steps depending on a data value
for example).</p>
<p>Besides, the recursive loop avoids the use of mutables whose value can
be modified in any part of the body of the loop whatsoever (or even
outside): on the contrary the recursive loop explicitly takes as
arguments the values susceptible to change during the recursive calls.</p>
</blockquote>
<h4 id="while-loops"><code>while</code> loops</h4>
<blockquote>
<p><strong>While loops law</strong>: Beware: usually a while loop is wrong, unless its
loop invariant has been explicitly written.</p>
</blockquote>
<p>The main use of the <code>while</code> loop is the infinite loop
<code>while true do     ...</code>. You get out of it through an exception,
generally on termination of the program.</p>
<p>Other <code>while</code> loops are hard to use, unless they come from canned
programs from algorithms courses where they were proved.</p>
<blockquote>
<p><strong>Justification</strong>: <code>while</code> loops require one or more mutables in order
that the loop condition change value and the loop finally terminate.
To prove their correctness, you must therefore discover the loop
invariants, an interesting but difficult sport.</p>
</blockquote>
<h3 id="exceptions">Exceptions</h3>
<p>Don't be afraid to define your own exceptions in your programs, but on
the other hand use as much as possible the exceptions predefined by the
system. For example, every search function which fails should raise the
predefined exception <code>Not_found</code>. Be careful to handle the exceptions
which may be raised by a function call with the help of a
<code>try ... with</code>.</p>
<p>Handling all exceptions by <code>try     ... with _ -&gt;</code> is usually reserved
for the main function of the program. If you need to catch all
exceptions to maintain an invariant of an algorithm, be careful to name
the exception and re-raise it, after having reset the invariant.
Typically:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let ic = open_in ...
and oc = open_out ... in
try
  treatment ic oc;
  close_in ic; close_out oc
with x -&gt; close_in ic; close_out oc; raise x
</code></pre>
<blockquote>
<p><strong>Justification</strong>: <code>try ... with _     -&gt;</code> silently catches all
exceptions, even those which have nothing to do with the computation
at hand (for example an interruption will be captured and the
computation will continue anyway!).</p>
</blockquote>
<h3 id="data-structures">Data structures</h3>
<p>One of the great strengths of OCaml is the power of the data structures
which can be defined and the simplicity of manipulating them. So you
must take advantage of this to the fullest extent; don't hesitate to
define your own data structures. In particular, don't systematically
represent enumerations by whole numbers, nor enumerations with two cases
by booleans. Examples:</p>
<pre><code class="language-ocaml">type figure =
   | Triangle | Square | Circle | Parallelogram
type convexity =
   | Convex | Concave | Other
type type_of_definition =
   | Recursive | Non_recursive
</code></pre>
<blockquote>
<p><strong>Justification</strong>: A boolean value often prevents intuitive
understanding of the corresponding code. For example, if
<code>type_of_definition</code> is coded by a boolean, what does <code>true</code> signify?
A “normal” definition (that is, non-recursive) or a recursive
definition?</p>
<p>In the case of an enumerated type encode by an integer, it is very
difficult to limit the range of acceptable integers: one must define
construction functions that will ensure the mandatory invariants of
the program (and verify afterwards that no values has been built
directly), or add assertions in the program and guards in pattern
matchings. This is not good practice, when the definition of a sum
type elegantly solves this problem, with the additional benefit of
firing the full power of pattern matching and compiler's verifications
of exhaustiveness.</p>
<p><strong>Criticism</strong>: For binary enumerations, one can systematically define
predicates whose names carry the semantics of the boolean that
implements the type. For instance, we can adopt the convention that a
predicate ends by the letter <code>p</code>. Then, in place of defining a new sum
type for <code>type_of_definition</code>, we will use a predicate function
<code>recursivep</code> that returns true if the definition is recursive.</p>
<p><strong>Answer</strong>: This method is specific to binary enumeration and cannot
be easily extended; moreover it is not well suited to pattern
matching. For instance, for definitions encoded by
<code>| Let of bool * string * expression</code> a typical pattern matching would
look like:</p>
<pre><code class="language-ocaml">| Let (_, v, e) as def -&gt;
   if recursivep def then code_for_recursive_case
   else code_for_non_recursive_case
</code></pre>
<p>or, if <code>recursivep</code> can be applied to booleans:</p>
<pre><code class="language-ocaml">| Let (b, v, e) -&gt;
   if recursivep b then code_for_recursive_case
   else code_for_non_recursive_case
</code></pre>
<p>contrast with an explicit encoding:</p>
<pre><code class="language-ocaml">| Let (Recursive, v, e) -&gt; code_for_recursive_case
| Let (Non_recursive, v, e) -&gt; code_for_non_recursive_case
</code></pre>
<p>The difference between the two programs is subtle and you may think
that this is just a matter of taste; however the explicit encoding is
definitively more robust to modifications and fits better with the
language.</p>
</blockquote>
<p><em>A contrario</em>, it is not necessary to systematically define new types
for boolean flags, when the interpretation of constructors <code>true</code> and
<code>false</code> is clear. The usefulness of the definition of the following
types is then questionable:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">type switch = On | Off
type bit = One | Zero
</code></pre>
<p>The same objection is admissible for enumerated types represented as
integers, when those integers have an evident interpretation with
respect to the data to be represented.</p>
<h3 id="when-to-use-mutables">When to use mutables</h3>
<p>Mutable values are useful and sometimes indispensable to simple and
clear programming. Nevertheless, you must use them with discernment:
OCaml's normal data structures are immutable. They are to be preferred
for the clarity and safety of programming which they allow.</p>
<h3 id="iterators">Iterators</h3>
<p>OCaml's iterators are a powerful and useful feature. However you should
not overuse them, nor <em>a contrario</em> neglect them: they are provided to
you by libraries and have every chance of being correct and
well-thought-out by the author of the library. So it's useless to
reinvent them.</p>
<p>So write</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let square_elements elements = List.map square elements
</code></pre>
<p>rather than:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let rec square_elements = function
  | [] -&gt; []
  | elem :: elements -&gt; square elem :: square_elements elements
</code></pre>
<p>On the other hand avoid writing:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let iterator f x l =
  List.fold_right (List.fold_left f) [List.map x l] l
</code></pre>
<p>even though you get:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">  let iterator f x l =
    List.fold_right (List.fold_left f) [List.map x l] l;;
  iterator (fun l x -&gt; x :: l) (fun l -&gt; List.rev l) [[1; 2; 3]]
</code></pre>
<p>In case of express need, you must be careful to add an explanatory
comment: in my opinion it's absolutely necessary!</p>
<h3 id="how-to-optimize-programs">How to optimize programs</h3>
<blockquote>
<p><strong>Pseudo law of optimization</strong>: No optimization <em>a priori</em>.<br />
No optimization <em>a posteriori</em> either.</p>
</blockquote>
<p>Above all program simply and clearly. Don't start optimizing until the
program bottleneck has been identified (in general a few routines). Then
optimization consists above all of changing <em>the complexity</em> of the
algorithm used. This often happens through redefining the data
structures being manipulated and completely rewriting the part of the
program which poses a problem.</p>
<blockquote>
<p><strong>Justification</strong>: Clarity and correctness of programs take
precedence. Besides, in a substantial program, it is practically
impossible to identify <em>a priori</em> the parts of the program whose
efficiency is of prime importance.</p>
</blockquote>
<h3 id="how-to-choose-between-classes-and-modules">How to choose between classes and modules</h3>
<p>You should use OCaml classes when you need inheritance, that is,
incremental refinement of data and their functionality.</p>
<p>You should use conventional data structures (in particular, variant
types) when you need pattern-matching.</p>
<p>You should use modules when the data structures are fixed and their
functionality is equally fixed or it's enough to add new functions in
the programs which use them.</p>
<h3 id="clarity-of-ocaml-code">Clarity of OCaml code</h3>
<p>The OCaml language includes powerful constructs which allow simple and
clear programming. The main problem to obtain crystal clear programs it
to use them appropriately.</p>
<p>The language features numerous programming styles (or programming
paradigms): imperative programming (based on the notion of state and
assignment), functional programming (based on the notion of function,
function results, and calculus), object oriented programming (based of
the notion of objects encapsulating a state and some procedures or
methods that can modify the state). The first work of the programmer is
to choose the programming paradigm that fits the best the problem at
hand. When using one of those programming paradigms, the difficulty is
to use the language construct that expresses in the most natural and
easiest way the computation that implements the algorithm.</p>
<h4 id="style-dangers">Style dangers</h4>
<p>Concerning programming styles, one can usually observe the two
symmetrical problematic behaviors: on the one hand, the “all
imperative” way (<em>systematic</em> usage of loops and assignment), and on
the other hand the “purely functional” way (<em>never</em> use loops nor
assignments); the “100% object” style will certainly appear in the
next future, but (fortunately) it is too new to be discussed here.</p>
<ul>
<li><strong>The “Too much imperative” danger</strong>:
<ul>
<li>It is a bad idea to use imperative style to code a function that
is <em>naturally</em> recursive. For instance, to compute the length of
a list, you should not write:
</li>
</ul>
</li>
</ul>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let list_length l =
  let l = ref l in
  let res = ref 0 in
  while !l &lt;&gt; [] do
    incr res; l := List.tl !l
  done;
  !res;;
</code></pre>
<p>in place of the following recursive function, so simple and
clear:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let rec list_length = function
  | [] -&gt; 0
  | _ :: l -&gt; 1 + list_length l
</code></pre>
<p>(For those that would contest the equivalence of those two
versions, see the <a href="#Imperativeandfunctionalversionsoflistlength">note below</a>).</p>
<ul>
<li>
<p>Another common “over imperative error” in the imperative world is
not to systematically choose the simple <code>for</code> loop to iter on the
element of a vector, but instead to use a complex <code>while</code> loop, with
one or two references (too many useless assignments, too many
opportunity for errors).</p>
</li>
<li>
<p>This category of programmer feels that the <code>mutable</code> keyword in
the record type definitions should be implicit.</p>
</li>
<li>
<p><strong>The “Too much functional” danger</strong>:</p>
<ul>
<li>The programmer that adheres to this dogma avoids
using arrays and assignment. In the most severe case, one
observes a complete denial of writing any imperative
construction, even in case it is evidently the most elegant way
to solve the problem.
</li>
<li>Characteristic symptoms: systematic rewriting of <code>for</code> loops
with recursive functions, usage of lists in contexts where
imperative data structures seem to be mandatory to anyone,
passing numerous global parameters of the problem to every
functions, even if a global reference would be perfect to avoid
these spurious parameters that are mainly invariants that must
be passed all over the place.
</li>
<li>This programmer feels that the <code>mutable</code> keyword in the record
type definitions should be suppressed from the language.
</li>
</ul>
</li>
</ul>
<h4 id="ocaml-code-generally-considered-unreadable">OCaml code generally considered unreadable</h4>
<p>The OCaml language includes powerful constructs which allow simple and
clear programming. However the power of these constructs also lets you
write uselessly complicated code, to the point where you get a perfectly
unreadable program.</p>
<p>Here are a number of known ways:</p>
<ul>
<li>Use useless (hence novice for readability) <code>if then else</code>, as in
</li>
</ul>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let flush_ps () =
  if not !psused then psused := true
</code></pre>
<p>or (more subtle)</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let sync b =
  if !last_is_dvi &lt;&gt; b then last_is_dvi := b
</code></pre>
<ul>
<li>Code one construct with another. For example code a <code>let ... in</code> by
the application of an anonymous function to an argument. You would
write<br />
</li>
</ul>
<!-- $MDX skip -->
<pre><code class="language-ocaml">(fun x y -&gt; x + y)
   e1 e2
</code></pre>
<p>instead of simply writing</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let x = e1
and y = e2 in
x + y
</code></pre>
<ul>
<li>
<p>Systematically code sequences with <code>let in</code> bindings.</p>
</li>
<li>
<p>Mix computations and side effects, particularly in function calls.
Recall that the order of evaluation of arguments in a function call
is unspecified, which implies that you must not mix side effects and
computations in function calls. However, when there is only one
argument you might take advantage of this to perform a side effect
within the argument, which is extremely troublesome for the reader
albeit without danger to the program semantics. To be absolutely
forbidden.</p>
</li>
<li>
<p>Misuse of iterators and higher-order functions (i.e. over- or
under-use). For example it's better to use <code>List.map</code> or
<code>List.iter</code> than to write their equivalents in-line using specific
recursive functions of your own. Even worse, you don't use
<code>List.map</code> or <code>List.iter</code> but write their equivalents in terms of
<code>List.fold_right</code> and <code>List.fold_left</code>.</p>
</li>
<li>
<p>Another efficient way to write unreadable code is to mix all or some
of these methods. For example:</p>
</li>
</ul>
<!-- $MDX skip -->
<pre><code class="language-ocaml">(fun u -&gt; print_string &quot;world&quot;; print_string u)
  (let temp = print_string &quot;Hello&quot;; &quot;!&quot; in
   ((fun x -&gt; print_string x; flush stdout) &quot; &quot;;
    temp));;
</code></pre>
<p>If you naturally write the program <code>print_string &quot;Hello world!&quot;</code> in this
way, you can without a doubt submit your work to the <a href="mailto:Pierre.Weis@inria.fr">Obfuscated OCaml
Contest</a>.</p>
<h2 id="managing-program-development">Managing program development</h2>
<p>We give here tips from veteran OCaml programmers, which have served in
developing the compilers which are good examples of large complex
programs developed by small teams.</p>
<h3 id="how-to-edit-programs">How to edit programs</h3>
<p>Many developers nurture a kind of veneration towards the Emacs editor
(gnu-emacs in general) which they use to write their programs. The
editor interfaces well with the language since it is capable of syntax
coloring OCaml source code (rendering different categories of words in
color, coloring keywords for example).</p>
<p>The following two commands are considered indispensable:</p>
<ul>
<li><code>CTRL-C-CTRL-C</code> or <code>Meta-X compile</code>: launches re-compilation from
within the editor (using the <code>make</code> command).
</li>
<li><code>CTRL-X-`</code>: puts the cursor in the file and at the exact place
where the OCaml compiler has signaled an error.
</li>
</ul>
<p>Developers describe thus how to use these features: <code>CTRL-C-CTRL-C</code>
combination recompiles the whole application; in case of errors, a
succession of <code>CTRL-X-`</code> commands permits correction of all the
errors signaled; the cycle begins again with a new re-compilation
launched by <code>CTRL-C-CTRL-C</code>.</p>
<h4 id="other-emacs-tricks">Other emacs tricks</h4>
<p>The <code>ESC-/</code> command (dynamic-abbrev-expand) automatically completes the
word in front of the cursor with one of the words present in one of the
files being edited. Thus this lets you always choose meaningful
identifiers without the tedium of having to type extended names in your
programs: the <code>ESC-/</code> easily completes the identifier after typing the
first letters. In case it brings up the wrong completion, each
subsequent <code>ESC-/</code> proposes an alternate completion.</p>
<p>Under Unix, the <code>CTRL-C-CTRL-C</code> or <code>Meta-X     compile</code> combination,
followed by <code>CTRL-X-`</code> is also used to find all occurrences of a
certain string in a OCaml program. Instead of launching <code>make</code> to
recompile, you launch the <code>grep</code> command; then all the “error
messages” from <code>grep</code> are compatible with the <code>CTRL-X-`</code> usage
which automatically takes you to the file and the place where the string
is found.</p>
<h3 id="how-to-edit-with-the-interactive-system">How to edit with the interactive system</h3>
<p>Under Unix: use the line editor <code>ledit</code> which offers great editing
capabilities “à la emacs” (including <code>ESC-/</code>!), as well as a history
mechanism which lets you retrieve previously typed commands and even
retrieve commands from one session in another. <code>ledit</code> is written in
OCaml and can be freely down-loaded
<a href="ftp://ftp.inria.fr/INRIA/Projects/cristal/caml-light/bazar-ocaml/ledit.tar.gz">here</a>.</p>
<h3 id="how-to-compile">How to compile</h3>
<p>The <code>make</code> utility is indispensable for managing the compilation and
re-compilation of programs. Sample <code>make</code> files can be found on <a href="https://caml.inria.fr//cgi-bin/hump.en.cgi">The
Hump</a>. You can also consult
the <code>Makefiles</code> for the OCaml compilers.</p>
<h3 id="how-to-develop-as-a-team-version-control">How to develop as a team: version control</h3>
<p>Users of the <a href="https://git-scm.com/">Git</a> software version control system
never run out of good things to say about the productivity gains it
brings. This system supports managing development by a team of
programmers while imposing consistency among them, and also maintains a
log of changes made to the software.<br />
Git also supports simultaneous development by several teams, possibly
dispersed among several sites linked on the Net.</p>
<p>An anonymous Git read-only mirror <a href="https://github.com/ocaml/ocaml">contains the working sources of the
OCaml compilers</a>, and the sources of
other software related to OCaml.</p>
<h2 id="notes">Notes</h2>
<h3 id="imperative-and-functional-versions-of-listlength">Imperative and functional versions of <code>list_length</code></h3>
<p>The two versions of <code>list_length</code> are not completely equivalent in term
of complexity, since the imperative version uses a constant amount of
stack room to execute, whereas the functional version needs to store
return addresses of suspended recursive calls (whose maximum number is
equal to the length of the list argument). If you want to retrieve a
constant space requirement to run the functional program you just have
to write a function that is recursive in its tail (or <em>tail-rec</em>), that
is a function that just ends by a recursive call (which is not the case
here since a call to <code>+</code> has to be perform after the recursive call has
returned). Just use an accumulator for intermediate results, as in:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let list_length l =
  let rec loop accu = function
    | [] -&gt; accu
    | _ :: l -&gt; loop (accu + 1) l in
  loop 0 l
</code></pre>
<p>This way, you get a program that has the same computational properties
as the imperative program with the additional clarity and natural
look of an algorithm that performs pattern matching and recursive
calls to handle an argument that belongs to a recursive sum data type.</p>
|js}
  };
 
  { title = {js|Compiling OCaml Projects|js}
  ; slug = {js|compiling-ocaml-projects|js}
  ; description = {js|An introduction to the OCaml compiler tools for building OCaml projects as well as the most common build tools
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["getting-started"]
  ; users = [`Intermediate]
  ; body_md = {js|
This tutorial explains how to compile your OCaml programs into executable form.
It addresses, in turn:

1. The compilation commands `ocamlc` and `ocamlopt` provided with OCaml. It is
   useful to learn these commands to understand OCaml's compilation model.

1. The `ocamlfind` front-end to the compiler, which saves you from worrying
   about where libraries have been installed on your particular system. 

1. Automatic build systems for OCaml, such as `dune`, which release us from
   details of compiler command invocation, so we never touch `ocamlc`,
   `ocamlopt`, or even `ocamlfind`.

In our [up and running tutorial](up_and_running.html) we jumped straight to using
the automated build system `dune`. Now we shall look under the hood.

## Compilation basics

In this section, we will first see how to compile a simple program using
only `ocamlc` or `ocamlopt`. Then we will see how to use libraries and how
to take advantage of the
[findlib](https://projects.camlcity.org/projects/findlib.html)
system, which provides the `ocamlfind` command.

### The ocamlc and ocamlopt compilers

OCaml comes with two compilers: `ocamlc` is the bytecode compiler, and
`ocamlopt` is the native code compiler. If you don't know which one to use, use
`ocamlopt` since it provides executables that are faster than bytecode.

Let's assume that our program `program` has two source files,
`module1.ml` and `module2.ml`. We will compile them to native code,
using `ocamlopt`. For now, we also assume that they do not use any other
library than the standard library, which is automatically loaded. You
can compile the program in one single step:

```shell
ocamlopt -o program module1.ml module2.ml
```

The compiler produces an executable named `program` or `program.exe`. The order
of the source files matters, and so `module1.ml` cannot depend upon things that
are defined in `module2.ml`.

The OCaml distribution is shipped with the standard library, plus several other
libraries. There are also a large number of third-party libraries, for a wide
range of applications, from networking to graphics. You should understand the
following:

1. The OCaml compilers know where the standard library is and use it
   systematically (try: `ocamlc -where`). You don't have to worry much about
   it.

1. The other libraries that ship with the OCaml distribution (str, unix, etc.)
   are installed in the same directory as the standard library.

1. Third-party libraries may be installed in various places, and even a given
   library can be installed in different places from one system to another.

If your program uses the unix library in addition to the standard library, for
example, the command line would be:

```shell
ocamlopt -o program unix.cmxa module1.ml module2.ml
```

Note that `.cmxa` is the extension of native code libraries, while `.cma` is
the extension of bytecode libraries. The file `unix.cmxa` is found because it
is always installed at the same place as the standard library, and this
directory is in the library search path.

If your program depends upon third-party libraries, you must pass them on the
command line. You must also indicate the libraries on which these libraries
depend. You must also pass the -I option to `ocamlopt` for each directory where
they may be found. This becomes complicated, and this information is
installation dependent. So we will use `ocamlfind` instead, which does these
jobs for us.

###  Using the ocamlfind front-end

The `ocamlfind` front-end is often used for compiling programs that use
third-party OCaml libraries. Library authors themselves make their library
installable with `ocamlfind` as well. You can install `ocamlfind` using the
opam package manager, by typing `opam install ocamlfind`.

Let's assume that all the libraries you want to use have been installed
properly with ocamlfind. You can see which libraries are available in your
system by typing:

```shell
ocamlfind list
```

This shows the list of package names, with their versions. Note that most
opam packages install software using ocamlfind, so your list of ocamlfind
libraries will be somewhat similar to your list of installed opam packages
obtained by `opam list`.

The command for compiling our program using package `pkg` will be:

```shell
ocamlfind ocamlopt -o program -linkpkg -package pkg module1.ml module2.ml
```

Multiple packages may be specified using commas e.g `pkg1,pkg2`. Ocamlfind
knows how to find any files `ocamlopt` may need from the package, for example
`.cmxa` implementation files or `.cmi` interface files, because they have been
packaged together and installed at a known location by ocamlfind. We need only
the name `pkg` to refer to them all - ocamlfind does the rest.

Note that you can compile the files separately. This is useful if
you want to recompile only some parts of the programs. Here are the
equivalent commands that perform a separate compilation of the source
files and link them together in a final step:

```shell
ocamlfind ocamlopt -c -package pkg module1.ml
ocamlfind ocamlopt -c -package pkg module2.ml
ocamlfind ocamlopt -o program -linkpkg -package pkg module1.cmx module2.cmx
```

Separate compilation (one command for `module1.ml`, another for `module2.ml`
and another to link the final output) is usually not performed manually but
only when using an automated build system that will take care of recompiling
only what it necessary.

## Interlude: making a custom toplevel

OCaml provides another tool `ocamlmktop` to make an interactive toplevel with
libraries accessible. For example:

```shell
ocamlmktop -o toplevel unix.cma module1.ml module2.ml
```

We run `toplevel` and get an OCaml toplevel with modules `Unix`, `Module1`, and
`Module2` all available, allowing us to experiment interactively with our
program.

OCamlfind also supports `ocamlmktop`:

```shell
ocamlfind ocamlmktop -o toplevel unix.cma -package pkg module1.ml module2.ml
```

## Dune: an automated build system

The most popular modern system for building OCaml projects is
[dune](https://dune.readthedocs.io/en/stable/) which may be installed with
`opam install dune`. It allows one to build OCaml projects from a simple
description of their elements. For example, the dune file for our project might
look like this:

```scheme
;; our example project
(executable
  (name program)
  (libraries unix pkg))
```

The dune [quick-start
guide](https://dune.readthedocs.io/en/latest/quick-start.html) shows you how to
write such description files for more complicated situations, and how to
structure, build, and run dune projects. 

## Other build systems

- [OMake](https://github.com/ocaml-omake/omake) Another OCaml build system.
- [GNU make](https://www.gnu.org/software/make/) GNU make can build anything, including OCaml. May be used in conjunction with [OCamlmakefile](https://github.com/mmottl/ocaml-makefile)
- [Oasis](https://github.com/ocaml/oasis) Generates a configure, build, and install system from a specification.
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#compilation-basics">Compilation basics</a>
</li>
<li><a href="#interlude-making-a-custom-toplevel">Interlude: making a custom toplevel</a>
</li>
<li><a href="#dune-an-automated-build-system">Dune: an automated build system</a>
</li>
<li><a href="#other-build-systems">Other build systems</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<p>This tutorial explains how to compile your OCaml programs into executable form.
It addresses, in turn:</p>
<ol>
<li>
<p>The compilation commands <code>ocamlc</code> and <code>ocamlopt</code> provided with OCaml. It is
useful to learn these commands to understand OCaml's compilation model.</p>
</li>
<li>
<p>The <code>ocamlfind</code> front-end to the compiler, which saves you from worrying
about where libraries have been installed on your particular system.</p>
</li>
<li>
<p>Automatic build systems for OCaml, such as <code>dune</code>, which release us from
details of compiler command invocation, so we never touch <code>ocamlc</code>,
<code>ocamlopt</code>, or even <code>ocamlfind</code>.</p>
</li>
</ol>
<p>In our <a href="up_and_running.html">up and running tutorial</a> we jumped straight to using
the automated build system <code>dune</code>. Now we shall look under the hood.</p>
<h2 id="compilation-basics">Compilation basics</h2>
<p>In this section, we will first see how to compile a simple program using
only <code>ocamlc</code> or <code>ocamlopt</code>. Then we will see how to use libraries and how
to take advantage of the
<a href="https://projects.camlcity.org/projects/findlib.html">findlib</a>
system, which provides the <code>ocamlfind</code> command.</p>
<h3 id="the-ocamlc-and-ocamlopt-compilers">The ocamlc and ocamlopt compilers</h3>
<p>OCaml comes with two compilers: <code>ocamlc</code> is the bytecode compiler, and
<code>ocamlopt</code> is the native code compiler. If you don't know which one to use, use
<code>ocamlopt</code> since it provides executables that are faster than bytecode.</p>
<p>Let's assume that our program <code>program</code> has two source files,
<code>module1.ml</code> and <code>module2.ml</code>. We will compile them to native code,
using <code>ocamlopt</code>. For now, we also assume that they do not use any other
library than the standard library, which is automatically loaded. You
can compile the program in one single step:</p>
<pre><code class="language-shell">ocamlopt -o program module1.ml module2.ml
</code></pre>
<p>The compiler produces an executable named <code>program</code> or <code>program.exe</code>. The order
of the source files matters, and so <code>module1.ml</code> cannot depend upon things that
are defined in <code>module2.ml</code>.</p>
<p>The OCaml distribution is shipped with the standard library, plus several other
libraries. There are also a large number of third-party libraries, for a wide
range of applications, from networking to graphics. You should understand the
following:</p>
<ol>
<li>
<p>The OCaml compilers know where the standard library is and use it
systematically (try: <code>ocamlc -where</code>). You don't have to worry much about
it.</p>
</li>
<li>
<p>The other libraries that ship with the OCaml distribution (str, unix, etc.)
are installed in the same directory as the standard library.</p>
</li>
<li>
<p>Third-party libraries may be installed in various places, and even a given
library can be installed in different places from one system to another.</p>
</li>
</ol>
<p>If your program uses the unix library in addition to the standard library, for
example, the command line would be:</p>
<pre><code class="language-shell">ocamlopt -o program unix.cmxa module1.ml module2.ml
</code></pre>
<p>Note that <code>.cmxa</code> is the extension of native code libraries, while <code>.cma</code> is
the extension of bytecode libraries. The file <code>unix.cmxa</code> is found because it
is always installed at the same place as the standard library, and this
directory is in the library search path.</p>
<p>If your program depends upon third-party libraries, you must pass them on the
command line. You must also indicate the libraries on which these libraries
depend. You must also pass the -I option to <code>ocamlopt</code> for each directory where
they may be found. This becomes complicated, and this information is
installation dependent. So we will use <code>ocamlfind</code> instead, which does these
jobs for us.</p>
<h3 id="using-the-ocamlfind-front-end">Using the ocamlfind front-end</h3>
<p>The <code>ocamlfind</code> front-end is often used for compiling programs that use
third-party OCaml libraries. Library authors themselves make their library
installable with <code>ocamlfind</code> as well. You can install <code>ocamlfind</code> using the
opam package manager, by typing <code>opam install ocamlfind</code>.</p>
<p>Let's assume that all the libraries you want to use have been installed
properly with ocamlfind. You can see which libraries are available in your
system by typing:</p>
<pre><code class="language-shell">ocamlfind list
</code></pre>
<p>This shows the list of package names, with their versions. Note that most
opam packages install software using ocamlfind, so your list of ocamlfind
libraries will be somewhat similar to your list of installed opam packages
obtained by <code>opam list</code>.</p>
<p>The command for compiling our program using package <code>pkg</code> will be:</p>
<pre><code class="language-shell">ocamlfind ocamlopt -o program -linkpkg -package pkg module1.ml module2.ml
</code></pre>
<p>Multiple packages may be specified using commas e.g <code>pkg1,pkg2</code>. Ocamlfind
knows how to find any files <code>ocamlopt</code> may need from the package, for example
<code>.cmxa</code> implementation files or <code>.cmi</code> interface files, because they have been
packaged together and installed at a known location by ocamlfind. We need only
the name <code>pkg</code> to refer to them all - ocamlfind does the rest.</p>
<p>Note that you can compile the files separately. This is useful if
you want to recompile only some parts of the programs. Here are the
equivalent commands that perform a separate compilation of the source
files and link them together in a final step:</p>
<pre><code class="language-shell">ocamlfind ocamlopt -c -package pkg module1.ml
ocamlfind ocamlopt -c -package pkg module2.ml
ocamlfind ocamlopt -o program -linkpkg -package pkg module1.cmx module2.cmx
</code></pre>
<p>Separate compilation (one command for <code>module1.ml</code>, another for <code>module2.ml</code>
and another to link the final output) is usually not performed manually but
only when using an automated build system that will take care of recompiling
only what it necessary.</p>
<h2 id="interlude-making-a-custom-toplevel">Interlude: making a custom toplevel</h2>
<p>OCaml provides another tool <code>ocamlmktop</code> to make an interactive toplevel with
libraries accessible. For example:</p>
<pre><code class="language-shell">ocamlmktop -o toplevel unix.cma module1.ml module2.ml
</code></pre>
<p>We run <code>toplevel</code> and get an OCaml toplevel with modules <code>Unix</code>, <code>Module1</code>, and
<code>Module2</code> all available, allowing us to experiment interactively with our
program.</p>
<p>OCamlfind also supports <code>ocamlmktop</code>:</p>
<pre><code class="language-shell">ocamlfind ocamlmktop -o toplevel unix.cma -package pkg module1.ml module2.ml
</code></pre>
<h2 id="dune-an-automated-build-system">Dune: an automated build system</h2>
<p>The most popular modern system for building OCaml projects is
<a href="https://dune.readthedocs.io/en/stable/">dune</a> which may be installed with
<code>opam install dune</code>. It allows one to build OCaml projects from a simple
description of their elements. For example, the dune file for our project might
look like this:</p>
<pre><code class="language-scheme">;; our example project
(executable
  (name program)
  (libraries unix pkg))
</code></pre>
<p>The dune <a href="https://dune.readthedocs.io/en/latest/quick-start.html">quick-start
guide</a> shows you how to
write such description files for more complicated situations, and how to
structure, build, and run dune projects.</p>
<h2 id="other-build-systems">Other build systems</h2>
<ul>
<li><a href="https://github.com/ocaml-omake/omake">OMake</a> Another OCaml build system.
</li>
<li><a href="https://www.gnu.org/software/make/">GNU make</a> GNU make can build anything, including OCaml. May be used in conjunction with <a href="https://github.com/mmottl/ocaml-makefile">OCamlmakefile</a>
</li>
<li><a href="https://github.com/ocaml/oasis">Oasis</a> Generates a configure, build, and install system from a specification.
</li>
</ul>
|js}
  };
 
  { title = {js|Data Types and Matching|js}
  ; slug = {js|data-types-and-matching|js}
  ; description = {js|Learn to build custom types and write function to process this data
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["language"]
  ; users = [`Beginner; `Intermediate]
  ; body_md = {js|
In this tutorial we learn how to build our own types in OCaml, and how to write
functions which process this new data.

## Built-in compound types

We have already seen simple data types such as `int`, `float`, `string`, and
`bool`.  Let's recap the built-in compound data types we can use in OCaml to
combine such values. First, we have lists which are ordered collections of any
number of elements of like type:

```ocaml
# []
- : 'a list = []
# [1; 2; 3]
- : int list = [1; 2; 3]
# [[1; 2]; [3; 4]; [5; 6]]
- : int list list = [[1; 2]; [3; 4]; [5; 6]]
# [false; true; false]
- : bool list = [false; true; false]
```

Next, we have tuples, which collect a fixed number of elements together:

```ocaml
# (5.0, 6.5)
- : float * float = (5., 6.5)
# (true, 0.0, 0.45, 0.73, "french blue")
- : bool * float * float * float * string =
(true, 0., 0.45, 0.73, "french blue")
```

We have records, which are like labeled tuples. They are defined by writing a
type definition giving a name for the record, and names for each of its fields,
and their types:

```ocaml
# type point = {x : float; y : float}
type point = { x : float; y : float; }
# let a = {x = 5.0; y = 6.5}
val a : point = {x = 5.; y = 6.5}
# type colour = {websafe : bool; r : float; g : float; b : float; name : string}
type colour = {
  websafe : bool;
  r : float;
  g : float;
  b : float;
  name : string;
}
# let b = {websafe = true; r = 0.0; g = 0.45; b = 0.73; name = "french blue"}
val b : colour =
  {websafe = true; r = 0.; g = 0.45; b = 0.73; name = "french blue"}
```

A record must contain all fields:

```ocaml
# let c = {name = "puce"}
Line 1, characters 9-24:
Error: Some record fields are undefined: websafe r g b
```

Records may be mutable:

```ocaml
# type person =
  {first_name : string;
   surname : string;
   mutable age : int}
type person = { first_name : string; surname : string; mutable age : int; }
# let birthday p =
  p.age <- p.age + 1
val birthday : person -> unit = <fun>
```

Another mutable compound data type is the fixed-length array which, just as a
list, must contain elements of like type. However, its elements may be accessed
in constant time:

```ocaml
# let arr = [|1; 2; 3|]
val arr : int array = [|1; 2; 3|]
# arr.(0)
- : int = 1
# arr.(0) <- 0
- : unit = ()
# arr
- : int array = [|0; 2; 3|]
```

In this tutorial, we will define our own compound data types, using the `type`
keyword, and some of these built-in structures as building blocks.

## A simple custom type

We can define a new data type `colour` which can take one of four values.

```ocaml env=colours
type colour = Red | Green | Blue | Yellow
```

Our new type is called `colour`, and has four *constructors* `Red`, `Green`,
`Blue` and `Yellow`. The name of the type must begin with a lower case letter,
and the names of the constructors with upper case letters. We can use our new
type anywhere a built-in type could be used:

```ocaml env=colours
# let additive_primaries = (Red, Green, Blue)
val additive_primaries : colour * colour * colour = (Red, Green, Blue)
# let pattern = [(1, Red); (3, Green); (1, Red); (2, Green)]
val pattern : (int * colour) list =
  [(1, Red); (3, Green); (1, Red); (2, Green)]
```

Notice the types inferred by OCaml for these expressions. We can pattern-match
on our new type, just as with any built-in type:

```ocaml env=colours
# let example c =
  match c with
  | Red -> "rose"
  | Green -> "grass"
  | Blue -> "sky"
  | Yellow -> "banana"
val example : colour -> string = <fun>
```

Notice the type of the function includes the name of our new type `colour`. We
can make the function shorter and elide its parameter `c` by using the
alternative `function` keyword which allows direct matching:

```ocaml env=colours
# let example = function
  | Red -> "rose"
  | Green -> "grass"
  | Blue -> "sky"
  | Yellow -> "banana"
val example : colour -> string = <fun>
```

We can match on more than one case at a time too:

```ocaml env=colours
# let rec is_primary = function
  | Red | Green | Blue -> true
  | _ -> false
val is_primary : colour -> bool = <fun>
```

## Constructors with data

Each constructor in a data type can carry additional information with it. Let's
extend our `colour` type to allow arbitrary RGB triples, each element begin a
number from 0 (no colour) to 1 (full colour): 

```ocaml env=colours
# type colour =
  | Red
  | Green
  | Blue
  | Yellow
  | RGB of float * float * float
type colour = Red | Green | Blue | Yellow | RGB of float * float * float

# [Red; Blue; RGB (0.5, 0.65, 0.12)]
- : colour list = [Red; Blue; RGB (0.5, 0.65, 0.12)]
```

Types, just like functions, may be recursively-defined. We extend our data type
to allow mixing of colours:

```ocaml env=colours
# type colour =
  | Red
  | Green
  | Blue
  | Yellow
  | RGB of float * float * float
  | Mix of float * colour * colour
type colour =
    Red
  | Green
  | Blue
  | Yellow
  | RGB of float * float * float
  | Mix of float * colour * colour
# Mix (0.5, Red, Mix (0.5, Blue, Green))
- : colour = Mix (0.5, Red, Mix (0.5, Blue, Green))
```

Here is a function over our new `colour` data type:

```ocaml env=colours
# let rec rgb_of_colour = function
  | Red -> (1.0, 0.0, 0.0)
  | Green -> (0.0, 1.0, 0.0)
  | Blue -> (0.0, 0.0, 1.0)
  | Yellow -> (1.0, 1.0, 0.0)
  | RGB (r, g, b) -> (r, g, b)
  | Mix (p, a, b) ->
      let (r1, g1, b1) = rgb_of_colour a in
      let (r2, g2, b2) = rgb_of_colour b in
      let mix x y = x *. p +. y *. (1.0 -. p) in
        (mix r1 r2, mix g1 g2, mix b1 b2)
val rgb_of_colour : colour -> float * float * float = <fun>
```

We can use records directly in the data type instead to label our components:

```ocaml env=colours
# type colour =
  | Red
  | Green
  | Blue
  | Yellow
  | RGB of {r : float; g : float; b : float}
  | Mix of {proportion : float; c1 : colour; c2 : colour}
type colour =
    Red
  | Green
  | Blue
  | Yellow
  | RGB of { r : float; g : float; b : float; }
  | Mix of { proportion : float; c1 : colour; c2 : colour; }
```

## Example: trees

Data types may be polymorphic as well as recursive. Here is an OCaml data type
for a binary tree carrying any kind of data:

```ocaml env=trees
# type 'a tree =
  | Leaf
  | Node of 'a tree * 'a * 'a tree
type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree
# let t =
    Node (Node (Leaf, 1, Leaf), 2, Node (Node (Leaf, 3, Leaf), 4, Leaf))
val t : int tree =
  Node (Node (Leaf, 1, Leaf), 2, Node (Node (Leaf, 3, Leaf), 4, Leaf))
```

Notice that we give the type parameter `'a` before the type name (if there is
more than one, we write `('a, 'b)` etc).  A `Leaf` holds no information,
just like an empty list. A `Node` holds a left tree, a value of type `'a`
and a right tree. In our example, we built an integer tree, but any type can be
used. Now we can write recursive and polymorphic functions over these trees, by
pattern matching on our new constructors:

```ocaml env=trees
# let rec total = function
  | Leaf -> 0
  | Node (l, x, r) -> total l + x + total r
val total : int tree -> int = <fun>
# let rec flip = function
  | Leaf -> Leaf
  | Node (l, x, r) -> Node (flip r, x, flip l)
val flip : 'a tree -> 'a tree = <fun>
```

Here, `flip` is polymorphic while `total` operates only on trees of type `int
tree`. Let's try our new functions out:

```ocaml env=trees
# let all = total t
val all : int = 10
# let flipped = flip t
val flipped : int tree =
  Node (Node (Leaf, 4, Node (Leaf, 3, Leaf)), 2, Node (Leaf, 1, Leaf))
# t = flip flipped
- : bool = true
```

Instead of integers, we could build a tree of key-value pairs. Then, if we
insist that the keys are unique and that a smaller key is always left of a
larger key, we have a data structure for dictionaries which performs better
than a simple list of pairs. It is known as a *binary search tree*:

```ocaml env=trees
# let rec insert (k, v) = function
  | Leaf -> Node (Leaf, (k, v), Leaf)
  | Node (l, (k', v'), r) ->
      if k < k' then Node (insert (k, v) l, (k', v'), r) 
      else if k > k' then Node (l, (k', v'), insert (k, v) r)
      else Node (l, (k, v), r)
val insert : 'a * 'b -> ('a * 'b) tree -> ('a * 'b) tree = <fun>
```

Similar functions can be written to look up values in a dictionary, to convert
a list of pairs to or from a tree dictionary and so on.

## Example: mathematical expressions

We wish to represent simple mathematical expressions like `n * (x + y)` and
multiply them out symbolically to get `n * x + n * y`.

Let's define a type for these expressions:

```ocaml env=expr
type expr =
  | Plus of expr * expr        (* a + b *)
  | Minus of expr * expr       (* a - b *)
  | Times of expr * expr       (* a * b *)
  | Divide of expr * expr      (* a / b *)
  | Var of string              (* "x", "y", etc. *)
```

The expression `n * (x + y)` would be written:

```ocaml env=expr
# Times (Var "n", Plus (Var "x", Var "y"))
- : expr = Times (Var "n", Plus (Var "x", Var "y"))
```

Let's write a function which prints out `Times (Var "n", Plus (Var "x", Var
"y"))` as something more like `n * (x + y)`.

```ocaml env=expr
# let rec to_string e =
  match e with
  | Plus (left, right) ->
     "(" ^ to_string left ^ " + " ^ to_string right ^ ")"
  | Minus (left, right) ->
     "(" ^ to_string left ^ " - " ^ to_string right ^ ")"
  | Times (left, right) ->
   "(" ^ to_string left ^ " * " ^ to_string right ^ ")"
  | Divide (left, right) ->
   "(" ^ to_string left ^ " / " ^ to_string right ^ ")"
  | Var v -> v
val to_string : expr -> string = <fun>
# let print_expr e =
  print_endline (to_string e)
val print_expr : expr -> unit = <fun>
```

(The `^` operator concatenates strings). We separate the function into two so
that our `to_string` function is usable in other contexts. Here's the
`print_expr` function in action:

```ocaml env=expr
# print_expr (Times (Var "n", Plus (Var "x", Var "y")))
(n * (x + y))
- : unit = ()
```

We can write a function to multiply out expressions of the form `n * (x + y)`
or `(x + y) * n` and for this we will use a nested pattern:

```ocaml env=expr
# let rec multiply_out e =
  match e with
  | Times (e1, Plus (e2, e3)) ->
     Plus (Times (multiply_out e1, multiply_out e2),
           Times (multiply_out e1, multiply_out e3))
  | Times (Plus (e1, e2), e3) ->
     Plus (Times (multiply_out e1, multiply_out e3),
           Times (multiply_out e2, multiply_out e3))
  | Plus (left, right) ->
     Plus (multiply_out left, multiply_out right)
  | Minus (left, right) ->
     Minus (multiply_out left, multiply_out right)
  | Times (left, right) ->
     Times (multiply_out left, multiply_out right)
  | Divide (left, right) ->
     Divide (multiply_out left, multiply_out right)
  | Var v -> Var v
val multiply_out : expr -> expr = <fun>
```

Here it is in action:

```ocaml env=expr
# print_expr (multiply_out (Times (Var "n", Plus (Var "x", Var "y"))))
((n * x) + (n * y))
- : unit = ()
```

How does the `multiply_out` function work? The key is in the first two
patterns. The first pattern is `Times (e1, Plus (e2, e3))` which matches
expressions of the form `e1 * (e2 + e3)`. Now look at the right hand side of
this first pattern match, and convince yourself that it is the equivalent of
`(e1 * e2) + (e1 * e3)`. The second pattern does the same thing, except for
expressions of the form `(e1 + e2) * e3`.

The remaining patterns don't change the form of the expression, but they
crucially *do* call the `multiply_out` function recursively on their
subexpressions. This ensures that all subexpressions within the expression get
multiplied out too (if you only wanted to multiply out the very top level of an
expression, then you could replace all the remaining patterns with a simple `e
-> e` rule).

Can we do the reverse (i.e. factorizing out common subexpressions)? We can!
(But it's a bit more complicated). The following version only works for the top
level expression. You could certainly extend it to cope with all levels of an
expression and more complex cases:

```ocaml env=expr
# let factorize e =
  match e with
  | Plus (Times (e1, e2), Times (e3, e4)) when e1 = e3 ->
     Times (e1, Plus (e2, e4))
  | Plus (Times (e1, e2), Times (e3, e4)) when e2 = e4 ->
     Times (Plus (e1, e3), e4)
  | e -> e
val factorize : expr -> expr = <fun>
# factorize (Plus (Times (Var "n", Var "x"),
                   Times (Var "n", Var "y")))
- : expr = Times (Var "n", Plus (Var "x", Var "y"))
```

The factorize function above introduces another couple of features. You can add
what are known as *guards* to each pattern match. A guard is the conditional
which follows the `when`, and it means that the pattern match only happens if
the pattern matches *and* the condition in the `when`-clause is satisfied.

<!-- $MDX skip -->
```ocaml
match value with
| pattern [ when condition ] -> result
| pattern [ when condition ] -> result
  ...
```

The second feature is the `=` operator which tests for "structural equality"
between two expressions. That means it goes recursively into each expression
checking they're exactly the same at all levels down.

Another feature which is useful when we build more complicated nested patterns
is the `as` keyword, which can be used to name part of an expression. For
example:

<!-- $MDX skip -->
```ocaml
Name ("/DeviceGray" | "/DeviceRGB" | "/DeviceCMYK") as n -> n

Node (l, ((k, _) as pair), r) when k = k' -> Some pair
```

## Mutually recursive data types

Data types may be mutually-recursive when declared with `and`:

```ocaml
type t = A | B of t' and t' = C | D of t
```

One common use for mutually-recursive data types is to *decorate* a tree, by
adding information to each node using mutually-recursive types, one of which is
a tuple or record. For example:

```ocaml
type t' = Int of int | Add of t * t
and t = {annotation : string; data : t'}
```

Values of such mutually-recursive data type are manipulated by accompanying
mutually-recursive functions:

```ocaml
# let rec sum_t' = function
  | Int i -> i
  | Add (i, i') -> sum_t i + sum_t i'
  and sum_t {annotation; data} =
    if annotation <> "" then Printf.printf "Touching %s\\n" annotation;
    sum_t' data
val sum_t' : t' -> int = <fun>
val sum_t : t -> int = <fun>
```

## A note on tupled constructors

There is a difference between `RGB of float * float * float` and `RGB of (float
* float * float)`. The first is a constructor with three pieces of data
associated with it, the second is a constructor with one tuple associated with
it. There are two ways this matters: the memory layout differs between the two
(a tuple is an extra indirection), and the ability to create or match using a
tuple:

```ocaml
# type t = T of int * int
type t = T of int * int

# type t2 = T2 of (int * int)
type t2 = T2 of (int * int)

# let pair = (1, 2)
val pair : int * int = (1, 2)

# T2 pair
- : t2 = T2 (1, 2)

# T pair
Line 1, characters 1-7:
Error: The constructor T expects 2 argument(s),
       but is applied here to 1 argument(s)

# match T2 (1, 2) with T2 x -> fst x
- : int = 1

# match T (1, 2) with T x -> fst x
Line 1, characters 21-24:
Error: The constructor T expects 2 argument(s),
       but is applied here to 1 argument(s)
```

Note, however, that OCaml allows us to use the always-matching `_` in either
version:

```ocaml
# match T2 (1, 2) with T2 _ -> 0
- : int = 0

# match T (1, 2) with T _ -> 0
- : int = 0
```

## Types and modules

Often, a module will provide a single type and operations on that type. For
example, a module for a file format like PNG might have the following `png.mli`
interface:

<!-- $MDX skip -->
```ocaml
type t

val of_file : filename -> t

val to_file : t -> filename -> unit

val flip_vertical : t -> t

val flip_horizontal : t -> t

val rotate : float -> t -> t
```

Traditionally, we name the type `t`. In the program using this library, it
would then be `Png.t` which is shorter, reads better than `Png.png`, and avoids
confusion if the library also defines other types.
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#built-in-compound-types">Built-in compound types</a>
</li>
<li><a href="#a-simple-custom-type">A simple custom type</a>
</li>
<li><a href="#constructors-with-data">Constructors with data</a>
</li>
<li><a href="#example-trees">Example: trees</a>
</li>
<li><a href="#example-mathematical-expressions">Example: mathematical expressions</a>
</li>
<li><a href="#mutually-recursive-data-types">Mutually recursive data types</a>
</li>
<li><a href="#a-note-on-tupled-constructors">A note on tupled constructors</a>
</li>
<li><a href="#types-and-modules">Types and modules</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<p>In this tutorial we learn how to build our own types in OCaml, and how to write
functions which process this new data.</p>
<h2 id="built-in-compound-types">Built-in compound types</h2>
<p>We have already seen simple data types such as <code>int</code>, <code>float</code>, <code>string</code>, and
<code>bool</code>.  Let's recap the built-in compound data types we can use in OCaml to
combine such values. First, we have lists which are ordered collections of any
number of elements of like type:</p>
<pre><code class="language-ocaml"># []
- : 'a list = []
# [1; 2; 3]
- : int list = [1; 2; 3]
# [[1; 2]; [3; 4]; [5; 6]]
- : int list list = [[1; 2]; [3; 4]; [5; 6]]
# [false; true; false]
- : bool list = [false; true; false]
</code></pre>
<p>Next, we have tuples, which collect a fixed number of elements together:</p>
<pre><code class="language-ocaml"># (5.0, 6.5)
- : float * float = (5., 6.5)
# (true, 0.0, 0.45, 0.73, &quot;french blue&quot;)
- : bool * float * float * float * string =
(true, 0., 0.45, 0.73, &quot;french blue&quot;)
</code></pre>
<p>We have records, which are like labeled tuples. They are defined by writing a
type definition giving a name for the record, and names for each of its fields,
and their types:</p>
<pre><code class="language-ocaml"># type point = {x : float; y : float}
type point = { x : float; y : float; }
# let a = {x = 5.0; y = 6.5}
val a : point = {x = 5.; y = 6.5}
# type colour = {websafe : bool; r : float; g : float; b : float; name : string}
type colour = {
  websafe : bool;
  r : float;
  g : float;
  b : float;
  name : string;
}
# let b = {websafe = true; r = 0.0; g = 0.45; b = 0.73; name = &quot;french blue&quot;}
val b : colour =
  {websafe = true; r = 0.; g = 0.45; b = 0.73; name = &quot;french blue&quot;}
</code></pre>
<p>A record must contain all fields:</p>
<pre><code class="language-ocaml"># let c = {name = &quot;puce&quot;}
Line 1, characters 9-24:
Error: Some record fields are undefined: websafe r g b
</code></pre>
<p>Records may be mutable:</p>
<pre><code class="language-ocaml"># type person =
  {first_name : string;
   surname : string;
   mutable age : int}
type person = { first_name : string; surname : string; mutable age : int; }
# let birthday p =
  p.age &lt;- p.age + 1
val birthday : person -&gt; unit = &lt;fun&gt;
</code></pre>
<p>Another mutable compound data type is the fixed-length array which, just as a
list, must contain elements of like type. However, its elements may be accessed
in constant time:</p>
<pre><code class="language-ocaml"># let arr = [|1; 2; 3|]
val arr : int array = [|1; 2; 3|]
# arr.(0)
- : int = 1
# arr.(0) &lt;- 0
- : unit = ()
# arr
- : int array = [|0; 2; 3|]
</code></pre>
<p>In this tutorial, we will define our own compound data types, using the <code>type</code>
keyword, and some of these built-in structures as building blocks.</p>
<h2 id="a-simple-custom-type">A simple custom type</h2>
<p>We can define a new data type <code>colour</code> which can take one of four values.</p>
<pre><code class="language-ocaml">type colour = Red | Green | Blue | Yellow
</code></pre>
<p>Our new type is called <code>colour</code>, and has four <em>constructors</em> <code>Red</code>, <code>Green</code>,
<code>Blue</code> and <code>Yellow</code>. The name of the type must begin with a lower case letter,
and the names of the constructors with upper case letters. We can use our new
type anywhere a built-in type could be used:</p>
<pre><code class="language-ocaml"># let additive_primaries = (Red, Green, Blue)
val additive_primaries : colour * colour * colour = (Red, Green, Blue)
# let pattern = [(1, Red); (3, Green); (1, Red); (2, Green)]
val pattern : (int * colour) list =
  [(1, Red); (3, Green); (1, Red); (2, Green)]
</code></pre>
<p>Notice the types inferred by OCaml for these expressions. We can pattern-match
on our new type, just as with any built-in type:</p>
<pre><code class="language-ocaml"># let example c =
  match c with
  | Red -&gt; &quot;rose&quot;
  | Green -&gt; &quot;grass&quot;
  | Blue -&gt; &quot;sky&quot;
  | Yellow -&gt; &quot;banana&quot;
val example : colour -&gt; string = &lt;fun&gt;
</code></pre>
<p>Notice the type of the function includes the name of our new type <code>colour</code>. We
can make the function shorter and elide its parameter <code>c</code> by using the
alternative <code>function</code> keyword which allows direct matching:</p>
<pre><code class="language-ocaml"># let example = function
  | Red -&gt; &quot;rose&quot;
  | Green -&gt; &quot;grass&quot;
  | Blue -&gt; &quot;sky&quot;
  | Yellow -&gt; &quot;banana&quot;
val example : colour -&gt; string = &lt;fun&gt;
</code></pre>
<p>We can match on more than one case at a time too:</p>
<pre><code class="language-ocaml"># let rec is_primary = function
  | Red | Green | Blue -&gt; true
  | _ -&gt; false
val is_primary : colour -&gt; bool = &lt;fun&gt;
</code></pre>
<h2 id="constructors-with-data">Constructors with data</h2>
<p>Each constructor in a data type can carry additional information with it. Let's
extend our <code>colour</code> type to allow arbitrary RGB triples, each element begin a
number from 0 (no colour) to 1 (full colour):</p>
<pre><code class="language-ocaml"># type colour =
  | Red
  | Green
  | Blue
  | Yellow
  | RGB of float * float * float
type colour = Red | Green | Blue | Yellow | RGB of float * float * float

# [Red; Blue; RGB (0.5, 0.65, 0.12)]
- : colour list = [Red; Blue; RGB (0.5, 0.65, 0.12)]
</code></pre>
<p>Types, just like functions, may be recursively-defined. We extend our data type
to allow mixing of colours:</p>
<pre><code class="language-ocaml"># type colour =
  | Red
  | Green
  | Blue
  | Yellow
  | RGB of float * float * float
  | Mix of float * colour * colour
type colour =
    Red
  | Green
  | Blue
  | Yellow
  | RGB of float * float * float
  | Mix of float * colour * colour
# Mix (0.5, Red, Mix (0.5, Blue, Green))
- : colour = Mix (0.5, Red, Mix (0.5, Blue, Green))
</code></pre>
<p>Here is a function over our new <code>colour</code> data type:</p>
<pre><code class="language-ocaml"># let rec rgb_of_colour = function
  | Red -&gt; (1.0, 0.0, 0.0)
  | Green -&gt; (0.0, 1.0, 0.0)
  | Blue -&gt; (0.0, 0.0, 1.0)
  | Yellow -&gt; (1.0, 1.0, 0.0)
  | RGB (r, g, b) -&gt; (r, g, b)
  | Mix (p, a, b) -&gt;
      let (r1, g1, b1) = rgb_of_colour a in
      let (r2, g2, b2) = rgb_of_colour b in
      let mix x y = x *. p +. y *. (1.0 -. p) in
        (mix r1 r2, mix g1 g2, mix b1 b2)
val rgb_of_colour : colour -&gt; float * float * float = &lt;fun&gt;
</code></pre>
<p>We can use records directly in the data type instead to label our components:</p>
<pre><code class="language-ocaml"># type colour =
  | Red
  | Green
  | Blue
  | Yellow
  | RGB of {r : float; g : float; b : float}
  | Mix of {proportion : float; c1 : colour; c2 : colour}
type colour =
    Red
  | Green
  | Blue
  | Yellow
  | RGB of { r : float; g : float; b : float; }
  | Mix of { proportion : float; c1 : colour; c2 : colour; }
</code></pre>
<h2 id="example-trees">Example: trees</h2>
<p>Data types may be polymorphic as well as recursive. Here is an OCaml data type
for a binary tree carrying any kind of data:</p>
<pre><code class="language-ocaml"># type 'a tree =
  | Leaf
  | Node of 'a tree * 'a * 'a tree
type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree
# let t =
    Node (Node (Leaf, 1, Leaf), 2, Node (Node (Leaf, 3, Leaf), 4, Leaf))
val t : int tree =
  Node (Node (Leaf, 1, Leaf), 2, Node (Node (Leaf, 3, Leaf), 4, Leaf))
</code></pre>
<p>Notice that we give the type parameter <code>'a</code> before the type name (if there is
more than one, we write <code>('a, 'b)</code> etc).  A <code>Leaf</code> holds no information,
just like an empty list. A <code>Node</code> holds a left tree, a value of type <code>'a</code>
and a right tree. In our example, we built an integer tree, but any type can be
used. Now we can write recursive and polymorphic functions over these trees, by
pattern matching on our new constructors:</p>
<pre><code class="language-ocaml"># let rec total = function
  | Leaf -&gt; 0
  | Node (l, x, r) -&gt; total l + x + total r
val total : int tree -&gt; int = &lt;fun&gt;
# let rec flip = function
  | Leaf -&gt; Leaf
  | Node (l, x, r) -&gt; Node (flip r, x, flip l)
val flip : 'a tree -&gt; 'a tree = &lt;fun&gt;
</code></pre>
<p>Here, <code>flip</code> is polymorphic while <code>total</code> operates only on trees of type <code>int tree</code>. Let's try our new functions out:</p>
<pre><code class="language-ocaml"># let all = total t
val all : int = 10
# let flipped = flip t
val flipped : int tree =
  Node (Node (Leaf, 4, Node (Leaf, 3, Leaf)), 2, Node (Leaf, 1, Leaf))
# t = flip flipped
- : bool = true
</code></pre>
<p>Instead of integers, we could build a tree of key-value pairs. Then, if we
insist that the keys are unique and that a smaller key is always left of a
larger key, we have a data structure for dictionaries which performs better
than a simple list of pairs. It is known as a <em>binary search tree</em>:</p>
<pre><code class="language-ocaml"># let rec insert (k, v) = function
  | Leaf -&gt; Node (Leaf, (k, v), Leaf)
  | Node (l, (k', v'), r) -&gt;
      if k &lt; k' then Node (insert (k, v) l, (k', v'), r) 
      else if k &gt; k' then Node (l, (k', v'), insert (k, v) r)
      else Node (l, (k, v), r)
val insert : 'a * 'b -&gt; ('a * 'b) tree -&gt; ('a * 'b) tree = &lt;fun&gt;
</code></pre>
<p>Similar functions can be written to look up values in a dictionary, to convert
a list of pairs to or from a tree dictionary and so on.</p>
<h2 id="example-mathematical-expressions">Example: mathematical expressions</h2>
<p>We wish to represent simple mathematical expressions like <code>n * (x + y)</code> and
multiply them out symbolically to get <code>n * x + n * y</code>.</p>
<p>Let's define a type for these expressions:</p>
<pre><code class="language-ocaml">type expr =
  | Plus of expr * expr        (* a + b *)
  | Minus of expr * expr       (* a - b *)
  | Times of expr * expr       (* a * b *)
  | Divide of expr * expr      (* a / b *)
  | Var of string              (* &quot;x&quot;, &quot;y&quot;, etc. *)
</code></pre>
<p>The expression <code>n * (x + y)</code> would be written:</p>
<pre><code class="language-ocaml"># Times (Var &quot;n&quot;, Plus (Var &quot;x&quot;, Var &quot;y&quot;))
- : expr = Times (Var &quot;n&quot;, Plus (Var &quot;x&quot;, Var &quot;y&quot;))
</code></pre>
<p>Let's write a function which prints out <code>Times (Var &quot;n&quot;, Plus (Var &quot;x&quot;, Var &quot;y&quot;))</code> as something more like <code>n * (x + y)</code>.</p>
<pre><code class="language-ocaml"># let rec to_string e =
  match e with
  | Plus (left, right) -&gt;
     &quot;(&quot; ^ to_string left ^ &quot; + &quot; ^ to_string right ^ &quot;)&quot;
  | Minus (left, right) -&gt;
     &quot;(&quot; ^ to_string left ^ &quot; - &quot; ^ to_string right ^ &quot;)&quot;
  | Times (left, right) -&gt;
   &quot;(&quot; ^ to_string left ^ &quot; * &quot; ^ to_string right ^ &quot;)&quot;
  | Divide (left, right) -&gt;
   &quot;(&quot; ^ to_string left ^ &quot; / &quot; ^ to_string right ^ &quot;)&quot;
  | Var v -&gt; v
val to_string : expr -&gt; string = &lt;fun&gt;
# let print_expr e =
  print_endline (to_string e)
val print_expr : expr -&gt; unit = &lt;fun&gt;
</code></pre>
<p>(The <code>^</code> operator concatenates strings). We separate the function into two so
that our <code>to_string</code> function is usable in other contexts. Here's the
<code>print_expr</code> function in action:</p>
<pre><code class="language-ocaml"># print_expr (Times (Var &quot;n&quot;, Plus (Var &quot;x&quot;, Var &quot;y&quot;)))
(n * (x + y))
- : unit = ()
</code></pre>
<p>We can write a function to multiply out expressions of the form <code>n * (x + y)</code>
or <code>(x + y) * n</code> and for this we will use a nested pattern:</p>
<pre><code class="language-ocaml"># let rec multiply_out e =
  match e with
  | Times (e1, Plus (e2, e3)) -&gt;
     Plus (Times (multiply_out e1, multiply_out e2),
           Times (multiply_out e1, multiply_out e3))
  | Times (Plus (e1, e2), e3) -&gt;
     Plus (Times (multiply_out e1, multiply_out e3),
           Times (multiply_out e2, multiply_out e3))
  | Plus (left, right) -&gt;
     Plus (multiply_out left, multiply_out right)
  | Minus (left, right) -&gt;
     Minus (multiply_out left, multiply_out right)
  | Times (left, right) -&gt;
     Times (multiply_out left, multiply_out right)
  | Divide (left, right) -&gt;
     Divide (multiply_out left, multiply_out right)
  | Var v -&gt; Var v
val multiply_out : expr -&gt; expr = &lt;fun&gt;
</code></pre>
<p>Here it is in action:</p>
<pre><code class="language-ocaml"># print_expr (multiply_out (Times (Var &quot;n&quot;, Plus (Var &quot;x&quot;, Var &quot;y&quot;))))
((n * x) + (n * y))
- : unit = ()
</code></pre>
<p>How does the <code>multiply_out</code> function work? The key is in the first two
patterns. The first pattern is <code>Times (e1, Plus (e2, e3))</code> which matches
expressions of the form <code>e1 * (e2 + e3)</code>. Now look at the right hand side of
this first pattern match, and convince yourself that it is the equivalent of
<code>(e1 * e2) + (e1 * e3)</code>. The second pattern does the same thing, except for
expressions of the form <code>(e1 + e2) * e3</code>.</p>
<p>The remaining patterns don't change the form of the expression, but they
crucially <em>do</em> call the <code>multiply_out</code> function recursively on their
subexpressions. This ensures that all subexpressions within the expression get
multiplied out too (if you only wanted to multiply out the very top level of an
expression, then you could replace all the remaining patterns with a simple <code>e -&gt; e</code> rule).</p>
<p>Can we do the reverse (i.e. factorizing out common subexpressions)? We can!
(But it's a bit more complicated). The following version only works for the top
level expression. You could certainly extend it to cope with all levels of an
expression and more complex cases:</p>
<pre><code class="language-ocaml"># let factorize e =
  match e with
  | Plus (Times (e1, e2), Times (e3, e4)) when e1 = e3 -&gt;
     Times (e1, Plus (e2, e4))
  | Plus (Times (e1, e2), Times (e3, e4)) when e2 = e4 -&gt;
     Times (Plus (e1, e3), e4)
  | e -&gt; e
val factorize : expr -&gt; expr = &lt;fun&gt;
# factorize (Plus (Times (Var &quot;n&quot;, Var &quot;x&quot;),
                   Times (Var &quot;n&quot;, Var &quot;y&quot;)))
- : expr = Times (Var &quot;n&quot;, Plus (Var &quot;x&quot;, Var &quot;y&quot;))
</code></pre>
<p>The factorize function above introduces another couple of features. You can add
what are known as <em>guards</em> to each pattern match. A guard is the conditional
which follows the <code>when</code>, and it means that the pattern match only happens if
the pattern matches <em>and</em> the condition in the <code>when</code>-clause is satisfied.</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">match value with
| pattern [ when condition ] -&gt; result
| pattern [ when condition ] -&gt; result
  ...
</code></pre>
<p>The second feature is the <code>=</code> operator which tests for &quot;structural equality&quot;
between two expressions. That means it goes recursively into each expression
checking they're exactly the same at all levels down.</p>
<p>Another feature which is useful when we build more complicated nested patterns
is the <code>as</code> keyword, which can be used to name part of an expression. For
example:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">Name (&quot;/DeviceGray&quot; | &quot;/DeviceRGB&quot; | &quot;/DeviceCMYK&quot;) as n -&gt; n

Node (l, ((k, _) as pair), r) when k = k' -&gt; Some pair
</code></pre>
<h2 id="mutually-recursive-data-types">Mutually recursive data types</h2>
<p>Data types may be mutually-recursive when declared with <code>and</code>:</p>
<pre><code class="language-ocaml">type t = A | B of t' and t' = C | D of t
</code></pre>
<p>One common use for mutually-recursive data types is to <em>decorate</em> a tree, by
adding information to each node using mutually-recursive types, one of which is
a tuple or record. For example:</p>
<pre><code class="language-ocaml">type t' = Int of int | Add of t * t
and t = {annotation : string; data : t'}
</code></pre>
<p>Values of such mutually-recursive data type are manipulated by accompanying
mutually-recursive functions:</p>
<pre><code class="language-ocaml"># let rec sum_t' = function
  | Int i -&gt; i
  | Add (i, i') -&gt; sum_t i + sum_t i'
  and sum_t {annotation; data} =
    if annotation &lt;&gt; &quot;&quot; then Printf.printf &quot;Touching %s\\n&quot; annotation;
    sum_t' data
val sum_t' : t' -&gt; int = &lt;fun&gt;
val sum_t : t -&gt; int = &lt;fun&gt;
</code></pre>
<h2 id="a-note-on-tupled-constructors">A note on tupled constructors</h2>
<p>There is a difference between <code>RGB of float * float * float</code> and `RGB of (float</p>
<ul>
<li>float * float)`. The first is a constructor with three pieces of data
associated with it, the second is a constructor with one tuple associated with
it. There are two ways this matters: the memory layout differs between the two
(a tuple is an extra indirection), and the ability to create or match using a
tuple:
</li>
</ul>
<pre><code class="language-ocaml"># type t = T of int * int
type t = T of int * int

# type t2 = T2 of (int * int)
type t2 = T2 of (int * int)

# let pair = (1, 2)
val pair : int * int = (1, 2)

# T2 pair
- : t2 = T2 (1, 2)

# T pair
Line 1, characters 1-7:
Error: The constructor T expects 2 argument(s),
       but is applied here to 1 argument(s)

# match T2 (1, 2) with T2 x -&gt; fst x
- : int = 1

# match T (1, 2) with T x -&gt; fst x
Line 1, characters 21-24:
Error: The constructor T expects 2 argument(s),
       but is applied here to 1 argument(s)
</code></pre>
<p>Note, however, that OCaml allows us to use the always-matching <code>_</code> in either
version:</p>
<pre><code class="language-ocaml"># match T2 (1, 2) with T2 _ -&gt; 0
- : int = 0

# match T (1, 2) with T _ -&gt; 0
- : int = 0
</code></pre>
<h2 id="types-and-modules">Types and modules</h2>
<p>Often, a module will provide a single type and operations on that type. For
example, a module for a file format like PNG might have the following <code>png.mli</code>
interface:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">type t

val of_file : filename -&gt; t

val to_file : t -&gt; filename -&gt; unit

val flip_vertical : t -&gt; t

val flip_horizontal : t -&gt; t

val rotate : float -&gt; t -&gt; t
</code></pre>
<p>Traditionally, we name the type <code>t</code>. In the program using this library, it
would then be <code>Png.t</code> which is shorter, reads better than <code>Png.png</code>, and avoids
confusion if the library also defines other types.</p>
|js}
  };
 
  { title = {js|Functional Programming|js}
  ; slug = {js|functional-programming|js}
  ; description = {js|A guide to functional programming in OCaml
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["language"]
  ; users = [`Beginner; `Intermediate]
  ; body_md = {js|
## What is functional programming?
We've got quite far into the tutorial, yet we haven't really considered
**functional programming**. All of the features given so far - rich data
types, pattern matching, type inference, nested functions - you could
imagine could exist in a kind of "super C" language. These are Cool
Features certainly, and make your code concise, easy to read, and have
fewer bugs, but they actually have very little to do with functional
programming. In fact my argument is going to be that the reason that
functional languages are so great is *not* because of functional
programming, but because we've been stuck with C-like languages for
years and in the meantime the cutting edge of programming has moved on
considerably. So while we were writing
`struct { int type; union { ... } }` for the umpteenth time, ML and
Haskell programmers had safe variants and pattern matching on datatypes.
While we were being careful to `free` all our `malloc`s, there have been
languages with garbage collectors able to outperform hand-coding since
the 80s.

Well, after that I'd better tell you what functional programming is
anyhow.

The basic, and not very enlightening definition is this: in a
**functional language**, **functions** are first-class citizens.

Lot of words there that don't really make much sense. So let's have an
example:

```ocaml
# let double x = x * 2 in
    List.map double [1; 2; 3]
- : int list = [2; 4; 6]
```

In this example, I've first defined a nested function called `double`
which takes an argument `x` and returns `x * 2`. Then `map` calls
`double` on each element of the given list (`[1; 2; 3]`) to produce the
result: a list with each number doubled.

`map` is known as a **higher-order function** (HOF). Higher-order
functions are just a fancy way of saying that the function takes a
function as one of its arguments. So far so simple. If you're familiar
with C/C++ then this looks like passing a function pointer around.

**Closures** are functions which carry around some of the "environment"
in which they were defined. In particular, a closure can reference
variables which were available at the point of its definition. Let's
generalise the function above so that now we can take any list of
integers and multiply each element by an arbitrary value `n`:

```ocaml
# let multiply n list =
    let f x = n * x in
      List.map f list
val multiply : int -> int list -> int list = <fun>
```

Hence:

```ocaml
# multiply 2 [1; 2; 3]
- : int list = [2; 4; 6]
# multiply 5 [1; 2; 3]
- : int list = [5; 10; 15]
```

The important point to note about the `multiply` function is the nested
function `f`. This is a closure. Look at how `f` uses the value of `n`
which isn't actually passed as an explicit argument to `f`. Instead `f`
picks it up from its environment - it's an argument to the `multiply`
function and hence available within this function.

This might sound straightforward, but let's look a bit closer at that
call to map: `List.map f list`.

`map` is defined in the `List` module, far away from the current code.
In other words, we're passing `f` into a module defined "a long time
ago, in a galaxy far far away". For all we know that code might pass `f`
to other modules, or save a reference to `f` somewhere and call it
later. Whether it does this or not, the closure will ensure that `f`
always has access back to its parental environment, and to `n`.

Here's a real example from lablgtk. This is actually a method on a class
(we haven't talked about classes and objects yet, but just think of it
as a function definition for now).

<!-- $MDX skip -->
```ocaml
class html_skel obj = object (self)
  ...
  ...
  method save_to_channel chan =
    let receiver_fn content =
      output_string chan content;
      true
    in
      save obj receiver_fn
  ...
end
```
First of all you need to know that the `save` function called at the end
of the method takes as its second argument a function (`receiver_fn`).
It repeatedly calls `receiver_fn` with snippets of text from the widget
that it's trying to save.

Now look at the definition of `receiver_fn`. This function is a closure
alright because it keeps a reference to `chan` from its environment.

## Partial function applications and currying
Let's define a plus function which just adds two integers:

```ocaml
# let plus a b =
    a + b
val plus : int -> int -> int = <fun>
```
Some questions for people asleep at the back of the class.

1. What is `plus`?
1. What is `plus 2 3`?
1. What is `plus 2`?

Question 1 is easy. `plus` is a function, it takes two arguments which
are integers and it returns an integer. We write its type like this:

```ocaml
# plus
- : int -> int -> int = <fun>
```
Question 2 is even easier. `plus 2 3` is a number, the integer `5`. We
write its value and type like this:

```ocaml
# 5
- : int = 5
```
But what about question 3? It looks like `plus 2` is a mistake, a bug.
In fact, however, it isn't. If we type this into the OCaml toplevel, it
tells us:

```ocaml
# plus 2
- : int -> int = <fun>
```
This isn't an error. It's telling us that `plus 2` is in fact a
*function*, which takes an `int` and returns an `int`. What sort of
function is this? We experiment by first of all giving this mysterious
function a name (`f`), and then trying it out on a few integers to see
what it does:

```ocaml
# let f = plus 2
val f : int -> int = <fun>
# f 10
- : int = 12
# f 15
- : int = 17
# f 99
- : int = 101
```
In engineering this is sufficient [proof by example](humor_proof.html)
for us to state that `plus 2` is the function which adds 2 to things.

Going back to the original definition, let's "fill in" the first
argument (`a`) setting it to 2 to get:

<!-- $MDX skip -->
```ocaml
let plus 2 b =       (* This is not real OCaml code! *)
  2 + b
```
You can kind of see, I hope, why `plus 2` is the function which adds 2
to things.

Looking at the types of these expressions we may be able to see some
rationale for the strange `->` arrow notation used for function types:

```ocaml
# plus
- : int -> int -> int = <fun>
# plus 2
- : int -> int = <fun>
# plus 2 3
- : int = 5
```
This process is called **currying** (or perhaps it's called
**uncurrying**, I never was really sure which was which). It is called
this after Haskell Curry who did some important stuff related to the
lambda calculus. Since I'm trying to avoid entering into the mathematics
behind OCaml because that makes for a very boring and irrelevant
tutorial, I won't go any further on the subject. You can find much more
information about currying if it interests you by [doing a search on
Google](https://www.google.com/search?q=currying "https://www.google.com/search?q=currying").

Remember our `double` and `multiply` functions from earlier on?
`multiply` was defined as this:

```ocaml
# let multiply n list =
  let f x = n * x in
    List.map f list
val multiply : int -> int list -> int list = <fun>
```
We can now define `double`, `triple` &amp;c functions very easily just like
this:

```ocaml
# let double = multiply 2
val double : int list -> int list = <fun>
# let triple = multiply 3
val triple : int list -> int list = <fun>
```
They really are functions, look:

```ocaml
# double [1; 2; 3]
- : int list = [2; 4; 6]
# triple [1; 2; 3]
- : int list = [3; 6; 9]
```

You can also use partial application directly (without the intermediate
`f` function) like this:

```ocaml
# let multiply n = List.map (( * ) n)
val multiply : int -> int list -> int list = <fun>
# let double = multiply 2
val double : int list -> int list = <fun>
# let triple = multiply 3
val triple : int list -> int list = <fun>
# double [1; 2; 3]
- : int list = [2; 4; 6]
# triple [1; 2; 3]
- : int list = [3; 6; 9]
```

In the example above, `(( * ) n)` is the partial application of the `( * )`
(times) function. Note the extra spaces needed so that OCaml doesn't
think `(*` starts a comment.

You can put infix operators into brackets to make functions. Here's an
identical definition of the `plus` function as before:

```ocaml
# let plus = ( + )
val plus : int -> int -> int = <fun>
# plus 2 3
- : int = 5
```
Here's some more currying fun:

```ocaml
# List.map (plus 2) [1; 2; 3]
- : int list = [3; 4; 5]
# let list_of_functions = List.map plus [1; 2; 3]
val list_of_functions : (int -> int) list = [<fun>; <fun>; <fun>]
```

##  What is functional programming good for?
Functional programming, like any good programming technique, is a useful
tool in your armoury for solving some classes of problems. It's very
good for callbacks, which have multiple uses from GUIs through to
event-driven loops. It's great for expressing generic algorithms.
`List.map` is really a generic algorithm for applying functions over any
type of list. Similarly you can define generic functions over trees.
Certain types of numerical problems can be solved more quickly with
functional programming (for example, numerically calculating the
derivative of a mathematical function).

##  Pure and impure functional programming
A **pure function** is one without any **side-effects**. A side-effect
really means that the function keeps some sort of hidden state inside
it. `strlen` is a good example of a pure function in C. If you call
`strlen` with the same string, it always returns the same length. The
output of `strlen` (the length) only depends on the inputs (the string)
and nothing else. Many functions in C are, unfortunately, impure. For
example, `malloc` - if you call it with the same number, it certainly
won't return the same pointer to you. `malloc`, of course, relies on a
huge amount of hidden internal state (objects allocated on the heap, the
allocation method in use, grabbing pages from the operating system,
etc.).

ML-derived languages like OCaml are "mostly pure". They allow
side-effects through things like references and arrays, but by and large
most of the code you'll write will be pure functional because they
encourage this thinking. Haskell, another functional language, is pure
functional. OCaml is therefore more practical because writing impure
functions is sometimes useful.

There are various theoretical advantages of having pure functions. One
advantage is that if a function is pure, then if it is called several
times with the same arguments, the compiler only needs to actually call
the function once. A good example in C is:

```C
for (i = 0; i < strlen (s); ++i)
  {
    // Do something which doesn't affect s.
  }
```
If naively compiled, this loop is O(n<sup>2</sup>) because `strlen (s)`
is called each time and `strlen` needs to iterate over the whole of `s`.
If the compiler is smart enough to work out that `strlen` is pure
functional *and* that `s` is not updated in the loop, then it can remove
the redundant extra calls to `strlen` and make the loop O(n). Do
compilers really do this? In the case of `strlen` yes, in other cases,
probably not.

Concentrating on writing small pure functions allows you to construct
reusable code using a bottom-up approach, testing each small function as
you go along. The current fashion is for carefully planning your
programs using a top-down approach, but in the author's opinion this
often results in projects failing.

##  Strictness vs laziness
C-derived and ML-derived languages are strict. Haskell and Miranda are
non-strict, or lazy, languages. OCaml is strict by default but allows a
lazy style of programming where it is needed.

In a strict language, arguments to functions are always evaluated first,
and the results are then passed to the function. For example in a strict
language, the call `give_me_a_three (1/0)` is always going to result in
a divide-by-zero error:

```ocaml
# let give_me_a_three _ = 3
val give_me_a_three : 'a -> int = <fun>
# give_me_a_three (1/0)
Exception: Division_by_zero.
```

If you've programmed in any conventional language, this is just how
things work, and you'd be surprised that things could work any other
way.

In a lazy language, something stranger happens. Arguments to functions
are only evaluated if the function actually uses them. Remember that the
`give_me_a_three` function throws away its argument and always returns a
3? Well in a lazy language, the above call would *not* fail because
`give_me_a_three` never looks at its first argument, so the first
argument is never evaluated, so the division by zero doesn't happen.

Lazy languages also let you do really odd things like defining an
infinitely long list. Provided you don't actually try to iterate over
the whole list this works (say, instead, that you just try to fetch the
first 10 elements).

OCaml is a strict language, but has a `Lazy` module that lets you write
lazy expressions. Here's an example. First we create a lazy expression
for `1/0`:

```ocaml
# let lazy_expr = lazy (1 / 0)
val lazy_expr : int lazy_t = <lazy>
```

Notice the type of this lazy expression is `int lazy_t`.

Because `give_me_a_three` takes `'a` (any type) we can pass this lazy
expression into the function:

```ocaml
# give_me_a_three lazy_expr
- : int = 3
```

To evaluate a lazy expression, you must use the `Lazy.force` function:

```ocaml
# Lazy.force lazy_expr
Exception: Division_by_zero.
```

##  Boxed vs. unboxed types
One term which you'll hear a lot when discussing functional languages is
"boxed". I was very confused when I first heard this term, but in fact
the distinction between boxed and unboxed types is quite simple if
you've used C, C++ or Java before (in Perl, everything is boxed).

The way to think of a boxed object is to think of an object which has
been allocated on the heap using `malloc` in C (or equivalently `new` in
C++), and/or is referred to through a pointer. Take a look at this
example C program:

```C
#include <stdio.h>

void
printit (int *ptr)
{
  printf ("the number is %d\\n", *ptr);
}

void
main ()
{
  int a = 3;
  int *p = &a;

  printit (p);
}
```

The variable `a` is allocated on the stack, and is quite definitely
unboxed.

The function `printit` takes a boxed integer and prints it.

The diagram below shows an array of unboxed (top) vs. boxed (below)
integers:

![Boxed Array](/tutorials/boxedarray.png "")

No prizes for guessing that the array of unboxed integers is much faster
than the array of boxed integers. In addition, because there are fewer
separate allocations, garbage collection is much faster and simpler on
the array of unboxed objects.

In C or C++ you should have no problems constructing either of the two
types of arrays above. In Java, you have two types, `int` which is
unboxed and `Integer` which is boxed, and hence considerably less
efficient. In OCaml, the basic types are all unboxed.

## Aliases for function names and arguments
It's possible to use this as a neat trick to save typing: aliasing function
names, and function arguments.

Although we haven't looked at object-oriented programming (that's the
subject for the ["Objects" section](objects.html)),
here's an example from OCamlNet of an
aliased function call. All you need to know is that
`cgi # output # output_string "string"` is a method call, similar to
`cgi.output().output_string ("string")` in Java.

<!-- $MDX skip -->
```ocaml
let begin_page cgi title =
  let out = cgi # output # output_string in
  out "<html>\\n";
  out "<head>\\n";
  out ("<title>" ^ text title ^ "</title>\\n");
  out ("<style type=\\"text/css\\">\\n");
  out "body { background: white; color: black; }\\n";
  out "</style>\\n";
  out "</head>\\n";
  out "<body>\\n";
  out ("<h1>" ^ text title ^ "</h1>\\n")
```

The `let out = ... ` is a partial function application for that method
call (partial, because the string parameter hasn't been applied). `out`
is therefore a function, which takes a string parameter.

<!-- $MDX skip -->
```ocaml
out "<html>\\n";
```

is equivalent to:
<!-- $MDX skip -->
```ocaml
cgi # output # output_string "<html>\\n";
```

We saved ourselves a lot of typing there.

We can also add arguments. This alternative definition of `print_string`
can be thought of as a kind of alias for a function name plus arguments:

<!-- $MDX skip -->
```ocaml
let print_string = output_string stdout
```

`output_string` takes two arguments (a channel and a string), but since
we have only supplied one, it is partially applied. So `print_string` is
a function, expecting one string argument.
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#what-is-functional-programming">What is functional programming?</a>
</li>
<li><a href="#partial-function-applications-and-currying">Partial function applications and currying</a>
</li>
<li><a href="#what-is-functional-programming-good-for">What is functional programming good for?</a>
</li>
<li><a href="#pure-and-impure-functional-programming">Pure and impure functional programming</a>
</li>
<li><a href="#strictness-vs-laziness">Strictness vs laziness</a>
</li>
<li><a href="#boxed-vs-unboxed-types">Boxed vs. unboxed types</a>
</li>
<li><a href="#aliases-for-function-names-and-arguments">Aliases for function names and arguments</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<h2 id="what-is-functional-programming">What is functional programming?</h2>
<p>We've got quite far into the tutorial, yet we haven't really considered
<strong>functional programming</strong>. All of the features given so far - rich data
types, pattern matching, type inference, nested functions - you could
imagine could exist in a kind of &quot;super C&quot; language. These are Cool
Features certainly, and make your code concise, easy to read, and have
fewer bugs, but they actually have very little to do with functional
programming. In fact my argument is going to be that the reason that
functional languages are so great is <em>not</em> because of functional
programming, but because we've been stuck with C-like languages for
years and in the meantime the cutting edge of programming has moved on
considerably. So while we were writing
<code>struct { int type; union { ... } }</code> for the umpteenth time, ML and
Haskell programmers had safe variants and pattern matching on datatypes.
While we were being careful to <code>free</code> all our <code>malloc</code>s, there have been
languages with garbage collectors able to outperform hand-coding since
the 80s.</p>
<p>Well, after that I'd better tell you what functional programming is
anyhow.</p>
<p>The basic, and not very enlightening definition is this: in a
<strong>functional language</strong>, <strong>functions</strong> are first-class citizens.</p>
<p>Lot of words there that don't really make much sense. So let's have an
example:</p>
<pre><code class="language-ocaml"># let double x = x * 2 in
    List.map double [1; 2; 3]
- : int list = [2; 4; 6]
</code></pre>
<p>In this example, I've first defined a nested function called <code>double</code>
which takes an argument <code>x</code> and returns <code>x * 2</code>. Then <code>map</code> calls
<code>double</code> on each element of the given list (<code>[1; 2; 3]</code>) to produce the
result: a list with each number doubled.</p>
<p><code>map</code> is known as a <strong>higher-order function</strong> (HOF). Higher-order
functions are just a fancy way of saying that the function takes a
function as one of its arguments. So far so simple. If you're familiar
with C/C++ then this looks like passing a function pointer around.</p>
<p><strong>Closures</strong> are functions which carry around some of the &quot;environment&quot;
in which they were defined. In particular, a closure can reference
variables which were available at the point of its definition. Let's
generalise the function above so that now we can take any list of
integers and multiply each element by an arbitrary value <code>n</code>:</p>
<pre><code class="language-ocaml"># let multiply n list =
    let f x = n * x in
      List.map f list
val multiply : int -&gt; int list -&gt; int list = &lt;fun&gt;
</code></pre>
<p>Hence:</p>
<pre><code class="language-ocaml"># multiply 2 [1; 2; 3]
- : int list = [2; 4; 6]
# multiply 5 [1; 2; 3]
- : int list = [5; 10; 15]
</code></pre>
<p>The important point to note about the <code>multiply</code> function is the nested
function <code>f</code>. This is a closure. Look at how <code>f</code> uses the value of <code>n</code>
which isn't actually passed as an explicit argument to <code>f</code>. Instead <code>f</code>
picks it up from its environment - it's an argument to the <code>multiply</code>
function and hence available within this function.</p>
<p>This might sound straightforward, but let's look a bit closer at that
call to map: <code>List.map f list</code>.</p>
<p><code>map</code> is defined in the <code>List</code> module, far away from the current code.
In other words, we're passing <code>f</code> into a module defined &quot;a long time
ago, in a galaxy far far away&quot;. For all we know that code might pass <code>f</code>
to other modules, or save a reference to <code>f</code> somewhere and call it
later. Whether it does this or not, the closure will ensure that <code>f</code>
always has access back to its parental environment, and to <code>n</code>.</p>
<p>Here's a real example from lablgtk. This is actually a method on a class
(we haven't talked about classes and objects yet, but just think of it
as a function definition for now).</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">class html_skel obj = object (self)
  ...
  ...
  method save_to_channel chan =
    let receiver_fn content =
      output_string chan content;
      true
    in
      save obj receiver_fn
  ...
end
</code></pre>
<p>First of all you need to know that the <code>save</code> function called at the end
of the method takes as its second argument a function (<code>receiver_fn</code>).
It repeatedly calls <code>receiver_fn</code> with snippets of text from the widget
that it's trying to save.</p>
<p>Now look at the definition of <code>receiver_fn</code>. This function is a closure
alright because it keeps a reference to <code>chan</code> from its environment.</p>
<h2 id="partial-function-applications-and-currying">Partial function applications and currying</h2>
<p>Let's define a plus function which just adds two integers:</p>
<pre><code class="language-ocaml"># let plus a b =
    a + b
val plus : int -&gt; int -&gt; int = &lt;fun&gt;
</code></pre>
<p>Some questions for people asleep at the back of the class.</p>
<ol>
<li>What is <code>plus</code>?
</li>
<li>What is <code>plus 2 3</code>?
</li>
<li>What is <code>plus 2</code>?
</li>
</ol>
<p>Question 1 is easy. <code>plus</code> is a function, it takes two arguments which
are integers and it returns an integer. We write its type like this:</p>
<pre><code class="language-ocaml"># plus
- : int -&gt; int -&gt; int = &lt;fun&gt;
</code></pre>
<p>Question 2 is even easier. <code>plus 2 3</code> is a number, the integer <code>5</code>. We
write its value and type like this:</p>
<pre><code class="language-ocaml"># 5
- : int = 5
</code></pre>
<p>But what about question 3? It looks like <code>plus 2</code> is a mistake, a bug.
In fact, however, it isn't. If we type this into the OCaml toplevel, it
tells us:</p>
<pre><code class="language-ocaml"># plus 2
- : int -&gt; int = &lt;fun&gt;
</code></pre>
<p>This isn't an error. It's telling us that <code>plus 2</code> is in fact a
<em>function</em>, which takes an <code>int</code> and returns an <code>int</code>. What sort of
function is this? We experiment by first of all giving this mysterious
function a name (<code>f</code>), and then trying it out on a few integers to see
what it does:</p>
<pre><code class="language-ocaml"># let f = plus 2
val f : int -&gt; int = &lt;fun&gt;
# f 10
- : int = 12
# f 15
- : int = 17
# f 99
- : int = 101
</code></pre>
<p>In engineering this is sufficient <a href="humor_proof.html">proof by example</a>
for us to state that <code>plus 2</code> is the function which adds 2 to things.</p>
<p>Going back to the original definition, let's &quot;fill in&quot; the first
argument (<code>a</code>) setting it to 2 to get:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let plus 2 b =       (* This is not real OCaml code! *)
  2 + b
</code></pre>
<p>You can kind of see, I hope, why <code>plus 2</code> is the function which adds 2
to things.</p>
<p>Looking at the types of these expressions we may be able to see some
rationale for the strange <code>-&gt;</code> arrow notation used for function types:</p>
<pre><code class="language-ocaml"># plus
- : int -&gt; int -&gt; int = &lt;fun&gt;
# plus 2
- : int -&gt; int = &lt;fun&gt;
# plus 2 3
- : int = 5
</code></pre>
<p>This process is called <strong>currying</strong> (or perhaps it's called
<strong>uncurrying</strong>, I never was really sure which was which). It is called
this after Haskell Curry who did some important stuff related to the
lambda calculus. Since I'm trying to avoid entering into the mathematics
behind OCaml because that makes for a very boring and irrelevant
tutorial, I won't go any further on the subject. You can find much more
information about currying if it interests you by <a href="https://www.google.com/search?q=currying" title="https://www.google.com/search?q=currying">doing a search on
Google</a>.</p>
<p>Remember our <code>double</code> and <code>multiply</code> functions from earlier on?
<code>multiply</code> was defined as this:</p>
<pre><code class="language-ocaml"># let multiply n list =
  let f x = n * x in
    List.map f list
val multiply : int -&gt; int list -&gt; int list = &lt;fun&gt;
</code></pre>
<p>We can now define <code>double</code>, <code>triple</code> &amp;c functions very easily just like
this:</p>
<pre><code class="language-ocaml"># let double = multiply 2
val double : int list -&gt; int list = &lt;fun&gt;
# let triple = multiply 3
val triple : int list -&gt; int list = &lt;fun&gt;
</code></pre>
<p>They really are functions, look:</p>
<pre><code class="language-ocaml"># double [1; 2; 3]
- : int list = [2; 4; 6]
# triple [1; 2; 3]
- : int list = [3; 6; 9]
</code></pre>
<p>You can also use partial application directly (without the intermediate
<code>f</code> function) like this:</p>
<pre><code class="language-ocaml"># let multiply n = List.map (( * ) n)
val multiply : int -&gt; int list -&gt; int list = &lt;fun&gt;
# let double = multiply 2
val double : int list -&gt; int list = &lt;fun&gt;
# let triple = multiply 3
val triple : int list -&gt; int list = &lt;fun&gt;
# double [1; 2; 3]
- : int list = [2; 4; 6]
# triple [1; 2; 3]
- : int list = [3; 6; 9]
</code></pre>
<p>In the example above, <code>(( * ) n)</code> is the partial application of the <code>( * )</code>
(times) function. Note the extra spaces needed so that OCaml doesn't
think <code>(*</code> starts a comment.</p>
<p>You can put infix operators into brackets to make functions. Here's an
identical definition of the <code>plus</code> function as before:</p>
<pre><code class="language-ocaml"># let plus = ( + )
val plus : int -&gt; int -&gt; int = &lt;fun&gt;
# plus 2 3
- : int = 5
</code></pre>
<p>Here's some more currying fun:</p>
<pre><code class="language-ocaml"># List.map (plus 2) [1; 2; 3]
- : int list = [3; 4; 5]
# let list_of_functions = List.map plus [1; 2; 3]
val list_of_functions : (int -&gt; int) list = [&lt;fun&gt;; &lt;fun&gt;; &lt;fun&gt;]
</code></pre>
<h2 id="what-is-functional-programming-good-for">What is functional programming good for?</h2>
<p>Functional programming, like any good programming technique, is a useful
tool in your armoury for solving some classes of problems. It's very
good for callbacks, which have multiple uses from GUIs through to
event-driven loops. It's great for expressing generic algorithms.
<code>List.map</code> is really a generic algorithm for applying functions over any
type of list. Similarly you can define generic functions over trees.
Certain types of numerical problems can be solved more quickly with
functional programming (for example, numerically calculating the
derivative of a mathematical function).</p>
<h2 id="pure-and-impure-functional-programming">Pure and impure functional programming</h2>
<p>A <strong>pure function</strong> is one without any <strong>side-effects</strong>. A side-effect
really means that the function keeps some sort of hidden state inside
it. <code>strlen</code> is a good example of a pure function in C. If you call
<code>strlen</code> with the same string, it always returns the same length. The
output of <code>strlen</code> (the length) only depends on the inputs (the string)
and nothing else. Many functions in C are, unfortunately, impure. For
example, <code>malloc</code> - if you call it with the same number, it certainly
won't return the same pointer to you. <code>malloc</code>, of course, relies on a
huge amount of hidden internal state (objects allocated on the heap, the
allocation method in use, grabbing pages from the operating system,
etc.).</p>
<p>ML-derived languages like OCaml are &quot;mostly pure&quot;. They allow
side-effects through things like references and arrays, but by and large
most of the code you'll write will be pure functional because they
encourage this thinking. Haskell, another functional language, is pure
functional. OCaml is therefore more practical because writing impure
functions is sometimes useful.</p>
<p>There are various theoretical advantages of having pure functions. One
advantage is that if a function is pure, then if it is called several
times with the same arguments, the compiler only needs to actually call
the function once. A good example in C is:</p>
<pre><code class="language-C">for (i = 0; i &lt; strlen (s); ++i)
  {
    // Do something which doesn't affect s.
  }
</code></pre>
<p>If naively compiled, this loop is O(n<sup>2</sup>) because <code>strlen (s)</code>
is called each time and <code>strlen</code> needs to iterate over the whole of <code>s</code>.
If the compiler is smart enough to work out that <code>strlen</code> is pure
functional <em>and</em> that <code>s</code> is not updated in the loop, then it can remove
the redundant extra calls to <code>strlen</code> and make the loop O(n). Do
compilers really do this? In the case of <code>strlen</code> yes, in other cases,
probably not.</p>
<p>Concentrating on writing small pure functions allows you to construct
reusable code using a bottom-up approach, testing each small function as
you go along. The current fashion is for carefully planning your
programs using a top-down approach, but in the author's opinion this
often results in projects failing.</p>
<h2 id="strictness-vs-laziness">Strictness vs laziness</h2>
<p>C-derived and ML-derived languages are strict. Haskell and Miranda are
non-strict, or lazy, languages. OCaml is strict by default but allows a
lazy style of programming where it is needed.</p>
<p>In a strict language, arguments to functions are always evaluated first,
and the results are then passed to the function. For example in a strict
language, the call <code>give_me_a_three (1/0)</code> is always going to result in
a divide-by-zero error:</p>
<pre><code class="language-ocaml"># let give_me_a_three _ = 3
val give_me_a_three : 'a -&gt; int = &lt;fun&gt;
# give_me_a_three (1/0)
Exception: Division_by_zero.
</code></pre>
<p>If you've programmed in any conventional language, this is just how
things work, and you'd be surprised that things could work any other
way.</p>
<p>In a lazy language, something stranger happens. Arguments to functions
are only evaluated if the function actually uses them. Remember that the
<code>give_me_a_three</code> function throws away its argument and always returns a
3? Well in a lazy language, the above call would <em>not</em> fail because
<code>give_me_a_three</code> never looks at its first argument, so the first
argument is never evaluated, so the division by zero doesn't happen.</p>
<p>Lazy languages also let you do really odd things like defining an
infinitely long list. Provided you don't actually try to iterate over
the whole list this works (say, instead, that you just try to fetch the
first 10 elements).</p>
<p>OCaml is a strict language, but has a <code>Lazy</code> module that lets you write
lazy expressions. Here's an example. First we create a lazy expression
for <code>1/0</code>:</p>
<pre><code class="language-ocaml"># let lazy_expr = lazy (1 / 0)
val lazy_expr : int lazy_t = &lt;lazy&gt;
</code></pre>
<p>Notice the type of this lazy expression is <code>int lazy_t</code>.</p>
<p>Because <code>give_me_a_three</code> takes <code>'a</code> (any type) we can pass this lazy
expression into the function:</p>
<pre><code class="language-ocaml"># give_me_a_three lazy_expr
- : int = 3
</code></pre>
<p>To evaluate a lazy expression, you must use the <code>Lazy.force</code> function:</p>
<pre><code class="language-ocaml"># Lazy.force lazy_expr
Exception: Division_by_zero.
</code></pre>
<h2 id="boxed-vs-unboxed-types">Boxed vs. unboxed types</h2>
<p>One term which you'll hear a lot when discussing functional languages is
&quot;boxed&quot;. I was very confused when I first heard this term, but in fact
the distinction between boxed and unboxed types is quite simple if
you've used C, C++ or Java before (in Perl, everything is boxed).</p>
<p>The way to think of a boxed object is to think of an object which has
been allocated on the heap using <code>malloc</code> in C (or equivalently <code>new</code> in
C++), and/or is referred to through a pointer. Take a look at this
example C program:</p>
<pre><code class="language-C">#include &lt;stdio.h&gt;

void
printit (int *ptr)
{
  printf (&quot;the number is %d\\n&quot;, *ptr);
}

void
main ()
{
  int a = 3;
  int *p = &amp;a;

  printit (p);
}
</code></pre>
<p>The variable <code>a</code> is allocated on the stack, and is quite definitely
unboxed.</p>
<p>The function <code>printit</code> takes a boxed integer and prints it.</p>
<p>The diagram below shows an array of unboxed (top) vs. boxed (below)
integers:</p>
<p><img src="/tutorials/boxedarray.png" alt="Boxed Array" title="" /></p>
<p>No prizes for guessing that the array of unboxed integers is much faster
than the array of boxed integers. In addition, because there are fewer
separate allocations, garbage collection is much faster and simpler on
the array of unboxed objects.</p>
<p>In C or C++ you should have no problems constructing either of the two
types of arrays above. In Java, you have two types, <code>int</code> which is
unboxed and <code>Integer</code> which is boxed, and hence considerably less
efficient. In OCaml, the basic types are all unboxed.</p>
<h2 id="aliases-for-function-names-and-arguments">Aliases for function names and arguments</h2>
<p>It's possible to use this as a neat trick to save typing: aliasing function
names, and function arguments.</p>
<p>Although we haven't looked at object-oriented programming (that's the
subject for the <a href="objects.html">&quot;Objects&quot; section</a>),
here's an example from OCamlNet of an
aliased function call. All you need to know is that
<code>cgi # output # output_string &quot;string&quot;</code> is a method call, similar to
<code>cgi.output().output_string (&quot;string&quot;)</code> in Java.</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let begin_page cgi title =
  let out = cgi # output # output_string in
  out &quot;&lt;html&gt;\\n&quot;;
  out &quot;&lt;head&gt;\\n&quot;;
  out (&quot;&lt;title&gt;&quot; ^ text title ^ &quot;&lt;/title&gt;\\n&quot;);
  out (&quot;&lt;style type=\\&quot;text/css\\&quot;&gt;\\n&quot;);
  out &quot;body { background: white; color: black; }\\n&quot;;
  out &quot;&lt;/style&gt;\\n&quot;;
  out &quot;&lt;/head&gt;\\n&quot;;
  out &quot;&lt;body&gt;\\n&quot;;
  out (&quot;&lt;h1&gt;&quot; ^ text title ^ &quot;&lt;/h1&gt;\\n&quot;)
</code></pre>
<p>The <code>let out = ... </code> is a partial function application for that method
call (partial, because the string parameter hasn't been applied). <code>out</code>
is therefore a function, which takes a string parameter.</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">out &quot;&lt;html&gt;\\n&quot;;
</code></pre>
<p>is equivalent to:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">cgi # output # output_string &quot;&lt;html&gt;\\n&quot;;
</code></pre>
<p>We saved ourselves a lot of typing there.</p>
<p>We can also add arguments. This alternative definition of <code>print_string</code>
can be thought of as a kind of alias for a function name plus arguments:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let print_string = output_string stdout
</code></pre>
<p><code>output_string</code> takes two arguments (a channel and a string), but since
we have only supplied one, it is partially applied. So <code>print_string</code> is
a function, expecting one string argument.</p>
|js}
  };
 
  { title = {js|If Statements, Loops and Recursions|js}
  ; slug = {js|if-statements-loops-and-recursions|js}
  ; description = {js|Learn basic control-flow and recursion in OCaml
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["language"]
  ; users = [`Beginner; `Intermediate]
  ; body_md = {js|
## If statements (actually, these are if expressions)
OCaml has an `if` statement with two variations, and the obvious meaning:

<!-- $MDX skip -->
```ocaml
if boolean-condition then expression
  
if boolean-condition then expression else other-expression
```

Unlike in the conventional languages you'll be used to, `if` statements
are really expressions. In other words, they're much more like
`boolean-condition ? expression : other-expression` in C than like the if
statements you may be used to.

Here's a simple example of an `if` statement:

```ocaml
# let max a b =
  if a > b then a else b
val max : 'a -> 'a -> 'a = <fun>
```

As a short aside, if you type this into the OCaml
interactive toplevel (as above), you'll
notice that OCaml decides that this function is polymorphic, with the
following type:

```ocaml
# max
- : 'a -> 'a -> 'a = <fun>
```

And indeed OCaml lets you use `max` on any type:

```ocaml
# max 3 5
- : int = 5
# max 3.5 13.0
- : float = 13.
# max "a" "b"
- : string = "b"
```

This is because `>` is in fact polymorphic. It works on any type, even
objects (it does a binary comparison).

\\[Note that the `Stdlib` module defines `min` and `max` for you.\\]

Let's look a bit more closely at the `if` expression. Here's the `range`
function which I showed you earlier without much explanation. You should
be able to combine your knowledge of recursive functions, lists and if
expressions to see what it does:

```ocaml
# let rec range a b =
    if a > b then []
    else a :: range (a + 1) b
val range : int -> int -> int list = <fun>
```

Let's examine some typical calls to this function. Let's start with the
easy case of `a > b`. A call to `range 11 10` returns `[]` (the empty
list) and that's it.

What about calling `range 10 10`? Since `10 > 10` is false, the
`else`-clause is evaluated, which is: `10 :: (range 11 10)` (I've added
the brackets to make the order of evaluation more clear). We've just
worked out that `range 11 10` = `[]`, so this is: `10 :: []`. Remember
our formal description of lists and the `::` (cons) operator? `10 :: []`
is just the same as `[10]`.

Let's try `range 9 10`:

<!-- $MDX skip -->
```ocaml
range 9 10
→ 9 :: (range 10 10)
→ 9 :: [10]
→ [9; 10]
```

It should be fairly clear that `range 1 10` evaluates to
`[1; 2; 3; 4; 5; 6; 7; 8; 9; 10]`.

What we've got here is a simple case of recursion. Functional
programming can be said to prefer recursion over loops, but I'm jumping
ahead of myself. We'll discuss recursion more at the end of this
chapter.

Back, temporarily, to `if` statements. What does this function do?

```ocaml
# let f x y =
    x + if y > 0 then y else 0
val f : int -> int -> int = <fun>
```

Clue: add brackets around the whole of the if expression. It clips `y`
like an [electronic diode](https://en.wikipedia.org/wiki/Diode#Current.E2.80.93voltage_characteristic).

The `abs` (absolute value) function is defined in `Stdlib` as:

```ocaml
# let abs x =
    if x >= 0 then x else -x
val abs : int -> int = <fun>
```

Also in `Stdlib`, the `string_of_float` function contains a complex
pair of nested `if` expressions:

<!-- $MDX skip -->
```ocaml
let string_of_float f =
  let s = format_float "%.12g" f in
  let l = string_length s in
  let rec loop i =
    if i >= l then s ^ "."
    else if s.[i] = '.' || s.[i] = 'e' then s
    else loop (i + 1)
  in
    loop 0
```

Let's examine this function. Suppose the function is called with `f` =
12.34. Then `s` = "12.34", and `l` = 5. We call `loop` the first time
with `i` = 0.

`i` is not greater than or equal to `l`, and `s.[i]` (the
`i`<sup>th</sup> character in `s`) is not a period or `'e'`. So
`loop (i + 1)` is called, ie. `loop 1`.

We go through the same dance for `i` = 1, and end up calling `loop 2`.

For `i` = 2, however, `s.[i]` is a period (refer to the original string,
`s` = "12.34"). So this immediately returns `s`, and the function
`string_of_float` returns "12.34".

What is `loop` doing? In fact it's checking whether the string returned
from `format_float` contains a period (or `'e'`). Suppose that we called
`string_of_float` with `12.0`. `format_float` would return the string
"12", but `string_of_float` must return "12." or "12.0" (because
floating point constants in OCaml must contain a period to differentiate
them from integer constants). Hence the check.

The strange use of recursion in this function is almost certainly for
efficiency. OCaml supports for loops, so why didn't the authors use for
loops? We'll see in the next section that OCaml's for loops are limited
in a way which prevents them from being used in `string_of_float`. Here,
however, is a more straightforward, but approximately twice as slow, way
of writing `string_of_float`:

<!-- $MDX skip -->
```ocaml
let string_of_float f =
  let s = format_float "%.12g" f in
    if String.contains s '.' || String.contains s 'e'
      then s
      else s ^ "."
```

## Using begin ... end
Here is some code from lablgtk:

<!-- $MDX skip -->
```ocaml
if GtkBase.Object.is_a obj cls then
  fun _ -> f obj
else begin
  eprintf "Glade-warning: %s expects a %s argument.\\n" name cls;
  raise Not_found
end
```

`begin` and `end` are what is known as **syntactic sugar** for open and
close parentheses. In the example above, all they do is group the two
statements in the `else`-clause together. Suppose the author had written
this instead:

<!-- $MDX skip -->
```ocaml
if GtkBase.Object.is_a obj cls then
  fun _ -> f obj
else
  eprintf "Glade-warning: %s expects a %s argument.\\n" name cls;
  raise Not_found
```
Fully bracketing and properly indenting the above expression gives:

<!-- $MDX skip -->
```ocaml
(if GtkBase.Object.is_a obj cls then
   fun _ -> f obj
 else
   eprintf "Glade-warning: %s expects a %s argument.\\n" name cls
);
raise Not_found
```
Not what was intended at all. So the `begin` and `end` are necessary to
group together multiple statements in a `then` or `else` clause of an if
expression. You can also use plain ordinary parentheses `( ... )` if you
prefer (and I do prefer, because I **loathe** Pascal :-). Here are two
simple examples:

```ocaml
# if 1 = 0 then
    print_endline "THEN"
  else begin
    print_endline "ELSE";
    failwith "else clause"
  end
ELSE
Exception: Failure "else clause".
# if 1 = 0 then
    print_endline "THEN"
  else (
    print_endline "ELSE";
    failwith "else clause"
  )
ELSE
Exception: Failure "else clause".
```

## For loops and while loops
OCaml supports a rather limited form of the familiar `for` loop:

<!-- $MDX skip -->
```ocaml
for variable = start_value to end_value do
  expression
done
  
for variable = start_value downto end_value do
  expression
done
```
A simple but real example from lablgtk:

<!-- $MDX skip -->
```ocaml
for i = 1 to n_jobs () do
  do_next_job ()
done
```
In OCaml, `for` loops are just shorthand for writing:

<!-- $MDX skip -->
```ocaml
let i = 1 in
do_next_job ();
let i = 2 in
do_next_job ();
let i = 3 in
do_next_job ();
  ...
let i = n_jobs () in
do_next_job ();
()
```

OCaml doesn't support the concept of breaking out of a `for` loop early
i.e. it has no `break`, `continue` or `last` statements. (You *could*
throw an exception and catch it outside, and this would run fast but
often looks clumsy.)

The expression inside an OCaml for loop should evaluate to `unit`
(otherwise you'll get a warning), and the for loop expression as a whole
returns `unit`:

```ocaml
# for i = 1 to 10 do i done
Line 1, characters 20-21:
Warning 10: this expression should have type unit.
- : unit = ()
```
Functional programmers tend to use recursion instead of explicit loops,
and regard **for** loops with suspicion since it can't return anything,
hence OCaml's relatively powerless **for** loop. We talk about recursion
below.

**While loops** in OCaml are written:

<!-- $MDX skip -->
```ocaml
while boolean-condition do
  expression
done
```
As with for loops, there is no way provided by the language to break out
of a while loop, except by throwing an exception, and this means that
while loops have fairly limited use. Again, remember that functional
programmers like recursion, and so while loops are second-class citizens
in the language.

If you stop to consider while loops, you may see that they aren't really
any use at all, except in conjunction with our old friend references.
Let's imagine that OCaml didn't have references for a moment:

<!-- $MDX skip -->
```ocaml
let quit_loop = false in
  while not quit_loop do
    print_string "Have you had enough yet? (y/n) ";
    let str = read_line () in
      if str.[0] = 'y' then
        (* how do I set quit_loop to true ?!? *)
  done
```
Remember that `quit_loop` is not a real "variable" - the let-binding
just makes `quit_loop` a shorthand for `false`. This means the while
loop condition (shown in red) is always true, and the loop runs on
forever!

Luckily OCaml *does have* references, so we can write the code above if
we want. Don't get confused and think that the `!` (exclamation mark)
means "not" as in C/Java. It's used here to mean "dereference the
pointer", similar in fact to Forth. You're better off reading `!` as
"get" or "deref".

<!-- $MDX skip -->
```ocaml
let quit_loop = ref false in
  while not !quit_loop do
    print_string "Have you had enough yet? (y/n) ";
    let str = read_line () in
      if str.[0] = 'y' then quit_loop := true
  done;;
```

## Looping over lists
If you want to loop over a list, don't be an imperative programmer and
reach for your trusty six-shooter Mr. For Loop! OCaml has some better
and faster ways to loop over lists, and they are all located in the
`List` module. There are in fact dozens of good functions in `List`, but
I'll only talk about the most useful ones here.

First off, let's define a list for us to use:

```ocaml
# let my_list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]
val my_list : int list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]
```

If you want to call a function once on every element of the list, use
`List.iter`, like this:

```ocaml
# let f elem =
    Printf.printf "I'm looking at element %d now\\n" elem
  in
    List.iter f my_list
I'm looking at element 1 now
I'm looking at element 2 now
I'm looking at element 3 now
I'm looking at element 4 now
I'm looking at element 5 now
I'm looking at element 6 now
I'm looking at element 7 now
I'm looking at element 8 now
I'm looking at element 9 now
I'm looking at element 10 now
- : unit = ()
```

`List.iter` is in fact what you should think about using first every
time your cerebellum suggests you use a for loop.

If you want to *transform* each element separately in the list - for
example, doubling each element in the list - then use `List.map`.

```ocaml
# List.map (( * ) 2) my_list
- : int list = [2; 4; 6; 8; 10; 12; 14; 16; 18; 20]
```

The function `List.filter` collects only those elements of a list which satisfy
some condition - e.g. returning all even numbers in a list.

```ocaml
# let is_even i =
    i mod 2 = 0
  in
    List.filter is_even my_list
- : int list = [2; 4; 6; 8; 10]
```

To find out if a list contains some element, use `List.mem` (short for
member):

```ocaml
# List.mem 12 my_list
- : bool = false
```

`List.for_all` and `List.exists` are the same as the "forall" and
"exist" operators in predicate logic.

For operating over two lists at the same time, there are "-2" variants
of some of these functions, namely `iter2`, `map2`, `for_all2`,
`exists2`.

The `map` and `filter` functions operate on individual list elements in
isolation. **Fold** is a more unusual operation that is best
thought about as "inserting an operator between each element of the
list". Suppose I wanted to add all the numbers in my list together. In
hand-waving terms what I want to do is insert a plus sign between the
elements in my list:

```ocaml
# 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 10
- : int = 55
```

The fold operation does this, although the exact details are a little
bit more tricky. First of all, what happens if I try to fold an empty
list? In the case of summing the list it would be nice if the answer was
zero, instead of error. However if I was trying to find the product of
the list, I'd like the answer to be one instead. So I obviously have to
provide some sort of "default" argument to my fold. The second issue
doesn't arise with simple operators like `+` and `*`: what happens if
the operator I'm using isn't associative, ie. (a *op* b) *op* c not
equal to a *op* (b *op* c)? In that case it would matter if I started
from the left hand end of the list and worked right, versus if I started
from the right and worked left. For this reason there are two versions
of fold, called `List.fold_left` (works left to right) and
`List.fold_right` (works right to left, and is also less efficient).

Let's use `List.fold_left` to define `sum` and `product` functions for
integer lists:

```ocaml
# let sum = List.fold_left ( + ) 0
val sum : int list -> int = <fun>
# let product = List.fold_left ( * ) 1
val product : int list -> int = <fun>
# sum my_list
- : int = 55
# product my_list
- : int = 3628800
```

That was easy! Notice that I've accidentally come up with a way to do
mathematical factorials:

```ocaml
# let fact n = product (range 1 n)
val fact : int -> int = <fun>
# fact 10
- : int = 3628800
```

(Notice that this factorial function isn't very useful because it
overflows the integers and gives wrong answers even for quite small
values of `n`.)

## Looping over strings
The `String` module also contains many dozens of useful string-related
functions, and some of them are concerned with looping over strings.

`String.copy` copies a string, like `strdup`. There is also a `String.iter`
function which works like `List.iter`, except over the characters of the
string.

## Recursion
Now we come to a hard topic - recursion. Functional programmers are
defined by their love of recursive functions, and in many ways recursive
functions in f.p. are the equivalent of loops in imperative programming.
In functional languages loops are second-class citizens, whilst
recursive functions get all the best support.

Writing recursive functions requires a change in mindset from writing
for loops and while loops. So what I'll give you in this section will be
just an introduction and examples.

In the first example we're going to read the whole of a file into memory
(into a long string). There are essentially three possible approaches to
this:

###  Approach 1
Get the length of the file, and read it all in one go using the
`really_input` method. This is the simplest, but it might not work on
channels which are not really files (eg. reading keyboard input) which
is why we look at the other two approaches.

###  Approach 2
The imperative approach, using a while loop which is broken out of using
an exception.

###  Approach 3
A recursive loop, breaking out of the recursion again using an
exception.

We're going to introduce a few new concepts here. Our second two
approaches will use the `Buffer` module - an expandable buffer which you
can think of like a string onto which you can efficiently append more
text at the end. We're also going to be catching the `End_of_file`
exception which the input functions throw when they reach the end of the
input. Also we're going to use `Sys.argv.(1)` to get the first command
line parameter.

```ocaml
(* Read whole file: Approach 1 *)
open Printf
  
let read_whole_chan chan =
  let len = in_channel_length chan in
  let result = (Bytes.create len) in
    really_input chan result 0 len;
    (Bytes.to_string result)
  
let read_whole_file filename =
  let chan = open_in filename in
    read_whole_chan chan
  
let main () =
  let filename = Sys.argv.(1) in
  let str = read_whole_file filename in
    printf "I read %d characters from %s\\n" (String.length str) filename
```

Approach 1 works but is not very satisfactory because `read_whole_chan`
won't work on non-file channels like keyboard input or sockets. Approach
2 involves a while loop:

```ocaml
(* Read whole file: Approach 2 *)
open Printf
  
let read_whole_chan chan =
  let buf = Buffer.create 4096 in
  try
    while true do
      let line = input_line chan in
        Buffer.add_string buf line;
        Buffer.add_char buf '\\n'
    done;
    assert false (* This is never executed
	                (always raises Assert_failure). *)
  with
    End_of_file -> Buffer.contents buf
  
let read_whole_file filename =
  let chan = open_in filename in
    read_whole_chan chan
  
let main () =
  let filename = Sys.argv.(1) in
  let str = read_whole_file filename in
    printf "I read %d characters from %s\\n" (String.length str) filename
```

The key to approach 2 is to look at the central while loop. Remember
that I said the only way to break out of a while loop early was with an
exception? This is exactly what we're doing here. Although I haven't
covered exceptions yet, you probably won't have any trouble
understanding the `End_of_file` exception thrown in the code above by
`input_line` when it hits the end of the file. The buffer `buf`
accumulates the contents of the file, and when we hit the end of the
file we return it (`Buffer.contents buf`).

One curious point about this is the apparently superfluous statement
(`assert false`) just after the while loop. What is it for?  Remember
that while loops, like for loops, are just expressions, and they return
the `unit` object (`()`). However OCaml demands that the return type
inside a `try` matches the return type of each caught exception. In this
case because `End_of_file` results in a `string`, the main body of the
`try` must also "return" a string — even though because of the infinite
while loop the string could never actually be returned.  `assert false`
has a polymorphic type, so will unify with whatever value is returned
by the `with` branch.

Here's our recursive version. Notice that it's *shorter* than approach
2, but not so easy to understand for imperative programmers at least:

```ocaml
(* Read whole file: Approach 3 *)
open Printf
  
let read_whole_chan chan =
  let buf = Buffer.create 4096 in
  let rec loop () =
    let line = input_line chan in
      Buffer.add_string buf line;
      Buffer.add_char buf '\\n';
      loop ()
  in
    try loop () with
      End_of_file -> Buffer.contents buf
  
let read_whole_file filename =
  let chan = open_in filename in
    read_whole_chan chan
  
let main () =
  let filename = Sys.argv.(1) in
  let str = read_whole_file filename in
  printf "I read %d characters from %s\\n" (String.length str) filename
```

Again we have an infinite loop - but in this case done using recursion.
`loop` calls itself at the end of the function. The infinite recursion
is broken when `input_line` throws an `End_of_file` exception.

It looks like approach 3 might overflow the stack if you gave it a
particularly large file, but this is in fact not the case. Because of
tail recursion (discussed below) the compiler will turn the recursive
`loop` function into a real while loop (!) which runs in constant stack
space.

In the next example we will show how recursion is great for constructing
or examining certain types of data structures, particularly trees. Let's
have a recursive type to represent files in a filesystem:

```ocaml
# type filesystem = File of string | Directory of filesystem list
type filesystem = File of string | Directory of filesystem list
```

The `opendir` and `readdir` functions are used to open a directory and
read elements from the directory. I'm going to define a handy
`readdir_no_ex` function which hides the annoying `End_of_file`
exception that `readdir` throws when it reaches the end of the
directory:

```ocaml
# #load "unix.cma"
# open Unix
# let readdir_no_ex dirh =
  try
    Some (readdir dirh)
  with
    End_of_file -> None
val readdir_no_ex : dir_handle -> string option = <fun>
```
The type of `readdir_no_ex` is this. Recall our earlier discussion about
null pointers.

```ocaml
# readdir_no_ex
- : dir_handle -> string option = <fun>
```

I'm also going to define a simple recursive function which I can use to
convert the `filesystem` type into a string for (eg) printing:

```ocaml
# let rec string_of_filesystem fs =
  match fs with
  | File filename -> filename ^ "\\n"
  | Directory fs_list ->
      List.fold_left (^) "" (List.map string_of_filesystem fs_list)
val string_of_filesystem : filesystem -> string = <fun>
```

Note the use of `fold_left` and `map`. The `map` is used to
(recursively) convert each `filesystem` in the list into a `string`.
Then the `fold_left (^) ""` concatenates the list together into one big
string. Notice also the use of pattern matching. (The library defines a
function called `String.concat` which is essentially equivalent to
`fold_left (^) `, but implemented more efficiently).

Now let's define a function to read a directory structure, recursively,
and return a recursive `filesystem` data structure. I'm going to show
this function in steps, but I'll print out the entire function at the
end of this section. First the outline of the function:

<!-- $MDX skip -->
```ocaml
let rec read_directory path =
  let dirh = opendir path in
  let rec loop () =
    (* ..... *) in
  Directory (loop ())
```

The call to `opendir` opens up the given path and returns a `dir_handle`
from which we will be able to read the names using `readdir_no_ex`
later. The return value of the function is going to be a
`Directory fs_list`, so all we need to do to complete the function is to
write our function `loop` which returns a list of `filesystem`s. The
type of `loop` will be:

<!-- $MDX skip -->
```ocaml
loop : unit -> filesystem list
```

How do we define loop? Let's take it in steps again.

<!-- $MDX skip -->
```ocaml
let rec loop () =
  let filename = readdir_no_ex dirh in
  (* ..... *)
```

First we read the next filename from the directory handle. `filename`
has type `string option`, in other words it could be `None` or
`Some "foo"` where `foo` is the name of the next filename in the
directory. We also need to ignore the `"."` and `".."` files (ie. the
current directory and the parent directory). We can do all this with a
nice pattern match:

<!-- $MDX skip -->
```ocaml
let rec loop () =
  let filename = readdir_no_ex dirh in
    match filename with
    | None -> []
    | Some "." -> loop ()
    | Some ".." -> loop ()
    | Some filename ->
        (* ..... *)
```

The `None` case is easy. Thinking recursively (!) if `loop` is called
and we've reached the end of the directory, `loop` needs to return a
list of entries - and there's no entries - so it returns the empty list
(`[]`).

For `"."` and `".."` we just ignore the file and call `loop` again.

What do we do when `loop` reads a real filename (the `Some filename`
match below)? Let `pathname` be the full path to the file. We 'stat' the
file to see if it's really a directory. If it *is* a directory, we set
`this` by recursively calling `read_directory` which will return
`Directory something`. Notice that the overall result of
`read_directory` is `Directory (loop ())`. If the file is really a file
(not a directory) then we let `this` be `File pathname`. Then we do
something clever: we return `this :: loop ()`. This is the recursive
call to `loop ()` to calculate the remaining directory members (a list),
to which we prepend `this`.

```ocaml
# let rec read_directory path =
  let dirh = opendir path in
  let rec loop () =
    let filename = readdir_no_ex dirh in
      match filename with
      | None -> []
      | Some "." -> loop ()
      | Some ".." -> loop ()
      | Some filename ->
          let pathname = path ^ "/" ^ filename in
          let stat = lstat pathname in
          let this =
            if stat.st_kind = S_DIR then
              read_directory pathname
            else
              File pathname
          in
            this :: loop ()
  in
    Directory (loop ())
val read_directory : string -> filesystem = <fun>
```

That's quite a complex bit of recursion, but although this is a made-up
example, it's fairly typical of the complex patterns of recursion found
in real-world functional programs. The two important lessons to take
away from this are:

* The use of recursion to build a list:

    <!-- $MDX skip -->
    ```ocaml
    let rec loop () =
      a match or if statement
      | base case -> []
      | recursive case -> element :: loop ()
    ```
    Compare this to our previous `range` function. The pattern of recursion
    is exactly the same:
    
    ```ocaml
    # let rec range a b =
      if a > b then []            (* Base case *)
      else a :: range (a + 1) b     (* Recursive case *)
    ```
	
* The use of recursion to build up trees:

    <!-- $MDX skip -->
    ```ocaml
    let rec read_directory path =
      (* blah blah *)
      if file-is-a-directory then
        read_directory path-to-file
      else
        Leaf file
    ```
    All that remains now to make this a working program is a little bit of
    code to call `read_directory` and display the result:
    
    <!-- $MDX skip -->
    ```ocaml
    let path = Sys.argv.(1) in
    let fs = read_directory path in
    print_endline (string_of_filesystem fs)
    ```

###  Recursion example: maximum element in a list
Remember the basic recursion pattern for lists:

<!-- $MDX skip -->
```ocaml
let rec loop () =
  a match or if statement
  | base case -> []
  | recursive case -> element :: loop ()
```
The key here is actually the use of the match / base case / recursive
case pattern. In this example - finding the maximum element in a list -
we're going to have two base cases and one recursive case. But before I
jump ahead to the code, let's just step back and think about the
problem. By thinking about the problem, the solution will appear "as if
by magic" (I promise you :-)

First of all, let's be clear that the maximum element of a list is just
the biggest one, e.g. the maximum element of the list `[1; 2; 3; 4; 1]`
is `4`.

Are there any special cases? Yes, there are. What's the maximum element
of the empty list `[]`? There *isn't one*. If we are passed an empty
list, we should throw an error.

What's the maximum element of a single element list such as `[4]`?
That's easy: it's just the element itself. So `list_max [4]` should
return `4`, or in the general case, `list_max [x]` should return `x`.

What's the maximum element of the general list `x :: remainder` (this is
the "cons" notation for the list, so `remainder` is the tail - also a
list)?

Think about this for a while. Suppose you know the maximum element of
`remainder`, which is, say, `y`. What's the maximum element of
`x :: remainder`? It depends on whether `x > y` or `x <= y`. If `x` is
bigger than `y`, then the overall maximum is `x`, whereas conversely if
`x` is less than `y`, then the overall maximum is `y`.

Does this really work? Consider `[1; 2; 3; 4; 1]` again. This is
`1 :: [2; 3; 4; 1]`. Now the maximum element of the remainder,
`[2; 3; 4; 1]`, is `4`. So now we're interested in `x = 1` and `y = 4`.
That head element `x = 1` doesn't matter because `y = 4` is bigger, so
the overall maximum of the whole list is `y = 4`.

Let's now code those rules above up, to get a working function:

```ocaml
# let rec list_max xs =
  match xs with
  | [] -> (* empty list: fail *)
      failwith "list_max called on empty list"
  | [x] -> (* single element list: return the element *)
      x
  | x :: remainder -> (* multiple element list: recursive case *)
      max x (list_max remainder)
val list_max : 'a list -> 'a = <fun>
```
I've added comments so you can see how the rules / special cases we
decided upon above really correspond to lines of code.

Does it work?

```ocaml
# list_max [1; 2; 3; 4; 1]
- : int = 4
# list_max []
Exception: Failure "list_max called on empty list".
# list_max [5; 4; 3; 2; 1]
- : int = 5
# list_max [5; 4; 3; 2; 1; 100]
- : int = 100
```
Notice how the solution proposed is both (a) very different from the
imperative for-loop solution, and (b) much more closely tied to the
problem specification. Functional programmers will tell you that this is
because the functional style is much higher level than the imperative
style, and therefore better and simpler. Whether you believe them is up
to you. It's certainly true that it's much simpler to reason logically
about the functional version, which is useful if you wanted to formally
prove that `list_max` is correct ("correct" being the mathematical way
to say that a program is provably bug-free, useful for space shuttles,
nuclear power plants and higher quality software in general).

###  Tail recursion
Let's look at the `range` function again for about the twentieth time:

```ocaml
# let rec range a b =
  if a > b then []
  else a :: range (a+1) b
val range : int -> int -> int list = <fun>
```
I'm going to rewrite it slightly to make something about the structure
of the program clearer (still the same function however):

```ocaml
# let rec range a b =
  if a > b then [] else
    let result = range (a+1) b in
      a :: result
val range : int -> int -> int list = <fun>
```
Let's call it:

```ocaml
# List.length (range 1 10)
- : int = 10
# List.length (range 1 1000000)
Stack overflow during evaluation (looping recursion?).
```
Hmmm ... at first sight this looks like a problem with recursive
programming, and hence with the whole of functional programming! If you
write your code recursively instead of iteratively then you necessarily
run out of stack space on large inputs, right?

In fact, wrong. Compilers can perform a simple optimisation on certain
types of recursive functions to turn them into while loops. These
certain types of recursive functions therefore run in constant stack
space, and with the equivalent efficiency of imperative while loops.
These functions are called **tail-recursive functions**.

In tail-recursive functions, the recursive call happens last of all.
Remember our `loop ()` functions above? They all had the form:

<!-- $MDX skip -->
```ocaml
let rec loop () =
  (* do something *)
  loop ()
```
Because the recursive call to `loop ()` happens as the very last thing,
`loop` is tail-recursive and the compiler will turn the whole thing into
a while loop.

Unfortunately `range` is not tail-recursive, and the longer version
above shows why. The recursive call to `range` doesn't happen as the
very last thing. In fact the last thing to happen is the `::` (cons)
operation. As a result, the compiler doesn't turn the recursion into a
while loop, and the function is not efficient in its use of stack space.

The use of an accumulating argument or `accumulator` allows one to write
functions such as `range` above in a tail-recursive manner, which means they
will be efficient and work properly on large inputs. Let's plan our rewritten
`range` function which will use an accumulator argument to store the "result so
far":

<!-- $MDX skip -->
```ocaml
let rec range2 a b accum =
  (* ... *)
  
let range a b =
  range2 a b []
```

The `accum` argument is going to accumulate the result. It's the "result
so far". We pass in the empty list ("no result so far"). The easy case
is when `a > b`:

<!-- $MDX skip -->
```ocaml
let rec range2 a b accum =
  if a > b then accum
  else
    (* ... *)
```
If `a > b` (i.e. if we've reached the end of the recursion), then stop
and return the result (`accum`).

Now the trick is to write the `else`-clause and make sure that the call
to `range2` is the very last thing that we do, so the function is
tail-recursive:

```ocaml
# let rec range2 a b accum =
  if a > b then accum
  else range2 (a + 1) b (a :: accum)
val range2 : int -> int -> int list -> int list = <fun>
```
There's only one slight problem with this function: it constructs the
list backwards! However, this is easy to rectify by redefining range as:

```ocaml
# let range a b = List.rev (range2 a b [])
val range : int -> int -> int list = <fun>
```
It works this time, although it's a bit slow to run because it really
does have to construct a list with a million elements in it:

```ocaml
# List.length (range 1 1000000)
- : int = 1000000
```
The following implementation is twice as fast as the previous one,
because it does not need to reverse a list:

```ocaml
# let rec range2 a b accum =
  if b < a then accum
  else range2 a (b - 1) (b :: accum)
val range2 : int -> int -> int list -> int list = <fun>
# let range a b =
  range2 a b []
val range : int -> int -> int list = <fun>
```
That was a brief overview of tail recursion, but in real world
situations determining if a function is tail recursive can be quite
hard. What did we really learn here? One thing is that recursive
functions have a dangerous trap for inexperienced programmers. Your
function can appear to work for small inputs (during testing), but fail
catastrophically in the field when exposed to large inputs. This is one
argument *against* using recursive functions, and for using explicit
while loops when possible.

## Mutable records, references (again!) and arrays
Previously we mentioned records in passing. These are like C `struct`s:

```ocaml
# type pair_of_ints = {a : int; b : int}
type pair_of_ints = { a : int; b : int; }
# {a = 3; b = 5}
- : pair_of_ints = {a = 3; b = 5}
# {a = 3}
Line 1, characters 1-8:
Error: Some record fields are undefined: b
```

One feature which I didn't cover: OCaml records can have mutable fields.
Normally an expression like `{a = 3; b = 5}` is an immutable, constant
object. However if the record has **mutable fields**, then
there is a way to change those fields in the record. This is an
imperative feature of OCaml, because functional languages don't normally
allow mutable objects (or references or mutable arrays, which we'll look
at in a moment).

Here is an object defined with a mutable field. This field is used to
count how many times the object has been accessed. You could imagine
this being used in a caching scheme to decide which objects you'd evict
from memory.

```ocaml
# type name = {name : string; mutable access_count : int}
type name = { name : string; mutable access_count : int; }
```

Here is a function defined on names which prints the `name` field and
increments the mutable `access_count` field:

```ocaml
# let print_name name =
  print_endline ("The name is " ^ name.name);
  name.access_count <- name.access_count + 1
val print_name : name -> unit = <fun>
```

Notice a strange, and very non-functional feature of `print_name`: it modifies
its `access_count` parameter. This function is not "pure". OCaml is a
functional language, but not to the extent that it forces functional
programming down your throat.

Anyway, let's see `print_name` in action:

```ocaml
# let n = {name = "Richard Jones"; access_count = 0}
val n : name = {name = "Richard Jones"; access_count = 0}
# n
- : name = {name = "Richard Jones"; access_count = 0}
# print_name n
The name is Richard Jones
- : unit = ()
# n
- : name = {name = "Richard Jones"; access_count = 1}
# print_name n
The name is Richard Jones
- : unit = ()
# n
- : name = {name = "Richard Jones"; access_count = 2}
```

Only fields explicitly marked as `mutable` can be assigned to using the
`<-` operator. If you try to assign to a non-mutable field, OCaml won't
let you:

```ocaml
# n.name <- "John Smith"
Line 1, characters 1-23:
Error: The record field name is not mutable
```
References, with which we should be familiar by now, are implemented
using records with a mutable `contents` field. Check out the definition
in `Stdlib`:

```ocaml
type 'a ref = {mutable contents : 'a}
```

And look closely at what the OCaml toplevel prints out for the value of
a reference:

```ocaml
# let r = ref 100
val r : int Stdlib.ref = {Stdlib.contents = 100}
```

Arrays are another sort of mutable structure provided by OCaml. In
OCaml, plain lists are implemented as linked lists, and linked lists are
slow for some types of operation. For example, getting the head of a
list, or iterating over a list to perform some operation on each element
is reasonably fast. However, jumping to the n<sup>th</sup> element of a
list, or trying to randomly access a list - both are slow operations.
The OCaml `Array` type is a real array, so random access is fast, but
insertion and deletion of elements is slow. `Array`s are also mutable so
you can randomly change elements too.

The basics of arrays are simple:

```ocaml
# let a = Array.create 10 0
Line 1, characters 9-21:
Alert deprecated: Stdlib.Array.create
Use Array.make instead.
val a : int array = [|0; 0; 0; 0; 0; 0; 0; 0; 0; 0|]
# for i = 0 to Array.length a - 1 do
  a.(i) <- i
Line 3, characters 1-3:
Error: Syntax error
# a
- : int array = [|0; 0; 0; 0; 0; 0; 0; 0; 0; 0|]
```
Notice the syntax for writing arrays: `[| element; element; ... |]`

The OCaml compiler was designed with heavy numerical processing in mind
(the sort of thing that FORTRAN is traditionally used for), and so it
contains various optimisations specifically for arrays of numbers,
vectors and matrices. Here is some benchmark code for doing dense matrix
multiplication. Notice that it uses for-loops and is generally very
imperative in style:

```ocaml
# let size = 30
val size : int = 30

# let mkmatrix rows cols =
  let count = ref 1
  and last_col = cols - 1
  and m = Array.make_matrix rows cols 0 in
    for i = 0 to rows - 1 do
      let mi = m.(i) in
        for j = 0 to last_col do
          mi.(j) <- !count;
          incr count
        done;
    done;
    m
val mkmatrix : int -> int -> int array array = <fun>

# let rec inner_loop k v m1i m2 j =
  if k < 0 then v
  else inner_loop (k - 1) (v + m1i.(k) * m2.(k).(j)) m1i m2 j
val inner_loop : int -> int -> int array -> int array array -> int -> int =
  <fun>

# let mmult rows cols m1 m2 m3 =
  let last_col = cols - 1
  and last_row = rows - 1 in
    for i = 0 to last_row do
      let m1i = m1.(i) and m3i = m3.(i) in
      for j = 0 to last_col do
        m3i.(j) <- inner_loop last_row 0 m1i m2 j
      done;
    done
val mmult :
  int -> int -> int array array -> int array array -> int array array -> unit =
  <fun>

# let () =
  let n =
    try int_of_string Sys.argv.(1)
    with Invalid_argument _ -> 1
  and m1 = mkmatrix size size
  and m2 = mkmatrix size size
  and m3 = Array.make_matrix size size 0 in
    for i = 1 to n - 1 do
      mmult size size m1 m2 m3
    done;
    mmult size size m1 m2 m3;
    Printf.printf "%d %d %d %d\\n" m3.(0).(0) m3.(2).(3) m3.(3).(2) m3.(4).(4)
Exception: Failure "int_of_string".
```

## Mutually recursive functions
Suppose I want to define two functions which call each other. This is
actually not a very common thing to do, but it can be useful sometimes.
Here's a contrived example (thanks to Ryan Tarpine): The number 0 is
even. Other numbers greater than 0 are even if their predecessor is odd.
Hence:

```ocaml
# let rec even n =
  match n with
  | 0 -> true
  | x -> odd (x - 1)
Line 4, characters 10-13:
Error: Unbound value odd
```

The code above doesn't compile because we haven't defined the function
`odd` yet! That's easy though. Zero is not odd, and other numbers
greater than 0 are odd if their predecessor is even. So to make this
complete we need that function too:

```ocaml
# let rec even n =
  match n with
  | 0 -> true
  | x -> odd (x - 1)
Line 4, characters 10-13:
Error: Unbound value odd
# let rec odd n =
  match n with
  | 0 -> false
  | x -> even (x - 1)
Line 4, characters 10-14:
Error: Unbound value even
```

The only problem is... this program doesn't compile. In order to compile
the `even` function, we already need the definition of `odd`, and to
compile `odd` we need the definition of `even`. So swapping the two
definitions around won't help either.

There are no "forward prototypes" (as seen in languages descended
from C) in OCaml but there is a special syntax
for defining a set of two or more mutually recursive functions, like
`odd` and `even`:

```ocaml
# let rec even n =
  match n with
  | 0 -> true
  | x -> odd (x - 1)
Line 4, characters 10-13:
Error: Unbound value odd
```
You can also
use similar syntax for writing mutually recursive class definitions and
modules.
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#if-statements-actually-these-are-if-expressions">If statements (actually, these are if expressions)</a>
</li>
<li><a href="#using-begin--end">Using begin ... end</a>
</li>
<li><a href="#for-loops-and-while-loops">For loops and while loops</a>
</li>
<li><a href="#looping-over-lists">Looping over lists</a>
</li>
<li><a href="#looping-over-strings">Looping over strings</a>
</li>
<li><a href="#recursion">Recursion</a>
</li>
<li><a href="#mutable-records-references-again-and-arrays">Mutable records, references (again!) and arrays</a>
</li>
<li><a href="#mutually-recursive-functions">Mutually recursive functions</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<h2 id="if-statements-actually-these-are-if-expressions">If statements (actually, these are if expressions)</h2>
<p>OCaml has an <code>if</code> statement with two variations, and the obvious meaning:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">if boolean-condition then expression
  
if boolean-condition then expression else other-expression
</code></pre>
<p>Unlike in the conventional languages you'll be used to, <code>if</code> statements
are really expressions. In other words, they're much more like
<code>boolean-condition ? expression : other-expression</code> in C than like the if
statements you may be used to.</p>
<p>Here's a simple example of an <code>if</code> statement:</p>
<pre><code class="language-ocaml"># let max a b =
  if a &gt; b then a else b
val max : 'a -&gt; 'a -&gt; 'a = &lt;fun&gt;
</code></pre>
<p>As a short aside, if you type this into the OCaml
interactive toplevel (as above), you'll
notice that OCaml decides that this function is polymorphic, with the
following type:</p>
<pre><code class="language-ocaml"># max
- : 'a -&gt; 'a -&gt; 'a = &lt;fun&gt;
</code></pre>
<p>And indeed OCaml lets you use <code>max</code> on any type:</p>
<pre><code class="language-ocaml"># max 3 5
- : int = 5
# max 3.5 13.0
- : float = 13.
# max &quot;a&quot; &quot;b&quot;
- : string = &quot;b&quot;
</code></pre>
<p>This is because <code>&gt;</code> is in fact polymorphic. It works on any type, even
objects (it does a binary comparison).</p>
<p>[Note that the <code>Stdlib</code> module defines <code>min</code> and <code>max</code> for you.]</p>
<p>Let's look a bit more closely at the <code>if</code> expression. Here's the <code>range</code>
function which I showed you earlier without much explanation. You should
be able to combine your knowledge of recursive functions, lists and if
expressions to see what it does:</p>
<pre><code class="language-ocaml"># let rec range a b =
    if a &gt; b then []
    else a :: range (a + 1) b
val range : int -&gt; int -&gt; int list = &lt;fun&gt;
</code></pre>
<p>Let's examine some typical calls to this function. Let's start with the
easy case of <code>a &gt; b</code>. A call to <code>range 11 10</code> returns <code>[]</code> (the empty
list) and that's it.</p>
<p>What about calling <code>range 10 10</code>? Since <code>10 &gt; 10</code> is false, the
<code>else</code>-clause is evaluated, which is: <code>10 :: (range 11 10)</code> (I've added
the brackets to make the order of evaluation more clear). We've just
worked out that <code>range 11 10</code> = <code>[]</code>, so this is: <code>10 :: []</code>. Remember
our formal description of lists and the <code>::</code> (cons) operator? <code>10 :: []</code>
is just the same as <code>[10]</code>.</p>
<p>Let's try <code>range 9 10</code>:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">range 9 10
→ 9 :: (range 10 10)
→ 9 :: [10]
→ [9; 10]
</code></pre>
<p>It should be fairly clear that <code>range 1 10</code> evaluates to
<code>[1; 2; 3; 4; 5; 6; 7; 8; 9; 10]</code>.</p>
<p>What we've got here is a simple case of recursion. Functional
programming can be said to prefer recursion over loops, but I'm jumping
ahead of myself. We'll discuss recursion more at the end of this
chapter.</p>
<p>Back, temporarily, to <code>if</code> statements. What does this function do?</p>
<pre><code class="language-ocaml"># let f x y =
    x + if y &gt; 0 then y else 0
val f : int -&gt; int -&gt; int = &lt;fun&gt;
</code></pre>
<p>Clue: add brackets around the whole of the if expression. It clips <code>y</code>
like an <a href="https://en.wikipedia.org/wiki/Diode#Current.E2.80.93voltage_characteristic">electronic diode</a>.</p>
<p>The <code>abs</code> (absolute value) function is defined in <code>Stdlib</code> as:</p>
<pre><code class="language-ocaml"># let abs x =
    if x &gt;= 0 then x else -x
val abs : int -&gt; int = &lt;fun&gt;
</code></pre>
<p>Also in <code>Stdlib</code>, the <code>string_of_float</code> function contains a complex
pair of nested <code>if</code> expressions:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let string_of_float f =
  let s = format_float &quot;%.12g&quot; f in
  let l = string_length s in
  let rec loop i =
    if i &gt;= l then s ^ &quot;.&quot;
    else if s.[i] = '.' || s.[i] = 'e' then s
    else loop (i + 1)
  in
    loop 0
</code></pre>
<p>Let's examine this function. Suppose the function is called with <code>f</code> =
12.34. Then <code>s</code> = &quot;12.34&quot;, and <code>l</code> = 5. We call <code>loop</code> the first time
with <code>i</code> = 0.</p>
<p><code>i</code> is not greater than or equal to <code>l</code>, and <code>s.[i]</code> (the
<code>i</code><sup>th</sup> character in <code>s</code>) is not a period or <code>'e'</code>. So
<code>loop (i + 1)</code> is called, ie. <code>loop 1</code>.</p>
<p>We go through the same dance for <code>i</code> = 1, and end up calling <code>loop 2</code>.</p>
<p>For <code>i</code> = 2, however, <code>s.[i]</code> is a period (refer to the original string,
<code>s</code> = &quot;12.34&quot;). So this immediately returns <code>s</code>, and the function
<code>string_of_float</code> returns &quot;12.34&quot;.</p>
<p>What is <code>loop</code> doing? In fact it's checking whether the string returned
from <code>format_float</code> contains a period (or <code>'e'</code>). Suppose that we called
<code>string_of_float</code> with <code>12.0</code>. <code>format_float</code> would return the string
&quot;12&quot;, but <code>string_of_float</code> must return &quot;12.&quot; or &quot;12.0&quot; (because
floating point constants in OCaml must contain a period to differentiate
them from integer constants). Hence the check.</p>
<p>The strange use of recursion in this function is almost certainly for
efficiency. OCaml supports for loops, so why didn't the authors use for
loops? We'll see in the next section that OCaml's for loops are limited
in a way which prevents them from being used in <code>string_of_float</code>. Here,
however, is a more straightforward, but approximately twice as slow, way
of writing <code>string_of_float</code>:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let string_of_float f =
  let s = format_float &quot;%.12g&quot; f in
    if String.contains s '.' || String.contains s 'e'
      then s
      else s ^ &quot;.&quot;
</code></pre>
<h2 id="using-begin--end">Using begin ... end</h2>
<p>Here is some code from lablgtk:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">if GtkBase.Object.is_a obj cls then
  fun _ -&gt; f obj
else begin
  eprintf &quot;Glade-warning: %s expects a %s argument.\\n&quot; name cls;
  raise Not_found
end
</code></pre>
<p><code>begin</code> and <code>end</code> are what is known as <strong>syntactic sugar</strong> for open and
close parentheses. In the example above, all they do is group the two
statements in the <code>else</code>-clause together. Suppose the author had written
this instead:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">if GtkBase.Object.is_a obj cls then
  fun _ -&gt; f obj
else
  eprintf &quot;Glade-warning: %s expects a %s argument.\\n&quot; name cls;
  raise Not_found
</code></pre>
<p>Fully bracketing and properly indenting the above expression gives:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">(if GtkBase.Object.is_a obj cls then
   fun _ -&gt; f obj
 else
   eprintf &quot;Glade-warning: %s expects a %s argument.\\n&quot; name cls
);
raise Not_found
</code></pre>
<p>Not what was intended at all. So the <code>begin</code> and <code>end</code> are necessary to
group together multiple statements in a <code>then</code> or <code>else</code> clause of an if
expression. You can also use plain ordinary parentheses <code>( ... )</code> if you
prefer (and I do prefer, because I <strong>loathe</strong> Pascal :-). Here are two
simple examples:</p>
<pre><code class="language-ocaml"># if 1 = 0 then
    print_endline &quot;THEN&quot;
  else begin
    print_endline &quot;ELSE&quot;;
    failwith &quot;else clause&quot;
  end
ELSE
Exception: Failure &quot;else clause&quot;.
# if 1 = 0 then
    print_endline &quot;THEN&quot;
  else (
    print_endline &quot;ELSE&quot;;
    failwith &quot;else clause&quot;
  )
ELSE
Exception: Failure &quot;else clause&quot;.
</code></pre>
<h2 id="for-loops-and-while-loops">For loops and while loops</h2>
<p>OCaml supports a rather limited form of the familiar <code>for</code> loop:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">for variable = start_value to end_value do
  expression
done
  
for variable = start_value downto end_value do
  expression
done
</code></pre>
<p>A simple but real example from lablgtk:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">for i = 1 to n_jobs () do
  do_next_job ()
done
</code></pre>
<p>In OCaml, <code>for</code> loops are just shorthand for writing:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let i = 1 in
do_next_job ();
let i = 2 in
do_next_job ();
let i = 3 in
do_next_job ();
  ...
let i = n_jobs () in
do_next_job ();
()
</code></pre>
<p>OCaml doesn't support the concept of breaking out of a <code>for</code> loop early
i.e. it has no <code>break</code>, <code>continue</code> or <code>last</code> statements. (You <em>could</em>
throw an exception and catch it outside, and this would run fast but
often looks clumsy.)</p>
<p>The expression inside an OCaml for loop should evaluate to <code>unit</code>
(otherwise you'll get a warning), and the for loop expression as a whole
returns <code>unit</code>:</p>
<pre><code class="language-ocaml"># for i = 1 to 10 do i done
Line 1, characters 20-21:
Warning 10: this expression should have type unit.
- : unit = ()
</code></pre>
<p>Functional programmers tend to use recursion instead of explicit loops,
and regard <strong>for</strong> loops with suspicion since it can't return anything,
hence OCaml's relatively powerless <strong>for</strong> loop. We talk about recursion
below.</p>
<p><strong>While loops</strong> in OCaml are written:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">while boolean-condition do
  expression
done
</code></pre>
<p>As with for loops, there is no way provided by the language to break out
of a while loop, except by throwing an exception, and this means that
while loops have fairly limited use. Again, remember that functional
programmers like recursion, and so while loops are second-class citizens
in the language.</p>
<p>If you stop to consider while loops, you may see that they aren't really
any use at all, except in conjunction with our old friend references.
Let's imagine that OCaml didn't have references for a moment:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let quit_loop = false in
  while not quit_loop do
    print_string &quot;Have you had enough yet? (y/n) &quot;;
    let str = read_line () in
      if str.[0] = 'y' then
        (* how do I set quit_loop to true ?!? *)
  done
</code></pre>
<p>Remember that <code>quit_loop</code> is not a real &quot;variable&quot; - the let-binding
just makes <code>quit_loop</code> a shorthand for <code>false</code>. This means the while
loop condition (shown in red) is always true, and the loop runs on
forever!</p>
<p>Luckily OCaml <em>does have</em> references, so we can write the code above if
we want. Don't get confused and think that the <code>!</code> (exclamation mark)
means &quot;not&quot; as in C/Java. It's used here to mean &quot;dereference the
pointer&quot;, similar in fact to Forth. You're better off reading <code>!</code> as
&quot;get&quot; or &quot;deref&quot;.</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let quit_loop = ref false in
  while not !quit_loop do
    print_string &quot;Have you had enough yet? (y/n) &quot;;
    let str = read_line () in
      if str.[0] = 'y' then quit_loop := true
  done;;
</code></pre>
<h2 id="looping-over-lists">Looping over lists</h2>
<p>If you want to loop over a list, don't be an imperative programmer and
reach for your trusty six-shooter Mr. For Loop! OCaml has some better
and faster ways to loop over lists, and they are all located in the
<code>List</code> module. There are in fact dozens of good functions in <code>List</code>, but
I'll only talk about the most useful ones here.</p>
<p>First off, let's define a list for us to use:</p>
<pre><code class="language-ocaml"># let my_list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]
val my_list : int list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]
</code></pre>
<p>If you want to call a function once on every element of the list, use
<code>List.iter</code>, like this:</p>
<pre><code class="language-ocaml"># let f elem =
    Printf.printf &quot;I'm looking at element %d now\\n&quot; elem
  in
    List.iter f my_list
I'm looking at element 1 now
I'm looking at element 2 now
I'm looking at element 3 now
I'm looking at element 4 now
I'm looking at element 5 now
I'm looking at element 6 now
I'm looking at element 7 now
I'm looking at element 8 now
I'm looking at element 9 now
I'm looking at element 10 now
- : unit = ()
</code></pre>
<p><code>List.iter</code> is in fact what you should think about using first every
time your cerebellum suggests you use a for loop.</p>
<p>If you want to <em>transform</em> each element separately in the list - for
example, doubling each element in the list - then use <code>List.map</code>.</p>
<pre><code class="language-ocaml"># List.map (( * ) 2) my_list
- : int list = [2; 4; 6; 8; 10; 12; 14; 16; 18; 20]
</code></pre>
<p>The function <code>List.filter</code> collects only those elements of a list which satisfy
some condition - e.g. returning all even numbers in a list.</p>
<pre><code class="language-ocaml"># let is_even i =
    i mod 2 = 0
  in
    List.filter is_even my_list
- : int list = [2; 4; 6; 8; 10]
</code></pre>
<p>To find out if a list contains some element, use <code>List.mem</code> (short for
member):</p>
<pre><code class="language-ocaml"># List.mem 12 my_list
- : bool = false
</code></pre>
<p><code>List.for_all</code> and <code>List.exists</code> are the same as the &quot;forall&quot; and
&quot;exist&quot; operators in predicate logic.</p>
<p>For operating over two lists at the same time, there are &quot;-2&quot; variants
of some of these functions, namely <code>iter2</code>, <code>map2</code>, <code>for_all2</code>,
<code>exists2</code>.</p>
<p>The <code>map</code> and <code>filter</code> functions operate on individual list elements in
isolation. <strong>Fold</strong> is a more unusual operation that is best
thought about as &quot;inserting an operator between each element of the
list&quot;. Suppose I wanted to add all the numbers in my list together. In
hand-waving terms what I want to do is insert a plus sign between the
elements in my list:</p>
<pre><code class="language-ocaml"># 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 10
- : int = 55
</code></pre>
<p>The fold operation does this, although the exact details are a little
bit more tricky. First of all, what happens if I try to fold an empty
list? In the case of summing the list it would be nice if the answer was
zero, instead of error. However if I was trying to find the product of
the list, I'd like the answer to be one instead. So I obviously have to
provide some sort of &quot;default&quot; argument to my fold. The second issue
doesn't arise with simple operators like <code>+</code> and <code>*</code>: what happens if
the operator I'm using isn't associative, ie. (a <em>op</em> b) <em>op</em> c not
equal to a <em>op</em> (b <em>op</em> c)? In that case it would matter if I started
from the left hand end of the list and worked right, versus if I started
from the right and worked left. For this reason there are two versions
of fold, called <code>List.fold_left</code> (works left to right) and
<code>List.fold_right</code> (works right to left, and is also less efficient).</p>
<p>Let's use <code>List.fold_left</code> to define <code>sum</code> and <code>product</code> functions for
integer lists:</p>
<pre><code class="language-ocaml"># let sum = List.fold_left ( + ) 0
val sum : int list -&gt; int = &lt;fun&gt;
# let product = List.fold_left ( * ) 1
val product : int list -&gt; int = &lt;fun&gt;
# sum my_list
- : int = 55
# product my_list
- : int = 3628800
</code></pre>
<p>That was easy! Notice that I've accidentally come up with a way to do
mathematical factorials:</p>
<pre><code class="language-ocaml"># let fact n = product (range 1 n)
val fact : int -&gt; int = &lt;fun&gt;
# fact 10
- : int = 3628800
</code></pre>
<p>(Notice that this factorial function isn't very useful because it
overflows the integers and gives wrong answers even for quite small
values of <code>n</code>.)</p>
<h2 id="looping-over-strings">Looping over strings</h2>
<p>The <code>String</code> module also contains many dozens of useful string-related
functions, and some of them are concerned with looping over strings.</p>
<p><code>String.copy</code> copies a string, like <code>strdup</code>. There is also a <code>String.iter</code>
function which works like <code>List.iter</code>, except over the characters of the
string.</p>
<h2 id="recursion">Recursion</h2>
<p>Now we come to a hard topic - recursion. Functional programmers are
defined by their love of recursive functions, and in many ways recursive
functions in f.p. are the equivalent of loops in imperative programming.
In functional languages loops are second-class citizens, whilst
recursive functions get all the best support.</p>
<p>Writing recursive functions requires a change in mindset from writing
for loops and while loops. So what I'll give you in this section will be
just an introduction and examples.</p>
<p>In the first example we're going to read the whole of a file into memory
(into a long string). There are essentially three possible approaches to
this:</p>
<h3 id="approach-1">Approach 1</h3>
<p>Get the length of the file, and read it all in one go using the
<code>really_input</code> method. This is the simplest, but it might not work on
channels which are not really files (eg. reading keyboard input) which
is why we look at the other two approaches.</p>
<h3 id="approach-2">Approach 2</h3>
<p>The imperative approach, using a while loop which is broken out of using
an exception.</p>
<h3 id="approach-3">Approach 3</h3>
<p>A recursive loop, breaking out of the recursion again using an
exception.</p>
<p>We're going to introduce a few new concepts here. Our second two
approaches will use the <code>Buffer</code> module - an expandable buffer which you
can think of like a string onto which you can efficiently append more
text at the end. We're also going to be catching the <code>End_of_file</code>
exception which the input functions throw when they reach the end of the
input. Also we're going to use <code>Sys.argv.(1)</code> to get the first command
line parameter.</p>
<pre><code class="language-ocaml">(* Read whole file: Approach 1 *)
open Printf
  
let read_whole_chan chan =
  let len = in_channel_length chan in
  let result = (Bytes.create len) in
    really_input chan result 0 len;
    (Bytes.to_string result)
  
let read_whole_file filename =
  let chan = open_in filename in
    read_whole_chan chan
  
let main () =
  let filename = Sys.argv.(1) in
  let str = read_whole_file filename in
    printf &quot;I read %d characters from %s\\n&quot; (String.length str) filename
</code></pre>
<p>Approach 1 works but is not very satisfactory because <code>read_whole_chan</code>
won't work on non-file channels like keyboard input or sockets. Approach
2 involves a while loop:</p>
<pre><code class="language-ocaml">(* Read whole file: Approach 2 *)
open Printf
  
let read_whole_chan chan =
  let buf = Buffer.create 4096 in
  try
    while true do
      let line = input_line chan in
        Buffer.add_string buf line;
        Buffer.add_char buf '\\n'
    done;
    assert false (* This is never executed
	                (always raises Assert_failure). *)
  with
    End_of_file -&gt; Buffer.contents buf
  
let read_whole_file filename =
  let chan = open_in filename in
    read_whole_chan chan
  
let main () =
  let filename = Sys.argv.(1) in
  let str = read_whole_file filename in
    printf &quot;I read %d characters from %s\\n&quot; (String.length str) filename
</code></pre>
<p>The key to approach 2 is to look at the central while loop. Remember
that I said the only way to break out of a while loop early was with an
exception? This is exactly what we're doing here. Although I haven't
covered exceptions yet, you probably won't have any trouble
understanding the <code>End_of_file</code> exception thrown in the code above by
<code>input_line</code> when it hits the end of the file. The buffer <code>buf</code>
accumulates the contents of the file, and when we hit the end of the
file we return it (<code>Buffer.contents buf</code>).</p>
<p>One curious point about this is the apparently superfluous statement
(<code>assert false</code>) just after the while loop. What is it for?  Remember
that while loops, like for loops, are just expressions, and they return
the <code>unit</code> object (<code>()</code>). However OCaml demands that the return type
inside a <code>try</code> matches the return type of each caught exception. In this
case because <code>End_of_file</code> results in a <code>string</code>, the main body of the
<code>try</code> must also &quot;return&quot; a string — even though because of the infinite
while loop the string could never actually be returned.  <code>assert false</code>
has a polymorphic type, so will unify with whatever value is returned
by the <code>with</code> branch.</p>
<p>Here's our recursive version. Notice that it's <em>shorter</em> than approach
2, but not so easy to understand for imperative programmers at least:</p>
<pre><code class="language-ocaml">(* Read whole file: Approach 3 *)
open Printf
  
let read_whole_chan chan =
  let buf = Buffer.create 4096 in
  let rec loop () =
    let line = input_line chan in
      Buffer.add_string buf line;
      Buffer.add_char buf '\\n';
      loop ()
  in
    try loop () with
      End_of_file -&gt; Buffer.contents buf
  
let read_whole_file filename =
  let chan = open_in filename in
    read_whole_chan chan
  
let main () =
  let filename = Sys.argv.(1) in
  let str = read_whole_file filename in
  printf &quot;I read %d characters from %s\\n&quot; (String.length str) filename
</code></pre>
<p>Again we have an infinite loop - but in this case done using recursion.
<code>loop</code> calls itself at the end of the function. The infinite recursion
is broken when <code>input_line</code> throws an <code>End_of_file</code> exception.</p>
<p>It looks like approach 3 might overflow the stack if you gave it a
particularly large file, but this is in fact not the case. Because of
tail recursion (discussed below) the compiler will turn the recursive
<code>loop</code> function into a real while loop (!) which runs in constant stack
space.</p>
<p>In the next example we will show how recursion is great for constructing
or examining certain types of data structures, particularly trees. Let's
have a recursive type to represent files in a filesystem:</p>
<pre><code class="language-ocaml"># type filesystem = File of string | Directory of filesystem list
type filesystem = File of string | Directory of filesystem list
</code></pre>
<p>The <code>opendir</code> and <code>readdir</code> functions are used to open a directory and
read elements from the directory. I'm going to define a handy
<code>readdir_no_ex</code> function which hides the annoying <code>End_of_file</code>
exception that <code>readdir</code> throws when it reaches the end of the
directory:</p>
<pre><code class="language-ocaml"># #load &quot;unix.cma&quot;
# open Unix
# let readdir_no_ex dirh =
  try
    Some (readdir dirh)
  with
    End_of_file -&gt; None
val readdir_no_ex : dir_handle -&gt; string option = &lt;fun&gt;
</code></pre>
<p>The type of <code>readdir_no_ex</code> is this. Recall our earlier discussion about
null pointers.</p>
<pre><code class="language-ocaml"># readdir_no_ex
- : dir_handle -&gt; string option = &lt;fun&gt;
</code></pre>
<p>I'm also going to define a simple recursive function which I can use to
convert the <code>filesystem</code> type into a string for (eg) printing:</p>
<pre><code class="language-ocaml"># let rec string_of_filesystem fs =
  match fs with
  | File filename -&gt; filename ^ &quot;\\n&quot;
  | Directory fs_list -&gt;
      List.fold_left (^) &quot;&quot; (List.map string_of_filesystem fs_list)
val string_of_filesystem : filesystem -&gt; string = &lt;fun&gt;
</code></pre>
<p>Note the use of <code>fold_left</code> and <code>map</code>. The <code>map</code> is used to
(recursively) convert each <code>filesystem</code> in the list into a <code>string</code>.
Then the <code>fold_left (^) &quot;&quot;</code> concatenates the list together into one big
string. Notice also the use of pattern matching. (The library defines a
function called <code>String.concat</code> which is essentially equivalent to
<code>fold_left (^) </code>, but implemented more efficiently).</p>
<p>Now let's define a function to read a directory structure, recursively,
and return a recursive <code>filesystem</code> data structure. I'm going to show
this function in steps, but I'll print out the entire function at the
end of this section. First the outline of the function:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let rec read_directory path =
  let dirh = opendir path in
  let rec loop () =
    (* ..... *) in
  Directory (loop ())
</code></pre>
<p>The call to <code>opendir</code> opens up the given path and returns a <code>dir_handle</code>
from which we will be able to read the names using <code>readdir_no_ex</code>
later. The return value of the function is going to be a
<code>Directory fs_list</code>, so all we need to do to complete the function is to
write our function <code>loop</code> which returns a list of <code>filesystem</code>s. The
type of <code>loop</code> will be:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">loop : unit -&gt; filesystem list
</code></pre>
<p>How do we define loop? Let's take it in steps again.</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let rec loop () =
  let filename = readdir_no_ex dirh in
  (* ..... *)
</code></pre>
<p>First we read the next filename from the directory handle. <code>filename</code>
has type <code>string option</code>, in other words it could be <code>None</code> or
<code>Some &quot;foo&quot;</code> where <code>foo</code> is the name of the next filename in the
directory. We also need to ignore the <code>&quot;.&quot;</code> and <code>&quot;..&quot;</code> files (ie. the
current directory and the parent directory). We can do all this with a
nice pattern match:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let rec loop () =
  let filename = readdir_no_ex dirh in
    match filename with
    | None -&gt; []
    | Some &quot;.&quot; -&gt; loop ()
    | Some &quot;..&quot; -&gt; loop ()
    | Some filename -&gt;
        (* ..... *)
</code></pre>
<p>The <code>None</code> case is easy. Thinking recursively (!) if <code>loop</code> is called
and we've reached the end of the directory, <code>loop</code> needs to return a
list of entries - and there's no entries - so it returns the empty list
(<code>[]</code>).</p>
<p>For <code>&quot;.&quot;</code> and <code>&quot;..&quot;</code> we just ignore the file and call <code>loop</code> again.</p>
<p>What do we do when <code>loop</code> reads a real filename (the <code>Some filename</code>
match below)? Let <code>pathname</code> be the full path to the file. We 'stat' the
file to see if it's really a directory. If it <em>is</em> a directory, we set
<code>this</code> by recursively calling <code>read_directory</code> which will return
<code>Directory something</code>. Notice that the overall result of
<code>read_directory</code> is <code>Directory (loop ())</code>. If the file is really a file
(not a directory) then we let <code>this</code> be <code>File pathname</code>. Then we do
something clever: we return <code>this :: loop ()</code>. This is the recursive
call to <code>loop ()</code> to calculate the remaining directory members (a list),
to which we prepend <code>this</code>.</p>
<pre><code class="language-ocaml"># let rec read_directory path =
  let dirh = opendir path in
  let rec loop () =
    let filename = readdir_no_ex dirh in
      match filename with
      | None -&gt; []
      | Some &quot;.&quot; -&gt; loop ()
      | Some &quot;..&quot; -&gt; loop ()
      | Some filename -&gt;
          let pathname = path ^ &quot;/&quot; ^ filename in
          let stat = lstat pathname in
          let this =
            if stat.st_kind = S_DIR then
              read_directory pathname
            else
              File pathname
          in
            this :: loop ()
  in
    Directory (loop ())
val read_directory : string -&gt; filesystem = &lt;fun&gt;
</code></pre>
<p>That's quite a complex bit of recursion, but although this is a made-up
example, it's fairly typical of the complex patterns of recursion found
in real-world functional programs. The two important lessons to take
away from this are:</p>
<ul>
<li>
<p>The use of recursion to build a list:</p>
  <!-- $MDX skip -->
  ```ocaml
  let rec loop () =
    a match or if statement
    | base case -> []
    | recursive case -> element :: loop ()
  ```
  Compare this to our previous `range` function. The pattern of recursion
  is exactly the same:
    
  ```ocaml
  # let rec range a b =
    if a > b then []            (* Base case *)
    else a :: range (a + 1) b     (* Recursive case *)
  ```
	
</li>
<li>
<p>The use of recursion to build up trees:</p>
  <!-- $MDX skip -->
  ```ocaml
  let rec read_directory path =
    (* blah blah *)
    if file-is-a-directory then
      read_directory path-to-file
    else
      Leaf file
  ```
  All that remains now to make this a working program is a little bit of
  code to call `read_directory` and display the result:
    
  <!-- $MDX skip -->
  ```ocaml
  let path = Sys.argv.(1) in
  let fs = read_directory path in
  print_endline (string_of_filesystem fs)
  ```

</li>
</ul>
<h3 id="recursion-example-maximum-element-in-a-list">Recursion example: maximum element in a list</h3>
<p>Remember the basic recursion pattern for lists:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let rec loop () =
  a match or if statement
  | base case -&gt; []
  | recursive case -&gt; element :: loop ()
</code></pre>
<p>The key here is actually the use of the match / base case / recursive
case pattern. In this example - finding the maximum element in a list -
we're going to have two base cases and one recursive case. But before I
jump ahead to the code, let's just step back and think about the
problem. By thinking about the problem, the solution will appear &quot;as if
by magic&quot; (I promise you :-)</p>
<p>First of all, let's be clear that the maximum element of a list is just
the biggest one, e.g. the maximum element of the list <code>[1; 2; 3; 4; 1]</code>
is <code>4</code>.</p>
<p>Are there any special cases? Yes, there are. What's the maximum element
of the empty list <code>[]</code>? There <em>isn't one</em>. If we are passed an empty
list, we should throw an error.</p>
<p>What's the maximum element of a single element list such as <code>[4]</code>?
That's easy: it's just the element itself. So <code>list_max [4]</code> should
return <code>4</code>, or in the general case, <code>list_max [x]</code> should return <code>x</code>.</p>
<p>What's the maximum element of the general list <code>x :: remainder</code> (this is
the &quot;cons&quot; notation for the list, so <code>remainder</code> is the tail - also a
list)?</p>
<p>Think about this for a while. Suppose you know the maximum element of
<code>remainder</code>, which is, say, <code>y</code>. What's the maximum element of
<code>x :: remainder</code>? It depends on whether <code>x &gt; y</code> or <code>x &lt;= y</code>. If <code>x</code> is
bigger than <code>y</code>, then the overall maximum is <code>x</code>, whereas conversely if
<code>x</code> is less than <code>y</code>, then the overall maximum is <code>y</code>.</p>
<p>Does this really work? Consider <code>[1; 2; 3; 4; 1]</code> again. This is
<code>1 :: [2; 3; 4; 1]</code>. Now the maximum element of the remainder,
<code>[2; 3; 4; 1]</code>, is <code>4</code>. So now we're interested in <code>x = 1</code> and <code>y = 4</code>.
That head element <code>x = 1</code> doesn't matter because <code>y = 4</code> is bigger, so
the overall maximum of the whole list is <code>y = 4</code>.</p>
<p>Let's now code those rules above up, to get a working function:</p>
<pre><code class="language-ocaml"># let rec list_max xs =
  match xs with
  | [] -&gt; (* empty list: fail *)
      failwith &quot;list_max called on empty list&quot;
  | [x] -&gt; (* single element list: return the element *)
      x
  | x :: remainder -&gt; (* multiple element list: recursive case *)
      max x (list_max remainder)
val list_max : 'a list -&gt; 'a = &lt;fun&gt;
</code></pre>
<p>I've added comments so you can see how the rules / special cases we
decided upon above really correspond to lines of code.</p>
<p>Does it work?</p>
<pre><code class="language-ocaml"># list_max [1; 2; 3; 4; 1]
- : int = 4
# list_max []
Exception: Failure &quot;list_max called on empty list&quot;.
# list_max [5; 4; 3; 2; 1]
- : int = 5
# list_max [5; 4; 3; 2; 1; 100]
- : int = 100
</code></pre>
<p>Notice how the solution proposed is both (a) very different from the
imperative for-loop solution, and (b) much more closely tied to the
problem specification. Functional programmers will tell you that this is
because the functional style is much higher level than the imperative
style, and therefore better and simpler. Whether you believe them is up
to you. It's certainly true that it's much simpler to reason logically
about the functional version, which is useful if you wanted to formally
prove that <code>list_max</code> is correct (&quot;correct&quot; being the mathematical way
to say that a program is provably bug-free, useful for space shuttles,
nuclear power plants and higher quality software in general).</p>
<h3 id="tail-recursion">Tail recursion</h3>
<p>Let's look at the <code>range</code> function again for about the twentieth time:</p>
<pre><code class="language-ocaml"># let rec range a b =
  if a &gt; b then []
  else a :: range (a+1) b
val range : int -&gt; int -&gt; int list = &lt;fun&gt;
</code></pre>
<p>I'm going to rewrite it slightly to make something about the structure
of the program clearer (still the same function however):</p>
<pre><code class="language-ocaml"># let rec range a b =
  if a &gt; b then [] else
    let result = range (a+1) b in
      a :: result
val range : int -&gt; int -&gt; int list = &lt;fun&gt;
</code></pre>
<p>Let's call it:</p>
<pre><code class="language-ocaml"># List.length (range 1 10)
- : int = 10
# List.length (range 1 1000000)
Stack overflow during evaluation (looping recursion?).
</code></pre>
<p>Hmmm ... at first sight this looks like a problem with recursive
programming, and hence with the whole of functional programming! If you
write your code recursively instead of iteratively then you necessarily
run out of stack space on large inputs, right?</p>
<p>In fact, wrong. Compilers can perform a simple optimisation on certain
types of recursive functions to turn them into while loops. These
certain types of recursive functions therefore run in constant stack
space, and with the equivalent efficiency of imperative while loops.
These functions are called <strong>tail-recursive functions</strong>.</p>
<p>In tail-recursive functions, the recursive call happens last of all.
Remember our <code>loop ()</code> functions above? They all had the form:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let rec loop () =
  (* do something *)
  loop ()
</code></pre>
<p>Because the recursive call to <code>loop ()</code> happens as the very last thing,
<code>loop</code> is tail-recursive and the compiler will turn the whole thing into
a while loop.</p>
<p>Unfortunately <code>range</code> is not tail-recursive, and the longer version
above shows why. The recursive call to <code>range</code> doesn't happen as the
very last thing. In fact the last thing to happen is the <code>::</code> (cons)
operation. As a result, the compiler doesn't turn the recursion into a
while loop, and the function is not efficient in its use of stack space.</p>
<p>The use of an accumulating argument or <code>accumulator</code> allows one to write
functions such as <code>range</code> above in a tail-recursive manner, which means they
will be efficient and work properly on large inputs. Let's plan our rewritten
<code>range</code> function which will use an accumulator argument to store the &quot;result so
far&quot;:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let rec range2 a b accum =
  (* ... *)
  
let range a b =
  range2 a b []
</code></pre>
<p>The <code>accum</code> argument is going to accumulate the result. It's the &quot;result
so far&quot;. We pass in the empty list (&quot;no result so far&quot;). The easy case
is when <code>a &gt; b</code>:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let rec range2 a b accum =
  if a &gt; b then accum
  else
    (* ... *)
</code></pre>
<p>If <code>a &gt; b</code> (i.e. if we've reached the end of the recursion), then stop
and return the result (<code>accum</code>).</p>
<p>Now the trick is to write the <code>else</code>-clause and make sure that the call
to <code>range2</code> is the very last thing that we do, so the function is
tail-recursive:</p>
<pre><code class="language-ocaml"># let rec range2 a b accum =
  if a &gt; b then accum
  else range2 (a + 1) b (a :: accum)
val range2 : int -&gt; int -&gt; int list -&gt; int list = &lt;fun&gt;
</code></pre>
<p>There's only one slight problem with this function: it constructs the
list backwards! However, this is easy to rectify by redefining range as:</p>
<pre><code class="language-ocaml"># let range a b = List.rev (range2 a b [])
val range : int -&gt; int -&gt; int list = &lt;fun&gt;
</code></pre>
<p>It works this time, although it's a bit slow to run because it really
does have to construct a list with a million elements in it:</p>
<pre><code class="language-ocaml"># List.length (range 1 1000000)
- : int = 1000000
</code></pre>
<p>The following implementation is twice as fast as the previous one,
because it does not need to reverse a list:</p>
<pre><code class="language-ocaml"># let rec range2 a b accum =
  if b &lt; a then accum
  else range2 a (b - 1) (b :: accum)
val range2 : int -&gt; int -&gt; int list -&gt; int list = &lt;fun&gt;
# let range a b =
  range2 a b []
val range : int -&gt; int -&gt; int list = &lt;fun&gt;
</code></pre>
<p>That was a brief overview of tail recursion, but in real world
situations determining if a function is tail recursive can be quite
hard. What did we really learn here? One thing is that recursive
functions have a dangerous trap for inexperienced programmers. Your
function can appear to work for small inputs (during testing), but fail
catastrophically in the field when exposed to large inputs. This is one
argument <em>against</em> using recursive functions, and for using explicit
while loops when possible.</p>
<h2 id="mutable-records-references-again-and-arrays">Mutable records, references (again!) and arrays</h2>
<p>Previously we mentioned records in passing. These are like C <code>struct</code>s:</p>
<pre><code class="language-ocaml"># type pair_of_ints = {a : int; b : int}
type pair_of_ints = { a : int; b : int; }
# {a = 3; b = 5}
- : pair_of_ints = {a = 3; b = 5}
# {a = 3}
Line 1, characters 1-8:
Error: Some record fields are undefined: b
</code></pre>
<p>One feature which I didn't cover: OCaml records can have mutable fields.
Normally an expression like <code>{a = 3; b = 5}</code> is an immutable, constant
object. However if the record has <strong>mutable fields</strong>, then
there is a way to change those fields in the record. This is an
imperative feature of OCaml, because functional languages don't normally
allow mutable objects (or references or mutable arrays, which we'll look
at in a moment).</p>
<p>Here is an object defined with a mutable field. This field is used to
count how many times the object has been accessed. You could imagine
this being used in a caching scheme to decide which objects you'd evict
from memory.</p>
<pre><code class="language-ocaml"># type name = {name : string; mutable access_count : int}
type name = { name : string; mutable access_count : int; }
</code></pre>
<p>Here is a function defined on names which prints the <code>name</code> field and
increments the mutable <code>access_count</code> field:</p>
<pre><code class="language-ocaml"># let print_name name =
  print_endline (&quot;The name is &quot; ^ name.name);
  name.access_count &lt;- name.access_count + 1
val print_name : name -&gt; unit = &lt;fun&gt;
</code></pre>
<p>Notice a strange, and very non-functional feature of <code>print_name</code>: it modifies
its <code>access_count</code> parameter. This function is not &quot;pure&quot;. OCaml is a
functional language, but not to the extent that it forces functional
programming down your throat.</p>
<p>Anyway, let's see <code>print_name</code> in action:</p>
<pre><code class="language-ocaml"># let n = {name = &quot;Richard Jones&quot;; access_count = 0}
val n : name = {name = &quot;Richard Jones&quot;; access_count = 0}
# n
- : name = {name = &quot;Richard Jones&quot;; access_count = 0}
# print_name n
The name is Richard Jones
- : unit = ()
# n
- : name = {name = &quot;Richard Jones&quot;; access_count = 1}
# print_name n
The name is Richard Jones
- : unit = ()
# n
- : name = {name = &quot;Richard Jones&quot;; access_count = 2}
</code></pre>
<p>Only fields explicitly marked as <code>mutable</code> can be assigned to using the
<code>&lt;-</code> operator. If you try to assign to a non-mutable field, OCaml won't
let you:</p>
<pre><code class="language-ocaml"># n.name &lt;- &quot;John Smith&quot;
Line 1, characters 1-23:
Error: The record field name is not mutable
</code></pre>
<p>References, with which we should be familiar by now, are implemented
using records with a mutable <code>contents</code> field. Check out the definition
in <code>Stdlib</code>:</p>
<pre><code class="language-ocaml">type 'a ref = {mutable contents : 'a}
</code></pre>
<p>And look closely at what the OCaml toplevel prints out for the value of
a reference:</p>
<pre><code class="language-ocaml"># let r = ref 100
val r : int Stdlib.ref = {Stdlib.contents = 100}
</code></pre>
<p>Arrays are another sort of mutable structure provided by OCaml. In
OCaml, plain lists are implemented as linked lists, and linked lists are
slow for some types of operation. For example, getting the head of a
list, or iterating over a list to perform some operation on each element
is reasonably fast. However, jumping to the n<sup>th</sup> element of a
list, or trying to randomly access a list - both are slow operations.
The OCaml <code>Array</code> type is a real array, so random access is fast, but
insertion and deletion of elements is slow. <code>Array</code>s are also mutable so
you can randomly change elements too.</p>
<p>The basics of arrays are simple:</p>
<pre><code class="language-ocaml"># let a = Array.create 10 0
Line 1, characters 9-21:
Alert deprecated: Stdlib.Array.create
Use Array.make instead.
val a : int array = [|0; 0; 0; 0; 0; 0; 0; 0; 0; 0|]
# for i = 0 to Array.length a - 1 do
  a.(i) &lt;- i
Line 3, characters 1-3:
Error: Syntax error
# a
- : int array = [|0; 0; 0; 0; 0; 0; 0; 0; 0; 0|]
</code></pre>
<p>Notice the syntax for writing arrays: <code>[| element; element; ... |]</code></p>
<p>The OCaml compiler was designed with heavy numerical processing in mind
(the sort of thing that FORTRAN is traditionally used for), and so it
contains various optimisations specifically for arrays of numbers,
vectors and matrices. Here is some benchmark code for doing dense matrix
multiplication. Notice that it uses for-loops and is generally very
imperative in style:</p>
<pre><code class="language-ocaml"># let size = 30
val size : int = 30

# let mkmatrix rows cols =
  let count = ref 1
  and last_col = cols - 1
  and m = Array.make_matrix rows cols 0 in
    for i = 0 to rows - 1 do
      let mi = m.(i) in
        for j = 0 to last_col do
          mi.(j) &lt;- !count;
          incr count
        done;
    done;
    m
val mkmatrix : int -&gt; int -&gt; int array array = &lt;fun&gt;

# let rec inner_loop k v m1i m2 j =
  if k &lt; 0 then v
  else inner_loop (k - 1) (v + m1i.(k) * m2.(k).(j)) m1i m2 j
val inner_loop : int -&gt; int -&gt; int array -&gt; int array array -&gt; int -&gt; int =
  &lt;fun&gt;

# let mmult rows cols m1 m2 m3 =
  let last_col = cols - 1
  and last_row = rows - 1 in
    for i = 0 to last_row do
      let m1i = m1.(i) and m3i = m3.(i) in
      for j = 0 to last_col do
        m3i.(j) &lt;- inner_loop last_row 0 m1i m2 j
      done;
    done
val mmult :
  int -&gt; int -&gt; int array array -&gt; int array array -&gt; int array array -&gt; unit =
  &lt;fun&gt;

# let () =
  let n =
    try int_of_string Sys.argv.(1)
    with Invalid_argument _ -&gt; 1
  and m1 = mkmatrix size size
  and m2 = mkmatrix size size
  and m3 = Array.make_matrix size size 0 in
    for i = 1 to n - 1 do
      mmult size size m1 m2 m3
    done;
    mmult size size m1 m2 m3;
    Printf.printf &quot;%d %d %d %d\\n&quot; m3.(0).(0) m3.(2).(3) m3.(3).(2) m3.(4).(4)
Exception: Failure &quot;int_of_string&quot;.
</code></pre>
<h2 id="mutually-recursive-functions">Mutually recursive functions</h2>
<p>Suppose I want to define two functions which call each other. This is
actually not a very common thing to do, but it can be useful sometimes.
Here's a contrived example (thanks to Ryan Tarpine): The number 0 is
even. Other numbers greater than 0 are even if their predecessor is odd.
Hence:</p>
<pre><code class="language-ocaml"># let rec even n =
  match n with
  | 0 -&gt; true
  | x -&gt; odd (x - 1)
Line 4, characters 10-13:
Error: Unbound value odd
</code></pre>
<p>The code above doesn't compile because we haven't defined the function
<code>odd</code> yet! That's easy though. Zero is not odd, and other numbers
greater than 0 are odd if their predecessor is even. So to make this
complete we need that function too:</p>
<pre><code class="language-ocaml"># let rec even n =
  match n with
  | 0 -&gt; true
  | x -&gt; odd (x - 1)
Line 4, characters 10-13:
Error: Unbound value odd
# let rec odd n =
  match n with
  | 0 -&gt; false
  | x -&gt; even (x - 1)
Line 4, characters 10-14:
Error: Unbound value even
</code></pre>
<p>The only problem is... this program doesn't compile. In order to compile
the <code>even</code> function, we already need the definition of <code>odd</code>, and to
compile <code>odd</code> we need the definition of <code>even</code>. So swapping the two
definitions around won't help either.</p>
<p>There are no &quot;forward prototypes&quot; (as seen in languages descended
from C) in OCaml but there is a special syntax
for defining a set of two or more mutually recursive functions, like
<code>odd</code> and <code>even</code>:</p>
<pre><code class="language-ocaml"># let rec even n =
  match n with
  | 0 -&gt; true
  | x -&gt; odd (x - 1)
Line 4, characters 10-13:
Error: Unbound value odd
</code></pre>
<p>You can also
use similar syntax for writing mutually recursive class definitions and
modules.</p>
|js}
  };
 
  { title = {js|Modules|js}
  ; slug = {js|modules|js}
  ; description = {js|Learn about OCaml modules and how they can be used to cleanly separate distinct parts of your program
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["language"]
  ; users = [`Beginner; `Intermediate]
  ; body_md = {js|
## Basic usage

In OCaml, every piece of code is wrapped into a module. Optionally, a module
itself can be a submodule of another module, pretty much like directories in a
file system - but we don't do this very often.

When you write a program let's say using two files `amodule.ml` and
`bmodule.ml`, each of these files automatically defines a module named
`Amodule` and a module named `Bmodule` that provide whatever you put into the
files.

Here is the code that we have in our file `amodule.ml`:

<!-- $MDX file=examples/amodule.ml -->
```ocaml
let hello () = print_endline "Hello"
```

And here is what we have in `bmodule.ml`:

<!-- $MDX file=examples/bmodule.ml -->
```ocaml
let () = Amodule.hello ()
```

We can compile the files in one command:

<!-- $MDX dir=examples -->
```sh
$ ocamlopt -o hello amodule.ml bmodule.ml
```

Or, as a build system might do, one by one:

<!-- $MDX dir=examples -->
```sh
$ ocamlopt -c amodule.ml
$ ocamlopt -c bmodule.ml
$ ocamlopt -o hello amodule.cmx bmodule.cmx
```

Now we have an executable that prints "Hello". As you can see, if you want to
access anything from a given module, use the name of the module (always
starting with a capital) followed by a dot and the thing that you want to use.
It may be a value, a type constructor, or anything else that a given module can
provide.

Libraries, starting with the standard library, provide collections of modules.
for example, `List.iter` designates the `iter` function from the `List` module.

If you are using a given module heavily, you may want to make its contents
directly accessible. For this, we use the `open` directive. In our example,
`bmodule.ml` could have been written:

<!-- $MDX skip -->
```ocaml
open Amodule
let () = hello ()
```

Using `open` or not is a matter of personal taste. Some modules provide names
that are used in many other modules. This is the case of the `List` module for
instance. Usually, we don't do `open List`. Other modules like `Printf` provide
names that are normally not subject to conflicts, such as `printf`. In order to
avoid writing `Printf.printf` all over the place, it often makes sense to place
one `open Printf` at the beginning of the file:

```ocaml
open Printf
let data = ["a"; "beautiful"; "day"]
let () = List.iter (printf "%s\\n") data
```

There are also local `open`s:

```ocaml
# let map_3d_matrix f m =
  let open Array in
    map (map (map f)) m
val map_3d_matrix :
  ('a -> 'b) -> 'a array array array -> 'b array array array = <fun>
# let map_3d_matrix' f =
  Array.(map (map (map f)))
val map_3d_matrix' :
  ('a -> 'b) -> 'a array array array -> 'b array array array = <fun>
```

## Interfaces and signatures

A module can provide a certain number of things (functions, types, submodules,
...) to the rest of the program that is using it. If nothing special is done,
everything which is defined in a module will be accessible from the outside. That's
often fine in small personal programs, but there are many situations where it
is better that a module only provides what it is meant to provide, not any of
the auxiliary functions and types that are used internally.

For this, we have to define a module interface, which will act as a mask over
the module's implementation. Just like a module derives from a .ml file, the
corresponding module interface or signature derives from an .mli file. It
contains a list of values with their type. Let's rewrite our `amodule.ml` file
to something called `amodule2.ml`:

<!-- $MDX file=examples/amodule2.ml -->
```ocaml
let hello () = print_endline "Hello"
```

As it is, `Amodule` has the following interface:

```ocaml
val message : string

val hello : unit -> unit
```
```mdx-error
Line 1, characters 1-21:
Error: Value declarations are only allowed in signatures
```

Let's assume that accessing the `message` value directly is none of the others
modules' business. We want to hide it by defining a restricted interface. This
is our `amodule2.mli` file:

<!-- $MDX file=examples/amodule2.mli -->
```ocaml
val hello : unit -> unit
(** Displays a greeting message. *)
```

(note the double asterisk at the beginning of the comment - it is a good habit
to document .mli files using the format supported by
[ocamldoc](/releases/{{! get LATEST_OCAML_VERSION_MAIN !}}/htmlman/ocamldoc.html))

Such .mli files must be compiled just before the matching .ml files. They are
compiled using `ocamlc`, even if .ml files are compiled to native code using
`ocamlopt`:

<!-- $MDX dir=examples -->
```sh
$ ocamlc -c amodule2.mli
$ ocamlopt -c amodule2.ml
```

## Abstract types

What about type definitions? We saw that values such as functions can be
exported by placing their name and their type in a .mli file, e.g.

<!-- $MDX skip -->
```ocaml
val hello : unit -> unit
```

But modules often define new types. Let's define a simple record type that
would represent a date:

```ocaml
type date = {day : int; month : int; year : int}
```

There are four options when it comes to writing the .mli file:

1. The type is completely omitted from the signature.
1. The type definition is copy-pasted into the signature.
1. The type is made abstract: only its name is given.
1. The record fields are made read-only: `type date = private { ... }`

Case 3 would look like this:

```ocaml
type date
```

Now, users of the module can manipulate objects of type `date`, but they can't
access the record fields directly. They must use the functions that the module
provides. Let's assume the module provides three functions, one for creating a
date, one for computing the difference between two dates, and one that returns
the date in years:

<!-- $MDX skip -->
```ocaml
type date

val create : ?days:int -> ?months:int -> ?years:int -> unit -> date

val sub : date -> date -> date

val years : date -> float
```

The point is that only `create` and `sub` can be used to create `date` records.
Therefore, it is not possible for the user of the module to create ill-formed
records. Actually, our implementation uses a record, but we could change it and
be sure that it will not break any code that relies on this module! This makes
a lot of sense in a library since subsequent versions of the same library can
continue to expose the same interface, while internally changing the
implementation, including data structures.

## Submodules

###  Submodule implementation

We saw that one `example.ml` file results automatically in one module
implementation named `Example`. Its module signature is automatically derived
and is the broadest possible, or can be restricted by writing an `example.mli`
file.

That said, a given module can also be defined explicitly from within a file.
That makes it a submodule of the current module. Let's consider this
`example.ml` file:

```ocaml
module Hello = struct
  let message = "Hello"
  let hello () = print_endline message
end

let goodbye () = print_endline "Goodbye"

let hello_goodbye () =
  Hello.hello ();
  goodbye ()
```

From another file, it is clear that we now have two levels of modules.  We can
write:

<!-- $MDX skip -->
```ocaml
let () =
  Example.Hello.hello ();
  Example.goodbye ()
```

###  Submodule interface

We can also restrict the interface of a given submodule. It is called a module
type. Let's do it in our `example.ml` file:

```ocaml
module Hello : sig
 val hello : unit -> unit
end
= 
struct
  let message = "Hello"
  let hello () = print_endline message
end
  
(* At this point, Hello.message is not accessible anymore. *)

let goodbye () = print_endline "Goodbye"

let hello_goodbye () =
  Hello.hello ();
  goodbye ()
```

The definition of the `Hello` module above is the equivalent of a
`hello.mli`/`hello.ml` pair of files. Writing all of that in one block of code
is not elegant so, in general, we prefer to define the module signature
separately:

<!-- $MDX skip -->
```ocaml
module type Hello_type = sig
 val hello : unit -> unit
end
  
module Hello : Hello_type = struct
  ...
end
```

`Hello_type` is a named module type, and can be reused to define other module
interfaces.

## Practical manipulation of modules

###  Displaying the interface of a module

You can use the `ocaml` toplevel to visualize the contents of an existing
module, such as `List`:

```ocaml
# #show List;;
module List = List
module List :
  sig
    type 'a t = 'a list = [] | (::) of 'a * 'a list
    val length : 'a t -> int
    val compare_lengths : 'a t -> 'b t -> int
    val compare_length_with : 'a t -> int -> int
    val cons : 'a -> 'a t -> 'a t
    val hd : 'a t -> 'a
    val tl : 'a t -> 'a t
    val nth : 'a t -> int -> 'a
    val nth_opt : 'a t -> int -> 'a option
    val rev : 'a t -> 'a t
    val init : int -> (int -> 'a) -> 'a t
    val append : 'a t -> 'a t -> 'a t
    val rev_append : 'a t -> 'a t -> 'a t
    val concat : 'a t t -> 'a t
    val flatten : 'a t t -> 'a t
    val iter : ('a -> unit) -> 'a t -> unit
    val iteri : (int -> 'a -> unit) -> 'a t -> unit
    val map : ('a -> 'b) -> 'a t -> 'b t
    val mapi : (int -> 'a -> 'b) -> 'a t -> 'b t
    val rev_map : ('a -> 'b) -> 'a t -> 'b t
    val filter_map : ('a -> 'b option) -> 'a t -> 'b t
    val concat_map : ('a -> 'b t) -> 'a t -> 'b t
    val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a
    val fold_right : ('a -> 'b -> 'b) -> 'a t -> 'b -> 'b
    val iter2 : ('a -> 'b -> unit) -> 'a t -> 'b t -> unit
    val map2 : ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t
    val rev_map2 : ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t
    val fold_left2 : ('a -> 'b -> 'c -> 'a) -> 'a -> 'b t -> 'c t -> 'a
    val fold_right2 : ('a -> 'b -> 'c -> 'c) -> 'a t -> 'b t -> 'c -> 'c
    val for_all : ('a -> bool) -> 'a t -> bool
    val exists : ('a -> bool) -> 'a t -> bool
    val for_all2 : ('a -> 'b -> bool) -> 'a t -> 'b t -> bool
    val exists2 : ('a -> 'b -> bool) -> 'a t -> 'b t -> bool
    val mem : 'a -> 'a t -> bool
    val memq : 'a -> 'a t -> bool
    val find : ('a -> bool) -> 'a t -> 'a
    val find_opt : ('a -> bool) -> 'a t -> 'a option
    val find_map : ('a -> 'b option) -> 'a t -> 'b option
    val filter : ('a -> bool) -> 'a t -> 'a t
    val find_all : ('a -> bool) -> 'a t -> 'a t
    val partition : ('a -> bool) -> 'a t -> 'a t * 'a t
    val assoc : 'a -> ('a * 'b) t -> 'b
    val assoc_opt : 'a -> ('a * 'b) t -> 'b option
    val assq : 'a -> ('a * 'b) t -> 'b
    val assq_opt : 'a -> ('a * 'b) t -> 'b option
    val mem_assoc : 'a -> ('a * 'b) t -> bool
    val mem_assq : 'a -> ('a * 'b) t -> bool
    val remove_assoc : 'a -> ('a * 'b) t -> ('a * 'b) t
    val remove_assq : 'a -> ('a * 'b) t -> ('a * 'b) t
    val split : ('a * 'b) t -> 'a t * 'b t
    val combine : 'a t -> 'b t -> ('a * 'b) t
    val sort : ('a -> 'a -> int) -> 'a t -> 'a t
    val stable_sort : ('a -> 'a -> int) -> 'a t -> 'a t
    val fast_sort : ('a -> 'a -> int) -> 'a t -> 'a t
    val sort_uniq : ('a -> 'a -> int) -> 'a t -> 'a t
    val merge : ('a -> 'a -> int) -> 'a t -> 'a t -> 'a t
    val to_seq : 'a t -> 'a Seq.t
    val of_seq : 'a Seq.t -> 'a t
  end
```

There is online documentation for each library.

###  Module inclusion

Let's say we feel that a function is missing from the standard `List` module,
but we really want it as if it were part of it. In an `extensions.ml` file, we
can achieve this effect by using the `include` directive:

```ocaml
# module List = struct
  include List
  let rec optmap f = function
    | [] -> []
    | hd :: tl ->
       match f hd with
       | None -> optmap f tl
       | Some x -> x :: optmap f tl
  end
module List :
  sig
    type 'a t = 'a list = [] | (::) of 'a * 'a list
    val length : 'a t -> int
    val compare_lengths : 'a t -> 'b t -> int
    val compare_length_with : 'a t -> int -> int
    val cons : 'a -> 'a t -> 'a t
    val hd : 'a t -> 'a
    val tl : 'a t -> 'a t
    val nth : 'a t -> int -> 'a
    val nth_opt : 'a t -> int -> 'a option
    val rev : 'a t -> 'a t
    val init : int -> (int -> 'a) -> 'a t
    val append : 'a t -> 'a t -> 'a t
    val rev_append : 'a t -> 'a t -> 'a t
    val concat : 'a t t -> 'a t
    val flatten : 'a t t -> 'a t
    val iter : ('a -> unit) -> 'a t -> unit
    val iteri : (int -> 'a -> unit) -> 'a t -> unit
    val map : ('a -> 'b) -> 'a t -> 'b t
    val mapi : (int -> 'a -> 'b) -> 'a t -> 'b t
    val rev_map : ('a -> 'b) -> 'a t -> 'b t
    val filter_map : ('a -> 'b option) -> 'a t -> 'b t
    val concat_map : ('a -> 'b t) -> 'a t -> 'b t
    val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a
    val fold_right : ('a -> 'b -> 'b) -> 'a t -> 'b -> 'b
    val iter2 : ('a -> 'b -> unit) -> 'a t -> 'b t -> unit
    val map2 : ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t
    val rev_map2 : ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t
    val fold_left2 : ('a -> 'b -> 'c -> 'a) -> 'a -> 'b t -> 'c t -> 'a
    val fold_right2 : ('a -> 'b -> 'c -> 'c) -> 'a t -> 'b t -> 'c -> 'c
    val for_all : ('a -> bool) -> 'a t -> bool
    val exists : ('a -> bool) -> 'a t -> bool
    val for_all2 : ('a -> 'b -> bool) -> 'a t -> 'b t -> bool
    val exists2 : ('a -> 'b -> bool) -> 'a t -> 'b t -> bool
    val mem : 'a -> 'a t -> bool
    val memq : 'a -> 'a t -> bool
    val find : ('a -> bool) -> 'a t -> 'a
    val find_opt : ('a -> bool) -> 'a t -> 'a option
    val find_map : ('a -> 'b option) -> 'a t -> 'b option
    val filter : ('a -> bool) -> 'a t -> 'a t
    val find_all : ('a -> bool) -> 'a t -> 'a t
    val partition : ('a -> bool) -> 'a t -> 'a t * 'a t
    val assoc : 'a -> ('a * 'b) t -> 'b
    val assoc_opt : 'a -> ('a * 'b) t -> 'b option
    val assq : 'a -> ('a * 'b) t -> 'b
    val assq_opt : 'a -> ('a * 'b) t -> 'b option
    val mem_assoc : 'a -> ('a * 'b) t -> bool
    val mem_assq : 'a -> ('a * 'b) t -> bool
    val remove_assoc : 'a -> ('a * 'b) t -> ('a * 'b) t
    val remove_assq : 'a -> ('a * 'b) t -> ('a * 'b) t
    val split : ('a * 'b) t -> 'a t * 'b t
    val combine : 'a t -> 'b t -> ('a * 'b) t
    val sort : ('a -> 'a -> int) -> 'a t -> 'a t
    val stable_sort : ('a -> 'a -> int) -> 'a t -> 'a t
    val fast_sort : ('a -> 'a -> int) -> 'a t -> 'a t
    val sort_uniq : ('a -> 'a -> int) -> 'a t -> 'a t
    val merge : ('a -> 'a -> int) -> 'a t -> 'a t -> 'a t
    val to_seq : 'a t -> 'a Seq.t
    val of_seq : 'a Seq.t -> 'a t
    val optmap : ('a -> 'b option) -> 'a t -> 'b t
  end
```

It creates a module `Extensions.List` that has everything the standard `List`
module has, plus a new `optmap` function. From another file, all we have to do
to override the default `List` module is `open Extensions` at the beginning of
the .ml file:

<!-- $MDX skip -->
```ocaml
open Extensions

...

List.optmap ...
```
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#basic-usage">Basic usage</a>
</li>
<li><a href="#interfaces-and-signatures">Interfaces and signatures</a>
</li>
<li><a href="#abstract-types">Abstract types</a>
</li>
<li><a href="#submodules">Submodules</a>
</li>
<li><a href="#practical-manipulation-of-modules">Practical manipulation of modules</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<h2 id="basic-usage">Basic usage</h2>
<p>In OCaml, every piece of code is wrapped into a module. Optionally, a module
itself can be a submodule of another module, pretty much like directories in a
file system - but we don't do this very often.</p>
<p>When you write a program let's say using two files <code>amodule.ml</code> and
<code>bmodule.ml</code>, each of these files automatically defines a module named
<code>Amodule</code> and a module named <code>Bmodule</code> that provide whatever you put into the
files.</p>
<p>Here is the code that we have in our file <code>amodule.ml</code>:</p>
<!-- $MDX file=examples/amodule.ml -->
<pre><code class="language-ocaml">let hello () = print_endline &quot;Hello&quot;
</code></pre>
<p>And here is what we have in <code>bmodule.ml</code>:</p>
<!-- $MDX file=examples/bmodule.ml -->
<pre><code class="language-ocaml">let () = Amodule.hello ()
</code></pre>
<p>We can compile the files in one command:</p>
<!-- $MDX dir=examples -->
<pre><code class="language-sh">$ ocamlopt -o hello amodule.ml bmodule.ml
</code></pre>
<p>Or, as a build system might do, one by one:</p>
<!-- $MDX dir=examples -->
<pre><code class="language-sh">$ ocamlopt -c amodule.ml
$ ocamlopt -c bmodule.ml
$ ocamlopt -o hello amodule.cmx bmodule.cmx
</code></pre>
<p>Now we have an executable that prints &quot;Hello&quot;. As you can see, if you want to
access anything from a given module, use the name of the module (always
starting with a capital) followed by a dot and the thing that you want to use.
It may be a value, a type constructor, or anything else that a given module can
provide.</p>
<p>Libraries, starting with the standard library, provide collections of modules.
for example, <code>List.iter</code> designates the <code>iter</code> function from the <code>List</code> module.</p>
<p>If you are using a given module heavily, you may want to make its contents
directly accessible. For this, we use the <code>open</code> directive. In our example,
<code>bmodule.ml</code> could have been written:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">open Amodule
let () = hello ()
</code></pre>
<p>Using <code>open</code> or not is a matter of personal taste. Some modules provide names
that are used in many other modules. This is the case of the <code>List</code> module for
instance. Usually, we don't do <code>open List</code>. Other modules like <code>Printf</code> provide
names that are normally not subject to conflicts, such as <code>printf</code>. In order to
avoid writing <code>Printf.printf</code> all over the place, it often makes sense to place
one <code>open Printf</code> at the beginning of the file:</p>
<pre><code class="language-ocaml">open Printf
let data = [&quot;a&quot;; &quot;beautiful&quot;; &quot;day&quot;]
let () = List.iter (printf &quot;%s\\n&quot;) data
</code></pre>
<p>There are also local <code>open</code>s:</p>
<pre><code class="language-ocaml"># let map_3d_matrix f m =
  let open Array in
    map (map (map f)) m
val map_3d_matrix :
  ('a -&gt; 'b) -&gt; 'a array array array -&gt; 'b array array array = &lt;fun&gt;
# let map_3d_matrix' f =
  Array.(map (map (map f)))
val map_3d_matrix' :
  ('a -&gt; 'b) -&gt; 'a array array array -&gt; 'b array array array = &lt;fun&gt;
</code></pre>
<h2 id="interfaces-and-signatures">Interfaces and signatures</h2>
<p>A module can provide a certain number of things (functions, types, submodules,
...) to the rest of the program that is using it. If nothing special is done,
everything which is defined in a module will be accessible from the outside. That's
often fine in small personal programs, but there are many situations where it
is better that a module only provides what it is meant to provide, not any of
the auxiliary functions and types that are used internally.</p>
<p>For this, we have to define a module interface, which will act as a mask over
the module's implementation. Just like a module derives from a .ml file, the
corresponding module interface or signature derives from an .mli file. It
contains a list of values with their type. Let's rewrite our <code>amodule.ml</code> file
to something called <code>amodule2.ml</code>:</p>
<!-- $MDX file=examples/amodule2.ml -->
<pre><code class="language-ocaml">let hello () = print_endline &quot;Hello&quot;
</code></pre>
<p>As it is, <code>Amodule</code> has the following interface:</p>
<pre><code class="language-ocaml">val message : string

val hello : unit -&gt; unit
</code></pre>
<pre><code class="language-mdx-error">Line 1, characters 1-21:
Error: Value declarations are only allowed in signatures
</code></pre>
<p>Let's assume that accessing the <code>message</code> value directly is none of the others
modules' business. We want to hide it by defining a restricted interface. This
is our <code>amodule2.mli</code> file:</p>
<!-- $MDX file=examples/amodule2.mli -->
<pre><code class="language-ocaml">val hello : unit -&gt; unit
(** Displays a greeting message. *)
</code></pre>
<p>(note the double asterisk at the beginning of the comment - it is a good habit
to document .mli files using the format supported by
[ocamldoc](/releases/{{! get LATEST_OCAML_VERSION_MAIN !}}/htmlman/ocamldoc.html))</p>
<p>Such .mli files must be compiled just before the matching .ml files. They are
compiled using <code>ocamlc</code>, even if .ml files are compiled to native code using
<code>ocamlopt</code>:</p>
<!-- $MDX dir=examples -->
<pre><code class="language-sh">$ ocamlc -c amodule2.mli
$ ocamlopt -c amodule2.ml
</code></pre>
<h2 id="abstract-types">Abstract types</h2>
<p>What about type definitions? We saw that values such as functions can be
exported by placing their name and their type in a .mli file, e.g.</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">val hello : unit -&gt; unit
</code></pre>
<p>But modules often define new types. Let's define a simple record type that
would represent a date:</p>
<pre><code class="language-ocaml">type date = {day : int; month : int; year : int}
</code></pre>
<p>There are four options when it comes to writing the .mli file:</p>
<ol>
<li>The type is completely omitted from the signature.
</li>
<li>The type definition is copy-pasted into the signature.
</li>
<li>The type is made abstract: only its name is given.
</li>
<li>The record fields are made read-only: <code>type date = private { ... }</code>
</li>
</ol>
<p>Case 3 would look like this:</p>
<pre><code class="language-ocaml">type date
</code></pre>
<p>Now, users of the module can manipulate objects of type <code>date</code>, but they can't
access the record fields directly. They must use the functions that the module
provides. Let's assume the module provides three functions, one for creating a
date, one for computing the difference between two dates, and one that returns
the date in years:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">type date

val create : ?days:int -&gt; ?months:int -&gt; ?years:int -&gt; unit -&gt; date

val sub : date -&gt; date -&gt; date

val years : date -&gt; float
</code></pre>
<p>The point is that only <code>create</code> and <code>sub</code> can be used to create <code>date</code> records.
Therefore, it is not possible for the user of the module to create ill-formed
records. Actually, our implementation uses a record, but we could change it and
be sure that it will not break any code that relies on this module! This makes
a lot of sense in a library since subsequent versions of the same library can
continue to expose the same interface, while internally changing the
implementation, including data structures.</p>
<h2 id="submodules">Submodules</h2>
<h3 id="submodule-implementation">Submodule implementation</h3>
<p>We saw that one <code>example.ml</code> file results automatically in one module
implementation named <code>Example</code>. Its module signature is automatically derived
and is the broadest possible, or can be restricted by writing an <code>example.mli</code>
file.</p>
<p>That said, a given module can also be defined explicitly from within a file.
That makes it a submodule of the current module. Let's consider this
<code>example.ml</code> file:</p>
<pre><code class="language-ocaml">module Hello = struct
  let message = &quot;Hello&quot;
  let hello () = print_endline message
end

let goodbye () = print_endline &quot;Goodbye&quot;

let hello_goodbye () =
  Hello.hello ();
  goodbye ()
</code></pre>
<p>From another file, it is clear that we now have two levels of modules.  We can
write:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let () =
  Example.Hello.hello ();
  Example.goodbye ()
</code></pre>
<h3 id="submodule-interface">Submodule interface</h3>
<p>We can also restrict the interface of a given submodule. It is called a module
type. Let's do it in our <code>example.ml</code> file:</p>
<pre><code class="language-ocaml">module Hello : sig
 val hello : unit -&gt; unit
end
= 
struct
  let message = &quot;Hello&quot;
  let hello () = print_endline message
end
  
(* At this point, Hello.message is not accessible anymore. *)

let goodbye () = print_endline &quot;Goodbye&quot;

let hello_goodbye () =
  Hello.hello ();
  goodbye ()
</code></pre>
<p>The definition of the <code>Hello</code> module above is the equivalent of a
<code>hello.mli</code>/<code>hello.ml</code> pair of files. Writing all of that in one block of code
is not elegant so, in general, we prefer to define the module signature
separately:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">module type Hello_type = sig
 val hello : unit -&gt; unit
end
  
module Hello : Hello_type = struct
  ...
end
</code></pre>
<p><code>Hello_type</code> is a named module type, and can be reused to define other module
interfaces.</p>
<h2 id="practical-manipulation-of-modules">Practical manipulation of modules</h2>
<h3 id="displaying-the-interface-of-a-module">Displaying the interface of a module</h3>
<p>You can use the <code>ocaml</code> toplevel to visualize the contents of an existing
module, such as <code>List</code>:</p>
<pre><code class="language-ocaml"># #show List;;
module List = List
module List :
  sig
    type 'a t = 'a list = [] | (::) of 'a * 'a list
    val length : 'a t -&gt; int
    val compare_lengths : 'a t -&gt; 'b t -&gt; int
    val compare_length_with : 'a t -&gt; int -&gt; int
    val cons : 'a -&gt; 'a t -&gt; 'a t
    val hd : 'a t -&gt; 'a
    val tl : 'a t -&gt; 'a t
    val nth : 'a t -&gt; int -&gt; 'a
    val nth_opt : 'a t -&gt; int -&gt; 'a option
    val rev : 'a t -&gt; 'a t
    val init : int -&gt; (int -&gt; 'a) -&gt; 'a t
    val append : 'a t -&gt; 'a t -&gt; 'a t
    val rev_append : 'a t -&gt; 'a t -&gt; 'a t
    val concat : 'a t t -&gt; 'a t
    val flatten : 'a t t -&gt; 'a t
    val iter : ('a -&gt; unit) -&gt; 'a t -&gt; unit
    val iteri : (int -&gt; 'a -&gt; unit) -&gt; 'a t -&gt; unit
    val map : ('a -&gt; 'b) -&gt; 'a t -&gt; 'b t
    val mapi : (int -&gt; 'a -&gt; 'b) -&gt; 'a t -&gt; 'b t
    val rev_map : ('a -&gt; 'b) -&gt; 'a t -&gt; 'b t
    val filter_map : ('a -&gt; 'b option) -&gt; 'a t -&gt; 'b t
    val concat_map : ('a -&gt; 'b t) -&gt; 'a t -&gt; 'b t
    val fold_left : ('a -&gt; 'b -&gt; 'a) -&gt; 'a -&gt; 'b t -&gt; 'a
    val fold_right : ('a -&gt; 'b -&gt; 'b) -&gt; 'a t -&gt; 'b -&gt; 'b
    val iter2 : ('a -&gt; 'b -&gt; unit) -&gt; 'a t -&gt; 'b t -&gt; unit
    val map2 : ('a -&gt; 'b -&gt; 'c) -&gt; 'a t -&gt; 'b t -&gt; 'c t
    val rev_map2 : ('a -&gt; 'b -&gt; 'c) -&gt; 'a t -&gt; 'b t -&gt; 'c t
    val fold_left2 : ('a -&gt; 'b -&gt; 'c -&gt; 'a) -&gt; 'a -&gt; 'b t -&gt; 'c t -&gt; 'a
    val fold_right2 : ('a -&gt; 'b -&gt; 'c -&gt; 'c) -&gt; 'a t -&gt; 'b t -&gt; 'c -&gt; 'c
    val for_all : ('a -&gt; bool) -&gt; 'a t -&gt; bool
    val exists : ('a -&gt; bool) -&gt; 'a t -&gt; bool
    val for_all2 : ('a -&gt; 'b -&gt; bool) -&gt; 'a t -&gt; 'b t -&gt; bool
    val exists2 : ('a -&gt; 'b -&gt; bool) -&gt; 'a t -&gt; 'b t -&gt; bool
    val mem : 'a -&gt; 'a t -&gt; bool
    val memq : 'a -&gt; 'a t -&gt; bool
    val find : ('a -&gt; bool) -&gt; 'a t -&gt; 'a
    val find_opt : ('a -&gt; bool) -&gt; 'a t -&gt; 'a option
    val find_map : ('a -&gt; 'b option) -&gt; 'a t -&gt; 'b option
    val filter : ('a -&gt; bool) -&gt; 'a t -&gt; 'a t
    val find_all : ('a -&gt; bool) -&gt; 'a t -&gt; 'a t
    val partition : ('a -&gt; bool) -&gt; 'a t -&gt; 'a t * 'a t
    val assoc : 'a -&gt; ('a * 'b) t -&gt; 'b
    val assoc_opt : 'a -&gt; ('a * 'b) t -&gt; 'b option
    val assq : 'a -&gt; ('a * 'b) t -&gt; 'b
    val assq_opt : 'a -&gt; ('a * 'b) t -&gt; 'b option
    val mem_assoc : 'a -&gt; ('a * 'b) t -&gt; bool
    val mem_assq : 'a -&gt; ('a * 'b) t -&gt; bool
    val remove_assoc : 'a -&gt; ('a * 'b) t -&gt; ('a * 'b) t
    val remove_assq : 'a -&gt; ('a * 'b) t -&gt; ('a * 'b) t
    val split : ('a * 'b) t -&gt; 'a t * 'b t
    val combine : 'a t -&gt; 'b t -&gt; ('a * 'b) t
    val sort : ('a -&gt; 'a -&gt; int) -&gt; 'a t -&gt; 'a t
    val stable_sort : ('a -&gt; 'a -&gt; int) -&gt; 'a t -&gt; 'a t
    val fast_sort : ('a -&gt; 'a -&gt; int) -&gt; 'a t -&gt; 'a t
    val sort_uniq : ('a -&gt; 'a -&gt; int) -&gt; 'a t -&gt; 'a t
    val merge : ('a -&gt; 'a -&gt; int) -&gt; 'a t -&gt; 'a t -&gt; 'a t
    val to_seq : 'a t -&gt; 'a Seq.t
    val of_seq : 'a Seq.t -&gt; 'a t
  end
</code></pre>
<p>There is online documentation for each library.</p>
<h3 id="module-inclusion">Module inclusion</h3>
<p>Let's say we feel that a function is missing from the standard <code>List</code> module,
but we really want it as if it were part of it. In an <code>extensions.ml</code> file, we
can achieve this effect by using the <code>include</code> directive:</p>
<pre><code class="language-ocaml"># module List = struct
  include List
  let rec optmap f = function
    | [] -&gt; []
    | hd :: tl -&gt;
       match f hd with
       | None -&gt; optmap f tl
       | Some x -&gt; x :: optmap f tl
  end
module List :
  sig
    type 'a t = 'a list = [] | (::) of 'a * 'a list
    val length : 'a t -&gt; int
    val compare_lengths : 'a t -&gt; 'b t -&gt; int
    val compare_length_with : 'a t -&gt; int -&gt; int
    val cons : 'a -&gt; 'a t -&gt; 'a t
    val hd : 'a t -&gt; 'a
    val tl : 'a t -&gt; 'a t
    val nth : 'a t -&gt; int -&gt; 'a
    val nth_opt : 'a t -&gt; int -&gt; 'a option
    val rev : 'a t -&gt; 'a t
    val init : int -&gt; (int -&gt; 'a) -&gt; 'a t
    val append : 'a t -&gt; 'a t -&gt; 'a t
    val rev_append : 'a t -&gt; 'a t -&gt; 'a t
    val concat : 'a t t -&gt; 'a t
    val flatten : 'a t t -&gt; 'a t
    val iter : ('a -&gt; unit) -&gt; 'a t -&gt; unit
    val iteri : (int -&gt; 'a -&gt; unit) -&gt; 'a t -&gt; unit
    val map : ('a -&gt; 'b) -&gt; 'a t -&gt; 'b t
    val mapi : (int -&gt; 'a -&gt; 'b) -&gt; 'a t -&gt; 'b t
    val rev_map : ('a -&gt; 'b) -&gt; 'a t -&gt; 'b t
    val filter_map : ('a -&gt; 'b option) -&gt; 'a t -&gt; 'b t
    val concat_map : ('a -&gt; 'b t) -&gt; 'a t -&gt; 'b t
    val fold_left : ('a -&gt; 'b -&gt; 'a) -&gt; 'a -&gt; 'b t -&gt; 'a
    val fold_right : ('a -&gt; 'b -&gt; 'b) -&gt; 'a t -&gt; 'b -&gt; 'b
    val iter2 : ('a -&gt; 'b -&gt; unit) -&gt; 'a t -&gt; 'b t -&gt; unit
    val map2 : ('a -&gt; 'b -&gt; 'c) -&gt; 'a t -&gt; 'b t -&gt; 'c t
    val rev_map2 : ('a -&gt; 'b -&gt; 'c) -&gt; 'a t -&gt; 'b t -&gt; 'c t
    val fold_left2 : ('a -&gt; 'b -&gt; 'c -&gt; 'a) -&gt; 'a -&gt; 'b t -&gt; 'c t -&gt; 'a
    val fold_right2 : ('a -&gt; 'b -&gt; 'c -&gt; 'c) -&gt; 'a t -&gt; 'b t -&gt; 'c -&gt; 'c
    val for_all : ('a -&gt; bool) -&gt; 'a t -&gt; bool
    val exists : ('a -&gt; bool) -&gt; 'a t -&gt; bool
    val for_all2 : ('a -&gt; 'b -&gt; bool) -&gt; 'a t -&gt; 'b t -&gt; bool
    val exists2 : ('a -&gt; 'b -&gt; bool) -&gt; 'a t -&gt; 'b t -&gt; bool
    val mem : 'a -&gt; 'a t -&gt; bool
    val memq : 'a -&gt; 'a t -&gt; bool
    val find : ('a -&gt; bool) -&gt; 'a t -&gt; 'a
    val find_opt : ('a -&gt; bool) -&gt; 'a t -&gt; 'a option
    val find_map : ('a -&gt; 'b option) -&gt; 'a t -&gt; 'b option
    val filter : ('a -&gt; bool) -&gt; 'a t -&gt; 'a t
    val find_all : ('a -&gt; bool) -&gt; 'a t -&gt; 'a t
    val partition : ('a -&gt; bool) -&gt; 'a t -&gt; 'a t * 'a t
    val assoc : 'a -&gt; ('a * 'b) t -&gt; 'b
    val assoc_opt : 'a -&gt; ('a * 'b) t -&gt; 'b option
    val assq : 'a -&gt; ('a * 'b) t -&gt; 'b
    val assq_opt : 'a -&gt; ('a * 'b) t -&gt; 'b option
    val mem_assoc : 'a -&gt; ('a * 'b) t -&gt; bool
    val mem_assq : 'a -&gt; ('a * 'b) t -&gt; bool
    val remove_assoc : 'a -&gt; ('a * 'b) t -&gt; ('a * 'b) t
    val remove_assq : 'a -&gt; ('a * 'b) t -&gt; ('a * 'b) t
    val split : ('a * 'b) t -&gt; 'a t * 'b t
    val combine : 'a t -&gt; 'b t -&gt; ('a * 'b) t
    val sort : ('a -&gt; 'a -&gt; int) -&gt; 'a t -&gt; 'a t
    val stable_sort : ('a -&gt; 'a -&gt; int) -&gt; 'a t -&gt; 'a t
    val fast_sort : ('a -&gt; 'a -&gt; int) -&gt; 'a t -&gt; 'a t
    val sort_uniq : ('a -&gt; 'a -&gt; int) -&gt; 'a t -&gt; 'a t
    val merge : ('a -&gt; 'a -&gt; int) -&gt; 'a t -&gt; 'a t -&gt; 'a t
    val to_seq : 'a t -&gt; 'a Seq.t
    val of_seq : 'a Seq.t -&gt; 'a t
    val optmap : ('a -&gt; 'b option) -&gt; 'a t -&gt; 'b t
  end
</code></pre>
<p>It creates a module <code>Extensions.List</code> that has everything the standard <code>List</code>
module has, plus a new <code>optmap</code> function. From another file, all we have to do
to override the default <code>List</code> module is <code>open Extensions</code> at the beginning of
the .ml file:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">open Extensions

...

List.optmap ...
</code></pre>
|js}
  };
 
  { title = {js|Labels|js}
  ; slug = {js|labels|js}
  ; description = {js|Provide labels to your functions arguments
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["language"]
  ; users = [`Intermediate; `Advanced]
  ; body_md = {js|
## Labelled and optional arguments to functions

Python has a nice syntax for writing arguments to functions. Here's
an example (from the Python tutorial, since I'm not a Python
programmer):

```python
def ask_ok(prompt, retries=4, complaint='Yes or no, please!'):
  # function definition omitted
```
Here are the ways we can call this Python function:

```python
ask_ok ('Do you really want to quit?')
ask_ok ('Overwrite the file?', 2)
ask_ok (prompt='Are you sure?')
ask_ok (complaint='Please answer yes or no!', prompt='Are you sure?')
```

Notice that in Python we are allowed to name arguments when we call
them, or use the usual function call syntax, and we can have optional
arguments with default values.

OCaml also has a way to label arguments and have optional arguments with
default values.

The basic syntax is:

```ocaml
# let rec range ~first:a ~last:b =
  if a > b then []
  else a :: range ~first:(a + 1) ~last:b
val range : first:int -> last:int -> int list = <fun>
```

(Notice that both `to` and `end` are reserved words in OCaml, so they
cannot be used as labels. So you cannot have `~from/~to` or
`~start/~end`.)

The type of our previous `range` function was:

<!-- $MDX skip -->
```ocaml
range : int -> int -> int list
```

And the type of our new `range` function with labelled arguments is:

```ocaml
# range
- : first:int -> last:int -> int list = <fun>
```

Confusingly, the `~` (tilde) is *not* shown in the type definition, but
you need to use it everywhere else.

With labelled arguments, it doesn't matter which order you give the
arguments anymore:

```ocaml
# range ~first:1 ~last:10
- : int list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]
# range ~last:10 ~first:1
- : int list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]
```

There is also a shorthand way to name the arguments, so that the label
is the same as the variable in the function definition:

```ocaml
# let may ~f x =
  match x with
  | None -> ()
  | Some x -> ignore (f x)
val may : f:('a -> 'b) -> 'a option -> unit = <fun>
```

It's worth spending some time working out exactly what this function
does, and also working out by hand its type signature. There's a lot
going on. First of all, the parameter `~f` is just shorthand for `~f:f`
(ie. the label is `~f` and the variable used in the function is `f`).
Secondly notice that the function takes two parameters. The second
parameter (`x`) is unlabelled - it is permitted for a function to take a
mixture of labelled and unlabelled arguments if you want.

What is the type of the labelled `f` parameter? Obviously it's a
function of some sort.

What is the type of the unlabelled `x` parameter? The `match` clause
gives us a clue. It's an `'a option`.

This tells us that `f` takes an `'a` parameter, and the return value of
`f` is ignored, so it could be anything. The type of `f` is therefore
`'a -> 'b`.

The `may` function as a whole returns `unit`. Notice in each case of the
`match` the result is `()`.

Thus the type of the `may` function is (and you can verify this in the
OCaml interactive toplevel if you want):

```ocaml
# may
- : f:('a -> 'b) -> 'a option -> unit = <fun>
```
What does this function do? Running the function in the OCaml toplevel
gives us some clues:

```ocaml
# may ~f:print_endline None
- : unit = ()
# may ~f:print_endline (Some "hello")
hello
- : unit = ()
```

If the unlabelled argument is a “null pointer” then `may` does nothing.
Otherwise `may` calls the `f` function on the argument. Why is this
useful? We're just about to find out ...

###  Optional arguments
Optional arguments are like labelled arguments, but we use `?` instead
of `~` in front of them. Here is an example:

```ocaml
# let rec range ?(step=1) a b =
  if a > b then []
  else a :: range ~step (a + step) b
val range : ?step:int -> int -> int -> int list = <fun>
```

Note the somewhat confusing syntax, switching between `?` and `~`. We'll
talk about that in the next section. Here is how you call this function:

```ocaml
# range 1 10
- : int list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]
# range 1 10 ~step:2
- : int list = [1; 3; 5; 7; 9]
```

In this case, `?(step=1)` fairly obviously means that `~step` is an
optional argument which defaults to 1. We can also omit the default
value and just have an optional argument. This example is modified from
lablgtk:

```ocaml
# type window =
  {mutable title: string;
   mutable width: int;
   mutable height: int}
type window = {
  mutable title : string;
  mutable width : int;
  mutable height : int;
}
# let create_window () =
  {title = "none"; width = 640; height = 480;}
val create_window : unit -> window = <fun>
# let set_title window title =
  window.title <- title
val set_title : window -> string -> unit = <fun>
# let set_width window width =
  window.width <- width
val set_width : window -> int -> unit = <fun>
# let set_height window height =
  window.height <- height
val set_height : window -> int -> unit = <fun>
# let open_window ?title ?width ?height () =
  let window = create_window () in
  may ~f:(set_title window) title;
  may ~f:(set_width window) width;
  may ~f:(set_height window) height;
  window
val open_window :
  ?title:string -> ?width:int -> ?height:int -> unit -> window = <fun>
```

This example is significantly complex and quite subtle, but the pattern
used is very common in the lablgtk source code. Let's concentrate on the
simple `create_window` function first. This function takes a `unit` and
returns a `window`, initialized with default settings for title, width
and height:

```ocaml
# create_window ()
- : window = {title = "none"; width = 640; height = 480}
```

The `set_title`, `set_width` and `set_height` functions are impure
functions which modify the `window` structure, in the obvious way. For
example:

```ocaml
# let w = create_window () in
  set_title w "My Application";
  w
- : window = {title = "My Application"; width = 640; height = 480}
```

So far this is just the imperative "mutable records" which we talked
about in the previous chapter. Now the complex part is the `open_window`
function. This function takes *4* arguments, three of them optional,
followed by a required, unlabelled `unit`. Let's first see this function
in action:

```ocaml
# open_window ~title:"My Application" ()
- : window = {title = "My Application"; width = 640; height = 480}
# open_window ~title:"Clock" ~width:128 ~height:128 ()
- : window = {title = "Clock"; width = 128; height = 128}
```

It does what you expect, but how?! The secret is in the `may` function
(see above) and the fact that the optional parameters *don't* have
defaults.

When an optional parameter doesn't have a default, then it has type
`'a option`. The `'a` would normally be inferred by type inference, so
in the case of `?title` above, this has type `string option`.

Remember the `may` function? It takes a function and an argument, and
calls the function on the argument provided the argument isn't `None`.
So:

<!-- $MDX skip -->
```ocaml
# may ~f:(set_title window) title
```

If the optional title argument is not specified by the caller, then
`title` = `None`, so `may` does nothing. But if we call the function
with, for example,

```ocaml
# open_window ~title:"My Application" ()
- : window = {title = "My Application"; width = 640; height = 480}
```

then `title` = `Some "My Application"`, and `may` therefore calls
`set_title window "My Application"`.

You should make sure you fully understand this example before proceeding
to the next section.

###  "Warning: This optional argument cannot be erased"
We've just touched upon labels and optional arguments, but even this
brief explanation should have raised several questions. The first may be
why the extra `unit` argument to `open_window`? Let's try defining this
function without the extra `unit`:

```ocaml
# let open_window ?title ?width ?height =
  let window = create_window () in
  may ~f:(set_title window) title;
  may ~f:(set_width window) width;
  may ~f:(set_height window) height;
  window
Line 1, characters 32-38:
Warning 16: this optional argument cannot be erased.
val open_window : ?title:string -> ?width:int -> ?height:int -> window =
  <fun>
```

Although OCaml has compiled the function, it has generated a somewhat
infamous warning: "This optional argument cannot be erased", referring
to the final `?height` argument. To try to show what's going on here,
let's call our modified `open_window` function:

```ocaml
# open_window
- : ?title:string -> ?width:int -> ?height:int -> window = <fun>
# open_window ~title:"My Application"
- : ?width:int -> ?height:int -> window = <fun>
```

Did that work or not? No it didn't. In fact it didn't even run the
`open_window` function at all. Instead it printed some strange type
information. What's going on?

Recall currying and uncurrying, and partial application of functions. If
we have a function `plus` defined as:

```ocaml
# let plus x y =
  x + y
val plus : int -> int -> int = <fun>
```
We can partially apply this, for example as `plus 2` which is "the
function that adds 2 to things":

```ocaml
# let f = plus 2
val f : int -> int = <fun>
# f 5
- : int = 7
# f 100
- : int = 102
```

In the `plus` example, the OCaml compiler can easily work out that
`plus 2` doesn't have enough arguments supplied yet. It needs another
argument before the `plus` function itself can be executed. Therefore
`plus 2` is a function which is waiting for its extra argument to come
along.

Things are not so clear when we add optional arguments into the mix. The
call to `open_window;;` above is a case in point. Does the user mean
"execute `open_window` now"? Or does the user mean to supply some or all
of the optional arguments later? Is `open_window;;` waiting for extra
arguments to come along like `plus 2`?

OCaml plays it safe and doesn't execute `open_window`. Instead it treats
it as a partial function application. The expression `open_window`
literally evaluates to a function value.

Let's go back to the original and working definition of `open_window`
where we had the extra unlabelled `unit` argument at the end:

```ocaml
# let open_window ?title ?width ?height () =
  let window = create_window () in
  may ~f:(set_title window) title;
  may ~f:(set_width window) width;
  may ~f:(set_height window) height;
  window
val open_window :
  ?title:string -> ?width:int -> ?height:int -> unit -> window = <fun>
```

If you want to pass optional arguments to `open_window` you must do so
before the final `unit`, so if you type:

```ocaml
# open_window ()
- : window = {title = "none"; width = 640; height = 480}
```
you must mean "execute `open_window` now with all optional arguments
unspecified". Whereas if you type:

```ocaml
# open_window
- : ?title:string -> ?width:int -> ?height:int -> unit -> window = <fun>
```
you mean "give me the functional value" or (more usually in the
toplevel) "print out the type of `open_window`".

###  More `~`shorthand
Let's rewrite the `range` function yet again, this time using as much
shorthand as possible for the labels:

```ocaml
# let rec range ~first ~last =
  if first > last then []
  else first :: range ~first:(first + 1) ~last
val range : first:int -> last:int -> int list = <fun>
```

Recall that `~foo` on its own is short for `~foo:foo`. This applies also
when calling functions as well as declaring the arguments to functions,
hence in the above the highlighted red `~last` is short for
`~last:last`.

###  Using `?foo` in a function call
There's another little wrinkle concerning optional arguments. Suppose we
write a function around `open_window` to open up an application:

```ocaml
# let open_application ?width ?height () =
  open_window ~title:"My Application" ~width ~height
Line 2, characters 40-45:
Error: This expression has type 'a option
       but an expression was expected of type int
```

Recall that `~width` is shorthand for `~width:width`. The type of
`width` is `'a option`, but `open_window ~width:` expects an `int`.

OCaml provides more syntactic sugar. Writing `?width` in the function
call is shorthand for writing `~width:(unwrap width)` where `unwrap`
would be a function which would remove the "`option` wrapper" around
`width` (it's not actually possible to write an `unwrap` function like
this, but conceptually that's the idea). So the correct way to write
this function is:

```ocaml
# let open_application ?width ?height () =
  open_window ~title:"My Application" ?width ?height
val open_application : ?width:int -> ?height:int -> unit -> unit -> window =
  <fun>
```

###  When and when not to use `~` and `?`
The syntax for labels and optional arguments is confusing, and you may
often wonder when to use `~foo`, when to use `?foo` and when to use
plain `foo`. It's something of a black art which takes practice to get
right.

`?foo` is only used when declaring the arguments of a function, ie:

<!-- $MDX skip -->
```ocaml
let f ?arg1 ... =
```

or when using the specialised "unwrap `option` wrapper" form for
function calls:

```ocaml
# let open_application ?width ?height () =
  open_window ~title:"My Application" ?width ?height
val open_application : ?width:int -> ?height:int -> unit -> unit -> window =
  <fun>
```
The declaration `?foo` creates a variable called `foo`, so if you need
the value of `?foo`, use just `foo`.

The same applies to labels. Only use the `~foo` form when declaring
arguments of a function, ie:

<!-- $MDX skip -->
```ocaml
let f ~foo:foo ... =
```

The declaration `~foo:foo` creates a variable called simply `foo`, so if
you need the value just use plain `foo`.

Things, however, get complicated for two reasons: first, the shorthand
form `~foo` (equivalent to `~foo:foo`), and second, when you call a
function which takes a labelled or optional argument and you use the
shorthand form.

Here is some apparently obscure code from lablgtk to demonstrate all of
this:

<!-- $MDX skip -->
```ocaml
# let html ?border_width ?width ?height ?packing ?show () =  (* line 1 *)
  let w = create () in
  load_empty w;
  Container.set w ?border_width ?width ?height;            (* line 4 *)
  pack_return (new html w) ~packing ~show                  (* line 5 *)
```
On line 1 we have the function definition. Notice there are 5 optional
arguments, and the mandatory `unit` 6<sup>th</sup> argument. Each of the
optional arguments is going to define a variable, eg. `border_width`, of
type `'a option`.

On line 4 we use the special `?foo` form for passing optional arguments
to functions which take optional arguments. `Container.set` has the
following type:

<!-- $MDX skip -->
```ocaml
module Container = struct
  let set ?border_width ?(width = -2) ?(height = -2) w =
    (* ... *)
```
Line 5 uses the `~`shorthand. Writing this in long form:

```ocaml
# pack_return (new html w) ~packing:packing ~show:show
Line 1, characters 1-12:
Error: Unbound value pack_return
```

The `pack_return` function actually takes mandatory labelled arguments
called `~packing` and `~show`, each of type `'a option`. In other words,
`pack_return` explicitly unwraps the `option` wrapper.

## More variants (“polymorphic variants”)
Try compiling the following C code:

```C
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

enum lock { open, close };

main ()
{
  int fd, n;
  char buffer[256];

  fd = open ("/etc/motd", O_RDONLY);                     // line 12
  while ((n = read (fd, buffer, sizeof buffer)) > 0)
    write (1, buffer, n);
  close (fd);                                            // line 15
}
```
When I compile the code I get a whole bunch of errors including:

```text
test.c: In function `main':
test.c:12: error: called object is not a function
test.c:15: error: called object is not a function
```
This illustrates one problem with enumerated types (enums) in C. In the
example above, one enum statement reserves *three* symbols, namely
`lock`, `open` and `close`. Here's another example:

```C
enum lock { open, close };
enum door { open, close };
```
Compiling gives:

```text
test.c:2: error: conflicting types for `open'
test.c:1: error: previous declaration of `open'
test.c:2: error: conflicting types for `close'
test.c:1: error: previous declaration of `close'
```
The first enum defines the symbol `open` as something of type
`enum lock`. You cannot reuse that symbol in another enum.

This will be familiar to most C/C++ programmers, and they won't write
naive code like that above. However the same issue happens with OCaml
variants, but OCaml provides a way to work around it.

Here is some OCaml code, which actually *does* compile:

```ocaml
# type lock = Open | Close
type lock = Open | Close
# type door = Open | Close
type door = Open | Close
```
After running those two statements, what is the type of `Open`? We can
find out easily enough in the toplevel:

```ocaml
# type lock = Open | Close
type lock = Open | Close
# type door = Open | Close
type door = Open | Close
# Open
- : door = Open
```

OCaml uses the most recent definition for `Open`, giving it the type
`door`. This is actually not such a serious problem because if you
accidentally tried to use `Open` in the type context of a `lock`, then
OCaml's wonderful type inference would immediately spot the error and
you wouldn't be able to compile the code.

So far, so much like C. Now I said that OCaml provides a way to work
around the constraint that `Open` can only have one type. In other
words, suppose I want to use `Open` to mean either "the `Open` of type
`lock`" or "the `Open` of type `door`" and I want OCaml to work out
which one I mean.

The syntax is slightly different, but here is how we do it:

```ocaml
# type lock = [ `Open | `Close ]
type lock = [ `Close | `Open ]
# type door = [ `Open | `Close ]
type door = [ `Close | `Open ]
```
Notice the syntactic differences:

1. Each variant name is prefixed with `` ` `` (a back tick).
1. You have to put square brackets (`[]`) around the alternatives.

The question naturally arises: What is the type of `` `Open``?

```ocaml
# `Open
- : [> `Open ] = `Open
```
`` [> `Open] `` can be read as
`` [ `Open | and some other possibilities which we don't know about ] ``.

The “>” (greater than) sign indicates that the set of possibilities is
bigger than those listed (open-ended).

There's nothing special about `` `Open ``. *Any* back-ticked word can be
used as a type, even one which we haven't mentioned before:

```ocaml
# `Foo
- : [> `Foo ] = `Foo
# `Foo 42
- : [> `Foo of int ] = `Foo 42
```
Let's write a function to print the state of a `lock`:

```ocaml
# let print_lock st =
  match st with
  | `Open -> print_endline "The lock is open"
  | `Close -> print_endline "The lock is closed"
val print_lock : [< `Close | `Open ] -> unit = <fun>
```
Take a careful look at the type of that function. Type inference has
worked out that the `st` argument has type `` [< `Close | `Open] ``. The
`<` (less than) sign means that this is a __closed class__. In
other words, this function will only work on `` `Close`` or `` `Open``
and not on anything else.

```ocaml
# print_lock `Open
The lock is open
- : unit = ()
```

Notice that `print_lock` works just as well with a `door` as with a
`lock`! We've deliberately given up some type safety, and type inference
is now being used to help guess what we mean, rather than enforce
correct coding.

This is only an introduction to polymorphic variants. Because of the
reduction in type safety, it is recommended that you don't use these in
your code. You will, however, see them in advanced OCaml code quite a
lot precisely because advanced programmers will sometimes want to weaken
the type system to write advanced idioms.
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#labelled-and-optional-arguments-to-functions">Labelled and optional arguments to functions</a>
</li>
<li><a href="#more-variants-polymorphic-variants">More variants (“polymorphic variants”)</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<h2 id="labelled-and-optional-arguments-to-functions">Labelled and optional arguments to functions</h2>
<p>Python has a nice syntax for writing arguments to functions. Here's
an example (from the Python tutorial, since I'm not a Python
programmer):</p>
<pre><code class="language-python">def ask_ok(prompt, retries=4, complaint='Yes or no, please!'):
  # function definition omitted
</code></pre>
<p>Here are the ways we can call this Python function:</p>
<pre><code class="language-python">ask_ok ('Do you really want to quit?')
ask_ok ('Overwrite the file?', 2)
ask_ok (prompt='Are you sure?')
ask_ok (complaint='Please answer yes or no!', prompt='Are you sure?')
</code></pre>
<p>Notice that in Python we are allowed to name arguments when we call
them, or use the usual function call syntax, and we can have optional
arguments with default values.</p>
<p>OCaml also has a way to label arguments and have optional arguments with
default values.</p>
<p>The basic syntax is:</p>
<pre><code class="language-ocaml"># let rec range ~first:a ~last:b =
  if a &gt; b then []
  else a :: range ~first:(a + 1) ~last:b
val range : first:int -&gt; last:int -&gt; int list = &lt;fun&gt;
</code></pre>
<p>(Notice that both <code>to</code> and <code>end</code> are reserved words in OCaml, so they
cannot be used as labels. So you cannot have <code>~from/~to</code> or
<code>~start/~end</code>.)</p>
<p>The type of our previous <code>range</code> function was:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">range : int -&gt; int -&gt; int list
</code></pre>
<p>And the type of our new <code>range</code> function with labelled arguments is:</p>
<pre><code class="language-ocaml"># range
- : first:int -&gt; last:int -&gt; int list = &lt;fun&gt;
</code></pre>
<p>Confusingly, the <code>~</code> (tilde) is <em>not</em> shown in the type definition, but
you need to use it everywhere else.</p>
<p>With labelled arguments, it doesn't matter which order you give the
arguments anymore:</p>
<pre><code class="language-ocaml"># range ~first:1 ~last:10
- : int list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]
# range ~last:10 ~first:1
- : int list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]
</code></pre>
<p>There is also a shorthand way to name the arguments, so that the label
is the same as the variable in the function definition:</p>
<pre><code class="language-ocaml"># let may ~f x =
  match x with
  | None -&gt; ()
  | Some x -&gt; ignore (f x)
val may : f:('a -&gt; 'b) -&gt; 'a option -&gt; unit = &lt;fun&gt;
</code></pre>
<p>It's worth spending some time working out exactly what this function
does, and also working out by hand its type signature. There's a lot
going on. First of all, the parameter <code>~f</code> is just shorthand for <code>~f:f</code>
(ie. the label is <code>~f</code> and the variable used in the function is <code>f</code>).
Secondly notice that the function takes two parameters. The second
parameter (<code>x</code>) is unlabelled - it is permitted for a function to take a
mixture of labelled and unlabelled arguments if you want.</p>
<p>What is the type of the labelled <code>f</code> parameter? Obviously it's a
function of some sort.</p>
<p>What is the type of the unlabelled <code>x</code> parameter? The <code>match</code> clause
gives us a clue. It's an <code>'a option</code>.</p>
<p>This tells us that <code>f</code> takes an <code>'a</code> parameter, and the return value of
<code>f</code> is ignored, so it could be anything. The type of <code>f</code> is therefore
<code>'a -&gt; 'b</code>.</p>
<p>The <code>may</code> function as a whole returns <code>unit</code>. Notice in each case of the
<code>match</code> the result is <code>()</code>.</p>
<p>Thus the type of the <code>may</code> function is (and you can verify this in the
OCaml interactive toplevel if you want):</p>
<pre><code class="language-ocaml"># may
- : f:('a -&gt; 'b) -&gt; 'a option -&gt; unit = &lt;fun&gt;
</code></pre>
<p>What does this function do? Running the function in the OCaml toplevel
gives us some clues:</p>
<pre><code class="language-ocaml"># may ~f:print_endline None
- : unit = ()
# may ~f:print_endline (Some &quot;hello&quot;)
hello
- : unit = ()
</code></pre>
<p>If the unlabelled argument is a “null pointer” then <code>may</code> does nothing.
Otherwise <code>may</code> calls the <code>f</code> function on the argument. Why is this
useful? We're just about to find out ...</p>
<h3 id="optional-arguments">Optional arguments</h3>
<p>Optional arguments are like labelled arguments, but we use <code>?</code> instead
of <code>~</code> in front of them. Here is an example:</p>
<pre><code class="language-ocaml"># let rec range ?(step=1) a b =
  if a &gt; b then []
  else a :: range ~step (a + step) b
val range : ?step:int -&gt; int -&gt; int -&gt; int list = &lt;fun&gt;
</code></pre>
<p>Note the somewhat confusing syntax, switching between <code>?</code> and <code>~</code>. We'll
talk about that in the next section. Here is how you call this function:</p>
<pre><code class="language-ocaml"># range 1 10
- : int list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]
# range 1 10 ~step:2
- : int list = [1; 3; 5; 7; 9]
</code></pre>
<p>In this case, <code>?(step=1)</code> fairly obviously means that <code>~step</code> is an
optional argument which defaults to 1. We can also omit the default
value and just have an optional argument. This example is modified from
lablgtk:</p>
<pre><code class="language-ocaml"># type window =
  {mutable title: string;
   mutable width: int;
   mutable height: int}
type window = {
  mutable title : string;
  mutable width : int;
  mutable height : int;
}
# let create_window () =
  {title = &quot;none&quot;; width = 640; height = 480;}
val create_window : unit -&gt; window = &lt;fun&gt;
# let set_title window title =
  window.title &lt;- title
val set_title : window -&gt; string -&gt; unit = &lt;fun&gt;
# let set_width window width =
  window.width &lt;- width
val set_width : window -&gt; int -&gt; unit = &lt;fun&gt;
# let set_height window height =
  window.height &lt;- height
val set_height : window -&gt; int -&gt; unit = &lt;fun&gt;
# let open_window ?title ?width ?height () =
  let window = create_window () in
  may ~f:(set_title window) title;
  may ~f:(set_width window) width;
  may ~f:(set_height window) height;
  window
val open_window :
  ?title:string -&gt; ?width:int -&gt; ?height:int -&gt; unit -&gt; window = &lt;fun&gt;
</code></pre>
<p>This example is significantly complex and quite subtle, but the pattern
used is very common in the lablgtk source code. Let's concentrate on the
simple <code>create_window</code> function first. This function takes a <code>unit</code> and
returns a <code>window</code>, initialized with default settings for title, width
and height:</p>
<pre><code class="language-ocaml"># create_window ()
- : window = {title = &quot;none&quot;; width = 640; height = 480}
</code></pre>
<p>The <code>set_title</code>, <code>set_width</code> and <code>set_height</code> functions are impure
functions which modify the <code>window</code> structure, in the obvious way. For
example:</p>
<pre><code class="language-ocaml"># let w = create_window () in
  set_title w &quot;My Application&quot;;
  w
- : window = {title = &quot;My Application&quot;; width = 640; height = 480}
</code></pre>
<p>So far this is just the imperative &quot;mutable records&quot; which we talked
about in the previous chapter. Now the complex part is the <code>open_window</code>
function. This function takes <em>4</em> arguments, three of them optional,
followed by a required, unlabelled <code>unit</code>. Let's first see this function
in action:</p>
<pre><code class="language-ocaml"># open_window ~title:&quot;My Application&quot; ()
- : window = {title = &quot;My Application&quot;; width = 640; height = 480}
# open_window ~title:&quot;Clock&quot; ~width:128 ~height:128 ()
- : window = {title = &quot;Clock&quot;; width = 128; height = 128}
</code></pre>
<p>It does what you expect, but how?! The secret is in the <code>may</code> function
(see above) and the fact that the optional parameters <em>don't</em> have
defaults.</p>
<p>When an optional parameter doesn't have a default, then it has type
<code>'a option</code>. The <code>'a</code> would normally be inferred by type inference, so
in the case of <code>?title</code> above, this has type <code>string option</code>.</p>
<p>Remember the <code>may</code> function? It takes a function and an argument, and
calls the function on the argument provided the argument isn't <code>None</code>.
So:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml"># may ~f:(set_title window) title
</code></pre>
<p>If the optional title argument is not specified by the caller, then
<code>title</code> = <code>None</code>, so <code>may</code> does nothing. But if we call the function
with, for example,</p>
<pre><code class="language-ocaml"># open_window ~title:&quot;My Application&quot; ()
- : window = {title = &quot;My Application&quot;; width = 640; height = 480}
</code></pre>
<p>then <code>title</code> = <code>Some &quot;My Application&quot;</code>, and <code>may</code> therefore calls
<code>set_title window &quot;My Application&quot;</code>.</p>
<p>You should make sure you fully understand this example before proceeding
to the next section.</p>
<h3 id="warning-this-optional-argument-cannot-be-erased">&quot;Warning: This optional argument cannot be erased&quot;</h3>
<p>We've just touched upon labels and optional arguments, but even this
brief explanation should have raised several questions. The first may be
why the extra <code>unit</code> argument to <code>open_window</code>? Let's try defining this
function without the extra <code>unit</code>:</p>
<pre><code class="language-ocaml"># let open_window ?title ?width ?height =
  let window = create_window () in
  may ~f:(set_title window) title;
  may ~f:(set_width window) width;
  may ~f:(set_height window) height;
  window
Line 1, characters 32-38:
Warning 16: this optional argument cannot be erased.
val open_window : ?title:string -&gt; ?width:int -&gt; ?height:int -&gt; window =
  &lt;fun&gt;
</code></pre>
<p>Although OCaml has compiled the function, it has generated a somewhat
infamous warning: &quot;This optional argument cannot be erased&quot;, referring
to the final <code>?height</code> argument. To try to show what's going on here,
let's call our modified <code>open_window</code> function:</p>
<pre><code class="language-ocaml"># open_window
- : ?title:string -&gt; ?width:int -&gt; ?height:int -&gt; window = &lt;fun&gt;
# open_window ~title:&quot;My Application&quot;
- : ?width:int -&gt; ?height:int -&gt; window = &lt;fun&gt;
</code></pre>
<p>Did that work or not? No it didn't. In fact it didn't even run the
<code>open_window</code> function at all. Instead it printed some strange type
information. What's going on?</p>
<p>Recall currying and uncurrying, and partial application of functions. If
we have a function <code>plus</code> defined as:</p>
<pre><code class="language-ocaml"># let plus x y =
  x + y
val plus : int -&gt; int -&gt; int = &lt;fun&gt;
</code></pre>
<p>We can partially apply this, for example as <code>plus 2</code> which is &quot;the
function that adds 2 to things&quot;:</p>
<pre><code class="language-ocaml"># let f = plus 2
val f : int -&gt; int = &lt;fun&gt;
# f 5
- : int = 7
# f 100
- : int = 102
</code></pre>
<p>In the <code>plus</code> example, the OCaml compiler can easily work out that
<code>plus 2</code> doesn't have enough arguments supplied yet. It needs another
argument before the <code>plus</code> function itself can be executed. Therefore
<code>plus 2</code> is a function which is waiting for its extra argument to come
along.</p>
<p>Things are not so clear when we add optional arguments into the mix. The
call to <code>open_window;;</code> above is a case in point. Does the user mean
&quot;execute <code>open_window</code> now&quot;? Or does the user mean to supply some or all
of the optional arguments later? Is <code>open_window;;</code> waiting for extra
arguments to come along like <code>plus 2</code>?</p>
<p>OCaml plays it safe and doesn't execute <code>open_window</code>. Instead it treats
it as a partial function application. The expression <code>open_window</code>
literally evaluates to a function value.</p>
<p>Let's go back to the original and working definition of <code>open_window</code>
where we had the extra unlabelled <code>unit</code> argument at the end:</p>
<pre><code class="language-ocaml"># let open_window ?title ?width ?height () =
  let window = create_window () in
  may ~f:(set_title window) title;
  may ~f:(set_width window) width;
  may ~f:(set_height window) height;
  window
val open_window :
  ?title:string -&gt; ?width:int -&gt; ?height:int -&gt; unit -&gt; window = &lt;fun&gt;
</code></pre>
<p>If you want to pass optional arguments to <code>open_window</code> you must do so
before the final <code>unit</code>, so if you type:</p>
<pre><code class="language-ocaml"># open_window ()
- : window = {title = &quot;none&quot;; width = 640; height = 480}
</code></pre>
<p>you must mean &quot;execute <code>open_window</code> now with all optional arguments
unspecified&quot;. Whereas if you type:</p>
<pre><code class="language-ocaml"># open_window
- : ?title:string -&gt; ?width:int -&gt; ?height:int -&gt; unit -&gt; window = &lt;fun&gt;
</code></pre>
<p>you mean &quot;give me the functional value&quot; or (more usually in the
toplevel) &quot;print out the type of <code>open_window</code>&quot;.</p>
<h3 id="more-shorthand">More <code>~</code>shorthand</h3>
<p>Let's rewrite the <code>range</code> function yet again, this time using as much
shorthand as possible for the labels:</p>
<pre><code class="language-ocaml"># let rec range ~first ~last =
  if first &gt; last then []
  else first :: range ~first:(first + 1) ~last
val range : first:int -&gt; last:int -&gt; int list = &lt;fun&gt;
</code></pre>
<p>Recall that <code>~foo</code> on its own is short for <code>~foo:foo</code>. This applies also
when calling functions as well as declaring the arguments to functions,
hence in the above the highlighted red <code>~last</code> is short for
<code>~last:last</code>.</p>
<h3 id="using-foo-in-a-function-call">Using <code>?foo</code> in a function call</h3>
<p>There's another little wrinkle concerning optional arguments. Suppose we
write a function around <code>open_window</code> to open up an application:</p>
<pre><code class="language-ocaml"># let open_application ?width ?height () =
  open_window ~title:&quot;My Application&quot; ~width ~height
Line 2, characters 40-45:
Error: This expression has type 'a option
       but an expression was expected of type int
</code></pre>
<p>Recall that <code>~width</code> is shorthand for <code>~width:width</code>. The type of
<code>width</code> is <code>'a option</code>, but <code>open_window ~width:</code> expects an <code>int</code>.</p>
<p>OCaml provides more syntactic sugar. Writing <code>?width</code> in the function
call is shorthand for writing <code>~width:(unwrap width)</code> where <code>unwrap</code>
would be a function which would remove the &quot;<code>option</code> wrapper&quot; around
<code>width</code> (it's not actually possible to write an <code>unwrap</code> function like
this, but conceptually that's the idea). So the correct way to write
this function is:</p>
<pre><code class="language-ocaml"># let open_application ?width ?height () =
  open_window ~title:&quot;My Application&quot; ?width ?height
val open_application : ?width:int -&gt; ?height:int -&gt; unit -&gt; unit -&gt; window =
  &lt;fun&gt;
</code></pre>
<h3 id="when-and-when-not-to-use--and-">When and when not to use <code>~</code> and <code>?</code></h3>
<p>The syntax for labels and optional arguments is confusing, and you may
often wonder when to use <code>~foo</code>, when to use <code>?foo</code> and when to use
plain <code>foo</code>. It's something of a black art which takes practice to get
right.</p>
<p><code>?foo</code> is only used when declaring the arguments of a function, ie:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let f ?arg1 ... =
</code></pre>
<p>or when using the specialised &quot;unwrap <code>option</code> wrapper&quot; form for
function calls:</p>
<pre><code class="language-ocaml"># let open_application ?width ?height () =
  open_window ~title:&quot;My Application&quot; ?width ?height
val open_application : ?width:int -&gt; ?height:int -&gt; unit -&gt; unit -&gt; window =
  &lt;fun&gt;
</code></pre>
<p>The declaration <code>?foo</code> creates a variable called <code>foo</code>, so if you need
the value of <code>?foo</code>, use just <code>foo</code>.</p>
<p>The same applies to labels. Only use the <code>~foo</code> form when declaring
arguments of a function, ie:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let f ~foo:foo ... =
</code></pre>
<p>The declaration <code>~foo:foo</code> creates a variable called simply <code>foo</code>, so if
you need the value just use plain <code>foo</code>.</p>
<p>Things, however, get complicated for two reasons: first, the shorthand
form <code>~foo</code> (equivalent to <code>~foo:foo</code>), and second, when you call a
function which takes a labelled or optional argument and you use the
shorthand form.</p>
<p>Here is some apparently obscure code from lablgtk to demonstrate all of
this:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml"># let html ?border_width ?width ?height ?packing ?show () =  (* line 1 *)
  let w = create () in
  load_empty w;
  Container.set w ?border_width ?width ?height;            (* line 4 *)
  pack_return (new html w) ~packing ~show                  (* line 5 *)
</code></pre>
<p>On line 1 we have the function definition. Notice there are 5 optional
arguments, and the mandatory <code>unit</code> 6<sup>th</sup> argument. Each of the
optional arguments is going to define a variable, eg. <code>border_width</code>, of
type <code>'a option</code>.</p>
<p>On line 4 we use the special <code>?foo</code> form for passing optional arguments
to functions which take optional arguments. <code>Container.set</code> has the
following type:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">module Container = struct
  let set ?border_width ?(width = -2) ?(height = -2) w =
    (* ... *)
</code></pre>
<p>Line 5 uses the <code>~</code>shorthand. Writing this in long form:</p>
<pre><code class="language-ocaml"># pack_return (new html w) ~packing:packing ~show:show
Line 1, characters 1-12:
Error: Unbound value pack_return
</code></pre>
<p>The <code>pack_return</code> function actually takes mandatory labelled arguments
called <code>~packing</code> and <code>~show</code>, each of type <code>'a option</code>. In other words,
<code>pack_return</code> explicitly unwraps the <code>option</code> wrapper.</p>
<h2 id="more-variants-polymorphic-variants">More variants (“polymorphic variants”)</h2>
<p>Try compiling the following C code:</p>
<pre><code class="language-C">#include &lt;stdio.h&gt;
#include &lt;fcntl.h&gt;
#include &lt;unistd.h&gt;

enum lock { open, close };

main ()
{
  int fd, n;
  char buffer[256];

  fd = open (&quot;/etc/motd&quot;, O_RDONLY);                     // line 12
  while ((n = read (fd, buffer, sizeof buffer)) &gt; 0)
    write (1, buffer, n);
  close (fd);                                            // line 15
}
</code></pre>
<p>When I compile the code I get a whole bunch of errors including:</p>
<pre><code class="language-text">test.c: In function `main':
test.c:12: error: called object is not a function
test.c:15: error: called object is not a function
</code></pre>
<p>This illustrates one problem with enumerated types (enums) in C. In the
example above, one enum statement reserves <em>three</em> symbols, namely
<code>lock</code>, <code>open</code> and <code>close</code>. Here's another example:</p>
<pre><code class="language-C">enum lock { open, close };
enum door { open, close };
</code></pre>
<p>Compiling gives:</p>
<pre><code class="language-text">test.c:2: error: conflicting types for `open'
test.c:1: error: previous declaration of `open'
test.c:2: error: conflicting types for `close'
test.c:1: error: previous declaration of `close'
</code></pre>
<p>The first enum defines the symbol <code>open</code> as something of type
<code>enum lock</code>. You cannot reuse that symbol in another enum.</p>
<p>This will be familiar to most C/C++ programmers, and they won't write
naive code like that above. However the same issue happens with OCaml
variants, but OCaml provides a way to work around it.</p>
<p>Here is some OCaml code, which actually <em>does</em> compile:</p>
<pre><code class="language-ocaml"># type lock = Open | Close
type lock = Open | Close
# type door = Open | Close
type door = Open | Close
</code></pre>
<p>After running those two statements, what is the type of <code>Open</code>? We can
find out easily enough in the toplevel:</p>
<pre><code class="language-ocaml"># type lock = Open | Close
type lock = Open | Close
# type door = Open | Close
type door = Open | Close
# Open
- : door = Open
</code></pre>
<p>OCaml uses the most recent definition for <code>Open</code>, giving it the type
<code>door</code>. This is actually not such a serious problem because if you
accidentally tried to use <code>Open</code> in the type context of a <code>lock</code>, then
OCaml's wonderful type inference would immediately spot the error and
you wouldn't be able to compile the code.</p>
<p>So far, so much like C. Now I said that OCaml provides a way to work
around the constraint that <code>Open</code> can only have one type. In other
words, suppose I want to use <code>Open</code> to mean either &quot;the <code>Open</code> of type
<code>lock</code>&quot; or &quot;the <code>Open</code> of type <code>door</code>&quot; and I want OCaml to work out
which one I mean.</p>
<p>The syntax is slightly different, but here is how we do it:</p>
<pre><code class="language-ocaml"># type lock = [ `Open | `Close ]
type lock = [ `Close | `Open ]
# type door = [ `Open | `Close ]
type door = [ `Close | `Open ]
</code></pre>
<p>Notice the syntactic differences:</p>
<ol>
<li>Each variant name is prefixed with <code>`</code> (a back tick).
</li>
<li>You have to put square brackets (<code>[]</code>) around the alternatives.
</li>
</ol>
<p>The question naturally arises: What is the type of <code> `Open</code>?</p>
<pre><code class="language-ocaml"># `Open
- : [&gt; `Open ] = `Open
</code></pre>
<p><code>[&gt; `Open]</code> can be read as
<code>[ `Open | and some other possibilities which we don't know about ]</code>.</p>
<p>The “&gt;” (greater than) sign indicates that the set of possibilities is
bigger than those listed (open-ended).</p>
<p>There's nothing special about <code>`Open</code>. <em>Any</em> back-ticked word can be
used as a type, even one which we haven't mentioned before:</p>
<pre><code class="language-ocaml"># `Foo
- : [&gt; `Foo ] = `Foo
# `Foo 42
- : [&gt; `Foo of int ] = `Foo 42
</code></pre>
<p>Let's write a function to print the state of a <code>lock</code>:</p>
<pre><code class="language-ocaml"># let print_lock st =
  match st with
  | `Open -&gt; print_endline &quot;The lock is open&quot;
  | `Close -&gt; print_endline &quot;The lock is closed&quot;
val print_lock : [&lt; `Close | `Open ] -&gt; unit = &lt;fun&gt;
</code></pre>
<p>Take a careful look at the type of that function. Type inference has
worked out that the <code>st</code> argument has type <code>[&lt; `Close | `Open]</code>. The
<code>&lt;</code> (less than) sign means that this is a <strong>closed class</strong>. In
other words, this function will only work on <code> `Close</code> or <code> `Open</code>
and not on anything else.</p>
<pre><code class="language-ocaml"># print_lock `Open
The lock is open
- : unit = ()
</code></pre>
<p>Notice that <code>print_lock</code> works just as well with a <code>door</code> as with a
<code>lock</code>! We've deliberately given up some type safety, and type inference
is now being used to help guess what we mean, rather than enforce
correct coding.</p>
<p>This is only an introduction to polymorphic variants. Because of the
reduction in type safety, it is recommended that you don't use these in
your code. You will, however, see them in advanced OCaml code quite a
lot precisely because advanced programmers will sometimes want to weaken
the type system to write advanced idioms.</p>
|js}
  };
 
  { title = {js|Pointers in OCaml|js}
  ; slug = {js|pointers-in-ocaml|js}
  ; description = {js|Use OCaml's explicit pointers with references
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["language"]
  ; users = [`Intermediate; `Advanced]
  ; body_md = {js|
## Status of pointers in OCaml
Pointers exist in OCaml, and in fact they spread all over the place.
They are used either implicitly (in the most cases), or explicitly (in
the rare occasions where implicit pointers are not more handy). The vast
majority of pointers usages that are found in usual programming
languages simply disappear in OCaml, or more exactly, those pointers are
totally automatically handled by the compiler. Thus, the OCaml programmer
can safely ignore the existence of pointers, focusing on the semantics of their
program.

For instance, lists or trees are defined without explicit pointers using
a concrete datatype definition. The underlying implementation uses
pointers, but this is hidden from the programmer since pointer
handling is done by the compiler.

In the rare occasions where explicit pointers are needed (the most
common case is when translating into OCaml an algorithm described in a
classic imperative language), OCaml provides references that are
full-fledged pointers, even first class citizen pointers (references can
be passed as argument, embedded into arbitrary data structures, and
returned as function results).

###  Explicit pointers are OCaml values of type `ref`
You can program directly with explicit references if you want to, but
this is normally a waste of time and effort.

Let's examine the simple example of linked lists (integer lists to be
simple). This data type is defined in C (or in Pascal) using explicit
pointers, for instance:

```C
/* Cells and lists type in C */
struct cell {
  int hd;
  struct cell *tl;
};

typedef struct cell cell, *list;
```
```Pascal
{Cells and lists type in Pascal}
type
 list = ^cell;
 cell = record
  hd: integer;
  tl: cell;
 end;
```
We can translate this in OCaml, using a sum type definition, without
pointers:

```ocaml
# type list = Nil | Cons of int * list
type list = Nil | Cons of int * list
```

Cell lists are thus represented as pairs, and the recursive structure of
lists is evident, with the two alternatives, empty list (the
`Nil`constructor) and non empty list (the `Cons` constructor).

Automatic management of pointers and automatic memory allocation shine
when allocating list values: one just writes `Cons (x, l)` to add `x` in
front of the list `l`. In C, you need to write this function, to
allocate a new cell and then fill its fields. For instance:

```C
/* The empty list */
#define nil NULL

/* The constructor of lists */
list cons (element x, list l)
{
  list result;
  result = (list) malloc (sizeof (cell));
  result -> hd = x;
  result -> tl = l;
  return (result);
}
```
Similarly, in Pascal:

```Pascal
{Creating a list cell}
function cons (x: integer; l: list): list;
  var p: list;
  begin
    new(p);
    p^.hd := x;
    p^.tl := l;
    cons := p
  end;
```
We thus see that fields of list cells in the C program have to be
mutable, otherwise initialization is impossible. By contrast in OCaml,
allocation and initialization are merged into a single basic operation:
constructor application. This way, immutable data structures are
definable (those data types are often referred to as “pure” or
“functional” data structures). If physical modifications are necessary
for other reasons than mere initialization, OCaml provides records with
mutable fields. For instance, a list type defining lists whose elements
can be in place modified could be written:

```ocaml
# type list = Nil | Cons of cell
  and cell = { mutable hd : int; tl : list }
type list = Nil | Cons of cell
and cell = { mutable hd : int; tl : list; }
```
If the structure of the list itself must also be modified (cells must be
physically removed from the list), the `tl` field would also be declared
as mutable:

```ocaml
# type list = Nil | Cons of cell
  and cell = { mutable hd : int; mutable tl : list }
type list = Nil | Cons of cell
and cell = { mutable hd : int; mutable tl : list; }
```

Physical assignments are still useless to allocate mutable data: you
write `Cons {hd = 1; tl = l}` to add `1` to the list `l`. Physical
assignments that remain in OCaml programs should be just those
assignments that are mandatory to implement the algorithm at hand.

Very often, pointers are used to implement physical modification of data
structures. In OCaml programs this means using vectors or mutable fields
in records.

**In conclusion:** You can use explicit pointers in OCaml, exactly as in C, but
this is not natural, since you get back the usual drawbacks and difficulties of
explicit pointers manipulation of classical algorithmic languages. See a more
complete example below.

## Defining pointers in OCaml
The general pointer type can be defined using the definition of a
pointer: a pointer is either null, or a pointer to an assignable memory
location:

```ocaml
# type 'a pointer = Null | Pointer of 'a ref
type 'a pointer = Null | Pointer of 'a ref
```
Explicit dereferencing (or reading the pointer's designated value) and
pointer assignment (or writing to the pointer's designated memory
location) are easily defined. We define dereferencing as a prefix
operator named `!^`, and assignment as the infix `^:=`.

```ocaml
# let ( !^ ) = function
    | Null -> invalid_arg "Attempt to dereference the null pointer"
    | Pointer r -> !r
val ( !^ ) : 'a pointer -> 'a = <fun>

# let ( ^:= ) p v =
    match p with
     | Null -> invalid_arg "Attempt to assign the null pointer"
     | Pointer r -> r := v
val ( ^:= ) : 'a pointer -> 'a -> unit = <fun>
```

Now we define the allocation of a new pointer initialized to point to a
given value:

```ocaml
# let new_pointer x = Pointer (ref x)
val new_pointer : 'a -> 'a pointer = <fun>
```
For instance, let's define and then assign a pointer to an integer:

```ocaml
# let p = new_pointer 0
val p : int pointer = Pointer {contents = 0}
# p ^:= 1
- : unit = ()
# !^p
- : int = 1
```

## Integer Lists
Now we can define lists using explicit pointers as in usual imperative
languages:

```ocaml
# type ilist = cell pointer
  and cell = { mutable hd : int; mutable tl : ilist }
type ilist = cell pointer
and cell = { mutable hd : int; mutable tl : ilist; }
```
We then define allocation of a new cell, the list constructor and its
associated destructors.

```ocaml
# let new_cell () = {hd = 0; tl = Null}
val new_cell : unit -> cell = <fun>
# let cons x l =
    let c = new_cell () in
    c.hd <- x;
    c.tl <- l;
    (new_pointer c : ilist)
val cons : int -> ilist -> ilist = <fun>
# let hd (l : ilist) = !^l.hd
val hd : ilist -> int = <fun>
# let tl (l : ilist) = !^l.tl
val tl : ilist -> ilist = <fun>
```

We can now write all kind of classical algorithms, based on pointers
manipulation, with their associated loops, their unwanted sharing
problems and their null pointer errors. For instance, list
concatenation, as often described in literature, physically modifies
its first list argument, hooking the second list to the end of the
first:

```ocaml
# let append (l1 : ilist) (l2 : ilist) =
  let temp = ref l1 in
  while tl !temp <> Null do
    temp := tl !temp
  done;
  !^ !temp.tl <- l2
val append : ilist -> ilist -> unit = <fun>

# let l1 = cons 1 (cons 2 Null)
val l1 : ilist =
  Pointer
   {contents = {hd = 1; tl = Pointer {contents = {hd = 2; tl = Null}}}}

# let l2 = cons 3 Null
val l2 : ilist = Pointer {contents = {hd = 3; tl = Null}}

# append l1 l2
- : unit = ()
```

The lists `l1` and `l2` are effectively catenated:

```ocaml
# l1
- : ilist =
Pointer
 {contents =
   {hd = 1;
    tl =
     Pointer
      {contents = {hd = 2; tl = Pointer {contents = {hd = 3; tl = Null}}}}}}
```

Just a nasty side effect of physical list concatenation: `l1` now
contains the concatenation of the two lists `l1` and `l2`, thus the list
`l1` no longer exists: in some sense `append` *consumes* its first
argument. In other words, the value of a list data now depends on its
history, that is on the sequence of function calls that use the value.
This strange behaviour leads to a lot of difficulties when explicitly
manipulating pointers. Try for instance, the seemingly harmless:

```ocaml
# append l1 l1
- : unit = ()
```

Then evaluate `l1`:

```ocaml
# l1
- : ilist =
Pointer
 {contents =
   {hd = 1;
    tl =
     Pointer
      {contents = {hd = 2; tl = Pointer {contents = {hd = 3; tl = <cycle>}}}}}}
```

## Polymorphic lists
We can define polymorphic lists using pointers; here is a simple implementation
of those polymorphic mutable lists:

```ocaml
# type 'a lists = 'a cell pointer
  and 'a cell = { mutable hd : 'a pointer; mutable tl : 'a lists }
type 'a lists = 'a cell pointer
and 'a cell = { mutable hd : 'a pointer; mutable tl : 'a lists; }
# let new_cell () = {hd = Null; tl = Null}
val new_cell : unit -> 'a cell = <fun>
# let cons x l =
    let c = new_cell () in
    c.hd <- new_pointer x;
    c.tl <- l;
    (new_pointer c : 'a lists)
val cons : 'a -> 'a lists -> 'a lists = <fun>
# let hd (l : 'a lists) = !^l.hd
val hd : 'a lists -> 'a pointer = <fun>
# let tl (l : 'a lists) = !^l.tl
val tl : 'a lists -> 'a lists = <fun>
# let append (l1 : 'a lists) (l2 : 'a lists) =
  let temp = ref l1 in
  while tl !temp <> Null do
    temp := tl !temp
  done;
  !^ !temp.tl <- l2
val append : 'a lists -> 'a lists -> unit = <fun>
```
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#status-of-pointers-in-ocaml">Status of pointers in OCaml</a>
</li>
<li><a href="#defining-pointers-in-ocaml">Defining pointers in OCaml</a>
</li>
<li><a href="#integer-lists">Integer Lists</a>
</li>
<li><a href="#polymorphic-lists">Polymorphic lists</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<h2 id="status-of-pointers-in-ocaml">Status of pointers in OCaml</h2>
<p>Pointers exist in OCaml, and in fact they spread all over the place.
They are used either implicitly (in the most cases), or explicitly (in
the rare occasions where implicit pointers are not more handy). The vast
majority of pointers usages that are found in usual programming
languages simply disappear in OCaml, or more exactly, those pointers are
totally automatically handled by the compiler. Thus, the OCaml programmer
can safely ignore the existence of pointers, focusing on the semantics of their
program.</p>
<p>For instance, lists or trees are defined without explicit pointers using
a concrete datatype definition. The underlying implementation uses
pointers, but this is hidden from the programmer since pointer
handling is done by the compiler.</p>
<p>In the rare occasions where explicit pointers are needed (the most
common case is when translating into OCaml an algorithm described in a
classic imperative language), OCaml provides references that are
full-fledged pointers, even first class citizen pointers (references can
be passed as argument, embedded into arbitrary data structures, and
returned as function results).</p>
<h3 id="explicit-pointers-are-ocaml-values-of-type-ref">Explicit pointers are OCaml values of type <code>ref</code></h3>
<p>You can program directly with explicit references if you want to, but
this is normally a waste of time and effort.</p>
<p>Let's examine the simple example of linked lists (integer lists to be
simple). This data type is defined in C (or in Pascal) using explicit
pointers, for instance:</p>
<pre><code class="language-C">/* Cells and lists type in C */
struct cell {
  int hd;
  struct cell *tl;
};

typedef struct cell cell, *list;
</code></pre>
<pre><code class="language-Pascal">{Cells and lists type in Pascal}
type
 list = ^cell;
 cell = record
  hd: integer;
  tl: cell;
 end;
</code></pre>
<p>We can translate this in OCaml, using a sum type definition, without
pointers:</p>
<pre><code class="language-ocaml"># type list = Nil | Cons of int * list
type list = Nil | Cons of int * list
</code></pre>
<p>Cell lists are thus represented as pairs, and the recursive structure of
lists is evident, with the two alternatives, empty list (the
<code>Nil</code>constructor) and non empty list (the <code>Cons</code> constructor).</p>
<p>Automatic management of pointers and automatic memory allocation shine
when allocating list values: one just writes <code>Cons (x, l)</code> to add <code>x</code> in
front of the list <code>l</code>. In C, you need to write this function, to
allocate a new cell and then fill its fields. For instance:</p>
<pre><code class="language-C">/* The empty list */
#define nil NULL

/* The constructor of lists */
list cons (element x, list l)
{
  list result;
  result = (list) malloc (sizeof (cell));
  result -&gt; hd = x;
  result -&gt; tl = l;
  return (result);
}
</code></pre>
<p>Similarly, in Pascal:</p>
<pre><code class="language-Pascal">{Creating a list cell}
function cons (x: integer; l: list): list;
  var p: list;
  begin
    new(p);
    p^.hd := x;
    p^.tl := l;
    cons := p
  end;
</code></pre>
<p>We thus see that fields of list cells in the C program have to be
mutable, otherwise initialization is impossible. By contrast in OCaml,
allocation and initialization are merged into a single basic operation:
constructor application. This way, immutable data structures are
definable (those data types are often referred to as “pure” or
“functional” data structures). If physical modifications are necessary
for other reasons than mere initialization, OCaml provides records with
mutable fields. For instance, a list type defining lists whose elements
can be in place modified could be written:</p>
<pre><code class="language-ocaml"># type list = Nil | Cons of cell
  and cell = { mutable hd : int; tl : list }
type list = Nil | Cons of cell
and cell = { mutable hd : int; tl : list; }
</code></pre>
<p>If the structure of the list itself must also be modified (cells must be
physically removed from the list), the <code>tl</code> field would also be declared
as mutable:</p>
<pre><code class="language-ocaml"># type list = Nil | Cons of cell
  and cell = { mutable hd : int; mutable tl : list }
type list = Nil | Cons of cell
and cell = { mutable hd : int; mutable tl : list; }
</code></pre>
<p>Physical assignments are still useless to allocate mutable data: you
write <code>Cons {hd = 1; tl = l}</code> to add <code>1</code> to the list <code>l</code>. Physical
assignments that remain in OCaml programs should be just those
assignments that are mandatory to implement the algorithm at hand.</p>
<p>Very often, pointers are used to implement physical modification of data
structures. In OCaml programs this means using vectors or mutable fields
in records.</p>
<p><strong>In conclusion:</strong> You can use explicit pointers in OCaml, exactly as in C, but
this is not natural, since you get back the usual drawbacks and difficulties of
explicit pointers manipulation of classical algorithmic languages. See a more
complete example below.</p>
<h2 id="defining-pointers-in-ocaml">Defining pointers in OCaml</h2>
<p>The general pointer type can be defined using the definition of a
pointer: a pointer is either null, or a pointer to an assignable memory
location:</p>
<pre><code class="language-ocaml"># type 'a pointer = Null | Pointer of 'a ref
type 'a pointer = Null | Pointer of 'a ref
</code></pre>
<p>Explicit dereferencing (or reading the pointer's designated value) and
pointer assignment (or writing to the pointer's designated memory
location) are easily defined. We define dereferencing as a prefix
operator named <code>!^</code>, and assignment as the infix <code>^:=</code>.</p>
<pre><code class="language-ocaml"># let ( !^ ) = function
    | Null -&gt; invalid_arg &quot;Attempt to dereference the null pointer&quot;
    | Pointer r -&gt; !r
val ( !^ ) : 'a pointer -&gt; 'a = &lt;fun&gt;

# let ( ^:= ) p v =
    match p with
     | Null -&gt; invalid_arg &quot;Attempt to assign the null pointer&quot;
     | Pointer r -&gt; r := v
val ( ^:= ) : 'a pointer -&gt; 'a -&gt; unit = &lt;fun&gt;
</code></pre>
<p>Now we define the allocation of a new pointer initialized to point to a
given value:</p>
<pre><code class="language-ocaml"># let new_pointer x = Pointer (ref x)
val new_pointer : 'a -&gt; 'a pointer = &lt;fun&gt;
</code></pre>
<p>For instance, let's define and then assign a pointer to an integer:</p>
<pre><code class="language-ocaml"># let p = new_pointer 0
val p : int pointer = Pointer {contents = 0}
# p ^:= 1
- : unit = ()
# !^p
- : int = 1
</code></pre>
<h2 id="integer-lists">Integer Lists</h2>
<p>Now we can define lists using explicit pointers as in usual imperative
languages:</p>
<pre><code class="language-ocaml"># type ilist = cell pointer
  and cell = { mutable hd : int; mutable tl : ilist }
type ilist = cell pointer
and cell = { mutable hd : int; mutable tl : ilist; }
</code></pre>
<p>We then define allocation of a new cell, the list constructor and its
associated destructors.</p>
<pre><code class="language-ocaml"># let new_cell () = {hd = 0; tl = Null}
val new_cell : unit -&gt; cell = &lt;fun&gt;
# let cons x l =
    let c = new_cell () in
    c.hd &lt;- x;
    c.tl &lt;- l;
    (new_pointer c : ilist)
val cons : int -&gt; ilist -&gt; ilist = &lt;fun&gt;
# let hd (l : ilist) = !^l.hd
val hd : ilist -&gt; int = &lt;fun&gt;
# let tl (l : ilist) = !^l.tl
val tl : ilist -&gt; ilist = &lt;fun&gt;
</code></pre>
<p>We can now write all kind of classical algorithms, based on pointers
manipulation, with their associated loops, their unwanted sharing
problems and their null pointer errors. For instance, list
concatenation, as often described in literature, physically modifies
its first list argument, hooking the second list to the end of the
first:</p>
<pre><code class="language-ocaml"># let append (l1 : ilist) (l2 : ilist) =
  let temp = ref l1 in
  while tl !temp &lt;&gt; Null do
    temp := tl !temp
  done;
  !^ !temp.tl &lt;- l2
val append : ilist -&gt; ilist -&gt; unit = &lt;fun&gt;

# let l1 = cons 1 (cons 2 Null)
val l1 : ilist =
  Pointer
   {contents = {hd = 1; tl = Pointer {contents = {hd = 2; tl = Null}}}}

# let l2 = cons 3 Null
val l2 : ilist = Pointer {contents = {hd = 3; tl = Null}}

# append l1 l2
- : unit = ()
</code></pre>
<p>The lists <code>l1</code> and <code>l2</code> are effectively catenated:</p>
<pre><code class="language-ocaml"># l1
- : ilist =
Pointer
 {contents =
   {hd = 1;
    tl =
     Pointer
      {contents = {hd = 2; tl = Pointer {contents = {hd = 3; tl = Null}}}}}}
</code></pre>
<p>Just a nasty side effect of physical list concatenation: <code>l1</code> now
contains the concatenation of the two lists <code>l1</code> and <code>l2</code>, thus the list
<code>l1</code> no longer exists: in some sense <code>append</code> <em>consumes</em> its first
argument. In other words, the value of a list data now depends on its
history, that is on the sequence of function calls that use the value.
This strange behaviour leads to a lot of difficulties when explicitly
manipulating pointers. Try for instance, the seemingly harmless:</p>
<pre><code class="language-ocaml"># append l1 l1
- : unit = ()
</code></pre>
<p>Then evaluate <code>l1</code>:</p>
<pre><code class="language-ocaml"># l1
- : ilist =
Pointer
 {contents =
   {hd = 1;
    tl =
     Pointer
      {contents = {hd = 2; tl = Pointer {contents = {hd = 3; tl = &lt;cycle&gt;}}}}}}
</code></pre>
<h2 id="polymorphic-lists">Polymorphic lists</h2>
<p>We can define polymorphic lists using pointers; here is a simple implementation
of those polymorphic mutable lists:</p>
<pre><code class="language-ocaml"># type 'a lists = 'a cell pointer
  and 'a cell = { mutable hd : 'a pointer; mutable tl : 'a lists }
type 'a lists = 'a cell pointer
and 'a cell = { mutable hd : 'a pointer; mutable tl : 'a lists; }
# let new_cell () = {hd = Null; tl = Null}
val new_cell : unit -&gt; 'a cell = &lt;fun&gt;
# let cons x l =
    let c = new_cell () in
    c.hd &lt;- new_pointer x;
    c.tl &lt;- l;
    (new_pointer c : 'a lists)
val cons : 'a -&gt; 'a lists -&gt; 'a lists = &lt;fun&gt;
# let hd (l : 'a lists) = !^l.hd
val hd : 'a lists -&gt; 'a pointer = &lt;fun&gt;
# let tl (l : 'a lists) = !^l.tl
val tl : 'a lists -&gt; 'a lists = &lt;fun&gt;
# let append (l1 : 'a lists) (l2 : 'a lists) =
  let temp = ref l1 in
  while tl !temp &lt;&gt; Null do
    temp := tl !temp
  done;
  !^ !temp.tl &lt;- l2
val append : 'a lists -&gt; 'a lists -&gt; unit = &lt;fun&gt;
</code></pre>
|js}
  };
 
  { title = {js|Null Pointers, Asserts and Warnings|js}
  ; slug = {js|null-pointers-asserts-and-warnings|js}
  ; description = {js|Handling warnings and asserting invariants for your code
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["language"]
  ; users = [`Intermediate; `Advanced]
  ; body_md = {js|
## Null pointers
So you've got a survey on your website which asks your readers for their
names and ages. Only problem is that for some reason a few of your
readers don't want to give you their age - they stubbornly refuse to
fill that field in. What's a poor database administrator to do?

Assume that the age is represented by an `int`, there are two possible
ways to solve this problem. The most common one (and the most *wrong*
one) is to assume some sort of "special" value for the age which means
that the age information wasn't collected. So if, say, age = -1 then the
data wasn't collected, otherwise the data was collected (even if it's
not valid!). This method kind of works until you start, for example,
calculating the mean age of visitors to your website. Since you forgot
to take into account your special value, you conclude that the mean age
of visitors is 7½ years old, and you employ web designers to remove all
the long words and use primary colours everywhere.

The other, correct method is to store the age in a field which has type
"int or null". Here's a SQL table for storing ages:

```SQL
create table users
(
  userid serial,
  name text not null,
  age int             -- may be null
);
```

If the age data isn't collected, then it goes into the database as a
special SQL `NULL` value. SQL ignores this automatically when you ask it
to compute averages and so on.

Programming languages also support nulls, although they may be easier to
use in some than in others. In Java, any reference to
an object can be null, so it might make sense in Java to store the
age as an `Integer` and allow references to the age to be null. In C
pointers can, of course, be null, but if you wanted a simple integer to
be null, you'd have to first box it up into an object allocated by
`malloc` on the heap.

OCaml has an elegant solution to the problem of nulls, using a simple
polymorphic variant type defined (in `Stdlib`) as:

```ocaml
type 'a option = None | Some of 'a
```

A "null pointer" is written `None`. The type of age in our example above
(an `int` which can be null) is `int option` (remember: backwards like
`int list` and `int binary_tree`).

```ocaml
# Some 3
- : int option = Some 3
```

What about a list of optional ints?

```ocaml
# [None; Some 3; Some 6; None]
- : int option list = [None; Some 3; Some 6; None]
```
And what about an optional list of ints?

```ocaml
# Some [1; 2; 3]
- : int list option = Some [1; 2; 3]
```

## Assert, warnings, fatal errors, and printing to stderr
The built-in `assert` takes an expression as an argument and throws an
exception *if* the provided expression evaluates to `false`. 
Assuming that you don't catch this exception (it's probably
unwise to catch this exception, particularly for beginners), this
results in the program stopping and printing out the source file and
line number where the error occurred. An example:

```ocaml
# assert (Sys.os_type = "Win32")
Exception: Assert_failure ("//toplevel//", 1, 1).
```

(Running this on Win32, of course, won't throw an error).

You can also just call `assert false` to stop your program if things
just aren't going well, but you're probably better to use ...

`failwith "error message"` throws a `Failure` exception, which again
assuming you don't try to catch it, will stop the program with the given
error message. `failwith` is often used during pattern matching, like
this real example:

<!-- $MDX skip -->
```ocaml
match Sys.os_type with
| "Unix" | "Cygwin" ->   (* code omitted *)
| "Win32" ->             (* code omitted *)
| "MacOS" ->             (* code omitted *)
| _ -> failwith "this system is not supported"
```

Note a couple of extra pattern matching features in this example too. A
so-called "range pattern" is used to match either `"Unix"` or
`"Cygwin"`, and the special `_` pattern which matches "anything else".

If you want to debug your program, then you'll probably want to print out a
warning some way through your function. Here's an example:

<!-- $MDX skip -->
```ocaml
open Graphics
  
let () =
  open_graph " 640x480";
  for i = 12 downto 1 do
    let radius = i * 20 in
    prerr_endline ("radius is " ^ string_of_int radius);
    set_color (if i mod 2 = 0 then red else yellow);
    fill_circle 320 240 radius
  done;
  ignore(read_line ())
```

If you prefer C-style `printf`'s then try using OCaml's `Printf` module
instead:

<!-- $MDX skip -->
```ocaml
open Graphics
  
let () =
  open_graph " 640x480";
  for i = 12 downto 1 do
    let radius = i * 20 in
    Printf.eprintf "radius is %d\\n" radius;
    set_color (if i mod 2 = 0 then red else yellow);
    fill_circle 320 240 radius
  done;
  ignore(read_line ())
```
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#null-pointers">Null pointers</a>
</li>
<li><a href="#assert-warnings-fatal-errors-and-printing-to-stderr">Assert, warnings, fatal errors, and printing to stderr</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<h2 id="null-pointers">Null pointers</h2>
<p>So you've got a survey on your website which asks your readers for their
names and ages. Only problem is that for some reason a few of your
readers don't want to give you their age - they stubbornly refuse to
fill that field in. What's a poor database administrator to do?</p>
<p>Assume that the age is represented by an <code>int</code>, there are two possible
ways to solve this problem. The most common one (and the most <em>wrong</em>
one) is to assume some sort of &quot;special&quot; value for the age which means
that the age information wasn't collected. So if, say, age = -1 then the
data wasn't collected, otherwise the data was collected (even if it's
not valid!). This method kind of works until you start, for example,
calculating the mean age of visitors to your website. Since you forgot
to take into account your special value, you conclude that the mean age
of visitors is 7½ years old, and you employ web designers to remove all
the long words and use primary colours everywhere.</p>
<p>The other, correct method is to store the age in a field which has type
&quot;int or null&quot;. Here's a SQL table for storing ages:</p>
<pre><code class="language-SQL">create table users
(
  userid serial,
  name text not null,
  age int             -- may be null
);
</code></pre>
<p>If the age data isn't collected, then it goes into the database as a
special SQL <code>NULL</code> value. SQL ignores this automatically when you ask it
to compute averages and so on.</p>
<p>Programming languages also support nulls, although they may be easier to
use in some than in others. In Java, any reference to
an object can be null, so it might make sense in Java to store the
age as an <code>Integer</code> and allow references to the age to be null. In C
pointers can, of course, be null, but if you wanted a simple integer to
be null, you'd have to first box it up into an object allocated by
<code>malloc</code> on the heap.</p>
<p>OCaml has an elegant solution to the problem of nulls, using a simple
polymorphic variant type defined (in <code>Stdlib</code>) as:</p>
<pre><code class="language-ocaml">type 'a option = None | Some of 'a
</code></pre>
<p>A &quot;null pointer&quot; is written <code>None</code>. The type of age in our example above
(an <code>int</code> which can be null) is <code>int option</code> (remember: backwards like
<code>int list</code> and <code>int binary_tree</code>).</p>
<pre><code class="language-ocaml"># Some 3
- : int option = Some 3
</code></pre>
<p>What about a list of optional ints?</p>
<pre><code class="language-ocaml"># [None; Some 3; Some 6; None]
- : int option list = [None; Some 3; Some 6; None]
</code></pre>
<p>And what about an optional list of ints?</p>
<pre><code class="language-ocaml"># Some [1; 2; 3]
- : int list option = Some [1; 2; 3]
</code></pre>
<h2 id="assert-warnings-fatal-errors-and-printing-to-stderr">Assert, warnings, fatal errors, and printing to stderr</h2>
<p>The built-in <code>assert</code> takes an expression as an argument and throws an
exception <em>if</em> the provided expression evaluates to <code>false</code>.
Assuming that you don't catch this exception (it's probably
unwise to catch this exception, particularly for beginners), this
results in the program stopping and printing out the source file and
line number where the error occurred. An example:</p>
<pre><code class="language-ocaml"># assert (Sys.os_type = &quot;Win32&quot;)
Exception: Assert_failure (&quot;//toplevel//&quot;, 1, 1).
</code></pre>
<p>(Running this on Win32, of course, won't throw an error).</p>
<p>You can also just call <code>assert false</code> to stop your program if things
just aren't going well, but you're probably better to use ...</p>
<p><code>failwith &quot;error message&quot;</code> throws a <code>Failure</code> exception, which again
assuming you don't try to catch it, will stop the program with the given
error message. <code>failwith</code> is often used during pattern matching, like
this real example:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">match Sys.os_type with
| &quot;Unix&quot; | &quot;Cygwin&quot; -&gt;   (* code omitted *)
| &quot;Win32&quot; -&gt;             (* code omitted *)
| &quot;MacOS&quot; -&gt;             (* code omitted *)
| _ -&gt; failwith &quot;this system is not supported&quot;
</code></pre>
<p>Note a couple of extra pattern matching features in this example too. A
so-called &quot;range pattern&quot; is used to match either <code>&quot;Unix&quot;</code> or
<code>&quot;Cygwin&quot;</code>, and the special <code>_</code> pattern which matches &quot;anything else&quot;.</p>
<p>If you want to debug your program, then you'll probably want to print out a
warning some way through your function. Here's an example:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">open Graphics
  
let () =
  open_graph &quot; 640x480&quot;;
  for i = 12 downto 1 do
    let radius = i * 20 in
    prerr_endline (&quot;radius is &quot; ^ string_of_int radius);
    set_color (if i mod 2 = 0 then red else yellow);
    fill_circle 320 240 radius
  done;
  ignore(read_line ())
</code></pre>
<p>If you prefer C-style <code>printf</code>'s then try using OCaml's <code>Printf</code> module
instead:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">open Graphics
  
let () =
  open_graph &quot; 640x480&quot;;
  for i = 12 downto 1 do
    let radius = i * 20 in
    Printf.eprintf &quot;radius is %d\\n&quot; radius;
    set_color (if i mod 2 = 0 then red else yellow);
    fill_circle 320 240 radius
  done;
  ignore(read_line ())
</code></pre>
|js}
  };
 
  { title = {js|Functors|js}
  ; slug = {js|functors|js}
  ; description = {js|Learn about functors, modules parameterised by other modules
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["language"]
  ; users = [`Beginner; `Intermediate]
  ; body_md = {js|
Functors are probably one of the most complex features of OCaml, but you don't
have to use them extensively to be a successful OCaml programmer.  Actually,
you may never have to define a functor yourself, but you will surely encounter
them in the standard library. They are the only way of using the Set and Map
modules, but using them is not so difficult.

##  What are functors and why do we need them?

A functor is a module that is parametrized by another module, just like a
function is a value which is parametrized by other values, the arguments.

It allows one to parametrize a type by a value, which is not possible directly
in OCaml without functors. For example, we can define a functor that takes an
int n and returns a collection of array operations that work exclusively on
arrays of length n. If by mistake the programmer passes a regular array to one
of those functions, it will result in a compilation error. If we were not using
this functor but the standard array type, the compiler would not be able to
detect the error, and we would get a runtime error at some undetermined date in
the future, which is much worse.

##  Using an existing functor

The standard library defines a `Set` module, which provides a `Make` functor.
This functor takes one argument, which is a module that provides (at least) two
things: the type of elements, given as `t` and the comparison function given as
`compare`. The point of the functor is to ensure that the same comparison
function will always be used, even if the programmer makes a mistake.

For example, if we want to use sets of ints, we would do this:

```ocaml
# module Int_set =
  Set.Make (struct
              type t = int
              let compare = compare
            end)
module Int_set :
  sig
    type elt = int
    type t
    val empty : t
    val is_empty : t -> bool
    val mem : int -> t -> bool
    val add : int -> t -> t
    val singleton : int -> t
    val remove : int -> t -> t
    val union : t -> t -> t
    val inter : t -> t -> t
    val disjoint : t -> t -> bool
    val diff : t -> t -> t
    val compare : t -> t -> int
    val equal : t -> t -> bool
    val subset : t -> t -> bool
    val iter : (int -> unit) -> t -> unit
    val map : (int -> int) -> t -> t
    val fold : (int -> 'a -> 'a) -> t -> 'a -> 'a
    val for_all : (int -> bool) -> t -> bool
    val exists : (int -> bool) -> t -> bool
    val filter : (int -> bool) -> t -> t
    val partition : (int -> bool) -> t -> t * t
    val cardinal : t -> int
    val elements : t -> int list
    val min_elt : t -> int
    val min_elt_opt : t -> int option
    val max_elt : t -> int
    val max_elt_opt : t -> int option
    val choose : t -> int
    val choose_opt : t -> int option
    val split : int -> t -> t * bool * t
    val find : int -> t -> int
    val find_opt : int -> t -> int option
    val find_first : (int -> bool) -> t -> int
    val find_first_opt : (int -> bool) -> t -> int option
    val find_last : (int -> bool) -> t -> int
    val find_last_opt : (int -> bool) -> t -> int option
    val of_list : int list -> t
    val to_seq_from : int -> t -> int Seq.t
    val to_seq : t -> int Seq.t
    val add_seq : int Seq.t -> t -> t
    val of_seq : int Seq.t -> t
  end
```

For sets of strings, it is even easier because the standard library provides a
`String` module with a type `t` and a function `compare`. If you were following
carefully, by now you must have guessed how to create a module for the
manipulation of sets of strings:

```ocaml
# module String_set = Set.Make (String)
module String_set :
  sig
    type elt = string
    type t = Set.Make(String).t
    val empty : t
    val is_empty : t -> bool
    val mem : elt -> t -> bool
    val add : elt -> t -> t
    val singleton : elt -> t
    val remove : elt -> t -> t
    val union : t -> t -> t
    val inter : t -> t -> t
    val disjoint : t -> t -> bool
    val diff : t -> t -> t
    val compare : t -> t -> int
    val equal : t -> t -> bool
    val subset : t -> t -> bool
    val iter : (elt -> unit) -> t -> unit
    val map : (elt -> elt) -> t -> t
    val fold : (elt -> 'a -> 'a) -> t -> 'a -> 'a
    val for_all : (elt -> bool) -> t -> bool
    val exists : (elt -> bool) -> t -> bool
    val filter : (elt -> bool) -> t -> t
    val partition : (elt -> bool) -> t -> t * t
    val cardinal : t -> int
    val elements : t -> elt list
    val min_elt : t -> elt
    val min_elt_opt : t -> elt option
    val max_elt : t -> elt
    val max_elt_opt : t -> elt option
    val choose : t -> elt
    val choose_opt : t -> elt option
    val split : elt -> t -> t * bool * t
    val find : elt -> t -> elt
    val find_opt : elt -> t -> elt option
    val find_first : (elt -> bool) -> t -> elt
    val find_first_opt : (elt -> bool) -> t -> elt option
    val find_last : (elt -> bool) -> t -> elt
    val find_last_opt : (elt -> bool) -> t -> elt option
    val of_list : elt list -> t
    val to_seq_from : elt -> t -> elt Seq.t
    val to_seq : t -> elt Seq.t
    val add_seq : elt Seq.t -> t -> t
    val of_seq : elt Seq.t -> t
  end
```

(the parentheses are necessary)

##  Defining functors

A functor with one argument can be defined like this:

<!-- $MDX skip -->
```ocaml
module F (X : X_type) = struct
  ...
end
```

where `X` is the module that will be passed as argument, and `X_type` is its
signature, which is mandatory.

The signature of the returned module itself can be constrained, using this
syntax:

<!-- $MDX skip -->
```ocaml
module F (X : X_type) : Y_type =
struct
  ...
end
```

or by specifying this in the .mli file:

<!-- $MDX skip -->
```ocaml
module F (X : X_type) : Y_type
```

Overall, the syntax of functors is hard to grasp. The best may be to look at
the source files
[`set.ml`](https://github.com/ocaml/ocaml/blob/trunk/stdlib/set.ml) or
[`map.ml`](https://github.com/ocaml/ocaml/blob/trunk/stdlib/map.ml) of the
standard library.
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#what-are-functors-and-why-do-we-need-them">What are functors and why do we need them?</a>
</li>
<li><a href="#using-an-existing-functor">Using an existing functor</a>
</li>
<li><a href="#defining-functors">Defining functors</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<p>Functors are probably one of the most complex features of OCaml, but you don't
have to use them extensively to be a successful OCaml programmer.  Actually,
you may never have to define a functor yourself, but you will surely encounter
them in the standard library. They are the only way of using the Set and Map
modules, but using them is not so difficult.</p>
<h2 id="what-are-functors-and-why-do-we-need-them">What are functors and why do we need them?</h2>
<p>A functor is a module that is parametrized by another module, just like a
function is a value which is parametrized by other values, the arguments.</p>
<p>It allows one to parametrize a type by a value, which is not possible directly
in OCaml without functors. For example, we can define a functor that takes an
int n and returns a collection of array operations that work exclusively on
arrays of length n. If by mistake the programmer passes a regular array to one
of those functions, it will result in a compilation error. If we were not using
this functor but the standard array type, the compiler would not be able to
detect the error, and we would get a runtime error at some undetermined date in
the future, which is much worse.</p>
<h2 id="using-an-existing-functor">Using an existing functor</h2>
<p>The standard library defines a <code>Set</code> module, which provides a <code>Make</code> functor.
This functor takes one argument, which is a module that provides (at least) two
things: the type of elements, given as <code>t</code> and the comparison function given as
<code>compare</code>. The point of the functor is to ensure that the same comparison
function will always be used, even if the programmer makes a mistake.</p>
<p>For example, if we want to use sets of ints, we would do this:</p>
<pre><code class="language-ocaml"># module Int_set =
  Set.Make (struct
              type t = int
              let compare = compare
            end)
module Int_set :
  sig
    type elt = int
    type t
    val empty : t
    val is_empty : t -&gt; bool
    val mem : int -&gt; t -&gt; bool
    val add : int -&gt; t -&gt; t
    val singleton : int -&gt; t
    val remove : int -&gt; t -&gt; t
    val union : t -&gt; t -&gt; t
    val inter : t -&gt; t -&gt; t
    val disjoint : t -&gt; t -&gt; bool
    val diff : t -&gt; t -&gt; t
    val compare : t -&gt; t -&gt; int
    val equal : t -&gt; t -&gt; bool
    val subset : t -&gt; t -&gt; bool
    val iter : (int -&gt; unit) -&gt; t -&gt; unit
    val map : (int -&gt; int) -&gt; t -&gt; t
    val fold : (int -&gt; 'a -&gt; 'a) -&gt; t -&gt; 'a -&gt; 'a
    val for_all : (int -&gt; bool) -&gt; t -&gt; bool
    val exists : (int -&gt; bool) -&gt; t -&gt; bool
    val filter : (int -&gt; bool) -&gt; t -&gt; t
    val partition : (int -&gt; bool) -&gt; t -&gt; t * t
    val cardinal : t -&gt; int
    val elements : t -&gt; int list
    val min_elt : t -&gt; int
    val min_elt_opt : t -&gt; int option
    val max_elt : t -&gt; int
    val max_elt_opt : t -&gt; int option
    val choose : t -&gt; int
    val choose_opt : t -&gt; int option
    val split : int -&gt; t -&gt; t * bool * t
    val find : int -&gt; t -&gt; int
    val find_opt : int -&gt; t -&gt; int option
    val find_first : (int -&gt; bool) -&gt; t -&gt; int
    val find_first_opt : (int -&gt; bool) -&gt; t -&gt; int option
    val find_last : (int -&gt; bool) -&gt; t -&gt; int
    val find_last_opt : (int -&gt; bool) -&gt; t -&gt; int option
    val of_list : int list -&gt; t
    val to_seq_from : int -&gt; t -&gt; int Seq.t
    val to_seq : t -&gt; int Seq.t
    val add_seq : int Seq.t -&gt; t -&gt; t
    val of_seq : int Seq.t -&gt; t
  end
</code></pre>
<p>For sets of strings, it is even easier because the standard library provides a
<code>String</code> module with a type <code>t</code> and a function <code>compare</code>. If you were following
carefully, by now you must have guessed how to create a module for the
manipulation of sets of strings:</p>
<pre><code class="language-ocaml"># module String_set = Set.Make (String)
module String_set :
  sig
    type elt = string
    type t = Set.Make(String).t
    val empty : t
    val is_empty : t -&gt; bool
    val mem : elt -&gt; t -&gt; bool
    val add : elt -&gt; t -&gt; t
    val singleton : elt -&gt; t
    val remove : elt -&gt; t -&gt; t
    val union : t -&gt; t -&gt; t
    val inter : t -&gt; t -&gt; t
    val disjoint : t -&gt; t -&gt; bool
    val diff : t -&gt; t -&gt; t
    val compare : t -&gt; t -&gt; int
    val equal : t -&gt; t -&gt; bool
    val subset : t -&gt; t -&gt; bool
    val iter : (elt -&gt; unit) -&gt; t -&gt; unit
    val map : (elt -&gt; elt) -&gt; t -&gt; t
    val fold : (elt -&gt; 'a -&gt; 'a) -&gt; t -&gt; 'a -&gt; 'a
    val for_all : (elt -&gt; bool) -&gt; t -&gt; bool
    val exists : (elt -&gt; bool) -&gt; t -&gt; bool
    val filter : (elt -&gt; bool) -&gt; t -&gt; t
    val partition : (elt -&gt; bool) -&gt; t -&gt; t * t
    val cardinal : t -&gt; int
    val elements : t -&gt; elt list
    val min_elt : t -&gt; elt
    val min_elt_opt : t -&gt; elt option
    val max_elt : t -&gt; elt
    val max_elt_opt : t -&gt; elt option
    val choose : t -&gt; elt
    val choose_opt : t -&gt; elt option
    val split : elt -&gt; t -&gt; t * bool * t
    val find : elt -&gt; t -&gt; elt
    val find_opt : elt -&gt; t -&gt; elt option
    val find_first : (elt -&gt; bool) -&gt; t -&gt; elt
    val find_first_opt : (elt -&gt; bool) -&gt; t -&gt; elt option
    val find_last : (elt -&gt; bool) -&gt; t -&gt; elt
    val find_last_opt : (elt -&gt; bool) -&gt; t -&gt; elt option
    val of_list : elt list -&gt; t
    val to_seq_from : elt -&gt; t -&gt; elt Seq.t
    val to_seq : t -&gt; elt Seq.t
    val add_seq : elt Seq.t -&gt; t -&gt; t
    val of_seq : elt Seq.t -&gt; t
  end
</code></pre>
<p>(the parentheses are necessary)</p>
<h2 id="defining-functors">Defining functors</h2>
<p>A functor with one argument can be defined like this:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">module F (X : X_type) = struct
  ...
end
</code></pre>
<p>where <code>X</code> is the module that will be passed as argument, and <code>X_type</code> is its
signature, which is mandatory.</p>
<p>The signature of the returned module itself can be constrained, using this
syntax:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">module F (X : X_type) : Y_type =
struct
  ...
end
</code></pre>
<p>or by specifying this in the .mli file:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">module F (X : X_type) : Y_type
</code></pre>
<p>Overall, the syntax of functors is hard to grasp. The best may be to look at
the source files
<a href="https://github.com/ocaml/ocaml/blob/trunk/stdlib/set.ml"><code>set.ml</code></a> or
<a href="https://github.com/ocaml/ocaml/blob/trunk/stdlib/map.ml"><code>map.ml</code></a> of the
standard library.</p>
|js}
  };
 
  { title = {js|Objects|js}
  ; slug = {js|objects|js}
  ; description = {js|OCaml is an object-oriented, imperative, functional programming language
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["language"]
  ; users = [`Intermediate; `Advanced]
  ; body_md = {js|
## Objects and classes
OCaml is an object-oriented, imperative, functional programming language
:-) It mixes all these paradigms and lets you use the most appropriate
(or most familiar) programming paradigm for the task at hand. In this
chapter I'm going to look at object-oriented programming in OCaml, but
I'm also going to talk about why you might or might not want to write
object-oriented programs.

The classic noddy example used in text books to demonstrate
object-oriented programming is the stack class. This is a pretty
terrible example in many ways, but I'm going to use it here to show the
basics of writing object-oriented OCaml.

Here's some basic code to provide a stack of integers. The class is
implemented using a linked list.

```ocaml
# class stack_of_ints =
  object (self)
    val mutable the_list = ([] : int list)     (* instance variable *)
    method push x =                            (* push method *)
      the_list <- x :: the_list
    method pop =                               (* pop method *)
      let result = List.hd the_list in
      the_list <- List.tl the_list;
      result
    method peek =                              (* peek method *)
      List.hd the_list
    method size =                              (* size method *)
      List.length the_list
  end
class stack_of_ints :
  object
    val mutable the_list : int list
    method peek : int
    method pop : int
    method push : int -> unit
    method size : int
  end
```

The basic pattern `class name = object (self) ... end` defines a class
called `name`.

The class has one instance variable, which is mutable (not constant),
called `the_list`. This is the underlying linked list. We initialize
this (each time a `stack_of_ints` object is created) using a bit of code
that you may not be familiar with. The expression `( [] : int list )`
means "an empty list, of type `int list`". Recall that the simple empty
list `[]` has type `'a list`, meaning a list of any type. However we
want a stack of `int`, not anything else, and so in this case we want to
tell the type inference engine that this list isn't the general "list of
anything" but is in fact the narrower "list of `int`". The syntax
`( expression : type )` means `expression` which is in fact of type
`type`. This *isn't* a general type cast, because you can't use it to
overrule the type inference engine, only to narrow a general type to
make it more specific. So you can't write, for example, `( 1 : float )`:

```ocaml
# (1 : float)
Line 1, characters 2-3:
Error: This expression has type int but an expression was expected of type
         float
  Hint: Did you mean `1.'?
```

Type safety is preserved. Back to the example ...

This class has four simple methods. `push` pushes an integer onto the
stack. `pop` pops the top integer off the stack and returns it. Notice
the `<-` assignment operator used for updating our mutable instance
variable. It's the same `<-` assignment operator which is used for
updating mutable fields in records.

`peek` returns the top of the stack (ie. head of the list) without
affecting the stack, while `size` returns the number of elements in the
stack (ie. the length of the list).

Let's write some code to test stacks of ints. First let's create a new
object. We use the familiar `new` operator:

```ocaml
# let s = new stack_of_ints
val s : stack_of_ints = <obj>
```
Now we'll push and pop some elements off the stack:

```ocaml
# for i = 1 to 10 do
    s#push i
  done
- : unit = ()
# while s#size > 0 do
    Printf.printf "Popped %d off the stack.\\n" s#pop
  done
Popped 10 off the stack.
Popped 9 off the stack.
Popped 8 off the stack.
Popped 7 off the stack.
Popped 6 off the stack.
Popped 5 off the stack.
Popped 4 off the stack.
Popped 3 off the stack.
Popped 2 off the stack.
Popped 1 off the stack.
- : unit = ()
```
Notice the syntax. `object#method` means call `method` on `object`. This
is the same as `object.method` or `object->method` that you will be
familiar with in imperative languages.

In the OCaml toplevel we can examine the types of objects and methods in
more detail:

```ocaml
# let s = new stack_of_ints
val s : stack_of_ints = <obj>
# s#push
- : int -> unit = <fun>
```

`s` is an opaque object. The implementation (ie. the list) is hidden
from callers.

###  Polymorphic classes
A stack of integers is good, but what about a stack that can store any
type? (Not a single stack that can store a mixture of types, but
multiple stacks each storing objects of any single type). As with
`'a list`, we can define `'a stack`:

```ocaml
# class ['a] stack =
  object (self)
    val mutable list = ([] : 'a list)    (* instance variable *)
    method push x =                      (* push method *)
      list <- x :: list
    method pop =                         (* pop method *)
      let result = List.hd list in
      list <- List.tl list;
      result
    method peek =                        (* peek method *)
      List.hd list
    method size =                        (* size method *)
      List.length list
  end
class ['a] stack :
  object
    val mutable list : 'a list
    method peek : 'a
    method pop : 'a
    method push : 'a -> unit
    method size : int
  end
```
The `class ['a] stack` doesn't really define just one class, but a whole
"class of classes", one for every possible type (ie. an infinitely large
number of classes!) Let's try and use our `'a stack` class. In this
instance we create a stack and push a floating point number onto the
stack. Notice the type of the stack:

```ocaml
# let s = new stack
val s : '_weak1 stack = <obj>
# s#push 1.0
- : unit = ()
# s
- : float stack = <obj>
```

This stack is now a `float stack`, and only floating point numbers may
be pushed and popped from this stack. Let's demonstrate the type-safety
of our new `float stack`:

```ocaml
# s#push 3.0
- : unit = ()
# s#pop
- : float = 3.
# s#pop
- : float = 1.
# s#push "a string"
Line 1, characters 8-18:
Error: This expression has type string but an expression was expected of type
         float
```

We can define polymorphic functions which can operate on any type of
stack. Our first attempt is this one:

```ocaml
# let drain_stack s =
  while s#size > 0 do
    ignore (s#pop)
  done
val drain_stack : < pop : 'a; size : int; .. > -> unit = <fun>
```

Notice the type of `drain_stack`. Cleverly - perhaps *too* cleverly -
OCaml's type inference engine has worked out that `drain_stack` works on
*any* object which has `pop` and `size` methods! So if we defined
another, entirely separate class which happened to contain `pop` and
`size` methods with suitable type signatures, then we might accidentally
call `drain_stack` on objects of that other type.

We can force OCaml to be more specific and only allow `drain_stack` to
be called on `'a stack`s by narrowing the type of the `s` argument, like
this:

```ocaml
# let drain_stack (s : 'a stack) =
  while s#size > 0 do
    ignore (s#pop)
  done
val drain_stack : 'a stack -> unit = <fun>
```

###  Inheritance, virtual classes, initializers
I've noticed programmers in Java tend to overuse inheritance, possibly
because it's the only reasonable way of extending code in that language.
A much better and more general way to extend code is usually to use
hooks (cf. Apache's module API). Nevertheless in certain narrow areas
inheritance can be useful, and the most important of these is in writing
GUI widget libraries.

Let's consider an imaginary OCaml widget library similar to Java's
Swing. We will define buttons and labels with the following class
hierarchy:

```
widget  (superclass for all widgets)
  |
  +----> container  (any widget that can contain other widgets)
  |        |
  |        +----> button
  |
  +-------------> label
```
(Notice that a `button` is a `container` because it can contain either a
label or an image, depending on what is displayed on the button).

`widget` is the virtual superclass for all widgets. I want every widget
to have a name (just a string) which is constant over the life of that
widget. This was my first attempt:

```ocaml
# class virtual widget name =
  object (self)
    method get_name =
      name
    method virtual repaint : unit
  end
Lines 1-6, characters 1-6:
Error: Some type variables are unbound in this type:
         class virtual widget :
           'a ->
           object method get_name : 'a method virtual repaint : unit end
       The method get_name has type 'a where 'a is unbound
```
Oops! I forgot that OCaml cannot infer the type of `name` so will assume
that it is `'a`. But that defines a polymorphic class, and I didn't
declare the class as polymorphic (`class ['a] widget`). I need to narrow
the type of `name` like this:

```ocaml
# class virtual widget (name : string) =
  object (self)
    method get_name =
      name
    method virtual repaint : unit
  end;;
class virtual widget :
  string -> object method get_name : string method virtual repaint : unit end
```
Now there are several new things going on in this code. Firstly the
class contains an **initializer**. This is an argument to the class
(`name`) which you can think of as exactly the equivalent of an argument
to a constructor in, eg., Java:

```java
public class Widget
{
  public Widget (String name)
  {
    ...
  }
}
```
In OCaml a constructor constructs the whole class, it's not just a
specially named function, so we write the arguments as if they are
arguments to the class:

<!-- $MDX skip -->
```ocaml
class foo arg1 arg2 ... =
```

Secondly the class contains a virtual method, and thus the whole class
is marked as virtual. The virtual method is our `repaint` method. We
need to tell OCaml it's virtual (`method virtual`), *and* we need to
tell OCaml the type of the method. Because the method doesn't contain
any code, OCaml can't use type inference to automatically work out the
type for you, so you need to tell it the type. In this case the method
just returns `unit`. If your class contains any virtual methods (even
just inherited ones) then you need to specify the whole class as virtual
by using `class virtual ...`.

As in C++ and Java, virtual classes cannot be directly instantiated
using `new`:

```ocaml
# let w = new widget "my widget"
Line 1, characters 9-19:
Error: Cannot instantiate the virtual class widget
```

Now my `container` class is more interesting. It must inherit from
`widget` and have the mechanics for storing the list of contained
widgets. Here is my simple implementation for `container`:

```ocaml
# class virtual container name =
  object (self)
    inherit widget name
    val mutable widgets = ([] : widget list)
    method add w =
      widgets <- w :: widgets
    method get_widgets =
      widgets
    method repaint =
      List.iter (fun w -> w#repaint) widgets
  end
class virtual container :
  string ->
  object
    val mutable widgets : widget list
    method add : widget -> unit
    method get_name : string
    method get_widgets : widget list
    method repaint : unit
  end
```

Notes:

1. The `container` class is marked as virtual. It doesn't contain any
 virtual methods, but in this case I just want to prevent people
 creating containers directly.
1. The `container` class has a `name` argument which is passed directly
 up when constructing the `widget`.
1. `inherit widget name` means that the `container` inherits from
 `widget`, and it passes the `name` argument to the constructor for
 `widget`.
1. My `container` contains a mutable list of widgets and methods to
 `add` a widget to this list and `get_widgets` (return the list of
 widgets).
1. The list of widgets returned by `get_widgets` cannot be modified by
 code outside the class. The reason for this is somewhat subtle, but
 basically comes down to the fact that OCaml's linked lists are
 immutable. Let's imagine that someone wrote this code:

  ```ocaml
  # let list = container#get_widgets in
    x :: list
  ```

Would this modify the private internal representation of my `container`
class, by prepending `x` to the list of widgets? No it wouldn't. The
private variable `widgets` would be unaffected by this or any other
change attempted by the outside code. This means, for example, that you
could change the internal representation to use an array at some later
date, and no code outside the class would need to be changed.

Last, but not least, we have implemented the previously virtual
`repaint` function so that `container#repaint` will repaint all of the
contained widgets. Notice I use `List.iter` to iterate over the list,
and I also use a probably unfamiliar anonymous function expression:

```ocaml
# (fun w -> w#repaint)
- : < repaint : 'a; .. > -> 'a = <fun>
```
which defines an anonymous function with one argument `w` that just
calls `w#repaint` (the `repaint` method on widget `w`).

In this instance our `button` class is simple (rather unrealistically
simple in fact, but nevermind that):

```ocaml
# type button_state = Released | Pressed
type button_state = Released | Pressed
# class button ?callback name =
  object (self)
    inherit container name as super
    val mutable state = Released
    method press =
      state <- Pressed;
      match callback with
      | None -> ()
      | Some f -> f ()
    method release =
      state <- Released
    method repaint =
      super#repaint;
      print_endline ("Button being repainted, state is " ^
                     (match state with
                      | Pressed -> "Pressed"
                      | Released -> "Released"))
  end
class button :
  ?callback:(unit -> unit) ->
  string ->
  object
    val mutable state : button_state
    val mutable widgets : widget list
    method add : widget -> unit
    method get_name : string
    method get_widgets : widget list
    method press : unit
    method release : unit
    method repaint : unit
  end
```

Notes:

1. This function has an optional argument (see the previous chapter)
 which is used to pass in the optional callback function. The
 callback is called when the button is pressed.
1. The expression `inherit container name as super` names the
 superclass `super`. I use this in the `repaint` method:
 `super#repaint`. This expressly calls the superclass method.
1. Pressing the button (calling `button#press` in this rather
 simplistic code) sets the state of the button to `Pressed` and calls
 the callback function, if one was defined. Notice that the
 `callback` variable is either `None` or `Some f`, in other words it
 has type `(unit -> unit) option`. Reread the previous chapter if you
 are unsure about this.
1. Notice a strange thing about the `callback` variable. It's defined
 as an argument to the class, but any method can see and use it. In
 other words, the variable is supplied when the object is
 constructed, but persists over the lifetime of the object.
1. The `repaint` method has been implemented. It calls the superclass
 (to repaint the container), then repaints the button, displaying the
 current state of the button.

Before defining our `label` class, let's play with the `button` class in
the OCaml toplevel:

```ocaml
# let b = new button ~callback:(fun () -> print_endline "Ouch!") "button"
val b : button = <obj>
# b#repaint
Button being repainted, state is Released
- : unit = ()
# b#press
Ouch!
- : unit = ()
# b#repaint
Button being repainted, state is Pressed
- : unit = ()
# b#release
- : unit = ()
```

Here's our comparatively trivial `label` class:

```ocaml
# class label name text =
  object (self)
    inherit widget name
    method repaint =
      print_endline ("Label: " ^ text)
  end
class label :
  string ->
  string -> object method get_name : string method repaint : unit end
```
Let's create a label which says "Press me!" and add it to the button:

```ocaml
# let l = new label "label" "Press me!"
val l : label = <obj>
# b#add l
- : unit = ()
# b#repaint
Label: Press me!
Button being repainted, state is Released
- : unit = ()
```

###  A note about `self`
In all the examples above we defined classes using the general pattern:

<!-- $MDX skip -->
```ocaml
class name =
  object (self)
    (* ... *)
  end
```
I didn't explain the reference to `self`. In fact this names the object,
allowing you to call methods in the same class or pass the object to
functions outside the class. In other words, it's exactly the same as
`this` in C++/Java. You may completely omit the
`(self)` part if you don't need to refer to yourself - indeed in all the
examples above we could have done exactly that. However, I would advise
you to leave it in there because you never know when you might modify
the class and require the reference to `self`. There is no penalty for
having it.

###  Inheritance and coercions

```ocaml
# let b = new button "button"
val b : button = <obj>
# let l = new label "label" "Press me!"
val l : label = <obj>
# [b; l]
Line 1, characters 5-6:
Error: This expression has type label but an expression was expected of type
         button
       The first object type has no method add
```
I created a button `b` and a label `l` and I tried to create a list
containing both, but I got an error. Yet `b` and `l` are both `widget`s,
so why can't I put them into the same list? Perhaps OCaml can't guess
that I want a `widget list`? Let's try telling it:

```ocaml
# let wl = ([] : widget list)
val wl : widget list = []
# let wl = b :: wl
Line 1, characters 15-17:
Error: This expression has type widget list
       but an expression was expected of type button list
       Type widget = < get_name : string; repaint : unit >
       is not compatible with type
         button =
           < add : widget -> unit; get_name : string;
             get_widgets : widget list; press : unit; release : unit;
             repaint : unit >
       The first object type has no method add
```

It turns out that OCaml doesn't coerce subclasses to the type of the
superclass by default, but you can tell it to by using the `:>`
(coercion) operator:

```ocaml
# let wl = (b :> widget) :: wl
val wl : widget list = [<obj>]
# let wl = (l :> widget) :: wl
val wl : widget list = [<obj>; <obj>]
```

The expression `(b :> widget)` means "coerce the button `b` to have type
`widget`". Type-safety is preserved because it is possible to tell
completely at compile time whether the coercion will succeed.

Actually, coercions are somewhat more subtle than described above, and
so I urge you to read the manual to find out the full details.

The `container#add` method defined above is actually incorrect, and
fails if you try to add widgets of different types into a `container`. A
coercion would fix this.

Is it possible to coerce from a superclass (eg. `widget`) to a subclass
(eg. `button`)? The answer, perhaps surprisingly, is NO! Coercing in
this direction is *unsafe*. You might try to coerce a `widget` which is
in fact a `label`, not a `button`.

###  The `Oo` module and comparing objects
The `Oo` module contains a few useful functions for OO programming.

`Oo.copy` makes a shallow copy of an object. `Oo.id object` returns a
unique identifying number for each object (a unique number across all
classes).

`=` and `<>` can be used to compare objects for *physical* equality (an
object and its copy are not physically identical). You can also use `<`
etc. which provides an ordering of objects based apparently on their
IDs.

## Objects without class
Here we examine how to use objects pretty much like records, without
necessarily using classes.

###  Immediate objects and object types
Objects can be used instead of records, and have some nice properties
that can make them preferable to records in some cases. We saw that the
canonical way of creating objects is to first define a class, and use
this class to create individual objects. This can be cumbersome in some
situations since class definitions are more than a type definition and
cannot be defined recursively with types. However, objects have a type
that is very analog to a record type, and it can be used in type
definitions. In addition, objects can be created without a class. They
are called *immediate objects*. Here is the definition of an immediate
object:

```ocaml
# let o =
  object
    val mutable n = 0
    method incr = n <- n + 1
    method get = n
  end
val o : < get : int; incr : unit > = <obj>
```

This object has a type, which is defined by its public methods only.
Values are not visible and neither are private methods (not shown).
Unlike records, such a type does not need to be predefined explicitly,
but doing so can make things clearer. We can do it like this:

```ocaml
# type counter = <get : int; incr : unit>
type counter = < get : int; incr : unit >
```
Compare with an equivalent record type definition:

```ocaml
# type counter_r =
  {get : unit -> int;
   incr : unit -> unit}
type counter_r = { get : unit -> int; incr : unit -> unit; }
```
The implementation of a record working like our object would be:

```ocaml
# let r =
  let n = ref 0 in
    {get = (fun () -> !n);
     incr = (fun () -> incr n)}
val r : counter_r = {get = <fun>; incr = <fun>}
```
In terms of functionality, both the object and the record are similar,
but each solution has its own advantages:

* **speed**: slightly faster field access in records
* **field names**: it is inconvenient to manipulate records of
 different types when some fields are named identically but it's not
 a problem with objects
* **subtyping**: it is impossible to coerce the type of a record to a
 type with less fields. That is however possible with objects, so
 objects of different kinds that share some methods can be mixed in a
 data structure where only their common methods are visible (see next
 section)
* **type definitions**: there is no need to define an object type in
 advance, so it lightens the dependency constraints between modules

###  Class types vs. just types
Beware of the confusion between *class types* and object *types*. A
*class type* is not a data *type*, normally referred to as *type* in the
OCaml jargon. An object *type* is a kind of data *type*, just like a
record type or a tuple.

When a class is defined, both a *class type* and an object *type* of the
same name are defined:

```ocaml
# class t =
  object
    val x = 0
    method get = x
  end
class t : object val x : int method get : int end
```

`object val x : int method get : int end` is a class type.

In this example, `t` is also the type of objects that this class would
create. Objects that derive from different classes or no class at all
(immediate objects) can be mixed together as long as they have the same
type:

```ocaml
# let x = object method get = 123 end
val x : < get : int > = <obj>
# let l = [new t; x]
val l : t list = [<obj>; <obj>]
```

Mixing objects that share a common subtype can be done, but requires
explicit type coercion using the `:>` operator:

```ocaml
# let x = object method get = 123 end
val x : < get : int > = <obj>
# let y = object method get = 80 method special = "hello" end
val y : < get : int; special : string > = <obj>
# let l = [x; y]
Line 1, characters 13-14:
Error: This expression has type < get : int; special : string >
       but an expression was expected of type < get : int >
       The second object type has no method special
# let l = [x; (y :> t)]
val l : t list = [<obj>; <obj>]
```
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#objects-and-classes">Objects and classes</a>
</li>
<li><a href="#objects-without-class">Objects without class</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<h2 id="objects-and-classes">Objects and classes</h2>
<p>OCaml is an object-oriented, imperative, functional programming language
:-) It mixes all these paradigms and lets you use the most appropriate
(or most familiar) programming paradigm for the task at hand. In this
chapter I'm going to look at object-oriented programming in OCaml, but
I'm also going to talk about why you might or might not want to write
object-oriented programs.</p>
<p>The classic noddy example used in text books to demonstrate
object-oriented programming is the stack class. This is a pretty
terrible example in many ways, but I'm going to use it here to show the
basics of writing object-oriented OCaml.</p>
<p>Here's some basic code to provide a stack of integers. The class is
implemented using a linked list.</p>
<pre><code class="language-ocaml"># class stack_of_ints =
  object (self)
    val mutable the_list = ([] : int list)     (* instance variable *)
    method push x =                            (* push method *)
      the_list &lt;- x :: the_list
    method pop =                               (* pop method *)
      let result = List.hd the_list in
      the_list &lt;- List.tl the_list;
      result
    method peek =                              (* peek method *)
      List.hd the_list
    method size =                              (* size method *)
      List.length the_list
  end
class stack_of_ints :
  object
    val mutable the_list : int list
    method peek : int
    method pop : int
    method push : int -&gt; unit
    method size : int
  end
</code></pre>
<p>The basic pattern <code>class name = object (self) ... end</code> defines a class
called <code>name</code>.</p>
<p>The class has one instance variable, which is mutable (not constant),
called <code>the_list</code>. This is the underlying linked list. We initialize
this (each time a <code>stack_of_ints</code> object is created) using a bit of code
that you may not be familiar with. The expression <code>( [] : int list )</code>
means &quot;an empty list, of type <code>int list</code>&quot;. Recall that the simple empty
list <code>[]</code> has type <code>'a list</code>, meaning a list of any type. However we
want a stack of <code>int</code>, not anything else, and so in this case we want to
tell the type inference engine that this list isn't the general &quot;list of
anything&quot; but is in fact the narrower &quot;list of <code>int</code>&quot;. The syntax
<code>( expression : type )</code> means <code>expression</code> which is in fact of type
<code>type</code>. This <em>isn't</em> a general type cast, because you can't use it to
overrule the type inference engine, only to narrow a general type to
make it more specific. So you can't write, for example, <code>( 1 : float )</code>:</p>
<pre><code class="language-ocaml"># (1 : float)
Line 1, characters 2-3:
Error: This expression has type int but an expression was expected of type
         float
  Hint: Did you mean `1.'?
</code></pre>
<p>Type safety is preserved. Back to the example ...</p>
<p>This class has four simple methods. <code>push</code> pushes an integer onto the
stack. <code>pop</code> pops the top integer off the stack and returns it. Notice
the <code>&lt;-</code> assignment operator used for updating our mutable instance
variable. It's the same <code>&lt;-</code> assignment operator which is used for
updating mutable fields in records.</p>
<p><code>peek</code> returns the top of the stack (ie. head of the list) without
affecting the stack, while <code>size</code> returns the number of elements in the
stack (ie. the length of the list).</p>
<p>Let's write some code to test stacks of ints. First let's create a new
object. We use the familiar <code>new</code> operator:</p>
<pre><code class="language-ocaml"># let s = new stack_of_ints
val s : stack_of_ints = &lt;obj&gt;
</code></pre>
<p>Now we'll push and pop some elements off the stack:</p>
<pre><code class="language-ocaml"># for i = 1 to 10 do
    s#push i
  done
- : unit = ()
# while s#size &gt; 0 do
    Printf.printf &quot;Popped %d off the stack.\\n&quot; s#pop
  done
Popped 10 off the stack.
Popped 9 off the stack.
Popped 8 off the stack.
Popped 7 off the stack.
Popped 6 off the stack.
Popped 5 off the stack.
Popped 4 off the stack.
Popped 3 off the stack.
Popped 2 off the stack.
Popped 1 off the stack.
- : unit = ()
</code></pre>
<p>Notice the syntax. <code>object#method</code> means call <code>method</code> on <code>object</code>. This
is the same as <code>object.method</code> or <code>object-&gt;method</code> that you will be
familiar with in imperative languages.</p>
<p>In the OCaml toplevel we can examine the types of objects and methods in
more detail:</p>
<pre><code class="language-ocaml"># let s = new stack_of_ints
val s : stack_of_ints = &lt;obj&gt;
# s#push
- : int -&gt; unit = &lt;fun&gt;
</code></pre>
<p><code>s</code> is an opaque object. The implementation (ie. the list) is hidden
from callers.</p>
<h3 id="polymorphic-classes">Polymorphic classes</h3>
<p>A stack of integers is good, but what about a stack that can store any
type? (Not a single stack that can store a mixture of types, but
multiple stacks each storing objects of any single type). As with
<code>'a list</code>, we can define <code>'a stack</code>:</p>
<pre><code class="language-ocaml"># class ['a] stack =
  object (self)
    val mutable list = ([] : 'a list)    (* instance variable *)
    method push x =                      (* push method *)
      list &lt;- x :: list
    method pop =                         (* pop method *)
      let result = List.hd list in
      list &lt;- List.tl list;
      result
    method peek =                        (* peek method *)
      List.hd list
    method size =                        (* size method *)
      List.length list
  end
class ['a] stack :
  object
    val mutable list : 'a list
    method peek : 'a
    method pop : 'a
    method push : 'a -&gt; unit
    method size : int
  end
</code></pre>
<p>The <code>class ['a] stack</code> doesn't really define just one class, but a whole
&quot;class of classes&quot;, one for every possible type (ie. an infinitely large
number of classes!) Let's try and use our <code>'a stack</code> class. In this
instance we create a stack and push a floating point number onto the
stack. Notice the type of the stack:</p>
<pre><code class="language-ocaml"># let s = new stack
val s : '_weak1 stack = &lt;obj&gt;
# s#push 1.0
- : unit = ()
# s
- : float stack = &lt;obj&gt;
</code></pre>
<p>This stack is now a <code>float stack</code>, and only floating point numbers may
be pushed and popped from this stack. Let's demonstrate the type-safety
of our new <code>float stack</code>:</p>
<pre><code class="language-ocaml"># s#push 3.0
- : unit = ()
# s#pop
- : float = 3.
# s#pop
- : float = 1.
# s#push &quot;a string&quot;
Line 1, characters 8-18:
Error: This expression has type string but an expression was expected of type
         float
</code></pre>
<p>We can define polymorphic functions which can operate on any type of
stack. Our first attempt is this one:</p>
<pre><code class="language-ocaml"># let drain_stack s =
  while s#size &gt; 0 do
    ignore (s#pop)
  done
val drain_stack : &lt; pop : 'a; size : int; .. &gt; -&gt; unit = &lt;fun&gt;
</code></pre>
<p>Notice the type of <code>drain_stack</code>. Cleverly - perhaps <em>too</em> cleverly -
OCaml's type inference engine has worked out that <code>drain_stack</code> works on
<em>any</em> object which has <code>pop</code> and <code>size</code> methods! So if we defined
another, entirely separate class which happened to contain <code>pop</code> and
<code>size</code> methods with suitable type signatures, then we might accidentally
call <code>drain_stack</code> on objects of that other type.</p>
<p>We can force OCaml to be more specific and only allow <code>drain_stack</code> to
be called on <code>'a stack</code>s by narrowing the type of the <code>s</code> argument, like
this:</p>
<pre><code class="language-ocaml"># let drain_stack (s : 'a stack) =
  while s#size &gt; 0 do
    ignore (s#pop)
  done
val drain_stack : 'a stack -&gt; unit = &lt;fun&gt;
</code></pre>
<h3 id="inheritance-virtual-classes-initializers">Inheritance, virtual classes, initializers</h3>
<p>I've noticed programmers in Java tend to overuse inheritance, possibly
because it's the only reasonable way of extending code in that language.
A much better and more general way to extend code is usually to use
hooks (cf. Apache's module API). Nevertheless in certain narrow areas
inheritance can be useful, and the most important of these is in writing
GUI widget libraries.</p>
<p>Let's consider an imaginary OCaml widget library similar to Java's
Swing. We will define buttons and labels with the following class
hierarchy:</p>
<pre><code>widget  (superclass for all widgets)
  |
  +----&gt; container  (any widget that can contain other widgets)
  |        |
  |        +----&gt; button
  |
  +-------------&gt; label
</code></pre>
<p>(Notice that a <code>button</code> is a <code>container</code> because it can contain either a
label or an image, depending on what is displayed on the button).</p>
<p><code>widget</code> is the virtual superclass for all widgets. I want every widget
to have a name (just a string) which is constant over the life of that
widget. This was my first attempt:</p>
<pre><code class="language-ocaml"># class virtual widget name =
  object (self)
    method get_name =
      name
    method virtual repaint : unit
  end
Lines 1-6, characters 1-6:
Error: Some type variables are unbound in this type:
         class virtual widget :
           'a -&gt;
           object method get_name : 'a method virtual repaint : unit end
       The method get_name has type 'a where 'a is unbound
</code></pre>
<p>Oops! I forgot that OCaml cannot infer the type of <code>name</code> so will assume
that it is <code>'a</code>. But that defines a polymorphic class, and I didn't
declare the class as polymorphic (<code>class ['a] widget</code>). I need to narrow
the type of <code>name</code> like this:</p>
<pre><code class="language-ocaml"># class virtual widget (name : string) =
  object (self)
    method get_name =
      name
    method virtual repaint : unit
  end;;
class virtual widget :
  string -&gt; object method get_name : string method virtual repaint : unit end
</code></pre>
<p>Now there are several new things going on in this code. Firstly the
class contains an <strong>initializer</strong>. This is an argument to the class
(<code>name</code>) which you can think of as exactly the equivalent of an argument
to a constructor in, eg., Java:</p>
<pre><code class="language-java">public class Widget
{
  public Widget (String name)
  {
    ...
  }
}
</code></pre>
<p>In OCaml a constructor constructs the whole class, it's not just a
specially named function, so we write the arguments as if they are
arguments to the class:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">class foo arg1 arg2 ... =
</code></pre>
<p>Secondly the class contains a virtual method, and thus the whole class
is marked as virtual. The virtual method is our <code>repaint</code> method. We
need to tell OCaml it's virtual (<code>method virtual</code>), <em>and</em> we need to
tell OCaml the type of the method. Because the method doesn't contain
any code, OCaml can't use type inference to automatically work out the
type for you, so you need to tell it the type. In this case the method
just returns <code>unit</code>. If your class contains any virtual methods (even
just inherited ones) then you need to specify the whole class as virtual
by using <code>class virtual ...</code>.</p>
<p>As in C++ and Java, virtual classes cannot be directly instantiated
using <code>new</code>:</p>
<pre><code class="language-ocaml"># let w = new widget &quot;my widget&quot;
Line 1, characters 9-19:
Error: Cannot instantiate the virtual class widget
</code></pre>
<p>Now my <code>container</code> class is more interesting. It must inherit from
<code>widget</code> and have the mechanics for storing the list of contained
widgets. Here is my simple implementation for <code>container</code>:</p>
<pre><code class="language-ocaml"># class virtual container name =
  object (self)
    inherit widget name
    val mutable widgets = ([] : widget list)
    method add w =
      widgets &lt;- w :: widgets
    method get_widgets =
      widgets
    method repaint =
      List.iter (fun w -&gt; w#repaint) widgets
  end
class virtual container :
  string -&gt;
  object
    val mutable widgets : widget list
    method add : widget -&gt; unit
    method get_name : string
    method get_widgets : widget list
    method repaint : unit
  end
</code></pre>
<p>Notes:</p>
<ol>
<li>The <code>container</code> class is marked as virtual. It doesn't contain any
virtual methods, but in this case I just want to prevent people
creating containers directly.
</li>
<li>The <code>container</code> class has a <code>name</code> argument which is passed directly
up when constructing the <code>widget</code>.
</li>
<li><code>inherit widget name</code> means that the <code>container</code> inherits from
<code>widget</code>, and it passes the <code>name</code> argument to the constructor for
<code>widget</code>.
</li>
<li>My <code>container</code> contains a mutable list of widgets and methods to
<code>add</code> a widget to this list and <code>get_widgets</code> (return the list of
widgets).
</li>
<li>The list of widgets returned by <code>get_widgets</code> cannot be modified by
code outside the class. The reason for this is somewhat subtle, but
basically comes down to the fact that OCaml's linked lists are
immutable. Let's imagine that someone wrote this code:
</li>
</ol>
<pre><code class="language-ocaml"># let list = container#get_widgets in
  x :: list
</code></pre>
<p>Would this modify the private internal representation of my <code>container</code>
class, by prepending <code>x</code> to the list of widgets? No it wouldn't. The
private variable <code>widgets</code> would be unaffected by this or any other
change attempted by the outside code. This means, for example, that you
could change the internal representation to use an array at some later
date, and no code outside the class would need to be changed.</p>
<p>Last, but not least, we have implemented the previously virtual
<code>repaint</code> function so that <code>container#repaint</code> will repaint all of the
contained widgets. Notice I use <code>List.iter</code> to iterate over the list,
and I also use a probably unfamiliar anonymous function expression:</p>
<pre><code class="language-ocaml"># (fun w -&gt; w#repaint)
- : &lt; repaint : 'a; .. &gt; -&gt; 'a = &lt;fun&gt;
</code></pre>
<p>which defines an anonymous function with one argument <code>w</code> that just
calls <code>w#repaint</code> (the <code>repaint</code> method on widget <code>w</code>).</p>
<p>In this instance our <code>button</code> class is simple (rather unrealistically
simple in fact, but nevermind that):</p>
<pre><code class="language-ocaml"># type button_state = Released | Pressed
type button_state = Released | Pressed
# class button ?callback name =
  object (self)
    inherit container name as super
    val mutable state = Released
    method press =
      state &lt;- Pressed;
      match callback with
      | None -&gt; ()
      | Some f -&gt; f ()
    method release =
      state &lt;- Released
    method repaint =
      super#repaint;
      print_endline (&quot;Button being repainted, state is &quot; ^
                     (match state with
                      | Pressed -&gt; &quot;Pressed&quot;
                      | Released -&gt; &quot;Released&quot;))
  end
class button :
  ?callback:(unit -&gt; unit) -&gt;
  string -&gt;
  object
    val mutable state : button_state
    val mutable widgets : widget list
    method add : widget -&gt; unit
    method get_name : string
    method get_widgets : widget list
    method press : unit
    method release : unit
    method repaint : unit
  end
</code></pre>
<p>Notes:</p>
<ol>
<li>This function has an optional argument (see the previous chapter)
which is used to pass in the optional callback function. The
callback is called when the button is pressed.
</li>
<li>The expression <code>inherit container name as super</code> names the
superclass <code>super</code>. I use this in the <code>repaint</code> method:
<code>super#repaint</code>. This expressly calls the superclass method.
</li>
<li>Pressing the button (calling <code>button#press</code> in this rather
simplistic code) sets the state of the button to <code>Pressed</code> and calls
the callback function, if one was defined. Notice that the
<code>callback</code> variable is either <code>None</code> or <code>Some f</code>, in other words it
has type <code>(unit -&gt; unit) option</code>. Reread the previous chapter if you
are unsure about this.
</li>
<li>Notice a strange thing about the <code>callback</code> variable. It's defined
as an argument to the class, but any method can see and use it. In
other words, the variable is supplied when the object is
constructed, but persists over the lifetime of the object.
</li>
<li>The <code>repaint</code> method has been implemented. It calls the superclass
(to repaint the container), then repaints the button, displaying the
current state of the button.
</li>
</ol>
<p>Before defining our <code>label</code> class, let's play with the <code>button</code> class in
the OCaml toplevel:</p>
<pre><code class="language-ocaml"># let b = new button ~callback:(fun () -&gt; print_endline &quot;Ouch!&quot;) &quot;button&quot;
val b : button = &lt;obj&gt;
# b#repaint
Button being repainted, state is Released
- : unit = ()
# b#press
Ouch!
- : unit = ()
# b#repaint
Button being repainted, state is Pressed
- : unit = ()
# b#release
- : unit = ()
</code></pre>
<p>Here's our comparatively trivial <code>label</code> class:</p>
<pre><code class="language-ocaml"># class label name text =
  object (self)
    inherit widget name
    method repaint =
      print_endline (&quot;Label: &quot; ^ text)
  end
class label :
  string -&gt;
  string -&gt; object method get_name : string method repaint : unit end
</code></pre>
<p>Let's create a label which says &quot;Press me!&quot; and add it to the button:</p>
<pre><code class="language-ocaml"># let l = new label &quot;label&quot; &quot;Press me!&quot;
val l : label = &lt;obj&gt;
# b#add l
- : unit = ()
# b#repaint
Label: Press me!
Button being repainted, state is Released
- : unit = ()
</code></pre>
<h3 id="a-note-about-self">A note about <code>self</code></h3>
<p>In all the examples above we defined classes using the general pattern:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">class name =
  object (self)
    (* ... *)
  end
</code></pre>
<p>I didn't explain the reference to <code>self</code>. In fact this names the object,
allowing you to call methods in the same class or pass the object to
functions outside the class. In other words, it's exactly the same as
<code>this</code> in C++/Java. You may completely omit the
<code>(self)</code> part if you don't need to refer to yourself - indeed in all the
examples above we could have done exactly that. However, I would advise
you to leave it in there because you never know when you might modify
the class and require the reference to <code>self</code>. There is no penalty for
having it.</p>
<h3 id="inheritance-and-coercions">Inheritance and coercions</h3>
<pre><code class="language-ocaml"># let b = new button &quot;button&quot;
val b : button = &lt;obj&gt;
# let l = new label &quot;label&quot; &quot;Press me!&quot;
val l : label = &lt;obj&gt;
# [b; l]
Line 1, characters 5-6:
Error: This expression has type label but an expression was expected of type
         button
       The first object type has no method add
</code></pre>
<p>I created a button <code>b</code> and a label <code>l</code> and I tried to create a list
containing both, but I got an error. Yet <code>b</code> and <code>l</code> are both <code>widget</code>s,
so why can't I put them into the same list? Perhaps OCaml can't guess
that I want a <code>widget list</code>? Let's try telling it:</p>
<pre><code class="language-ocaml"># let wl = ([] : widget list)
val wl : widget list = []
# let wl = b :: wl
Line 1, characters 15-17:
Error: This expression has type widget list
       but an expression was expected of type button list
       Type widget = &lt; get_name : string; repaint : unit &gt;
       is not compatible with type
         button =
           &lt; add : widget -&gt; unit; get_name : string;
             get_widgets : widget list; press : unit; release : unit;
             repaint : unit &gt;
       The first object type has no method add
</code></pre>
<p>It turns out that OCaml doesn't coerce subclasses to the type of the
superclass by default, but you can tell it to by using the <code>:&gt;</code>
(coercion) operator:</p>
<pre><code class="language-ocaml"># let wl = (b :&gt; widget) :: wl
val wl : widget list = [&lt;obj&gt;]
# let wl = (l :&gt; widget) :: wl
val wl : widget list = [&lt;obj&gt;; &lt;obj&gt;]
</code></pre>
<p>The expression <code>(b :&gt; widget)</code> means &quot;coerce the button <code>b</code> to have type
<code>widget</code>&quot;. Type-safety is preserved because it is possible to tell
completely at compile time whether the coercion will succeed.</p>
<p>Actually, coercions are somewhat more subtle than described above, and
so I urge you to read the manual to find out the full details.</p>
<p>The <code>container#add</code> method defined above is actually incorrect, and
fails if you try to add widgets of different types into a <code>container</code>. A
coercion would fix this.</p>
<p>Is it possible to coerce from a superclass (eg. <code>widget</code>) to a subclass
(eg. <code>button</code>)? The answer, perhaps surprisingly, is NO! Coercing in
this direction is <em>unsafe</em>. You might try to coerce a <code>widget</code> which is
in fact a <code>label</code>, not a <code>button</code>.</p>
<h3 id="the-oo-module-and-comparing-objects">The <code>Oo</code> module and comparing objects</h3>
<p>The <code>Oo</code> module contains a few useful functions for OO programming.</p>
<p><code>Oo.copy</code> makes a shallow copy of an object. <code>Oo.id object</code> returns a
unique identifying number for each object (a unique number across all
classes).</p>
<p><code>=</code> and <code>&lt;&gt;</code> can be used to compare objects for <em>physical</em> equality (an
object and its copy are not physically identical). You can also use <code>&lt;</code>
etc. which provides an ordering of objects based apparently on their
IDs.</p>
<h2 id="objects-without-class">Objects without class</h2>
<p>Here we examine how to use objects pretty much like records, without
necessarily using classes.</p>
<h3 id="immediate-objects-and-object-types">Immediate objects and object types</h3>
<p>Objects can be used instead of records, and have some nice properties
that can make them preferable to records in some cases. We saw that the
canonical way of creating objects is to first define a class, and use
this class to create individual objects. This can be cumbersome in some
situations since class definitions are more than a type definition and
cannot be defined recursively with types. However, objects have a type
that is very analog to a record type, and it can be used in type
definitions. In addition, objects can be created without a class. They
are called <em>immediate objects</em>. Here is the definition of an immediate
object:</p>
<pre><code class="language-ocaml"># let o =
  object
    val mutable n = 0
    method incr = n &lt;- n + 1
    method get = n
  end
val o : &lt; get : int; incr : unit &gt; = &lt;obj&gt;
</code></pre>
<p>This object has a type, which is defined by its public methods only.
Values are not visible and neither are private methods (not shown).
Unlike records, such a type does not need to be predefined explicitly,
but doing so can make things clearer. We can do it like this:</p>
<pre><code class="language-ocaml"># type counter = &lt;get : int; incr : unit&gt;
type counter = &lt; get : int; incr : unit &gt;
</code></pre>
<p>Compare with an equivalent record type definition:</p>
<pre><code class="language-ocaml"># type counter_r =
  {get : unit -&gt; int;
   incr : unit -&gt; unit}
type counter_r = { get : unit -&gt; int; incr : unit -&gt; unit; }
</code></pre>
<p>The implementation of a record working like our object would be:</p>
<pre><code class="language-ocaml"># let r =
  let n = ref 0 in
    {get = (fun () -&gt; !n);
     incr = (fun () -&gt; incr n)}
val r : counter_r = {get = &lt;fun&gt;; incr = &lt;fun&gt;}
</code></pre>
<p>In terms of functionality, both the object and the record are similar,
but each solution has its own advantages:</p>
<ul>
<li><strong>speed</strong>: slightly faster field access in records
</li>
<li><strong>field names</strong>: it is inconvenient to manipulate records of
different types when some fields are named identically but it's not
a problem with objects
</li>
<li><strong>subtyping</strong>: it is impossible to coerce the type of a record to a
type with less fields. That is however possible with objects, so
objects of different kinds that share some methods can be mixed in a
data structure where only their common methods are visible (see next
section)
</li>
<li><strong>type definitions</strong>: there is no need to define an object type in
advance, so it lightens the dependency constraints between modules
</li>
</ul>
<h3 id="class-types-vs-just-types">Class types vs. just types</h3>
<p>Beware of the confusion between <em>class types</em> and object <em>types</em>. A
<em>class type</em> is not a data <em>type</em>, normally referred to as <em>type</em> in the
OCaml jargon. An object <em>type</em> is a kind of data <em>type</em>, just like a
record type or a tuple.</p>
<p>When a class is defined, both a <em>class type</em> and an object <em>type</em> of the
same name are defined:</p>
<pre><code class="language-ocaml"># class t =
  object
    val x = 0
    method get = x
  end
class t : object val x : int method get : int end
</code></pre>
<p><code>object val x : int method get : int end</code> is a class type.</p>
<p>In this example, <code>t</code> is also the type of objects that this class would
create. Objects that derive from different classes or no class at all
(immediate objects) can be mixed together as long as they have the same
type:</p>
<pre><code class="language-ocaml"># let x = object method get = 123 end
val x : &lt; get : int &gt; = &lt;obj&gt;
# let l = [new t; x]
val l : t list = [&lt;obj&gt;; &lt;obj&gt;]
</code></pre>
<p>Mixing objects that share a common subtype can be done, but requires
explicit type coercion using the <code>:&gt;</code> operator:</p>
<pre><code class="language-ocaml"># let x = object method get = 123 end
val x : &lt; get : int &gt; = &lt;obj&gt;
# let y = object method get = 80 method special = &quot;hello&quot; end
val y : &lt; get : int; special : string &gt; = &lt;obj&gt;
# let l = [x; y]
Line 1, characters 13-14:
Error: This expression has type &lt; get : int; special : string &gt;
       but an expression was expected of type &lt; get : int &gt;
       The second object type has no method special
# let l = [x; (y :&gt; t)]
val l : t list = [&lt;obj&gt;; &lt;obj&gt;]
</code></pre>
|js}
  };
 
  { title = {js|Error Handling|js}
  ; slug = {js|error-handling|js}
  ; description = {js|Discover the different ways you can manage errors in your OCaml programs
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["errors"]
  ; users = [`Beginner; `Intermediate]
  ; body_md = {js|
## Exceptions

One way of handling errors in OCaml is exceptions. The
standard library relies heavily upon them.

Exceptions belong to the type `exn` (an extensible sum type):

```ocaml
exception Foo of string

let i_will_fail () =
  raise (Foo "Oh no!")
```

Here, we add a variant `Foo` to the type `exn`, and create a function
that will raise this exception. Now, how do we handle exceptions?
The construct is `try ... with ...`:

```ocaml
let safe_inverse n =
  try Some (1 / n) with
    Division_by_zero -> None

let safe_list_find p l =
  try Some (List.find p l) with
    Not_found -> None
```

We can try those functions:

```ocaml
# 1 / 0;;
Exception: Division_by_zero.
# safe_inverse 2;;
- : int option = Some 0
# safe_inverse 0;;
- : int option = None
# List.find (fun x -> x mod 2 = 0) [1; 3; 5]
Exception: Not_found.
# safe_list_find (fun x -> x mod 2 = 0) [1; 3; 4; 5]
- : int option = Some 4
# safe_list_find (fun x -> x mod 2 = 0) [1; 3; 5]
- : int option = None
```

The biggest issue with exceptions is that they do not appear in types.
One has to read the documentation to see that, indeed, `Map.S.find`
or `List.hd` are not total functions, and that they might fail.

It is considered good practice nowadays, when a function can fail in
cases that are not bugs (i.e., not `assert false`, but network failures,
keys not present, etc.)
to return a more explicit type such as `'a option` or `('a, 'b) result`.
A relatively common idiom is to have such a safe version of the function,
say, `val foo : a -> b option`, and an exception raising
version `val foo_exn : a -> b`.

### Documentation

Functions that can raise exceptions should be documented like this:

<!-- $MDX skip -->
```ocaml
val foo : a -> b
(** foo does this and that, here is how it works, etc.
    @raise Invalid_argument if [a] doesn't satisfy ...
    @raise Sys_error if filesystem is not happy *)
```

### Stacktraces

To get a stacktrace when a unhandled exception makes your program crash, you
need to compile the program in "debug" mode (with `-g` when calling
`ocamlc`, or `-tag 'debug'` when calling `ocamlbuild`).
Then:

```
OCAMLRUNPARAM=b ./myprogram [args]
```

And you will get a stacktrace. Alternatively, you can call, from within the program,

```ocaml
let () = Printexc.record_backtrace true
```

### Printing

To print an exception, the module `Printexc` comes in handy. For instance,
the following function `notify_user : (unit -> 'a) -> 'a` can be used
to call a function and, if it fails, print the exception on `stderr`.
If stacktraces are enabled, this function will also display it.

```ocaml
let notify_user f =
  try f () with e ->
    let msg = Printexc.to_string e
    and stack = Printexc.get_backtrace () in
      Printf.eprintf "there was an error: %s%s\\n" msg stack;
      raise e
```

OCaml knows how to print its built-in exception, but you can also tell it
how to print your own exceptions:

```ocaml
exception Foo of int

let () =
  Printexc.register_printer
    (function
      | Foo i -> Some (Printf.sprintf "Foo(%d)" i)
      | _ -> None (* for other exceptions *)
    )
```

Each printer should take care of the exceptions it knows about, returning
`Some <printed exception>`, and return `None` otherwise (let the other printers
do the job!).

## Result type

The Stdlib module contains the following type:

```ocaml
type ('a, 'b) result =
  | Ok of 'a
  | Error of 'b
```

A value `Ok x` means that the computation succeeded with `x`, and
a value `Error e` means that it failed.
Pattern matching can be used to deal with both cases, as with any
other sum type. The advantage here is that a function `a -> b` that
fails can be modified so its type is `a -> (b, error) result`,
which makes the failure explicit.
The error case `e` in `Error e` can be of any type
(the `'b` type variable), but a few possible choices
are:

- `exn`, in which case the result type just makes exceptions explicit.
- `string`, where the error case is a message that indicates what failed.
- `string lazy_t`, a more elaborate form of error message that is only evaluated
  if printing is required.
- some polymorphic variant, with one case per
  possible error. This is very accurate (each error can be dealt with
  explicitly and occurs in the type) but the use of polymorphic variants
  sometimes make error messages hard to read.

For easy combination of functions that can fail, many alternative standard
libraries provide useful combinators on the `result` type: `map`, `>>=`, etc.
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#exceptions">Exceptions</a>
</li>
<li><a href="#result-type">Result type</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<h2 id="exceptions">Exceptions</h2>
<p>One way of handling errors in OCaml is exceptions. The
standard library relies heavily upon them.</p>
<p>Exceptions belong to the type <code>exn</code> (an extensible sum type):</p>
<pre><code class="language-ocaml">exception Foo of string

let i_will_fail () =
  raise (Foo &quot;Oh no!&quot;)
</code></pre>
<p>Here, we add a variant <code>Foo</code> to the type <code>exn</code>, and create a function
that will raise this exception. Now, how do we handle exceptions?
The construct is <code>try ... with ...</code>:</p>
<pre><code class="language-ocaml">let safe_inverse n =
  try Some (1 / n) with
    Division_by_zero -&gt; None

let safe_list_find p l =
  try Some (List.find p l) with
    Not_found -&gt; None
</code></pre>
<p>We can try those functions:</p>
<pre><code class="language-ocaml"># 1 / 0;;
Exception: Division_by_zero.
# safe_inverse 2;;
- : int option = Some 0
# safe_inverse 0;;
- : int option = None
# List.find (fun x -&gt; x mod 2 = 0) [1; 3; 5]
Exception: Not_found.
# safe_list_find (fun x -&gt; x mod 2 = 0) [1; 3; 4; 5]
- : int option = Some 4
# safe_list_find (fun x -&gt; x mod 2 = 0) [1; 3; 5]
- : int option = None
</code></pre>
<p>The biggest issue with exceptions is that they do not appear in types.
One has to read the documentation to see that, indeed, <code>Map.S.find</code>
or <code>List.hd</code> are not total functions, and that they might fail.</p>
<p>It is considered good practice nowadays, when a function can fail in
cases that are not bugs (i.e., not <code>assert false</code>, but network failures,
keys not present, etc.)
to return a more explicit type such as <code>'a option</code> or <code>('a, 'b) result</code>.
A relatively common idiom is to have such a safe version of the function,
say, <code>val foo : a -&gt; b option</code>, and an exception raising
version <code>val foo_exn : a -&gt; b</code>.</p>
<h3 id="documentation">Documentation</h3>
<p>Functions that can raise exceptions should be documented like this:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">val foo : a -&gt; b
(** foo does this and that, here is how it works, etc.
    @raise Invalid_argument if [a] doesn't satisfy ...
    @raise Sys_error if filesystem is not happy *)
</code></pre>
<h3 id="stacktraces">Stacktraces</h3>
<p>To get a stacktrace when a unhandled exception makes your program crash, you
need to compile the program in &quot;debug&quot; mode (with <code>-g</code> when calling
<code>ocamlc</code>, or <code>-tag 'debug'</code> when calling <code>ocamlbuild</code>).
Then:</p>
<pre><code>OCAMLRUNPARAM=b ./myprogram [args]
</code></pre>
<p>And you will get a stacktrace. Alternatively, you can call, from within the program,</p>
<pre><code class="language-ocaml">let () = Printexc.record_backtrace true
</code></pre>
<h3 id="printing">Printing</h3>
<p>To print an exception, the module <code>Printexc</code> comes in handy. For instance,
the following function <code>notify_user : (unit -&gt; 'a) -&gt; 'a</code> can be used
to call a function and, if it fails, print the exception on <code>stderr</code>.
If stacktraces are enabled, this function will also display it.</p>
<pre><code class="language-ocaml">let notify_user f =
  try f () with e -&gt;
    let msg = Printexc.to_string e
    and stack = Printexc.get_backtrace () in
      Printf.eprintf &quot;there was an error: %s%s\\n&quot; msg stack;
      raise e
</code></pre>
<p>OCaml knows how to print its built-in exception, but you can also tell it
how to print your own exceptions:</p>
<pre><code class="language-ocaml">exception Foo of int

let () =
  Printexc.register_printer
    (function
      | Foo i -&gt; Some (Printf.sprintf &quot;Foo(%d)&quot; i)
      | _ -&gt; None (* for other exceptions *)
    )
</code></pre>
<p>Each printer should take care of the exceptions it knows about, returning
<code>Some &lt;printed exception&gt;</code>, and return <code>None</code> otherwise (let the other printers
do the job!).</p>
<h2 id="result-type">Result type</h2>
<p>The Stdlib module contains the following type:</p>
<pre><code class="language-ocaml">type ('a, 'b) result =
  | Ok of 'a
  | Error of 'b
</code></pre>
<p>A value <code>Ok x</code> means that the computation succeeded with <code>x</code>, and
a value <code>Error e</code> means that it failed.
Pattern matching can be used to deal with both cases, as with any
other sum type. The advantage here is that a function <code>a -&gt; b</code> that
fails can be modified so its type is <code>a -&gt; (b, error) result</code>,
which makes the failure explicit.
The error case <code>e</code> in <code>Error e</code> can be of any type
(the <code>'b</code> type variable), but a few possible choices
are:</p>
<ul>
<li><code>exn</code>, in which case the result type just makes exceptions explicit.
</li>
<li><code>string</code>, where the error case is a message that indicates what failed.
</li>
<li><code>string lazy_t</code>, a more elaborate form of error message that is only evaluated
if printing is required.
</li>
<li>some polymorphic variant, with one case per
possible error. This is very accurate (each error can be dealt with
explicitly and occurs in the type) but the use of polymorphic variants
sometimes make error messages hard to read.
</li>
</ul>
<p>For easy combination of functions that can fail, many alternative standard
libraries provide useful combinators on the <code>result</code> type: <code>map</code>, <code>&gt;&gt;=</code>, etc.</p>
|js}
  };
 
  { title = {js|Common Error Messages|js}
  ; slug = {js|common-error-messages|js}
  ; description = {js|Understand the most common error messages the OCaml compiler can throw at you
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["errors"; "debugging"]
  ; users = [`Beginner]
  ; body_md = {js|
This page gives a list of quick explanations for some error or warning
messages that are emitted by the OCaml compilers. Longer explanations
are usually given in dedicated sections of this tutorial.

## Type errors
###  This expression has type ... but is here used with type ...
When the type of an object is not compatible with the context in which
it is used, it is frequent to obtain this kind of message:

```ocaml
# 1 + 2.5
Line 1, characters 5-8:
Error: This expression has type float but an expression was expected of type
         int
```
"This expression has type *X* but is here used with type *Y*" means that
if the contents of the expression is isolated (2.5), its type is
inferred as *X* (float). But the context, i.e. everything which is
around (1 + ...) tells that the gap expects an expression of type *Y*
(int) which is not compatible with *X*.

More disturbing is the following message:

```text
This expression has type my_type but is here used with type my_type
```
This error happens often while testing some type definitions using the
interactive toplevel.  In OCaml, it is perfectly legal
to define a type with a name
that is already taken by another type. Consider the following session:

```ocaml
# type my_type = A | B
type my_type = A | B
# let a = A
val a : my_type = A
# type my_type = A | B
type my_type = A | B
# let b = B
val b : my_type = B
# a = b
Line 1, characters 5-6:
Error: This expression has type my_type/1
       but an expression was expected of type my_type/2
       Hint: The type my_type has been defined multiple times in this
         toplevel session. Some toplevel values still refer to old versions
         of this type. Did you try to redefine them?
```
For the compiler, the second definition of my_type is totally
independent from the first definition. So we have defined two types
which have the same name. Since "a" was defined earlier, it belongs to
the first type while "b" belongs to the second type. In this example,
redefining "a" after the last definition of my_type solves the problem.
This kind of problem should not happen in real programs unless you use
the same name for the same type in the same module, which is highly
discouraged.

###  Warning: This optional argument cannot be erased
Functions with optional arguments must have at least one non-labelled
argument. For instance, this is not OK:

```ocaml
# let f ?(x = 0) ?(y = 0) = print_int (x + y)
Line 1, characters 18-23:
Warning 16: this optional argument cannot be erased.
val f : ?x:int -> ?y:int -> unit = <fun>
```
The solution is simply to add one argument of type unit, like this:

```ocaml
# let f ?(x = 0) ?(y = 0) () = print_int (x + y)
val f : ?x:int -> ?y:int -> unit -> unit = <fun>
```
See the [Labels](labels.html "Labels") section for more details on
functions with labelled arguments.

###  The type of this expression... contains type variables that cannot be generalized
This happens in some cases when the full type of an object is not known
by the compiler when it reaches the end of the compilation unit (file)
but for some reason it cannot remain polymorphic. Example:

```ocaml env=ref
# let x = ref None
val x : '_weak1 option ref = {contents = None}
```
triggers the following message during the compilation:

```text
The type of this expression, '_a option ref,
contains type variables that cannot be generalized
```

Solution: help the compiler with a type annotation, like for instance:

```ocaml env=ref
# let x : string option ref = ref None
val x : string option ref = {contents = None}
```
or:

```ocaml env=ref
# let x = ref (None : string option)
val x : string option ref = {contents = None}
```

Data of type `'_weak<n>` may be allowed temporarily, for instance during a
toplevel session. It means that the given object has an unknown type,
but it cannot be any type: it is not polymorphic data. In the toplevel,
our example gives these results:

```ocaml env=ref
# let x = ref None
val x : '_weak2 option ref = {contents = None}
```

The compiler tells us that the type of x is not fully known yet. But by
using `x` later, the compiler can infer the type of `x`:

```ocaml env=ref
# x := Some 0
- : unit = ()
```
Now `x` has a known type:

```ocaml env=ref
# x
- : int option ref = {contents = Some 0}
```

## Pattern matching warnings and errors
###  This pattern is unused
This warning should be considered as an error, since there is no reason
to intentionally keep such code. It may happen when the programmer
introduced a catch-all pattern unintentionally such as in the following
situation:

```ocaml
# let test_member x tup =
  match tup with
  | (y, _) | (_, y) when y = x -> true
  | _ -> false
Line 3, characters 14-20:
Warning 12: this sub-pattern is unused.
Line 3, characters 5-20:
Warning 57: Ambiguous or-pattern variables under guard;
variable y may match different arguments. (See manual section 9.5)
val test_member : 'a -> 'a * 'a -> bool = <fun>
```
Obviously, the programmer had a misconception of what OCaml's pattern
matching is about. Remember the following:

* the tree of cases is traversed linearly, from left to right. There
 is *no backtracking* as in regexp matching.
* a guard ("when" clause) is not part of a pattern. It is simply a
 condition which is evaluated at most once and is used as a last
 resort to jump to the next match case.
* lowercase identifiers (bindings such as "y" above) are just names,
 so they will always match.

In our example, it is now clear that only the first item of the pair
will ever be tested. This leads to the following results:

```ocaml
# test_member 1 (1, 0)
- : bool = true
# test_member 1 (0, 1)
- : bool = false
```
###  This pattern-matching is not exhaustive
OCaml's pattern matching can check whether a set of patterns is
exhaustive or not, based on the *type* only. So in the following
example, the compiler doesn't know what range of ints the "mod" operator
would return:

```ocamltop
let is_even x =
  match x mod 2 with
  | 0 -> true
  | 1 | -1 -> false
```
A short solution without pattern matching would be:

```ocaml
# let is_even x = x mod 2 = 0
val is_even : int -> bool = <fun>
```
In general, that kind of simplification is not possible and the best
solution is to add a catch-all case which should never be reached:

```ocaml
# let is_even x =
  match x mod 2 with
  | 0 -> true
  | 1 | -1 -> false
  | _ -> assert false
val is_even : int -> bool = <fun>
```

## Problems recompiling valid programs
###  x.cmi is not a compiled interface
When recompiling some old program or compiling a program from an
external source that was not cleaned properly, it is possible to get
this error message:

```text
some_module.cmi is not a compiled interface
```

It means that some_module.cmi is not valid according to the *current
version* of the OCaml compiler. Most of the time, removing the old
compiled files (*.cmi, *.cmo, *.cmx, ...) and recompiling is
sufficient to solve this problem.
	
###  Warning: Illegal backslash escape in string
Recent versions of OCaml warn you against unprotected backslashes in
strings since they should be doubled. Such a message may be displayed
when compiling an older program, and can be turned off with the `-w x`
option.

```ocaml
# "\\e\\n" (* bad practice *)
File "_none_", line 1, characters 1-3:
Warning 14: illegal backslash escape in string.
- : string = "\\\\e\\n"
# "\\\\e\\n" (* good practice *)
- : string = "\\\\e\\n"
```
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#type-errors">Type errors</a>
</li>
<li><a href="#pattern-matching-warnings-and-errors">Pattern matching warnings and errors</a>
</li>
<li><a href="#problems-recompiling-valid-programs">Problems recompiling valid programs</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<p>This page gives a list of quick explanations for some error or warning
messages that are emitted by the OCaml compilers. Longer explanations
are usually given in dedicated sections of this tutorial.</p>
<h2 id="type-errors">Type errors</h2>
<h3 id="this-expression-has-type--but-is-here-used-with-type-">This expression has type ... but is here used with type ...</h3>
<p>When the type of an object is not compatible with the context in which
it is used, it is frequent to obtain this kind of message:</p>
<pre><code class="language-ocaml"># 1 + 2.5
Line 1, characters 5-8:
Error: This expression has type float but an expression was expected of type
         int
</code></pre>
<p>&quot;This expression has type <em>X</em> but is here used with type <em>Y</em>&quot; means that
if the contents of the expression is isolated (2.5), its type is
inferred as <em>X</em> (float). But the context, i.e. everything which is
around (1 + ...) tells that the gap expects an expression of type <em>Y</em>
(int) which is not compatible with <em>X</em>.</p>
<p>More disturbing is the following message:</p>
<pre><code class="language-text">This expression has type my_type but is here used with type my_type
</code></pre>
<p>This error happens often while testing some type definitions using the
interactive toplevel.  In OCaml, it is perfectly legal
to define a type with a name
that is already taken by another type. Consider the following session:</p>
<pre><code class="language-ocaml"># type my_type = A | B
type my_type = A | B
# let a = A
val a : my_type = A
# type my_type = A | B
type my_type = A | B
# let b = B
val b : my_type = B
# a = b
Line 1, characters 5-6:
Error: This expression has type my_type/1
       but an expression was expected of type my_type/2
       Hint: The type my_type has been defined multiple times in this
         toplevel session. Some toplevel values still refer to old versions
         of this type. Did you try to redefine them?
</code></pre>
<p>For the compiler, the second definition of my_type is totally
independent from the first definition. So we have defined two types
which have the same name. Since &quot;a&quot; was defined earlier, it belongs to
the first type while &quot;b&quot; belongs to the second type. In this example,
redefining &quot;a&quot; after the last definition of my_type solves the problem.
This kind of problem should not happen in real programs unless you use
the same name for the same type in the same module, which is highly
discouraged.</p>
<h3 id="warning-this-optional-argument-cannot-be-erased">Warning: This optional argument cannot be erased</h3>
<p>Functions with optional arguments must have at least one non-labelled
argument. For instance, this is not OK:</p>
<pre><code class="language-ocaml"># let f ?(x = 0) ?(y = 0) = print_int (x + y)
Line 1, characters 18-23:
Warning 16: this optional argument cannot be erased.
val f : ?x:int -&gt; ?y:int -&gt; unit = &lt;fun&gt;
</code></pre>
<p>The solution is simply to add one argument of type unit, like this:</p>
<pre><code class="language-ocaml"># let f ?(x = 0) ?(y = 0) () = print_int (x + y)
val f : ?x:int -&gt; ?y:int -&gt; unit -&gt; unit = &lt;fun&gt;
</code></pre>
<p>See the <a href="labels.html" title="Labels">Labels</a> section for more details on
functions with labelled arguments.</p>
<h3 id="the-type-of-this-expression-contains-type-variables-that-cannot-be-generalized">The type of this expression... contains type variables that cannot be generalized</h3>
<p>This happens in some cases when the full type of an object is not known
by the compiler when it reaches the end of the compilation unit (file)
but for some reason it cannot remain polymorphic. Example:</p>
<pre><code class="language-ocaml"># let x = ref None
val x : '_weak1 option ref = {contents = None}
</code></pre>
<p>triggers the following message during the compilation:</p>
<pre><code class="language-text">The type of this expression, '_a option ref,
contains type variables that cannot be generalized
</code></pre>
<p>Solution: help the compiler with a type annotation, like for instance:</p>
<pre><code class="language-ocaml"># let x : string option ref = ref None
val x : string option ref = {contents = None}
</code></pre>
<p>or:</p>
<pre><code class="language-ocaml"># let x = ref (None : string option)
val x : string option ref = {contents = None}
</code></pre>
<p>Data of type <code>'_weak&lt;n&gt;</code> may be allowed temporarily, for instance during a
toplevel session. It means that the given object has an unknown type,
but it cannot be any type: it is not polymorphic data. In the toplevel,
our example gives these results:</p>
<pre><code class="language-ocaml"># let x = ref None
val x : '_weak2 option ref = {contents = None}
</code></pre>
<p>The compiler tells us that the type of x is not fully known yet. But by
using <code>x</code> later, the compiler can infer the type of <code>x</code>:</p>
<pre><code class="language-ocaml"># x := Some 0
- : unit = ()
</code></pre>
<p>Now <code>x</code> has a known type:</p>
<pre><code class="language-ocaml"># x
- : int option ref = {contents = Some 0}
</code></pre>
<h2 id="pattern-matching-warnings-and-errors">Pattern matching warnings and errors</h2>
<h3 id="this-pattern-is-unused">This pattern is unused</h3>
<p>This warning should be considered as an error, since there is no reason
to intentionally keep such code. It may happen when the programmer
introduced a catch-all pattern unintentionally such as in the following
situation:</p>
<pre><code class="language-ocaml"># let test_member x tup =
  match tup with
  | (y, _) | (_, y) when y = x -&gt; true
  | _ -&gt; false
Line 3, characters 14-20:
Warning 12: this sub-pattern is unused.
Line 3, characters 5-20:
Warning 57: Ambiguous or-pattern variables under guard;
variable y may match different arguments. (See manual section 9.5)
val test_member : 'a -&gt; 'a * 'a -&gt; bool = &lt;fun&gt;
</code></pre>
<p>Obviously, the programmer had a misconception of what OCaml's pattern
matching is about. Remember the following:</p>
<ul>
<li>the tree of cases is traversed linearly, from left to right. There
is <em>no backtracking</em> as in regexp matching.
</li>
<li>a guard (&quot;when&quot; clause) is not part of a pattern. It is simply a
condition which is evaluated at most once and is used as a last
resort to jump to the next match case.
</li>
<li>lowercase identifiers (bindings such as &quot;y&quot; above) are just names,
so they will always match.
</li>
</ul>
<p>In our example, it is now clear that only the first item of the pair
will ever be tested. This leads to the following results:</p>
<pre><code class="language-ocaml"># test_member 1 (1, 0)
- : bool = true
# test_member 1 (0, 1)
- : bool = false
</code></pre>
<h3 id="this-pattern-matching-is-not-exhaustive">This pattern-matching is not exhaustive</h3>
<p>OCaml's pattern matching can check whether a set of patterns is
exhaustive or not, based on the <em>type</em> only. So in the following
example, the compiler doesn't know what range of ints the &quot;mod&quot; operator
would return:</p>
<pre><code class="language-ocamltop">let is_even x =
  match x mod 2 with
  | 0 -&gt; true
  | 1 | -1 -&gt; false
</code></pre>
<p>A short solution without pattern matching would be:</p>
<pre><code class="language-ocaml"># let is_even x = x mod 2 = 0
val is_even : int -&gt; bool = &lt;fun&gt;
</code></pre>
<p>In general, that kind of simplification is not possible and the best
solution is to add a catch-all case which should never be reached:</p>
<pre><code class="language-ocaml"># let is_even x =
  match x mod 2 with
  | 0 -&gt; true
  | 1 | -1 -&gt; false
  | _ -&gt; assert false
val is_even : int -&gt; bool = &lt;fun&gt;
</code></pre>
<h2 id="problems-recompiling-valid-programs">Problems recompiling valid programs</h2>
<h3 id="xcmi-is-not-a-compiled-interface">x.cmi is not a compiled interface</h3>
<p>When recompiling some old program or compiling a program from an
external source that was not cleaned properly, it is possible to get
this error message:</p>
<pre><code class="language-text">some_module.cmi is not a compiled interface
</code></pre>
<p>It means that some_module.cmi is not valid according to the <em>current
version</em> of the OCaml compiler. Most of the time, removing the old
compiled files (*.cmi, *.cmo, *.cmx, ...) and recompiling is
sufficient to solve this problem.</p>
<h3 id="warning-illegal-backslash-escape-in-string">Warning: Illegal backslash escape in string</h3>
<p>Recent versions of OCaml warn you against unprotected backslashes in
strings since they should be doubled. Such a message may be displayed
when compiling an older program, and can be turned off with the <code>-w x</code>
option.</p>
<pre><code class="language-ocaml"># &quot;\\e\\n&quot; (* bad practice *)
File &quot;_none_&quot;, line 1, characters 1-3:
Warning 14: illegal backslash escape in string.
- : string = &quot;\\\\e\\n&quot;
# &quot;\\\\e\\n&quot; (* good practice *)
- : string = &quot;\\\\e\\n&quot;
</code></pre>
|js}
  };
 
  { title = {js|Debug|js}
  ; slug = {js|debug|js}
  ; description = {js|Learn to build custom types and write function to process this data
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["debugging"]
  ; users = [`Beginner; `Intermediate]
  ; body_md = {js|
This tutorial presents two techniques for debugging OCaml programs:

* [Tracing functions calls](#Tracingfunctionscallsinthetoplevel),
  which works in the interactive toplevel.
* The [OCaml debugger](#The-OCaml-debugger), which allows analysing programs
  compiled with `ocamlc`.

## Tracing functions calls in the toplevel

The simplest way to debug programs in the toplevel is to follow the function
calls, by “tracing” the faulty function:

```ocaml
# let rec fib x = if x <= 1 then 1 else fib (x - 1) + fib (x - 2)
val fib : int -> int = <fun>
# #trace fib
fib is now traced.
# fib 3
fib <-- 3
fib <-- 1
fib --> 1
fib <-- 2
fib <-- 0
fib --> 1
fib <-- 1
fib --> 1
fib --> 2
fib --> 3
- : int = 3
# #untrace fib
fib is no longer traced.
```

###  Polymorphic functions

A difficulty with polymorphic functions is that the output of the trace system
is not very informative in case of polymorphic arguments and/or results.
Consider a sorting algorithm (say bubble sort):

```ocaml
# let exchange i j v =
  let aux = v.(i) in
    v.(i) <- v.(j);
    v.(j) <- aux
val exchange : int -> int -> 'a array -> unit = <fun>
# let one_pass_vect fin v =
  for j = 1 to fin do
    if v.(j - 1) > v.(j) then exchange (j - 1) j v
  done
val one_pass_vect : int -> 'a array -> unit = <fun>
# let bubble_sort_vect v =
  for i = Array.length v - 1 downto 0 do
    one_pass_vect i v
  done
val bubble_sort_vect : 'a array -> unit = <fun>
# let q = [|18; 3; 1|]
val q : int array = [|18; 3; 1|]
# #trace one_pass_vect
one_pass_vect is now traced.
# bubble_sort_vect q
one_pass_vect <-- 2
one_pass_vect --> <fun>
one_pass_vect* <-- [|<poly>; <poly>; <poly>|]
one_pass_vect* --> ()
one_pass_vect <-- 1
one_pass_vect --> <fun>
one_pass_vect* <-- [|<poly>; <poly>; <poly>|]
one_pass_vect* --> ()
one_pass_vect <-- 0
one_pass_vect --> <fun>
one_pass_vect* <-- [|<poly>; <poly>; <poly>|]
one_pass_vect* --> ()
- : unit = ()
```

The function `one_pass_vect` being polymorphic, its vector argument is printed
as a vector containing polymorphic values, `[|<poly>; <poly>; <poly>|]`, and
thus we cannot properly follow the computation.

A simple way to overcome this problem is to define a monomorphic version of the
faulty function. This is fairly easy using a *type constraint*.  Generally
speaking, this allows a proper understanding of the error in the definition of
the polymorphic function. Once this has been corrected, you just have to
suppress the type constraint to revert to a polymorphic version of the
function.

For our sorting routine, a single type constraint on the argument of the
`exchange` function warranties a monomorphic typing, that allows a proper trace
of function calls:

```ocaml
# let exchange i j (v : int array) =    (* notice the type constraint *)
  let aux = v.(i) in
    v.(i) <- v.(j);
    v.(j) <- aux
val exchange : int -> int -> int array -> unit = <fun>
# let one_pass_vect fin v =
  for j = 1 to fin do
    if v.(j - 1) > v.(j) then exchange (j - 1) j v
  done
val one_pass_vect : int -> int array -> unit = <fun>
# let bubble_sort_vect v =
  for i = Array.length v - 1 downto 0 do
    one_pass_vect i v
  done
val bubble_sort_vect : int array -> unit = <fun>
# let q = [| 18; 3; 1 |]
val q : int array = [|18; 3; 1|]
# #trace one_pass_vect
one_pass_vect is now traced.
# bubble_sort_vect q
one_pass_vect <-- 2
one_pass_vect --> <fun>
one_pass_vect* <-- [|18; 3; 1|]
one_pass_vect* --> ()
one_pass_vect <-- 1
one_pass_vect --> <fun>
one_pass_vect* <-- [|3; 1; 18|]
one_pass_vect* --> ()
one_pass_vect <-- 0
one_pass_vect --> <fun>
one_pass_vect* <-- [|1; 3; 18|]
one_pass_vect* --> ()
- : unit = ()
```

###  Limitations

To keep track of assignments to data structures and mutable variables in a
program, the trace facility is not powerful enough. You need an extra mechanism
to stop the program in any place and ask for internal values: that is a
symbolic debugger with its stepping feature.

Stepping a functional program has a meaning which is a bit weird to define and
understand. Let me say that we use the notion of *runtime events* that happen
for instance when a parameter is passed to a function or when entering a
pattern matching, or selecting a clause in a pttern matching. Computation
progress is taken into account by these events, independently of the
instructions executed on the hardware.

Although this is difficult to implement, there exists such a debugger for OCaml
under Unix: `ocamldebug`. Its use is illustrated in the next section.

In fact, for complex programs, it is likely the case that the programmer will
use explicit printing to find the bugs, since this methodology allows the
reduction of the trace material: only useful data are printed and special
purpose formats are more suited to get the relevant information, than what can
be output automatically by the generic pretty-printer used by the trace
mechanism.

## The OCaml debugger

We now give a quick tutorial for the OCaml debugger (`ocamldebug`).  Before
starting, please note that `ocamldebug` does not work under native Windows
ports of OCaml (but it runs under the Cygwin port).

###  Launching the debugger

Consider the following obviously wrong program written in the file
`uncaught.ml`:

```ocaml
(* file uncaught.ml *)
let l = ref []
let find_address name = List.assoc name !l
let add_address name address = l := (name, address) :: ! l

let () =
  add_address "IRIA" "Rocquencourt";;
  print_string (find_address "INRIA"); print_newline ();;
```
```mdx-error
val l : (string * string) list ref = {contents = [("IRIA", "Rocquencourt")]}
val find_address : string -> string = <fun>
val add_address : string -> string -> unit = <fun>
Exception: Not_found.
```

At runtime, the program raises an uncaught exception `Not_found`.  Suppose we
want to find where and why this exception has been raised, we can proceed as
follows. First, we compile the program in debug mode:

```
ocamlc -g uncaught.ml
```

We launch the debugger:

```
ocamldebug a.out
```

Then the debugger answers with a banner and a prompt:

```
OCaml Debugger version 4.12.0

(ocd)
```

###  Finding the cause of a spurious exception

Type `r` (for *run*); you get

```
(ocd) r
Loading program... done.
Time : 12
Program end.
Uncaught exception: Not_found
(ocd)
```

Self explanatory, isn't it? So, you want to step backward to set the program
counter before the time the exception is raised; hence type in `b` as
*backstep*, and you get

```
(ocd) b
Time : 11 - pc : 15500 - module List
143     [] -> <|b|>raise Not_found
```

The debugger tells you that you are in module `List`, inside a pattern matching
on a list that already chose the `[]` case and is about to execute `raise
Not_found`, since the program is stopped just before this expression (as
witnessed by the `<|b|>` mark).

But, as you know, you want the debugger to tell you which procedure calls the
one from `List`, and also who calls the procedure that calls the one from
`List`; hence, you want a backtrace of the execution stack:

```
(ocd) bt
#0  Pc : 15500  List char 3562
#1  Pc : 19128  Uncaught char 221
```

So the last function called is from module `List` at character 3562, that is:

<!-- $MDX skip -->
```ocaml
let rec assoc x = function
  | [] -> raise Not_found
          ^
  | (a,b)::l -> if a = x then b else assoc x l
```

The function that calls it is in module `Uncaught`, file `uncaught.ml` char
221:


<!-- $MDX skip -->
```ocaml
print_string (find_address "INRIA"); print_newline ();;
                                  ^
```

To sum up: if you're developing a program you can compile it with the `-g`
option, to be ready to debug the program if necessary. Hence, to find a
spurious exception you just need to type `ocamldebug a.out`, then `r`, `b`, and
`bt` gives you the backtrace.

###  Getting help and info in the debugger

To get more info about the current status of the debugger you can ask it
directly at the toplevel prompt of the debugger; for instance:

```
(ocd) info breakpoints
No breakpoint.

(ocd) help break
  1      15396  in List, character 3539
break : Set breakpoint at specified line or function.
Syntax: break function-name
break @ [module] linenum
break @ [module] # characternum
```

###  Setting break points

Let's set up a breakpoint and rerun the entire program from the
beginning (`(g)oto 0` then `(r)un`):

```
(ocd) break @Uncaught 9
Breakpoint 3 at 19112 : file Uncaught, line 9 column 34

(ocd) g 0
Time : 0
Beginning of program.

(ocd) r
Time : 6 - pc : 19112 - module Uncaught
Breakpoint : 1
9 add "IRIA" "Rocquencourt"<|a|>;;
```

Then, we can step and find what happens when `find_address` is about to be
called

```
(ocd) s
Time : 7 - pc : 19012 - module Uncaught
5 let find_address name = <|b|>List.assoc name !l;;

(ocd) p name
name : string = "INRIA"

(ocd) p !l
$1 : (string * string) list = ["IRIA", "Rocquencourt"]
(ocd)
```

Now we can guess why `List.assoc` will fail to find "INRIA" in the list...

###  Using the debugger under Emacs

Under Emacs you call the debugger using `ESC-x` `ocamldebug a.out`. Then Emacs
will send you directly to the file and character reported by the debugger, and
you can step back and forth using `ESC-b` and `ESC-s`, you can set up break
points using `CTRL-X space`, and so on...
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#tracing-functions-calls-in-the-toplevel">Tracing functions calls in the toplevel</a>
</li>
<li><a href="#the-ocaml-debugger">The OCaml debugger</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<p>This tutorial presents two techniques for debugging OCaml programs:</p>
<ul>
<li><a href="#Tracingfunctionscallsinthetoplevel">Tracing functions calls</a>,
which works in the interactive toplevel.
</li>
<li>The <a href="#The-OCaml-debugger">OCaml debugger</a>, which allows analysing programs
compiled with <code>ocamlc</code>.
</li>
</ul>
<h2 id="tracing-functions-calls-in-the-toplevel">Tracing functions calls in the toplevel</h2>
<p>The simplest way to debug programs in the toplevel is to follow the function
calls, by “tracing” the faulty function:</p>
<pre><code class="language-ocaml"># let rec fib x = if x &lt;= 1 then 1 else fib (x - 1) + fib (x - 2)
val fib : int -&gt; int = &lt;fun&gt;
# #trace fib
fib is now traced.
# fib 3
fib &lt;-- 3
fib &lt;-- 1
fib --&gt; 1
fib &lt;-- 2
fib &lt;-- 0
fib --&gt; 1
fib &lt;-- 1
fib --&gt; 1
fib --&gt; 2
fib --&gt; 3
- : int = 3
# #untrace fib
fib is no longer traced.
</code></pre>
<h3 id="polymorphic-functions">Polymorphic functions</h3>
<p>A difficulty with polymorphic functions is that the output of the trace system
is not very informative in case of polymorphic arguments and/or results.
Consider a sorting algorithm (say bubble sort):</p>
<pre><code class="language-ocaml"># let exchange i j v =
  let aux = v.(i) in
    v.(i) &lt;- v.(j);
    v.(j) &lt;- aux
val exchange : int -&gt; int -&gt; 'a array -&gt; unit = &lt;fun&gt;
# let one_pass_vect fin v =
  for j = 1 to fin do
    if v.(j - 1) &gt; v.(j) then exchange (j - 1) j v
  done
val one_pass_vect : int -&gt; 'a array -&gt; unit = &lt;fun&gt;
# let bubble_sort_vect v =
  for i = Array.length v - 1 downto 0 do
    one_pass_vect i v
  done
val bubble_sort_vect : 'a array -&gt; unit = &lt;fun&gt;
# let q = [|18; 3; 1|]
val q : int array = [|18; 3; 1|]
# #trace one_pass_vect
one_pass_vect is now traced.
# bubble_sort_vect q
one_pass_vect &lt;-- 2
one_pass_vect --&gt; &lt;fun&gt;
one_pass_vect* &lt;-- [|&lt;poly&gt;; &lt;poly&gt;; &lt;poly&gt;|]
one_pass_vect* --&gt; ()
one_pass_vect &lt;-- 1
one_pass_vect --&gt; &lt;fun&gt;
one_pass_vect* &lt;-- [|&lt;poly&gt;; &lt;poly&gt;; &lt;poly&gt;|]
one_pass_vect* --&gt; ()
one_pass_vect &lt;-- 0
one_pass_vect --&gt; &lt;fun&gt;
one_pass_vect* &lt;-- [|&lt;poly&gt;; &lt;poly&gt;; &lt;poly&gt;|]
one_pass_vect* --&gt; ()
- : unit = ()
</code></pre>
<p>The function <code>one_pass_vect</code> being polymorphic, its vector argument is printed
as a vector containing polymorphic values, <code>[|&lt;poly&gt;; &lt;poly&gt;; &lt;poly&gt;|]</code>, and
thus we cannot properly follow the computation.</p>
<p>A simple way to overcome this problem is to define a monomorphic version of the
faulty function. This is fairly easy using a <em>type constraint</em>.  Generally
speaking, this allows a proper understanding of the error in the definition of
the polymorphic function. Once this has been corrected, you just have to
suppress the type constraint to revert to a polymorphic version of the
function.</p>
<p>For our sorting routine, a single type constraint on the argument of the
<code>exchange</code> function warranties a monomorphic typing, that allows a proper trace
of function calls:</p>
<pre><code class="language-ocaml"># let exchange i j (v : int array) =    (* notice the type constraint *)
  let aux = v.(i) in
    v.(i) &lt;- v.(j);
    v.(j) &lt;- aux
val exchange : int -&gt; int -&gt; int array -&gt; unit = &lt;fun&gt;
# let one_pass_vect fin v =
  for j = 1 to fin do
    if v.(j - 1) &gt; v.(j) then exchange (j - 1) j v
  done
val one_pass_vect : int -&gt; int array -&gt; unit = &lt;fun&gt;
# let bubble_sort_vect v =
  for i = Array.length v - 1 downto 0 do
    one_pass_vect i v
  done
val bubble_sort_vect : int array -&gt; unit = &lt;fun&gt;
# let q = [| 18; 3; 1 |]
val q : int array = [|18; 3; 1|]
# #trace one_pass_vect
one_pass_vect is now traced.
# bubble_sort_vect q
one_pass_vect &lt;-- 2
one_pass_vect --&gt; &lt;fun&gt;
one_pass_vect* &lt;-- [|18; 3; 1|]
one_pass_vect* --&gt; ()
one_pass_vect &lt;-- 1
one_pass_vect --&gt; &lt;fun&gt;
one_pass_vect* &lt;-- [|3; 1; 18|]
one_pass_vect* --&gt; ()
one_pass_vect &lt;-- 0
one_pass_vect --&gt; &lt;fun&gt;
one_pass_vect* &lt;-- [|1; 3; 18|]
one_pass_vect* --&gt; ()
- : unit = ()
</code></pre>
<h3 id="limitations">Limitations</h3>
<p>To keep track of assignments to data structures and mutable variables in a
program, the trace facility is not powerful enough. You need an extra mechanism
to stop the program in any place and ask for internal values: that is a
symbolic debugger with its stepping feature.</p>
<p>Stepping a functional program has a meaning which is a bit weird to define and
understand. Let me say that we use the notion of <em>runtime events</em> that happen
for instance when a parameter is passed to a function or when entering a
pattern matching, or selecting a clause in a pttern matching. Computation
progress is taken into account by these events, independently of the
instructions executed on the hardware.</p>
<p>Although this is difficult to implement, there exists such a debugger for OCaml
under Unix: <code>ocamldebug</code>. Its use is illustrated in the next section.</p>
<p>In fact, for complex programs, it is likely the case that the programmer will
use explicit printing to find the bugs, since this methodology allows the
reduction of the trace material: only useful data are printed and special
purpose formats are more suited to get the relevant information, than what can
be output automatically by the generic pretty-printer used by the trace
mechanism.</p>
<h2 id="the-ocaml-debugger">The OCaml debugger</h2>
<p>We now give a quick tutorial for the OCaml debugger (<code>ocamldebug</code>).  Before
starting, please note that <code>ocamldebug</code> does not work under native Windows
ports of OCaml (but it runs under the Cygwin port).</p>
<h3 id="launching-the-debugger">Launching the debugger</h3>
<p>Consider the following obviously wrong program written in the file
<code>uncaught.ml</code>:</p>
<pre><code class="language-ocaml">(* file uncaught.ml *)
let l = ref []
let find_address name = List.assoc name !l
let add_address name address = l := (name, address) :: ! l

let () =
  add_address &quot;IRIA&quot; &quot;Rocquencourt&quot;;;
  print_string (find_address &quot;INRIA&quot;); print_newline ();;
</code></pre>
<pre><code class="language-mdx-error">val l : (string * string) list ref = {contents = [(&quot;IRIA&quot;, &quot;Rocquencourt&quot;)]}
val find_address : string -&gt; string = &lt;fun&gt;
val add_address : string -&gt; string -&gt; unit = &lt;fun&gt;
Exception: Not_found.
</code></pre>
<p>At runtime, the program raises an uncaught exception <code>Not_found</code>.  Suppose we
want to find where and why this exception has been raised, we can proceed as
follows. First, we compile the program in debug mode:</p>
<pre><code>ocamlc -g uncaught.ml
</code></pre>
<p>We launch the debugger:</p>
<pre><code>ocamldebug a.out
</code></pre>
<p>Then the debugger answers with a banner and a prompt:</p>
<pre><code>OCaml Debugger version 4.12.0

(ocd)
</code></pre>
<h3 id="finding-the-cause-of-a-spurious-exception">Finding the cause of a spurious exception</h3>
<p>Type <code>r</code> (for <em>run</em>); you get</p>
<pre><code>(ocd) r
Loading program... done.
Time : 12
Program end.
Uncaught exception: Not_found
(ocd)
</code></pre>
<p>Self explanatory, isn't it? So, you want to step backward to set the program
counter before the time the exception is raised; hence type in <code>b</code> as
<em>backstep</em>, and you get</p>
<pre><code>(ocd) b
Time : 11 - pc : 15500 - module List
143     [] -&gt; &lt;|b|&gt;raise Not_found
</code></pre>
<p>The debugger tells you that you are in module <code>List</code>, inside a pattern matching
on a list that already chose the <code>[]</code> case and is about to execute <code>raise Not_found</code>, since the program is stopped just before this expression (as
witnessed by the <code>&lt;|b|&gt;</code> mark).</p>
<p>But, as you know, you want the debugger to tell you which procedure calls the
one from <code>List</code>, and also who calls the procedure that calls the one from
<code>List</code>; hence, you want a backtrace of the execution stack:</p>
<pre><code>(ocd) bt
#0  Pc : 15500  List char 3562
#1  Pc : 19128  Uncaught char 221
</code></pre>
<p>So the last function called is from module <code>List</code> at character 3562, that is:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let rec assoc x = function
  | [] -&gt; raise Not_found
          ^
  | (a,b)::l -&gt; if a = x then b else assoc x l
</code></pre>
<p>The function that calls it is in module <code>Uncaught</code>, file <code>uncaught.ml</code> char
221:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">print_string (find_address &quot;INRIA&quot;); print_newline ();;
                                  ^
</code></pre>
<p>To sum up: if you're developing a program you can compile it with the <code>-g</code>
option, to be ready to debug the program if necessary. Hence, to find a
spurious exception you just need to type <code>ocamldebug a.out</code>, then <code>r</code>, <code>b</code>, and
<code>bt</code> gives you the backtrace.</p>
<h3 id="getting-help-and-info-in-the-debugger">Getting help and info in the debugger</h3>
<p>To get more info about the current status of the debugger you can ask it
directly at the toplevel prompt of the debugger; for instance:</p>
<pre><code>(ocd) info breakpoints
No breakpoint.

(ocd) help break
  1      15396  in List, character 3539
break : Set breakpoint at specified line or function.
Syntax: break function-name
break @ [module] linenum
break @ [module] # characternum
</code></pre>
<h3 id="setting-break-points">Setting break points</h3>
<p>Let's set up a breakpoint and rerun the entire program from the
beginning (<code>(g)oto 0</code> then <code>(r)un</code>):</p>
<pre><code>(ocd) break @Uncaught 9
Breakpoint 3 at 19112 : file Uncaught, line 9 column 34

(ocd) g 0
Time : 0
Beginning of program.

(ocd) r
Time : 6 - pc : 19112 - module Uncaught
Breakpoint : 1
9 add &quot;IRIA&quot; &quot;Rocquencourt&quot;&lt;|a|&gt;;;
</code></pre>
<p>Then, we can step and find what happens when <code>find_address</code> is about to be
called</p>
<pre><code>(ocd) s
Time : 7 - pc : 19012 - module Uncaught
5 let find_address name = &lt;|b|&gt;List.assoc name !l;;

(ocd) p name
name : string = &quot;INRIA&quot;

(ocd) p !l
$1 : (string * string) list = [&quot;IRIA&quot;, &quot;Rocquencourt&quot;]
(ocd)
</code></pre>
<p>Now we can guess why <code>List.assoc</code> will fail to find &quot;INRIA&quot; in the list...</p>
<h3 id="using-the-debugger-under-emacs">Using the debugger under Emacs</h3>
<p>Under Emacs you call the debugger using <code>ESC-x</code> <code>ocamldebug a.out</code>. Then Emacs
will send you directly to the file and character reported by the debugger, and
you can step back and forth using <code>ESC-b</code> and <code>ESC-s</code>, you can set up break
points using <code>CTRL-X space</code>, and so on...</p>
|js}
  };
 
  { title = {js|Map|js}
  ; slug = {js|map|js}
  ; description = {js|Create a mapping using the standard library's Map module
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["stdlib"]
  ; users = [`Beginner; `Intermediate]
  ; body_md = {js|
## Module Map

Map creates a "mapping". For instance, let's say I have some data that is
users and their associated passwords. I could with the Map module create
a mapping from user names to their passwords. The mapping module not
only does this but it does it fairly efficiently. It also does this in a
functional way. In the example below I am going to do a mapping from
strings to strings. However, it is possible to do mappings with all
different types of data.

To create a Map I can do:

```ocaml
# module MyUsers = Map.Make(String)
module MyUsers :
  sig
    type key = string
    type 'a t = 'a Map.Make(String).t
    val empty : 'a t
    val is_empty : 'a t -> bool
    val mem : key -> 'a t -> bool
    val add : key -> 'a -> 'a t -> 'a t
    val update : key -> ('a option -> 'a option) -> 'a t -> 'a t
    val singleton : key -> 'a -> 'a t
    val remove : key -> 'a t -> 'a t
    val merge :
      (key -> 'a option -> 'b option -> 'c option) -> 'a t -> 'b t -> 'c t
    val union : (key -> 'a -> 'a -> 'a option) -> 'a t -> 'a t -> 'a t
    val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int
    val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
    val iter : (key -> 'a -> unit) -> 'a t -> unit
    val fold : (key -> 'a -> 'b -> 'b) -> 'a t -> 'b -> 'b
    val for_all : (key -> 'a -> bool) -> 'a t -> bool
    val exists : (key -> 'a -> bool) -> 'a t -> bool
    val filter : (key -> 'a -> bool) -> 'a t -> 'a t
    val partition : (key -> 'a -> bool) -> 'a t -> 'a t * 'a t
    val cardinal : 'a t -> int
    val bindings : 'a t -> (key * 'a) list
    val min_binding : 'a t -> key * 'a
    val min_binding_opt : 'a t -> (key * 'a) option
    val max_binding : 'a t -> key * 'a
    val max_binding_opt : 'a t -> (key * 'a) option
    val choose : 'a t -> key * 'a
    val choose_opt : 'a t -> (key * 'a) option
    val split : key -> 'a t -> 'a t * 'a option * 'a t
    val find : key -> 'a t -> 'a
    val find_opt : key -> 'a t -> 'a option
    val find_first : (key -> bool) -> 'a t -> key * 'a
    val find_first_opt : (key -> bool) -> 'a t -> (key * 'a) option
    val find_last : (key -> bool) -> 'a t -> key * 'a
    val find_last_opt : (key -> bool) -> 'a t -> (key * 'a) option
    val map : ('a -> 'b) -> 'a t -> 'b t
    val mapi : (key -> 'a -> 'b) -> 'a t -> 'b t
    val to_seq : 'a t -> (key * 'a) Seq.t
    val to_seq_from : key -> 'a t -> (key * 'a) Seq.t
    val add_seq : (key * 'a) Seq.t -> 'a t -> 'a t
    val of_seq : (key * 'a) Seq.t -> 'a t
  end
```

OK, we have created the module `MyUsers`.  Now, let's start putting
something into it.  Where do we start?  Well, let's create an empty
map to begin with:

```ocaml
# let m = MyUsers.empty
val m : 'a MyUsers.t = <abstr>
```

Hummm. An empty map is kind of boring, so let's add some data.

```ocaml
# let m = MyUsers.add "fred" "sugarplums" m
val m : string MyUsers.t = <abstr>
```

We have now created a new map—again called `m`, thus masking the previous
one—by adding
"fred" and his password "sugarplums" to our previous empty map.
There is a fairly important point to make here. Once we have added the
string "sugarplums" we have fixed the types of mappings that we can do.
This means our mapping in our module `MyUsers` is from strings _to strings_.
If we want a mapping from strings to integers or a mapping from integers
to whatever we will have to create a different mapping.

Let's add in some additional data just for kicks.

```ocaml
# let m = MyUsers.add "tom" "ilovelucy" m
val m : string MyUsers.t = <abstr>
# let m = MyUsers.add "mark" "ocamlrules" m
val m : string MyUsers.t = <abstr>
# let m = MyUsers.add "pete" "linux" m
val m : string MyUsers.t = <abstr>
```

Now that we have some data inside of our map, wouldn't it be nice
to be able to view that data at some point? Let's begin by creating a
simple print function.

```ocaml
# let print_user key password =
  print_string(key ^ " " ^ password ^ "\\n")
val print_user : string -> string -> unit = <fun>
```

We have here a function that will take two strings, a key, and a password,
and print them out nicely, including a new line character at the end.
All we need to do is to have this function applied to our mapping. Here
is what that would look like.

```ocaml
# MyUsers.iter print_user m
fred sugarplums
mark ocamlrules
pete linux
tom ilovelucy
- : unit = ()
```
The reason we put our data into a mapping however is probably so we can
quickly find the data. Let's actually show how to do a find.

```ocaml
# MyUsers.find "fred" m
- : string = "sugarplums"
```

This should quickly and efficiently return Fred's password: "sugarplums".

|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#module-map">Module Map</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<h2 id="module-map">Module Map</h2>
<p>Map creates a &quot;mapping&quot;. For instance, let's say I have some data that is
users and their associated passwords. I could with the Map module create
a mapping from user names to their passwords. The mapping module not
only does this but it does it fairly efficiently. It also does this in a
functional way. In the example below I am going to do a mapping from
strings to strings. However, it is possible to do mappings with all
different types of data.</p>
<p>To create a Map I can do:</p>
<pre><code class="language-ocaml"># module MyUsers = Map.Make(String)
module MyUsers :
  sig
    type key = string
    type 'a t = 'a Map.Make(String).t
    val empty : 'a t
    val is_empty : 'a t -&gt; bool
    val mem : key -&gt; 'a t -&gt; bool
    val add : key -&gt; 'a -&gt; 'a t -&gt; 'a t
    val update : key -&gt; ('a option -&gt; 'a option) -&gt; 'a t -&gt; 'a t
    val singleton : key -&gt; 'a -&gt; 'a t
    val remove : key -&gt; 'a t -&gt; 'a t
    val merge :
      (key -&gt; 'a option -&gt; 'b option -&gt; 'c option) -&gt; 'a t -&gt; 'b t -&gt; 'c t
    val union : (key -&gt; 'a -&gt; 'a -&gt; 'a option) -&gt; 'a t -&gt; 'a t -&gt; 'a t
    val compare : ('a -&gt; 'a -&gt; int) -&gt; 'a t -&gt; 'a t -&gt; int
    val equal : ('a -&gt; 'a -&gt; bool) -&gt; 'a t -&gt; 'a t -&gt; bool
    val iter : (key -&gt; 'a -&gt; unit) -&gt; 'a t -&gt; unit
    val fold : (key -&gt; 'a -&gt; 'b -&gt; 'b) -&gt; 'a t -&gt; 'b -&gt; 'b
    val for_all : (key -&gt; 'a -&gt; bool) -&gt; 'a t -&gt; bool
    val exists : (key -&gt; 'a -&gt; bool) -&gt; 'a t -&gt; bool
    val filter : (key -&gt; 'a -&gt; bool) -&gt; 'a t -&gt; 'a t
    val partition : (key -&gt; 'a -&gt; bool) -&gt; 'a t -&gt; 'a t * 'a t
    val cardinal : 'a t -&gt; int
    val bindings : 'a t -&gt; (key * 'a) list
    val min_binding : 'a t -&gt; key * 'a
    val min_binding_opt : 'a t -&gt; (key * 'a) option
    val max_binding : 'a t -&gt; key * 'a
    val max_binding_opt : 'a t -&gt; (key * 'a) option
    val choose : 'a t -&gt; key * 'a
    val choose_opt : 'a t -&gt; (key * 'a) option
    val split : key -&gt; 'a t -&gt; 'a t * 'a option * 'a t
    val find : key -&gt; 'a t -&gt; 'a
    val find_opt : key -&gt; 'a t -&gt; 'a option
    val find_first : (key -&gt; bool) -&gt; 'a t -&gt; key * 'a
    val find_first_opt : (key -&gt; bool) -&gt; 'a t -&gt; (key * 'a) option
    val find_last : (key -&gt; bool) -&gt; 'a t -&gt; key * 'a
    val find_last_opt : (key -&gt; bool) -&gt; 'a t -&gt; (key * 'a) option
    val map : ('a -&gt; 'b) -&gt; 'a t -&gt; 'b t
    val mapi : (key -&gt; 'a -&gt; 'b) -&gt; 'a t -&gt; 'b t
    val to_seq : 'a t -&gt; (key * 'a) Seq.t
    val to_seq_from : key -&gt; 'a t -&gt; (key * 'a) Seq.t
    val add_seq : (key * 'a) Seq.t -&gt; 'a t -&gt; 'a t
    val of_seq : (key * 'a) Seq.t -&gt; 'a t
  end
</code></pre>
<p>OK, we have created the module <code>MyUsers</code>.  Now, let's start putting
something into it.  Where do we start?  Well, let's create an empty
map to begin with:</p>
<pre><code class="language-ocaml"># let m = MyUsers.empty
val m : 'a MyUsers.t = &lt;abstr&gt;
</code></pre>
<p>Hummm. An empty map is kind of boring, so let's add some data.</p>
<pre><code class="language-ocaml"># let m = MyUsers.add &quot;fred&quot; &quot;sugarplums&quot; m
val m : string MyUsers.t = &lt;abstr&gt;
</code></pre>
<p>We have now created a new map—again called <code>m</code>, thus masking the previous
one—by adding
&quot;fred&quot; and his password &quot;sugarplums&quot; to our previous empty map.
There is a fairly important point to make here. Once we have added the
string &quot;sugarplums&quot; we have fixed the types of mappings that we can do.
This means our mapping in our module <code>MyUsers</code> is from strings <em>to strings</em>.
If we want a mapping from strings to integers or a mapping from integers
to whatever we will have to create a different mapping.</p>
<p>Let's add in some additional data just for kicks.</p>
<pre><code class="language-ocaml"># let m = MyUsers.add &quot;tom&quot; &quot;ilovelucy&quot; m
val m : string MyUsers.t = &lt;abstr&gt;
# let m = MyUsers.add &quot;mark&quot; &quot;ocamlrules&quot; m
val m : string MyUsers.t = &lt;abstr&gt;
# let m = MyUsers.add &quot;pete&quot; &quot;linux&quot; m
val m : string MyUsers.t = &lt;abstr&gt;
</code></pre>
<p>Now that we have some data inside of our map, wouldn't it be nice
to be able to view that data at some point? Let's begin by creating a
simple print function.</p>
<pre><code class="language-ocaml"># let print_user key password =
  print_string(key ^ &quot; &quot; ^ password ^ &quot;\\n&quot;)
val print_user : string -&gt; string -&gt; unit = &lt;fun&gt;
</code></pre>
<p>We have here a function that will take two strings, a key, and a password,
and print them out nicely, including a new line character at the end.
All we need to do is to have this function applied to our mapping. Here
is what that would look like.</p>
<pre><code class="language-ocaml"># MyUsers.iter print_user m
fred sugarplums
mark ocamlrules
pete linux
tom ilovelucy
- : unit = ()
</code></pre>
<p>The reason we put our data into a mapping however is probably so we can
quickly find the data. Let's actually show how to do a find.</p>
<pre><code class="language-ocaml"># MyUsers.find &quot;fred&quot; m
- : string = &quot;sugarplums&quot;
</code></pre>
<p>This should quickly and efficiently return Fred's password: &quot;sugarplums&quot;.</p>
|js}
  };
 
  { title = {js|Sets|js}
  ; slug = {js|sets|js}
  ; description = {js|The standard library's Set module
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["stdlib"]
  ; users = [`Beginner; `Intermediate]
  ; body_md = {js|
## Module Set
To make a set of strings:

```ocaml
# module SS = Set.Make(String)
module SS :
  sig
    type elt = string
    type t = Set.Make(String).t
    val empty : t
    val is_empty : t -> bool
    val mem : elt -> t -> bool
    val add : elt -> t -> t
    val singleton : elt -> t
    val remove : elt -> t -> t
    val union : t -> t -> t
    val inter : t -> t -> t
    val disjoint : t -> t -> bool
    val diff : t -> t -> t
    val compare : t -> t -> int
    val equal : t -> t -> bool
    val subset : t -> t -> bool
    val iter : (elt -> unit) -> t -> unit
    val map : (elt -> elt) -> t -> t
    val fold : (elt -> 'a -> 'a) -> t -> 'a -> 'a
    val for_all : (elt -> bool) -> t -> bool
    val exists : (elt -> bool) -> t -> bool
    val filter : (elt -> bool) -> t -> t
    val partition : (elt -> bool) -> t -> t * t
    val cardinal : t -> int
    val elements : t -> elt list
    val min_elt : t -> elt
    val min_elt_opt : t -> elt option
    val max_elt : t -> elt
    val max_elt_opt : t -> elt option
    val choose : t -> elt
    val choose_opt : t -> elt option
    val split : elt -> t -> t * bool * t
    val find : elt -> t -> elt
    val find_opt : elt -> t -> elt option
    val find_first : (elt -> bool) -> t -> elt
    val find_first_opt : (elt -> bool) -> t -> elt option
    val find_last : (elt -> bool) -> t -> elt
    val find_last_opt : (elt -> bool) -> t -> elt option
    val of_list : elt list -> t
    val to_seq_from : elt -> t -> elt Seq.t
    val to_seq : t -> elt Seq.t
    val add_seq : elt Seq.t -> t -> t
    val of_seq : elt Seq.t -> t
  end
```

To create a set you need to start somewhere so here is the empty set:

```ocaml
# let s = SS.empty
val s : SS.t = <abstr>
```

Alternatively if we know an element to start with we can create a set
like

```ocaml
# let s = SS.singleton "hello"
val s : SS.t = <abstr>
```

To add some elements to the set we can do.

```ocaml
# let s =
  List.fold_right SS.add ["hello"; "world"; "community"; "manager";
                          "stuff"; "blue"; "green"] s
val s : SS.t = <abstr>
```

Now if we are playing around with sets we will probably want to see what
is in the set that we have created. To do this we can write a function
that will print the set out.

```ocaml
# let print_set s = 
   SS.iter print_endline s
val print_set : SS.t -> unit = <fun>
```

If we want to remove a specific element of a set there is a remove
function. However if we want to remove several elements at once we could
think of it as doing a 'filter'. Let's filter out all words that are
longer than 5 characters.

This can be written as:

```ocaml
# let my_filter str =
  String.length str <= 5
val my_filter : string -> bool = <fun>
# let s2 = SS.filter my_filter s
val s2 : SS.t = <abstr>
```

or using an anonymous function:

```ocaml
# let s2 = SS.filter (fun str -> String.length str <= 5) s
val s2 : SS.t = <abstr>
```

If we want to check and see if an element is in the set it might look
like this.

```ocaml
# SS.mem "hello" s2
- : bool = true
```

The Set module also provides the set theoretic operations union,
intersection and difference. For example, the difference of the original
set and the set with short strings (≤ 5 characters) is the set of long
strings:

```ocaml
# print_set (SS.diff s s2)
community
manager
- : unit = ()
```

Note that the Set module provides a purely functional data structure:
removing an element from a set does not alter that set but, rather,
returns a new set that is very similar to (and shares much of its
internals with) the original set.

|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#module-set">Module Set</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<h2 id="module-set">Module Set</h2>
<p>To make a set of strings:</p>
<pre><code class="language-ocaml"># module SS = Set.Make(String)
module SS :
  sig
    type elt = string
    type t = Set.Make(String).t
    val empty : t
    val is_empty : t -&gt; bool
    val mem : elt -&gt; t -&gt; bool
    val add : elt -&gt; t -&gt; t
    val singleton : elt -&gt; t
    val remove : elt -&gt; t -&gt; t
    val union : t -&gt; t -&gt; t
    val inter : t -&gt; t -&gt; t
    val disjoint : t -&gt; t -&gt; bool
    val diff : t -&gt; t -&gt; t
    val compare : t -&gt; t -&gt; int
    val equal : t -&gt; t -&gt; bool
    val subset : t -&gt; t -&gt; bool
    val iter : (elt -&gt; unit) -&gt; t -&gt; unit
    val map : (elt -&gt; elt) -&gt; t -&gt; t
    val fold : (elt -&gt; 'a -&gt; 'a) -&gt; t -&gt; 'a -&gt; 'a
    val for_all : (elt -&gt; bool) -&gt; t -&gt; bool
    val exists : (elt -&gt; bool) -&gt; t -&gt; bool
    val filter : (elt -&gt; bool) -&gt; t -&gt; t
    val partition : (elt -&gt; bool) -&gt; t -&gt; t * t
    val cardinal : t -&gt; int
    val elements : t -&gt; elt list
    val min_elt : t -&gt; elt
    val min_elt_opt : t -&gt; elt option
    val max_elt : t -&gt; elt
    val max_elt_opt : t -&gt; elt option
    val choose : t -&gt; elt
    val choose_opt : t -&gt; elt option
    val split : elt -&gt; t -&gt; t * bool * t
    val find : elt -&gt; t -&gt; elt
    val find_opt : elt -&gt; t -&gt; elt option
    val find_first : (elt -&gt; bool) -&gt; t -&gt; elt
    val find_first_opt : (elt -&gt; bool) -&gt; t -&gt; elt option
    val find_last : (elt -&gt; bool) -&gt; t -&gt; elt
    val find_last_opt : (elt -&gt; bool) -&gt; t -&gt; elt option
    val of_list : elt list -&gt; t
    val to_seq_from : elt -&gt; t -&gt; elt Seq.t
    val to_seq : t -&gt; elt Seq.t
    val add_seq : elt Seq.t -&gt; t -&gt; t
    val of_seq : elt Seq.t -&gt; t
  end
</code></pre>
<p>To create a set you need to start somewhere so here is the empty set:</p>
<pre><code class="language-ocaml"># let s = SS.empty
val s : SS.t = &lt;abstr&gt;
</code></pre>
<p>Alternatively if we know an element to start with we can create a set
like</p>
<pre><code class="language-ocaml"># let s = SS.singleton &quot;hello&quot;
val s : SS.t = &lt;abstr&gt;
</code></pre>
<p>To add some elements to the set we can do.</p>
<pre><code class="language-ocaml"># let s =
  List.fold_right SS.add [&quot;hello&quot;; &quot;world&quot;; &quot;community&quot;; &quot;manager&quot;;
                          &quot;stuff&quot;; &quot;blue&quot;; &quot;green&quot;] s
val s : SS.t = &lt;abstr&gt;
</code></pre>
<p>Now if we are playing around with sets we will probably want to see what
is in the set that we have created. To do this we can write a function
that will print the set out.</p>
<pre><code class="language-ocaml"># let print_set s = 
   SS.iter print_endline s
val print_set : SS.t -&gt; unit = &lt;fun&gt;
</code></pre>
<p>If we want to remove a specific element of a set there is a remove
function. However if we want to remove several elements at once we could
think of it as doing a 'filter'. Let's filter out all words that are
longer than 5 characters.</p>
<p>This can be written as:</p>
<pre><code class="language-ocaml"># let my_filter str =
  String.length str &lt;= 5
val my_filter : string -&gt; bool = &lt;fun&gt;
# let s2 = SS.filter my_filter s
val s2 : SS.t = &lt;abstr&gt;
</code></pre>
<p>or using an anonymous function:</p>
<pre><code class="language-ocaml"># let s2 = SS.filter (fun str -&gt; String.length str &lt;= 5) s
val s2 : SS.t = &lt;abstr&gt;
</code></pre>
<p>If we want to check and see if an element is in the set it might look
like this.</p>
<pre><code class="language-ocaml"># SS.mem &quot;hello&quot; s2
- : bool = true
</code></pre>
<p>The Set module also provides the set theoretic operations union,
intersection and difference. For example, the difference of the original
set and the set with short strings (≤ 5 characters) is the set of long
strings:</p>
<pre><code class="language-ocaml"># print_set (SS.diff s s2)
community
manager
- : unit = ()
</code></pre>
<p>Note that the Set module provides a purely functional data structure:
removing an element from a set does not alter that set but, rather,
returns a new set that is very similar to (and shares much of its
internals with) the original set.</p>
|js}
  };
 
  { title = {js|Hashtables|js}
  ; slug = {js|hashtables|js}
  ; description = {js|Discover efficient and mutable lookup tables with OCaml's Hashtbl module
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["stdlib"]
  ; users = [`Intermediate; `Advanced]
  ; body_md = {js|
## Module Hashtbl

The Hashtbl module implements an efficient, mutable lookup table. To
create a hash table we could write:

```ocaml
# let my_hash = Hashtbl.create 123456
val my_hash : ('_weak1, '_weak2) Hashtbl.t = <abstr>
```
The 123456 is the initial size of the hashtbl. This initial number is
just your best guess as to the amount of data that you will be putting
into the hash table. The hash table can grow if you under-estimate the
size so don't worry about it too much. The type of my_hash is:

```ocaml
# my_hash
- : ('_weak1, '_weak2) Hashtbl.t = <abstr>
```

The `'_weak1` and `'_weak2` correspond to the key and value types, respectively.
There are no concrete types (e.g., `int` or `float * string`) filled in in
those slots because the type of the key and value are not yet
determined. The underscore indicates that the key and data types, once
chosen, will be fixed. In other words, you can't sometimes use a given
hashtable with ints for keys, and then later use a string as a key in
that same hashtable.

Lets add some data to `my_hash`. Lets say I am working on a cross word
solving program and I want to find all words that start with a certain
letter. First I need to enter the data into `my_hash`.

Note that a hashtable is modified by in-place updates, so, unlike a map,
another hash table is _not_ created every time you change the table. Thus,
the code `let my_hash = Hashtbl.add my_hash ...` wouldn't make any
sense. Instead, we would write something like this:

```ocaml
# Hashtbl.add my_hash "h" "hello";
  Hashtbl.add my_hash "h" "hi";
  Hashtbl.add my_hash "h" "hug";
  Hashtbl.add my_hash "h" "hard";
  Hashtbl.add my_hash "w" "wimp";
  Hashtbl.add my_hash "w" "world";
  Hashtbl.add my_hash "w" "wine"
- : unit = ()
```

If we want to find one element in `my_hash` that has an `"h"` in it then we
would write: 

```ocaml
# Hashtbl.find my_hash "h"
- : string = "hard"
```

Notice how it returns just one element? That element
was the last one entered in with the value of `"h"`.

What we probably want is all the elements that start with `"h"`. To do
this we want to *find all* of them. What better name for this than
`find_all`?

```ocaml
# Hashtbl.find_all my_hash "h"
- : string list = ["hard"; "hug"; "hi"; "hello"]
```

returns `["hard"; "hug"; "hi"; "hello"]`.

If you remove a key, its previous value becomes again the default one
associated to the key.

```ocaml
# Hashtbl.remove my_hash "h";;
- : unit = ()
# Hashtbl.find my_hash "h";;
- : string = "hug"
```

This behavior is interesting for the above example or when, say, the
keys represent variables that can be temporarily masked by a local
variables of the same name.

In other contexts, one may prefer new values to *replace* the previous
ones.  In this case, one uses `Hashtbl.replace`:

```ocaml
# Hashtbl.replace my_hash "t" "try";
  Hashtbl.replace my_hash "t" "test";
  Hashtbl.find_all my_hash "t"
- : string list = ["test"]

# Hashtbl.remove my_hash "t";
  Hashtbl.find my_hash "t"
Exception: Not_found.
```

To find out whether there is an
entry in `my_hash` for a letter we would do:

```ocaml
# Hashtbl.mem my_hash "h"
- : bool = true
```
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#module-hashtbl">Module Hashtbl</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<h2 id="module-hashtbl">Module Hashtbl</h2>
<p>The Hashtbl module implements an efficient, mutable lookup table. To
create a hash table we could write:</p>
<pre><code class="language-ocaml"># let my_hash = Hashtbl.create 123456
val my_hash : ('_weak1, '_weak2) Hashtbl.t = &lt;abstr&gt;
</code></pre>
<p>The 123456 is the initial size of the hashtbl. This initial number is
just your best guess as to the amount of data that you will be putting
into the hash table. The hash table can grow if you under-estimate the
size so don't worry about it too much. The type of my_hash is:</p>
<pre><code class="language-ocaml"># my_hash
- : ('_weak1, '_weak2) Hashtbl.t = &lt;abstr&gt;
</code></pre>
<p>The <code>'_weak1</code> and <code>'_weak2</code> correspond to the key and value types, respectively.
There are no concrete types (e.g., <code>int</code> or <code>float * string</code>) filled in in
those slots because the type of the key and value are not yet
determined. The underscore indicates that the key and data types, once
chosen, will be fixed. In other words, you can't sometimes use a given
hashtable with ints for keys, and then later use a string as a key in
that same hashtable.</p>
<p>Lets add some data to <code>my_hash</code>. Lets say I am working on a cross word
solving program and I want to find all words that start with a certain
letter. First I need to enter the data into <code>my_hash</code>.</p>
<p>Note that a hashtable is modified by in-place updates, so, unlike a map,
another hash table is <em>not</em> created every time you change the table. Thus,
the code <code>let my_hash = Hashtbl.add my_hash ...</code> wouldn't make any
sense. Instead, we would write something like this:</p>
<pre><code class="language-ocaml"># Hashtbl.add my_hash &quot;h&quot; &quot;hello&quot;;
  Hashtbl.add my_hash &quot;h&quot; &quot;hi&quot;;
  Hashtbl.add my_hash &quot;h&quot; &quot;hug&quot;;
  Hashtbl.add my_hash &quot;h&quot; &quot;hard&quot;;
  Hashtbl.add my_hash &quot;w&quot; &quot;wimp&quot;;
  Hashtbl.add my_hash &quot;w&quot; &quot;world&quot;;
  Hashtbl.add my_hash &quot;w&quot; &quot;wine&quot;
- : unit = ()
</code></pre>
<p>If we want to find one element in <code>my_hash</code> that has an <code>&quot;h&quot;</code> in it then we
would write:</p>
<pre><code class="language-ocaml"># Hashtbl.find my_hash &quot;h&quot;
- : string = &quot;hard&quot;
</code></pre>
<p>Notice how it returns just one element? That element
was the last one entered in with the value of <code>&quot;h&quot;</code>.</p>
<p>What we probably want is all the elements that start with <code>&quot;h&quot;</code>. To do
this we want to <em>find all</em> of them. What better name for this than
<code>find_all</code>?</p>
<pre><code class="language-ocaml"># Hashtbl.find_all my_hash &quot;h&quot;
- : string list = [&quot;hard&quot;; &quot;hug&quot;; &quot;hi&quot;; &quot;hello&quot;]
</code></pre>
<p>returns <code>[&quot;hard&quot;; &quot;hug&quot;; &quot;hi&quot;; &quot;hello&quot;]</code>.</p>
<p>If you remove a key, its previous value becomes again the default one
associated to the key.</p>
<pre><code class="language-ocaml"># Hashtbl.remove my_hash &quot;h&quot;;;
- : unit = ()
# Hashtbl.find my_hash &quot;h&quot;;;
- : string = &quot;hug&quot;
</code></pre>
<p>This behavior is interesting for the above example or when, say, the
keys represent variables that can be temporarily masked by a local
variables of the same name.</p>
<p>In other contexts, one may prefer new values to <em>replace</em> the previous
ones.  In this case, one uses <code>Hashtbl.replace</code>:</p>
<pre><code class="language-ocaml"># Hashtbl.replace my_hash &quot;t&quot; &quot;try&quot;;
  Hashtbl.replace my_hash &quot;t&quot; &quot;test&quot;;
  Hashtbl.find_all my_hash &quot;t&quot;
- : string list = [&quot;test&quot;]

# Hashtbl.remove my_hash &quot;t&quot;;
  Hashtbl.find my_hash &quot;t&quot;
Exception: Not_found.
</code></pre>
<p>To find out whether there is an
entry in <code>my_hash</code> for a letter we would do:</p>
<pre><code class="language-ocaml"># Hashtbl.mem my_hash &quot;h&quot;
- : bool = true
</code></pre>
|js}
  };
 
  { title = {js|Streams|js}
  ; slug = {js|streams|js}
  ; description = {js|Streams offer an abstraction over consuming items from sequences
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["stdlib"]
  ; users = [`Beginner; `Intermediate]
  ; body_md = {js|
Suppose you need to process each line of a text file. One way to do this
is to read the file in as a single large string and use something like
`Str.split` to turn it into a list. This works when the file is small,
but because the entire file is loaded into memory, it does not scale
well when the file is large.

More commonly, the `input_line` function can be used to read one line at
a time from a channel. This typically looks like:

```ocaml
let in_channel = open_in "lines.txt" in
try
  while true do
    let line = input_line in_channel in
    (* do something with line *)
  done
with End_of_file ->
  close_in in_channel
```
```mdx-error
Line 6, characters 5-9:
Error: Syntax error
```

The above code is efficient with memory, but it can be inconvenient in
other ways. Since `input_line` only works with the `in_channel` type, it
cannot be reused in cases where the text is already in memory. The
`End_of_file` exception can be raised at any point during iteration, and
it is the programmer's responsibility to ensure that the file is closed
appropriately. In fact, if there is any other exception in the above
example, the file will not be closed at all. Altogether, there is a lot
going on: channels, I/O, exceptions, and files.

Streams offer an abstraction over one part of this process: reading
items from a sequence. They don't assume anything about files or
channels, and they replace the `End_of_file` exception with a more
structured approach to dealing with the end of input. Here is a function
that builds a stream of lines from an input channel:

```ocaml
# let line_stream_of_channel channel =
  Stream.from
    (fun _ ->
       try Some (input_line channel) with End_of_file -> None)
val line_stream_of_channel : in_channel -> string Stream.t = <fun>
```
The "Stream.from" function builds a stream from a callback function.
This function is passed the current stream count (starting with 0) as an
argument and is expected to return an `'a option`. If the option has a
value (`Some x`), that value will be the next item in the stream. If it
has no value (`None`), this indicates that the stream is empty and no
further reads will be attempted. Since the option is polymorphic,
`Stream.from` can construct streams of any type. These streams have a
type of `'a Stream.t`.

With this simple function, we can now easily construct line streams from
any input channel:

```ocaml
# let in_channel = open_in "019_streams.md"
val in_channel : in_channel = <abstr>
# let lines = line_stream_of_channel in_channel
val lines : string Stream.t = <abstr>
```

This variable `lines` is a stream of strings, one string per line. We
can now begin reading lines from it by passing it to `Stream.next`:

```ocaml
# Stream.next lines
- : string = "---"
# Stream.next lines
- : string = "title: Streams"
# Stream.next lines
- : string = "description: >"
# Stream.next lines
- : string =
"  Streams offer an abstraction over consuming items from sequences"
# while true do ignore(Stream.next lines) done
Exception: Stdlib.Stream.Failure.
```

As you can see, `Stream.next` either returns the next item in the stream
or raises a `Stream.Failure` exception indicating that the stream is
empty. Likewise, with a little help from the `Stream.of_list`
constructor and the `Str` regular expression module, we could build a
stream of lines from a string in memory:

```ocaml
# #load "str.cma"
# let line_stream_of_string string =
  Stream.of_list (Str.split (Str.regexp "\\n") string)
val line_stream_of_string : string -> string Stream.t = <fun>
```
and these streams could be used exactly the same way:

```ocaml
# let lines = line_stream_of_string "hello\\nstream\\nworld"
val lines : string Stream.t = <abstr>
# Stream.next lines
- : string = "hello"
# Stream.next lines
- : string = "stream"
# Stream.next lines
- : string = "world"
# Stream.next lines
Exception: Stdlib.Stream.Failure.
```

Since both cases raise `Stream.Failure` on an empty stream, there is no
need to worry about catching `End_of_file` in the case of file I/O. This
unified interface makes it much easier to write functions that can
receive data from multiple sources.

The `Stream.iter` function automates the common task of performing an
operation for each item. With it, we can rewrite the original example as
follows:

```ocaml
let in_channel = open_in "019_streams.md" in
try
  Stream.iter
    (fun line ->
       (* do something with line *)
       print_endline line)
    (line_stream_of_channel in_channel);
  close_in in_channel
with e ->
  close_in in_channel;
  raise e
```

Note how much easier it is to handle I/O exceptions properly, since we
can deal with them independently from the end-of-file condition. This
separation of concerns allows us to decompose this into simpler and more
reusable functions:

```ocaml
# let process_line line =
  print_endline line
val process_line : string -> unit = <fun>

# let process_lines lines =
  Stream.iter process_line lines
val process_lines : string Stream.t -> unit = <fun>

# let process_file filename =
  let in_channel = open_in filename in
  try
    process_lines (line_stream_of_channel in_channel);
    close_in in_channel
  with e ->
    close_in in_channel;
    raise e
val process_file : string -> unit = <fun>

# let process_string string =
  process_lines (line_stream_of_string string)
val process_string : string -> unit = <fun>
```

## Constructing streams
In the above examples, we saw two methods for constructing streams:

* Stream.from, which builds a stream from a callback function
* Stream.of_list, which builds a stream from a list in memory

The `Stream` module provides a few other stream builders:

* Stream.of_string, which builds a character stream from a string
* Stream.of_channel, which builds a character stream from a channel

`Stream.from` is the most general, and it can be used to produce streams
of any type. It is not limited to I/O and can even produce infinite
sequences. Here are a few simple stream builders defined with
`Stream.from`:

```ocaml
# let empty_stream () = Stream.from (fun _ -> None)
val empty_stream : unit -> 'a Stream.t = <fun>
# let const_stream k = Stream.from (fun _ -> Some k)
val const_stream : 'a -> 'a Stream.t = <fun>
# let count_stream i = Stream.from (fun j -> Some (i + j))
val count_stream : int -> int Stream.t = <fun>
```

## Deconstructing streams
We already saw the `Stream.next` function, which retrieves a single item
from a stream. There is another way to work with streams that is often
preferable: `Stream.peek` and `Stream.junk`. When used together, these
functions allow you to see what the next item would be. This feature,
known as "look ahead", is very useful when writing parsers. Even if you
don't need to look ahead, the peek/junk protocol may be nicer to work
with because it uses options instead of exceptions:

```ocaml
# let lines = line_stream_of_string "hello\\nworld"
val lines : string Stream.t = <abstr>
# Stream.peek lines
- : string option = Some "hello"
# Stream.peek lines
- : string option = Some "hello"
# Stream.junk lines
- : unit = ()
# Stream.peek lines
- : string option = Some "world"
# Stream.junk lines
- : unit = ()
# Stream.peek lines
- : string option = None
```

As you can see, it is necessary to call `Stream.junk` to advance to the
next item. `Stream.peek` will always give you either the next item or
`None`, and it will never fail. Likewise, `Stream.junk` always succeeds
(even if the stream is empty).

## A more complex `Stream.from` example
Here is a function that converts a line stream into a paragraph stream.
As such, it is both a stream consumer and a stream producer.

```ocaml
# let paragraphs lines =
  let rec next para_lines i =
    match Stream.peek lines, para_lines with
    | None, [] -> None
    | Some "", [] ->
        Stream.junk lines;
        next para_lines i
    | Some "", _ | None, _ ->
        Some (String.concat "\\n" (List.rev para_lines))
    | Some line, _ ->
        Stream.junk lines;
        next (line :: para_lines) i in
  Stream.from (next [])
val paragraphs : string Stream.t -> string Stream.t = <fun>
```

This function uses an extra parameter to `next` (the `Stream.from`
callback) called `para_lines` in order to collect the lines for each
paragraph. Paragraphs are delimited by any number of blank lines.

Each time `next` is called, a `match` expression tests two values: the
next line in the stream, and the contents of `para_lines`. Four cases
are handled:

1. If the end of the stream is reached and no lines have been
 collected, the paragraph stream ends as well.
1. If the next line is blank and no lines have been collected, the
 blank is ignored and `next` is called recursively to keep looking
 for a non-blank line.
1. If a blank line or end of stream is reached and lines **have** been
 collected, the paragraph is returned by concatenating `para_lines`
 to a single string.
1. Finally, if a non-blank line has been reached, the line is collected
 by recursively calling `para_lines`.

Happily, we can rely on the OCaml compiler's exhaustiveness checking to
ensure that we are handling all possible cases.

With this new tool, we can now work just as easily with paragraphs as we
could before with lines:

```ocaml
(* Print each paragraph, followed by a separator. *)
let lines = line_stream_of_channel in_channel in
Stream.iter
  (fun para ->
     print_endline para;
     print_endline "--")
  (paragraphs lines)
```
Functions like `paragraphs` that produce and consume streams can be
composed together in a manner very similar to UNIX pipes and filters.

## Stream combinators
Just like lists and arrays, common iteration patterns such as `map`,
`filter`, and `fold` can be very useful. The `Stream` module does not
provide such functions, but they can be built easily using
`Stream.from`:

```ocaml
# let stream_map f stream =
  let rec next i =
    try Some (f (Stream.next stream))
    with Stream.Failure -> None in
  Stream.from next
val stream_map : ('a -> 'b) -> 'a Stream.t -> 'b Stream.t = <fun>

# let stream_filter p stream =
  let rec next i =
    try
      let value = Stream.next stream in
      if p value then Some value else next i
    with Stream.Failure -> None in
  Stream.from next
val stream_filter : ('a -> bool) -> 'a Stream.t -> 'a Stream.t = <fun>

# let stream_fold f stream init =
  let result = ref init in
  Stream.iter
    (fun x -> result := f x !result)
    stream;
  !result
val stream_fold : ('a -> 'b -> 'b) -> 'a Stream.t -> 'b -> 'b = <fun>
```
For example, here is a stream of leap years starting with 2000:

```ocaml
# let is_leap year =
  year mod 4 = 0 && (year mod 100 <> 0 || year mod 400 = 0)
val is_leap : int -> bool = <fun>
# let leap_years = stream_filter is_leap (count_stream 2000)
val leap_years : int Stream.t = <abstr>
```

We can use the `Stream.npeek` function to look ahead by more than one
item. In this case, we'll peek at the next 30 items to make sure that
the year 2100 is not a leap year (since it's divisible by 100 but not
400!):

```ocaml
# Stream.npeek 30 leap_years
- : int list =
[2000; 2004; 2008; 2012; 2016; 2020; 2024; 2028; 2032; 2036; 2040; 2044;
 2048; 2052; 2056; 2060; 2064; 2068; 2072; 2076; 2080; 2084; 2088; 2092;
 2096; 2104; 2108; 2112; 2116; 2120]
```

Note that we must be careful not to use `Stream.iter` on an infinite
stream like `leap_years`. This applies to `stream_fold`, as well as any
function that attempts to consume the entire stream.

```ocaml
# stream_fold (+) (Stream.of_list [1; 2; 3]) 0
- : int = 6
```

`stream_fold (+) (count_stream 0) 0` runs forever.

## Other useful stream builders
The previously defined `const_stream` function builds a stream that
repeats a single value. It is also useful to build a stream that repeats
a sequence of values. The following function does just that:

```ocaml
# let cycle items =
  let buf = ref [] in
  let rec next i =
    if !buf = [] then buf := items;
    match !buf with
      | h :: t -> (buf := t; Some h)
      | [] -> None in
  Stream.from next
val cycle : 'a list -> 'a Stream.t = <fun>
```

One common task that can benefit from this kind of stream is the
generation of alternating background colors for HTML. By using `cycle`
with `stream_combine`, explained in the next section, an infinite stream
of background colors can be combined with a finite stream of data to
produce a sequence of HTML blocks:

```ocaml
# let stream_combine stream1 stream2 =
  let rec next i =
    try Some (Stream.next stream1, Stream.next stream2)
    with Stream.Failure -> None in
  Stream.from next
val stream_combine : 'a Stream.t -> 'b Stream.t -> ('a * 'b) Stream.t = <fun>
# Stream.iter print_endline
  (stream_map
     (fun (bg, s) ->
        Printf.sprintf "<div style='background: %s'>%s</div>" bg s)
     (stream_combine
        (cycle ["#eee"; "#fff"])
        (Stream.of_list ["hello"; "html"; "world"])))
<div style='background: #eee'>hello</div>
<div style='background: #fff'>html</div>
<div style='background: #eee'>world</div>
- : unit = ()
```
Here is a simple `range` function that produces a sequence of integers:

```ocaml
# let range ?(start=0) ?(stop=0) ?(step=1) () =
  let in_range = if step < 0 then (>) else (<) in
  let current = ref start in
  let rec next i =
    if in_range !current stop
    then let result = !current in (current := !current + step;
                                   Some result)
    else None in
  Stream.from next
val range : ?start:int -> ?stop:int -> ?step:int -> unit -> int Stream.t =
  <fun>
```

This works just like Python's `xrange` built-in function, providing an
easy way to produce an assortment of lazy integer sequences by
specifying combinations of `start`, `stop`, or `step` values:

```ocaml
# Stream.npeek 10 (range ~start:5 ~stop:10 ())
- : int list = [5; 6; 7; 8; 9]
# Stream.npeek 10 (range ~stop:10 ~step:2 ())
- : int list = [0; 2; 4; 6; 8]
# Stream.npeek 10 (range ~start:10 ~step:(-1) ())
- : int list = [10; 9; 8; 7; 6; 5; 4; 3; 2; 1]
# Stream.npeek 10 (range ~start:10 ~stop:5 ~step:(-1) ())
- : int list = [10; 9; 8; 7; 6]
```

## Combining streams
There are several ways to combine streams. One is to produce a stream of
streams and then concatenate them into a single stream. The following
function works just like `List.concat`, but instead of turning a list of
lists into a list, it turns a stream of streams into a stream:

```ocaml
# let stream_concat streams =
  let current_stream = ref None in
  let rec next i =
    try
      let stream =
        match !current_stream with
        | Some stream -> stream
        | None ->
           let stream = Stream.next streams in
           current_stream := Some stream;
           stream in
      try Some (Stream.next stream)
      with Stream.Failure -> (current_stream := None; next i)
    with Stream.Failure -> None in
  Stream.from next
val stream_concat : 'a Stream.t Stream.t -> 'a Stream.t = <fun>
```
Here is a sequence of ranges which are themselves derived from a range,
concatenated with `stream_concat` to produce a flattened `int Stream.t`.

```ocaml
# Stream.npeek 10
  (stream_concat
     (stream_map
        (fun i -> range ~stop:i ())
        (range ~stop:5 ())))
- : int list = [0; 0; 1; 0; 1; 2; 0; 1; 2; 3]
```

Another way to combine streams is to iterate through them in a pairwise
fashion:

```ocaml
# let stream_combine stream1 stream2 =
  let rec next i =
    try Some (Stream.next stream1, Stream.next stream2)
    with Stream.Failure -> None in
  Stream.from next
val stream_combine : 'a Stream.t -> 'b Stream.t -> ('a * 'b) Stream.t = <fun>
```
This is useful, for instance, if you have a stream of keys and a stream
of corresponding values. Iterating through key value pairs is then as
simple as:

```ocaml
Stream.iter
  (fun (key, value) ->
     (* do something with 'key' and 'value' *)
     ())
  (stream_combine key_stream value_stream)
```
```mdx-error
Line 5, characters 21-31:
Error: Unbound value key_stream
```
Since `stream_combine` stops as soon as either of its input streams runs
out, it can be used to combine an infinite stream with a finite one.
This provides a neat way to add indexes to a sequence:

```ocaml
# let items = ["this"; "is"; "a"; "test"]
val items : string list = ["this"; "is"; "a"; "test"]
# Stream.iter
  (fun (index, value) ->
     Printf.printf "%d. %s\\n%!" index value)
  (stream_combine (count_stream 1) (Stream.of_list items))
1. this
2. is
3. a
4. test
- : unit = ()
```

## Copying streams
Streams are destructive; once you discard an item in a stream, it is no
longer available unless you save a copy somewhere. What if you want to
use the same stream more than once? One way is to create a "tee". The
following function creates two output streams from one input stream,
intelligently queueing unseen values until they have been produced by
both streams:

```ocaml
# let stream_tee stream =
  let next self other i =
    try
      if Queue.is_empty self
      then
        let value = Stream.next stream in
        Queue.add value other;
        Some value
      else
        Some (Queue.take self)
    with Stream.Failure -> None in
  let q1 = Queue.create () in
  let q2 = Queue.create () in
  (Stream.from (next q1 q2), Stream.from (next q2 q1))
val stream_tee : 'a Stream.t -> 'a Stream.t * 'a Stream.t = <fun>
```
Here is an example of a stream tee in action:

```ocaml
# let letters = Stream.of_list ['a'; 'b'; 'c'; 'd'; 'e']
val letters : char Stream.t = <abstr>
# let s1, s2 = stream_tee letters
val s1 : char Stream.t = <abstr>
val s2 : char Stream.t = <abstr>
# Stream.next s1
- : char = 'a'
# Stream.next s1
- : char = 'b'
# Stream.next s2
- : char = 'a'
# Stream.next s1
- : char = 'c'
# Stream.next s2
- : char = 'b'
# Stream.next s2
- : char = 'c'
```

Again, since streams are destructive, you probably want to leave the
original stream alone or you will lose items from the copied streams:

```ocaml
# Stream.next letters
- : char = 'd'
# Stream.next s1
- : char = 'e'
# Stream.next s2
- : char = 'e'
```

## Converting streams
Here are a few functions for converting between streams and lists,
arrays, and hash tables. These probably belong in the standard library,
but they are simple to define anyhow. Again, beware of infinite streams,
which will cause these functions to hang.

```ocaml
# let stream_of_list = Stream.of_list
val stream_of_list : 'a list -> 'a Stream.t = <fun>
# let list_of_stream stream =
  let result = ref [] in
  Stream.iter (fun value -> result := value :: !result) stream;
  List.rev !result
val list_of_stream : 'a Stream.t -> 'a list = <fun>
# let stream_of_array array =
  Stream.of_list (Array.to_list array)
val stream_of_array : 'a array -> 'a Stream.t = <fun>
# let array_of_stream stream =
  Array.of_list (list_of_stream stream)
val array_of_stream : 'a Stream.t -> 'a array = <fun>
# let stream_of_hash hash =
  let result = ref [] in
  Hashtbl.iter
    (fun key value -> result := (key, value) :: !result)
    hash;
  Stream.of_list !result
val stream_of_hash : ('a, 'b) Hashtbl.t -> ('a * 'b) Stream.t = <fun>
# let hash_of_stream stream =
  let result = Hashtbl.create 0 in
  Stream.iter
    (fun (key, value) -> Hashtbl.replace result key value)
    stream;
  result
val hash_of_stream : ('a * 'b) Stream.t -> ('a, 'b) Hashtbl.t = <fun>
```

What if you want to convert arbitrary data types to streams? Well, if the
data type defines an `iter` function, and you don't mind using threads,
you can use a producer-consumer arrangement to invert control:

```ocaml
# #directory "+threads";;
# #load "threads.cma";;
# let elements iter coll =
  let channel = Event.new_channel () in
  let producer () =
    let () =
      iter (fun x -> Event.sync (Event.send channel (Some x))) coll in
    Event.sync (Event.send channel None) in
  let consumer i =
    Event.sync (Event.receive channel) in
  ignore (Thread.create producer ());
  Stream.from consumer
val elements : (('a -> unit) -> 'b -> unit) -> 'b -> 'a Stream.t = <fun>
```

Now it is possible to build a stream from an `iter` function and a
corresponding value:

```ocaml
# module StringSet = Set.Make(String)
module StringSet :
  sig
    type elt = string
    type t = Set.Make(String).t
    val empty : t
    val is_empty : t -> bool
    val mem : elt -> t -> bool
    val add : elt -> t -> t
    val singleton : elt -> t
    val remove : elt -> t -> t
    val union : t -> t -> t
    val inter : t -> t -> t
    val disjoint : t -> t -> bool
    val diff : t -> t -> t
    val compare : t -> t -> int
    val equal : t -> t -> bool
    val subset : t -> t -> bool
    val iter : (elt -> unit) -> t -> unit
    val map : (elt -> elt) -> t -> t
    val fold : (elt -> 'a -> 'a) -> t -> 'a -> 'a
    val for_all : (elt -> bool) -> t -> bool
    val exists : (elt -> bool) -> t -> bool
    val filter : (elt -> bool) -> t -> t
    val partition : (elt -> bool) -> t -> t * t
    val cardinal : t -> int
    val elements : t -> elt list
    val min_elt : t -> elt
    val min_elt_opt : t -> elt option
    val max_elt : t -> elt
    val max_elt_opt : t -> elt option
    val choose : t -> elt
    val choose_opt : t -> elt option
    val split : elt -> t -> t * bool * t
    val find : elt -> t -> elt
    val find_opt : elt -> t -> elt option
    val find_first : (elt -> bool) -> t -> elt
    val find_first_opt : (elt -> bool) -> t -> elt option
    val find_last : (elt -> bool) -> t -> elt
    val find_last_opt : (elt -> bool) -> t -> elt option
    val of_list : elt list -> t
    val to_seq_from : elt -> t -> elt Seq.t
    val to_seq : t -> elt Seq.t
    val add_seq : elt Seq.t -> t -> t
    val of_seq : elt Seq.t -> t
  end
# let set = StringSet.empty
val set : StringSet.t = <abstr>
# let set = StringSet.add "here" set
val set : StringSet.t = <abstr>
# let set = StringSet.add "are" set
val set : StringSet.t = <abstr>
# let set = StringSet.add "some" set
val set : StringSet.t = <abstr>
# let set = StringSet.add "values" set
val set : StringSet.t = <abstr>
# let stream = elements StringSet.iter set
val stream : string Stream.t = <abstr>
# Stream.iter print_endline stream
are
here
some
values
- : unit = ()
```

Some data types, like Hashtbl and Map, provide an `iter` function that
iterates through key-value pairs. Here's a function for those, too:

```ocaml
# let items iter coll =
  let channel = Event.new_channel () in
  let producer () =
    let () =
      iter (fun k v ->
              Event.sync (Event.send channel (Some (k, v)))) coll in
    Event.sync (Event.send channel None) in
  let consumer i =
    Event.sync (Event.receive channel) in
  ignore (Thread.create producer ());
  Stream.from consumer
val items : (('a -> 'b -> unit) -> 'c -> unit) -> 'c -> ('a * 'b) Stream.t =
  <fun>
```

If we want just the keys, or just the values, it is simple to transform
the output of `items` using `stream_map`:

```ocaml
# let keys iter coll = stream_map (fun (k, v) -> k) (items iter coll)
val keys : (('a -> 'b -> unit) -> 'c -> unit) -> 'c -> 'a Stream.t = <fun>
# let values iter coll = stream_map (fun (k, v) -> v) (items iter coll)
val values : (('a -> 'b -> unit) -> 'c -> unit) -> 'c -> 'b Stream.t = <fun>
```

Keep in mind that these techniques spawn producer threads which carry a
few risks: they only terminate when they have finished iterating, and
any change to the original data structure while iterating may produce
unexpected results.

## Other built-in Stream functions
There are a few other documented methods in the `Stream` module:

* Stream.empty, which raises `Stream.Failure` unless a stream is empty
* Stream.count, which returns the stream count (number of discarded
 elements)

In addition, there are a few undocumented functions: `iapp`, `icons`,
`ising`, `lapp`, `lcons`, `lsing`, `sempty`, `slazy`, and `dump`. They
are visible in the interface with the caveat: "For system use only, not
for the casual user".
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#constructing-streams">Constructing streams</a>
</li>
<li><a href="#deconstructing-streams">Deconstructing streams</a>
</li>
<li><a href="#a-more-complex-streamfrom-example">A more complex <code>Stream.from</code> example</a>
</li>
<li><a href="#stream-combinators">Stream combinators</a>
</li>
<li><a href="#other-useful-stream-builders">Other useful stream builders</a>
</li>
<li><a href="#combining-streams">Combining streams</a>
</li>
<li><a href="#copying-streams">Copying streams</a>
</li>
<li><a href="#converting-streams">Converting streams</a>
</li>
<li><a href="#other-built-in-stream-functions">Other built-in Stream functions</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<p>Suppose you need to process each line of a text file. One way to do this
is to read the file in as a single large string and use something like
<code>Str.split</code> to turn it into a list. This works when the file is small,
but because the entire file is loaded into memory, it does not scale
well when the file is large.</p>
<p>More commonly, the <code>input_line</code> function can be used to read one line at
a time from a channel. This typically looks like:</p>
<pre><code class="language-ocaml">let in_channel = open_in &quot;lines.txt&quot; in
try
  while true do
    let line = input_line in_channel in
    (* do something with line *)
  done
with End_of_file -&gt;
  close_in in_channel
</code></pre>
<pre><code class="language-mdx-error">Line 6, characters 5-9:
Error: Syntax error
</code></pre>
<p>The above code is efficient with memory, but it can be inconvenient in
other ways. Since <code>input_line</code> only works with the <code>in_channel</code> type, it
cannot be reused in cases where the text is already in memory. The
<code>End_of_file</code> exception can be raised at any point during iteration, and
it is the programmer's responsibility to ensure that the file is closed
appropriately. In fact, if there is any other exception in the above
example, the file will not be closed at all. Altogether, there is a lot
going on: channels, I/O, exceptions, and files.</p>
<p>Streams offer an abstraction over one part of this process: reading
items from a sequence. They don't assume anything about files or
channels, and they replace the <code>End_of_file</code> exception with a more
structured approach to dealing with the end of input. Here is a function
that builds a stream of lines from an input channel:</p>
<pre><code class="language-ocaml"># let line_stream_of_channel channel =
  Stream.from
    (fun _ -&gt;
       try Some (input_line channel) with End_of_file -&gt; None)
val line_stream_of_channel : in_channel -&gt; string Stream.t = &lt;fun&gt;
</code></pre>
<p>The &quot;Stream.from&quot; function builds a stream from a callback function.
This function is passed the current stream count (starting with 0) as an
argument and is expected to return an <code>'a option</code>. If the option has a
value (<code>Some x</code>), that value will be the next item in the stream. If it
has no value (<code>None</code>), this indicates that the stream is empty and no
further reads will be attempted. Since the option is polymorphic,
<code>Stream.from</code> can construct streams of any type. These streams have a
type of <code>'a Stream.t</code>.</p>
<p>With this simple function, we can now easily construct line streams from
any input channel:</p>
<pre><code class="language-ocaml"># let in_channel = open_in &quot;019_streams.md&quot;
val in_channel : in_channel = &lt;abstr&gt;
# let lines = line_stream_of_channel in_channel
val lines : string Stream.t = &lt;abstr&gt;
</code></pre>
<p>This variable <code>lines</code> is a stream of strings, one string per line. We
can now begin reading lines from it by passing it to <code>Stream.next</code>:</p>
<pre><code class="language-ocaml"># Stream.next lines
- : string = &quot;---&quot;
# Stream.next lines
- : string = &quot;title: Streams&quot;
# Stream.next lines
- : string = &quot;description: &gt;&quot;
# Stream.next lines
- : string =
&quot;  Streams offer an abstraction over consuming items from sequences&quot;
# while true do ignore(Stream.next lines) done
Exception: Stdlib.Stream.Failure.
</code></pre>
<p>As you can see, <code>Stream.next</code> either returns the next item in the stream
or raises a <code>Stream.Failure</code> exception indicating that the stream is
empty. Likewise, with a little help from the <code>Stream.of_list</code>
constructor and the <code>Str</code> regular expression module, we could build a
stream of lines from a string in memory:</p>
<pre><code class="language-ocaml"># #load &quot;str.cma&quot;
# let line_stream_of_string string =
  Stream.of_list (Str.split (Str.regexp &quot;\\n&quot;) string)
val line_stream_of_string : string -&gt; string Stream.t = &lt;fun&gt;
</code></pre>
<p>and these streams could be used exactly the same way:</p>
<pre><code class="language-ocaml"># let lines = line_stream_of_string &quot;hello\\nstream\\nworld&quot;
val lines : string Stream.t = &lt;abstr&gt;
# Stream.next lines
- : string = &quot;hello&quot;
# Stream.next lines
- : string = &quot;stream&quot;
# Stream.next lines
- : string = &quot;world&quot;
# Stream.next lines
Exception: Stdlib.Stream.Failure.
</code></pre>
<p>Since both cases raise <code>Stream.Failure</code> on an empty stream, there is no
need to worry about catching <code>End_of_file</code> in the case of file I/O. This
unified interface makes it much easier to write functions that can
receive data from multiple sources.</p>
<p>The <code>Stream.iter</code> function automates the common task of performing an
operation for each item. With it, we can rewrite the original example as
follows:</p>
<pre><code class="language-ocaml">let in_channel = open_in &quot;019_streams.md&quot; in
try
  Stream.iter
    (fun line -&gt;
       (* do something with line *)
       print_endline line)
    (line_stream_of_channel in_channel);
  close_in in_channel
with e -&gt;
  close_in in_channel;
  raise e
</code></pre>
<p>Note how much easier it is to handle I/O exceptions properly, since we
can deal with them independently from the end-of-file condition. This
separation of concerns allows us to decompose this into simpler and more
reusable functions:</p>
<pre><code class="language-ocaml"># let process_line line =
  print_endline line
val process_line : string -&gt; unit = &lt;fun&gt;

# let process_lines lines =
  Stream.iter process_line lines
val process_lines : string Stream.t -&gt; unit = &lt;fun&gt;

# let process_file filename =
  let in_channel = open_in filename in
  try
    process_lines (line_stream_of_channel in_channel);
    close_in in_channel
  with e -&gt;
    close_in in_channel;
    raise e
val process_file : string -&gt; unit = &lt;fun&gt;

# let process_string string =
  process_lines (line_stream_of_string string)
val process_string : string -&gt; unit = &lt;fun&gt;
</code></pre>
<h2 id="constructing-streams">Constructing streams</h2>
<p>In the above examples, we saw two methods for constructing streams:</p>
<ul>
<li>Stream.from, which builds a stream from a callback function
</li>
<li>Stream.of_list, which builds a stream from a list in memory
</li>
</ul>
<p>The <code>Stream</code> module provides a few other stream builders:</p>
<ul>
<li>Stream.of_string, which builds a character stream from a string
</li>
<li>Stream.of_channel, which builds a character stream from a channel
</li>
</ul>
<p><code>Stream.from</code> is the most general, and it can be used to produce streams
of any type. It is not limited to I/O and can even produce infinite
sequences. Here are a few simple stream builders defined with
<code>Stream.from</code>:</p>
<pre><code class="language-ocaml"># let empty_stream () = Stream.from (fun _ -&gt; None)
val empty_stream : unit -&gt; 'a Stream.t = &lt;fun&gt;
# let const_stream k = Stream.from (fun _ -&gt; Some k)
val const_stream : 'a -&gt; 'a Stream.t = &lt;fun&gt;
# let count_stream i = Stream.from (fun j -&gt; Some (i + j))
val count_stream : int -&gt; int Stream.t = &lt;fun&gt;
</code></pre>
<h2 id="deconstructing-streams">Deconstructing streams</h2>
<p>We already saw the <code>Stream.next</code> function, which retrieves a single item
from a stream. There is another way to work with streams that is often
preferable: <code>Stream.peek</code> and <code>Stream.junk</code>. When used together, these
functions allow you to see what the next item would be. This feature,
known as &quot;look ahead&quot;, is very useful when writing parsers. Even if you
don't need to look ahead, the peek/junk protocol may be nicer to work
with because it uses options instead of exceptions:</p>
<pre><code class="language-ocaml"># let lines = line_stream_of_string &quot;hello\\nworld&quot;
val lines : string Stream.t = &lt;abstr&gt;
# Stream.peek lines
- : string option = Some &quot;hello&quot;
# Stream.peek lines
- : string option = Some &quot;hello&quot;
# Stream.junk lines
- : unit = ()
# Stream.peek lines
- : string option = Some &quot;world&quot;
# Stream.junk lines
- : unit = ()
# Stream.peek lines
- : string option = None
</code></pre>
<p>As you can see, it is necessary to call <code>Stream.junk</code> to advance to the
next item. <code>Stream.peek</code> will always give you either the next item or
<code>None</code>, and it will never fail. Likewise, <code>Stream.junk</code> always succeeds
(even if the stream is empty).</p>
<h2 id="a-more-complex-streamfrom-example">A more complex <code>Stream.from</code> example</h2>
<p>Here is a function that converts a line stream into a paragraph stream.
As such, it is both a stream consumer and a stream producer.</p>
<pre><code class="language-ocaml"># let paragraphs lines =
  let rec next para_lines i =
    match Stream.peek lines, para_lines with
    | None, [] -&gt; None
    | Some &quot;&quot;, [] -&gt;
        Stream.junk lines;
        next para_lines i
    | Some &quot;&quot;, _ | None, _ -&gt;
        Some (String.concat &quot;\\n&quot; (List.rev para_lines))
    | Some line, _ -&gt;
        Stream.junk lines;
        next (line :: para_lines) i in
  Stream.from (next [])
val paragraphs : string Stream.t -&gt; string Stream.t = &lt;fun&gt;
</code></pre>
<p>This function uses an extra parameter to <code>next</code> (the <code>Stream.from</code>
callback) called <code>para_lines</code> in order to collect the lines for each
paragraph. Paragraphs are delimited by any number of blank lines.</p>
<p>Each time <code>next</code> is called, a <code>match</code> expression tests two values: the
next line in the stream, and the contents of <code>para_lines</code>. Four cases
are handled:</p>
<ol>
<li>If the end of the stream is reached and no lines have been
collected, the paragraph stream ends as well.
</li>
<li>If the next line is blank and no lines have been collected, the
blank is ignored and <code>next</code> is called recursively to keep looking
for a non-blank line.
</li>
<li>If a blank line or end of stream is reached and lines <strong>have</strong> been
collected, the paragraph is returned by concatenating <code>para_lines</code>
to a single string.
</li>
<li>Finally, if a non-blank line has been reached, the line is collected
by recursively calling <code>para_lines</code>.
</li>
</ol>
<p>Happily, we can rely on the OCaml compiler's exhaustiveness checking to
ensure that we are handling all possible cases.</p>
<p>With this new tool, we can now work just as easily with paragraphs as we
could before with lines:</p>
<pre><code class="language-ocaml">(* Print each paragraph, followed by a separator. *)
let lines = line_stream_of_channel in_channel in
Stream.iter
  (fun para -&gt;
     print_endline para;
     print_endline &quot;--&quot;)
  (paragraphs lines)
</code></pre>
<p>Functions like <code>paragraphs</code> that produce and consume streams can be
composed together in a manner very similar to UNIX pipes and filters.</p>
<h2 id="stream-combinators">Stream combinators</h2>
<p>Just like lists and arrays, common iteration patterns such as <code>map</code>,
<code>filter</code>, and <code>fold</code> can be very useful. The <code>Stream</code> module does not
provide such functions, but they can be built easily using
<code>Stream.from</code>:</p>
<pre><code class="language-ocaml"># let stream_map f stream =
  let rec next i =
    try Some (f (Stream.next stream))
    with Stream.Failure -&gt; None in
  Stream.from next
val stream_map : ('a -&gt; 'b) -&gt; 'a Stream.t -&gt; 'b Stream.t = &lt;fun&gt;

# let stream_filter p stream =
  let rec next i =
    try
      let value = Stream.next stream in
      if p value then Some value else next i
    with Stream.Failure -&gt; None in
  Stream.from next
val stream_filter : ('a -&gt; bool) -&gt; 'a Stream.t -&gt; 'a Stream.t = &lt;fun&gt;

# let stream_fold f stream init =
  let result = ref init in
  Stream.iter
    (fun x -&gt; result := f x !result)
    stream;
  !result
val stream_fold : ('a -&gt; 'b -&gt; 'b) -&gt; 'a Stream.t -&gt; 'b -&gt; 'b = &lt;fun&gt;
</code></pre>
<p>For example, here is a stream of leap years starting with 2000:</p>
<pre><code class="language-ocaml"># let is_leap year =
  year mod 4 = 0 &amp;&amp; (year mod 100 &lt;&gt; 0 || year mod 400 = 0)
val is_leap : int -&gt; bool = &lt;fun&gt;
# let leap_years = stream_filter is_leap (count_stream 2000)
val leap_years : int Stream.t = &lt;abstr&gt;
</code></pre>
<p>We can use the <code>Stream.npeek</code> function to look ahead by more than one
item. In this case, we'll peek at the next 30 items to make sure that
the year 2100 is not a leap year (since it's divisible by 100 but not
400!):</p>
<pre><code class="language-ocaml"># Stream.npeek 30 leap_years
- : int list =
[2000; 2004; 2008; 2012; 2016; 2020; 2024; 2028; 2032; 2036; 2040; 2044;
 2048; 2052; 2056; 2060; 2064; 2068; 2072; 2076; 2080; 2084; 2088; 2092;
 2096; 2104; 2108; 2112; 2116; 2120]
</code></pre>
<p>Note that we must be careful not to use <code>Stream.iter</code> on an infinite
stream like <code>leap_years</code>. This applies to <code>stream_fold</code>, as well as any
function that attempts to consume the entire stream.</p>
<pre><code class="language-ocaml"># stream_fold (+) (Stream.of_list [1; 2; 3]) 0
- : int = 6
</code></pre>
<p><code>stream_fold (+) (count_stream 0) 0</code> runs forever.</p>
<h2 id="other-useful-stream-builders">Other useful stream builders</h2>
<p>The previously defined <code>const_stream</code> function builds a stream that
repeats a single value. It is also useful to build a stream that repeats
a sequence of values. The following function does just that:</p>
<pre><code class="language-ocaml"># let cycle items =
  let buf = ref [] in
  let rec next i =
    if !buf = [] then buf := items;
    match !buf with
      | h :: t -&gt; (buf := t; Some h)
      | [] -&gt; None in
  Stream.from next
val cycle : 'a list -&gt; 'a Stream.t = &lt;fun&gt;
</code></pre>
<p>One common task that can benefit from this kind of stream is the
generation of alternating background colors for HTML. By using <code>cycle</code>
with <code>stream_combine</code>, explained in the next section, an infinite stream
of background colors can be combined with a finite stream of data to
produce a sequence of HTML blocks:</p>
<pre><code class="language-ocaml"># let stream_combine stream1 stream2 =
  let rec next i =
    try Some (Stream.next stream1, Stream.next stream2)
    with Stream.Failure -&gt; None in
  Stream.from next
val stream_combine : 'a Stream.t -&gt; 'b Stream.t -&gt; ('a * 'b) Stream.t = &lt;fun&gt;
# Stream.iter print_endline
  (stream_map
     (fun (bg, s) -&gt;
        Printf.sprintf &quot;&lt;div style='background: %s'&gt;%s&lt;/div&gt;&quot; bg s)
     (stream_combine
        (cycle [&quot;#eee&quot;; &quot;#fff&quot;])
        (Stream.of_list [&quot;hello&quot;; &quot;html&quot;; &quot;world&quot;])))
&lt;div style='background: #eee'&gt;hello&lt;/div&gt;
&lt;div style='background: #fff'&gt;html&lt;/div&gt;
&lt;div style='background: #eee'&gt;world&lt;/div&gt;
- : unit = ()
</code></pre>
<p>Here is a simple <code>range</code> function that produces a sequence of integers:</p>
<pre><code class="language-ocaml"># let range ?(start=0) ?(stop=0) ?(step=1) () =
  let in_range = if step &lt; 0 then (&gt;) else (&lt;) in
  let current = ref start in
  let rec next i =
    if in_range !current stop
    then let result = !current in (current := !current + step;
                                   Some result)
    else None in
  Stream.from next
val range : ?start:int -&gt; ?stop:int -&gt; ?step:int -&gt; unit -&gt; int Stream.t =
  &lt;fun&gt;
</code></pre>
<p>This works just like Python's <code>xrange</code> built-in function, providing an
easy way to produce an assortment of lazy integer sequences by
specifying combinations of <code>start</code>, <code>stop</code>, or <code>step</code> values:</p>
<pre><code class="language-ocaml"># Stream.npeek 10 (range ~start:5 ~stop:10 ())
- : int list = [5; 6; 7; 8; 9]
# Stream.npeek 10 (range ~stop:10 ~step:2 ())
- : int list = [0; 2; 4; 6; 8]
# Stream.npeek 10 (range ~start:10 ~step:(-1) ())
- : int list = [10; 9; 8; 7; 6; 5; 4; 3; 2; 1]
# Stream.npeek 10 (range ~start:10 ~stop:5 ~step:(-1) ())
- : int list = [10; 9; 8; 7; 6]
</code></pre>
<h2 id="combining-streams">Combining streams</h2>
<p>There are several ways to combine streams. One is to produce a stream of
streams and then concatenate them into a single stream. The following
function works just like <code>List.concat</code>, but instead of turning a list of
lists into a list, it turns a stream of streams into a stream:</p>
<pre><code class="language-ocaml"># let stream_concat streams =
  let current_stream = ref None in
  let rec next i =
    try
      let stream =
        match !current_stream with
        | Some stream -&gt; stream
        | None -&gt;
           let stream = Stream.next streams in
           current_stream := Some stream;
           stream in
      try Some (Stream.next stream)
      with Stream.Failure -&gt; (current_stream := None; next i)
    with Stream.Failure -&gt; None in
  Stream.from next
val stream_concat : 'a Stream.t Stream.t -&gt; 'a Stream.t = &lt;fun&gt;
</code></pre>
<p>Here is a sequence of ranges which are themselves derived from a range,
concatenated with <code>stream_concat</code> to produce a flattened <code>int Stream.t</code>.</p>
<pre><code class="language-ocaml"># Stream.npeek 10
  (stream_concat
     (stream_map
        (fun i -&gt; range ~stop:i ())
        (range ~stop:5 ())))
- : int list = [0; 0; 1; 0; 1; 2; 0; 1; 2; 3]
</code></pre>
<p>Another way to combine streams is to iterate through them in a pairwise
fashion:</p>
<pre><code class="language-ocaml"># let stream_combine stream1 stream2 =
  let rec next i =
    try Some (Stream.next stream1, Stream.next stream2)
    with Stream.Failure -&gt; None in
  Stream.from next
val stream_combine : 'a Stream.t -&gt; 'b Stream.t -&gt; ('a * 'b) Stream.t = &lt;fun&gt;
</code></pre>
<p>This is useful, for instance, if you have a stream of keys and a stream
of corresponding values. Iterating through key value pairs is then as
simple as:</p>
<pre><code class="language-ocaml">Stream.iter
  (fun (key, value) -&gt;
     (* do something with 'key' and 'value' *)
     ())
  (stream_combine key_stream value_stream)
</code></pre>
<pre><code class="language-mdx-error">Line 5, characters 21-31:
Error: Unbound value key_stream
</code></pre>
<p>Since <code>stream_combine</code> stops as soon as either of its input streams runs
out, it can be used to combine an infinite stream with a finite one.
This provides a neat way to add indexes to a sequence:</p>
<pre><code class="language-ocaml"># let items = [&quot;this&quot;; &quot;is&quot;; &quot;a&quot;; &quot;test&quot;]
val items : string list = [&quot;this&quot;; &quot;is&quot;; &quot;a&quot;; &quot;test&quot;]
# Stream.iter
  (fun (index, value) -&gt;
     Printf.printf &quot;%d. %s\\n%!&quot; index value)
  (stream_combine (count_stream 1) (Stream.of_list items))
1. this
2. is
3. a
4. test
- : unit = ()
</code></pre>
<h2 id="copying-streams">Copying streams</h2>
<p>Streams are destructive; once you discard an item in a stream, it is no
longer available unless you save a copy somewhere. What if you want to
use the same stream more than once? One way is to create a &quot;tee&quot;. The
following function creates two output streams from one input stream,
intelligently queueing unseen values until they have been produced by
both streams:</p>
<pre><code class="language-ocaml"># let stream_tee stream =
  let next self other i =
    try
      if Queue.is_empty self
      then
        let value = Stream.next stream in
        Queue.add value other;
        Some value
      else
        Some (Queue.take self)
    with Stream.Failure -&gt; None in
  let q1 = Queue.create () in
  let q2 = Queue.create () in
  (Stream.from (next q1 q2), Stream.from (next q2 q1))
val stream_tee : 'a Stream.t -&gt; 'a Stream.t * 'a Stream.t = &lt;fun&gt;
</code></pre>
<p>Here is an example of a stream tee in action:</p>
<pre><code class="language-ocaml"># let letters = Stream.of_list ['a'; 'b'; 'c'; 'd'; 'e']
val letters : char Stream.t = &lt;abstr&gt;
# let s1, s2 = stream_tee letters
val s1 : char Stream.t = &lt;abstr&gt;
val s2 : char Stream.t = &lt;abstr&gt;
# Stream.next s1
- : char = 'a'
# Stream.next s1
- : char = 'b'
# Stream.next s2
- : char = 'a'
# Stream.next s1
- : char = 'c'
# Stream.next s2
- : char = 'b'
# Stream.next s2
- : char = 'c'
</code></pre>
<p>Again, since streams are destructive, you probably want to leave the
original stream alone or you will lose items from the copied streams:</p>
<pre><code class="language-ocaml"># Stream.next letters
- : char = 'd'
# Stream.next s1
- : char = 'e'
# Stream.next s2
- : char = 'e'
</code></pre>
<h2 id="converting-streams">Converting streams</h2>
<p>Here are a few functions for converting between streams and lists,
arrays, and hash tables. These probably belong in the standard library,
but they are simple to define anyhow. Again, beware of infinite streams,
which will cause these functions to hang.</p>
<pre><code class="language-ocaml"># let stream_of_list = Stream.of_list
val stream_of_list : 'a list -&gt; 'a Stream.t = &lt;fun&gt;
# let list_of_stream stream =
  let result = ref [] in
  Stream.iter (fun value -&gt; result := value :: !result) stream;
  List.rev !result
val list_of_stream : 'a Stream.t -&gt; 'a list = &lt;fun&gt;
# let stream_of_array array =
  Stream.of_list (Array.to_list array)
val stream_of_array : 'a array -&gt; 'a Stream.t = &lt;fun&gt;
# let array_of_stream stream =
  Array.of_list (list_of_stream stream)
val array_of_stream : 'a Stream.t -&gt; 'a array = &lt;fun&gt;
# let stream_of_hash hash =
  let result = ref [] in
  Hashtbl.iter
    (fun key value -&gt; result := (key, value) :: !result)
    hash;
  Stream.of_list !result
val stream_of_hash : ('a, 'b) Hashtbl.t -&gt; ('a * 'b) Stream.t = &lt;fun&gt;
# let hash_of_stream stream =
  let result = Hashtbl.create 0 in
  Stream.iter
    (fun (key, value) -&gt; Hashtbl.replace result key value)
    stream;
  result
val hash_of_stream : ('a * 'b) Stream.t -&gt; ('a, 'b) Hashtbl.t = &lt;fun&gt;
</code></pre>
<p>What if you want to convert arbitrary data types to streams? Well, if the
data type defines an <code>iter</code> function, and you don't mind using threads,
you can use a producer-consumer arrangement to invert control:</p>
<pre><code class="language-ocaml"># #directory &quot;+threads&quot;;;
# #load &quot;threads.cma&quot;;;
# let elements iter coll =
  let channel = Event.new_channel () in
  let producer () =
    let () =
      iter (fun x -&gt; Event.sync (Event.send channel (Some x))) coll in
    Event.sync (Event.send channel None) in
  let consumer i =
    Event.sync (Event.receive channel) in
  ignore (Thread.create producer ());
  Stream.from consumer
val elements : (('a -&gt; unit) -&gt; 'b -&gt; unit) -&gt; 'b -&gt; 'a Stream.t = &lt;fun&gt;
</code></pre>
<p>Now it is possible to build a stream from an <code>iter</code> function and a
corresponding value:</p>
<pre><code class="language-ocaml"># module StringSet = Set.Make(String)
module StringSet :
  sig
    type elt = string
    type t = Set.Make(String).t
    val empty : t
    val is_empty : t -&gt; bool
    val mem : elt -&gt; t -&gt; bool
    val add : elt -&gt; t -&gt; t
    val singleton : elt -&gt; t
    val remove : elt -&gt; t -&gt; t
    val union : t -&gt; t -&gt; t
    val inter : t -&gt; t -&gt; t
    val disjoint : t -&gt; t -&gt; bool
    val diff : t -&gt; t -&gt; t
    val compare : t -&gt; t -&gt; int
    val equal : t -&gt; t -&gt; bool
    val subset : t -&gt; t -&gt; bool
    val iter : (elt -&gt; unit) -&gt; t -&gt; unit
    val map : (elt -&gt; elt) -&gt; t -&gt; t
    val fold : (elt -&gt; 'a -&gt; 'a) -&gt; t -&gt; 'a -&gt; 'a
    val for_all : (elt -&gt; bool) -&gt; t -&gt; bool
    val exists : (elt -&gt; bool) -&gt; t -&gt; bool
    val filter : (elt -&gt; bool) -&gt; t -&gt; t
    val partition : (elt -&gt; bool) -&gt; t -&gt; t * t
    val cardinal : t -&gt; int
    val elements : t -&gt; elt list
    val min_elt : t -&gt; elt
    val min_elt_opt : t -&gt; elt option
    val max_elt : t -&gt; elt
    val max_elt_opt : t -&gt; elt option
    val choose : t -&gt; elt
    val choose_opt : t -&gt; elt option
    val split : elt -&gt; t -&gt; t * bool * t
    val find : elt -&gt; t -&gt; elt
    val find_opt : elt -&gt; t -&gt; elt option
    val find_first : (elt -&gt; bool) -&gt; t -&gt; elt
    val find_first_opt : (elt -&gt; bool) -&gt; t -&gt; elt option
    val find_last : (elt -&gt; bool) -&gt; t -&gt; elt
    val find_last_opt : (elt -&gt; bool) -&gt; t -&gt; elt option
    val of_list : elt list -&gt; t
    val to_seq_from : elt -&gt; t -&gt; elt Seq.t
    val to_seq : t -&gt; elt Seq.t
    val add_seq : elt Seq.t -&gt; t -&gt; t
    val of_seq : elt Seq.t -&gt; t
  end
# let set = StringSet.empty
val set : StringSet.t = &lt;abstr&gt;
# let set = StringSet.add &quot;here&quot; set
val set : StringSet.t = &lt;abstr&gt;
# let set = StringSet.add &quot;are&quot; set
val set : StringSet.t = &lt;abstr&gt;
# let set = StringSet.add &quot;some&quot; set
val set : StringSet.t = &lt;abstr&gt;
# let set = StringSet.add &quot;values&quot; set
val set : StringSet.t = &lt;abstr&gt;
# let stream = elements StringSet.iter set
val stream : string Stream.t = &lt;abstr&gt;
# Stream.iter print_endline stream
are
here
some
values
- : unit = ()
</code></pre>
<p>Some data types, like Hashtbl and Map, provide an <code>iter</code> function that
iterates through key-value pairs. Here's a function for those, too:</p>
<pre><code class="language-ocaml"># let items iter coll =
  let channel = Event.new_channel () in
  let producer () =
    let () =
      iter (fun k v -&gt;
              Event.sync (Event.send channel (Some (k, v)))) coll in
    Event.sync (Event.send channel None) in
  let consumer i =
    Event.sync (Event.receive channel) in
  ignore (Thread.create producer ());
  Stream.from consumer
val items : (('a -&gt; 'b -&gt; unit) -&gt; 'c -&gt; unit) -&gt; 'c -&gt; ('a * 'b) Stream.t =
  &lt;fun&gt;
</code></pre>
<p>If we want just the keys, or just the values, it is simple to transform
the output of <code>items</code> using <code>stream_map</code>:</p>
<pre><code class="language-ocaml"># let keys iter coll = stream_map (fun (k, v) -&gt; k) (items iter coll)
val keys : (('a -&gt; 'b -&gt; unit) -&gt; 'c -&gt; unit) -&gt; 'c -&gt; 'a Stream.t = &lt;fun&gt;
# let values iter coll = stream_map (fun (k, v) -&gt; v) (items iter coll)
val values : (('a -&gt; 'b -&gt; unit) -&gt; 'c -&gt; unit) -&gt; 'c -&gt; 'b Stream.t = &lt;fun&gt;
</code></pre>
<p>Keep in mind that these techniques spawn producer threads which carry a
few risks: they only terminate when they have finished iterating, and
any change to the original data structure while iterating may produce
unexpected results.</p>
<h2 id="other-built-in-stream-functions">Other built-in Stream functions</h2>
<p>There are a few other documented methods in the <code>Stream</code> module:</p>
<ul>
<li>Stream.empty, which raises <code>Stream.Failure</code> unless a stream is empty
</li>
<li>Stream.count, which returns the stream count (number of discarded
elements)
</li>
</ul>
<p>In addition, there are a few undocumented functions: <code>iapp</code>, <code>icons</code>,
<code>ising</code>, <code>lapp</code>, <code>lcons</code>, <code>lsing</code>, <code>sempty</code>, <code>slazy</code>, and <code>dump</code>. They
are visible in the interface with the caveat: &quot;For system use only, not
for the casual user&quot;.</p>
|js}
  };
 
  { title = {js|Format|js}
  ; slug = {js|format|js}
  ; description = {js|The Format module of Caml Light and OCaml's standard libraries provides pretty-printing facilities to get a fancy display for printing routines
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["stdlib"; "common"]
  ; users = [`Intermediate]
  ; body_md = {js|
The `Format` module of Caml Light and OCaml's standard libraries
provides pretty-printing facilities to get a fancy display for printing
routines. This module implements a “pretty-printing engine” that is
intended to break lines in a nice way (let's say “automatically when it
is necessary”).

## Principles
Line breaking is based on three concepts:

* **boxes**: a box is a logical pretty-printing unit, which defines a
 behaviour of the pretty-printing engine to display the material
 inside the box.
* **break hints**: a break hint is a directive to the pretty-printing
 engine that proposes to break the line here, if it is necessary to
 properly print the rest of the material. Otherwise, the
 pretty-printing engine never break lines (except “in case of
 emergency” to avoid very bad output). In short, a break hint tells
 the pretty printer that a line break here may be appropriate.
* **Indentation rules**: When a line break occurs, the pretty-printing
 engines fixes the indentation (or amount of leading spaces) of the
 new line using indentation rules, as follows:
    * A box can state the extra indentation of every new line opened
 in its scope. This extra indentation is named **box breaking
 indentation**.
    * A break hint can also set the additional indentation of the new
 line it may fire. This extra indentation is named **hint
 breaking indentation**.
    * If break hint `bh` fires a new line within box `b`, then the
 indentation of the new line is simply the sum of: the current
 indentation of box `b` `+` the additional box breaking
 indentation, as defined by box `b` `+` the additional hint
 breaking indentation, as defined by break hint `bh`.

## Boxes
There are 4 types of boxes. (The most often used is the “hov” box type,
so skip the rest at first reading).

* **horizontal box** (*h* box, as obtained by the `open_hbox`
 procedure): within this box, break hints do not lead to line breaks.
* **vertical box** (*v* box, as obtained by the `open_vbox`
 procedure): within this box, every break hint lead to a new line.
* **vertical/horizontal box** (*hv* box, as obtained by the
 `open_hvbox` procedure): if it is possible, the entire box is
 written on a single line; otherwise, every break hint within the box
 leads to a new line.
* **vertical or horizontal box** (*hov* box, as obtained by the
 open_box or open_hovbox procedures): within this box, break hints
 are used to cut the line when there is no more room on the line.
 There are two kinds of “hov” boxes, you can find the details
 [below](#Refinementonhovboxes). In first approximation, let me consider these
 two kinds of “hov” boxes as equivalent and obtained by calling the
 `open_box` procedure.

Let me give an example. Suppose we can write 10 chars before the right
margin (that indicates no more room). We represent any char as a `-`
sign; characters `[` and `]` indicates the opening and closing of a box
and `b` stands for a break hint given to the pretty-printing engine.

The output "--b--b--" is displayed like this (the b symbol stands for
the value of the break that is explained below):

* within a “h” box:

    ```text
    --b--b--
    ```

* within a “v” box:

    ```text
    --b
    --b
    --
    ```

* within a “hv” box:

    If there is enough room to print the box on the line:

    ```text
    --b--b--
    ```
    But "---b---b---" that cannot fit on the line is written

    ```text
    ---b
    ---b
    ---
    ```

* within a “hov” box:

    If there is enough room to print the box on the line:

    ```text
    --b--b--
    ```
    But if "---b---b---" cannot fit on the line, it is written as

    ```text
    ---b---b
    ---
    ```
    The first break hint does not lead to a new line, since there is
    enough room on the line. The second one leads to a new line since
    there is no more room to print the material following it. If the
    room left on the line were even shorter, the first break hint may
    lead to a new line and "---b---b---" is written as:

    ```text
    ---b
    ---b
    ---
    ```


## Printing spaces
Break hints are also used to output spaces (if the line is not split
when the break is encountered, otherwise the new line indicates properly
the separation between printing items). You output a break hint using
`print_break sp indent`, and this `sp` integer is used to print “sp”
spaces. Thus `print_break sp ...` may be thought as: print `sp` spaces
or output a new line.

For instance, if b is `break 1 0` in the output "--b--b--", we get

* within a “h” box:

    ```text
    -- -- --
    ```

* within a “v” box:

    ```text
    --
    --
    --
    ```

* within a “hv” box:

    ```text
    -- -- --
    ```
    or, according to the remaining room on the line:

    ```text
    --
    --
    --
    ```

* and similarly for “hov” boxes.

Generally speaking, a printing routine using "format", should not
directly output white spaces: the routine should use break hints
instead. (For instance `print_space ()` that is a convenient
abbreviation for `print_break 1 0` and outputs a single space or break
the line.)


## Indentation of new lines
The user gets 2 ways to fix the indentation of new lines:

* **when defining the box**: when you open a box, you can fix the
 indentation added to each new line opened within that box.<br />
 For instance: `open_hovbox 1` opens a “hov” box with new lines
 indented 1 more than the initial indentation of the box. With output
 "---[--b--b--b--", we get:

    ```text
    ---[--b--b
         --b--
    ```
    with `open_hovbox 2`, we get

    ```text
    ---[--b--b
          --b--
    ```
    Note: the `[` sign in the display is not visible on the screen, it
    is just there to materialise the aperture of the pretty-printing
    box. Last “screen” stands for:

    ```text
    -----b--b
         --b--
    ```

* **when defining the break that makes the new line**. As said above,
 you output a break hint using `print_break     sp           indent`.
 The `indent` integer is used to fix the additional indentation of
 the new line. Namely, it is added to the default indentation offset
 of the box where the break occurs.<br />
 For instance, if `[` stands for the opening of a “hov” box with 1
 as extra indentation (as obtained by `open_hovbox 1`), and b is
 `print_break       1       2`, then from output "---[--b--b--b--",
 we get:

    ```text
    ---[-- --
          --
          --
    ```


## Refinement on “hov” boxes
###  Packing and structural “hov” boxes

The “hov” box type is refined into two categories.

* **the vertical or horizontal *packing* box** (as obtained by the
 open_hovbox procedure): break hints are used to cut the line when
 there is no more room on the line; no new line occurs if there is
 enough room on the line.
* **vertical or horizontal *structural* box** (as obtained by the
 open_box procedure): similar to the “hov” packing box, the break
 hints are used to cut the line when there is no more room on the
 line; in addition, break hints that can show the box structure lead
 to new lines even if there is enough room on the current line.

###  Differences between a packing and a structural “hov” box
The difference between a packing and a structural “hov” box is shown by
a routine that closes boxes and parentheses at the end of printing: with
packing boxes, the closure of boxes and parentheses do not lead to new
lines if there is enough room on the line, whereas with structural boxes
each break hint will lead to a new line. For instance, when printing
`[(---[(----[(---b)]b)]b)]`, where `b` is a break hint without extra
indentation (`print_cut ()`). If `[` means opening of a packing “hov”
box (open_hovbox), `[(---[(----[(---b)]b)]b)]` is printed as follows:

```text
(---
 (----
  (---)))
```
If we replace the packing boxes by structural boxes (open_box), each
break hint that precedes a closing parenthesis can show the boxes
structure, if it leads to a new line; hence `[(---[(----[(---b)]b)]b)]`
is printed like this:

```text
(---
 (----
  (---
  )
 )
)
```

## Practical advice

When writing a pretty-printing routine, follow these simple rules:

1. Boxes must be opened and closed consistently (`open_*` and
 `close_box` must be nested like parentheses).
1. Never hesitate to open a box.
1. Output many break hints, otherwise the pretty-printer is in a bad
 situation where it tries to do its best, which is always “worse than
 your bad”.
1. Do not try to force spacing using explicit spaces in the character
 strings. For each space you want in the output emit a break hint
 (`print_space ()`), unless you explicitly don't want the line to be
 broken here. For instance, imagine you want to pretty print an OCaml
 definition, more precisely a `let rec ident =     expression` value
 definition. You will probably treat the first three spaces as
 “unbreakable spaces” and write them directly in the string constants
 for keywords, and print `"let rec "` before the identifier, and
 similarly write ` =` to get an unbreakable space after the
 identifier; in contrast, the space after the `=` sign is certainly a
 break hint, since breaking the line after `=` is a usual (and
 elegant) way to indent the expression part of a definition. In
 short, it is often necessary to print unbreakable spaces; however,
 most of the time a space should be considered a break hint.
1. Do not try to force new lines, let the pretty-printer do it for you:
 that's its only job. In particular, do not use `force_newline`: this
 procedure effectively leads to a newline, but it also as the
 unfortunate side effect to partially reinitialise the
 pretty-printing engine, so that the rest of the printing material is
 noticeably messed up.
1. Never put newline characters directly in the strings to be printed:
 pretty printing engine will consider this newline character as any
 other character written on the current line and this will completely
 mess up the output. Instead of new line characters use line break
 hints: if those break hints must always result in new lines, it just
 means that the surrounding box must be a vertical box!
1. End your main program by a `print_newline ()` call, that flushes the
 pretty-printer tables (hence the output). (Note that the top-level
 loop of the interactive system does it as well, just before a new
 input.)

## Printing to `stdout`: using `printf`
The `format` module provides a general printing facility “à la”
`printf`. In addition to the usual conversion facility provided by
`printf`, you can write pretty-printing indications directly inside the
format string (opening and closing boxes, indicating breaking hints,
etc).

Pretty-printing annotations are introduced by the `@` symbol, directly
into the string format. Almost any function of the `format` module can
be called from within a `printf` format string. For instance

* “`@[`” open a box (`open_box     0`). You may precise the type as an
 extra argument. For instance `@[<hov n>` is equivalent to
 `open_hovbox       n`.
* “`@]`” close a box (`close_box       ()`).
* “`@` ” output a breakable space (`print_space ()`).
* “`@,`” output a break hint (`print_cut       ()`).
* “`@;<n m>`” emit a “full” break hint (`print_break n m`).
* “`@.`” end the pretty-printing, closing all the boxes still opened
 (`print_newline ()`).

For instance

```ocaml
# Format.printf "@[<1>%s@ =@ %d@ %s@]@." "Prix TTC" 100 "Euros"
Prix TTC = 100 Euros
- : unit = ()
```

## A concrete example

Let me give a full example: the shortest non trivial example you could
imagine, that is the λ-calculus. :)

Thus the problem is to pretty-print the values of a concrete data type
that models a language of expressions that defines functions and their
applications to arguments.

First, I give the abstract syntax of lambda-terms (we illustrate it in
the [interactive system](../description.html#Interactivity)):

```ocaml
# type lambda =
  | Lambda of string * lambda
  | Var of string
  | Apply of lambda * lambda
type lambda =
    Lambda of string * lambda
  | Var of string
  | Apply of lambda * lambda
```
I use the format library to print the lambda-terms:

```ocaml
open Format
let ident = print_string
let kwd = print_string

let rec print_exp0 = function
  | Var s ->  ident s
  | lam -> open_hovbox 1; kwd "("; print_lambda lam; kwd ")"; close_box ()
and print_app = function
  | e -> open_hovbox 2; print_other_applications e; close_box ()
and print_other_applications f =
  match f with
  | Apply (f, arg) -> print_app f; print_space (); print_exp0 arg
  | f -> print_exp0 f
and print_lambda = function
  | Lambda (s, lam) ->
      open_hovbox 1;
      kwd "\\\\"; ident s; kwd "."; print_space(); print_lambda lam;
      close_box()
  | e -> print_app e
```
In Caml Light, replace the first line by:

<!-- $MDX skip -->
```ocaml
#open "format";;
```

###  Most general pretty-printing: using `fprintf`

We use the `fprintf` function to write the most versatile version of the
pretty-printing functions for lambda-terms. Now, the functions get an
extra argument, namely a pretty-printing formatter (the `ppf` argument)
where printing will occur. This way the printing routines are more
general, since they can print on any formatter defined in the program
(either printing to a file, or to `stdout`, to `stderr`, or even to a
string). Furthermore, the pretty-printing functions are now
compositional, since they may be used in conjunction with the special
`%a` conversion, that prints a `fprintf` argument with a user's supplied
function (these user's supplied functions also have a formatter as first
argument).

Using `fprintf`, the lambda-terms printing routines can be written as
follows:

```ocaml
open Format

let ident ppf s = fprintf ppf "%s" s
let kwd ppf s = fprintf ppf "%s" s

let rec pr_exp0 ppf = function
  | Var s -> fprintf ppf "%a" ident s
  | lam -> fprintf ppf "@[<1>(%a)@]" pr_lambda lam
and pr_app ppf e =
  fprintf ppf "@[<2>%a@]" pr_other_applications e
and pr_other_applications ppf f =
  match f with
  | Apply (f, arg) -> fprintf ppf "%a@ %a" pr_app f pr_exp0 arg
  | f -> pr_exp0 ppf f
and pr_lambda ppf = function
  | Lambda (s, lam) ->
     fprintf ppf "@[<1>%a%a%a@ %a@]"
             kwd "\\\\" ident s kwd "." pr_lambda lam
  | e -> pr_app ppf e
```

Given those general printing routines, procedures to print to `stdout`
or `stderr` is just a matter of partial application:

```ocaml
let print_lambda = pr_lambda std_formatter
let eprint_lambda = pr_lambda err_formatter
```
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#principles">Principles</a>
</li>
<li><a href="#boxes">Boxes</a>
</li>
<li><a href="#printing-spaces">Printing spaces</a>
</li>
<li><a href="#indentation-of-new-lines">Indentation of new lines</a>
</li>
<li><a href="#refinement-on-hov-boxes">Refinement on “hov” boxes</a>
</li>
<li><a href="#practical-advice">Practical advice</a>
</li>
<li><a href="#printing-to-stdout-using-printf">Printing to <code>stdout</code>: using <code>printf</code></a>
</li>
<li><a href="#a-concrete-example">A concrete example</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<p>The <code>Format</code> module of Caml Light and OCaml's standard libraries
provides pretty-printing facilities to get a fancy display for printing
routines. This module implements a “pretty-printing engine” that is
intended to break lines in a nice way (let's say “automatically when it
is necessary”).</p>
<h2 id="principles">Principles</h2>
<p>Line breaking is based on three concepts:</p>
<ul>
<li><strong>boxes</strong>: a box is a logical pretty-printing unit, which defines a
behaviour of the pretty-printing engine to display the material
inside the box.
</li>
<li><strong>break hints</strong>: a break hint is a directive to the pretty-printing
engine that proposes to break the line here, if it is necessary to
properly print the rest of the material. Otherwise, the
pretty-printing engine never break lines (except “in case of
emergency” to avoid very bad output). In short, a break hint tells
the pretty printer that a line break here may be appropriate.
</li>
<li><strong>Indentation rules</strong>: When a line break occurs, the pretty-printing
engines fixes the indentation (or amount of leading spaces) of the
new line using indentation rules, as follows:
<ul>
<li>A box can state the extra indentation of every new line opened
in its scope. This extra indentation is named <strong>box breaking
indentation</strong>.
</li>
<li>A break hint can also set the additional indentation of the new
line it may fire. This extra indentation is named <strong>hint
breaking indentation</strong>.
</li>
<li>If break hint <code>bh</code> fires a new line within box <code>b</code>, then the
indentation of the new line is simply the sum of: the current
indentation of box <code>b</code> <code>+</code> the additional box breaking
indentation, as defined by box <code>b</code> <code>+</code> the additional hint
breaking indentation, as defined by break hint <code>bh</code>.
</li>
</ul>
</li>
</ul>
<h2 id="boxes">Boxes</h2>
<p>There are 4 types of boxes. (The most often used is the “hov” box type,
so skip the rest at first reading).</p>
<ul>
<li><strong>horizontal box</strong> (<em>h</em> box, as obtained by the <code>open_hbox</code>
procedure): within this box, break hints do not lead to line breaks.
</li>
<li><strong>vertical box</strong> (<em>v</em> box, as obtained by the <code>open_vbox</code>
procedure): within this box, every break hint lead to a new line.
</li>
<li><strong>vertical/horizontal box</strong> (<em>hv</em> box, as obtained by the
<code>open_hvbox</code> procedure): if it is possible, the entire box is
written on a single line; otherwise, every break hint within the box
leads to a new line.
</li>
<li><strong>vertical or horizontal box</strong> (<em>hov</em> box, as obtained by the
open_box or open_hovbox procedures): within this box, break hints
are used to cut the line when there is no more room on the line.
There are two kinds of “hov” boxes, you can find the details
<a href="#Refinementonhovboxes">below</a>. In first approximation, let me consider these
two kinds of “hov” boxes as equivalent and obtained by calling the
<code>open_box</code> procedure.
</li>
</ul>
<p>Let me give an example. Suppose we can write 10 chars before the right
margin (that indicates no more room). We represent any char as a <code>-</code>
sign; characters <code>[</code> and <code>]</code> indicates the opening and closing of a box
and <code>b</code> stands for a break hint given to the pretty-printing engine.</p>
<p>The output &quot;--b--b--&quot; is displayed like this (the b symbol stands for
the value of the break that is explained below):</p>
<ul>
<li>
<p>within a “h” box:</p>
<pre><code class="language-text">--b--b--
</code></pre>
</li>
<li>
<p>within a “v” box:</p>
<pre><code class="language-text">--b
--b
--
</code></pre>
</li>
<li>
<p>within a “hv” box:</p>
<p>If there is enough room to print the box on the line:</p>
<pre><code class="language-text">--b--b--
</code></pre>
<p>But &quot;---b---b---&quot; that cannot fit on the line is written</p>
<pre><code class="language-text">---b
---b
---
</code></pre>
</li>
<li>
<p>within a “hov” box:</p>
<p>If there is enough room to print the box on the line:</p>
<pre><code class="language-text">--b--b--
</code></pre>
<p>But if &quot;---b---b---&quot; cannot fit on the line, it is written as</p>
<pre><code class="language-text">---b---b
---
</code></pre>
<p>The first break hint does not lead to a new line, since there is
enough room on the line. The second one leads to a new line since
there is no more room to print the material following it. If the
room left on the line were even shorter, the first break hint may
lead to a new line and &quot;---b---b---&quot; is written as:</p>
<pre><code class="language-text">---b
---b
---
</code></pre>
</li>
</ul>
<h2 id="printing-spaces">Printing spaces</h2>
<p>Break hints are also used to output spaces (if the line is not split
when the break is encountered, otherwise the new line indicates properly
the separation between printing items). You output a break hint using
<code>print_break sp indent</code>, and this <code>sp</code> integer is used to print “sp”
spaces. Thus <code>print_break sp ...</code> may be thought as: print <code>sp</code> spaces
or output a new line.</p>
<p>For instance, if b is <code>break 1 0</code> in the output &quot;--b--b--&quot;, we get</p>
<ul>
<li>
<p>within a “h” box:</p>
<pre><code class="language-text">-- -- --
</code></pre>
</li>
<li>
<p>within a “v” box:</p>
<pre><code class="language-text">--
--
--
</code></pre>
</li>
<li>
<p>within a “hv” box:</p>
<pre><code class="language-text">-- -- --
</code></pre>
<p>or, according to the remaining room on the line:</p>
<pre><code class="language-text">--
--
--
</code></pre>
</li>
<li>
<p>and similarly for “hov” boxes.</p>
</li>
</ul>
<p>Generally speaking, a printing routine using &quot;format&quot;, should not
directly output white spaces: the routine should use break hints
instead. (For instance <code>print_space ()</code> that is a convenient
abbreviation for <code>print_break 1 0</code> and outputs a single space or break
the line.)</p>
<h2 id="indentation-of-new-lines">Indentation of new lines</h2>
<p>The user gets 2 ways to fix the indentation of new lines:</p>
<ul>
<li>
<p><strong>when defining the box</strong>: when you open a box, you can fix the
indentation added to each new line opened within that box.<br />
For instance: <code>open_hovbox 1</code> opens a “hov” box with new lines
indented 1 more than the initial indentation of the box. With output
&quot;---[--b--b--b--&quot;, we get:</p>
<pre><code class="language-text">---[--b--b
     --b--
</code></pre>
<p>with <code>open_hovbox 2</code>, we get</p>
<pre><code class="language-text">---[--b--b
      --b--
</code></pre>
<p>Note: the <code>[</code> sign in the display is not visible on the screen, it
is just there to materialise the aperture of the pretty-printing
box. Last “screen” stands for:</p>
<pre><code class="language-text">-----b--b
     --b--
</code></pre>
</li>
<li>
<p><strong>when defining the break that makes the new line</strong>. As said above,
you output a break hint using <code>print_break     sp           indent</code>.
The <code>indent</code> integer is used to fix the additional indentation of
the new line. Namely, it is added to the default indentation offset
of the box where the break occurs.<br />
For instance, if <code>[</code> stands for the opening of a “hov” box with 1
as extra indentation (as obtained by <code>open_hovbox 1</code>), and b is
<code>print_break       1       2</code>, then from output &quot;---[--b--b--b--&quot;,
we get:</p>
<pre><code class="language-text">---[-- --
      --
      --
</code></pre>
</li>
</ul>
<h2 id="refinement-on-hov-boxes">Refinement on “hov” boxes</h2>
<h3 id="packing-and-structural-hov-boxes">Packing and structural “hov” boxes</h3>
<p>The “hov” box type is refined into two categories.</p>
<ul>
<li><strong>the vertical or horizontal <em>packing</em> box</strong> (as obtained by the
open_hovbox procedure): break hints are used to cut the line when
there is no more room on the line; no new line occurs if there is
enough room on the line.
</li>
<li><strong>vertical or horizontal <em>structural</em> box</strong> (as obtained by the
open_box procedure): similar to the “hov” packing box, the break
hints are used to cut the line when there is no more room on the
line; in addition, break hints that can show the box structure lead
to new lines even if there is enough room on the current line.
</li>
</ul>
<h3 id="differences-between-a-packing-and-a-structural-hov-box">Differences between a packing and a structural “hov” box</h3>
<p>The difference between a packing and a structural “hov” box is shown by
a routine that closes boxes and parentheses at the end of printing: with
packing boxes, the closure of boxes and parentheses do not lead to new
lines if there is enough room on the line, whereas with structural boxes
each break hint will lead to a new line. For instance, when printing
<code>[(---[(----[(---b)]b)]b)]</code>, where <code>b</code> is a break hint without extra
indentation (<code>print_cut ()</code>). If <code>[</code> means opening of a packing “hov”
box (open_hovbox), <code>[(---[(----[(---b)]b)]b)]</code> is printed as follows:</p>
<pre><code class="language-text">(---
 (----
  (---)))
</code></pre>
<p>If we replace the packing boxes by structural boxes (open_box), each
break hint that precedes a closing parenthesis can show the boxes
structure, if it leads to a new line; hence <code>[(---[(----[(---b)]b)]b)]</code>
is printed like this:</p>
<pre><code class="language-text">(---
 (----
  (---
  )
 )
)
</code></pre>
<h2 id="practical-advice">Practical advice</h2>
<p>When writing a pretty-printing routine, follow these simple rules:</p>
<ol>
<li>Boxes must be opened and closed consistently (<code>open_*</code> and
<code>close_box</code> must be nested like parentheses).
</li>
<li>Never hesitate to open a box.
</li>
<li>Output many break hints, otherwise the pretty-printer is in a bad
situation where it tries to do its best, which is always “worse than
your bad”.
</li>
<li>Do not try to force spacing using explicit spaces in the character
strings. For each space you want in the output emit a break hint
(<code>print_space ()</code>), unless you explicitly don't want the line to be
broken here. For instance, imagine you want to pretty print an OCaml
definition, more precisely a <code>let rec ident =     expression</code> value
definition. You will probably treat the first three spaces as
“unbreakable spaces” and write them directly in the string constants
for keywords, and print <code>&quot;let rec &quot;</code> before the identifier, and
similarly write <code> =</code> to get an unbreakable space after the
identifier; in contrast, the space after the <code>=</code> sign is certainly a
break hint, since breaking the line after <code>=</code> is a usual (and
elegant) way to indent the expression part of a definition. In
short, it is often necessary to print unbreakable spaces; however,
most of the time a space should be considered a break hint.
</li>
<li>Do not try to force new lines, let the pretty-printer do it for you:
that's its only job. In particular, do not use <code>force_newline</code>: this
procedure effectively leads to a newline, but it also as the
unfortunate side effect to partially reinitialise the
pretty-printing engine, so that the rest of the printing material is
noticeably messed up.
</li>
<li>Never put newline characters directly in the strings to be printed:
pretty printing engine will consider this newline character as any
other character written on the current line and this will completely
mess up the output. Instead of new line characters use line break
hints: if those break hints must always result in new lines, it just
means that the surrounding box must be a vertical box!
</li>
<li>End your main program by a <code>print_newline ()</code> call, that flushes the
pretty-printer tables (hence the output). (Note that the top-level
loop of the interactive system does it as well, just before a new
input.)
</li>
</ol>
<h2 id="printing-to-stdout-using-printf">Printing to <code>stdout</code>: using <code>printf</code></h2>
<p>The <code>format</code> module provides a general printing facility “à la”
<code>printf</code>. In addition to the usual conversion facility provided by
<code>printf</code>, you can write pretty-printing indications directly inside the
format string (opening and closing boxes, indicating breaking hints,
etc).</p>
<p>Pretty-printing annotations are introduced by the <code>@</code> symbol, directly
into the string format. Almost any function of the <code>format</code> module can
be called from within a <code>printf</code> format string. For instance</p>
<ul>
<li>“<code>@[</code>” open a box (<code>open_box     0</code>). You may precise the type as an
extra argument. For instance <code>@[&lt;hov n&gt;</code> is equivalent to
<code>open_hovbox       n</code>.
</li>
<li>“<code>@]</code>” close a box (<code>close_box       ()</code>).
</li>
<li>“<code>@</code> ” output a breakable space (<code>print_space ()</code>).
</li>
<li>“<code>@,</code>” output a break hint (<code>print_cut       ()</code>).
</li>
<li>“<code>@;&lt;n m&gt;</code>” emit a “full” break hint (<code>print_break n m</code>).
</li>
<li>“<code>@.</code>” end the pretty-printing, closing all the boxes still opened
(<code>print_newline ()</code>).
</li>
</ul>
<p>For instance</p>
<pre><code class="language-ocaml"># Format.printf &quot;@[&lt;1&gt;%s@ =@ %d@ %s@]@.&quot; &quot;Prix TTC&quot; 100 &quot;Euros&quot;
Prix TTC = 100 Euros
- : unit = ()
</code></pre>
<h2 id="a-concrete-example">A concrete example</h2>
<p>Let me give a full example: the shortest non trivial example you could
imagine, that is the λ-calculus. :)</p>
<p>Thus the problem is to pretty-print the values of a concrete data type
that models a language of expressions that defines functions and their
applications to arguments.</p>
<p>First, I give the abstract syntax of lambda-terms (we illustrate it in
the <a href="../description.html#Interactivity">interactive system</a>):</p>
<pre><code class="language-ocaml"># type lambda =
  | Lambda of string * lambda
  | Var of string
  | Apply of lambda * lambda
type lambda =
    Lambda of string * lambda
  | Var of string
  | Apply of lambda * lambda
</code></pre>
<p>I use the format library to print the lambda-terms:</p>
<pre><code class="language-ocaml">open Format
let ident = print_string
let kwd = print_string

let rec print_exp0 = function
  | Var s -&gt;  ident s
  | lam -&gt; open_hovbox 1; kwd &quot;(&quot;; print_lambda lam; kwd &quot;)&quot;; close_box ()
and print_app = function
  | e -&gt; open_hovbox 2; print_other_applications e; close_box ()
and print_other_applications f =
  match f with
  | Apply (f, arg) -&gt; print_app f; print_space (); print_exp0 arg
  | f -&gt; print_exp0 f
and print_lambda = function
  | Lambda (s, lam) -&gt;
      open_hovbox 1;
      kwd &quot;\\\\&quot;; ident s; kwd &quot;.&quot;; print_space(); print_lambda lam;
      close_box()
  | e -&gt; print_app e
</code></pre>
<p>In Caml Light, replace the first line by:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">#open &quot;format&quot;;;
</code></pre>
<h3 id="most-general-pretty-printing-using-fprintf">Most general pretty-printing: using <code>fprintf</code></h3>
<p>We use the <code>fprintf</code> function to write the most versatile version of the
pretty-printing functions for lambda-terms. Now, the functions get an
extra argument, namely a pretty-printing formatter (the <code>ppf</code> argument)
where printing will occur. This way the printing routines are more
general, since they can print on any formatter defined in the program
(either printing to a file, or to <code>stdout</code>, to <code>stderr</code>, or even to a
string). Furthermore, the pretty-printing functions are now
compositional, since they may be used in conjunction with the special
<code>%a</code> conversion, that prints a <code>fprintf</code> argument with a user's supplied
function (these user's supplied functions also have a formatter as first
argument).</p>
<p>Using <code>fprintf</code>, the lambda-terms printing routines can be written as
follows:</p>
<pre><code class="language-ocaml">open Format

let ident ppf s = fprintf ppf &quot;%s&quot; s
let kwd ppf s = fprintf ppf &quot;%s&quot; s

let rec pr_exp0 ppf = function
  | Var s -&gt; fprintf ppf &quot;%a&quot; ident s
  | lam -&gt; fprintf ppf &quot;@[&lt;1&gt;(%a)@]&quot; pr_lambda lam
and pr_app ppf e =
  fprintf ppf &quot;@[&lt;2&gt;%a@]&quot; pr_other_applications e
and pr_other_applications ppf f =
  match f with
  | Apply (f, arg) -&gt; fprintf ppf &quot;%a@ %a&quot; pr_app f pr_exp0 arg
  | f -&gt; pr_exp0 ppf f
and pr_lambda ppf = function
  | Lambda (s, lam) -&gt;
     fprintf ppf &quot;@[&lt;1&gt;%a%a%a@ %a@]&quot;
             kwd &quot;\\\\&quot; ident s kwd &quot;.&quot; pr_lambda lam
  | e -&gt; pr_app ppf e
</code></pre>
<p>Given those general printing routines, procedures to print to <code>stdout</code>
or <code>stderr</code> is just a matter of partial application:</p>
<pre><code class="language-ocaml">let print_lambda = pr_lambda std_formatter
let eprint_lambda = pr_lambda err_formatter
</code></pre>
|js}
  };
 
  { title = {js|Calling C Libraries|js}
  ; slug = {js|calling-c-libraries|js}
  ; description = {js|Cross the divide and call C code from your OCaml program
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["interoperability"]
  ; users = [`Advanced]
  ; body_md = {js|
## MiniGtk
While the structure of lablgtk outlined in [Introduction to
Gtk](introduction_to_gtk.html "Introduction to Gtk") seems perhaps
over-complex, it's worth considering exactly why the author chose two
layers. To appreciate this, you really need to get your hands dirty and
look at other ways that a Gtk wrapper might have been written.

To this end I played around with something I call
<dfn>MiniGtk</dfn>, intended as a simple Gtk wrapper. All MiniGtk is
capable of is opening a window with a label, but after writing MiniGtk I
had renewed respect for the author of lablgtk!

MiniGtk is also a good tutorial for people who want to write OCaml
bindings around their favorite C library. If you've ever tried to write
bindings for Python or Java, you'll find doing the same for OCaml is
surprisingly easy, although you do have to worry a bit about the garbage
collector.

Let's talk first about how MiniGtk is structured: rather than using a
two layered approach as with lablgtk, I wanted to implement MiniGtk
using a single (object-oriented) layer. This means that MiniGtk consists
of a bunch of class definitions. Methods in those classes pretty much
directly translate into calls to the C `libgtk-1.2.so` library.

I also wanted to rationalise the module naming scheme for Gtk. So there
is exactly one top-level module called (surprise!) `Gtk` and all classes
are inside this module. A test program looks like this:

<!-- $MDX skip -->
```ocaml
let win = new Gtk.window ~title:"My window" ();;
let lbl = new Gtk.label ~text:"Hello" ();;
win#add lbl;;

let () =
  Gtk.main ()
```
I defined a single abstract type to cover all `GtkObject`s (and
"subclasses" of this C structure). In the `Gtk` module you'll find this
type definition:

```ocaml
type obj
```

As discussed in the last chapter, this defines an abstract type of which
it is impossible to create any instances. In OCaml, at least. Certain C
functions are going to create instances of this type. For instance, the
function which creates new labels (ie. `GtkLabel` structures) is defined
this way:

<!-- $MDX skip -->
```ocaml
external gtk_label_new : string -> obj = "gtk_label_new_c"
```

This strange function definition defines an <dfn>external
function</dfn>, one coming from C. The C function is called
`gtk_label_new_c`, and it takes a string and returns one of our abstract
`obj` types.

OCaml doesn't quite let you call *any* C function yet. You need to write
a little C wrapper around the library's function to translate to and
from OCaml's internal types and C types. `gtk_label_new_c` (note the
additional `_c`) is my wrapper around the real Gtk C function called
`gtk_label_new`. Here it is. I'll explain more about it later.

```C
CAMLprim value
gtk_label_new_c (value str)
{
  CAMLparam1 (str);
  CAMLreturn (wrap (GTK_OBJECT (
    gtk_label_new (String_val (str)))));
 }
```
Before explaining this function further, I'm going to take a step back
and look at the hierarchy of our Gtk classes. I've chosen to reflect the
actual Gtk widget hierarchy as closely as possible. All Gtk widgets are
derived from a virtual base class called `GtkObject`. In fact from this
class is derived `GtkWidget` and the whole variety of Gtk widgets are
derived from this. So we define our own `GtkObject` equivalent class
like this (note that `object` is a reserved word in OCaml).

```ocaml
type obj

class virtual gtk_object (obj : obj) =
object (self)
  val obj = obj
  method obj = obj
end
```

`type obj` defines our abstract object type, and `class gtk_object`
takes one of these "things" as a parameter to its constructor. Recall
from above that this parameter is actually the C `GtkObject` structure
(in fact it's a specially wrapped pointer to this structure).

You can't create `gtk_object` instances directly because it's a virtual
class, but if you could you'd have to construct them like this:
`new gtk_object obj`. What would you pass as that `obj` parameter? You'd
pass the return value of, for instance, `gtk_label_new` (go back and
have a look at how that `external` function was typed). This is shown
below:

<!-- $MDX skip -->
```ocaml
(* Example code, not really part of MiniGtk! *)
class label text =
  let obj = gtk_label_new text in
  object (self)
    inherit gtk_object obj
  end
```

Of course the real `label` class doesn't inherit directly from
`gtk_object` as shown above, but in principle this is how it works.

Following the Gtk class hierarchy the only class derived directly from
`gtk_object` is our `widget` class, defined like this:

<!-- $MDX skip -->
```ocaml
external gtk_widget_show : obj -> unit = "gtk_widget_show_c"
external gtk_widget_show_all : obj -> unit = "gtk_widget_show_all_c"

class virtual widget ?show obj =
  object (self)
    inherit gtk_object obj
    method show = gtk_widget_show obj
    method show_all = gtk_widget_show_all obj
    initializer if show <> Some false then self#show
  end
```
This class is considerably more complex. Let's look at the
initialization code first:

<!-- $MDX skip -->
```ocaml
class virtual widget ?show obj =
  object (self)
    inherit gtk_object obj
    initializer
      if show <> Some false then self#show
  end
```

The `initializer` section may well be new to you. This is code which
runs when an object is being created - the equivalent of a constructor
in other languages. In this case we check the boolean optional `show`
argument and unless the user specified it explicitly as `false` we
automatically call the `#show` method. (All Gtk widgets need to be
"shown" after being created unless you want a widget to be created but
hidden).

The actual definition of the methods happens with the help of a couple
of external functions. These are basically direct calls to the C library
(well, in fact there's a tiny bit of wrapper code, but that's not
functionally important).

<!-- $MDX skip -->
```ocaml
method show = gtk_widget_show obj
method show_all = gtk_widget_show_all obj
```

Notice that we pass the underlying `GtkObject` to both C library calls.
This makes sense because these functions are prototyped as
`void gtk_widget_show (GtkWidget *);` in C (`GtkWidget` and `GtkObject`
are safely used interchangeably in this context).

I want to describe the `label` class (the real one this time!), but in
between `widget` and `label` is `misc`, a generic class which describes
a large class of miscellaneous widgets. This class just adds padding and
alignment around a widget such as a label. Here is its definition:

<!-- $MDX skip -->
```ocaml
let may f x =
  match x with
  | None -> ()
  | Some x -> f x

external gtk_misc_set_alignment :
  obj -> float * float -> unit = "gtk_misc_set_alignment_c"
external gtk_misc_set_padding :
  obj -> int * int -> unit = "gtk_misc_set_padding_c"

class virtual misc ?alignment ?padding ?show obj =
  object (self)
    inherit widget ?show obj
    method set_alignment = gtk_misc_set_alignment obj
    method set_padding = gtk_misc_set_padding obj
    initializer
      may (gtk_misc_set_alignment obj) alignment;
      may (gtk_misc_set_padding obj) padding
  end
```

We start with a helper function called
`may : ('a -> unit) -> 'a option -> unit` which invokes its first
argument on the contents of its second unless the second argument is
`None`. This trick (stolen from lablgtk of course) is very useful when
dealing with optional arguments as we'll see.

The methods in `misc` should be straightforward. What is tricky is the
initialization code. First notice that we take optional `alignment` and
`padding` arguments to the constructor, and we pass the optional `show`
and mandatory `obj` arguments directly up to `widget`. What do we do
with the optional `alignment` and `padding`? The initializer uses these:

<!-- $MDX skip -->
```ocaml
initializer
  may (gtk_misc_set_alignment obj) alignment;
  may (gtk_misc_set_padding obj) padding 
```

It's that tricky `may` function in action. *If* the user gave an
`alignment` argument, then this will set the alignment on the object by
calling `gtk_misc_set_alignment obj the_alignment`. But more commonly
the user will omit the `alignment` argument, in which case `alignment`
is `None` and this does nothing. (In effect we get Gtk's default
alignment, whatever that is). A similar thing happens with the
`padding`. Note there is a certain simplicity and elegance in the way
this is done.

Now we can finally get to the `label` class, which is derived directly
from `misc`:

<!-- $MDX skip -->
```ocaml
external gtk_label_new :
    string -> obj  = "gtk_label_new_c"
external gtk_label_set_text :
    obj -> string -> unit = "gtk_label_set_text_c"
external gtk_label_set_justify :
    obj -> Justification.t -> unit = "gtk_label_set_justify_c"
external gtk_label_set_pattern :
    obj -> string -> unit = "gtk_label_set_pattern_c"
external gtk_label_set_line_wrap :
    obj -> bool -> unit = "gtk_label_set_line_wrap_c"

class label ~text
  ?justify ?pattern ?line_wrap ?alignment
  ?padding ?show () =
  let obj = gtk_label_new text in
  object (self)
    inherit misc ?alignment ?padding ?show obj
    method set_text = gtk_label_set_text obj
    method set_justify = gtk_label_set_justify obj
    method set_pattern = gtk_label_set_pattern obj
    method set_line_wrap = gtk_label_set_line_wrap obj
    initializer
      may (gtk_label_set_justify obj) justify;
      may (gtk_label_set_pattern obj) pattern;
      may (gtk_label_set_line_wrap obj) line_wrap
  end
```
Although this class is bigger than the ones we've looked at up til now,
it's really more of the same idea, *except* that this class isn't
virtual. You can create instances of this class which means it finally
has to call `gtk_..._new`. This is the initialization code (we discussed
this pattern above):

<!-- $MDX skip -->
```ocaml
class label ~text ... () =
  let obj = gtk_label_new text in
  object (self)
    inherit misc ... obj
  end
```
(Pop quiz: what happens if we need to define a class which is both a
base class from which other classes can be derived, and is also a
non-virtual class of which the user should be allowed to create
instances?)

####  Wrapping calls to C libraries
Now we'll look in more detail at actually wrapping up calls to C library
functions. Here's a simple example:

```C
/* external gtk_label_set_text :
     obj -> string -> unit
       = "gtk_label_set_text_c" */

CAMLprim value
gtk_label_set_text_c (value obj, value str)
{
  CAMLparam2 (obj, str);
  gtk_label_set_text (unwrap (GtkLabel, obj),
    String_val (str));
  CAMLreturn (Val_unit);
}
```
Comparing the OCaml prototype for the external function call (in the
comment) with the definition of the function we can see two things:

* The C function that OCaml calls is named `"gtk_label_set_text_c"`.
* Two arguments are passed (`value obj` and `value str`) and a unit is
 returned.

Values are OCaml's internal representation of all sorts of things from
simple integers through to strings and even objects. I'm not going to go
into any great detail about the `value` type because it is more than
adequately covered in the OCaml manual. To use `value` you need to just
know what macros are available to convert between a `value` and some C
type. The macros look like this:

<dl> <dt>`String_val (val)`</dt> <dd> Convert from a `value`
which is known to be a string to a C string (ie. `char *`). </dd>
<dt>`Val_unit`</dt> <dd> The OCaml unit `()` as a `value`. </dd>
<dt>`Int_val (val)`</dt> <dd> Convert from a `value` which
is known to be an integer to a C `int`. </dd>
<dt>`Val_int (i)`</dt> <dd> Convert from a C integer `i` into an
integer `value`. </dd> <dt>`Bool_val (val)`</dt> <dd> Convert
from a `value` which is known to be a boolean to a C boolean (ie. an
`int`). </dd> <dt>`Val_bool (i)`</dt> <dd> Convert from a C
integer `i` into a boolean `value`. </dd> </dl>

You can guess the others or consult the manual. Note that there is no
straightforward conversion from C `char *` to a value. This involves
allocating memory, which is somewhat more complicated.

In `gtk_label_set_text_c` above, the `external` definition, plus strong
typing and type inference, has already ensured that the arguments are of
the correct type, so to convert `value str` to a C `char *` we called
`String_val (str)`.

The other parts of the function are a bit stranger. To ensure that the
garbage collector "knows" that your C function is still using `obj` and
`str` while the C function is running (remember that the garbage
collector might be triggered within your C function by a number of
events - a callback to OCaml or using one of OCaml's allocation
functions), you need to frame the function to add code to tell the
garbage collector about the "roots" that you're using. And tell the
garbage collector when you finish using those roots too, of course. This
is done by framing the function within `CAMLparamN` ... `CAMLreturn`.
Hence:

```C
CAMLparam2 (obj, str);
...
CAMLreturn (Val_unit); 
```

`CAMLparam2` is a macro saying that you're using two `value` parameters.
(There is another macro for annotating local `value` variables too). You
need to use `CAMLreturn` instead of plain `return` which tells the GC
you've finished with those roots. It might be instructive to examine
what code is inlined when you write `CAMLparam2 (obj, str)`. This is the
generated code (with the author's version of OCaml, so it might vary
between implementations slightly):

```C
struct caml__roots_block *caml__frame
    = local_roots;
struct caml__roots_block caml__roots_obj;

caml__roots_obj.next = local_roots;
local_roots = &caml__roots_obj;
caml__roots_obj.nitems = 1;
caml__roots_obj.ntables = 2;
caml__roots_obj.tables [0] = &obj;
caml__roots_obj.tables [1] = &str; 
```
And for `CAMLreturn (foo)`:

```C
local_roots = caml__frame;
return (foo); 
```

If you follow the code closely you'll see that `local_roots` is
obviously a linked list of `caml__roots_block` structures. One (or more)
of these structures is pushed onto the linked list when we enter the
function, and all of these are popped back off when we leave, thus
restoring `local_roots` to its previous state when we leave the
function. (*If* you remembered to call `CAMLreturn` instead of `return`
of course - otherwise `local_roots` will end up pointing at
uninitialised data on the stack with "hilarious" consequences).

Each `caml__roots_block` structure has space for up to five `value`s
(you can have multiple blocks, so this isn't a limitation). When the GC
runs we can infer that it must walk through the linked list, starting at
`local_roots`, and treat each `value` as a root for garbage collection
purposes. The consequences of *not* declaring a `value` parameter or
local `value` variable in this way would be that the garbage collector
might treat that variable as unreachable memory and thus reclaim it
while your function is running!

Finally there is the mysterious `unwrap` macro. This is one I wrote
myself, or rather, this is one I mostly copied from lablgtk. There are
two related functions, called `wrap` and `unwrap` and as you might
possibly have guessed, they wrap and unwrap `GtkObject`s in OCaml
`value`s. These functions establish the somewhat magical relationship
between `GtkObject` and our opaque, mysterious `obj` type which we
defined for OCaml (see the very first part of this chapter to remind
yourself).

The problem is how do we wrap up (and hide) the C `GtkObject` structure
in a way that we can pass it around as an opaque "thing" (`obj`) through
our OCaml code, and hopefully pass it back later to a C function which
can unwrap it and retrieve the same `GtkObject` back again?

In order for it to get passed to OCaml code at all, we must somehow
convert it to a `value`. Luckily we can quite easily use the C API to
create `value` blocks which the OCaml garbage collector *won't* examine
too closely ......
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#minigtk">MiniGtk</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<h2 id="minigtk">MiniGtk</h2>
<p>While the structure of lablgtk outlined in <a href="introduction_to_gtk.html" title="Introduction to Gtk">Introduction to
Gtk</a> seems perhaps
over-complex, it's worth considering exactly why the author chose two
layers. To appreciate this, you really need to get your hands dirty and
look at other ways that a Gtk wrapper might have been written.</p>
<p>To this end I played around with something I call
<dfn>MiniGtk</dfn>, intended as a simple Gtk wrapper. All MiniGtk is
capable of is opening a window with a label, but after writing MiniGtk I
had renewed respect for the author of lablgtk!</p>
<p>MiniGtk is also a good tutorial for people who want to write OCaml
bindings around their favorite C library. If you've ever tried to write
bindings for Python or Java, you'll find doing the same for OCaml is
surprisingly easy, although you do have to worry a bit about the garbage
collector.</p>
<p>Let's talk first about how MiniGtk is structured: rather than using a
two layered approach as with lablgtk, I wanted to implement MiniGtk
using a single (object-oriented) layer. This means that MiniGtk consists
of a bunch of class definitions. Methods in those classes pretty much
directly translate into calls to the C <code>libgtk-1.2.so</code> library.</p>
<p>I also wanted to rationalise the module naming scheme for Gtk. So there
is exactly one top-level module called (surprise!) <code>Gtk</code> and all classes
are inside this module. A test program looks like this:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let win = new Gtk.window ~title:&quot;My window&quot; ();;
let lbl = new Gtk.label ~text:&quot;Hello&quot; ();;
win#add lbl;;

let () =
  Gtk.main ()
</code></pre>
<p>I defined a single abstract type to cover all <code>GtkObject</code>s (and
&quot;subclasses&quot; of this C structure). In the <code>Gtk</code> module you'll find this
type definition:</p>
<pre><code class="language-ocaml">type obj
</code></pre>
<p>As discussed in the last chapter, this defines an abstract type of which
it is impossible to create any instances. In OCaml, at least. Certain C
functions are going to create instances of this type. For instance, the
function which creates new labels (ie. <code>GtkLabel</code> structures) is defined
this way:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">external gtk_label_new : string -&gt; obj = &quot;gtk_label_new_c&quot;
</code></pre>
<p>This strange function definition defines an <dfn>external
function</dfn>, one coming from C. The C function is called
<code>gtk_label_new_c</code>, and it takes a string and returns one of our abstract
<code>obj</code> types.</p>
<p>OCaml doesn't quite let you call <em>any</em> C function yet. You need to write
a little C wrapper around the library's function to translate to and
from OCaml's internal types and C types. <code>gtk_label_new_c</code> (note the
additional <code>_c</code>) is my wrapper around the real Gtk C function called
<code>gtk_label_new</code>. Here it is. I'll explain more about it later.</p>
<pre><code class="language-C">CAMLprim value
gtk_label_new_c (value str)
{
  CAMLparam1 (str);
  CAMLreturn (wrap (GTK_OBJECT (
    gtk_label_new (String_val (str)))));
 }
</code></pre>
<p>Before explaining this function further, I'm going to take a step back
and look at the hierarchy of our Gtk classes. I've chosen to reflect the
actual Gtk widget hierarchy as closely as possible. All Gtk widgets are
derived from a virtual base class called <code>GtkObject</code>. In fact from this
class is derived <code>GtkWidget</code> and the whole variety of Gtk widgets are
derived from this. So we define our own <code>GtkObject</code> equivalent class
like this (note that <code>object</code> is a reserved word in OCaml).</p>
<pre><code class="language-ocaml">type obj

class virtual gtk_object (obj : obj) =
object (self)
  val obj = obj
  method obj = obj
end
</code></pre>
<p><code>type obj</code> defines our abstract object type, and <code>class gtk_object</code>
takes one of these &quot;things&quot; as a parameter to its constructor. Recall
from above that this parameter is actually the C <code>GtkObject</code> structure
(in fact it's a specially wrapped pointer to this structure).</p>
<p>You can't create <code>gtk_object</code> instances directly because it's a virtual
class, but if you could you'd have to construct them like this:
<code>new gtk_object obj</code>. What would you pass as that <code>obj</code> parameter? You'd
pass the return value of, for instance, <code>gtk_label_new</code> (go back and
have a look at how that <code>external</code> function was typed). This is shown
below:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">(* Example code, not really part of MiniGtk! *)
class label text =
  let obj = gtk_label_new text in
  object (self)
    inherit gtk_object obj
  end
</code></pre>
<p>Of course the real <code>label</code> class doesn't inherit directly from
<code>gtk_object</code> as shown above, but in principle this is how it works.</p>
<p>Following the Gtk class hierarchy the only class derived directly from
<code>gtk_object</code> is our <code>widget</code> class, defined like this:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">external gtk_widget_show : obj -&gt; unit = &quot;gtk_widget_show_c&quot;
external gtk_widget_show_all : obj -&gt; unit = &quot;gtk_widget_show_all_c&quot;

class virtual widget ?show obj =
  object (self)
    inherit gtk_object obj
    method show = gtk_widget_show obj
    method show_all = gtk_widget_show_all obj
    initializer if show &lt;&gt; Some false then self#show
  end
</code></pre>
<p>This class is considerably more complex. Let's look at the
initialization code first:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">class virtual widget ?show obj =
  object (self)
    inherit gtk_object obj
    initializer
      if show &lt;&gt; Some false then self#show
  end
</code></pre>
<p>The <code>initializer</code> section may well be new to you. This is code which
runs when an object is being created - the equivalent of a constructor
in other languages. In this case we check the boolean optional <code>show</code>
argument and unless the user specified it explicitly as <code>false</code> we
automatically call the <code>#show</code> method. (All Gtk widgets need to be
&quot;shown&quot; after being created unless you want a widget to be created but
hidden).</p>
<p>The actual definition of the methods happens with the help of a couple
of external functions. These are basically direct calls to the C library
(well, in fact there's a tiny bit of wrapper code, but that's not
functionally important).</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">method show = gtk_widget_show obj
method show_all = gtk_widget_show_all obj
</code></pre>
<p>Notice that we pass the underlying <code>GtkObject</code> to both C library calls.
This makes sense because these functions are prototyped as
<code>void gtk_widget_show (GtkWidget *);</code> in C (<code>GtkWidget</code> and <code>GtkObject</code>
are safely used interchangeably in this context).</p>
<p>I want to describe the <code>label</code> class (the real one this time!), but in
between <code>widget</code> and <code>label</code> is <code>misc</code>, a generic class which describes
a large class of miscellaneous widgets. This class just adds padding and
alignment around a widget such as a label. Here is its definition:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let may f x =
  match x with
  | None -&gt; ()
  | Some x -&gt; f x

external gtk_misc_set_alignment :
  obj -&gt; float * float -&gt; unit = &quot;gtk_misc_set_alignment_c&quot;
external gtk_misc_set_padding :
  obj -&gt; int * int -&gt; unit = &quot;gtk_misc_set_padding_c&quot;

class virtual misc ?alignment ?padding ?show obj =
  object (self)
    inherit widget ?show obj
    method set_alignment = gtk_misc_set_alignment obj
    method set_padding = gtk_misc_set_padding obj
    initializer
      may (gtk_misc_set_alignment obj) alignment;
      may (gtk_misc_set_padding obj) padding
  end
</code></pre>
<p>We start with a helper function called
<code>may : ('a -&gt; unit) -&gt; 'a option -&gt; unit</code> which invokes its first
argument on the contents of its second unless the second argument is
<code>None</code>. This trick (stolen from lablgtk of course) is very useful when
dealing with optional arguments as we'll see.</p>
<p>The methods in <code>misc</code> should be straightforward. What is tricky is the
initialization code. First notice that we take optional <code>alignment</code> and
<code>padding</code> arguments to the constructor, and we pass the optional <code>show</code>
and mandatory <code>obj</code> arguments directly up to <code>widget</code>. What do we do
with the optional <code>alignment</code> and <code>padding</code>? The initializer uses these:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">initializer
  may (gtk_misc_set_alignment obj) alignment;
  may (gtk_misc_set_padding obj) padding 
</code></pre>
<p>It's that tricky <code>may</code> function in action. <em>If</em> the user gave an
<code>alignment</code> argument, then this will set the alignment on the object by
calling <code>gtk_misc_set_alignment obj the_alignment</code>. But more commonly
the user will omit the <code>alignment</code> argument, in which case <code>alignment</code>
is <code>None</code> and this does nothing. (In effect we get Gtk's default
alignment, whatever that is). A similar thing happens with the
<code>padding</code>. Note there is a certain simplicity and elegance in the way
this is done.</p>
<p>Now we can finally get to the <code>label</code> class, which is derived directly
from <code>misc</code>:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">external gtk_label_new :
    string -&gt; obj  = &quot;gtk_label_new_c&quot;
external gtk_label_set_text :
    obj -&gt; string -&gt; unit = &quot;gtk_label_set_text_c&quot;
external gtk_label_set_justify :
    obj -&gt; Justification.t -&gt; unit = &quot;gtk_label_set_justify_c&quot;
external gtk_label_set_pattern :
    obj -&gt; string -&gt; unit = &quot;gtk_label_set_pattern_c&quot;
external gtk_label_set_line_wrap :
    obj -&gt; bool -&gt; unit = &quot;gtk_label_set_line_wrap_c&quot;

class label ~text
  ?justify ?pattern ?line_wrap ?alignment
  ?padding ?show () =
  let obj = gtk_label_new text in
  object (self)
    inherit misc ?alignment ?padding ?show obj
    method set_text = gtk_label_set_text obj
    method set_justify = gtk_label_set_justify obj
    method set_pattern = gtk_label_set_pattern obj
    method set_line_wrap = gtk_label_set_line_wrap obj
    initializer
      may (gtk_label_set_justify obj) justify;
      may (gtk_label_set_pattern obj) pattern;
      may (gtk_label_set_line_wrap obj) line_wrap
  end
</code></pre>
<p>Although this class is bigger than the ones we've looked at up til now,
it's really more of the same idea, <em>except</em> that this class isn't
virtual. You can create instances of this class which means it finally
has to call <code>gtk_..._new</code>. This is the initialization code (we discussed
this pattern above):</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">class label ~text ... () =
  let obj = gtk_label_new text in
  object (self)
    inherit misc ... obj
  end
</code></pre>
<p>(Pop quiz: what happens if we need to define a class which is both a
base class from which other classes can be derived, and is also a
non-virtual class of which the user should be allowed to create
instances?)</p>
<h4 id="wrapping-calls-to-c-libraries">Wrapping calls to C libraries</h4>
<p>Now we'll look in more detail at actually wrapping up calls to C library
functions. Here's a simple example:</p>
<pre><code class="language-C">/* external gtk_label_set_text :
     obj -&gt; string -&gt; unit
       = &quot;gtk_label_set_text_c&quot; */

CAMLprim value
gtk_label_set_text_c (value obj, value str)
{
  CAMLparam2 (obj, str);
  gtk_label_set_text (unwrap (GtkLabel, obj),
    String_val (str));
  CAMLreturn (Val_unit);
}
</code></pre>
<p>Comparing the OCaml prototype for the external function call (in the
comment) with the definition of the function we can see two things:</p>
<ul>
<li>The C function that OCaml calls is named <code>&quot;gtk_label_set_text_c&quot;</code>.
</li>
<li>Two arguments are passed (<code>value obj</code> and <code>value str</code>) and a unit is
returned.
</li>
</ul>
<p>Values are OCaml's internal representation of all sorts of things from
simple integers through to strings and even objects. I'm not going to go
into any great detail about the <code>value</code> type because it is more than
adequately covered in the OCaml manual. To use <code>value</code> you need to just
know what macros are available to convert between a <code>value</code> and some C
type. The macros look like this:</p>
<dl> <dt>`String_val (val)`</dt> <dd> Convert from a `value`
which is known to be a string to a C string (ie. `char *`). </dd>
<dt>`Val_unit`</dt> <dd> The OCaml unit `()` as a `value`. </dd>
<dt>`Int_val (val)`</dt> <dd> Convert from a `value` which
is known to be an integer to a C `int`. </dd>
<dt>`Val_int (i)`</dt> <dd> Convert from a C integer `i` into an
integer `value`. </dd> <dt>`Bool_val (val)`</dt> <dd> Convert
from a `value` which is known to be a boolean to a C boolean (ie. an
`int`). </dd> <dt>`Val_bool (i)`</dt> <dd> Convert from a C
integer `i` into a boolean `value`. </dd> </dl>
<p>You can guess the others or consult the manual. Note that there is no
straightforward conversion from C <code>char *</code> to a value. This involves
allocating memory, which is somewhat more complicated.</p>
<p>In <code>gtk_label_set_text_c</code> above, the <code>external</code> definition, plus strong
typing and type inference, has already ensured that the arguments are of
the correct type, so to convert <code>value str</code> to a C <code>char *</code> we called
<code>String_val (str)</code>.</p>
<p>The other parts of the function are a bit stranger. To ensure that the
garbage collector &quot;knows&quot; that your C function is still using <code>obj</code> and
<code>str</code> while the C function is running (remember that the garbage
collector might be triggered within your C function by a number of
events - a callback to OCaml or using one of OCaml's allocation
functions), you need to frame the function to add code to tell the
garbage collector about the &quot;roots&quot; that you're using. And tell the
garbage collector when you finish using those roots too, of course. This
is done by framing the function within <code>CAMLparamN</code> ... <code>CAMLreturn</code>.
Hence:</p>
<pre><code class="language-C">CAMLparam2 (obj, str);
...
CAMLreturn (Val_unit); 
</code></pre>
<p><code>CAMLparam2</code> is a macro saying that you're using two <code>value</code> parameters.
(There is another macro for annotating local <code>value</code> variables too). You
need to use <code>CAMLreturn</code> instead of plain <code>return</code> which tells the GC
you've finished with those roots. It might be instructive to examine
what code is inlined when you write <code>CAMLparam2 (obj, str)</code>. This is the
generated code (with the author's version of OCaml, so it might vary
between implementations slightly):</p>
<pre><code class="language-C">struct caml__roots_block *caml__frame
    = local_roots;
struct caml__roots_block caml__roots_obj;

caml__roots_obj.next = local_roots;
local_roots = &amp;caml__roots_obj;
caml__roots_obj.nitems = 1;
caml__roots_obj.ntables = 2;
caml__roots_obj.tables [0] = &amp;obj;
caml__roots_obj.tables [1] = &amp;str; 
</code></pre>
<p>And for <code>CAMLreturn (foo)</code>:</p>
<pre><code class="language-C">local_roots = caml__frame;
return (foo); 
</code></pre>
<p>If you follow the code closely you'll see that <code>local_roots</code> is
obviously a linked list of <code>caml__roots_block</code> structures. One (or more)
of these structures is pushed onto the linked list when we enter the
function, and all of these are popped back off when we leave, thus
restoring <code>local_roots</code> to its previous state when we leave the
function. (<em>If</em> you remembered to call <code>CAMLreturn</code> instead of <code>return</code>
of course - otherwise <code>local_roots</code> will end up pointing at
uninitialised data on the stack with &quot;hilarious&quot; consequences).</p>
<p>Each <code>caml__roots_block</code> structure has space for up to five <code>value</code>s
(you can have multiple blocks, so this isn't a limitation). When the GC
runs we can infer that it must walk through the linked list, starting at
<code>local_roots</code>, and treat each <code>value</code> as a root for garbage collection
purposes. The consequences of <em>not</em> declaring a <code>value</code> parameter or
local <code>value</code> variable in this way would be that the garbage collector
might treat that variable as unreachable memory and thus reclaim it
while your function is running!</p>
<p>Finally there is the mysterious <code>unwrap</code> macro. This is one I wrote
myself, or rather, this is one I mostly copied from lablgtk. There are
two related functions, called <code>wrap</code> and <code>unwrap</code> and as you might
possibly have guessed, they wrap and unwrap <code>GtkObject</code>s in OCaml
<code>value</code>s. These functions establish the somewhat magical relationship
between <code>GtkObject</code> and our opaque, mysterious <code>obj</code> type which we
defined for OCaml (see the very first part of this chapter to remind
yourself).</p>
<p>The problem is how do we wrap up (and hide) the C <code>GtkObject</code> structure
in a way that we can pass it around as an opaque &quot;thing&quot; (<code>obj</code>) through
our OCaml code, and hopefully pass it back later to a C function which
can unwrap it and retrieve the same <code>GtkObject</code> back again?</p>
<p>In order for it to get passed to OCaml code at all, we must somehow
convert it to a <code>value</code>. Luckily we can quite easily use the C API to
create <code>value</code> blocks which the OCaml garbage collector <em>won't</em> examine
too closely ......</p>
|js}
  };
 
  { title = {js|Calling Fortran Libraries|js}
  ; slug = {js|calling-fortran-libraries|js}
  ; description = {js|Cross the divide and call Fortran code from your OCaml program
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["interoperability"]
  ; users = [`Advanced]
  ; body_md = {js|
Fortran isn't a language the many people write new code in but it still
is in extensive use in the scientific communities. Many, many libraries
exist for doing numerical calculation that will never be written in C or
C++. It is quite possible though to call Fortran routines from OCaml as
they are normally compiled into the same object format, with minimal
name mangling, as C programs.

This tutorial will step by step through the process of compiling an
interface module for a fortran function. The steps that are involved
here are the same steps as for wrapping a C function with a few
considerations that have to be taken into account for Fortran.

The Fortran function is contained in a file called func.f and has the
following signature

`subroutine gtd6(integer iyd, real sec, real alt, real lat, real lon, real dens(8), real temp(2))`

The `iyd`, `sec`, `alt`, `lat`, and `lon` parameters are input
parameters while `dens` and `temp` are output parameters.

All of the examples below use the GNU Fortran 77 compiler (g77). None of
these have been tested with the GNU fortran 90 compiler (gfort) and will
not be until it has proven itself through some time.

###  Step 1: Compile the Fortran routine
Where C/C++ have only one category of subroutine (the function), Fortran
has two: the function and the subroutine. The function is the equivalent
to a non-void C function in that it takes parameters and always returns
a value. The subroutine is equivalent to a void C function.

When g77 compiles a fortran function it creates a named function that
has an underscore appended. If the fortran name for the function
contains any underscores then the compiled function name will have two
underscores appended. The generated function can be called by this name.
Subroutines will be converted into a C function that returns an int.

To compile the funcs.f file into an object file, one can use the
following:

`prompt> g77 -c funcs.f`

Which will generate the file 'funcs.o'. You can then see the names of
the compiled functions by executing

`prompt> nm funcs.o`

In this output you will see a line that has the following

` T gtd6_ `

This shows that the function gtd6_ has been created and is in the
object file.

Fortran has support for both integer and real types and those are the
names that they go by. In our case we have only real and integer types.
Reals are equivalent to C doubles and integers are equivalent to C
longs. In addition, Fortran passes everything by reference so the
corresponding C prototype for our gtd6 function is

` int gtd6_(integer *iyd, real* sec, real* alt, real* glat, real* glong, real* dens, real* temp);`

Note that its up to the caller to know that `dens` and `temp` are
actually arrays. Failure to pass an array will cause a segmentation
violation since the gtd6_ function is using them as arrays (yet another
reason OCaml shines).

###  Step 2: Create the C wrapper
Because OCaml's foreign function interface is C based, it is necessary
to create a C wrapper. To avoid difficulties in passing back arrays of
values, we are going to simply create a function that will return the
second element of the temperature array as computed by the function and
ignore the other return values (this is a very frequent use of the
function). This function will be in the source file wrapper.c.

```C
CAMLprim value gtd6_t (value iydV, value secVal, value altVal, value latVal, value lonVal) {
   CAMLparam5( iydV, secVal, altVal, latVal, lonVal );
   long iyd = Long_val( iydV );
   float    sec = Double_val( secVal );
   float    alt = Double_val( altVal );
   float    lat = Double_val( latVal );
   float    lon = Double_val( lonVal );

   gtd6_(&iyd, &sec, &alt, &glat, &glon, d, t);
   CAMLreturn( caml_copy_double( t[1] ) );
}
```
A few points of interest

1. The file must include the OCaml header files `alloc.h`, `memory.h`,
 and `mlvalue.h`.
1. The function first calls the CAMLparam5 macro. This is required at
 the start of any function that uses the CAML types.
1. The function uses the Double_val and Long_val macros to extract
 the C types from the OCaml value object.
1. All of the values are passed by reference to the gtd6_ routine as
 required by the prototype.
1. The function uses the copy_caml_double function and the CAMLreturn
 macro to create a new value containing the return value and to
 return it respectively.

###  Step 3: Compile the shared library.
Now having the two source files funcs.f and wrapper.c we need to create
a shared library that can be loaded by OCaml. Its easier to do this as a
multistep process, so here are the commands:

`prompt> g77 -c funcs.f`

`prompt> cc -I<ocaml include path> -c wrapper.c `

`prompt> cc -shared -o wrapper.so wrapper.o funcs.o -lg2c`

This will create a shared object library called wrapper.so containing
the fortran function and the wrapper function. The -lg2c option is
required to provide the implementations of the built in fortran
functions that are used.

###  Step 4: Now to OCaml
Now in an OCaml file (gtd6.ml) we have to define the external reference
to the function and a function to call it.

<!-- $MDX skip -->
```ocaml
external temp : int -> float -> float -> float -> float -> float = "gtd6_t"

let () =
  print_double (temp 1 2.0 3.0 4.0 5.0);
  print_newline ()
```
This tells OCaml that the temp function takes 5 parameters and returns a
single floating point and calls the C function gtd6_t.

At this point, the steps that are given are to compile this into
bytecode. I don't yet have much experience compiling to native so I'll
let some else help out (or wait until I learn how to do it).

```
prompt> ocamlc -c gtd6.ml prompt> ocamlc -o test gtd6.cmo wrapper.so
```
And voila, we've called the fortran function from OCaml.
|js}
  ; toc_html = {js||js}
  ; body_html = {js|<p>Fortran isn't a language the many people write new code in but it still
is in extensive use in the scientific communities. Many, many libraries
exist for doing numerical calculation that will never be written in C or
C++. It is quite possible though to call Fortran routines from OCaml as
they are normally compiled into the same object format, with minimal
name mangling, as C programs.</p>
<p>This tutorial will step by step through the process of compiling an
interface module for a fortran function. The steps that are involved
here are the same steps as for wrapping a C function with a few
considerations that have to be taken into account for Fortran.</p>
<p>The Fortran function is contained in a file called func.f and has the
following signature</p>
<p><code>subroutine gtd6(integer iyd, real sec, real alt, real lat, real lon, real dens(8), real temp(2))</code></p>
<p>The <code>iyd</code>, <code>sec</code>, <code>alt</code>, <code>lat</code>, and <code>lon</code> parameters are input
parameters while <code>dens</code> and <code>temp</code> are output parameters.</p>
<p>All of the examples below use the GNU Fortran 77 compiler (g77). None of
these have been tested with the GNU fortran 90 compiler (gfort) and will
not be until it has proven itself through some time.</p>
<h3 id="step-1-compile-the-fortran-routine">Step 1: Compile the Fortran routine</h3>
<p>Where C/C++ have only one category of subroutine (the function), Fortran
has two: the function and the subroutine. The function is the equivalent
to a non-void C function in that it takes parameters and always returns
a value. The subroutine is equivalent to a void C function.</p>
<p>When g77 compiles a fortran function it creates a named function that
has an underscore appended. If the fortran name for the function
contains any underscores then the compiled function name will have two
underscores appended. The generated function can be called by this name.
Subroutines will be converted into a C function that returns an int.</p>
<p>To compile the funcs.f file into an object file, one can use the
following:</p>
<p><code>prompt&gt; g77 -c funcs.f</code></p>
<p>Which will generate the file 'funcs.o'. You can then see the names of
the compiled functions by executing</p>
<p><code>prompt&gt; nm funcs.o</code></p>
<p>In this output you will see a line that has the following</p>
<p><code>T gtd6_</code></p>
<p>This shows that the function gtd6_ has been created and is in the
object file.</p>
<p>Fortran has support for both integer and real types and those are the
names that they go by. In our case we have only real and integer types.
Reals are equivalent to C doubles and integers are equivalent to C
longs. In addition, Fortran passes everything by reference so the
corresponding C prototype for our gtd6 function is</p>
<p><code> int gtd6_(integer *iyd, real* sec, real* alt, real* glat, real* glong, real* dens, real* temp);</code></p>
<p>Note that its up to the caller to know that <code>dens</code> and <code>temp</code> are
actually arrays. Failure to pass an array will cause a segmentation
violation since the gtd6_ function is using them as arrays (yet another
reason OCaml shines).</p>
<h3 id="step-2-create-the-c-wrapper">Step 2: Create the C wrapper</h3>
<p>Because OCaml's foreign function interface is C based, it is necessary
to create a C wrapper. To avoid difficulties in passing back arrays of
values, we are going to simply create a function that will return the
second element of the temperature array as computed by the function and
ignore the other return values (this is a very frequent use of the
function). This function will be in the source file wrapper.c.</p>
<pre><code class="language-C">CAMLprim value gtd6_t (value iydV, value secVal, value altVal, value latVal, value lonVal) {
   CAMLparam5( iydV, secVal, altVal, latVal, lonVal );
   long iyd = Long_val( iydV );
   float    sec = Double_val( secVal );
   float    alt = Double_val( altVal );
   float    lat = Double_val( latVal );
   float    lon = Double_val( lonVal );

   gtd6_(&amp;iyd, &amp;sec, &amp;alt, &amp;glat, &amp;glon, d, t);
   CAMLreturn( caml_copy_double( t[1] ) );
}
</code></pre>
<p>A few points of interest</p>
<ol>
<li>The file must include the OCaml header files <code>alloc.h</code>, <code>memory.h</code>,
and <code>mlvalue.h</code>.
</li>
<li>The function first calls the CAMLparam5 macro. This is required at
the start of any function that uses the CAML types.
</li>
<li>The function uses the Double_val and Long_val macros to extract
the C types from the OCaml value object.
</li>
<li>All of the values are passed by reference to the gtd6_ routine as
required by the prototype.
</li>
<li>The function uses the copy_caml_double function and the CAMLreturn
macro to create a new value containing the return value and to
return it respectively.
</li>
</ol>
<h3 id="step-3-compile-the-shared-library">Step 3: Compile the shared library.</h3>
<p>Now having the two source files funcs.f and wrapper.c we need to create
a shared library that can be loaded by OCaml. Its easier to do this as a
multistep process, so here are the commands:</p>
<p><code>prompt&gt; g77 -c funcs.f</code></p>
<p><code>prompt&gt; cc -I&lt;ocaml include path&gt; -c wrapper.c </code></p>
<p><code>prompt&gt; cc -shared -o wrapper.so wrapper.o funcs.o -lg2c</code></p>
<p>This will create a shared object library called wrapper.so containing
the fortran function and the wrapper function. The -lg2c option is
required to provide the implementations of the built in fortran
functions that are used.</p>
<h3 id="step-4-now-to-ocaml">Step 4: Now to OCaml</h3>
<p>Now in an OCaml file (gtd6.ml) we have to define the external reference
to the function and a function to call it.</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">external temp : int -&gt; float -&gt; float -&gt; float -&gt; float -&gt; float = &quot;gtd6_t&quot;

let () =
  print_double (temp 1 2.0 3.0 4.0 5.0);
  print_newline ()
</code></pre>
<p>This tells OCaml that the temp function takes 5 parameters and returns a
single floating point and calls the C function gtd6_t.</p>
<p>At this point, the steps that are given are to compile this into
bytecode. I don't yet have much experience compiling to native so I'll
let some else help out (or wait until I learn how to do it).</p>
<pre><code>prompt&gt; ocamlc -c gtd6.ml prompt&gt; ocamlc -o test gtd6.cmo wrapper.so
</code></pre>
<p>And voila, we've called the fortran function from OCaml.</p>
|js}
  };
 
  { title = {js|Command-line Arguments|js}
  ; slug = {js|command-line-arguments|js}
  ; description = {js|The Arg module that comes with the compiler can help you write command line interfaces
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["common"]
  ; users = [`Intermediate]
  ; body_md = {js|
In this tutorial we learn how to read command line arguments directly, using
OCaml's `Sys.argv` array, and then how to do so more easily using the standard
library's `Arg` module.

## Sys.argv

Like in C and many other languages, the arguments that are passed to a given
program on the command line are stored in an array. Following tradition, this
array is named `argv`. It is found in the `Sys` module of the standard library,
therefore its full name is `Sys.argv`. The number of arguments including the
name of the program itself is simply the length of the array. It is obtained
using the `Array.length` function.

The following program displays the arguments with their position in `Sys.argv`:

<!-- $MDX file=examples/args.ml -->
```ocaml
let () =
  for i = 0 to Array.length Sys.argv - 1 do
    Printf.printf "[%i] %s\\n" i Sys.argv.(i)
  done
```

If you save the program above as `args.ml`, and run `ocaml args.ml arg1 arg2
arg3`, here is what you get:

<!-- $MDX dir=examples -->
```sh
$ ocaml args.ml arg1 arg2 arg3
[0] args.ml
[1] arg1
[2] arg2
[3] arg3
```

Note that `ocaml` launched a subprocess that actually runs the program where
argv is `args.ml arg1 arg2 arg3`. You can also compile your program using
`ocamlopt -o args args.ml`, and then running `./args arg1 arg2 arg3` and you
will get:

<!-- $MDX dir=examples -->
```sh
$ ocamlopt -o args args.ml
$ ./args arg1 arg2 arg3
[0] ./args
[1] arg1
[2] arg2
[3] arg3
```

## Using the Arg module

The OCaml standard library has a module for writing command line interfaces, so
we do not have to use `Sys.argv` directly. We shall consider the example from
the OCaml documentation, a program for appending files.

First, we set up the usage message to be printed in the case of a malformed
command line, or when help is requested:

<!-- $MDX file=examples/append.ml,part=0 -->
```ocaml
let usage_msg = "append [-verbose] <file1> [<file2>] ... -o <output>"
```

Now, we create some references to hold the information gathered from the
command line. The `Arg` module will fill these in for us as the command line is
read.

<!-- $MDX file=examples/append.ml,part=1 -->
```ocaml
let verbose = ref false

let input_files = ref []

let output_file = ref ""
```

We have a boolean reference for the `-verbose` flag with a default value of
`false`. Then we have a reference to a list which will hold the names of all
the input files. Finally, we have a string reference into which the single
output file name specified by `-o` will be placed.

We will need a function to handle the anonymous inputs, that is to say the ones
with no flag before them. In this case these are our input file names. Our
function simply adds the file name to the reference defined earlier.

<!-- $MDX file=examples/append.ml,part=2 -->
```ocaml
let anon_fun filename = input_files := filename :: !input_files
```

Finally we build the list of command line flag specifcations. Each is a tuple
of the flag name, the action to be taken when it is encountered, and the help
string.

<!-- $MDX file=examples/append.ml,part=3 -->
```ocaml
let speclist =
  [
    ("-verbose", Arg.Set verbose, "Output debug information");
    ("-o", Arg.Set_string output_file, "Set output file name");
  ]
```

We have two kinds of action here: the `Arg.Set` action which sets a boolean
reference, and the `Arg.Set_string` action which sets a string reference. Our
`input_files` reference will of course be updated by the `anon_fun` function
already defined.

We can now call `Arg.parse`, giving it our specification list, anonymous
function, and usage message. Once it returns, the references will be filled
with all the information required to append our files.

<!-- $MDX file=examples/append.ml,part=4 -->
```ocaml
let () = Arg.parse speclist anon_fun usage_msg

(* Main functionality here *)
```

Let's save our program as `append.ml` and compile it with `ocamlopt -o append
append.ml` and try it out:

<!-- $MDX dir=examples -->
```sh
$ ocamlopt -o append append.ml
$ ./append -verbose one.txt two.txt -o three.txt
$ ./append one.txt two.txt
$ ./append -quiet
./append: unknown option '-quiet'.
append [-verbose] <file1> [<file2>] ... -o <output>
  -verbose Output debug information
  -o Set output file name
  -help  Display this list of options
  --help  Display this list of options
[2]
$ ./append -help
append [-verbose] <file1> [<file2>] ... -o <output>
  -verbose Output debug information
  -o Set output file name
  -help  Display this list of options
  --help  Display this list of options
```

Here is the whole program:

```ocaml
let usage_msg = "append [-verbose] <file1> [<file2>] ... -o <output>"

let verbose = ref false

let input_files = ref []

let output_file = ref ""

let anon_fun filename =
  input_files := filename :: !input_files

let speclist =
  [("-verbose", Arg.Set verbose, "Output debug information");
   ("-o", Arg.Set_string output_file, "Set output file name")]

let () =
  Arg.parse speclist anon_fun usage_msg;
  (* Main functionality here *)
```

The `Arg` module has many more actions than just `Set` and `Set_string`, and
some lower-level function for parsing more complicated command lines.

## Other tools for parsing command-line options

There are libraries with facilities different from or more extensive than the
built-in `Arg` module:

* [Cmdliner](https://erratique.ch/software/cmdliner/doc/Cmdliner) is a modern
  interface for command line processing, which also generates UNIX man pages
  automatically.

* [Clap](https://opam.ocaml.org/packages/clap/) is an imperative command line
  parser.

* [Minicli](https://opam.ocaml.org/packages/minicli/) has good support for
  rejecting malformed command lines which others might sliently accept.

* [Getopt](https://opam.ocaml.org/packages/getopt/) for OCaml is similar to
  [GNU getopt](https://www.gnu.org/software/libc/manual/html_node/Getopt.html).
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#sysargv">Sys.argv</a>
</li>
<li><a href="#using-the-arg-module">Using the Arg module</a>
</li>
<li><a href="#other-tools-for-parsing-command-line-options">Other tools for parsing command-line options</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<p>In this tutorial we learn how to read command line arguments directly, using
OCaml's <code>Sys.argv</code> array, and then how to do so more easily using the standard
library's <code>Arg</code> module.</p>
<h2 id="sysargv">Sys.argv</h2>
<p>Like in C and many other languages, the arguments that are passed to a given
program on the command line are stored in an array. Following tradition, this
array is named <code>argv</code>. It is found in the <code>Sys</code> module of the standard library,
therefore its full name is <code>Sys.argv</code>. The number of arguments including the
name of the program itself is simply the length of the array. It is obtained
using the <code>Array.length</code> function.</p>
<p>The following program displays the arguments with their position in <code>Sys.argv</code>:</p>
<!-- $MDX file=examples/args.ml -->
<pre><code class="language-ocaml">let () =
  for i = 0 to Array.length Sys.argv - 1 do
    Printf.printf &quot;[%i] %s\\n&quot; i Sys.argv.(i)
  done
</code></pre>
<p>If you save the program above as <code>args.ml</code>, and run <code>ocaml args.ml arg1 arg2 arg3</code>, here is what you get:</p>
<!-- $MDX dir=examples -->
<pre><code class="language-sh">$ ocaml args.ml arg1 arg2 arg3
[0] args.ml
[1] arg1
[2] arg2
[3] arg3
</code></pre>
<p>Note that <code>ocaml</code> launched a subprocess that actually runs the program where
argv is <code>args.ml arg1 arg2 arg3</code>. You can also compile your program using
<code>ocamlopt -o args args.ml</code>, and then running <code>./args arg1 arg2 arg3</code> and you
will get:</p>
<!-- $MDX dir=examples -->
<pre><code class="language-sh">$ ocamlopt -o args args.ml
$ ./args arg1 arg2 arg3
[0] ./args
[1] arg1
[2] arg2
[3] arg3
</code></pre>
<h2 id="using-the-arg-module">Using the Arg module</h2>
<p>The OCaml standard library has a module for writing command line interfaces, so
we do not have to use <code>Sys.argv</code> directly. We shall consider the example from
the OCaml documentation, a program for appending files.</p>
<p>First, we set up the usage message to be printed in the case of a malformed
command line, or when help is requested:</p>
<!-- $MDX file=examples/append.ml,part=0 -->
<pre><code class="language-ocaml">let usage_msg = &quot;append [-verbose] &lt;file1&gt; [&lt;file2&gt;] ... -o &lt;output&gt;&quot;
</code></pre>
<p>Now, we create some references to hold the information gathered from the
command line. The <code>Arg</code> module will fill these in for us as the command line is
read.</p>
<!-- $MDX file=examples/append.ml,part=1 -->
<pre><code class="language-ocaml">let verbose = ref false

let input_files = ref []

let output_file = ref &quot;&quot;
</code></pre>
<p>We have a boolean reference for the <code>-verbose</code> flag with a default value of
<code>false</code>. Then we have a reference to a list which will hold the names of all
the input files. Finally, we have a string reference into which the single
output file name specified by <code>-o</code> will be placed.</p>
<p>We will need a function to handle the anonymous inputs, that is to say the ones
with no flag before them. In this case these are our input file names. Our
function simply adds the file name to the reference defined earlier.</p>
<!-- $MDX file=examples/append.ml,part=2 -->
<pre><code class="language-ocaml">let anon_fun filename = input_files := filename :: !input_files
</code></pre>
<p>Finally we build the list of command line flag specifcations. Each is a tuple
of the flag name, the action to be taken when it is encountered, and the help
string.</p>
<!-- $MDX file=examples/append.ml,part=3 -->
<pre><code class="language-ocaml">let speclist =
  [
    (&quot;-verbose&quot;, Arg.Set verbose, &quot;Output debug information&quot;);
    (&quot;-o&quot;, Arg.Set_string output_file, &quot;Set output file name&quot;);
  ]
</code></pre>
<p>We have two kinds of action here: the <code>Arg.Set</code> action which sets a boolean
reference, and the <code>Arg.Set_string</code> action which sets a string reference. Our
<code>input_files</code> reference will of course be updated by the <code>anon_fun</code> function
already defined.</p>
<p>We can now call <code>Arg.parse</code>, giving it our specification list, anonymous
function, and usage message. Once it returns, the references will be filled
with all the information required to append our files.</p>
<!-- $MDX file=examples/append.ml,part=4 -->
<pre><code class="language-ocaml">let () = Arg.parse speclist anon_fun usage_msg

(* Main functionality here *)
</code></pre>
<p>Let's save our program as <code>append.ml</code> and compile it with <code>ocamlopt -o append append.ml</code> and try it out:</p>
<!-- $MDX dir=examples -->
<pre><code class="language-sh">$ ocamlopt -o append append.ml
$ ./append -verbose one.txt two.txt -o three.txt
$ ./append one.txt two.txt
$ ./append -quiet
./append: unknown option '-quiet'.
append [-verbose] &lt;file1&gt; [&lt;file2&gt;] ... -o &lt;output&gt;
  -verbose Output debug information
  -o Set output file name
  -help  Display this list of options
  --help  Display this list of options
[2]
$ ./append -help
append [-verbose] &lt;file1&gt; [&lt;file2&gt;] ... -o &lt;output&gt;
  -verbose Output debug information
  -o Set output file name
  -help  Display this list of options
  --help  Display this list of options
</code></pre>
<p>Here is the whole program:</p>
<pre><code class="language-ocaml">let usage_msg = &quot;append [-verbose] &lt;file1&gt; [&lt;file2&gt;] ... -o &lt;output&gt;&quot;

let verbose = ref false

let input_files = ref []

let output_file = ref &quot;&quot;

let anon_fun filename =
  input_files := filename :: !input_files

let speclist =
  [(&quot;-verbose&quot;, Arg.Set verbose, &quot;Output debug information&quot;);
   (&quot;-o&quot;, Arg.Set_string output_file, &quot;Set output file name&quot;)]

let () =
  Arg.parse speclist anon_fun usage_msg;
  (* Main functionality here *)
</code></pre>
<p>The <code>Arg</code> module has many more actions than just <code>Set</code> and <code>Set_string</code>, and
some lower-level function for parsing more complicated command lines.</p>
<h2 id="other-tools-for-parsing-command-line-options">Other tools for parsing command-line options</h2>
<p>There are libraries with facilities different from or more extensive than the
built-in <code>Arg</code> module:</p>
<ul>
<li>
<p><a href="https://erratique.ch/software/cmdliner/doc/Cmdliner">Cmdliner</a> is a modern
interface for command line processing, which also generates UNIX man pages
automatically.</p>
</li>
<li>
<p><a href="https://opam.ocaml.org/packages/clap/">Clap</a> is an imperative command line
parser.</p>
</li>
<li>
<p><a href="https://opam.ocaml.org/packages/minicli/">Minicli</a> has good support for
rejecting malformed command lines which others might sliently accept.</p>
</li>
<li>
<p><a href="https://opam.ocaml.org/packages/getopt/">Getopt</a> for OCaml is similar to
<a href="https://www.gnu.org/software/libc/manual/html_node/Getopt.html">GNU getopt</a>.</p>
</li>
</ul>
|js}
  };
 
  { title = {js|File Manipulation|js}
  ; slug = {js|file-manipulation|js}
  ; description = {js|A guide to basic file manipulation in OCaml with the standard library
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["common"]
  ; users = [`Beginner; `Intermediate]
  ; body_md = {js|
This is a guide to basic file manipulation in OCaml using only the
standard library.

<!-- TODO: links to new API locations -->
Official documentation for the modules of interest:
the core library including the initially opened module Stdlib and Printf.

## Buffered channels
The normal way of opening a file in OCaml returns a **channel**. There
are two kinds of channels:

* channels that write to a file: type `out_channel`
* channels that read from a file: type `in_channel`

###  Writing
For writing into a file, you would do this:

1. Open the file to obtain an `out_channel`
1. Write to the channel
1. If you want to force writing to the physical device, you must flush
 the channel, otherwise writing will not take place immediately.
1. When you are done, you can close the channel. This flushes the
 channel automatically.

Commonly used functions: `open_out`, `open_out_bin`, `flush`,
`close_out`, `close_out_noerr`

Standard `out_channel`s: `stdout`, `stderr`

###  Reading
For reading data from a file you would do this:

1. Open the file to obtain an `in_channel`
1. Read characters from the channel. Reading consumes the channel, so
 if you read a character, the channel will point to the next
 character in the file.
1. When there are no more characters to read, the `End_of_file`
 exception is raised. Often, this is where you want to close the
 channel.

Commonly used functions: `open_in`, `open_in_bin`, `close_in`,
`close_in_noerr`

Standard `in_channel`: `stdin`

###  Seeking
Whenever you write or read something to or from a channel, the current
position changes to the next character after what you just wrote or
read. Occasionally, you may want to skip to a particular position in the
file, or restart reading from the beginning. This is possible for
channels that point to regular files, use `seek_in` or `seek_out`.

###  Gotchas
* Don't forget to flush your `out_channel`s if you want to actually
 write something. This is particularly important if you are writing
 to non-files such as the standard output (`stdout`) or a socket.
* Don't forget to close any unused channel, because operating systems
 have a limit on the number of files that can be opened
 simultaneously. You must catch any exception that would occur during
 the file manipulation, close the corresponding channel, and re-raise
 the exception.
* The `Unix` module provides access to non-buffered file descriptors
 among other things. It provides standard file descriptors that have
 the same name as the corresponding standard channels: `stdin`,
 `stdout` and `stderr`. Therefore if you do `open Unix`, you may get
 type errors. If you want to be sure that you are using the `stdout`
 channel and not the `stdout` file descriptor, you can prepend it
 with the module name where it comes from: `Stdlib.stdout`. *Note
 that most things that don't seem to belong to any module actually
 belong to the `Stdlib` module, which is automatically opened.*
* `open_out` and `open_out_bin` truncate the given file if it already
 exists! Use `open_out_gen` if you want an alternate behavior.

###  Example

<!-- $MDX file=examples/file_manip.ml -->
```ocaml
let file = "example.dat"

let message = "Hello!"

let () =
  (* Write message to file *)
  let oc = open_out file in
  (* create or truncate file, return channel *)
  Printf.fprintf oc "%s\\n" message;
  (* write something *)
  close_out oc;

  (* flush and close the channel *)

  (* Read file and display the first line *)
  let ic = open_in file in
  try
    let line = input_line ic in
    (* read line, discard \\n *)
    print_endline line;
    (* write the result to stdout *)
    flush stdout;
    (* write on the underlying device now *)
    close_in ic
    (* close the input channel *)
  with e ->
    (* some unexpected exception occurs *)
    close_in_noerr ic;
    (* emergency closing *)
    raise e

(* exit with error: files are closed but channels are not flushed *)

(* normal exit: all channels are flushed and closed *)
```

We can compile and run this example: 

<!-- $MDX dir=examples -->
```sh
$ ocamlopt -o file_manip file_manip.ml
$ ./file_manip
Hello!
```
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#buffered-channels">Buffered channels</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<p>This is a guide to basic file manipulation in OCaml using only the
standard library.</p>
<!-- TODO: links to new API locations -->
<p>Official documentation for the modules of interest:
the core library including the initially opened module Stdlib and Printf.</p>
<h2 id="buffered-channels">Buffered channels</h2>
<p>The normal way of opening a file in OCaml returns a <strong>channel</strong>. There
are two kinds of channels:</p>
<ul>
<li>channels that write to a file: type <code>out_channel</code>
</li>
<li>channels that read from a file: type <code>in_channel</code>
</li>
</ul>
<h3 id="writing">Writing</h3>
<p>For writing into a file, you would do this:</p>
<ol>
<li>Open the file to obtain an <code>out_channel</code>
</li>
<li>Write to the channel
</li>
<li>If you want to force writing to the physical device, you must flush
the channel, otherwise writing will not take place immediately.
</li>
<li>When you are done, you can close the channel. This flushes the
channel automatically.
</li>
</ol>
<p>Commonly used functions: <code>open_out</code>, <code>open_out_bin</code>, <code>flush</code>,
<code>close_out</code>, <code>close_out_noerr</code></p>
<p>Standard <code>out_channel</code>s: <code>stdout</code>, <code>stderr</code></p>
<h3 id="reading">Reading</h3>
<p>For reading data from a file you would do this:</p>
<ol>
<li>Open the file to obtain an <code>in_channel</code>
</li>
<li>Read characters from the channel. Reading consumes the channel, so
if you read a character, the channel will point to the next
character in the file.
</li>
<li>When there are no more characters to read, the <code>End_of_file</code>
exception is raised. Often, this is where you want to close the
channel.
</li>
</ol>
<p>Commonly used functions: <code>open_in</code>, <code>open_in_bin</code>, <code>close_in</code>,
<code>close_in_noerr</code></p>
<p>Standard <code>in_channel</code>: <code>stdin</code></p>
<h3 id="seeking">Seeking</h3>
<p>Whenever you write or read something to or from a channel, the current
position changes to the next character after what you just wrote or
read. Occasionally, you may want to skip to a particular position in the
file, or restart reading from the beginning. This is possible for
channels that point to regular files, use <code>seek_in</code> or <code>seek_out</code>.</p>
<h3 id="gotchas">Gotchas</h3>
<ul>
<li>Don't forget to flush your <code>out_channel</code>s if you want to actually
write something. This is particularly important if you are writing
to non-files such as the standard output (<code>stdout</code>) or a socket.
</li>
<li>Don't forget to close any unused channel, because operating systems
have a limit on the number of files that can be opened
simultaneously. You must catch any exception that would occur during
the file manipulation, close the corresponding channel, and re-raise
the exception.
</li>
<li>The <code>Unix</code> module provides access to non-buffered file descriptors
among other things. It provides standard file descriptors that have
the same name as the corresponding standard channels: <code>stdin</code>,
<code>stdout</code> and <code>stderr</code>. Therefore if you do <code>open Unix</code>, you may get
type errors. If you want to be sure that you are using the <code>stdout</code>
channel and not the <code>stdout</code> file descriptor, you can prepend it
with the module name where it comes from: <code>Stdlib.stdout</code>. <em>Note
that most things that don't seem to belong to any module actually
belong to the <code>Stdlib</code> module, which is automatically opened.</em>
</li>
<li><code>open_out</code> and <code>open_out_bin</code> truncate the given file if it already
exists! Use <code>open_out_gen</code> if you want an alternate behavior.
</li>
</ul>
<h3 id="example">Example</h3>
<!-- $MDX file=examples/file_manip.ml -->
<pre><code class="language-ocaml">let file = &quot;example.dat&quot;

let message = &quot;Hello!&quot;

let () =
  (* Write message to file *)
  let oc = open_out file in
  (* create or truncate file, return channel *)
  Printf.fprintf oc &quot;%s\\n&quot; message;
  (* write something *)
  close_out oc;

  (* flush and close the channel *)

  (* Read file and display the first line *)
  let ic = open_in file in
  try
    let line = input_line ic in
    (* read line, discard \\n *)
    print_endline line;
    (* write the result to stdout *)
    flush stdout;
    (* write on the underlying device now *)
    close_in ic
    (* close the input channel *)
  with e -&gt;
    (* some unexpected exception occurs *)
    close_in_noerr ic;
    (* emergency closing *)
    raise e

(* exit with error: files are closed but channels are not flushed *)

(* normal exit: all channels are flushed and closed *)
</code></pre>
<p>We can compile and run this example:</p>
<!-- $MDX dir=examples -->
<pre><code class="language-sh">$ ocamlopt -o file_manip file_manip.ml
$ ./file_manip
Hello!
</code></pre>
|js}
  };
 
  { title = {js|Garbage Collection|js}
  ; slug = {js|garbage-collection|js}
  ; description = {js|OCaml is a garbage collected language meaning you don't have to worry about allocating and freeing memory
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["advanced"]
  ; users = [`Intermediate; `Advanced]
  ; body_md = {js|
## Garbage collection, reference counting, explicit allocation

As with all modern languages, OCaml provides a garbage collector so that
you don't need to explicitly allocate and free memory as in C/C++.

The OCaml garbage collector is a modern hybrid generational/incremental
collector which outperforms hand-allocation in most cases.

Why would garbage collection be faster than explicit memory allocation
as in C? It's often assumed that calling `free` costs nothing. In fact
`free` is an expensive operation which involves navigating over the
complex data structures used by the memory allocator. If your program
calls `free` intermittently, then all of that code and data needs to be
loaded into the cache, displacing your program code and data, each time
you `free` a single memory allocation. A collection strategy which frees
multiple memory areas in one go (such as either a pool allocator or a
GC) pays this penalty only once for multiple allocations (thus the cost
per allocation is much reduced).

GCs also move memory areas around and compact the heap. This makes
allocation easier, hence faster, and a smart GC can be written to
interact well with the L1 and L2 caches.

Of course none of this precludes writing a very fast hand-allocator, but
it's considerably harder work than most programmers realise.

OCaml's garbage collector has two heaps, the **minor heap** and the
**major heap**. This recognises a general principle: Most objects are
small and allocated frequently and then immediately freed. These objects
go into the minor heap first, which is GCed frequently. Only some
objects are long lasting. These objects get promoted from the minor heap
to the major heap after some time, and the major heap is only collected
infrequently.

The OCaml GC is synchronous. It doesn't run in a separate thread, and it
can only get called during an allocation request.

###  GC vs. reference counting
Python has a form of garbage collection, but it uses a simple scheme
called **reference counting**. Simply put, each Python object keeps a
count of the number of other objects pointing (referencing) itself. When
the count falls to zero, nothing is pointing at this object, and so the
object can be freed.

Reference counting is not considered as serious garbage collection by
computer scientists, yet it has one big practical advantage over full
garbage collectors. With reference counting, you can avoid many explicit
calls to `close`/`closedir` in code. Whereas in OCaml

<!-- $MDX skip -->
```ocaml
let read_file filename =
  let chan = open_in filename in
  (* read from chan *) in
List.iter read_file files
```

Calls to `read_file` open the file but don't close it. Because OCaml
uses a full garbage collector `chan` isn't collected until some time
later when the minor heap becomes full. In addition, **OCaml will not
close the channel when it collects the handle's memory**. So this
program would eventually run out of file descriptors.

You need to be aware of this when writing OCaml code which uses files or
directories or any other heavyweight object with complex finalisation.

To be fair to full garbage collection, I should mention the
disadvantages of reference counting schemes:

* Each object needs to store a reference count. In other words there's
 a word overhead for every object. Programs use more memory, and are
 consequently slower because they are more likely to fill up the
 cache or spill into swap.
* Reference counting is expensive - every time you manipulate pointers
 to an object you need to update and check the reference count.
 Pointer manipulation is frequent, so this slows your program and
 bloats the code size of compiled code.
* They cannot collect so-called circular, or self-referential
 structures. I've programmed in many languages in many years and
 can't recall ever having created one of these.
* Graph algorithms, of course, violate the previous assumption.

## The Gc module
The `Gc` module contains some useful functions for querying and calling
the garbage collector from OCaml programs.

Here is a program which runs and then prints out GC statistics just
before quitting:

<!-- TODO: Probably write a GC example without dependencies -->

<!-- $MDX file=examples/gc.ml -->
```ocaml
let rec iterate r x_init i =
  if i = 1 then x_init
  else
    let x = iterate r x_init (i - 1) in
    r *. x *. (1.0 -. x)

let () =
  Random.self_init ();
  Graphics.open_graph " 640x480";
  for x = 0 to 640 do
    let r = 4.0 *. float_of_int x /. 640.0 in
    for i = 0 to 39 do
      let x_init = Random.float 1.0 in
      let x_final = iterate r x_init 500 in
      let y = int_of_float (x_final *. 480.) in
      Graphics.plot x y
    done
  done;
  Gc.print_stat stdout
```

Here is what it printed out for me:

```
minor_words: 115926165     # Total number of words allocated
promoted_words: 31217      # Promoted from minor -> major
major_words: 31902         # Large objects allocated in major directly
minor_collections: 3538    # Number of minor heap collections
major_collections: 39      # Number of major heap collections
heap_words: 63488          # Size of the heap, in words = approx. 256K
heap_chunks: 1
top_heap_words: 63488
live_words: 2694
live_blocks: 733
free_words: 60794
free_blocks: 4
largest_free: 31586
fragments: 0
compactions: 0
```

We can see that minor heap collections are approximately 100 times more
frequent than major heap collections (in this example, not necessarily
in general). Over the lifetime of the program, an astonishing 440 MB of
memory was allocated, although of course most of that would have been
immediately freed in a minor collection. Only about 128K was promoted to
long-term storage on the major heap, and about another 128K consisted of
large objects which would have been allocated directly onto the major
heap.

We can instruct the GC to print out debugging messages when one of
several events happen (eg. on every major collection). Try adding the
following code to the example above near the beginning:

<!-- $MDX skip -->
```ocaml
# Gc.set {(Gc.get ()) with Gc.verbose = 0x01}
```

(We haven't seen the `{ expression with field = value }` form before,
but it should be mostly obvious what it does). The above code anyway
causes the GC to print a message at the start of every major collection.

## Finalisation and the Weak module
We can write a function called a **finaliser** which is called when an
object is about to be freed by the GC.

The `Weak` module lets us create so-called weak pointers. A **weak
pointer** is best defined by comparing it to a "normal pointer". When we
have an ordinary OCaml object, we reference that object through a name
(eg. `let name = ... in`) or through another object. The garbage
collector sees that we have a reference to that object and won't collect
it. That's what you might call a "normal pointer". If, however, you hold
a weak pointer or weak reference to an object, then you hint to the
garbage collector that it may collect the object at any time. (Not
necessarily that it *will* collect the object). Some time later, when
you come to examine the object, you can either turn your weak pointer
into a normal pointer, or else you can be informed that the GC did
actually collect the object.

Finalisation and weak pointers can be used together to implement an
in-memory object database cache. Let's imagine that we have a very large
number of large user records in a file on disk. This is far too much
data to be loaded into memory all at once, and anyway other programs
might access the data on the disk, so we need to lock individual records
when we hold copies of them in memory.

The *public* interface to our "in-memory object database cache" is going
to be just two functions:

<!-- $MDX skip -->
```ocaml
type record = {mutable name : string; mutable address : string}
val get_record : int -> record
val sync_records : unit -> unit
```

The `get_record` call is the only call that most programs will need to
make. It gets the n<sup>th</sup> record either out of the cache or from
disk and returns it. The program can then read and/or update the
`record.name` and `record.address` fields. The program then just
literally forgets about the record! Behind the scenes, finalisation is
going to write the record back out to disk at some later point in time.

The `sync_records` function can also be called by user programs. This
function synchronises the disk copy and in-memory copies of all records.

OCaml doesn't currently run finalisers at exit. However you can easily
force it to by adding the following command to your code. This command
causes a full major GC cycle on exit:

<!-- $MDX skip -->
```ocaml
at_exit Gc.full_major
```

Our code is also going to implement a cache of recently accessed records
using the `Weak` module. The advantage of using the `Weak` module rather
than hand-rolling our own code is two-fold: Firstly the garbage
collector has a global view of memory requirements for the whole
program, and so is in a better position to decide when to shrink the
cache. Secondly our code will be much simpler.

For our example, we're going to use a very simple format for the file of
users' records. The file is just a list of user records, each user
record having a fixed size of 256 bytes. Each user record has just two
fields (padded with spaces if necessary), the name field (64 bytes) and
the address field (192 bytes). Before a record can be loaded into
memory, the program must acquire an exclusive lock on the record. After
the in-memory copy is written back out to the file, the program must
release the lock. Here is some code to define the on-disk format and
some low-level functions to read, write, lock and unlock records:


<!-- $MDX file=examples/objcache.ml,part=0 -->
```ocaml
(* In-memory format. *)
type record = { mutable name : string; mutable address : string }

(* On-disk format. *)
let record_size = 256

let name_size = 64

let addr_size = 192

(* Low-level load/save records to file. *)
let seek_record n fd = ignore (Unix.lseek fd (n * record_size) Unix.SEEK_SET)

let write_record record n fd =
  seek_record n fd;
  ignore (Unix.write fd (Bytes.of_string record.name) 0 name_size);
  ignore (Unix.write fd (Bytes.of_string record.address) 0 addr_size)

let read_record record n fd =
  seek_record n fd;
  ignore (Unix.read fd (Bytes.of_string record.name) 0 name_size);
  ignore (Unix.read fd (Bytes.of_string record.address) 0 addr_size)

(* Lock/unlock the nth record in a file. *)
let lock_record n fd =
  seek_record n fd;
  Unix.lockf fd Unix.F_LOCK record_size

let unlock_record n fd =
  seek_record n fd;
  Unix.lockf fd Unix.F_ULOCK record_size
```

We also need a function to create new, empty in-memory `record` objects:

<!-- $MDX file=examples/objcache.ml,part=1 -->
```ocaml
(* Create a new, empty record. *)
let new_record () =
  { name = String.make name_size ' '; address = String.make addr_size ' ' }
```


Because this is a really simple program, we're going to fix the number
of records in advance:

<!-- $MDX file=examples/objcache.ml,part=2 -->
```ocaml
(* Total number of records. *)
let nr_records = 10000

(* On-disk file. *)
let diskfile = Unix.openfile "users.bin" [ Unix.O_RDWR; Unix.O_CREAT ] 0o666
```

Download [users.bin.gz](users.bin.gz) and decompress it before
running the program.

Our cache of records is very simple:

<!-- $MDX file=examples/objcache.ml,part=3 -->
```ocaml
(* Cache of records. *)
let cache = Weak.create nr_records
```

The `get_record` function is very short and basically composed of two
halves. We grab the record from the cache. If the cache gives us `None`,
then that either means that we haven't loaded this record from the cache
yet, or else it has been written out to disk (finalised) and dropped
from the cache. If the cache gives us `Some record` then we just return
`record` (this promotes the weak pointer to the record to a normal
pointer).


<!-- $MDX file=examples/objcache.ml,part=4 -->
```ocaml
(* The finaliser function. *)
let finaliser n record =
  printf "*** objcache: finalising record %d\\n%!" n;
  write_record record n diskfile;
  unlock_record n diskfile

(* Get a record from the cache or off disk. *)
let get_record n =
  match Weak.get cache n with
  | Some record ->
      printf "*** objcache: fetching record %d from memory cache\\n%!" n;
      record
  | None ->
      printf "*** objcache: loading record %d from disk\\n%!" n;
      let record = new_record () in
      Gc.finalise (finaliser n) record;
      lock_record n diskfile;
      read_record record n diskfile;
      Weak.set cache n (Some record);
      record
```

The `sync_records` function is even easier. First of all it empties the
cache by replacing all the weak pointers with `None`. This now means
that the garbage collector *can* collect and finalise all of those
records. But it doesn't necessarily mean that the GC *will* collect the
records straightaway (in fact it's not likely that it will), so to force
the GC to collect the records immediately, we also invoke a major cycle:


Finally we have some test code. I won't reproduce the test code, but you
can download the complete program and test code
[objcache.ml](objcache.ml), and compile it with:

<!-- $MDX dir=examples -->
```sh
$ ocamlc unix.cma objcache.ml -o objcache
```

## Exercises
Here are some ways to extend the example above, in approximately
increasing order of difficulty:

1. Implement the record as an **object**, and allow it to transparently
 pad/unpad strings. You will need to provide methods to set and get
 the name and address fields (four public methods in all). Hide as
 much of the implementation (file access, locking) code in the class
 as possible.
1. Extend the program so that it acquires a **read lock** on getting
 the record, but upgrades this to a **write lock** just before the
 user updates any field.
1. Support a **variable number of records** and add a function to
 create a new record (in the file). [Tip: OCaml has support for weak
 hashtables.]
1. Add support for **variable-length records**.
1. Make the underlying file representation a **DBM-style hash**.
1. Provide a general-purpose cache fronting a "users" table in your
 choice of **relational database** (with locking).
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#garbage-collection-reference-counting-explicit-allocation">Garbage collection, reference counting, explicit allocation</a>
</li>
<li><a href="#the-gc-module">The Gc module</a>
</li>
<li><a href="#finalisation-and-the-weak-module">Finalisation and the Weak module</a>
</li>
<li><a href="#exercises">Exercises</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<h2 id="garbage-collection-reference-counting-explicit-allocation">Garbage collection, reference counting, explicit allocation</h2>
<p>As with all modern languages, OCaml provides a garbage collector so that
you don't need to explicitly allocate and free memory as in C/C++.</p>
<p>The OCaml garbage collector is a modern hybrid generational/incremental
collector which outperforms hand-allocation in most cases.</p>
<p>Why would garbage collection be faster than explicit memory allocation
as in C? It's often assumed that calling <code>free</code> costs nothing. In fact
<code>free</code> is an expensive operation which involves navigating over the
complex data structures used by the memory allocator. If your program
calls <code>free</code> intermittently, then all of that code and data needs to be
loaded into the cache, displacing your program code and data, each time
you <code>free</code> a single memory allocation. A collection strategy which frees
multiple memory areas in one go (such as either a pool allocator or a
GC) pays this penalty only once for multiple allocations (thus the cost
per allocation is much reduced).</p>
<p>GCs also move memory areas around and compact the heap. This makes
allocation easier, hence faster, and a smart GC can be written to
interact well with the L1 and L2 caches.</p>
<p>Of course none of this precludes writing a very fast hand-allocator, but
it's considerably harder work than most programmers realise.</p>
<p>OCaml's garbage collector has two heaps, the <strong>minor heap</strong> and the
<strong>major heap</strong>. This recognises a general principle: Most objects are
small and allocated frequently and then immediately freed. These objects
go into the minor heap first, which is GCed frequently. Only some
objects are long lasting. These objects get promoted from the minor heap
to the major heap after some time, and the major heap is only collected
infrequently.</p>
<p>The OCaml GC is synchronous. It doesn't run in a separate thread, and it
can only get called during an allocation request.</p>
<h3 id="gc-vs-reference-counting">GC vs. reference counting</h3>
<p>Python has a form of garbage collection, but it uses a simple scheme
called <strong>reference counting</strong>. Simply put, each Python object keeps a
count of the number of other objects pointing (referencing) itself. When
the count falls to zero, nothing is pointing at this object, and so the
object can be freed.</p>
<p>Reference counting is not considered as serious garbage collection by
computer scientists, yet it has one big practical advantage over full
garbage collectors. With reference counting, you can avoid many explicit
calls to <code>close</code>/<code>closedir</code> in code. Whereas in OCaml</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">let read_file filename =
  let chan = open_in filename in
  (* read from chan *) in
List.iter read_file files
</code></pre>
<p>Calls to <code>read_file</code> open the file but don't close it. Because OCaml
uses a full garbage collector <code>chan</code> isn't collected until some time
later when the minor heap becomes full. In addition, <strong>OCaml will not
close the channel when it collects the handle's memory</strong>. So this
program would eventually run out of file descriptors.</p>
<p>You need to be aware of this when writing OCaml code which uses files or
directories or any other heavyweight object with complex finalisation.</p>
<p>To be fair to full garbage collection, I should mention the
disadvantages of reference counting schemes:</p>
<ul>
<li>Each object needs to store a reference count. In other words there's
a word overhead for every object. Programs use more memory, and are
consequently slower because they are more likely to fill up the
cache or spill into swap.
</li>
<li>Reference counting is expensive - every time you manipulate pointers
to an object you need to update and check the reference count.
Pointer manipulation is frequent, so this slows your program and
bloats the code size of compiled code.
</li>
<li>They cannot collect so-called circular, or self-referential
structures. I've programmed in many languages in many years and
can't recall ever having created one of these.
</li>
<li>Graph algorithms, of course, violate the previous assumption.
</li>
</ul>
<h2 id="the-gc-module">The Gc module</h2>
<p>The <code>Gc</code> module contains some useful functions for querying and calling
the garbage collector from OCaml programs.</p>
<p>Here is a program which runs and then prints out GC statistics just
before quitting:</p>
<!-- TODO: Probably write a GC example without dependencies -->
<!-- $MDX file=examples/gc.ml -->
<pre><code class="language-ocaml">let rec iterate r x_init i =
  if i = 1 then x_init
  else
    let x = iterate r x_init (i - 1) in
    r *. x *. (1.0 -. x)

let () =
  Random.self_init ();
  Graphics.open_graph &quot; 640x480&quot;;
  for x = 0 to 640 do
    let r = 4.0 *. float_of_int x /. 640.0 in
    for i = 0 to 39 do
      let x_init = Random.float 1.0 in
      let x_final = iterate r x_init 500 in
      let y = int_of_float (x_final *. 480.) in
      Graphics.plot x y
    done
  done;
  Gc.print_stat stdout
</code></pre>
<p>Here is what it printed out for me:</p>
<pre><code>minor_words: 115926165     # Total number of words allocated
promoted_words: 31217      # Promoted from minor -&gt; major
major_words: 31902         # Large objects allocated in major directly
minor_collections: 3538    # Number of minor heap collections
major_collections: 39      # Number of major heap collections
heap_words: 63488          # Size of the heap, in words = approx. 256K
heap_chunks: 1
top_heap_words: 63488
live_words: 2694
live_blocks: 733
free_words: 60794
free_blocks: 4
largest_free: 31586
fragments: 0
compactions: 0
</code></pre>
<p>We can see that minor heap collections are approximately 100 times more
frequent than major heap collections (in this example, not necessarily
in general). Over the lifetime of the program, an astonishing 440 MB of
memory was allocated, although of course most of that would have been
immediately freed in a minor collection. Only about 128K was promoted to
long-term storage on the major heap, and about another 128K consisted of
large objects which would have been allocated directly onto the major
heap.</p>
<p>We can instruct the GC to print out debugging messages when one of
several events happen (eg. on every major collection). Try adding the
following code to the example above near the beginning:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml"># Gc.set {(Gc.get ()) with Gc.verbose = 0x01}
</code></pre>
<p>(We haven't seen the <code>{ expression with field = value }</code> form before,
but it should be mostly obvious what it does). The above code anyway
causes the GC to print a message at the start of every major collection.</p>
<h2 id="finalisation-and-the-weak-module">Finalisation and the Weak module</h2>
<p>We can write a function called a <strong>finaliser</strong> which is called when an
object is about to be freed by the GC.</p>
<p>The <code>Weak</code> module lets us create so-called weak pointers. A <strong>weak
pointer</strong> is best defined by comparing it to a &quot;normal pointer&quot;. When we
have an ordinary OCaml object, we reference that object through a name
(eg. <code>let name = ... in</code>) or through another object. The garbage
collector sees that we have a reference to that object and won't collect
it. That's what you might call a &quot;normal pointer&quot;. If, however, you hold
a weak pointer or weak reference to an object, then you hint to the
garbage collector that it may collect the object at any time. (Not
necessarily that it <em>will</em> collect the object). Some time later, when
you come to examine the object, you can either turn your weak pointer
into a normal pointer, or else you can be informed that the GC did
actually collect the object.</p>
<p>Finalisation and weak pointers can be used together to implement an
in-memory object database cache. Let's imagine that we have a very large
number of large user records in a file on disk. This is far too much
data to be loaded into memory all at once, and anyway other programs
might access the data on the disk, so we need to lock individual records
when we hold copies of them in memory.</p>
<p>The <em>public</em> interface to our &quot;in-memory object database cache&quot; is going
to be just two functions:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">type record = {mutable name : string; mutable address : string}
val get_record : int -&gt; record
val sync_records : unit -&gt; unit
</code></pre>
<p>The <code>get_record</code> call is the only call that most programs will need to
make. It gets the n<sup>th</sup> record either out of the cache or from
disk and returns it. The program can then read and/or update the
<code>record.name</code> and <code>record.address</code> fields. The program then just
literally forgets about the record! Behind the scenes, finalisation is
going to write the record back out to disk at some later point in time.</p>
<p>The <code>sync_records</code> function can also be called by user programs. This
function synchronises the disk copy and in-memory copies of all records.</p>
<p>OCaml doesn't currently run finalisers at exit. However you can easily
force it to by adding the following command to your code. This command
causes a full major GC cycle on exit:</p>
<!-- $MDX skip -->
<pre><code class="language-ocaml">at_exit Gc.full_major
</code></pre>
<p>Our code is also going to implement a cache of recently accessed records
using the <code>Weak</code> module. The advantage of using the <code>Weak</code> module rather
than hand-rolling our own code is two-fold: Firstly the garbage
collector has a global view of memory requirements for the whole
program, and so is in a better position to decide when to shrink the
cache. Secondly our code will be much simpler.</p>
<p>For our example, we're going to use a very simple format for the file of
users' records. The file is just a list of user records, each user
record having a fixed size of 256 bytes. Each user record has just two
fields (padded with spaces if necessary), the name field (64 bytes) and
the address field (192 bytes). Before a record can be loaded into
memory, the program must acquire an exclusive lock on the record. After
the in-memory copy is written back out to the file, the program must
release the lock. Here is some code to define the on-disk format and
some low-level functions to read, write, lock and unlock records:</p>
<!-- $MDX file=examples/objcache.ml,part=0 -->
<pre><code class="language-ocaml">(* In-memory format. *)
type record = { mutable name : string; mutable address : string }

(* On-disk format. *)
let record_size = 256

let name_size = 64

let addr_size = 192

(* Low-level load/save records to file. *)
let seek_record n fd = ignore (Unix.lseek fd (n * record_size) Unix.SEEK_SET)

let write_record record n fd =
  seek_record n fd;
  ignore (Unix.write fd (Bytes.of_string record.name) 0 name_size);
  ignore (Unix.write fd (Bytes.of_string record.address) 0 addr_size)

let read_record record n fd =
  seek_record n fd;
  ignore (Unix.read fd (Bytes.of_string record.name) 0 name_size);
  ignore (Unix.read fd (Bytes.of_string record.address) 0 addr_size)

(* Lock/unlock the nth record in a file. *)
let lock_record n fd =
  seek_record n fd;
  Unix.lockf fd Unix.F_LOCK record_size

let unlock_record n fd =
  seek_record n fd;
  Unix.lockf fd Unix.F_ULOCK record_size
</code></pre>
<p>We also need a function to create new, empty in-memory <code>record</code> objects:</p>
<!-- $MDX file=examples/objcache.ml,part=1 -->
<pre><code class="language-ocaml">(* Create a new, empty record. *)
let new_record () =
  { name = String.make name_size ' '; address = String.make addr_size ' ' }
</code></pre>
<p>Because this is a really simple program, we're going to fix the number
of records in advance:</p>
<!-- $MDX file=examples/objcache.ml,part=2 -->
<pre><code class="language-ocaml">(* Total number of records. *)
let nr_records = 10000

(* On-disk file. *)
let diskfile = Unix.openfile &quot;users.bin&quot; [ Unix.O_RDWR; Unix.O_CREAT ] 0o666
</code></pre>
<p>Download <a href="users.bin.gz">users.bin.gz</a> and decompress it before
running the program.</p>
<p>Our cache of records is very simple:</p>
<!-- $MDX file=examples/objcache.ml,part=3 -->
<pre><code class="language-ocaml">(* Cache of records. *)
let cache = Weak.create nr_records
</code></pre>
<p>The <code>get_record</code> function is very short and basically composed of two
halves. We grab the record from the cache. If the cache gives us <code>None</code>,
then that either means that we haven't loaded this record from the cache
yet, or else it has been written out to disk (finalised) and dropped
from the cache. If the cache gives us <code>Some record</code> then we just return
<code>record</code> (this promotes the weak pointer to the record to a normal
pointer).</p>
<!-- $MDX file=examples/objcache.ml,part=4 -->
<pre><code class="language-ocaml">(* The finaliser function. *)
let finaliser n record =
  printf &quot;*** objcache: finalising record %d\\n%!&quot; n;
  write_record record n diskfile;
  unlock_record n diskfile

(* Get a record from the cache or off disk. *)
let get_record n =
  match Weak.get cache n with
  | Some record -&gt;
      printf &quot;*** objcache: fetching record %d from memory cache\\n%!&quot; n;
      record
  | None -&gt;
      printf &quot;*** objcache: loading record %d from disk\\n%!&quot; n;
      let record = new_record () in
      Gc.finalise (finaliser n) record;
      lock_record n diskfile;
      read_record record n diskfile;
      Weak.set cache n (Some record);
      record
</code></pre>
<p>The <code>sync_records</code> function is even easier. First of all it empties the
cache by replacing all the weak pointers with <code>None</code>. This now means
that the garbage collector <em>can</em> collect and finalise all of those
records. But it doesn't necessarily mean that the GC <em>will</em> collect the
records straightaway (in fact it's not likely that it will), so to force
the GC to collect the records immediately, we also invoke a major cycle:</p>
<p>Finally we have some test code. I won't reproduce the test code, but you
can download the complete program and test code
<a href="objcache.ml">objcache.ml</a>, and compile it with:</p>
<!-- $MDX dir=examples -->
<pre><code class="language-sh">$ ocamlc unix.cma objcache.ml -o objcache
</code></pre>
<h2 id="exercises">Exercises</h2>
<p>Here are some ways to extend the example above, in approximately
increasing order of difficulty:</p>
<ol>
<li>Implement the record as an <strong>object</strong>, and allow it to transparently
pad/unpad strings. You will need to provide methods to set and get
the name and address fields (four public methods in all). Hide as
much of the implementation (file access, locking) code in the class
as possible.
</li>
<li>Extend the program so that it acquires a <strong>read lock</strong> on getting
the record, but upgrades this to a <strong>write lock</strong> just before the
user updates any field.
</li>
<li>Support a <strong>variable number of records</strong> and add a function to
create a new record (in the file). [Tip: OCaml has support for weak
hashtables.]
</li>
<li>Add support for <strong>variable-length records</strong>.
</li>
<li>Make the underlying file representation a <strong>DBM-style hash</strong>.
</li>
<li>Provide a general-purpose cache fronting a &quot;users&quot; table in your
choice of <strong>relational database</strong> (with locking).
</li>
</ol>
|js}
  };
 
  { title = {js|Performance and Profiling|js}
  ; slug = {js|performance-and-profiling|js}
  ; description = {js|Understand how to profile your OCaml code to analyse its performance and produce faster programs
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["advanced"]
  ; users = [`Intermediate; `Advanced]
  ; body_md = {js|
## Speed
Why is OCaml fast? Indeed, step back and ask *is OCaml fast?* How can we
make programs faster? In this chapter we'll look at what actually
happens when you compile your OCaml programs down to machine code. This
will help in understanding why OCaml is not just a great language for
programming, but is also a very fast language indeed. And it'll help you
to help the compiler write better machine code for you. It's also (I
believe anyway) a good thing for programmers to have some idea of what
happens between you typing `ocamlopt` and getting a binary you can run.

But you will need to know some assembler to get the most out of this
section. Don't be afraid! I'll help you out by translating the assembler
into a C-like pseudocode (after all C is just a portable assembly
language).

###  Basics of assembly language
The examples I give in this chapter are all compiled on an x86 Linux
machine. The x86 is, of course, a 32 bit machine, so an x86 "word" is 4
bytes (= 32 bits) long. At this level OCaml deals mostly with word-sized
objects, so you'll need to remember to multiply by four to get the size
in bytes.

To refresh your memory, the x86 has only a small number of general
purpose registers, each of which can store one word. The Linux assembler
puts `%` in front of register names. The registers are: `%eax`, `%ebx`,
`%ecx`, `%edx`, `%esi`, `%edi`, `%ebp` (special register used for stack
frames), and `%esp` (the stack pointer).

The Linux assembler (in common with other Unix assemblers, but opposite
to MS-derived assemblers) writes moves to and from registers/memory as:

```assembly
movl from, to
```

So `movl %ebx, %eax` means "copy the contents of register `%ebx` into
register `%eax`" (not the other way round).

Almost all of the assembly language that we will look at is going to be
dominated not by machine code instructions like `movl` but by what are
known as **assembler directives**. These directives begin
with a . (period) and they literally *direct* the assembler to do
something. Here are the common ones for the Linux assembler:

#### .text

**Text** is the Unix way of saying "program code". The **text segment**
simply means the part of the executable where program code is stored.
The `.text` directive switches the assembler so it starts writing into
the text segment.

#### .data

Similarly, the `.data` directive switches the assembler so it starts
writing into the data segment (part) of the executable.

```assembly
  .globl foo
foo:
```
This declares a global symbol called `foo`. It means the address of the
next thing to come can be named `foo`. Writing just `foo:` without the
preceding `.globl` directive declares a local symbol (local to just the
current file).

```assembly
.long 12345
.byte 9
.ascii "hello"
.space 4
```
`.long` writes a word (4 bytes) to the current segment. `.byte` writes a
single byte. `.ascii` writes a string of bytes (NOT nul-terminated).
`.space` writes the given number of zero bytes. Normally you use these
in the data segment.

###  The "hello, world" program
Enough assembler. Put the following program into a file called
`smallest.ml`:

```ocaml
print_string "hello, world\\n"
```
And compile it to a native code executable using:

```shell
ocamlopt -S smallest.ml -o smallest
```

The `-S` (capital S) tells the compiler to leave the assembly language
file (called `smallest.s` - lowercase s) instead of deleting it.

Here are the edited highlights of the `smallest.s` file with my comments
added. First of all the data segment:

```assembly
    .data
    .long   4348                     ; header for string
    .globl  Smallest__1
lest__1:
    .ascii  "hello, world\\12"        ; string
    .space  2                        ; padding ..
    .byte   2                        ;  .. after string
```
Next up the text (program code) segment:

```assembly
    .text
    .globl  Smallest__entry          ; entry point to the program
lest__entry:

    ; this is equivalent to the C pseudo-code:
    ; Pervasives.output_string (stdout, &Smallest__1)

    movl    $Smallest__1, %ebx
    movl    Pervasives + 92, %eax    ; Pervasives + 92 == stdout
    call    Pervasives__output_string_212

    ; return 1

    movl    $1, %eax
    ret
```

In C everything has to be inside a function. Think about how you can't
just write `printf ("hello, world\\n");` in C, but instead you have to
put it inside `main () { ... }`. In OCaml you are allowed to have
commands at the top level, not inside a function. But when we translate
this into assembly language, where do we put those commands? There needs
to be some way to call those commands from outside, so they need to be
labelled in some way. As you can see from the code snippet, OCaml solves
this by taking the filename (`smallest.ml`), capitalizing it and adding
`__entry`, thus making up a symbol called `Smallest__entry` to refer to
the top level commands in this file.

Now look at the code that OCaml has generated. The original code said
`print_string "hello, world\\n"`, but OCaml has instead compiled the
equivalent of `Pervasives.output_string stdout "hello, world\\n"`. Why?
If you look into `pervasives.ml` you'll see why:

```ocaml
let print_string s = output_string stdout s
```

OCaml has *inlined* this function. **Inlining** - taking a function and
expanding it from its definition - is sometimes a performance win,
because it avoids the overhead of an extra function call, and it can
lead to more opportunities for the optimizer to do its thing. Sometimes
inlining is not good, because it can lead to code bloating, and thus
destroys the good work done by the processor cache (and besides function
calls are actually not very expensive at all on modern processors).
OCaml will inline simple calls like this, because they are essentially
risk free, almost always leading to a small performance gain.

What else can we notice about this? The calling convention seems to be
that the first two arguments are passed in the `%eax` and `%ebx`
registers respectively. Other arguments are probably passed on the
stack, but we'll see about that later.

C programs have a simple convention for storing strings, known as
**ASCIIZ**. This just means that the string is stored in ASCII, followed
by a trailing NUL (`\\0`) character. OCaml stores strings in a different
way, as we can see from the data segment above. This string is stored
like this:

```
4 byte header: 4348
the string:    h e l l o , SP w o r l d \\n
padding:       \\0 \\0 \\002
```

Firstly the padding brings the total length of the string up to a whole
number of words (4 words, 16 bytes in this example). The padding is
carefully designed so that you can work out the actual length of the
string in bytes, provided that you know the total number of *words*
allocated to the string. The encoding for this is unambiguous (which you
can prove to yourself).

One nice feature of having strings with an explicit length is that you
can represent strings containing ASCII NUL (`\\0`) characters in them,
something which is difficult to do in C. However, the flip side is that
you need to be aware of this if you pass an OCaml string to some C
native code: if it contains ASCII NUL, then the C `str*` functions will
fail on it.

Secondly we have the header. Every boxed (allocated) object in OCaml has
a header which tells the garbage collector about how large the object is
in words, and something about what the object contains. Writing the
number 4348 in binary:

```
length of the object in words:  0000 0000 0000 0000 0001 00 (4 words)
color (used by GC):             00
tag:                            1111 1100 (String_tag)
```
See `/usr/include/caml/mlvalues.h` for more information about
the format of heap allocated objects in OCaml.

One unusual thing is that the code passes a pointer to the start of the
string (ie. the word immediately after the header) to
`Pervasives.output_string`. This means that `output_string` must
subtract 4 from the pointer to get at the header to determine the length
of the string.

What have I missed out from this simple example? Well, the text segment
above is not the whole story. It would be really nice if OCaml
translated that simple hello world program into just the five lines of
assembler shown above. But there is the question of what actually calls
`Smallest__entry` in the real program. For this OCaml includes a whole
load of bootstrapping code which does things like starting up the
garbage collector, allocating and initializing memory, calling
initializers in libraries and so on. OCaml links all of this code
statically to the final executable, which is why the program I end up
with (on Linux) weighs in at a portly 95,442 bytes. Nevertheless the
start-up time for the program is still unmeasurably small (under a
millisecond), compared to several seconds for starting up a reasonable
Java program and a second or so for a Perl script.

###  Tail recursion
We mentioned in chapter 6 that OCaml can turn tail-recursive function
calls into simple loops. Is this actually true? Let's look at what
simple tail recursion compiles to:

<!-- do not execute this code!! -->
<!-- $MDX skip -->
```ocaml
let rec loop () =
  print_string "I go on forever ...";
  loop ()
  
let () = loop ()
```

The file is called `tail.ml`, so following OCaml's usual procedure for
naming functions, our function will be called `Tail__loop_nnn` (where
`nnn` is some unique number which OCaml appends to distinguish
identically named functions from one another).

Here is the assembler for just the `loop` function defined above:

```assembly
        .text
        .globl  Tail__loop_56
Tail__loop_56:
.L100:
        ; Print the string
        movl    $Tail__2, %ebx
        movl    Pervasives + 92, %eax
        call    Pervasives__output_string_212
.L101:
        ; The following movl is in fact obsolete:
        movl    $1, %eax
        ; Jump back to the .L100 label above (ie. loop forever)
        jmp     .L100
```

So that's pretty conclusive. Calling `Tail__loop_56` will first print
the string, and then jump back to the top, then print the string, and
jump back, and so on forever. It's a simple loop, *not* a recursive
function call, so it doesn't use any stack space.

###  Digression: Where are the types?
OCaml is statically typed as we've said before on many occasions, so at
compile time, OCaml knows that the type of `loop` is `unit -> unit`. It
knows that the type of `"hello, world\\n"` is `string`. It doesn't make
any attempt to communicate this fact to the `output_string` function.
`output_string` is expecting a `channel` and a `string` as arguments,
and indeed that's what it gets. What would happen if we passed, say, an
`int` instead of a `string`?

This is essentially an impossible condition. Because OCaml knows the
types at compile time, it doesn't need to deal with types or check types
at run time. There is no way, in pure OCaml, to "trick" the compiler
into generating a call to `Pervasives.output_string stdout 1`. Such an
error would be flagged at compile time, by type inference, and so could
never be compiled.

The upshot is that by the time we have compiled OCaml code to assembler
type information mostly isn't required, certainly in the cases we've
looked at above where the type is fully known at compile time, and there
is no polymorphism going on.

Fully knowing all your types at compile time is a major performance win
because it totally avoids any dynamic type checking at run time. Compare
this to a Java method invocation for example: `obj.method ()`. This is
an expensive operation because you need to find the concrete class that
`obj` is an instance of, and then look up the method, and you need to do
all of this potentially *every* time you call any method. Casting
objects is another case where you need to do a considerable amount of
work at run time in Java. None of this is allowed with OCaml's static
types.

###  Polymorphic types
As you might have guessed from the discussion above, polymorphism, which
is where the compiler *doesn't* have a fully known type for a function
at compile time, might have an impact on performance. Suppose we require
a function to work out the maximum of two integers. Our first attempt
is:

```ocaml
# let max a b =
  if a > b then a else b
val max : 'a -> 'a -> 'a = <fun>
```

Simple enough, but recall that the \\> (greater than) operator in OCaml
is polymorphic. It has type `'a -> 'a -> bool`, and this means that the
`max` function we defined above is going to be polymorphic:

```ocaml
# let max a b =
  if a > b then a else b
val max : 'a -> 'a -> 'a = <fun>
```

This is indeed reflected in the code that OCaml generates for this
function, which is pretty complex:

```assembly
        .text
        .globl  Max__max_56
Max__max_56:

        ; Reserve two words of stack space.

        subl    $8, %esp

        ; Save the first and second arguments (a and b) on the stack.

        movl    %eax, 4(%esp)
        movl    %ebx, 0(%esp)

        ; Call the C "greaterthan" function (in the OCaml library).

        pushl   %ebx
        pushl   %eax
        movl    $greaterthan, %eax
        call    caml_c_call
.L102:
        addl    $8, %esp

        ; If the C "greaterthan" function returned 1, jump to .L100

        cmpl    $1, %eax
        je      .L100

        ; Returned 0, so get argument a which we previously saved on
        ; the stack and return it.

        movl    4(%esp), %eax
        addl    $8, %esp
        ret

        ; Returned 1, so get argument b which we previously saved on
        ; the stack and return it.

.L100:
        movl    0(%esp), %eax
        addl    $8, %esp
        ret
```

Basically the \\> operation is done by calling a C function from the
OCaml library. This is obviously not going to be very efficient, nothing
like as efficient as if we could generate some quick inline assembly
language for doing the \\>.

This is not a complete dead loss by any means. All we need to do is to
hint to the OCaml compiler that the arguments are in fact integers. Then
OCaml will generate a specialised version of `max` which only works on
`int` arguments:

```ocaml
# let max (a : int) (b : int) =
  if a > b then a else b
val max : int -> int -> int = <fun>
```
Here is the assembly code generated for this function:

```assembly
        .text
        .globl  Max_int__max_56
Max_int__max_56:

        ; Single assembly instruction "cmpl" for performing the > op.
        cmpl    %ebx, %eax

        ; If %ebx > %eax, jump to .L100
        jle     .L100
        ; Just return argument a.
        ret
        ; Return argument b.

.L100:
        movl    %ebx, %eax
        ret
```
That's just 5 lines of assembler, and is about as simple as you can make
it.

What about this code:

```ocaml
# let max a b =
  if a > b then a else b
val max : 'a -> 'a -> 'a = <fun>
# let () = print_int (max 2 3)
3
```

Is OCaml going to be smart enough to inline the `max` function and
specialise it to work on integers? Disappointingly the answer is no.
OCaml still has to generate the external `Max.max` symbol (because this
is a module, and so that function might be called from outside the
module), and it doesn't inline the function.

Here's another variation:

```ocaml
# let max a b =
  if a > b then a else b in
  print_int (max 2 3)
3
- : unit = ()
```

Disappointingly although the definition of `max` in this code is local
(it can't be called from outside the module), OCaml still doesn't
specialise the function.

Lesson: if you have a function which is unintentionally polymorphic then
you can help the compiler by specifying types for one or more of the
arguments.

###  The representation of integers, tag bits, heap-allocated values
There are a number of peculiarities about integers in OCaml. One of
these is that integers are 31 bit entities, not 32 bit entities. What
happens to the "missing" bit?

Write this to `int.ml`:

```ocaml
print_int 3
```

and compile with `ocamlopt -S int.ml -o int` to generate assembly
language in `int.s`. Recall from the discussion above that we are
expecting OCaml to inline the `print_int` function as
`output_string (string_of_int 3)`, and examining the assembly language
output we can see that this is exactly what OCaml does:

```assembly
        .text
        .globl  Int__entry
Int__entry:

        ; Call Pervasives.string_of_int (3)

        movl    $7, %eax
        call    Pervasives__string_of_int_152

        ; Call Pervasives.output_string (stdout, result_of_previous)

        movl    %eax, %ebx
        movl    Pervasives + 92, %eax
        call    Pervasives__output_string_212
```

The important code is shown in red. It shows two things: Firstly the
integer is unboxed (not allocated on the heap), but is instead passed
directly to the function in the register `%eax`. This is fast. But
secondly we see that the number being passed is 7, not 3.

This is a consequence of the representation of integers in OCaml. The
bottom bit of the integer is used as a tag - we'll see what for next.
The top 31 bits are the actual integer. The binary representation of 7
is 111, so the bottom tag bit is 1 and the top 31 bits form the number
11 in binary = 3. To get from the OCaml representation to the integer,
divide by two and round down.

Why the tag bit at all? This bit is used to distinguish between integers
and pointers to structures on the heap, and the distinction is only
necessary if we are calling a polymorphic function. In the case above,
where we are calling `string_of_int`, the argument can only ever be an
`int` and so the tag bit would never be consulted. Nevertheless, to
avoid having two internal representations for integers, all integers in
OCaml carry around the tag bit.

A bit of background about pointers is required to understand why the tag
bit is really necessary, and why it is where it is.

In the world of RISC chips like the Sparc, MIPS and Alpha, pointers have
to be word-aligned. So on the older 32 bit Sparc, for example, it's not
possible to create and use a pointer which isn't aligned to a multiple
of 4 (bytes). Trying to use one generates a processor exception, which
means basically your program segfaults. The reason for this is just to
simplify memory access. It's just a lot simpler to design the memory
subsystem of a CPU if you only need to worry about word-aligned access.

For historical reasons (because the x86 is derived from an 8 bit chip),
the x86 has supported unaligned memory access, although if you align all
memory accesses to multiples of 4, then things go faster.

Nevertheless, all pointers in OCaml are aligned - ie. multiples of 4 for
32 bit processors, and multiples of 8 for 64 bit processors. This means
that the bottom bit of any pointer in OCaml will always be zero.

So you can see that by looking at the bottom bit of a register, you can
immediately tell if it stores a pointer ("tag" bit is zero), or an
integer (tag bit set to one).

Remember our polymorphic \\> function which caused us so much trouble in
the previous section? We looked at the assembler and found out that
OCaml compiles a call to a C function called `greaterthan` whenever it
sees the polymorphic form of \\>. This function takes two arguments, in
registers `%eax` and `%ebx`. But `greaterthan` can be called with
integers, floats, strings, opaque objects ... How does it know what
`%eax` and `%ebx` point to?

It uses the following decision tree:

* **Tag bit is one:** compare the two integers and return.
* **Tag bit is zero:** `%eax` and `%ebx` must point at two
 heap-allocated memory blocks. Look at the header word of the memory
 blocks, specifically the bottom 8 bits of the header word, which tag
 the content of the block.
     * **String_tag:** Compare two strings.
     * **Double_tag:** Compare two floats.
     * etc.

Note that because \\> has type `'a -> 'a -> bool`, both arguments must
have the same type. The compiler should enforce this at compile time. I
would assume that `greaterthan` probably contains code to sanity-check
this at run time however.

###  Floats
Floats are, by default, boxed (allocated on the heap). Save this as
`float.ml` and compile it with `ocamlopt -S float.ml -o float`:

```ocamltop
print_float 3.0
```
The number is not passed directly to `string_of_float` in the `%eax`
register as happened above with ints. Instead, it is created statically
in the data segment:

```assembly
        .data
        .long   2301
        .globl  Float__1
Float__1:
        .double 3.0
```
and a pointer to the float is passed in `%eax` instead:

```assembly
        movl    $Float__1, %eax
        call    Pervasives__string_of_float_157
```
Note the structure of the floating point number: it has a header (2301),
followed by the 8 byte (2 word) representation of the number itself. The
header can be decoded by writing it as binary:

```
Length of the object in words:  0000 0000 0000 0000 0000 10 (8 bytes)
Color:                          00
Tag:                            1111 1101 (Double_tag)
```
`string_of_float` isn't polymorphic, but suppose we have a polymorphic
function `foo : 'a -> unit` taking one polymorphic argument. If we call
`foo` with `%eax` containing 7, then this is equivalent to `foo 3`,
whereas if we call `foo` with `%eax` containing a pointer to `Float__1`
above, then this is equivalent to `foo 3.0`.

###  Arrays
I mentioned earlier that one of OCaml's targets was numerical computing.
Numerical computing does a lot of work on vectors and matrices, which
are essentially arrays of floats. As a special hack to make this go
faster, OCaml implements **arrays of unboxed floats**. This
means that in the special case where we have an object of type
`float array` (array of floats), OCaml stores them the same way as in C:

```C
double array[10];
```
... instead of having an array of pointers to ten separately allocated
floats on the heap.

Let's see this in practice:

```ocaml
let a = Array.create 10 0.0;;
for i = 0 to 9 do
  a.(i) <- float_of_int i
done
```

I'm going to compile this code with the `-unsafe` option to remove
bounds checking (simplifying the code for our exposition here). The
first line, which creates the array, is compiled to a simple C call:

```assembly
        pushl   $Arrayfloats__1     ; Boxed float 0.0
        pushl   $21                 ; The integer 10
        movl    $make_vect, %eax    ; Address of the C function to call
        call    caml_c_call
    ; ...
        movl    %eax, Arrayfloats   ; Store the resulting pointer to the
                                    ; array at this place on the heap.
```
The loop is compiled to this relatively simple assembly language:

```assembly
        movl    $1, %eax            ; Let %eax = 0. %eax is going to store i.
        cmpl    $19, %eax           ; If %eax > 9, then jump out of the
        jg      .L100               ;   loop (to label .L100 at the end).

.L101:                              ; This is the start of the loop body.
        movl    Arrayfloats, %ecx   ; Address of the array to %ecx.

        movl    %eax, %ebx          ; Copy i to %ebx.
        sarl    $1, %ebx            ; Remove the tag bit from %ebx by
                                    ;   shifting it right 1 place. So %ebx
                                    ;   now contains the real integer i.

        pushl   %ebx                ; Convert %ebx to a float.
        fildl   (%esp)
        addl    $4, %esp

        fstpl   -4(%ecx, %eax, 4)   ; Store the float in the array at the ith
                                ; position.

        addl    $2, %eax            ; i := i + 1
        cmpl    $19, %eax           ; If i <= 9, loop around again.
        jle     .L101
.L100:
```
The important statement is the one which stores the float into the
array. It is:

```assembly
        fstpl   -4(%ecx, %eax, 4)
```
The assembler syntax is rather complex, but the bracketed expression
`-4(%ecx, %eax, 4)` means "at the address `%ecx + 4*%eax - 4`". Recall
that `%eax` is the OCaml representation of i, complete with tag bit, so
it is essentially equal to `i*2+1`, so let's substitute that and
multiply it out:

```assembly
  %ecx + 4*%eax - 4
= %ecx + 4*(i*2+1) - 4
= %ecx + 4*i*2 + 4 - 4
= %ecx + 8*i
```
(Each float in the array is 8 bytes long.)

So arrays of floats are unboxed, as expected.

###  Partially applied functions and closures
How does OCaml compile functions which are only partially applied? Let's
compile this code:

```ocaml
Array.map ((+) 2) [|1; 2; 3; 4; 5|]
```

If you recall the syntax, `[| ... |]` declares an array (in this case an
`int array`), and `((+) 2)` is a closure - "the function which adds 2 to
things".

Compiling this code reveals some interesting new features. Firstly the
code which allocates the array:

```assembly
        movl    $24, %eax           ; Allocate 5 * 4 + 4 = 24 bytes of memory.
        call    caml_alloc

        leal    4(%eax), %eax       ; Let %eax point to 4 bytes into the
                                    ;   allocated memory.
```
All heap allocations have the same format: 4 byte header + data. In this
case the data is 5 integers, so we allocate 4 bytes for the header plus
5 * 4 bytes for the data. We update the pointer to point at the first
data word, ie. 4 bytes into the allocated memory block.

Next OCaml generates code to initialize the array:

```assembly
        movl    $5120, -4(%eax)
        movl    $3, (%eax)
        movl    $5, 4(%eax)
        movl    $7, 8(%eax)
        movl    $9, 12(%eax)
        movl    $11, 16(%eax)
```
The header word is 5120, which if you write it in binary means a block
containing 5 words, with tag zero. The tag of zero means it's a
"structured block" a.k.a. an array. We also copy the numbers 1, 2, 3, 4
and 5 to the appropriate places in the array. Notice the OCaml
representation of integers is used. Because this is a structured block,
the garbage collector will scan each word in this block, and the GC
needs to be able to distinguish between integers and pointers to other
heap-allocated blocks (the GC does not have access to type information
about this array).

Next the closure `((+) 2)` is created. The closure is represented by
this block allocated in the data segment:

```assembly
        .data
        .long   3319
        .globl  Closure__1
Closure__1:
        .long   caml_curry2
        .long   5
        .long   Closure__fun_58
```
The header is 3319, indicating a `Closure_tag` with length 3 words. The
3 words in the block are the address of the function `caml_curry2`, the
integer number 2 and the address of this function:

```assembly
        .text
        .globl  Closure__fun_58
Closure__fun_58:

        ; The function takes two arguments, %eax and %ebx.
        ; This line causes the function to return %eax + %ebx - 1.

        lea     -1(%eax, %ebx), %eax
        ret
```
What does this function do? On the face of it, it adds the two
arguments, and subtracts one. But remember that `%eax` and `%ebx` are in
the OCaml representation for integers. Let's represent them as:

* `%eax = 2 * a + 1`
* `%ebx = 2 * b + 1`

where `a` and `b` are the actual integer arguments. So this function
returns:

```
%eax + %ebx - 1
= 2 * a + 1 + 2 * b + 1 - 1
= 2 * a + 2 * b + 1
= 2 * (a + b) + 1
```
In other words, this function returns the OCaml integer representation
of the sum `a + b`. This function is `(+)`!

(It's actually more subtle than this - to perform the mathematics
quickly, OCaml uses the x86 addressing hardware in a way that probably
wasn't intended by the designers of the x86.)

So back to our closure - we won't go into the details of the
`caml_curry2` function, but just say that this closure is the argument
`2` applied to the function `(+)`, waiting for a second argument. Just
as expected.

The actual call to the `Array.map` function is quite difficult to
understand, but the main points for our examination of OCaml is that the
code:

* Does call `Array.map` with an explicit closure.
* Does not attempt to inline the call and turn it into a loop.

Calling `Array.map` in this way is undoubtedly slower than writing a
loop over the array by hand. The overhead is mainly in the fact that the
closure must be evaluated for each element of the array, and that isn't
as fast as inlining the closure as a function (if this optimization were
even possible). However, if you had a more substantial closure than just
`((+) 2)`, the overhead would be reduced. The FP version also saves
expensive *programmer* time versus writing the imperative loop.

## Profiling
There are two types of profiling that you can do on OCaml programs:

1. Get execution counts for bytecode.
1. Get real profiling for native code.

The `ocamlcp` and `ocamlprof` programs perform profiling on bytecode.
Here is an example:

<!-- $MDX file=examples/gc.ml -->
```ocaml
let rec iterate r x_init i =
  if i = 1 then x_init
  else
    let x = iterate r x_init (i - 1) in
    r *. x *. (1.0 -. x)

let () =
  Random.self_init ();
  Graphics.open_graph " 640x480";
  for x = 0 to 640 do
    let r = 4.0 *. float_of_int x /. 640.0 in
    for i = 0 to 39 do
      let x_init = Random.float 1.0 in
      let x_final = iterate r x_init 500 in
      let y = int_of_float (x_final *. 480.) in
      Graphics.plot x y
    done
  done;
  Gc.print_stat stdout
```

And can be run and compiled with 

<!-- $MDX skip -->
```
$ ocamlcp -p a graphics.cma graphtest.ml -o graphtest
$ ./graphtest
$ ocamlprof graphtest.ml
```

The comments `(* nnn *)` are added by `ocamlprof`, showing how many
times each part of the code was called.

Profiling native code is done using your operating system's native
support for profiling. In the case of Linux, we use `gprof`. An alternative
is [perf](https://en.wikipedia.org/wiki/Perf_(Linux)), as explained below.

We compile it using the `-p` option to `ocamlopt` which tells the
compiler to include profiling information for `gprof`:

After running the program as normal, the profiling code dumps out a file
`gmon.out` which we can interpret with `gprof`:

```
$ gprof ./a.out
Flat profile:
  
Each sample counts as 0.01 seconds.
  %   cumulative   self              self     total
 time   seconds   seconds    calls   s/call   s/call  name
 10.86      0.57     0.57     2109     0.00     0.00  sweep_slice
  9.71      1.08     0.51     1113     0.00     0.00  mark_slice
  7.24      1.46     0.38  4569034     0.00     0.00  Sieve__code_begin
  6.86      1.82     0.36  9171515     0.00     0.00  Stream__set_data_140
  6.57      2.17     0.34 12741964     0.00     0.00  fl_merge_block
  6.29      2.50     0.33  4575034     0.00     0.00  Stream__peek_154
  5.81      2.80     0.30 12561656     0.00     0.00  alloc_shr
  5.71      3.10     0.30     3222     0.00     0.00  oldify_mopup
  4.57      3.34     0.24 12561656     0.00     0.00  allocate_block
  4.57      3.58     0.24  9171515     0.00     0.00  modify
  4.38      3.81     0.23  8387342     0.00     0.00  oldify_one
  3.81      4.01     0.20 12561658     0.00     0.00  fl_allocate
  3.81      4.21     0.20  4569034     0.00     0.00  Sieve__filter_56
  3.62      4.40     0.19     6444     0.00     0.00  empty_minor_heap
  3.24      4.57     0.17     3222     0.00     0.00  oldify_local_roots
  2.29      4.69     0.12  4599482     0.00     0.00  Stream__slazy_221
  2.10      4.80     0.11  4597215     0.00     0.00  darken
  1.90      4.90     0.10  4596481     0.00     0.00  Stream__fun_345
  1.52      4.98     0.08  4575034     0.00     0.00  Stream__icons_207
  1.52      5.06     0.08  4575034     0.00     0.00  Stream__junk_165
  1.14      5.12     0.06     1112     0.00     0.00  do_local_roots
  
[ etc. ]
```

### Using perf on Linux

Assuming perf is installed and your program is compiled into
native code with `-g` (or ocamlbuild tag `debug`), you just need to type

<!-- $MDX skip -->
```sh
perf record --call-graph=dwarf -- ./foo.native a b c d
perf report
```

The first command launches `foo.native` with arguments `a b c d` and
records profiling information in `perf.data`; the second command
starts an interactive program to explore the call graph. The option
`--call-graph=dwarf` makes perf aware of the calling convention of
OCaml (with old versions of `perf`, enabling frame pointers in OCaml
might help; opam provides suitable compiler switches, such as `4.02.1+fp`).

## Summary
In summary here are some tips for getting the best performance out of
your programs:

1. Write your program as simply as possible. If it takes too long to
 run, profile it to find out where it's spending its time and
 concentrate optimizations on just those areas.
1. Check for unintentional polymorphism, and add type hints for the
 compiler.
1. Closures are slower than simple function calls, but add to
 maintainability and readability.
1. As a last resort, rewrite hotspots in your program in C (but first
 check the assembly language produced by the OCaml compiler to see if
 you can do better than it).
1. Performance might depend on external factors (speed of your database
 queries? speed of the network?). If so then no amount of
 optimization will help you.

###  Further reading
You can find out more about how OCaml represents different types by
reading the ("Interfacing C with OCaml") chapter in the OCaml manual and also
looking at the `mlvalues.h` header file.

<!--###  Java dynamic dispatch
**There are some serious mistakes in the last paragraph:**

* Dynamic method dispatch itself is seldom a performance problem. In
 languages without multiple inheritance (e.g. Java) this is usually
 done via one step of pointer indirection. Objects in OCaml are also
 dynamically dispatched. Since this is the point with polymorphism in
 an OO setting.

* Dynamic method dispatch often hinders a compiler to inline function
 and this hits the performance.

* In Java is a dynamic type check (aka cast) much more expensive than
 a dynamic method dispatch. -->
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#speed">Speed</a>
</li>
<li><a href="#profiling">Profiling</a>
</li>
<li><a href="#summary">Summary</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<h2 id="speed">Speed</h2>
<p>Why is OCaml fast? Indeed, step back and ask <em>is OCaml fast?</em> How can we
make programs faster? In this chapter we'll look at what actually
happens when you compile your OCaml programs down to machine code. This
will help in understanding why OCaml is not just a great language for
programming, but is also a very fast language indeed. And it'll help you
to help the compiler write better machine code for you. It's also (I
believe anyway) a good thing for programmers to have some idea of what
happens between you typing <code>ocamlopt</code> and getting a binary you can run.</p>
<p>But you will need to know some assembler to get the most out of this
section. Don't be afraid! I'll help you out by translating the assembler
into a C-like pseudocode (after all C is just a portable assembly
language).</p>
<h3 id="basics-of-assembly-language">Basics of assembly language</h3>
<p>The examples I give in this chapter are all compiled on an x86 Linux
machine. The x86 is, of course, a 32 bit machine, so an x86 &quot;word&quot; is 4
bytes (= 32 bits) long. At this level OCaml deals mostly with word-sized
objects, so you'll need to remember to multiply by four to get the size
in bytes.</p>
<p>To refresh your memory, the x86 has only a small number of general
purpose registers, each of which can store one word. The Linux assembler
puts <code>%</code> in front of register names. The registers are: <code>%eax</code>, <code>%ebx</code>,
<code>%ecx</code>, <code>%edx</code>, <code>%esi</code>, <code>%edi</code>, <code>%ebp</code> (special register used for stack
frames), and <code>%esp</code> (the stack pointer).</p>
<p>The Linux assembler (in common with other Unix assemblers, but opposite
to MS-derived assemblers) writes moves to and from registers/memory as:</p>
<pre><code class="language-assembly">movl from, to
</code></pre>
<p>So <code>movl %ebx, %eax</code> means &quot;copy the contents of register <code>%ebx</code> into
register <code>%eax</code>&quot; (not the other way round).</p>
<p>Almost all of the assembly language that we will look at is going to be
dominated not by machine code instructions like <code>movl</code> but by what are
known as <strong>assembler directives</strong>. These directives begin
with a . (period) and they literally <em>direct</em> the assembler to do
something. Here are the common ones for the Linux assembler:</p>
<h4 id="text">.text</h4>
<p><strong>Text</strong> is the Unix way of saying &quot;program code&quot;. The <strong>text segment</strong>
simply means the part of the executable where program code is stored.
The <code>.text</code> directive switches the assembler so it starts writing into
the text segment.</p>
<h4 id="data">.data</h4>
<p>Similarly, the <code>.data</code> directive switches the assembler so it starts
writing into the data segment (part) of the executable.</p>
<pre><code class="language-assembly">  .globl foo
foo:
</code></pre>
<p>This declares a global symbol called <code>foo</code>. It means the address of the
next thing to come can be named <code>foo</code>. Writing just <code>foo:</code> without the
preceding <code>.globl</code> directive declares a local symbol (local to just the
current file).</p>
<pre><code class="language-assembly">.long 12345
.byte 9
.ascii &quot;hello&quot;
.space 4
</code></pre>
<p><code>.long</code> writes a word (4 bytes) to the current segment. <code>.byte</code> writes a
single byte. <code>.ascii</code> writes a string of bytes (NOT nul-terminated).
<code>.space</code> writes the given number of zero bytes. Normally you use these
in the data segment.</p>
<h3 id="the-hello-world-program">The &quot;hello, world&quot; program</h3>
<p>Enough assembler. Put the following program into a file called
<code>smallest.ml</code>:</p>
<pre><code class="language-ocaml">print_string &quot;hello, world\\n&quot;
</code></pre>
<p>And compile it to a native code executable using:</p>
<pre><code class="language-shell">ocamlopt -S smallest.ml -o smallest
</code></pre>
<p>The <code>-S</code> (capital S) tells the compiler to leave the assembly language
file (called <code>smallest.s</code> - lowercase s) instead of deleting it.</p>
<p>Here are the edited highlights of the <code>smallest.s</code> file with my comments
added. First of all the data segment:</p>
<pre><code class="language-assembly">    .data
    .long   4348                     ; header for string
    .globl  Smallest__1
lest__1:
    .ascii  &quot;hello, world\\12&quot;        ; string
    .space  2                        ; padding ..
    .byte   2                        ;  .. after string
</code></pre>
<p>Next up the text (program code) segment:</p>
<pre><code class="language-assembly">    .text
    .globl  Smallest__entry          ; entry point to the program
lest__entry:

    ; this is equivalent to the C pseudo-code:
    ; Pervasives.output_string (stdout, &amp;Smallest__1)

    movl    $Smallest__1, %ebx
    movl    Pervasives + 92, %eax    ; Pervasives + 92 == stdout
    call    Pervasives__output_string_212

    ; return 1

    movl    $1, %eax
    ret
</code></pre>
<p>In C everything has to be inside a function. Think about how you can't
just write <code>printf (&quot;hello, world\\n&quot;);</code> in C, but instead you have to
put it inside <code>main () { ... }</code>. In OCaml you are allowed to have
commands at the top level, not inside a function. But when we translate
this into assembly language, where do we put those commands? There needs
to be some way to call those commands from outside, so they need to be
labelled in some way. As you can see from the code snippet, OCaml solves
this by taking the filename (<code>smallest.ml</code>), capitalizing it and adding
<code>__entry</code>, thus making up a symbol called <code>Smallest__entry</code> to refer to
the top level commands in this file.</p>
<p>Now look at the code that OCaml has generated. The original code said
<code>print_string &quot;hello, world\\n&quot;</code>, but OCaml has instead compiled the
equivalent of <code>Pervasives.output_string stdout &quot;hello, world\\n&quot;</code>. Why?
If you look into <code>pervasives.ml</code> you'll see why:</p>
<pre><code class="language-ocaml">let print_string s = output_string stdout s
</code></pre>
<p>OCaml has <em>inlined</em> this function. <strong>Inlining</strong> - taking a function and
expanding it from its definition - is sometimes a performance win,
because it avoids the overhead of an extra function call, and it can
lead to more opportunities for the optimizer to do its thing. Sometimes
inlining is not good, because it can lead to code bloating, and thus
destroys the good work done by the processor cache (and besides function
calls are actually not very expensive at all on modern processors).
OCaml will inline simple calls like this, because they are essentially
risk free, almost always leading to a small performance gain.</p>
<p>What else can we notice about this? The calling convention seems to be
that the first two arguments are passed in the <code>%eax</code> and <code>%ebx</code>
registers respectively. Other arguments are probably passed on the
stack, but we'll see about that later.</p>
<p>C programs have a simple convention for storing strings, known as
<strong>ASCIIZ</strong>. This just means that the string is stored in ASCII, followed
by a trailing NUL (<code>\\0</code>) character. OCaml stores strings in a different
way, as we can see from the data segment above. This string is stored
like this:</p>
<pre><code>4 byte header: 4348
the string:    h e l l o , SP w o r l d \\n
padding:       \\0 \\0 \\002
</code></pre>
<p>Firstly the padding brings the total length of the string up to a whole
number of words (4 words, 16 bytes in this example). The padding is
carefully designed so that you can work out the actual length of the
string in bytes, provided that you know the total number of <em>words</em>
allocated to the string. The encoding for this is unambiguous (which you
can prove to yourself).</p>
<p>One nice feature of having strings with an explicit length is that you
can represent strings containing ASCII NUL (<code>\\0</code>) characters in them,
something which is difficult to do in C. However, the flip side is that
you need to be aware of this if you pass an OCaml string to some C
native code: if it contains ASCII NUL, then the C <code>str*</code> functions will
fail on it.</p>
<p>Secondly we have the header. Every boxed (allocated) object in OCaml has
a header which tells the garbage collector about how large the object is
in words, and something about what the object contains. Writing the
number 4348 in binary:</p>
<pre><code>length of the object in words:  0000 0000 0000 0000 0001 00 (4 words)
color (used by GC):             00
tag:                            1111 1100 (String_tag)
</code></pre>
<p>See <code>/usr/include/caml/mlvalues.h</code> for more information about
the format of heap allocated objects in OCaml.</p>
<p>One unusual thing is that the code passes a pointer to the start of the
string (ie. the word immediately after the header) to
<code>Pervasives.output_string</code>. This means that <code>output_string</code> must
subtract 4 from the pointer to get at the header to determine the length
of the string.</p>
<p>What have I missed out from this simple example? Well, the text segment
above is not the whole story. It would be really nice if OCaml
translated that simple hello world program into just the five lines of
assembler shown above. But there is the question of what actually calls
<code>Smallest__entry</code> in the real program. For this OCaml includes a whole
load of bootstrapping code which does things like starting up the
garbage collector, allocating and initializing memory, calling
initializers in libraries and so on. OCaml links all of this code
statically to the final executable, which is why the program I end up
with (on Linux) weighs in at a portly 95,442 bytes. Nevertheless the
start-up time for the program is still unmeasurably small (under a
millisecond), compared to several seconds for starting up a reasonable
Java program and a second or so for a Perl script.</p>
<h3 id="tail-recursion">Tail recursion</h3>
<p>We mentioned in chapter 6 that OCaml can turn tail-recursive function
calls into simple loops. Is this actually true? Let's look at what
simple tail recursion compiles to:</p>
<!-- do not execute this code!! -->
<!-- $MDX skip -->
<pre><code class="language-ocaml">let rec loop () =
  print_string &quot;I go on forever ...&quot;;
  loop ()
  
let () = loop ()
</code></pre>
<p>The file is called <code>tail.ml</code>, so following OCaml's usual procedure for
naming functions, our function will be called <code>Tail__loop_nnn</code> (where
<code>nnn</code> is some unique number which OCaml appends to distinguish
identically named functions from one another).</p>
<p>Here is the assembler for just the <code>loop</code> function defined above:</p>
<pre><code class="language-assembly">        .text
        .globl  Tail__loop_56
Tail__loop_56:
.L100:
        ; Print the string
        movl    $Tail__2, %ebx
        movl    Pervasives + 92, %eax
        call    Pervasives__output_string_212
.L101:
        ; The following movl is in fact obsolete:
        movl    $1, %eax
        ; Jump back to the .L100 label above (ie. loop forever)
        jmp     .L100
</code></pre>
<p>So that's pretty conclusive. Calling <code>Tail__loop_56</code> will first print
the string, and then jump back to the top, then print the string, and
jump back, and so on forever. It's a simple loop, <em>not</em> a recursive
function call, so it doesn't use any stack space.</p>
<h3 id="digression-where-are-the-types">Digression: Where are the types?</h3>
<p>OCaml is statically typed as we've said before on many occasions, so at
compile time, OCaml knows that the type of <code>loop</code> is <code>unit -&gt; unit</code>. It
knows that the type of <code>&quot;hello, world\\n&quot;</code> is <code>string</code>. It doesn't make
any attempt to communicate this fact to the <code>output_string</code> function.
<code>output_string</code> is expecting a <code>channel</code> and a <code>string</code> as arguments,
and indeed that's what it gets. What would happen if we passed, say, an
<code>int</code> instead of a <code>string</code>?</p>
<p>This is essentially an impossible condition. Because OCaml knows the
types at compile time, it doesn't need to deal with types or check types
at run time. There is no way, in pure OCaml, to &quot;trick&quot; the compiler
into generating a call to <code>Pervasives.output_string stdout 1</code>. Such an
error would be flagged at compile time, by type inference, and so could
never be compiled.</p>
<p>The upshot is that by the time we have compiled OCaml code to assembler
type information mostly isn't required, certainly in the cases we've
looked at above where the type is fully known at compile time, and there
is no polymorphism going on.</p>
<p>Fully knowing all your types at compile time is a major performance win
because it totally avoids any dynamic type checking at run time. Compare
this to a Java method invocation for example: <code>obj.method ()</code>. This is
an expensive operation because you need to find the concrete class that
<code>obj</code> is an instance of, and then look up the method, and you need to do
all of this potentially <em>every</em> time you call any method. Casting
objects is another case where you need to do a considerable amount of
work at run time in Java. None of this is allowed with OCaml's static
types.</p>
<h3 id="polymorphic-types">Polymorphic types</h3>
<p>As you might have guessed from the discussion above, polymorphism, which
is where the compiler <em>doesn't</em> have a fully known type for a function
at compile time, might have an impact on performance. Suppose we require
a function to work out the maximum of two integers. Our first attempt
is:</p>
<pre><code class="language-ocaml"># let max a b =
  if a &gt; b then a else b
val max : 'a -&gt; 'a -&gt; 'a = &lt;fun&gt;
</code></pre>
<p>Simple enough, but recall that the &gt; (greater than) operator in OCaml
is polymorphic. It has type <code>'a -&gt; 'a -&gt; bool</code>, and this means that the
<code>max</code> function we defined above is going to be polymorphic:</p>
<pre><code class="language-ocaml"># let max a b =
  if a &gt; b then a else b
val max : 'a -&gt; 'a -&gt; 'a = &lt;fun&gt;
</code></pre>
<p>This is indeed reflected in the code that OCaml generates for this
function, which is pretty complex:</p>
<pre><code class="language-assembly">        .text
        .globl  Max__max_56
Max__max_56:

        ; Reserve two words of stack space.

        subl    $8, %esp

        ; Save the first and second arguments (a and b) on the stack.

        movl    %eax, 4(%esp)
        movl    %ebx, 0(%esp)

        ; Call the C &quot;greaterthan&quot; function (in the OCaml library).

        pushl   %ebx
        pushl   %eax
        movl    $greaterthan, %eax
        call    caml_c_call
.L102:
        addl    $8, %esp

        ; If the C &quot;greaterthan&quot; function returned 1, jump to .L100

        cmpl    $1, %eax
        je      .L100

        ; Returned 0, so get argument a which we previously saved on
        ; the stack and return it.

        movl    4(%esp), %eax
        addl    $8, %esp
        ret

        ; Returned 1, so get argument b which we previously saved on
        ; the stack and return it.

.L100:
        movl    0(%esp), %eax
        addl    $8, %esp
        ret
</code></pre>
<p>Basically the &gt; operation is done by calling a C function from the
OCaml library. This is obviously not going to be very efficient, nothing
like as efficient as if we could generate some quick inline assembly
language for doing the &gt;.</p>
<p>This is not a complete dead loss by any means. All we need to do is to
hint to the OCaml compiler that the arguments are in fact integers. Then
OCaml will generate a specialised version of <code>max</code> which only works on
<code>int</code> arguments:</p>
<pre><code class="language-ocaml"># let max (a : int) (b : int) =
  if a &gt; b then a else b
val max : int -&gt; int -&gt; int = &lt;fun&gt;
</code></pre>
<p>Here is the assembly code generated for this function:</p>
<pre><code class="language-assembly">        .text
        .globl  Max_int__max_56
Max_int__max_56:

        ; Single assembly instruction &quot;cmpl&quot; for performing the &gt; op.
        cmpl    %ebx, %eax

        ; If %ebx &gt; %eax, jump to .L100
        jle     .L100
        ; Just return argument a.
        ret
        ; Return argument b.

.L100:
        movl    %ebx, %eax
        ret
</code></pre>
<p>That's just 5 lines of assembler, and is about as simple as you can make
it.</p>
<p>What about this code:</p>
<pre><code class="language-ocaml"># let max a b =
  if a &gt; b then a else b
val max : 'a -&gt; 'a -&gt; 'a = &lt;fun&gt;
# let () = print_int (max 2 3)
3
</code></pre>
<p>Is OCaml going to be smart enough to inline the <code>max</code> function and
specialise it to work on integers? Disappointingly the answer is no.
OCaml still has to generate the external <code>Max.max</code> symbol (because this
is a module, and so that function might be called from outside the
module), and it doesn't inline the function.</p>
<p>Here's another variation:</p>
<pre><code class="language-ocaml"># let max a b =
  if a &gt; b then a else b in
  print_int (max 2 3)
3
- : unit = ()
</code></pre>
<p>Disappointingly although the definition of <code>max</code> in this code is local
(it can't be called from outside the module), OCaml still doesn't
specialise the function.</p>
<p>Lesson: if you have a function which is unintentionally polymorphic then
you can help the compiler by specifying types for one or more of the
arguments.</p>
<h3 id="the-representation-of-integers-tag-bits-heap-allocated-values">The representation of integers, tag bits, heap-allocated values</h3>
<p>There are a number of peculiarities about integers in OCaml. One of
these is that integers are 31 bit entities, not 32 bit entities. What
happens to the &quot;missing&quot; bit?</p>
<p>Write this to <code>int.ml</code>:</p>
<pre><code class="language-ocaml">print_int 3
</code></pre>
<p>and compile with <code>ocamlopt -S int.ml -o int</code> to generate assembly
language in <code>int.s</code>. Recall from the discussion above that we are
expecting OCaml to inline the <code>print_int</code> function as
<code>output_string (string_of_int 3)</code>, and examining the assembly language
output we can see that this is exactly what OCaml does:</p>
<pre><code class="language-assembly">        .text
        .globl  Int__entry
Int__entry:

        ; Call Pervasives.string_of_int (3)

        movl    $7, %eax
        call    Pervasives__string_of_int_152

        ; Call Pervasives.output_string (stdout, result_of_previous)

        movl    %eax, %ebx
        movl    Pervasives + 92, %eax
        call    Pervasives__output_string_212
</code></pre>
<p>The important code is shown in red. It shows two things: Firstly the
integer is unboxed (not allocated on the heap), but is instead passed
directly to the function in the register <code>%eax</code>. This is fast. But
secondly we see that the number being passed is 7, not 3.</p>
<p>This is a consequence of the representation of integers in OCaml. The
bottom bit of the integer is used as a tag - we'll see what for next.
The top 31 bits are the actual integer. The binary representation of 7
is 111, so the bottom tag bit is 1 and the top 31 bits form the number
11 in binary = 3. To get from the OCaml representation to the integer,
divide by two and round down.</p>
<p>Why the tag bit at all? This bit is used to distinguish between integers
and pointers to structures on the heap, and the distinction is only
necessary if we are calling a polymorphic function. In the case above,
where we are calling <code>string_of_int</code>, the argument can only ever be an
<code>int</code> and so the tag bit would never be consulted. Nevertheless, to
avoid having two internal representations for integers, all integers in
OCaml carry around the tag bit.</p>
<p>A bit of background about pointers is required to understand why the tag
bit is really necessary, and why it is where it is.</p>
<p>In the world of RISC chips like the Sparc, MIPS and Alpha, pointers have
to be word-aligned. So on the older 32 bit Sparc, for example, it's not
possible to create and use a pointer which isn't aligned to a multiple
of 4 (bytes). Trying to use one generates a processor exception, which
means basically your program segfaults. The reason for this is just to
simplify memory access. It's just a lot simpler to design the memory
subsystem of a CPU if you only need to worry about word-aligned access.</p>
<p>For historical reasons (because the x86 is derived from an 8 bit chip),
the x86 has supported unaligned memory access, although if you align all
memory accesses to multiples of 4, then things go faster.</p>
<p>Nevertheless, all pointers in OCaml are aligned - ie. multiples of 4 for
32 bit processors, and multiples of 8 for 64 bit processors. This means
that the bottom bit of any pointer in OCaml will always be zero.</p>
<p>So you can see that by looking at the bottom bit of a register, you can
immediately tell if it stores a pointer (&quot;tag&quot; bit is zero), or an
integer (tag bit set to one).</p>
<p>Remember our polymorphic &gt; function which caused us so much trouble in
the previous section? We looked at the assembler and found out that
OCaml compiles a call to a C function called <code>greaterthan</code> whenever it
sees the polymorphic form of &gt;. This function takes two arguments, in
registers <code>%eax</code> and <code>%ebx</code>. But <code>greaterthan</code> can be called with
integers, floats, strings, opaque objects ... How does it know what
<code>%eax</code> and <code>%ebx</code> point to?</p>
<p>It uses the following decision tree:</p>
<ul>
<li><strong>Tag bit is one:</strong> compare the two integers and return.
</li>
<li><strong>Tag bit is zero:</strong> <code>%eax</code> and <code>%ebx</code> must point at two
heap-allocated memory blocks. Look at the header word of the memory
blocks, specifically the bottom 8 bits of the header word, which tag
the content of the block.
<ul>
<li><strong>String_tag:</strong> Compare two strings.
</li>
<li><strong>Double_tag:</strong> Compare two floats.
</li>
<li>etc.
</li>
</ul>
</li>
</ul>
<p>Note that because &gt; has type <code>'a -&gt; 'a -&gt; bool</code>, both arguments must
have the same type. The compiler should enforce this at compile time. I
would assume that <code>greaterthan</code> probably contains code to sanity-check
this at run time however.</p>
<h3 id="floats">Floats</h3>
<p>Floats are, by default, boxed (allocated on the heap). Save this as
<code>float.ml</code> and compile it with <code>ocamlopt -S float.ml -o float</code>:</p>
<pre><code class="language-ocamltop">print_float 3.0
</code></pre>
<p>The number is not passed directly to <code>string_of_float</code> in the <code>%eax</code>
register as happened above with ints. Instead, it is created statically
in the data segment:</p>
<pre><code class="language-assembly">        .data
        .long   2301
        .globl  Float__1
Float__1:
        .double 3.0
</code></pre>
<p>and a pointer to the float is passed in <code>%eax</code> instead:</p>
<pre><code class="language-assembly">        movl    $Float__1, %eax
        call    Pervasives__string_of_float_157
</code></pre>
<p>Note the structure of the floating point number: it has a header (2301),
followed by the 8 byte (2 word) representation of the number itself. The
header can be decoded by writing it as binary:</p>
<pre><code>Length of the object in words:  0000 0000 0000 0000 0000 10 (8 bytes)
Color:                          00
Tag:                            1111 1101 (Double_tag)
</code></pre>
<p><code>string_of_float</code> isn't polymorphic, but suppose we have a polymorphic
function <code>foo : 'a -&gt; unit</code> taking one polymorphic argument. If we call
<code>foo</code> with <code>%eax</code> containing 7, then this is equivalent to <code>foo 3</code>,
whereas if we call <code>foo</code> with <code>%eax</code> containing a pointer to <code>Float__1</code>
above, then this is equivalent to <code>foo 3.0</code>.</p>
<h3 id="arrays">Arrays</h3>
<p>I mentioned earlier that one of OCaml's targets was numerical computing.
Numerical computing does a lot of work on vectors and matrices, which
are essentially arrays of floats. As a special hack to make this go
faster, OCaml implements <strong>arrays of unboxed floats</strong>. This
means that in the special case where we have an object of type
<code>float array</code> (array of floats), OCaml stores them the same way as in C:</p>
<pre><code class="language-C">double array[10];
</code></pre>
<p>... instead of having an array of pointers to ten separately allocated
floats on the heap.</p>
<p>Let's see this in practice:</p>
<pre><code class="language-ocaml">let a = Array.create 10 0.0;;
for i = 0 to 9 do
  a.(i) &lt;- float_of_int i
done
</code></pre>
<p>I'm going to compile this code with the <code>-unsafe</code> option to remove
bounds checking (simplifying the code for our exposition here). The
first line, which creates the array, is compiled to a simple C call:</p>
<pre><code class="language-assembly">        pushl   $Arrayfloats__1     ; Boxed float 0.0
        pushl   $21                 ; The integer 10
        movl    $make_vect, %eax    ; Address of the C function to call
        call    caml_c_call
    ; ...
        movl    %eax, Arrayfloats   ; Store the resulting pointer to the
                                    ; array at this place on the heap.
</code></pre>
<p>The loop is compiled to this relatively simple assembly language:</p>
<pre><code class="language-assembly">        movl    $1, %eax            ; Let %eax = 0. %eax is going to store i.
        cmpl    $19, %eax           ; If %eax &gt; 9, then jump out of the
        jg      .L100               ;   loop (to label .L100 at the end).

.L101:                              ; This is the start of the loop body.
        movl    Arrayfloats, %ecx   ; Address of the array to %ecx.

        movl    %eax, %ebx          ; Copy i to %ebx.
        sarl    $1, %ebx            ; Remove the tag bit from %ebx by
                                    ;   shifting it right 1 place. So %ebx
                                    ;   now contains the real integer i.

        pushl   %ebx                ; Convert %ebx to a float.
        fildl   (%esp)
        addl    $4, %esp

        fstpl   -4(%ecx, %eax, 4)   ; Store the float in the array at the ith
                                ; position.

        addl    $2, %eax            ; i := i + 1
        cmpl    $19, %eax           ; If i &lt;= 9, loop around again.
        jle     .L101
.L100:
</code></pre>
<p>The important statement is the one which stores the float into the
array. It is:</p>
<pre><code class="language-assembly">        fstpl   -4(%ecx, %eax, 4)
</code></pre>
<p>The assembler syntax is rather complex, but the bracketed expression
<code>-4(%ecx, %eax, 4)</code> means &quot;at the address <code>%ecx + 4*%eax - 4</code>&quot;. Recall
that <code>%eax</code> is the OCaml representation of i, complete with tag bit, so
it is essentially equal to <code>i*2+1</code>, so let's substitute that and
multiply it out:</p>
<pre><code class="language-assembly">  %ecx + 4*%eax - 4
= %ecx + 4*(i*2+1) - 4
= %ecx + 4*i*2 + 4 - 4
= %ecx + 8*i
</code></pre>
<p>(Each float in the array is 8 bytes long.)</p>
<p>So arrays of floats are unboxed, as expected.</p>
<h3 id="partially-applied-functions-and-closures">Partially applied functions and closures</h3>
<p>How does OCaml compile functions which are only partially applied? Let's
compile this code:</p>
<pre><code class="language-ocaml">Array.map ((+) 2) [|1; 2; 3; 4; 5|]
</code></pre>
<p>If you recall the syntax, <code>[| ... |]</code> declares an array (in this case an
<code>int array</code>), and <code>((+) 2)</code> is a closure - &quot;the function which adds 2 to
things&quot;.</p>
<p>Compiling this code reveals some interesting new features. Firstly the
code which allocates the array:</p>
<pre><code class="language-assembly">        movl    $24, %eax           ; Allocate 5 * 4 + 4 = 24 bytes of memory.
        call    caml_alloc

        leal    4(%eax), %eax       ; Let %eax point to 4 bytes into the
                                    ;   allocated memory.
</code></pre>
<p>All heap allocations have the same format: 4 byte header + data. In this
case the data is 5 integers, so we allocate 4 bytes for the header plus
5 * 4 bytes for the data. We update the pointer to point at the first
data word, ie. 4 bytes into the allocated memory block.</p>
<p>Next OCaml generates code to initialize the array:</p>
<pre><code class="language-assembly">        movl    $5120, -4(%eax)
        movl    $3, (%eax)
        movl    $5, 4(%eax)
        movl    $7, 8(%eax)
        movl    $9, 12(%eax)
        movl    $11, 16(%eax)
</code></pre>
<p>The header word is 5120, which if you write it in binary means a block
containing 5 words, with tag zero. The tag of zero means it's a
&quot;structured block&quot; a.k.a. an array. We also copy the numbers 1, 2, 3, 4
and 5 to the appropriate places in the array. Notice the OCaml
representation of integers is used. Because this is a structured block,
the garbage collector will scan each word in this block, and the GC
needs to be able to distinguish between integers and pointers to other
heap-allocated blocks (the GC does not have access to type information
about this array).</p>
<p>Next the closure <code>((+) 2)</code> is created. The closure is represented by
this block allocated in the data segment:</p>
<pre><code class="language-assembly">        .data
        .long   3319
        .globl  Closure__1
Closure__1:
        .long   caml_curry2
        .long   5
        .long   Closure__fun_58
</code></pre>
<p>The header is 3319, indicating a <code>Closure_tag</code> with length 3 words. The
3 words in the block are the address of the function <code>caml_curry2</code>, the
integer number 2 and the address of this function:</p>
<pre><code class="language-assembly">        .text
        .globl  Closure__fun_58
Closure__fun_58:

        ; The function takes two arguments, %eax and %ebx.
        ; This line causes the function to return %eax + %ebx - 1.

        lea     -1(%eax, %ebx), %eax
        ret
</code></pre>
<p>What does this function do? On the face of it, it adds the two
arguments, and subtracts one. But remember that <code>%eax</code> and <code>%ebx</code> are in
the OCaml representation for integers. Let's represent them as:</p>
<ul>
<li><code>%eax = 2 * a + 1</code>
</li>
<li><code>%ebx = 2 * b + 1</code>
</li>
</ul>
<p>where <code>a</code> and <code>b</code> are the actual integer arguments. So this function
returns:</p>
<pre><code>%eax + %ebx - 1
= 2 * a + 1 + 2 * b + 1 - 1
= 2 * a + 2 * b + 1
= 2 * (a + b) + 1
</code></pre>
<p>In other words, this function returns the OCaml integer representation
of the sum <code>a + b</code>. This function is <code>(+)</code>!</p>
<p>(It's actually more subtle than this - to perform the mathematics
quickly, OCaml uses the x86 addressing hardware in a way that probably
wasn't intended by the designers of the x86.)</p>
<p>So back to our closure - we won't go into the details of the
<code>caml_curry2</code> function, but just say that this closure is the argument
<code>2</code> applied to the function <code>(+)</code>, waiting for a second argument. Just
as expected.</p>
<p>The actual call to the <code>Array.map</code> function is quite difficult to
understand, but the main points for our examination of OCaml is that the
code:</p>
<ul>
<li>Does call <code>Array.map</code> with an explicit closure.
</li>
<li>Does not attempt to inline the call and turn it into a loop.
</li>
</ul>
<p>Calling <code>Array.map</code> in this way is undoubtedly slower than writing a
loop over the array by hand. The overhead is mainly in the fact that the
closure must be evaluated for each element of the array, and that isn't
as fast as inlining the closure as a function (if this optimization were
even possible). However, if you had a more substantial closure than just
<code>((+) 2)</code>, the overhead would be reduced. The FP version also saves
expensive <em>programmer</em> time versus writing the imperative loop.</p>
<h2 id="profiling">Profiling</h2>
<p>There are two types of profiling that you can do on OCaml programs:</p>
<ol>
<li>Get execution counts for bytecode.
</li>
<li>Get real profiling for native code.
</li>
</ol>
<p>The <code>ocamlcp</code> and <code>ocamlprof</code> programs perform profiling on bytecode.
Here is an example:</p>
<!-- $MDX file=examples/gc.ml -->
<pre><code class="language-ocaml">let rec iterate r x_init i =
  if i = 1 then x_init
  else
    let x = iterate r x_init (i - 1) in
    r *. x *. (1.0 -. x)

let () =
  Random.self_init ();
  Graphics.open_graph &quot; 640x480&quot;;
  for x = 0 to 640 do
    let r = 4.0 *. float_of_int x /. 640.0 in
    for i = 0 to 39 do
      let x_init = Random.float 1.0 in
      let x_final = iterate r x_init 500 in
      let y = int_of_float (x_final *. 480.) in
      Graphics.plot x y
    done
  done;
  Gc.print_stat stdout
</code></pre>
<p>And can be run and compiled with</p>
<!-- $MDX skip -->
<pre><code>$ ocamlcp -p a graphics.cma graphtest.ml -o graphtest
$ ./graphtest
$ ocamlprof graphtest.ml
</code></pre>
<p>The comments <code>(* nnn *)</code> are added by <code>ocamlprof</code>, showing how many
times each part of the code was called.</p>
<p>Profiling native code is done using your operating system's native
support for profiling. In the case of Linux, we use <code>gprof</code>. An alternative
is <a href="https://en.wikipedia.org/wiki/Perf_(Linux)">perf</a>, as explained below.</p>
<p>We compile it using the <code>-p</code> option to <code>ocamlopt</code> which tells the
compiler to include profiling information for <code>gprof</code>:</p>
<p>After running the program as normal, the profiling code dumps out a file
<code>gmon.out</code> which we can interpret with <code>gprof</code>:</p>
<pre><code>$ gprof ./a.out
Flat profile:
  
Each sample counts as 0.01 seconds.
  %   cumulative   self              self     total
 time   seconds   seconds    calls   s/call   s/call  name
 10.86      0.57     0.57     2109     0.00     0.00  sweep_slice
  9.71      1.08     0.51     1113     0.00     0.00  mark_slice
  7.24      1.46     0.38  4569034     0.00     0.00  Sieve__code_begin
  6.86      1.82     0.36  9171515     0.00     0.00  Stream__set_data_140
  6.57      2.17     0.34 12741964     0.00     0.00  fl_merge_block
  6.29      2.50     0.33  4575034     0.00     0.00  Stream__peek_154
  5.81      2.80     0.30 12561656     0.00     0.00  alloc_shr
  5.71      3.10     0.30     3222     0.00     0.00  oldify_mopup
  4.57      3.34     0.24 12561656     0.00     0.00  allocate_block
  4.57      3.58     0.24  9171515     0.00     0.00  modify
  4.38      3.81     0.23  8387342     0.00     0.00  oldify_one
  3.81      4.01     0.20 12561658     0.00     0.00  fl_allocate
  3.81      4.21     0.20  4569034     0.00     0.00  Sieve__filter_56
  3.62      4.40     0.19     6444     0.00     0.00  empty_minor_heap
  3.24      4.57     0.17     3222     0.00     0.00  oldify_local_roots
  2.29      4.69     0.12  4599482     0.00     0.00  Stream__slazy_221
  2.10      4.80     0.11  4597215     0.00     0.00  darken
  1.90      4.90     0.10  4596481     0.00     0.00  Stream__fun_345
  1.52      4.98     0.08  4575034     0.00     0.00  Stream__icons_207
  1.52      5.06     0.08  4575034     0.00     0.00  Stream__junk_165
  1.14      5.12     0.06     1112     0.00     0.00  do_local_roots
  
[ etc. ]
</code></pre>
<h3 id="using-perf-on-linux">Using perf on Linux</h3>
<p>Assuming perf is installed and your program is compiled into
native code with <code>-g</code> (or ocamlbuild tag <code>debug</code>), you just need to type</p>
<!-- $MDX skip -->
<pre><code class="language-sh">perf record --call-graph=dwarf -- ./foo.native a b c d
perf report
</code></pre>
<p>The first command launches <code>foo.native</code> with arguments <code>a b c d</code> and
records profiling information in <code>perf.data</code>; the second command
starts an interactive program to explore the call graph. The option
<code>--call-graph=dwarf</code> makes perf aware of the calling convention of
OCaml (with old versions of <code>perf</code>, enabling frame pointers in OCaml
might help; opam provides suitable compiler switches, such as <code>4.02.1+fp</code>).</p>
<h2 id="summary">Summary</h2>
<p>In summary here are some tips for getting the best performance out of
your programs:</p>
<ol>
<li>Write your program as simply as possible. If it takes too long to
run, profile it to find out where it's spending its time and
concentrate optimizations on just those areas.
</li>
<li>Check for unintentional polymorphism, and add type hints for the
compiler.
</li>
<li>Closures are slower than simple function calls, but add to
maintainability and readability.
</li>
<li>As a last resort, rewrite hotspots in your program in C (but first
check the assembly language produced by the OCaml compiler to see if
you can do better than it).
</li>
<li>Performance might depend on external factors (speed of your database
queries? speed of the network?). If so then no amount of
optimization will help you.
</li>
</ol>
<h3 id="further-reading">Further reading</h3>
<p>You can find out more about how OCaml represents different types by
reading the (&quot;Interfacing C with OCaml&quot;) chapter in the OCaml manual and also
looking at the <code>mlvalues.h</code> header file.</p>
<!--###  Java dynamic dispatch
**There are some serious mistakes in the last paragraph:**

* Dynamic method dispatch itself is seldom a performance problem. In
 languages without multiple inheritance (e.g. Java) this is usually
 done via one step of pointer indirection. Objects in OCaml are also
 dynamically dispatched. Since this is the point with polymorphism in
 an OO setting.

* Dynamic method dispatch often hinders a compiler to inline function
 and this hits the performance.

* In Java is a dynamic type check (aka cast) much more expensive than
 a dynamic method dispatch. -->
|js}
  };
 
  { title = {js|Comparison of Standard Containers|js}
  ; slug = {js|comparison-of-standard-containers|js}
  ; description = {js|A comparison of some core data-structures including lists, queues and arrays
|js}
  ; date = {js|2021-05-27T21:07:30-00:00|js}
  ; tags = 
 ["language"]
  ; users = [`Intermediate]
  ; body_md = {js|
This is a rough comparison of the different container types that are
provided by the OCaml language or by the OCaml standard library. In each
case, n is the number of valid elements in the container.

Note that the big-O cost given for some operations reflects the current
implementation but is not guaranteed by the official documentation.
Hopefully it will not become worse. Anyway, if you want more details,
you should read the documentation about each of the modules. Often, it
is also instructive to read the corresponding implementation.

## Lists: immutable singly-linked lists
Adding an element always creates a new list l from an element x and list
tl. tl remains unchanged, but it is not copied either.

* "adding" an element: O(1), cons operator `::`
* length: O(n), function `List.length`
* accessing cell `i`: O(i)
* finding an element: O(n)

Well-suited for: IO, pattern-matching

Not very efficient for: random access, indexed elements

## Arrays: mutable vectors
Arrays are mutable data structures with a fixed length and random access.

* "adding" an element (by creating a new array): O(n)
* length: O(1), function `Array.length`
* accessing cell `i`: O(1)
* finding an element: O(n)

Well-suited for sets of elements of known size, access by numeric index,
in-place modification. Basic arrays have a fixed length.

## Strings: immutable vectors
Strings are very similar to arrays but are immutable. Strings are
specialized for storing chars (bytes) and have some convenient syntax.
Strings have a fixed length. For extensible strings, the standard Buffer
module can be used (see below).

* "adding" an element (by creating a new string): O(n)
* length: O(1)
* accessing character `i`: O(1)
* finding an element: O(n)

## Set and Map: immutable trees
Like lists, these are immutable and they may share some subtrees. They
are a good solution for keeping older versions of sets of items.

* "adding" an element: O(log n)
* returning the number of elements: O(n)
* finding an element: O(log n)

Sets and maps are very useful in compilation and meta-programming, but
in other situations hash tables are often more appropriate (see below).

## Hashtbl: automatically growing hash tables
Ocaml hash tables are mutable data structures, which are a good solution
for storing (key, data) pairs in one single place.

* adding an element: O(1) if the initial size of the table is larger
 than the number of elements it contains; O(log n) on average if n
 elements have been added in a table which is initially much smaller
 than n.
* returning the number of elements: O(1)
* finding an element: O(1)

## Buffer: extensible strings
Buffers provide an efficient way to accumulate a sequence of bytes in a
single place. They are mutable.

* adding a char: O(1) if the buffer is big enough, or O(log n) on
 average if the initial size of the buffer was much smaller than the
 number of bytes n.
* adding a string of k chars: O(k * "adding a char")
* length: O(1)
* accessing cell `i`: O(1)

## Queue
OCaml queues are mutable first-in-first-out (FIFO) data structures.

* adding an element: O(1)
* taking an element: O(1)
* length: O(1)

## Stack
OCaml stacks are mutable last-in-first-out (LIFO) data structures. They
are just like lists, except that they are mutable, i.e. adding an
element doesn't create a new stack but simply adds it to the stack.

* adding an element: O(1)
* taking an element: O(1)
* length: O(1)
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><a href="#lists-immutable-singly-linked-lists">Lists: immutable singly-linked lists</a>
</li>
<li><a href="#arrays-mutable-vectors">Arrays: mutable vectors</a>
</li>
<li><a href="#strings-immutable-vectors">Strings: immutable vectors</a>
</li>
<li><a href="#set-and-map-immutable-trees">Set and Map: immutable trees</a>
</li>
<li><a href="#hashtbl-automatically-growing-hash-tables">Hashtbl: automatically growing hash tables</a>
</li>
<li><a href="#buffer-extensible-strings">Buffer: extensible strings</a>
</li>
<li><a href="#queue">Queue</a>
</li>
<li><a href="#stack">Stack</a>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<p>This is a rough comparison of the different container types that are
provided by the OCaml language or by the OCaml standard library. In each
case, n is the number of valid elements in the container.</p>
<p>Note that the big-O cost given for some operations reflects the current
implementation but is not guaranteed by the official documentation.
Hopefully it will not become worse. Anyway, if you want more details,
you should read the documentation about each of the modules. Often, it
is also instructive to read the corresponding implementation.</p>
<h2 id="lists-immutable-singly-linked-lists">Lists: immutable singly-linked lists</h2>
<p>Adding an element always creates a new list l from an element x and list
tl. tl remains unchanged, but it is not copied either.</p>
<ul>
<li>&quot;adding&quot; an element: O(1), cons operator <code>::</code>
</li>
<li>length: O(n), function <code>List.length</code>
</li>
<li>accessing cell <code>i</code>: O(i)
</li>
<li>finding an element: O(n)
</li>
</ul>
<p>Well-suited for: IO, pattern-matching</p>
<p>Not very efficient for: random access, indexed elements</p>
<h2 id="arrays-mutable-vectors">Arrays: mutable vectors</h2>
<p>Arrays are mutable data structures with a fixed length and random access.</p>
<ul>
<li>&quot;adding&quot; an element (by creating a new array): O(n)
</li>
<li>length: O(1), function <code>Array.length</code>
</li>
<li>accessing cell <code>i</code>: O(1)
</li>
<li>finding an element: O(n)
</li>
</ul>
<p>Well-suited for sets of elements of known size, access by numeric index,
in-place modification. Basic arrays have a fixed length.</p>
<h2 id="strings-immutable-vectors">Strings: immutable vectors</h2>
<p>Strings are very similar to arrays but are immutable. Strings are
specialized for storing chars (bytes) and have some convenient syntax.
Strings have a fixed length. For extensible strings, the standard Buffer
module can be used (see below).</p>
<ul>
<li>&quot;adding&quot; an element (by creating a new string): O(n)
</li>
<li>length: O(1)
</li>
<li>accessing character <code>i</code>: O(1)
</li>
<li>finding an element: O(n)
</li>
</ul>
<h2 id="set-and-map-immutable-trees">Set and Map: immutable trees</h2>
<p>Like lists, these are immutable and they may share some subtrees. They
are a good solution for keeping older versions of sets of items.</p>
<ul>
<li>&quot;adding&quot; an element: O(log n)
</li>
<li>returning the number of elements: O(n)
</li>
<li>finding an element: O(log n)
</li>
</ul>
<p>Sets and maps are very useful in compilation and meta-programming, but
in other situations hash tables are often more appropriate (see below).</p>
<h2 id="hashtbl-automatically-growing-hash-tables">Hashtbl: automatically growing hash tables</h2>
<p>Ocaml hash tables are mutable data structures, which are a good solution
for storing (key, data) pairs in one single place.</p>
<ul>
<li>adding an element: O(1) if the initial size of the table is larger
than the number of elements it contains; O(log n) on average if n
elements have been added in a table which is initially much smaller
than n.
</li>
<li>returning the number of elements: O(1)
</li>
<li>finding an element: O(1)
</li>
</ul>
<h2 id="buffer-extensible-strings">Buffer: extensible strings</h2>
<p>Buffers provide an efficient way to accumulate a sequence of bytes in a
single place. They are mutable.</p>
<ul>
<li>adding a char: O(1) if the buffer is big enough, or O(log n) on
average if the initial size of the buffer was much smaller than the
number of bytes n.
</li>
<li>adding a string of k chars: O(k * &quot;adding a char&quot;)
</li>
<li>length: O(1)
</li>
<li>accessing cell <code>i</code>: O(1)
</li>
</ul>
<h2 id="queue">Queue</h2>
<p>OCaml queues are mutable first-in-first-out (FIFO) data structures.</p>
<ul>
<li>adding an element: O(1)
</li>
<li>taking an element: O(1)
</li>
<li>length: O(1)
</li>
</ul>
<h2 id="stack">Stack</h2>
<p>OCaml stacks are mutable last-in-first-out (LIFO) data structures. They
are just like lists, except that they are mutable, i.e. adding an
element doesn't create a new stack but simply adds it to the stack.</p>
<ul>
<li>adding an element: O(1)
</li>
<li>taking an element: O(1)
</li>
<li>length: O(1)
</li>
</ul>
|js}
  }]

