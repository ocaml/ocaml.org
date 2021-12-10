
type kind = [ `Compiler ]

type t =
  { kind : kind
  ; version : string
  ; date : string
  ; intro_md : string
  ; intro_html : string
  ; highlights_md : string
  ; highlights_html : string
  ; body_md : string
  ; body_html : string
  }
  
let all = 
[
  { kind = `Compiler
  ; version = {js|4.12.0|js}
  ; date = {js|2021-02-24|js}
  ; intro_md = {js|This page describes OCaml version **4.12.0**, released on 2021-02-24.

This release is available as an [opam](/p/ocaml/4.12.0) package.
|js}
  ; intro_html = {js|<p>This page describes OCaml version <strong>4.12.0</strong>, released on 2021-02-24.</p>
<p>This release is available as an <a href="/p/ocaml/4.12.0">opam</a> package.</p>
|js}
  ; highlights_md = {js|- Major progress in reducing the difference between the mainline and
  multicore runtime
- A new configuration option `ocaml-option-nnpchecker` which emits an alarm
  when the garbage collector finds out-of-heap pointers that could cause a crash
  in the multicore runtime
- Support for macOS/arm64 - Mnemonic names for warnings - Many quality of life improvements - Many bug fixes
|js}
  ; highlights_html = {js|<ul>
<li>Major progress in reducing the difference between the mainline and
multicore runtime
</li>
<li>A new configuration option <code>ocaml-option-nnpchecker</code> which emits an alarm
when the garbage collector finds out-of-heap pointers that could cause a crash
in the multicore runtime
</li>
<li>Support for macOS/arm64 - Mnemonic names for warnings - Many quality of life improvements - Many bug fixes
</li>
</ul>
|js}
  ; body_md = {js|
What's new
----------
Some of the highlights in OCaml 4.12.0 are:

- Major progress in reducing the difference between the mainline and
  multicore runtime
- A new configuration option `ocaml-option-nnpchecker` which emits an alarm
  when the garbage collector finds out-of-heap pointers that could cause a crash
  in the multicore runtime
- Support for macOS/arm64
- Mnemonic names for warnings
- Many quality of life improvements
- Many bug fixes

For a comprehensive list of changes and details on all new features,
bug fixes, optimizations, etc., please consult the
[changelog](#Changes).

Configuration options
---------------------

The configuration of the installed opam switch can be tuned with the
following options:

- ocaml-option-32bit: set OCaml to be compiled in 32-bit mode for 64-bit Linux and OS X hosts
- ocaml-option-afl: set OCaml to be compiled with afl-fuzz instrumentation
- ocaml-option-bytecode-only: compile OCaml without the native-code compiler
- ocaml-option-default-unsafe-string: set OCaml to be compiled without safe strings by default
- ocaml-option-flambda: set OCaml to be compiled with flambda activated
- ocaml-option-fp: set OCaml to be compiled with frame-pointers enabled
- ocaml-option-musl: set OCaml to be compiled with musl-gcc
- ocaml-option-nnp : set OCaml to be compiled with --disable-naked-pointers
- ocaml-option-nnpchecker: set OCaml to be compiled with --enable-naked-pointers-checker
- ocaml-option-no-flat-float-array: set OCaml to be compiled with --disable-flat-float-array
- ocaml-option-static :set OCaml to be compiled with musl-gcc -static

For instance, one can install a switch with both `flambda` and the naked-pointer checker enabled with

```
opam switch create 4.12.0+flambda+nnpchecker --package=ocaml-variants.4.12.0+options,ocaml-option-flambda,ocaml-option-nnpchecker
```


Source distribution
---------------------------------------------

- [Source
  tarball](https://github.com/ocaml/ocaml/archive/4.12.0.tar.gz)
  (.tar.gz) for compilation under Unix (including Linux and MacOS X)
  and Microsoft Windows (including Cygwin).
- Also available in
  [.zip](https://github.com/ocaml/ocaml/archive/4.12.0.zip)
  format.
- [OPAM](https://opam.ocaml.org/) is a source-based distribution of
  OCaml and many companion libraries and tools. Compilation and
  installation are automated by powerful package managers.
- The official development repo is hosted on
  [GitHub](https://github.com/ocaml/ocaml).

The
[INSTALL](4.12/notes/INSTALL.adoc) file
of the distribution provides detailed compilation and installation
instructions — see also the [Windows release
notes](4.12/notes/README.win32.adoc) for
instructions on how to build under Windows.

Alternative Compilers
---------------------

Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:

* [Js_of_ocaml](http://ocsigen.org/js_of_ocaml/) is a stable OCaml
  to JavaScript compiler.

User's manual
------------------------------------

The user's manual for OCaml can be:

- [browsed
  online](4.12/htmlman/index.html),
- downloaded as a single
  [PDF](4.12/ocaml-4.12-refman.pdf),
  or [plain
  text](4.12/ocaml-4.12-refman.txt)
  document,
- downloaded as a single
  [TAR](4.12/ocaml-4.12-refman-html.tar.gz)
  or
  [ZIP](4.11/ocaml-4.12-refman-html.zip)
  archive of HTML files,
- downloaded as a single
  [tarball](4.12/ocaml-4.12-refman.info.tar.gz)
  of Emacs info files,



Changes
-------

This is the
[changelog](4.12/notes/Changes).
(Changes that can break existing programs are marked with a  "breaking change" warning)

### Supported platforms (highlights):

- [9699](https://github.com/ocaml/ocaml/issues/9699): add support for iOS and macOS on ARM 64 bits
  (Eduardo Rafael, review by Xavier Leroy, Nicolás Ojeda Bär
   and Anil Madhavapeddy, additional testing by Michael Schmidt)

### Standard library (highlights):

- [9797](https://github.com/ocaml/ocaml/issues/9797): Add Sys.mkdir and Sys.rmdir.
  (David Allsopp, review by Nicolás Ojeda Bär, Sébastien Hinderer and
   Xavier Leroy)

* [*breaking change*] [9765](https://github.com/ocaml/ocaml/issues/9765): add init functions to Bigarray.
  (Jeremy Yallop, review by Gabriel Scherer, Nicolás Ojeda Bär, and
   Xavier Leroy)

* [*breaking change*] [9668](https://github.com/ocaml/ocaml/issues/9668): List.equal, List.compare
  (This could break code using "open List" by shadowing
   Stdlib.{equal,compare}.)
  (Gabriel Scherer, review by Nicolás Ojeda Bär, Daniel Bünzli and Alain Frisch)

- [9066](https://github.com/ocaml/ocaml/issues/9066): a new Either module with
  type 'a Either.t = Left of 'a | Right of 'b
  (Gabriel Scherer, review by Daniel Bünzli, Thomas Refis, Jeremy Yallop)

- [9066](https://github.com/ocaml/ocaml/issues/9066): List.partition_map :
    ('a -> ('b, 'c) Either.t) -> 'a list -> 'b list * 'c list
  (Gabriel Scherer, review by Jeremy Yallop)

- [9865](https://github.com/ocaml/ocaml/issues/9865): add Format.pp_print_seq
  (Raphaël Proust, review by Nicolás Ojeda Bär)

### Compiler user-interface and warnings (highlights):

- [9657](https://github.com/ocaml/ocaml/issues/9657): Warnings can now be referred to by their mnemonic name. The names are
  displayed using `-warn-help` and can be utilized anywhere where a warning list
  specification is expected.
      ocamlc -w +fragile-match
      ...[@@ocaml.warning "-fragile-match"]
  Note that only a single warning name at a time is supported for now:
  "-w +foo-bar" does not work, you must use "-w +foo -w -bar".
  (Nicolás Ojeda Bär, review by Gabriel Scherer, Florian Angeletti and
   Leo White)

- [8939](https://github.com/ocaml/ocaml/issues/8939): Command-line option to save Linear IR before emit.
  (Greta Yorsh, review by Mark Shinwell, Sébastien Hinderer and Frédéric Bour)

- [9003](https://github.com/ocaml/ocaml/issues/9003): Start compilation from Emit when the input file is in Linear IR format.
  (Greta Yorsh, review by Jérémie Dimino, Gabriel Scherer and Frédéric Bour)

### Language features (highlights):

* [*breaking change*] [9500](https://github.com/ocaml/ocaml/issues/9500), [9727](https://github.com/ocaml/ocaml/issues/9727), [9866](https://github.com/ocaml/ocaml/issues/9866), [9870](https://github.com/ocaml/ocaml/issues/9870), [9873](https://github.com/ocaml/ocaml/issues/9873): Injectivity annotations
  One can now mark type parameters as injective, which is useful for
  abstract types:
    module Vec : sig type !'a t end = struct type 'a t = 'a array end
  On non-abstract types, this can be used to check the injectivity of
  parameters. Since all parameters of record and sum types are by definition
  injective, this only makes sense for type abbreviations:
    type !'a t = 'a list
  Note that this change required making the regularity check stricter.
  (Jacques Garrigue, review by Jeremy Yallop and Leo White)

### Runtime system (highlights):

- [9534](https://github.com/ocaml/ocaml/issues/9534), [9947](https://github.com/ocaml/ocaml/issues/9947): Introduce a naked pointers checker mode to the runtime
  (configure option --enable-naked-pointers-checker).  Alarms are printed
  when the garbage collector finds out-of-heap pointers that could
  cause a crash in no-naked-pointers mode.
  (Enguerrand Decorne, KC Sivaramakrishnan, Xavier Leroy, Stephen Dolan,
  David Allsopp, Nicolás Ojeda Bär review by Xavier Leroy, Nicolás Ojeda Bär)

* [*breaking change*] [1128](https://github.com/ocaml/ocaml/issues/1128), [7503](https://github.com/ocaml/ocaml/issues/7503), [9036](https://github.com/ocaml/ocaml/issues/9036), [9722](https://github.com/ocaml/ocaml/issues/9722), [10069](https://github.com/ocaml/ocaml/issues/10069): EINTR-based signal handling.
  When a signal arrives, avoid running its OCaml handler in the middle
  of a blocking section. Instead, allow control to return quickly to
  a polling point where the signal handler can safely run, ensuring that
  I/O locks are not held while it runs. A polling point was removed from
  caml_leave_blocking_section, and one added to caml_raise.
  (Stephen Dolan, review by Goswin von Brederlow, Xavier Leroy, Damien
   Doligez, Anil Madhavapeddy, Guillaume Munch-Maccagnoni and Jacques-
   Henri Jourdan)

* [*breaking change*] [5154](https://github.com/ocaml/ocaml/issues/5154), [9569](https://github.com/ocaml/ocaml/issues/9569), [9734](https://github.com/ocaml/ocaml/issues/9734): Add `Val_none`, `Some_val`, `Is_none`, `Is_some`,
  `caml_alloc_some`, and `Tag_some`. As these macros are sometimes defined by
  authors of C bindings, this change may cause warnings/errors in case of
  redefinition.
  (Nicolás Ojeda Bär, review by Stephen Dolan, Gabriel Scherer, Mark Shinwell,
  and Xavier Leroy)

* [*breaking change*] [9674](https://github.com/ocaml/ocaml/issues/9674): Memprof: guarantee that an allocation callback is always run
  in the same thread the allocation takes place
  (Jacques-Henri Jourdan, review by Stephen Dolan)

- [10025](https://github.com/ocaml/ocaml/issues/10025): Track custom blocks (e.g. Bigarray) with Memprof
  (Stephen Dolan, review by Leo White, Gabriel Scherer and Jacques-Henri
   Jourdan)

- [9619](https://github.com/ocaml/ocaml/issues/9619): Change representation of function closures so that code pointers
  can be easily distinguished from environment variables
  (Xavier Leroy, review by Mark Shinwell and Damien Doligez)

- [9654](https://github.com/ocaml/ocaml/issues/9654): More efficient management of code fragments.
  (Xavier Leroy, review by Jacques-Henri Jourdan, Damien Doligez, and
  Stephen Dolan)

### Other libraries (highlights):

- [9573](https://github.com/ocaml/ocaml/issues/9573): reimplement Unix.create_process and related functions without
  Unix.fork, for better efficiency and compatibility with threads.
  (Xavier Leroy, review by Gabriel Scherer and Anil Madhavapeddy)

- [9575](https://github.com/ocaml/ocaml/issues/9575): Add Unix.is_inet6_addr
  (Nicolás Ojeda Bär, review by Xavier Leroy)

- [9930](https://github.com/ocaml/ocaml/issues/9930): new module Semaphore in the thread library, implementing
  counting semaphores and binary semaphores
  (Xavier Leroy, review by Daniel Bünzli and Damien Doligez,
   additional suggestions by Stephen Dolan and Craig Ferguson)

* [*breaking change*] [9206](https://github.com/ocaml/ocaml/issues/9206), [9419](https://github.com/ocaml/ocaml/issues/9419): update documentation of the threads library;
  deprecate Thread.kill, Thread.wait_read, Thread.wait_write,
  and the whole ThreadUnix module.
  (Xavier Leroy, review by Florian Angeletti, Guillaume Munch-Maccagnoni,
   and Gabriel Scherer)

### Manual and documentation (highlights):

- [9755](https://github.com/ocaml/ocaml/issues/9755): Manual: post-processing the html generated by ocamldoc and
   hevea. Improvements on design and navigation, including a mobile
   version, and a quick-search functionality for the API.
   (San Vũ Ngọc, review by David Allsopp and Florian Angeletti)

- [9468](https://github.com/ocaml/ocaml/issues/9468): HACKING.adoc: using dune to get merlin support
  (Thomas Refis, review by Gabriel Scherer)

- [9684](https://github.com/ocaml/ocaml/issues/9684): document in address_class.h the runtime value model in
  naked-pointers and no-naked-pointers mode
  (Xavier Leroy and Gabriel Scherer)

### Internal/compiler-libs changes (highlights):

- [9464](https://github.com/ocaml/ocaml/issues/9464), [9493](https://github.com/ocaml/ocaml/issues/9493), [9520](https://github.com/ocaml/ocaml/issues/9520), [9563](https://github.com/ocaml/ocaml/issues/9563), [9599](https://github.com/ocaml/ocaml/issues/9599), [9608](https://github.com/ocaml/ocaml/issues/9608), [9647](https://github.com/ocaml/ocaml/issues/9647): refactor
  the pattern-matching compiler
  (Thomas Refis and Gabriel Scherer, review by Florian Angeletti)

- [9696](https://github.com/ocaml/ocaml/issues/9696): ocamltest now shows its log when a test fails. In addition, the log
  contains the output of executed programs.
  (Nicolás Ojeda Bär, review by David Allsopp, Sébastien Hinderer and Gabriel
  Scherer)

### Build system (highlights):

- [9824](https://github.com/ocaml/ocaml/issues/9824), [9837](https://github.com/ocaml/ocaml/issues/9837): Honour the CFLAGS and CPPFLAGS variables.
  (Sébastien Hinderer, review by David Allsopp)

- [10063](https://github.com/ocaml/ocaml/issues/10063): (Re-)enable building on illumos (SmartOS, OmniOS, ...) and
  Oracle Solaris; x86_64/GCC and 64-bit SPARC/Sun PRO C compilers.
  (partially revert [2024](https://github.com/ocaml/ocaml/issues/2024)).
  (Tõivo Leedjärv and Konstantin Romanov,
   review by Gabriel Scherer, Sébastien Hinderer and Xavier Leroy)


### Language features:

- [1655](https://github.com/ocaml/ocaml/issues/1655): pattern aliases do not ignore type constraints
  (Thomas Refis, review by Jacques Garrigue and Gabriel Scherer)

- [9429](https://github.com/ocaml/ocaml/issues/9429): Add unary operators containing `#` to the parser for use in ppx
  rewriters
  (Leo White, review by Damien Doligez)

### Runtime system:

* [*breaking change*] [9697](https://github.com/ocaml/ocaml/issues/9697): Remove the Is_in_code_area macro and the registration of DLL code
  areas in the page table, subsumed by the new code fragment management API
  (Xavier Leroy, review by Jacques-Henri Jourdan)

- [9756](https://github.com/ocaml/ocaml/issues/9756): garbage collector colors change
  removes the gray color from the major gc
  (Sadiq Jaffer and Stephen Dolan reviewed by Xavier Leroy,
  KC Sivaramakrishnan, Damien Doligez and Jacques-Henri Jourdan)

* [*breaking change*] [9513](https://github.com/ocaml/ocaml/issues/9513): Selectively initialise blocks in `Obj.new_block`. Reject `Custom_tag`
  objects and zero-length `String_tag` objects.
  (KC Sivaramakrishnan, review by David Allsopp, Xavier Leroy, Mark Shinwell
  and Leo White)

- [9564](https://github.com/ocaml/ocaml/issues/9564): Add a macro to construct out-of-heap block header.
  (KC Sivaramakrishnan, review by Stephen Dolan, Gabriel Scherer,
   and Xavier Leroy)

- [9951](https://github.com/ocaml/ocaml/issues/9951): Ensure that the mark stack push optimisation handles naked pointers
  (KC Sivaramakrishnan, reported by Enguerrand Decorne, review by Gabriel
   Scherer, and Xavier Leroy)

- [9678](https://github.com/ocaml/ocaml/issues/9678): Reimplement `Obj.reachable_words` using a hash table to
  detect sharing, instead of temporary in-place modifications.  This
  is a prerequisite for Multicore OCaml.
  (Xavier Leroy, review by Jacques-Henri Jourdan and Sébastien Hinderer)

- [1795](https://github.com/ocaml/ocaml/issues/1795), [9543](https://github.com/ocaml/ocaml/issues/9543): modernize signal handling on Linux i386, PowerPC, and s390x,
  adding support for Musl ppc64le along the way.
  (Xavier Leroy and Anil Madhavapeddy, review by Stephen Dolan)

- [9648](https://github.com/ocaml/ocaml/issues/9648), [9689](https://github.com/ocaml/ocaml/issues/9689): Update the generic hash function to take advantage
  of the new representation for function closures
  (Xavier Leroy, review by Stephen Dolan)

- [9649](https://github.com/ocaml/ocaml/issues/9649): Update the marshaler (output_value) to take advantage
  of the new representation for function closures
  (Xavier Leroy, review by Damien Doligez)

- [10050](https://github.com/ocaml/ocaml/issues/10050): update {PUSH,}OFFSETCLOSURE* bytecode instructions to match new
  representation for closures
  (Nathanaël Courant, review by Xavier Leroy)

- [9728](https://github.com/ocaml/ocaml/issues/9728): Take advantage of the new closure representation to simplify the
  compaction algorithm and remove its dependence on the page table
  (Damien Doligez, review by Jacques-Henri Jourdan and Xavier Leroy)

- [2195](https://github.com/ocaml/ocaml/issues/2195): Improve error message in bytecode stack trace printing and load
  debug information during bytecode startup if OCAMLRUNPARAM=b=2.
  (David Allsopp, review by Gabriel Scherer and Xavier Leroy)

- [9466](https://github.com/ocaml/ocaml/issues/9466): Memprof: optimize random samples generation.
  (Jacques-Henri Jourdan, review by Xavier Leroy and Stephen Dolan)

- [9628](https://github.com/ocaml/ocaml/issues/9628): Memprof: disable sampling when memprof is suspended.
  (Jacques-Henri Jourdan, review by Gabriel Scherer and Stephen Dolan)

- [10056](https://github.com/ocaml/ocaml/issues/10056): Memprof: ensure young_trigger is within the bounds of the minor
  heap in caml_memprof_renew_minor_sample (regression from [8684](https://github.com/ocaml/ocaml/issues/8684))
  (David Allsopp, review by Guillaume Munch-Maccagnoni and
  Jacques-Henri Jourdan)

- [9508](https://github.com/ocaml/ocaml/issues/9508): Remove support for FreeBSD prior to 4.0R, that required explicit
  floating-point initialization to behave like IEEE standard
  (Hannes Mehnert, review by David Allsopp)

- [8807](https://github.com/ocaml/ocaml/issues/8807), [9503](https://github.com/ocaml/ocaml/issues/9503): Use different symbols for do_local_roots on bytecode and native
  (Stephen Dolan, review by David Allsopp and Xavier Leroy)

- [9670](https://github.com/ocaml/ocaml/issues/9670): Report full major collections in Gc stats.
  (Leo White, review by Gabriel Scherer)

- [9675](https://github.com/ocaml/ocaml/issues/9675): Remove the caml_static_{alloc,free,resize} primitives, now unused.
  (Xavier Leroy, review by Gabriel Scherer)

- [9710](https://github.com/ocaml/ocaml/issues/9710): Drop "support" for an hypothetical JIT for OCaml bytecode
   which has never existed.
  (Jacques-Henri Jourdan, review by Xavier Leroy)

- [9742](https://github.com/ocaml/ocaml/issues/9742), [9989](https://github.com/ocaml/ocaml/issues/9989): Ephemerons are now compatible with infix pointers occurring
   when using mutually recursive functions.
   (Jacques-Henri Jourdan, review by François Bobot)

- [9888](https://github.com/ocaml/ocaml/issues/9888), [9890](https://github.com/ocaml/ocaml/issues/9890): Fixes a bug in the `riscv` backend where register t0 was not
  saved/restored when performing a GC. This could potentially lead to a
  segfault.
  (Nicolás Ojeda Bär, report by Xavier Leroy, review by Xavier Leroy)

- [9907](https://github.com/ocaml/ocaml/issues/9907): Fix native toplevel on native Windows.
  (David Allsopp, review by Florian Angeletti)

- [9909](https://github.com/ocaml/ocaml/issues/9909): Remove caml_code_area_start and caml_code_area_end globals (no longer
  needed as the pagetable heads towards retirement).
  (David Allsopp, review by Xavier Leroy)

- [9949](https://github.com/ocaml/ocaml/issues/9949): Clarify documentation of GC message 0x1 and make sure it is
  displayed every time a major cycle is forcibly finished.
  (Damien Doligez, review by Xavier Leroy)

- [10062](https://github.com/ocaml/ocaml/issues/10062): set ARCH_INT64_PRINTF_FORMAT correctly for both modes of mingw-w64
  (David Allsopp, review by Xavier Leroy)

### Code generation and optimizations:

- [9551](https://github.com/ocaml/ocaml/issues/9551): ocamlc no longer loads DLLs at link time to check that
  external functions referenced from OCaml code are defined.
  Instead, .so/.dll files are parsed directly by pure OCaml code.
  (Nicolás Ojeda Bär, review by Daniel Bünzli, Gabriel Scherer,
   Anil Madhavapeddy, and Xavier Leroy)

- [9620](https://github.com/ocaml/ocaml/issues/9620): Limit the number of parameters for an uncurried or untupled
   function.  Functions with more parameters than that are left
   partially curried or tupled.
   (Xavier Leroy, review by Mark Shinwell)

- [9752](https://github.com/ocaml/ocaml/issues/9752): Revised handling of calling conventions for external C functions.
   Provide a more precise description of the types of unboxed arguments,
   so that the ARM64 iOS/macOS calling conventions can be honored.
   (Xavier Leroy, review by Mark Shinwell and Eduardo Rafael)

- [9838](https://github.com/ocaml/ocaml/issues/9838): Ensure that Cmm immediates are generated as Cconst_int where
  possible, improving instruction selection.
  (Stephen Dolan, review by Leo White and Xavier Leroy)

- [9864](https://github.com/ocaml/ocaml/issues/9864): Revised recognition of immediate arguments to integer operations.
  Fixes several issues that could have led to producing assembly code
  that is rejected by the assembler.
  (Xavier Leroy, review by Stephen Dolan)

- [9969](https://github.com/ocaml/ocaml/issues/9969), [9981](https://github.com/ocaml/ocaml/issues/9981): Added mergeable flag to ELF sections containing mergeable
  constants.  Fixes compatibility with the integrated assembler in clang 11.0.0.
  (Jacob Young, review by Nicolás Ojeda Bär)

### Standard library:

- [9781](https://github.com/ocaml/ocaml/issues/9781): add injectivity annotations to parameterized abstract types
  (Jeremy Yallop, review by Nicolás Ojeda Bär)

* [*breaking change*] [9554](https://github.com/ocaml/ocaml/issues/9554): add primitive __FUNCTION__ that returns the name of the current method
  or function, including any enclosing module or class.
  (Nicolás Ojeda Bär, Stephen Dolan, review by Stephen Dolan)

- [9075](https://github.com/ocaml/ocaml/issues/9075): define to_rev_seq in Set and Map modules.
  (Sébastien Briais, review by Gabriel Scherer and Nicolás Ojeda Bär)

- [9561](https://github.com/ocaml/ocaml/issues/9561): Unbox Unix.gettimeofday and Unix.time
  (Stephen Dolan, review by David Allsopp)

- [9570](https://github.com/ocaml/ocaml/issues/9570): Provide an Atomic module with a trivial purely-sequential
  implementation, to help write code that is compatible with Multicore
  OCaml.
  (Gabriel Scherer, review by Xavier Leroy)

- [10035](https://github.com/ocaml/ocaml/issues/10035): Make sure that flambda respects atomicity in the Atomic module.
  (Guillaume Munch-Maccagnoni, review by Gabriel Scherer)

- [9571](https://github.com/ocaml/ocaml/issues/9571): Make at_exit and Printexc.register_printer thread-safe.
  (Guillaume Munch-Maccagnoni, review by Gabriel Scherer and Xavier Leroy)

- [9587](https://github.com/ocaml/ocaml/issues/9587): Arg: new Rest_all spec to get all rest arguments in a list
  (this is similar to Rest, but makes it possible to detect when there
   are no arguments (an empty list) after the rest marker)
  (Gabriel Scherer, review by Nicolás Ojeda Bär and David Allsopp)

- [9655](https://github.com/ocaml/ocaml/issues/9655): Obj: introduce type raw_data and functions raw_field, set_raw_field
   to manipulate out-of-heap pointers in no-naked-pointer mode,
   and more generally all other data that is not a well-formed OCaml value
   (Xavier Leroy, review by Damien Doligez and Gabriel Scherer)

- [9663](https://github.com/ocaml/ocaml/issues/9663): Extend Printexc API for raw backtrace entries.
  (Stephen Dolan, review by Nicolás Ojeda Bär and Gabriel Scherer)

- [9763](https://github.com/ocaml/ocaml/issues/9763): Add function Hashtbl.rebuild to convert from old hash table
  formats (that may have been saved to persistent storage) to the
  current hash table format.  Remove leftover support for the hash
  table format and generic hash function that were in use before OCaml 4.00.
  (Xavier Leroy, review by Nicolás Ojeda Bär)

- [10070](https://github.com/ocaml/ocaml/issues/10070): Fix Float.Array.blit when source and destination arrays coincide.
  (Nicolás Ojeda Bär, review by Alain Frisch and Xavier Leroy)

### Other libraries:

- [8796](https://github.com/ocaml/ocaml/issues/8796): On Windows, make Unix.utimes use FILE_FLAG_BACKUP_SEMANTICS flag
  to allow it to work with directories.
  (Daniil Baturin, review by Damien Doligez)

- [9593](https://github.com/ocaml/ocaml/issues/9593): Use new flag for non-elevated symbolic links and test for Developer
  Mode on Windows
  (Manuel Hornung, review by David Allsopp and Nicolás Ojeda Bär)

* [*breaking change*] [9601](https://github.com/ocaml/ocaml/issues/9601): Return EPERM for EUNKNOWN -1314 in win32unix (principally affects
  error handling when Unix.symlink is unavailable)
  (David Allsopp, review by Xavier Leroy)

- [9338](https://github.com/ocaml/ocaml/issues/9338), [9790](https://github.com/ocaml/ocaml/issues/9790): Dynlink: make sure *_units () functions report accurate
  information before the first load.
  (Daniel Bünzli, review by Xavier Leroy and Nicolás Ojeda Bär)

* [*breaking change*] [9757](https://github.com/ocaml/ocaml/issues/9757), [9846](https://github.com/ocaml/ocaml/issues/9846), [10161](https://github.com/ocaml/ocaml/issues/10161): check proper ownership when operating over mutexes.
  Now, unlocking a mutex held by another thread or not locked at all
  reliably raises a Sys_error exception.  Before, it was undefined
  behavior, but the documentation did not say so.
  Likewise, locking a mutex already locked by the current thread
  reliably raises a Sys_error exception.  Before, it could
  deadlock or succeed (and do recursive locking), depending on the OS.
  (Xavier Leroy, report by Guillaume Munch-Maccagnoni, review by
  Guillaume Munch-Maccagnoni, David Allsopp, and Stephen Dolan)

- [9802](https://github.com/ocaml/ocaml/issues/9802): Ensure signals are handled before Unix.kill returns
  (Stephen Dolan, review by Jacques-Henri Jourdan)

- [9869](https://github.com/ocaml/ocaml/issues/9869), [10073](https://github.com/ocaml/ocaml/issues/10073): Add Unix.SO_REUSEPORT
  (Yishuai Li, review by Xavier Leroy, amended by David Allsopp)

- [9906](https://github.com/ocaml/ocaml/issues/9906), [9914](https://github.com/ocaml/ocaml/issues/9914): Add Unix._exit as a way to exit the process immediately,
  skipping any finalization action
  (Ivan Gotovchits and Xavier Leroy, review by Sébastien Hinderer and
   David Allsopp)

- [9958](https://github.com/ocaml/ocaml/issues/9958): Raise exception in case of error in Unix.setsid.
  (Nicolás Ojeda Bär, review by Stephen Dolan)

- [9971](https://github.com/ocaml/ocaml/issues/9971), [9973](https://github.com/ocaml/ocaml/issues/9973): Make sure the process can terminate when the last thread
  calls Thread.exit.
  (Xavier Leroy, report by Jacques-Henri Jourdan, review by David Allsopp
  and Jacques-Henri Jourdan).

### Tools:

- [9551](https://github.com/ocaml/ocaml/issues/9551): ocamlobjinfo is now able to display information on .cmxs shared
  libraries natively; it no longer requires libbfd to do so
  (Nicolás Ojeda Bär, review by Daniel Bünzli, Gabriel Scherer,
   Anil Madhavapeddy, and Xavier Leroy)

* [*breaking change*] [9299](https://github.com/ocaml/ocaml/issues/9299), [9795](https://github.com/ocaml/ocaml/issues/9795): ocamldep: do not process files during cli parsing. Fixes
  various broken cli behaviours.
  (Daniel Bünzli, review by Nicolás Ojeda Bär)

### Debugging and profiling:

- [9606](https://github.com/ocaml/ocaml/issues/9606), [9635](https://github.com/ocaml/ocaml/issues/9635), [9637](https://github.com/ocaml/ocaml/issues/9637): fix 4.10 performance regression in the debugger
  (behaviors quadratic in the size of the debugged program)
  (Xavier Leroy, report by Jacques Garrigue and Virgile Prevosto,
  review by David Allsopp and Jacques-Henri Jourdan)

- [9948](https://github.com/ocaml/ocaml/issues/9948): Remove Spacetime.
  (Nicolás Ojeda Bär, review by Stephen Dolan and Xavier Leroy)

### Manual and documentation:

- [10142](https://github.com/ocaml/ocaml/issues/10142), [10154](https://github.com/ocaml/ocaml/issues/10154): improved rendering and latex code for toplevel code examples.
  (Florian Angeletti, report by John Whitington, review by Gabriel Scherer)

- [9745](https://github.com/ocaml/ocaml/issues/9745): Manual: Standard Library labeled and unlabeled documentation unified
  (John Whitington, review by Nicolás Ojeda Bär, David Allsopp,
   Thomas Refis, and Florian Angeletti)

- [9877](https://github.com/ocaml/ocaml/issues/9877): manual, warn that multi-index indexing operators should be defined in
  conjunction of single-index ones.
  (Florian Angeletti, review by Hezekiah M. Carty, Gabriel Scherer,
   and Marcello Seri)

- [10233](https://github.com/ocaml/ocaml/issues/10233): Document `-save-ir-after scheduling` and update `-stop-after` options.
  (Greta Yorsh, review by Gabriel Scherer and Florian Angeletti)

### Compiler user-interface and warnings:

- [1931](https://github.com/ocaml/ocaml/issues/1931): rely on levels to enforce principality in patterns
  (Thomas Refis and Leo White, review by Jacques Garrigue)

* [*breaking change*] [9011](https://github.com/ocaml/ocaml/issues/9011): Do not create .a/.lib files when creating a .cmxa with no modules.
  macOS ar doesn't support creating empty .a files ([1094](https://github.com/ocaml/ocaml/issues/1094)) and MSVC doesn't
  permit .lib files to contain no objects. When linking with a .cmxa containing
  no modules, it is now not an error for there to be no .a/.lib file.
  (David Allsopp, review by Xavier Leroy)

- [9560](https://github.com/ocaml/ocaml/issues/9560): Report partial application warnings on type errors in applications.
  (Stephen Dolan, report and testcase by whitequark, review by Gabriel Scherer
   and Thomas Refis)

- [9583](https://github.com/ocaml/ocaml/issues/9583): when bytecode linking fails due to an unavailable module, the module
  that requires it is now included in the error message.
  (Nicolás Ojeda Bär, review by Vincent Laviron)

- [9615](https://github.com/ocaml/ocaml/issues/9615): Attach package type attributes to core_type.
  When parsing constraints on a first class module, attributes found after the
  module type were parsed but ignored. Now they are attached to the
  corresponding core_type.
  (Etienne Millon, review by Thomas Refis)

- [6633](https://github.com/ocaml/ocaml/issues/6633), [9673](https://github.com/ocaml/ocaml/issues/9673): Add hint when a module is used instead of a module type or
  when a module type is used instead of a module or when a class type is used
  instead of a class.
  (Xavier Van de Woestyne, report by whitequark, review by Florian Angeletti
  and Gabriel Scherer)

- [9754](https://github.com/ocaml/ocaml/issues/9754): allow [@tailcall true] (equivalent to [@tailcall]) and
  [@tailcall false] (warns if on a tailcall)
  (Gabriel Scherer, review by Nicolás Ojeda Bär)

- [9751](https://github.com/ocaml/ocaml/issues/9751): Add warning 68. Pattern-matching depending on mutable state
  prevents the remaining arguments from being uncurried.
  (Hugo Heuzard, review by Leo White)

- [9783](https://github.com/ocaml/ocaml/issues/9783): Widen warning 16 (Unerasable optional argument) to more cases.
  (Leo White, review by Florian Angeletti)

- [10008](https://github.com/ocaml/ocaml/issues/10008): Improve error message for aliases to the current compilation unit.
  (Leo White, review by Gabriel Scherer)

- [10046](https://github.com/ocaml/ocaml/issues/10046): Link all DLLs with -static-libgcc on mingw32 to prevent dependency
  on libgcc_s_sjlj-1.dll with mingw-w64 runtime 8.0.0 (previously this was
  only needed for dllunix.dll).
  (David Allsopp, report by Andreas Hauptmann, review by Xavier Leroy)

- [9634](https://github.com/ocaml/ocaml/issues/9634): Allow initial and repeated commas in `OCAMLRUNPARAM`.
  (Nicolás Ojeda Bär, review by Gabriel Scherer)

### Internal/compiler-libs changes:

- [8987](https://github.com/ocaml/ocaml/issues/8987): Make some locations more accurate
  (Thomas Refis, review by Gabriel Scherer)

- [9216](https://github.com/ocaml/ocaml/issues/9216): add Lambda.duplicate which refreshes bound identifiers
  (Gabriel Scherer, review by Pierre Chambart and Vincent Laviron)

- [9376](https://github.com/ocaml/ocaml/issues/9376): Remove spurious Ptop_defs from #use
  (Leo White, review by Damien Doligez)

- [9604](https://github.com/ocaml/ocaml/issues/9604): refactoring of the ocamltest codebase.
  (Nicolás Ojeda Bär, review by Gabriel Scherer and Sébastien Hinderer)

- [9498](https://github.com/ocaml/ocaml/issues/9498), [9511](https://github.com/ocaml/ocaml/issues/9511): make the pattern-matching analyzer more robust to
  or-pattern explosion, by stopping after the first counter-example to
  exhaustivity
  (Gabriel Scherer, review by Luc Maranget, Thomas Refis and Florian Angeletti,
   report by Alex Fedoseev through Hongbo Zhang)

- [9514](https://github.com/ocaml/ocaml/issues/9514): optimize pattern-matching exhaustivity analysis in the single-row case
  (Gabriel Scherer, review by Stephen DOlan)

- [9442](https://github.com/ocaml/ocaml/issues/9442): refactor the implementation of the [@tailcall] attribute
  to allow for a structured attribute payload
  (Gabriel Scherer, review by Vladimir Keleshev and Nicolás Ojeda Bär)

- [9688](https://github.com/ocaml/ocaml/issues/9688): Expose the main entrypoint in compilerlibs
  (Stephen Dolan, review by Nicolás Ojeda Bär, Greta Yorsh and David Allsopp)

- [9715](https://github.com/ocaml/ocaml/issues/9715): recheck scope escapes after normalising paths
  (Matthew Ryan, review by Gabriel Scherer and Thomas Refis)

- [9778](https://github.com/ocaml/ocaml/issues/9778): Fix printing for bindings where polymorphic type annotations and
  attributes are present.
  (Matthew Ryan, review by Nicolás Ojeda Bär)

- [9797](https://github.com/ocaml/ocaml/issues/9797), [9849](https://github.com/ocaml/ocaml/issues/9849): Eliminate the routine use of external commands in ocamltest.
  ocamltest no longer calls the mkdir, rm and ln external commands (at present,
  the only external command ocamltest uses is diff).
  (David Allsopp, review by Nicolás Ojeda Bär, Sébastien Hinderer and
   Xavier Leroy)

- [9801](https://github.com/ocaml/ocaml/issues/9801): Don't ignore EOL-at-EOF differences in ocamltest.
  (David Allsopp, review by Damien Doligez, much input and thought from
   Daniel Bünzli, Damien Doligez, Sébastien Hinderer, and Xavier Leroy)

- [9889](https://github.com/ocaml/ocaml/issues/9889): more caching when printing types with -short-path.
  (Florian Angeletti, review by Gabriel Scherer)

-  [9591](https://github.com/ocaml/ocaml/issues/9591): fix pprint of polyvariants that start with a core_type, closed,
   not low (Chet Murthy, review by Florian Angeletti)

-  [9590](https://github.com/ocaml/ocaml/issues/9590): fix pprint of extension constructors (and exceptions) that rebind
   (Chet Murthy, review by octachron@)

- [9963](https://github.com/ocaml/ocaml/issues/9963): Centralized tracking of frontend's global state
  (Frédéric Bour and Thomas Refis, review by Gabriel Scherer)

- [9631](https://github.com/ocaml/ocaml/issues/9631): Named text sections for caml_system__code_begin/end symbols
  (Greta Yorsh, review by Frédéric Bour)

- [9896](https://github.com/ocaml/ocaml/issues/9896): Share the strings representing scopes, fixing some regression
  on .cmo/.cma sizes
  (Alain Frisch and Xavier Clerc, review by Gabriel Scherer)

### Build system:

- [9332](https://github.com/ocaml/ocaml/issues/9332), [9518](https://github.com/ocaml/ocaml/issues/9518), [9529](https://github.com/ocaml/ocaml/issues/9529): Cease storing C dependencies in the codebase. C
  dependencies are generated on-the-fly in development mode. For incremental
  compilation, the MSVC ports require GCC to be present.
  (David Allsopp, review by Sébastien Hinderer, YAML-fu by Stephen Dolan)

- [7121](https://github.com/ocaml/ocaml/issues/7121), [9558](https://github.com/ocaml/ocaml/issues/9558): Always have the autoconf-discovered ld in PACKLD, with
  extra flags in new variable PACKLD_FLAGS. For
  cross-compilation, this means the triplet-prefixed version will always be
  used.
  (David Allsopp, report by Adrian Nader, review by Sébastien Hinderer)

- [9527](https://github.com/ocaml/ocaml/issues/9527): stop including configuration when running 'clean' rules
  to avoid C dependency recomputation.
  (Gabriel Scherer, review by David Allsopp)

- [9804](https://github.com/ocaml/ocaml/issues/9804): Build C stubs of libraries in otherlibs/ with debug info.
  (Stephen Dolan, review by Sébastien Hinderer and David Allsopp)

- [9938](https://github.com/ocaml/ocaml/issues/9938), [9939](https://github.com/ocaml/ocaml/issues/9939): Define __USE_MINGW_ANSI_STDIO=0 for the mingw-w64 ports to
  prevent their C99-compliant snprintf conflicting with ours.
  (David Allsopp, report by Michael Soegtrop, review by Xavier Leroy)

- [9895](https://github.com/ocaml/ocaml/issues/9895), [9523](https://github.com/ocaml/ocaml/issues/9523): Avoid conflict with C++20 by not installing VERSION to the OCaml
  Standard Library directory.
  (Bernhard Schommer, review by David Allsopp)

- [10044](https://github.com/ocaml/ocaml/issues/10044): Always report the detected ARCH, MODEL and SYSTEM, even for bytecode-
  only builds (fixes a "configuration regression" from 4.08 for the Windows
  builds)
  (David Allsopp, review by Xavier Leroy)

- [10071](https://github.com/ocaml/ocaml/issues/10071): Fix bug in tests/misc/weaklifetime.ml that was reported in [10055](https://github.com/ocaml/ocaml/issues/10055)
  (Damien Doligez and Gabriel Scherer, report by David Allsopp)

### Bug fixes:

- [7538](https://github.com/ocaml/ocaml/issues/7538), [9669](https://github.com/ocaml/ocaml/issues/9669): Check for misplaced attributes on module aliases
  (Leo White, report by Thomas Leonard, review by Florian Angeletti)

- [7813](https://github.com/ocaml/ocaml/issues/7813), [9955](https://github.com/ocaml/ocaml/issues/9955): make sure the major GC cycle doesn't get stuck in Idle state
  (Damien Doligez, report by Anders Fugmann, review by Jacques-Henri Jourdan)

- [7902](https://github.com/ocaml/ocaml/issues/7902), [9556](https://github.com/ocaml/ocaml/issues/9556): Type-checker infers recursive type, even though -rectypes is
  off.
  (Jacques Garrigue, report by Francois Pottier, review by Leo White)

- [8746](https://github.com/ocaml/ocaml/issues/8746): Hashtbl: Restore ongoing traversal status after filter_map_inplace
  (Mehdi Bouaziz, review by Alain Frisch)

- [8747](https://github.com/ocaml/ocaml/issues/8747), [9709](https://github.com/ocaml/ocaml/issues/9709): incorrect principality warning on functional updates of records
  (Jacques Garrigue, report and review by Thomas Refis)

* [*breaking change*] [8907](https://github.com/ocaml/ocaml/issues/8907), [9878](https://github.com/ocaml/ocaml/issues/9878): `Typemod.normalize_signature` uses wrong environment
  (Jacques Garrigue, report and review by Leo White)

- [9421](https://github.com/ocaml/ocaml/issues/9421), [9427](https://github.com/ocaml/ocaml/issues/9427): fix printing of (::) in ocamldoc
  (Florian Angeletti, report by Yawar Amin, review by Damien Doligez)

- [9440](https://github.com/ocaml/ocaml/issues/9440): for a type extension constructor with parameterised arguments,
  REPL displayed <poly> for each as opposed to the concrete values used.
  (Christian Quinn, review by Gabriel Scherer)

- [9433](https://github.com/ocaml/ocaml/issues/9433): Fix package constraints for module aliases
  (Leo White, review by Jacques Garrigue)

- [9469](https://github.com/ocaml/ocaml/issues/9469): Better backtraces for lazy values
  (Leo White, review by Nicolás Ojeda Bär)

- [9521](https://github.com/ocaml/ocaml/issues/9521), [9522](https://github.com/ocaml/ocaml/issues/9522): correctly fail when comparing functions
  with Closure and Infix tags.
  (Gabriel Scherer and Jeremy Yallop and Xavier Leroy,
   report by Twitter user @st_toHKR through Jun Furuse)

- [9611](https://github.com/ocaml/ocaml/issues/9611): maintain order of load path entries in various situations: when passing
  them to system linker, ppx contexts, etc.
  (Nicolás Ojeda Bär, review by Jérémie Dimino and Gabriel Scherer)

- [9633](https://github.com/ocaml/ocaml/issues/9633): ocamltest: fix a bug when certain variables set in test scripts would
  be ignored (eg `ocamlrunparam`).
  (Nicolás Ojeda Bär, review by Sébastien Hinderer)

- [9681](https://github.com/ocaml/ocaml/issues/9681), [9690](https://github.com/ocaml/ocaml/issues/9690), [9693](https://github.com/ocaml/ocaml/issues/9693): small runtime changes
  for the new closure representation ([9619](https://github.com/ocaml/ocaml/issues/9619))
  (Xavier Leroy, Sadiq Jaffer, Gabriel Scherer,
   review by Xavier Leroy and Jacques-Henri Jourdan)

- [9739](https://github.com/ocaml/ocaml/issues/9739), [9747](https://github.com/ocaml/ocaml/issues/9747): Avoid calling type variables, types that are not variables in
  recursive occurrence error messages
  (for instance, "Type variable int occurs inside int list")
  (Florian Angeletti, report by Stephen Dolan, review by Armaël Guéneau)

- [9759](https://github.com/ocaml/ocaml/issues/9759), [9767](https://github.com/ocaml/ocaml/issues/9767): Spurious GADT ambiguity without -principal
  (Jacques Garrigue, report by Thomas Refis,
   review by Thomas Refis and Gabriel Scherer)

- [9799](https://github.com/ocaml/ocaml/issues/9799), [9803](https://github.com/ocaml/ocaml/issues/9803): make pat_env point to the correct environment
  (Thomas Refis, report by Alex Fedoseev, review by Gabriel Scherer)

- [9825](https://github.com/ocaml/ocaml/issues/9825), [9830](https://github.com/ocaml/ocaml/issues/9830): the C global variable caml_fl_merge and the C function
  caml_spacetime_my_profinfo (bytecode version) were declared and
  defined with different types.  This is undefined behavior and
  cancause link-time errors with link-time optimization (LTO).
  (Xavier Leroy, report by Richard Jones, review by Nicolás Ojeda Bär)

- [9753](https://github.com/ocaml/ocaml/issues/9753): fix build for Android
  (Eduardo Rafael, review by Xavier Leroy)

- [9848](https://github.com/ocaml/ocaml/issues/9848), [9855](https://github.com/ocaml/ocaml/issues/9855): Fix double free of bytecode in toplevel
  (Stephen Dolan, report by Sampsa Kiiskinen, review by Gabriel Scherer)

- [9858](https://github.com/ocaml/ocaml/issues/9858), [9861](https://github.com/ocaml/ocaml/issues/9861): Compiler fails with Ctype.Nondep_cannot_erase exception
  (Thomas Refis, report by Philippe Veber, review by Florian Angeletti)

- [9860](https://github.com/ocaml/ocaml/issues/9860): wrong range constraint for subtract immediate on zSystems / s390x
  (Xavier Leroy, review by Stephen Dolan)

- [9868](https://github.com/ocaml/ocaml/issues/9868), [9872](https://github.com/ocaml/ocaml/issues/9872), [9892](https://github.com/ocaml/ocaml/issues/9892): bugs in {in,out}_channel_length and seek_in
  for files opened in text mode under Windows
  (Xavier Leroy, report by Alain Frisch, review by Nicolás Ojeda Bär
  and Alain Frisch)

- [9925](https://github.com/ocaml/ocaml/issues/9925): Correct passing -fdebug-prefix-map to flexlink on Cygwin by prefixing
  it with -link.
  (David Allsopp, review by Xavier Leroy)

- [9927](https://github.com/ocaml/ocaml/issues/9927): Restore Cygwin64 support.
  (David Allsopp, review by Xavier Leroy)

- [9940](https://github.com/ocaml/ocaml/issues/9940): Fix unboxing of allocated constants from other compilation units
  (Vincent Laviron, report by Stephen Dolan, review by Xavier Leroy and
  Stephen Dolan)

- [9991](https://github.com/ocaml/ocaml/issues/9991): Fix reproducibility for `-no-alias-deps`
  (Leo White, review by Gabriel Scherer and Florian Angeletti)

- [9998](https://github.com/ocaml/ocaml/issues/9998): Use Sys.opaque_identity in CamlinternalLazy.force
  This removes extra warning 59 messages when compiling afl-instrumented
  code with flambda -O3.
  (Vincent Laviron, report by Louis Gesbert, review by Gabriel Scherer and
   Pierre Chambart)

- [9999](https://github.com/ocaml/ocaml/issues/9999): fix -dsource printing of the pattern (`A as x | (`B as x)).
  (Gabriel Scherer, report by Anton Bachin, review by Florian Angeletti)

- [9970](https://github.com/ocaml/ocaml/issues/9970), [10010](https://github.com/ocaml/ocaml/issues/10010): fix the declaration scope of extensible-datatype constructors.
  A regression that dates back to 4.08 makes extensible-datatype constructors
  with inline records very fragile, for example:
    type 'a t += X of {x : 'a}
  (Gabriel Scherer, review by Thomas Refis and Leo White,
   report by Nicolás Ojeda Bär)

- [10048](https://github.com/ocaml/ocaml/issues/10048): Fix bug with generalized local opens.
  (Leo White, review by Thomas Refis)

- [10106](https://github.com/ocaml/ocaml/issues/10106), [10112](https://github.com/ocaml/ocaml/issues/10112): some expected-type explanations where forgotten
  after some let-bindings
  (Gabriel Scherer, review by Thomas Refis and Florian Angeletti,
   report by Daniil Baturin)
|js}
  ; body_html = {js|<h2>What's new</h2>
<p>Some of the highlights in OCaml 4.12.0 are:</p>
<ul>
<li>Major progress in reducing the difference between the mainline and
multicore runtime
</li>
<li>A new configuration option <code>ocaml-option-nnpchecker</code> which emits an alarm
when the garbage collector finds out-of-heap pointers that could cause a crash
in the multicore runtime
</li>
<li>Support for macOS/arm64
</li>
<li>Mnemonic names for warnings
</li>
<li>Many quality of life improvements
</li>
<li>Many bug fixes
</li>
</ul>
<p>For a comprehensive list of changes and details on all new features,
bug fixes, optimizations, etc., please consult the
<a href="#Changes">changelog</a>.</p>
<h2>Configuration options</h2>
<p>The configuration of the installed opam switch can be tuned with the
following options:</p>
<ul>
<li>ocaml-option-32bit: set OCaml to be compiled in 32-bit mode for 64-bit Linux and OS X hosts
</li>
<li>ocaml-option-afl: set OCaml to be compiled with afl-fuzz instrumentation
</li>
<li>ocaml-option-bytecode-only: compile OCaml without the native-code compiler
</li>
<li>ocaml-option-default-unsafe-string: set OCaml to be compiled without safe strings by default
</li>
<li>ocaml-option-flambda: set OCaml to be compiled with flambda activated
</li>
<li>ocaml-option-fp: set OCaml to be compiled with frame-pointers enabled
</li>
<li>ocaml-option-musl: set OCaml to be compiled with musl-gcc
</li>
<li>ocaml-option-nnp : set OCaml to be compiled with --disable-naked-pointers
</li>
<li>ocaml-option-nnpchecker: set OCaml to be compiled with --enable-naked-pointers-checker
</li>
<li>ocaml-option-no-flat-float-array: set OCaml to be compiled with --disable-flat-float-array
</li>
<li>ocaml-option-static :set OCaml to be compiled with musl-gcc -static
</li>
</ul>
<p>For instance, one can install a switch with both <code>flambda</code> and the naked-pointer checker enabled with</p>
<pre><code>opam switch create 4.12.0+flambda+nnpchecker --package=ocaml-variants.4.12.0+options,ocaml-option-flambda,ocaml-option-nnpchecker
</code></pre>
<h2>Source distribution</h2>
<ul>
<li><a href="https://github.com/ocaml/ocaml/archive/4.12.0.tar.gz">Source
tarball</a>
(.tar.gz) for compilation under Unix (including Linux and MacOS X)
and Microsoft Windows (including Cygwin).
</li>
<li>Also available in
<a href="https://github.com/ocaml/ocaml/archive/4.12.0.zip">.zip</a>
format.
</li>
<li><a href="https://opam.ocaml.org/">OPAM</a> is a source-based distribution of
OCaml and many companion libraries and tools. Compilation and
installation are automated by powerful package managers.
</li>
<li>The official development repo is hosted on
<a href="https://github.com/ocaml/ocaml">GitHub</a>.
</li>
</ul>
<p>The
<a href="4.12/notes/INSTALL.adoc">INSTALL</a> file
of the distribution provides detailed compilation and installation
instructions — see also the <a href="4.12/notes/README.win32.adoc">Windows release
notes</a> for
instructions on how to build under Windows.</p>
<h2>Alternative Compilers</h2>
<p>Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:</p>
<ul>
<li><a href="http://ocsigen.org/js_of_ocaml/">Js_of_ocaml</a> is a stable OCaml
to JavaScript compiler.
</li>
</ul>
<h2>User's manual</h2>
<p>The user's manual for OCaml can be:</p>
<ul>
<li><a href="4.12/htmlman/index.html">browsed
online</a>,
</li>
<li>downloaded as a single
<a href="4.12/ocaml-4.12-refman.pdf">PDF</a>,
or <a href="4.12/ocaml-4.12-refman.txt">plain
text</a>
document,
</li>
<li>downloaded as a single
<a href="4.12/ocaml-4.12-refman-html.tar.gz">TAR</a>
or
<a href="4.11/ocaml-4.12-refman-html.zip">ZIP</a>
archive of HTML files,
</li>
<li>downloaded as a single
<a href="4.12/ocaml-4.12-refman.info.tar.gz">tarball</a>
of Emacs info files,
</li>
</ul>
<h2>Changes</h2>
<p>This is the
<a href="4.12/notes/Changes">changelog</a>.
(Changes that can break existing programs are marked with a  &quot;breaking change&quot; warning)</p>
<h3>Supported platforms (highlights):</h3>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/9699">9699</a>: add support for iOS and macOS on ARM 64 bits
(Eduardo Rafael, review by Xavier Leroy, Nicolás Ojeda Bär
and Anil Madhavapeddy, additional testing by Michael Schmidt)
</li>
</ul>
<h3>Standard library (highlights):</h3>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/9797">9797</a>: Add Sys.mkdir and Sys.rmdir.
(David Allsopp, review by Nicolás Ojeda Bär, Sébastien Hinderer and
Xavier Leroy)
</li>
</ul>
<ul>
<li>
<p>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/9765">9765</a>: add init functions to Bigarray.
(Jeremy Yallop, review by Gabriel Scherer, Nicolás Ojeda Bär, and
Xavier Leroy)</p>
</li>
<li>
<p>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/9668">9668</a>: List.equal, List.compare
(This could break code using &quot;open List&quot; by shadowing
Stdlib.{equal,compare}.)
(Gabriel Scherer, review by Nicolás Ojeda Bär, Daniel Bünzli and Alain Frisch)</p>
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9066">9066</a>: a new Either module with
type 'a Either.t = Left of 'a | Right of 'b
(Gabriel Scherer, review by Daniel Bünzli, Thomas Refis, Jeremy Yallop)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9066">9066</a>: List.partition_map :
('a -&gt; ('b, 'c) Either.t) -&gt; 'a list -&gt; 'b list * 'c list
(Gabriel Scherer, review by Jeremy Yallop)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9865">9865</a>: add Format.pp_print_seq
(Raphaël Proust, review by Nicolás Ojeda Bär)</p>
</li>
</ul>
<h3>Compiler user-interface and warnings (highlights):</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9657">9657</a>: Warnings can now be referred to by their mnemonic name. The names are
displayed using <code>-warn-help</code> and can be utilized anywhere where a warning list
specification is expected.
ocamlc -w +fragile-match
...[@@ocaml.warning &quot;-fragile-match&quot;]
Note that only a single warning name at a time is supported for now:
&quot;-w +foo-bar&quot; does not work, you must use &quot;-w +foo -w -bar&quot;.
(Nicolás Ojeda Bär, review by Gabriel Scherer, Florian Angeletti and
Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8939">8939</a>: Command-line option to save Linear IR before emit.
(Greta Yorsh, review by Mark Shinwell, Sébastien Hinderer and Frédéric Bour)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9003">9003</a>: Start compilation from Emit when the input file is in Linear IR format.
(Greta Yorsh, review by Jérémie Dimino, Gabriel Scherer and Frédéric Bour)</p>
</li>
</ul>
<h3>Language features (highlights):</h3>
<ul>
<li>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/9500">9500</a>, <a href="https://github.com/ocaml/ocaml/issues/9727">9727</a>, <a href="https://github.com/ocaml/ocaml/issues/9866">9866</a>, <a href="https://github.com/ocaml/ocaml/issues/9870">9870</a>, <a href="https://github.com/ocaml/ocaml/issues/9873">9873</a>: Injectivity annotations
One can now mark type parameters as injective, which is useful for
abstract types:
module Vec : sig type !'a t end = struct type 'a t = 'a array end
On non-abstract types, this can be used to check the injectivity of
parameters. Since all parameters of record and sum types are by definition
injective, this only makes sense for type abbreviations:
type !'a t = 'a list
Note that this change required making the regularity check stricter.
(Jacques Garrigue, review by Jeremy Yallop and Leo White)
</li>
</ul>
<h3>Runtime system (highlights):</h3>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/9534">9534</a>, <a href="https://github.com/ocaml/ocaml/issues/9947">9947</a>: Introduce a naked pointers checker mode to the runtime
(configure option --enable-naked-pointers-checker).  Alarms are printed
when the garbage collector finds out-of-heap pointers that could
cause a crash in no-naked-pointers mode.
(Enguerrand Decorne, KC Sivaramakrishnan, Xavier Leroy, Stephen Dolan,
David Allsopp, Nicolás Ojeda Bär review by Xavier Leroy, Nicolás Ojeda Bär)
</li>
</ul>
<ul>
<li>
<p>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/1128">1128</a>, <a href="https://github.com/ocaml/ocaml/issues/7503">7503</a>, <a href="https://github.com/ocaml/ocaml/issues/9036">9036</a>, <a href="https://github.com/ocaml/ocaml/issues/9722">9722</a>, <a href="https://github.com/ocaml/ocaml/issues/10069">10069</a>: EINTR-based signal handling.
When a signal arrives, avoid running its OCaml handler in the middle
of a blocking section. Instead, allow control to return quickly to
a polling point where the signal handler can safely run, ensuring that
I/O locks are not held while it runs. A polling point was removed from
caml_leave_blocking_section, and one added to caml_raise.
(Stephen Dolan, review by Goswin von Brederlow, Xavier Leroy, Damien
Doligez, Anil Madhavapeddy, Guillaume Munch-Maccagnoni and Jacques-
Henri Jourdan)</p>
</li>
<li>
<p>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/5154">5154</a>, <a href="https://github.com/ocaml/ocaml/issues/9569">9569</a>, <a href="https://github.com/ocaml/ocaml/issues/9734">9734</a>: Add <code>Val_none</code>, <code>Some_val</code>, <code>Is_none</code>, <code>Is_some</code>,
<code>caml_alloc_some</code>, and <code>Tag_some</code>. As these macros are sometimes defined by
authors of C bindings, this change may cause warnings/errors in case of
redefinition.
(Nicolás Ojeda Bär, review by Stephen Dolan, Gabriel Scherer, Mark Shinwell,
and Xavier Leroy)</p>
</li>
<li>
<p>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/9674">9674</a>: Memprof: guarantee that an allocation callback is always run
in the same thread the allocation takes place
(Jacques-Henri Jourdan, review by Stephen Dolan)</p>
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/10025">10025</a>: Track custom blocks (e.g. Bigarray) with Memprof
(Stephen Dolan, review by Leo White, Gabriel Scherer and Jacques-Henri
Jourdan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9619">9619</a>: Change representation of function closures so that code pointers
can be easily distinguished from environment variables
(Xavier Leroy, review by Mark Shinwell and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9654">9654</a>: More efficient management of code fragments.
(Xavier Leroy, review by Jacques-Henri Jourdan, Damien Doligez, and
Stephen Dolan)</p>
</li>
</ul>
<h3>Other libraries (highlights):</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9573">9573</a>: reimplement Unix.create_process and related functions without
Unix.fork, for better efficiency and compatibility with threads.
(Xavier Leroy, review by Gabriel Scherer and Anil Madhavapeddy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9575">9575</a>: Add Unix.is_inet6_addr
(Nicolás Ojeda Bär, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9930">9930</a>: new module Semaphore in the thread library, implementing
counting semaphores and binary semaphores
(Xavier Leroy, review by Daniel Bünzli and Damien Doligez,
additional suggestions by Stephen Dolan and Craig Ferguson)</p>
</li>
</ul>
<ul>
<li>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/9206">9206</a>, <a href="https://github.com/ocaml/ocaml/issues/9419">9419</a>: update documentation of the threads library;
deprecate Thread.kill, Thread.wait_read, Thread.wait_write,
and the whole ThreadUnix module.
(Xavier Leroy, review by Florian Angeletti, Guillaume Munch-Maccagnoni,
and Gabriel Scherer)
</li>
</ul>
<h3>Manual and documentation (highlights):</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9755">9755</a>: Manual: post-processing the html generated by ocamldoc and
hevea. Improvements on design and navigation, including a mobile
version, and a quick-search functionality for the API.
(San Vũ Ngọc, review by David Allsopp and Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9468">9468</a>: HACKING.adoc: using dune to get merlin support
(Thomas Refis, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9684">9684</a>: document in address_class.h the runtime value model in
naked-pointers and no-naked-pointers mode
(Xavier Leroy and Gabriel Scherer)</p>
</li>
</ul>
<h3>Internal/compiler-libs changes (highlights):</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9464">9464</a>, <a href="https://github.com/ocaml/ocaml/issues/9493">9493</a>, <a href="https://github.com/ocaml/ocaml/issues/9520">9520</a>, <a href="https://github.com/ocaml/ocaml/issues/9563">9563</a>, <a href="https://github.com/ocaml/ocaml/issues/9599">9599</a>, <a href="https://github.com/ocaml/ocaml/issues/9608">9608</a>, <a href="https://github.com/ocaml/ocaml/issues/9647">9647</a>: refactor
the pattern-matching compiler
(Thomas Refis and Gabriel Scherer, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9696">9696</a>: ocamltest now shows its log when a test fails. In addition, the log
contains the output of executed programs.
(Nicolás Ojeda Bär, review by David Allsopp, Sébastien Hinderer and Gabriel
Scherer)</p>
</li>
</ul>
<h3>Build system (highlights):</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9824">9824</a>, <a href="https://github.com/ocaml/ocaml/issues/9837">9837</a>: Honour the CFLAGS and CPPFLAGS variables.
(Sébastien Hinderer, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/10063">10063</a>: (Re-)enable building on illumos (SmartOS, OmniOS, ...) and
Oracle Solaris; x86_64/GCC and 64-bit SPARC/Sun PRO C compilers.
(partially revert <a href="https://github.com/ocaml/ocaml/issues/2024">2024</a>).
(Tõivo Leedjärv and Konstantin Romanov,
review by Gabriel Scherer, Sébastien Hinderer and Xavier Leroy)</p>
</li>
</ul>
<h3>Language features:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/1655">1655</a>: pattern aliases do not ignore type constraints
(Thomas Refis, review by Jacques Garrigue and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9429">9429</a>: Add unary operators containing <code>#</code> to the parser for use in ppx
rewriters
(Leo White, review by Damien Doligez)</p>
</li>
</ul>
<h3>Runtime system:</h3>
<ul>
<li>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/9697">9697</a>: Remove the Is_in_code_area macro and the registration of DLL code
areas in the page table, subsumed by the new code fragment management API
(Xavier Leroy, review by Jacques-Henri Jourdan)
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/9756">9756</a>: garbage collector colors change
removes the gray color from the major gc
(Sadiq Jaffer and Stephen Dolan reviewed by Xavier Leroy,
KC Sivaramakrishnan, Damien Doligez and Jacques-Henri Jourdan)
</li>
</ul>
<ul>
<li>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/9513">9513</a>: Selectively initialise blocks in <code>Obj.new_block</code>. Reject <code>Custom_tag</code>
objects and zero-length <code>String_tag</code> objects.
(KC Sivaramakrishnan, review by David Allsopp, Xavier Leroy, Mark Shinwell
and Leo White)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9564">9564</a>: Add a macro to construct out-of-heap block header.
(KC Sivaramakrishnan, review by Stephen Dolan, Gabriel Scherer,
and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9951">9951</a>: Ensure that the mark stack push optimisation handles naked pointers
(KC Sivaramakrishnan, reported by Enguerrand Decorne, review by Gabriel
Scherer, and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9678">9678</a>: Reimplement <code>Obj.reachable_words</code> using a hash table to
detect sharing, instead of temporary in-place modifications.  This
is a prerequisite for Multicore OCaml.
(Xavier Leroy, review by Jacques-Henri Jourdan and Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/1795">1795</a>, <a href="https://github.com/ocaml/ocaml/issues/9543">9543</a>: modernize signal handling on Linux i386, PowerPC, and s390x,
adding support for Musl ppc64le along the way.
(Xavier Leroy and Anil Madhavapeddy, review by Stephen Dolan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9648">9648</a>, <a href="https://github.com/ocaml/ocaml/issues/9689">9689</a>: Update the generic hash function to take advantage
of the new representation for function closures
(Xavier Leroy, review by Stephen Dolan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9649">9649</a>: Update the marshaler (output_value) to take advantage
of the new representation for function closures
(Xavier Leroy, review by Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/10050">10050</a>: update {PUSH,}OFFSETCLOSURE* bytecode instructions to match new
representation for closures
(Nathanaël Courant, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9728">9728</a>: Take advantage of the new closure representation to simplify the
compaction algorithm and remove its dependence on the page table
(Damien Doligez, review by Jacques-Henri Jourdan and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2195">2195</a>: Improve error message in bytecode stack trace printing and load
debug information during bytecode startup if OCAMLRUNPARAM=b=2.
(David Allsopp, review by Gabriel Scherer and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9466">9466</a>: Memprof: optimize random samples generation.
(Jacques-Henri Jourdan, review by Xavier Leroy and Stephen Dolan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9628">9628</a>: Memprof: disable sampling when memprof is suspended.
(Jacques-Henri Jourdan, review by Gabriel Scherer and Stephen Dolan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/10056">10056</a>: Memprof: ensure young_trigger is within the bounds of the minor
heap in caml_memprof_renew_minor_sample (regression from <a href="https://github.com/ocaml/ocaml/issues/8684">8684</a>)
(David Allsopp, review by Guillaume Munch-Maccagnoni and
Jacques-Henri Jourdan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9508">9508</a>: Remove support for FreeBSD prior to 4.0R, that required explicit
floating-point initialization to behave like IEEE standard
(Hannes Mehnert, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8807">8807</a>, <a href="https://github.com/ocaml/ocaml/issues/9503">9503</a>: Use different symbols for do_local_roots on bytecode and native
(Stephen Dolan, review by David Allsopp and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9670">9670</a>: Report full major collections in Gc stats.
(Leo White, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9675">9675</a>: Remove the caml_static_{alloc,free,resize} primitives, now unused.
(Xavier Leroy, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9710">9710</a>: Drop &quot;support&quot; for an hypothetical JIT for OCaml bytecode
which has never existed.
(Jacques-Henri Jourdan, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9742">9742</a>, <a href="https://github.com/ocaml/ocaml/issues/9989">9989</a>: Ephemerons are now compatible with infix pointers occurring
when using mutually recursive functions.
(Jacques-Henri Jourdan, review by François Bobot)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9888">9888</a>, <a href="https://github.com/ocaml/ocaml/issues/9890">9890</a>: Fixes a bug in the <code>riscv</code> backend where register t0 was not
saved/restored when performing a GC. This could potentially lead to a
segfault.
(Nicolás Ojeda Bär, report by Xavier Leroy, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9907">9907</a>: Fix native toplevel on native Windows.
(David Allsopp, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9909">9909</a>: Remove caml_code_area_start and caml_code_area_end globals (no longer
needed as the pagetable heads towards retirement).
(David Allsopp, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9949">9949</a>: Clarify documentation of GC message 0x1 and make sure it is
displayed every time a major cycle is forcibly finished.
(Damien Doligez, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/10062">10062</a>: set ARCH_INT64_PRINTF_FORMAT correctly for both modes of mingw-w64
(David Allsopp, review by Xavier Leroy)</p>
</li>
</ul>
<h3>Code generation and optimizations:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9551">9551</a>: ocamlc no longer loads DLLs at link time to check that
external functions referenced from OCaml code are defined.
Instead, .so/.dll files are parsed directly by pure OCaml code.
(Nicolás Ojeda Bär, review by Daniel Bünzli, Gabriel Scherer,
Anil Madhavapeddy, and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9620">9620</a>: Limit the number of parameters for an uncurried or untupled
function.  Functions with more parameters than that are left
partially curried or tupled.
(Xavier Leroy, review by Mark Shinwell)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9752">9752</a>: Revised handling of calling conventions for external C functions.
Provide a more precise description of the types of unboxed arguments,
so that the ARM64 iOS/macOS calling conventions can be honored.
(Xavier Leroy, review by Mark Shinwell and Eduardo Rafael)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9838">9838</a>: Ensure that Cmm immediates are generated as Cconst_int where
possible, improving instruction selection.
(Stephen Dolan, review by Leo White and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9864">9864</a>: Revised recognition of immediate arguments to integer operations.
Fixes several issues that could have led to producing assembly code
that is rejected by the assembler.
(Xavier Leroy, review by Stephen Dolan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9969">9969</a>, <a href="https://github.com/ocaml/ocaml/issues/9981">9981</a>: Added mergeable flag to ELF sections containing mergeable
constants.  Fixes compatibility with the integrated assembler in clang 11.0.0.
(Jacob Young, review by Nicolás Ojeda Bär)</p>
</li>
</ul>
<h3>Standard library:</h3>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/9781">9781</a>: add injectivity annotations to parameterized abstract types
(Jeremy Yallop, review by Nicolás Ojeda Bär)
</li>
</ul>
<ul>
<li>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/9554">9554</a>: add primitive <strong>FUNCTION</strong> that returns the name of the current method
or function, including any enclosing module or class.
(Nicolás Ojeda Bär, Stephen Dolan, review by Stephen Dolan)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9075">9075</a>: define to_rev_seq in Set and Map modules.
(Sébastien Briais, review by Gabriel Scherer and Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9561">9561</a>: Unbox Unix.gettimeofday and Unix.time
(Stephen Dolan, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9570">9570</a>: Provide an Atomic module with a trivial purely-sequential
implementation, to help write code that is compatible with Multicore
OCaml.
(Gabriel Scherer, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/10035">10035</a>: Make sure that flambda respects atomicity in the Atomic module.
(Guillaume Munch-Maccagnoni, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9571">9571</a>: Make at_exit and Printexc.register_printer thread-safe.
(Guillaume Munch-Maccagnoni, review by Gabriel Scherer and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9587">9587</a>: Arg: new Rest_all spec to get all rest arguments in a list
(this is similar to Rest, but makes it possible to detect when there
are no arguments (an empty list) after the rest marker)
(Gabriel Scherer, review by Nicolás Ojeda Bär and David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9655">9655</a>: Obj: introduce type raw_data and functions raw_field, set_raw_field
to manipulate out-of-heap pointers in no-naked-pointer mode,
and more generally all other data that is not a well-formed OCaml value
(Xavier Leroy, review by Damien Doligez and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9663">9663</a>: Extend Printexc API for raw backtrace entries.
(Stephen Dolan, review by Nicolás Ojeda Bär and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9763">9763</a>: Add function Hashtbl.rebuild to convert from old hash table
formats (that may have been saved to persistent storage) to the
current hash table format.  Remove leftover support for the hash
table format and generic hash function that were in use before OCaml 4.00.
(Xavier Leroy, review by Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/10070">10070</a>: Fix Float.Array.blit when source and destination arrays coincide.
(Nicolás Ojeda Bär, review by Alain Frisch and Xavier Leroy)</p>
</li>
</ul>
<h3>Other libraries:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8796">8796</a>: On Windows, make Unix.utimes use FILE_FLAG_BACKUP_SEMANTICS flag
to allow it to work with directories.
(Daniil Baturin, review by Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9593">9593</a>: Use new flag for non-elevated symbolic links and test for Developer
Mode on Windows
(Manuel Hornung, review by David Allsopp and Nicolás Ojeda Bär)</p>
</li>
</ul>
<ul>
<li>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/9601">9601</a>: Return EPERM for EUNKNOWN -1314 in win32unix (principally affects
error handling when Unix.symlink is unavailable)
(David Allsopp, review by Xavier Leroy)
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/9338">9338</a>, <a href="https://github.com/ocaml/ocaml/issues/9790">9790</a>: Dynlink: make sure *_units () functions report accurate
information before the first load.
(Daniel Bünzli, review by Xavier Leroy and Nicolás Ojeda Bär)
</li>
</ul>
<ul>
<li>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/9757">9757</a>, <a href="https://github.com/ocaml/ocaml/issues/9846">9846</a>, <a href="https://github.com/ocaml/ocaml/issues/10161">10161</a>: check proper ownership when operating over mutexes.
Now, unlocking a mutex held by another thread or not locked at all
reliably raises a Sys_error exception.  Before, it was undefined
behavior, but the documentation did not say so.
Likewise, locking a mutex already locked by the current thread
reliably raises a Sys_error exception.  Before, it could
deadlock or succeed (and do recursive locking), depending on the OS.
(Xavier Leroy, report by Guillaume Munch-Maccagnoni, review by
Guillaume Munch-Maccagnoni, David Allsopp, and Stephen Dolan)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9802">9802</a>: Ensure signals are handled before Unix.kill returns
(Stephen Dolan, review by Jacques-Henri Jourdan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9869">9869</a>, <a href="https://github.com/ocaml/ocaml/issues/10073">10073</a>: Add Unix.SO_REUSEPORT
(Yishuai Li, review by Xavier Leroy, amended by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9906">9906</a>, <a href="https://github.com/ocaml/ocaml/issues/9914">9914</a>: Add Unix._exit as a way to exit the process immediately,
skipping any finalization action
(Ivan Gotovchits and Xavier Leroy, review by Sébastien Hinderer and
David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9958">9958</a>: Raise exception in case of error in Unix.setsid.
(Nicolás Ojeda Bär, review by Stephen Dolan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9971">9971</a>, <a href="https://github.com/ocaml/ocaml/issues/9973">9973</a>: Make sure the process can terminate when the last thread
calls Thread.exit.
(Xavier Leroy, report by Jacques-Henri Jourdan, review by David Allsopp
and Jacques-Henri Jourdan).</p>
</li>
</ul>
<h3>Tools:</h3>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/9551">9551</a>: ocamlobjinfo is now able to display information on .cmxs shared
libraries natively; it no longer requires libbfd to do so
(Nicolás Ojeda Bär, review by Daniel Bünzli, Gabriel Scherer,
Anil Madhavapeddy, and Xavier Leroy)
</li>
</ul>
<ul>
<li>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/9299">9299</a>, <a href="https://github.com/ocaml/ocaml/issues/9795">9795</a>: ocamldep: do not process files during cli parsing. Fixes
various broken cli behaviours.
(Daniel Bünzli, review by Nicolás Ojeda Bär)
</li>
</ul>
<h3>Debugging and profiling:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9606">9606</a>, <a href="https://github.com/ocaml/ocaml/issues/9635">9635</a>, <a href="https://github.com/ocaml/ocaml/issues/9637">9637</a>: fix 4.10 performance regression in the debugger
(behaviors quadratic in the size of the debugged program)
(Xavier Leroy, report by Jacques Garrigue and Virgile Prevosto,
review by David Allsopp and Jacques-Henri Jourdan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9948">9948</a>: Remove Spacetime.
(Nicolás Ojeda Bär, review by Stephen Dolan and Xavier Leroy)</p>
</li>
</ul>
<h3>Manual and documentation:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/10142">10142</a>, <a href="https://github.com/ocaml/ocaml/issues/10154">10154</a>: improved rendering and latex code for toplevel code examples.
(Florian Angeletti, report by John Whitington, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9745">9745</a>: Manual: Standard Library labeled and unlabeled documentation unified
(John Whitington, review by Nicolás Ojeda Bär, David Allsopp,
Thomas Refis, and Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9877">9877</a>: manual, warn that multi-index indexing operators should be defined in
conjunction of single-index ones.
(Florian Angeletti, review by Hezekiah M. Carty, Gabriel Scherer,
and Marcello Seri)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/10233">10233</a>: Document <code>-save-ir-after scheduling</code> and update <code>-stop-after</code> options.
(Greta Yorsh, review by Gabriel Scherer and Florian Angeletti)</p>
</li>
</ul>
<h3>Compiler user-interface and warnings:</h3>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/1931">1931</a>: rely on levels to enforce principality in patterns
(Thomas Refis and Leo White, review by Jacques Garrigue)
</li>
</ul>
<ul>
<li>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/9011">9011</a>: Do not create .a/.lib files when creating a .cmxa with no modules.
macOS ar doesn't support creating empty .a files (<a href="https://github.com/ocaml/ocaml/issues/1094">1094</a>) and MSVC doesn't
permit .lib files to contain no objects. When linking with a .cmxa containing
no modules, it is now not an error for there to be no .a/.lib file.
(David Allsopp, review by Xavier Leroy)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9560">9560</a>: Report partial application warnings on type errors in applications.
(Stephen Dolan, report and testcase by whitequark, review by Gabriel Scherer
and Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9583">9583</a>: when bytecode linking fails due to an unavailable module, the module
that requires it is now included in the error message.
(Nicolás Ojeda Bär, review by Vincent Laviron)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9615">9615</a>: Attach package type attributes to core_type.
When parsing constraints on a first class module, attributes found after the
module type were parsed but ignored. Now they are attached to the
corresponding core_type.
(Etienne Millon, review by Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/6633">6633</a>, <a href="https://github.com/ocaml/ocaml/issues/9673">9673</a>: Add hint when a module is used instead of a module type or
when a module type is used instead of a module or when a class type is used
instead of a class.
(Xavier Van de Woestyne, report by whitequark, review by Florian Angeletti
and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9754">9754</a>: allow [@tailcall true] (equivalent to [@tailcall]) and
[@tailcall false] (warns if on a tailcall)
(Gabriel Scherer, review by Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9751">9751</a>: Add warning 68. Pattern-matching depending on mutable state
prevents the remaining arguments from being uncurried.
(Hugo Heuzard, review by Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9783">9783</a>: Widen warning 16 (Unerasable optional argument) to more cases.
(Leo White, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/10008">10008</a>: Improve error message for aliases to the current compilation unit.
(Leo White, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/10046">10046</a>: Link all DLLs with -static-libgcc on mingw32 to prevent dependency
on libgcc_s_sjlj-1.dll with mingw-w64 runtime 8.0.0 (previously this was
only needed for dllunix.dll).
(David Allsopp, report by Andreas Hauptmann, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9634">9634</a>: Allow initial and repeated commas in <code>OCAMLRUNPARAM</code>.
(Nicolás Ojeda Bär, review by Gabriel Scherer)</p>
</li>
</ul>
<h3>Internal/compiler-libs changes:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8987">8987</a>: Make some locations more accurate
(Thomas Refis, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9216">9216</a>: add Lambda.duplicate which refreshes bound identifiers
(Gabriel Scherer, review by Pierre Chambart and Vincent Laviron)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9376">9376</a>: Remove spurious Ptop_defs from #use
(Leo White, review by Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9604">9604</a>: refactoring of the ocamltest codebase.
(Nicolás Ojeda Bär, review by Gabriel Scherer and Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9498">9498</a>, <a href="https://github.com/ocaml/ocaml/issues/9511">9511</a>: make the pattern-matching analyzer more robust to
or-pattern explosion, by stopping after the first counter-example to
exhaustivity
(Gabriel Scherer, review by Luc Maranget, Thomas Refis and Florian Angeletti,
report by Alex Fedoseev through Hongbo Zhang)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9514">9514</a>: optimize pattern-matching exhaustivity analysis in the single-row case
(Gabriel Scherer, review by Stephen DOlan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9442">9442</a>: refactor the implementation of the [@tailcall] attribute
to allow for a structured attribute payload
(Gabriel Scherer, review by Vladimir Keleshev and Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9688">9688</a>: Expose the main entrypoint in compilerlibs
(Stephen Dolan, review by Nicolás Ojeda Bär, Greta Yorsh and David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9715">9715</a>: recheck scope escapes after normalising paths
(Matthew Ryan, review by Gabriel Scherer and Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9778">9778</a>: Fix printing for bindings where polymorphic type annotations and
attributes are present.
(Matthew Ryan, review by Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9797">9797</a>, <a href="https://github.com/ocaml/ocaml/issues/9849">9849</a>: Eliminate the routine use of external commands in ocamltest.
ocamltest no longer calls the mkdir, rm and ln external commands (at present,
the only external command ocamltest uses is diff).
(David Allsopp, review by Nicolás Ojeda Bär, Sébastien Hinderer and
Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9801">9801</a>: Don't ignore EOL-at-EOF differences in ocamltest.
(David Allsopp, review by Damien Doligez, much input and thought from
Daniel Bünzli, Damien Doligez, Sébastien Hinderer, and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9889">9889</a>: more caching when printing types with -short-path.
(Florian Angeletti, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9591">9591</a>: fix pprint of polyvariants that start with a core_type, closed,
not low (Chet Murthy, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9590">9590</a>: fix pprint of extension constructors (and exceptions) that rebind
(Chet Murthy, review by octachron@)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9963">9963</a>: Centralized tracking of frontend's global state
(Frédéric Bour and Thomas Refis, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9631">9631</a>: Named text sections for caml_system__code_begin/end symbols
(Greta Yorsh, review by Frédéric Bour)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9896">9896</a>: Share the strings representing scopes, fixing some regression
on .cmo/.cma sizes
(Alain Frisch and Xavier Clerc, review by Gabriel Scherer)</p>
</li>
</ul>
<h3>Build system:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9332">9332</a>, <a href="https://github.com/ocaml/ocaml/issues/9518">9518</a>, <a href="https://github.com/ocaml/ocaml/issues/9529">9529</a>: Cease storing C dependencies in the codebase. C
dependencies are generated on-the-fly in development mode. For incremental
compilation, the MSVC ports require GCC to be present.
(David Allsopp, review by Sébastien Hinderer, YAML-fu by Stephen Dolan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7121">7121</a>, <a href="https://github.com/ocaml/ocaml/issues/9558">9558</a>: Always have the autoconf-discovered ld in PACKLD, with
extra flags in new variable PACKLD_FLAGS. For
cross-compilation, this means the triplet-prefixed version will always be
used.
(David Allsopp, report by Adrian Nader, review by Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9527">9527</a>: stop including configuration when running 'clean' rules
to avoid C dependency recomputation.
(Gabriel Scherer, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9804">9804</a>: Build C stubs of libraries in otherlibs/ with debug info.
(Stephen Dolan, review by Sébastien Hinderer and David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9938">9938</a>, <a href="https://github.com/ocaml/ocaml/issues/9939">9939</a>: Define __USE_MINGW_ANSI_STDIO=0 for the mingw-w64 ports to
prevent their C99-compliant snprintf conflicting with ours.
(David Allsopp, report by Michael Soegtrop, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9895">9895</a>, <a href="https://github.com/ocaml/ocaml/issues/9523">9523</a>: Avoid conflict with C++20 by not installing VERSION to the OCaml
Standard Library directory.
(Bernhard Schommer, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/10044">10044</a>: Always report the detected ARCH, MODEL and SYSTEM, even for bytecode-
only builds (fixes a &quot;configuration regression&quot; from 4.08 for the Windows
builds)
(David Allsopp, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/10071">10071</a>: Fix bug in tests/misc/weaklifetime.ml that was reported in <a href="https://github.com/ocaml/ocaml/issues/10055">10055</a>
(Damien Doligez and Gabriel Scherer, report by David Allsopp)</p>
</li>
</ul>
<h3>Bug fixes:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7538">7538</a>, <a href="https://github.com/ocaml/ocaml/issues/9669">9669</a>: Check for misplaced attributes on module aliases
(Leo White, report by Thomas Leonard, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7813">7813</a>, <a href="https://github.com/ocaml/ocaml/issues/9955">9955</a>: make sure the major GC cycle doesn't get stuck in Idle state
(Damien Doligez, report by Anders Fugmann, review by Jacques-Henri Jourdan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7902">7902</a>, <a href="https://github.com/ocaml/ocaml/issues/9556">9556</a>: Type-checker infers recursive type, even though -rectypes is
off.
(Jacques Garrigue, report by Francois Pottier, review by Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8746">8746</a>: Hashtbl: Restore ongoing traversal status after filter_map_inplace
(Mehdi Bouaziz, review by Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8747">8747</a>, <a href="https://github.com/ocaml/ocaml/issues/9709">9709</a>: incorrect principality warning on functional updates of records
(Jacques Garrigue, report and review by Thomas Refis)</p>
</li>
</ul>
<ul>
<li>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/8907">8907</a>, <a href="https://github.com/ocaml/ocaml/issues/9878">9878</a>: <code>Typemod.normalize_signature</code> uses wrong environment
(Jacques Garrigue, report and review by Leo White)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9421">9421</a>, <a href="https://github.com/ocaml/ocaml/issues/9427">9427</a>: fix printing of (::) in ocamldoc
(Florian Angeletti, report by Yawar Amin, review by Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9440">9440</a>: for a type extension constructor with parameterised arguments,
REPL displayed <poly> for each as opposed to the concrete values used.
(Christian Quinn, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9433">9433</a>: Fix package constraints for module aliases
(Leo White, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9469">9469</a>: Better backtraces for lazy values
(Leo White, review by Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9521">9521</a>, <a href="https://github.com/ocaml/ocaml/issues/9522">9522</a>: correctly fail when comparing functions
with Closure and Infix tags.
(Gabriel Scherer and Jeremy Yallop and Xavier Leroy,
report by Twitter user @st_toHKR through Jun Furuse)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9611">9611</a>: maintain order of load path entries in various situations: when passing
them to system linker, ppx contexts, etc.
(Nicolás Ojeda Bär, review by Jérémie Dimino and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9633">9633</a>: ocamltest: fix a bug when certain variables set in test scripts would
be ignored (eg <code>ocamlrunparam</code>).
(Nicolás Ojeda Bär, review by Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9681">9681</a>, <a href="https://github.com/ocaml/ocaml/issues/9690">9690</a>, <a href="https://github.com/ocaml/ocaml/issues/9693">9693</a>: small runtime changes
for the new closure representation (<a href="https://github.com/ocaml/ocaml/issues/9619">9619</a>)
(Xavier Leroy, Sadiq Jaffer, Gabriel Scherer,
review by Xavier Leroy and Jacques-Henri Jourdan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9739">9739</a>, <a href="https://github.com/ocaml/ocaml/issues/9747">9747</a>: Avoid calling type variables, types that are not variables in
recursive occurrence error messages
(for instance, &quot;Type variable int occurs inside int list&quot;)
(Florian Angeletti, report by Stephen Dolan, review by Armaël Guéneau)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9759">9759</a>, <a href="https://github.com/ocaml/ocaml/issues/9767">9767</a>: Spurious GADT ambiguity without -principal
(Jacques Garrigue, report by Thomas Refis,
review by Thomas Refis and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9799">9799</a>, <a href="https://github.com/ocaml/ocaml/issues/9803">9803</a>: make pat_env point to the correct environment
(Thomas Refis, report by Alex Fedoseev, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9825">9825</a>, <a href="https://github.com/ocaml/ocaml/issues/9830">9830</a>: the C global variable caml_fl_merge and the C function
caml_spacetime_my_profinfo (bytecode version) were declared and
defined with different types.  This is undefined behavior and
cancause link-time errors with link-time optimization (LTO).
(Xavier Leroy, report by Richard Jones, review by Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9753">9753</a>: fix build for Android
(Eduardo Rafael, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9848">9848</a>, <a href="https://github.com/ocaml/ocaml/issues/9855">9855</a>: Fix double free of bytecode in toplevel
(Stephen Dolan, report by Sampsa Kiiskinen, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9858">9858</a>, <a href="https://github.com/ocaml/ocaml/issues/9861">9861</a>: Compiler fails with Ctype.Nondep_cannot_erase exception
(Thomas Refis, report by Philippe Veber, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9860">9860</a>: wrong range constraint for subtract immediate on zSystems / s390x
(Xavier Leroy, review by Stephen Dolan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9868">9868</a>, <a href="https://github.com/ocaml/ocaml/issues/9872">9872</a>, <a href="https://github.com/ocaml/ocaml/issues/9892">9892</a>: bugs in {in,out}_channel_length and seek_in
for files opened in text mode under Windows
(Xavier Leroy, report by Alain Frisch, review by Nicolás Ojeda Bär
and Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9925">9925</a>: Correct passing -fdebug-prefix-map to flexlink on Cygwin by prefixing
it with -link.
(David Allsopp, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9927">9927</a>: Restore Cygwin64 support.
(David Allsopp, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9940">9940</a>: Fix unboxing of allocated constants from other compilation units
(Vincent Laviron, report by Stephen Dolan, review by Xavier Leroy and
Stephen Dolan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9991">9991</a>: Fix reproducibility for <code>-no-alias-deps</code>
(Leo White, review by Gabriel Scherer and Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9998">9998</a>: Use Sys.opaque_identity in CamlinternalLazy.force
This removes extra warning 59 messages when compiling afl-instrumented
code with flambda -O3.
(Vincent Laviron, report by Louis Gesbert, review by Gabriel Scherer and
Pierre Chambart)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9999">9999</a>: fix -dsource printing of the pattern (<code>A as x | (</code>B as x)).
(Gabriel Scherer, report by Anton Bachin, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9970">9970</a>, <a href="https://github.com/ocaml/ocaml/issues/10010">10010</a>: fix the declaration scope of extensible-datatype constructors.
A regression that dates back to 4.08 makes extensible-datatype constructors
with inline records very fragile, for example:
type 'a t += X of {x : 'a}
(Gabriel Scherer, review by Thomas Refis and Leo White,
report by Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/10048">10048</a>: Fix bug with generalized local opens.
(Leo White, review by Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/10106">10106</a>, <a href="https://github.com/ocaml/ocaml/issues/10112">10112</a>: some expected-type explanations where forgotten
after some let-bindings
(Gabriel Scherer, review by Thomas Refis and Florian Angeletti,
report by Daniil Baturin)</p>
</li>
</ul>
|js}
  };
 
  { kind = `Compiler
  ; version = {js|4.11.2|js}
  ; date = {js|2021-02-24|js}
  ; intro_md = {js|This page describes OCaml **4.11.2**, released on Feb 24, 2021. This is a bug-fix release of [OCaml 4.11.0](/releases/4.11.0).

This release is available as an [opam](/p/ocaml/4.11.2) package.
|js}
  ; intro_html = {js|<p>This page describes OCaml <strong>4.11.2</strong>, released on Feb 24, 2021. This is a bug-fix release of <a href="/releases/4.11.0">OCaml 4.11.0</a>.</p>
<p>This release is available as an <a href="/p/ocaml/4.11.2">opam</a> package.</p>
|js}
  ; highlights_md = {js|- Bug fixes for 4.11.1
|js}
  ; highlights_html = {js|<ul>
<li>Bug fixes for 4.11.1
</li>
</ul>
|js}
  ; body_md = {js|
Opam switches
-------------

This release is available as multiple
[opam](https://opam.ocaml.org/doc/Usage.html) switches:

- 4.11.2 — Official release 4.11.2
- 4.11.2+flambda — Official release 4.11.2, with flambda activated

- 4.11.2+afl — Official release 4.11.2, with afl-fuzz instrumentation
- 4.11.2+no-flat-float-array - Official release 4.11.2, with
  --disable-flat-float-array
- 4.11.2+flambda+no-flat-float-array — Official release 4.11.2, with
  flambda activated and --disable-flat-float-array
- 4.11.2+fp — Official release 4.11.2, with frame-pointers
- 4.11.2+fp+flambda — Official release 4.11.2, with frame-pointers
  and flambda activated
- 4.11.2+musl+static+flambda - Official release 4.11.2, compiled with
  musl-gcc -static and with flambda activated

- 4.11.2+32bit - Official release 4.11.2, compiled in 32-bit mode
  for 64-bit Linux and OS X hosts
- 4.11.2+bytecode-only - Official release 4.11.2, without the
  native-code compiler

- 4.11.2+spacetime - Official 4.11.2 release with spacetime activated
- 4.11.2+default-unsafe-string — Official release 4.11.2, without
  safe strings by default



Source distribution
---------------------------------------------

- [Source
  tarball](https://github.com/ocaml/ocaml/archive/4.11.2.tar.gz)
  (.tar.gz) for compilation under Unix (including Linux and macOS)
  and Microsoft Windows (including Cygwin).
- Also available in
  [.zip](https://github.com/ocaml/ocaml/archive/4.11.2.zip)
  format.
- The official development repo is hosted on
  [GitHub](https://github.com/ocaml/ocaml).

Changes
-------

### Build system:

- [9938](https://github.com/ocaml/ocaml/issues/9938), [9939](https://github.com/ocaml/ocaml/issues/9939): Define __USE_MINGW_ANSI_STDIO=0 for the mingw-w64 ports to
  prevent their C99-compliant snprintf conflicting with ours.
  (David Allsopp, report by Michael Soegtrop, review by Xavier Leroy)

### Runtime system:

- [10056](https://github.com/ocaml/ocaml/issues/10056): Memprof: ensure young_trigger is within the bounds of the minor
  heap in caml_memprof_renew_minor_sample (regression from [8684](https://github.com/ocaml/ocaml/issues/8684))
  (David Allsopp, review by Guillaume Munch-Maccagnoni and
  Jacques-Henri Jourdan)

- [9654](https://github.com/ocaml/ocaml/issues/9654): More efficient management of code fragments.
  (Xavier Leroy, review by Jacques-Henri Jourdan, Damien Doligez, and
  Stephen Dolan)

### Tools:

- [9606](https://github.com/ocaml/ocaml/issues/9606), [9635](https://github.com/ocaml/ocaml/issues/9635), [9637](https://github.com/ocaml/ocaml/issues/9637): fix performance regression in the debugger
  (behaviors quadratic in the size of the debugged program)
  (Xavier Leroy, report by Jacques Garrigue and Virgile Prevosto,
  review by David Allsopp and Jacques-Henri Jourdan)

### Code generation and optimizations:

- [9969](https://github.com/ocaml/ocaml/issues/9969), [9981](https://github.com/ocaml/ocaml/issues/9981): Added mergeable flag to ELF sections containing mergeable
  constants.  Fixes compatibility with the integrated assembler in clang 11.0.0.
  (Jacob Young, review by Nicolás Ojeda Bär)

### Bug fixes:

- [9970](https://github.com/ocaml/ocaml/issues/9970), [10010](https://github.com/ocaml/ocaml/issues/10010): fix the declaration scope of extensible-datatype constructors.
  A regression that dates back to 4.08 makes extensible-datatype constructors
  with inline records very fragile, for example:
    type 'a t += X of {x : 'a}
  (Gabriel Scherer, review by Thomas Refis and Leo White,
   report by Nicolás Ojeda Bär)

- [9096](https://github.com/ocaml/ocaml/issues/9096), [10096](https://github.com/ocaml/ocaml/issues/10096): fix a 4.11.0 performance regression in classes/objects
  declared within a function
  (Gabriel Scherer, review by Leo White, report by Sacha Ayoun)

- [9326](https://github.com/ocaml/ocaml/issues/9326), [10125](https://github.com/ocaml/ocaml/issues/10125): Gc.set incorrectly handles the three `custom_*` fields,
  causing a performance regression
  (report by Emilio Jesús Gallego Arias, analysis and fix by Stephen Dolan,
   code by Xavier Leroy, review by Hugo Heuzard and Gabriel Scherer)
|js}
  ; body_html = {js|<h2>Opam switches</h2>
<p>This release is available as multiple
<a href="https://opam.ocaml.org/doc/Usage.html">opam</a> switches:</p>
<ul>
<li>
<p>4.11.2 — Official release 4.11.2</p>
</li>
<li>
<p>4.11.2+flambda — Official release 4.11.2, with flambda activated</p>
</li>
<li>
<p>4.11.2+afl — Official release 4.11.2, with afl-fuzz instrumentation</p>
</li>
<li>
<p>4.11.2+no-flat-float-array - Official release 4.11.2, with
--disable-flat-float-array</p>
</li>
<li>
<p>4.11.2+flambda+no-flat-float-array — Official release 4.11.2, with
flambda activated and --disable-flat-float-array</p>
</li>
<li>
<p>4.11.2+fp — Official release 4.11.2, with frame-pointers</p>
</li>
<li>
<p>4.11.2+fp+flambda — Official release 4.11.2, with frame-pointers
and flambda activated</p>
</li>
<li>
<p>4.11.2+musl+static+flambda - Official release 4.11.2, compiled with
musl-gcc -static and with flambda activated</p>
</li>
<li>
<p>4.11.2+32bit - Official release 4.11.2, compiled in 32-bit mode
for 64-bit Linux and OS X hosts</p>
</li>
<li>
<p>4.11.2+bytecode-only - Official release 4.11.2, without the
native-code compiler</p>
</li>
<li>
<p>4.11.2+spacetime - Official 4.11.2 release with spacetime activated</p>
</li>
<li>
<p>4.11.2+default-unsafe-string — Official release 4.11.2, without
safe strings by default</p>
</li>
</ul>
<h2>Source distribution</h2>
<ul>
<li><a href="https://github.com/ocaml/ocaml/archive/4.11.2.tar.gz">Source
tarball</a>
(.tar.gz) for compilation under Unix (including Linux and macOS)
and Microsoft Windows (including Cygwin).
</li>
<li>Also available in
<a href="https://github.com/ocaml/ocaml/archive/4.11.2.zip">.zip</a>
format.
</li>
<li>The official development repo is hosted on
<a href="https://github.com/ocaml/ocaml">GitHub</a>.
</li>
</ul>
<h2>Changes</h2>
<h3>Build system:</h3>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/9938">9938</a>, <a href="https://github.com/ocaml/ocaml/issues/9939">9939</a>: Define __USE_MINGW_ANSI_STDIO=0 for the mingw-w64 ports to
prevent their C99-compliant snprintf conflicting with ours.
(David Allsopp, report by Michael Soegtrop, review by Xavier Leroy)
</li>
</ul>
<h3>Runtime system:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/10056">10056</a>: Memprof: ensure young_trigger is within the bounds of the minor
heap in caml_memprof_renew_minor_sample (regression from <a href="https://github.com/ocaml/ocaml/issues/8684">8684</a>)
(David Allsopp, review by Guillaume Munch-Maccagnoni and
Jacques-Henri Jourdan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9654">9654</a>: More efficient management of code fragments.
(Xavier Leroy, review by Jacques-Henri Jourdan, Damien Doligez, and
Stephen Dolan)</p>
</li>
</ul>
<h3>Tools:</h3>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/9606">9606</a>, <a href="https://github.com/ocaml/ocaml/issues/9635">9635</a>, <a href="https://github.com/ocaml/ocaml/issues/9637">9637</a>: fix performance regression in the debugger
(behaviors quadratic in the size of the debugged program)
(Xavier Leroy, report by Jacques Garrigue and Virgile Prevosto,
review by David Allsopp and Jacques-Henri Jourdan)
</li>
</ul>
<h3>Code generation and optimizations:</h3>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/9969">9969</a>, <a href="https://github.com/ocaml/ocaml/issues/9981">9981</a>: Added mergeable flag to ELF sections containing mergeable
constants.  Fixes compatibility with the integrated assembler in clang 11.0.0.
(Jacob Young, review by Nicolás Ojeda Bär)
</li>
</ul>
<h3>Bug fixes:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9970">9970</a>, <a href="https://github.com/ocaml/ocaml/issues/10010">10010</a>: fix the declaration scope of extensible-datatype constructors.
A regression that dates back to 4.08 makes extensible-datatype constructors
with inline records very fragile, for example:
type 'a t += X of {x : 'a}
(Gabriel Scherer, review by Thomas Refis and Leo White,
report by Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9096">9096</a>, <a href="https://github.com/ocaml/ocaml/issues/10096">10096</a>: fix a 4.11.0 performance regression in classes/objects
declared within a function
(Gabriel Scherer, review by Leo White, report by Sacha Ayoun)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9326">9326</a>, <a href="https://github.com/ocaml/ocaml/issues/10125">10125</a>: Gc.set incorrectly handles the three <code>custom_*</code> fields,
causing a performance regression
(report by Emilio Jesús Gallego Arias, analysis and fix by Stephen Dolan,
code by Xavier Leroy, review by Hugo Heuzard and Gabriel Scherer)</p>
</li>
</ul>
|js}
  };
 
  { kind = `Compiler
  ; version = {js|4.10.2|js}
  ; date = {js|2020-12-08|js}
  ; intro_md = {js|This page describes OCaml **4.10.2**, released on Dec 8, 2020.  It is an exceptional release making OCaml **4.10** available on macOS/arm64 and fixes some compatibility issues for the mingw64 and FreeBSD/amd64 platform.

Note that those fixes were backported from OCaml 4.12: further improvement to the support of the macOS/arm64 platform will happen on the 4.12 branch.

This release is available as an [opam](/p/ocaml/4.10.2) package.
|js}
  ; intro_html = {js|<p>This page describes OCaml <strong>4.10.2</strong>, released on Dec 8, 2020.  It is an exceptional release making OCaml <strong>4.10</strong> available on macOS/arm64 and fixes some compatibility issues for the mingw64 and FreeBSD/amd64 platform.</p>
<p>Note that those fixes were backported from OCaml 4.12: further improvement to the support of the macOS/arm64 platform will happen on the 4.12 branch.</p>
<p>This release is available as an <a href="/p/ocaml/4.10.2">opam</a> package.</p>
|js}
  ; highlights_md = {js|- Bug fixes for 4.10.1
|js}
  ; highlights_html = {js|<ul>
<li>Bug fixes for 4.10.1
</li>
</ul>
|js}
  ; body_md = {js|
Source distribution
---------------------------------------------

- [Source
  tarball](https://github.com/ocaml/ocaml/archive/4.10.2.tar.gz)
  (.tar.gz) for compilation under Unix (including Linux and macOS)
  and Microsoft Windows (including Cygwin).
- Also available in
  [.zip](https://github.com/ocaml/ocaml/archive/4.10.2.zip)
  format.
- [OPAM](https://opam.ocaml.org/) is a source-based distribution of
  OCaml and many companion libraries and tools. Compilation and
  installation are automated by powerful package managers.
- The official development repo is hosted on
  [GitHub](https://github.com/ocaml/ocaml).

## Changes

- [#9938](https://github.com/ocaml/ocaml/issues/9938), [#9939](https://github.com/ocaml/ocaml/issues/9939): Define `__USE_MINGW_ANSI_STDIO=0` for the mingw-w64 ports to prevent their C99-compliant snprintf conflicting with ours.
(David Allsopp, report by Michael Soegtrop, review by Xavier Leroy)

### Supported Platforms: 

- [#9699](https://github.com/ocaml/ocaml/issues/9699), [#10026](https://github.com/ocaml/ocaml/issues/10026): Add support for iOS and macOS on ARM 64 bits backported from OCaml 4.12.0.
(GitHub user @EduardoRFS, review by Xavier Leroy, Nicolás Ojeda Bär
and Anil Madhavapeddy, additional testing by Michael Schmidt)

### Code generation and optimization: 

- [#9752](https://github.com/ocaml/ocaml/issues/9752), [#10026](https://github.com/ocaml/ocaml/issues/10026):Revised handling of calling conventions for external C functions.
Provide a more precise description of the types of unboxed arguments,
so that the ARM64 iOS/macOS calling conventions can be honored.
Backported from OCaml 4.12.0
(Xavier Leroy, review by Mark Shinwell and Github user @EduardoRFS)

- [#9699](https://github.com/ocaml/ocaml/issues/9699), [#9981](https://github.com/ocaml/ocaml/issues/9981): Added mergeable flag tqo ELF sections containing mergeable constants. Fixes compatibility with the integrated assembler in clang 11.0.0.
Backported from OCaml 4.12.0
(Jacob Young, review by Nicolás Ojeda Bär)|js}
  ; body_html = {js|<h2>Source distribution</h2>
<ul>
<li><a href="https://github.com/ocaml/ocaml/archive/4.10.2.tar.gz">Source
tarball</a>
(.tar.gz) for compilation under Unix (including Linux and macOS)
and Microsoft Windows (including Cygwin).
</li>
<li>Also available in
<a href="https://github.com/ocaml/ocaml/archive/4.10.2.zip">.zip</a>
format.
</li>
<li><a href="https://opam.ocaml.org/">OPAM</a> is a source-based distribution of
OCaml and many companion libraries and tools. Compilation and
installation are automated by powerful package managers.
</li>
<li>The official development repo is hosted on
<a href="https://github.com/ocaml/ocaml">GitHub</a>.
</li>
</ul>
<h2>Changes</h2>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/9938">#9938</a>, <a href="https://github.com/ocaml/ocaml/issues/9939">#9939</a>: Define <code>__USE_MINGW_ANSI_STDIO=0</code> for the mingw-w64 ports to prevent their C99-compliant snprintf conflicting with ours.
(David Allsopp, report by Michael Soegtrop, review by Xavier Leroy)
</li>
</ul>
<h3>Supported Platforms:</h3>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/9699">#9699</a>, <a href="https://github.com/ocaml/ocaml/issues/10026">#10026</a>: Add support for iOS and macOS on ARM 64 bits backported from OCaml 4.12.0.
(GitHub user @EduardoRFS, review by Xavier Leroy, Nicolás Ojeda Bär
and Anil Madhavapeddy, additional testing by Michael Schmidt)
</li>
</ul>
<h3>Code generation and optimization:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9752">#9752</a>, <a href="https://github.com/ocaml/ocaml/issues/10026">#10026</a>:Revised handling of calling conventions for external C functions.
Provide a more precise description of the types of unboxed arguments,
so that the ARM64 iOS/macOS calling conventions can be honored.
Backported from OCaml 4.12.0
(Xavier Leroy, review by Mark Shinwell and Github user @EduardoRFS)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9699">#9699</a>, <a href="https://github.com/ocaml/ocaml/issues/9981">#9981</a>: Added mergeable flag tqo ELF sections containing mergeable constants. Fixes compatibility with the integrated assembler in clang 11.0.0.
Backported from OCaml 4.12.0
(Jacob Young, review by Nicolás Ojeda Bär)</p>
</li>
</ul>
|js}
  };
 
  { kind = `Compiler
  ; version = {js|4.11.1|js}
  ; date = {js|2020-08-31|js}
  ; intro_md = {js|This page describe OCaml **4.11.1**, released on Aug 31, 2020.  It is a bug-fix release of [OCaml 4.11.0](/releases/4.11.0).

This release is available as an [opam](/p/ocaml/4.11.1) package.
|js}
  ; intro_html = {js|<p>This page describe OCaml <strong>4.11.1</strong>, released on Aug 31, 2020.  It is a bug-fix release of <a href="/releases/4.11.0">OCaml 4.11.0</a>.</p>
<p>This release is available as an <a href="/p/ocaml/4.11.1">opam</a> package.</p>
|js}
  ; highlights_md = {js|- Bug fixes for 4.11.0
|js}
  ; highlights_html = {js|<ul>
<li>Bug fixes for 4.11.0
</li>
</ul>
|js}
  ; body_md = {js|
### Bug fixes:

- [#9856](https://github.com/ocaml/ocaml/issues/9856), [#9857](https://github.com/ocaml/ocaml/issues/9857): Prevent polymorphic type annotations from generalizing
  weak polymorphic variables.
  (Leo White, report by Thierry Martinez, review by Jacques Garrigue)

- [#9859](https://github.com/ocaml/ocaml/issues/9859), [#9862](https://github.com/ocaml/ocaml/issues/9862): Remove an erroneous assertion when inferred function types
  appear in the right hand side of an explicit :> coercion
  (Florian Angeletti, report by Jerry James, review by Thomas Refis)
|js}
  ; body_html = {js|<h3>Bug fixes:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9856">#9856</a>, <a href="https://github.com/ocaml/ocaml/issues/9857">#9857</a>: Prevent polymorphic type annotations from generalizing
weak polymorphic variables.
(Leo White, report by Thierry Martinez, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9859">#9859</a>, <a href="https://github.com/ocaml/ocaml/issues/9862">#9862</a>: Remove an erroneous assertion when inferred function types
appear in the right hand side of an explicit :&gt; coercion
(Florian Angeletti, report by Jerry James, review by Thomas Refis)</p>
</li>
</ul>
|js}
  };
 
  { kind = `Compiler
  ; version = {js|4.10.1|js}
  ; date = {js|2020-08-20|js}
  ; intro_md = {js|This page describe OCaml **4.10.1**, released on Aug 20, 2020.  It is a bug-fix release of [OCaml 4.10.0](/releases/4.10.0).

This release is available as an [opam](/p/ocaml/4.10.1) package.
|js}
  ; intro_html = {js|<p>This page describe OCaml <strong>4.10.1</strong>, released on Aug 20, 2020.  It is a bug-fix release of <a href="/releases/4.10.0">OCaml 4.10.0</a>.</p>
<p>This release is available as an <a href="/p/ocaml/4.10.1">opam</a> package.</p>
|js}
  ; highlights_md = {js|- Bug fixes for 4.10.0
|js}
  ; highlights_html = {js|<ul>
<li>Bug fixes for 4.10.0
</li>
</ul>
|js}
  ; body_md = {js|
### Runtime system:

- [#9344](https://github.com/ocaml/ocaml/issues/9344), [#9368](https://github.com/ocaml/ocaml/issues/9368): Disable exception backtraces in bytecode programs
  built with "-output-complete-exe". At the moment, such programs do
  not embed debug information and exception backtraces where causing
  them to crash.
  (Jérémie Dimino, review by Nicolás Ojeda Bär)

### Build system:

- [#9531](https://github.com/ocaml/ocaml/issues/9531): fix support for the BFD library on FreeBSD
  (Hannes Mehnert, review by Gabriel Scherer and David Allsopp)

### Bug fixes:

- [#9068](https://github.com/ocaml/ocaml/issues/9068), [#9437](https://github.com/ocaml/ocaml/issues/9437): ocamlopt -output-complete-obj failure on FreeBSD 12
  (Xavier Leroy, report by Hannes Mehnert, review by Sébastien Hinderer)

- [#9165](https://github.com/ocaml/ocaml/issues/9165), [#9840](https://github.com/ocaml/ocaml/issues/9840): Add missing -function-sections flag in Makefiles.
  (Greta Yorsh, review by David Allsopp)

- [#9495](https://github.com/ocaml/ocaml/issues/9495): fix a bug where bytecode binaries compiled with `-output-complete-exe`
  would not execute `at_exit` hooks at program termination (in particular,
  output channels would not be flushed).
  (Nicolás Ojeda Bär, review by David Allsopp)

- [#9714](https://github.com/ocaml/ocaml/issues/9714), [#9724](https://github.com/ocaml/ocaml/issues/9724): Use the C++ alignas keyword when compiling in C++ in MSVC.
  Fixes a bug with MSVC C++ 2015 onwards.
  (Antonin Décimo, review by David Allsopp and Xavier Leroy)

- [#9736](https://github.com/ocaml/ocaml/issues/9736), [#9749](https://github.com/ocaml/ocaml/issues/9749): Compaction must start in a heap where all free blocks are
  blue, which was not the case with the best-fit allocator.
  (Damien Doligez, report and review by Leo White)

### Tools:

- [#9552](https://github.com/ocaml/ocaml/issues/9552): restore ocamloptp build and installation
  (Florian Angeletti, review by David Allsopp and Xavier Leroy)
|js}
  ; body_html = {js|<h3>Runtime system:</h3>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/9344">#9344</a>, <a href="https://github.com/ocaml/ocaml/issues/9368">#9368</a>: Disable exception backtraces in bytecode programs
built with &quot;-output-complete-exe&quot;. At the moment, such programs do
not embed debug information and exception backtraces where causing
them to crash.
(Jérémie Dimino, review by Nicolás Ojeda Bär)
</li>
</ul>
<h3>Build system:</h3>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/9531">#9531</a>: fix support for the BFD library on FreeBSD
(Hannes Mehnert, review by Gabriel Scherer and David Allsopp)
</li>
</ul>
<h3>Bug fixes:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9068">#9068</a>, <a href="https://github.com/ocaml/ocaml/issues/9437">#9437</a>: ocamlopt -output-complete-obj failure on FreeBSD 12
(Xavier Leroy, report by Hannes Mehnert, review by Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9165">#9165</a>, <a href="https://github.com/ocaml/ocaml/issues/9840">#9840</a>: Add missing -function-sections flag in Makefiles.
(Greta Yorsh, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9495">#9495</a>: fix a bug where bytecode binaries compiled with <code>-output-complete-exe</code>
would not execute <code>at_exit</code> hooks at program termination (in particular,
output channels would not be flushed).
(Nicolás Ojeda Bär, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9714">#9714</a>, <a href="https://github.com/ocaml/ocaml/issues/9724">#9724</a>: Use the C++ alignas keyword when compiling in C++ in MSVC.
Fixes a bug with MSVC C++ 2015 onwards.
(Antonin Décimo, review by David Allsopp and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9736">#9736</a>, <a href="https://github.com/ocaml/ocaml/issues/9749">#9749</a>: Compaction must start in a heap where all free blocks are
blue, which was not the case with the best-fit allocator.
(Damien Doligez, report and review by Leo White)</p>
</li>
</ul>
<h3>Tools:</h3>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/9552">#9552</a>: restore ocamloptp build and installation
(Florian Angeletti, review by David Allsopp and Xavier Leroy)
</li>
</ul>
|js}
  };
 
  { kind = `Compiler
  ; version = {js|4.11.0|js}
  ; date = {js|2020-08-19|js}
  ; intro_md = {js|This page describes OCaml version **4.11.0**, released on 2020-08-19. 

This release is available as an [opam](/p/ocaml/4.11.0) package.
|js}
  ; intro_html = {js|<p>This page describes OCaml version <strong>4.11.0</strong>, released on 2020-08-19.</p>
<p>This release is available as an <a href="/p/ocaml/4.11.0">opam</a> package.</p>
|js}
  ; highlights_md = {js|- Statmemprof: a new statistical memory profiler
- A new instrumented runtime that logs runtime statistics in a standard format
- A native backend for the RISC-V architecture
- Improved backtraces that refer to function names
- Suppport for recursive and yet unboxed types
- A quoted extension syntax for ppxs.
- Many quality of life improvements
- Many bug fixes.
|js}
  ; highlights_html = {js|<ul>
<li>Statmemprof: a new statistical memory profiler
</li>
<li>A new instrumented runtime that logs runtime statistics in a standard format
</li>
<li>A native backend for the RISC-V architecture
</li>
<li>Improved backtraces that refer to function names
</li>
<li>Suppport for recursive and yet unboxed types
</li>
<li>A quoted extension syntax for ppxs.
</li>
<li>Many quality of life improvements
</li>
<li>Many bug fixes.
</li>
</ul>
|js}
  ; body_md = {js|
Opam switches
-------------

This release is available as multiple
[OPAM](https://opam.ocaml.org/doc/Usage.html) switches:

- 4.11.0 — Official release 4.11.0
- 4.11.0+flambda — Official release 4.11.0, with flambda activated

- 4.11.0+afl — Official release 4.11.0, with afl-fuzz instrumentation
- 4.11.0+spacetime - Official 4.11.0 release with spacetime activated

- 4.11.0+default-unsafe-string — Official release 4.11.0, without
  safe strings by default
- 4.11.0+no-flat-float-array - Official release 4.11.0, with
  --disable-flat-float-array
- 4.11.0+flambda+no-flat-float-array — Official release 4.11.0, with
  flambda activated and --disable-flat-float-array
- 4.11.0+fp — Official release 4.11.0, with frame-pointers
- 4.11.0+fp+flambda — Official release 4.11.0, with frame-pointers
  and flambda activated
- 4.11.0+musl+static+flambda - Official release 4.11.0, compiled with
  musl-gcc -static and with flambda activated

- 4.11.0+32bit - Official release 4.11.0, compiled in 32-bit mode
  for 64-bit Linux and OS X hosts
- 4.11.0+bytecode-only - Official release 4.11.0, without the
  native-code compiler


What's new
----------
Some of the highlights in release 4.11 are:

- Statmemprof: a new statistical memory profiler
- A new instrumented runtime that logs runtime statistics in a standard format
- A native backend for the RISC-V architecture
- Improved backtraces that refer to function names
- Suppport for recursive and yet unboxed types
- A quoted extension syntax for ppxs.
- Many quality of life improvements
- Many bug fixes.

For a comprehensive list of changes and details on all new features,
bug fixes, optimizations, etc., please consult the
[changelog](#Changes).

Source distribution
---------------------------------------------

- [Source
  tarball](https://github.com/ocaml/ocaml/archive/4.11.0.tar.gz)
  (.tar.gz) for compilation under Unix (including Linux and MacOS X)
  and Microsoft Windows (including Cygwin).
- Also available in
  [.zip](https://github.com/ocaml/ocaml/archive/4.11.0.zip)
  format.
- [OPAM](https://opam.ocaml.org/) is a source-based distribution of
  OCaml and many companion libraries and tools. Compilation and
  installation are automated by powerful package managers.
- The official development repo is hosted on
  [GitHub](https://github.com/ocaml/ocaml).

The
[INSTALL](4.11/notes/INSTALL.adoc) file
of the distribution provides detailed compilation and installation
instructions — see also the [Windows release
notes](4.11/notes/README.win32.adoc) for
instructions on how to build under Windows.

Alternative Compilers
---------------------

Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:

* [Js_of_ocaml](http://ocsigen.org/js_of_ocaml/) is a stable OCaml
  to JavaScript compiler.
* [Bucklescript](http://bucklescript.github.io/bucklescript/) is a
  newer OCaml to JavaScript compiler. See its
  [wiki](https://github.com/bucklescript/bucklescript/wiki/Differences-from-js_of_ocaml) for
  an explanation of how it differs from `js_of_ocaml`.
* [OCaml-java](http://www.ocamljava.org/) is a stable OCaml to
  Java compiler.

User's manual
------------------------------------

The user's manual for OCaml can be:

- [browsed
  online](4.11/htmlman/index.html),
- downloaded as a single
  [PDF](4.11/ocaml-4.11-refman.pdf),
  or [plain
  text](4.11/ocaml-4.11-refman.txt)
  document,
- downloaded as a single
  [TAR](4.11/ocaml-4.11-refman-html.tar.gz)
  or
  [ZIP](4.11/ocaml-4.11-refman-html.zip)
  archive of HTML files,
- downloaded as a single
  [tarball](4.11/ocaml-4.11-refman.info.tar.gz)
  of Emacs info files,



Changes
-------

This is the
[changelog](4.11/notes/Changes).
(Changes that can break existing programs are marked with a  "*breaking change" warning)

### Runtime system:

- [#9096](https://github.com/ocaml/ocaml/issues/9096): Print function names in backtraces.
  Old output:
```
Called from file "foo.ml", line 16, characters 42-53
```
  New output:
```
Called from Foo.bar in file "foo.ml", line 16, characters 42-53
```
  (Stephen Dolan, review by Leo White and Mark Shinwell)

- [#9082](https://github.com/ocaml/ocaml/issues/9082): The instrumented runtime now records logs in the CTF format.
  A new API is available in the runtime to collect runtime statistics,
  replacing the previous instrumented runtime macros.
  Gc.eventlog_pause and Gc.eventlog_resume were added to allow user to control
  instrumentation in a running program.
  See the manual for more information on how to use this instrumentation mode.
  (Enguerrand Decorne and Stephen Dolan, with help and review from
  David Allsopp, Sébastien Hinderer, review by Anil Madhavapeddy,
  Nicolás Ojeda Bär, Shakthi Kannan, KC Sivaramakrishnan, Gabriel Scherer,
  Guillaume Munch-Maccagnoni, Damien Doligez, Leo White, Daniel Bünzli
  and Xavier Leroy)

- [#9230](https://github.com/ocaml/ocaml/issues/9230), [#9362](https://github.com/ocaml/ocaml/issues/9362): Memprof support for native allocations.
  (Jacques-Henri Jourdan and Stephen Dolan, review by Gabriel Scherer)

- [#8920](https://github.com/ocaml/ocaml/issues/8920), [#9238](https://github.com/ocaml/ocaml/issues/9238), [#9239](https://github.com/ocaml/ocaml/issues/9239), [#9254](https://github.com/ocaml/ocaml/issues/9254), [#9458](https://github.com/ocaml/ocaml/issues/9458): New API for statistical memory profiling
  in Memprof.Gc. The new version does no longer use ephemerons and allows
  registering callbacks for promotion and deallocation of memory
  blocks.
  The new API no longer gives the block tags to the allocation callback.
  (Stephen Dolan and Jacques-Henri Jourdan, review by Damien Doligez
   and Gabriel Scherer)

- [#9353](https://github.com/ocaml/ocaml/issues/9353): Reimplement `output_value` and the `Marshal.to_*` functions
  using a hash table to detect sharing, instead of temporary in-place
  modifications.  This is a prerequisite for Multicore OCaml.
  (Xavier Leroy and Basile Clément, review by Gabriel Scherer and
  Stephen Dolan)


- [#9119](https://github.com/ocaml/ocaml/issues/9119): Make [caml_stat_resize_noexc] compatible with the [realloc]
  API when the old block is NULL.
  (Jacques-Henri Jourdan, review by Xavier Leroy)

- [#9233](https://github.com/ocaml/ocaml/issues/9233): Restore the bytecode stack after an allocation.
  (Stephen Dolan, review by Gabriel Scherer and Jacques-Henri Jourdan)

- [#9249](https://github.com/ocaml/ocaml/issues/9249): restore definition of ARCH_ALIGN_INT64 in m.h if the architecture
  requires 64-bit integers to be double-word aligned (autoconf regression)
  (David Allsopp, review by Sébastien Hinderer)

- [#9259](https://github.com/ocaml/ocaml/issues/9259): Made `Ephemeron.blit_key` and `Weak.blit` faster. They are now
  linear in the size of the range being copied instead of depending on the
  total sizes of the ephemerons or weak arrays involved.
  (Arseniy Alekseyev, design advice by Leo White, review by François Bobot
  and Damien Doligez)

- [#9279](https://github.com/ocaml/ocaml/issues/9279): Memprof optimisation.
  (Stephen Dolan, review by Jacques-Henri Jourdan)

- [#9280](https://github.com/ocaml/ocaml/issues/9280): Micro-optimise allocations on amd64 to save a register.
  (Stephen Dolan, review by Xavier Leroy)

- [#9426](https://github.com/ocaml/ocaml/issues/9426): build the Mingw ports with higher levels of GCC optimization
  (Xavier Leroy, review by Sébastien Hinderer)

* \\[*breaking change*\\] [#9483](https://github.com/ocaml/ocaml/issues/9483): Remove accidental inclusion of <stdio.h> in <caml/misc.h>
  The only release with the inclusion of stdio.h has been 4.10.0
  (Christopher Zimmermann, review by Xavier Leroy and David Allsopp)

- [#9282](https://github.com/ocaml/ocaml/issues/9282): Make Cconst_symbol have typ_int to fix no-naked-pointers mode.
  (Stephen Dolan, review by Mark Shinwell, Xavier Leroy and Vincent Laviron)

- [#9497](https://github.com/ocaml/ocaml/issues/9497): Harmonise behaviour between bytecode and native code for
  recursive module initialisation in one particular case (fixes [#9494](https://github.com/ocaml/ocaml/issues/9494)).
  (Mark Shinwell, David Allsopp, Vincent Laviron, Xavier Leroy,
  Geoff Reedy, original bug report by Arlen Cox)

- [#8791](https://github.com/ocaml/ocaml/issues/8791): use a variable-length encoding when marshalling bigarray dimensions,
  avoiding overflow.
  (Jeremy Yallop, Stephen Dolan, review by Xavier Leroy)

### Code generation and optimizations:

- [#9441](https://github.com/ocaml/ocaml/issues/9441): Add RISC-V RV64G native-code backend.
  (Nicolás Ojeda Bär, review by Xavier Leroy and Gabriel Scherer)

- [#9316](https://github.com/ocaml/ocaml/issues/9316), [#9443](https://github.com/ocaml/ocaml/issues/9443), [#9463](https://github.com/ocaml/ocaml/issues/9463), [#9782](https://github.com/ocaml/ocaml/issues/9782): Use typing information from Clambda
  for mutable Cmm variables.
  (Stephen Dolan, review by Vincent Laviron, Guillaume Bury, Xavier Leroy,
  and Gabriel Scherer; temporary bug report by Richard Jones)

- [#8637](https://github.com/ocaml/ocaml/issues/8637), [#8805](https://github.com/ocaml/ocaml/issues/8805), [#9247](https://github.com/ocaml/ocaml/issues/9247), [#9296](https://github.com/ocaml/ocaml/issues/9296): Record debug info for each allocation.
  (Stephen Dolan and Jacques-Henri Jourdan, review by Damien Doligez,
   KC Sivaramakrishnan and Xavier Leroy)


- [#9193](https://github.com/ocaml/ocaml/issues/9193): Make tuple matching optimisation apply to Lswitch and Lstringswitch.
  (Stephen Dolan, review by Thomas Refis and Gabriel Scherer)

- [#9392](https://github.com/ocaml/ocaml/issues/9392): Visit registers at most once in Coloring.iter_preferred.
  (Stephen Dolan, review by Pierre Chambart and Xavier Leroy)

- [#9549](https://github.com/ocaml/ocaml/issues/9549), [#9557](https://github.com/ocaml/ocaml/issues/9557): Make -flarge-toc the default for PowerPC and introduce
  -fsmall-toc to enable the previous behaviour.
  (David Allsopp, report by Nathaniel Wesley Filardo, review by Xavier Leroy)

### Language features

- [#8820](https://github.com/ocaml/ocaml/issues/8820), [#9166](https://github.com/ocaml/ocaml/issues/9166): quoted extensions: {%foo|...|} is lighter syntax for
  [%foo {||}], and {%foo bar|...|bar} for [%foo {bar|...|bar}].
  (Gabriel Radanne, Leo White, Gabriel Scherer and Pieter Goetschalckx,
   request by Bikal Lem)

- [#7364](https://github.com/ocaml/ocaml/issues/7364), [#2188](https://github.com/ocaml/ocaml/issues/2188), [#9592](https://github.com/ocaml/ocaml/issues/9592), [#9609](https://github.com/ocaml/ocaml/issues/9609): improvement of the unboxability check for types
  with a single constructor. Mutually-recursive type declarations can
  now contain unboxed types. This is based on the paper
    https://arxiv.org/abs/1811.02300
  (Gabriel Scherer and Rodolphe Lepigre,
   review by Jeremy Yallop, Damien Doligez and Frédéric Bour)

- [#1154](https://github.com/ocaml/ocaml/issues/1154), [#1706](https://github.com/ocaml/ocaml/issues/1706): spellchecker hints and type-directed disambiguation
  for extensible sum type constructors
  (Florian Angeletti, review by Alain Frisch, Gabriel Radanne, Gabriel Scherer
  and Leo White)


- [#6673](https://github.com/ocaml/ocaml/issues/6673), [#1132](https://github.com/ocaml/ocaml/issues/1132), [#9617](https://github.com/ocaml/ocaml/issues/9617): Relax the handling of explicit polymorphic types.
  This improves error messages in some polymorphic recursive definition,
  and requires less polymorphic annotations in some cases of
  mutually-recursive definitions involving polymorphic recursion.
  (Leo White, review by Jacques Garrigue and Gabriel Scherer)

- [#9232](https://github.com/ocaml/ocaml/issues/9232): allow any class type paths in #-types,
  For instance, "val f: #F(X).t -> unit" is now allowed.
  (Florian Angeletti, review by Gabriel Scherer, suggestion by Leo White)

### Standard library:

- [#9077](https://github.com/ocaml/ocaml/issues/9077): Add Seq.cons and Seq.append
  (Sébastien Briais, review by Yawar Amin and Florian Angeletti)

- [#9235](https://github.com/ocaml/ocaml/issues/9235): Add Array.exists2 and Array.for_all2
  (Bernhard Schommer, review by Armaël Guéneau)

- [#9226](https://github.com/ocaml/ocaml/issues/9226): Add Seq.unfold.
   (Jeremy Yallop, review by Hezekiah M. Carty, Gabriel Scherer and
   Gabriel Radanne)

- [#9059](https://github.com/ocaml/ocaml/issues/9059): Added List.filteri function, same as List.filter but
  with the index of the element.
  (Léo Andrès, review by Alain Frisch)

- [#8894](https://github.com/ocaml/ocaml/issues/8894): Added List.fold_left_map function combining map and fold.
  (Bernhard Schommer, review by Alain Frisch and github user @cfcs)

- [#9365](https://github.com/ocaml/ocaml/issues/9365): Set.filter_map and Map.filter_map
  (Gabriel Scherer, review by Stephen Dolan and Nicolás Ojeda Bär)


- [#9248](https://github.com/ocaml/ocaml/issues/9248): Add Printexc.default_uncaught_exception_handler
  (Raphael Sousa Santos, review by Daniel Bünzli)

- [#8771](https://github.com/ocaml/ocaml/issues/8771): Lexing: add set_position and set_filename to change (fake)
   the initial tracking position of the lexbuf.
   (Konstantin Romanov, Miguel Lumapat, review by Gabriel Scherer,
    Sébastien Hinderer, and David Allsopp)

- [#9237](https://github.com/ocaml/ocaml/issues/9237): `Format.pp_update_geometry ppf (fun geo -> {geo with ...})`
  for formatter geometry changes that are robust to new geometry fields.
  (Gabriel Scherer, review by Josh Berdine and Florian Angeletti)

- [#7110](https://github.com/ocaml/ocaml/issues/7110): Added Printf.ikbprintf and Printf.ibprintf
  (Muskan Garg, review by Gabriel Scherer and Florian Angeletti)

- [#9266](https://github.com/ocaml/ocaml/issues/9266): Install pretty-printer for the exception Fun.Finally_raised.
  (Guillaume Munch-Maccagnoni, review by Daniel Bünzli, Gabriel Radanne,
   and Gabriel Scherer)

### Other libraries:

- [#9106](https://github.com/ocaml/ocaml/issues/9106): Register printer for Unix_error in win32unix, as in unix.
  (Christopher Zimmermann, review by David Allsopp)

- [#9183](https://github.com/ocaml/ocaml/issues/9183): Preserve exception backtrace of exceptions raised by top-level phrases
  of dynlinked modules.
  (Nicolás Ojeda Bär, review by Xavier Clerc and Gabriel Scherer)

- [#9320](https://github.com/ocaml/ocaml/issues/9320), [#9550](https://github.com/ocaml/ocaml/issues/9550): under Windows, make sure that the Unix.exec* functions
  properly quote their argument lists.
  (Xavier Leroy, report by André Maroneze, review by Nicolás Ojeda Bär
   and David Allsopp)

- [#9490](https://github.com/ocaml/ocaml/issues/9490), [#9505](https://github.com/ocaml/ocaml/issues/9505): ensure proper rounding of file times returned by
  Unix.stat, Unix.lstat, Unix.fstat.
  (Xavier Leroy and Guillaume Melquiond, report by David Brown,
   review by Gabriel Scherer and David Allsopp)

### Tools:

- [#9283](https://github.com/ocaml/ocaml/issues/9283), [#9455](https://github.com/ocaml/ocaml/issues/9455), [#9457](https://github.com/ocaml/ocaml/issues/9457): add a new toplevel directive `#use_output "<command>"` to
  run a command and evaluate its output.
  (Jérémie Dimino, review by David Allsopp)


- [#6969](https://github.com/ocaml/ocaml/issues/6969): Argument -nocwd added to ocamldep
  (Muskan Garg, review by Florian Angeletti)

- [#8676](https://github.com/ocaml/ocaml/issues/8676), [#9594](https://github.com/ocaml/ocaml/issues/9594): turn debugger off in programs launched by the program
  being debugged
  (Xavier Leroy, report by Michael Soegtrop, review by Gabriel Scherer)

- [#9057](https://github.com/ocaml/ocaml/issues/9057): aid debugging the debugger by preserving backtraces of unhandled
  exceptions.
  (David Allsopp, review by Gabriel Scherer)

- [#9276](https://github.com/ocaml/ocaml/issues/9276): objinfo: cm[x]a print extra C options, objects and dlls in
  the order given on the cli. Follow up to [#4949](https://github.com/ocaml/ocaml/issues/4949).
  (Daniel Bünzli, review by Gabriel Scherer)

- [#463](https://github.com/ocaml/ocaml/issues/463): objinfo: better errors on object files coming
  from a different (older or newer), incompatible compiler version.
  (Gabriel Scherer, review by Gabriel Radanne and Damien Doligez)

- [#9181](https://github.com/ocaml/ocaml/issues/9181): make objinfo work on Cygwin and look for the caml_plugin_header
  symbol in both the static and the dynamic symbol tables.
  (Sébastien Hinderer, review by Gabriel Scherer and David Allsopp)

* \\[*breaking change*\\] [#9197](https://github.com/ocaml/ocaml/issues/9197): remove compatibility logic from [#244](https://github.com/ocaml/ocaml/issues/244) that was designed to
  synchronize toplevel printing margins with Format.std_formatter,
  but also resulted in unpredictable/fragile changes to formatter
  margins.
  Setting the margins on the desired formatters should now work.
  typically on `Format.std_formatter`.
  Note that there currently is no robust way to do this from the
  toplevel, as applications may redirect toplevel printing. In
  a compiler/toplevel driver, one should instead access
  `Location.formatter_for_warnings`; it is not currently exposed
  to the toplevel.
  (Gabriel Scherer, review by Armaël Guéneau)

- [#9207](https://github.com/ocaml/ocaml/issues/9207), [#9210](https://github.com/ocaml/ocaml/issues/9210): fix ocamlyacc to work correctly with up to 255 entry
  points to the grammar.
  (Andreas Abel, review by Xavier Leroy)

- [#9482](https://github.com/ocaml/ocaml/issues/9482), [#9492](https://github.com/ocaml/ocaml/issues/9492): use diversions (@file) to work around OS limitations
  on length of Sys.command argument.
  (Xavier Leroy, report by Jérémie Dimino, review by David Allsopp)

- [#9552](https://github.com/ocaml/ocaml/issues/9552): restore ocamloptp build and installation
  (Florian Angeletti, review by David Allsopp and Xavier Leroy)

### Manual and documentation:

- [#9141](https://github.com/ocaml/ocaml/issues/9141): beginning of the ocamltest reference manual
  (Sébastien Hinderer, review by Gabriel Scherer and Thomas Refis)

- [#9228](https://github.com/ocaml/ocaml/issues/9228): Various Map documentation improvements: add missing key argument in
  the 'merge' example; clarify the relationship between input and output keys
  in 'union'; note that find and find_opt return values, not bindings.
  (Jeremy Yallop, review by Gabriel Scherer and Florian Angeletti)

- [#9255](https://github.com/ocaml/ocaml/issues/9255), [#9300](https://github.com/ocaml/ocaml/issues/9300): reference chapter, split the expression grammar
  (Florian Angeletti, report by Harrison Ainsworth, review by Gabriel Scherer)

- [#9325](https://github.com/ocaml/ocaml/issues/9325): documented base case for `List.for_all` and `List.exists`
  (Glenn Slotte, review by Florian Angeletti)

- [#9410](https://github.com/ocaml/ocaml/issues/9410), [#9422](https://github.com/ocaml/ocaml/issues/9422): replaced naive fibonacci example with gcd
  (Anukriti Kumar, review by San Vu Ngoc, Florian Angeletti, Léo Andrès)

- [#9541](https://github.com/ocaml/ocaml/issues/9541): Add a documentation page for the instrumented runtime;
  additional changes to option names in the instrumented runtime.
  (Enguerrand Decorne, review by Anil Madhavapeddy, Gabriel Scherer,
   Daniel Bünzli, David Allsopp, Florian Angeletti,
   and Sébastien Hinderer)

- [#9610](https://github.com/ocaml/ocaml/issues/9610): manual, C FFI: naked pointers are deprecated, detail the
  forward-compatible options for handling out-of-heap pointers.
  (Xavier Leroy, review by Mark Shinwell, David Allsopp and Florian Angeletti)

- [#9618](https://github.com/ocaml/ocaml/issues/9618): clarify the Format documentation on the margin and maximum indentation
  limit
  (Florian Angeletti, review by Josh Berdine)


- [#8644](https://github.com/ocaml/ocaml/issues/8644): fix formatting comment about @raise in stdlib's mli files
  (Élie Brami, review by David Allsopp)

- [#9327](https://github.com/ocaml/ocaml/issues/9327), [#9401](https://github.com/ocaml/ocaml/issues/9401): manual, fix infix attribute examples
  (Florian Angeletti, report by David Cadé, review by Gabriel Scherer)

- [#9403](https://github.com/ocaml/ocaml/issues/9403): added a description for warning 67 and added a "." at the end of
  warnings for consistency.
  (Muskan Garg, review by Gabriel Scherer and Florian Angeletti)

- [#7708](https://github.com/ocaml/ocaml/issues/7708), [#9580](https://github.com/ocaml/ocaml/issues/9580): Ensure Stdlib documentation index refers to Stdlib.
  (Stephen Dolan, review by Florian Angeletti, report by Hannes Mehnert)

### Compiler user-interface and warnings:

- [#9712](https://github.com/ocaml/ocaml/issues/9712): Update the version format to allow "~".
  The new format is "major.minor[.patchlevel][(+|~)additional-info]",
  for instance "4.12.0~beta1+flambda".
  This is a documentation-only change for the 4.11 branch, the new format
  will be used starting with the 4.12 branch.
  (Florian Angeletti, review by Damien Doligez and Xavier Leroy)

- [#1664](https://github.com/ocaml/ocaml/issues/1664): make -output-complete-obj link the runtime native c libraries when
  building shared libraries like `-output-obj`.
  (Florian Angeletti, review by Nicolás Ojeda Bär)

- [#9349](https://github.com/ocaml/ocaml/issues/9349): Support [@inlined hint] attribute.
  (Leo White, review by Stephen Dolan)

- [#2141](https://github.com/ocaml/ocaml/issues/2141): generate .annot files from cmt data; deprecate -annot.
  (Nicolás Ojeda Bär, review by Alain Frisch, Gabriel Scherer and Damien
  Doligez)


* \\[*breaking change*\\] [#7678](https://github.com/ocaml/ocaml/issues/7678), [#8631](https://github.com/ocaml/ocaml/issues/8631): ocamlc -c and ocamlopt -c pass same switches to the C
  compiler when compiling .c files (in particular, this means ocamlopt
  passes -fPIC on systems requiring it for shared library support).
  (David Allsopp, report by Daniel Bünzli, review by Sébastien Hinderer)

- [#9074](https://github.com/ocaml/ocaml/issues/9074): reworded error message for non-regular structural types
  (Florian Angeletti, review by Jacques Garrigue and Leo White,
   report by Chas Emerick)

- [#8938](https://github.com/ocaml/ocaml/issues/8938): Extend ocamlopt option "-stop-after" to handle "scheduling" argument.
  (Greta Yorsh, review by Florian Angeletti and Sébastien Hinderer)

- [#8945](https://github.com/ocaml/ocaml/issues/8945), [#9086](https://github.com/ocaml/ocaml/issues/9086): Fix toplevel show directive to work with constructors
  (Simon Parry, review by Gabriel Scherer, Jeremy Yallop,
  Alain Frisch, Florian Angeletti)

- [#9107](https://github.com/ocaml/ocaml/issues/9107): improved error message for exceptions in module signature errors
  (Gabriel Scherer, review by Florian Angeletti)

- [#9208](https://github.com/ocaml/ocaml/issues/9208): -dno-locations option to hide source locations (and debug events)
  from intermediate-representation dumps (-dfoo).
  (Gabriel Scherer, review by Vincent Laviron)

- [#9393](https://github.com/ocaml/ocaml/issues/9393): Improve recursive module usage warnings
  (Leo White, review by Thomas Refis)

- [#9486](https://github.com/ocaml/ocaml/issues/9486): Fix configuration for the Haiku operating system
  (Sylvain Kerjean, review by David Allsopp and Sébastien Hinderer)

### Internal/compiler-libs changes:

- [#9021](https://github.com/ocaml/ocaml/issues/9021): expose compiler Longident.t parsers
  (Florian Angeletti, review by Gabriel Scherer)

- [#9452](https://github.com/ocaml/ocaml/issues/9452): Add locations to docstring attributes
  (Leo White, review by Gabriel Scherer)


- [#463](https://github.com/ocaml/ocaml/issues/463): a new Misc.Magic_number module for user-friendly parsing
  and validation of OCaml magic numbers.
  (Gabriel Scherer, review by Gabriel Radanne and Damien Doligez)

- [#1176](https://github.com/ocaml/ocaml/issues/1176): encourage better compatibility with older Microsoft C compilers by
  using GCC's -Wdeclaration-after-statement when available. Introduce
  Caml_inline to stop abuse of the inline keyword on MSVC and to help ensure
  that only static inline is used in the codebase (erroneous instance in
  runtime/win32.c removed).
  (David Allsopp, review by Oliver Andrieu and Xavier Leroy)

- [#8934](https://github.com/ocaml/ocaml/issues/8934): Stop relying on location to track usage
  (Thomas Refis, review by Gabriel Radanne)

- [#8970](https://github.com/ocaml/ocaml/issues/8970): separate value patterns (matching on values) from computation patterns
  (matching on the effects of a copmutation) in the typedtree.
  (Gabriel Scherer, review by Jacques Garrigue and Alain Frisch)

- [#9060](https://github.com/ocaml/ocaml/issues/9060): ensure that Misc.protect_refs preserves backtraces
  (Gabriel Scherer, review by Guillaume Munch-Maccagnoni and David Allsopp)

- [#9078](https://github.com/ocaml/ocaml/issues/9078): make all compilerlibs/ available to ocamltest.
  (Gabriel Scherer, review by Sébastien Hinderer)

- [#9079](https://github.com/ocaml/ocaml/issues/9079): typecore/parmatch: refactor ppat_of_type and refine
  the use of backtracking on wildcard patterns
  (Florian Angeletti, Jacques Garrigue, Gabriel Scherer,
   review by Thomas Refis)

- [#9081](https://github.com/ocaml/ocaml/issues/9081): typedtree, make the pat_env field of pattern data immutable
  (Gabriel Scherer, review by Jacques Garrigue, report by Alain Frisch)

- [#9178](https://github.com/ocaml/ocaml/issues/9178), [#9182](https://github.com/ocaml/ocaml/issues/9182), [#9196](https://github.com/ocaml/ocaml/issues/9196): refactor label-disambiguation (Typecore.NameChoice)
  (Gabriel Scherer, Thomas Refis, Florian Angeletti and Jacques Garrigue,
   reviewing each other without self-loops)

- [#9321](https://github.com/ocaml/ocaml/issues/9321), [#9322](https://github.com/ocaml/ocaml/issues/9322), [#9359](https://github.com/ocaml/ocaml/issues/9359), [#9361](https://github.com/ocaml/ocaml/issues/9361), [#9417](https://github.com/ocaml/ocaml/issues/9417), [#9447](https://github.com/ocaml/ocaml/issues/9447): refactor the
  pattern-matching compiler
  (Thomas Refis and Gabriel Scherer, review by Florian Angeletti)

- [#9211](https://github.com/ocaml/ocaml/issues/9211), [#9215](https://github.com/ocaml/ocaml/issues/9215), [#9222](https://github.com/ocaml/ocaml/issues/9222): fix Makefile dependencies in
  compilerlibs, dynlink, ocamltest.
  (Gabriel Scherer, review by Vincent Laviron and David Allsopp)

- [#9305](https://github.com/ocaml/ocaml/issues/9305): Avoid polymorphic compare in Ident
  (Leo White, review by Xavier Leroy and Gabriel Scherer)

- [#7927](https://github.com/ocaml/ocaml/issues/7927): refactor val_env met_env par_env to class_env
  (Muskan Garg, review by Gabriel Scherer and Florian Angeletti)

- [#2324](https://github.com/ocaml/ocaml/issues/2324), [#9613](https://github.com/ocaml/ocaml/issues/9613): Replace the caml_int_compare and caml_float_compare
  (C functions) with primitives.
  (Greta Yorsh, review by Stephen Dolan and Vincent Laviron)

- [#9246](https://github.com/ocaml/ocaml/issues/9246): Avoid rechecking functor applications
  (Leo White, review by Jacques Garrigue)

- [#9402](https://github.com/ocaml/ocaml/issues/9402): Remove `sudo:false` from .travis.yml
  (Hikaru Yoshimura)

* \\[*breaking change*\\] [#9411](https://github.com/ocaml/ocaml/issues/9411): forbid optional arguments reordering with -nolabels
  (Thomas Refis, review by Frédéric Bour and Jacques Garrigue)

- [#9414](https://github.com/ocaml/ocaml/issues/9414): testsuite, ocamltest: keep test artifacts only on failure.
  Use KEEP_TEST_DIR_ON_SUCCESS=1 to keep all artifacts.
  (Gabriel Scherer, review by Sébastien Hinderer)


### Build system:

- [#9250](https://github.com/ocaml/ocaml/issues/9250): Add --disable-ocamltest to configure and disable building for
  non-development builds.
  (David Allsopp, review by Sébastien Hinderer)

### Bug fixes:

- [#7520](https://github.com/ocaml/ocaml/issues/7520), [#9547](https://github.com/ocaml/ocaml/issues/9547): Odd behaviour of refutation cases with polymorphic variants
  (Jacques Garrigue, report by Leo White, reviews by Gabriel Scherer and Leo)

- [#7562](https://github.com/ocaml/ocaml/issues/7562), [#9456](https://github.com/ocaml/ocaml/issues/9456): ocamlopt-generated code crashed on Alpine Linux on
  ppc64le, arm, and i386.  Fixed by turning PIE off for musl-based Linux
  systems except amd64 (x86_64) and s390x.
  (Xavier Leroy, review by Gabriel Scherer)

- [#7683](https://github.com/ocaml/ocaml/issues/7683), [#1499](https://github.com/ocaml/ocaml/issues/1499): Fixes one case where the evaluation order in native-code
  may not match the one in bytecode.
  (Nicolás Ojeda Bär, report by Pierre Chambart, review by Gabriel Scherer)

- [#7696](https://github.com/ocaml/ocaml/issues/7696), [#6608](https://github.com/ocaml/ocaml/issues/6608): Record expression deleted when all fields specified
  (Jacques Garrigue, report by Jeremy Yallop)

- [#7741](https://github.com/ocaml/ocaml/issues/7741), [#9645](https://github.com/ocaml/ocaml/issues/9645): Failure to report escaping type variable
  (Jacques Garrigue, report by Gabriel Radanne, review by Gabriel Scherer)

- [#7817](https://github.com/ocaml/ocaml/issues/7817), [#9546](https://github.com/ocaml/ocaml/issues/9546): Unsound inclusion check for polymorphic variant
  (Jacques Garrigue, report by Mikhail Mandrykin, review by Gabriel Scherer)

- [#7897](https://github.com/ocaml/ocaml/issues/7897), [#9537](https://github.com/ocaml/ocaml/issues/9537): Fix warning 38 for rebound extension constructors
  (Leo White, review by Florian Angeletti)

- [#7917](https://github.com/ocaml/ocaml/issues/7917), [#9426](https://github.com/ocaml/ocaml/issues/9426): Use GCC option -fexcess-precision=standard when available,
  avoiding a problem with x87 excess precision in Float.round.
  (Xavier Leroy, review by Sébastien Hinderer)

- [#9011](https://github.com/ocaml/ocaml/issues/9011): Allow linking .cmxa files with no units on MSVC by not requiring the
  .lib file to be present.
  (David Allsopp, report by Dimitry Bely, review by Xavier Leroy)

- [#9064](https://github.com/ocaml/ocaml/issues/9064): Relax the level handling when unifying row fields
  (Leo White, review by Jacques Garrigue)

- [#9097](https://github.com/ocaml/ocaml/issues/9097): Do not emit references to dead labels introduced by [#2321](https://github.com/ocaml/ocaml/issues/2321) (spacetime).
  (Greta Yorsh, review by Mark Shinwell)

- [#9163](https://github.com/ocaml/ocaml/issues/9163): Treat loops properly in un_anf
  (Leo White, review by Mark Shinwell, Pierre Chambart and Vincent Laviron)

- [#9189](https://github.com/ocaml/ocaml/issues/9189), [#9281](https://github.com/ocaml/ocaml/issues/9281): fix a conflict with Gentoo build system
  by removing an one-letter Makefile variable.
  (Florian Angeletti, report by Ralph Seichter, review by David Allsopp
   and Damien Doligez)

- [#9225](https://github.com/ocaml/ocaml/issues/9225): Do not drop bytecode debug info after C calls.
  (Stephen Dolan, review by Gabriel Scherer and Jacques-Henri Jourdan)

- [#9231](https://github.com/ocaml/ocaml/issues/9231): Make sure a debug event (and the corresponding debug
  information) is inserted after every primitive that can appear in a
  collected call stack, and make sure ocamlc preserves such events
  even if they are at tail position.
  (Jacques-Henri Jourdan, review by Gabriel Scherer)

- [#9244](https://github.com/ocaml/ocaml/issues/9244): Fix some missing usage warnings
  (Leo White, review by Florian Angeletti)

- [#9274](https://github.com/ocaml/ocaml/issues/9274), avoid reading cmi file while printing types
  (Florian Angeletti, review by Gabriel Scherer)

- [#9307](https://github.com/ocaml/ocaml/issues/9307), [#9345](https://github.com/ocaml/ocaml/issues/9345): reproducible env summaries for reproducible compilation
  (Florian Angeletti, review by Leo White)

- [#9309](https://github.com/ocaml/ocaml/issues/9309), [#9318](https://github.com/ocaml/ocaml/issues/9318): Fix exhaustivity checking with empty types
  (Florian Angeletti, Stefan Muenzel and Thomas Refis, review by Gabriel Scherer
  and Thomas Refis)

- [#9335](https://github.com/ocaml/ocaml/issues/9335): actually have --disable-stdlib-manpages not build the manpages
  (implementation conflicted with [#8837](https://github.com/ocaml/ocaml/issues/8837) which wasn't picked up in review)
  (David Allsopp, review by Florian Angeletti and Sébastien Hinderer)

- [#9343](https://github.com/ocaml/ocaml/issues/9343): Re-enable `-short-paths` for some error messages
  (Leo White, review by Florian Angeletti)

- [#9355](https://github.com/ocaml/ocaml/issues/9355), [#9356](https://github.com/ocaml/ocaml/issues/9356): ocamldebug, fix a fatal error when printing values
  whose type involves a functor application.
  (Florian Angeletti, review by Gabriel Scherer, report by Cyril Six)

- [#9367](https://github.com/ocaml/ocaml/issues/9367): Make bytecode and native-code backtraces agree.
  (Stephen Dolan, review by Gabriel Scherer)

- [#9375](https://github.com/ocaml/ocaml/issues/9375), [#9477](https://github.com/ocaml/ocaml/issues/9477): add forgotten substitution when compiling anonymous modules
  (Thomas Refis, review by Frédéric Bour, report by Andreas Hauptmann)

- [#9384](https://github.com/ocaml/ocaml/issues/9384), [#9385](https://github.com/ocaml/ocaml/issues/9385): Fix copy scope bugs in substitutions
  (Leo White, review by Thomas Refis, report by Nick Roberts)

* \\[*breaking change*\\] [#9388](https://github.com/ocaml/ocaml/issues/9388): Prohibit signature local types with constraints
  (Leo White, review by Jacques Garrigue)

- [#9406](https://github.com/ocaml/ocaml/issues/9406), [#9409](https://github.com/ocaml/ocaml/issues/9409): fix an error with packed module types from missing
  cmis.
  (Florian Angeletti, report by Thomas Leonard, review by Gabriel Radanne
   and Gabriel Scherer)

- [#9415](https://github.com/ocaml/ocaml/issues/9415): Treat `open struct` as `include struct` in toplevel
  (Leo White, review by Thomas Refis)

- [#9416](https://github.com/ocaml/ocaml/issues/9416): Avoid warning 58 in flambda ocamlnat
  (Leo White, review by Florian Angeletti)

- [#9420](https://github.com/ocaml/ocaml/issues/9420): Fix memory leak when `caml_output_value_to_block` raises an exception
  (Xavier Leroy, review by Guillaume Munch-Maccagnoni)

- [#9428](https://github.com/ocaml/ocaml/issues/9428): Fix truncated exception backtrace for C->OCaml callbacks
  on Power and Z System
  (Xavier Leroy, review by Nicolás Ojeda Bär)

- [#9623](https://github.com/ocaml/ocaml/issues/9623), [#9642](https://github.com/ocaml/ocaml/issues/9642): fix typing environments in Typedecl.transl_with_constraint
  (Gabriel Scherer, review by Jacques Garrigue and Leo White,
   report by Hugo Heuzard)

- [#9695](https://github.com/ocaml/ocaml/issues/9695), [#9702](https://github.com/ocaml/ocaml/issues/9702): no error when opening an alias to a missing module
  (Jacques Garrigue, report and review by Gabriel Scherer)

- [#9714](https://github.com/ocaml/ocaml/issues/9714), [#9724](https://github.com/ocaml/ocaml/issues/9724): Add a terminator to the `caml_domain_state` structure
  to better ensure that members are correctly spaced.
  (Antonin Décimo, review by David Allsopp and Xavier Leroy)
|js}
  ; body_html = {js|<h2>Opam switches</h2>
<p>This release is available as multiple
<a href="https://opam.ocaml.org/doc/Usage.html">OPAM</a> switches:</p>
<ul>
<li>
<p>4.11.0 — Official release 4.11.0</p>
</li>
<li>
<p>4.11.0+flambda — Official release 4.11.0, with flambda activated</p>
</li>
<li>
<p>4.11.0+afl — Official release 4.11.0, with afl-fuzz instrumentation</p>
</li>
<li>
<p>4.11.0+spacetime - Official 4.11.0 release with spacetime activated</p>
</li>
<li>
<p>4.11.0+default-unsafe-string — Official release 4.11.0, without
safe strings by default</p>
</li>
<li>
<p>4.11.0+no-flat-float-array - Official release 4.11.0, with
--disable-flat-float-array</p>
</li>
<li>
<p>4.11.0+flambda+no-flat-float-array — Official release 4.11.0, with
flambda activated and --disable-flat-float-array</p>
</li>
<li>
<p>4.11.0+fp — Official release 4.11.0, with frame-pointers</p>
</li>
<li>
<p>4.11.0+fp+flambda — Official release 4.11.0, with frame-pointers
and flambda activated</p>
</li>
<li>
<p>4.11.0+musl+static+flambda - Official release 4.11.0, compiled with
musl-gcc -static and with flambda activated</p>
</li>
<li>
<p>4.11.0+32bit - Official release 4.11.0, compiled in 32-bit mode
for 64-bit Linux and OS X hosts</p>
</li>
<li>
<p>4.11.0+bytecode-only - Official release 4.11.0, without the
native-code compiler</p>
</li>
</ul>
<h2>What's new</h2>
<p>Some of the highlights in release 4.11 are:</p>
<ul>
<li>Statmemprof: a new statistical memory profiler
</li>
<li>A new instrumented runtime that logs runtime statistics in a standard format
</li>
<li>A native backend for the RISC-V architecture
</li>
<li>Improved backtraces that refer to function names
</li>
<li>Suppport for recursive and yet unboxed types
</li>
<li>A quoted extension syntax for ppxs.
</li>
<li>Many quality of life improvements
</li>
<li>Many bug fixes.
</li>
</ul>
<p>For a comprehensive list of changes and details on all new features,
bug fixes, optimizations, etc., please consult the
<a href="#Changes">changelog</a>.</p>
<h2>Source distribution</h2>
<ul>
<li><a href="https://github.com/ocaml/ocaml/archive/4.11.0.tar.gz">Source
tarball</a>
(.tar.gz) for compilation under Unix (including Linux and MacOS X)
and Microsoft Windows (including Cygwin).
</li>
<li>Also available in
<a href="https://github.com/ocaml/ocaml/archive/4.11.0.zip">.zip</a>
format.
</li>
<li><a href="https://opam.ocaml.org/">OPAM</a> is a source-based distribution of
OCaml and many companion libraries and tools. Compilation and
installation are automated by powerful package managers.
</li>
<li>The official development repo is hosted on
<a href="https://github.com/ocaml/ocaml">GitHub</a>.
</li>
</ul>
<p>The
<a href="4.11/notes/INSTALL.adoc">INSTALL</a> file
of the distribution provides detailed compilation and installation
instructions — see also the <a href="4.11/notes/README.win32.adoc">Windows release
notes</a> for
instructions on how to build under Windows.</p>
<h2>Alternative Compilers</h2>
<p>Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:</p>
<ul>
<li><a href="http://ocsigen.org/js_of_ocaml/">Js_of_ocaml</a> is a stable OCaml
to JavaScript compiler.
</li>
<li><a href="http://bucklescript.github.io/bucklescript/">Bucklescript</a> is a
newer OCaml to JavaScript compiler. See its
<a href="https://github.com/bucklescript/bucklescript/wiki/Differences-from-js_of_ocaml">wiki</a> for
an explanation of how it differs from <code>js_of_ocaml</code>.
</li>
<li><a href="http://www.ocamljava.org/">OCaml-java</a> is a stable OCaml to
Java compiler.
</li>
</ul>
<h2>User's manual</h2>
<p>The user's manual for OCaml can be:</p>
<ul>
<li><a href="4.11/htmlman/index.html">browsed
online</a>,
</li>
<li>downloaded as a single
<a href="4.11/ocaml-4.11-refman.pdf">PDF</a>,
or <a href="4.11/ocaml-4.11-refman.txt">plain
text</a>
document,
</li>
<li>downloaded as a single
<a href="4.11/ocaml-4.11-refman-html.tar.gz">TAR</a>
or
<a href="4.11/ocaml-4.11-refman-html.zip">ZIP</a>
archive of HTML files,
</li>
<li>downloaded as a single
<a href="4.11/ocaml-4.11-refman.info.tar.gz">tarball</a>
of Emacs info files,
</li>
</ul>
<h2>Changes</h2>
<p>This is the
<a href="4.11/notes/Changes">changelog</a>.
(Changes that can break existing programs are marked with a  &quot;*breaking change&quot; warning)</p>
<h3>Runtime system:</h3>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/9096">#9096</a>: Print function names in backtraces.
Old output:
</li>
</ul>
<pre><code>Called from file &quot;foo.ml&quot;, line 16, characters 42-53
</code></pre>
<p>New output:</p>
<pre><code>Called from Foo.bar in file &quot;foo.ml&quot;, line 16, characters 42-53
</code></pre>
<p>(Stephen Dolan, review by Leo White and Mark Shinwell)</p>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9082">#9082</a>: The instrumented runtime now records logs in the CTF format.
A new API is available in the runtime to collect runtime statistics,
replacing the previous instrumented runtime macros.
Gc.eventlog_pause and Gc.eventlog_resume were added to allow user to control
instrumentation in a running program.
See the manual for more information on how to use this instrumentation mode.
(Enguerrand Decorne and Stephen Dolan, with help and review from
David Allsopp, Sébastien Hinderer, review by Anil Madhavapeddy,
Nicolás Ojeda Bär, Shakthi Kannan, KC Sivaramakrishnan, Gabriel Scherer,
Guillaume Munch-Maccagnoni, Damien Doligez, Leo White, Daniel Bünzli
and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9230">#9230</a>, <a href="https://github.com/ocaml/ocaml/issues/9362">#9362</a>: Memprof support for native allocations.
(Jacques-Henri Jourdan and Stephen Dolan, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8920">#8920</a>, <a href="https://github.com/ocaml/ocaml/issues/9238">#9238</a>, <a href="https://github.com/ocaml/ocaml/issues/9239">#9239</a>, <a href="https://github.com/ocaml/ocaml/issues/9254">#9254</a>, <a href="https://github.com/ocaml/ocaml/issues/9458">#9458</a>: New API for statistical memory profiling
in Memprof.Gc. The new version does no longer use ephemerons and allows
registering callbacks for promotion and deallocation of memory
blocks.
The new API no longer gives the block tags to the allocation callback.
(Stephen Dolan and Jacques-Henri Jourdan, review by Damien Doligez
and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9353">#9353</a>: Reimplement <code>output_value</code> and the <code>Marshal.to_*</code> functions
using a hash table to detect sharing, instead of temporary in-place
modifications.  This is a prerequisite for Multicore OCaml.
(Xavier Leroy and Basile Clément, review by Gabriel Scherer and
Stephen Dolan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9119">#9119</a>: Make [caml_stat_resize_noexc] compatible with the [realloc]
API when the old block is NULL.
(Jacques-Henri Jourdan, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9233">#9233</a>: Restore the bytecode stack after an allocation.
(Stephen Dolan, review by Gabriel Scherer and Jacques-Henri Jourdan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9249">#9249</a>: restore definition of ARCH_ALIGN_INT64 in m.h if the architecture
requires 64-bit integers to be double-word aligned (autoconf regression)
(David Allsopp, review by Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9259">#9259</a>: Made <code>Ephemeron.blit_key</code> and <code>Weak.blit</code> faster. They are now
linear in the size of the range being copied instead of depending on the
total sizes of the ephemerons or weak arrays involved.
(Arseniy Alekseyev, design advice by Leo White, review by François Bobot
and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9279">#9279</a>: Memprof optimisation.
(Stephen Dolan, review by Jacques-Henri Jourdan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9280">#9280</a>: Micro-optimise allocations on amd64 to save a register.
(Stephen Dolan, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9426">#9426</a>: build the Mingw ports with higher levels of GCC optimization
(Xavier Leroy, review by Sébastien Hinderer)</p>
</li>
</ul>
<ul>
<li>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/9483">#9483</a>: Remove accidental inclusion of &lt;stdio.h&gt; in &lt;caml/misc.h&gt;
The only release with the inclusion of stdio.h has been 4.10.0
(Christopher Zimmermann, review by Xavier Leroy and David Allsopp)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9282">#9282</a>: Make Cconst_symbol have typ_int to fix no-naked-pointers mode.
(Stephen Dolan, review by Mark Shinwell, Xavier Leroy and Vincent Laviron)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9497">#9497</a>: Harmonise behaviour between bytecode and native code for
recursive module initialisation in one particular case (fixes <a href="https://github.com/ocaml/ocaml/issues/9494">#9494</a>).
(Mark Shinwell, David Allsopp, Vincent Laviron, Xavier Leroy,
Geoff Reedy, original bug report by Arlen Cox)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8791">#8791</a>: use a variable-length encoding when marshalling bigarray dimensions,
avoiding overflow.
(Jeremy Yallop, Stephen Dolan, review by Xavier Leroy)</p>
</li>
</ul>
<h3>Code generation and optimizations:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9441">#9441</a>: Add RISC-V RV64G native-code backend.
(Nicolás Ojeda Bär, review by Xavier Leroy and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9316">#9316</a>, <a href="https://github.com/ocaml/ocaml/issues/9443">#9443</a>, <a href="https://github.com/ocaml/ocaml/issues/9463">#9463</a>, <a href="https://github.com/ocaml/ocaml/issues/9782">#9782</a>: Use typing information from Clambda
for mutable Cmm variables.
(Stephen Dolan, review by Vincent Laviron, Guillaume Bury, Xavier Leroy,
and Gabriel Scherer; temporary bug report by Richard Jones)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8637">#8637</a>, <a href="https://github.com/ocaml/ocaml/issues/8805">#8805</a>, <a href="https://github.com/ocaml/ocaml/issues/9247">#9247</a>, <a href="https://github.com/ocaml/ocaml/issues/9296">#9296</a>: Record debug info for each allocation.
(Stephen Dolan and Jacques-Henri Jourdan, review by Damien Doligez,
KC Sivaramakrishnan and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9193">#9193</a>: Make tuple matching optimisation apply to Lswitch and Lstringswitch.
(Stephen Dolan, review by Thomas Refis and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9392">#9392</a>: Visit registers at most once in Coloring.iter_preferred.
(Stephen Dolan, review by Pierre Chambart and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9549">#9549</a>, <a href="https://github.com/ocaml/ocaml/issues/9557">#9557</a>: Make -flarge-toc the default for PowerPC and introduce
-fsmall-toc to enable the previous behaviour.
(David Allsopp, report by Nathaniel Wesley Filardo, review by Xavier Leroy)</p>
</li>
</ul>
<h3>Language features</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8820">#8820</a>, <a href="https://github.com/ocaml/ocaml/issues/9166">#9166</a>: quoted extensions: {%foo|...|} is lighter syntax for
[%foo {||}], and {%foo bar|...|bar} for [%foo {bar|...|bar}].
(Gabriel Radanne, Leo White, Gabriel Scherer and Pieter Goetschalckx,
request by Bikal Lem)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7364">#7364</a>, <a href="https://github.com/ocaml/ocaml/issues/2188">#2188</a>, <a href="https://github.com/ocaml/ocaml/issues/9592">#9592</a>, <a href="https://github.com/ocaml/ocaml/issues/9609">#9609</a>: improvement of the unboxability check for types
with a single constructor. Mutually-recursive type declarations can
now contain unboxed types. This is based on the paper
https://arxiv.org/abs/1811.02300
(Gabriel Scherer and Rodolphe Lepigre,
review by Jeremy Yallop, Damien Doligez and Frédéric Bour)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/1154">#1154</a>, <a href="https://github.com/ocaml/ocaml/issues/1706">#1706</a>: spellchecker hints and type-directed disambiguation
for extensible sum type constructors
(Florian Angeletti, review by Alain Frisch, Gabriel Radanne, Gabriel Scherer
and Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/6673">#6673</a>, <a href="https://github.com/ocaml/ocaml/issues/1132">#1132</a>, <a href="https://github.com/ocaml/ocaml/issues/9617">#9617</a>: Relax the handling of explicit polymorphic types.
This improves error messages in some polymorphic recursive definition,
and requires less polymorphic annotations in some cases of
mutually-recursive definitions involving polymorphic recursion.
(Leo White, review by Jacques Garrigue and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9232">#9232</a>: allow any class type paths in #-types,
For instance, &quot;val f: #F(X).t -&gt; unit&quot; is now allowed.
(Florian Angeletti, review by Gabriel Scherer, suggestion by Leo White)</p>
</li>
</ul>
<h3>Standard library:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9077">#9077</a>: Add Seq.cons and Seq.append
(Sébastien Briais, review by Yawar Amin and Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9235">#9235</a>: Add Array.exists2 and Array.for_all2
(Bernhard Schommer, review by Armaël Guéneau)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9226">#9226</a>: Add Seq.unfold.
(Jeremy Yallop, review by Hezekiah M. Carty, Gabriel Scherer and
Gabriel Radanne)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9059">#9059</a>: Added List.filteri function, same as List.filter but
with the index of the element.
(Léo Andrès, review by Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8894">#8894</a>: Added List.fold_left_map function combining map and fold.
(Bernhard Schommer, review by Alain Frisch and github user @cfcs)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9365">#9365</a>: Set.filter_map and Map.filter_map
(Gabriel Scherer, review by Stephen Dolan and Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9248">#9248</a>: Add Printexc.default_uncaught_exception_handler
(Raphael Sousa Santos, review by Daniel Bünzli)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8771">#8771</a>: Lexing: add set_position and set_filename to change (fake)
the initial tracking position of the lexbuf.
(Konstantin Romanov, Miguel Lumapat, review by Gabriel Scherer,
Sébastien Hinderer, and David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9237">#9237</a>: <code>Format.pp_update_geometry ppf (fun geo -&gt; {geo with ...})</code>
for formatter geometry changes that are robust to new geometry fields.
(Gabriel Scherer, review by Josh Berdine and Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7110">#7110</a>: Added Printf.ikbprintf and Printf.ibprintf
(Muskan Garg, review by Gabriel Scherer and Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9266">#9266</a>: Install pretty-printer for the exception Fun.Finally_raised.
(Guillaume Munch-Maccagnoni, review by Daniel Bünzli, Gabriel Radanne,
and Gabriel Scherer)</p>
</li>
</ul>
<h3>Other libraries:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9106">#9106</a>: Register printer for Unix_error in win32unix, as in unix.
(Christopher Zimmermann, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9183">#9183</a>: Preserve exception backtrace of exceptions raised by top-level phrases
of dynlinked modules.
(Nicolás Ojeda Bär, review by Xavier Clerc and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9320">#9320</a>, <a href="https://github.com/ocaml/ocaml/issues/9550">#9550</a>: under Windows, make sure that the Unix.exec* functions
properly quote their argument lists.
(Xavier Leroy, report by André Maroneze, review by Nicolás Ojeda Bär
and David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9490">#9490</a>, <a href="https://github.com/ocaml/ocaml/issues/9505">#9505</a>: ensure proper rounding of file times returned by
Unix.stat, Unix.lstat, Unix.fstat.
(Xavier Leroy and Guillaume Melquiond, report by David Brown,
review by Gabriel Scherer and David Allsopp)</p>
</li>
</ul>
<h3>Tools:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9283">#9283</a>, <a href="https://github.com/ocaml/ocaml/issues/9455">#9455</a>, <a href="https://github.com/ocaml/ocaml/issues/9457">#9457</a>: add a new toplevel directive <code>#use_output &quot;&lt;command&gt;&quot;</code> to
run a command and evaluate its output.
(Jérémie Dimino, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/6969">#6969</a>: Argument -nocwd added to ocamldep
(Muskan Garg, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8676">#8676</a>, <a href="https://github.com/ocaml/ocaml/issues/9594">#9594</a>: turn debugger off in programs launched by the program
being debugged
(Xavier Leroy, report by Michael Soegtrop, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9057">#9057</a>: aid debugging the debugger by preserving backtraces of unhandled
exceptions.
(David Allsopp, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9276">#9276</a>: objinfo: cm[x]a print extra C options, objects and dlls in
the order given on the cli. Follow up to <a href="https://github.com/ocaml/ocaml/issues/4949">#4949</a>.
(Daniel Bünzli, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/463">#463</a>: objinfo: better errors on object files coming
from a different (older or newer), incompatible compiler version.
(Gabriel Scherer, review by Gabriel Radanne and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9181">#9181</a>: make objinfo work on Cygwin and look for the caml_plugin_header
symbol in both the static and the dynamic symbol tables.
(Sébastien Hinderer, review by Gabriel Scherer and David Allsopp)</p>
</li>
</ul>
<ul>
<li>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/9197">#9197</a>: remove compatibility logic from <a href="https://github.com/ocaml/ocaml/issues/244">#244</a> that was designed to
synchronize toplevel printing margins with Format.std_formatter,
but also resulted in unpredictable/fragile changes to formatter
margins.
Setting the margins on the desired formatters should now work.
typically on <code>Format.std_formatter</code>.
Note that there currently is no robust way to do this from the
toplevel, as applications may redirect toplevel printing. In
a compiler/toplevel driver, one should instead access
<code>Location.formatter_for_warnings</code>; it is not currently exposed
to the toplevel.
(Gabriel Scherer, review by Armaël Guéneau)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9207">#9207</a>, <a href="https://github.com/ocaml/ocaml/issues/9210">#9210</a>: fix ocamlyacc to work correctly with up to 255 entry
points to the grammar.
(Andreas Abel, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9482">#9482</a>, <a href="https://github.com/ocaml/ocaml/issues/9492">#9492</a>: use diversions (@file) to work around OS limitations
on length of Sys.command argument.
(Xavier Leroy, report by Jérémie Dimino, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9552">#9552</a>: restore ocamloptp build and installation
(Florian Angeletti, review by David Allsopp and Xavier Leroy)</p>
</li>
</ul>
<h3>Manual and documentation:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9141">#9141</a>: beginning of the ocamltest reference manual
(Sébastien Hinderer, review by Gabriel Scherer and Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9228">#9228</a>: Various Map documentation improvements: add missing key argument in
the 'merge' example; clarify the relationship between input and output keys
in 'union'; note that find and find_opt return values, not bindings.
(Jeremy Yallop, review by Gabriel Scherer and Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9255">#9255</a>, <a href="https://github.com/ocaml/ocaml/issues/9300">#9300</a>: reference chapter, split the expression grammar
(Florian Angeletti, report by Harrison Ainsworth, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9325">#9325</a>: documented base case for <code>List.for_all</code> and <code>List.exists</code>
(Glenn Slotte, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9410">#9410</a>, <a href="https://github.com/ocaml/ocaml/issues/9422">#9422</a>: replaced naive fibonacci example with gcd
(Anukriti Kumar, review by San Vu Ngoc, Florian Angeletti, Léo Andrès)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9541">#9541</a>: Add a documentation page for the instrumented runtime;
additional changes to option names in the instrumented runtime.
(Enguerrand Decorne, review by Anil Madhavapeddy, Gabriel Scherer,
Daniel Bünzli, David Allsopp, Florian Angeletti,
and Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9610">#9610</a>: manual, C FFI: naked pointers are deprecated, detail the
forward-compatible options for handling out-of-heap pointers.
(Xavier Leroy, review by Mark Shinwell, David Allsopp and Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9618">#9618</a>: clarify the Format documentation on the margin and maximum indentation
limit
(Florian Angeletti, review by Josh Berdine)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8644">#8644</a>: fix formatting comment about @raise in stdlib's mli files
(Élie Brami, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9327">#9327</a>, <a href="https://github.com/ocaml/ocaml/issues/9401">#9401</a>: manual, fix infix attribute examples
(Florian Angeletti, report by David Cadé, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9403">#9403</a>: added a description for warning 67 and added a &quot;.&quot; at the end of
warnings for consistency.
(Muskan Garg, review by Gabriel Scherer and Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7708">#7708</a>, <a href="https://github.com/ocaml/ocaml/issues/9580">#9580</a>: Ensure Stdlib documentation index refers to Stdlib.
(Stephen Dolan, review by Florian Angeletti, report by Hannes Mehnert)</p>
</li>
</ul>
<h3>Compiler user-interface and warnings:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9712">#9712</a>: Update the version format to allow &quot;~&quot;.
The new format is &quot;major.minor[.patchlevel][(+|~)additional-info]&quot;,
for instance &quot;4.12.0~beta1+flambda&quot;.
This is a documentation-only change for the 4.11 branch, the new format
will be used starting with the 4.12 branch.
(Florian Angeletti, review by Damien Doligez and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/1664">#1664</a>: make -output-complete-obj link the runtime native c libraries when
building shared libraries like <code>-output-obj</code>.
(Florian Angeletti, review by Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9349">#9349</a>: Support [@inlined hint] attribute.
(Leo White, review by Stephen Dolan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2141">#2141</a>: generate .annot files from cmt data; deprecate -annot.
(Nicolás Ojeda Bär, review by Alain Frisch, Gabriel Scherer and Damien
Doligez)</p>
</li>
</ul>
<ul>
<li>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/7678">#7678</a>, <a href="https://github.com/ocaml/ocaml/issues/8631">#8631</a>: ocamlc -c and ocamlopt -c pass same switches to the C
compiler when compiling .c files (in particular, this means ocamlopt
passes -fPIC on systems requiring it for shared library support).
(David Allsopp, report by Daniel Bünzli, review by Sébastien Hinderer)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9074">#9074</a>: reworded error message for non-regular structural types
(Florian Angeletti, review by Jacques Garrigue and Leo White,
report by Chas Emerick)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8938">#8938</a>: Extend ocamlopt option &quot;-stop-after&quot; to handle &quot;scheduling&quot; argument.
(Greta Yorsh, review by Florian Angeletti and Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8945">#8945</a>, <a href="https://github.com/ocaml/ocaml/issues/9086">#9086</a>: Fix toplevel show directive to work with constructors
(Simon Parry, review by Gabriel Scherer, Jeremy Yallop,
Alain Frisch, Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9107">#9107</a>: improved error message for exceptions in module signature errors
(Gabriel Scherer, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9208">#9208</a>: -dno-locations option to hide source locations (and debug events)
from intermediate-representation dumps (-dfoo).
(Gabriel Scherer, review by Vincent Laviron)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9393">#9393</a>: Improve recursive module usage warnings
(Leo White, review by Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9486">#9486</a>: Fix configuration for the Haiku operating system
(Sylvain Kerjean, review by David Allsopp and Sébastien Hinderer)</p>
</li>
</ul>
<h3>Internal/compiler-libs changes:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9021">#9021</a>: expose compiler Longident.t parsers
(Florian Angeletti, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9452">#9452</a>: Add locations to docstring attributes
(Leo White, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/463">#463</a>: a new Misc.Magic_number module for user-friendly parsing
and validation of OCaml magic numbers.
(Gabriel Scherer, review by Gabriel Radanne and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/1176">#1176</a>: encourage better compatibility with older Microsoft C compilers by
using GCC's -Wdeclaration-after-statement when available. Introduce
Caml_inline to stop abuse of the inline keyword on MSVC and to help ensure
that only static inline is used in the codebase (erroneous instance in
runtime/win32.c removed).
(David Allsopp, review by Oliver Andrieu and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8934">#8934</a>: Stop relying on location to track usage
(Thomas Refis, review by Gabriel Radanne)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8970">#8970</a>: separate value patterns (matching on values) from computation patterns
(matching on the effects of a copmutation) in the typedtree.
(Gabriel Scherer, review by Jacques Garrigue and Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9060">#9060</a>: ensure that Misc.protect_refs preserves backtraces
(Gabriel Scherer, review by Guillaume Munch-Maccagnoni and David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9078">#9078</a>: make all compilerlibs/ available to ocamltest.
(Gabriel Scherer, review by Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9079">#9079</a>: typecore/parmatch: refactor ppat_of_type and refine
the use of backtracking on wildcard patterns
(Florian Angeletti, Jacques Garrigue, Gabriel Scherer,
review by Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9081">#9081</a>: typedtree, make the pat_env field of pattern data immutable
(Gabriel Scherer, review by Jacques Garrigue, report by Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9178">#9178</a>, <a href="https://github.com/ocaml/ocaml/issues/9182">#9182</a>, <a href="https://github.com/ocaml/ocaml/issues/9196">#9196</a>: refactor label-disambiguation (Typecore.NameChoice)
(Gabriel Scherer, Thomas Refis, Florian Angeletti and Jacques Garrigue,
reviewing each other without self-loops)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9321">#9321</a>, <a href="https://github.com/ocaml/ocaml/issues/9322">#9322</a>, <a href="https://github.com/ocaml/ocaml/issues/9359">#9359</a>, <a href="https://github.com/ocaml/ocaml/issues/9361">#9361</a>, <a href="https://github.com/ocaml/ocaml/issues/9417">#9417</a>, <a href="https://github.com/ocaml/ocaml/issues/9447">#9447</a>: refactor the
pattern-matching compiler
(Thomas Refis and Gabriel Scherer, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9211">#9211</a>, <a href="https://github.com/ocaml/ocaml/issues/9215">#9215</a>, <a href="https://github.com/ocaml/ocaml/issues/9222">#9222</a>: fix Makefile dependencies in
compilerlibs, dynlink, ocamltest.
(Gabriel Scherer, review by Vincent Laviron and David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9305">#9305</a>: Avoid polymorphic compare in Ident
(Leo White, review by Xavier Leroy and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7927">#7927</a>: refactor val_env met_env par_env to class_env
(Muskan Garg, review by Gabriel Scherer and Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2324">#2324</a>, <a href="https://github.com/ocaml/ocaml/issues/9613">#9613</a>: Replace the caml_int_compare and caml_float_compare
(C functions) with primitives.
(Greta Yorsh, review by Stephen Dolan and Vincent Laviron)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9246">#9246</a>: Avoid rechecking functor applications
(Leo White, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9402">#9402</a>: Remove <code>sudo:false</code> from .travis.yml
(Hikaru Yoshimura)</p>
</li>
</ul>
<ul>
<li>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/9411">#9411</a>: forbid optional arguments reordering with -nolabels
(Thomas Refis, review by Frédéric Bour and Jacques Garrigue)
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/9414">#9414</a>: testsuite, ocamltest: keep test artifacts only on failure.
Use KEEP_TEST_DIR_ON_SUCCESS=1 to keep all artifacts.
(Gabriel Scherer, review by Sébastien Hinderer)
</li>
</ul>
<h3>Build system:</h3>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/9250">#9250</a>: Add --disable-ocamltest to configure and disable building for
non-development builds.
(David Allsopp, review by Sébastien Hinderer)
</li>
</ul>
<h3>Bug fixes:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7520">#7520</a>, <a href="https://github.com/ocaml/ocaml/issues/9547">#9547</a>: Odd behaviour of refutation cases with polymorphic variants
(Jacques Garrigue, report by Leo White, reviews by Gabriel Scherer and Leo)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7562">#7562</a>, <a href="https://github.com/ocaml/ocaml/issues/9456">#9456</a>: ocamlopt-generated code crashed on Alpine Linux on
ppc64le, arm, and i386.  Fixed by turning PIE off for musl-based Linux
systems except amd64 (x86_64) and s390x.
(Xavier Leroy, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7683">#7683</a>, <a href="https://github.com/ocaml/ocaml/issues/1499">#1499</a>: Fixes one case where the evaluation order in native-code
may not match the one in bytecode.
(Nicolás Ojeda Bär, report by Pierre Chambart, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7696">#7696</a>, <a href="https://github.com/ocaml/ocaml/issues/6608">#6608</a>: Record expression deleted when all fields specified
(Jacques Garrigue, report by Jeremy Yallop)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7741">#7741</a>, <a href="https://github.com/ocaml/ocaml/issues/9645">#9645</a>: Failure to report escaping type variable
(Jacques Garrigue, report by Gabriel Radanne, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7817">#7817</a>, <a href="https://github.com/ocaml/ocaml/issues/9546">#9546</a>: Unsound inclusion check for polymorphic variant
(Jacques Garrigue, report by Mikhail Mandrykin, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7897">#7897</a>, <a href="https://github.com/ocaml/ocaml/issues/9537">#9537</a>: Fix warning 38 for rebound extension constructors
(Leo White, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7917">#7917</a>, <a href="https://github.com/ocaml/ocaml/issues/9426">#9426</a>: Use GCC option -fexcess-precision=standard when available,
avoiding a problem with x87 excess precision in Float.round.
(Xavier Leroy, review by Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9011">#9011</a>: Allow linking .cmxa files with no units on MSVC by not requiring the
.lib file to be present.
(David Allsopp, report by Dimitry Bely, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9064">#9064</a>: Relax the level handling when unifying row fields
(Leo White, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9097">#9097</a>: Do not emit references to dead labels introduced by <a href="https://github.com/ocaml/ocaml/issues/2321">#2321</a> (spacetime).
(Greta Yorsh, review by Mark Shinwell)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9163">#9163</a>: Treat loops properly in un_anf
(Leo White, review by Mark Shinwell, Pierre Chambart and Vincent Laviron)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9189">#9189</a>, <a href="https://github.com/ocaml/ocaml/issues/9281">#9281</a>: fix a conflict with Gentoo build system
by removing an one-letter Makefile variable.
(Florian Angeletti, report by Ralph Seichter, review by David Allsopp
and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9225">#9225</a>: Do not drop bytecode debug info after C calls.
(Stephen Dolan, review by Gabriel Scherer and Jacques-Henri Jourdan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9231">#9231</a>: Make sure a debug event (and the corresponding debug
information) is inserted after every primitive that can appear in a
collected call stack, and make sure ocamlc preserves such events
even if they are at tail position.
(Jacques-Henri Jourdan, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9244">#9244</a>: Fix some missing usage warnings
(Leo White, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9274">#9274</a>, avoid reading cmi file while printing types
(Florian Angeletti, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9307">#9307</a>, <a href="https://github.com/ocaml/ocaml/issues/9345">#9345</a>: reproducible env summaries for reproducible compilation
(Florian Angeletti, review by Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9309">#9309</a>, <a href="https://github.com/ocaml/ocaml/issues/9318">#9318</a>: Fix exhaustivity checking with empty types
(Florian Angeletti, Stefan Muenzel and Thomas Refis, review by Gabriel Scherer
and Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9335">#9335</a>: actually have --disable-stdlib-manpages not build the manpages
(implementation conflicted with <a href="https://github.com/ocaml/ocaml/issues/8837">#8837</a> which wasn't picked up in review)
(David Allsopp, review by Florian Angeletti and Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9343">#9343</a>: Re-enable <code>-short-paths</code> for some error messages
(Leo White, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9355">#9355</a>, <a href="https://github.com/ocaml/ocaml/issues/9356">#9356</a>: ocamldebug, fix a fatal error when printing values
whose type involves a functor application.
(Florian Angeletti, review by Gabriel Scherer, report by Cyril Six)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9367">#9367</a>: Make bytecode and native-code backtraces agree.
(Stephen Dolan, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9375">#9375</a>, <a href="https://github.com/ocaml/ocaml/issues/9477">#9477</a>: add forgotten substitution when compiling anonymous modules
(Thomas Refis, review by Frédéric Bour, report by Andreas Hauptmann)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9384">#9384</a>, <a href="https://github.com/ocaml/ocaml/issues/9385">#9385</a>: Fix copy scope bugs in substitutions
(Leo White, review by Thomas Refis, report by Nick Roberts)</p>
</li>
</ul>
<ul>
<li>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/9388">#9388</a>: Prohibit signature local types with constraints
(Leo White, review by Jacques Garrigue)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9406">#9406</a>, <a href="https://github.com/ocaml/ocaml/issues/9409">#9409</a>: fix an error with packed module types from missing
cmis.
(Florian Angeletti, report by Thomas Leonard, review by Gabriel Radanne
and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9415">#9415</a>: Treat <code>open struct</code> as <code>include struct</code> in toplevel
(Leo White, review by Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9416">#9416</a>: Avoid warning 58 in flambda ocamlnat
(Leo White, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9420">#9420</a>: Fix memory leak when <code>caml_output_value_to_block</code> raises an exception
(Xavier Leroy, review by Guillaume Munch-Maccagnoni)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9428">#9428</a>: Fix truncated exception backtrace for C-&gt;OCaml callbacks
on Power and Z System
(Xavier Leroy, review by Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9623">#9623</a>, <a href="https://github.com/ocaml/ocaml/issues/9642">#9642</a>: fix typing environments in Typedecl.transl_with_constraint
(Gabriel Scherer, review by Jacques Garrigue and Leo White,
report by Hugo Heuzard)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9695">#9695</a>, <a href="https://github.com/ocaml/ocaml/issues/9702">#9702</a>: no error when opening an alias to a missing module
(Jacques Garrigue, report and review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9714">#9714</a>, <a href="https://github.com/ocaml/ocaml/issues/9724">#9724</a>: Add a terminator to the <code>caml_domain_state</code> structure
to better ensure that members are correctly spaced.
(Antonin Décimo, review by David Allsopp and Xavier Leroy)</p>
</li>
</ul>
|js}
  };
 
  { kind = `Compiler
  ; version = {js|4.09.1|js}
  ; date = {js|2020-03-16|js}
  ; intro_md = {js|This page describe OCaml **4.09.1**, released on Mar 16, 2020.  It is a bug-fix release of [OCaml 4.09.0](/releases/4.09.0).
|js}
  ; intro_html = {js|<p>This page describe OCaml <strong>4.09.1</strong>, released on Mar 16, 2020.  It is a bug-fix release of <a href="/releases/4.09.0">OCaml 4.09.0</a>.</p>
|js}
  ; highlights_md = {js|- Bug fixes for 4.09.0
|js}
  ; highlights_html = {js|<ul>
<li>Bug fixes for 4.09.0
</li>
</ul>
|js}
  ; body_md = {js|
### Bug fixes:

- [#8855](https://github.com/ocaml/ocaml/issues/8855), [#8858](https://github.com/ocaml/ocaml/issues/8858): Links for tools not created when installing with
  --disable-installing-byecode-programs (e.g. ocamldep.opt installed, but
  ocamldep link not created)
  (David Allsopp, report by Thomas Leonard)

- [#8947](https://github.com/ocaml/ocaml/issues/8947), [#9134](https://github.com/ocaml/ocaml/issues/9134), [#9302](https://github.com/ocaml/ocaml/issues/9302): fix/improve support for the BFD library
  (Sébastien Hinderer, review by Damien Doligez and David Allsopp)

- [#8953](https://github.com/ocaml/ocaml/issues/8953), [#8954](https://github.com/ocaml/ocaml/issues/8954): Fix error submessages in the toplevel: do not display
  dummy locations
  (Armaël Guéneau, review by Gabriel Scherer)

- [#8965](https://github.com/ocaml/ocaml/issues/8965), [#8979](https://github.com/ocaml/ocaml/issues/8979): Alpine build failure caused by check-parser-uptodate-or-warn.sh
  (Gabriel Scherer and David Allsopp, report by Anton Kochkov)

- [#8985](https://github.com/ocaml/ocaml/issues/8985), [#8986](https://github.com/ocaml/ocaml/issues/8986): fix generation of the primitives when the locale collation is
  incompatible with C.
  (David Allsopp, review by Nicolás Ojeda Bär, report by Sebastian Rasmussen)

- [#9050](https://github.com/ocaml/ocaml/issues/9050), [#9076](https://github.com/ocaml/ocaml/issues/9076): install missing compilerlibs/ocamlmiddleend archives
  (Gabriel Scherer, review by Florian Angeletti, report by Olaf Hering)

- [#9073](https://github.com/ocaml/ocaml/issues/9073), [#9120](https://github.com/ocaml/ocaml/issues/9120): fix incorrect GC ratio multiplier when allocating custom blocks
  with caml_alloc_custom_mem in runtime/custom.c
  (Markus Mottl, review by Gabriel Scherer and Damien Doligez)

- [#9144](https://github.com/ocaml/ocaml/issues/9144), [#9180](https://github.com/ocaml/ocaml/issues/9180): multiple definitions of global variables in the C runtime,
  causing problems with GCC 10.0 and possibly with other C compilers
  (Xavier Leroy, report by Jürgen Reuter, review by Mark Shinwell)

- [#9180](https://github.com/ocaml/ocaml/issues/9180): pass -fno-common option to C compiler when available,
  so as to detect problematic multiple definitions of global variables
  in the C runtime
  (Xavier Leroy, review by Mark Shinwell)

- [#9128](https://github.com/ocaml/ocaml/issues/9128): Fix a bug in bytecode mode which could lead to a segmentation
  fault. The bug was caused by the fact that the atom table shared a
  page with some bytecode. The fix makes sure both the atom table and
  the minor heap have their own pages.
  (Jacques-Henri Jourdan, review by Stephen Dolan, Xavier Leroy and
   Gabriel Scherer)
|js}
  ; body_html = {js|<h3>Bug fixes:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8855">#8855</a>, <a href="https://github.com/ocaml/ocaml/issues/8858">#8858</a>: Links for tools not created when installing with
--disable-installing-byecode-programs (e.g. ocamldep.opt installed, but
ocamldep link not created)
(David Allsopp, report by Thomas Leonard)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8947">#8947</a>, <a href="https://github.com/ocaml/ocaml/issues/9134">#9134</a>, <a href="https://github.com/ocaml/ocaml/issues/9302">#9302</a>: fix/improve support for the BFD library
(Sébastien Hinderer, review by Damien Doligez and David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8953">#8953</a>, <a href="https://github.com/ocaml/ocaml/issues/8954">#8954</a>: Fix error submessages in the toplevel: do not display
dummy locations
(Armaël Guéneau, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8965">#8965</a>, <a href="https://github.com/ocaml/ocaml/issues/8979">#8979</a>: Alpine build failure caused by check-parser-uptodate-or-warn.sh
(Gabriel Scherer and David Allsopp, report by Anton Kochkov)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8985">#8985</a>, <a href="https://github.com/ocaml/ocaml/issues/8986">#8986</a>: fix generation of the primitives when the locale collation is
incompatible with C.
(David Allsopp, review by Nicolás Ojeda Bär, report by Sebastian Rasmussen)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9050">#9050</a>, <a href="https://github.com/ocaml/ocaml/issues/9076">#9076</a>: install missing compilerlibs/ocamlmiddleend archives
(Gabriel Scherer, review by Florian Angeletti, report by Olaf Hering)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9073">#9073</a>, <a href="https://github.com/ocaml/ocaml/issues/9120">#9120</a>: fix incorrect GC ratio multiplier when allocating custom blocks
with caml_alloc_custom_mem in runtime/custom.c
(Markus Mottl, review by Gabriel Scherer and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9144">#9144</a>, <a href="https://github.com/ocaml/ocaml/issues/9180">#9180</a>: multiple definitions of global variables in the C runtime,
causing problems with GCC 10.0 and possibly with other C compilers
(Xavier Leroy, report by Jürgen Reuter, review by Mark Shinwell)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9180">#9180</a>: pass -fno-common option to C compiler when available,
so as to detect problematic multiple definitions of global variables
in the C runtime
(Xavier Leroy, review by Mark Shinwell)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9128">#9128</a>: Fix a bug in bytecode mode which could lead to a segmentation
fault. The bug was caused by the fact that the atom table shared a
page with some bytecode. The fix makes sure both the atom table and
the minor heap have their own pages.
(Jacques-Henri Jourdan, review by Stephen Dolan, Xavier Leroy and
Gabriel Scherer)</p>
</li>
</ul>
|js}
  };
 
  { kind = `Compiler
  ; version = {js|4.10.0|js}
  ; date = {js|2020-02-21|js}
  ; intro_md = {js|This page describes OCaml version **4.10.0**, released on 2020-02-21. 
|js}
  ; intro_html = {js|<p>This page describes OCaml version <strong>4.10.0</strong>, released on 2020-02-21.</p>
|js}
  ; highlights_md = {js|- A new best-fit allocator for the major heap which reducing both GC cost an
  memory usage.
- Immutable strings are now enforced at configuration time - User-defined indexing operators for multidimensional arrays - Coming soon: statmemprof, a new statistical memory profiler. The external API
  will be release next version.
- Miscellaneous improvements to the manual - A more precise exhaustiveness check for GADTs - Many bug fixes
|js}
  ; highlights_html = {js|<ul>
<li>A new best-fit allocator for the major heap which reducing both GC cost an
memory usage.
</li>
<li>Immutable strings are now enforced at configuration time - User-defined indexing operators for multidimensional arrays - Coming soon: statmemprof, a new statistical memory profiler. The external API
will be release next version.
</li>
<li>Miscellaneous improvements to the manual - A more precise exhaustiveness check for GADTs - Many bug fixes
</li>
</ul>
|js}
  ; body_md = {js|
Opam switches
-------------

This release is available as multiple
[OPAM](https://opam.ocaml.org/doc/Usage.html) switches:

- 4.10.0 — Official release 4.10.0
- 4.10.0+flambda — Official release 4.10.0, with flambda activated

- 4.10.0+afl — Official release 4.10.0, with afl-fuzz instrumentation
- 4.10.0+spacetime - Official 4.10.0 release with spacetime activated

- 4.10.0+default-unsafe-string — Official release 4.10.0, without
  safe strings by default
- 4.10.0+no-flat-float-array - Official release 4.10.0, with
  --disable-flat-float-array
- 4.10.0+flambda+no-flat-float-array — Official release 4.10.0, with
  flambda activated and --disable-flat-float-array
- 4.10.0+fp — Official release 4.10.0, with frame-pointers
- 4.10.0+fp+flambda — Official release 4.10.0, with frame-pointers
  and flambda activated
- 4.10.0+musl+static+flambda - Official release 4.10.0, compiled with
  musl-gcc -static and with flambda activated

- 4.10.0+32bit - Official release 4.10.0, compiled in 32-bit mode
  for 64-bit Linux and OS X hosts
- 4.10.0+bytecode-only - Official release 4.10.0, without the
  native-code compiler


What's new
----------
Some of the highlights in release 4.10 are:

- A new best-fit allocator for the major heap which reducing both GC cost an
   memory usage.
- Immutable strings are now enforced at configuration time
- User-defined indexing operators for multidimensional arrays
- Coming soon: statmemprof, a new statistical memory profiler. The external API
  will be release next version.
- Miscellaneous improvements to the manual
- A more precise exhaustiveness check for GADTs
- Many bug fixes

For a comprehensive list of changes and details on all new features,
bug fixes, optimizations, etc., please consult the
[changelog](#Changes).

Source distribution
---------------------------------------------

- [Source
  tarball](https://github.com/ocaml/ocaml/archive/4.10.0.tar.gz)
  (.tar.gz) for compilation under Unix (including Linux and MacOS X)
  and Microsoft Windows (including Cygwin).
- Also available in
  [.zip](https://github.com/ocaml/ocaml/archive/4.10.0.zip)
  format.
- [OPAM](https://opam.ocaml.org/) is a source-based distribution of
  OCaml and many companion libraries and tools. Compilation and
  installation are automated by powerful package managers.
- The official development repo is hosted on
  [GitHub](https://github.com/ocaml/ocaml).

The
[INSTALL](4.10/notes/INSTALL.adoc) file
of the distribution provides detailed compilation and installation
instructions — see also the [Windows release
notes](4.10/notes/README.win32.adoc) for
instructions on how to build under Windows.

Alternative Compilers
---------------------

Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:

* [Js_of_ocaml](http://ocsigen.org/js_of_ocaml/) is a stable OCaml
  to JavaScript compiler.
* [Bucklescript](http://bucklescript.github.io/bucklescript/) is a
  newer OCaml to JavaScript compiler. See its
  [wiki](https://github.com/bucklescript/bucklescript/wiki/Differences-from-js_of_ocaml) for
  an explanation of how it differs from `js_of_ocaml`.
* [OCaml-java](http://www.ocamljava.org/) is a stable OCaml to
  Java compiler.

User's manual
------------------------------------

The user's manual for OCaml can be:

- [browsed
  online](4.10/htmlman/index.html),
- downloaded as a single
  [PDF](4.10/ocaml-4.10-refman.pdf),
  or [plain
  text](4.10/ocaml-4.10-refman.txt)
  document,
- downloaded as a single
  [TAR](4.10/ocaml-4.10-refman-html.tar.gz)
  or
  [ZIP](4.10/ocaml-4.10-refman-html.zip)
  archive of HTML files,
- downloaded as a single
  [tarball](4.10/ocaml-4.10-refman.info.tar.gz)
  of Emacs info files,



Changes
-------

This is the
[changelog](4.10/notes/Changes).

(Changes that can break existing programs are marked with a "*")

### Language features

- [#7757](https://github.com/ocaml/ocaml/issues/7757), [#1726](https://github.com/ocaml/ocaml/issues/1726): multi-indices for extended indexing operators:
  `a.%{0;1;2}` desugars to `( .%{ ;.. } ) a [|0;1;2|]`
  (Florian Angeletti, review by Gabriel Radanne)

* [*breaking change*] [#1859](https://github.com/ocaml/ocaml/issues/1859), [#9117](https://github.com/ocaml/ocaml/issues/9117): enforce safe (immutable) strings by removing
  the -unsafe-string option by default. This can be overridden by
  a configure-time option (available since 4.04 in 2016):
  --disable-force-safe-string since 4.08, -no-force-safe-since
  between 4.07 and 4.04.
  In the force-safe-string mode (now the default), the return type of the
  String_val macro in C stubs is `const char*` instead of
  `char*`. This change may break C FFI code.
  (Kate Deplaix)


- [#6662](https://github.com/ocaml/ocaml/issues/6662), [#8908](https://github.com/ocaml/ocaml/issues/8908): allow writing "module _ = E" to ignore module expressions
  (Thomas Refis, review by Gabriel Radanne)

### Runtime system:

- [#8809](https://github.com/ocaml/ocaml/issues/8809), [#9292](https://github.com/ocaml/ocaml/issues/9292): Add a best-fit allocator for the major heap; still
  experimental, it should be much better than current allocation
  policies (first-fit and next-fit) for programs with large heaps,
  reducing both GC cost and memory usage.
  This new best-fit is not (yet) the default; set it explicitly with
  OCAMLRUNPARAM="a=2" (or Gc.set from the program). You may also want
  to increase the `space_overhead` parameter of the GC (a percentage,
  80 by default), for example OCAMLRUNPARAM="o=85", for optimal
  speed.
  (Damien Doligez, review by Stephen Dolan, Jacques-Henri Jourdan,
   Xavier Leroy, Leo White)

* [*breaking change*] [#8713](https://github.com/ocaml/ocaml/issues/8713), [#8940](https://github.com/ocaml/ocaml/issues/8940), [#9115](https://github.com/ocaml/ocaml/issues/9115), [#9143](https://github.com/ocaml/ocaml/issues/9143), [#9202](https://github.com/ocaml/ocaml/issues/9202), [#9251](https://github.com/ocaml/ocaml/issues/9251):
  Introduce a state table in the runtime to contain the global variables.
  (The Multicore runtime will have one such state for each domain.)

   This changes the status of some internal variables of the OCaml runtime;
   in many cases the header file originally defining the internal variable
   provides a compatibility macro with the old name, but programs
   re-defining those variables by hand need to be fixed.

   (KC Sivaramakrishnan and Stephen Dolan,
    compatibility hacking by David Allsopp, Florian Angeletti, Kate Deplaix,
    Jacques Garrigue, Guillaume Munch-Maccagnoni and Nicolás Ojeda Bär,
    review by David Allsopp, Alain Frisch, Nicolas Ojeda Bar,
    Gabriel Scherer, Damien Doligez, and Guillaume Munch-Maccagnoni)

- [#8993](https://github.com/ocaml/ocaml/issues/8993): New C functions caml_process_pending_actions{,_exn} in
  caml/signals.h, intended for executing all pending actions inside
  long-running C functions (requested minor and major collections,
  signal handlers, finalisers, and memprof callbacks). The function
  caml_process_pending_actions_exn returns any exception arising
  during their execution, allowing resources to be cleaned-up before
  re-raising.
  (Guillaume Munch-Maccagnoni, review by Jacques-Henri Jourdan,
   Stephen Dolan, and Gabriel Scherer)

* [*breaking change*] [#8691](https://github.com/ocaml/ocaml/issues/8691), [#8897](https://github.com/ocaml/ocaml/issues/8897), [#9027](https://github.com/ocaml/ocaml/issues/9027): Allocation functions are now guaranteed not to
  trigger any OCaml callback when called from C. In long-running C
  functions, this can be replaced with calls to
  caml_process_pending_actions at safe points.
  Side effect of this change: in bytecode mode, polling for
  asynchronous callbacks is performed at every minor heap allocation,
  in addition to function calls and loops as in previous OCaml
  releases.
  (Jacques-Henri Jourdan, review by Stephen Dolan, Gabriel Scherer and
   Guillaume Munch-Maccagnoni)

* [*breaking change*] [#9037](https://github.com/ocaml/ocaml/issues/9037): caml_check_urgent_gc is now guaranteed not to trigger any
  finaliser. In long-running C functions, this can be replaced
  with calls to caml_process_pending_actions at safe points.
  (Guillaume Munch-Maccagnoni, review by Jacques-Henri Jourdan and
   Stephen Dolan)


- [#8619](https://github.com/ocaml/ocaml/issues/8619): Ensure Gc.minor_words remains accurate after a GC.
  (Stephen Dolan, Xavier Leroy and David Allsopp,
   review by Xavier Leroy and Gabriel Scherer)

- [#8667](https://github.com/ocaml/ocaml/issues/8667): Limit GC credit to 1.0
  (Leo White, review by Damien Doligez)

- [#8670](https://github.com/ocaml/ocaml/issues/8670): Fix stack overflow detection with systhreads
  (Stephen Dolan, review by Xavier Leroy, Anil Madhavapeddy, Gabriel Scherer,
   Frédéric Bour and Guillaume Munch-Maccagnoni)

* [*breaking change*] [#8711](https://github.com/ocaml/ocaml/issues/8711): The major GC hooks are no longer allowed to interact with the
   OCaml heap.
   (Jacques-Henri Jourdan, review by Damien Doligez)

- [#8630](https://github.com/ocaml/ocaml/issues/8630): Use abort() instead of exit(2) in caml_fatal_error, and add
  the new hook caml_fatal_error_hook.
  (Jacques-Henri Jourdan, review by Xavier Leroy)

- [#8641](https://github.com/ocaml/ocaml/issues/8641): Better call stacks when a C call is involved in byte code mode
  (Jacques-Henri Jourdan, review by Xavier Leroy)

- [#8634](https://github.com/ocaml/ocaml/issues/8634), [#8668](https://github.com/ocaml/ocaml/issues/8668), [#8684](https://github.com/ocaml/ocaml/issues/8684), [#9103](https://github.com/ocaml/ocaml/issues/9103) (originally [#847](https://github.com/ocaml/ocaml/issues/847)): Statistical memory profiling.
  In OCaml 4.10, support for allocations in the minor heap in native
  mode is not available, and callbacks for promotions and
  deallocations are not available.
  Hence, there is not any public API for this feature yet.
  (Jacques-Henri Jourdan, review by Stephen Dolan, Gabriel Scherer
   and Damien Doligez)

- [#9268](https://github.com/ocaml/ocaml/issues/9268), [#9271](https://github.com/ocaml/ocaml/issues/9271): Fix bytecode backtrace generation with large integers present.
  (Stephen Dolan and Mark Shinwell, review by Gabriel Scherer and
   Jacques-Henri Jourdan)

### Standard library:

- [#8760](https://github.com/ocaml/ocaml/issues/8760): List.concat_map : ('a -> 'b list) -> 'a list -> 'b list
  (Gabriel Scherer, review by Daniel Bünzli and Thomas Refis)

- [#8832](https://github.com/ocaml/ocaml/issues/8832): List.find_map : ('a -> 'b option) -> 'a list -> 'b option
  (Gabriel Scherer, review by Jeremy Yallop, Nicolás Ojeda Bär
   and Daniel Bünzli)

- [#7672](https://github.com/ocaml/ocaml/issues/7672), [#1492](https://github.com/ocaml/ocaml/issues/1492): Add `Filename.quote_command` to produce properly-quoted
  commands for execution by Sys.command.
  (Xavier Leroy, review by David Allsopp and Damien Doligez)

- [#8971](https://github.com/ocaml/ocaml/issues/8971): Add `Filename.null`, the conventional name of the "null" device.
  (Nicolás Ojeda Bär, review by Xavier Leroy and Alain Frisch)

- [#8651](https://github.com/ocaml/ocaml/issues/8651): add '%#F' modifier in printf to output OCaml float constants
  in hexadecimal
  (Pierre Roux, review by Gabriel Scherer and Xavier Leroy)


- [#8657](https://github.com/ocaml/ocaml/issues/8657): Optimization in [Array.make] when initializing with unboxed
   or young values.
   (Jacques-Henri Jourdan, review by Gabriel Scherer and Stephen Dolan)

- [#8716](https://github.com/ocaml/ocaml/issues/8716): Optimize [Array.fill] and [Hashtbl.clear] with a new runtime primitive
  (Alain Frisch, review by David Allsopp, Stephen Dolan and Damien Doligez)

- [#8530](https://github.com/ocaml/ocaml/issues/8530): List.sort: avoid duplicate work by chop
  (Guillaume Munch-Maccagnoni, review by David Allsopp, Damien Doligez and
   Gabriel Scherer)

### Other libraries:

- [#1939](https://github.com/ocaml/ocaml/issues/1939), [#2023](https://github.com/ocaml/ocaml/issues/2023): Implement Unix.truncate and Unix.ftruncate on Windows.
  (Florent Monnier and Nicolás Ojeda Bär, review by David Allsopp)

### Code generation and optimizations:

- [#8806](https://github.com/ocaml/ocaml/issues/8806): Add an [@@immediate64] attribute for types that are known to
  be immediate only on 64 bit platforms
  (Jérémie Dimino, review by Vladimir Keleshev)

- [#9028](https://github.com/ocaml/ocaml/issues/9028), [#9032](https://github.com/ocaml/ocaml/issues/9032): Fix miscompilation by no longer assuming that
  untag_int (tag_int x) = x in Cmmgen; the compilation of `(n lsl 1) + 1`,
  for example, would be incorrect if evaluated with a large value for `n`.
  (Stephen Dolan, review by Vincent Laviron and Xavier Leroy)

- [#8672](https://github.com/ocaml/ocaml/issues/8672): Optimise Switch code generation on booleans.
  (Stephen Dolan, review by Pierre Chambart)


- [#8990](https://github.com/ocaml/ocaml/issues/8990): amd64: Emit 32bit registers for Iconst_int when we can
  (Xavier Clerc, Tom Kelly and Mark Shinwell, review by Xavier Leroy)

- [#2322](https://github.com/ocaml/ocaml/issues/2322): Add pseudo-instruction `Ladjust_trap_depth` to replace
  dummy Lpushtrap generated in linearize
  (Greta Yorsh and Vincent Laviron, review by Xavier Leroy)

- [#8707](https://github.com/ocaml/ocaml/issues/8707): Simplif: more regular treatment of Tupled and Curried functions
  (Gabriel Scherer, review by Leo White and Alain Frisch)

- [#8526](https://github.com/ocaml/ocaml/issues/8526): Add compile-time option -function-sections in ocamlopt to emit
  each function in a separate named text section on supported targets.
  (Greta Yorsh, review by Pierre Chambart)

- [#2321](https://github.com/ocaml/ocaml/issues/2321): Eliminate dead ICatch handlers
  (Greta Yorsh, review by Pierre Chambart and Vincent Laviron)

- [#8919](https://github.com/ocaml/ocaml/issues/8919): lift mutable lets along with immutable ones
  (Leo White, review by Pierre Chambart)

- [#8909](https://github.com/ocaml/ocaml/issues/8909): Graph coloring register allocator: the weights put on
  preference edges should not be divided by 2 in branches of
  conditional constructs, because it is not good for performance
  and because it leads to ignoring preference edges with 0 weight.
  (Eric Stavarache, review by Xavier Leroy)

- [#9006](https://github.com/ocaml/ocaml/issues/9006): int32 code generation improvements
  (Stephen Dolan, designed with Greta Yorsh, review by Xavier Clerc,
   Xavier Leroy and Alain Frisch)

- [#9041](https://github.com/ocaml/ocaml/issues/9041): amd64: Avoid stall in sqrtsd by clearing destination.
  (Stephen Dolan, with thanks to Andrew Hunter, Will Hasenplaugh,
   Spiros Eliopoulos and Brian Nigito. Review by Xavier Leroy)

- [#2165](https://github.com/ocaml/ocaml/issues/2165): better unboxing heuristics for let-bound identifiers
  (Alain Frisch, review by Vincent Laviron and Gabriel Scherer)

- [#8735](https://github.com/ocaml/ocaml/issues/8735): unbox across static handlers
  (Alain Frisch, review by Vincent Laviron and Gabriel Scherer)

### Manual and documentation:

- [#8718](https://github.com/ocaml/ocaml/issues/8718), [#9089](https://github.com/ocaml/ocaml/issues/9089): syntactic highlighting for code examples in the manual
  (Florian Angeletti, report by Anton Kochkov, review by Gabriel Scherer)

- [#9101](https://github.com/ocaml/ocaml/issues/9101): add links to section anchor before the section title,
  make the name of those anchor explicits.
  (Florian Angeletti, review by Daniel Bünzli, Sébastien Hinderer,
   and Gabriel Scherer)

- [#9257](https://github.com/ocaml/ocaml/issues/9257), cautionary guidelines for using the internal runtime API
  without too much updating pain.
  (Florian Angeletti, review by Daniel Bünzli, Guillaume Munch-Maccagnoni
   and KC Sivaramakrishnan)


- [#8950](https://github.com/ocaml/ocaml/issues/8950): move local opens in pattern out of the extension chapter
  (Florian Angeletti, review and suggestion by Gabriel Scherer)

- [#9088](https://github.com/ocaml/ocaml/issues/9088), [#9097](https://github.com/ocaml/ocaml/issues/9097): fix operator character classes
  (Florian Angelettion, review by Gabriel Scherer,
   report by Clément Busschaert)

- [#9169](https://github.com/ocaml/ocaml/issues/9169): better documentation for the best-fit allocation policy
  (Gabriel Scherer, review by Guillaume Munch-Maccagnoni
   and Florian Angeletti)

### Compiler user-interface and warnings:

- [#8833](https://github.com/ocaml/ocaml/issues/8833): Hint for (type) redefinitions in toplevel session
  (Florian Angeletti, review by Gabriel Scherer)

- [#2127](https://github.com/ocaml/ocaml/issues/2127), [#9185](https://github.com/ocaml/ocaml/issues/9185): Refactor lookup functions
  Included observable changes:
    - makes the location of usage warnings and alerts for constructors more
      precise
    - don't warn about a constructor never being used to build values when it
      has been defined as private
  (Leo White, Hugo Heuzard review by Thomas Refis, Florian Angeletti)

- [#8702](https://github.com/ocaml/ocaml/issues/8702), [#8777](https://github.com/ocaml/ocaml/issues/8777): improved error messages for fixed row polymorphic variants
  (Florian Angeletti, report by Leo White, review by Thomas Refis)

- [#8844](https://github.com/ocaml/ocaml/issues/8844): Printing faulty constructors, inline records fields and their types
  during type mismatches. Also slightly changed other type mismatches error
  output.
  (Mekhrubon Turaev, review by Florian Angeletti, Leo White)

- [#8885](https://github.com/ocaml/ocaml/issues/8885): Warn about unused local modules
  (Thomas Refis, review by Alain Frisch)

- [#8872](https://github.com/ocaml/ocaml/issues/8872): Add ocamlc option "-output-complete-exe" to build a self-contained
  binary for bytecode programs, containing the runtime and C stubs.
  (Stéphane Glondu, Nicolás Ojeda Bär, review by Jérémie Dimino and Daniel
  Bünzli)

- [#8874](https://github.com/ocaml/ocaml/issues/8874): add tests for typechecking error messages and pack them into
  pretty-printing boxes.
  (Oxana Kostikova, review by Gabriel Scherer)

- [#8891](https://github.com/ocaml/ocaml/issues/8891): Warn about unused functor parameters
  (Thomas Refis, review by Gabriel Radanne)

- [#8903](https://github.com/ocaml/ocaml/issues/8903): Improve errors for first-class modules
  (Leo White, review by Jacques Garrigue)

- [#8914](https://github.com/ocaml/ocaml/issues/8914): clarify the warning on unboxable types used in external primitives (61)
  (Gabriel Scherer, review by Florian Angeletti, report on the Discourse forum)

- [#9046](https://github.com/ocaml/ocaml/issues/9046): disable warning 30 by default
  This outdated warning complained on label/constructor name conflicts
  within a mutually-recursive type declarations; there is now no need
  to complain thanks to type-based disambiguation.
  (Gabriel Scherer)

### Tools:

* [*breaking change*] [#6792](https://github.com/ocaml/ocaml/issues/6792), [#8654](https://github.com/ocaml/ocaml/issues/8654) ocamldebug now supports programs using Dynlink. This
  changes ocamldebug messages, which may break compatibility
  with older emacs modes.
  (Whitequark and Jacques-Henri Jourdan, review by Gabriel Scherer
   and Xavier Clerc)

- [#8621](https://github.com/ocaml/ocaml/issues/8621): Make ocamlyacc a Windows Unicode application
  (David Allsopp, review by Nicolás Ojeda Bär)

* [*breaking change*] [#8834](https://github.com/ocaml/ocaml/issues/8834), `ocaml`: adhere to the XDG base directory specification to
  locate an `.ocamlinit` file. Reads an `$XDG_CONFIG_HOME/ocaml/init.ml`
  file before trying to lookup `~/.ocamlinit`. On Windows the behaviour
  is unchanged.
  (Daniel C. Bünzli, review by David Allsopp, Armaël Guéneau and
   Nicolás Ojeda Bär)

- [#9113](https://github.com/ocaml/ocaml/issues/9113): ocamldoc: fix the rendering of multi-line code blocks
  in the 'man' backend.
  (Gabriel Scherer, review by Florian Angeletti)

- [#9127](https://github.com/ocaml/ocaml/issues/9127), [#9130](https://github.com/ocaml/ocaml/issues/9130): ocamldoc: fix the formatting of closing brace in record types.
  (David Allsopp, report by San Vu Ngoc)

- [#9181](https://github.com/ocaml/ocaml/issues/9181): make objinfo work on Cygwin and look for the caml_plugin_header
  symbol in both the static and the dynamic symbol tables.
  (Sébastien Hinderer, review by Gabriel Scherer and David Allsopp)

### Build system:

- [#8840](https://github.com/ocaml/ocaml/issues/8840): use ocaml{c,opt}.opt when available to build internal tools
  On my machine this reduces parallel-build times from 3m30s to 2m50s.
  (Gabriel Scherer, review by Xavier Leroy and Sébastien Hinderer)

- [#8650](https://github.com/ocaml/ocaml/issues/8650): ensure that "make" variables are defined before use;
  revise generation of config/util.ml to better quote special characters
  (Xavier Leroy, review by David Allsopp)

- [#8690](https://github.com/ocaml/ocaml/issues/8690), [#8696](https://github.com/ocaml/ocaml/issues/8696): avoid rebuilding the world when files containing primitives
  change.
  (Stephen Dolan, review by Gabriel Scherer, Sébastien Hinderer and
   Thomas Refis)

- [#8835](https://github.com/ocaml/ocaml/issues/8835): new configure option --disable-stdlib-manpages to disable building
  and installation of the library manpages.
  (David Allsopp, review by Florian Angeletti and Gabriel Scherer)

- [#8837](https://github.com/ocaml/ocaml/issues/8837): build manpages using ocamldoc.opt when available
  cuts the manpages build time from 14s to 4s
  (Gabriel Scherer, review by David Allsopp and Sébastien Hinderer,
   report by David Allsopp)

- [#8843](https://github.com/ocaml/ocaml/issues/8843), [#8841](https://github.com/ocaml/ocaml/issues/8841): fix use of off_t on 32-bit systems.
  (Stephen Dolan, report by Richard Jones, review by Xavier Leroy)

- [#8947](https://github.com/ocaml/ocaml/issues/8947), [#9134](https://github.com/ocaml/ocaml/issues/9134), [#9302](https://github.com/ocaml/ocaml/issues/9302), [#9311](https://github.com/ocaml/ocaml/issues/9311): fix/improve support for the BFD library
  (Sébastien Hinderer, review by Damien Doligez and David Allsopp)

- [#8951](https://github.com/ocaml/ocaml/issues/8951): let make's default target build the compiler
  (Sébastien Hinderer, review by David Allsopp)

- [#8995](https://github.com/ocaml/ocaml/issues/8995): allow developers to specify frequently-used configure options in
  Git (ocaml.configure option) and a directory for host-specific, shareable
  config.cache files (ocaml.configure-cache option). See HACKING.adoc for
  further details.
  (David Allsopp, review by Gabriel Scherer)

- [#9136](https://github.com/ocaml/ocaml/issues/9136): Don't propagate Cygwin-style prefix from configure to
  Makefile.config on Windows ports.
  (David Allsopp, review by Sébastien Hinderer)

### Internal/compiler-libs changes:

- [#8828](https://github.com/ocaml/ocaml/issues/8828): Added abstractions for variants, records, constructors, fields and
  extension constructor types mismatch.
  (Mekhrubon Turaev, review by Florian Angeletti, Leo White and Gabriel Scherer)

- [#7927](https://github.com/ocaml/ocaml/issues/7927), [#8527](https://github.com/ocaml/ocaml/issues/8527): Replace long tuples into records in typeclass.ml
  (Ulugbek Abdullaev, review by David Allsopp and Gabriel Scherer)

- [#1963](https://github.com/ocaml/ocaml/issues/1963): split cmmgen into generic Cmm helpers and clambda transformations
  (Vincent Laviron, review by Mark Shinwell)

- [#1901](https://github.com/ocaml/ocaml/issues/1901): Fix lexing of character literals in comments
  (Pieter Goetschalckx, review by Damien Doligez)

- [#1932](https://github.com/ocaml/ocaml/issues/1932): Allow octal escape sequences and identifiers containing apostrophes
  in ocamlyacc actions and comments.
  (Pieter Goetschalckx, review by Damien Doligez)

- [#2288](https://github.com/ocaml/ocaml/issues/2288): Move middle end code from [Asmgen] to [Clambda_middle_end] and
  [Flambda_middle_end].  Run [Un_anf] from the middle end, not [Cmmgen].
  (Mark Shinwell, review by Pierre Chambart)

- [#8692](https://github.com/ocaml/ocaml/issues/8692): Remove Misc.may_map and similar
  (Leo White, review by Gabriel Scherer and Thomas Refis)

- [#8677](https://github.com/ocaml/ocaml/issues/8677): Use unsigned comparisons in amd64 and i386 emitter of Lcondbranch3.
  (Greta Yorsh, review by Xavier Leroy)

- [#8766](https://github.com/ocaml/ocaml/issues/8766): Parmatch: introduce a type for simplified pattern heads
  (Gabriel Scherer and Thomas Refis, review by Stephen Dolan and
   Florian Angeletti)

- [#8774](https://github.com/ocaml/ocaml/issues/8774): New implementation of Env.make_copy_of_types
  (Alain Frisch, review by Thomas Refis, Leo White and Jacques Garrigue)

- [#7924](https://github.com/ocaml/ocaml/issues/7924): Use a variant instead of an int in Bad_variance exception
  (Rian Douglas, review by Gabriel Scherer)

- [#8890](https://github.com/ocaml/ocaml/issues/8890): in -dtimings output, show time spent in C linker clearly
  (Valentin Gatien-Baron)

- [#8910](https://github.com/ocaml/ocaml/issues/8910), [#8911](https://github.com/ocaml/ocaml/issues/8911): minor improvements to the printing of module types
  (Gabriel Scherer, review by Florian Angeletti)

- [#8913](https://github.com/ocaml/ocaml/issues/8913): ocamltest: improve 'promote' implementation to take
  skipped lines/bytes into account
  (Gabriel Scherer, review by Sébastien Hinderer)

- [#8908](https://github.com/ocaml/ocaml/issues/8908): Use an option instead of a string for module names ("_" becomes None),
  and a dedicated type for functor parameters: "()" maps to "Unit" (instead of
  "*").
  (Thomas Refis, review by Gabriel Radanne)

- [#8928](https://github.com/ocaml/ocaml/issues/8928): Move contains_calls and num_stack_slots from Proc to Mach.fundecl
  (Greta Yorsh, review by Florian Angeletti and Vincent Laviron)

- [#8959](https://github.com/ocaml/ocaml/issues/8959), [#8960](https://github.com/ocaml/ocaml/issues/8960), [#8968](https://github.com/ocaml/ocaml/issues/8968), [#9023](https://github.com/ocaml/ocaml/issues/9023): minor refactorings in the typing of patterns:
  + refactor the {let,pat}_bound_idents* functions
  + minor bugfix in type_pat
  + refactor the generic pattern-traversal functions
    in Typecore and Typedtree
  + restrict the use of Need_backtrack
  (Gabriel Scherer and Florian Angeletti,
   review by Thomas Refis and Gabriel Scherer)

- [#9030](https://github.com/ocaml/ocaml/issues/9030): clarify and document the parameter space of type_pat
  (Gabriel Scherer and Florian Angeletti and Jacques Garrigue,
   review by Florian Angeletti and Thomas Refis)

- [#8975](https://github.com/ocaml/ocaml/issues/8975): "ocamltests" files are no longer required or used by
  "ocamltest". Instead, any text file in the testsuite directory containing a
  valid "TEST" block will be automatically included in the testsuite.
  (Nicolás Ojeda Bär, review by Gabriel Scherer and Sébastien Hinderer)

- [#8992](https://github.com/ocaml/ocaml/issues/8992): share argument implementations between executables
  (Florian Angeletti, review by Gabriel Scherer)

- [#9015](https://github.com/ocaml/ocaml/issues/9015): fix fatal error in pprint_ast ([#8789](https://github.com/ocaml/ocaml/issues/8789))
  (Damien Doligez, review by ...)

### Bug fixes:

- [#5673](https://github.com/ocaml/ocaml/issues/5673), [#7636](https://github.com/ocaml/ocaml/issues/7636): unused type variable causes generalization error
  (Jacques Garrigue and Leo White, review by Leo White,
   reports by Jean-Louis Giavitto and Christophe Raffalli)

- [#6922](https://github.com/ocaml/ocaml/issues/6922), [#8955](https://github.com/ocaml/ocaml/issues/8955): Fix regression with -principal type inference for inherited
  methods, allowing to compile ocamldoc with -principal
  (Jacques Garrigue, review by Leo White)

- [#7925](https://github.com/ocaml/ocaml/issues/7925), [#8611](https://github.com/ocaml/ocaml/issues/8611): fix error highlighting for exceptionally
  long toplevel phrases
  (Kyle Miller, reported by Armaël Guéneau, review by Armaël Guéneau
   and Nicolás Ojeda Bär)

- [#8622](https://github.com/ocaml/ocaml/issues/8622): Don't generate #! headers over 127 characters.
  (David Allsopp, review by Xavier Leroy and Stephen Dolan)

- [#8715](https://github.com/ocaml/ocaml/issues/8715): minor bugfixes in CamlinternalFormat; removes the unused
  and misleading function CamlinternalFormat.string_of_formatting_gen
  (Gabriel Scherer and Florian Angeletti,
   review by Florian Angeletti and Gabriel Radanne)

- [#8792](https://github.com/ocaml/ocaml/issues/8792), [#9018](https://github.com/ocaml/ocaml/issues/9018): Possible (latent) bug in Ctype.normalize_type
  removed incrimined Btype.log_type, replaced by Btype.set_type
  (Jacques Garrigue, report by Alain Frisch, review by Thomas Refis)

- [#8856](https://github.com/ocaml/ocaml/issues/8856), [#8860](https://github.com/ocaml/ocaml/issues/8860): avoid stackoverflow when printing cyclic type expressions
  in some error submessages.
  (Florian Angeletti, report by Mekhrubon Turaev, review by Leo White)

- [#8875](https://github.com/ocaml/ocaml/issues/8875): fix missing newlines in the output from MSVC invocation.
  (Nicolás Ojeda Bär, review by Gabriel Scherer)

- [#8921](https://github.com/ocaml/ocaml/issues/8921), [#8924](https://github.com/ocaml/ocaml/issues/8924): Fix stack overflow with Flambda
  (Vincent Laviron, review by Pierre Chambart and Leo White,
   report by Aleksandr Kuzmenko)

- [#8892](https://github.com/ocaml/ocaml/issues/8892), [#8895](https://github.com/ocaml/ocaml/issues/8895): fix the definition of Is_young when CAML_INTERNALS is not
  defined.
  (David Allsopp, review by Xavier Leroy)

- [#8896](https://github.com/ocaml/ocaml/issues/8896): deprecate addr typedef in misc.h
  (David Allsopp, suggestion by Xavier Leroy)

- [#8981](https://github.com/ocaml/ocaml/issues/8981): Fix check for incompatible -c and -o options.
  (Greta Yorsh, review by Damien Doligez)

- [#9019](https://github.com/ocaml/ocaml/issues/9019), [#9154](https://github.com/ocaml/ocaml/issues/9154): Unsound exhaustivity of GADTs from incomplete unification
  Also fixes bug found by Thomas Refis in [#9012](https://github.com/ocaml/ocaml/issues/9012)
  (Jacques Garrigue, report and review by Leo White, Thomas Refis)

- [#9031](https://github.com/ocaml/ocaml/issues/9031): Unregister Windows stack overflow handler while shutting
  the runtime down.
  (Dmitry Bely, review by David Allsopp)

- [#9051](https://github.com/ocaml/ocaml/issues/9051): fix unregistered local root in win32unix/select.c (could result in
  `select` returning file_descr-like values which weren't in the original sets)
  and correct initialisation of some blocks allocated with caml_alloc_small.
  (David Allsopp, review by Xavier Leroy)

- [#9073](https://github.com/ocaml/ocaml/issues/9073), [#9120](https://github.com/ocaml/ocaml/issues/9120): fix incorrect GC ratio multiplier when allocating custom blocks
  with caml_alloc_custom_mem in runtime/custom.c
  (Markus Mottl, review by Gabriel Scherer and Damien Doligez)

- [#9209](https://github.com/ocaml/ocaml/issues/9209), [#9212](https://github.com/ocaml/ocaml/issues/9212): fix a development-version regression caused by [#2288](https://github.com/ocaml/ocaml/issues/2288)
  (Kate Deplaix and David Allsopp, review by Sébastien Hinderer
   and Gabriel Scherer )
|js}
  ; body_html = {js|<h2>Opam switches</h2>
<p>This release is available as multiple
<a href="https://opam.ocaml.org/doc/Usage.html">OPAM</a> switches:</p>
<ul>
<li>
<p>4.10.0 — Official release 4.10.0</p>
</li>
<li>
<p>4.10.0+flambda — Official release 4.10.0, with flambda activated</p>
</li>
<li>
<p>4.10.0+afl — Official release 4.10.0, with afl-fuzz instrumentation</p>
</li>
<li>
<p>4.10.0+spacetime - Official 4.10.0 release with spacetime activated</p>
</li>
<li>
<p>4.10.0+default-unsafe-string — Official release 4.10.0, without
safe strings by default</p>
</li>
<li>
<p>4.10.0+no-flat-float-array - Official release 4.10.0, with
--disable-flat-float-array</p>
</li>
<li>
<p>4.10.0+flambda+no-flat-float-array — Official release 4.10.0, with
flambda activated and --disable-flat-float-array</p>
</li>
<li>
<p>4.10.0+fp — Official release 4.10.0, with frame-pointers</p>
</li>
<li>
<p>4.10.0+fp+flambda — Official release 4.10.0, with frame-pointers
and flambda activated</p>
</li>
<li>
<p>4.10.0+musl+static+flambda - Official release 4.10.0, compiled with
musl-gcc -static and with flambda activated</p>
</li>
<li>
<p>4.10.0+32bit - Official release 4.10.0, compiled in 32-bit mode
for 64-bit Linux and OS X hosts</p>
</li>
<li>
<p>4.10.0+bytecode-only - Official release 4.10.0, without the
native-code compiler</p>
</li>
</ul>
<h2>What's new</h2>
<p>Some of the highlights in release 4.10 are:</p>
<ul>
<li>A new best-fit allocator for the major heap which reducing both GC cost an
memory usage.
</li>
<li>Immutable strings are now enforced at configuration time
</li>
<li>User-defined indexing operators for multidimensional arrays
</li>
<li>Coming soon: statmemprof, a new statistical memory profiler. The external API
will be release next version.
</li>
<li>Miscellaneous improvements to the manual
</li>
<li>A more precise exhaustiveness check for GADTs
</li>
<li>Many bug fixes
</li>
</ul>
<p>For a comprehensive list of changes and details on all new features,
bug fixes, optimizations, etc., please consult the
<a href="#Changes">changelog</a>.</p>
<h2>Source distribution</h2>
<ul>
<li><a href="https://github.com/ocaml/ocaml/archive/4.10.0.tar.gz">Source
tarball</a>
(.tar.gz) for compilation under Unix (including Linux and MacOS X)
and Microsoft Windows (including Cygwin).
</li>
<li>Also available in
<a href="https://github.com/ocaml/ocaml/archive/4.10.0.zip">.zip</a>
format.
</li>
<li><a href="https://opam.ocaml.org/">OPAM</a> is a source-based distribution of
OCaml and many companion libraries and tools. Compilation and
installation are automated by powerful package managers.
</li>
<li>The official development repo is hosted on
<a href="https://github.com/ocaml/ocaml">GitHub</a>.
</li>
</ul>
<p>The
<a href="4.10/notes/INSTALL.adoc">INSTALL</a> file
of the distribution provides detailed compilation and installation
instructions — see also the <a href="4.10/notes/README.win32.adoc">Windows release
notes</a> for
instructions on how to build under Windows.</p>
<h2>Alternative Compilers</h2>
<p>Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:</p>
<ul>
<li><a href="http://ocsigen.org/js_of_ocaml/">Js_of_ocaml</a> is a stable OCaml
to JavaScript compiler.
</li>
<li><a href="http://bucklescript.github.io/bucklescript/">Bucklescript</a> is a
newer OCaml to JavaScript compiler. See its
<a href="https://github.com/bucklescript/bucklescript/wiki/Differences-from-js_of_ocaml">wiki</a> for
an explanation of how it differs from <code>js_of_ocaml</code>.
</li>
<li><a href="http://www.ocamljava.org/">OCaml-java</a> is a stable OCaml to
Java compiler.
</li>
</ul>
<h2>User's manual</h2>
<p>The user's manual for OCaml can be:</p>
<ul>
<li><a href="4.10/htmlman/index.html">browsed
online</a>,
</li>
<li>downloaded as a single
<a href="4.10/ocaml-4.10-refman.pdf">PDF</a>,
or <a href="4.10/ocaml-4.10-refman.txt">plain
text</a>
document,
</li>
<li>downloaded as a single
<a href="4.10/ocaml-4.10-refman-html.tar.gz">TAR</a>
or
<a href="4.10/ocaml-4.10-refman-html.zip">ZIP</a>
archive of HTML files,
</li>
<li>downloaded as a single
<a href="4.10/ocaml-4.10-refman.info.tar.gz">tarball</a>
of Emacs info files,
</li>
</ul>
<h2>Changes</h2>
<p>This is the
<a href="4.10/notes/Changes">changelog</a>.</p>
<p>(Changes that can break existing programs are marked with a &quot;*&quot;)</p>
<h3>Language features</h3>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/7757">#7757</a>, <a href="https://github.com/ocaml/ocaml/issues/1726">#1726</a>: multi-indices for extended indexing operators:
<code>a.%{0;1;2}</code> desugars to <code>( .%{ ;.. } ) a [|0;1;2|]</code>
(Florian Angeletti, review by Gabriel Radanne)
</li>
</ul>
<ul>
<li>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/1859">#1859</a>, <a href="https://github.com/ocaml/ocaml/issues/9117">#9117</a>: enforce safe (immutable) strings by removing
the -unsafe-string option by default. This can be overridden by
a configure-time option (available since 4.04 in 2016):
--disable-force-safe-string since 4.08, -no-force-safe-since
between 4.07 and 4.04.
In the force-safe-string mode (now the default), the return type of the
String_val macro in C stubs is <code>const char*</code> instead of
<code>char*</code>. This change may break C FFI code.
(Kate Deplaix)
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/6662">#6662</a>, <a href="https://github.com/ocaml/ocaml/issues/8908">#8908</a>: allow writing &quot;module _ = E&quot; to ignore module expressions
(Thomas Refis, review by Gabriel Radanne)
</li>
</ul>
<h3>Runtime system:</h3>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/8809">#8809</a>, <a href="https://github.com/ocaml/ocaml/issues/9292">#9292</a>: Add a best-fit allocator for the major heap; still
experimental, it should be much better than current allocation
policies (first-fit and next-fit) for programs with large heaps,
reducing both GC cost and memory usage.
This new best-fit is not (yet) the default; set it explicitly with
OCAMLRUNPARAM=&quot;a=2&quot; (or Gc.set from the program). You may also want
to increase the <code>space_overhead</code> parameter of the GC (a percentage,
80 by default), for example OCAMLRUNPARAM=&quot;o=85&quot;, for optimal
speed.
(Damien Doligez, review by Stephen Dolan, Jacques-Henri Jourdan,
Xavier Leroy, Leo White)
</li>
</ul>
<ul>
<li>
<p>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/8713">#8713</a>, <a href="https://github.com/ocaml/ocaml/issues/8940">#8940</a>, <a href="https://github.com/ocaml/ocaml/issues/9115">#9115</a>, <a href="https://github.com/ocaml/ocaml/issues/9143">#9143</a>, <a href="https://github.com/ocaml/ocaml/issues/9202">#9202</a>, <a href="https://github.com/ocaml/ocaml/issues/9251">#9251</a>:
Introduce a state table in the runtime to contain the global variables.
(The Multicore runtime will have one such state for each domain.)</p>
<p>This changes the status of some internal variables of the OCaml runtime;
in many cases the header file originally defining the internal variable
provides a compatibility macro with the old name, but programs
re-defining those variables by hand need to be fixed.</p>
<p>(KC Sivaramakrishnan and Stephen Dolan,
compatibility hacking by David Allsopp, Florian Angeletti, Kate Deplaix,
Jacques Garrigue, Guillaume Munch-Maccagnoni and Nicolás Ojeda Bär,
review by David Allsopp, Alain Frisch, Nicolas Ojeda Bar,
Gabriel Scherer, Damien Doligez, and Guillaume Munch-Maccagnoni)</p>
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/8993">#8993</a>: New C functions caml_process_pending_actions{,_exn} in
caml/signals.h, intended for executing all pending actions inside
long-running C functions (requested minor and major collections,
signal handlers, finalisers, and memprof callbacks). The function
caml_process_pending_actions_exn returns any exception arising
during their execution, allowing resources to be cleaned-up before
re-raising.
(Guillaume Munch-Maccagnoni, review by Jacques-Henri Jourdan,
Stephen Dolan, and Gabriel Scherer)
</li>
</ul>
<ul>
<li>
<p>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/8691">#8691</a>, <a href="https://github.com/ocaml/ocaml/issues/8897">#8897</a>, <a href="https://github.com/ocaml/ocaml/issues/9027">#9027</a>: Allocation functions are now guaranteed not to
trigger any OCaml callback when called from C. In long-running C
functions, this can be replaced with calls to
caml_process_pending_actions at safe points.
Side effect of this change: in bytecode mode, polling for
asynchronous callbacks is performed at every minor heap allocation,
in addition to function calls and loops as in previous OCaml
releases.
(Jacques-Henri Jourdan, review by Stephen Dolan, Gabriel Scherer and
Guillaume Munch-Maccagnoni)</p>
</li>
<li>
<p>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/9037">#9037</a>: caml_check_urgent_gc is now guaranteed not to trigger any
finaliser. In long-running C functions, this can be replaced
with calls to caml_process_pending_actions at safe points.
(Guillaume Munch-Maccagnoni, review by Jacques-Henri Jourdan and
Stephen Dolan)</p>
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8619">#8619</a>: Ensure Gc.minor_words remains accurate after a GC.
(Stephen Dolan, Xavier Leroy and David Allsopp,
review by Xavier Leroy and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8667">#8667</a>: Limit GC credit to 1.0
(Leo White, review by Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8670">#8670</a>: Fix stack overflow detection with systhreads
(Stephen Dolan, review by Xavier Leroy, Anil Madhavapeddy, Gabriel Scherer,
Frédéric Bour and Guillaume Munch-Maccagnoni)</p>
</li>
</ul>
<ul>
<li>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/8711">#8711</a>: The major GC hooks are no longer allowed to interact with the
OCaml heap.
(Jacques-Henri Jourdan, review by Damien Doligez)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8630">#8630</a>: Use abort() instead of exit(2) in caml_fatal_error, and add
the new hook caml_fatal_error_hook.
(Jacques-Henri Jourdan, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8641">#8641</a>: Better call stacks when a C call is involved in byte code mode
(Jacques-Henri Jourdan, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8634">#8634</a>, <a href="https://github.com/ocaml/ocaml/issues/8668">#8668</a>, <a href="https://github.com/ocaml/ocaml/issues/8684">#8684</a>, <a href="https://github.com/ocaml/ocaml/issues/9103">#9103</a> (originally <a href="https://github.com/ocaml/ocaml/issues/847">#847</a>): Statistical memory profiling.
In OCaml 4.10, support for allocations in the minor heap in native
mode is not available, and callbacks for promotions and
deallocations are not available.
Hence, there is not any public API for this feature yet.
(Jacques-Henri Jourdan, review by Stephen Dolan, Gabriel Scherer
and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9268">#9268</a>, <a href="https://github.com/ocaml/ocaml/issues/9271">#9271</a>: Fix bytecode backtrace generation with large integers present.
(Stephen Dolan and Mark Shinwell, review by Gabriel Scherer and
Jacques-Henri Jourdan)</p>
</li>
</ul>
<h3>Standard library:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8760">#8760</a>: List.concat_map : ('a -&gt; 'b list) -&gt; 'a list -&gt; 'b list
(Gabriel Scherer, review by Daniel Bünzli and Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8832">#8832</a>: List.find_map : ('a -&gt; 'b option) -&gt; 'a list -&gt; 'b option
(Gabriel Scherer, review by Jeremy Yallop, Nicolás Ojeda Bär
and Daniel Bünzli)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7672">#7672</a>, <a href="https://github.com/ocaml/ocaml/issues/1492">#1492</a>: Add <code>Filename.quote_command</code> to produce properly-quoted
commands for execution by Sys.command.
(Xavier Leroy, review by David Allsopp and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8971">#8971</a>: Add <code>Filename.null</code>, the conventional name of the &quot;null&quot; device.
(Nicolás Ojeda Bär, review by Xavier Leroy and Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8651">#8651</a>: add '%#F' modifier in printf to output OCaml float constants
in hexadecimal
(Pierre Roux, review by Gabriel Scherer and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8657">#8657</a>: Optimization in [Array.make] when initializing with unboxed
or young values.
(Jacques-Henri Jourdan, review by Gabriel Scherer and Stephen Dolan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8716">#8716</a>: Optimize [Array.fill] and [Hashtbl.clear] with a new runtime primitive
(Alain Frisch, review by David Allsopp, Stephen Dolan and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8530">#8530</a>: List.sort: avoid duplicate work by chop
(Guillaume Munch-Maccagnoni, review by David Allsopp, Damien Doligez and
Gabriel Scherer)</p>
</li>
</ul>
<h3>Other libraries:</h3>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/1939">#1939</a>, <a href="https://github.com/ocaml/ocaml/issues/2023">#2023</a>: Implement Unix.truncate and Unix.ftruncate on Windows.
(Florent Monnier and Nicolás Ojeda Bär, review by David Allsopp)
</li>
</ul>
<h3>Code generation and optimizations:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8806">#8806</a>: Add an [@@immediate64] attribute for types that are known to
be immediate only on 64 bit platforms
(Jérémie Dimino, review by Vladimir Keleshev)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9028">#9028</a>, <a href="https://github.com/ocaml/ocaml/issues/9032">#9032</a>: Fix miscompilation by no longer assuming that
untag_int (tag_int x) = x in Cmmgen; the compilation of <code>(n lsl 1) + 1</code>,
for example, would be incorrect if evaluated with a large value for <code>n</code>.
(Stephen Dolan, review by Vincent Laviron and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8672">#8672</a>: Optimise Switch code generation on booleans.
(Stephen Dolan, review by Pierre Chambart)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8990">#8990</a>: amd64: Emit 32bit registers for Iconst_int when we can
(Xavier Clerc, Tom Kelly and Mark Shinwell, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2322">#2322</a>: Add pseudo-instruction <code>Ladjust_trap_depth</code> to replace
dummy Lpushtrap generated in linearize
(Greta Yorsh and Vincent Laviron, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8707">#8707</a>: Simplif: more regular treatment of Tupled and Curried functions
(Gabriel Scherer, review by Leo White and Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8526">#8526</a>: Add compile-time option -function-sections in ocamlopt to emit
each function in a separate named text section on supported targets.
(Greta Yorsh, review by Pierre Chambart)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2321">#2321</a>: Eliminate dead ICatch handlers
(Greta Yorsh, review by Pierre Chambart and Vincent Laviron)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8919">#8919</a>: lift mutable lets along with immutable ones
(Leo White, review by Pierre Chambart)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8909">#8909</a>: Graph coloring register allocator: the weights put on
preference edges should not be divided by 2 in branches of
conditional constructs, because it is not good for performance
and because it leads to ignoring preference edges with 0 weight.
(Eric Stavarache, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9006">#9006</a>: int32 code generation improvements
(Stephen Dolan, designed with Greta Yorsh, review by Xavier Clerc,
Xavier Leroy and Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9041">#9041</a>: amd64: Avoid stall in sqrtsd by clearing destination.
(Stephen Dolan, with thanks to Andrew Hunter, Will Hasenplaugh,
Spiros Eliopoulos and Brian Nigito. Review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2165">#2165</a>: better unboxing heuristics for let-bound identifiers
(Alain Frisch, review by Vincent Laviron and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8735">#8735</a>: unbox across static handlers
(Alain Frisch, review by Vincent Laviron and Gabriel Scherer)</p>
</li>
</ul>
<h3>Manual and documentation:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8718">#8718</a>, <a href="https://github.com/ocaml/ocaml/issues/9089">#9089</a>: syntactic highlighting for code examples in the manual
(Florian Angeletti, report by Anton Kochkov, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9101">#9101</a>: add links to section anchor before the section title,
make the name of those anchor explicits.
(Florian Angeletti, review by Daniel Bünzli, Sébastien Hinderer,
and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9257">#9257</a>, cautionary guidelines for using the internal runtime API
without too much updating pain.
(Florian Angeletti, review by Daniel Bünzli, Guillaume Munch-Maccagnoni
and KC Sivaramakrishnan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8950">#8950</a>: move local opens in pattern out of the extension chapter
(Florian Angeletti, review and suggestion by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9088">#9088</a>, <a href="https://github.com/ocaml/ocaml/issues/9097">#9097</a>: fix operator character classes
(Florian Angelettion, review by Gabriel Scherer,
report by Clément Busschaert)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9169">#9169</a>: better documentation for the best-fit allocation policy
(Gabriel Scherer, review by Guillaume Munch-Maccagnoni
and Florian Angeletti)</p>
</li>
</ul>
<h3>Compiler user-interface and warnings:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8833">#8833</a>: Hint for (type) redefinitions in toplevel session
(Florian Angeletti, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2127">#2127</a>, <a href="https://github.com/ocaml/ocaml/issues/9185">#9185</a>: Refactor lookup functions
Included observable changes:</p>
<ul>
<li>makes the location of usage warnings and alerts for constructors more
precise
</li>
<li>don't warn about a constructor never being used to build values when it
has been defined as private
(Leo White, Hugo Heuzard review by Thomas Refis, Florian Angeletti)
</li>
</ul>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8702">#8702</a>, <a href="https://github.com/ocaml/ocaml/issues/8777">#8777</a>: improved error messages for fixed row polymorphic variants
(Florian Angeletti, report by Leo White, review by Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8844">#8844</a>: Printing faulty constructors, inline records fields and their types
during type mismatches. Also slightly changed other type mismatches error
output.
(Mekhrubon Turaev, review by Florian Angeletti, Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8885">#8885</a>: Warn about unused local modules
(Thomas Refis, review by Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8872">#8872</a>: Add ocamlc option &quot;-output-complete-exe&quot; to build a self-contained
binary for bytecode programs, containing the runtime and C stubs.
(Stéphane Glondu, Nicolás Ojeda Bär, review by Jérémie Dimino and Daniel
Bünzli)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8874">#8874</a>: add tests for typechecking error messages and pack them into
pretty-printing boxes.
(Oxana Kostikova, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8891">#8891</a>: Warn about unused functor parameters
(Thomas Refis, review by Gabriel Radanne)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8903">#8903</a>: Improve errors for first-class modules
(Leo White, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8914">#8914</a>: clarify the warning on unboxable types used in external primitives (61)
(Gabriel Scherer, review by Florian Angeletti, report on the Discourse forum)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9046">#9046</a>: disable warning 30 by default
This outdated warning complained on label/constructor name conflicts
within a mutually-recursive type declarations; there is now no need
to complain thanks to type-based disambiguation.
(Gabriel Scherer)</p>
</li>
</ul>
<h3>Tools:</h3>
<ul>
<li>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/6792">#6792</a>, <a href="https://github.com/ocaml/ocaml/issues/8654">#8654</a> ocamldebug now supports programs using Dynlink. This
changes ocamldebug messages, which may break compatibility
with older emacs modes.
(Whitequark and Jacques-Henri Jourdan, review by Gabriel Scherer
and Xavier Clerc)
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/8621">#8621</a>: Make ocamlyacc a Windows Unicode application
(David Allsopp, review by Nicolás Ojeda Bär)
</li>
</ul>
<ul>
<li>[<em>breaking change</em>] <a href="https://github.com/ocaml/ocaml/issues/8834">#8834</a>, <code>ocaml</code>: adhere to the XDG base directory specification to
locate an <code>.ocamlinit</code> file. Reads an <code>$XDG_CONFIG_HOME/ocaml/init.ml</code>
file before trying to lookup <code>~/.ocamlinit</code>. On Windows the behaviour
is unchanged.
(Daniel C. Bünzli, review by David Allsopp, Armaël Guéneau and
Nicolás Ojeda Bär)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9113">#9113</a>: ocamldoc: fix the rendering of multi-line code blocks
in the 'man' backend.
(Gabriel Scherer, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9127">#9127</a>, <a href="https://github.com/ocaml/ocaml/issues/9130">#9130</a>: ocamldoc: fix the formatting of closing brace in record types.
(David Allsopp, report by San Vu Ngoc)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9181">#9181</a>: make objinfo work on Cygwin and look for the caml_plugin_header
symbol in both the static and the dynamic symbol tables.
(Sébastien Hinderer, review by Gabriel Scherer and David Allsopp)</p>
</li>
</ul>
<h3>Build system:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8840">#8840</a>: use ocaml{c,opt}.opt when available to build internal tools
On my machine this reduces parallel-build times from 3m30s to 2m50s.
(Gabriel Scherer, review by Xavier Leroy and Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8650">#8650</a>: ensure that &quot;make&quot; variables are defined before use;
revise generation of config/util.ml to better quote special characters
(Xavier Leroy, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8690">#8690</a>, <a href="https://github.com/ocaml/ocaml/issues/8696">#8696</a>: avoid rebuilding the world when files containing primitives
change.
(Stephen Dolan, review by Gabriel Scherer, Sébastien Hinderer and
Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8835">#8835</a>: new configure option --disable-stdlib-manpages to disable building
and installation of the library manpages.
(David Allsopp, review by Florian Angeletti and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8837">#8837</a>: build manpages using ocamldoc.opt when available
cuts the manpages build time from 14s to 4s
(Gabriel Scherer, review by David Allsopp and Sébastien Hinderer,
report by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8843">#8843</a>, <a href="https://github.com/ocaml/ocaml/issues/8841">#8841</a>: fix use of off_t on 32-bit systems.
(Stephen Dolan, report by Richard Jones, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8947">#8947</a>, <a href="https://github.com/ocaml/ocaml/issues/9134">#9134</a>, <a href="https://github.com/ocaml/ocaml/issues/9302">#9302</a>, <a href="https://github.com/ocaml/ocaml/issues/9311">#9311</a>: fix/improve support for the BFD library
(Sébastien Hinderer, review by Damien Doligez and David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8951">#8951</a>: let make's default target build the compiler
(Sébastien Hinderer, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8995">#8995</a>: allow developers to specify frequently-used configure options in
Git (ocaml.configure option) and a directory for host-specific, shareable
config.cache files (ocaml.configure-cache option). See HACKING.adoc for
further details.
(David Allsopp, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9136">#9136</a>: Don't propagate Cygwin-style prefix from configure to
Makefile.config on Windows ports.
(David Allsopp, review by Sébastien Hinderer)</p>
</li>
</ul>
<h3>Internal/compiler-libs changes:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8828">#8828</a>: Added abstractions for variants, records, constructors, fields and
extension constructor types mismatch.
(Mekhrubon Turaev, review by Florian Angeletti, Leo White and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7927">#7927</a>, <a href="https://github.com/ocaml/ocaml/issues/8527">#8527</a>: Replace long tuples into records in typeclass.ml
(Ulugbek Abdullaev, review by David Allsopp and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/1963">#1963</a>: split cmmgen into generic Cmm helpers and clambda transformations
(Vincent Laviron, review by Mark Shinwell)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/1901">#1901</a>: Fix lexing of character literals in comments
(Pieter Goetschalckx, review by Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/1932">#1932</a>: Allow octal escape sequences and identifiers containing apostrophes
in ocamlyacc actions and comments.
(Pieter Goetschalckx, review by Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2288">#2288</a>: Move middle end code from [Asmgen] to [Clambda_middle_end] and
[Flambda_middle_end].  Run [Un_anf] from the middle end, not [Cmmgen].
(Mark Shinwell, review by Pierre Chambart)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8692">#8692</a>: Remove Misc.may_map and similar
(Leo White, review by Gabriel Scherer and Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8677">#8677</a>: Use unsigned comparisons in amd64 and i386 emitter of Lcondbranch3.
(Greta Yorsh, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8766">#8766</a>: Parmatch: introduce a type for simplified pattern heads
(Gabriel Scherer and Thomas Refis, review by Stephen Dolan and
Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8774">#8774</a>: New implementation of Env.make_copy_of_types
(Alain Frisch, review by Thomas Refis, Leo White and Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7924">#7924</a>: Use a variant instead of an int in Bad_variance exception
(Rian Douglas, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8890">#8890</a>: in -dtimings output, show time spent in C linker clearly
(Valentin Gatien-Baron)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8910">#8910</a>, <a href="https://github.com/ocaml/ocaml/issues/8911">#8911</a>: minor improvements to the printing of module types
(Gabriel Scherer, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8913">#8913</a>: ocamltest: improve 'promote' implementation to take
skipped lines/bytes into account
(Gabriel Scherer, review by Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8908">#8908</a>: Use an option instead of a string for module names (&quot;_&quot; becomes None),
and a dedicated type for functor parameters: &quot;()&quot; maps to &quot;Unit&quot; (instead of
&quot;*&quot;).
(Thomas Refis, review by Gabriel Radanne)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8928">#8928</a>: Move contains_calls and num_stack_slots from Proc to Mach.fundecl
(Greta Yorsh, review by Florian Angeletti and Vincent Laviron)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8959">#8959</a>, <a href="https://github.com/ocaml/ocaml/issues/8960">#8960</a>, <a href="https://github.com/ocaml/ocaml/issues/8968">#8968</a>, <a href="https://github.com/ocaml/ocaml/issues/9023">#9023</a>: minor refactorings in the typing of patterns:</p>
<ul>
<li>refactor the {let,pat}_bound_idents* functions
</li>
<li>minor bugfix in type_pat
</li>
<li>refactor the generic pattern-traversal functions
in Typecore and Typedtree
</li>
<li>restrict the use of Need_backtrack
(Gabriel Scherer and Florian Angeletti,
review by Thomas Refis and Gabriel Scherer)
</li>
</ul>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9030">#9030</a>: clarify and document the parameter space of type_pat
(Gabriel Scherer and Florian Angeletti and Jacques Garrigue,
review by Florian Angeletti and Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8975">#8975</a>: &quot;ocamltests&quot; files are no longer required or used by
&quot;ocamltest&quot;. Instead, any text file in the testsuite directory containing a
valid &quot;TEST&quot; block will be automatically included in the testsuite.
(Nicolás Ojeda Bär, review by Gabriel Scherer and Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8992">#8992</a>: share argument implementations between executables
(Florian Angeletti, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9015">#9015</a>: fix fatal error in pprint_ast (<a href="https://github.com/ocaml/ocaml/issues/8789">#8789</a>)
(Damien Doligez, review by ...)</p>
</li>
</ul>
<h3>Bug fixes:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/5673">#5673</a>, <a href="https://github.com/ocaml/ocaml/issues/7636">#7636</a>: unused type variable causes generalization error
(Jacques Garrigue and Leo White, review by Leo White,
reports by Jean-Louis Giavitto and Christophe Raffalli)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/6922">#6922</a>, <a href="https://github.com/ocaml/ocaml/issues/8955">#8955</a>: Fix regression with -principal type inference for inherited
methods, allowing to compile ocamldoc with -principal
(Jacques Garrigue, review by Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7925">#7925</a>, <a href="https://github.com/ocaml/ocaml/issues/8611">#8611</a>: fix error highlighting for exceptionally
long toplevel phrases
(Kyle Miller, reported by Armaël Guéneau, review by Armaël Guéneau
and Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8622">#8622</a>: Don't generate #! headers over 127 characters.
(David Allsopp, review by Xavier Leroy and Stephen Dolan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8715">#8715</a>: minor bugfixes in CamlinternalFormat; removes the unused
and misleading function CamlinternalFormat.string_of_formatting_gen
(Gabriel Scherer and Florian Angeletti,
review by Florian Angeletti and Gabriel Radanne)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8792">#8792</a>, <a href="https://github.com/ocaml/ocaml/issues/9018">#9018</a>: Possible (latent) bug in Ctype.normalize_type
removed incrimined Btype.log_type, replaced by Btype.set_type
(Jacques Garrigue, report by Alain Frisch, review by Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8856">#8856</a>, <a href="https://github.com/ocaml/ocaml/issues/8860">#8860</a>: avoid stackoverflow when printing cyclic type expressions
in some error submessages.
(Florian Angeletti, report by Mekhrubon Turaev, review by Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8875">#8875</a>: fix missing newlines in the output from MSVC invocation.
(Nicolás Ojeda Bär, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8921">#8921</a>, <a href="https://github.com/ocaml/ocaml/issues/8924">#8924</a>: Fix stack overflow with Flambda
(Vincent Laviron, review by Pierre Chambart and Leo White,
report by Aleksandr Kuzmenko)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8892">#8892</a>, <a href="https://github.com/ocaml/ocaml/issues/8895">#8895</a>: fix the definition of Is_young when CAML_INTERNALS is not
defined.
(David Allsopp, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8896">#8896</a>: deprecate addr typedef in misc.h
(David Allsopp, suggestion by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8981">#8981</a>: Fix check for incompatible -c and -o options.
(Greta Yorsh, review by Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9019">#9019</a>, <a href="https://github.com/ocaml/ocaml/issues/9154">#9154</a>: Unsound exhaustivity of GADTs from incomplete unification
Also fixes bug found by Thomas Refis in <a href="https://github.com/ocaml/ocaml/issues/9012">#9012</a>
(Jacques Garrigue, report and review by Leo White, Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9031">#9031</a>: Unregister Windows stack overflow handler while shutting
the runtime down.
(Dmitry Bely, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9051">#9051</a>: fix unregistered local root in win32unix/select.c (could result in
<code>select</code> returning file_descr-like values which weren't in the original sets)
and correct initialisation of some blocks allocated with caml_alloc_small.
(David Allsopp, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9073">#9073</a>, <a href="https://github.com/ocaml/ocaml/issues/9120">#9120</a>: fix incorrect GC ratio multiplier when allocating custom blocks
with caml_alloc_custom_mem in runtime/custom.c
(Markus Mottl, review by Gabriel Scherer and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/9209">#9209</a>, <a href="https://github.com/ocaml/ocaml/issues/9212">#9212</a>: fix a development-version regression caused by <a href="https://github.com/ocaml/ocaml/issues/2288">#2288</a>
(Kate Deplaix and David Allsopp, review by Sébastien Hinderer
and Gabriel Scherer )</p>
</li>
</ul>
|js}
  };
 
  { kind = `Compiler
  ; version = {js|4.09.0|js}
  ; date = {js|2019-09-18|js}
  ; intro_md = {js|This page describes OCaml version **4.09.0**, released on 2019-09-18. 
|js}
  ; intro_html = {js|<p>This page describes OCaml version <strong>4.09.0</strong>, released on 2019-09-18.</p>
|js}
  ; highlights_md = {js|- New optimisations, in particular for affine functions in matches, for instance
  ```ocaml
    type t = A | B | C
    let affine = function
      | A -> 4
      | B -> 3
      | C -> 2
  ```
- The `graphics` library was moved out of the compiler distribution. - The `vmthread` library was removed. - Support for compiler plugins was removed. - Many bug fixes.
|js}
  ; highlights_html = {js|<ul>
<li>New optimisations, in particular for affine functions in matches, for instance
<pre><code class="language-ocaml">  type t = A | B | C
  let affine = function
    | A -&gt; 4
    | B -&gt; 3
    | C -&gt; 2
</code></pre>
</li>
<li>The <code>graphics</code> library was moved out of the compiler distribution. - The <code>vmthread</code> library was removed. - Support for compiler plugins was removed. - Many bug fixes.
</li>
</ul>
|js}
  ; body_md = {js|
Opam Switches
-------------

This release is available as multiple
[OPAM](https://opam.ocaml.org/doc/Usage.html) switches:

- 4.09.0 — Official release 4.09.0
- 4.09.0+flambda — Official release 4.09.0, with flambda activated

- 4.09.0+afl — Official release 4.09.0, with afl-fuzz instrumentation
- 4.09.0+spacetime - Official 4.09.0 release with spacetime activated

- 4.09.0+force-safe-string — Official release 4.09.0, with safe string
  forced globally
- 4.09.0+default-unsafe-string — Official release 4.09.0, without
  safe strings by default
- 4.09.0+no-flat-float-array - Official release 4.09.0, with
  --disable-flat-float-array
- 4.09.0+flambda+no-flat-float-array — Official release 4.09.0, with
  flambda activated and --disable-flat-float-array
- 4.09.0+fp — Official release 4.09.0, with frame-pointers
- 4.09.0+fp+flambda — Official release 4.09.0, with frame-pointers
  and flambda activated
- 4.09.0+musl+static+flambda - Official release 4.09.0, compiled with
  musl-gcc -static and with flambda activated

- 4.09.0+32bit - Official release 4.09.0, compiled in 32-bit mode
  for 64-bit Linux and OS X hosts
- 4.09.0+bytecode-only - Official release 4.09.0, without the
  native-code compiler


What's new
----------

Some of the highlights in release 4.09 are:

- New optimisations, in particular for affine functions in matches, for instance
 ```ocaml
  type t = A | B | C
  let affine = function
    | A -> 4
    | B -> 3
    | C -> 2
```
- The `graphics` library was moved out of the compiler distribution.
- The `vmthread` library was removed.
- Support for compiler plugins was removed.
- Many bug fixes.

For a comprehensive list of changes and details on all new features,
bug fixes, optimizations, etc., please consult the
[changelog](#Changes).

Source distribution
---------------------------------------------

- [Source
  tarball](https://github.com/ocaml/ocaml/archive/4.09.0.tar.gz)
  (.tar.gz) for compilation under Unix (including Linux and MacOS X)
  and Microsoft Windows (including Cygwin).
- Also available in
  [.zip](https://github.com/ocaml/ocaml/archive/4.09.0.zip)
  format.
- [OPAM](https://opam.ocaml.org/) is a source-based distribution of
  OCaml and many companion libraries and tools. Compilation and
  installation are automated by powerful package managers.
- The official development repo is hosted on
  [GitHub](https://github.com/ocaml/ocaml).

The
[INSTALL](4.09/notes/INSTALL.adoc) file
of the distribution provides detailed compilation and installation
instructions — see also the [Windows release
notes](4.09/notes/README.win32.adoc) for
instructions on how to build under Windows.

Alternative Compilers
---------------------

Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:

* [Js_of_ocaml](http://ocsigen.org/js_of_ocaml/) is a stable OCaml
  to JavaScript compiler.
* [Bucklescript](http://bucklescript.github.io/bucklescript/) is a
  newer OCaml to JavaScript compiler. See its
  [wiki](https://github.com/bucklescript/bucklescript/wiki/Differences-from-js_of_ocaml) for
  an explanation of how it differs from `js_of_ocaml`.
* [OCaml-java](http://www.ocamljava.org/) is a stable OCaml to
  Java compiler.

User's manual
------------------------------------

The user's manual for OCaml can be:

- [browsed
  online](4.09/htmlman/index.html),
- downloaded as a single
  [PDF](4.09/ocaml-4.09-refman.pdf),
  or [plain
  text](4.09/ocaml-4.09-refman.txt)
  document,
- downloaded as a single
  [TAR](4.09/ocaml-4.09-refman-html.tar.gz)
  or
  [ZIP](4.09/ocaml-4.09-refman-html.zip)
  archive of HTML files,
- downloaded as a single
  [tarball](4.09/ocaml-4.09-refman.info.tar.gz)
  of Emacs info files,



Changes
-------

This is the
[changelog](4.09/notes/Changes).


### Runtime system:

* (*breaking change*) [#1725](https://github.com/ocaml/ocaml/issues/1725), [#2279](https://github.com/ocaml/ocaml/issues/2279): Deprecate Obj.set_tag and Obj.truncate
  (Stephen Dolan, review by Gabriel Scherer, Damien Doligez and Xavier Leroy)

* (*breaking change*) [#2240](https://github.com/ocaml/ocaml/issues/2240): Constify "identifier" in struct custom_operations
  (Cedric Cellier, review by Xavier Leroy)

* (*breaking change*) [#2293](https://github.com/ocaml/ocaml/issues/2293): Constify "caml_named_value"
  (Stephen Dolan, review by Xavier Leroy)

- [#8787](https://github.com/ocaml/ocaml/issues/8787), [#8788](https://github.com/ocaml/ocaml/issues/8788): avoid integer overflow in caml_output_value_to_bytes
  (Jeremy Yallop, report by Marcello Seri)


- [#2075](https://github.com/ocaml/ocaml/issues/2075), [#7729](https://github.com/ocaml/ocaml/issues/7729): rename _T macro used to support Unicode in the (Windows) runtime
  in order to avoid compiler warning
  (Nicolás Ojeda Bär, review by Gabriel Scherer and David Allsopp)

- [#2250](https://github.com/ocaml/ocaml/issues/2250): Remove extra integer sign-extension in compare functions
  (Stefan Muenzel, review by Xavier Leroy)

- [#8607](https://github.com/ocaml/ocaml/issues/8607): Remove obsolete macros for pre-2002 MSVC support
  (Stephen Dolan, review by Nicolás Ojeda Bär and David Allsopp)

- [#8656](https://github.com/ocaml/ocaml/issues/8656): Fix a bug in [caml_modify_generational_global_root]
  (Jacques-Henri Jourdan, review by Gabriel Scherer)

### Standard library:

- [#2262](https://github.com/ocaml/ocaml/issues/2262): take precision (.<n>) and flags ('+' and ' ') into account
  in printf %F
  (Pierre Roux, review by Gabriel Scherer)

- [#6148](https://github.com/ocaml/ocaml/issues/6148), [#8596](https://github.com/ocaml/ocaml/issues/8596): optimize some buffer operations
  (Damien Doligez, reports by John Whitington and Alain Frisch,
   review by Jeremy Yallop and Gabriel Scherer)

### Other libraries:

* (*breaking change*) [#2318](https://github.com/ocaml/ocaml/issues/2318): Delete the graphics library. This library is now available
  as a separate "graphics" package in opam. Its new home is:
  https://github.com/ocaml/graphics
  (Jérémie Dimino, review by Nicolas Ojeda Bar, Xavier Leroy and
   Sébastien Hinderer)

* (*breaking change*) [#2289](https://github.com/ocaml/ocaml/issues/2289): Delete the vmthreads library. This library was deprecated in 4.08.0.
  (Jérémie Dimino)

- [#2112](https://github.com/ocaml/ocaml/issues/2112): Fix Thread.yield unfairness with busy threads yielding to each
  other.
  (Andrew Hunter, review by Jacques-Henri Jourdan, Spiros Eliopoulos, Stephen
  Weeks, & Mark Shinwell)

- [#7903](https://github.com/ocaml/ocaml/issues/7903), [#2306](https://github.com/ocaml/ocaml/issues/2306): Make Thread.delay interruptible by signals again
  (Xavier Leroy, review by Jacques-Henri Jourdan and Edwin Török)

- [#2248](https://github.com/ocaml/ocaml/issues/2248): Unix alloc_sockaddr: Fix read of uninitialized memory for an
  unbound Unix socket. Add support for receiving abstract (Linux) socket paths.
  (Tim Cuthbertson, review by Sébastien Hinderer and Jérémie Dimino)

### Compiler user-interface and warnings:

* (*breaking change*) [#2276](https://github.com/ocaml/ocaml/issues/2276): Remove support for compiler plugins and hooks (also adds
  [Dynlink.unsafe_get_global_value])
  (Mark Shinwell, Xavier Clerc, review by Nicolás Ojeda Bär,
  Florian Angeletti, David Allsopp and Xavier Leroy)

- [#2301](https://github.com/ocaml/ocaml/issues/2301): Hint on type error on int literal
  (Jules Aguillon, review by Nicolás Ojeda Bär , Florian Angeletti,
  Gabriel Scherer and Armaël Guéneau)

* (*breaking change*) [#2314](https://github.com/ocaml/ocaml/issues/2314): Remove support for gprof profiling.
  (Mark Shinwell, review by Xavier Clerc and Stephen Dolan)

- [#2190](https://github.com/ocaml/ocaml/issues/2190): fix pretty printing (using Pprintast) of "lazy ..." patterns and
  "fun (type t) -> ..." expressions.
  (Nicolás Ojeda Bär, review by Gabriel Scherer)

- [#2277](https://github.com/ocaml/ocaml/issues/2277): Use newtype names as type variable names
  The inferred type of (fun (type t) (x : t) -> x)
  is now printed as ('t -> 't) rather than ('a -> 'a).
  (Matthew Ryan)


- [#2309](https://github.com/ocaml/ocaml/issues/2309): New options -with-runtime and -without-runtime in ocamlopt/ocamlc
  that control the inclusion of the runtime system in the generated program.
  (Lucas Pluvinage, review by Daniel Bünzli, Damien Doligez, David Allsopp
   and Florian Angeletti)

- [#3819](https://github.com/ocaml/ocaml/issues/3819), [#8546](https://github.com/ocaml/ocaml/issues/8546) more explanations and tests for illegal permutation
  (Florian Angeletti, review by Gabriel Scherer)

- [#8537](https://github.com/ocaml/ocaml/issues/8537): fix the -runtime-variant option for bytecode
  (Damien Doligez, review by David Allsopp)

- [#8541](https://github.com/ocaml/ocaml/issues/8541): Correctly print multi-lines locations
  (Louis Roché, review by Gabriel Scherer)

- [#8579](https://github.com/ocaml/ocaml/issues/8579): Better error message for private constructors
  of an extensible variant type
  (Guillaume Bury, review by many fine eyes)

### Code generation and optimizations:

- [#2278](https://github.com/ocaml/ocaml/issues/2278): Remove native code generation support for 32-bit Intel macOS,
  iOS and other Darwin targets.
  (Mark Shinwell, review by Nicolas Ojeda Bar and Xavier Leroy)

- [#8547](https://github.com/ocaml/ocaml/issues/8547): Optimize matches that are an affine function of the input.
  (Stefan Muenzel, review by Alain Frisch, Gabriel Scherer)


- [#1904](https://github.com/ocaml/ocaml/issues/1904), [#7931](https://github.com/ocaml/ocaml/issues/7931): Add FreeBSD/aarch64 support
  (Greg V, review by Sébastien Hinderer, Stephen Dolan, Damien Doligez
   and Xavier Leroy)

- [#8507](https://github.com/ocaml/ocaml/issues/8507): Shorten symbol names of anonymous functions in Flambda mode
  (the directory portions are now hidden)
  (Mark Shinwell, review by Nicolás Ojeda Bär)

- [#8681](https://github.com/ocaml/ocaml/issues/8681), [#8699](https://github.com/ocaml/ocaml/issues/8699), [#8712](https://github.com/ocaml/ocaml/issues/8712): Fix code generation with nested let rec of functions.
  (Stephen Dolan, Leo White, Gabriel Scherer and Pierre Chambart,
   review by Gabriel Scherer, reports by Alexey Solovyev and Jonathan French)

### Manual and documentation:

- [#7584](https://github.com/ocaml/ocaml/issues/7584), [#8538](https://github.com/ocaml/ocaml/issues/8538): Document .cmt* files in the "overview" of ocaml{c,opt}
  (Oxana Kostikova, rewiew by Florian Angeletti)


- [#8757](https://github.com/ocaml/ocaml/issues/8757): Rename Pervasives to Stdlib in core library documentation.
  (Ian Zimmerman, review by David Allsopp)

- [#8515](https://github.com/ocaml/ocaml/issues/8515): manual, precise constraints on reexported types
  (Florian Angeletti, review by Gabriel Scherer)

### Tools:

- [#2221](https://github.com/ocaml/ocaml/issues/2221): ocamldep will now correctly allow a .ml file in an include directory
  that appears first in the search order to shadow a .mli appearing in a later
  include directory.
  (Nicolás Ojeda Bär, review by Florian Angeletti)

### Internal/compiler-libs changes:

- [#1579](https://github.com/ocaml/ocaml/issues/1579): Add a separate types for clambda primitives
  (Pierre Chambart, review by Vincent Laviron and Mark Shinwell)

- [#1965](https://github.com/ocaml/ocaml/issues/1965): remove loop constructors in Cmm and Mach
  (Vincent Laviron)

- [#1973](https://github.com/ocaml/ocaml/issues/1973): fix compilation of catches with multiple handlers
  (Vincent Laviron)

- [#2228](https://github.com/ocaml/ocaml/issues/2228), [#8545](https://github.com/ocaml/ocaml/issues/8545): refactoring the handling of .cmi files
  by moving the logic from Env to a new module Persistent_env
  (Gabriel Scherer, review by Jérémie Dimino and Thomas Refis)

- [#2229](https://github.com/ocaml/ocaml/issues/2229): Env: remove prefix_idents cache
  (Thomas Refis, review by Frédéric Bour and Gabriel Scherer)

- [#2237](https://github.com/ocaml/ocaml/issues/2237), [#8582](https://github.com/ocaml/ocaml/issues/8582): Reorder linearisation of Trywith to avoid a call instruction
  (Vincent Laviron and Greta Yorsh, additional review by Mark Shinwell;
  fix in [#8582](https://github.com/ocaml/ocaml/issues/8582) by Mark Shinwell, Xavier Leroy and Anil Madhavapeddy)

- [#2265](https://github.com/ocaml/ocaml/issues/2265): Add bytecomp/opcodes.mli
  (Mark Shinwell, review by Nicolas Ojeda Bar)

- [#2268](https://github.com/ocaml/ocaml/issues/2268): Improve packing mechanism used for building compilerlibs modules
  into the Dynlink libraries
  (Mark Shinwell, Stephen Dolan, review by David Allsopp)

- [#2280](https://github.com/ocaml/ocaml/issues/2280): Don't make more Clambda constants after starting Cmmgen
  (Mark Shinwell, review by Vincent Laviron)

- [#2281](https://github.com/ocaml/ocaml/issues/2281): Move some middle-end files around
  (Mark Shinwell, review by Pierre Chambart and Vincent Laviron)

- [#2283](https://github.com/ocaml/ocaml/issues/2283): Add [is_prefix] and [find_and_chop_longest_common_prefix] to
  [Misc.Stdlib.List]
  (Mark Shinwell, review by Alain Frisch and Stephen Dolan)

- [#2284](https://github.com/ocaml/ocaml/issues/2284): Add various utility functions to [Misc] and remove functions
  from [Misc.Stdlib.Option] that are now in [Stdlib.Option]
  (Mark Shinwell, review by Thomas Refis)

- [#2286](https://github.com/ocaml/ocaml/issues/2286): Functorise [Consistbl]
  (Mark Shinwell, review by Gabriel Radanne)

- [#2291](https://github.com/ocaml/ocaml/issues/2291): Add [Compute_ranges] pass
  (Mark Shinwell, review by Vincent Laviron)

- [#2292](https://github.com/ocaml/ocaml/issues/2292): Add [Proc.frame_required] and [Proc.prologue_required].
  Move tail recursion label creation to [Linearize].  Correctly position
  [Lprologue] relative to [Iname_for_debugger] operations.
  (Mark Shinwell, review by Vincent Laviron)

- [#2308](https://github.com/ocaml/ocaml/issues/2308): More debugging information on [Cmm] terms
  (Mark Shinwell, review by Stephen Dolan)

- [#7878](https://github.com/ocaml/ocaml/issues/7878), [#8542](https://github.com/ocaml/ocaml/issues/8542): Replaced TypedtreeIter with tast_iterator
  (Isaac "Izzy" Avram, review by Gabriel Scherer and Nicolás Ojeda Bär)

- [#8598](https://github.com/ocaml/ocaml/issues/8598): Replace "not is_nonexpansive" by "maybe_expansive".
  (Thomas Refis, review by David Allsopp, Florian Angeletti, Gabriel Radanne,
   Gabriel Scherer and Xavier Leroy)

### Compiler distribution build system:

- [#2267](https://github.com/ocaml/ocaml/issues/2267): merge generation of header programs, also fixing parallel build on
  Cygwin.
  (David Allsopp, review by Sébastien Hinderer)

- [#8514](https://github.com/ocaml/ocaml/issues/8514): Use boot/ocamlc.opt for building, if available.
  (Stephen Dolan, review by Gabriel Scherer)

### Bug fixes:

- [#8864](https://github.com/ocaml/ocaml/issues/8864), [#8865](https://github.com/ocaml/ocaml/issues/8865): Fix native compilation of left shift by (word_size - 1)
  (Vincent Laviron, report by Murilo Giacometti Rocha, review by Xavier Leroy)

- [#2296](https://github.com/ocaml/ocaml/issues/2296): Fix parsing of hexadecimal floats with underscores in the exponent.
  (Hugo Heuzard and Xavier Leroy, review by Gabriel Scherer)

- [#8800](https://github.com/ocaml/ocaml/issues/8800): Fix soundness bug in extension constructor inclusion
  (Leo White, review by Jacques Garrigue)

- [#8848](https://github.com/ocaml/ocaml/issues/8848): Fix x86 stack probe CFI information in caml_c_call and
  caml_call_gc
  (Tom Kelly, review by Xavier Leroy)


- [#7156](https://github.com/ocaml/ocaml/issues/7156), [#8594](https://github.com/ocaml/ocaml/issues/8594): make top level use custom printers if they are available
  (Andrew Litteken, report by Martin Jambon, review by Nicolás Ojeda Bär,
   Thomas Refis, Armaël Guéneau, Gabriel Scherer, David Allsopp)

- [#3249](https://github.com/ocaml/ocaml/issues/3249): ocamlmklib should reject .cmxa files
  (Xavier Leroy)

- [#7937](https://github.com/ocaml/ocaml/issues/7937), [#2287](https://github.com/ocaml/ocaml/issues/2287): fix uncaught Unify exception when looking for type
  declaration
  (Florian Angeletti, review by Jacques Garrigue)

- [#8610](https://github.com/ocaml/ocaml/issues/8610), [#8613](https://github.com/ocaml/ocaml/issues/8613): toplevel printing, consistent deduplicated name for types
  (Florian Angeletti, review by Thomas Refis and Gabriel Scherer,
   reported by Xavier Clerc)

- [#8635](https://github.com/ocaml/ocaml/issues/8635), [#8636](https://github.com/ocaml/ocaml/issues/8636): Fix a bad side-effect of the -allow-approx option of
  ocamldep. It used to turn some errors into successes
  (Jérémie Dimino)

- [#8701](https://github.com/ocaml/ocaml/issues/8701), [#8725](https://github.com/ocaml/ocaml/issues/8725): Variance of constrained parameters causes principality issues
  (Jacques Garrigue, report by Leo White, review by Gabriel Scherer)

- [#8777](https://github.com/ocaml/ocaml/issues/8777)(partial): fix position information in some polymorphic variant
  error messages about missing tags
  (Florian Angeletti, review by Thomas Refis)

- [#8779](https://github.com/ocaml/ocaml/issues/8779), more cautious variance computation to avoid missing cmis
  (Florian Angeletti, report by Antonio Nuno Monteiro, review by Leo White)

- [#8810](https://github.com/ocaml/ocaml/issues/8810): Env.lookup_module: don't allow creating loops
  (Thomas Refis, report by Leo White, review by Jacques Garrigue)

- [#8862](https://github.com/ocaml/ocaml/issues/8862), [#8871](https://github.com/ocaml/ocaml/issues/8871): subst: preserve scopes
  (Thomas Refis, report by Leo White, review by Jacques Garrigue)

- [#8921](https://github.com/ocaml/ocaml/issues/8921), [#8924](https://github.com/ocaml/ocaml/issues/8924): Fix stack overflow with Flambda
  (Vincent Laviron, review by Pierre Chambart and Leo White,
   report by Aleksandr Kuzmenko)

- [#8944](https://github.com/ocaml/ocaml/issues/8944): Fix "open struct .. end" on clambda backend
  (Thomas Refis, review by Leo White, report by Damon Wang and Mark Shinwell)
|js}
  ; body_html = {js|<h2>Opam Switches</h2>
<p>This release is available as multiple
<a href="https://opam.ocaml.org/doc/Usage.html">OPAM</a> switches:</p>
<ul>
<li>
<p>4.09.0 — Official release 4.09.0</p>
</li>
<li>
<p>4.09.0+flambda — Official release 4.09.0, with flambda activated</p>
</li>
<li>
<p>4.09.0+afl — Official release 4.09.0, with afl-fuzz instrumentation</p>
</li>
<li>
<p>4.09.0+spacetime - Official 4.09.0 release with spacetime activated</p>
</li>
<li>
<p>4.09.0+force-safe-string — Official release 4.09.0, with safe string
forced globally</p>
</li>
<li>
<p>4.09.0+default-unsafe-string — Official release 4.09.0, without
safe strings by default</p>
</li>
<li>
<p>4.09.0+no-flat-float-array - Official release 4.09.0, with
--disable-flat-float-array</p>
</li>
<li>
<p>4.09.0+flambda+no-flat-float-array — Official release 4.09.0, with
flambda activated and --disable-flat-float-array</p>
</li>
<li>
<p>4.09.0+fp — Official release 4.09.0, with frame-pointers</p>
</li>
<li>
<p>4.09.0+fp+flambda — Official release 4.09.0, with frame-pointers
and flambda activated</p>
</li>
<li>
<p>4.09.0+musl+static+flambda - Official release 4.09.0, compiled with
musl-gcc -static and with flambda activated</p>
</li>
<li>
<p>4.09.0+32bit - Official release 4.09.0, compiled in 32-bit mode
for 64-bit Linux and OS X hosts</p>
</li>
<li>
<p>4.09.0+bytecode-only - Official release 4.09.0, without the
native-code compiler</p>
</li>
</ul>
<h2>What's new</h2>
<p>Some of the highlights in release 4.09 are:</p>
<ul>
<li>New optimisations, in particular for affine functions in matches, for instance
</li>
</ul>
<pre><code><span class='ocaml-source'> </span><span class='ocaml-keyword-other'>type</span><span class='ocaml-source'> </span><span class='ocaml-source'>t</span><span class='ocaml-source'> </span><span class='ocaml-keyword-operator'>=</span><span class='ocaml-source'> </span><span class='ocaml-constant-language-capital-identifier'>A</span><span class='ocaml-source'> </span><span class='ocaml-keyword-other'>|</span><span class='ocaml-source'> </span><span class='ocaml-constant-language-capital-identifier'>B</span><span class='ocaml-source'> </span><span class='ocaml-keyword-other'>|</span><span class='ocaml-source'> </span><span class='ocaml-constant-language-capital-identifier'>C</span><span class='ocaml-source'>
</span><span class='ocaml-source'> </span><span class='ocaml-keyword'>let </span><span class='ocaml-entity-name-function-binding'>affine</span><span class='ocaml-source'> </span><span class='ocaml-keyword-operator'>=</span><span class='ocaml-source'> </span><span class='ocaml-keyword-other'>function</span><span class='ocaml-source'>
</span><span class='ocaml-source'>   </span><span class='ocaml-keyword-other'>|</span><span class='ocaml-source'> </span><span class='ocaml-constant-language-capital-identifier'>A</span><span class='ocaml-source'> </span><span class='ocaml-keyword-operator'>-></span><span class='ocaml-source'> </span><span class='ocaml-constant-numeric-decimal-integer'>4</span><span class='ocaml-source'>
</span><span class='ocaml-source'>   </span><span class='ocaml-keyword-other'>|</span><span class='ocaml-source'> </span><span class='ocaml-constant-language-capital-identifier'>B</span><span class='ocaml-source'> </span><span class='ocaml-keyword-operator'>-></span><span class='ocaml-source'> </span><span class='ocaml-constant-numeric-decimal-integer'>3</span><span class='ocaml-source'>
</span><span class='ocaml-source'>   </span><span class='ocaml-keyword-other'>|</span><span class='ocaml-source'> </span><span class='ocaml-constant-language-capital-identifier'>C</span><span class='ocaml-source'> </span><span class='ocaml-keyword-operator'>-></span><span class='ocaml-source'> </span><span class='ocaml-constant-numeric-decimal-integer'>2</span><span class='ocaml-source'>
</span></code></pre><ul>
<li>The <code>graphics</code> library was moved out of the compiler distribution.
</li>
<li>The <code>vmthread</code> library was removed.
</li>
<li>Support for compiler plugins was removed.
</li>
<li>Many bug fixes.
</li>
</ul>
<p>For a comprehensive list of changes and details on all new features,
bug fixes, optimizations, etc., please consult the
<a href="#Changes">changelog</a>.</p>
<h2>Source distribution</h2>
<ul>
<li><a href="https://github.com/ocaml/ocaml/archive/4.09.0.tar.gz">Source
tarball</a>
(.tar.gz) for compilation under Unix (including Linux and MacOS X)
and Microsoft Windows (including Cygwin).
</li>
<li>Also available in
<a href="https://github.com/ocaml/ocaml/archive/4.09.0.zip">.zip</a>
format.
</li>
<li><a href="https://opam.ocaml.org/">OPAM</a> is a source-based distribution of
OCaml and many companion libraries and tools. Compilation and
installation are automated by powerful package managers.
</li>
<li>The official development repo is hosted on
<a href="https://github.com/ocaml/ocaml">GitHub</a>.
</li>
</ul>
<p>The
<a href="4.09/notes/INSTALL.adoc">INSTALL</a> file
of the distribution provides detailed compilation and installation
instructions — see also the <a href="4.09/notes/README.win32.adoc">Windows release
notes</a> for
instructions on how to build under Windows.</p>
<h2>Alternative Compilers</h2>
<p>Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:</p>
<ul>
<li><a href="http://ocsigen.org/js_of_ocaml/">Js_of_ocaml</a> is a stable OCaml
to JavaScript compiler.
</li>
<li><a href="http://bucklescript.github.io/bucklescript/">Bucklescript</a> is a
newer OCaml to JavaScript compiler. See its
<a href="https://github.com/bucklescript/bucklescript/wiki/Differences-from-js_of_ocaml">wiki</a> for
an explanation of how it differs from <code>js_of_ocaml</code>.
</li>
<li><a href="http://www.ocamljava.org/">OCaml-java</a> is a stable OCaml to
Java compiler.
</li>
</ul>
<h2>User's manual</h2>
<p>The user's manual for OCaml can be:</p>
<ul>
<li><a href="4.09/htmlman/index.html">browsed
online</a>,
</li>
<li>downloaded as a single
<a href="4.09/ocaml-4.09-refman.pdf">PDF</a>,
or <a href="4.09/ocaml-4.09-refman.txt">plain
text</a>
document,
</li>
<li>downloaded as a single
<a href="4.09/ocaml-4.09-refman-html.tar.gz">TAR</a>
or
<a href="4.09/ocaml-4.09-refman-html.zip">ZIP</a>
archive of HTML files,
</li>
<li>downloaded as a single
<a href="4.09/ocaml-4.09-refman.info.tar.gz">tarball</a>
of Emacs info files,
</li>
</ul>
<h2>Changes</h2>
<p>This is the
<a href="4.09/notes/Changes">changelog</a>.</p>
<h3>Runtime system:</h3>
<ul>
<li>
<p>(<em>breaking change</em>) <a href="https://github.com/ocaml/ocaml/issues/1725">#1725</a>, <a href="https://github.com/ocaml/ocaml/issues/2279">#2279</a>: Deprecate Obj.set_tag and Obj.truncate
(Stephen Dolan, review by Gabriel Scherer, Damien Doligez and Xavier Leroy)</p>
</li>
<li>
<p>(<em>breaking change</em>) <a href="https://github.com/ocaml/ocaml/issues/2240">#2240</a>: Constify &quot;identifier&quot; in struct custom_operations
(Cedric Cellier, review by Xavier Leroy)</p>
</li>
<li>
<p>(<em>breaking change</em>) <a href="https://github.com/ocaml/ocaml/issues/2293">#2293</a>: Constify &quot;caml_named_value&quot;
(Stephen Dolan, review by Xavier Leroy)</p>
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8787">#8787</a>, <a href="https://github.com/ocaml/ocaml/issues/8788">#8788</a>: avoid integer overflow in caml_output_value_to_bytes
(Jeremy Yallop, report by Marcello Seri)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2075">#2075</a>, <a href="https://github.com/ocaml/ocaml/issues/7729">#7729</a>: rename _T macro used to support Unicode in the (Windows) runtime
in order to avoid compiler warning
(Nicolás Ojeda Bär, review by Gabriel Scherer and David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2250">#2250</a>: Remove extra integer sign-extension in compare functions
(Stefan Muenzel, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8607">#8607</a>: Remove obsolete macros for pre-2002 MSVC support
(Stephen Dolan, review by Nicolás Ojeda Bär and David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8656">#8656</a>: Fix a bug in [caml_modify_generational_global_root]
(Jacques-Henri Jourdan, review by Gabriel Scherer)</p>
</li>
</ul>
<h3>Standard library:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2262">#2262</a>: take precision (.<n>) and flags ('+' and ' ') into account
in printf %F
(Pierre Roux, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/6148">#6148</a>, <a href="https://github.com/ocaml/ocaml/issues/8596">#8596</a>: optimize some buffer operations
(Damien Doligez, reports by John Whitington and Alain Frisch,
review by Jeremy Yallop and Gabriel Scherer)</p>
</li>
</ul>
<h3>Other libraries:</h3>
<ul>
<li>
<p>(<em>breaking change</em>) <a href="https://github.com/ocaml/ocaml/issues/2318">#2318</a>: Delete the graphics library. This library is now available
as a separate &quot;graphics&quot; package in opam. Its new home is:
https://github.com/ocaml/graphics
(Jérémie Dimino, review by Nicolas Ojeda Bar, Xavier Leroy and
Sébastien Hinderer)</p>
</li>
<li>
<p>(<em>breaking change</em>) <a href="https://github.com/ocaml/ocaml/issues/2289">#2289</a>: Delete the vmthreads library. This library was deprecated in 4.08.0.
(Jérémie Dimino)</p>
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2112">#2112</a>: Fix Thread.yield unfairness with busy threads yielding to each
other.
(Andrew Hunter, review by Jacques-Henri Jourdan, Spiros Eliopoulos, Stephen
Weeks, &amp; Mark Shinwell)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7903">#7903</a>, <a href="https://github.com/ocaml/ocaml/issues/2306">#2306</a>: Make Thread.delay interruptible by signals again
(Xavier Leroy, review by Jacques-Henri Jourdan and Edwin Török)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2248">#2248</a>: Unix alloc_sockaddr: Fix read of uninitialized memory for an
unbound Unix socket. Add support for receiving abstract (Linux) socket paths.
(Tim Cuthbertson, review by Sébastien Hinderer and Jérémie Dimino)</p>
</li>
</ul>
<h3>Compiler user-interface and warnings:</h3>
<ul>
<li>(<em>breaking change</em>) <a href="https://github.com/ocaml/ocaml/issues/2276">#2276</a>: Remove support for compiler plugins and hooks (also adds
[Dynlink.unsafe_get_global_value])
(Mark Shinwell, Xavier Clerc, review by Nicolás Ojeda Bär,
Florian Angeletti, David Allsopp and Xavier Leroy)
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/2301">#2301</a>: Hint on type error on int literal
(Jules Aguillon, review by Nicolás Ojeda Bär , Florian Angeletti,
Gabriel Scherer and Armaël Guéneau)
</li>
</ul>
<ul>
<li>(<em>breaking change</em>) <a href="https://github.com/ocaml/ocaml/issues/2314">#2314</a>: Remove support for gprof profiling.
(Mark Shinwell, review by Xavier Clerc and Stephen Dolan)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2190">#2190</a>: fix pretty printing (using Pprintast) of &quot;lazy ...&quot; patterns and
&quot;fun (type t) -&gt; ...&quot; expressions.
(Nicolás Ojeda Bär, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2277">#2277</a>: Use newtype names as type variable names
The inferred type of (fun (type t) (x : t) -&gt; x)
is now printed as ('t -&gt; 't) rather than ('a -&gt; 'a).
(Matthew Ryan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2309">#2309</a>: New options -with-runtime and -without-runtime in ocamlopt/ocamlc
that control the inclusion of the runtime system in the generated program.
(Lucas Pluvinage, review by Daniel Bünzli, Damien Doligez, David Allsopp
and Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/3819">#3819</a>, <a href="https://github.com/ocaml/ocaml/issues/8546">#8546</a> more explanations and tests for illegal permutation
(Florian Angeletti, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8537">#8537</a>: fix the -runtime-variant option for bytecode
(Damien Doligez, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8541">#8541</a>: Correctly print multi-lines locations
(Louis Roché, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8579">#8579</a>: Better error message for private constructors
of an extensible variant type
(Guillaume Bury, review by many fine eyes)</p>
</li>
</ul>
<h3>Code generation and optimizations:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2278">#2278</a>: Remove native code generation support for 32-bit Intel macOS,
iOS and other Darwin targets.
(Mark Shinwell, review by Nicolas Ojeda Bar and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8547">#8547</a>: Optimize matches that are an affine function of the input.
(Stefan Muenzel, review by Alain Frisch, Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/1904">#1904</a>, <a href="https://github.com/ocaml/ocaml/issues/7931">#7931</a>: Add FreeBSD/aarch64 support
(Greg V, review by Sébastien Hinderer, Stephen Dolan, Damien Doligez
and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8507">#8507</a>: Shorten symbol names of anonymous functions in Flambda mode
(the directory portions are now hidden)
(Mark Shinwell, review by Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8681">#8681</a>, <a href="https://github.com/ocaml/ocaml/issues/8699">#8699</a>, <a href="https://github.com/ocaml/ocaml/issues/8712">#8712</a>: Fix code generation with nested let rec of functions.
(Stephen Dolan, Leo White, Gabriel Scherer and Pierre Chambart,
review by Gabriel Scherer, reports by Alexey Solovyev and Jonathan French)</p>
</li>
</ul>
<h3>Manual and documentation:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7584">#7584</a>, <a href="https://github.com/ocaml/ocaml/issues/8538">#8538</a>: Document .cmt* files in the &quot;overview&quot; of ocaml{c,opt}
(Oxana Kostikova, rewiew by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8757">#8757</a>: Rename Pervasives to Stdlib in core library documentation.
(Ian Zimmerman, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8515">#8515</a>: manual, precise constraints on reexported types
(Florian Angeletti, review by Gabriel Scherer)</p>
</li>
</ul>
<h3>Tools:</h3>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/2221">#2221</a>: ocamldep will now correctly allow a .ml file in an include directory
that appears first in the search order to shadow a .mli appearing in a later
include directory.
(Nicolás Ojeda Bär, review by Florian Angeletti)
</li>
</ul>
<h3>Internal/compiler-libs changes:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/1579">#1579</a>: Add a separate types for clambda primitives
(Pierre Chambart, review by Vincent Laviron and Mark Shinwell)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/1965">#1965</a>: remove loop constructors in Cmm and Mach
(Vincent Laviron)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/1973">#1973</a>: fix compilation of catches with multiple handlers
(Vincent Laviron)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2228">#2228</a>, <a href="https://github.com/ocaml/ocaml/issues/8545">#8545</a>: refactoring the handling of .cmi files
by moving the logic from Env to a new module Persistent_env
(Gabriel Scherer, review by Jérémie Dimino and Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2229">#2229</a>: Env: remove prefix_idents cache
(Thomas Refis, review by Frédéric Bour and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2237">#2237</a>, <a href="https://github.com/ocaml/ocaml/issues/8582">#8582</a>: Reorder linearisation of Trywith to avoid a call instruction
(Vincent Laviron and Greta Yorsh, additional review by Mark Shinwell;
fix in <a href="https://github.com/ocaml/ocaml/issues/8582">#8582</a> by Mark Shinwell, Xavier Leroy and Anil Madhavapeddy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2265">#2265</a>: Add bytecomp/opcodes.mli
(Mark Shinwell, review by Nicolas Ojeda Bar)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2268">#2268</a>: Improve packing mechanism used for building compilerlibs modules
into the Dynlink libraries
(Mark Shinwell, Stephen Dolan, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2280">#2280</a>: Don't make more Clambda constants after starting Cmmgen
(Mark Shinwell, review by Vincent Laviron)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2281">#2281</a>: Move some middle-end files around
(Mark Shinwell, review by Pierre Chambart and Vincent Laviron)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2283">#2283</a>: Add [is_prefix] and [find_and_chop_longest_common_prefix] to
[Misc.Stdlib.List]
(Mark Shinwell, review by Alain Frisch and Stephen Dolan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2284">#2284</a>: Add various utility functions to [Misc] and remove functions
from [Misc.Stdlib.Option] that are now in [Stdlib.Option]
(Mark Shinwell, review by Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2286">#2286</a>: Functorise [Consistbl]
(Mark Shinwell, review by Gabriel Radanne)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2291">#2291</a>: Add [Compute_ranges] pass
(Mark Shinwell, review by Vincent Laviron)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2292">#2292</a>: Add [Proc.frame_required] and [Proc.prologue_required].
Move tail recursion label creation to [Linearize].  Correctly position
[Lprologue] relative to [Iname_for_debugger] operations.
(Mark Shinwell, review by Vincent Laviron)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2308">#2308</a>: More debugging information on [Cmm] terms
(Mark Shinwell, review by Stephen Dolan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7878">#7878</a>, <a href="https://github.com/ocaml/ocaml/issues/8542">#8542</a>: Replaced TypedtreeIter with tast_iterator
(Isaac &quot;Izzy&quot; Avram, review by Gabriel Scherer and Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8598">#8598</a>: Replace &quot;not is_nonexpansive&quot; by &quot;maybe_expansive&quot;.
(Thomas Refis, review by David Allsopp, Florian Angeletti, Gabriel Radanne,
Gabriel Scherer and Xavier Leroy)</p>
</li>
</ul>
<h3>Compiler distribution build system:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2267">#2267</a>: merge generation of header programs, also fixing parallel build on
Cygwin.
(David Allsopp, review by Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8514">#8514</a>: Use boot/ocamlc.opt for building, if available.
(Stephen Dolan, review by Gabriel Scherer)</p>
</li>
</ul>
<h3>Bug fixes:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8864">#8864</a>, <a href="https://github.com/ocaml/ocaml/issues/8865">#8865</a>: Fix native compilation of left shift by (word_size - 1)
(Vincent Laviron, report by Murilo Giacometti Rocha, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/2296">#2296</a>: Fix parsing of hexadecimal floats with underscores in the exponent.
(Hugo Heuzard and Xavier Leroy, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8800">#8800</a>: Fix soundness bug in extension constructor inclusion
(Leo White, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8848">#8848</a>: Fix x86 stack probe CFI information in caml_c_call and
caml_call_gc
(Tom Kelly, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7156">#7156</a>, <a href="https://github.com/ocaml/ocaml/issues/8594">#8594</a>: make top level use custom printers if they are available
(Andrew Litteken, report by Martin Jambon, review by Nicolás Ojeda Bär,
Thomas Refis, Armaël Guéneau, Gabriel Scherer, David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/3249">#3249</a>: ocamlmklib should reject .cmxa files
(Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/7937">#7937</a>, <a href="https://github.com/ocaml/ocaml/issues/2287">#2287</a>: fix uncaught Unify exception when looking for type
declaration
(Florian Angeletti, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8610">#8610</a>, <a href="https://github.com/ocaml/ocaml/issues/8613">#8613</a>: toplevel printing, consistent deduplicated name for types
(Florian Angeletti, review by Thomas Refis and Gabriel Scherer,
reported by Xavier Clerc)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8635">#8635</a>, <a href="https://github.com/ocaml/ocaml/issues/8636">#8636</a>: Fix a bad side-effect of the -allow-approx option of
ocamldep. It used to turn some errors into successes
(Jérémie Dimino)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8701">#8701</a>, <a href="https://github.com/ocaml/ocaml/issues/8725">#8725</a>: Variance of constrained parameters causes principality issues
(Jacques Garrigue, report by Leo White, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8777">#8777</a>(partial): fix position information in some polymorphic variant
error messages about missing tags
(Florian Angeletti, review by Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8779">#8779</a>, more cautious variance computation to avoid missing cmis
(Florian Angeletti, report by Antonio Nuno Monteiro, review by Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8810">#8810</a>: Env.lookup_module: don't allow creating loops
(Thomas Refis, report by Leo White, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8862">#8862</a>, <a href="https://github.com/ocaml/ocaml/issues/8871">#8871</a>: subst: preserve scopes
(Thomas Refis, report by Leo White, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8921">#8921</a>, <a href="https://github.com/ocaml/ocaml/issues/8924">#8924</a>: Fix stack overflow with Flambda
(Vincent Laviron, review by Pierre Chambart and Leo White,
report by Aleksandr Kuzmenko)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/issues/8944">#8944</a>: Fix &quot;open struct .. end&quot; on clambda backend
(Thomas Refis, review by Leo White, report by Damon Wang and Mark Shinwell)</p>
</li>
</ul>
|js}
  };
 
  { kind = `Compiler
  ; version = {js|4.08.1|js}
  ; date = {js|2019-08-05|js}
  ; intro_md = {js|This page describe OCaml **4.08.1**, released on Aug 5, 2019.  It is a bug-fix release of [OCaml 4.08.0](/releases/4.08.0).
|js}
  ; intro_html = {js|<p>This page describe OCaml <strong>4.08.1</strong>, released on Aug 5, 2019.  It is a bug-fix release of <a href="/releases/4.08.0">OCaml 4.08.0</a>.</p>
|js}
  ; highlights_md = {js|- Bug fixes for 4.08.0
|js}
  ; highlights_html = {js|<ul>
<li>Bug fixes for 4.08.0
</li>
</ul>
|js}
  ; body_md = {js|
### Bug fixes:

- [#7887](https://caml.inria.fr/mantis/view.php?id=7887):
  ensure frame table is 8-aligned on ARM64 and PPC64
  (Xavier Leroy, report by Mark Hayden, review by Mark Shinwell
   and Gabriel Scherer)

- [#8751](https://caml.inria.fr/mantis/view.php?id=8751):
  fix bug that could result in misaligned data section when compiling to
  native-code on amd64.  (observed with the mingw64 compiler)
  (Nicolás Ojeda Bär, review by David Allsopp)

- [#8769](https://caml.inria.fr/mantis/view.php?id=8769),
  [#8770](https://caml.inria.fr/mantis/view.php?id=8770):
  Fix assertion failure with -pack
  (Leo White, review by Gabriel Scherer, report by Fabian @copy)

- [#8816](https://caml.inria.fr/mantis/view.php?id=8816),
  [#8818](https://caml.inria.fr/mantis/view.php?id=8818):
  fix loading of packed modules with Dynlink (regression in
  [#2176](https://caml.inria.fr/mantis/view.php?id=2176)
  ).
  (Leo White, report by Andre Maroneze, review by Gabriel Scherer)

- [#8830](https://caml.inria.fr/mantis/view.php?id=8830):
  configure script: fix tool prefix detection and Debian's armhf
  detection
  (Stéphane Glondu, review by David Allsopp)

- [#8843](https://caml.inria.fr/mantis/view.php?id=8843),
  [#8841](https://caml.inria.fr/mantis/view.php?id=8841):
  fix use of off_t on 32-bit systems.
  (Stephen Dolan, report by Richard Jones, review by Xavier Leroy)
|js}
  ; body_html = {js|<h3>Bug fixes:</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7887">#7887</a>:
ensure frame table is 8-aligned on ARM64 and PPC64
(Xavier Leroy, report by Mark Hayden, review by Mark Shinwell
and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=8751">#8751</a>:
fix bug that could result in misaligned data section when compiling to
native-code on amd64.  (observed with the mingw64 compiler)
(Nicolás Ojeda Bär, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=8769">#8769</a>,
<a href="https://caml.inria.fr/mantis/view.php?id=8770">#8770</a>:
Fix assertion failure with -pack
(Leo White, review by Gabriel Scherer, report by Fabian @copy)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=8816">#8816</a>,
<a href="https://caml.inria.fr/mantis/view.php?id=8818">#8818</a>:
fix loading of packed modules with Dynlink (regression in
<a href="https://caml.inria.fr/mantis/view.php?id=2176">#2176</a>
).
(Leo White, report by Andre Maroneze, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=8830">#8830</a>:
configure script: fix tool prefix detection and Debian's armhf
detection
(Stéphane Glondu, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=8843">#8843</a>,
<a href="https://caml.inria.fr/mantis/view.php?id=8841">#8841</a>:
fix use of off_t on 32-bit systems.
(Stephen Dolan, report by Richard Jones, review by Xavier Leroy)</p>
</li>
</ul>
|js}
  };
 
  { kind = `Compiler
  ; version = {js|4.08.0|js}
  ; date = {js|2019-06-14|js}
  ; intro_md = {js|This page describes OCaml version **4.08.0**, released on 2019-06-14. 
|js}
  ; intro_html = {js|<p>This page describes OCaml version <strong>4.08.0</strong>, released on 2019-06-14.</p>
|js}
  ; highlights_md = {js|- Binding operators (`let*`, `let+`, `and*`, etc). They can be used to
  streamline monadic code.
- `open` now applies to arbitrary module expression in structures and
  to applicative paths in signatures.
- A new notion of (user-defined) "alerts" generalizes the deprecated
  warning.
- New modules in the standard library: `Fun`, `Bool`, `Int`, `Option`,
  `Result`.
- A significant number of new functions in `Float`, including FMA support,
  and a new `Float.Array` submodule.
- Source highlighting for errors and warnings in batch mode. - Many error messages were improved. - Improved AFL instrumentation for objects and lazy values.
|js}
  ; highlights_html = {js|<ul>
<li>Binding operators (<code>let*</code>, <code>let+</code>, <code>and*</code>, etc). They can be used to
streamline monadic code.
</li>
<li><code>open</code> now applies to arbitrary module expression in structures and
to applicative paths in signatures.
</li>
<li>A new notion of (user-defined) &quot;alerts&quot; generalizes the deprecated
warning.
</li>
<li>New modules in the standard library: <code>Fun</code>, <code>Bool</code>, <code>Int</code>, <code>Option</code>,
<code>Result</code>.
</li>
<li>A significant number of new functions in <code>Float</code>, including FMA support,
and a new <code>Float.Array</code> submodule.
</li>
<li>Source highlighting for errors and warnings in batch mode. - Many error messages were improved. - Improved AFL instrumentation for objects and lazy values.
</li>
</ul>
|js}
  ; body_md = {js|
Opam Switches
-------------

This release is available as multiple
[OPAM](https://opam.ocaml.org/doc/Usage.html) switches:

- 4.08.0 — Official release 4.08.0
- 4.08.0+32bit - Official release 4.08.0, compiled in 32-bit mode
  for 64-bit Linux and OS X hosts
- 4.08.0+afl — Official release 4.08.0, with afl-fuzz instrumentation
- 4.08.0+bytecode-only - Official release 4.08.0, without the
  native-code compiler
- 4.08.0+default-unsafe-string — Official release 4.08.0, without
  safe strings by default
  strings by default
- 4.08.0+flambda — Official release 4.08.0, with flambda activated
- 4.08.0+flambda+no-flat-float-array — Official release 4.08.0, with
  flambda activated and --disable-flat-float-array
- 4.08.0+force-safe-string — Official release 4.08.0, with safe string
  forced globally
- 4.08.0+fp — Official release 4.08.0, with frame-pointers
- 4.08.0+fp+flambda — Official release 4.08.0, with frame-pointers
  and flambda activated
- 4.08.0+musl+static+flambda - Official release 4.08.0, compiled with
  musl-gcc -static and with flambda activated
- 4.08.0+no-flat-float-array - Official release 4.08.0, with
  --disable-flat-float-array
- 4.08.0+spacetime - Official 4.08.0 release with spacetime activated

What's new
----------

Some of the highlights in release 4.08 are:

- Binding operators (`let*`, `let+`, `and*`, etc). They can be used to
  streamline monadic code.
- `open` now applies to arbitrary module expression in structures and
  to applicative paths in signatures.
- A new notion of (user-defined) "alerts" generalizes the deprecated
  warning.
- New modules in the standard library: `Fun`, `Bool`, `Int`, `Option`,
  `Result`.
- A significant number of new functions in `Float`, including FMA support,
  and a new `Float.Array` submodule.
- Source highlighting for errors and warnings in batch mode.
- Many error messages were improved.
- Improved AFL instrumentation for objects and lazy values.

For a comprehensive list of changes and details on all new features,
bug fixes, optimizations, etc., please consult the
[changelog](#Changes).


Source distribution
---------------------------------------------

- [Source
  tarball](https://github.com/ocaml/ocaml/archive/4.08.0.tar.gz)
  (.tar.gz) for compilation under Unix (including Linux and MacOS X)
  and Microsoft Windows (including Cygwin).
- Also available in
  [.zip](https://github.com/ocaml/ocaml/archive/4.08.0.zip)
  format.
- [OPAM](https://opam.ocaml.org/) is a source-based distribution of
  OCaml and many companion libraries and tools. Compilation and
  installation are automated by powerful package managers.
- The official development repo is hosted on
  [GitHub](https://github.com/ocaml/ocaml).

The
[INSTALL](4.08/notes/INSTALL.adoc) file
of the distribution provides detailed compilation and installation
instructions — see also the [Windows release
notes](4.08/notes/README.win32.adoc) for
instructions on how to build under Windows.

Alternative Compilers
---------------------

Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:

* [Js_of_ocaml](http://ocsigen.org/js_of_ocaml/) is a stable OCaml
  to JavaScript compiler.
* [Bucklescript](http://bucklescript.github.io/bucklescript/) is a
  newer OCaml to JavaScript compiler. See its
  [wiki](https://github.com/bucklescript/bucklescript/wiki/Differences-from-js_of_ocaml) for
  an explanation of how it differs from `js_of_ocaml`.
* [OCaml-java](http://www.ocamljava.org/) is a stable OCaml to
  Java compiler.

User's manual
------------------------------------

The user's manual for OCaml can be:

- [browsed
  online](4.08/htmlman/index.html),
- downloaded as a single
  [PostScript](4.08/ocaml-4.08-refman.ps.gz),
  [PDF](4.08/ocaml-4.08-refman.pdf),
  or [plain
  text](4.08/ocaml-4.08-refman.txt)
  document,
- downloaded as a single
  [TAR](4.08/ocaml-4.08-refman-html.tar.gz)
  or
  [ZIP](4.08/ocaml-4.08-refman-html.zip)
  archive of HTML files,
- downloaded as a single
  [tarball](4.08/ocaml-4.08-refman.info.tar.gz)
  of Emacs info files,


Changes
-------

This is the
[changelog](4.08/notes/Changes).

(Changes that can break existing programs are marked with a "*")

### Language features:

- [#1947](https://github.com/ocaml/ocaml/pull/1947):
  Introduce binding operators (`let*`, `let+`, `and*` etc.)
  (Leo White, review by Thomas Refis)

- [#1892](https://github.com/ocaml/ocaml/pull/1892):
  Allow shadowing of items coming from an `include`
  (Thomas Refis, review by Gabriel Radanne)

- [#2122](https://github.com/ocaml/ocaml/pull/2122):
  Introduce local substitutions in signatures: `type t := type_expr`
  and `module M := Extended(Module).Path`
  (Thomas Refis, with help and review from Leo White, and Alain Frisch)

- [#1804](https://github.com/ocaml/ocaml/pull/1804):
  New notion of "alerts" that generalizes the deprecated warning  
  
        [@@ocaml.alert deprecated "Please use bar instead!"]
        [@@ocaml.alert unsafe "Please use safe_foo instead!"]

  (Alain Frisch, review by Leo White and Damien Doligez)

- [#6422](https://github.com/ocaml/ocaml/pull/6422),
  [#7083](https://github.com/ocaml/ocaml/pull/7083),
  [#305](https://github.com/ocaml/ocaml/pull/305),
  [#1568](https://github.com/ocaml/ocaml/pull/1568):
  Allow `exception` under or-patterns
  (Thomas Refis, with help and review from Alain Frisch, Gabriel Scherer, Jeremy
  Yallop, Leo White and Luc Maranget)


- [#1705](https://github.com/ocaml/ocaml/pull/1705):
  Allow `@@attributes` on exception declarations.
  (Hugo Heuzard, review by Gabriel Radanne and Thomas Refis)

- [#1506](https://github.com/ocaml/ocaml/pull/1506),
  [#2147](https://github.com/ocaml/ocaml/pull/2147),
  [#2166](https://github.com/ocaml/ocaml/pull/2166),
  [#2167](https://github.com/ocaml/ocaml/pull/2167):
  Extended `open` to arbitrary module
  expression in structures and to applicative paths in signatures
  (Runhang Li, review by Alain Frisch, Florian Angeletti, Jeremy Yallop,
  Leo White and Thomas Refis)

* [#2106](https://github.com/ocaml/ocaml/pull/2106):
  `.~` is now a reserved keyword, and is no longer available
  for use in extended indexing operators
  (Jeremy Yallop, review by Gabriel Scherer, Florian Angeletti, and
   Damien Doligez)

* [#7841](https://github.com/ocaml/ocaml/pull/7841),
  [#2041](https://github.com/ocaml/ocaml/pull/2041),
  [#2235](https://github.com/ocaml/ocaml/pull/2235):
  allow modules from include directories
  to shadow other ones, even in the toplevel; for a example, including
  a directory that defines its own Result module will shadow the stdlib's.
  (Jérémie Dimino, review by Alain Frisch and David Allsopp)

### Type system:

- [#2110](https://github.com/ocaml/ocaml/pull/2110):
  Partial support for GADTs inside or-patterns;
  The type equalities introduced by the GADT constructor are only
  available inside the or-pattern; they cannot be used in the
  right-hand-side of the clause, when both sides of the or-pattern
  agree on it.
  (Thomas Refis and Leo White, review by Jacques Garrigue)

- [#1826](https://github.com/ocaml/ocaml/pull/1826):
  allow expanding a type to a private abbreviation instead of
  abstracting when removing references to an identifier.
  (Thomas Refis and Leo White, review by Jacques Garrigue)

- [#1942](https://github.com/ocaml/ocaml/pull/1942),
  [#2244](https://github.com/ocaml/ocaml/pull/2244):
  simplification of the static check
  for recursive definitions
  (Alban Reynaud and Gabriel Scherer,
   review by Jeremy Yallop, Armaël Guéneau and Damien Doligez)

### Standard library:

- [#2128](https://github.com/ocaml/ocaml/pull/2128):
  Add `Fun` module: `id`, `const`, `flip`, `negate`, `protect`
  (protect is a `try_finally` combinator)
  https://caml.inria.fr/pub/docs/manual-ocaml/libref/Fun.html
  (Many fine eyes)

- [#2010](https://github.com/ocaml/ocaml/pull/2010):
  Add `Bool` module
  https://caml.inria.fr/pub/docs/manual-ocaml/libref/Bool.html
  (Many fine eyes)

- [#2011](https://github.com/ocaml/ocaml/pull/2011):
  Add `Int` module
  https://caml.inria.fr/pub/docs/manual-ocaml/libref/Int.html
  (Many fine eyes)

- [#1940](https://github.com/ocaml/ocaml/pull/1940):
  Add `Option` module and `Format.pp_print_option`,
  `none`, `some`, `value`, `get`, `bind`, `join`, `map`, `fold`, `iter`, etc.
  https://caml.inria.fr/pub/docs/manual-ocaml/libref/Option.html
  (Many fine eyes)

- [#1956](https://github.com/ocaml/ocaml/pull/1956):
  Add `Result` module and `Format.pp_print_result`,
  `ok`, `error`, `value`, `get_ok`, `bind`, `join`, `map`, `map_error`, etc.
  https://caml.inria.fr/pub/docs/manual-ocaml/libref/Result.html
  (Many fine eyes)

- [#1855](https://github.com/ocaml/ocaml/pull/1855),
  [#2118](https://github.com/ocaml/ocaml/pull/2118):
  Add `Fun.protect ~finally` for enforcing local
  invariants whether a function raises or not, similar to
  `unwind-protect` in Lisp and `FINALLY` in Modula-2. It is careful
  about preserving backtraces and treating exceptions in finally as
  errors.
  (Marcello Seri and Guillaume Munch-Maccagnoni, review by Daniel
  Bünzli, Gabriel Scherer, François Bobot, Nicolás Ojeda Bär, Xavier
  Clerc, Boris Yakobowski, Damien Doligez, and Xavier Leroy)

* [#1605](https://github.com/ocaml/ocaml/pull/1605):
  Deprecate `Stdlib.Pervasives`. Following [#1010](https://github.com/ocaml/ocaml/pull/1010),
  `Pervasives` is no longer needed and `Stdlib` should be used instead.
  (Jérémie Dimino, review by Nicolás Ojeda Bär)

- [#2185](https://github.com/ocaml/ocaml/pull/2185):
  Add `List.filter_map`.
  (Thomas Refis, review by Alain Frisch and Gabriel Scherer)

- [#1957](https://github.com/ocaml/ocaml/pull/1957):
  Add `Stack.{top_opt,pop_opt}` and `Queue.{peek_opt,take_opt}`.
  (Vladimir Keleshev, review by Nicolás Ojeda Bär and Gabriel Scherer)

- [#1182](https://github.com/ocaml/ocaml/pull/1182):
  Add new `Printf` formats `%#d`, `%#Ld`, `%#ld`, `%#nd` (idem for
  `%i` and `%u` ) for alternative integer formatting — inserts
  `_` between blocks of digits.
  (ygrek, review by Gabriel Scherer)

- [#1959](https://github.com/ocaml/ocaml/pull/1959):
  Add `Format.dprintf`, a printing function which outputs a closure
  usable with `%t`.
  (Gabriel Radanne, request by Armaël Guéneau,
   review by Florian Angeletti and Gabriel Scherer)

- [#1986](https://github.com/ocaml/ocaml/pull/1986),
  [#6450](https://github.com/ocaml/ocaml/pull/6450):
  Add `Set.disjoint`.
  (Nicolás Ojeda Bär, review by Gabriel Scherer)

- [#7812](https://github.com/ocaml/ocaml/pull/7812),
  [#2125](https://github.com/ocaml/ocaml/pull/2125):
  Add `Filename.chop_suffix_opt`.
  (Alain Frisch, review by Nicolás Ojeda Bär, suggestion by whitequark)

- [#1864](https://github.com/ocaml/ocaml/pull/1864):
  Extend `Bytes` and `Buffer` with functions to read/write
  binary representations of numbers.
  (Alain Frisch and Daniel Bünzli)

- [#1458](https://github.com/ocaml/ocaml/pull/1458):
  Add unsigned operations `unsigned_div`, `unsigned_rem`, `unsigned_compare`
  and `unsigned_to_int` to modules `Int32`, `Int64`, `Nativeint`.
  (Nicolás Ojeda Bär, review by Daniel Bünzli, Alain Frisch and Max Mouratov)

- [#2002](https://github.com/ocaml/ocaml/pull/2002):
  Add `Format.pp_print_custom_break`, a new more general kind of break
  hint that can emit non-whitespace characters.
  (Vladimir Keleshev and Pierre Weis, review by Josh Berdine, Gabriel Radanne)

- [#1966](https://github.com/ocaml/ocaml/pull/1966):
  Add `Format` semantic tags using extensible sum types.
  (Gabriel Radanne, review by Nicolás Ojeda Bär)

- [#1794](https://github.com/ocaml/ocaml/pull/1794):
  Add constants `zero`, `one`, `minus_one` and functions `succ`,
  `pred`, `is_finite`, `is_infinite`, `is_nan`, `is_integer`, `trunc`, `round`,
  `next_after`, `sign_bit`, `min`, `max`, `min_max`, `min_num`, `max_num`,
  `min_max_num` to module `Float`.
  (Christophe Troestler, review by Alain Frish, Xavier Clerc and Daniel Bünzli)

- [#1354](https://github.com/ocaml/ocaml/pull/1354),
  [#2177](https://github.com/ocaml/ocaml/pull/2177):
  Add fma support to `Float` module.
  (Laurent Thévenoux, review by Alain Frisch, Jacques-Henri Jourdan,
  Xavier Leroy)



- [#5072](https://github.com/ocaml/ocaml/pull/5072),
  [#6655](https://github.com/ocaml/ocaml/pull/6655),
  [#1876](https://github.com/ocaml/ocaml/pull/1876):
  add aliases in `Stdlib` for built-in types
  and exceptions.
  (Jeremy Yallop, reports by Pierre Letouzey and David Sheets,
   review by Valentin Gatien-Baron, Gabriel Scherer and Alain Frisch)

- [#1731](https://github.com/ocaml/ocaml/pull/1731):
  `Format`, use `raise_notrace` to preserve backtraces.
  (Frédéric Bour, report by Jules Villard, review by Gabriel Scherer)

- [#6701](https://github.com/ocaml/ocaml/pull/6701),
  [#1185](https://github.com/ocaml/ocaml/pull/1185),
  [#1803](https://github.com/ocaml/ocaml/pull/1803):
  make `float_of_string` and `string_of_float`
  locale-independent.
  (ygrek, review by Xavier Leroy and Damien Doligez)

- [#7795](https://github.com/ocaml/ocaml/pull/7795),
  [#1782](https://github.com/ocaml/ocaml/pull/1782):
  Fix off-by-one error in `Weak.create`.
  (KC Sivaramakrishnan, review by Gabriel Scherer and François Bobot)

- [#7235](https://github.com/ocaml/ocaml/pull/7235):
  `Format`, flush `err_formatter` at exit.
  (Pierre Weis, request by Jun Furuse)

- [#1857](https://github.com/ocaml/ocaml/pull/1857),
  [#7812](https://github.com/ocaml/ocaml/pull/7812):
  Remove `Sort` module, deprecated since 2000 and emitting
  a deprecation warning since 4.02.
  (whitequark)

- [#1923](https://github.com/ocaml/ocaml/pull/1923):
  `Arg` module sometimes misbehaved instead of rejecting invalid
  `-keyword=arg` inputs
  (Valentin Gatien-Baron, review by Gabriel Scherer)

- [#1959](https://github.com/ocaml/ocaml/pull/1959):
  Small simplification and optimization to `Format.ifprintf`
  (Gabriel Radanne, review by Gabriel Scherer)

- [#2119](https://github.com/ocaml/ocaml/pull/2119):
  Clarify the documentation of `Set.diff`.
  (Gabriel Scherer, suggestion by John Skaller)

- [#2145](https://github.com/ocaml/ocaml/pull/2145):
  Deprecate the mutability of `Gc.control` record fields.
  (Damien Doligez, review by Alain Frisch)

- [#2159](https://github.com/ocaml/ocaml/pull/2159),
  [#7874](https://github.com/ocaml/ocaml/pull/7874):
  annotate `{String,Bytes}.equal` as being `[@@noalloc]`.
  (Pierre-Marie Pédrot, review by Nicolás Ojeda Bär)

- [#1936](https://github.com/ocaml/ocaml/pull/1936):
  Add module `Float.Array`.
  (Damien Doligez, review by Xavier Clerc and Alain Frisch)

- [#2183](https://github.com/ocaml/ocaml/pull/2183):
  Fix segfault in `Array.create_float` with `-no-flat-float-array`.
  (Damien Doligez, review by Gabriel Scherer and Jeremy Yallop)

- [#1525](https://github.com/ocaml/ocaml/pull/1525):
  Make function `set_max_indent` respect documentation.
  (Pierre Weis, Richard Bonichon, review by Florian Angeletti)

- [#2202](https://github.com/ocaml/ocaml/pull/2202):
  Correct `Hashtbl.MakeSeeded.{add_seq,replace_seq,of_seq}` to use
  functor hash function instead of default hash function. 
  `Hashtbl.Make.of_seq` shouldn't create randomized hash tables.
  (David Allsopp, review by Alain Frisch)

### Other libraries:

- [#2533](https://github.com/ocaml/ocaml/pull/2533),
  [#1839](https://github.com/ocaml/ocaml/pull/1839),
  [#1949](https://github.com/ocaml/ocaml/pull/1949):
  added `Unix.fsync`.
  (Francois Berenger, Nicolás Ojeda Bär, review by Daniel Bünzli, David Allsopp
  and ygrek)

- [#1792](https://github.com/ocaml/ocaml/pull/1792),
  [#7794](https://github.com/ocaml/ocaml/pull/7794):
  Add `Unix.open_process_args{,_in,_out,_full}` similar to
  `Unix.open_process{,_in,_out,_full}`, but passing an explicit argv array.
  (Nicolás Ojeda Bär, review by Jérémie Dimino, request by Volker Diels-Grabsch)

- [#1999](https://github.com/ocaml/ocaml/pull/1999):
  Add `Unix.process{,_in,_out,_full}_pid` to retrieve opened process's
  pid.
  (Romain Beauxis, review by Nicolás Ojeda Bär)

- [#2222](https://github.com/ocaml/ocaml/pull/2222):
  Set default status in `waitpid` when pid is zero. Otherwise,
  status value is undefined.
  (Romain Beauxis and Xavier Leroy, review by Stephen Dolan)

* [#2104](https://github.com/ocaml/ocaml/pull/2104),
  [#2211](https://github.com/ocaml/ocaml/pull/2211),
  [#4127](https://github.com/ocaml/ocaml/pull/4127),
  [#7709](https://github.com/ocaml/ocaml/pull/7709):
  Fix `Thread.sigmask`. When
  system threads are loaded, `Unix.sigprocmask` is now an alias for
  `Thread.sigmask`. This changes the behavior at least on MacOS, where
  `Unix.sigprocmask` used to change the masks of all threads.
  (Jacques-Henri Jourdan, review by Jérémie Dimino)

- [#1061](https://github.com/ocaml/ocaml/pull/1061):
  Add `?follow` parameter to `Unix.link`. This allows hardlinking
  symlinks.
  (Christopher Zimmermann, review by Xavier Leroy, Damien Doligez, David
   Allsopp, David Sheets)

- [#2038](https://github.com/ocaml/ocaml/pull/2038):
  Deprecate vm threads.
  OCaml supported both "native threads", based on pthreads,
  and its own green-threads implementation, "vm threads". We are not
  aware of any recent usage of "vm threads", and removing them simplifies
  further maintenance.
  (Jérémie Dimino)

* [#4208](https://github.com/ocaml/ocaml/pull/4208),
  [#4229](https://github.com/ocaml/ocaml/pull/4229),
  [#4839](https://github.com/ocaml/ocaml/pull/4839),
  [#6462](https://github.com/ocaml/ocaml/pull/6462),
  [#6957](https://github.com/ocaml/ocaml/pull/6957),
  [#6950](https://github.com/ocaml/ocaml/pull/6950),
  [#1063](https://github.com/ocaml/ocaml/pull/1063),
  [#2176](https://github.com/ocaml/ocaml/pull/2176),
  [#2297](https://github.com/ocaml/ocaml/pull/2297):
  Make (nat)dynlink sound by correctly failing when
  dynlinked module names clash with other modules or interfaces.
  (Mark Shinwell, Leo White, Nicolás Ojeda Bär, Pierre Chambart)

- [#2263](https://github.com/ocaml/ocaml/pull/2263):
  Delete the deprecated Bigarray.*.map_file functions in
  favour of `*_of_genarray (Unix.map_file ...)` functions instead. The
  `Unix.map_file` function was introduced in OCaml 4.06.0 onwards.
  (Jérémie Dimino, reviewed by David Allsopp and Anil Madhavapeddy)

### Compiler user-interface and warnings:

- [#2096](https://github.com/ocaml/ocaml/pull/2096):
  Add source highlighting for errors & warnings in batch mode
  (Armaël Guéneau, review by Gabriel Scherer and Jérémie Dimino)

- [#2133](https://github.com/ocaml/ocaml/pull/2133):
  [@ocaml.warn_on_literal_pattern]: now warn on literal patterns
  found anywhere in a constructor's arguments.
  (Jeremy Yallop, review by Gabriel Scherer)

- [#1720](https://github.com/ocaml/ocaml/pull/1720):
  Improve error reporting for missing `rec` in let-bindings.
  (Arthur Charguéraud and Armaël Guéneau, with help and advice
   from Gabriel Scherer, Frédéric Bour, Xavier Clerc and Leo White)

- [#7116](https://github.com/ocaml/ocaml/pull/7116),
  [#1430](https://github.com/ocaml/ocaml/pull/1430):
  new `-config-var` option
  to get the value of a single configuration variable in scripts.
  (Gabriel Scherer, review by Sébastien Hinderer and David Allsopp,
   request by Adrien Nader)

- [#1733](https://github.com/ocaml/ocaml/pull/1733),
  [#1993](https://github.com/ocaml/ocaml/pull/1993),
  [#1998](https://github.com/ocaml/ocaml/pull/1998),
  [#2058](https://github.com/ocaml/ocaml/pull/2058),
  [#2094](https://github.com/ocaml/ocaml/pull/2094),
  [#2140](https://github.com/ocaml/ocaml/pull/2140):
  Typing error message improvements
    - [#1733](https://github.com/ocaml/ocaml/pull/1733),
	  change the perspective of the unexpected existential error
      message.
    - [#1993](https://github.com/ocaml/ocaml/pull/1993),
	  expanded error messages for universal quantification failure
    - [#1998](https://github.com/ocaml/ocaml/pull/1998),
	  more context for unbound type parameter error
    - [#2058](https://github.com/ocaml/ocaml/pull/2058), full
      explanation for unsafe cycles in recursive module definitions
      (suggestion by Ivan Gotovchits)
    - [#2094](https://github.com/ocaml/ocaml/pull/2094), rewording for
      "constructor has no type" error
    - [#7565](https://github.com/ocaml/ocaml/pull/7565),
      [#2140](https://github.com/ocaml/ocaml/pull/2140), more context
      for universal variable escape in method type.

  (Florian Angeletti, reviews by Jacques Garrique, Armaël Guéneau,
   Gabriel Radanne, Gabriel Scherer and Jeremy Yallop)

- [#1913](https://github.com/ocaml/ocaml/pull/1913):
  new flag `-dump-into-file` to print debug output like `-dlambda` into
  a file named after the file being built, instead of on stderr.
  (Valentin Gatien-Baron, review by Thomas Refis)

- [#1921](https://github.com/ocaml/ocaml/pull/1921):
  in the compilation context passed to ppx extensions,
  add more configuration options related to type-checking:
  `-rectypes`, `-principal`, `-alias-deps`, `-unboxed-types`, `-unsafe-string`.
  (Gabriel Scherer, review by Gabriel Radanne, Xavier Clerc and Frédéric Bour)

- [#1976](https://github.com/ocaml/ocaml/pull/1976):
  Better error messages for extension constructor type mismatches
  (Thomas Refis, review by Gabriel Scherer)

- [#1841](https://github.com/ocaml/ocaml/pull/1841),
  [#7808](https://github.com/ocaml/ocaml/pull/7808):
  The environment variable `OCAMLTOP_INCLUDE_PATH` can now
  specify a list of additional include directories for the ocaml toplevel.
  (Nicolás Ojeda Bär, request by Daniel Bünzli, review by Daniel Bünzli and
  Damien Doligez)

- [#6638](https://github.com/ocaml/ocaml/pull/6638),
  [#1110](https://github.com/ocaml/ocaml/pull/1110):
  introduced a dedicated warning to report
  unused `open!` statements
  (Alain Frisch, report by dwang, review by and design from Leo White)

- [#1974](https://github.com/ocaml/ocaml/pull/1974):
  Trigger warning 5 in `let _ = e` and `ignore e` if `e` is of function
  type and syntactically an application. (For the case of `ignore e` the warning
  already existed, but used to be triggered even when e was not an application.)
  (Nicolás Ojeda Bär, review by Alain Frisch and Jacques Garrigue)

- [#7408](https://github.com/ocaml/ocaml/pull/7408),
  [#7846](https://github.com/ocaml/ocaml/pull/7846),
  [#2015](https://github.com/ocaml/ocaml/pull/2015):
  Check arity of primitives.
  (Hugo Heuzard, review by Nicolás Ojeda Bär)


- [#2091](https://github.com/ocaml/ocaml/pull/2091):
  Add a warning triggered by type declarations `type t = ()`
  (Armaël Guéneau, report by linse, review by Florian Angeletti and Gabriel
  Scherer)

- [#2004](https://github.com/ocaml/ocaml/pull/2004):
  Use common standard library path `lib/ocaml` for Windows,
  for consistency with OSX & Linux. Previously was located at `lib`.
  (Bryan Phelps, Jordan Walke, review by David Allsopp)

- [#6416](https://github.com/ocaml/ocaml/pull/6416),
  [#1120](https://github.com/ocaml/ocaml/pull/1120):
  unique printed names for identifiers.
  (Florian Angeletti, review by Jacques Garrigue)

- [#1691](https://github.com/ocaml/ocaml/pull/1691):
  add `shared_libraries` to `ocamlc -config` exporting
  `SUPPORTS_SHARED_LIBRARIES` from `Makefile.config`.
  (David Allsopp, review by Gabriel Scherer and Mark Shinwell)

- [#6913](https://github.com/ocaml/ocaml/pull/6913),
  [#1786](https://github.com/ocaml/ocaml/pull/1786):
  new `-match-context-rows` option
  to control the degree of optimization in the pattern matching compiler.
  (Dwight Guth, review by Gabriel Scherer and Luc Maranget)

- [#1822](https://github.com/ocaml/ocaml/pull/1822):
  keep attributes attached to pattern variables from being discarded.
  (Nicolás Ojeda Bär, review by Thomas Refis)

- [#1845](https://github.com/ocaml/ocaml/pull/1845):
  new `-dcamlprimc` option to keep the generated C file containing
  the information about primitives; pass `-fdebug-prefix-map` to the C compiler
  when supported, for reproducible builds.
  (Xavier Clerc, review by Jérémie Dimino)

- [#1856](https://github.com/ocaml/ocaml/pull/1856),
  [#1869](https://github.com/ocaml/ocaml/pull/1869):
  use `BUILD_PATH_PREFIX_MAP` when compiling primitives
  in order to make builds reproducible if code contains uses of
  `__FILE__` or `__LOC__`
  (Xavier Clerc, review by Gabriel Scherer and Sébastien Hinderer)

- [#1906](https://github.com/ocaml/ocaml/pull/1906):
  the `-unsafe` option does not apply to marshalled ASTs passed
  to the compiler directly or by a `-pp` preprocessor; add a proper
  warning (64) instead of a simple stderr message
  (Valentin Gatien-Baron)

- [#1925](https://github.com/ocaml/ocaml/pull/1925):
  Print error locations more consistently between batch mode, toplevel
  and expect tests.
  (Armaël Guéneau, review by Thomas Refis, Gabriel Scherer and François Bobot)

- [#1930](https://github.com/ocaml/ocaml/pull/1930):
  pass the elements from `BUILD_PATH_PREFIX_MAP` to the assembler.
  (Xavier Clerc, review by Gabriel Scherer, Sébastien Hinderer, and
   Xavier Leroy)

- [#1945](https://github.com/ocaml/ocaml/pull/1945),
  [#2032](https://github.com/ocaml/ocaml/pull/2032):
  new `-stop-after [parsing|typing]` option
  to stop compilation after the parsing or typing pass.
  (Gabriel Scherer, review by Jérémie Dimino)

- [#1953](https://github.com/ocaml/ocaml/pull/1953):
  Add locations to attributes in the parsetree.
  (Hugo Heuzard, review by Gabriel Radanne)

- [#1954](https://github.com/ocaml/ocaml/pull/1954):
  Add locations to toplevel directives.
  (Hugo Heuzard, review by Gabriel Radanne)

* [#1979](https://github.com/ocaml/ocaml/pull/1979):
  Remove support for `TERM=norepeat` when displaying errors.
  (Armaël Guéneau, review by Gabriel Scherer and Florian Angeletti)

- [#1960](https://github.com/ocaml/ocaml/pull/1960):
  The parser keeps previous location when relocating ast node.
  (Hugo Heuzard, review by Jérémie Dimino)

- [#7864](https://github.com/ocaml/ocaml/pull/7864),
  [#2109](https://github.com/ocaml/ocaml/pull/2109):
  remove duplicates from spelling suggestions.
  (Nicolás Ojeda Bär, review by Armaël Guéneau)

### Manual and documentation:

- [#7548](https://github.com/ocaml/ocaml/pull/7548):
  printf example in the tutorial part of the manual
 (Kostikova Oxana, rewiew by Gabriel Scherer, Florian Angeletti,
 Marcello Seri and Armaël Guéneau)

- [#7546](https://github.com/ocaml/ocaml/pull/7546),
  [#2020](https://github.com/ocaml/ocaml/pull/2020):
  preambles and introduction for compiler-libs.
  (Florian Angeletti, review by Daniel Bünzli, Perry E. Metzger
  and Gabriel Scherer)

- [#7547](https://github.com/ocaml/ocaml/pull/7547),
  [#2273](https://github.com/ocaml/ocaml/pull/2273):
  Tutorial on Lazy expressions and patterns in OCaml Manual
  (Ulugbek Abdullaev, review by Florian Angeletti and Gabriel Scherer)

- [#7720](https://github.com/ocaml/ocaml/pull/7720),
  [#1596](https://github.com/ocaml/ocaml/pull/1596),
  precise the documentation
  of the maximum indentation limit in `Format`.
  (Florian Angeletti, review by Richard Bonichon and Pierre Weis)

- [#7825](https://github.com/ocaml/ocaml/pull/7825):
  html manual split compilerlibs from stdlib in the html
  index of modules.
  (Florian Angeletti, review by Perry E. Metzger and Gabriel Scherer)

- [#1209](https://github.com/ocaml/ocaml/pull/1209),
  [#2008](https://github.com/ocaml/ocaml/pull/2008):
  in the Extension section, use the caml_example environment
  (uses the compiler to check the example code).
  This change was made possible by a lot of tooling work from Florian Angeletti:
  [#1702](https://github.com/ocaml/ocaml/pull/1702),
  [#1765](https://github.com/ocaml/ocaml/pull/1765),
  [#1863](https://github.com/ocaml/ocaml/pull/1863), and Gabriel Scherer's 
  [#1903](https://github.com/ocaml/ocaml/pull/1903).
  (Gabriel Scherer, review by Florian Angeletti)

- [#1788](https://github.com/ocaml/ocaml/pull/1788),
  [#1831](https://github.com/ocaml/ocaml/pull/1831),
  [#2007](https://github.com/ocaml/ocaml/pull/2007),
  [#2198](https://github.com/ocaml/ocaml/pull/2198),
  [#2232](https://github.com/ocaml/ocaml/pull/2232):
  move language extensions to the core
  chapters:
     - [#1788](https://github.com/ocaml/ocaml/pull/1788): quoted
       string description
     - [#1831](https://github.com/ocaml/ocaml/pull/1831): local
       exceptions and exception cases
     - [#2007](https://github.com/ocaml/ocaml/pull/2007): 32-bit,
       64-bit and native integer literals
     - [#2198](https://github.com/ocaml/ocaml/pull/2198): lazy patterns
     - [#2232](https://github.com/ocaml/ocaml/pull/2232): short
       object copy notation.

  (Florian Angeletti, review by Xavier Clerc, Perry E. Metzger, Gabriel Scherer
   and Jeremy Yallop)

- [#1863](https://github.com/ocaml/ocaml/pull/1863):
  caml-tex2, move to compiler-libs
  (Florian Angeletti, review by Sébastien Hinderer and Gabriel Scherer)

- [#2105](https://github.com/ocaml/ocaml/pull/2105):
  Change verbatim to caml_example in documentation
  (Maxime Flin, review by Florian Angeletti)

- [#2114](https://github.com/ocaml/ocaml/pull/2114):
  ocamldoc, improved manpages for documentation inside modules
  (Florian Angeletti, review by Gabriel Scherer)

- [#2117](https://github.com/ocaml/ocaml/pull/2117):
  stdlib documentation, duplicate the operator precedence table
  from the manual inside a separate "OCaml_operators" module.
  (Florian Angeletti, review by Daniel Bünzli, Perry E. Metzger
  and Gabriel Scherer)

- [#2187](https://github.com/ocaml/ocaml/pull/2187):
  document `exception A | pat` patterns
  (Florian Angeletti, review by Perry E. Metzger and Jeremy Yallop)

- [#8508](https://github.com/ocaml/ocaml/pull/8508):
  refresh `\\moduleref` macro
  (Florian Angeletti, review by Gabriel Scherer)

### Code generation and optimizations:

- [#7725](https://github.com/ocaml/ocaml/pull/7725),
  [#1754](https://github.com/ocaml/ocaml/pull/1754):
  improve AFL instrumentation for objects and lazy values.
  (Stephen Dolan)

- [#1631](https://github.com/ocaml/ocaml/pull/1631):
  AMD64 code generator: emit shorter instruction sequences for the
  sign-extension operations.
  (LemonBoy, review by Alain Frisch and Xavier Leroy)

- [#7246](https://github.com/ocaml/ocaml/pull/7246),
  [#2146](https://github.com/ocaml/ocaml/pull/2146):
  make a few int64 primitives use `[@@unboxed]`
  stubs on 32bits.
  (Jérémie Dimino)

- [#1917](https://github.com/ocaml/ocaml/pull/1917):
  comballoc: ensure object allocation order is preserved
  (Stephen Dolan)

- [#6242](https://github.com/ocaml/ocaml/pull/6242),
  [#2143](https://github.com/ocaml/ocaml/pull/2143),
  [#8558](https://github.com/ocaml/ocaml/pull/8558),
  [#8559](https://github.com/ocaml/ocaml/pull/8559):
  Optimize some local functions.
  Local functions that do not escape and whose calls all have
  the same continuation are lowered into a static-catch handler.
  (Alain Frisch, review by Gabriel Scherer)

- [#2082](https://github.com/ocaml/ocaml/pull/2082):
  New options `-insn-sched` and `-no-insn-sched` to control
  instruction scheduling.
  (Mark Shinwell, review by Damien Doligez)

- [#2239](https://github.com/ocaml/ocaml/pull/2239):
  Fix match miscompilation with flambda.
  (Leo White, review by Alain Frisch)

### Runtime system:

- [#7198](https://github.com/ocaml/ocaml/pull/7198),
  [#7750](https://github.com/ocaml/ocaml/pull/7750),
  [#1738](https://github.com/ocaml/ocaml/pull/1738):
  add a function (`caml_alloc_custom_mem`)
  and three GC parameters to give the user better control of the
  out-of-heap memory retained by custom values; use the function to
  allocate bigarrays and I/O channels.
  (Damien Doligez, review by Alain Frisch)

- [#1793](https://github.com/ocaml/ocaml/pull/1793):
  add the `-m` and `-M` command-line options to `ocamlrun`.
  Option `-m` prints the magic number of the bytecode executable passed
  as argument, `-M` prints the magic number expected by ocamlrun.
  (Sébastien Hinderer, review by Xavier Clerc and Damien Doligez)

- [#1867](https://github.com/ocaml/ocaml/pull/1867):
  Remove the C plugins mechanism.
  (Xavier Leroy, review by David Allsopp, Damien Doligez, Sébastien Hinderer)

- [#8627](https://github.com/ocaml/ocaml/pull/8627):
  Require SSE2 for 32-bit mingw port to generate correct code
  for caml_round with GCC 7.4.
  (David Allsopp, review by Xavier Leroy)

- [#7676](https://github.com/ocaml/ocaml/pull/7676),
  [#2144](https://github.com/ocaml/ocaml/pull/2144):
  Remove old GC heuristic.
  (Damien Doligez, report and review by Alain Frisch)

- [#1723](https://github.com/ocaml/ocaml/pull/1723):
  Remove internal `Meta.static_{alloc,free}` primitives.
  (Stephen Dolan, review by Gabriel Scherer)

- [#1895](https://github.com/ocaml/ocaml/pull/1895):
  `Printexc.get_callstack` would return only one frame in native
  code in threads other then the initial one.
  (Valentin Gatien-Baron, review by Xavier Leroy)

- [#1900](https://github.com/ocaml/ocaml/pull/1900),
  [#7814](https://github.com/ocaml/ocaml/pull/7814):
  Avoid exporting non-prefixed identifiers in the debug
  and instrumented runtimes.
  (Damien Doligez, report by Gabriel Scherer)

- [#2079](https://github.com/ocaml/ocaml/pull/2079):
  Avoid page table lookup in Pervasives.compare with
  no-naked-pointers.
  (Sam Goldman, review by Gabriel Scherer, David Allsopp, Stephen Dolan)

- [#7829](https://github.com/ocaml/ocaml/pull/7829),
  [#8585](https://github.com/ocaml/ocaml/pull/8585):
  Fix pointer comparisons in `freelist.c` (for 32-bit platforms).
  (David Allsopp and Damien Doligez)

- [#8567](https://github.com/ocaml/ocaml/pull/8567),
  [#8569](https://github.com/ocaml/ocaml/pull/8569):
  On ARM64, use 32-bit loads to access `caml_backtrace_active`.
  (Xavier Leroy, review by Mark Shinwell and Greta Yorsh)

- [#8568](https://github.com/ocaml/ocaml/pull/8568):
  Fix a memory leak in mmapped bigarrays.
  (Damien Doligez, review by Xavier Leroy and Jérémie Dimino)

### Tools

- [#2182](https://github.com/ocaml/ocaml/pull/2182):
  Split Emacs caml-mode as an independent project.
  (Christophe Troestler, review by Gabriel Scherer)

- [#1865](https://github.com/ocaml/ocaml/pull/1865):
  Support dark themes in Emacs, and clean up usage of
  deprecated Emacs APIs.
  (Wilfred Hughes, review by Clément Pit-Claudel)

- [#1590](https://github.com/ocaml/ocaml/pull/1590):
  ocamllex-generated lexers can be instructed not to update
  their `lex_curr_p`/`lex_start_p` fields, resulting in a significant
  performance gain when those fields are not required.
  (Alain Frisch, review by Jérémie Dimino)

- [#7843](https://github.com/ocaml/ocaml/pull/7843),
  [#2013](https://github.com/ocaml/ocaml/pull/2013):
  ocamldoc, better handling of `((! echo {{!label}text} !))` in the latex
  backend.
  (Florian Angeletti, review by Nicolás Ojeda Bär and Gabriel Scherer)

- [#7844](https://github.com/ocaml/ocaml/pull/7844),
  [#2040](https://github.com/ocaml/ocaml/pull/2040):
  Emacs, use built-in detection of comments,
  fixes an imenu crash.
  (Wilfred Hughes, review by Christophe Troestler)

- [#7850](https://github.com/ocaml/ocaml/pull/7850):
  Emacs, use symbol boundaries in regular expressions,
  fixes an imenu crash.
  (Wilfred Hughes, review by Christophe Troestler)

- [#1711](https://github.com/ocaml/ocaml/pull/1711):
  the new `open` flag in `OCAMLRUNPARAM` takes a comma-separated list of
  modules to open as if they had been passed via the command line `-open` flag.
  (Nicolás Ojeda Bär, review by Mark Shinwell)

- [#2000](https://github.com/ocaml/ocaml/pull/2000):
  `ocamdoc`, extended support for `include module type of ...`
  (Florian Angeletti, review by Jérémie Dimino)

- [#2045](https://github.com/ocaml/ocaml/pull/2045):
  `ocamlmklib` now supports options `-args` and `-args0` to provide extra
  command-line arguments in a file.
  (Nicolás Ojeda Bär, review by Gabriel Scherer and Daniel Bünzli)

- [#2189](https://github.com/ocaml/ocaml/pull/2189):
  change ocamldep Makefile-output to print each dependency
  on a new line, for more readable diffs of versioned dependencies.
  (Gabriel Scherer, review by Nicolás Ojeda Bär)

- [#2223](https://github.com/ocaml/ocaml/pull/2223):
  ocamltest: fix the "bsd" and "not-bsd" built-in actions to
  recognize all BSD variants.
  (Damien Doligez, review by Sébastien Hinderer and David Allsopp)

### Compiler distribution build system:

- [#1776](https://github.com/ocaml/ocaml/pull/1776):
  add `-no-install-bytecode-programs` and related configure options to
  control (non-)installation of `.byte` executables.
  (Mark Shinwell, review by Sébastien Hinderer and Gabriel Scherer)

- [#1777](https://github.com/ocaml/ocaml/pull/1777):
  add `-no-install-source-artifacts` and related configure options to
  control installation of `.cmt`, `.cmti`, `.mli` and `.ml` files.
  (Mark Shinwell, review by Nicolás Ojeda Bär and Sébastien Hinderer)

- [#1781](https://github.com/ocaml/ocaml/pull/1781):
  cleanup of the manual's build process.
  (steinuil, review by Marcello Seri, Gabriel Scherer and Florian Angeletti)

- [#1797](https://github.com/ocaml/ocaml/pull/1797):
  remove the deprecated `Makefile.nt` files.
  (Sébastien Hinderer, review by Nicolas Ojeda Bar)

- [#1805](https://github.com/ocaml/ocaml/pull/1805):
  fix the bootstrap procedure and its documentation.
  (Sébastien Hinderer, Xavier Leroy and Damien Doligez; review by
  Gabriel Scherer)

- [#1840](https://github.com/ocaml/ocaml/pull/1840):
  build system enhancements.
  (Sébastien Hinderer, review by David Allsopp, Xavier Leroy and
  Damien Doligez)

- [#1852](https://github.com/ocaml/ocaml/pull/1852):
  merge runtime directories.
  (Sébastien Hinderer, review by Xavier Leroy and Damien Doligez)

- [#1854](https://github.com/ocaml/ocaml/pull/1854):
  remove the no longer defined `BYTECCCOMPOPTS` build variable.
  (Sébastien Hinderer, review by Damien Doligez)

- [#2024](https://github.com/ocaml/ocaml/pull/2024):
  stop supporting obsolete platforms: Rhapsody (old beta
  version of MacOS X, BeOS, alpha\\*-\\*-linux\\*, mips-\\*-irix6\\*,
  alpha\\*-\\*-unicos, powerpc-\\*-aix, \\*-\\*-solaris2\\*, mips\\*-\\*-irix[56]\\*,
  i[3456]86-\\*-darwin[89].\\*, i[3456]86-\\*-solaris\\*, \\*-\\*-sunos\\*
  \\*- \\*-unicos.
  (Sébastien Hinderer, review by Xavier Leroy, Damien Doligez, Gabriel
  Scherer and Armaël Guéneau)

- [#2053](https://github.com/ocaml/ocaml/pull/2053):
  allow unix, vmthreads and str not to be built.
  (David Allsopp, review by Sébastien Hinderer)

* [#2059](https://github.com/ocaml/ocaml/pull/2059):
  stop defining `OCAML_STDLIB_DIR` in `s.h`.
  (Sébastien Hinderer, review by David Allsopp and Damien Doligez)

* [#2066](https://github.com/ocaml/ocaml/pull/2066):
  remove the `standard_runtime` configuration variable.
  (Sébastien Hinderer, review by Xavier Leroy, Stephen Dolan and
  Damien Doligez)

* [#2139](https://github.com/ocaml/ocaml/pull/2139):
  use autoconf to generate the compiler's configuration script.
  (Sébastien Hinderer, review by Damien Doligez and David Allsopp)

- [#2148](https://github.com/ocaml/ocaml/pull/2148):
  fix a parallel build bug involving `CamlinternalLazy`.
  (Stephen Dolan, review by Gabriel Scherer and Nicolas Ojeda Bar)

- [#2264](https://github.com/ocaml/ocaml/pull/2264),
  [#7904](https://github.com/ocaml/ocaml/pull/7904):
  the configure script now sets the Unicode handling mode under
  Windows according to the value of the variable
  `WINDOWS_UNICODE_MODE`.  If `WINDOWS_UNICODE_MODE` is `ansi` then it
  is assumed to be the current code page encoding.  If
  `WINDOWS_UNICODE_MODE` is `compatible` or empty or not set at all,
  then encoding is UTF-8 with code page fallback.
  (Nicolás Ojeda Bär, review by Sébastien Hinderer and David Allsopp)

- [#2266](https://github.com/ocaml/ocaml/pull/2266):
  ensure Cygwin ports configure with `EXE=.exe`, or the compiler is
  unable to find the camlheader files (subtle regression of #2139/2041)
  (David Allsopp, report and review by Sébastien Hinderer)

- [#7919](https://github.com/ocaml/ocaml/pull/7919),
  [#2311](https://github.com/ocaml/ocaml/pull/2311):
  Fix assembler detection in configure.
  (Sébastien Hinderer, review by David Allsopp)

- [#2295](https://github.com/ocaml/ocaml/pull/2295):
  Restore support for bytecode target XLC/AIX/Power.
  (Konstantin Romanov, review by Sébastien Hinderer and David Allsopp)

- [#8528](https://github.com/ocaml/ocaml/pull/8528):
  get rid of the direct call to the C preprocessor in the testsuite.
  (Sébastien Hinderer, review by David Allsopp)

- [#7938](https://github.com/ocaml/ocaml/pull/7938),
  [#8532](https://github.com/ocaml/ocaml/pull/8532):
  Fix alignment detection for ints on 32-bits platforms.
  (Sébastien Hinderer, review by Xavier Leroy)

* [#8533](https://github.com/ocaml/ocaml/pull/8533):
  Remove some unused configure tests.
  (Stephen Dolan, review by David Allsopp and Sébastien Hinderer)

- [#2207](https://github.com/ocaml/ocaml/pull/2207),
  [#8604](https://github.com/ocaml/ocaml/pull/8604):
  Add opam files to allow pinning.
  (Leo White, Greta Yorsh, review by Gabriel Radanne)

- [#8616](https://github.com/ocaml/ocaml/pull/8616):
  configure: use variables rather than arguments for a few options.
  (Sébastien Hinderer, review by David Allsopp, Gabriel Scherer and
  Damien Doligez)

- [#8632](https://github.com/ocaml/ocaml/pull/8632):
  Correctly propagate flags for `--with-pic` in configure.
  (David Allsopp, review by Sébastien Hinderer and Damien Doligez)

- [#8673](https://github.com/ocaml/ocaml/pull/8673):
  restore SpaceTime and libunwind support in configure script.
  (Sébastien Hinderer, review by Damien Doligez)

### Internal/compiler-libs changes:

- [#7918](https://github.com/ocaml/ocaml/pull/7918),
  [#1703](https://github.com/ocaml/ocaml/pull/1703),
  [#1944](https://github.com/ocaml/ocaml/pull/1944),
  [#2213](https://github.com/ocaml/ocaml/pull/2213),
  [#2257](https://github.com/ocaml/ocaml/pull/2257):
  Add the module
  `Compile_common`, which factorizes the common part in `Compile` and
  `Optcompile`.  This also makes the pipeline more modular.
  (Gabriel Radanne, help from Gabriel Scherer and Valentin
   Gatien-Baron, review by Mark Shinwell and Gabriel Radanne,
   regression spotted by Clément Franchini)

- [#292](https://github.com/ocaml/ocaml/pull/292):
  use Menhir as the parser generator for the OCaml parser.
  Satellite GPRs: [#1844](https://github.com/ocaml/ocaml/pull/1844),
  [#1846](https://github.com/ocaml/ocaml/pull/1846),
  [#1853](https://github.com/ocaml/ocaml/pull/1853),
  [#1850](https://github.com/ocaml/ocaml/pull/1850),
  [#1934](https://github.com/ocaml/ocaml/pull/1934),
  [#2151](https://github.com/ocaml/ocaml/pull/2151),
  [#2174](https://github.com/ocaml/ocaml/pull/2174)
  (Gabriel Scherer, Nicolás Ojeda Bär, Frédéric Bour, Thomas Refis
   and François Pottier,
   review by Nicolás Ojeda Bär, Leo White and David Allsopp)

- [#374](https://github.com/ocaml/ocaml/pull/374):
  use `Misc.try_finally` for resource cleanup in the compiler
  codebase. This should fix the problem of catch-and-reraise `try .. with`
  blocks destroying backtrace information — in the compiler.
  (François Bobot, help from Gabriel Scherer and Nicolás Ojeda Bär,
   review by Gabriel Scherer)

- [#1148](https://github.com/ocaml/ocaml/pull/1148),
  [#1287](https://github.com/ocaml/ocaml/pull/1287),
  [#1288](https://github.com/ocaml/ocaml/pull/1288),
  [#1874](https://github.com/ocaml/ocaml/pull/1874):
  significant improvements
  of the tools/check-typo script used over the files of the whole repository;
  contributors are now expected to check that check-typo passes on their
  pull requests; see `CONTRIBUTING.md` for more details.
  (David Allsopp, review by Damien Doligez and Sébastien Hinderer)

- [#1610](https://github.com/ocaml/ocaml/pull/1610),
  [#2252](https://github.com/ocaml/ocaml/pull/2252):
  Remove positions from paths.
  (Leo White, review by Frédéric Bour and Thomas Refis)

- [#1745](https://github.com/ocaml/ocaml/pull/1745):
  do not generalize the type of every sub-pattern,
  only of variables (preliminary work for GADTs in or-patterns).
  (Thomas Refis, review by Leo White)

- [#1909](https://github.com/ocaml/ocaml/pull/1909):
  unsharing pattern types (preliminary work for GADTs in or-patterns).
  (Thomas Refis, with help from Leo White, review by Jacques Garrigue)

- [#1748](https://github.com/ocaml/ocaml/pull/1748):
  do not error when instantiating polymorphic fields in patterns.
  (Thomas Refis, review by Gabriel Scherer)

- [#2317](https://github.com/ocaml/ocaml/pull/2317):
  type_let: be more careful generalizing parts of the pattern.
  (Thomas Refis and Leo White, review by Jacques Garrigue)

- [#1746](https://github.com/ocaml/ocaml/pull/1746):
  remove unreachable error variant: `Make_seltype_nongen`.
  (Florian Angeletti, review by Gabriel Radanne)

- [#1747](https://github.com/ocaml/ocaml/pull/1747):
  type_cases: always propagate (preliminary work
  for GADTs in or-patterns).
  (Thomas Refis, review by Jacques Garrigue)

- [#1811](https://github.com/ocaml/ocaml/pull/1811):
  shadow the polymorphic comparison in the middle-end.
  (Xavier Clerc, review by Pierre Chambart)

- [#1833](https://github.com/ocaml/ocaml/pull/1833):
  allow non-val payloads in CMM Ccatch handlers.
  (Simon Fowler, review by Xavier Clerc)

- [#1866](https://github.com/ocaml/ocaml/pull/1866):
  document the release process.
  (Damien Doligez and Gabriel Scherer, review by Sébastien Hinderer,
   Perry E. Metzger, Xavier Leroy and David Allsopp)

- [#1886](https://github.com/ocaml/ocaml/pull/1886):
  move the `Location.absname` reference to `Clflags.absname`.
  (Armaël Guéneau, review by Jérémie Dimino)

- [#1894](https://github.com/ocaml/ocaml/pull/1894):
  generalize `highlight_dumb` in `location.ml` to handle highlighting
  several locations.
  (Armaël Guéneau, review by Gabriel Scherer)

- [#1903](https://github.com/ocaml/ocaml/pull/1903):
  parsetree, add locations to all nodes with attributes.
  (Gabriel Scherer, review by Thomas Refis)

- [#1905](https://github.com/ocaml/ocaml/pull/1905):
  add check-typo-since to check the files changed
  since a given git reference.
  (Gabriel Scherer, review by David Allsopp)

- [#1910](https://github.com/ocaml/ocaml/pull/1910):
  improve the check-typo use of `.gitattributes`.
  (Gabriel Scherer, review by David Allsopp and Damien Doligez)

- [#1938](https://github.com/ocaml/ocaml/pull/1938):
  always check ast invariants after preprocessing.
  (Florian Angeletti, review by Alain Frisch and Gabriel Scherer)

- [#1941](https://github.com/ocaml/ocaml/pull/1941):
  refactor the command line parsing of ocamlcp and ocamloptp.
  (Valentin Gatien-Baron, review by Florian Angeletti)

- [#1948](https://github.com/ocaml/ocaml/pull/1948):
  Refactor `Stdlib.Format`. Notably, use `Stdlib.Stack` and `Stdlib.Queue`,
  and avoid exceptions for control flow.
  (Vladimir Keleshev, review by Nicolás Ojeda Bär and Gabriel Scherer)

* [#1952](https://github.com/ocaml/ocaml/pull/1952):
  refactor the code responsible for displaying errors and warnings
  `Location.report_error` is removed, use `Location.print_report` instead.
  (Armaël Guéneau, review by Thomas Refis)

- [#7835](https://github.com/ocaml/ocaml/pull/7835),
  [#1980](https://github.com/ocaml/ocaml/pull/1980),
  [#8548](https://github.com/ocaml/ocaml/pull/8548),
  [#8586](https://github.com/ocaml/ocaml/pull/8586):
  separate scope from stamp in idents and explicitly
  rescope idents when substituting signatures.
  (Thomas Refis, review by Jacques Garrigue and Leo White)

- [#1996](https://github.com/ocaml/ocaml/pull/1996):
  expose `Pprintast.longident` to help compiler-libs users print
  `Longident.t` values.
  (Gabriel Scherer, review by Florian Angeletti and Thomas Refis)

- [#2030](https://github.com/ocaml/ocaml/pull/2030):
  makefile targets to build AST files of sources
  for parser testing.  See `parsing/HACKING.adoc`.
  (Gabriel Scherer, review by Nicolás Ojeda Bär)

* [#2041](https://github.com/ocaml/ocaml/pull/2041):
  add a cache for looking up files in the load path.
  (Jérémie Dimino, review by Alain Frisch and David Allsopp)

- [#2047](https://github.com/ocaml/ocaml/pull/2047),
  [#2269](https://github.com/ocaml/ocaml/pull/2269):
  a new type for unification traces.
  (Florian Angeletti, report by Leo White (#2269),
   review by Thomas Refis and Gabriel Scherer)

- [#2055](https://github.com/ocaml/ocaml/pull/2055):
  Add `Linearize.Lprologue`.
  (Mark Shinwell, review by Pierre Chambart)

- [#2056](https://github.com/ocaml/ocaml/pull/2056):
  Use `Backend_var` rather than `Ident` from `Clambda` onwards;
  use `Backend_var.With_provenance` for variables in binding position.
  (Mark Shinwell, review by Pierre Chambart)

- [#2060](https://github.com/ocaml/ocaml/pull/2060):
  "Phantom let" support for the Clambda language.
  (Mark Shinwell, review by Vincent Laviron)

- [#2065](https://github.com/ocaml/ocaml/pull/2065):
  Add `Proc.destroyed_at_reloadretaddr`.
  (Mark Shinwell, review by Damien Doligez)

- [#2070](https://github.com/ocaml/ocaml/pull/2070):
  "Phantom let" support for the Cmm language.
  (Mark Shinwell, review by Vincent Laviron)

- [#2072](https://github.com/ocaml/ocaml/pull/2072):
  Always associate a scope to a type.
  (Thomas Refis, review by Jacques Garrigue and Leo White)

- [#2074](https://github.com/ocaml/ocaml/pull/2074):
  Correct naming of record field inside `Ialloc` terms.
  (Mark Shinwell, review by Jérémie Dimino)

- [#2076](https://github.com/ocaml/ocaml/pull/2076):
  Add `Targetint.print`.
  (Mark Shinwell)

- [#2080](https://github.com/ocaml/ocaml/pull/2080):
  Add `Proc.dwarf_register_numbers` and
  `Proc.stack_ptr_dwarf_register_number`.
  (Mark Shinwell, review by Bernhard Schommer)

- [#2088](https://github.com/ocaml/ocaml/pull/2088):
  Add `Clambda.usymbol_provenance`.
  (Mark Shinwell, review by Damien Doligez)

- [#2152](https://github.com/ocaml/ocaml/pull/2152),
  [#2517](https://github.com/ocaml/ocaml/pull/2517):
  refactorize the fixpoint to compute type-system
  properties of mutually-recursive type declarations.
  (Gabriel Scherer and Rodolphe Lepigre, review by Armaël Guéneau)

- [#2156](https://github.com/ocaml/ocaml/pull/2156):
  propagate more type information through Lambda and Clambda
  intermediate language, as a preparation step for more future optimizations.
  (Pierre Chambart and Alain Frisch, cross-reviewed by themselves)

- [#2160](https://github.com/ocaml/ocaml/pull/2160):
  restore `--disable-shared` support and ensure testsuite runs correctly
  when compiled without shared library support.
  (David Allsopp, review by Damien Doligez and Sébastien Hinderer)

* [#2173](https://github.com/ocaml/ocaml/pull/2173):
  removed `TypedtreeMap`.
  (Thomas Refis, review by Gabriel Scherer)

- [#7867](https://github.com/ocaml/ocaml/pull/7867):
  Fix `#mod_use` raising an exception for filenames with no
  extension.
  (Geoff Gole)

- [#2100](https://github.com/ocaml/ocaml/pull/2100):
  Fix `Unix.getaddrinfo` when called on strings containing
  null bytes; it would crash the GC later on.
  (Armaël Guéneau, report and fix by Joe, review by Sébastien Hinderer)

- [#7847](https://github.com/ocaml/ocaml/pull/7847),
  [#2019](https://github.com/ocaml/ocaml/pull/2019):
  Fix an infinite loop that could occur when the
  (Menhir-generated) parser encountered a syntax error in a certain
  specific state.
  (François Pottier, report by Stefan Muenzel,
  review by Frédéric Bour, Thomas Refis, Gabriel Scherer)

- [#1626](https://github.com/ocaml/ocaml/pull/1626):
  Do not allow recursive modules in `with module`.
  (Leo White, review by Gabriel Radanne)

- [#7726](https://github.com/ocaml/ocaml/pull/7726),
  [#1676](https://github.com/ocaml/ocaml/pull/1676):
  Recursive modules, equi-recursive types and stack overflow.
  (Jacques Garrigue, report by Jeremy Yallop, review by Leo White)

- [#7723](https://github.com/ocaml/ocaml/pull/7723),
  [#1698](https://github.com/ocaml/ocaml/pull/1698):
  Ensure `with module` and `with type` do not weaken
  module aliases.
  (Leo White, review by Gabriel Radanne and Jacques Garrigue)

- [#1719](https://github.com/ocaml/ocaml/pull/1719):
  fix `Pervasives.LargeFile` functions under Windows.
  (Alain Frisch)

- [#1739](https://github.com/ocaml/ocaml/pull/1739):
  ensure ocamltest waits for child processes to terminate on Windows.
  (David Allsopp, review by Sébastien Hinderer)

- [#7554](https://github.com/ocaml/ocaml/pull/7554),
  [#1751](https://github.com/ocaml/ocaml/pull/1751):
  `Lambda.subst`: also update debug event environments
  (Thomas Refis, review by Gabriel Scherer)

- [#7238](https://github.com/ocaml/ocaml/pull/7238),
  [#1825](https://github.com/ocaml/ocaml/pull/1825):
  in `Unix.in_channel_of_descr` and `Unix.out_channel_of_descr`,
  raise an error if the given file description is not suitable for
  character-oriented I/O, for example if it is a block device or a
  datagram socket.
  (Xavier Leroy, review by Jérémie Dimino and Perry E. Metzger)

- [#7799](https://github.com/ocaml/ocaml/pull/7799),
  [#1820](https://github.com/ocaml/ocaml/pull/1820):
  fix bug where `Scanf.format_from_string` could fail when
  the argument string contained characters that require escaping.
  (Gabriel Scherer and Nicolás Ojeda Bär, report by Guillaume Melquiond, review
  by Gabriel Scherer)

- [#1843](https://github.com/ocaml/ocaml/pull/1843):
  ocamloptp was doing the wrong thing with option `-inline-max-unroll`.
  (Github user @poechsel, review by Nicolás Ojeda Bär).

- [#1890](https://github.com/ocaml/ocaml/pull/1890):
  remove last use of `Ctype.unroll_abbrev`.
  (Thomas Refis, report by Leo White, review by Jacques Garrigue)

- [#1893](https://github.com/ocaml/ocaml/pull/1893):
  dev-branch only, warning 40 (name not in scope) triggered spurious
  warnings 49 (missing cmi) with `-no-alias-deps`.
  (Florian Angeletti, report by Valentin Gatien-Baron,
  review by Gabriel Scherer)

- [#1912](https://github.com/ocaml/ocaml/pull/1912):
  Allow quoted strings, octal/unicode escape sequences and identifiers
  containing apostrophes in ocamllex actions and comments.
  (Pieter Goetschalckx, review by Damien Doligez)

- [#7828](https://github.com/ocaml/ocaml/pull/7828),
  [#1935](https://github.com/ocaml/ocaml/pull/1935):
  correct the conditions that generate warning 61,
  `Unboxable_type_in_prim_decl`.
  (Stefan Muenzel)

- [#1958](https://github.com/ocaml/ocaml/pull/1958):
  allow `module M(_:S) = struct end` syntax.
  (Hugo Heuzard, review by Gabriel Scherer)

- [#1970](https://github.com/ocaml/ocaml/pull/1970):
  fix order of floatting documentation comments in classes.
  (Hugo Heuzard, review by Nicolás Ojeda Bär)

- [#1977](https://github.com/ocaml/ocaml/pull/1977):
  `[@@ocaml.warning "..."]` attributes attached to type declarations are
  no longer ignored.
  (Nicolás Ojeda Bär, review by Gabriel Scherer)

- [#7830](https://github.com/ocaml/ocaml/pull/7830),
  [#1987](https://github.com/ocaml/ocaml/pull/1987):
  fix ocamldebug crash when printing a value in the scope of
  an `open` statement for which the `.cmi` is not available.
  (Nicolás Ojeda Bär, report by Jocelyn Sérot, review by Gabriel Scherer)

- [#7854](https://github.com/ocaml/ocaml/pull/7854),
  [#2062](https://github.com/ocaml/ocaml/pull/2062):
  fix an issue where the wrong locale may be used when using
  the legacy ANSI encoding under Windows.
  (Nicolás Ojeda Bär, report by Tiphaine Turpin)

- [#2083](https://github.com/ocaml/ocaml/pull/2083):
  Fix excessively aggressive float unboxing and introduce similar fix
  as a preventative measure for boxed int unboxing.
  (Thomas Refis, Mark Shinwell, Leo White)

- [#2130](https://github.com/ocaml/ocaml/pull/2130):
  fix printing of type variables with a quote in their name.
  (Alain Frisch, review by Armaël Guéneau and Gabriel Scherer,
  report by Hugo Heuzard)

- [#2131](https://github.com/ocaml/ocaml/pull/2131):
  fix wrong calls to `Env.normalize_path` on non-module paths.
  (Alain Frisch, review by Jacques Garrigue)

- [#2175](https://github.com/ocaml/ocaml/pull/2175):
  Apply substitution to all modules when packing.
  (Leo White, review by Gabriel Scherer)

- [#2220](https://github.com/ocaml/ocaml/pull/2220):
  Remove duplicate process management code in
  `otherlibs/threads/unix.ml`.
  (Romain Beauxis, review by Gabriel Scherer and Alain Frisch)

- [#2231](https://github.com/ocaml/ocaml/pull/2231):
  `Env`: always freshen persistent signatures before using them.
  (Thomas Refis and Leo White, review by Gabriel Radanne)

- [#7851](https://github.com/ocaml/ocaml/pull/7851),
  [#8570](https://github.com/ocaml/ocaml/pull/8570):
  Module type of allows to transform a malformed
  module type into a vicious signature, breaking soundness.
  (Jacques Garrigue, review by Leo White)

- [#7923](https://github.com/ocaml/ocaml/pull/7923),
  [#2259](https://github.com/ocaml/ocaml/pull/2259):
  fix regression in FlexDLL bootstrapped build caused by
  refactoring the root Makefile for Dune in #2093.
  (David Allsopp, report by Marc Lasson)

- [#7929](https://github.com/ocaml/ocaml/pull/7929),
  [#2261](https://github.com/ocaml/ocaml/pull/2261):
  `Subst.signature`: call cleanup_types exactly once.
  (Thomas Refis, review by Gabriel Scherer and Jacques Garrigue,
  report by Daniel Bünzli and Jon Ludlam)

- [#8550](https://github.com/ocaml/ocaml/pull/8550),
  [#8552](https://github.com/ocaml/ocaml/pull/8552):
  Soundness issue with class generalization.
  (Jacques Garrigue, review by Leo White and Thomas Refis,
  report by Jeremy Yallop)
|js}
  ; body_html = {js|<h2>Opam Switches</h2>
<p>This release is available as multiple
<a href="https://opam.ocaml.org/doc/Usage.html">OPAM</a> switches:</p>
<ul>
<li>4.08.0 — Official release 4.08.0
</li>
<li>4.08.0+32bit - Official release 4.08.0, compiled in 32-bit mode
for 64-bit Linux and OS X hosts
</li>
<li>4.08.0+afl — Official release 4.08.0, with afl-fuzz instrumentation
</li>
<li>4.08.0+bytecode-only - Official release 4.08.0, without the
native-code compiler
</li>
<li>4.08.0+default-unsafe-string — Official release 4.08.0, without
safe strings by default
strings by default
</li>
<li>4.08.0+flambda — Official release 4.08.0, with flambda activated
</li>
<li>4.08.0+flambda+no-flat-float-array — Official release 4.08.0, with
flambda activated and --disable-flat-float-array
</li>
<li>4.08.0+force-safe-string — Official release 4.08.0, with safe string
forced globally
</li>
<li>4.08.0+fp — Official release 4.08.0, with frame-pointers
</li>
<li>4.08.0+fp+flambda — Official release 4.08.0, with frame-pointers
and flambda activated
</li>
<li>4.08.0+musl+static+flambda - Official release 4.08.0, compiled with
musl-gcc -static and with flambda activated
</li>
<li>4.08.0+no-flat-float-array - Official release 4.08.0, with
--disable-flat-float-array
</li>
<li>4.08.0+spacetime - Official 4.08.0 release with spacetime activated
</li>
</ul>
<h2>What's new</h2>
<p>Some of the highlights in release 4.08 are:</p>
<ul>
<li>Binding operators (<code>let*</code>, <code>let+</code>, <code>and*</code>, etc). They can be used to
streamline monadic code.
</li>
<li><code>open</code> now applies to arbitrary module expression in structures and
to applicative paths in signatures.
</li>
<li>A new notion of (user-defined) &quot;alerts&quot; generalizes the deprecated
warning.
</li>
<li>New modules in the standard library: <code>Fun</code>, <code>Bool</code>, <code>Int</code>, <code>Option</code>,
<code>Result</code>.
</li>
<li>A significant number of new functions in <code>Float</code>, including FMA support,
and a new <code>Float.Array</code> submodule.
</li>
<li>Source highlighting for errors and warnings in batch mode.
</li>
<li>Many error messages were improved.
</li>
<li>Improved AFL instrumentation for objects and lazy values.
</li>
</ul>
<p>For a comprehensive list of changes and details on all new features,
bug fixes, optimizations, etc., please consult the
<a href="#Changes">changelog</a>.</p>
<h2>Source distribution</h2>
<ul>
<li><a href="https://github.com/ocaml/ocaml/archive/4.08.0.tar.gz">Source
tarball</a>
(.tar.gz) for compilation under Unix (including Linux and MacOS X)
and Microsoft Windows (including Cygwin).
</li>
<li>Also available in
<a href="https://github.com/ocaml/ocaml/archive/4.08.0.zip">.zip</a>
format.
</li>
<li><a href="https://opam.ocaml.org/">OPAM</a> is a source-based distribution of
OCaml and many companion libraries and tools. Compilation and
installation are automated by powerful package managers.
</li>
<li>The official development repo is hosted on
<a href="https://github.com/ocaml/ocaml">GitHub</a>.
</li>
</ul>
<p>The
<a href="4.08/notes/INSTALL.adoc">INSTALL</a> file
of the distribution provides detailed compilation and installation
instructions — see also the <a href="4.08/notes/README.win32.adoc">Windows release
notes</a> for
instructions on how to build under Windows.</p>
<h2>Alternative Compilers</h2>
<p>Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:</p>
<ul>
<li><a href="http://ocsigen.org/js_of_ocaml/">Js_of_ocaml</a> is a stable OCaml
to JavaScript compiler.
</li>
<li><a href="http://bucklescript.github.io/bucklescript/">Bucklescript</a> is a
newer OCaml to JavaScript compiler. See its
<a href="https://github.com/bucklescript/bucklescript/wiki/Differences-from-js_of_ocaml">wiki</a> for
an explanation of how it differs from <code>js_of_ocaml</code>.
</li>
<li><a href="http://www.ocamljava.org/">OCaml-java</a> is a stable OCaml to
Java compiler.
</li>
</ul>
<h2>User's manual</h2>
<p>The user's manual for OCaml can be:</p>
<ul>
<li><a href="4.08/htmlman/index.html">browsed
online</a>,
</li>
<li>downloaded as a single
<a href="4.08/ocaml-4.08-refman.ps.gz">PostScript</a>,
<a href="4.08/ocaml-4.08-refman.pdf">PDF</a>,
or <a href="4.08/ocaml-4.08-refman.txt">plain
text</a>
document,
</li>
<li>downloaded as a single
<a href="4.08/ocaml-4.08-refman-html.tar.gz">TAR</a>
or
<a href="4.08/ocaml-4.08-refman-html.zip">ZIP</a>
archive of HTML files,
</li>
<li>downloaded as a single
<a href="4.08/ocaml-4.08-refman.info.tar.gz">tarball</a>
of Emacs info files,
</li>
</ul>
<h2>Changes</h2>
<p>This is the
<a href="4.08/notes/Changes">changelog</a>.</p>
<p>(Changes that can break existing programs are marked with a &quot;*&quot;)</p>
<h3>Language features:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1947">#1947</a>:
Introduce binding operators (<code>let*</code>, <code>let+</code>, <code>and*</code> etc.)
(Leo White, review by Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1892">#1892</a>:
Allow shadowing of items coming from an <code>include</code>
(Thomas Refis, review by Gabriel Radanne)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2122">#2122</a>:
Introduce local substitutions in signatures: <code>type t := type_expr</code>
and <code>module M := Extended(Module).Path</code>
(Thomas Refis, with help and review from Leo White, and Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1804">#1804</a>:
New notion of &quot;alerts&quot; that generalizes the deprecated warning</p>
<pre><code>  [@@ocaml.alert deprecated &quot;Please use bar instead!&quot;]
  [@@ocaml.alert unsafe &quot;Please use safe_foo instead!&quot;]
</code></pre>
<p>(Alain Frisch, review by Leo White and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/6422">#6422</a>,
<a href="https://github.com/ocaml/ocaml/pull/7083">#7083</a>,
<a href="https://github.com/ocaml/ocaml/pull/305">#305</a>,
<a href="https://github.com/ocaml/ocaml/pull/1568">#1568</a>:
Allow <code>exception</code> under or-patterns
(Thomas Refis, with help and review from Alain Frisch, Gabriel Scherer, Jeremy
Yallop, Leo White and Luc Maranget)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1705">#1705</a>:
Allow <code>@@attributes</code> on exception declarations.
(Hugo Heuzard, review by Gabriel Radanne and Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1506">#1506</a>,
<a href="https://github.com/ocaml/ocaml/pull/2147">#2147</a>,
<a href="https://github.com/ocaml/ocaml/pull/2166">#2166</a>,
<a href="https://github.com/ocaml/ocaml/pull/2167">#2167</a>:
Extended <code>open</code> to arbitrary module
expression in structures and to applicative paths in signatures
(Runhang Li, review by Alain Frisch, Florian Angeletti, Jeremy Yallop,
Leo White and Thomas Refis)</p>
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2106">#2106</a>:
<code>.~</code> is now a reserved keyword, and is no longer available
for use in extended indexing operators
(Jeremy Yallop, review by Gabriel Scherer, Florian Angeletti, and
Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7841">#7841</a>,
<a href="https://github.com/ocaml/ocaml/pull/2041">#2041</a>,
<a href="https://github.com/ocaml/ocaml/pull/2235">#2235</a>:
allow modules from include directories
to shadow other ones, even in the toplevel; for a example, including
a directory that defines its own Result module will shadow the stdlib's.
(Jérémie Dimino, review by Alain Frisch and David Allsopp)</p>
</li>
</ul>
<h3>Type system:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2110">#2110</a>:
Partial support for GADTs inside or-patterns;
The type equalities introduced by the GADT constructor are only
available inside the or-pattern; they cannot be used in the
right-hand-side of the clause, when both sides of the or-pattern
agree on it.
(Thomas Refis and Leo White, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1826">#1826</a>:
allow expanding a type to a private abbreviation instead of
abstracting when removing references to an identifier.
(Thomas Refis and Leo White, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1942">#1942</a>,
<a href="https://github.com/ocaml/ocaml/pull/2244">#2244</a>:
simplification of the static check
for recursive definitions
(Alban Reynaud and Gabriel Scherer,
review by Jeremy Yallop, Armaël Guéneau and Damien Doligez)</p>
</li>
</ul>
<h3>Standard library:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2128">#2128</a>:
Add <code>Fun</code> module: <code>id</code>, <code>const</code>, <code>flip</code>, <code>negate</code>, <code>protect</code>
(protect is a <code>try_finally</code> combinator)
https://caml.inria.fr/pub/docs/manual-ocaml/libref/Fun.html
(Many fine eyes)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2010">#2010</a>:
Add <code>Bool</code> module
https://caml.inria.fr/pub/docs/manual-ocaml/libref/Bool.html
(Many fine eyes)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2011">#2011</a>:
Add <code>Int</code> module
https://caml.inria.fr/pub/docs/manual-ocaml/libref/Int.html
(Many fine eyes)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1940">#1940</a>:
Add <code>Option</code> module and <code>Format.pp_print_option</code>,
<code>none</code>, <code>some</code>, <code>value</code>, <code>get</code>, <code>bind</code>, <code>join</code>, <code>map</code>, <code>fold</code>, <code>iter</code>, etc.
https://caml.inria.fr/pub/docs/manual-ocaml/libref/Option.html
(Many fine eyes)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1956">#1956</a>:
Add <code>Result</code> module and <code>Format.pp_print_result</code>,
<code>ok</code>, <code>error</code>, <code>value</code>, <code>get_ok</code>, <code>bind</code>, <code>join</code>, <code>map</code>, <code>map_error</code>, etc.
https://caml.inria.fr/pub/docs/manual-ocaml/libref/Result.html
(Many fine eyes)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1855">#1855</a>,
<a href="https://github.com/ocaml/ocaml/pull/2118">#2118</a>:
Add <code>Fun.protect ~finally</code> for enforcing local
invariants whether a function raises or not, similar to
<code>unwind-protect</code> in Lisp and <code>FINALLY</code> in Modula-2. It is careful
about preserving backtraces and treating exceptions in finally as
errors.
(Marcello Seri and Guillaume Munch-Maccagnoni, review by Daniel
Bünzli, Gabriel Scherer, François Bobot, Nicolás Ojeda Bär, Xavier
Clerc, Boris Yakobowski, Damien Doligez, and Xavier Leroy)</p>
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/1605">#1605</a>:
Deprecate <code>Stdlib.Pervasives</code>. Following <a href="https://github.com/ocaml/ocaml/pull/1010">#1010</a>,
<code>Pervasives</code> is no longer needed and <code>Stdlib</code> should be used instead.
(Jérémie Dimino, review by Nicolás Ojeda Bär)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2185">#2185</a>:
Add <code>List.filter_map</code>.
(Thomas Refis, review by Alain Frisch and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1957">#1957</a>:
Add <code>Stack.{top_opt,pop_opt}</code> and <code>Queue.{peek_opt,take_opt}</code>.
(Vladimir Keleshev, review by Nicolás Ojeda Bär and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1182">#1182</a>:
Add new <code>Printf</code> formats <code>%#d</code>, <code>%#Ld</code>, <code>%#ld</code>, <code>%#nd</code> (idem for
<code>%i</code> and <code>%u</code> ) for alternative integer formatting — inserts
<code>_</code> between blocks of digits.
(ygrek, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1959">#1959</a>:
Add <code>Format.dprintf</code>, a printing function which outputs a closure
usable with <code>%t</code>.
(Gabriel Radanne, request by Armaël Guéneau,
review by Florian Angeletti and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1986">#1986</a>,
<a href="https://github.com/ocaml/ocaml/pull/6450">#6450</a>:
Add <code>Set.disjoint</code>.
(Nicolás Ojeda Bär, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7812">#7812</a>,
<a href="https://github.com/ocaml/ocaml/pull/2125">#2125</a>:
Add <code>Filename.chop_suffix_opt</code>.
(Alain Frisch, review by Nicolás Ojeda Bär, suggestion by whitequark)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1864">#1864</a>:
Extend <code>Bytes</code> and <code>Buffer</code> with functions to read/write
binary representations of numbers.
(Alain Frisch and Daniel Bünzli)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1458">#1458</a>:
Add unsigned operations <code>unsigned_div</code>, <code>unsigned_rem</code>, <code>unsigned_compare</code>
and <code>unsigned_to_int</code> to modules <code>Int32</code>, <code>Int64</code>, <code>Nativeint</code>.
(Nicolás Ojeda Bär, review by Daniel Bünzli, Alain Frisch and Max Mouratov)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2002">#2002</a>:
Add <code>Format.pp_print_custom_break</code>, a new more general kind of break
hint that can emit non-whitespace characters.
(Vladimir Keleshev and Pierre Weis, review by Josh Berdine, Gabriel Radanne)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1966">#1966</a>:
Add <code>Format</code> semantic tags using extensible sum types.
(Gabriel Radanne, review by Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1794">#1794</a>:
Add constants <code>zero</code>, <code>one</code>, <code>minus_one</code> and functions <code>succ</code>,
<code>pred</code>, <code>is_finite</code>, <code>is_infinite</code>, <code>is_nan</code>, <code>is_integer</code>, <code>trunc</code>, <code>round</code>,
<code>next_after</code>, <code>sign_bit</code>, <code>min</code>, <code>max</code>, <code>min_max</code>, <code>min_num</code>, <code>max_num</code>,
<code>min_max_num</code> to module <code>Float</code>.
(Christophe Troestler, review by Alain Frish, Xavier Clerc and Daniel Bünzli)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1354">#1354</a>,
<a href="https://github.com/ocaml/ocaml/pull/2177">#2177</a>:
Add fma support to <code>Float</code> module.
(Laurent Thévenoux, review by Alain Frisch, Jacques-Henri Jourdan,
Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/5072">#5072</a>,
<a href="https://github.com/ocaml/ocaml/pull/6655">#6655</a>,
<a href="https://github.com/ocaml/ocaml/pull/1876">#1876</a>:
add aliases in <code>Stdlib</code> for built-in types
and exceptions.
(Jeremy Yallop, reports by Pierre Letouzey and David Sheets,
review by Valentin Gatien-Baron, Gabriel Scherer and Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1731">#1731</a>:
<code>Format</code>, use <code>raise_notrace</code> to preserve backtraces.
(Frédéric Bour, report by Jules Villard, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/6701">#6701</a>,
<a href="https://github.com/ocaml/ocaml/pull/1185">#1185</a>,
<a href="https://github.com/ocaml/ocaml/pull/1803">#1803</a>:
make <code>float_of_string</code> and <code>string_of_float</code>
locale-independent.
(ygrek, review by Xavier Leroy and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7795">#7795</a>,
<a href="https://github.com/ocaml/ocaml/pull/1782">#1782</a>:
Fix off-by-one error in <code>Weak.create</code>.
(KC Sivaramakrishnan, review by Gabriel Scherer and François Bobot)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7235">#7235</a>:
<code>Format</code>, flush <code>err_formatter</code> at exit.
(Pierre Weis, request by Jun Furuse)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1857">#1857</a>,
<a href="https://github.com/ocaml/ocaml/pull/7812">#7812</a>:
Remove <code>Sort</code> module, deprecated since 2000 and emitting
a deprecation warning since 4.02.
(whitequark)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1923">#1923</a>:
<code>Arg</code> module sometimes misbehaved instead of rejecting invalid
<code>-keyword=arg</code> inputs
(Valentin Gatien-Baron, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1959">#1959</a>:
Small simplification and optimization to <code>Format.ifprintf</code>
(Gabriel Radanne, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2119">#2119</a>:
Clarify the documentation of <code>Set.diff</code>.
(Gabriel Scherer, suggestion by John Skaller)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2145">#2145</a>:
Deprecate the mutability of <code>Gc.control</code> record fields.
(Damien Doligez, review by Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2159">#2159</a>,
<a href="https://github.com/ocaml/ocaml/pull/7874">#7874</a>:
annotate <code>{String,Bytes}.equal</code> as being <code>[@@noalloc]</code>.
(Pierre-Marie Pédrot, review by Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1936">#1936</a>:
Add module <code>Float.Array</code>.
(Damien Doligez, review by Xavier Clerc and Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2183">#2183</a>:
Fix segfault in <code>Array.create_float</code> with <code>-no-flat-float-array</code>.
(Damien Doligez, review by Gabriel Scherer and Jeremy Yallop)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1525">#1525</a>:
Make function <code>set_max_indent</code> respect documentation.
(Pierre Weis, Richard Bonichon, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2202">#2202</a>:
Correct <code>Hashtbl.MakeSeeded.{add_seq,replace_seq,of_seq}</code> to use
functor hash function instead of default hash function.
<code>Hashtbl.Make.of_seq</code> shouldn't create randomized hash tables.
(David Allsopp, review by Alain Frisch)</p>
</li>
</ul>
<h3>Other libraries:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2533">#2533</a>,
<a href="https://github.com/ocaml/ocaml/pull/1839">#1839</a>,
<a href="https://github.com/ocaml/ocaml/pull/1949">#1949</a>:
added <code>Unix.fsync</code>.
(Francois Berenger, Nicolás Ojeda Bär, review by Daniel Bünzli, David Allsopp
and ygrek)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1792">#1792</a>,
<a href="https://github.com/ocaml/ocaml/pull/7794">#7794</a>:
Add <code>Unix.open_process_args{,_in,_out,_full}</code> similar to
<code>Unix.open_process{,_in,_out,_full}</code>, but passing an explicit argv array.
(Nicolás Ojeda Bär, review by Jérémie Dimino, request by Volker Diels-Grabsch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1999">#1999</a>:
Add <code>Unix.process{,_in,_out,_full}_pid</code> to retrieve opened process's
pid.
(Romain Beauxis, review by Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2222">#2222</a>:
Set default status in <code>waitpid</code> when pid is zero. Otherwise,
status value is undefined.
(Romain Beauxis and Xavier Leroy, review by Stephen Dolan)</p>
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/2104">#2104</a>,
<a href="https://github.com/ocaml/ocaml/pull/2211">#2211</a>,
<a href="https://github.com/ocaml/ocaml/pull/4127">#4127</a>,
<a href="https://github.com/ocaml/ocaml/pull/7709">#7709</a>:
Fix <code>Thread.sigmask</code>. When
system threads are loaded, <code>Unix.sigprocmask</code> is now an alias for
<code>Thread.sigmask</code>. This changes the behavior at least on MacOS, where
<code>Unix.sigprocmask</code> used to change the masks of all threads.
(Jacques-Henri Jourdan, review by Jérémie Dimino)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1061">#1061</a>:
Add <code>?follow</code> parameter to <code>Unix.link</code>. This allows hardlinking
symlinks.
(Christopher Zimmermann, review by Xavier Leroy, Damien Doligez, David
Allsopp, David Sheets)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2038">#2038</a>:
Deprecate vm threads.
OCaml supported both &quot;native threads&quot;, based on pthreads,
and its own green-threads implementation, &quot;vm threads&quot;. We are not
aware of any recent usage of &quot;vm threads&quot;, and removing them simplifies
further maintenance.
(Jérémie Dimino)</p>
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/4208">#4208</a>,
<a href="https://github.com/ocaml/ocaml/pull/4229">#4229</a>,
<a href="https://github.com/ocaml/ocaml/pull/4839">#4839</a>,
<a href="https://github.com/ocaml/ocaml/pull/6462">#6462</a>,
<a href="https://github.com/ocaml/ocaml/pull/6957">#6957</a>,
<a href="https://github.com/ocaml/ocaml/pull/6950">#6950</a>,
<a href="https://github.com/ocaml/ocaml/pull/1063">#1063</a>,
<a href="https://github.com/ocaml/ocaml/pull/2176">#2176</a>,
<a href="https://github.com/ocaml/ocaml/pull/2297">#2297</a>:
Make (nat)dynlink sound by correctly failing when
dynlinked module names clash with other modules or interfaces.
(Mark Shinwell, Leo White, Nicolás Ojeda Bär, Pierre Chambart)
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/2263">#2263</a>:
Delete the deprecated Bigarray.*.map_file functions in
favour of <code>*_of_genarray (Unix.map_file ...)</code> functions instead. The
<code>Unix.map_file</code> function was introduced in OCaml 4.06.0 onwards.
(Jérémie Dimino, reviewed by David Allsopp and Anil Madhavapeddy)
</li>
</ul>
<h3>Compiler user-interface and warnings:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2096">#2096</a>:
Add source highlighting for errors &amp; warnings in batch mode
(Armaël Guéneau, review by Gabriel Scherer and Jérémie Dimino)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2133">#2133</a>:
[@ocaml.warn_on_literal_pattern]: now warn on literal patterns
found anywhere in a constructor's arguments.
(Jeremy Yallop, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1720">#1720</a>:
Improve error reporting for missing <code>rec</code> in let-bindings.
(Arthur Charguéraud and Armaël Guéneau, with help and advice
from Gabriel Scherer, Frédéric Bour, Xavier Clerc and Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7116">#7116</a>,
<a href="https://github.com/ocaml/ocaml/pull/1430">#1430</a>:
new <code>-config-var</code> option
to get the value of a single configuration variable in scripts.
(Gabriel Scherer, review by Sébastien Hinderer and David Allsopp,
request by Adrien Nader)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1733">#1733</a>,
<a href="https://github.com/ocaml/ocaml/pull/1993">#1993</a>,
<a href="https://github.com/ocaml/ocaml/pull/1998">#1998</a>,
<a href="https://github.com/ocaml/ocaml/pull/2058">#2058</a>,
<a href="https://github.com/ocaml/ocaml/pull/2094">#2094</a>,
<a href="https://github.com/ocaml/ocaml/pull/2140">#2140</a>:
Typing error message improvements</p>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/1733">#1733</a>,
change the perspective of the unexpected existential error
message.
</li>
<li><a href="https://github.com/ocaml/ocaml/pull/1993">#1993</a>,
expanded error messages for universal quantification failure
</li>
<li><a href="https://github.com/ocaml/ocaml/pull/1998">#1998</a>,
more context for unbound type parameter error
</li>
<li><a href="https://github.com/ocaml/ocaml/pull/2058">#2058</a>, full
explanation for unsafe cycles in recursive module definitions
(suggestion by Ivan Gotovchits)
</li>
<li><a href="https://github.com/ocaml/ocaml/pull/2094">#2094</a>, rewording for
&quot;constructor has no type&quot; error
</li>
<li><a href="https://github.com/ocaml/ocaml/pull/7565">#7565</a>,
<a href="https://github.com/ocaml/ocaml/pull/2140">#2140</a>, more context
for universal variable escape in method type.
</li>
</ul>
<p>(Florian Angeletti, reviews by Jacques Garrique, Armaël Guéneau,
Gabriel Radanne, Gabriel Scherer and Jeremy Yallop)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1913">#1913</a>:
new flag <code>-dump-into-file</code> to print debug output like <code>-dlambda</code> into
a file named after the file being built, instead of on stderr.
(Valentin Gatien-Baron, review by Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1921">#1921</a>:
in the compilation context passed to ppx extensions,
add more configuration options related to type-checking:
<code>-rectypes</code>, <code>-principal</code>, <code>-alias-deps</code>, <code>-unboxed-types</code>, <code>-unsafe-string</code>.
(Gabriel Scherer, review by Gabriel Radanne, Xavier Clerc and Frédéric Bour)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1976">#1976</a>:
Better error messages for extension constructor type mismatches
(Thomas Refis, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1841">#1841</a>,
<a href="https://github.com/ocaml/ocaml/pull/7808">#7808</a>:
The environment variable <code>OCAMLTOP_INCLUDE_PATH</code> can now
specify a list of additional include directories for the ocaml toplevel.
(Nicolás Ojeda Bär, request by Daniel Bünzli, review by Daniel Bünzli and
Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/6638">#6638</a>,
<a href="https://github.com/ocaml/ocaml/pull/1110">#1110</a>:
introduced a dedicated warning to report
unused <code>open!</code> statements
(Alain Frisch, report by dwang, review by and design from Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1974">#1974</a>:
Trigger warning 5 in <code>let _ = e</code> and <code>ignore e</code> if <code>e</code> is of function
type and syntactically an application. (For the case of <code>ignore e</code> the warning
already existed, but used to be triggered even when e was not an application.)
(Nicolás Ojeda Bär, review by Alain Frisch and Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7408">#7408</a>,
<a href="https://github.com/ocaml/ocaml/pull/7846">#7846</a>,
<a href="https://github.com/ocaml/ocaml/pull/2015">#2015</a>:
Check arity of primitives.
(Hugo Heuzard, review by Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2091">#2091</a>:
Add a warning triggered by type declarations <code>type t = ()</code>
(Armaël Guéneau, report by linse, review by Florian Angeletti and Gabriel
Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2004">#2004</a>:
Use common standard library path <code>lib/ocaml</code> for Windows,
for consistency with OSX &amp; Linux. Previously was located at <code>lib</code>.
(Bryan Phelps, Jordan Walke, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/6416">#6416</a>,
<a href="https://github.com/ocaml/ocaml/pull/1120">#1120</a>:
unique printed names for identifiers.
(Florian Angeletti, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1691">#1691</a>:
add <code>shared_libraries</code> to <code>ocamlc -config</code> exporting
<code>SUPPORTS_SHARED_LIBRARIES</code> from <code>Makefile.config</code>.
(David Allsopp, review by Gabriel Scherer and Mark Shinwell)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/6913">#6913</a>,
<a href="https://github.com/ocaml/ocaml/pull/1786">#1786</a>:
new <code>-match-context-rows</code> option
to control the degree of optimization in the pattern matching compiler.
(Dwight Guth, review by Gabriel Scherer and Luc Maranget)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1822">#1822</a>:
keep attributes attached to pattern variables from being discarded.
(Nicolás Ojeda Bär, review by Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1845">#1845</a>:
new <code>-dcamlprimc</code> option to keep the generated C file containing
the information about primitives; pass <code>-fdebug-prefix-map</code> to the C compiler
when supported, for reproducible builds.
(Xavier Clerc, review by Jérémie Dimino)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1856">#1856</a>,
<a href="https://github.com/ocaml/ocaml/pull/1869">#1869</a>:
use <code>BUILD_PATH_PREFIX_MAP</code> when compiling primitives
in order to make builds reproducible if code contains uses of
<code>__FILE__</code> or <code>__LOC__</code>
(Xavier Clerc, review by Gabriel Scherer and Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1906">#1906</a>:
the <code>-unsafe</code> option does not apply to marshalled ASTs passed
to the compiler directly or by a <code>-pp</code> preprocessor; add a proper
warning (64) instead of a simple stderr message
(Valentin Gatien-Baron)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1925">#1925</a>:
Print error locations more consistently between batch mode, toplevel
and expect tests.
(Armaël Guéneau, review by Thomas Refis, Gabriel Scherer and François Bobot)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1930">#1930</a>:
pass the elements from <code>BUILD_PATH_PREFIX_MAP</code> to the assembler.
(Xavier Clerc, review by Gabriel Scherer, Sébastien Hinderer, and
Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1945">#1945</a>,
<a href="https://github.com/ocaml/ocaml/pull/2032">#2032</a>:
new <code>-stop-after [parsing|typing]</code> option
to stop compilation after the parsing or typing pass.
(Gabriel Scherer, review by Jérémie Dimino)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1953">#1953</a>:
Add locations to attributes in the parsetree.
(Hugo Heuzard, review by Gabriel Radanne)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1954">#1954</a>:
Add locations to toplevel directives.
(Hugo Heuzard, review by Gabriel Radanne)</p>
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/1979">#1979</a>:
Remove support for <code>TERM=norepeat</code> when displaying errors.
(Armaël Guéneau, review by Gabriel Scherer and Florian Angeletti)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1960">#1960</a>:
The parser keeps previous location when relocating ast node.
(Hugo Heuzard, review by Jérémie Dimino)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7864">#7864</a>,
<a href="https://github.com/ocaml/ocaml/pull/2109">#2109</a>:
remove duplicates from spelling suggestions.
(Nicolás Ojeda Bär, review by Armaël Guéneau)</p>
</li>
</ul>
<h3>Manual and documentation:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7548">#7548</a>:
printf example in the tutorial part of the manual
(Kostikova Oxana, rewiew by Gabriel Scherer, Florian Angeletti,
Marcello Seri and Armaël Guéneau)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7546">#7546</a>,
<a href="https://github.com/ocaml/ocaml/pull/2020">#2020</a>:
preambles and introduction for compiler-libs.
(Florian Angeletti, review by Daniel Bünzli, Perry E. Metzger
and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7547">#7547</a>,
<a href="https://github.com/ocaml/ocaml/pull/2273">#2273</a>:
Tutorial on Lazy expressions and patterns in OCaml Manual
(Ulugbek Abdullaev, review by Florian Angeletti and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7720">#7720</a>,
<a href="https://github.com/ocaml/ocaml/pull/1596">#1596</a>,
precise the documentation
of the maximum indentation limit in <code>Format</code>.
(Florian Angeletti, review by Richard Bonichon and Pierre Weis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7825">#7825</a>:
html manual split compilerlibs from stdlib in the html
index of modules.
(Florian Angeletti, review by Perry E. Metzger and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1209">#1209</a>,
<a href="https://github.com/ocaml/ocaml/pull/2008">#2008</a>:
in the Extension section, use the caml_example environment
(uses the compiler to check the example code).
This change was made possible by a lot of tooling work from Florian Angeletti:
<a href="https://github.com/ocaml/ocaml/pull/1702">#1702</a>,
<a href="https://github.com/ocaml/ocaml/pull/1765">#1765</a>,
<a href="https://github.com/ocaml/ocaml/pull/1863">#1863</a>, and Gabriel Scherer's
<a href="https://github.com/ocaml/ocaml/pull/1903">#1903</a>.
(Gabriel Scherer, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1788">#1788</a>,
<a href="https://github.com/ocaml/ocaml/pull/1831">#1831</a>,
<a href="https://github.com/ocaml/ocaml/pull/2007">#2007</a>,
<a href="https://github.com/ocaml/ocaml/pull/2198">#2198</a>,
<a href="https://github.com/ocaml/ocaml/pull/2232">#2232</a>:
move language extensions to the core
chapters:</p>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/1788">#1788</a>: quoted
string description
</li>
<li><a href="https://github.com/ocaml/ocaml/pull/1831">#1831</a>: local
exceptions and exception cases
</li>
<li><a href="https://github.com/ocaml/ocaml/pull/2007">#2007</a>: 32-bit,
64-bit and native integer literals
</li>
<li><a href="https://github.com/ocaml/ocaml/pull/2198">#2198</a>: lazy patterns
</li>
<li><a href="https://github.com/ocaml/ocaml/pull/2232">#2232</a>: short
object copy notation.
</li>
</ul>
<p>(Florian Angeletti, review by Xavier Clerc, Perry E. Metzger, Gabriel Scherer
and Jeremy Yallop)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1863">#1863</a>:
caml-tex2, move to compiler-libs
(Florian Angeletti, review by Sébastien Hinderer and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2105">#2105</a>:
Change verbatim to caml_example in documentation
(Maxime Flin, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2114">#2114</a>:
ocamldoc, improved manpages for documentation inside modules
(Florian Angeletti, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2117">#2117</a>:
stdlib documentation, duplicate the operator precedence table
from the manual inside a separate &quot;OCaml_operators&quot; module.
(Florian Angeletti, review by Daniel Bünzli, Perry E. Metzger
and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2187">#2187</a>:
document <code>exception A | pat</code> patterns
(Florian Angeletti, review by Perry E. Metzger and Jeremy Yallop)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/8508">#8508</a>:
refresh <code>\\moduleref</code> macro
(Florian Angeletti, review by Gabriel Scherer)</p>
</li>
</ul>
<h3>Code generation and optimizations:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7725">#7725</a>,
<a href="https://github.com/ocaml/ocaml/pull/1754">#1754</a>:
improve AFL instrumentation for objects and lazy values.
(Stephen Dolan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1631">#1631</a>:
AMD64 code generator: emit shorter instruction sequences for the
sign-extension operations.
(LemonBoy, review by Alain Frisch and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7246">#7246</a>,
<a href="https://github.com/ocaml/ocaml/pull/2146">#2146</a>:
make a few int64 primitives use <code>[@@unboxed]</code>
stubs on 32bits.
(Jérémie Dimino)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1917">#1917</a>:
comballoc: ensure object allocation order is preserved
(Stephen Dolan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/6242">#6242</a>,
<a href="https://github.com/ocaml/ocaml/pull/2143">#2143</a>,
<a href="https://github.com/ocaml/ocaml/pull/8558">#8558</a>,
<a href="https://github.com/ocaml/ocaml/pull/8559">#8559</a>:
Optimize some local functions.
Local functions that do not escape and whose calls all have
the same continuation are lowered into a static-catch handler.
(Alain Frisch, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2082">#2082</a>:
New options <code>-insn-sched</code> and <code>-no-insn-sched</code> to control
instruction scheduling.
(Mark Shinwell, review by Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2239">#2239</a>:
Fix match miscompilation with flambda.
(Leo White, review by Alain Frisch)</p>
</li>
</ul>
<h3>Runtime system:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7198">#7198</a>,
<a href="https://github.com/ocaml/ocaml/pull/7750">#7750</a>,
<a href="https://github.com/ocaml/ocaml/pull/1738">#1738</a>:
add a function (<code>caml_alloc_custom_mem</code>)
and three GC parameters to give the user better control of the
out-of-heap memory retained by custom values; use the function to
allocate bigarrays and I/O channels.
(Damien Doligez, review by Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1793">#1793</a>:
add the <code>-m</code> and <code>-M</code> command-line options to <code>ocamlrun</code>.
Option <code>-m</code> prints the magic number of the bytecode executable passed
as argument, <code>-M</code> prints the magic number expected by ocamlrun.
(Sébastien Hinderer, review by Xavier Clerc and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1867">#1867</a>:
Remove the C plugins mechanism.
(Xavier Leroy, review by David Allsopp, Damien Doligez, Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/8627">#8627</a>:
Require SSE2 for 32-bit mingw port to generate correct code
for caml_round with GCC 7.4.
(David Allsopp, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7676">#7676</a>,
<a href="https://github.com/ocaml/ocaml/pull/2144">#2144</a>:
Remove old GC heuristic.
(Damien Doligez, report and review by Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1723">#1723</a>:
Remove internal <code>Meta.static_{alloc,free}</code> primitives.
(Stephen Dolan, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1895">#1895</a>:
<code>Printexc.get_callstack</code> would return only one frame in native
code in threads other then the initial one.
(Valentin Gatien-Baron, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1900">#1900</a>,
<a href="https://github.com/ocaml/ocaml/pull/7814">#7814</a>:
Avoid exporting non-prefixed identifiers in the debug
and instrumented runtimes.
(Damien Doligez, report by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2079">#2079</a>:
Avoid page table lookup in Pervasives.compare with
no-naked-pointers.
(Sam Goldman, review by Gabriel Scherer, David Allsopp, Stephen Dolan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7829">#7829</a>,
<a href="https://github.com/ocaml/ocaml/pull/8585">#8585</a>:
Fix pointer comparisons in <code>freelist.c</code> (for 32-bit platforms).
(David Allsopp and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/8567">#8567</a>,
<a href="https://github.com/ocaml/ocaml/pull/8569">#8569</a>:
On ARM64, use 32-bit loads to access <code>caml_backtrace_active</code>.
(Xavier Leroy, review by Mark Shinwell and Greta Yorsh)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/8568">#8568</a>:
Fix a memory leak in mmapped bigarrays.
(Damien Doligez, review by Xavier Leroy and Jérémie Dimino)</p>
</li>
</ul>
<h3>Tools</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2182">#2182</a>:
Split Emacs caml-mode as an independent project.
(Christophe Troestler, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1865">#1865</a>:
Support dark themes in Emacs, and clean up usage of
deprecated Emacs APIs.
(Wilfred Hughes, review by Clément Pit-Claudel)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1590">#1590</a>:
ocamllex-generated lexers can be instructed not to update
their <code>lex_curr_p</code>/<code>lex_start_p</code> fields, resulting in a significant
performance gain when those fields are not required.
(Alain Frisch, review by Jérémie Dimino)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7843">#7843</a>,
<a href="https://github.com/ocaml/ocaml/pull/2013">#2013</a>:
ocamldoc, better handling of <code>((! echo {{!label}text} !))</code> in the latex
backend.
(Florian Angeletti, review by Nicolás Ojeda Bär and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7844">#7844</a>,
<a href="https://github.com/ocaml/ocaml/pull/2040">#2040</a>:
Emacs, use built-in detection of comments,
fixes an imenu crash.
(Wilfred Hughes, review by Christophe Troestler)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7850">#7850</a>:
Emacs, use symbol boundaries in regular expressions,
fixes an imenu crash.
(Wilfred Hughes, review by Christophe Troestler)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1711">#1711</a>:
the new <code>open</code> flag in <code>OCAMLRUNPARAM</code> takes a comma-separated list of
modules to open as if they had been passed via the command line <code>-open</code> flag.
(Nicolás Ojeda Bär, review by Mark Shinwell)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2000">#2000</a>:
<code>ocamdoc</code>, extended support for <code>include module type of ...</code>
(Florian Angeletti, review by Jérémie Dimino)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2045">#2045</a>:
<code>ocamlmklib</code> now supports options <code>-args</code> and <code>-args0</code> to provide extra
command-line arguments in a file.
(Nicolás Ojeda Bär, review by Gabriel Scherer and Daniel Bünzli)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2189">#2189</a>:
change ocamldep Makefile-output to print each dependency
on a new line, for more readable diffs of versioned dependencies.
(Gabriel Scherer, review by Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2223">#2223</a>:
ocamltest: fix the &quot;bsd&quot; and &quot;not-bsd&quot; built-in actions to
recognize all BSD variants.
(Damien Doligez, review by Sébastien Hinderer and David Allsopp)</p>
</li>
</ul>
<h3>Compiler distribution build system:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1776">#1776</a>:
add <code>-no-install-bytecode-programs</code> and related configure options to
control (non-)installation of <code>.byte</code> executables.
(Mark Shinwell, review by Sébastien Hinderer and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1777">#1777</a>:
add <code>-no-install-source-artifacts</code> and related configure options to
control installation of <code>.cmt</code>, <code>.cmti</code>, <code>.mli</code> and <code>.ml</code> files.
(Mark Shinwell, review by Nicolás Ojeda Bär and Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1781">#1781</a>:
cleanup of the manual's build process.
(steinuil, review by Marcello Seri, Gabriel Scherer and Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1797">#1797</a>:
remove the deprecated <code>Makefile.nt</code> files.
(Sébastien Hinderer, review by Nicolas Ojeda Bar)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1805">#1805</a>:
fix the bootstrap procedure and its documentation.
(Sébastien Hinderer, Xavier Leroy and Damien Doligez; review by
Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1840">#1840</a>:
build system enhancements.
(Sébastien Hinderer, review by David Allsopp, Xavier Leroy and
Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1852">#1852</a>:
merge runtime directories.
(Sébastien Hinderer, review by Xavier Leroy and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1854">#1854</a>:
remove the no longer defined <code>BYTECCCOMPOPTS</code> build variable.
(Sébastien Hinderer, review by Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2024">#2024</a>:
stop supporting obsolete platforms: Rhapsody (old beta
version of MacOS X, BeOS, alpha*-*-linux*, mips-*-irix6*,
alpha*-*-unicos, powerpc-*-aix, *-*-solaris2*, mips*-*-irix[56]*,
i[3456]86-*-darwin[89].*, i[3456]86-*-solaris*, *-*-sunos*
*- *-unicos.
(Sébastien Hinderer, review by Xavier Leroy, Damien Doligez, Gabriel
Scherer and Armaël Guéneau)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2053">#2053</a>:
allow unix, vmthreads and str not to be built.
(David Allsopp, review by Sébastien Hinderer)</p>
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2059">#2059</a>:
stop defining <code>OCAML_STDLIB_DIR</code> in <code>s.h</code>.
(Sébastien Hinderer, review by David Allsopp and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2066">#2066</a>:
remove the <code>standard_runtime</code> configuration variable.
(Sébastien Hinderer, review by Xavier Leroy, Stephen Dolan and
Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2139">#2139</a>:
use autoconf to generate the compiler's configuration script.
(Sébastien Hinderer, review by Damien Doligez and David Allsopp)</p>
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2148">#2148</a>:
fix a parallel build bug involving <code>CamlinternalLazy</code>.
(Stephen Dolan, review by Gabriel Scherer and Nicolas Ojeda Bar)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2264">#2264</a>,
<a href="https://github.com/ocaml/ocaml/pull/7904">#7904</a>:
the configure script now sets the Unicode handling mode under
Windows according to the value of the variable
<code>WINDOWS_UNICODE_MODE</code>.  If <code>WINDOWS_UNICODE_MODE</code> is <code>ansi</code> then it
is assumed to be the current code page encoding.  If
<code>WINDOWS_UNICODE_MODE</code> is <code>compatible</code> or empty or not set at all,
then encoding is UTF-8 with code page fallback.
(Nicolás Ojeda Bär, review by Sébastien Hinderer and David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2266">#2266</a>:
ensure Cygwin ports configure with <code>EXE=.exe</code>, or the compiler is
unable to find the camlheader files (subtle regression of #2139/2041)
(David Allsopp, report and review by Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7919">#7919</a>,
<a href="https://github.com/ocaml/ocaml/pull/2311">#2311</a>:
Fix assembler detection in configure.
(Sébastien Hinderer, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2295">#2295</a>:
Restore support for bytecode target XLC/AIX/Power.
(Konstantin Romanov, review by Sébastien Hinderer and David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/8528">#8528</a>:
get rid of the direct call to the C preprocessor in the testsuite.
(Sébastien Hinderer, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7938">#7938</a>,
<a href="https://github.com/ocaml/ocaml/pull/8532">#8532</a>:
Fix alignment detection for ints on 32-bits platforms.
(Sébastien Hinderer, review by Xavier Leroy)</p>
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/8533">#8533</a>:
Remove some unused configure tests.
(Stephen Dolan, review by David Allsopp and Sébastien Hinderer)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2207">#2207</a>,
<a href="https://github.com/ocaml/ocaml/pull/8604">#8604</a>:
Add opam files to allow pinning.
(Leo White, Greta Yorsh, review by Gabriel Radanne)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/8616">#8616</a>:
configure: use variables rather than arguments for a few options.
(Sébastien Hinderer, review by David Allsopp, Gabriel Scherer and
Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/8632">#8632</a>:
Correctly propagate flags for <code>--with-pic</code> in configure.
(David Allsopp, review by Sébastien Hinderer and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/8673">#8673</a>:
restore SpaceTime and libunwind support in configure script.
(Sébastien Hinderer, review by Damien Doligez)</p>
</li>
</ul>
<h3>Internal/compiler-libs changes:</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7918">#7918</a>,
<a href="https://github.com/ocaml/ocaml/pull/1703">#1703</a>,
<a href="https://github.com/ocaml/ocaml/pull/1944">#1944</a>,
<a href="https://github.com/ocaml/ocaml/pull/2213">#2213</a>,
<a href="https://github.com/ocaml/ocaml/pull/2257">#2257</a>:
Add the module
<code>Compile_common</code>, which factorizes the common part in <code>Compile</code> and
<code>Optcompile</code>.  This also makes the pipeline more modular.
(Gabriel Radanne, help from Gabriel Scherer and Valentin
Gatien-Baron, review by Mark Shinwell and Gabriel Radanne,
regression spotted by Clément Franchini)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/292">#292</a>:
use Menhir as the parser generator for the OCaml parser.
Satellite GPRs: <a href="https://github.com/ocaml/ocaml/pull/1844">#1844</a>,
<a href="https://github.com/ocaml/ocaml/pull/1846">#1846</a>,
<a href="https://github.com/ocaml/ocaml/pull/1853">#1853</a>,
<a href="https://github.com/ocaml/ocaml/pull/1850">#1850</a>,
<a href="https://github.com/ocaml/ocaml/pull/1934">#1934</a>,
<a href="https://github.com/ocaml/ocaml/pull/2151">#2151</a>,
<a href="https://github.com/ocaml/ocaml/pull/2174">#2174</a>
(Gabriel Scherer, Nicolás Ojeda Bär, Frédéric Bour, Thomas Refis
and François Pottier,
review by Nicolás Ojeda Bär, Leo White and David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/374">#374</a>:
use <code>Misc.try_finally</code> for resource cleanup in the compiler
codebase. This should fix the problem of catch-and-reraise <code>try .. with</code>
blocks destroying backtrace information — in the compiler.
(François Bobot, help from Gabriel Scherer and Nicolás Ojeda Bär,
review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1148">#1148</a>,
<a href="https://github.com/ocaml/ocaml/pull/1287">#1287</a>,
<a href="https://github.com/ocaml/ocaml/pull/1288">#1288</a>,
<a href="https://github.com/ocaml/ocaml/pull/1874">#1874</a>:
significant improvements
of the tools/check-typo script used over the files of the whole repository;
contributors are now expected to check that check-typo passes on their
pull requests; see <code>CONTRIBUTING.md</code> for more details.
(David Allsopp, review by Damien Doligez and Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1610">#1610</a>,
<a href="https://github.com/ocaml/ocaml/pull/2252">#2252</a>:
Remove positions from paths.
(Leo White, review by Frédéric Bour and Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1745">#1745</a>:
do not generalize the type of every sub-pattern,
only of variables (preliminary work for GADTs in or-patterns).
(Thomas Refis, review by Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1909">#1909</a>:
unsharing pattern types (preliminary work for GADTs in or-patterns).
(Thomas Refis, with help from Leo White, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1748">#1748</a>:
do not error when instantiating polymorphic fields in patterns.
(Thomas Refis, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2317">#2317</a>:
type_let: be more careful generalizing parts of the pattern.
(Thomas Refis and Leo White, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1746">#1746</a>:
remove unreachable error variant: <code>Make_seltype_nongen</code>.
(Florian Angeletti, review by Gabriel Radanne)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1747">#1747</a>:
type_cases: always propagate (preliminary work
for GADTs in or-patterns).
(Thomas Refis, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1811">#1811</a>:
shadow the polymorphic comparison in the middle-end.
(Xavier Clerc, review by Pierre Chambart)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1833">#1833</a>:
allow non-val payloads in CMM Ccatch handlers.
(Simon Fowler, review by Xavier Clerc)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1866">#1866</a>:
document the release process.
(Damien Doligez and Gabriel Scherer, review by Sébastien Hinderer,
Perry E. Metzger, Xavier Leroy and David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1886">#1886</a>:
move the <code>Location.absname</code> reference to <code>Clflags.absname</code>.
(Armaël Guéneau, review by Jérémie Dimino)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1894">#1894</a>:
generalize <code>highlight_dumb</code> in <code>location.ml</code> to handle highlighting
several locations.
(Armaël Guéneau, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1903">#1903</a>:
parsetree, add locations to all nodes with attributes.
(Gabriel Scherer, review by Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1905">#1905</a>:
add check-typo-since to check the files changed
since a given git reference.
(Gabriel Scherer, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1910">#1910</a>:
improve the check-typo use of <code>.gitattributes</code>.
(Gabriel Scherer, review by David Allsopp and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1938">#1938</a>:
always check ast invariants after preprocessing.
(Florian Angeletti, review by Alain Frisch and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1941">#1941</a>:
refactor the command line parsing of ocamlcp and ocamloptp.
(Valentin Gatien-Baron, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1948">#1948</a>:
Refactor <code>Stdlib.Format</code>. Notably, use <code>Stdlib.Stack</code> and <code>Stdlib.Queue</code>,
and avoid exceptions for control flow.
(Vladimir Keleshev, review by Nicolás Ojeda Bär and Gabriel Scherer)</p>
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/1952">#1952</a>:
refactor the code responsible for displaying errors and warnings
<code>Location.report_error</code> is removed, use <code>Location.print_report</code> instead.
(Armaël Guéneau, review by Thomas Refis)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7835">#7835</a>,
<a href="https://github.com/ocaml/ocaml/pull/1980">#1980</a>,
<a href="https://github.com/ocaml/ocaml/pull/8548">#8548</a>,
<a href="https://github.com/ocaml/ocaml/pull/8586">#8586</a>:
separate scope from stamp in idents and explicitly
rescope idents when substituting signatures.
(Thomas Refis, review by Jacques Garrigue and Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1996">#1996</a>:
expose <code>Pprintast.longident</code> to help compiler-libs users print
<code>Longident.t</code> values.
(Gabriel Scherer, review by Florian Angeletti and Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2030">#2030</a>:
makefile targets to build AST files of sources
for parser testing.  See <code>parsing/HACKING.adoc</code>.
(Gabriel Scherer, review by Nicolás Ojeda Bär)</p>
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/2041">#2041</a>:
add a cache for looking up files in the load path.
(Jérémie Dimino, review by Alain Frisch and David Allsopp)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2047">#2047</a>,
<a href="https://github.com/ocaml/ocaml/pull/2269">#2269</a>:
a new type for unification traces.
(Florian Angeletti, report by Leo White (#2269),
review by Thomas Refis and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2055">#2055</a>:
Add <code>Linearize.Lprologue</code>.
(Mark Shinwell, review by Pierre Chambart)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2056">#2056</a>:
Use <code>Backend_var</code> rather than <code>Ident</code> from <code>Clambda</code> onwards;
use <code>Backend_var.With_provenance</code> for variables in binding position.
(Mark Shinwell, review by Pierre Chambart)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2060">#2060</a>:
&quot;Phantom let&quot; support for the Clambda language.
(Mark Shinwell, review by Vincent Laviron)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2065">#2065</a>:
Add <code>Proc.destroyed_at_reloadretaddr</code>.
(Mark Shinwell, review by Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2070">#2070</a>:
&quot;Phantom let&quot; support for the Cmm language.
(Mark Shinwell, review by Vincent Laviron)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2072">#2072</a>:
Always associate a scope to a type.
(Thomas Refis, review by Jacques Garrigue and Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2074">#2074</a>:
Correct naming of record field inside <code>Ialloc</code> terms.
(Mark Shinwell, review by Jérémie Dimino)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2076">#2076</a>:
Add <code>Targetint.print</code>.
(Mark Shinwell)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2080">#2080</a>:
Add <code>Proc.dwarf_register_numbers</code> and
<code>Proc.stack_ptr_dwarf_register_number</code>.
(Mark Shinwell, review by Bernhard Schommer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2088">#2088</a>:
Add <code>Clambda.usymbol_provenance</code>.
(Mark Shinwell, review by Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2152">#2152</a>,
<a href="https://github.com/ocaml/ocaml/pull/2517">#2517</a>:
refactorize the fixpoint to compute type-system
properties of mutually-recursive type declarations.
(Gabriel Scherer and Rodolphe Lepigre, review by Armaël Guéneau)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2156">#2156</a>:
propagate more type information through Lambda and Clambda
intermediate language, as a preparation step for more future optimizations.
(Pierre Chambart and Alain Frisch, cross-reviewed by themselves)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2160">#2160</a>:
restore <code>--disable-shared</code> support and ensure testsuite runs correctly
when compiled without shared library support.
(David Allsopp, review by Damien Doligez and Sébastien Hinderer)</p>
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/2173">#2173</a>:
removed <code>TypedtreeMap</code>.
(Thomas Refis, review by Gabriel Scherer)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7867">#7867</a>:
Fix <code>#mod_use</code> raising an exception for filenames with no
extension.
(Geoff Gole)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2100">#2100</a>:
Fix <code>Unix.getaddrinfo</code> when called on strings containing
null bytes; it would crash the GC later on.
(Armaël Guéneau, report and fix by Joe, review by Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7847">#7847</a>,
<a href="https://github.com/ocaml/ocaml/pull/2019">#2019</a>:
Fix an infinite loop that could occur when the
(Menhir-generated) parser encountered a syntax error in a certain
specific state.
(François Pottier, report by Stefan Muenzel,
review by Frédéric Bour, Thomas Refis, Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1626">#1626</a>:
Do not allow recursive modules in <code>with module</code>.
(Leo White, review by Gabriel Radanne)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7726">#7726</a>,
<a href="https://github.com/ocaml/ocaml/pull/1676">#1676</a>:
Recursive modules, equi-recursive types and stack overflow.
(Jacques Garrigue, report by Jeremy Yallop, review by Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7723">#7723</a>,
<a href="https://github.com/ocaml/ocaml/pull/1698">#1698</a>:
Ensure <code>with module</code> and <code>with type</code> do not weaken
module aliases.
(Leo White, review by Gabriel Radanne and Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1719">#1719</a>:
fix <code>Pervasives.LargeFile</code> functions under Windows.
(Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1739">#1739</a>:
ensure ocamltest waits for child processes to terminate on Windows.
(David Allsopp, review by Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7554">#7554</a>,
<a href="https://github.com/ocaml/ocaml/pull/1751">#1751</a>:
<code>Lambda.subst</code>: also update debug event environments
(Thomas Refis, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7238">#7238</a>,
<a href="https://github.com/ocaml/ocaml/pull/1825">#1825</a>:
in <code>Unix.in_channel_of_descr</code> and <code>Unix.out_channel_of_descr</code>,
raise an error if the given file description is not suitable for
character-oriented I/O, for example if it is a block device or a
datagram socket.
(Xavier Leroy, review by Jérémie Dimino and Perry E. Metzger)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7799">#7799</a>,
<a href="https://github.com/ocaml/ocaml/pull/1820">#1820</a>:
fix bug where <code>Scanf.format_from_string</code> could fail when
the argument string contained characters that require escaping.
(Gabriel Scherer and Nicolás Ojeda Bär, report by Guillaume Melquiond, review
by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1843">#1843</a>:
ocamloptp was doing the wrong thing with option <code>-inline-max-unroll</code>.
(Github user @poechsel, review by Nicolás Ojeda Bär).</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1890">#1890</a>:
remove last use of <code>Ctype.unroll_abbrev</code>.
(Thomas Refis, report by Leo White, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1893">#1893</a>:
dev-branch only, warning 40 (name not in scope) triggered spurious
warnings 49 (missing cmi) with <code>-no-alias-deps</code>.
(Florian Angeletti, report by Valentin Gatien-Baron,
review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1912">#1912</a>:
Allow quoted strings, octal/unicode escape sequences and identifiers
containing apostrophes in ocamllex actions and comments.
(Pieter Goetschalckx, review by Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7828">#7828</a>,
<a href="https://github.com/ocaml/ocaml/pull/1935">#1935</a>:
correct the conditions that generate warning 61,
<code>Unboxable_type_in_prim_decl</code>.
(Stefan Muenzel)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1958">#1958</a>:
allow <code>module M(_:S) = struct end</code> syntax.
(Hugo Heuzard, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1970">#1970</a>:
fix order of floatting documentation comments in classes.
(Hugo Heuzard, review by Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1977">#1977</a>:
<code>[@@ocaml.warning &quot;...&quot;]</code> attributes attached to type declarations are
no longer ignored.
(Nicolás Ojeda Bär, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7830">#7830</a>,
<a href="https://github.com/ocaml/ocaml/pull/1987">#1987</a>:
fix ocamldebug crash when printing a value in the scope of
an <code>open</code> statement for which the <code>.cmi</code> is not available.
(Nicolás Ojeda Bär, report by Jocelyn Sérot, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7854">#7854</a>,
<a href="https://github.com/ocaml/ocaml/pull/2062">#2062</a>:
fix an issue where the wrong locale may be used when using
the legacy ANSI encoding under Windows.
(Nicolás Ojeda Bär, report by Tiphaine Turpin)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2083">#2083</a>:
Fix excessively aggressive float unboxing and introduce similar fix
as a preventative measure for boxed int unboxing.
(Thomas Refis, Mark Shinwell, Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2130">#2130</a>:
fix printing of type variables with a quote in their name.
(Alain Frisch, review by Armaël Guéneau and Gabriel Scherer,
report by Hugo Heuzard)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2131">#2131</a>:
fix wrong calls to <code>Env.normalize_path</code> on non-module paths.
(Alain Frisch, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2175">#2175</a>:
Apply substitution to all modules when packing.
(Leo White, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2220">#2220</a>:
Remove duplicate process management code in
<code>otherlibs/threads/unix.ml</code>.
(Romain Beauxis, review by Gabriel Scherer and Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/2231">#2231</a>:
<code>Env</code>: always freshen persistent signatures before using them.
(Thomas Refis and Leo White, review by Gabriel Radanne)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7851">#7851</a>,
<a href="https://github.com/ocaml/ocaml/pull/8570">#8570</a>:
Module type of allows to transform a malformed
module type into a vicious signature, breaking soundness.
(Jacques Garrigue, review by Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7923">#7923</a>,
<a href="https://github.com/ocaml/ocaml/pull/2259">#2259</a>:
fix regression in FlexDLL bootstrapped build caused by
refactoring the root Makefile for Dune in #2093.
(David Allsopp, report by Marc Lasson)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/7929">#7929</a>,
<a href="https://github.com/ocaml/ocaml/pull/2261">#2261</a>:
<code>Subst.signature</code>: call cleanup_types exactly once.
(Thomas Refis, review by Gabriel Scherer and Jacques Garrigue,
report by Daniel Bünzli and Jon Ludlam)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/8550">#8550</a>,
<a href="https://github.com/ocaml/ocaml/pull/8552">#8552</a>:
Soundness issue with class generalization.
(Jacques Garrigue, review by Leo White and Thomas Refis,
report by Jeremy Yallop)</p>
</li>
</ul>
|js}
  };
 
  { kind = `Compiler
  ; version = {js|4.07.1|js}
  ; date = {js|2018-10-04|js}
  ; intro_md = {js|This page describes OCaml version **4.07.1**, released on 2018-10-04. 
|js}
  ; intro_html = {js|<p>This page describes OCaml version <strong>4.07.1</strong>, released on 2018-10-04.</p>
|js}
  ; highlights_md = {js|- Bug fixes for 4.07.0
|js}
  ; highlights_html = {js|<ul>
<li>Bug fixes for 4.07.0
</li>
</ul>
|js}
  ; body_md = {js|
Opam Switches
-------------

This release is available as multiple
[OPAM](https://opam.ocaml.org/doc/Usage.html) switches:

- 4.07.1 — Official 4.07.1 release
- 4.07.1+32bit - Official 4.07.1 release compiled in 32-bit mode
- 4.07.1+afl — Official 4.07.1 release with afl-fuzz instrumentation
- 4.07.1+default-unsafe-string — Official 4.07.1 release without safe
  strings by default
- 4.07.1+flambda — Official 4.07.1 release with flambda activated
- 4.07.1+flambda+no-flat-float-arrays — Official 4.07.1 release with flambda
  activated and flat float arrays disabled
- 4.07.1+force-safe-string — Official 4.07.1 release with -safe-string enabled
- 4.07.1+fp — Official 4.07.1 release with frame-pointers
- 4.07.1+fp+flambda — Official 4.07.1 release with frame-pointers and
  flambda activated

What's new
----------

This is a bug-fix release, please consult the
[changelog](#Changes).


Source distribution
---------------------------------------------

- [Source
  tarball](https://github.com/ocaml/ocaml/archive/4.07.1.tar.gz)
  (.tar.gz) for compilation under Unix (including Linux and MacOS X)
  and Microsoft Windows (including Cygwin).
- Also available in
  [.zip](https://github.com/ocaml/ocaml/archive/4.07.1.zip)
  format.
- [OPAM](https://opam.ocaml.org/) is a source-based distribution of
  OCaml and many companion libraries and tools. Compilation and
  installation are automated by powerful package managers.
- The official development repo is hosted on
  [GitHub](https://github.com/ocaml/ocaml).

The
[INSTALL](4.07/notes/INSTALL.adoc) file
of the distribution provides detailed compilation and installation
instructions -- see also the [Windows release
notes](4.07/notes/README.win32.adoc) for
instructions on how to build under Windows.

Alternative Compilers
---------------------

Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:

* [Js_of_ocaml](http://ocsigen.org/js_of_ocaml/) is a stable OCaml
  to JavaScript compiler.
* [Bucklescript](https://bucklescript.github.io/) is a
  newer OCaml to JavaScript compiler.  See the
  [comparison to Js_of_ocaml](https://bucklescript.github.io/docs/en/comparison-to-jsoo).
  Bucklescript may take some time to be compatible with the latest
  release of OCaml.
* [OCaml-java](http://www.ocamljava.org/) is a stable OCaml to
  Java compiler.

User's manual
------------------------------------

The user's manual for OCaml can be:

- [browsed
  online](4.07/htmlman/index.html),
- downloaded as a single
  [PostScript](4.07/ocaml-4.07-refman.ps.gz),
  [PDF](4.07/ocaml-4.07-refman.pdf),
  or [plain
  text](4.07/ocaml-4.07-refman.txt)
  document,
- downloaded as a single
  [TAR](4.07/ocaml-4.07-refman-html.tar.gz)
  or
  [ZIP](4.07/ocaml-4.07-refman-html.zip)
  archive of HTML files,
- downloaded as a single
  [tarball](4.07/ocaml-4.07-refman.info.tar.gz)
  of Emacs info files,


Changes
-------

This is the
[changelog](4.07/notes/Changes).

(Changes that can break existing programs are marked with a "*")

### Bug fixes:

- [MPR#7815](https://caml.inria.fr/mantis/view.php?id=7815),
  [GPR#1896](https://github.com/ocaml/ocaml/pull/1896):
  major GC crash with first-fit policy
  (Stephen Dolan and Damien Doligez, report by Joris Giovannangeli)

* [MPR#7818](https://caml.inria.fr/mantis/view.php?id=7818),
  [GPR#2051](https://github.com/ocaml/ocaml/pull/2051):
  Remove local aliases in functor argument types,
  to prevent the aliasing of their target.
  (Jacques Garrigue, report by mandrykin, review by Leo White)

- [MPR#7820](https://caml.inria.fr/mantis/view.php?id=7820),
  [GPR#1897](https://github.com/ocaml/ocaml/pull/1897):
  Fix Array.of_seq. This function used to apply a circular
  permutation of one cell to the right on the sequence.
  (Thierry Martinez, review by Nicolás Ojeda Bär)

- [MPR#7821](https://caml.inria.fr/mantis/view.php?id=7821),
  [GPR#1908](https://github.com/ocaml/ocaml/pull/1908):
  make sure that the compilation of extension
  constructors doesn't cause the compiler to load more cmi files
  (Jérémie Dimino)

- [MPR#7824](https://caml.inria.fr/mantis/view.php?id=7824),
  [GPR#1914](https://github.com/ocaml/ocaml/pull/1914):
  subtype_row: filter out absent fields when row is closed
  (Leo White and Thomas Refis, report by talex, review by Jacques Garrigue)

- [GPR#1915](https://github.com/ocaml/ocaml/pull/1915):
  rec_check.ml is too permissive for certain class declarations.
  (Alban Reynaud with Gabriel Scherer, review by Jeremy Yallop)

- [MPR#7833](https://caml.inria.fr/mantis/view.php?id=7833),
  [MPR#7835](https://caml.inria.fr/mantis/view.php?id=7835),
  [MPR#7822](https://caml.inria.fr/mantis/view.php?id=7822),
  [GPR#1997](https://github.com/ocaml/ocaml/pull/1997):
  Track newtype level again
  (Leo White, reports by Jerome Simeon, Thomas Refis and Florian
  Angeletti, review by Jacques Garrigue)

- [MPR#7838](https://caml.inria.fr/mantis/view.php?id=7838):
  -principal causes assertion failure in type checker
  (Jacques Garrigue, report by Markus Mottl, review by Thomas Refis)
|js}
  ; body_html = {js|<h2>Opam Switches</h2>
<p>This release is available as multiple
<a href="https://opam.ocaml.org/doc/Usage.html">OPAM</a> switches:</p>
<ul>
<li>4.07.1 — Official 4.07.1 release
</li>
<li>4.07.1+32bit - Official 4.07.1 release compiled in 32-bit mode
</li>
<li>4.07.1+afl — Official 4.07.1 release with afl-fuzz instrumentation
</li>
<li>4.07.1+default-unsafe-string — Official 4.07.1 release without safe
strings by default
</li>
<li>4.07.1+flambda — Official 4.07.1 release with flambda activated
</li>
<li>4.07.1+flambda+no-flat-float-arrays — Official 4.07.1 release with flambda
activated and flat float arrays disabled
</li>
<li>4.07.1+force-safe-string — Official 4.07.1 release with -safe-string enabled
</li>
<li>4.07.1+fp — Official 4.07.1 release with frame-pointers
</li>
<li>4.07.1+fp+flambda — Official 4.07.1 release with frame-pointers and
flambda activated
</li>
</ul>
<h2>What's new</h2>
<p>This is a bug-fix release, please consult the
<a href="#Changes">changelog</a>.</p>
<h2>Source distribution</h2>
<ul>
<li><a href="https://github.com/ocaml/ocaml/archive/4.07.1.tar.gz">Source
tarball</a>
(.tar.gz) for compilation under Unix (including Linux and MacOS X)
and Microsoft Windows (including Cygwin).
</li>
<li>Also available in
<a href="https://github.com/ocaml/ocaml/archive/4.07.1.zip">.zip</a>
format.
</li>
<li><a href="https://opam.ocaml.org/">OPAM</a> is a source-based distribution of
OCaml and many companion libraries and tools. Compilation and
installation are automated by powerful package managers.
</li>
<li>The official development repo is hosted on
<a href="https://github.com/ocaml/ocaml">GitHub</a>.
</li>
</ul>
<p>The
<a href="4.07/notes/INSTALL.adoc">INSTALL</a> file
of the distribution provides detailed compilation and installation
instructions -- see also the <a href="4.07/notes/README.win32.adoc">Windows release
notes</a> for
instructions on how to build under Windows.</p>
<h2>Alternative Compilers</h2>
<p>Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:</p>
<ul>
<li><a href="http://ocsigen.org/js_of_ocaml/">Js_of_ocaml</a> is a stable OCaml
to JavaScript compiler.
</li>
<li><a href="https://bucklescript.github.io/">Bucklescript</a> is a
newer OCaml to JavaScript compiler.  See the
<a href="https://bucklescript.github.io/docs/en/comparison-to-jsoo">comparison to Js_of_ocaml</a>.
Bucklescript may take some time to be compatible with the latest
release of OCaml.
</li>
<li><a href="http://www.ocamljava.org/">OCaml-java</a> is a stable OCaml to
Java compiler.
</li>
</ul>
<h2>User's manual</h2>
<p>The user's manual for OCaml can be:</p>
<ul>
<li><a href="4.07/htmlman/index.html">browsed
online</a>,
</li>
<li>downloaded as a single
<a href="4.07/ocaml-4.07-refman.ps.gz">PostScript</a>,
<a href="4.07/ocaml-4.07-refman.pdf">PDF</a>,
or <a href="4.07/ocaml-4.07-refman.txt">plain
text</a>
document,
</li>
<li>downloaded as a single
<a href="4.07/ocaml-4.07-refman-html.tar.gz">TAR</a>
or
<a href="4.07/ocaml-4.07-refman-html.zip">ZIP</a>
archive of HTML files,
</li>
<li>downloaded as a single
<a href="4.07/ocaml-4.07-refman.info.tar.gz">tarball</a>
of Emacs info files,
</li>
</ul>
<h2>Changes</h2>
<p>This is the
<a href="4.07/notes/Changes">changelog</a>.</p>
<p>(Changes that can break existing programs are marked with a &quot;*&quot;)</p>
<h3>Bug fixes:</h3>
<ul>
<li><a href="https://caml.inria.fr/mantis/view.php?id=7815">MPR#7815</a>,
<a href="https://github.com/ocaml/ocaml/pull/1896">GPR#1896</a>:
major GC crash with first-fit policy
(Stephen Dolan and Damien Doligez, report by Joris Giovannangeli)
</li>
</ul>
<ul>
<li><a href="https://caml.inria.fr/mantis/view.php?id=7818">MPR#7818</a>,
<a href="https://github.com/ocaml/ocaml/pull/2051">GPR#2051</a>:
Remove local aliases in functor argument types,
to prevent the aliasing of their target.
(Jacques Garrigue, report by mandrykin, review by Leo White)
</li>
</ul>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7820">MPR#7820</a>,
<a href="https://github.com/ocaml/ocaml/pull/1897">GPR#1897</a>:
Fix Array.of_seq. This function used to apply a circular
permutation of one cell to the right on the sequence.
(Thierry Martinez, review by Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7821">MPR#7821</a>,
<a href="https://github.com/ocaml/ocaml/pull/1908">GPR#1908</a>:
make sure that the compilation of extension
constructors doesn't cause the compiler to load more cmi files
(Jérémie Dimino)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7824">MPR#7824</a>,
<a href="https://github.com/ocaml/ocaml/pull/1914">GPR#1914</a>:
subtype_row: filter out absent fields when row is closed
(Leo White and Thomas Refis, report by talex, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1915">GPR#1915</a>:
rec_check.ml is too permissive for certain class declarations.
(Alban Reynaud with Gabriel Scherer, review by Jeremy Yallop)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7833">MPR#7833</a>,
<a href="https://caml.inria.fr/mantis/view.php?id=7835">MPR#7835</a>,
<a href="https://caml.inria.fr/mantis/view.php?id=7822">MPR#7822</a>,
<a href="https://github.com/ocaml/ocaml/pull/1997">GPR#1997</a>:
Track newtype level again
(Leo White, reports by Jerome Simeon, Thomas Refis and Florian
Angeletti, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7838">MPR#7838</a>:
-principal causes assertion failure in type checker
(Jacques Garrigue, report by Markus Mottl, review by Thomas Refis)</p>
</li>
</ul>
|js}
  };
 
  { kind = `Compiler
  ; version = {js|4.07.0|js}
  ; date = {js|2018-07-10|js}
  ; intro_md = {js|This page describes OCaml version **4.07.0**, released on 2018-07-10. 
|js}
  ; intro_html = {js|<p>This page describes OCaml version <strong>4.07.0</strong>, released on 2018-07-10.</p>
|js}
  ; highlights_md = {js|- The standard library is now packed into a module called `Stdlib`, which is
  open by default. This makes it easier to add new modules to the standard
  library without clashing with user-defined modules.
- The `Bigarray` module is now part of the standard library. - The modules `Seq`, `Float` were added to the standard library. - Improvements to several error and warning messages printed by the
  compiler make them much easier to understand.
- Many improvements to flambda. - Removed the dependency on curses/terminfo/termcap. - The SpaceTime profiler now works under Windows.
|js}
  ; highlights_html = {js|<ul>
<li>The standard library is now packed into a module called <code>Stdlib</code>, which is
open by default. This makes it easier to add new modules to the standard
library without clashing with user-defined modules.
</li>
<li>The <code>Bigarray</code> module is now part of the standard library. - The modules <code>Seq</code>, <code>Float</code> were added to the standard library. - Improvements to several error and warning messages printed by the
compiler make them much easier to understand.
</li>
<li>Many improvements to flambda. - Removed the dependency on curses/terminfo/termcap. - The SpaceTime profiler now works under Windows.
</li>
</ul>
|js}
  ; body_md = {js|
Opam Switches
-------------

This release is available as multiple
[OPAM](https://opam.ocaml.org/doc/Usage.html) switches:

- 4.07.0 — Official 4.07.0 release
- 4.07.0+afl — Official 4.07.0 release with afl-fuzz instrumentation
- 4.07.0+default-unsafe-string — Official 4.07.0 release without safe
  strings by default
- 4.07.0+flambda — Official 4.07.0 release with flambda activated
- 4.07.0+force-safe-string — Official 4.07.0 release with -safe-string enabled.
- 4.07.0+fp — Official 4.07.0 release with frame-pointers
- 4.07.0+fp+flambda — Official 4.07.0 release with frame-pointers and
  flambda activated

What's new
----------

Some of the highlights in release 4.07 are:

- The standard library is now packed into a module called `Stdlib`, which is
  open by default. This makes it easier to add new modules to the standard
  library without clashing with user-defined modules.

- The `Bigarray` module is now part of the standard library.

- The modules `Seq`, `Float` were added to the standard library.

- Improvements to several error and warning messages printed by the
  compiler make them much easier to understand.

- Many improvements to flambda.

- Removed the dependency on curses/terminfo/termcap.

- The SpaceTime profiler now works under Windows.


For a comprehensive list of changes and details on all new features,
bug fixes, optimizations, etc., please consult the
[changelog](#Changes).


Source distribution
---------------------------------------------

- [Source
  tarball](https://github.com/ocaml/ocaml/archive/4.07.0.tar.gz)
  (.tar.gz) for compilation under Unix (including Linux and MacOS X)
  and Microsoft Windows (including Cygwin).
- Also available in
  [.zip](https://github.com/ocaml/ocaml/archive/4.07.0.zip)
  format.
- [OPAM](https://opam.ocaml.org/) is a source-based distribution of
  OCaml and many companion libraries and tools. Compilation and
  installation are automated by powerful package managers.
- The official development repo is hosted on
  [GitHub](https://github.com/ocaml/ocaml).

The
[INSTALL](4.07/notes/INSTALL.adoc) file
of the distribution provides detailed compilation and installation
instructions -- see also the [Windows release
notes](4.07/notes/README.win32.adoc) for
instructions on how to build under Windows.

Alternative Compilers
---------------------

Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:

* [Js_of_ocaml](http://ocsigen.org/js_of_ocaml/) is a stable OCaml
  to JavaScript compiler.
* [Bucklescript](http://bucklescript.github.io/bucklescript/) is a
  newer OCaml to JavaScript compiler. See its
  [wiki](https://github.com/bucklescript/bucklescript/wiki/Differences-from-js_of_ocaml) for
  an explanation of how it differs from js_of_ocaml.
* [OCaml-java](http://www.ocamljava.org/) is a stable OCaml to
  Java compiler.

User's manual
------------------------------------

The user's manual for OCaml can be:

- [browsed
  online](4.07/htmlman/index.html),
- downloaded as a single
  [PostScript](4.07/ocaml-4.07-refman.ps.gz),
  [PDF](4.07/ocaml-4.07-refman.pdf),
  or [plain
  text](4.07/ocaml-4.07-refman.txt)
  document,
- downloaded as a single
  [TAR](4.07/ocaml-4.07-refman-html.tar.gz)
  or
  [ZIP](4.07/ocaml-4.07-refman-html.zip)
  archive of HTML files,
- downloaded as a single
  [tarball](4.07/ocaml-4.07-refman.info.tar.gz)
  of Emacs info files,


Changes
-------

This is the
[changelog](4.07/notes/Changes).

(Changes that can break existing programs are marked with a "*")

### Language features:

- [MPR#6023](https://caml.inria.fr/mantis/view.php?id=6023),
  [GPR#1648](https://github.com/ocaml/ocaml/pull/1648):
  Allow type-based selection of GADT constructors
  (Thomas Refis and Leo White, review by Jacques Garrigue and Gabriel Scherer)

- [GPR#1546](https://github.com/ocaml/ocaml/pull/1546):
  Allow empty variants
  (Runhang Li, review by Gabriel Radanne and Jacques Garrigue)

### Standard library:

- [MPR#4170](https://caml.inria.fr/mantis/view.php?id=4170),
  [GPR#1674](https://github.com/ocaml/ocaml/pull/1674):
  add the constant `Float.pi`.
  (Christophe Troestler, review by Damien Doligez)

- [MPR#6139](https://caml.inria.fr/mantis/view.php?id=6139),
  [GPR#1685](https://github.com/ocaml/ocaml/pull/1685):
  Move the Bigarray module to the standard library. Keep the
  bigarray library as on overlay adding the deprecated map_file
  functions
  (Jérémie Dimino, review by Mark Shinwell)

- [MPR#7690](https://caml.inria.fr/mantis/view.php?id=7690),
  [GPR#1528](https://github.com/ocaml/ocaml/pull/1528):
  fix the `float_of_string` function for hexadecimal floats
  with very large values of the exponent.
  (Olivier Andrieu)

- [GPR#1002](https://github.com/ocaml/ocaml/pull/1002):
  add a new `Seq` module defining a list-of-thunks style iterator.
  Also add `{to,of}_seq` to several standard modules.
  (Simon Cruanes, review by Alain Frisch and François Bobot)

* [GPR#1010](https://github.com/ocaml/ocaml/pull/1010):
  pack all standard library modules into a single module `Stdlib`
  which is the default opened module (`Stdlib` itself includes
  `Pervasives`) to free
  up the global namespace for other standard libraries, while still allowing any
  OCaml standard library module to be referred to as Stdlib.Module). This is
  implemented efficiently using module aliases (prefixing all modules with
  `Stdlib__`, e.g. `Stdlib__string`).
  (Jérémie Dimino, David Allsopp and Florian Angeletti, review by David Allsopp
   and Gabriel Radanne)

- [GPR#1637](https://github.com/ocaml/ocaml/pull/1637):
  `String.escaped` is faster and does not allocate when called with a
  string that does not contain any characters needing to be escaped.
  (Alain Frisch, review by Xavier Leroy and Gabriel Scherer)

- [GPR#1638](https://github.com/ocaml/ocaml/pull/1638):
  add a `Float` module.
  (Nicolás Ojeda Bär, review by Alain Frisch and Jeremy Yallop)

- [GPR#1697](https://github.com/ocaml/ocaml/pull/1697):
  Tune `List.init` tailrec threshold so that it does not stack overflow
  when compiled with the Js_of_ocaml backend.
  (Hugo Heuzard, reviewed by Gabriel Scherer)

### Other libraries:

- [MPR#7745](https://caml.inria.fr/mantis/view.php?id=7745),
  [GPR#1629](https://github.com/ocaml/ocaml/pull/1629):
  `Graphics.open_graph` displays the correct window title on
  Windows again (fault introduced by 4.06 Unicode changes).
  (David Allsopp)

* [GPR#1406](https://github.com/ocaml/ocaml/pull/1406):
  `Unix.isatty` now returns true in the native Windows ports when
  passed a file descriptor connected to a Cygwin PTY. In particular, compiler
  colors for the native Windows ports now work under Cygwin/MSYS2.
  (Nicolás Ojeda Bär, review by Gabriel Scherer, David Allsopp, Xavier Leroy)

- [GPR#1451](https://github.com/ocaml/ocaml/pull/1451):
  `getpwuid`, `getgrgid`, `getpwnam`, `getgrnam` now raise `Unix.error`
  instead of returning `Not_found` when interrupted by a signal.
  (Arseniy Alekseyev, review by Mark Shinwell and Xavier Leroy)

- [GPR#1477](https://github.com/ocaml/ocaml/pull/1477):
  `raw_spacetime_lib` can now be used in bytecode.
  (Nicolás Ojeda Bär, review by Mark Shinwell)

- [GPR#1533](https://github.com/ocaml/ocaml/pull/1533):
  (a) The implementation of `Thread.yield` for system thread
  now uses nanosleep(1) for enabling better preemption.
  (b) `Thread.delay` is now an alias for `Unix.sleepf`.
  (Jacques-Henri Jourdan, review by Xavier Leroy and David Allsopp)

### Compiler user-interface and warnings:

- [MPR#7663](https://caml.inria.fr/mantis/view.php?id=7663),
  [GPR#1694](https://github.com/ocaml/ocaml/pull/1694):
  print the whole cycle and add a reference to the manual in
  the unsafe recursive module evaluation error message.
  (Florian Angeletti, report by Matej Košík, review by Gabriel Scherer)

- [GPR#1166](https://github.com/ocaml/ocaml/pull/1166):
  In `OCAMLPARAM`, an alternative separator can be specified as
  first character (instead of comma) in the set ":|; ,"
  (Fabrice Le Fessant)

- [GPR#1358](https://github.com/ocaml/ocaml/pull/1358):
  Fix usage warnings with no mli file
  (Leo White, review by Alain Frisch)

- [GPR#1428](https://github.com/ocaml/ocaml/pull/1428):
  give a non dummy location for warning 49 (no cmi found)
  (Valentin Gatien-Baron)

- [GPR#1491](https://github.com/ocaml/ocaml/pull/1491):
  Improve error reporting for ill-typed applicative functor
  types, `F(M).t`.
  (Valentin Gatien-Baron, review by Florian Angeletti and Gabriel Radanne)

- [GPR#1496](https://github.com/ocaml/ocaml/pull/1496):
  Refactor the code printing explanation for unification type errors,
  in order to avoid duplicating pattern matches
  (Armaël Guéneau, review by Florian Angeletti and Gabriel Scherer)

- [GPR#1505](https://github.com/ocaml/ocaml/pull/1505):
  Add specific error messages for unification errors involving
  functions of type `unit -> _`
  (Arthur Charguéraud and Armaël Guéneau, with help from Leo White, review by
  Florian Angeletti and Gabriel Radanne)

- [GPR#1510](https://github.com/ocaml/ocaml/pull/1510):
  Add specific explanation for unification errors caused by type
  constraints propagated by keywords (such as if, while, for...)
  (Armaël Guéneau and Gabriel Scherer, original design by Arthur Charguéraud,
  review by Frédéric Bour, Gabriel Radanne and Alain Frisch)

- [GPR#1515](https://github.com/ocaml/ocaml/pull/1515):
  honor the `BUILD_PATH_PREFIX_MAP` environment variable
  to enable reproducible builds
  (Gabriel Scherer, with help from Ximin Luo, review by Damien Doligez)

- [GPR#1534](https://github.com/ocaml/ocaml/pull/1534):
  Extend the warning printed when `(*)` is used, adding a hint to
  suggest using `( * )` instead
  (Armaël Guéneau, with help and review from Florian Angeletti and Gabriel
  Scherer)

- [GPR#1552](https://github.com/ocaml/ocaml/pull/1552),
  [GPR#1577](https://github.com/ocaml/ocaml/pull/1577):
  do not warn about ambiguous variables in guards
  (warning 57) when the ambiguous values have been filtered by
  a previous clause
  (Gabriel Scherer and Thomas Refis, review by Luc Maranget)

- [GPR#1554](https://github.com/ocaml/ocaml/pull/1554):
  warnings 52 and 57: fix reference to manual detailed explanation
  (Florian Angeletti, review by Thomas Refis and Gabriel Scherer)

- [GPR#1618](https://github.com/ocaml/ocaml/pull/1618):
  add the `-dno-unique-ids` and `-dunique-ids` compiler flags
  (Sébastien Hinderer, review by Leo White and Damien Doligez)

- [GPR#1649](https://github.com/ocaml/ocaml/pull/1649)
  change compilation order of toplevel definitions, so that some warnings
  emitted by the bytecode compiler appear more in-order than before.
  (Luc Maranget, advice and review by Damien Doligez)

- [GPR#1806](https://github.com/ocaml/ocaml/pull/1806):
  add `linscan` to `OCAMLPARAM` options
  (Raja Boujbel)

### Code generation and optimizations:

- [MPR#7630](https://caml.inria.fr/mantis/view.php?id=7630),
  [GPR#1401](https://github.com/ocaml/ocaml/pull/1401):
  Faster compilation of large modules with Flambda.
  (Pierre Chambart, report by Emilio Jesús Gallego Arias,
  Pierre-Marie Pédrot and Paul Steckler, review by Gabriel Scherer
  and Leo White)

- [MPR#7630](https://caml.inria.fr/mantis/view.php?id=7630),
  [GPR#1455](https://github.com/ocaml/ocaml/pull/1455):
  Disable CSE for the initialization function
  (Pierre Chambart, report by Emilio Jesús Gallego Arias,
   review by Gabriel Scherer and Xavier Leroy)

- [GPR#1370](https://github.com/ocaml/ocaml/pull/1370):
  Fix code duplication in Cmmgen
  (Vincent Laviron, with help from Pierre Chambart,
   reviews by Gabriel Scherer and Luc Maranget)

- [GPR#1486](https://github.com/ocaml/ocaml/pull/1486):
  ARM 32-bit port: add support for ARMv8 in 32-bit mode,
  a.k.a. AArch32.
  For this platform, avoid ITE conditional instruction blocks and use
  simpler IT blocks instead
  (Xavier Leroy, review by Mark Shinwell)

- [GPR#1487](https://github.com/ocaml/ocaml/pull/1487):
  Treat negated float comparisons more directly
  (Leo White, review by Xavier Leroy)

- [GPR#1573](https://github.com/ocaml/ocaml/pull/1573):
  emitcode: merge events after instructions reordering
  (Thomas Refis and Leo White, with help from David Allsopp, review by Frédéric
  Bour)

- [GPR#1606](https://github.com/ocaml/ocaml/pull/1606):
  Simplify the semantics of Lambda.free_variables and `Lambda.subst`,
  including some API changes in `bytecomp/lambda.mli`
  (Pierre Chambart, review by Gabriel Scherer)

- [GPR#1613](https://github.com/ocaml/ocaml/pull/1613):
  ensure that set-of-closures are processed first so that other
  entries in the let-rec symbol do not get dummy approximations
  (Leo White and Xavier Clerc, review by Pierre Chambart)

* [GPR#1617](https://github.com/ocaml/ocaml/pull/1617):
  Make string/bytes distinguishable in the bytecode.
  (Hugo Heuzard, reviewed by Nicolás Ojeda Bär)

- [GPR#1627](https://github.com/ocaml/ocaml/pull/1627):
  Reduce cmx sizes by sharing variable names (Flambda only)
  (Fuyong Quah, Leo White, review by Xavier Clerc)

- [GPR#1665](https://github.com/ocaml/ocaml/pull/1665):
  reduce the size of cmx files in classic mode by dropping the
  bodies of functions that will not be inlined
  (Fuyong Quah, review by Leo White and Pierre Chambart)

- [GPR#1666](https://github.com/ocaml/ocaml/pull/1666):
  reduce the size of cmx files in classic mode by dropping the
  bodies of functions that cannot be reached from the module block
  (Fuyong Quah, review by Leo White and Pierre Chambart)

- [GPR#1686](https://github.com/ocaml/ocaml/pull/1686):
  Turn off by default flambda invariants checks.
  (Pierre Chambart)

- [GPR#1707](https://github.com/ocaml/ocaml/pull/1707):
  Add `Closure_origin.t` to trace inlined functions to prevent
  infinite loops from repeatedly inlining copies of the same
  function.
  (Fu Yong Quah)

- [GPR#1740](https://github.com/ocaml/ocaml/pull/1740):
  make sure `startup.o` is always linked in when using
  `-output-complete-obj`. Previously, it was always linked in only on some
  platforms, making this option unusable on platforms where it wasn't
  (Jérémie Dimino, review by Sébastien Hinderer and Xavier Leroy)

### Runtime system:

- [MPR#6411](https://caml.inria.fr/mantis/view.php?id=6411),
  [GPR#1535](https://github.com/ocaml/ocaml/pull/1535):
  don't compile everything with `-static-libgcc` on mingw32,
  only `dllbigarray.dll` and `libbigarray.a`. Allows the use of C++
  libraries which raise exceptions.
  (David Allsopp)

- [MPR#7100](https://caml.inria.fr/mantis/view.php?id=7100),
  [GPR#1476](https://github.com/ocaml/ocaml/pull/1476):
  trigger a minor GC when custom blocks accumulate
  in minor heap
  (Alain Frisch, report by talex, review by Damien Doligez, Leo White,
  Gabriel Scherer)

- [GPR#1431](https://github.com/ocaml/ocaml/pull/1431):
  remove ocamlrun dependencies on curses/terminfo/termcap C library
  (Xavier Leroy, review by Daniel Bünzli)

- [GPR#1478](https://github.com/ocaml/ocaml/pull/1478):
  The Spacetime profiler now works under Windows (but it is not yet
  able to collect profiling information from C stubs).
  (Nicolás Ojeda Bär, review by Xavier Leroy, Mark Shinwell)

- [GPR#1483](https://github.com/ocaml/ocaml/pull/1483):
  fix GC freelist accounting for chunks larger than the maximum block
  size.
  (David Allsopp and Damien Doligez)

- [GPR#1526](https://github.com/ocaml/ocaml/pull/1526):
  install the debug and instrumented runtimes
  (`lib{caml,asm}run{d,i}.a`)
  (Gabriel Scherer, reminded by Julia Lawall)

- [GPR#1563](https://github.com/ocaml/ocaml/pull/1563):
  simplify implementation of `LSRINT` and `ASRINT`
  (Max Mouratov, review by Frédéric Bour)

- [GPR#1644](https://github.com/ocaml/ocaml/pull/1644):
  remove `caml_alloc_float_array` from the bytecode primitives list
  (it's a native code primitive)
  (David Allsopp)

- [GPR#1701](https://github.com/ocaml/ocaml/pull/1701):
  fix missing root bug in [GPR#1476](https://github.com/ocaml/ocaml/pull/1476)
  (Mark Shinwell)

- [GPR#1752](https://github.com/ocaml/ocaml/pull/1752):
  do not alias function arguments to sigprocmask
  (Anil Madhavapeddy)

- [GPR#1753](https://github.com/ocaml/ocaml/pull/1753):
  avoid potential off-by-one overflow in debugger socket path
  length
  (Anil Madhavapeddy)

### Tools:

- [MPR#7643](https://caml.inria.fr/mantis/view.php?id=7643),
  [GPR#1377](https://github.com/ocaml/ocaml/pull/1377):
  `ocamldep`, fix an exponential blowup in presence of nested
  structures and signatures
  (e.g. `include struct … include(struct … end) … end`)
  (Florian Angeletti, review by Gabriel Scherer, report by Christophe Raffalli)

- [MPR#7687](https://caml.inria.fr/mantis/view.php?id=7687),
  [GPR#1653](https://github.com/ocaml/ocaml/pull/1653):
  deprecate `-thread` option,
  which is equivalent to `-I +threads`.
  (Nicolás Ojeda Bär, report by Daniel Bünzli)

- [MPR#7710](https://caml.inria.fr/mantis/view.php?id=7710):
  `ocamldep -sort` should exit with nonzero code in case of
  cyclic dependencies
  (Xavier Leroy, report by Mantis user baileyparker)

- [GPR#1537](https://github.com/ocaml/ocaml/pull/1537):
  `boot/ocamldep` is no longer included in the source distribution;
  `boot/ocamlc -depend` can be used in its place.
  (Nicolás Ojeda Bär, review by Xavier Leroy and Damien Doligez)

- [GPR#1585](https://github.com/ocaml/ocaml/pull/1585):
  optimize output of `ocamllex -ml`
  (Alain Frisch, review by Frédéric Bour and Gabriel Scherer)

- [GPR#1667](https://github.com/ocaml/ocaml/pull/1667):
  add command-line options `-no-propt`, `-no-version`, `-no-time`,
  `-no-breakpoint` and `-topdirs-path` to ocamldebug
  (Sébastien Hinderer, review by Damien Doligez)

- [GPR#1695](https://github.com/ocaml/ocaml/pull/1695):
  add the `-null-crc` command-line option to ocamlobjinfo.
  (Sébastien Hinderer, review by David Allsopp and Gabriel Scherer)

- [GPR#1710](https://github.com/ocaml/ocaml/pull/1710):
  ocamldoc, improve the 'man' rendering of subscripts and
  superscripts.
  (Gabriel Scherer)

- [GPR#1771](https://github.com/ocaml/ocaml/pull/1771):
  ocamdebug, avoid out of bound access
  (Thomas Refis)

### Manual and documentation:

- [MPR#7613](https://caml.inria.fr/mantis/view.php?id=7613):
  minor reword of the "refutation cases" paragraph
  (Florian Angeletti, review by Jacques Garrigue)

- PR#7647, [GPR#1384](https://github.com/ocaml/ocaml/pull/1384):
  emphasize ocaml.org website and forum in README
  (Yawar Amin, review by Gabriel Scherer)

- PR#7698, [GPR#1545](https://github.com/ocaml/ocaml/pull/1545):
  improve wording in OCaml manual in several places,
  mostly in Chapter 1.  This addresses the easier changes suggested in
  the PR.
  (Jim Fehrle, review by Florian Angeletti and David Allsopp)

- [GPR#1540](https://github.com/ocaml/ocaml/pull/1540):
  manual, decouple verbatim and toplevel style in code examples
  (Florian Angeletti, review by Gabriel Scherer)

- [GPR#1556](https://github.com/ocaml/ocaml/pull/1556):
  manual, add a consistency test for manual references inside
  the compiler source code.
  (Florian Angeletti, review by Gabriel Scherer)

- [GPR#1647](https://github.com/ocaml/ocaml/pull/1647):
  manual, subsection on record and variant disambiguation
  (Florian Angeletti, review by Alain Frisch and Gabriel Scherer)

- [GPR#1702](https://github.com/ocaml/ocaml/pull/1702):
  manual, add a signature mode for code examples
  (Florian Angeletti, review by Gabriel Scherer)

- [GPR#1741](https://github.com/ocaml/ocaml/pull/1741):
  manual, improve typesetting and legibility in HTML output
  (steinuil, review by Gabriel Scherer)

- [GPR#1757](https://github.com/ocaml/ocaml/pull/1757):
  style the html manual, changing type and layout
  (Charles Chamberlain, review by Florian Angeletti, Xavier Leroy,
  Gabriel Radanne, Perry E. Metzger, and Gabriel Scherer)

- [GPR#1765](https://github.com/ocaml/ocaml/pull/1765):
  manual, ellipsis in code examples
  (Florian Angeletti, review and suggestion by Gabriel Scherer)

- [GPR#1767](https://github.com/ocaml/ocaml/pull/1767):
  change html manual to use relative font sizes
  (Charles Chamberlain, review by Daniel Bünzli, Perry E. Metzger,
  Josh Berdine, and Gabriel Scherer)

- [GPR#1779](https://github.com/ocaml/ocaml/pull/1779):
  integrate the Bigarray documentation into the main manual.
  (Perry E. Metzger, review by Florian Angeletti and Xavier Clerc)

### Type system:

- [MPR#7611](https://caml.inria.fr/mantis/view.php?id=7611),
  [GPR#1491](https://github.com/ocaml/ocaml/pull/1491):
  reject the use of generative functors as applicative
  (Valentin Gatien-Baron)

- [MPR#7706](https://caml.inria.fr/mantis/view.php?id=7706),
  [GPR#1565](https://github.com/ocaml/ocaml/pull/1565):
  in recursive value declarations, track
  static size of locally-defined variables
  (Gabriel Scherer, review by Jeremy Yallop and Leo White, report by Leo White)

- [MPR#7717](https://caml.inria.fr/mantis/view.php?id=7717),
  [GPR#1593](https://github.com/ocaml/ocaml/pull/1593):
  in recursive value declarations, don't treat
  unboxed constructor size as statically known
  (Jeremy Yallop, report by Pierre Chambart, review by Gabriel Scherer)

- [MPR#7767](https://caml.inria.fr/mantis/view.php?id=7767),
  [GPR#1712](https://github.com/ocaml/ocaml/pull/1712):
  restore legacy treatment of partially-applied
  labeled functions in `let rec` bindings.
  (Jeremy Yallop, report by Ivan Gotovchits, review by Gabriel Scherer)

* [MPR#7787](https://caml.inria.fr/mantis/view.php?id=7787),
  [GPR#1652](https://github.com/ocaml/ocaml/pull/1652),
  [GPR#1743](https://github.com/ocaml/ocaml/pull/1743):
  Don't remove module aliases in `module type of`
  and `with module`.
  The old behaviour can be obtained using the `[@remove_aliases]`
  attribute.
  (Leo White and Thomas Refis, review by Jacques Garrigue)

- [GPR#1468](https://github.com/ocaml/ocaml/pull/1468):
  Do not enrich type_decls with incoherent manifests
  (Thomas Refis and Leo White, review by Jacques Garrigue)

- [GPR#1469](https://github.com/ocaml/ocaml/pull/1469):
  Use the information from `[@@immediate]` annotations when
  computing whether a type can be `[@@unboxed]`
  (Damien Doligez, report by Stephan Muenzel, review by Alain Frisch)

- [GPR#1513](https://github.com/ocaml/ocaml/pull/1513):
  Allow compilation units to shadow sub-modules of `Pervasives`.
  For instance users can now use a `largeFile.ml` file in their
  project.
  (Jérémie Dimino, review by Nicolas Ojeda Bar, Alain Frisch and Gabriel Radanne)

- [GPR#1516](https://github.com/ocaml/ocaml/pull/1516):
  Allow `float array` construction in recursive bindings
  when configured with `-no-flat-float-array`
  (Jeremy Yallop, report by Gabriel Scherer)

- [GPR#1583](https://github.com/ocaml/ocaml/pull/1583):
  propagate refined `ty_arg` to Parmatch checks
  (Thomas Refis, review by Jacques Garrigue)

- [GPR#1609](https://github.com/ocaml/ocaml/pull/1609):
  Changes to ambivalence scope tracking
  (Thomas Refis and Leo White, review by Jacques Garrigue)

- [GPR#1628](https://github.com/ocaml/ocaml/pull/1628):
  Treat `reraise` and `raise_notrace` as nonexpansive.
  (Leo White, review by Alain Frisch)

* [GPR#1778](https://github.com/ocaml/ocaml/pull/1778):
  Fix Soundness bug with non-generalized type variable and
  local modules.  This is the same bug as
  [MPR#7414](https://caml.inria.fr/mantis/view.php?id=7414),
  but using local modules instead of non-local ones.
  (Leo White, review by Jacques Garrigue)

### Compiler distribution build system

- [MPR#5219](https://caml.inria.fr/mantis/view.php?id=5219),
  [GPR#1680](https://github.com/ocaml/ocaml/pull/1680),
  [GPR#1877](https://github.com/ocaml/ocaml/pull/1877):
  use `install` instead of `cp` in install scripts.
  (Gabriel Scherer, review by Sébastien Hinderer and Valentin Gatien-Baron)

- [MPR#7679](https://caml.inria.fr/mantis/view.php?id=7679):
  make sure `.a` files are erased before calling `ar rc`, otherwise
  leftover `.a` files from an earlier compilation may contain unwanted
  modules
  (Xavier Leroy)

- [GPR#1571](https://github.com/ocaml/ocaml/pull/1571):
  do not perform architecture tests on 32-bit platforms, allowing
  64-bit back-ends to use 64-bit specific constructs
  (Xavier Clerc, review by Damien Doligez)

### Internal/compiler-libs changes:

- [MPR#7738](https://caml.inria.fr/mantis/view.php?id=7738),
  [GPR#1624](https://github.com/ocaml/ocaml/pull/1624):
  `Asmlink.reset` also resets `lib_ccobjs/ccopts`
  (Cedric Cellier, review by Gabriel Scherer)

- [GPR#1488](https://github.com/ocaml/ocaml/pull/1488),
  [GPR#1560](https://github.com/ocaml/ocaml/pull/1560):
  Refreshing parmatch
  (Gabriel Scherer and Thomas Refis, review by Luc Maranget)

- [GPR#1502](https://github.com/ocaml/ocaml/pull/1502):
  more command line options for expect tests
  (Florian Angeletti, review by Gabriel Scherer)

- [GPR#1511](https://github.com/ocaml/ocaml/pull/1511):
  show code at error location in expect-style tests,
  using new `Location.show_code_at_location` function
  (Gabriel Scherer and Armaël Guéneau,
   review by Valentin Gatien-Baron and Damien Doligez)

- [GPR#1519](https://github.com/ocaml/ocaml/pull/1519),
  [GPR#1532](https://github.com/ocaml/ocaml/pull/1532),
  GRP#1570: migrate tests to ocamltest
  (Sébastien Hinderer, review by Gabriel Scherer, Valentin Gatien-Baron
  and Nicolás Ojeda Bär)

- [GPR#1520](https://github.com/ocaml/ocaml/pull/1520):
  more robust implementation of `Misc.no_overflow_mul`
  (Max Mouratov, review by Xavier Leroy)

- [GPR#1557](https://github.com/ocaml/ocaml/pull/1557):
  Organise and simplify translation of primitives
  (Leo White, review by François Bobot and Nicolás Ojeda Bär)

- [GPR#1567](https://github.com/ocaml/ocaml/pull/1567):
  register all idents relevant for `reraise`
  (Thomas Refis, review by Alain Frisch and Frédéric Bour)

- [GPR#1586](https://github.com/ocaml/ocaml/pull/1586):
  testsuite: `make promote` for ocamltest tests
  (The new `-promote` option for ocamltest is experimental
  and subject to change/removal).
  (Gabriel Scherer)

- [GPR#1619](https://github.com/ocaml/ocaml/pull/1619):
  expect_test: print all the exceptions, even the unexpected ones
  (Thomas Refis, review by Jérémie Dimino)

- [GPR#1621](https://github.com/ocaml/ocaml/pull/1621):
  expect_test: make sure to not use the installed stdlib
  (Jérémie Dimino, review by Thomas Refis)

- [GPR#1646](https://github.com/ocaml/ocaml/pull/1646):
  add ocamldoc test to ocamltest and migrate ocamldoc tests to
  ocamltest
  (Florian Angeletti, review by Sébastien Hinderer)

- [GPR#1663](https://github.com/ocaml/ocaml/pull/1663):
  refactor flambda specialise/inlining handling
  (Leo White and Xavier Clerc, review by Pierre Chambart)

- [GPR#1679](https://github.com/ocaml/ocaml/pull/1679):
  remove Pbittest from primitives in lambda
  (Hugo Heuzard, review by Mark Shinwell)

* [GPR#1704](https://github.com/ocaml/ocaml/pull/1704):
  Make Ident.t abstract and immutable.
  (Gabriel Radanne, review by Mark Shinwell)

### Bug fixes

- [MPR#4499](https://caml.inria.fr/mantis/view.php?id=4499),
  [GPR#1479](https://github.com/ocaml/ocaml/pull/1479):
  Use native Windows API to implement `Sys.getenv`,
  `Unix.getenv` and `Unix.environment` under Windows.
  (Nicolás Ojeda Bär, report by Alain Frisch, review by David Allsopp, Xavier
  Leroy)

- [MPR#5250](https://caml.inria.fr/mantis/view.php?id=5250),
  [GPR#1435](https://github.com/ocaml/ocaml/pull/1435):
  on Cygwin, when ocamlrun searches the path
  for a bytecode executable file, skip directories and other
  non-regular files, like other Unix variants do.
  (Xavier Leroy)

- [MPR#6394](https://caml.inria.fr/mantis/view.php?id=6394),
  [GPR#1425](https://github.com/ocaml/ocaml/pull/1425):
  fix `fatal_error` from `Parmatch.get_type_path`
  (Virgile Prevosto, review by David Allsopp, Thomas Refis and Jacques Garrigue)

* [MPR#6604](https://caml.inria.fr/mantis/view.php?id=6604),
  [GPR#931](https://github.com/ocaml/ocaml/pull/931):
  Only allow directives with filename and at the beginning of
  the line
  (Tadeu Zagallo, report by Roberto Di Cosmo,
   review by Hongbo Zhang, David Allsopp, Gabriel Scherer, Xavier Leroy)

- [MPR#7138](https://caml.inria.fr/mantis/view.php?id=7138),
  [MPR#7701](https://caml.inria.fr/mantis/view.php?id=7701),
  [GPR#1693](https://github.com/ocaml/ocaml/pull/1693):
  Keep documentation comments
  even in empty structures and signatures
  (Leo White, Florian Angeletti, report by Anton Bachin)

- [MPR#7178](https://caml.inria.fr/mantis/view.php?id=7178),
  [MPR#7253](https://caml.inria.fr/mantis/view.php?id=7253),
  [MPR#7796](https://caml.inria.fr/mantis/view.php?id=7796),
  [GPR#1790](https://github.com/ocaml/ocaml/pull/1790):
  Make sure a function
  registered with `at_exit` is executed only once when the program
  exits
  (Nicolás Ojeda Bär and Xavier Leroy, review by Max Mouratov)

- [MPR#7391](https://caml.inria.fr/mantis/view.php?id=7391),
  [GPR#1620](https://github.com/ocaml/ocaml/pull/1620):
  Do not put a dummy method in object types
  (Thomas Refis, review by Jacques Garrigue)

- PR#7660, [GPR#1445](https://github.com/ocaml/ocaml/pull/1445):
  Use native Windows API to implement `Unix.utimes` in order to
  avoid unintended shifts of the argument timestamp depending on DST
  setting.
  (Nicolás Ojeda Bär, review by David Allsopp, Xavier Leroy)

- [MPR#7668](https://caml.inria.fr/mantis/view.php?id=7668):
  `-principal` is broken with polymorphic variants
  (Jacques Garrigue, report by Jun Furuse)

- [MPR#7680](https://caml.inria.fr/mantis/view.php?id=7680),
  [GPR#1497](https://github.com/ocaml/ocaml/pull/1497):
  Incorrect interaction between `Matching.for_let and`
  `Simplif.simplify_exits`
  (Alain Frisch, report and review by Vincent Laviron)

- [MPR#7682](https://caml.inria.fr/mantis/view.php?id=7682),
  [GPR#1495](https://github.com/ocaml/ocaml/pull/1495):
  fix `[@@unboxed]` for records with 1 polymorphic field
  (Alain Frisch, report by Stéphane Graham-Lengrand, review by Gabriel Scherer)

- [MPR#7695](https://caml.inria.fr/mantis/view.php?id=7695),
  [GPR#1541](https://github.com/ocaml/ocaml/pull/1541):
  Fatal error: exception `Ctype.Unify(_)` with field override
  (Jacques Garrigue, report by Nicolás Ojeda Bär)

- [MPR#7704](https://caml.inria.fr/mantis/view.php?id=7704),
  [GPR#1564](https://github.com/ocaml/ocaml/pull/1564):
  use proper variant tag in non-exhaustiveness warning
  (Jacques Garrigue, report by Thomas Refis)

- [MPR#7711](https://caml.inria.fr/mantis/view.php?id=7711),
  [GPR#1581](https://github.com/ocaml/ocaml/pull/1581):
  Internal typechecker error triggered by a constraint on
  self type in a class type
  (Jacques Garrigue, report and review by Florian Angeletti)

- [MPR#7712](https://caml.inria.fr/mantis/view.php?id=7712),
  [GPR#1576](https://github.com/ocaml/ocaml/pull/1576):
  assertion failure with type abbreviations
  (Thomas Refis, report by Michael O'Connor, review by Jacques Garrigue)

- [MPR#7747](https://caml.inria.fr/mantis/view.php?id=7747):
  Type checker can loop infinitly and consumes all computer memory
  (Jacques Garrigue, report by kantian)

- [MPR#7751](https://caml.inria.fr/mantis/view.php?id=7751),
  [GPR#1657](https://github.com/ocaml/ocaml/pull/1657):
  The toplevel prints some concrete types as abstract
  (Jacques Garrigue, report by Matej Kosik)

- [MPR#7765](https://caml.inria.fr/mantis/view.php?id=7765),
  [GPR#1718](https://github.com/ocaml/ocaml/pull/1718):
  When unmarshaling bigarrays, protect against integer
  overflows in size computations
  (Xavier Leroy, report by Maximilian Tschirschnitz,
   review by Gabriel Scherer)

- [MPR#7760](https://caml.inria.fr/mantis/view.php?id=7760),
  [GPR#1713](https://github.com/ocaml/ocaml/pull/1713):
  Exact selection of lexing engine, that is
  correct "Segfault in ocamllex-generated code using 'shortest'"
  (Luc Maranget, Frédéric Bour, report by Stephen Dolan,
  review by Gabriel Scherer)

- [MPR#7769](https://caml.inria.fr/mantis/view.php?id=7769),
  [GPR#1714](https://github.com/ocaml/ocaml/pull/1714):
  calls to Stream.junk could, under some conditions, be
  ignored when used on streams based on input channels.
  (Nicolás Ojeda Bär, report by Michael Perin, review by Gabriel Scherer)

- [MPR#7793](https://caml.inria.fr/mantis/view.php?id=7793),
  [GPR#1766](https://github.com/ocaml/ocaml/pull/1766):
  the toplevel `#use` directive now accepts sequences of `;;`
  tokens. This fixes a bug in which certain files accepted by the compiler were
  rejected by ocamldep.
  (Nicolás Ojeda Bär, report by Hugo Heuzard, review by Hugo Heuzard)

- [GPR#1517](https://github.com/ocaml/ocaml/pull/1517):
  More robust handling of type variables in mcomp
  (Leo White and Thomas Refis, review by Jacques Garrigue)

- [GPR#1530](https://github.com/ocaml/ocaml/pull/1530),
  [GPR#1574](https://github.com/ocaml/ocaml/pull/1574):
  testsuite, fix `make parallel` and `make one DIR=...`
  to work on ocamltest-based tests.
  (Runhang Li and Sébastien Hinderer, review by Gabriel Scherer)

- [GPR#1550](https://github.com/ocaml/ocaml/pull/1550),
  [GPR#1555](https://github.com/ocaml/ocaml/pull/1555):
  Make pattern matching warnings more robust
  to ill-typed columns
  (Thomas Refis, with help from Gabriel Scherer and Luc Maranget)

- [GPR#1614](https://github.com/ocaml/ocaml/pull/1614):
  consider all bound variables when inlining, fixing a compiler
  fatal error.
  (Xavier Clerc, review by Pierre Chambart, Leo White)

- [GPR#1622](https://github.com/ocaml/ocaml/pull/1622):
  fix bug in the expansion of command-line arguments under Windows
  which could result in some elements of Sys.argv being truncated in
  some cases.
  (Nicolás Ojeda Bär, review by Sébastien Hinderer)

- [GPR#1623](https://github.com/ocaml/ocaml/pull/1623):
  Segfault on Windows 64 bits when expanding wildcards in arguments.
  (Marc Lasson, review by David Allsopp, Alain Frisch, Sébastien Hinderer,
   Xavier Leroy, Nicolas Ojeda Bar)

- [GPR#1661](https://github.com/ocaml/ocaml/pull/1661):
  more precise principality warning regarding record fields
  disambiguation
  (Thomas Refis, review by Leo White)

- [GPR#1687](https://github.com/ocaml/ocaml/pull/1687):
  fix bug in the printing of short functor types `(S1 -> S2) -> S3`
  (Pieter Goetschalckx, review by Gabriel Scherer)

- [GPR#1722](https://github.com/ocaml/ocaml/pull/1722):
  Scrape types in `Typeopt.maybe_pointer`
  (Leo White, review by Thomas Refis)

- [GPR#1755](https://github.com/ocaml/ocaml/pull/1755):
  ensure that a bigarray is never collected while reading complex
  values
  (Xavier Clerc, Mark Shinwell and Leo White, report by Chris Hardin,
  reviews by Stephen Dolan and Xavier Leroy)

- [GPR#1764](https://github.com/ocaml/ocaml/pull/1764):
  in `byterun/memory.c`, `struct pool_block`, use C99 flexible arrays
  if available
  (Xavier Leroy, review by Max Mouratov)

- [GPR#1774](https://github.com/ocaml/ocaml/pull/1774):
  ocamlopt for ARM could generate VFP loads and stores with bad
  offsets, rejected by the assembler.
  (Xavier Leroy, review by Mark Shinwell)

- [GPR#1808](https://github.com/ocaml/ocaml/pull/1808):
  handle `[@inlined]` attributes under a module constraint
  (Xavier Clerc, review by Leo White)

- [GPR#1810](https://github.com/ocaml/ocaml/pull/1810):
  use bit-pattern comparison when meeting float approximations
  (Xavier Clerc, report by Christophe Troestler, review by Nicolás Ojeda Bär
   and Gabriel Scherer)

- [GPR#1835](https://github.com/ocaml/ocaml/pull/1835):
  Fix off-by-one errors in `Weak.get_copy` and `Weak.blit`
  (KC Sivaramakrishnan)

- [GPR#1849](https://github.com/ocaml/ocaml/pull/1849):
  bug in runtime function `generic_final_minor_update()`
  that could lead to crashes when `Gc.finalise_last` is used
  (report and fix by Yuriy Vostrikov, review by François Bobot)
|js}
  ; body_html = {js|<h2>Opam Switches</h2>
<p>This release is available as multiple
<a href="https://opam.ocaml.org/doc/Usage.html">OPAM</a> switches:</p>
<ul>
<li>4.07.0 — Official 4.07.0 release
</li>
<li>4.07.0+afl — Official 4.07.0 release with afl-fuzz instrumentation
</li>
<li>4.07.0+default-unsafe-string — Official 4.07.0 release without safe
strings by default
</li>
<li>4.07.0+flambda — Official 4.07.0 release with flambda activated
</li>
<li>4.07.0+force-safe-string — Official 4.07.0 release with -safe-string enabled.
</li>
<li>4.07.0+fp — Official 4.07.0 release with frame-pointers
</li>
<li>4.07.0+fp+flambda — Official 4.07.0 release with frame-pointers and
flambda activated
</li>
</ul>
<h2>What's new</h2>
<p>Some of the highlights in release 4.07 are:</p>
<ul>
<li>
<p>The standard library is now packed into a module called <code>Stdlib</code>, which is
open by default. This makes it easier to add new modules to the standard
library without clashing with user-defined modules.</p>
</li>
<li>
<p>The <code>Bigarray</code> module is now part of the standard library.</p>
</li>
<li>
<p>The modules <code>Seq</code>, <code>Float</code> were added to the standard library.</p>
</li>
<li>
<p>Improvements to several error and warning messages printed by the
compiler make them much easier to understand.</p>
</li>
<li>
<p>Many improvements to flambda.</p>
</li>
<li>
<p>Removed the dependency on curses/terminfo/termcap.</p>
</li>
<li>
<p>The SpaceTime profiler now works under Windows.</p>
</li>
</ul>
<p>For a comprehensive list of changes and details on all new features,
bug fixes, optimizations, etc., please consult the
<a href="#Changes">changelog</a>.</p>
<h2>Source distribution</h2>
<ul>
<li><a href="https://github.com/ocaml/ocaml/archive/4.07.0.tar.gz">Source
tarball</a>
(.tar.gz) for compilation under Unix (including Linux and MacOS X)
and Microsoft Windows (including Cygwin).
</li>
<li>Also available in
<a href="https://github.com/ocaml/ocaml/archive/4.07.0.zip">.zip</a>
format.
</li>
<li><a href="https://opam.ocaml.org/">OPAM</a> is a source-based distribution of
OCaml and many companion libraries and tools. Compilation and
installation are automated by powerful package managers.
</li>
<li>The official development repo is hosted on
<a href="https://github.com/ocaml/ocaml">GitHub</a>.
</li>
</ul>
<p>The
<a href="4.07/notes/INSTALL.adoc">INSTALL</a> file
of the distribution provides detailed compilation and installation
instructions -- see also the <a href="4.07/notes/README.win32.adoc">Windows release
notes</a> for
instructions on how to build under Windows.</p>
<h2>Alternative Compilers</h2>
<p>Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:</p>
<ul>
<li><a href="http://ocsigen.org/js_of_ocaml/">Js_of_ocaml</a> is a stable OCaml
to JavaScript compiler.
</li>
<li><a href="http://bucklescript.github.io/bucklescript/">Bucklescript</a> is a
newer OCaml to JavaScript compiler. See its
<a href="https://github.com/bucklescript/bucklescript/wiki/Differences-from-js_of_ocaml">wiki</a> for
an explanation of how it differs from js_of_ocaml.
</li>
<li><a href="http://www.ocamljava.org/">OCaml-java</a> is a stable OCaml to
Java compiler.
</li>
</ul>
<h2>User's manual</h2>
<p>The user's manual for OCaml can be:</p>
<ul>
<li><a href="4.07/htmlman/index.html">browsed
online</a>,
</li>
<li>downloaded as a single
<a href="4.07/ocaml-4.07-refman.ps.gz">PostScript</a>,
<a href="4.07/ocaml-4.07-refman.pdf">PDF</a>,
or <a href="4.07/ocaml-4.07-refman.txt">plain
text</a>
document,
</li>
<li>downloaded as a single
<a href="4.07/ocaml-4.07-refman-html.tar.gz">TAR</a>
or
<a href="4.07/ocaml-4.07-refman-html.zip">ZIP</a>
archive of HTML files,
</li>
<li>downloaded as a single
<a href="4.07/ocaml-4.07-refman.info.tar.gz">tarball</a>
of Emacs info files,
</li>
</ul>
<h2>Changes</h2>
<p>This is the
<a href="4.07/notes/Changes">changelog</a>.</p>
<p>(Changes that can break existing programs are marked with a &quot;*&quot;)</p>
<h3>Language features:</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=6023">MPR#6023</a>,
<a href="https://github.com/ocaml/ocaml/pull/1648">GPR#1648</a>:
Allow type-based selection of GADT constructors
(Thomas Refis and Leo White, review by Jacques Garrigue and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1546">GPR#1546</a>:
Allow empty variants
(Runhang Li, review by Gabriel Radanne and Jacques Garrigue)</p>
</li>
</ul>
<h3>Standard library:</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=4170">MPR#4170</a>,
<a href="https://github.com/ocaml/ocaml/pull/1674">GPR#1674</a>:
add the constant <code>Float.pi</code>.
(Christophe Troestler, review by Damien Doligez)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=6139">MPR#6139</a>,
<a href="https://github.com/ocaml/ocaml/pull/1685">GPR#1685</a>:
Move the Bigarray module to the standard library. Keep the
bigarray library as on overlay adding the deprecated map_file
functions
(Jérémie Dimino, review by Mark Shinwell)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7690">MPR#7690</a>,
<a href="https://github.com/ocaml/ocaml/pull/1528">GPR#1528</a>:
fix the <code>float_of_string</code> function for hexadecimal floats
with very large values of the exponent.
(Olivier Andrieu)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1002">GPR#1002</a>:
add a new <code>Seq</code> module defining a list-of-thunks style iterator.
Also add <code>{to,of}_seq</code> to several standard modules.
(Simon Cruanes, review by Alain Frisch and François Bobot)</p>
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/1010">GPR#1010</a>:
pack all standard library modules into a single module <code>Stdlib</code>
which is the default opened module (<code>Stdlib</code> itself includes
<code>Pervasives</code>) to free
up the global namespace for other standard libraries, while still allowing any
OCaml standard library module to be referred to as Stdlib.Module). This is
implemented efficiently using module aliases (prefixing all modules with
<code>Stdlib__</code>, e.g. <code>Stdlib__string</code>).
(Jérémie Dimino, David Allsopp and Florian Angeletti, review by David Allsopp
and Gabriel Radanne)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1637">GPR#1637</a>:
<code>String.escaped</code> is faster and does not allocate when called with a
string that does not contain any characters needing to be escaped.
(Alain Frisch, review by Xavier Leroy and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1638">GPR#1638</a>:
add a <code>Float</code> module.
(Nicolás Ojeda Bär, review by Alain Frisch and Jeremy Yallop)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1697">GPR#1697</a>:
Tune <code>List.init</code> tailrec threshold so that it does not stack overflow
when compiled with the Js_of_ocaml backend.
(Hugo Heuzard, reviewed by Gabriel Scherer)</p>
</li>
</ul>
<h3>Other libraries:</h3>
<ul>
<li><a href="https://caml.inria.fr/mantis/view.php?id=7745">MPR#7745</a>,
<a href="https://github.com/ocaml/ocaml/pull/1629">GPR#1629</a>:
<code>Graphics.open_graph</code> displays the correct window title on
Windows again (fault introduced by 4.06 Unicode changes).
(David Allsopp)
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/1406">GPR#1406</a>:
<code>Unix.isatty</code> now returns true in the native Windows ports when
passed a file descriptor connected to a Cygwin PTY. In particular, compiler
colors for the native Windows ports now work under Cygwin/MSYS2.
(Nicolás Ojeda Bär, review by Gabriel Scherer, David Allsopp, Xavier Leroy)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1451">GPR#1451</a>:
<code>getpwuid</code>, <code>getgrgid</code>, <code>getpwnam</code>, <code>getgrnam</code> now raise <code>Unix.error</code>
instead of returning <code>Not_found</code> when interrupted by a signal.
(Arseniy Alekseyev, review by Mark Shinwell and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1477">GPR#1477</a>:
<code>raw_spacetime_lib</code> can now be used in bytecode.
(Nicolás Ojeda Bär, review by Mark Shinwell)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1533">GPR#1533</a>:
(a) The implementation of <code>Thread.yield</code> for system thread
now uses nanosleep(1) for enabling better preemption.
(b) <code>Thread.delay</code> is now an alias for <code>Unix.sleepf</code>.
(Jacques-Henri Jourdan, review by Xavier Leroy and David Allsopp)</p>
</li>
</ul>
<h3>Compiler user-interface and warnings:</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7663">MPR#7663</a>,
<a href="https://github.com/ocaml/ocaml/pull/1694">GPR#1694</a>:
print the whole cycle and add a reference to the manual in
the unsafe recursive module evaluation error message.
(Florian Angeletti, report by Matej Košík, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1166">GPR#1166</a>:
In <code>OCAMLPARAM</code>, an alternative separator can be specified as
first character (instead of comma) in the set &quot;:|; ,&quot;
(Fabrice Le Fessant)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1358">GPR#1358</a>:
Fix usage warnings with no mli file
(Leo White, review by Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1428">GPR#1428</a>:
give a non dummy location for warning 49 (no cmi found)
(Valentin Gatien-Baron)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1491">GPR#1491</a>:
Improve error reporting for ill-typed applicative functor
types, <code>F(M).t</code>.
(Valentin Gatien-Baron, review by Florian Angeletti and Gabriel Radanne)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1496">GPR#1496</a>:
Refactor the code printing explanation for unification type errors,
in order to avoid duplicating pattern matches
(Armaël Guéneau, review by Florian Angeletti and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1505">GPR#1505</a>:
Add specific error messages for unification errors involving
functions of type <code>unit -&gt; _</code>
(Arthur Charguéraud and Armaël Guéneau, with help from Leo White, review by
Florian Angeletti and Gabriel Radanne)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1510">GPR#1510</a>:
Add specific explanation for unification errors caused by type
constraints propagated by keywords (such as if, while, for...)
(Armaël Guéneau and Gabriel Scherer, original design by Arthur Charguéraud,
review by Frédéric Bour, Gabriel Radanne and Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1515">GPR#1515</a>:
honor the <code>BUILD_PATH_PREFIX_MAP</code> environment variable
to enable reproducible builds
(Gabriel Scherer, with help from Ximin Luo, review by Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1534">GPR#1534</a>:
Extend the warning printed when <code>(*)</code> is used, adding a hint to
suggest using <code>( * )</code> instead
(Armaël Guéneau, with help and review from Florian Angeletti and Gabriel
Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1552">GPR#1552</a>,
<a href="https://github.com/ocaml/ocaml/pull/1577">GPR#1577</a>:
do not warn about ambiguous variables in guards
(warning 57) when the ambiguous values have been filtered by
a previous clause
(Gabriel Scherer and Thomas Refis, review by Luc Maranget)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1554">GPR#1554</a>:
warnings 52 and 57: fix reference to manual detailed explanation
(Florian Angeletti, review by Thomas Refis and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1618">GPR#1618</a>:
add the <code>-dno-unique-ids</code> and <code>-dunique-ids</code> compiler flags
(Sébastien Hinderer, review by Leo White and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1649">GPR#1649</a>
change compilation order of toplevel definitions, so that some warnings
emitted by the bytecode compiler appear more in-order than before.
(Luc Maranget, advice and review by Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1806">GPR#1806</a>:
add <code>linscan</code> to <code>OCAMLPARAM</code> options
(Raja Boujbel)</p>
</li>
</ul>
<h3>Code generation and optimizations:</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7630">MPR#7630</a>,
<a href="https://github.com/ocaml/ocaml/pull/1401">GPR#1401</a>:
Faster compilation of large modules with Flambda.
(Pierre Chambart, report by Emilio Jesús Gallego Arias,
Pierre-Marie Pédrot and Paul Steckler, review by Gabriel Scherer
and Leo White)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7630">MPR#7630</a>,
<a href="https://github.com/ocaml/ocaml/pull/1455">GPR#1455</a>:
Disable CSE for the initialization function
(Pierre Chambart, report by Emilio Jesús Gallego Arias,
review by Gabriel Scherer and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1370">GPR#1370</a>:
Fix code duplication in Cmmgen
(Vincent Laviron, with help from Pierre Chambart,
reviews by Gabriel Scherer and Luc Maranget)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1486">GPR#1486</a>:
ARM 32-bit port: add support for ARMv8 in 32-bit mode,
a.k.a. AArch32.
For this platform, avoid ITE conditional instruction blocks and use
simpler IT blocks instead
(Xavier Leroy, review by Mark Shinwell)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1487">GPR#1487</a>:
Treat negated float comparisons more directly
(Leo White, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1573">GPR#1573</a>:
emitcode: merge events after instructions reordering
(Thomas Refis and Leo White, with help from David Allsopp, review by Frédéric
Bour)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1606">GPR#1606</a>:
Simplify the semantics of Lambda.free_variables and <code>Lambda.subst</code>,
including some API changes in <code>bytecomp/lambda.mli</code>
(Pierre Chambart, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1613">GPR#1613</a>:
ensure that set-of-closures are processed first so that other
entries in the let-rec symbol do not get dummy approximations
(Leo White and Xavier Clerc, review by Pierre Chambart)</p>
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/1617">GPR#1617</a>:
Make string/bytes distinguishable in the bytecode.
(Hugo Heuzard, reviewed by Nicolás Ojeda Bär)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1627">GPR#1627</a>:
Reduce cmx sizes by sharing variable names (Flambda only)
(Fuyong Quah, Leo White, review by Xavier Clerc)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1665">GPR#1665</a>:
reduce the size of cmx files in classic mode by dropping the
bodies of functions that will not be inlined
(Fuyong Quah, review by Leo White and Pierre Chambart)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1666">GPR#1666</a>:
reduce the size of cmx files in classic mode by dropping the
bodies of functions that cannot be reached from the module block
(Fuyong Quah, review by Leo White and Pierre Chambart)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1686">GPR#1686</a>:
Turn off by default flambda invariants checks.
(Pierre Chambart)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1707">GPR#1707</a>:
Add <code>Closure_origin.t</code> to trace inlined functions to prevent
infinite loops from repeatedly inlining copies of the same
function.
(Fu Yong Quah)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1740">GPR#1740</a>:
make sure <code>startup.o</code> is always linked in when using
<code>-output-complete-obj</code>. Previously, it was always linked in only on some
platforms, making this option unusable on platforms where it wasn't
(Jérémie Dimino, review by Sébastien Hinderer and Xavier Leroy)</p>
</li>
</ul>
<h3>Runtime system:</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=6411">MPR#6411</a>,
<a href="https://github.com/ocaml/ocaml/pull/1535">GPR#1535</a>:
don't compile everything with <code>-static-libgcc</code> on mingw32,
only <code>dllbigarray.dll</code> and <code>libbigarray.a</code>. Allows the use of C++
libraries which raise exceptions.
(David Allsopp)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7100">MPR#7100</a>,
<a href="https://github.com/ocaml/ocaml/pull/1476">GPR#1476</a>:
trigger a minor GC when custom blocks accumulate
in minor heap
(Alain Frisch, report by talex, review by Damien Doligez, Leo White,
Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1431">GPR#1431</a>:
remove ocamlrun dependencies on curses/terminfo/termcap C library
(Xavier Leroy, review by Daniel Bünzli)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1478">GPR#1478</a>:
The Spacetime profiler now works under Windows (but it is not yet
able to collect profiling information from C stubs).
(Nicolás Ojeda Bär, review by Xavier Leroy, Mark Shinwell)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1483">GPR#1483</a>:
fix GC freelist accounting for chunks larger than the maximum block
size.
(David Allsopp and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1526">GPR#1526</a>:
install the debug and instrumented runtimes
(<code>lib{caml,asm}run{d,i}.a</code>)
(Gabriel Scherer, reminded by Julia Lawall)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1563">GPR#1563</a>:
simplify implementation of <code>LSRINT</code> and <code>ASRINT</code>
(Max Mouratov, review by Frédéric Bour)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1644">GPR#1644</a>:
remove <code>caml_alloc_float_array</code> from the bytecode primitives list
(it's a native code primitive)
(David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1701">GPR#1701</a>:
fix missing root bug in <a href="https://github.com/ocaml/ocaml/pull/1476">GPR#1476</a>
(Mark Shinwell)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1752">GPR#1752</a>:
do not alias function arguments to sigprocmask
(Anil Madhavapeddy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1753">GPR#1753</a>:
avoid potential off-by-one overflow in debugger socket path
length
(Anil Madhavapeddy)</p>
</li>
</ul>
<h3>Tools:</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7643">MPR#7643</a>,
<a href="https://github.com/ocaml/ocaml/pull/1377">GPR#1377</a>:
<code>ocamldep</code>, fix an exponential blowup in presence of nested
structures and signatures
(e.g. <code>include struct … include(struct … end) … end</code>)
(Florian Angeletti, review by Gabriel Scherer, report by Christophe Raffalli)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7687">MPR#7687</a>,
<a href="https://github.com/ocaml/ocaml/pull/1653">GPR#1653</a>:
deprecate <code>-thread</code> option,
which is equivalent to <code>-I +threads</code>.
(Nicolás Ojeda Bär, report by Daniel Bünzli)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7710">MPR#7710</a>:
<code>ocamldep -sort</code> should exit with nonzero code in case of
cyclic dependencies
(Xavier Leroy, report by Mantis user baileyparker)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1537">GPR#1537</a>:
<code>boot/ocamldep</code> is no longer included in the source distribution;
<code>boot/ocamlc -depend</code> can be used in its place.
(Nicolás Ojeda Bär, review by Xavier Leroy and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1585">GPR#1585</a>:
optimize output of <code>ocamllex -ml</code>
(Alain Frisch, review by Frédéric Bour and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1667">GPR#1667</a>:
add command-line options <code>-no-propt</code>, <code>-no-version</code>, <code>-no-time</code>,
<code>-no-breakpoint</code> and <code>-topdirs-path</code> to ocamldebug
(Sébastien Hinderer, review by Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1695">GPR#1695</a>:
add the <code>-null-crc</code> command-line option to ocamlobjinfo.
(Sébastien Hinderer, review by David Allsopp and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1710">GPR#1710</a>:
ocamldoc, improve the 'man' rendering of subscripts and
superscripts.
(Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1771">GPR#1771</a>:
ocamdebug, avoid out of bound access
(Thomas Refis)</p>
</li>
</ul>
<h3>Manual and documentation:</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7613">MPR#7613</a>:
minor reword of the &quot;refutation cases&quot; paragraph
(Florian Angeletti, review by Jacques Garrigue)</p>
</li>
<li>
<p>PR#7647, <a href="https://github.com/ocaml/ocaml/pull/1384">GPR#1384</a>:
emphasize ocaml.org website and forum in README
(Yawar Amin, review by Gabriel Scherer)</p>
</li>
<li>
<p>PR#7698, <a href="https://github.com/ocaml/ocaml/pull/1545">GPR#1545</a>:
improve wording in OCaml manual in several places,
mostly in Chapter 1.  This addresses the easier changes suggested in
the PR.
(Jim Fehrle, review by Florian Angeletti and David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1540">GPR#1540</a>:
manual, decouple verbatim and toplevel style in code examples
(Florian Angeletti, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1556">GPR#1556</a>:
manual, add a consistency test for manual references inside
the compiler source code.
(Florian Angeletti, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1647">GPR#1647</a>:
manual, subsection on record and variant disambiguation
(Florian Angeletti, review by Alain Frisch and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1702">GPR#1702</a>:
manual, add a signature mode for code examples
(Florian Angeletti, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1741">GPR#1741</a>:
manual, improve typesetting and legibility in HTML output
(steinuil, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1757">GPR#1757</a>:
style the html manual, changing type and layout
(Charles Chamberlain, review by Florian Angeletti, Xavier Leroy,
Gabriel Radanne, Perry E. Metzger, and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1765">GPR#1765</a>:
manual, ellipsis in code examples
(Florian Angeletti, review and suggestion by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1767">GPR#1767</a>:
change html manual to use relative font sizes
(Charles Chamberlain, review by Daniel Bünzli, Perry E. Metzger,
Josh Berdine, and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1779">GPR#1779</a>:
integrate the Bigarray documentation into the main manual.
(Perry E. Metzger, review by Florian Angeletti and Xavier Clerc)</p>
</li>
</ul>
<h3>Type system:</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7611">MPR#7611</a>,
<a href="https://github.com/ocaml/ocaml/pull/1491">GPR#1491</a>:
reject the use of generative functors as applicative
(Valentin Gatien-Baron)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7706">MPR#7706</a>,
<a href="https://github.com/ocaml/ocaml/pull/1565">GPR#1565</a>:
in recursive value declarations, track
static size of locally-defined variables
(Gabriel Scherer, review by Jeremy Yallop and Leo White, report by Leo White)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7717">MPR#7717</a>,
<a href="https://github.com/ocaml/ocaml/pull/1593">GPR#1593</a>:
in recursive value declarations, don't treat
unboxed constructor size as statically known
(Jeremy Yallop, report by Pierre Chambart, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7767">MPR#7767</a>,
<a href="https://github.com/ocaml/ocaml/pull/1712">GPR#1712</a>:
restore legacy treatment of partially-applied
labeled functions in <code>let rec</code> bindings.
(Jeremy Yallop, report by Ivan Gotovchits, review by Gabriel Scherer)</p>
</li>
</ul>
<ul>
<li><a href="https://caml.inria.fr/mantis/view.php?id=7787">MPR#7787</a>,
<a href="https://github.com/ocaml/ocaml/pull/1652">GPR#1652</a>,
<a href="https://github.com/ocaml/ocaml/pull/1743">GPR#1743</a>:
Don't remove module aliases in <code>module type of</code>
and <code>with module</code>.
The old behaviour can be obtained using the <code>[@remove_aliases]</code>
attribute.
(Leo White and Thomas Refis, review by Jacques Garrigue)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1468">GPR#1468</a>:
Do not enrich type_decls with incoherent manifests
(Thomas Refis and Leo White, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1469">GPR#1469</a>:
Use the information from <code>[@@immediate]</code> annotations when
computing whether a type can be <code>[@@unboxed]</code>
(Damien Doligez, report by Stephan Muenzel, review by Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1513">GPR#1513</a>:
Allow compilation units to shadow sub-modules of <code>Pervasives</code>.
For instance users can now use a <code>largeFile.ml</code> file in their
project.
(Jérémie Dimino, review by Nicolas Ojeda Bar, Alain Frisch and Gabriel Radanne)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1516">GPR#1516</a>:
Allow <code>float array</code> construction in recursive bindings
when configured with <code>-no-flat-float-array</code>
(Jeremy Yallop, report by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1583">GPR#1583</a>:
propagate refined <code>ty_arg</code> to Parmatch checks
(Thomas Refis, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1609">GPR#1609</a>:
Changes to ambivalence scope tracking
(Thomas Refis and Leo White, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1628">GPR#1628</a>:
Treat <code>reraise</code> and <code>raise_notrace</code> as nonexpansive.
(Leo White, review by Alain Frisch)</p>
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/1778">GPR#1778</a>:
Fix Soundness bug with non-generalized type variable and
local modules.  This is the same bug as
<a href="https://caml.inria.fr/mantis/view.php?id=7414">MPR#7414</a>,
but using local modules instead of non-local ones.
(Leo White, review by Jacques Garrigue)
</li>
</ul>
<h3>Compiler distribution build system</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=5219">MPR#5219</a>,
<a href="https://github.com/ocaml/ocaml/pull/1680">GPR#1680</a>,
<a href="https://github.com/ocaml/ocaml/pull/1877">GPR#1877</a>:
use <code>install</code> instead of <code>cp</code> in install scripts.
(Gabriel Scherer, review by Sébastien Hinderer and Valentin Gatien-Baron)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7679">MPR#7679</a>:
make sure <code>.a</code> files are erased before calling <code>ar rc</code>, otherwise
leftover <code>.a</code> files from an earlier compilation may contain unwanted
modules
(Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1571">GPR#1571</a>:
do not perform architecture tests on 32-bit platforms, allowing
64-bit back-ends to use 64-bit specific constructs
(Xavier Clerc, review by Damien Doligez)</p>
</li>
</ul>
<h3>Internal/compiler-libs changes:</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7738">MPR#7738</a>,
<a href="https://github.com/ocaml/ocaml/pull/1624">GPR#1624</a>:
<code>Asmlink.reset</code> also resets <code>lib_ccobjs/ccopts</code>
(Cedric Cellier, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1488">GPR#1488</a>,
<a href="https://github.com/ocaml/ocaml/pull/1560">GPR#1560</a>:
Refreshing parmatch
(Gabriel Scherer and Thomas Refis, review by Luc Maranget)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1502">GPR#1502</a>:
more command line options for expect tests
(Florian Angeletti, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1511">GPR#1511</a>:
show code at error location in expect-style tests,
using new <code>Location.show_code_at_location</code> function
(Gabriel Scherer and Armaël Guéneau,
review by Valentin Gatien-Baron and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1519">GPR#1519</a>,
<a href="https://github.com/ocaml/ocaml/pull/1532">GPR#1532</a>,
GRP#1570: migrate tests to ocamltest
(Sébastien Hinderer, review by Gabriel Scherer, Valentin Gatien-Baron
and Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1520">GPR#1520</a>:
more robust implementation of <code>Misc.no_overflow_mul</code>
(Max Mouratov, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1557">GPR#1557</a>:
Organise and simplify translation of primitives
(Leo White, review by François Bobot and Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1567">GPR#1567</a>:
register all idents relevant for <code>reraise</code>
(Thomas Refis, review by Alain Frisch and Frédéric Bour)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1586">GPR#1586</a>:
testsuite: <code>make promote</code> for ocamltest tests
(The new <code>-promote</code> option for ocamltest is experimental
and subject to change/removal).
(Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1619">GPR#1619</a>:
expect_test: print all the exceptions, even the unexpected ones
(Thomas Refis, review by Jérémie Dimino)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1621">GPR#1621</a>:
expect_test: make sure to not use the installed stdlib
(Jérémie Dimino, review by Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1646">GPR#1646</a>:
add ocamldoc test to ocamltest and migrate ocamldoc tests to
ocamltest
(Florian Angeletti, review by Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1663">GPR#1663</a>:
refactor flambda specialise/inlining handling
(Leo White and Xavier Clerc, review by Pierre Chambart)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1679">GPR#1679</a>:
remove Pbittest from primitives in lambda
(Hugo Heuzard, review by Mark Shinwell)</p>
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/1704">GPR#1704</a>:
Make Ident.t abstract and immutable.
(Gabriel Radanne, review by Mark Shinwell)
</li>
</ul>
<h3>Bug fixes</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=4499">MPR#4499</a>,
<a href="https://github.com/ocaml/ocaml/pull/1479">GPR#1479</a>:
Use native Windows API to implement <code>Sys.getenv</code>,
<code>Unix.getenv</code> and <code>Unix.environment</code> under Windows.
(Nicolás Ojeda Bär, report by Alain Frisch, review by David Allsopp, Xavier
Leroy)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=5250">MPR#5250</a>,
<a href="https://github.com/ocaml/ocaml/pull/1435">GPR#1435</a>:
on Cygwin, when ocamlrun searches the path
for a bytecode executable file, skip directories and other
non-regular files, like other Unix variants do.
(Xavier Leroy)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=6394">MPR#6394</a>,
<a href="https://github.com/ocaml/ocaml/pull/1425">GPR#1425</a>:
fix <code>fatal_error</code> from <code>Parmatch.get_type_path</code>
(Virgile Prevosto, review by David Allsopp, Thomas Refis and Jacques Garrigue)</p>
</li>
</ul>
<ul>
<li><a href="https://caml.inria.fr/mantis/view.php?id=6604">MPR#6604</a>,
<a href="https://github.com/ocaml/ocaml/pull/931">GPR#931</a>:
Only allow directives with filename and at the beginning of
the line
(Tadeu Zagallo, report by Roberto Di Cosmo,
review by Hongbo Zhang, David Allsopp, Gabriel Scherer, Xavier Leroy)
</li>
</ul>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7138">MPR#7138</a>,
<a href="https://caml.inria.fr/mantis/view.php?id=7701">MPR#7701</a>,
<a href="https://github.com/ocaml/ocaml/pull/1693">GPR#1693</a>:
Keep documentation comments
even in empty structures and signatures
(Leo White, Florian Angeletti, report by Anton Bachin)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7178">MPR#7178</a>,
<a href="https://caml.inria.fr/mantis/view.php?id=7253">MPR#7253</a>,
<a href="https://caml.inria.fr/mantis/view.php?id=7796">MPR#7796</a>,
<a href="https://github.com/ocaml/ocaml/pull/1790">GPR#1790</a>:
Make sure a function
registered with <code>at_exit</code> is executed only once when the program
exits
(Nicolás Ojeda Bär and Xavier Leroy, review by Max Mouratov)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7391">MPR#7391</a>,
<a href="https://github.com/ocaml/ocaml/pull/1620">GPR#1620</a>:
Do not put a dummy method in object types
(Thomas Refis, review by Jacques Garrigue)</p>
</li>
<li>
<p>PR#7660, <a href="https://github.com/ocaml/ocaml/pull/1445">GPR#1445</a>:
Use native Windows API to implement <code>Unix.utimes</code> in order to
avoid unintended shifts of the argument timestamp depending on DST
setting.
(Nicolás Ojeda Bär, review by David Allsopp, Xavier Leroy)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7668">MPR#7668</a>:
<code>-principal</code> is broken with polymorphic variants
(Jacques Garrigue, report by Jun Furuse)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7680">MPR#7680</a>,
<a href="https://github.com/ocaml/ocaml/pull/1497">GPR#1497</a>:
Incorrect interaction between <code>Matching.for_let and</code>
<code>Simplif.simplify_exits</code>
(Alain Frisch, report and review by Vincent Laviron)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7682">MPR#7682</a>,
<a href="https://github.com/ocaml/ocaml/pull/1495">GPR#1495</a>:
fix <code>[@@unboxed]</code> for records with 1 polymorphic field
(Alain Frisch, report by Stéphane Graham-Lengrand, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7695">MPR#7695</a>,
<a href="https://github.com/ocaml/ocaml/pull/1541">GPR#1541</a>:
Fatal error: exception <code>Ctype.Unify(_)</code> with field override
(Jacques Garrigue, report by Nicolás Ojeda Bär)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7704">MPR#7704</a>,
<a href="https://github.com/ocaml/ocaml/pull/1564">GPR#1564</a>:
use proper variant tag in non-exhaustiveness warning
(Jacques Garrigue, report by Thomas Refis)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7711">MPR#7711</a>,
<a href="https://github.com/ocaml/ocaml/pull/1581">GPR#1581</a>:
Internal typechecker error triggered by a constraint on
self type in a class type
(Jacques Garrigue, report and review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7712">MPR#7712</a>,
<a href="https://github.com/ocaml/ocaml/pull/1576">GPR#1576</a>:
assertion failure with type abbreviations
(Thomas Refis, report by Michael O'Connor, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7747">MPR#7747</a>:
Type checker can loop infinitly and consumes all computer memory
(Jacques Garrigue, report by kantian)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7751">MPR#7751</a>,
<a href="https://github.com/ocaml/ocaml/pull/1657">GPR#1657</a>:
The toplevel prints some concrete types as abstract
(Jacques Garrigue, report by Matej Kosik)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7765">MPR#7765</a>,
<a href="https://github.com/ocaml/ocaml/pull/1718">GPR#1718</a>:
When unmarshaling bigarrays, protect against integer
overflows in size computations
(Xavier Leroy, report by Maximilian Tschirschnitz,
review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7760">MPR#7760</a>,
<a href="https://github.com/ocaml/ocaml/pull/1713">GPR#1713</a>:
Exact selection of lexing engine, that is
correct &quot;Segfault in ocamllex-generated code using 'shortest'&quot;
(Luc Maranget, Frédéric Bour, report by Stephen Dolan,
review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7769">MPR#7769</a>,
<a href="https://github.com/ocaml/ocaml/pull/1714">GPR#1714</a>:
calls to Stream.junk could, under some conditions, be
ignored when used on streams based on input channels.
(Nicolás Ojeda Bär, report by Michael Perin, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7793">MPR#7793</a>,
<a href="https://github.com/ocaml/ocaml/pull/1766">GPR#1766</a>:
the toplevel <code>#use</code> directive now accepts sequences of <code>;;</code>
tokens. This fixes a bug in which certain files accepted by the compiler were
rejected by ocamldep.
(Nicolás Ojeda Bär, report by Hugo Heuzard, review by Hugo Heuzard)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1517">GPR#1517</a>:
More robust handling of type variables in mcomp
(Leo White and Thomas Refis, review by Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1530">GPR#1530</a>,
<a href="https://github.com/ocaml/ocaml/pull/1574">GPR#1574</a>:
testsuite, fix <code>make parallel</code> and <code>make one DIR=...</code>
to work on ocamltest-based tests.
(Runhang Li and Sébastien Hinderer, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1550">GPR#1550</a>,
<a href="https://github.com/ocaml/ocaml/pull/1555">GPR#1555</a>:
Make pattern matching warnings more robust
to ill-typed columns
(Thomas Refis, with help from Gabriel Scherer and Luc Maranget)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1614">GPR#1614</a>:
consider all bound variables when inlining, fixing a compiler
fatal error.
(Xavier Clerc, review by Pierre Chambart, Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1622">GPR#1622</a>:
fix bug in the expansion of command-line arguments under Windows
which could result in some elements of Sys.argv being truncated in
some cases.
(Nicolás Ojeda Bär, review by Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1623">GPR#1623</a>:
Segfault on Windows 64 bits when expanding wildcards in arguments.
(Marc Lasson, review by David Allsopp, Alain Frisch, Sébastien Hinderer,
Xavier Leroy, Nicolas Ojeda Bar)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1661">GPR#1661</a>:
more precise principality warning regarding record fields
disambiguation
(Thomas Refis, review by Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1687">GPR#1687</a>:
fix bug in the printing of short functor types <code>(S1 -&gt; S2) -&gt; S3</code>
(Pieter Goetschalckx, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1722">GPR#1722</a>:
Scrape types in <code>Typeopt.maybe_pointer</code>
(Leo White, review by Thomas Refis)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1755">GPR#1755</a>:
ensure that a bigarray is never collected while reading complex
values
(Xavier Clerc, Mark Shinwell and Leo White, report by Chris Hardin,
reviews by Stephen Dolan and Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1764">GPR#1764</a>:
in <code>byterun/memory.c</code>, <code>struct pool_block</code>, use C99 flexible arrays
if available
(Xavier Leroy, review by Max Mouratov)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1774">GPR#1774</a>:
ocamlopt for ARM could generate VFP loads and stores with bad
offsets, rejected by the assembler.
(Xavier Leroy, review by Mark Shinwell)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1808">GPR#1808</a>:
handle <code>[@inlined]</code> attributes under a module constraint
(Xavier Clerc, review by Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1810">GPR#1810</a>:
use bit-pattern comparison when meeting float approximations
(Xavier Clerc, report by Christophe Troestler, review by Nicolás Ojeda Bär
and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1835">GPR#1835</a>:
Fix off-by-one errors in <code>Weak.get_copy</code> and <code>Weak.blit</code>
(KC Sivaramakrishnan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1849">GPR#1849</a>:
bug in runtime function <code>generic_final_minor_update()</code>
that could lead to crashes when <code>Gc.finalise_last</code> is used
(report and fix by Yuriy Vostrikov, review by François Bobot)</p>
</li>
</ul>
|js}
  };
 
  { kind = `Compiler
  ; version = {js|4.06.0|js}
  ; date = {js|2017-11-03|js}
  ; intro_md = {js|This page describes OCaml version **4.06.0**, released on 2017-11-03. 
|js}
  ; intro_html = {js|<p>This page describes OCaml version <strong>4.06.0</strong>, released on 2017-11-03.</p>
|js}
  ; highlights_md = {js|- Strings (type `string`) are now immutable by default. In-place
  modification must use the type `bytes` of byte sequences, which is
  distinct from `string`.  This corresponds to the `-safe-string`
  compile-time option, which was introduced in OCaml 4.02 in 2014, and
  which is now the default.
- Object types can now extend a previously-defined object type, as in
  `<t; a: int>`.
- Destructive substitution over module signatures can now express more
  substitutions, such as `S with type M.t := type-expr`
  and `S with module M.N := path`.
- Users can now define operators that look like array indexing, e.g.
  `let ( .%() ) = List.nth in [0; 1; 2].%(1)`
- New escape `\\u{XXXX}` in string literals, denoting the UTF-8
  encoding of the Unicode code point `XXXX`.
- Full Unicode support was added to the Windows runtime system.  In
  particular, file names can now contain Unicode characters.
- An alternate register allocator based on linear scan can be selected
  with `ocamlopt -linscan`.  It reduces compilation time compared with
  the default register allocator.
- The Num library for arbitrary-precision integer and rational
  arithmetic is no longer part of the core distribution and can be
  found as a separate OPAM package.
|js}
  ; highlights_html = {js|<ul>
<li>Strings (type <code>string</code>) are now immutable by default. In-place
modification must use the type <code>bytes</code> of byte sequences, which is
distinct from <code>string</code>.  This corresponds to the <code>-safe-string</code>
compile-time option, which was introduced in OCaml 4.02 in 2014, and
which is now the default.
</li>
<li>Object types can now extend a previously-defined object type, as in
<code>&lt;t; a: int&gt;</code>.
</li>
<li>Destructive substitution over module signatures can now express more
substitutions, such as <code>S with type M.t := type-expr</code>
and <code>S with module M.N := path</code>.
</li>
<li>Users can now define operators that look like array indexing, e.g.
<code>let ( .%() ) = List.nth in [0; 1; 2].%(1)</code>
</li>
<li>New escape <code>\\u{XXXX}</code> in string literals, denoting the UTF-8
encoding of the Unicode code point <code>XXXX</code>.
</li>
<li>Full Unicode support was added to the Windows runtime system.  In
particular, file names can now contain Unicode characters.
</li>
<li>An alternate register allocator based on linear scan can be selected
with <code>ocamlopt -linscan</code>.  It reduces compilation time compared with
the default register allocator.
</li>
<li>The Num library for arbitrary-precision integer and rational
arithmetic is no longer part of the core distribution and can be
found as a separate OPAM package.
</li>
</ul>
|js}
  ; body_md = {js|
Opam Switches
-------------

This release is available as multiple
[OPAM](https://opam.ocaml.org/doc/Usage.html) switches:

- 4.06.0 — Official 4.06.0 release
- 4.06.0+afl — Official 4.06.0 release with afl-fuzz instrumentation
- 4.06.0+default-unsafe-string — Official 4.06.0 release without safe
  strings by default
- 4.06.0+flambda — Official 4.06.0 release with flambda activated
- 4.06.0+force-safe-string — Official 4.06.0 release with -safe-string enabled.
- 4.06.0+fp — Official 4.06.0 release with frame-pointers
- 4.06.0+fp+flambda — Official 4.06.0 release with frame-pointers and
  flambda activated

What's new
----------

Some of the highlights in release 4.06 are:

- Strings (type `string`) are now immutable by default. In-place
  modification must use the type `bytes` of byte sequences, which is
  distinct from `string`.  This corresponds to the `-safe-string`
  compile-time option, which was introduced in OCaml 4.02 in 2014, and
  which is now the default.

- Object types can now extend a previously-defined object type, as in
  `<t; a: int>`.

- Destructive substitution over module signatures can now express more
  substitutions, such as `S with type M.t := type-expr`
  and `S with module M.N := path`.

- Users can now define operators that look like array indexing, e.g.
  `let ( .%() ) = List.nth in [0; 1; 2].%(1)`

- New escape `\\u{XXXX}` in string literals, denoting the UTF-8
  encoding of the Unicode code point `XXXX`.

- Full Unicode support was added to the Windows runtime system.  In
  particular, file names can now contain Unicode characters.

- An alternate register allocator based on linear scan can be selected
  with `ocamlopt -linscan`.  It reduces compilation time compared with
  the default register allocator.

- The Num library for arbitrary-precision integer and rational
  arithmetic is no longer part of the core distribution and can be
  found as a separate OPAM package.


For a comprehensive list of changes and details on all new features,
bug fixes, optimizations, etc., please consult the
[changelog](#Changes).


Source distribution
---------------------------------------------

- [Source
  tarball](https://github.com/ocaml/ocaml/archive/4.06.0.tar.gz)
  (.tar.gz) for compilation under Unix (including Linux and MacOS X)
  and Microsoft Windows (including Cygwin).
- Also available in
  [.zip](https://github.com/ocaml/ocaml/archive/4.06.0.zip)
  format.
- [OPAM](https://opam.ocaml.org/) is a source-based distribution of
  OCaml and many companion libraries and tools. Compilation and
  installation are automated by powerful package managers.
- The official development repo is hosted on
  [GitHub](https://github.com/ocaml/ocaml).

The
[INSTALL](4.06/notes/INSTALL.adoc) file
of the distribution provides detailed compilation and installation
instructions -- see also the [Windows release
notes](4.06/notes/README.win32.adoc) for
instructions on how to build under Windows.

Alternative Compilers
---------------------

Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:

* [Js_of_ocaml](http://ocsigen.org/js_of_ocaml/) is a stable OCaml
  to JavaScript compiler.
* [Bucklescript](http://bucklescript.github.io/bucklescript/) is a
  newer OCaml to JavaScript compiler. See its
  [wiki](https://github.com/bucklescript/bucklescript/wiki/Differences-from-js_of_ocaml) for
  an explanation of how it differs from js_of_ocaml.
* [OCaml-java](http://www.ocamljava.org/) is a stable OCaml to
  Java compiler.

User's manual
------------------------------------

The user's manual for OCaml can be:

- [browsed
  online](4.06/htmlman/index.html),
- downloaded as a single
  [PostScript](4.06/ocaml-4.06-refman.ps.gz),
  [PDF](4.06/ocaml-4.06-refman.pdf),
  or [plain
  text](4.06/ocaml-4.06-refman.txt)
  document,
- downloaded as a single
  [TAR](4.06/ocaml-4.06-refman-html.tar.gz)
  or
  [ZIP](4.06/ocaml-4.06-refman-html.zip)
  archive of HTML files,
- downloaded as a single
  [tarball](4.06/ocaml-4.06-refman.info.tar.gz)
  of Emacs info files,


Changes
-------

This is the
[changelog](4.06/notes/Changes).

(Changes that can break existing programs are marked with a "*")

### Language features:

- [MPR#6271](https://caml.inria.fr/mantis/view.php?id=6271),
  [MPR#7529](https://caml.inria.fr/mantis/view.php?id=7529),
  [GPR#1249](https://github.com/ocaml/ocaml/pull/1249):
  Support `let open M in ...`
  in class expressions and class type expressions.  
  (Alain Frisch, reviews by Thomas Refis and Jacques Garrigue)

- [GPR#792](https://github.com/ocaml/ocaml/pull/792):
  fix limitations of destructive substitutions, by
  allowing `S with type t := type-expr`,
  `S with type M.t := type-expr`, `S with module M.N := path`.  
  (Valentin Gatien-Baron, review by Jacques Garrigue and Leo White)

* [GPR#1064](https://github.com/ocaml/ocaml/pull/1064),
  [GPR#1392](https://github.com/ocaml/ocaml/pull/1392):
  extended indexing operators, add a new class of
  user-defined indexing operators, obtained by adding at least one
  operator character after the dot symbol to the standard indexing
  operators: e,g `.%()`, `.?[]`, `.@{}<-`:
  
    ```ocaml
    let ( .%() ) = List.nth in
	[0; 1; 2].%(1)
    ```

  After this change, functions or methods with an explicit polymorphic type
  annotation and of which the first argument is optional now requires a space
  between the dot and the question mark,
  e.g. `<f:'a.?opt:int->unit>` must now be written
  `<f:'a. ?opt:int->unit>`.  
  (Florian Angeletti, review by Damien Doligez and Gabriel Radanne)

- [GPR#1118](https://github.com/ocaml/ocaml/pull/1118):
  Support inherited field in object type expression

    ```ocaml
    type t = < m : int >
    type u = < n : int; t; k : int >
    ```

   (Runhang Li, reivew by Jeremy Yallop, Leo White, Jacques Garrigue,
   and Florian Angeletti)

* [GPR#1232](https://github.com/ocaml/ocaml/pull/1232):
  Support Unicode character escape sequences in string
  literals via the `\\u{X+}` syntax. These escapes are substituted by the
  UTF-8 encoding of the Unicode character.  
  (Daniel Bünzli, review by Damien Doligez, Alain Frisch, Xavier
  Leroy and Leo White)

- [GPR#1247](https://github.com/ocaml/ocaml/pull/1247):
  `M.(::)` construction for expressions
  and patterns (plus fix printing of (::) in the toplevel)  
  (Florian Angeletti, review by Alain Frisch, Gabriel Scherer)

* [GPR#1252](https://github.com/ocaml/ocaml/pull/1252):
  The default mode is now safe-string, can be overridden
  at configure time or at compile time.
  (See [GPR#1386](https://github.com/ocaml/ocaml/pull/1386)
  below for the configure-time options)
  This breaks the code that uses the `string` type as mutable
  strings (instead of `Bytes.t`, introduced by 4.02 in 2014).  
  (Damien Doligez)

* [GPR#1253](https://github.com/ocaml/ocaml/pull/1253):
  Private extensible variants
  This change breaks code relying on the undocumented ability to export
  extension constructors for abstract type in signature. Briefly,

    ```ocaml
    module type S = sig
      type t
      type t += A
    end
    ```

	must now be written
	
    ```ocaml
    module type S = sig
      type t = private ..
      type t += A
    end
    ```

    (Leo White, review by Alain Frisch)

- [GPR#1333](https://github.com/ocaml/ocaml/pull/1333):
  turn off warning 40 by default
  (Constructor or label name used out of scope)  
  (Leo White)

- [GPR#1348](https://github.com/ocaml/ocaml/pull/1348):
  accept anonymous type parameters in `with` constraints:
  `S with type _ t = int`.  
  (Valentin Gatien-Baron, report by Jeremy Yallop)

### Type system

- [MPR#248](https://caml.inria.fr/mantis/view.php?id=248),
  [GPR#1225](https://github.com/ocaml/ocaml/pull/1225):
  unique names for weak type variables

    ```ocaml
    # ref [];;
    - : '__weak1 list ref = {contents = []}
    ```

<!-- FIXME: Double underscore because omd treats the first as "lower" -->
   (Florian Angeletti, review by Frédéric Bour, Jacques Garrigue,
   Gabriel Radanne and Gabriel Scherer)

* [MPR#6738](https://caml.inria.fr/mantis/view.php?id=6738),
  [MPR#7215](https://caml.inria.fr/mantis/view.php?id=7215),
  [MPR#7231](https://caml.inria.fr/mantis/view.php?id=7231),
  [GPR#556](https://github.com/ocaml/ocaml/pull/556):
  Add a new check that `let rec`
  bindings are well formed.  
  (Jeremy Yallop, reviews by Stephen Dolan, Gabriel Scherer, Leo
   White, and Damien Doligez)

- [GPR#1142](https://github.com/ocaml/ocaml/pull/1142):
  Mark assertions nonexpansive, so that `assert false`
  can be used as a placeholder for a polymorphic function.  
  (Stephen Dolan)

### Standard library:

- [MPR#1771](https://caml.inria.fr/mantis/view.php?id=1771),
  [MPR#7309](https://caml.inria.fr/mantis/view.php?id=7309),
  [GPR#1026](https://github.com/ocaml/ocaml/pull/1026):
  Add update to maps. Allows to update a
  binding in a map or create a new binding if the key had no binding
  
    ```ocaml
    val update: key -> ('a option -> 'a option) -> 'a t -> 'a t
    ```

  (Sébastien Briais, review by Daniel Buenzli, Alain Frisch and
  Gabriel Scherer)

- [MPR#7515](https://caml.inria.fr/mantis/view.php?id=7515),
  [GPR#1147](https://github.com/ocaml/ocaml/pull/1147):
  `Arg.align` now optionally uses the tab
  character `'\\t'` to separate the "unaligned" and "aligned" parts of
  the documentation string. If tab is not present, then space is used
  as a fallback. Allows to have spaces in the unaligned part, which is
  useful for Tuple options.  (Nicolas Ojeda Bar, review by Alain
  Frisch and Gabriel Scherer)

* [GPR#615](https://github.com/ocaml/ocaml/pull/615):
  Format, add symbolic formatters that output symbolic
  pretty-printing items.  New fields have been added to the
  `formatter_out_functions` record, thus this change will break any code
  building such record from scratch.  When building
  `Format.formatter_out_functions` values redefinining the
  `out_spaces` field, `{ fmt_out_funs with out_spaces = f; }` should
  be replaced by `{ fmt_out_funs with out_spaces = f; out_indent = f; }`
  to maintain the old behavior.  
  (Richard Bonichon and Pierre Weis, review by Alain Frisch, original
  request by Spiros Eliopoulos in
  [GPR#506](https://github.com/ocaml/ocaml/pull/506))

* [GPR#943](https://github.com/ocaml/ocaml/pull/943):
  Fixed the divergence of the Pervasives module between the
  stdlib and threads implementations.  In rare circumstances this can
  change the behavior of existing applications: the implementation of
  `Pervasives.close_out` used when compiling with thread support was
  inconsistent with the manual.  It will now not suppress exceptions
  escaping `Pervasives.flush` anymore.  Developers who want the old
  behavior should use `Pervasives.close_out_noerr` instead.  The stdlib
  implementation, used by applications not compiled with thread
  support, will now only suppress `Sys_error` exceptions in
  `Pervasives.flush_all`.  This should allow exceedingly unlikely
  assertion exceptions to escape, which could help reveal bugs in the
  standard library.  
  (Markus Mottl, review by Hezekiah M. Carty, Jeremie Dimino, Damien
  Doligez, Alain Frisch, Xavier Leroy, Gabriel Scherer and Mark
  Shinwell)

- [GPR#1034](https://github.com/ocaml/ocaml/pull/1034):
  `List.init : int -> (int -> 'a) -> 'a list`  
  (Richard Degenne, review by David Allsopp, Thomas Braibant, Florian
  Angeletti, Gabriel Scherer, Nathan Moreau, Alain Frisch)

- GRP#1091 Add the `Uchar.{bom,rep}` constants.  
  (Daniel Bünzli, Alain Frisch)

- [GPR#1091](https://github.com/ocaml/ocaml/pull/1091):
  Add `Buffer.add_utf_{8,16le,16be}_uchar` to encode `Uchar.t`
  values to the corresponding UTF-X transformation formats in `Buffer.t`
  values.  
  (Daniel Bünzli, review by Damien Doligez, Max Mouratov)

- [GPR#1175](https://github.com/ocaml/ocaml/pull/1175):
  Bigarray, add a `change_layout` function to each Array[N]
  submodules.  
  (Florian Angeletti)

* [GPR#1306](https://github.com/ocaml/ocaml/pull/1306):
  In the MSVC and Mingw ports, `Sys.rename src dst` no
  longer fails if file `dst` exists, but replaces it with file `src`,
  like in the other ports.  
  (Xavier Leroy)

- [GPR#1314](https://github.com/ocaml/ocaml/pull/1314):
  Format, use the optional width information
  when formatting a boolean: `"%8B", "%-8B"` for example  
  (Xavier Clerc, review by Gabriel Scherer)

- [c9cc0f25138ce58e4f4e68c4219afe33e2a9d034](https://github.com/ocaml/ocaml/commit/c9cc0f25138ce58e4f4e68c4219afe33e2a9d034):
  Resurrect tabulation boxes
  in module Format. Rewrite/extend documentation of tabulation boxes.  
  (Pierre Weis)

### Other libraries:

- [MPR#7564](https://caml.inria.fr/mantis/view.php?id=7564), [GPR#1211](https://github.com/ocaml/ocaml/pull/1211): Allow forward slashes in the target of symbolic links
  created by `Unix.symlink` under Windows.
  (Nicolas Ojeda Bar, review by David Allsopp)

* [MPR#7640](https://caml.inria.fr/mantis/view.php?id=7640), [GPR#1414](https://github.com/ocaml/ocaml/pull/1414): reimplementation of `Unix.execvpe` to fix issues
  with the 4.05 implementation.  The main issue is that the current
  directory was always searched (last), even if the current directory
  is not listed in the PATH.  
  (Xavier Leroy, report by Louis Gesbert and Arseniy Alekseyev,
   review by Ivan Gotovchits)

- [GPR#997](https://github.com/ocaml/ocaml/pull/997), [GPR#1077](https://github.com/ocaml/ocaml/pull/1077): Deprecate `Bigarray.*.map_file` and add
  `Unix.map_file` as a first step towards moving Bigarray to the stdlib  
  (Jérémie Dimino and Xavier Leroy)

* [GPR#1178](https://github.com/ocaml/ocaml/pull/1178): remove the Num library for arbitrary-precision arithmetic.
  It now lives as a separate project https://github.com/ocaml/num
  with an OPAM package called `num`.  
  (Xavier Leroy)

- [GPR#1217](https://github.com/ocaml/ocaml/pull/1217): Restrict `Unix.environment` in privileged contexts; add
  `Unix.unsafe_environment`.  
  (Jeremy Yallop, review by Mark Shinwell, Nicolas Ojeda Bar,
  Damien Doligez and Hannes Mehnert)

- [GPR#1321](https://github.com/ocaml/ocaml/pull/1321): Reimplement `Unix.isatty` on Windows. It no longer returns
  true for the null device.  
  (David Allsopp)

### Compiler user-interface and warnings:

- [MPR#7361](https://caml.inria.fr/mantis/view.php?id=7361), [GPR#1248](https://github.com/ocaml/ocaml/pull/1248): support `ocaml.warning` in all attribute
  contexts, and arrange so that `ocaml.ppwarning` is correctly scoped
  by surrounding `ocaml.warning` attributes.  
  (Alain Frisch, review by Florian Angeletti and Thomas Refis)

- [MPR#7444](https://caml.inria.fr/mantis/view.php?id=7444), [GPR#1138](https://github.com/ocaml/ocaml/pull/1138): trigger deprecation warning when a "deprecated"
  attribute is hidden by signature coercion.  
  (Alain Frisch, report by bmillwood, review by Leo White)

- [MPR#7472](https://caml.inria.fr/mantis/view.php?id=7472): ensure `.cmi` files are created atomically,
  to avoid corruption of `.cmi` files produced simultaneously by a run
  of ocamlc and a run of ocamlopt.  
  (Xavier Leroy, from a suggestion by Gerd Stolpmann)

* [MPR#7514](https://caml.inria.fr/mantis/view.php?id=7514), [GPR#1152](https://github.com/ocaml/ocaml/pull/1152): add `-dprofile` option, similar to `-dtimings` but
  also displays memory allocation and consumption.
  The corresponding addition of a new compiler-internal
  Profile module may affect some users of
  compilers-libs/ocamlcommon (by creating module conflicts).  
  (Valentin Gatien-Baron, report by Gabriel Scherer)

- [MPR#7620](https://caml.inria.fr/mantis/view.php?id=7620), [GPR#1317](https://github.com/ocaml/ocaml/pull/1317): `Typecore.force_delayed_checks` does not run
  with `-i` option.  
  (Jacques Garrigue, report by Jun Furuse)

- [MPR#7624](https://caml.inria.fr/mantis/view.php?id=7624): handle warning attributes placed on let bindings.  
  (Xavier Clerc, report by dinosaure, review by Alain Frisch)

- [GPR#896](https://github.com/ocaml/ocaml/pull/896): `-compat-32` is now taken into account when building
  `.cmo`/`.cma`.  
  (Hugo Heuzard)

- [GPR#948](https://github.com/ocaml/ocaml/pull/948): the compiler now reports warnings-as-errors by prefixing
  them with "Error (warning ..):", instead of "Warning ..:" and
  a trailing "Error: Some fatal warnings were triggered" message.  
  (Valentin Gatien-Baron, review by Alain Frisch)

- [GPR#1032](https://github.com/ocaml/ocaml/pull/1032): display the output of `-dtimings` as a hierarchy.  
  (Valentin Gatien-Baron, review by Gabriel Scherer)

- [GPR#1114](https://github.com/ocaml/ocaml/pull/1114), [GPR#1393](https://github.com/ocaml/ocaml/pull/1393), [GPR#1429](https://github.com/ocaml/ocaml/pull/1429): refine the (`ocamlc -config`)
  information on C compilers: the variables
  `{bytecode,native}_c_compiler` are deprecated (the distinction is
  now mostly meaningless) in favor of a single `c_compiler` variable
  combined with `ocaml{c,opt}_cflags` and `ocaml{c,opt}_cppflags`.  
  (Sébastien Hinderer, Jeremy Yallop, Gabriel Scherer, review by
  Adrien Nader and David Allsopp)

* [GPR#1189](https://github.com/ocaml/ocaml/pull/1189): allow MSVC ports to use `-l` option in `ocamlmklib`.  
  (David Allsopp)

- [GPR#1332](https://github.com/ocaml/ocaml/pull/1332): fix ocamlc handling of `-output-complete-obj`.  
  (François Bobot)

- [GPR#1336](https://github.com/ocaml/ocaml/pull/1336): `-thread` and `-vmthread` option information is propagated to
  PPX rewriters.  
  (Jun Furuse, review by Alain Frisch)

### Code generation and optimizations:

- [MPR#5324](https://caml.inria.fr/mantis/view.php?id=5324), [GPR#375](https://github.com/ocaml/ocaml/pull/375): An alternative Linear Scan register allocator for
  ocamlopt, activated with the `-linscan` command-line flag.  This
  allocator represents a trade-off between worse generated code
  performance for higher compilation speed (especially interesting in
  some cases graph coloring is necessarily quadratic).  
  (Marcell Fischbach and Benedikt Meurer, adapted by Nicolas Ojeda
  Bar, review by Nicolas Ojeda Bar and Alain Frisch)

- [MPR#6927](https://caml.inria.fr/mantis/view.php?id=6927), [GPR#988](https://github.com/ocaml/ocaml/pull/988): On macOS, when compiling bytecode stubs, plugins,
  and shared libraries through `-output-obj`, generate dylibs instead of
  bundles.  
  (whitequark)

- [MPR#7447](https://caml.inria.fr/mantis/view.php?id=7447), [GPR#995](https://github.com/ocaml/ocaml/pull/995): incorrect code generation for nested recursive
  bindings.  
  (Leo White and Jeremy Yallop, report by Stephen Dolan)

- [MPR#7501](https://caml.inria.fr/mantis/view.php?id=7501), [GPR#1089](https://github.com/ocaml/ocaml/pull/1089): Consider arrays of length zero as constants
  when using Flambda.  
  (Pierre Chambart, review by Mark Shinwell and Leo White)

- [MPR#7531](https://caml.inria.fr/mantis/view.php?id=7531), [GPR#1162](https://github.com/ocaml/ocaml/pull/1162): Erroneous code transformation at partial
  applications.  
  (Mark Shinwell)

- [MPR#7614](https://caml.inria.fr/mantis/view.php?id=7614), [GPR#1313](https://github.com/ocaml/ocaml/pull/1313): Ensure that inlining does not depend on the order
  of symbols (flambda).  
  (Leo White, Xavier Clerc, report by Alex, review by Gabriel Scherer
  and Pierre Chambart)

- [MPR#7616](https://caml.inria.fr/mantis/view.php?id=7616), [GPR#1339](https://github.com/ocaml/ocaml/pull/1339): don't warn on mutation of zero size blocks.  
  (Leo White)

- [MPR#7631](https://caml.inria.fr/mantis/view.php?id=7631), [GPR#1355](https://github.com/ocaml/ocaml/pull/1355): `-linscan` option crashes ocamlopt.  
  (Xavier Clerc, report by Paul Steckler)

- [MPR#7642](https://caml.inria.fr/mantis/view.php?id=7642), [GPR#1411](https://github.com/ocaml/ocaml/pull/1411): ARM port: wrong register allocation for integer
  multiply on ARMv4 and ARMv5; possible wrong register allocation for
  floating-point multiply and add on VFP and for floating-point
  negation and absolute value on soft FP emulation.  
  (Xavier Leroy, report by Stéphane Glondu and Ximin Luo,
   review and additional sightings by Mark Shinwell)

* [GPR#659](https://github.com/ocaml/ocaml/pull/659): Remove support for SPARC native code generation.  
  (Mark Shinwell)

- [GPR#850](https://github.com/ocaml/ocaml/pull/850): Optimize away some physical equality.  
  (Pierre Chambart, review by Mark Shinwell and Leo White)

- [GPR#856](https://github.com/ocaml/ocaml/pull/856): Register availability analysis.  
  (Mark Shinwell, Thomas Refis, review by Pierre Chambart)

- [GPR#1143](https://github.com/ocaml/ocaml/pull/1143): tweaked several allocation functions in the runtime by
  checking for likely conditions before unlikely ones and eliminating
  some redundant checks.  
  (Markus Mottl, review by Alain Frisch, Xavier Leroy, Gabriel Scherer,
  Mark Shinwell and Leo White)

- [GPR#1183](https://github.com/ocaml/ocaml/pull/1183): compile curried functors to multi-argument functions
  earlier in the compiler pipeline; correctly propagate `[@@inline]`
  attributes on such functors; mark functor coercion veneers as
  stubs.  
  (Mark Shinwell, review by Pierre Chambart and Leo White)

- [GPR#1195](https://github.com/ocaml/ocaml/pull/1195): Merge functions based on partiality rather than
  `Parmatch.irrefutable`.
  (Leo White, review by Thomas Refis, Alain Frisch and Gabriel Scherer)

- [GPR#1215](https://github.com/ocaml/ocaml/pull/1215): Improve compilation of short-circuit operators
  (Leo White, review by Frédéric Bour and Mark Shinwell)

- [GPR#1250](https://github.com/ocaml/ocaml/pull/1250): illegal ARM64 assembly code generated for large combined
  allocations.  
  (report and initial fix by Steve Walk, review and final fix by
  Xavier Leroy)

- [GPR#1271](https://github.com/ocaml/ocaml/pull/1271): Don't generate Ialloc instructions for closures that exceed
  `Max_young_wosize`; instead allocate them on the major heap.  (Related
  to [GPR#1250](https://github.com/ocaml/ocaml/pull/1250).)  
  (Mark Shinwell)

- [GPR#1294](https://github.com/ocaml/ocaml/pull/1294): Add a configure-time option to remove the dynamic float array
  optimization and add a floatarray type to let the user choose when to
  flatten float arrays. Note that float-only records are unchanged: they
  are still optimized by unboxing their fields.  
  (Damien Doligez, review by Alain Frisch and Mark Shinwell)

- [GPR#1304](https://github.com/ocaml/ocaml/pull/1304): Mark registers clobbered by PLT stubs as destroyed across
  allocations.  
  (Mark Shinwell, Xavier Clerc, report and initial debugging by
  Valentin Gatien-Baron)

- [GPR#1323](https://github.com/ocaml/ocaml/pull/1323): make sure that frame tables are generated in the data
  section and not in the read-only data section, as was the case
  before in the PPC and System-Z ports.  This avoids relocations in
  the text segment of shared libraries and position-independent
  executables generated by ocamlopt.  
  (Xavier Leroy, review by Mark Shinwell)

- [GPR#1330](https://github.com/ocaml/ocaml/pull/1330): when generating dynamically-linkable code on AArch64, always
  reference symbols (even locally-defined ones) through the GOT.  
  (Mark Shinwell, review by Xavier Leroy)

### Tools:

- [MPR#1956](https://caml.inria.fr/mantis/view.php?id=1956), [GPR#973](https://github.com/ocaml/ocaml/pull/973): tools/check-symbol-names checks for globally
  linked names not namespaced with `caml_`.
  (Stephen Dolan)

- [MPR#6928](https://caml.inria.fr/mantis/view.php?id=6928), [GPR#1103](https://github.com/ocaml/ocaml/pull/1103): ocamldoc, do not introduce an empty `<h1>` in
  `index.html` when no `-title` has been provided.  
  (Pierre Boutillier)

- [MPR#7048](https://caml.inria.fr/mantis/view.php?id=7048): ocamldoc, in `-latex` mode, don't escape Latin-1 accented
  letters.  
  (Xavier Leroy, report by Hugo Herbelin)

* [MPR#7351](https://caml.inria.fr/mantis/view.php?id=7351): ocamldoc, use semantic tags rather than `<br>` tags in the html
  backend.  
  (Florian Angeletti, request and review by Daniel Bünzli )

* [MPR#7352](https://caml.inria.fr/mantis/view.php?id=7352), [MPR#7353](https://caml.inria.fr/mantis/view.php?id=7353): ocamldoc, better paragraphs in html output.  
  (Florian Angeletti, request by Daniel Bünzli)

* [MPR#7363](https://caml.inria.fr/mantis/view.php?id=7363), [GPR#830](https://github.com/ocaml/ocaml/pull/830): ocamldoc, start heading levels at `{1` not `{2` or `{6`.
  This change modifies the mapping between ocamldoc heading level and
  html heading level, breaking custom css style for ocamldoc.  
  (Florian Angeletti, request and review by Daniel Bünzli)

* [MPR#7478](https://caml.inria.fr/mantis/view.php?id=7478), [GPR#1037](https://github.com/ocaml/ocaml/pull/1037): ocamldoc, do not use as a module preamble documentation
  comments that occur after the first module element. This change may break
  existing documentation. In particular, module preambles must now come before
  any `open` statement.  
  (Florian Angeletti, review by David Allsopp and report by Daniel Bünzli)

- [MPR#7521](https://caml.inria.fr/mantis/view.php?id=7521), [GPR#1159](https://github.com/ocaml/ocaml/pull/1159): ocamldoc, end generated latex file with a new
  line.  
  (Florian Angeletti)

- [MPR#7575](https://caml.inria.fr/mantis/view.php?id=7575), [GPR#1219](https://github.com/ocaml/ocaml/pull/1219): Switch compilers from `-no-keep-locs`
  to `-keep-locs` by default: produced `.cmi` files will contain locations.
  This provides better error messages. Note that, as a consequence,
  `.cmi` digests now depend on the file path as given to the
  compiler.  
  (Daniel Bünzli)

- [MPR#7610](https://caml.inria.fr/mantis/view.php?id=7610), [GPR#1346](https://github.com/ocaml/ocaml/pull/1346): `caml.el` (the Emacs editing mode) was cleaned up
  and made compatible with Emacs 25.  
  (Stefan Monnier, Christophe Troestler)

- [MPR#7635](https://caml.inria.fr/mantis/view.php?id=7635), [GPR#1383](https://github.com/ocaml/ocaml/pull/1383): ocamldoc, add an identifier to module
  and module type elements.  
  (Florian Angeletti, review by Yawar Amin and Gabriel Scherer)

- [GPR#681](https://github.com/ocaml/ocaml/pull/681), [GPR#1426](https://github.com/ocaml/ocaml/pull/1426): Introduce ocamltest, a new test driver for the
  OCaml compiler testsuite.  
  (Sébastien Hinderer, review by Damien Doligez)

- [GPR#1012](https://github.com/ocaml/ocaml/pull/1012): ocamlyacc, fix parsing of raw strings and nested comments,
  as well as the handling of `'` characters in identifiers.  
  (Demi Obenour)

- [GPR#1045](https://github.com/ocaml/ocaml/pull/1045): ocamldep, add a `-shared` option to generate dependencies
  for native plugin files (i.e., `.cmxs` files).  
  (Florian Angeletti, suggestion by Sébastien Hinderer)

- [GPR#1078](https://github.com/ocaml/ocaml/pull/1078): add a subcommand `-depend` to `ocamlc` and `ocamlopt`, to
  behave as ocamldep.  Should be used mostly to replace `ocamldep` in
  the `boot` directory to reduce its size in the future.  
  (Fabrice Le Fessant)

- [GPR#1036](https://github.com/ocaml/ocaml/pull/1036): `ocamlcmt` (`tools/read_cmt`) is installed, converts `.cmt`
  to `.annot`.  
  (Fabrice Le Fessant)

- [GPR#1180](https://github.com/ocaml/ocaml/pull/1180): Add support for recording numbers of direct and indirect
  calls over the lifetime of a program when using Spacetime
  profiling.  
  (Mark Shinwell)

- [GPR#1457](https://github.com/ocaml/ocaml/pull/1457), ocamldoc: restore label for exception in the LaTeX backend
  (omitted since 4.04.0).  
  (Florian Angeletti, review by Gabriel Scherer)

### Toplevel:

- [MPR#7570](https://caml.inria.fr/mantis/view.php?id=7570): remove unusable `-plugin` option from the toplevel.  
  (Florian Angeletti)

- [GPR#1041](https://github.com/ocaml/ocaml/pull/1041): `-nostdlib` no longer ignored by toplevel.  
  (David Allsopp, review by Xavier Leroy)

- [GPR#1231](https://github.com/ocaml/ocaml/pull/1231): improved printing of unicode texts in the toplevel,
  unless `OCAMLTOP_UTF_8` is set to false.  
  (Florian Angeletti, review by Daniel Bünzli, Xavier Leroy and
   Gabriel Scherer)

### Runtime system:

* [MPR#3771](https://caml.inria.fr/mantis/view.php?id=3771), [GPR#153](https://github.com/ocaml/ocaml/pull/153), [GPR#1200](https://github.com/ocaml/ocaml/pull/1200), [GPR#1357](https://github.com/ocaml/ocaml/pull/1357), [GPR#1362](https://github.com/ocaml/ocaml/pull/1362), [GPR#1363](https://github.com/ocaml/ocaml/pull/1363), [GPR#1369](https://github.com/ocaml/ocaml/pull/1369), [GPR#1398](https://github.com/ocaml/ocaml/pull/1398),
  [GPR#1446](https://github.com/ocaml/ocaml/pull/1446), [GPR#1448](https://github.com/ocaml/ocaml/pull/1448): Unicode support for the Windows runtime.  
  (ygrek, Nicolas Ojeda Bar, review by Alain Frisch, David Allsopp, Damien
  Doligez)

* [MPR#7594](https://caml.inria.fr/mantis/view.php?id=7594), [GPR#1274](https://github.com/ocaml/ocaml/pull/1274), [GPR#1368](https://github.com/ocaml/ocaml/pull/1368): `String_val` now returns `const
  char*`, not `char*` when `-safe-string` is enabled at configure time.
  New macro `Bytes_val` for accessing bytes values.  
  (Jeremy Yallop, reviews by Mark Shinwell and Xavier Leroy)

- [GPR#71](https://github.com/ocaml/ocaml/pull/71): The runtime can now be shut down gracefully by means of the
  new `caml_shutdown` and `caml_startup_pooled` functions. The new `c`
  flag in `OCAMLRUNPARAM` enables shutting the runtime properly on
  process exit.  
  (Max Mouratov, review and discussion by Damien Doligez, Gabriel
  Scherer, Mark Shinwell, Thomas Braibant, Stephen Dolan, Pierre
  Chambart, François Bobot, Jacques Garrigue, David Allsopp, and Alain
  Frisch)

- [GPR#938](https://github.com/ocaml/ocaml/pull/938), [GPR#1170](https://github.com/ocaml/ocaml/pull/1170), [GPR#1289](https://github.com/ocaml/ocaml/pull/1289): Stack overflow detection on 64-bit
  Windows.  
  (Olivier Andrieu, tweaked by David Allsopp)

- [GPR#1070](https://github.com/ocaml/ocaml/pull/1070), [GPR#1295](https://github.com/ocaml/ocaml/pull/1295): enable gcc typechecking for `caml_alloc_sprintf`,
  `caml_gc_message`.  Make `caml_gc_message` a variadic function.  Fix
  many `caml_gc_message` format strings.  
  (Olivier Andrieu, review and 32bit fix by David Allsopp)

- [GPR#1073](https://github.com/ocaml/ocaml/pull/1073): Remove statically allocated compare stack.  
  (Stephen Dolan)

- [GPR#1086](https://github.com/ocaml/ocaml/pull/1086): in `Sys.getcwd`, just fail instead of calling `getwd()`
  if `HAS_GETCWD` is not set.  
  (Report and first fix by Sebastian Markbåge, final fix by Xavier Leroy,
   review by MarK Shinwell)

- [GPR#1269](https://github.com/ocaml/ocaml/pull/1269): Remove 50ms delay at exit for programs using threads.  
  (Valentin Gatien-Baron, review by Stephen Dolan)

* [GPR#1309](https://github.com/ocaml/ocaml/pull/1309): open files with `O_CLOEXEC` (or equivalent) in
  `caml_sys_open`, thus unifying the semantics between Unix and
  Windows and also eliminating race condition on Unix.  
  (David Allsopp, report by Andreas Hauptmann)

- [GPR#1326](https://github.com/ocaml/ocaml/pull/1326): Enable use of CFI directives in AArch64 and ARM runtime
  systems' assembly code (`asmrun/arm64.S`).  Add CFI directives to
  enable unwinding through `caml_c_call` and `caml_call_gc` with
  correct termination of unwinding at `main`.  
  (Mark Shinwell, review by Xavier Leroy and Gabriel Scherer, with
  thanks to Daniel Bünzli and Fu Yong Quah for testing)

- [GPR#1338](https://github.com/ocaml/ocaml/pull/1338): Add `-g` for bytecode runtime system compilation.  
  (Mark Shinwell)

* [GPR#1416](https://github.com/ocaml/ocaml/pull/1416), [GPR#1444](https://github.com/ocaml/ocaml/pull/1444): switch the Windows 10 Console to UTF-8
  encoding.  
  (David Allsopp, reviews by Nicolás Ojeda Bär and Xavier Leroy)

### Manual and documentation:

- [MPR#6548](https://caml.inria.fr/mantis/view.php?id=6548): remove obsolete limitation in the description of private
  type abbreviations.  
  (Florian Angeletti, suggestion by Leo White)

- [MPR#6676](https://caml.inria.fr/mantis/view.php?id=6676), [GPR#1110](https://github.com/ocaml/ocaml/pull/1110): move record notation to tutorial.  
  (Florian Angeletti, review by Gabriel Scherer)

- [MPR#6676](https://caml.inria.fr/mantis/view.php?id=6676), [GPR#1112](https://github.com/ocaml/ocaml/pull/1112): move local opens to tutorial.  
  (Florian Angeletti)

- [MPR#6676](https://caml.inria.fr/mantis/view.php?id=6676), [GPR#1153](https://github.com/ocaml/ocaml/pull/1153): move overriding class definitions to reference
  manual and tutorial.  
  (Florian Angeletti)

- [MPR#6709](https://caml.inria.fr/mantis/view.php?id=6709): document the associativity and precedence level of
  pervasive operators.  
  (Florian Angeletti, review by David Allsopp)

- [MPR#7254](https://caml.inria.fr/mantis/view.php?id=7254), [GPR#1096](https://github.com/ocaml/ocaml/pull/1096): Rudimentary documentation of ocamlnat.  
  (Mark Shinwell)

- [MPR#7281](https://caml.inria.fr/mantis/view.php?id=7281), [GPR#1259](https://github.com/ocaml/ocaml/pull/1259): fix `.TH` macros in generated manpages.  
  (Olaf Hering)

- [MPR#7507](https://caml.inria.fr/mantis/view.php?id=7507): Align the description of the printf conversion
  specification `"%g"` with the ISO C90 description.  
  (Florian Angeletti, suggestion by Armaël Guéneau)

- [MPR#7551](https://caml.inria.fr/mantis/view.php?id=7551), [GPR#1194](https://github.com/ocaml/ocaml/pull/1194) : make the final `";;"` potentially optional in
  `caml_example`.  
  (Florian Angeletti, review and suggestion by Gabriel Scherer)

- [MPR#7588](https://caml.inria.fr/mantis/view.php?id=7588), [GPR#1291](https://github.com/ocaml/ocaml/pull/1291): make format documentation predictable.  
  (Florian Angeletti, review by Gabriel Radanne)

- [MPR#7604](https://caml.inria.fr/mantis/view.php?id=7604): Minor Ephemeron documentation fixes.  
  (Miod Vallat, review by Florian Angeletti)

- [GPR#594](https://github.com/ocaml/ocaml/pull/594): New chapter on polymorphism troubles:
  weakly polymorphic types, polymorphic recursion,and higher-ranked
  polymorphism.  
  (Florian Angeletti, review by Damien Doligez, Gabriel Scherer,
   and Gerd Stolpmann)

- [GPR#1187](https://github.com/ocaml/ocaml/pull/1187): Minimal documentation for compiler plugins.  
  (Florian Angeletti)

- [GPR#1202](https://github.com/ocaml/ocaml/pull/1202): Fix Typos in comments as well as basic grammar errors.  
  (JP Rodi, review and suggestions by David Allsopp, Max Mouratov,
  Florian Angeletti, Xavier Leroy, Mark Shinwell and Damien Doligez)

- [GPR#1220](https://github.com/ocaml/ocaml/pull/1220): Fix `-keep-docs` option in ocamlopt manpage.  
  (Etienne Millon)

### Compiler distribution build system:

- [MPR#6373](https://caml.inria.fr/mantis/view.php?id=6373), [GPR#1093](https://github.com/ocaml/ocaml/pull/1093): Suppress trigraph warnings from macOS
  assembler.  
  (Mark Shinwell)

- [MPR#7639](https://caml.inria.fr/mantis/view.php?id=7639), [GPR#1371](https://github.com/ocaml/ocaml/pull/1371): fix configure script for correct detection of
  int64 alignment on Mac OS X 10.13 (High Sierra) and above; fix bug in
  configure script relating to such detection.  
  (Mark Shinwell, report by John Whitington, review by Xavier Leroy)

- [GPR#558](https://github.com/ocaml/ocaml/pull/558): enable shared library and natdynlink support on more Linux
  platforms.  
  (Felix Janda, Mark Shinwell)

* [GPR#1104](https://github.com/ocaml/ocaml/pull/1104): remove support for the NeXTStep platform.  
  (Sébastien Hinderer)

- [GPR#1130](https://github.com/ocaml/ocaml/pull/1130): enable detection of IBM XL C compiler (one need to run
  configure with `-cc <path to xlc compiler>`).  Enable shared library
  support for bytecode executables on AIX/xlc (tested on AIX 7.1, XL C
  12).  To enable 64-bit, run both `configure` and `make world` with
  `OBJECT_MODE=64`.  
  (Konstantin Romanov, Enrique Naudon)

- [GPR#1203](https://github.com/ocaml/ocaml/pull/1203): speed up the manual build by using `ocamldoc.opt`.  
  (Gabriel Scherer, review by Florian Angeletti)

- [GPR#1214](https://github.com/ocaml/ocaml/pull/1214): harden `config/Makefile` against `#` characters in
  PREFIX.  
  (Gabriel Scherer, review by David Allsopp and Damien Doligez)

- [GPR#1216](https://github.com/ocaml/ocaml/pull/1216): move Compplugin and friends from `BYTECOMP` to `COMP`.  
  (Leo White, review by Mark Shinwell)

* [GPR#1242](https://github.com/ocaml/ocaml/pull/1242): disable C plugins loading by default.  
  (Alexey Egorov)

- [GPR#1275](https://github.com/ocaml/ocaml/pull/1275): correct configure test for Spacetime availability.  
  (Mark Shinwell)

- [GPR#1278](https://github.com/ocaml/ocaml/pull/1278): discover presence of `<sys/shm.h>` during configure for
  afl runtime.  
  (Hannes Mehnert)

- [GPR#1386](https://github.com/ocaml/ocaml/pull/1386): provide configure-time options to fine-tune the safe-string
  options and default settings changed by [GPR#1525](https://github.com/ocaml/ocaml/pull/1525).

  The previous configure option `-safe-string` is now
  renamed `-force-safe-string`.

  At configure-time, `-force-safe-string` forces all module to use
  immutable strings (this disables the per-file, compile-time
  `-unsafe-string` option). The new default-(un)safe-string options
  let you set the default choice for the per-file compile-time
  option. (The new [GPR#1252](https://github.com/ocaml/ocaml/pull/1252) behavior corresponds to having
  `-default-safe-string`, while 4.05 and older had
  `-default-unsafe-string`).

  (Gabriel Scherer, review by Jacques-Pascal Deplaix and Damien Doligez)

- [GPR#1409](https://github.com/ocaml/ocaml/pull/1409): Fix to enable NetBSD/powerpc to work.  
  (Håvard Eidnes)

### Internal/compiler-libs changes:

- [MPR#6826](https://caml.inria.fr/mantis/view.php?id=6826), [GPR#828](https://github.com/ocaml/ocaml/pull/828), [GPR#834](https://github.com/ocaml/ocaml/pull/834): improve compilation time for `open`.  
  (Alain Frisch, review by Frédéric Bour and Jacques Garrigue)

- [MPR#7127](https://caml.inria.fr/mantis/view.php?id=7127), [GPR#454](https://github.com/ocaml/ocaml/pull/454), [GPR#1058](https://github.com/ocaml/ocaml/pull/1058): in toplevel, print bytes and strip
  strings longer than the size specified by the `print_length`
  directive.  
  (Fabrice Le Fessant, initial PR by Junsong Li)

- [GPR#406](https://github.com/ocaml/ocaml/pull/406): remove polymorphic comparison for `Types.constructor_tag`
  in compiler.  
  (Dwight Guth, review by Gabriel Radanne, Damien Doligez, Gabriel
  Scherer, Pierre Chambart, Mark Shinwell)

- GRP#1119: Change Set (private) type to inline records.  
  (Albin Coquereau)

* [GPR#1127](https://github.com/ocaml/ocaml/pull/1127): move `config/{m,s}.h` to `byterun/caml` and install them.
  User code should not have to include them directly since they are
  included by other header files.  Previously `{m,s}.h` were not
  installed but they were substituted into `caml/config.h`; they are
  now just `#include`-d by this file.  This may break some scripts
  relying on the (unspecified) presence of certain `#define` in
  `config.h` instead of `m.h` and `s.h` — they can be rewritten to try
  to grep those files if they exist.  
  (Sébastien Hinderer)

- [GPR#1281](https://github.com/ocaml/ocaml/pull/1281): avoid formatter flushes inside exported printers in
  `Location`.  
  (Florian Angeletti, review by Gabriel Scherer)

### Bug fixes

- [MPR#5927](https://caml.inria.fr/mantis/view.php?id=5927): Type equality broken for conjunctive polymorphic variant
  tags.  
  (Jacques Garrigue, report by Leo White)

- [MPR#6329](https://caml.inria.fr/mantis/view.php?id=6329), [GPR#1437](https://github.com/ocaml/ocaml/pull/1437): Introduce padding word before "data_end" symbols
  to ensure page table tests work correctly on an immediately preceding
  block of zero size.  
  (Mark Shinwell, review by Xavier Leroy)

- [MPR#6587](https://caml.inria.fr/mantis/view.php?id=6587): only elide Pervasives from printed type paths in
  unambiguous context.  
  (Florian Angeletti and Jacques Garrigue)

- [MPR#6934](https://caml.inria.fr/mantis/view.php?id=6934): `nonrec` misbehaves with GADTs.  
  (Jacques Garrigue, report by Markus Mottl)

- [MPR#7070](https://caml.inria.fr/mantis/view.php?id=7070), [GPR#1139](https://github.com/ocaml/ocaml/pull/1139): Unexported values can cause non-generalisable
  variables error.  
  (Leo White)

- [MPR#7261](https://caml.inria.fr/mantis/view.php?id=7261): Warn on type constraints in GADT declarations.  
  (Jacques Garrigue, report by Fabrice Le Botlan)

- [MPR#7321](https://caml.inria.fr/mantis/view.php?id=7321): Private type in signature clashes with type definition via
  functor instantiation.  
  (Jacques Garrigue, report by Markus Mottl)

- [MPR#7372](https://caml.inria.fr/mantis/view.php?id=7372), [GPR#834](https://github.com/ocaml/ocaml/pull/834): fix type-checker bug with GADT and inline
  records.  
  (Alain Frisch, review by Frédéric Bour and Jacques Garrigue)

- [MPR#7344](https://caml.inria.fr/mantis/view.php?id=7344): Inconsistent behavior with type annotations on `let`.  
  (Jacques Garrigue, report by Leo White)

- [MPR#7468](https://caml.inria.fr/mantis/view.php?id=7468): possible GC problem in `caml_alloc_sprintf`.  
  (Xavier Leroy, discovery by Olivier Andrieu)

- [MPR#7496](https://caml.inria.fr/mantis/view.php?id=7496): Fixed conjunctive polymorphic variant tags do not unify
  with themselves.  
  (Jacques Garrigue, report by Leo White)

- [MPR#7506](https://caml.inria.fr/mantis/view.php?id=7506): `pprintast` ignores attributes in tails of a list.  
  (Alain Frisch, report by Kenichi Asai and Gabriel Scherer)

- [MPR#7513](https://caml.inria.fr/mantis/view.php?id=7513): `List.compare_length_with` mishandles negative numbers /
  overflow.  
  (Fabrice Le Fessant, report by Jeremy Yallop)

- [MPR#7519](https://caml.inria.fr/mantis/view.php?id=7519): Incorrect rejection of program due to faux scope escape.  
  (Jacques Garrigue, report by Markus Mottl)

- [MPR#7540](https://caml.inria.fr/mantis/view.php?id=7540), [GPR#1179](https://github.com/ocaml/ocaml/pull/1179): Fixed setting of breakpoints within packed modules
  for `ocamldebug`.  
  (Hugo Herbelin, review by Gabriel Scherer, Damien Doligez)

- [MPR#7543](https://caml.inria.fr/mantis/view.php?id=7543): short-paths `printtyp` can fail on packed type error
  messages.  
  (Florian Angeletti)

- [MPR#7553](https://caml.inria.fr/mantis/view.php?id=7553), [GPR#1191](https://github.com/ocaml/ocaml/pull/1191): Prevent repeated warnings with recursive
  modules.  
  (Leo White, review by Josh Berdine and Alain Frisch)

- [MPR#7563](https://caml.inria.fr/mantis/view.php?id=7563), [GPR#1210](https://github.com/ocaml/ocaml/pull/1210): code generation bug when a module alias and
  an extension constructor have the same name in the same module.  
  (Gabriel Scherer, report by Manuel Fähndrich,
   review by Jacques Garrigue and Leo White)

- [MPR#7591](https://caml.inria.fr/mantis/view.php?id=7591), [GPR#1257](https://github.com/ocaml/ocaml/pull/1257): on x86-64, frame table is not 8-aligned.  
  (Xavier Leroy, report by Mantis user "voglerr", review by Gabriel Scherer)

- [MPR#7601](https://caml.inria.fr/mantis/view.php?id=7601), [GPR#1320](https://github.com/ocaml/ocaml/pull/1320): It seems like a hidden non-generalized type variable
  remains in some inferred signatures, which leads to strange errors.  
  (Jacques Garrigue, report by Mandrikin)

- [MPR#7609](https://caml.inria.fr/mantis/view.php?id=7609): use-after-free memory corruption if a program debugged
  under ocamldebug calls `Pervasives.flush_all`.  
  (Xavier Leroy, report by Paul Steckler, review by Gabriel Scherer)

- [MPR#7612](https://caml.inria.fr/mantis/view.php?id=7612), [GPR#1345](https://github.com/ocaml/ocaml/pull/1345): afl-instrumentation bugfix for classes.  
  (Stephen Dolan, review by Gabriel Scherer and David Allsopp)

- [MPR#7617](https://caml.inria.fr/mantis/view.php?id=7617), [MPR#7618](https://caml.inria.fr/mantis/view.php?id=7618), [GPR#1318](https://github.com/ocaml/ocaml/pull/1318): Ambiguous (mistakenly) type escaping the
  scope of its equation.  
  (Jacques Garrigue, report by Thomas Refis)

- [MPR#7619](https://caml.inria.fr/mantis/view.php?id=7619), [GPR#1387](https://github.com/ocaml/ocaml/pull/1387): position of the optional last semi-column not included
  in the position of the expression (same behavior as for lists).  
  (Christophe Raffalli, review by Gabriel Scherer)

- [MPR#7638](https://caml.inria.fr/mantis/view.php?id=7638): in the Windows Mingw64 port, multithreaded programs compiled
  to bytecode could crash when raising an exception from C code.
  This looks like a Mingw64 issue, which we work around with GCC
  builtins.  
  (Xavier Leroy)

- [MPR#7656](https://caml.inria.fr/mantis/view.php?id=7656), [GPR#1423](https://github.com/ocaml/ocaml/pull/1423): false 'unused type/constructor/value' alarms
  in the 4.06 development version.  
  (Alain Frisch, review by Jacques Garrigue, report by Jacques-Pascal Deplaix)

- [MPR#7657](https://caml.inria.fr/mantis/view.php?id=7657), [GPR#1424](https://github.com/ocaml/ocaml/pull/1424): ensures correct call-by-value semantics when
  eta-expanding functions to eliminate optional arguments.  
  (Alain Frisch, report by sliquister, review by Leo White and Jacques
  Garrigue)

- [MPR#7658](https://caml.inria.fr/mantis/view.php?id=7658), [GPR#1439](https://github.com/ocaml/ocaml/pull/1439): Fix Spacetime runtime system compilation with
  `-force-safe-string`.  
  (Mark Shinwell, report by Christoph Spiel, review by Gabriel Scherer)

- [GPR#1155](https://github.com/ocaml/ocaml/pull/1155): Fix a race condition with `WAIT_NOHANG` on Windows.  
  (Jérémie Dimino and David Allsopp)

- [GPR#1199](https://github.com/ocaml/ocaml/pull/1199): Pretty-printing formatting cleanup in `pprintast`.  
  (Ethan Aubin, suggestion by Gabriel Scherer, review by David Allsopp,
  Florian Angeletti, and Gabriel Scherer)

- [GPR#1223](https://github.com/ocaml/ocaml/pull/1223): Fix corruption of the environment when using `-short-paths`
  with the toplevel.  
  (Leo White, review by Alain Frisch)

- [GPR#1243](https://github.com/ocaml/ocaml/pull/1243): Fix `pprintast` for `#...` infix operators.  
  (Alain Frisch, report by Omar Chebib)

- [GPR#1324](https://github.com/ocaml/ocaml/pull/1324): ensure that flambda warning are printed only once.  
  (Xavier Clerc)

- [GPR#1329](https://github.com/ocaml/ocaml/pull/1329): Prevent recursive polymorphic variant names.  
  (Jacques Garrigue, fix suggested by Leo White)

- [GPR#1308](https://github.com/ocaml/ocaml/pull/1308): Only treat pure patterns as inactive.  
  (Leo White, review by Alain Frisch and Gabriel Scherer)

- [GPR#1390](https://github.com/ocaml/ocaml/pull/1390): fix the `[@@unboxed]` type check to accept parametrized
  types.  
  (Leo White, review by Damien Doligez)

- [GPR#1407](https://github.com/ocaml/ocaml/pull/1407): Fix `raw_spacetime_lib`.  
  (Leo White, review by Gabriel Scherer and Damien Doligez)
|js}
  ; body_html = {js|<h2>Opam Switches</h2>
<p>This release is available as multiple
<a href="https://opam.ocaml.org/doc/Usage.html">OPAM</a> switches:</p>
<ul>
<li>4.06.0 — Official 4.06.0 release
</li>
<li>4.06.0+afl — Official 4.06.0 release with afl-fuzz instrumentation
</li>
<li>4.06.0+default-unsafe-string — Official 4.06.0 release without safe
strings by default
</li>
<li>4.06.0+flambda — Official 4.06.0 release with flambda activated
</li>
<li>4.06.0+force-safe-string — Official 4.06.0 release with -safe-string enabled.
</li>
<li>4.06.0+fp — Official 4.06.0 release with frame-pointers
</li>
<li>4.06.0+fp+flambda — Official 4.06.0 release with frame-pointers and
flambda activated
</li>
</ul>
<h2>What's new</h2>
<p>Some of the highlights in release 4.06 are:</p>
<ul>
<li>
<p>Strings (type <code>string</code>) are now immutable by default. In-place
modification must use the type <code>bytes</code> of byte sequences, which is
distinct from <code>string</code>.  This corresponds to the <code>-safe-string</code>
compile-time option, which was introduced in OCaml 4.02 in 2014, and
which is now the default.</p>
</li>
<li>
<p>Object types can now extend a previously-defined object type, as in
<code>&lt;t; a: int&gt;</code>.</p>
</li>
<li>
<p>Destructive substitution over module signatures can now express more
substitutions, such as <code>S with type M.t := type-expr</code>
and <code>S with module M.N := path</code>.</p>
</li>
<li>
<p>Users can now define operators that look like array indexing, e.g.
<code>let ( .%() ) = List.nth in [0; 1; 2].%(1)</code></p>
</li>
<li>
<p>New escape <code>\\u{XXXX}</code> in string literals, denoting the UTF-8
encoding of the Unicode code point <code>XXXX</code>.</p>
</li>
<li>
<p>Full Unicode support was added to the Windows runtime system.  In
particular, file names can now contain Unicode characters.</p>
</li>
<li>
<p>An alternate register allocator based on linear scan can be selected
with <code>ocamlopt -linscan</code>.  It reduces compilation time compared with
the default register allocator.</p>
</li>
<li>
<p>The Num library for arbitrary-precision integer and rational
arithmetic is no longer part of the core distribution and can be
found as a separate OPAM package.</p>
</li>
</ul>
<p>For a comprehensive list of changes and details on all new features,
bug fixes, optimizations, etc., please consult the
<a href="#Changes">changelog</a>.</p>
<h2>Source distribution</h2>
<ul>
<li><a href="https://github.com/ocaml/ocaml/archive/4.06.0.tar.gz">Source
tarball</a>
(.tar.gz) for compilation under Unix (including Linux and MacOS X)
and Microsoft Windows (including Cygwin).
</li>
<li>Also available in
<a href="https://github.com/ocaml/ocaml/archive/4.06.0.zip">.zip</a>
format.
</li>
<li><a href="https://opam.ocaml.org/">OPAM</a> is a source-based distribution of
OCaml and many companion libraries and tools. Compilation and
installation are automated by powerful package managers.
</li>
<li>The official development repo is hosted on
<a href="https://github.com/ocaml/ocaml">GitHub</a>.
</li>
</ul>
<p>The
<a href="4.06/notes/INSTALL.adoc">INSTALL</a> file
of the distribution provides detailed compilation and installation
instructions -- see also the <a href="4.06/notes/README.win32.adoc">Windows release
notes</a> for
instructions on how to build under Windows.</p>
<h2>Alternative Compilers</h2>
<p>Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:</p>
<ul>
<li><a href="http://ocsigen.org/js_of_ocaml/">Js_of_ocaml</a> is a stable OCaml
to JavaScript compiler.
</li>
<li><a href="http://bucklescript.github.io/bucklescript/">Bucklescript</a> is a
newer OCaml to JavaScript compiler. See its
<a href="https://github.com/bucklescript/bucklescript/wiki/Differences-from-js_of_ocaml">wiki</a> for
an explanation of how it differs from js_of_ocaml.
</li>
<li><a href="http://www.ocamljava.org/">OCaml-java</a> is a stable OCaml to
Java compiler.
</li>
</ul>
<h2>User's manual</h2>
<p>The user's manual for OCaml can be:</p>
<ul>
<li><a href="4.06/htmlman/index.html">browsed
online</a>,
</li>
<li>downloaded as a single
<a href="4.06/ocaml-4.06-refman.ps.gz">PostScript</a>,
<a href="4.06/ocaml-4.06-refman.pdf">PDF</a>,
or <a href="4.06/ocaml-4.06-refman.txt">plain
text</a>
document,
</li>
<li>downloaded as a single
<a href="4.06/ocaml-4.06-refman-html.tar.gz">TAR</a>
or
<a href="4.06/ocaml-4.06-refman-html.zip">ZIP</a>
archive of HTML files,
</li>
<li>downloaded as a single
<a href="4.06/ocaml-4.06-refman.info.tar.gz">tarball</a>
of Emacs info files,
</li>
</ul>
<h2>Changes</h2>
<p>This is the
<a href="4.06/notes/Changes">changelog</a>.</p>
<p>(Changes that can break existing programs are marked with a &quot;*&quot;)</p>
<h3>Language features:</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=6271">MPR#6271</a>,
<a href="https://caml.inria.fr/mantis/view.php?id=7529">MPR#7529</a>,
<a href="https://github.com/ocaml/ocaml/pull/1249">GPR#1249</a>:
Support <code>let open M in ...</code>
in class expressions and class type expressions.<br />
(Alain Frisch, reviews by Thomas Refis and Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/792">GPR#792</a>:
fix limitations of destructive substitutions, by
allowing <code>S with type t := type-expr</code>,
<code>S with type M.t := type-expr</code>, <code>S with module M.N := path</code>.<br />
(Valentin Gatien-Baron, review by Jacques Garrigue and Leo White)</p>
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1064">GPR#1064</a>,
<a href="https://github.com/ocaml/ocaml/pull/1392">GPR#1392</a>:
extended indexing operators, add a new class of
user-defined indexing operators, obtained by adding at least one
operator character after the dot symbol to the standard indexing
operators: e,g <code>.%()</code>, <code>.?[]</code>, <code>.@{}&lt;-</code>:</p>
<pre><code class="language-ocaml">let ( .%() ) = List.nth in
[0; 1; 2].%(1)
</code></pre>
<p>After this change, functions or methods with an explicit polymorphic type
annotation and of which the first argument is optional now requires a space
between the dot and the question mark,
e.g. <code>&lt;f:'a.?opt:int-&gt;unit&gt;</code> must now be written
<code>&lt;f:'a. ?opt:int-&gt;unit&gt;</code>.<br />
(Florian Angeletti, review by Damien Doligez and Gabriel Radanne)</p>
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1118">GPR#1118</a>:
Support inherited field in object type expression</p>
<pre><code class="language-ocaml">type t = &lt; m : int &gt;
type u = &lt; n : int; t; k : int &gt;
</code></pre>
<p>(Runhang Li, reivew by Jeremy Yallop, Leo White, Jacques Garrigue,
and Florian Angeletti)</p>
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/1232">GPR#1232</a>:
Support Unicode character escape sequences in string
literals via the <code>\\u{X+}</code> syntax. These escapes are substituted by the
UTF-8 encoding of the Unicode character.<br />
(Daniel Bünzli, review by Damien Doligez, Alain Frisch, Xavier
Leroy and Leo White)
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/1247">GPR#1247</a>:
<code>M.(::)</code> construction for expressions
and patterns (plus fix printing of (::) in the toplevel)<br />
(Florian Angeletti, review by Alain Frisch, Gabriel Scherer)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1252">GPR#1252</a>:
The default mode is now safe-string, can be overridden
at configure time or at compile time.
(See <a href="https://github.com/ocaml/ocaml/pull/1386">GPR#1386</a>
below for the configure-time options)
This breaks the code that uses the <code>string</code> type as mutable
strings (instead of <code>Bytes.t</code>, introduced by 4.02 in 2014).<br />
(Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1253">GPR#1253</a>:
Private extensible variants
This change breaks code relying on the undocumented ability to export
extension constructors for abstract type in signature. Briefly,</p>
<pre><code class="language-ocaml">module type S = sig
  type t
  type t += A
end
</code></pre>
<p>must now be written</p>
<pre><code class="language-ocaml">module type S = sig
  type t = private ..
  type t += A
end
</code></pre>
<p>(Leo White, review by Alain Frisch)</p>
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1333">GPR#1333</a>:
turn off warning 40 by default
(Constructor or label name used out of scope)<br />
(Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1348">GPR#1348</a>:
accept anonymous type parameters in <code>with</code> constraints:
<code>S with type _ t = int</code>.<br />
(Valentin Gatien-Baron, report by Jeremy Yallop)</p>
</li>
</ul>
<h3>Type system</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=248">MPR#248</a>,
<a href="https://github.com/ocaml/ocaml/pull/1225">GPR#1225</a>:
unique names for weak type variables</p>
<pre><code class="language-ocaml"># ref [];;
- : '__weak1 list ref = {contents = []}
</code></pre>
</li>
</ul>
<!-- FIXME: Double underscore because omd treats the first as "lower" -->
<p>(Florian Angeletti, review by Frédéric Bour, Jacques Garrigue,
Gabriel Radanne and Gabriel Scherer)</p>
<ul>
<li><a href="https://caml.inria.fr/mantis/view.php?id=6738">MPR#6738</a>,
<a href="https://caml.inria.fr/mantis/view.php?id=7215">MPR#7215</a>,
<a href="https://caml.inria.fr/mantis/view.php?id=7231">MPR#7231</a>,
<a href="https://github.com/ocaml/ocaml/pull/556">GPR#556</a>:
Add a new check that <code>let rec</code>
bindings are well formed.<br />
(Jeremy Yallop, reviews by Stephen Dolan, Gabriel Scherer, Leo
White, and Damien Doligez)
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/1142">GPR#1142</a>:
Mark assertions nonexpansive, so that <code>assert false</code>
can be used as a placeholder for a polymorphic function.<br />
(Stephen Dolan)
</li>
</ul>
<h3>Standard library:</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=1771">MPR#1771</a>,
<a href="https://caml.inria.fr/mantis/view.php?id=7309">MPR#7309</a>,
<a href="https://github.com/ocaml/ocaml/pull/1026">GPR#1026</a>:
Add update to maps. Allows to update a
binding in a map or create a new binding if the key had no binding</p>
<pre><code class="language-ocaml">val update: key -&gt; ('a option -&gt; 'a option) -&gt; 'a t -&gt; 'a t
</code></pre>
<p>(Sébastien Briais, review by Daniel Buenzli, Alain Frisch and
Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7515">MPR#7515</a>,
<a href="https://github.com/ocaml/ocaml/pull/1147">GPR#1147</a>:
<code>Arg.align</code> now optionally uses the tab
character <code>'\\t'</code> to separate the &quot;unaligned&quot; and &quot;aligned&quot; parts of
the documentation string. If tab is not present, then space is used
as a fallback. Allows to have spaces in the unaligned part, which is
useful for Tuple options.  (Nicolas Ojeda Bar, review by Alain
Frisch and Gabriel Scherer)</p>
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/615">GPR#615</a>:
Format, add symbolic formatters that output symbolic
pretty-printing items.  New fields have been added to the
<code>formatter_out_functions</code> record, thus this change will break any code
building such record from scratch.  When building
<code>Format.formatter_out_functions</code> values redefinining the
<code>out_spaces</code> field, <code>{ fmt_out_funs with out_spaces = f; }</code> should
be replaced by <code>{ fmt_out_funs with out_spaces = f; out_indent = f; }</code>
to maintain the old behavior.<br />
(Richard Bonichon and Pierre Weis, review by Alain Frisch, original
request by Spiros Eliopoulos in
<a href="https://github.com/ocaml/ocaml/pull/506">GPR#506</a>)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/943">GPR#943</a>:
Fixed the divergence of the Pervasives module between the
stdlib and threads implementations.  In rare circumstances this can
change the behavior of existing applications: the implementation of
<code>Pervasives.close_out</code> used when compiling with thread support was
inconsistent with the manual.  It will now not suppress exceptions
escaping <code>Pervasives.flush</code> anymore.  Developers who want the old
behavior should use <code>Pervasives.close_out_noerr</code> instead.  The stdlib
implementation, used by applications not compiled with thread
support, will now only suppress <code>Sys_error</code> exceptions in
<code>Pervasives.flush_all</code>.  This should allow exceedingly unlikely
assertion exceptions to escape, which could help reveal bugs in the
standard library.<br />
(Markus Mottl, review by Hezekiah M. Carty, Jeremie Dimino, Damien
Doligez, Alain Frisch, Xavier Leroy, Gabriel Scherer and Mark
Shinwell)</p>
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1034">GPR#1034</a>:
<code>List.init : int -&gt; (int -&gt; 'a) -&gt; 'a list</code><br />
(Richard Degenne, review by David Allsopp, Thomas Braibant, Florian
Angeletti, Gabriel Scherer, Nathan Moreau, Alain Frisch)</p>
</li>
<li>
<p>GRP#1091 Add the <code>Uchar.{bom,rep}</code> constants.<br />
(Daniel Bünzli, Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1091">GPR#1091</a>:
Add <code>Buffer.add_utf_{8,16le,16be}_uchar</code> to encode <code>Uchar.t</code>
values to the corresponding UTF-X transformation formats in <code>Buffer.t</code>
values.<br />
(Daniel Bünzli, review by Damien Doligez, Max Mouratov)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1175">GPR#1175</a>:
Bigarray, add a <code>change_layout</code> function to each Array[N]
submodules.<br />
(Florian Angeletti)</p>
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/1306">GPR#1306</a>:
In the MSVC and Mingw ports, <code>Sys.rename src dst</code> no
longer fails if file <code>dst</code> exists, but replaces it with file <code>src</code>,
like in the other ports.<br />
(Xavier Leroy)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1314">GPR#1314</a>:
Format, use the optional width information
when formatting a boolean: <code>&quot;%8B&quot;, &quot;%-8B&quot;</code> for example<br />
(Xavier Clerc, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/commit/c9cc0f25138ce58e4f4e68c4219afe33e2a9d034">c9cc0f25138ce58e4f4e68c4219afe33e2a9d034</a>:
Resurrect tabulation boxes
in module Format. Rewrite/extend documentation of tabulation boxes.<br />
(Pierre Weis)</p>
</li>
</ul>
<h3>Other libraries:</h3>
<ul>
<li><a href="https://caml.inria.fr/mantis/view.php?id=7564">MPR#7564</a>, <a href="https://github.com/ocaml/ocaml/pull/1211">GPR#1211</a>: Allow forward slashes in the target of symbolic links
created by <code>Unix.symlink</code> under Windows.
(Nicolas Ojeda Bar, review by David Allsopp)
</li>
</ul>
<ul>
<li><a href="https://caml.inria.fr/mantis/view.php?id=7640">MPR#7640</a>, <a href="https://github.com/ocaml/ocaml/pull/1414">GPR#1414</a>: reimplementation of <code>Unix.execvpe</code> to fix issues
with the 4.05 implementation.  The main issue is that the current
directory was always searched (last), even if the current directory
is not listed in the PATH.<br />
(Xavier Leroy, report by Louis Gesbert and Arseniy Alekseyev,
review by Ivan Gotovchits)
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/997">GPR#997</a>, <a href="https://github.com/ocaml/ocaml/pull/1077">GPR#1077</a>: Deprecate <code>Bigarray.*.map_file</code> and add
<code>Unix.map_file</code> as a first step towards moving Bigarray to the stdlib<br />
(Jérémie Dimino and Xavier Leroy)
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/1178">GPR#1178</a>: remove the Num library for arbitrary-precision arithmetic.
It now lives as a separate project https://github.com/ocaml/num
with an OPAM package called <code>num</code>.<br />
(Xavier Leroy)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1217">GPR#1217</a>: Restrict <code>Unix.environment</code> in privileged contexts; add
<code>Unix.unsafe_environment</code>.<br />
(Jeremy Yallop, review by Mark Shinwell, Nicolas Ojeda Bar,
Damien Doligez and Hannes Mehnert)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1321">GPR#1321</a>: Reimplement <code>Unix.isatty</code> on Windows. It no longer returns
true for the null device.<br />
(David Allsopp)</p>
</li>
</ul>
<h3>Compiler user-interface and warnings:</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7361">MPR#7361</a>, <a href="https://github.com/ocaml/ocaml/pull/1248">GPR#1248</a>: support <code>ocaml.warning</code> in all attribute
contexts, and arrange so that <code>ocaml.ppwarning</code> is correctly scoped
by surrounding <code>ocaml.warning</code> attributes.<br />
(Alain Frisch, review by Florian Angeletti and Thomas Refis)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7444">MPR#7444</a>, <a href="https://github.com/ocaml/ocaml/pull/1138">GPR#1138</a>: trigger deprecation warning when a &quot;deprecated&quot;
attribute is hidden by signature coercion.<br />
(Alain Frisch, report by bmillwood, review by Leo White)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7472">MPR#7472</a>: ensure <code>.cmi</code> files are created atomically,
to avoid corruption of <code>.cmi</code> files produced simultaneously by a run
of ocamlc and a run of ocamlopt.<br />
(Xavier Leroy, from a suggestion by Gerd Stolpmann)</p>
</li>
</ul>
<ul>
<li><a href="https://caml.inria.fr/mantis/view.php?id=7514">MPR#7514</a>, <a href="https://github.com/ocaml/ocaml/pull/1152">GPR#1152</a>: add <code>-dprofile</code> option, similar to <code>-dtimings</code> but
also displays memory allocation and consumption.
The corresponding addition of a new compiler-internal
Profile module may affect some users of
compilers-libs/ocamlcommon (by creating module conflicts).<br />
(Valentin Gatien-Baron, report by Gabriel Scherer)
</li>
</ul>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7620">MPR#7620</a>, <a href="https://github.com/ocaml/ocaml/pull/1317">GPR#1317</a>: <code>Typecore.force_delayed_checks</code> does not run
with <code>-i</code> option.<br />
(Jacques Garrigue, report by Jun Furuse)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7624">MPR#7624</a>: handle warning attributes placed on let bindings.<br />
(Xavier Clerc, report by dinosaure, review by Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/896">GPR#896</a>: <code>-compat-32</code> is now taken into account when building
<code>.cmo</code>/<code>.cma</code>.<br />
(Hugo Heuzard)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/948">GPR#948</a>: the compiler now reports warnings-as-errors by prefixing
them with &quot;Error (warning ..):&quot;, instead of &quot;Warning ..:&quot; and
a trailing &quot;Error: Some fatal warnings were triggered&quot; message.<br />
(Valentin Gatien-Baron, review by Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1032">GPR#1032</a>: display the output of <code>-dtimings</code> as a hierarchy.<br />
(Valentin Gatien-Baron, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1114">GPR#1114</a>, <a href="https://github.com/ocaml/ocaml/pull/1393">GPR#1393</a>, <a href="https://github.com/ocaml/ocaml/pull/1429">GPR#1429</a>: refine the (<code>ocamlc -config</code>)
information on C compilers: the variables
<code>{bytecode,native}_c_compiler</code> are deprecated (the distinction is
now mostly meaningless) in favor of a single <code>c_compiler</code> variable
combined with <code>ocaml{c,opt}_cflags</code> and <code>ocaml{c,opt}_cppflags</code>.<br />
(Sébastien Hinderer, Jeremy Yallop, Gabriel Scherer, review by
Adrien Nader and David Allsopp)</p>
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/1189">GPR#1189</a>: allow MSVC ports to use <code>-l</code> option in <code>ocamlmklib</code>.<br />
(David Allsopp)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1332">GPR#1332</a>: fix ocamlc handling of <code>-output-complete-obj</code>.<br />
(François Bobot)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1336">GPR#1336</a>: <code>-thread</code> and <code>-vmthread</code> option information is propagated to
PPX rewriters.<br />
(Jun Furuse, review by Alain Frisch)</p>
</li>
</ul>
<h3>Code generation and optimizations:</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=5324">MPR#5324</a>, <a href="https://github.com/ocaml/ocaml/pull/375">GPR#375</a>: An alternative Linear Scan register allocator for
ocamlopt, activated with the <code>-linscan</code> command-line flag.  This
allocator represents a trade-off between worse generated code
performance for higher compilation speed (especially interesting in
some cases graph coloring is necessarily quadratic).<br />
(Marcell Fischbach and Benedikt Meurer, adapted by Nicolas Ojeda
Bar, review by Nicolas Ojeda Bar and Alain Frisch)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=6927">MPR#6927</a>, <a href="https://github.com/ocaml/ocaml/pull/988">GPR#988</a>: On macOS, when compiling bytecode stubs, plugins,
and shared libraries through <code>-output-obj</code>, generate dylibs instead of
bundles.<br />
(whitequark)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7447">MPR#7447</a>, <a href="https://github.com/ocaml/ocaml/pull/995">GPR#995</a>: incorrect code generation for nested recursive
bindings.<br />
(Leo White and Jeremy Yallop, report by Stephen Dolan)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7501">MPR#7501</a>, <a href="https://github.com/ocaml/ocaml/pull/1089">GPR#1089</a>: Consider arrays of length zero as constants
when using Flambda.<br />
(Pierre Chambart, review by Mark Shinwell and Leo White)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7531">MPR#7531</a>, <a href="https://github.com/ocaml/ocaml/pull/1162">GPR#1162</a>: Erroneous code transformation at partial
applications.<br />
(Mark Shinwell)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7614">MPR#7614</a>, <a href="https://github.com/ocaml/ocaml/pull/1313">GPR#1313</a>: Ensure that inlining does not depend on the order
of symbols (flambda).<br />
(Leo White, Xavier Clerc, report by Alex, review by Gabriel Scherer
and Pierre Chambart)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7616">MPR#7616</a>, <a href="https://github.com/ocaml/ocaml/pull/1339">GPR#1339</a>: don't warn on mutation of zero size blocks.<br />
(Leo White)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7631">MPR#7631</a>, <a href="https://github.com/ocaml/ocaml/pull/1355">GPR#1355</a>: <code>-linscan</code> option crashes ocamlopt.<br />
(Xavier Clerc, report by Paul Steckler)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7642">MPR#7642</a>, <a href="https://github.com/ocaml/ocaml/pull/1411">GPR#1411</a>: ARM port: wrong register allocation for integer
multiply on ARMv4 and ARMv5; possible wrong register allocation for
floating-point multiply and add on VFP and for floating-point
negation and absolute value on soft FP emulation.<br />
(Xavier Leroy, report by Stéphane Glondu and Ximin Luo,
review and additional sightings by Mark Shinwell)</p>
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/659">GPR#659</a>: Remove support for SPARC native code generation.<br />
(Mark Shinwell)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/850">GPR#850</a>: Optimize away some physical equality.<br />
(Pierre Chambart, review by Mark Shinwell and Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/856">GPR#856</a>: Register availability analysis.<br />
(Mark Shinwell, Thomas Refis, review by Pierre Chambart)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1143">GPR#1143</a>: tweaked several allocation functions in the runtime by
checking for likely conditions before unlikely ones and eliminating
some redundant checks.<br />
(Markus Mottl, review by Alain Frisch, Xavier Leroy, Gabriel Scherer,
Mark Shinwell and Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1183">GPR#1183</a>: compile curried functors to multi-argument functions
earlier in the compiler pipeline; correctly propagate <code>[@@inline]</code>
attributes on such functors; mark functor coercion veneers as
stubs.<br />
(Mark Shinwell, review by Pierre Chambart and Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1195">GPR#1195</a>: Merge functions based on partiality rather than
<code>Parmatch.irrefutable</code>.
(Leo White, review by Thomas Refis, Alain Frisch and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1215">GPR#1215</a>: Improve compilation of short-circuit operators
(Leo White, review by Frédéric Bour and Mark Shinwell)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1250">GPR#1250</a>: illegal ARM64 assembly code generated for large combined
allocations.<br />
(report and initial fix by Steve Walk, review and final fix by
Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1271">GPR#1271</a>: Don't generate Ialloc instructions for closures that exceed
<code>Max_young_wosize</code>; instead allocate them on the major heap.  (Related
to <a href="https://github.com/ocaml/ocaml/pull/1250">GPR#1250</a>.)<br />
(Mark Shinwell)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1294">GPR#1294</a>: Add a configure-time option to remove the dynamic float array
optimization and add a floatarray type to let the user choose when to
flatten float arrays. Note that float-only records are unchanged: they
are still optimized by unboxing their fields.<br />
(Damien Doligez, review by Alain Frisch and Mark Shinwell)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1304">GPR#1304</a>: Mark registers clobbered by PLT stubs as destroyed across
allocations.<br />
(Mark Shinwell, Xavier Clerc, report and initial debugging by
Valentin Gatien-Baron)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1323">GPR#1323</a>: make sure that frame tables are generated in the data
section and not in the read-only data section, as was the case
before in the PPC and System-Z ports.  This avoids relocations in
the text segment of shared libraries and position-independent
executables generated by ocamlopt.<br />
(Xavier Leroy, review by Mark Shinwell)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1330">GPR#1330</a>: when generating dynamically-linkable code on AArch64, always
reference symbols (even locally-defined ones) through the GOT.<br />
(Mark Shinwell, review by Xavier Leroy)</p>
</li>
</ul>
<h3>Tools:</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=1956">MPR#1956</a>, <a href="https://github.com/ocaml/ocaml/pull/973">GPR#973</a>: tools/check-symbol-names checks for globally
linked names not namespaced with <code>caml_</code>.
(Stephen Dolan)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=6928">MPR#6928</a>, <a href="https://github.com/ocaml/ocaml/pull/1103">GPR#1103</a>: ocamldoc, do not introduce an empty <code>&lt;h1&gt;</code> in
<code>index.html</code> when no <code>-title</code> has been provided.<br />
(Pierre Boutillier)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7048">MPR#7048</a>: ocamldoc, in <code>-latex</code> mode, don't escape Latin-1 accented
letters.<br />
(Xavier Leroy, report by Hugo Herbelin)</p>
</li>
</ul>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7351">MPR#7351</a>: ocamldoc, use semantic tags rather than <code>&lt;br&gt;</code> tags in the html
backend.<br />
(Florian Angeletti, request and review by Daniel Bünzli )</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7352">MPR#7352</a>, <a href="https://caml.inria.fr/mantis/view.php?id=7353">MPR#7353</a>: ocamldoc, better paragraphs in html output.<br />
(Florian Angeletti, request by Daniel Bünzli)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7363">MPR#7363</a>, <a href="https://github.com/ocaml/ocaml/pull/830">GPR#830</a>: ocamldoc, start heading levels at <code>{1</code> not <code>{2</code> or <code>{6</code>.
This change modifies the mapping between ocamldoc heading level and
html heading level, breaking custom css style for ocamldoc.<br />
(Florian Angeletti, request and review by Daniel Bünzli)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7478">MPR#7478</a>, <a href="https://github.com/ocaml/ocaml/pull/1037">GPR#1037</a>: ocamldoc, do not use as a module preamble documentation
comments that occur after the first module element. This change may break
existing documentation. In particular, module preambles must now come before
any <code>open</code> statement.<br />
(Florian Angeletti, review by David Allsopp and report by Daniel Bünzli)</p>
</li>
</ul>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7521">MPR#7521</a>, <a href="https://github.com/ocaml/ocaml/pull/1159">GPR#1159</a>: ocamldoc, end generated latex file with a new
line.<br />
(Florian Angeletti)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7575">MPR#7575</a>, <a href="https://github.com/ocaml/ocaml/pull/1219">GPR#1219</a>: Switch compilers from <code>-no-keep-locs</code>
to <code>-keep-locs</code> by default: produced <code>.cmi</code> files will contain locations.
This provides better error messages. Note that, as a consequence,
<code>.cmi</code> digests now depend on the file path as given to the
compiler.<br />
(Daniel Bünzli)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7610">MPR#7610</a>, <a href="https://github.com/ocaml/ocaml/pull/1346">GPR#1346</a>: <code>caml.el</code> (the Emacs editing mode) was cleaned up
and made compatible with Emacs 25.<br />
(Stefan Monnier, Christophe Troestler)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7635">MPR#7635</a>, <a href="https://github.com/ocaml/ocaml/pull/1383">GPR#1383</a>: ocamldoc, add an identifier to module
and module type elements.<br />
(Florian Angeletti, review by Yawar Amin and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/681">GPR#681</a>, <a href="https://github.com/ocaml/ocaml/pull/1426">GPR#1426</a>: Introduce ocamltest, a new test driver for the
OCaml compiler testsuite.<br />
(Sébastien Hinderer, review by Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1012">GPR#1012</a>: ocamlyacc, fix parsing of raw strings and nested comments,
as well as the handling of <code>'</code> characters in identifiers.<br />
(Demi Obenour)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1045">GPR#1045</a>: ocamldep, add a <code>-shared</code> option to generate dependencies
for native plugin files (i.e., <code>.cmxs</code> files).<br />
(Florian Angeletti, suggestion by Sébastien Hinderer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1078">GPR#1078</a>: add a subcommand <code>-depend</code> to <code>ocamlc</code> and <code>ocamlopt</code>, to
behave as ocamldep.  Should be used mostly to replace <code>ocamldep</code> in
the <code>boot</code> directory to reduce its size in the future.<br />
(Fabrice Le Fessant)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1036">GPR#1036</a>: <code>ocamlcmt</code> (<code>tools/read_cmt</code>) is installed, converts <code>.cmt</code>
to <code>.annot</code>.<br />
(Fabrice Le Fessant)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1180">GPR#1180</a>: Add support for recording numbers of direct and indirect
calls over the lifetime of a program when using Spacetime
profiling.<br />
(Mark Shinwell)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1457">GPR#1457</a>, ocamldoc: restore label for exception in the LaTeX backend
(omitted since 4.04.0).<br />
(Florian Angeletti, review by Gabriel Scherer)</p>
</li>
</ul>
<h3>Toplevel:</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7570">MPR#7570</a>: remove unusable <code>-plugin</code> option from the toplevel.<br />
(Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1041">GPR#1041</a>: <code>-nostdlib</code> no longer ignored by toplevel.<br />
(David Allsopp, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1231">GPR#1231</a>: improved printing of unicode texts in the toplevel,
unless <code>OCAMLTOP_UTF_8</code> is set to false.<br />
(Florian Angeletti, review by Daniel Bünzli, Xavier Leroy and
Gabriel Scherer)</p>
</li>
</ul>
<h3>Runtime system:</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=3771">MPR#3771</a>, <a href="https://github.com/ocaml/ocaml/pull/153">GPR#153</a>, <a href="https://github.com/ocaml/ocaml/pull/1200">GPR#1200</a>, <a href="https://github.com/ocaml/ocaml/pull/1357">GPR#1357</a>, <a href="https://github.com/ocaml/ocaml/pull/1362">GPR#1362</a>, <a href="https://github.com/ocaml/ocaml/pull/1363">GPR#1363</a>, <a href="https://github.com/ocaml/ocaml/pull/1369">GPR#1369</a>, <a href="https://github.com/ocaml/ocaml/pull/1398">GPR#1398</a>,
<a href="https://github.com/ocaml/ocaml/pull/1446">GPR#1446</a>, <a href="https://github.com/ocaml/ocaml/pull/1448">GPR#1448</a>: Unicode support for the Windows runtime.<br />
(ygrek, Nicolas Ojeda Bar, review by Alain Frisch, David Allsopp, Damien
Doligez)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7594">MPR#7594</a>, <a href="https://github.com/ocaml/ocaml/pull/1274">GPR#1274</a>, <a href="https://github.com/ocaml/ocaml/pull/1368">GPR#1368</a>: <code>String_val</code> now returns <code>const char*</code>, not <code>char*</code> when <code>-safe-string</code> is enabled at configure time.
New macro <code>Bytes_val</code> for accessing bytes values.<br />
(Jeremy Yallop, reviews by Mark Shinwell and Xavier Leroy)</p>
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/71">GPR#71</a>: The runtime can now be shut down gracefully by means of the
new <code>caml_shutdown</code> and <code>caml_startup_pooled</code> functions. The new <code>c</code>
flag in <code>OCAMLRUNPARAM</code> enables shutting the runtime properly on
process exit.<br />
(Max Mouratov, review and discussion by Damien Doligez, Gabriel
Scherer, Mark Shinwell, Thomas Braibant, Stephen Dolan, Pierre
Chambart, François Bobot, Jacques Garrigue, David Allsopp, and Alain
Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/938">GPR#938</a>, <a href="https://github.com/ocaml/ocaml/pull/1170">GPR#1170</a>, <a href="https://github.com/ocaml/ocaml/pull/1289">GPR#1289</a>: Stack overflow detection on 64-bit
Windows.<br />
(Olivier Andrieu, tweaked by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1070">GPR#1070</a>, <a href="https://github.com/ocaml/ocaml/pull/1295">GPR#1295</a>: enable gcc typechecking for <code>caml_alloc_sprintf</code>,
<code>caml_gc_message</code>.  Make <code>caml_gc_message</code> a variadic function.  Fix
many <code>caml_gc_message</code> format strings.<br />
(Olivier Andrieu, review and 32bit fix by David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1073">GPR#1073</a>: Remove statically allocated compare stack.<br />
(Stephen Dolan)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1086">GPR#1086</a>: in <code>Sys.getcwd</code>, just fail instead of calling <code>getwd()</code>
if <code>HAS_GETCWD</code> is not set.<br />
(Report and first fix by Sebastian Markbåge, final fix by Xavier Leroy,
review by MarK Shinwell)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1269">GPR#1269</a>: Remove 50ms delay at exit for programs using threads.<br />
(Valentin Gatien-Baron, review by Stephen Dolan)</p>
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/1309">GPR#1309</a>: open files with <code>O_CLOEXEC</code> (or equivalent) in
<code>caml_sys_open</code>, thus unifying the semantics between Unix and
Windows and also eliminating race condition on Unix.<br />
(David Allsopp, report by Andreas Hauptmann)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1326">GPR#1326</a>: Enable use of CFI directives in AArch64 and ARM runtime
systems' assembly code (<code>asmrun/arm64.S</code>).  Add CFI directives to
enable unwinding through <code>caml_c_call</code> and <code>caml_call_gc</code> with
correct termination of unwinding at <code>main</code>.<br />
(Mark Shinwell, review by Xavier Leroy and Gabriel Scherer, with
thanks to Daniel Bünzli and Fu Yong Quah for testing)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1338">GPR#1338</a>: Add <code>-g</code> for bytecode runtime system compilation.<br />
(Mark Shinwell)</p>
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/1416">GPR#1416</a>, <a href="https://github.com/ocaml/ocaml/pull/1444">GPR#1444</a>: switch the Windows 10 Console to UTF-8
encoding.<br />
(David Allsopp, reviews by Nicolás Ojeda Bär and Xavier Leroy)
</li>
</ul>
<h3>Manual and documentation:</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=6548">MPR#6548</a>: remove obsolete limitation in the description of private
type abbreviations.<br />
(Florian Angeletti, suggestion by Leo White)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=6676">MPR#6676</a>, <a href="https://github.com/ocaml/ocaml/pull/1110">GPR#1110</a>: move record notation to tutorial.<br />
(Florian Angeletti, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=6676">MPR#6676</a>, <a href="https://github.com/ocaml/ocaml/pull/1112">GPR#1112</a>: move local opens to tutorial.<br />
(Florian Angeletti)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=6676">MPR#6676</a>, <a href="https://github.com/ocaml/ocaml/pull/1153">GPR#1153</a>: move overriding class definitions to reference
manual and tutorial.<br />
(Florian Angeletti)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=6709">MPR#6709</a>: document the associativity and precedence level of
pervasive operators.<br />
(Florian Angeletti, review by David Allsopp)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7254">MPR#7254</a>, <a href="https://github.com/ocaml/ocaml/pull/1096">GPR#1096</a>: Rudimentary documentation of ocamlnat.<br />
(Mark Shinwell)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7281">MPR#7281</a>, <a href="https://github.com/ocaml/ocaml/pull/1259">GPR#1259</a>: fix <code>.TH</code> macros in generated manpages.<br />
(Olaf Hering)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7507">MPR#7507</a>: Align the description of the printf conversion
specification <code>&quot;%g&quot;</code> with the ISO C90 description.<br />
(Florian Angeletti, suggestion by Armaël Guéneau)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7551">MPR#7551</a>, <a href="https://github.com/ocaml/ocaml/pull/1194">GPR#1194</a> : make the final <code>&quot;;;&quot;</code> potentially optional in
<code>caml_example</code>.<br />
(Florian Angeletti, review and suggestion by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7588">MPR#7588</a>, <a href="https://github.com/ocaml/ocaml/pull/1291">GPR#1291</a>: make format documentation predictable.<br />
(Florian Angeletti, review by Gabriel Radanne)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7604">MPR#7604</a>: Minor Ephemeron documentation fixes.<br />
(Miod Vallat, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/594">GPR#594</a>: New chapter on polymorphism troubles:
weakly polymorphic types, polymorphic recursion,and higher-ranked
polymorphism.<br />
(Florian Angeletti, review by Damien Doligez, Gabriel Scherer,
and Gerd Stolpmann)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1187">GPR#1187</a>: Minimal documentation for compiler plugins.<br />
(Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1202">GPR#1202</a>: Fix Typos in comments as well as basic grammar errors.<br />
(JP Rodi, review and suggestions by David Allsopp, Max Mouratov,
Florian Angeletti, Xavier Leroy, Mark Shinwell and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1220">GPR#1220</a>: Fix <code>-keep-docs</code> option in ocamlopt manpage.<br />
(Etienne Millon)</p>
</li>
</ul>
<h3>Compiler distribution build system:</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=6373">MPR#6373</a>, <a href="https://github.com/ocaml/ocaml/pull/1093">GPR#1093</a>: Suppress trigraph warnings from macOS
assembler.<br />
(Mark Shinwell)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7639">MPR#7639</a>, <a href="https://github.com/ocaml/ocaml/pull/1371">GPR#1371</a>: fix configure script for correct detection of
int64 alignment on Mac OS X 10.13 (High Sierra) and above; fix bug in
configure script relating to such detection.<br />
(Mark Shinwell, report by John Whitington, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/558">GPR#558</a>: enable shared library and natdynlink support on more Linux
platforms.<br />
(Felix Janda, Mark Shinwell)</p>
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/1104">GPR#1104</a>: remove support for the NeXTStep platform.<br />
(Sébastien Hinderer)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1130">GPR#1130</a>: enable detection of IBM XL C compiler (one need to run
configure with <code>-cc &lt;path to xlc compiler&gt;</code>).  Enable shared library
support for bytecode executables on AIX/xlc (tested on AIX 7.1, XL C
12).  To enable 64-bit, run both <code>configure</code> and <code>make world</code> with
<code>OBJECT_MODE=64</code>.<br />
(Konstantin Romanov, Enrique Naudon)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1203">GPR#1203</a>: speed up the manual build by using <code>ocamldoc.opt</code>.<br />
(Gabriel Scherer, review by Florian Angeletti)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1214">GPR#1214</a>: harden <code>config/Makefile</code> against <code>#</code> characters in
PREFIX.<br />
(Gabriel Scherer, review by David Allsopp and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1216">GPR#1216</a>: move Compplugin and friends from <code>BYTECOMP</code> to <code>COMP</code>.<br />
(Leo White, review by Mark Shinwell)</p>
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/1242">GPR#1242</a>: disable C plugins loading by default.<br />
(Alexey Egorov)
</li>
</ul>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1275">GPR#1275</a>: correct configure test for Spacetime availability.<br />
(Mark Shinwell)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1278">GPR#1278</a>: discover presence of <code>&lt;sys/shm.h&gt;</code> during configure for
afl runtime.<br />
(Hannes Mehnert)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1386">GPR#1386</a>: provide configure-time options to fine-tune the safe-string
options and default settings changed by <a href="https://github.com/ocaml/ocaml/pull/1525">GPR#1525</a>.</p>
<p>The previous configure option <code>-safe-string</code> is now
renamed <code>-force-safe-string</code>.</p>
<p>At configure-time, <code>-force-safe-string</code> forces all module to use
immutable strings (this disables the per-file, compile-time
<code>-unsafe-string</code> option). The new default-(un)safe-string options
let you set the default choice for the per-file compile-time
option. (The new <a href="https://github.com/ocaml/ocaml/pull/1252">GPR#1252</a> behavior corresponds to having
<code>-default-safe-string</code>, while 4.05 and older had
<code>-default-unsafe-string</code>).</p>
<p>(Gabriel Scherer, review by Jacques-Pascal Deplaix and Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1409">GPR#1409</a>: Fix to enable NetBSD/powerpc to work.<br />
(Håvard Eidnes)</p>
</li>
</ul>
<h3>Internal/compiler-libs changes:</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=6826">MPR#6826</a>, <a href="https://github.com/ocaml/ocaml/pull/828">GPR#828</a>, <a href="https://github.com/ocaml/ocaml/pull/834">GPR#834</a>: improve compilation time for <code>open</code>.<br />
(Alain Frisch, review by Frédéric Bour and Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7127">MPR#7127</a>, <a href="https://github.com/ocaml/ocaml/pull/454">GPR#454</a>, <a href="https://github.com/ocaml/ocaml/pull/1058">GPR#1058</a>: in toplevel, print bytes and strip
strings longer than the size specified by the <code>print_length</code>
directive.<br />
(Fabrice Le Fessant, initial PR by Junsong Li)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/406">GPR#406</a>: remove polymorphic comparison for <code>Types.constructor_tag</code>
in compiler.<br />
(Dwight Guth, review by Gabriel Radanne, Damien Doligez, Gabriel
Scherer, Pierre Chambart, Mark Shinwell)</p>
</li>
<li>
<p>GRP#1119: Change Set (private) type to inline records.<br />
(Albin Coquereau)</p>
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/1127">GPR#1127</a>: move <code>config/{m,s}.h</code> to <code>byterun/caml</code> and install them.
User code should not have to include them directly since they are
included by other header files.  Previously <code>{m,s}.h</code> were not
installed but they were substituted into <code>caml/config.h</code>; they are
now just <code>#include</code>-d by this file.  This may break some scripts
relying on the (unspecified) presence of certain <code>#define</code> in
<code>config.h</code> instead of <code>m.h</code> and <code>s.h</code> — they can be rewritten to try
to grep those files if they exist.<br />
(Sébastien Hinderer)
</li>
</ul>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/1281">GPR#1281</a>: avoid formatter flushes inside exported printers in
<code>Location</code>.<br />
(Florian Angeletti, review by Gabriel Scherer)
</li>
</ul>
<h3>Bug fixes</h3>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=5927">MPR#5927</a>: Type equality broken for conjunctive polymorphic variant
tags.<br />
(Jacques Garrigue, report by Leo White)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=6329">MPR#6329</a>, <a href="https://github.com/ocaml/ocaml/pull/1437">GPR#1437</a>: Introduce padding word before &quot;data_end&quot; symbols
to ensure page table tests work correctly on an immediately preceding
block of zero size.<br />
(Mark Shinwell, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=6587">MPR#6587</a>: only elide Pervasives from printed type paths in
unambiguous context.<br />
(Florian Angeletti and Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=6934">MPR#6934</a>: <code>nonrec</code> misbehaves with GADTs.<br />
(Jacques Garrigue, report by Markus Mottl)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7070">MPR#7070</a>, <a href="https://github.com/ocaml/ocaml/pull/1139">GPR#1139</a>: Unexported values can cause non-generalisable
variables error.<br />
(Leo White)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7261">MPR#7261</a>: Warn on type constraints in GADT declarations.<br />
(Jacques Garrigue, report by Fabrice Le Botlan)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7321">MPR#7321</a>: Private type in signature clashes with type definition via
functor instantiation.<br />
(Jacques Garrigue, report by Markus Mottl)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7372">MPR#7372</a>, <a href="https://github.com/ocaml/ocaml/pull/834">GPR#834</a>: fix type-checker bug with GADT and inline
records.<br />
(Alain Frisch, review by Frédéric Bour and Jacques Garrigue)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7344">MPR#7344</a>: Inconsistent behavior with type annotations on <code>let</code>.<br />
(Jacques Garrigue, report by Leo White)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7468">MPR#7468</a>: possible GC problem in <code>caml_alloc_sprintf</code>.<br />
(Xavier Leroy, discovery by Olivier Andrieu)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7496">MPR#7496</a>: Fixed conjunctive polymorphic variant tags do not unify
with themselves.<br />
(Jacques Garrigue, report by Leo White)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7506">MPR#7506</a>: <code>pprintast</code> ignores attributes in tails of a list.<br />
(Alain Frisch, report by Kenichi Asai and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7513">MPR#7513</a>: <code>List.compare_length_with</code> mishandles negative numbers /
overflow.<br />
(Fabrice Le Fessant, report by Jeremy Yallop)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7519">MPR#7519</a>: Incorrect rejection of program due to faux scope escape.<br />
(Jacques Garrigue, report by Markus Mottl)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7540">MPR#7540</a>, <a href="https://github.com/ocaml/ocaml/pull/1179">GPR#1179</a>: Fixed setting of breakpoints within packed modules
for <code>ocamldebug</code>.<br />
(Hugo Herbelin, review by Gabriel Scherer, Damien Doligez)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7543">MPR#7543</a>: short-paths <code>printtyp</code> can fail on packed type error
messages.<br />
(Florian Angeletti)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7553">MPR#7553</a>, <a href="https://github.com/ocaml/ocaml/pull/1191">GPR#1191</a>: Prevent repeated warnings with recursive
modules.<br />
(Leo White, review by Josh Berdine and Alain Frisch)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7563">MPR#7563</a>, <a href="https://github.com/ocaml/ocaml/pull/1210">GPR#1210</a>: code generation bug when a module alias and
an extension constructor have the same name in the same module.<br />
(Gabriel Scherer, report by Manuel Fähndrich,
review by Jacques Garrigue and Leo White)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7591">MPR#7591</a>, <a href="https://github.com/ocaml/ocaml/pull/1257">GPR#1257</a>: on x86-64, frame table is not 8-aligned.<br />
(Xavier Leroy, report by Mantis user &quot;voglerr&quot;, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7601">MPR#7601</a>, <a href="https://github.com/ocaml/ocaml/pull/1320">GPR#1320</a>: It seems like a hidden non-generalized type variable
remains in some inferred signatures, which leads to strange errors.<br />
(Jacques Garrigue, report by Mandrikin)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7609">MPR#7609</a>: use-after-free memory corruption if a program debugged
under ocamldebug calls <code>Pervasives.flush_all</code>.<br />
(Xavier Leroy, report by Paul Steckler, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7612">MPR#7612</a>, <a href="https://github.com/ocaml/ocaml/pull/1345">GPR#1345</a>: afl-instrumentation bugfix for classes.<br />
(Stephen Dolan, review by Gabriel Scherer and David Allsopp)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7617">MPR#7617</a>, <a href="https://caml.inria.fr/mantis/view.php?id=7618">MPR#7618</a>, <a href="https://github.com/ocaml/ocaml/pull/1318">GPR#1318</a>: Ambiguous (mistakenly) type escaping the
scope of its equation.<br />
(Jacques Garrigue, report by Thomas Refis)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7619">MPR#7619</a>, <a href="https://github.com/ocaml/ocaml/pull/1387">GPR#1387</a>: position of the optional last semi-column not included
in the position of the expression (same behavior as for lists).<br />
(Christophe Raffalli, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7638">MPR#7638</a>: in the Windows Mingw64 port, multithreaded programs compiled
to bytecode could crash when raising an exception from C code.
This looks like a Mingw64 issue, which we work around with GCC
builtins.<br />
(Xavier Leroy)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7656">MPR#7656</a>, <a href="https://github.com/ocaml/ocaml/pull/1423">GPR#1423</a>: false 'unused type/constructor/value' alarms
in the 4.06 development version.<br />
(Alain Frisch, review by Jacques Garrigue, report by Jacques-Pascal Deplaix)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7657">MPR#7657</a>, <a href="https://github.com/ocaml/ocaml/pull/1424">GPR#1424</a>: ensures correct call-by-value semantics when
eta-expanding functions to eliminate optional arguments.<br />
(Alain Frisch, report by sliquister, review by Leo White and Jacques
Garrigue)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7658">MPR#7658</a>, <a href="https://github.com/ocaml/ocaml/pull/1439">GPR#1439</a>: Fix Spacetime runtime system compilation with
<code>-force-safe-string</code>.<br />
(Mark Shinwell, report by Christoph Spiel, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1155">GPR#1155</a>: Fix a race condition with <code>WAIT_NOHANG</code> on Windows.<br />
(Jérémie Dimino and David Allsopp)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1199">GPR#1199</a>: Pretty-printing formatting cleanup in <code>pprintast</code>.<br />
(Ethan Aubin, suggestion by Gabriel Scherer, review by David Allsopp,
Florian Angeletti, and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1223">GPR#1223</a>: Fix corruption of the environment when using <code>-short-paths</code>
with the toplevel.<br />
(Leo White, review by Alain Frisch)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1243">GPR#1243</a>: Fix <code>pprintast</code> for <code>#...</code> infix operators.<br />
(Alain Frisch, report by Omar Chebib)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1324">GPR#1324</a>: ensure that flambda warning are printed only once.<br />
(Xavier Clerc)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1329">GPR#1329</a>: Prevent recursive polymorphic variant names.<br />
(Jacques Garrigue, fix suggested by Leo White)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1308">GPR#1308</a>: Only treat pure patterns as inactive.<br />
(Leo White, review by Alain Frisch and Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1390">GPR#1390</a>: fix the <code>[@@unboxed]</code> type check to accept parametrized
types.<br />
(Leo White, review by Damien Doligez)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1407">GPR#1407</a>: Fix <code>raw_spacetime_lib</code>.<br />
(Leo White, review by Gabriel Scherer and Damien Doligez)</p>
</li>
</ul>
|js}
  };
 
  { kind = `Compiler
  ; version = {js|4.05.0|js}
  ; date = {js|2017-07-13|js}
  ; intro_md = {js|This page describes OCaml version **4.05.0**, released on 2017-07-13.
|js}
  ; intro_html = {js|<p>This page describes OCaml version <strong>4.05.0</strong>, released on 2017-07-13.</p>
|js}
  ; highlights_md = {js|- Some improvements in performance and usability. - Many bug fixes
|js}
  ; highlights_html = {js|<ul>
<li>Some improvements in performance and usability. - Many bug fixes
</li>
</ul>
|js}
  ; body_md = {js|
Opam Switches
-------------

This release is available as multiple [OPAM](https://opam.ocaml.org/doc/Usage.html) switches:

- 4.05.0 — Official 4.05.0 release
- 4.05.0+flambda — Official 4.05.0 release with flambda enabled
- 4.05.0+fp — Official 4.05.0 release with frame pointers
- 4.05.0+safe-string - Official 4.05.0 release with `-safe-string` enabled
- 4.05.0+spacetime - Official 4.05.0 release with [`-spacetime` profiling](http://caml.inria.fr/pub/docs/manual-ocaml/spacetime.html) enabled
- 4.05.0+afl — Official 4.05.0 release with support for afl-fuzz instrumentation

## What's new

OCaml 4.05 comprises mainly bug fixes, with some improvements in
performance and usability.
For a comprehensive list of changes and details on all new features,
bug fixes, optimizations, etc., please consult the
[changelog](4.05/notes/Changes). There
is also a crowdsourced [annotated
changelog for 4.05.0](https://github.com/gasche/ocaml-releases-change-explanation/wiki/4.05.0-changes-explanation) which contains extra commentaries and examples.

## Source distribution

- [Source
  tarball](https://github.com/ocaml/ocaml/archive/4.05.0.tar.gz)
  (.tar.gz) for compilation under Unix (including Linux and MacOS X)
  and Microsoft Windows (including Cygwin).

- Also available in
  [.zip](https://github.com/ocaml/ocaml/archive/4.05.0.zip)
  format.

- [OPAM](https://opam.ocaml.org/) is a source-based distribution of
  OCaml and many companion libraries and tools. Compilation and
  installation are automated by powerful package managers.

- The official development repo is hosted on
  [GitHub](https://github.com/ocaml/ocaml).

The [INSTALL](4.05/notes/INSTALL.adoc)
file of the distribution provides detailed compilation and
installation instructions -- see also the [Windows release
notes](4.05/notes/README.win32.adoc) for instructions on how to build under Windows.

## Alternative Compilers

Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:

* [Js_of_ocaml](http://ocsigen.org/js_of_ocaml/) is a stable OCaml
  to JavaScript compiler.

* [Bucklescript](http://bucklescript.github.io/bucklescript/) is a newer
  OCaml to JavaScript compiler. See its
  [wiki](https://github.com/bucklescript/bucklescript/wiki/Differences-from-js_of_ocaml)
  for an explanation of how it differs from js_of_ocaml.

* [OCaml-java](http://www.ocamljava.org/) is a stable OCaml to
  Java compiler.

## User's manual

The user's manual for OCaml can be:

- [browsed
  online](4.05/htmlman/index.html),

- downloaded as a single
  [PostScript](4.05/ocaml-4.05-refman.ps.gz),
  [PDF](4.05/ocaml-4.05-refman.pdf),
  or [plain
  text](4.05/ocaml-4.05-refman.txt)
  document,

- downloaded as a single
  [TAR](4.05/ocaml-4.05-refman-html.tar.gz)
  or
  [ZIP](4.05/ocaml-4.05-refman-html.zip)
  archive of HTML files,

- downloaded as a single
  [tarball](4.05/ocaml-4.05-refman.info.tar.gz)
  of Emacs info files,


|js}
  ; body_html = {js|<h2>Opam Switches</h2>
<p>This release is available as multiple <a href="https://opam.ocaml.org/doc/Usage.html">OPAM</a> switches:</p>
<ul>
<li>4.05.0 — Official 4.05.0 release
</li>
<li>4.05.0+flambda — Official 4.05.0 release with flambda enabled
</li>
<li>4.05.0+fp — Official 4.05.0 release with frame pointers
</li>
<li>4.05.0+safe-string - Official 4.05.0 release with <code>-safe-string</code> enabled
</li>
<li>4.05.0+spacetime - Official 4.05.0 release with <a href="http://caml.inria.fr/pub/docs/manual-ocaml/spacetime.html"><code>-spacetime</code> profiling</a> enabled
</li>
<li>4.05.0+afl — Official 4.05.0 release with support for afl-fuzz instrumentation
</li>
</ul>
<h2>What's new</h2>
<p>OCaml 4.05 comprises mainly bug fixes, with some improvements in
performance and usability.
For a comprehensive list of changes and details on all new features,
bug fixes, optimizations, etc., please consult the
<a href="4.05/notes/Changes">changelog</a>. There
is also a crowdsourced <a href="https://github.com/gasche/ocaml-releases-change-explanation/wiki/4.05.0-changes-explanation">annotated
changelog for 4.05.0</a> which contains extra commentaries and examples.</p>
<h2>Source distribution</h2>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/archive/4.05.0.tar.gz">Source
tarball</a>
(.tar.gz) for compilation under Unix (including Linux and MacOS X)
and Microsoft Windows (including Cygwin).</p>
</li>
<li>
<p>Also available in
<a href="https://github.com/ocaml/ocaml/archive/4.05.0.zip">.zip</a>
format.</p>
</li>
<li>
<p><a href="https://opam.ocaml.org/">OPAM</a> is a source-based distribution of
OCaml and many companion libraries and tools. Compilation and
installation are automated by powerful package managers.</p>
</li>
<li>
<p>The official development repo is hosted on
<a href="https://github.com/ocaml/ocaml">GitHub</a>.</p>
</li>
</ul>
<p>The <a href="4.05/notes/INSTALL.adoc">INSTALL</a>
file of the distribution provides detailed compilation and
installation instructions -- see also the <a href="4.05/notes/README.win32.adoc">Windows release
notes</a> for instructions on how to build under Windows.</p>
<h2>Alternative Compilers</h2>
<p>Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:</p>
<ul>
<li>
<p><a href="http://ocsigen.org/js_of_ocaml/">Js_of_ocaml</a> is a stable OCaml
to JavaScript compiler.</p>
</li>
<li>
<p><a href="http://bucklescript.github.io/bucklescript/">Bucklescript</a> is a newer
OCaml to JavaScript compiler. See its
<a href="https://github.com/bucklescript/bucklescript/wiki/Differences-from-js_of_ocaml">wiki</a>
for an explanation of how it differs from js_of_ocaml.</p>
</li>
<li>
<p><a href="http://www.ocamljava.org/">OCaml-java</a> is a stable OCaml to
Java compiler.</p>
</li>
</ul>
<h2>User's manual</h2>
<p>The user's manual for OCaml can be:</p>
<ul>
<li>
<p><a href="4.05/htmlman/index.html">browsed
online</a>,</p>
</li>
<li>
<p>downloaded as a single
<a href="4.05/ocaml-4.05-refman.ps.gz">PostScript</a>,
<a href="4.05/ocaml-4.05-refman.pdf">PDF</a>,
or <a href="4.05/ocaml-4.05-refman.txt">plain
text</a>
document,</p>
</li>
<li>
<p>downloaded as a single
<a href="4.05/ocaml-4.05-refman-html.tar.gz">TAR</a>
or
<a href="4.05/ocaml-4.05-refman-html.zip">ZIP</a>
archive of HTML files,</p>
</li>
<li>
<p>downloaded as a single
<a href="4.05/ocaml-4.05-refman.info.tar.gz">tarball</a>
of Emacs info files,</p>
</li>
</ul>
|js}
  };
 
  { kind = `Compiler
  ; version = {js|4.04.0|js}
  ; date = {js|2017-06-23|js}
  ; intro_md = {js|This page describes OCaml version **4.04.2**, released on 2017-06-23.
|js}
  ; intro_html = {js|<p>This page describes OCaml version <strong>4.04.2</strong>, released on 2017-06-23.</p>
|js}
  ; highlights_md = {js|- Exceptions can be declared locally within an expression, with syntax
  `let exception ... in ...`
- Optimized memory representation for immutable records with a single
  field, and concrete types with a single constructor with a single
  argument. This is triggered with a `@@unboxed` attribute on the type
  definition.
- Support for the Spacetime memory profiler was added.
|js}
  ; highlights_html = {js|<ul>
<li>Exceptions can be declared locally within an expression, with syntax
<code>let exception ... in ...</code>
</li>
<li>Optimized memory representation for immutable records with a single
field, and concrete types with a single constructor with a single
argument. This is triggered with a <code>@@unboxed</code> attribute on the type
definition.
</li>
<li>Support for the Spacetime memory profiler was added.
</li>
</ul>
|js}
  ; body_md = {js|
Opam Switches
-------------

This release is available as multiple OPAM switches:

- 4.04.2 — Official 4.04.2 release
- 4.04.2+flambda — Official 4.04.2 release with flambda enabled
- 4.04.2+fp — Official 4.04.2 release with frame pointers
- 4.04.2+fp+flambda — Official 4.04.2 release with frame pointers and flambda enabled
- 4.04.2+safe-string - Official 4.04.2 release with `-safe-string` enabled

For a comprehensive list of changes and details on all new features,
bug fixes, optimizations, etc., please consult the
[changelog](4.04/notes/Changes). There
is also a crowdsourced [annotated
changelog for 4.04.0](https://github.com/gasche/ocaml-releases-change-explanation/wiki/4.04.0-changes-explanation).

### Security Updates

The 4.04.2 release features an important security update, described in
the security advisory below.

```
CVE-2017-9772: Privilege escalation in OCaml runtime for SUID executables

The environment variables CAML_CPLUGINS, CAML_NATIVE_CPLUGINS, and
CAML_BYTE_CPLUGINS can be used to auto-load code into any ocamlopt-compiled
executable or any ocamlc-compiled executable in ‘custom runtime mode’.
This can lead to privilege escalation if the executable is marked setuid.

Vulnerable versions: OCaml 4.04.0 and 4.04.1

Workarounds:
  - Upgrade to OCaml 4.04.2 or higher.
or - Compile the OCaml distribution with the "-no-cplugins" configure option.
or - OPAM users can "opam update && opam switch recompile 4.04.1", as
    the repository has had backported patches applied.

Impact: This only affects binaries that have been installed on Unix-like
operating systems (including Linux and macOS) with the setuid bit set.
However, in that situation, any user who execute the program gains all
the privileges of the owner of the executable (meaning that root-owned
setuid executables provide root access).

Fix: OCaml 4.04.2 mitigates this by modifying Sys.getenv and Unix.getenv
to raise an exception if the process has ever had elevated privileges.
The OCaml runtime has also been modified to use this function for
retrieving all of the runtime environment variables which could potentially
cause files to be accessed or modified.  The older behaviour is available
in the `caml_sys_unsafe_getenv` primitive for applications that require
strict compatibility.

Credits: This was originally reported by Eric Milliken on the OCaml Mantis
bug tracker. https://caml.inria.fr/mantis/view.php?id=7557

CVSS v2 Vector:
AV:L/AC:L/Au:S/C:C/I:C/A:N/E:F/RL:OF/RC:C/CDP:H/TD:L/CR:H/IR:H/AR:L
CWE ID: 114
```

## What's new

Some of the highlights in release 4.04 are:

- Exceptions can be declared locally within an expression, with syntax
  `let exception ... in ...`

- Optimized memory representation for immutable records with a single
  field, and concrete types with a single constructor with a single
  argument. This is triggered with a `@@unboxed` attribute on the type
  definition.

- Support for the Spacetime memory profiler was added.

For a comprehensive list of changes and details on all new features,
bug fixes, optimizations, etc., please consult the
[changelog](4.04/notes/Changes).


## Source distribution

- [Source
  tarball](https://github.com/ocaml/ocaml/archive/4.04.2.tar.gz)
  (.tar.gz) for compilation under Unix (including Linux and MacOS X)
  and Microsoft Windows (including Cygwin).

- Also available in
  [.zip](https://github.com/ocaml/ocaml/archive/4.04.2.zip)
  format.

- [OPAM](https://opam.ocaml.org/) is a source-based distribution of
  OCaml and many companion libraries and tools. Compilation and
  installation are automated by powerful package managers.

- The official development repo is hosted on
  [GitHub](https://github.com/ocaml/ocaml).

The [INSTALL](4.04/notes/INSTALL.adoc)
file of the distribution provides detailed compilation and
installation instructions.


## Binary distributions for Linux

Binary distributions for CentOS, Debian, Fedora, RHEL, Ubuntu are
available
[here](http://software.opensuse.org/download.html?project=home%3Aocaml&package=ocaml).


## Binary distribution for Microsoft Windows

Four ports of OCaml for Microsoft Windows are currently available. For
additional information, please consult the list of [portability
issues](/learn/portability.html) or the
[Windows release
notes](4.04/notes/README.win32.adoc).

- [Cygwin-based native Win32
  port](http://protz.github.com/ocaml-installer/). A self
  installer. The interactive loop comes with a simple graphical user
  interface. Some features require the Cygwin environment, which the
  installer can fetch for you. However, the compilers are, and
  generate true Win32 executables, which do not require Cygwin to run.

- Microsoft-based native Win32 port. No binary distribution available
  yet; download the source distribution and compile it.

- [Cygwin](http://cygwin.com/)-based port. Requires Cygwin. No
  graphical user interface is provided. The compilers generate
  executables that do require Cygwin. The precompiled binaries are
  part of the Cygwin distribution; you can install them using the
  Cygwin setup tool. Alternatively, download the source distribution
  and compile it under Cygwin.

- Microsoft-based native Win64 port Same features as the
  Microsoft-based native Win32 port, but generates 64-bit code. No
  binary distribution available yet; download the source distribution
  and compile it.


## Precompiled binaries for Solaris

Available at [sunfreeware.com](http://sunfreeware.com/).


## Alternative Compilers

Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:

* [Js_of_ocaml](http://ocsigen.org/js_of_ocaml/) is a stable OCaml
  to JavaScript compiler.

* [Bucklescript](http://bucklescript.github.io/bucklescript/) is a newer
  OCaml to JavaScript compiler. See its
  [wiki](https://github.com/bucklescript/bucklescript/wiki/Differences-from-js_of_ocaml)
  for an explanation of how it differs from js_of_ocaml.

* [OCaml-java](http://www.ocamljava.org/) is a stable OCaml to
  Java compiler.


## User's manual

The user's manual for OCaml can be:

- [browsed
  online](4.04/htmlman/index.html),

- downloaded as a single
  [PostScript](4.04/ocaml-4.04-refman.ps.gz),
  [PDF](4.04/ocaml-4.04-refman.pdf),
  or [plain
  text](4.04/ocaml-4.04-refman.txt)
  document,

- downloaded as a single
  [TAR](4.04/ocaml-4.04-refman-html.tar.gz)
  or
  [ZIP](4.04/ocaml-4.04-refman-html.zip)
  archive of HTML files,

- downloaded as a single
  [tarball](4.04/ocaml-4.04-refman.info.tar.gz)
  of Emacs info files,


|js}
  ; body_html = {js|<h2>Opam Switches</h2>
<p>This release is available as multiple OPAM switches:</p>
<ul>
<li>4.04.2 — Official 4.04.2 release
</li>
<li>4.04.2+flambda — Official 4.04.2 release with flambda enabled
</li>
<li>4.04.2+fp — Official 4.04.2 release with frame pointers
</li>
<li>4.04.2+fp+flambda — Official 4.04.2 release with frame pointers and flambda enabled
</li>
<li>4.04.2+safe-string - Official 4.04.2 release with <code>-safe-string</code> enabled
</li>
</ul>
<p>For a comprehensive list of changes and details on all new features,
bug fixes, optimizations, etc., please consult the
<a href="4.04/notes/Changes">changelog</a>. There
is also a crowdsourced <a href="https://github.com/gasche/ocaml-releases-change-explanation/wiki/4.04.0-changes-explanation">annotated
changelog for 4.04.0</a>.</p>
<p>### Security Updates</p>
<p>The 4.04.2 release features an important security update, described in
the security advisory below.</p>
<pre><code>CVE-2017-9772: Privilege escalation in OCaml runtime for SUID executables

The environment variables CAML_CPLUGINS, CAML_NATIVE_CPLUGINS, and
CAML_BYTE_CPLUGINS can be used to auto-load code into any ocamlopt-compiled
executable or any ocamlc-compiled executable in ‘custom runtime mode’.
This can lead to privilege escalation if the executable is marked setuid.

Vulnerable versions: OCaml 4.04.0 and 4.04.1

Workarounds:
  - Upgrade to OCaml 4.04.2 or higher.
or - Compile the OCaml distribution with the &quot;-no-cplugins&quot; configure option.
or - OPAM users can &quot;opam update &amp;&amp; opam switch recompile 4.04.1&quot;, as
    the repository has had backported patches applied.

Impact: This only affects binaries that have been installed on Unix-like
operating systems (including Linux and macOS) with the setuid bit set.
However, in that situation, any user who execute the program gains all
the privileges of the owner of the executable (meaning that root-owned
setuid executables provide root access).

Fix: OCaml 4.04.2 mitigates this by modifying Sys.getenv and Unix.getenv
to raise an exception if the process has ever had elevated privileges.
The OCaml runtime has also been modified to use this function for
retrieving all of the runtime environment variables which could potentially
cause files to be accessed or modified.  The older behaviour is available
in the `caml_sys_unsafe_getenv` primitive for applications that require
strict compatibility.

Credits: This was originally reported by Eric Milliken on the OCaml Mantis
bug tracker. https://caml.inria.fr/mantis/view.php?id=7557

CVSS v2 Vector:
AV:L/AC:L/Au:S/C:C/I:C/A:N/E:F/RL:OF/RC:C/CDP:H/TD:L/CR:H/IR:H/AR:L
CWE ID: 114
</code></pre>
<h2>What's new</h2>
<p>Some of the highlights in release 4.04 are:</p>
<ul>
<li>
<p>Exceptions can be declared locally within an expression, with syntax
<code>let exception ... in ...</code></p>
</li>
<li>
<p>Optimized memory representation for immutable records with a single
field, and concrete types with a single constructor with a single
argument. This is triggered with a <code>@@unboxed</code> attribute on the type
definition.</p>
</li>
<li>
<p>Support for the Spacetime memory profiler was added.</p>
</li>
</ul>
<p>For a comprehensive list of changes and details on all new features,
bug fixes, optimizations, etc., please consult the
<a href="4.04/notes/Changes">changelog</a>.</p>
<h2>Source distribution</h2>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/archive/4.04.2.tar.gz">Source
tarball</a>
(.tar.gz) for compilation under Unix (including Linux and MacOS X)
and Microsoft Windows (including Cygwin).</p>
</li>
<li>
<p>Also available in
<a href="https://github.com/ocaml/ocaml/archive/4.04.2.zip">.zip</a>
format.</p>
</li>
<li>
<p><a href="https://opam.ocaml.org/">OPAM</a> is a source-based distribution of
OCaml and many companion libraries and tools. Compilation and
installation are automated by powerful package managers.</p>
</li>
<li>
<p>The official development repo is hosted on
<a href="https://github.com/ocaml/ocaml">GitHub</a>.</p>
</li>
</ul>
<p>The <a href="4.04/notes/INSTALL.adoc">INSTALL</a>
file of the distribution provides detailed compilation and
installation instructions.</p>
<h2>Binary distributions for Linux</h2>
<p>Binary distributions for CentOS, Debian, Fedora, RHEL, Ubuntu are
available
<a href="http://software.opensuse.org/download.html?project=home%3Aocaml&amp;package=ocaml">here</a>.</p>
<h2>Binary distribution for Microsoft Windows</h2>
<p>Four ports of OCaml for Microsoft Windows are currently available. For
additional information, please consult the list of <a href="/learn/portability.html">portability
issues</a> or the
<a href="4.04/notes/README.win32.adoc">Windows release
notes</a>.</p>
<ul>
<li>
<p><a href="http://protz.github.com/ocaml-installer/">Cygwin-based native Win32
port</a>. A self
installer. The interactive loop comes with a simple graphical user
interface. Some features require the Cygwin environment, which the
installer can fetch for you. However, the compilers are, and
generate true Win32 executables, which do not require Cygwin to run.</p>
</li>
<li>
<p>Microsoft-based native Win32 port. No binary distribution available
yet; download the source distribution and compile it.</p>
</li>
<li>
<p><a href="http://cygwin.com/">Cygwin</a>-based port. Requires Cygwin. No
graphical user interface is provided. The compilers generate
executables that do require Cygwin. The precompiled binaries are
part of the Cygwin distribution; you can install them using the
Cygwin setup tool. Alternatively, download the source distribution
and compile it under Cygwin.</p>
</li>
<li>
<p>Microsoft-based native Win64 port Same features as the
Microsoft-based native Win32 port, but generates 64-bit code. No
binary distribution available yet; download the source distribution
and compile it.</p>
</li>
</ul>
<h2>Precompiled binaries for Solaris</h2>
<p>Available at <a href="http://sunfreeware.com/">sunfreeware.com</a>.</p>
<h2>Alternative Compilers</h2>
<p>Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:</p>
<ul>
<li>
<p><a href="http://ocsigen.org/js_of_ocaml/">Js_of_ocaml</a> is a stable OCaml
to JavaScript compiler.</p>
</li>
<li>
<p><a href="http://bucklescript.github.io/bucklescript/">Bucklescript</a> is a newer
OCaml to JavaScript compiler. See its
<a href="https://github.com/bucklescript/bucklescript/wiki/Differences-from-js_of_ocaml">wiki</a>
for an explanation of how it differs from js_of_ocaml.</p>
</li>
<li>
<p><a href="http://www.ocamljava.org/">OCaml-java</a> is a stable OCaml to
Java compiler.</p>
</li>
</ul>
<h2>User's manual</h2>
<p>The user's manual for OCaml can be:</p>
<ul>
<li>
<p><a href="4.04/htmlman/index.html">browsed
online</a>,</p>
</li>
<li>
<p>downloaded as a single
<a href="4.04/ocaml-4.04-refman.ps.gz">PostScript</a>,
<a href="4.04/ocaml-4.04-refman.pdf">PDF</a>,
or <a href="4.04/ocaml-4.04-refman.txt">plain
text</a>
document,</p>
</li>
<li>
<p>downloaded as a single
<a href="4.04/ocaml-4.04-refman-html.tar.gz">TAR</a>
or
<a href="4.04/ocaml-4.04-refman-html.zip">ZIP</a>
archive of HTML files,</p>
</li>
<li>
<p>downloaded as a single
<a href="4.04/ocaml-4.04-refman.info.tar.gz">tarball</a>
of Emacs info files,</p>
</li>
</ul>
|js}
  };
 
  { kind = `Compiler
  ; version = {js|4.03.0|js}
  ; date = {js|2016-04-25|js}
  ; intro_md = {js|This page describes OCaml version **4.03.0**, released on 2016-04-25.
|js}
  ; intro_html = {js|<p>This page describes OCaml version <strong>4.03.0</strong>, released on 2016-04-25.</p>
|js}
  ; highlights_md = {js|- A new intermediate representation, called Flambda, was added to the
  native-code compiler, along with several new optimizations over the
  Flambda representation, such as aggressive function inlining. (The
  Flambda optimizer needs to be activated at configuration time by
  `./configure -flambda`.)
- New language feature: inline records as arguments to datatype
  constructors. This makes it possible to name the arguments of a
  constructor, and use convenient record notation to access them,
  without the cost of declaring a separate record type for the
  arguments.
- The `@unboxed` and `@untagged` attributes are supported on external
  function declarations to pass parameters and results to C stub
  functions in a more efficient way.  Other attributes honored by the
  compiler include `@tailcall` and `@inline`.
- Improvements to the garbage collector, resulting in better GC
  latency (shorter GC pauses).
- Support for ephemerons, a more general form of GC finalization of
  data structures.
- The runtime system is now compiled at higher levels of C
  optimization, resulting in significant speedups for the bytecode
  interpreter.
- New native code generators supporting the PowerPC 64-bit
  architecture (in big and little-endian modes) and the IBM zSystem
  architecture.
- The whole code base (compilers, libraries and tools) is now licensed
  under the LGPL v2.1 with static linking exception.
- The ocamlbuild compilation manager was split off and lives as an
  [independent project](https://github.com/ocaml/ocamlbuild/).
|js}
  ; highlights_html = {js|<ul>
<li>A new intermediate representation, called Flambda, was added to the
native-code compiler, along with several new optimizations over the
Flambda representation, such as aggressive function inlining. (The
Flambda optimizer needs to be activated at configuration time by
<code>./configure -flambda</code>.)
</li>
<li>New language feature: inline records as arguments to datatype
constructors. This makes it possible to name the arguments of a
constructor, and use convenient record notation to access them,
without the cost of declaring a separate record type for the
arguments.
</li>
<li>The <code>@unboxed</code> and <code>@untagged</code> attributes are supported on external
function declarations to pass parameters and results to C stub
functions in a more efficient way.  Other attributes honored by the
compiler include <code>@tailcall</code> and <code>@inline</code>.
</li>
<li>Improvements to the garbage collector, resulting in better GC
latency (shorter GC pauses).
</li>
<li>Support for ephemerons, a more general form of GC finalization of
data structures.
</li>
<li>The runtime system is now compiled at higher levels of C
optimization, resulting in significant speedups for the bytecode
interpreter.
</li>
<li>New native code generators supporting the PowerPC 64-bit
architecture (in big and little-endian modes) and the IBM zSystem
architecture.
</li>
<li>The whole code base (compilers, libraries and tools) is now licensed
under the LGPL v2.1 with static linking exception.
</li>
<li>The ocamlbuild compilation manager was split off and lives as an
<a href="https://github.com/ocaml/ocamlbuild/">independent project</a>.
</li>
</ul>
|js}
  ; body_md = {js|
Opam Switches
-------------

This release is available as multiple OPAM switches:

- 4.03.0 — Official 4.03.0 release
- 4.03.0+flambda — Official 4.03.0 release with flambda enabled
- 4.03.0+fp — Official 4.03.0 release with frame pointers
- 4.03.0+fp+flambda — Official 4.03.0 release with frame pointers and flambda enabled

## What's new?

Some of the highlights in release 4.03 are:

- A new intermediate representation, called Flambda, was added to the
  native-code compiler, along with several new optimizations over the
  Flambda representation, such as aggressive function inlining. (The
  Flambda optimizer needs to be activated at configuration time by
  `./configure -flambda`.)
- New language feature: inline records as arguments to datatype
  constructors. This makes it possible to name the arguments of a
  constructor, and use convenient record notation to access them,
  without the cost of declaring a separate record type for the
  arguments.
- The `@unboxed` and `@untagged` attributes are supported on external
  function declarations to pass parameters and results to C stub
  functions in a more efficient way.  Other attributes honored by the
  compiler include `@tailcall` and `@inline`.
- Improvements to the garbage collector, resulting in better GC
  latency (shorter GC pauses).
- Support for ephemerons, a more general form of GC finalization of
  data structures.
- The runtime system is now compiled at higher levels of C
  optimization, resulting in significant speedups for the bytecode
  interpreter.
- New native code generators supporting the PowerPC 64-bit
  architecture (in big and little-endian modes) and the IBM zSystem
  architecture.
- The whole code base (compilers, libraries and tools) is now licensed
  under the LGPL v2.1 with static linking exception.
- The ocamlbuild compilation manager was split off and lives as an
  [independent project](https://github.com/ocaml/ocamlbuild/).

For a comprehensive list of changes and details on all new features,
bug fixes, optimizations, etc., please consult the
[release notes](4.03/notes/Changes).


## Source distribution

- [Source
  tarball](https://github.com/ocaml/ocaml/archive/4.03.0.tar.gz)
  (.tar.gz) for compilation under Unix (including Linux and MacOS X)
  and Microsoft Windows (including Cygwin).

- Also available in
  [.zip](https://github.com/ocaml/ocaml/archive/4.03.0.zip)
  format.

- [OPAM](https://opam.ocaml.org/) is a source-based distribution of
  OCaml and many companion libraries and tools. Compilation and
  installation are automated by powerful package managers.

- The official development repo is hosted on
  [GitHub](https://github.com/ocaml/ocaml).

The [INSTALL](4.03/notes/INSTALL.adoc)
file of the distribution provides detailed compilation and
installation instructions.


## Binary distributions for Linux

Binary distributions for CentOS, Debian, Fedora, RHEL, Ubuntu are
available
[here](http://software.opensuse.org/download.html?project=home%3Aocaml&package=ocaml).


## Binary distribution for Microsoft Windows

Four ports of OCaml for Microsoft Windows are currently available. For
additional information, please consult the list of [portability
issues](/learn/portability.html) or the
[Windows release
notes](4.03/notes/README.win32.adoc).

- [Cygwin-based native Win32
  port](http://protz.github.com/ocaml-installer/). A self
  installer. The interactive loop comes with a simple graphical user
  interface. Some features require the Cygwin environment, which the
  installer can fetch for you. However, the compilers are, and
  generate true Win32 executables, which do not require Cygwin to run.

- Microsoft-based native Win32 port. No binary distribution available
  yet; download the source distribution and compile it.

- [Cygwin](http://cygwin.com/)-based port. Requires Cygwin. No
  graphical user interface is provided. The compilers generate
  executables that do require Cygwin. The precompiled binaries are
  part of the Cygwin distribution; you can install them using the
  Cygwin setup tool. Alternatively, download the source distribution
  and compile it under Cygwin.

- Microsoft-based native Win64 port Same features as the
  Microsoft-based native Win32 port, but generates 64-bit code. No
  binary distribution available yet; download the source distribution
  and compile it.


## Precompiled binaries for Solaris

Available at [sunfreeware.com](http://sunfreeware.com/).


## Alternative Compilers

Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:

* The [js_of_ocaml project](http://ocsigen.org/js_of_ocaml/), an OCaml
  to Javascript compiler (stable)

* The [ocaml-java project](http://www.ocamljava.org/), an OCaml to
  Java compiler (stable)


## User's manual

The user's manual for OCaml can be:

- [browsed
  online](4.03/htmlman/index.html),

- downloaded as a single
  [PostScript](4.03/ocaml-4.03-refman.ps.gz),
  [PDF](4.03/ocaml-4.03-refman.pdf),
  or [plain
  text](4.03/ocaml-4.03-refman.txt)
  document,

- downloaded as a single
  [TAR](4.03/ocaml-4.03-refman-html.tar.gz)
  or
  [ZIP](4.03/ocaml-4.03-refman-html.zip)
  archive of HTML files,

- downloaded as a single
  [tarball](4.03/ocaml-4.03-refman.info.tar.gz)
  of Emacs info files,

- an enhanced version which marks up differences to OCaml 4.02 can also be
  [browsed online](http://www.askra.de/software/ocaml-doc/4.03/).

|js}
  ; body_html = {js|<h2>Opam Switches</h2>
<p>This release is available as multiple OPAM switches:</p>
<ul>
<li>4.03.0 — Official 4.03.0 release
</li>
<li>4.03.0+flambda — Official 4.03.0 release with flambda enabled
</li>
<li>4.03.0+fp — Official 4.03.0 release with frame pointers
</li>
<li>4.03.0+fp+flambda — Official 4.03.0 release with frame pointers and flambda enabled
</li>
</ul>
<h2>What's new?</h2>
<p>Some of the highlights in release 4.03 are:</p>
<ul>
<li>A new intermediate representation, called Flambda, was added to the
native-code compiler, along with several new optimizations over the
Flambda representation, such as aggressive function inlining. (The
Flambda optimizer needs to be activated at configuration time by
<code>./configure -flambda</code>.)
</li>
<li>New language feature: inline records as arguments to datatype
constructors. This makes it possible to name the arguments of a
constructor, and use convenient record notation to access them,
without the cost of declaring a separate record type for the
arguments.
</li>
<li>The <code>@unboxed</code> and <code>@untagged</code> attributes are supported on external
function declarations to pass parameters and results to C stub
functions in a more efficient way.  Other attributes honored by the
compiler include <code>@tailcall</code> and <code>@inline</code>.
</li>
<li>Improvements to the garbage collector, resulting in better GC
latency (shorter GC pauses).
</li>
<li>Support for ephemerons, a more general form of GC finalization of
data structures.
</li>
<li>The runtime system is now compiled at higher levels of C
optimization, resulting in significant speedups for the bytecode
interpreter.
</li>
<li>New native code generators supporting the PowerPC 64-bit
architecture (in big and little-endian modes) and the IBM zSystem
architecture.
</li>
<li>The whole code base (compilers, libraries and tools) is now licensed
under the LGPL v2.1 with static linking exception.
</li>
<li>The ocamlbuild compilation manager was split off and lives as an
<a href="https://github.com/ocaml/ocamlbuild/">independent project</a>.
</li>
</ul>
<p>For a comprehensive list of changes and details on all new features,
bug fixes, optimizations, etc., please consult the
<a href="4.03/notes/Changes">release notes</a>.</p>
<h2>Source distribution</h2>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/archive/4.03.0.tar.gz">Source
tarball</a>
(.tar.gz) for compilation under Unix (including Linux and MacOS X)
and Microsoft Windows (including Cygwin).</p>
</li>
<li>
<p>Also available in
<a href="https://github.com/ocaml/ocaml/archive/4.03.0.zip">.zip</a>
format.</p>
</li>
<li>
<p><a href="https://opam.ocaml.org/">OPAM</a> is a source-based distribution of
OCaml and many companion libraries and tools. Compilation and
installation are automated by powerful package managers.</p>
</li>
<li>
<p>The official development repo is hosted on
<a href="https://github.com/ocaml/ocaml">GitHub</a>.</p>
</li>
</ul>
<p>The <a href="4.03/notes/INSTALL.adoc">INSTALL</a>
file of the distribution provides detailed compilation and
installation instructions.</p>
<h2>Binary distributions for Linux</h2>
<p>Binary distributions for CentOS, Debian, Fedora, RHEL, Ubuntu are
available
<a href="http://software.opensuse.org/download.html?project=home%3Aocaml&amp;package=ocaml">here</a>.</p>
<h2>Binary distribution for Microsoft Windows</h2>
<p>Four ports of OCaml for Microsoft Windows are currently available. For
additional information, please consult the list of <a href="/learn/portability.html">portability
issues</a> or the
<a href="4.03/notes/README.win32.adoc">Windows release
notes</a>.</p>
<ul>
<li>
<p><a href="http://protz.github.com/ocaml-installer/">Cygwin-based native Win32
port</a>. A self
installer. The interactive loop comes with a simple graphical user
interface. Some features require the Cygwin environment, which the
installer can fetch for you. However, the compilers are, and
generate true Win32 executables, which do not require Cygwin to run.</p>
</li>
<li>
<p>Microsoft-based native Win32 port. No binary distribution available
yet; download the source distribution and compile it.</p>
</li>
<li>
<p><a href="http://cygwin.com/">Cygwin</a>-based port. Requires Cygwin. No
graphical user interface is provided. The compilers generate
executables that do require Cygwin. The precompiled binaries are
part of the Cygwin distribution; you can install them using the
Cygwin setup tool. Alternatively, download the source distribution
and compile it under Cygwin.</p>
</li>
<li>
<p>Microsoft-based native Win64 port Same features as the
Microsoft-based native Win32 port, but generates 64-bit code. No
binary distribution available yet; download the source distribution
and compile it.</p>
</li>
</ul>
<h2>Precompiled binaries for Solaris</h2>
<p>Available at <a href="http://sunfreeware.com/">sunfreeware.com</a>.</p>
<h2>Alternative Compilers</h2>
<p>Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:</p>
<ul>
<li>
<p>The <a href="http://ocsigen.org/js_of_ocaml/">js_of_ocaml project</a>, an OCaml
to Javascript compiler (stable)</p>
</li>
<li>
<p>The <a href="http://www.ocamljava.org/">ocaml-java project</a>, an OCaml to
Java compiler (stable)</p>
</li>
</ul>
<h2>User's manual</h2>
<p>The user's manual for OCaml can be:</p>
<ul>
<li>
<p><a href="4.03/htmlman/index.html">browsed
online</a>,</p>
</li>
<li>
<p>downloaded as a single
<a href="4.03/ocaml-4.03-refman.ps.gz">PostScript</a>,
<a href="4.03/ocaml-4.03-refman.pdf">PDF</a>,
or <a href="4.03/ocaml-4.03-refman.txt">plain
text</a>
document,</p>
</li>
<li>
<p>downloaded as a single
<a href="4.03/ocaml-4.03-refman-html.tar.gz">TAR</a>
or
<a href="4.03/ocaml-4.03-refman-html.zip">ZIP</a>
archive of HTML files,</p>
</li>
<li>
<p>downloaded as a single
<a href="4.03/ocaml-4.03-refman.info.tar.gz">tarball</a>
of Emacs info files,</p>
</li>
<li>
<p>an enhanced version which marks up differences to OCaml 4.02 can also be
<a href="http://www.askra.de/software/ocaml-doc/4.03/">browsed online</a>.</p>
</li>
</ul>
|js}
  };
 
  { kind = `Compiler
  ; version = {js|4.06.1|js}
  ; date = {js|2016-02-16|js}
  ; intro_md = {js|This page describe OCaml **4.06.1**, released on Feb 16, 2018.  It is a bug-fix release of [OCaml 4.06.0](/releases/4.06.0).
|js}
  ; intro_html = {js|<p>This page describe OCaml <strong>4.06.1</strong>, released on Feb 16, 2018.  It is a bug-fix release of <a href="/releases/4.06.0">OCaml 4.06.0</a>.</p>
|js}
  ; highlights_md = {js|- Bug fixes for 4.06.0
|js}
  ; highlights_html = {js|<ul>
<li>Bug fixes for 4.06.0
</li>
</ul>
|js}
  ; body_md = {js|

Changes (Bug fixes)
-------------------

- [MPR#7661](https://caml.inria.fr/mantis/view.php?id=7661),
  [GPR#1459](https://github.com/ocaml/ocaml/pull/1459):
  fix faulty compilation of patterns
  using extensible variants constructors
  (Luc Maranget, review by Thomas Refis and Gabriel Scherer, report
  by Abdelraouf Ouadjaout and Thibault Suzanne)

- [MPR#7702](https://caml.inria.fr/mantis/view.php?id=7702),
  [GPR#1553](https://github.com/ocaml/ocaml/pull/1553):
  refresh raise counts when inlining a function
  (Vincent Laviron, Xavier Clerc, report by Cheng Sun)

- [MPR#7704](https://caml.inria.fr/mantis/view.php?id=7704),
  [GPR#1559](https://github.com/ocaml/ocaml/pull/1559):
  Soundness issue with private rows and pattern-matching
  (Jacques Garrigue, report by Jeremy Yallop, review by Thomas Refis)

- [MPR#7705](https://caml.inria.fr/mantis/view.php?id=7705),
  [GPR#1558](https://github.com/ocaml/ocaml/pull/1558):
  add missing bounds check in Bigarray.Genarray.nth_dim.
  (Nicolás Ojeda Bär, report by Jeremy Yallop, review by Gabriel Scherer)

- [MPR#7713](https://caml.inria.fr/mantis/view.php?id=7713),
  [GPR#1587](https://github.com/ocaml/ocaml/pull/1587):
  Make pattern matching warnings more robust
  to ill-typed columns; this is a backport of GPR#1550 from 4.07+dev
  (Thomas Refis, review by Gabriel Scherer, report by Andreas Hauptmann)

- [GPR#1470](https://github.com/ocaml/ocaml/pull/1470):
  Don't commute negation with float comparison
  (Leo White, review by Xavier Leroy)

- [GPR#1538](https://github.com/ocaml/ocaml/pull/1538):
  Make pattern matching compilation more robust to ill-typed columns
  (Gabriel Scherer and Thomas Refis, review by Luc Maranget)
|js}
  ; body_html = {js|<h2>Changes (Bug fixes)</h2>
<ul>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7661">MPR#7661</a>,
<a href="https://github.com/ocaml/ocaml/pull/1459">GPR#1459</a>:
fix faulty compilation of patterns
using extensible variants constructors
(Luc Maranget, review by Thomas Refis and Gabriel Scherer, report
by Abdelraouf Ouadjaout and Thibault Suzanne)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7702">MPR#7702</a>,
<a href="https://github.com/ocaml/ocaml/pull/1553">GPR#1553</a>:
refresh raise counts when inlining a function
(Vincent Laviron, Xavier Clerc, report by Cheng Sun)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7704">MPR#7704</a>,
<a href="https://github.com/ocaml/ocaml/pull/1559">GPR#1559</a>:
Soundness issue with private rows and pattern-matching
(Jacques Garrigue, report by Jeremy Yallop, review by Thomas Refis)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7705">MPR#7705</a>,
<a href="https://github.com/ocaml/ocaml/pull/1558">GPR#1558</a>:
add missing bounds check in Bigarray.Genarray.nth_dim.
(Nicolás Ojeda Bär, report by Jeremy Yallop, review by Gabriel Scherer)</p>
</li>
<li>
<p><a href="https://caml.inria.fr/mantis/view.php?id=7713">MPR#7713</a>,
<a href="https://github.com/ocaml/ocaml/pull/1587">GPR#1587</a>:
Make pattern matching warnings more robust
to ill-typed columns; this is a backport of GPR#1550 from 4.07+dev
(Thomas Refis, review by Gabriel Scherer, report by Andreas Hauptmann)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1470">GPR#1470</a>:
Don't commute negation with float comparison
(Leo White, review by Xavier Leroy)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/1538">GPR#1538</a>:
Make pattern matching compilation more robust to ill-typed columns
(Gabriel Scherer and Thomas Refis, review by Luc Maranget)</p>
</li>
</ul>
|js}
  };
 
  { kind = `Compiler
  ; version = {js|4.02.3|js}
  ; date = {js|2015-07-27|js}
  ; intro_md = {js|This page describes OCaml version **4.02.3**, released on 2015-07-27.
|js}
  ; intro_html = {js|<p>This page describes OCaml version <strong>4.02.3</strong>, released on 2015-07-27.</p>
|js}
  ; highlights_md = {js|- In a first step towards making strings immutable, a type bytes of
  mutable byte arrays and a supporting library module `Bytes` were
  introduced. By default, `bytes` is a synonym for `string`, so
  existing code that mutates values of type `string` still compiles,
  with warnings. Option `-safe-string` separates the types `string`
  and `bytes`, making strings immutable.
- The `match` construct was extended to discriminate not just on the
  value of its argument expression, but also on exceptions arising out
  of the evaluation of this expression. This solves an old problem: in
  a `let x = a in b`, catch exceptions raised by `a` but not those
  raised by `b`.
- Module aliases (giving an alternative name to an existing module or
  compilation unit, as in `module M = AnotherModule`) are now tracked
  specially by the type system and the compiler. This enables not only
  more precise typing of applicative functors, but also more precise
  dependency analysis at link-time, potentially reducing the size of
  executables.
- Annotations can now be attached to most syntactic elements of OCaml
  sources (expressions, definitions, type declarations, etc). These
  annotations are used by the compiler (e.g. to warn on uses of
  functions annotated as deprecated) but also by "ppx" preprocessors,
  to guide rewriting of abstract syntax trees.
- Extensible data types can be declared (`type t = ..`) then later
  extended with new constructors (`type t += A of int`). This
  generalizes the handling of the exn type of exception values.
- Functors and functor applications can now take a special () argument
  to force generativity of abstract types.
- New toplevel directives `#show_type`, `#show_modules`, etc, to query
  the toplevel environment.
- Performance of `ocamlopt`-generated code is improved on some
  programs through more aggressive constant propagation, two new
  optimization passes (dead code elimination and common subexpression
  elimination), better compilation of pattern-matching over strings,
  optimized representation of constant exceptions, and GC tuning for
  large memory heaps.
- The format strings argument of `printf` functions are now
  represented as a GADT. This speeds up the `printf` functions
  considerably, and leads to more precise typechecking of format
  strings.
- The native-code compiler now supports the AArch64 (ARM 64 bits)
  architecture.
- The Camlp4 preprocessor and the Labltk library were split off the
  distribution. They are now separate projects.
|js}
  ; highlights_html = {js|<ul>
<li>In a first step towards making strings immutable, a type bytes of
mutable byte arrays and a supporting library module <code>Bytes</code> were
introduced. By default, <code>bytes</code> is a synonym for <code>string</code>, so
existing code that mutates values of type <code>string</code> still compiles,
with warnings. Option <code>-safe-string</code> separates the types <code>string</code>
and <code>bytes</code>, making strings immutable.
</li>
<li>The <code>match</code> construct was extended to discriminate not just on the
value of its argument expression, but also on exceptions arising out
of the evaluation of this expression. This solves an old problem: in
a <code>let x = a in b</code>, catch exceptions raised by <code>a</code> but not those
raised by <code>b</code>.
</li>
<li>Module aliases (giving an alternative name to an existing module or
compilation unit, as in <code>module M = AnotherModule</code>) are now tracked
specially by the type system and the compiler. This enables not only
more precise typing of applicative functors, but also more precise
dependency analysis at link-time, potentially reducing the size of
executables.
</li>
<li>Annotations can now be attached to most syntactic elements of OCaml
sources (expressions, definitions, type declarations, etc). These
annotations are used by the compiler (e.g. to warn on uses of
functions annotated as deprecated) but also by &quot;ppx&quot; preprocessors,
to guide rewriting of abstract syntax trees.
</li>
<li>Extensible data types can be declared (<code>type t = ..</code>) then later
extended with new constructors (<code>type t += A of int</code>). This
generalizes the handling of the exn type of exception values.
</li>
<li>Functors and functor applications can now take a special () argument
to force generativity of abstract types.
</li>
<li>New toplevel directives <code>#show_type</code>, <code>#show_modules</code>, etc, to query
the toplevel environment.
</li>
<li>Performance of <code>ocamlopt</code>-generated code is improved on some
programs through more aggressive constant propagation, two new
optimization passes (dead code elimination and common subexpression
elimination), better compilation of pattern-matching over strings,
optimized representation of constant exceptions, and GC tuning for
large memory heaps.
</li>
<li>The format strings argument of <code>printf</code> functions are now
represented as a GADT. This speeds up the <code>printf</code> functions
considerably, and leads to more precise typechecking of format
strings.
</li>
<li>The native-code compiler now supports the AArch64 (ARM 64 bits)
architecture.
</li>
<li>The Camlp4 preprocessor and the Labltk library were split off the
distribution. They are now separate projects.
</li>
</ul>
|js}
  ; body_md = {js|
# OCaml 4.02.3


## What's New

Some of the highlights in release 4.02 are:

- In a first step towards making strings immutable, a type bytes of
  mutable byte arrays and a supporting library module `Bytes` were
  introduced. By default, `bytes` is a synonym for `string`, so
  existing code that mutates values of type `string` still compiles,
  with warnings. Option `-safe-string` separates the types `string`
  and `bytes`, making strings immutable.

- The `match` construct was extended to discriminate not just on the
  value of its argument expression, but also on exceptions arising out
  of the evaluation of this expression. This solves an old problem: in
  a `let x = a in b`, catch exceptions raised by `a` but not those
  raised by `b`.

- Module aliases (giving an alternative name to an existing module or
  compilation unit, as in `module M = AnotherModule`) are now tracked
  specially by the type system and the compiler. This enables not only
  more precise typing of applicative functors, but also more precise
  dependency analysis at link-time, potentially reducing the size of
  executables.

- Annotations can now be attached to most syntactic elements of OCaml
  sources (expressions, definitions, type declarations, etc). These
  annotations are used by the compiler (e.g. to warn on uses of
  functions annotated as deprecated) but also by "ppx" preprocessors,
  to guide rewriting of abstract syntax trees.

- Extensible data types can be declared (`type t = ..`) then later
  extended with new constructors (`type t += A of int`). This
  generalizes the handling of the exn type of exception values.

- Functors and functor applications can now take a special () argument
  to force generativity of abstract types.

- New toplevel directives `#show_type`, `#show_modules`, etc, to query
  the toplevel environment.

- Performance of `ocamlopt`-generated code is improved on some
  programs through more aggressive constant propagation, two new
  optimization passes (dead code elimination and common subexpression
  elimination), better compilation of pattern-matching over strings,
  optimized representation of constant exceptions, and GC tuning for
  large memory heaps.

- The format strings argument of `printf` functions are now
  represented as a GADT. This speeds up the `printf` functions
  considerably, and leads to more precise typechecking of format
  strings.

- The native-code compiler now supports the AArch64 (ARM 64 bits)
  architecture.

- The Camlp4 preprocessor and the Labltk library were split off the
  distribution. They are now separate projects.

For more information, please consult the [comprehensive list of
changes](4.02/notes/Changes).



## Source distribution

- [Source
  tarball](https://github.com/ocaml/ocaml/archive/4.02.3.tar.gz)
  (.tar.gz) for compilation under Unix (including Linux and MacOS X)
  and Microsoft Windows (including Cygwin).

- Also available in
  [.zip](https://github.com/ocaml/ocaml/archive/4.02.3.zip)
  format.

- [OPAM](https://opam.ocaml.org/) is a source-based distribution of
  OCaml and many companion libraries and tools. Compilation and
  installation are automated by powerful package managers.

- You also have [access](index.html) to the working
  sources and to all previous public releases.

The [INSTALL](4.02/notes/INSTALL)
file of the distribution provides detailed compilation and
installation instruction.


## Binary distributions for Linux

Binary distributions for CentOS, Debian, Fedora, RHEL, Ubuntu are
available
[here](http://software.opensuse.org/download.html?project=home%3Aocaml&package=ocaml).


## Binary distribution for Microsoft Windows

Four ports of OCaml for Microsoft Windows are currently available. For
additional information, please consult the list of [portability
issues](/learn/portability.html) or the
[Windows release
notes](4.02/notes/README.win32).

- [Cygwin-based native Win32
  port](http://protz.github.com/ocaml-installer/). A self
  installer. The interactive loop comes with a simple graphical user
  interface. Some features require the Cygwin environment, which the
  installer can fetch for you. However, the compilers are, and
  generate true Win32 executables, which do not require Cygwin to run.

- Microsoft-based native Win32 port. No binary distribution available
  yet; download the source distribution and compile it.

- [Cygwin](http://cygwin.com/)-based port. Requires Cygwin. No
  graphical user interface is provided. The compilers generate
  executables that do require Cygwin. The precompiled binaries are
  part of the Cygwin distribution; you can install them using the
  Cygwin setup tool. Alternatively, download the source distribution
  and compile it under Cygwin.

- Microsoft-based native Win64 port Same features as the
  Microsoft-based native Win32 port, but generates 64-bit code. No
  binary distribution available yet; download the source distribution
  and compile it.


## Precompiled binaries for Solaris

Available at [sunfreeware.com](http://sunfreeware.com/).


## Alternative Compilers

Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:

* The [js_of_ocaml project](http://ocsigen.org/js_of_ocaml/), an OCaml
  to Javascript compiler (stable)

* The [ocaml-java project](http://www.ocamljava.org/), an OCaml to
  Java compiler (stable)


## User's manual

The user's manual for OCaml can be:

- [browsed
  online](4.02/htmlman/index.html),

- downloaded as a single
  [PostScript](4.02/ocaml-4.02-refman.ps.gz),
  [PDF](4.02/ocaml-4.02-refman.pdf),
  or [plain
  text](4.02/ocaml-4.02-refman.txt)
  document,

- downloaded as a single
  [TAR](4.02/ocaml-4.02-refman-html.tar.gz)
  or
  [ZIP](4.02/ocaml-4.02-refman-html.zip)
  archive of HTML files,

- downloaded as a single
  [tarball](4.02/ocaml-4.02-refman.info.tar.gz)
  of Emacs info files,

- an enhanced version which marks up differences to OCaml 4.01 can also be
  [browsed online](http://www.askra.de/software/ocaml-doc/4.02/).

## License

OCaml is Free Software, copyright INRIA, licensed under a combination
of the QPL and the LGPLv2 (with a special exception on static
linking). See the full [license](/docs/license.html). Members of the
[OCaml Consortium](/consortium/) benefit from a
more liberal license (BSD-like).
|js}
  ; body_html = {js|<h1>OCaml 4.02.3</h1>
<h2>What's New</h2>
<p>Some of the highlights in release 4.02 are:</p>
<ul>
<li>
<p>In a first step towards making strings immutable, a type bytes of
mutable byte arrays and a supporting library module <code>Bytes</code> were
introduced. By default, <code>bytes</code> is a synonym for <code>string</code>, so
existing code that mutates values of type <code>string</code> still compiles,
with warnings. Option <code>-safe-string</code> separates the types <code>string</code>
and <code>bytes</code>, making strings immutable.</p>
</li>
<li>
<p>The <code>match</code> construct was extended to discriminate not just on the
value of its argument expression, but also on exceptions arising out
of the evaluation of this expression. This solves an old problem: in
a <code>let x = a in b</code>, catch exceptions raised by <code>a</code> but not those
raised by <code>b</code>.</p>
</li>
<li>
<p>Module aliases (giving an alternative name to an existing module or
compilation unit, as in <code>module M = AnotherModule</code>) are now tracked
specially by the type system and the compiler. This enables not only
more precise typing of applicative functors, but also more precise
dependency analysis at link-time, potentially reducing the size of
executables.</p>
</li>
<li>
<p>Annotations can now be attached to most syntactic elements of OCaml
sources (expressions, definitions, type declarations, etc). These
annotations are used by the compiler (e.g. to warn on uses of
functions annotated as deprecated) but also by &quot;ppx&quot; preprocessors,
to guide rewriting of abstract syntax trees.</p>
</li>
<li>
<p>Extensible data types can be declared (<code>type t = ..</code>) then later
extended with new constructors (<code>type t += A of int</code>). This
generalizes the handling of the exn type of exception values.</p>
</li>
<li>
<p>Functors and functor applications can now take a special () argument
to force generativity of abstract types.</p>
</li>
<li>
<p>New toplevel directives <code>#show_type</code>, <code>#show_modules</code>, etc, to query
the toplevel environment.</p>
</li>
<li>
<p>Performance of <code>ocamlopt</code>-generated code is improved on some
programs through more aggressive constant propagation, two new
optimization passes (dead code elimination and common subexpression
elimination), better compilation of pattern-matching over strings,
optimized representation of constant exceptions, and GC tuning for
large memory heaps.</p>
</li>
<li>
<p>The format strings argument of <code>printf</code> functions are now
represented as a GADT. This speeds up the <code>printf</code> functions
considerably, and leads to more precise typechecking of format
strings.</p>
</li>
<li>
<p>The native-code compiler now supports the AArch64 (ARM 64 bits)
architecture.</p>
</li>
<li>
<p>The Camlp4 preprocessor and the Labltk library were split off the
distribution. They are now separate projects.</p>
</li>
</ul>
<p>For more information, please consult the <a href="4.02/notes/Changes">comprehensive list of
changes</a>.</p>
<h2>Source distribution</h2>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/archive/4.02.3.tar.gz">Source
tarball</a>
(.tar.gz) for compilation under Unix (including Linux and MacOS X)
and Microsoft Windows (including Cygwin).</p>
</li>
<li>
<p>Also available in
<a href="https://github.com/ocaml/ocaml/archive/4.02.3.zip">.zip</a>
format.</p>
</li>
<li>
<p><a href="https://opam.ocaml.org/">OPAM</a> is a source-based distribution of
OCaml and many companion libraries and tools. Compilation and
installation are automated by powerful package managers.</p>
</li>
<li>
<p>You also have <a href="index.html">access</a> to the working
sources and to all previous public releases.</p>
</li>
</ul>
<p>The <a href="4.02/notes/INSTALL">INSTALL</a>
file of the distribution provides detailed compilation and
installation instruction.</p>
<h2>Binary distributions for Linux</h2>
<p>Binary distributions for CentOS, Debian, Fedora, RHEL, Ubuntu are
available
<a href="http://software.opensuse.org/download.html?project=home%3Aocaml&amp;package=ocaml">here</a>.</p>
<h2>Binary distribution for Microsoft Windows</h2>
<p>Four ports of OCaml for Microsoft Windows are currently available. For
additional information, please consult the list of <a href="/learn/portability.html">portability
issues</a> or the
<a href="4.02/notes/README.win32">Windows release
notes</a>.</p>
<ul>
<li>
<p><a href="http://protz.github.com/ocaml-installer/">Cygwin-based native Win32
port</a>. A self
installer. The interactive loop comes with a simple graphical user
interface. Some features require the Cygwin environment, which the
installer can fetch for you. However, the compilers are, and
generate true Win32 executables, which do not require Cygwin to run.</p>
</li>
<li>
<p>Microsoft-based native Win32 port. No binary distribution available
yet; download the source distribution and compile it.</p>
</li>
<li>
<p><a href="http://cygwin.com/">Cygwin</a>-based port. Requires Cygwin. No
graphical user interface is provided. The compilers generate
executables that do require Cygwin. The precompiled binaries are
part of the Cygwin distribution; you can install them using the
Cygwin setup tool. Alternatively, download the source distribution
and compile it under Cygwin.</p>
</li>
<li>
<p>Microsoft-based native Win64 port Same features as the
Microsoft-based native Win32 port, but generates 64-bit code. No
binary distribution available yet; download the source distribution
and compile it.</p>
</li>
</ul>
<h2>Precompiled binaries for Solaris</h2>
<p>Available at <a href="http://sunfreeware.com/">sunfreeware.com</a>.</p>
<h2>Alternative Compilers</h2>
<p>Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:</p>
<ul>
<li>
<p>The <a href="http://ocsigen.org/js_of_ocaml/">js_of_ocaml project</a>, an OCaml
to Javascript compiler (stable)</p>
</li>
<li>
<p>The <a href="http://www.ocamljava.org/">ocaml-java project</a>, an OCaml to
Java compiler (stable)</p>
</li>
</ul>
<h2>User's manual</h2>
<p>The user's manual for OCaml can be:</p>
<ul>
<li>
<p><a href="4.02/htmlman/index.html">browsed
online</a>,</p>
</li>
<li>
<p>downloaded as a single
<a href="4.02/ocaml-4.02-refman.ps.gz">PostScript</a>,
<a href="4.02/ocaml-4.02-refman.pdf">PDF</a>,
or <a href="4.02/ocaml-4.02-refman.txt">plain
text</a>
document,</p>
</li>
<li>
<p>downloaded as a single
<a href="4.02/ocaml-4.02-refman-html.tar.gz">TAR</a>
or
<a href="4.02/ocaml-4.02-refman-html.zip">ZIP</a>
archive of HTML files,</p>
</li>
<li>
<p>downloaded as a single
<a href="4.02/ocaml-4.02-refman.info.tar.gz">tarball</a>
of Emacs info files,</p>
</li>
<li>
<p>an enhanced version which marks up differences to OCaml 4.01 can also be
<a href="http://www.askra.de/software/ocaml-doc/4.02/">browsed online</a>.</p>
</li>
</ul>
<h2>License</h2>
<p>OCaml is Free Software, copyright INRIA, licensed under a combination
of the QPL and the LGPLv2 (with a special exception on static
linking). See the full <a href="/docs/license.html">license</a>. Members of the
<a href="/consortium/">OCaml Consortium</a> benefit from a
more liberal license (BSD-like).</p>
|js}
  };
 
  { kind = `Compiler
  ; version = {js|4.01.0|js}
  ; date = {js|2013-09-12|js}
  ; intro_md = {js|This page describes OCaml version **4.01.0**, released on 2013-09-12.
|js}
  ; intro_html = {js|<p>This page describes OCaml version <strong>4.01.0</strong>, released on 2013-09-12.</p>
|js}
  ; highlights_md = {js|- It is now possible to have several variant constructors or record
  fields of the same name in scope, and type information will be used
  to disambiguate which one is used -- instead of always using the
  last one. See [this
  post](http://www.lexifi.com/blog/type-based-selection-label-and-constructors)
  for a more detailed description of the feature.

- New warnings can be activated to warn about identifiers that are
  used after having been shadowed by an `open` construct. The `open`
  keyword can be written `open!` to silence this warning (as `method!`
  silences the method warning).

- The compiler now suggests possible typos on "unbound identifier" errors.
- Infix application operators `(|>)` and `(@@)` are added to `Pervasives`.
- The `-short-path` option changes the way the type-checker prints
  types to pick a short representation (eg. `string` instead of
  `StringSet.elt`).

- This release saw a lot of polishing with sets of changes in many
  places: the type system for GADTs, compilation speed with
  `-bin-annot`, ocamlbuild, the test suite, low-level optimizations,
  etc.
|js}
  ; highlights_html = {js|<ul>
<li>
<p>It is now possible to have several variant constructors or record
fields of the same name in scope, and type information will be used
to disambiguate which one is used -- instead of always using the
last one. See <a href="http://www.lexifi.com/blog/type-based-selection-label-and-constructors">this
post</a>
for a more detailed description of the feature.</p>
</li>
<li>
<p>New warnings can be activated to warn about identifiers that are
used after having been shadowed by an <code>open</code> construct. The <code>open</code>
keyword can be written <code>open!</code> to silence this warning (as <code>method!</code>
silences the method warning).</p>
</li>
<li>
<p>The compiler now suggests possible typos on &quot;unbound identifier&quot; errors.</p>
</li>
<li>
<p>Infix application operators <code>(|&gt;)</code> and <code>(@@)</code> are added to <code>Pervasives</code>.</p>
</li>
<li>
<p>The <code>-short-path</code> option changes the way the type-checker prints
types to pick a short representation (eg. <code>string</code> instead of
<code>StringSet.elt</code>).</p>
</li>
<li>
<p>This release saw a lot of polishing with sets of changes in many
places: the type system for GADTs, compilation speed with
<code>-bin-annot</code>, ocamlbuild, the test suite, low-level optimizations,
etc.</p>
</li>
</ul>
|js}
  ; body_md = {js|
**License**<br />
 The OCaml system is open source software: the compiler is distributed
under the terms of the Q Public License, and its library is under LGPL;
please read the [license](/docs/license.html) document for more details. A
BSD-style license is also available for a fee through the [OCaml
Consortium](/consortium/).

## What's New

Some of the highlights in release 4.01 are:

-   It is now possible to have several variant constructors or record
    fields of the same name in scope, and type information will be used
    to disambiguate which one is used -- instead of always using the
    last one. See [this
    post](http://www.lexifi.com/blog/type-based-selection-label-and-constructors)
    for a more detailed description of the feature.

-   New warnings can be activated to warn about identifiers that are
    used after having been shadowed by an `open` construct. The `open`
    keyword can be written `open!` to silence this warning (as `method!`
    silences the method warning).

-   The compiler now suggests possible typos on "unbound identifier"
    errors.

-   Infix application operators `(|>)` and `(@@)` are added to
    `Pervasives`.

-   The `-short-path` option changes the way the type-checker prints
    types to pick a short representation (eg. `string` instead of
    `StringSet.elt`).

-   This release saw a lot of polishing with sets of changes in many
    places: the type system for GADTs, compilation speed with
    `-bin-annot`, ocamlbuild, the test suite, low-level optimizations,
    etc.

For more information, please consult the [comprehensive list of
changes](4.01/notes/Changes).

## Source distribution

-   [Source tarball](https://github.com/ocaml/ocaml/archive/4.01.0.tar.gz)
    (.tar.gz) for compilation under Unix (including Linux and MacOS X)
    and Microsoft Windows (including Cygwin).
-   Also available in
    [.zip](https://github.com/ocaml/ocaml/archive/4.01.0.zip) format.
-   [OPAM](https://opam.ocaml.org/) is a source-based distribution of
    OCaml and many companion libraries and tools. Compilation and
    installation are automated by powerful package managers.
-   You also have [access](index.html) to the working
 sources and to all previous public releases.

The [INSTALL](4.01/notes/INSTALL) file of the
distribution provides detailed compilation and installation instruction.

## Precompiled binaries for Linux

-   [Debian packages](http://packages.debian.org/ocaml).
-   [Fedora
    packages](https://admin.fedoraproject.org/pkgdb/package/ocaml/).
-   [Gentoo
    packages](http://packages.gentoo.org/packages/?category=dev-lang;name=ocaml).


## Precompiled binaries for MacOS X

Binary package compiled on Mac OS 10.7.5 with XCode tools 4.6.3
(probably not compatible with earlier versions of Mac OS X):

-   [for 64-bit Intel](https://caml.inria.fr/pub/distrib/ocaml-4.01/ocaml-4.01.0-intel.dmg)
    (4.01.0)

## Precompiled binaries for Microsoft Windows

Four ports of OCaml for Microsoft Windows are currently available. For
additional information, please consult the list of [portability
issues](/learn/portability.html) or the [Windows release
notes](4.01/notes/README.win32).

-   [Cygwin-based native Win32 port
    (4.00.0)](http://protz.github.com/ocaml-installer/). A self
    installer. The interactive loop comes with a simple graphical user
    interface. Some features require the Cygwin environment, which the
    installer can fetch for you. However, the compilers are, and
    generate true Win32 executables, which do not require Cygwin to run.
-   Microsoft-based native Win32 port. No binary distribution available
    yet; download the source distribution and compile it.
-   [Cygwin](http://cygwin.com/)-based port. Requires Cygwin. No
    graphical user interface is provided. The compilers generate
    executables that do require Cygwin. The precompiled binaries are
    part of the Cygwin distribution; you can install them using the
    Cygwin `setup` tool. Alternatively, download the source distribution
    and compile it under Cygwin.
-   Microsoft-based native Win64 port Same features as the
    Microsoft-based native Win32 port, but generates 64-bit code. No
    binary distribution available yet; download the source distribution
    and compile it.

## Precompiled binaries for Solaris

Available at [sunfreeware.com](http://sunfreeware.com/).

## Alternative Compilers

Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:

* The [js_of_ocaml project](http://ocsigen.org/js_of_ocaml/), an
 OCaml to Javascript compiler (stable)
* The [ocaml-java project](http://ocamljava.x9c.fr/), an OCaml to Java
 compiler (stable)

## User's manual
The user's manual for OCaml can be:

-   [browsed online](4.01/htmlman/index.html),
-   downloaded as a single
    [PostScript](4.01/ocaml-4.01-refman.ps.gz),
    [PDF](4.01/ocaml-4.01-refman.pdf), or [plain
    text](4.01/ocaml-4.01-refman.txt) document,
-   downloaded as a single
    [TAR](4.01/ocaml-4.01-refman-html.tar.gz) or
    [ZIP](4.01/ocaml-4.01-refman-html.zip) archive
    of HTML files,
-   downloaded as a single
    [tarball](4.01/ocaml-4.01-refman.info.tar.gz)
    of Emacs `info` files,
-   an enhanced version which marks up differences to OCaml 4.00 can also be
    [browsed online](http://www.askra.de/software/ocaml-doc/4.01/).


|js}
  ; body_html = {js|<p><strong>License</strong><br />
The OCaml system is open source software: the compiler is distributed
under the terms of the Q Public License, and its library is under LGPL;
please read the <a href="/docs/license.html">license</a> document for more details. A
BSD-style license is also available for a fee through the <a href="/consortium/">OCaml
Consortium</a>.</p>
<h2>What's New</h2>
<p>Some of the highlights in release 4.01 are:</p>
<ul>
<li>
<p>It is now possible to have several variant constructors or record
fields of the same name in scope, and type information will be used
to disambiguate which one is used -- instead of always using the
last one. See <a href="http://www.lexifi.com/blog/type-based-selection-label-and-constructors">this
post</a>
for a more detailed description of the feature.</p>
</li>
<li>
<p>New warnings can be activated to warn about identifiers that are
used after having been shadowed by an <code>open</code> construct. The <code>open</code>
keyword can be written <code>open!</code> to silence this warning (as <code>method!</code>
silences the method warning).</p>
</li>
<li>
<p>The compiler now suggests possible typos on &quot;unbound identifier&quot;
errors.</p>
</li>
<li>
<p>Infix application operators <code>(|&gt;)</code> and <code>(@@)</code> are added to
<code>Pervasives</code>.</p>
</li>
<li>
<p>The <code>-short-path</code> option changes the way the type-checker prints
types to pick a short representation (eg. <code>string</code> instead of
<code>StringSet.elt</code>).</p>
</li>
<li>
<p>This release saw a lot of polishing with sets of changes in many
places: the type system for GADTs, compilation speed with
<code>-bin-annot</code>, ocamlbuild, the test suite, low-level optimizations,
etc.</p>
</li>
</ul>
<p>For more information, please consult the <a href="4.01/notes/Changes">comprehensive list of
changes</a>.</p>
<h2>Source distribution</h2>
<ul>
<li><a href="https://github.com/ocaml/ocaml/archive/4.01.0.tar.gz">Source tarball</a>
(.tar.gz) for compilation under Unix (including Linux and MacOS X)
and Microsoft Windows (including Cygwin).
</li>
<li>Also available in
<a href="https://github.com/ocaml/ocaml/archive/4.01.0.zip">.zip</a> format.
</li>
<li><a href="https://opam.ocaml.org/">OPAM</a> is a source-based distribution of
OCaml and many companion libraries and tools. Compilation and
installation are automated by powerful package managers.
</li>
<li>You also have <a href="index.html">access</a> to the working
sources and to all previous public releases.
</li>
</ul>
<p>The <a href="4.01/notes/INSTALL">INSTALL</a> file of the
distribution provides detailed compilation and installation instruction.</p>
<h2>Precompiled binaries for Linux</h2>
<ul>
<li><a href="http://packages.debian.org/ocaml">Debian packages</a>.
</li>
<li><a href="https://admin.fedoraproject.org/pkgdb/package/ocaml/">Fedora
packages</a>.
</li>
<li><a href="http://packages.gentoo.org/packages/?category=dev-lang;name=ocaml">Gentoo
packages</a>.
</li>
</ul>
<h2>Precompiled binaries for MacOS X</h2>
<p>Binary package compiled on Mac OS 10.7.5 with XCode tools 4.6.3
(probably not compatible with earlier versions of Mac OS X):</p>
<ul>
<li><a href="https://caml.inria.fr/pub/distrib/ocaml-4.01/ocaml-4.01.0-intel.dmg">for 64-bit Intel</a>
(4.01.0)
</li>
</ul>
<h2>Precompiled binaries for Microsoft Windows</h2>
<p>Four ports of OCaml for Microsoft Windows are currently available. For
additional information, please consult the list of <a href="/learn/portability.html">portability
issues</a> or the <a href="4.01/notes/README.win32">Windows release
notes</a>.</p>
<ul>
<li><a href="http://protz.github.com/ocaml-installer/">Cygwin-based native Win32 port
(4.00.0)</a>. A self
installer. The interactive loop comes with a simple graphical user
interface. Some features require the Cygwin environment, which the
installer can fetch for you. However, the compilers are, and
generate true Win32 executables, which do not require Cygwin to run.
</li>
<li>Microsoft-based native Win32 port. No binary distribution available
yet; download the source distribution and compile it.
</li>
<li><a href="http://cygwin.com/">Cygwin</a>-based port. Requires Cygwin. No
graphical user interface is provided. The compilers generate
executables that do require Cygwin. The precompiled binaries are
part of the Cygwin distribution; you can install them using the
Cygwin <code>setup</code> tool. Alternatively, download the source distribution
and compile it under Cygwin.
</li>
<li>Microsoft-based native Win64 port Same features as the
Microsoft-based native Win32 port, but generates 64-bit code. No
binary distribution available yet; download the source distribution
and compile it.
</li>
</ul>
<h2>Precompiled binaries for Solaris</h2>
<p>Available at <a href="http://sunfreeware.com/">sunfreeware.com</a>.</p>
<h2>Alternative Compilers</h2>
<p>Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:</p>
<ul>
<li>The <a href="http://ocsigen.org/js_of_ocaml/">js_of_ocaml project</a>, an
OCaml to Javascript compiler (stable)
</li>
<li>The <a href="http://ocamljava.x9c.fr/">ocaml-java project</a>, an OCaml to Java
compiler (stable)
</li>
</ul>
<h2>User's manual</h2>
<p>The user's manual for OCaml can be:</p>
<ul>
<li><a href="4.01/htmlman/index.html">browsed online</a>,
</li>
<li>downloaded as a single
<a href="4.01/ocaml-4.01-refman.ps.gz">PostScript</a>,
<a href="4.01/ocaml-4.01-refman.pdf">PDF</a>, or <a href="4.01/ocaml-4.01-refman.txt">plain
text</a> document,
</li>
<li>downloaded as a single
<a href="4.01/ocaml-4.01-refman-html.tar.gz">TAR</a> or
<a href="4.01/ocaml-4.01-refman-html.zip">ZIP</a> archive
of HTML files,
</li>
<li>downloaded as a single
<a href="4.01/ocaml-4.01-refman.info.tar.gz">tarball</a>
of Emacs <code>info</code> files,
</li>
<li>an enhanced version which marks up differences to OCaml 4.00 can also be
<a href="http://www.askra.de/software/ocaml-doc/4.01/">browsed online</a>.
</li>
</ul>
|js}
  };
 
  { kind = `Compiler
  ; version = {js|4.00.1|js}
  ; date = {js|2012-10-05|js}
  ; intro_md = {js|This page describes OCaml version **4.00.1**, released on 2012-10-05.
|js}
  ; intro_html = {js|<p>This page describes OCaml version <strong>4.00.1</strong>, released on 2012-10-05.</p>
|js}
  ; highlights_md = {js|- The name the language is now officially "OCaml", and this name is
  used consistently in all the documentation and tool outputs.
- Generalized Algebraic Data Types (GADTs): this is a powerful
  extension of the type system that provides great flexibility and
  power to the programmer.
- A new and improved ARM back-end. - Changes to first-class modules: type annotations can now be omitted
  when packing and unpacking modules (and are inferred from context
  whenever possible), and first-class modules can now be unpacked by
  pattern-matching.
- Support for randomized hash tables to avoid denial-of-service
  vulnerabilities.
- Installation of the compiler's internal libraries in
  `+compiler-libs` for easier access by third-party programming tools.
|js}
  ; highlights_html = {js|<ul>
<li>The name the language is now officially &quot;OCaml&quot;, and this name is
used consistently in all the documentation and tool outputs.
</li>
<li>Generalized Algebraic Data Types (GADTs): this is a powerful
extension of the type system that provides great flexibility and
power to the programmer.
</li>
<li>A new and improved ARM back-end. - Changes to first-class modules: type annotations can now be omitted
when packing and unpacking modules (and are inferred from context
whenever possible), and first-class modules can now be unpacked by
pattern-matching.
</li>
<li>Support for randomized hash tables to avoid denial-of-service
vulnerabilities.
</li>
<li>Installation of the compiler's internal libraries in
<code>+compiler-libs</code> for easier access by third-party programming tools.
</li>
</ul>
|js}
  ; body_md = {js|
**License**<br />
 The OCaml system is open source software: the compiler is distributed
under the terms of the Q Public License, and its library is under LGPL;
please read the [license](/docs/license.html) document for more details. A
BSD-style license is also available for a fee through the [OCaml
Consortium](/consortium/).

## What's New
Release 4.00.1 is mostly a bugfix release.

Some of the highlights in release 4.0.0 (July 2012) are:

* The name the language is now officially "OCaml", and this name is
 used consistently in all the documentation and tool outputs.
* Generalized Algebraic Data Types (GADTs): this is a powerful
 extension of the type system that provides great flexibility and
 power to the programmer.
* A new and improved ARM back-end.
* Changes to first-class modules: type annotations can now be omitted
 when packing and unpacking modules (and are inferred from context
 whenever possible), and first-class modules can now be unpacked by
 pattern-matching.
* Support for randomized hash tables to avoid denial-of-service
 vulnerabilities.
* Installation of the compiler's internal libraries in
 `+compiler-libs` for easier access by third-party programming tools.

For more information, please consult the [comprehensive list of
changes](4.00/notes/Changes).

## Source distribution
* [Source
 tarball](https://github.com/ocaml/ocaml/archive/4.00.1.tar.gz)
 (.tar.gz) for compilation under Unix (including Linux and MacOS X)
 and Microsoft Windows (including Cygwin).
* Also available in
 [.zip](https://github.com/ocaml/ocaml/archive/4.00.1.zip)
 format.
* You also have [access](index.html) to the working
 sources and to all previous public releases.

The [INSTALL](4.00/notes/INSTALL)
file of the distribution provides detailed compilation and installation
instruction.

## Precompiled binaries for Linux
* [Debian packages](http://packages.debian.org/ocaml).
* [Fedora
 packages](https://admin.fedoraproject.org/pkgdb/package/ocaml/).
* [Gentoo
 packages](http://packages.gentoo.org/packages/?category=dev-lang;name=ocaml).

## Precompiled binaries for MacOS X
Binary package compiled on Mac OS 10.7.5 with XCode tools 4.4 (probably
not compatible with earlier versions of Mac OS X):

* [for
 Intel](https://caml.inria.fr/pub/distrib/ocaml-4.00/ocaml-4.00.1-intel.dmg)
 (4.00.1)

## Precompiled binaries for Microsoft Windows
Four ports of OCaml for Microsoft Windows are currently available. For
additional information, please consult the list of [portability
issues](http://caml.inria.fr/ocaml/portability.en.html) or the [Windows
release
notes](4.00/notes/README.win32).

* [Cygwin-based native Win32 port
 (4.00.0)](http://protz.github.com/ocaml-installer/). A self
 installer. The interactive loop comes with a simple graphical user
 interface. Some features require the Cygwin environment, which the
 installer can fetch for you. However, the compilers are, and
 generate true Win32 executables, which do not require Cygwin to run.
* Microsoft-based native Win32 port. No binary distribution available
 yet; download the source distribution and compile it.
* [Cygwin](http://cygwin.com/)-based port. Requires Cygwin. No
 graphical user interface is provided. The compilers generate
 executables that do require Cygwin. The precompiled binaries are
 part of the Cygwin distribution; you can install them using the
 Cygwin `setup` tool. Alternatively, download the source distribution
 and compile it under Cygwin.
* Microsoft-based native Win64 port Same features as the
 Microsoft-based native Win32 port, but generates 64-bit code. No
 binary distribution available yet; download the source distribution
 and compile it.

## Precompiled binaries for Solaris
Available at [sunfreeware.com](http://sunfreeware.com/).

## Alternative Compilers
Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:

* The [js_of_ocaml project](http://ocsigen.org/js_of_ocaml/), an
 OCaml to Javascript compiler (stable)
* The [ocamljava project](http://cafesterol.x9c.fr/), an OCaml to Java
 compiler (experimental)

## User's manual
The user's manual for OCaml can be:

* [browsed
 online](4.00/htmlman/index.html),
* downloaded as a single
 [PostScript](4.00/ocaml-4.00-refman.ps.gz),
 [PDF](4.00/ocaml-4.00-refman.pdf),
 or [plain
 text](4.00/ocaml-4.00-refman.txt)
 document,
* downloaded as a single
 [TAR](4.00/ocaml-4.00-refman-html.tar.gz)
 or
 [ZIP](4.00/ocaml-4.00-refman-html.zip)
 archive of HTML files,
* downloaded as a single
 [tarball](4.00/ocaml-4.00-refman.info.tar.gz)
 of Emacs `info` files.

|js}
  ; body_html = {js|<p><strong>License</strong><br />
The OCaml system is open source software: the compiler is distributed
under the terms of the Q Public License, and its library is under LGPL;
please read the <a href="/docs/license.html">license</a> document for more details. A
BSD-style license is also available for a fee through the <a href="/consortium/">OCaml
Consortium</a>.</p>
<h2>What's New</h2>
<p>Release 4.00.1 is mostly a bugfix release.</p>
<p>Some of the highlights in release 4.0.0 (July 2012) are:</p>
<ul>
<li>The name the language is now officially &quot;OCaml&quot;, and this name is
used consistently in all the documentation and tool outputs.
</li>
<li>Generalized Algebraic Data Types (GADTs): this is a powerful
extension of the type system that provides great flexibility and
power to the programmer.
</li>
<li>A new and improved ARM back-end.
</li>
<li>Changes to first-class modules: type annotations can now be omitted
when packing and unpacking modules (and are inferred from context
whenever possible), and first-class modules can now be unpacked by
pattern-matching.
</li>
<li>Support for randomized hash tables to avoid denial-of-service
vulnerabilities.
</li>
<li>Installation of the compiler's internal libraries in
<code>+compiler-libs</code> for easier access by third-party programming tools.
</li>
</ul>
<p>For more information, please consult the <a href="4.00/notes/Changes">comprehensive list of
changes</a>.</p>
<h2>Source distribution</h2>
<ul>
<li><a href="https://github.com/ocaml/ocaml/archive/4.00.1.tar.gz">Source
tarball</a>
(.tar.gz) for compilation under Unix (including Linux and MacOS X)
and Microsoft Windows (including Cygwin).
</li>
<li>Also available in
<a href="https://github.com/ocaml/ocaml/archive/4.00.1.zip">.zip</a>
format.
</li>
<li>You also have <a href="index.html">access</a> to the working
sources and to all previous public releases.
</li>
</ul>
<p>The <a href="4.00/notes/INSTALL">INSTALL</a>
file of the distribution provides detailed compilation and installation
instruction.</p>
<h2>Precompiled binaries for Linux</h2>
<ul>
<li><a href="http://packages.debian.org/ocaml">Debian packages</a>.
</li>
<li><a href="https://admin.fedoraproject.org/pkgdb/package/ocaml/">Fedora
packages</a>.
</li>
<li><a href="http://packages.gentoo.org/packages/?category=dev-lang;name=ocaml">Gentoo
packages</a>.
</li>
</ul>
<h2>Precompiled binaries for MacOS X</h2>
<p>Binary package compiled on Mac OS 10.7.5 with XCode tools 4.4 (probably
not compatible with earlier versions of Mac OS X):</p>
<ul>
<li><a href="https://caml.inria.fr/pub/distrib/ocaml-4.00/ocaml-4.00.1-intel.dmg">for
Intel</a>
(4.00.1)
</li>
</ul>
<h2>Precompiled binaries for Microsoft Windows</h2>
<p>Four ports of OCaml for Microsoft Windows are currently available. For
additional information, please consult the list of <a href="http://caml.inria.fr/ocaml/portability.en.html">portability
issues</a> or the <a href="4.00/notes/README.win32">Windows
release
notes</a>.</p>
<ul>
<li><a href="http://protz.github.com/ocaml-installer/">Cygwin-based native Win32 port
(4.00.0)</a>. A self
installer. The interactive loop comes with a simple graphical user
interface. Some features require the Cygwin environment, which the
installer can fetch for you. However, the compilers are, and
generate true Win32 executables, which do not require Cygwin to run.
</li>
<li>Microsoft-based native Win32 port. No binary distribution available
yet; download the source distribution and compile it.
</li>
<li><a href="http://cygwin.com/">Cygwin</a>-based port. Requires Cygwin. No
graphical user interface is provided. The compilers generate
executables that do require Cygwin. The precompiled binaries are
part of the Cygwin distribution; you can install them using the
Cygwin <code>setup</code> tool. Alternatively, download the source distribution
and compile it under Cygwin.
</li>
<li>Microsoft-based native Win64 port Same features as the
Microsoft-based native Win32 port, but generates 64-bit code. No
binary distribution available yet; download the source distribution
and compile it.
</li>
</ul>
<h2>Precompiled binaries for Solaris</h2>
<p>Available at <a href="http://sunfreeware.com/">sunfreeware.com</a>.</p>
<h2>Alternative Compilers</h2>
<p>Additionally, the following projects allow you to compile OCaml code to
targets traditionally associated with other languages:</p>
<ul>
<li>The <a href="http://ocsigen.org/js_of_ocaml/">js_of_ocaml project</a>, an
OCaml to Javascript compiler (stable)
</li>
<li>The <a href="http://cafesterol.x9c.fr/">ocamljava project</a>, an OCaml to Java
compiler (experimental)
</li>
</ul>
<h2>User's manual</h2>
<p>The user's manual for OCaml can be:</p>
<ul>
<li><a href="4.00/htmlman/index.html">browsed
online</a>,
</li>
<li>downloaded as a single
<a href="4.00/ocaml-4.00-refman.ps.gz">PostScript</a>,
<a href="4.00/ocaml-4.00-refman.pdf">PDF</a>,
or <a href="4.00/ocaml-4.00-refman.txt">plain
text</a>
document,
</li>
<li>downloaded as a single
<a href="4.00/ocaml-4.00-refman-html.tar.gz">TAR</a>
or
<a href="4.00/ocaml-4.00-refman-html.zip">ZIP</a>
archive of HTML files,
</li>
<li>downloaded as a single
<a href="4.00/ocaml-4.00-refman.info.tar.gz">tarball</a>
of Emacs <code>info</code> files.
</li>
</ul>
|js}
  };
 
  { kind = `Compiler
  ; version = {js|3.12.1|js}
  ; date = {js|2011-07-04|js}
  ; intro_md = {js|This page describes OCaml version **3.12.1**, released on 2011-07-04.
|js}
  ; intro_html = {js|<p>This page describes OCaml version <strong>3.12.1</strong>, released on 2011-07-04.</p>
|js}
  ; highlights_md = {js|- Polymorphic recursion is supported, using explicit type declarations
  on the recursively-defined identifiers.
- First-class modules: module expressions can be embedded as values of
  the core language, then manipulated like any other first-class
  value, then projected back to the module level.
- New operator to modify a signature a posteriori:
  `S with   type t := tau` denotes signature `S` where the `t` type
  component is removed and substituted by the type `tau` elsewhere.
- New notations for record expressions and record patterns: `{ lbl }`
  as shorthand for `{ lbl = lbl }`, and `{ ...; _ }` marks record
  patterns where some labels were intentionally omitted.
- Local open `let open   ... in ...` now supported by popular demand. - Type variables can be bound as type parameters to functions; such
  types are treated like abstract types within the function body, and
  like type variables (possibly generalized) outside.
- The `module type of` construct enables to recover the module type of
  a given module.
- Explicit method override using the `method!` keyword, with
  associated warnings and errors.
|js}
  ; highlights_html = {js|<ul>
<li>Polymorphic recursion is supported, using explicit type declarations
on the recursively-defined identifiers.
</li>
<li>First-class modules: module expressions can be embedded as values of
the core language, then manipulated like any other first-class
value, then projected back to the module level.
</li>
<li>New operator to modify a signature a posteriori:
<code>S with   type t := tau</code> denotes signature <code>S</code> where the <code>t</code> type
component is removed and substituted by the type <code>tau</code> elsewhere.
</li>
<li>New notations for record expressions and record patterns: <code>{ lbl }</code>
as shorthand for <code>{ lbl = lbl }</code>, and <code>{ ...; _ }</code> marks record
patterns where some labels were intentionally omitted.
</li>
<li>Local open <code>let open   ... in ...</code> now supported by popular demand. - Type variables can be bound as type parameters to functions; such
types are treated like abstract types within the function body, and
like type variables (possibly generalized) outside.
</li>
<li>The <code>module type of</code> construct enables to recover the module type of
a given module.
</li>
<li>Explicit method override using the <code>method!</code> keyword, with
associated warnings and errors.
</li>
</ul>
|js}
  ; body_md = {js|
**License**<br />
 The OCaml system is open source software: the compiler is distributed
under the terms of the Q Public License, and its library is under LGPL;
please read the [license](/docs/license.html) document for more details. A
BSD-style license is also available for a fee through the [OCaml
Consortium](/consortium/).

## What's New
Some of the highlights in release 3.12 are:

* Polymorphic recursion is supported, using explicit type declarations
 on the recursively-defined identifiers.
* First-class modules: module expressions can be embedded as values of
 the core language, then manipulated like any other first-class
 value, then projected back to the module level.
* New operator to modify a signature a posteriori:
 `S with   type t := tau` denotes signature `S` where the `t` type
 component is removed and substituted by the type `tau` elsewhere.
* New notations for record expressions and record patterns: `{ lbl }`
 as shorthand for `{ lbl = lbl }`, and `{ ...; _ }` marks record
 patterns where some labels were intentionally omitted.
* Local open `let open   ... in ...` now supported by popular demand.
* Type variables can be bound as type parameters to functions; such
 types are treated like abstract types within the function body, and
 like type variables (possibly generalized) outside.
* The `module type of` construct enables to recover the module type of
 a given module.
* Explicit method override using the `method!` keyword, with
 associated warnings and errors.

For more information, please consult the [comprehensive list of
changes](4.00/notes/Changes).

## ![](../img/source.gif "")Source distribution
* [Source
 tarball](https://github.com/ocaml/ocaml/archive/3.12.1.tar.gz)
 (.tar.gz) for compilation under Unix (including Linux and MacOS X)
 and Microsoft Windows (including Cygwin).
* Also available in
 [.zip](https://github.com/ocaml/ocaml/archive/3.12.1.zip)
 format.
* You also have [access](index.html) to the working
 sources and to all previous public releases.

The [INSTALL](3.12/notes/INSTALL)
file of the distribution provides detailed compilation and installation
instruction.

## ![](../img/freebsd.gif "")Precompiled binaries for FreeBSD
Use binary packages provided by the FreeBSD project. Further information
about the FreeBSD packages is available at
[FreshPorts](http://www.freshports.org/lang/ocaml).

## ![](../img/linux.gif "")Precompiled binaries for Linux
* [RPM packages](http://rpm.nogin.org/ocaml.html) for Fedora, RedHat,
 Mandriva. (Contributed by Aleksey Nogin.)
* [Debian packages](http://packages.debian.org/ocaml).
* [Gentoo
 packages](http://packages.gentoo.org/packages/?category=dev-lang;name=ocaml).

## ![](../img/macos.gif "")Precompiled binaries for MacOS X
Binary package compiled on Mac OS 10.6.4 with XCode tools 3.2.3 (not
compatible with Mac OS 10.4.x):

* [for
 Intel](https://caml.inria.fr/pub/distrib/ocaml-3.12/ocaml-3.12.0-intel.dmg)

## ![](../img/windows.gif "")Precompiled binaries for Microsoft Windows
Four ports of OCaml for Microsoft Windows are currently available. For
additional information, please consult the list of [portability
issues](http://caml.inria.fr/ocaml/portability.en.html) or the [Windows
release
notes](3.12/notes/README.win32).

* [MinGW-based native Win32 port
 (3.12.1)](http://protz.github.com/ocaml-installer/). A self
 installer. The interactive loop comes with a simple graphical user
 interface. Some features require the [Cygwin](http://cygwin.com/)
 environment. However, the compilers generate true Win32 executables,
 which do not require Cygwin to run.
* [Cygwin](http://cygwin.com/)-based port. Requires Cygwin. No
 graphical user interface is provided. The compilers generate
 executables that do require Cygwin. The precompiled binaries are
 part of the Cygwin distribution; you can install them using the
 Cygwin `setup` tool. Alternatively, download the source distribution
 and compile it under Cygwin.
* Microsoft-based native Win64 port Same features as the
 Microsoft-based native Win32 port, but generates 64-bit code. No
 binary distribution available yet; download the source distribution
 and compile it.

## Precompiled binaries for Solaris
Available at [sunfreeware.com](http://sunfreeware.com/).

## ![](../img/doc.gif "")User's manual
The user's manual for OCaml can be:

* downloaded as a single
 [PostScript](3.12/ocaml-3.12-refman.ps.gz),
 [PDF](3.12/ocaml-3.12-refman.pdf),
 or [plain
 text](3.12/ocaml-3.12-refman.txt)
 document,
* downloaded as a single
 [TAR](3.12/ocaml-3.12-refman.html.tar.gz)
 or
 [ZIP](3.12/ocaml-3.12-refman.html.zip)
 archive of HTML files,
* downloaded as a single
 [tarball](3.12/ocaml-3.12-refman.info.tar.gz)
 of Emacs `info` files.
|js}
  ; body_html = {js|<p><strong>License</strong><br />
The OCaml system is open source software: the compiler is distributed
under the terms of the Q Public License, and its library is under LGPL;
please read the <a href="/docs/license.html">license</a> document for more details. A
BSD-style license is also available for a fee through the <a href="/consortium/">OCaml
Consortium</a>.</p>
<h2>What's New</h2>
<p>Some of the highlights in release 3.12 are:</p>
<ul>
<li>Polymorphic recursion is supported, using explicit type declarations
on the recursively-defined identifiers.
</li>
<li>First-class modules: module expressions can be embedded as values of
the core language, then manipulated like any other first-class
value, then projected back to the module level.
</li>
<li>New operator to modify a signature a posteriori:
<code>S with   type t := tau</code> denotes signature <code>S</code> where the <code>t</code> type
component is removed and substituted by the type <code>tau</code> elsewhere.
</li>
<li>New notations for record expressions and record patterns: <code>{ lbl }</code>
as shorthand for <code>{ lbl = lbl }</code>, and <code>{ ...; _ }</code> marks record
patterns where some labels were intentionally omitted.
</li>
<li>Local open <code>let open   ... in ...</code> now supported by popular demand.
</li>
<li>Type variables can be bound as type parameters to functions; such
types are treated like abstract types within the function body, and
like type variables (possibly generalized) outside.
</li>
<li>The <code>module type of</code> construct enables to recover the module type of
a given module.
</li>
<li>Explicit method override using the <code>method!</code> keyword, with
associated warnings and errors.
</li>
</ul>
<p>For more information, please consult the <a href="4.00/notes/Changes">comprehensive list of
changes</a>.</p>
<h2><img src="../img/source.gif" alt="" title="" />Source distribution</h2>
<ul>
<li><a href="https://github.com/ocaml/ocaml/archive/3.12.1.tar.gz">Source
tarball</a>
(.tar.gz) for compilation under Unix (including Linux and MacOS X)
and Microsoft Windows (including Cygwin).
</li>
<li>Also available in
<a href="https://github.com/ocaml/ocaml/archive/3.12.1.zip">.zip</a>
format.
</li>
<li>You also have <a href="index.html">access</a> to the working
sources and to all previous public releases.
</li>
</ul>
<p>The <a href="3.12/notes/INSTALL">INSTALL</a>
file of the distribution provides detailed compilation and installation
instruction.</p>
<h2><img src="../img/freebsd.gif" alt="" title="" />Precompiled binaries for FreeBSD</h2>
<p>Use binary packages provided by the FreeBSD project. Further information
about the FreeBSD packages is available at
<a href="http://www.freshports.org/lang/ocaml">FreshPorts</a>.</p>
<h2><img src="../img/linux.gif" alt="" title="" />Precompiled binaries for Linux</h2>
<ul>
<li><a href="http://rpm.nogin.org/ocaml.html">RPM packages</a> for Fedora, RedHat,
Mandriva. (Contributed by Aleksey Nogin.)
</li>
<li><a href="http://packages.debian.org/ocaml">Debian packages</a>.
</li>
<li><a href="http://packages.gentoo.org/packages/?category=dev-lang;name=ocaml">Gentoo
packages</a>.
</li>
</ul>
<h2><img src="../img/macos.gif" alt="" title="" />Precompiled binaries for MacOS X</h2>
<p>Binary package compiled on Mac OS 10.6.4 with XCode tools 3.2.3 (not
compatible with Mac OS 10.4.x):</p>
<ul>
<li><a href="https://caml.inria.fr/pub/distrib/ocaml-3.12/ocaml-3.12.0-intel.dmg">for
Intel</a>
</li>
</ul>
<h2><img src="../img/windows.gif" alt="" title="" />Precompiled binaries for Microsoft Windows</h2>
<p>Four ports of OCaml for Microsoft Windows are currently available. For
additional information, please consult the list of <a href="http://caml.inria.fr/ocaml/portability.en.html">portability
issues</a> or the <a href="3.12/notes/README.win32">Windows
release
notes</a>.</p>
<ul>
<li><a href="http://protz.github.com/ocaml-installer/">MinGW-based native Win32 port
(3.12.1)</a>. A self
installer. The interactive loop comes with a simple graphical user
interface. Some features require the <a href="http://cygwin.com/">Cygwin</a>
environment. However, the compilers generate true Win32 executables,
which do not require Cygwin to run.
</li>
<li><a href="http://cygwin.com/">Cygwin</a>-based port. Requires Cygwin. No
graphical user interface is provided. The compilers generate
executables that do require Cygwin. The precompiled binaries are
part of the Cygwin distribution; you can install them using the
Cygwin <code>setup</code> tool. Alternatively, download the source distribution
and compile it under Cygwin.
</li>
<li>Microsoft-based native Win64 port Same features as the
Microsoft-based native Win32 port, but generates 64-bit code. No
binary distribution available yet; download the source distribution
and compile it.
</li>
</ul>
<h2>Precompiled binaries for Solaris</h2>
<p>Available at <a href="http://sunfreeware.com/">sunfreeware.com</a>.</p>
<h2><img src="../img/doc.gif" alt="" title="" />User's manual</h2>
<p>The user's manual for OCaml can be:</p>
<ul>
<li>downloaded as a single
<a href="3.12/ocaml-3.12-refman.ps.gz">PostScript</a>,
<a href="3.12/ocaml-3.12-refman.pdf">PDF</a>,
or <a href="3.12/ocaml-3.12-refman.txt">plain
text</a>
document,
</li>
<li>downloaded as a single
<a href="3.12/ocaml-3.12-refman.html.tar.gz">TAR</a>
or
<a href="3.12/ocaml-3.12-refman.html.zip">ZIP</a>
archive of HTML files,
</li>
<li>downloaded as a single
<a href="3.12/ocaml-3.12-refman.info.tar.gz">tarball</a>
of Emacs <code>info</code> files.
</li>
</ul>
|js}
  }]

