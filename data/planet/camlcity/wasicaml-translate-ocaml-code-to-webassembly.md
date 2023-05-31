---
title: 'WasiCaml: Translate OCaml Code to WebAssembly'
description:
url: http://blog.camlcity.org/blog/wasicaml1.html
date: 2021-07-15T00:00:00-00:00
preview_image:
featured:
authors:
- camlcity
---



<div>
  <b>The portability story behind WasiCaml</b><br/>&nbsp;
</div>

<div>
  
  For a recent project we wrote a compiler that translates a
  domain-specific language (DSL) to some runnable form, and we did
  that in OCaml. The DSL is now part of an Electron-based integrated
  development environment (IDE) that will soon be available
  from <a href="https://remixlabs.com">Remix Labs</a>. Electron runs
  on a couple of operating systems, but the DSL compiler orginally did
  not.  How do we accomplish it to run the DSL compiler on as many
  different operating systems?  This was the question we faced when
  starting the development of WasiCaml, a translator from OCaml
  bytecode to WebAssembly.

</div>

<div>
  
<p>
  Of course, Electron is just an example of a cross-platform
  environment.  You can develop apps for Mac, Windows, and Linux, and
  it is Javascript-based.  We picked Electron for porting the user
  interface of the IDE to the desktop - originally the IDE was written
  for the web, and the DSL compiler was running on a server backing
  the web app. Initially, the Electron version of the IDE started just
  a native binary of the DSL compiler as a server process that ran in
  the background, just like we did it for the web, but this means that
  you run into the cross-build problem again that you actually want to
  avoid by running something in Electron: we would have needed to set
  up several build pipelines, one for each OS, in order to build the
  DSL compiler for the targets we wanted to support.

</p><p>
  There are already tools to translate OCaml to Javascript (namely
  Bucklescript and js_of_ocaml), and we could have used these to fiddle
  the DSL compiler into the Javascript code base. However, this does
  not feel right: we would have had to reorganize the OCaml code base
  because you can't link in C libraries, and driving the DSL compiler
  would have been quite adventurous (it talks via a bidirectional
  pipeline to its clients). At that time we were already exploring
  WebAssembly for other parts of the system, and the idea came up
  to also use WebAssembly for running the DSL compiler. The
  <a href="https://github.com/remixlabs/wasicaml/">WasiCaml</a>
  project was born (and the translation to Javascript only plan B
  should this turn out to be more difficult than expected).

  </p><h2>A quick intro to WebAssembly</h2>

<p>
  As the name suggests, WebAssembly provides a fairly low-level virtual
  machine for running the code. The instructions are comparable to the
  ones you find in a CPU, e.g. load, store, arithmetic. The code is
  structured into functions which take a fixed number of parameters
  and return a single result. The functions can have local variables
  that can be read and written by the code. The parameters and variables
  can have one of four numeric types (i32, i64, f32, and f64).

</p><p>
  For example, this is a WebAssembly module with just one function that
  increments a 32 bit number at a memory location by one, and returns
  the value:
</p><blockquote>
<code style="white-space: pre">
(module
  (import &quot;env&quot; &quot;memory&quot; (memory $memory 1))
  (func $incr (export &quot;incr&quot;) (param $x i32) (result i32)
    (local.get $x)
    (i32.load)
    (i32.const 1)
    (i32.add)
    (return)
  )
)
</code>
</blockquote>

<p>
  Here, the code is given in the textual format known as WAT. For running
  it, you first need to convert it to the binary format (WASM), e.g.
  with a tool like <a href="https://github.com/WebAssembly/wabt">wat2wasm</a>.

</p><p>
  Also note that there is an operands stack: <code>local.get</code> pushes
  the result on this stack, and <code>i32.load</code> loads the number
  from the address found on the stack, and also pushes the result on the
  stack. This stack is mainly meant to express the code in a very compact
  way. The engine running code normally translates the stack operations
  into a more efficient form before starting up.

</p><p>
  A WebAssembly VM is equipped with linear memory, i.e. the memory
  addresses go from 0 to a maximum address, without fragmentation, and
  without address ranges supporting special semantics like mapped files. The
  memory is only used for data - the running code is inaccessible
  (i.e. the VM has a Harvard architecture), and this also includes the
  call stack and other parts of the VM (e.g. you cannot iterate over
  the local variables of the functions). In order to also support
  indirect jumps, there is a way to reference functions by numeric
  IDs.

</p><p>
  Typically, WebAssembly VMs translate the code to the native
  instruction set of the host running of code before running the code
  (often as JIT compilers, but there are now also engines doing the
  translation statically ahead of time, and producing native binaries),
  and these engines almost reach native speed.  All current browsers support
  WebAssembly now, and it is also present in other Javascript-based
  environments (like node, or the Electron platform).  Although it
  started as a web technology, WebAssembly is not limited to the web.
  For example, <a href="https://docs.wasmtime.dev/">wasmtime</a>
  allows you to embed a WebAssembly engine into almost any environment
  - e.g. you could embed the engine into an application server written
  in Go. In this case, there is no Javascript involved at all.
    
  </p><h2>WASI</h2>

<p>
  While the WebAssembly standard defines how to express the code and
  how to run it, there is still the question how to use it with
  popular languages like C, and
  Rust. The <a href="https://wasi.dev/">WASI</a> standard is an ABI
  that answers a lot of the questions. As an ABI it defines calling
  conventions, but it is not limited to that. In particular, there is
  a version of libc that defines a Unix-like set of base functionality
  the language-specific runtime can use. Also, WASI defines a set of host
  functions that play a role comparable to system calls in the WebAssembly
  world, and that allow access to files, the process environment, and
  the current time. With the help of WASI you can compile many C
  or Rust libraries to WebAssembly, and the porting effort is low.

</p><p>
  WASI is multi-lingual environment, and you can in particular link
  code written in different languages into the same executable. This is
  possible because the language-specific runtimes have a common foundation
  (libc), and e.g. memory allocated from one language also counts as
  &quot;taken&quot; within the other language.

</p><p>
  WASI is still in an early stage. While developing with it I discovered
  a couple of bugs, but the functionality is already impressive and
  usable for many purposes.
  
  </p><h2>WasiCaml</h2>

<p>
  So now, what is WasiCaml, and how can I use it?

</p><p>
  Let's assume you have a bytecode executable created by something like
</p><blockquote>
<code style="white-space: pre">
  ocamlc -o myexecutable mycode.ml
</code>
</blockquote>

<p>Now, you can further translate the bytecode executable to WebAssembly:

</p><blockquote>
<code style="white-space: pre">
  wasicaml -o mywasm.wasm myexecutable
</code>
</blockquote>

<p>If you want to run this executable, you need a specially configured
WebAssembly engine which can be found in ~/.wasicaml/js after installation:

</p><blockquote>
<code style="white-space: pre">
  node ~/.wasicaml/js/main.js ./mywasm.wasm ./mywasm.wasm arg ...
</code>
</blockquote>

<p>The <code>mywasm.wasm</code> binary is portable and can be run
  everywhere!

</p><p>For simplicity, wasicaml can also generate a wrapper that hides the
<code>node</code> invocation, and this is triggered by just omitting
the .wasm suffix:

</p><blockquote>
<code style="white-space: pre">
  wasicaml -o mywasm myexecutable
</code>
</blockquote>

<p>Now you can run the program simply with <code>./mywasm</code> (but note
that the wrapper is not portable).

</p><p>Another option is to link in C libraries like e.g.
</p><blockquote>
<code style="white-space: pre">
  wasicaml -o mywasm.wasm myexecutable -cclib ~/.wasicaml/lib/ocaml/libunix.a
</code>
</blockquote>

Of course, the C library must also be WASI-compatible.

<p>Note that WasiCaml-produced code can so far not be run with
  wasmtime or wasmer, in particular because there is no machinery
  for exception handling in these engines. Browsers are fully
  supported, though.

  </p><h2>The WasiCaml project</h2>

<p>WebAssembly is still a very new technology and information about it
  is rare. For example, it took a while until I understood that LLVM
  includes a full-featured assembler for WebAssembly, i.e. you can feed
  it a <code>code.s</code> file, and you get a <code>code.o</code>
  file back with partially linked WebAssembly code. This is documented
  nowhere, and I could only figure out some parts of the assembler syntax
  by reading the source code of LLVM.

</p><p>What I already knew from an earlier WebAssembly project is that
  there is no exception handling (EH) mechanism yet in the standard
  (although this will likely change soon). This turned out as a
  special problem for WasiCaml, because the OCaml runtime uses long
  jumps in external C code to trigger OCaml exceptions. I remembered
  the way the <a href="https://emscripten.org">Emscripten</a>
  toolchain (which is another wrapper around LLVM) gets around this
  difficulty.  If the host language is Javascript, embedded
  WebAssembly code is compiled to run in the same VM that is also used
  to execute Javascript itself, and this means that Javascript exceptions
  also work perfectly for WebAssembly! Of course, this trick is
  really limited to Javascript hosts, but at least I could remove
  the blocker for one of the possible execution environments.

</p><p>The very first task was then to get the OCaml bytecode interpreter
  working in a WASI (plus EH) environment.
  
  </p><h2>Milestone: running the bytecode interpreter in the WASI environment</h2>

<p>Essentially, this means that I wanted to (1) clone the OCaml source
  code, (2) <code>configure</code> it, and (3) <code>make</code> the
  bytecode interpreter (and the whole OCaml bytecode toolchain).  The
  C compiler comes from the
  <a href="https://github.com/WebAssembly/wasi-sdk">WASI SDK</a>,
  and it compiles directly to WebAssembly. Now, if you just set the
  <code>CC</code> variable to this C compiler, <code>configure</code>
  will consider the target as a cross-compile target. Such targets
  are still very tricky, and - because we actually <em>can</em> run
  the code somehow - I thought it is better to avoid cross-compilation
  altogether, and to add some tooling so that binaries are
  directly runnable.

</p><p>Instead of pointing <code>CC</code> directly to the C compiler of
  the WASI SDK, there is now a wrapper script <code>wasi_cc</code>.
  The main purpose of this script is to reshape the WebAssembly
  executables so that they are directly runnable on the host
  system. This is accomplished by prepending a <em>starter</em> to the
  WebAssembly code. The <em>starter</em> runs <code>node</code> with
  the right driver script, and extracts the WebAssembly code from the
  executable file. For example, if you do

</p><blockquote>
<code style="white-space: pre">
  wasi_cc -o ex code.c
</code>
</blockquote>

the resulting file <code>ex</code> can be directly run with
<code>./ex</code>.

<p>With this trick, <code>configure</code> now &quot;thinks&quot; that the
  target is a native target of the operating
  system. <code>configure</code> could also run the tests on the
  existence of the various libc library functions the OCaml runtime
  needs, and figured out a lot of that stuff correctly. Nevertheless,
  not everything was working, and I had to fork the OCaml sources in
  order to disable functions that are not available
  (see <a href="https://github.com/gerdstolpmann/ocaml/compare/4.12.0...gerd/wasi-4.12.0">gerd/wasi-4.12.0</a>
  for the changes).

</p><p>In this branch of OCaml I also changed the main function of the
  bytecode interpreter so that it catches exceptions from Javascript
  (actually, this function was split into two, and the outer function
  catches the exception thrown by the inner function).

</p><p>A final difficulty was that function pointers in WebAssembly are typed
  - which is a logical consequence of the fact that functions are typed.
  OCaml generates a file <code>prims.c</code> that initializes the list
  of FFI functions, and initially LLVM did not like this file, because
  it could not infer the types of the function pointers. The solution
  was <em>not</em> to generate WebAssembly for this single file but
  to leave it as LLVM IR (&quot;bitcode&quot;). In this format function pointers
  can remain untyped, and the LLVM linker is smart enough to fix up
  the problem at link time, and to convert LLVM IR to WebAssembly when
  the types of the FFI functions are known.

</p><p>With this trick, everything worked fine! The speed of the bytecode
  interpreter did not slow much down in WebAssembly, which was very
  encouraging.

  </p><h2>Milestone: the direct translator</h2>

<p>After the bytecode interpreter was running, the second step was to
  directly generate WebAssembly code from OCaml. Actually, there were
  two choices: either to pick up one of the internal formats of OCaml
  (e.g. &quot;Lambda&quot; or &quot;C--&quot;) and to change the OCaml compiler directly,
  or to take the bytecode as the starting point. I preferred the
  latter because WasiCaml is then an add-on processor that can be
  easily added to existing OCaml projects, and because some
  difficulties could be avoided (e.g. incremental compilation, and
  many many fixups through the whole toolchain). Also, I hoped that
  the resulting speed would still be &quot;good enough&quot; (at least for the
  purposes of the DSL compiler we wanted to run with WebAssembly).

</p><p>Also, bytecode made it also a lot easier for me to get started.
  There were really a lot of unanswered questions: what does the
  function call mechanism look like? How do we get around the problem
  that OCaml code typically requires tail calls to be working but
  there aren't tail calls in WebAssembly (yet)? What does the code
  look to allocate a block of memory? How do we emulate exceptions?
  Picking bytecode meant that I could focus on these questions, while
  the bytecode instructions could initially be translated in a naive
  way, e.g. by translating each bytecode instruction separately to a
  fixed block of WebAssembly instructions (like instantiating a
  template). (Note that the current WasiCaml compiler is already
  a lot better than that.)

</p><p>Picking bytecode also meant that WasiCaml inherits the bytecode
  stack. This is actually not a bad thing - because of OCaml's memory
  management the stack must reside in addressable memory, and the
  bytecode stack could serve as what the WebAssembly community calls
  a <em>shadow stack</em>. (Even for the C language there is a
  shadow stack - and the alternative would have been to also use the
  shadow stack of the C language.) So we got the shadow stack for
  OCaml code practically for free.

</p><p>The stack is important because the garbage collector must be
  able to run over all locations where OCaml values are stored.
  As already mentioned, the locations WebAssembly natively supports
  cannot be traversed over (like local and global variables), and
  hence it is crucial to put OCaml values into memory whenever there
  is the chance of a garbage collector run.

</p><p>Note that the native OCaml compiler is not much different in this
  respect - only that the native stack of the operating system can be
  used for storing values because it resides in memory. The details
  are different, though. When a value is moved temporarily to the
  stack, this is usually called &quot;register spilling&quot;, and this is done
  because (1) there is only a limited amount of registers, but another
  register is needed, or (2) you don't know which register remains
  untouched when you call a function, or (3) you call some code that
  may run the garbage collector. Now, in WebAssembly, reason (1) is
  never the case because there can be any number of local variables
  (which take over the role of registers), and the details of (3) are
  very different, because in a native environment the registers are
  global stores, permitting some time-saving tricks that are
  unavailable in WebAssembly.

</p><p>So, for developing the WasiCaml code emitter, this meant that it
  had to follow constraints so that OCaml values end up on the stack
  in the right moment. Actually, these constraints mainly shaped the
  layout of the WasiCaml code.
  
  </p><h2>32 bit comes back!</h2>

<p>Once WasiCaml was working, we got back to the DSL compiler we
  originally wanted to make cross-platform. And we actually got it
  running! There was one remaining problem, though: WebAseembly is a
  32 bit environment. As you may know, OCaml suffers from some
  limitations in this case. Most annoyingly, strings can only be 16 MB
  in size at most.

</p><p>Fortunately, this problem occurred only here and there, mostly
  in the code emitter. Here, we could switch to
  <a href="https://github.com/Chris00/ocaml-rope">ropes</a>
  as alternate representation - and, lucky as we were, it turned
  out that this change did not eat much performance.

</p><p>The DSL compiler is quite big, and the WebAssembly version takes
  around 3 seconds to start up. This is longer than usual, but for
  our application we could hide the startup time, and are now quite
  happy with the product.

  </p><hr/>

<p>PS. Interested in WebAssembly and you know OCaml (or another
  functional language like Elm, Scala, Haskell, ...)?
  <a href="https://www.mixtional.de/recruiting/2021-01/index.html">We might have
    a job for you (July 2021)</a>.
</p>
</div>

<div>
  Gerd Stolpmann is the CEO of <a href="https://mixtional.de">Mixtional Code GmbH</a>, currently busy with the last development steps of the <a href="http://remixlabs.com">Remix Labs</a> platform

</div>

<div>
  
</div>


          
