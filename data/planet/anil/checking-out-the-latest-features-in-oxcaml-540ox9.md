---
title: Checking out the latest features in OxCaml 5.4.0+ox9
description: What changed between OxCaml 5.2.0+minus39 and 5.4.0+ox9, covering unboxed
  values, atomic fields, safer effects, and experimental polymorphism over layouts
  and modes.
url: https://anil.recoil.org/notes/oxcaml-ox9-improvements
date: 2026-11-06T00:00:00-00:00
preview_image: https://anil.recoil.org/images/arod-ss-ox9.640.webp
authors:
- Anil Madhavapeddy
source:
ignore:
keywords:
- effect
- effect handler
- float
- foreign function interface
- ocamlformat
- ox9
- oxcaml
- type checker
- unboxed
- utop
---

<p>This <a href="https://anil.recoil.org/notes/bushel-lives">website</a> runs on <a href="https://anil.recoil.org/projects/oxcaml">OxCaml</a>, a set of performance-oriented
extensions to the OCaml language <a href="https://oxcaml.org">developed</a> at Jane Street.
I <a href="https://anil.recoil.org/notes/oxcaml-opam-guards">last upgraded</a> our monorepo back in the summer, and <a href="https://www.dra27.uk">David Allsopp</a> has
just released a major <a href="https://github.com/oxcaml/opam-repository/pull/66">OxCaml 5.4.0-ox9</a> release.
This upgrade shifts the base version of the fork over to a newer release of OCaml (yay!),
as well as many improvements to their extensions.</p>
<p>If you're new to OxCaml then you may want to start with the <a href="https://anil.recoil.org/notes/icfp25-oxcaml">ICFP tutorial</a> first, and there's a <a href="https://anil.recoil.org/news.xml#a-recap-of-oxcaml-tis-a-speedy-camel">quick recap</a>
and <a href="https://anil.recoil.org/news.xml#installing-oxcaml-540-ox9-yourself">installation instructions</a>. The rest of
the post goes through the changes that affected my code, grouped into
<a href="https://anil.recoil.org/news.xml#reducing-allocations">reducing allocations</a>, <a href="https://anil.recoil.org/news.xml#kinds">kinds</a>,
<a href="https://anil.recoil.org/news.xml#modes-and-stack-allocation">modes</a>, <a href="https://anil.recoil.org/news.xml#effect-handlers">effect handlers</a>,
the <a href="https://anil.recoil.org/news.xml#foreign-function-interface">C interface</a> and <a href="https://anil.recoil.org/news.xml#performance-and-optimisations">performance</a>, followed by a peek at the
<a href="https://anil.recoil.org/news.xml#emerging-features">emerging features</a> behind extension flags and some
<a href="https://anil.recoil.org/news.xml#should-you-use-oxcaml-yourself">advice</a> on whether to dive in yourself.</p>
<p><img src="https://anil.recoil.org/images/arod-ss-ox9.webp" alt="%c" title="This website's development dashboard, using the OCaml console library, running OxCaml 5.4.0+ox9"></p>
<h2><a href="https://anil.recoil.org/news.xml#a-recap-of-oxcaml-tis-a-speedy-camel" class="anchor" aria-hidden="true"></a>A recap of OxCaml: tis a speedy camel</h2>
<p>For those arriving fresh, <a href="https://oxcaml.org">OxCaml</a> is a fork of the OCaml
compiler (<a href="https://github.com/oxcaml/oxcaml">oxcaml/oxcaml</a>) and used in production at
Jane Street. The extensions are designed to be conservative, so normal OCaml
code mostly works, and are enabled when more control over allocation, memory layout, or
data-race-free concurrency is needed.</p>
<p>I like it because, unlike Rust, we can benefit from the ergonomics of having
a garbage collector by default, and selectively write high-performance code
where necessary.  The main extensions are:</p>
<ul>
<li><a href="https://oxcaml.org/documentation/kinds/intro/"><em>Layouts and kinds</em></a>, which let you declare
<a href="https://oxcaml.org/documentation/unboxed-types/intro/">unboxed types</a> such as <code>float#</code>,
<code>int64_u</code> and unboxed records <code>r#</code> that are stored flat with no <a href="https://dev.realworldocaml.org/runtime-memory-layout.html">pointer
indirection</a>, and polymorphic code that's explicit about which of these
representations it accepts.</li>
<li><a href="https://doi.org/10.1145/3674642"><em>Modes</em></a>, which annotate a value with dataflow properties.
These include
<code>local</code> for stack allocation, <code>unique</code> for values with a single mutator, and
<code>portable</code> and <code>contended</code> for values that can cross between parallel domains
safely.</li>
<li><a href="https://oxcaml.org/documentation/miscellaneous-extensions/zero_alloc_check/"><em>Checked performance claims</em></a>, such as <code>[@zero_alloc]</code> on a function to
guarantee no allocations, along with <a href="https://oxcaml.org/documentation/simd/intro/">SIMD vector operations</a>
and the <a href="https://icfp23.sigplan.org/details/ocaml-2023-papers/8/Efficient-OCaml-compilation-with-Flambda-2">Flambda 2 optimiser</a>.</li>
<li><a href="https://oxcaml.org/documentation/parallelism/intro/"><em>Parallelism</em></a>, via the <code>parallel</code> and <code>await</code> libraries and the <code>capsule</code>
abstraction, which depend on the mode system for their safety guarantees.
We did a <a href="https://anil.recoil.org/notes/icfp25-oxcaml">tutorial at ICFP</a> about these last year.</li>
</ul>
<p>OxCaml generally tracks upstream OCaml, rebasing irregularly and tagging
numbered snapshots in between. The 5.2-based series has run for some years
now (from minus25 to minus40), and the process of rebasing to the 5.4-based series has now reached ox9.
While the compiler itself advances regularly, the supporting OxCaml libraries must also match or
else we can't really take advantage of the new features.</p>
<p>These support libraries like Base, Core, <code>ppx_jane</code> etc, are distributed through an
<a href="https://github.com/oxcaml/opam-repository">oxcaml opam overlay</a> whose
<a href="https://anil.recoil.org/notes/oxcaml-opam-guards">guard packages</a> make sure that an OxCaml opam switch
installs the right packages.  This is a complex packaging endeavour, and that's why
I'm excited that <a href="https://www.dra27.uk">David Allsopp</a> has merged a usable 5.4.0-ox9 release that we can
all use in public that also includes the corresponding Jane Street libraries!</p>
<h2><a href="https://anil.recoil.org/news.xml#installing-oxcaml-540-ox9-yourself" class="anchor" aria-hidden="true"></a>Installing OxCaml 5.4.0-ox9 yourself</h2>
<p>The instructions on oxcaml.org still refer to <code>5.2.0+ox</code> and will no doubt be
updated soon, but I did the following to directly install the <code>5.4.0-ox9</code> libraries.</p>
<pre><code class="language-sh">opam update --all
opam switch create 5.4.0-ox9 oxcaml-compiler.5.4.0-ox9 \
  --repos ox=git+https://github.com/oxcaml/opam-repository.git,default
eval $(opam env --switch 5.4.0-ox9)
opam install -y merlin ocaml-lsp-server ocamlformat utop core_unix parallel
</code></pre>
<p>The <code>ox</code> repository must be listed before <code>default</code> so that patched versions of
tools such as merlin, ocamlformat and ppxlib take priority over the upstream ones.
If you already have an older OxCaml switch, there's no upgrade path within
it as the libraries for minus39 conflict with any other compiler release. It's
easier just to create a fresh switch for the new 5.4.0 series.</p>
<p>I went through all of the changes while updating my <a href="https://anil.recoil.org/notes/aoah-2025-25">Claude OCaml Marketplace</a> skills for
<a href="https://github.com/avsm/ocaml-claude-marketplace/tree/main/plugins/ocaml-dev/skills/oxcaml">OxCaml 5.4.0-ox9</a> (<a href="https://github.com/avsm/ocaml-claude-marketplace/commit/258d5756b0cc0af6f2bfe996daba334056a6c523">changeset</a>).
What follows are interesting new features released in the past three months
that I reviewed while also updating my monorepos to deploy the compiler.
I've left out everything that arrived with upstream OCaml 5.3/5.4
(effect handler syntax, <code>Stdlib.Iarray</code> and so on), so look at the
<a href="https://ocaml.org/releases/5.4.0">upstream release notes</a> for those first if you're unfamiliar with the
OCaml ecosystem.</p>
<h2><a href="https://anil.recoil.org/news.xml#reducing-allocations" class="anchor" aria-hidden="true"></a>Reducing allocations</h2>
<p>The headline feature of OxCaml is to execute programs faster by doing
less work on housekeeping (like allocating and deallocating memory) and more on
useful compute.</p>
<h3><a href="https://anil.recoil.org/news.xml#unboxed-numbers-and-mixed-records" class="anchor" aria-hidden="true"></a>Unboxed numbers and mixed records</h3>
<p>OxCaml has several mechanisms to reduce <a href="https://www.janestreet.com/tech-talks/unboxed-types-for-ocaml/">boxing</a> of integers and floats,
which are extremely beneficial to improving data processing performance.
The <code>#</code> suffix is used for the unboxed version of primitive types, such
as <code>float#</code>, <code>int8#</code> and the unboxed version <code>r#</code> of a record <code>r</code>.</p>
<p>In addition to these unboxed variants of standard types, there are
also custom types for 32-bit, 64-bit and native unboxed integers and a 32-bit float
which used to also use the <code>int64#</code>, <code>int32#</code>, <code>nativeint#</code> and <code>float32#</code> syntax.
These four are now standalone types called <code>int64_u</code>, <code>int32_u</code>, <code>nativeint_u</code> and <code>float32_u</code>
(<a href="https://github.com/oxcaml/oxcaml/pull/6663">#6663</a>), which is a breaking
(but good) change.</p>
<pre><code class="language-ocaml">type sample = { id : int64_u; weight : float#; tag : int8#; label : string }
let s = { id = #7L; weight = #0.5; tag = #3s; label = "a" }

type boxed = float# box                         (* equal to float *)

type m = { f : float; u : float# }              (* no [@@flatten_floats] *)
let unboxed () : m# = #{ f = 1.0; u = #2.0 }

type node = { next : #(node option * float#) }
let rec cycle = { next = #(Some cycle, #4.0) }  (* through an unboxed field *)
</code></pre>
<p>5.4.0-ox9 also makes unboxed types much more usable in general, as seen in the above
snippets:</p>
<ul>
<li>There was no way to name the boxed form of an unboxed type, but now the predefined
<code>'a box</code> exists (<a href="https://github.com/oxcaml/oxcaml/pull/5342">#5342</a>).</li>
<li>A record mixing <code>float</code> and <code>float#</code> fields was rejected unless annotated
<code>[@@flatten_floats]</code>. The attribute is now optional, and without it the
record also generates an unboxed version
(<a href="https://github.com/oxcaml/oxcaml/pull/6106">#6106</a>).</li>
<li>A recursive value couldn't pass through an unboxed field ("not allowed as
right-hand side of let rec"), which made cyclic structures built from
flat records very difficult to express (about as awkward as they are in Rust!).
This now works in 5.4.0-ox9 (<a href="https://github.com/oxcaml/oxcaml/pull/6847">#6847</a>).</li>
<li>Unsigned types are now builtin, with <code>uint8_u</code> through to <code>uint64_u</code> with
unsigned division and remainder primitives. I couldn't find literals or arithmetic
operations yet though (<a href="https://github.com/oxcaml/oxcaml/pull/6534">#6534</a>).</li>
</ul>
<h3><a href="https://anil.recoil.org/news.xml#non-allocating-optional-types" class="anchor" aria-hidden="true"></a>Non-allocating optional types</h3>
<p>The builtin <a href="https://oxcaml.org/documentation/unboxed-types/or-null/"><code>'a or_null</code></a> type is a
non-allocating replacement for <code>option</code>, where <code>This x</code> is represented as <code>x</code> itself and
<code>Null</code> as a special immediate value.</p>
<pre><code class="language-ocaml">type 'a maybe = Nope | Yep of 'a [@@or_null]
type callback = Unset | Set of (unit -&gt; unit) [@@or_null]
type flag = Off of unit# | On of string [@@or_null]

let run = function Unset -&gt; () | Set f -&gt; f ()
</code></pre>
<p>5.2.0-minus39 introduced <code>[@@or_null]</code> on user-defined variants, which allows
an unboxed optional type. It required the payload to have exactly
one type parameter, so only generic <code>option</code>-like types qualified. As shown above, the payload can now
be any type in 5.4.0+ox9 (<a href="https://github.com/oxcaml/oxcaml/pull/5830">#5830</a>), and the null
constructor can also carry a void payload
(<a href="https://github.com/oxcaml/oxcaml/pull/6383">#6383</a>), and the resulting type
has the same kind as the built-in <code>or_null</code>.</p>
<p>In practice this means an optional callback or an optional integer can have a descriptive type of its own without
requiring an allocation due to the boxing.  I've started using this quite a bit in my <a href="https://anil.recoil.org/notes/oxcaml-httpz">zero allocation httpz</a>
library that drives this site.</p>
<h3><a href="https://anil.recoil.org/news.xml#atomic-record-fields" class="anchor" aria-hidden="true"></a>Atomic record fields</h3>
<p>An OCaml record field can be marked <code>[@atomic]</code> (since <a href="https://ocaml.org/releases/5.4.0">OCaml 5.4</a>) so that the field is accessed with atomic reads and writes.
This allows it to be safely shared between parallel domains without being wrapped in a separate <code>Atomic.t</code>.</p>
<p>An <code>[@atomic]</code> field couldn't previously appear in a record that also held
unboxed fields, which meant that (e.g.) a lock-free counter alongside a <code>float#</code> in
a record had to be boxed in a separately allocated <code>Atomic.t</code>.
Block indices also didn't support atomic fields either, but both now work
(<a href="https://github.com/oxcaml/oxcaml/pull/6423">#6423</a>, <a href="https://github.com/oxcaml/oxcaml/pull/6667">#6667</a>).</p>
<p>This means that shared mutable state can be inline in a flat record, which
allows for some tightly laid out concurrent-friendly datastructures.</p>
<p>One behaviour that's changed is that a functional update <code>{ c with … }</code> used to copy
all atomic fields with an ordinary read.
This is now rejected unless the atomic field is given
explicitly <code>{ c with the_atomic=... }</code> (<a href="https://github.com/oxcaml/oxcaml/pull/6453">#6453</a>).</p>
<pre><code class="language-ocaml">open Stdlib_stable

type counter = { mutable hits : int [@atomic]; rate : float# }
let hits : (counter, int) idx_atomic = (.hits)

let bump (c : counter) = Idx_atomic.incr c hits
let swap (c : counter) = Idx_atomic.compare_and_set c hits 0 1

let reset (c : counter) = { c with hits = 0 }
(* { c with rate = #1.0 } is rejected: it would read [hits] implicitly *)
</code></pre>
<h2><a href="https://anil.recoil.org/news.xml#kinds" class="anchor" aria-hidden="true"></a>Kinds</h2>
<p><a href="https://oxcaml.org/documentation/kinds/intro/">OxCaml kinds</a> describe how a type is represented in memory (e.g. a boxed pointer, or a flat
float, etc) along with whether it can cross modes.
Kinds allow polymorphic code to be more explicit about which representations work, instead of assuming everything is a pointer.</p>
<blockquote>
<p>Roughly, the kind system adds an extra level to the type system: terms are
classified by types, and types are classified by kinds.  [...] Kinds capture
properties of types along several different dimensions. For example, kinds
can be used to identify which types have values that are passed in floating
point registers, or are safely ignored by the garbage collector.
<cite>-- <a href="https://oxcaml.org/documentation/kinds/intro/">OxCaml Kinds</a>, Jan 2026</cite></p>
</blockquote>
<p>Kind annotations used to be accepted without any check that they were
accurate. Writing <code>('a : any)</code> on a parameter used as (e.g.) an <code>'a list</code> compiled
silently with the kind narrowed to what the body needed. The 5.4.0+ox9 compiler now
warns by default when an annotation is weaker than the inferred kind
(<a href="https://github.com/oxcaml/oxcaml/pull/5362">#5362</a>) or when a modifier has no
effect. This lets annotations be trusted as documentation, so some of my older
code raised warnings when upgrading (but everything was easily fixed to the more
specific kind annotation).</p>
<p>The remaining changes remove gaps in the compiler implementation.</p>
<ul>
<li><code>[@@@implicit_kind]</code> was ignored in structures; it now applies there as it does in signatures
(<a href="https://github.com/oxcaml/oxcaml/pull/6114">#6114</a>).</li>
<li>Modifiers on abstract kinds are now accepted
(<a href="https://github.com/oxcaml/oxcaml/pull/5874">#5874</a>).</li>
<li>The new modifier <code>addressable</code> marks kinds whose boxed form has
interior pointers (<a href="https://github.com/oxcaml/oxcaml/pull/6712">#6712</a>).</li>
<li>A constructor whose arguments are all void used to be accepted, but now
needs <code>[@immediate_all_void_constructor]</code>
(<a href="https://github.com/oxcaml/oxcaml/pull/6256">#6256</a>). This is because the
representation of such constructors is planned to change in a future release
and this attribute will make the upgrade easier.</li>
</ul>
<pre><code class="language-ocaml">type ('a : any mod separable) cell = 'a array   (* [any] alone: warning 181 *)

module Buffer = struct
  [@@@implicit_kind: ('elt : bits64)]
  let singleton : 'elt -&gt; 'elt array = fun x -&gt; [| x |]
end

module type S = sig
  kind_ k
  val get : ('a : k separable). 'a array -&gt; 'a
end

type handle : bits8 addressable
type t = A of unit# [@immediate_all_void_constructor] | B of int
</code></pre>
<h2><a href="https://anil.recoil.org/news.xml#modes-and-stack-allocation" class="anchor" aria-hidden="true"></a>Modes and stack allocation</h2>
<p>A mode is an annotation on a <em>value</em> that tracks a dataflow property, like
whether the value is allocated on the stack (<code>local</code>), has a single owner
(<code>unique</code>) or can safely cross to another domain (<code>portable</code>). The OxCaml
type checker enforces that these properties are used consistently.</p>
<p>The change in 5.4.0-ox9 that broke my code was a bugfix for a leak
(<a href="https://github.com/oxcaml/oxcaml/pull/6396">#6396</a>). Previously, if the last expression
of a function was a call that returned a local value (e.g. <code>fst p</code> on a local
pair), then the enclosing function was also made local-returning as well which
never released the caller's stack frames. This is now an error unless the call
is wrapped in <code>exclave_</code>, bound to a variable, or annotated <code>[@nontail]</code>. The
fix itself was mechanical in the few places in my monorepo where the ox9
compiler rejected old code.</p>
<p>Implicit mode inference, by contrast, became more permissive and usable:</p>
<ul>
<li>A mode on a parameter used to apply to every axis; e.g.
<code>(f @ stateful)</code> made <code>f</code> nonportable.  The implied axes are now inferred
(<a href="https://github.com/oxcaml/oxcaml/pull/6745">#6745</a>) using fancy type math.</li>
<li>A partial application is now constrained only by used parameters
(<a href="https://github.com/oxcaml/oxcaml/pull/6966">#6966</a>).</li>
<li>A coercion can mode-cross the result of a function
(<a href="https://github.com/oxcaml/oxcaml/pull/6407">#6407</a>).</li>
</ul>
<p>Together these remove a number of mode annotations and eta-expansions that were
previously quite verbose and also sometimes breaking existing OCaml code. A handy new
default warning also reports modalities that have no effect (<a href="https://github.com/oxcaml/oxcaml/pull/5532">#5532</a>).</p>
<pre><code class="language-ocaml">let first (p : (int * int) @ local) = fst p [@nontail]  (* a tail call is rejected *)
let pair x y = exclave_ stack_ (x, y)

let needs_portable (f : (unit -&gt; unit) @ portable) = ()
let h (f @ stateful) = needs_portable f     (* portability is inferred, not fixed *)

let g : int -&gt; int = fun x -&gt; x + 1
let g' = (g :&gt; int -&gt; int @ portable)       (* coercion mode-crosses the result *)

type r = { mutable n : int @@ global }      (* warning 220: redundant modality *)
</code></pre>
<h2><a href="https://anil.recoil.org/news.xml#effect-handlers" class="anchor" aria-hidden="true"></a>Effect handlers</h2>
<p>Effect handlers let a computation suspend itself and hand control to a
handler further up the stack, allowing direct-style concurrency libraries
such as <a href="https://github.com/ocaml-multicore/eio">Eio</a> to schedule lightweight fibers without resorting to monadic code.
The effect handlers in OxCaml expose a different interface to those I helped
<a href="https://anil.recoil.org/papers/2021-pldi-retroeff">engineer into OCaml 5</a>.</p>
<p>Previously, <code>Effect.perform</code> was the only way to perform an effect and was
mostly dynamically typed.
A second interface in OxCaml now threads a zero-size token
from the point where a handler is installed to each <code>perform</code>
(<a href="https://github.com/oxcaml/oxcaml/pull/6281">#6281</a>).</p>
<p>This helps with the JavaScript compilation (where, until the <a href="https://github.com/WebAssembly/stack-switching">wasm stack switching</a>
extension is more widely adopted, there is a regional CPS transform to turn effects
into JavaScript).
The old effect function still works but raises an alert.</p>
<p>There's also a new <code>Stdlib.Dynamic</code> (<a href="https://github.com/oxcaml/oxcaml/pull/6412">#6412</a>).
to allow fiber-local storage. A dynamic variable is bound for the
extent of a function call, and is inherited by child fibers, and is safe to read in
parallel.</p>
<pre><code class="language-ocaml">type _ Effect.t += Ask : int Effect.t

let body (h : Effect.Handler.t @ local) () = Effect.Safe.perform h Ask + 1

let answer =                                (* 42 *)
  Effect.Deep.Safe.try_with body ()
    { effc = fun (type a) (e : a Effect.t) -&gt;
        match e with
        | Ask -&gt; Some (fun (k : (a, _) Effect.Deep.continuation) -&gt;
                   Effect.Deep.continue k 41)
        | _ -&gt; None }

let depth : int Dynamic.t = Dynamic.make ()
let current () = match Dynamic.get depth with Null -&gt; 0 | This d -&gt; d
let nested () =                             (* 1; an unbound variable reads Null *)
  let r = Dynamic.with_temporarily depth 1 ~f:current in
  r
</code></pre>
<p>I haven't ported my local OxCaml Eio fork to the new functions yet, but it
looks reasonably straightforward.</p>
<h2><a href="https://anil.recoil.org/news.xml#foreign-function-interface" class="anchor" aria-hidden="true"></a>Foreign function interface</h2>
<p>One of the more complex areas to deal with in OxCaml is the C interface,
since the homogeneous value layouts are more flexible with modes.</p>
<ul>
<li>A C stub declared <code>external</code> could previously not satisfy a
<code>[@@zero_alloc]</code> signature. This now works
(<a href="https://github.com/oxcaml/oxcaml/pull/6651">#6651</a>), so allocation-free
interfaces no longer need a wrapper function around each stub!</li>
<li>Reading memory at a raw address now has compiler primitives to avoid Obj.magic
(<a href="https://github.com/oxcaml/oxcaml/pull/6350">#6350</a>).</li>
<li>C code that called back into OxCaml had no means of releasing stack
allocations made by that callback. They can now open and close a region
(<a href="https://github.com/oxcaml/oxcaml/pull/6142">#6142</a>), and can also donate
memory it has laid out as OCaml blocks to the major heap
(<a href="https://github.com/oxcaml/oxcaml/pull/6248">#6248</a>). This last feature
looks really useful for my DuckDB/Clickhouse bindings!</li>
</ul>
<pre><code class="language-ocaml">module Trunc : sig
  val to_int : float -&gt; int [@@zero_alloc]
end = struct
  external to_int : float -&gt; int = "caml_int_of_float" [@@noalloc]
end

external peek : ('a : any). int64_u @ local -&gt; 'a @ local
  = "%unsafe_get_ext_ptr" [@@layout_poly]
</code></pre>
<pre><code class="language-c">#ifdef OXCAML_RUNTIME
caml_region_t region = caml_region_begin();
value v = caml_callback(f, Val_unit);      /* may return a stack-allocated value */
intnat n = Long_val(Field(v, 0));
caml_region_end(region);                   /* frees the callback's stack allocations */
#endif
</code></pre>
<h2><a href="https://anil.recoil.org/news.xml#performance-and-optimisations" class="anchor" aria-hidden="true"></a>Performance and optimisations</h2>
<p>The GC performance seems to have generally
had a big boost due to elite Jane Street optimisation ninjas beavering away.</p>
<p>The garbage collector has much better pacing now. Previously, the major collector had no idle phase but
now after sweeping it waits until allocation passes a threshold before starting
again (<a href="https://github.com/oxcaml/oxcaml/pull/6484">#6484</a> and <a href="https://github.com/ocaml/ocaml/pull/14365">upstream</a>).
This reduces GC activity significantly in programs with small or steady-state heaps.
Pacing also accounts better for large off-heap data, which we encounter when mapping in large IO libraries in Bigarrays.</p>
<p>There seem to be tons of new optimisations like continuation lifting and specialisation that are now enabled
at <code>-O2</code>/<code>-O3</code> codegen. x86-64 output also looks better through conditional moves, and immediate and address folding.
For larger binaries, frametables are about 40% smaller (<a href="https://github.com/oxcaml/oxcaml/pull/6399">#6399</a>), and large links,
debug information and incremental rebuilds are faster. Things are generally snappier overall in my builds; fast compile
time is one of OCaml's best features and OxCaml is still pretty good even in release builds!</p>
<h2><a href="https://anil.recoil.org/news.xml#emerging-features" class="anchor" aria-hidden="true"></a>Emerging features</h2>
<p>The following need an extension flag or are documented as experimental, but
I couldn't resist taking a peek to see where the language is heading. I'm still
not using most of these things in my production binaries though.</p>
<h3><a href="https://anil.recoil.org/news.xml#layout-polymorphism" class="anchor" aria-hidden="true"></a>Layout polymorphism</h3>
<p>This is a huge quality-of-life feature to allow multiple representations without
resorting to ugly <code>ppx_template</code> extensions.  On 5.2.0+minus39, a <code>let poly_</code> binding type-checked, but
actually using it at an unboxed layout killed the compiler with an internal error.
Both now compile and run
(<a href="https://github.com/oxcaml/oxcaml/pull/5870">#5870</a>,
<a href="https://github.com/oxcaml/oxcaml/pull/6287">#6287</a>)!</p>
<pre><code class="language-ocaml">(* -extension layout_poly_alpha *)
let poly_ id x = x
let poly_ pair x y = #(x, y)

let demo () =
  let #(s, n) = pair "a" #1L in     (* string, int64_u *)
  #(s, id n, id #42.0)              (* id at bits64 and at float64 *)
</code></pre>
<h3><a href="https://anil.recoil.org/news.xml#mode-polymorphism" class="anchor" aria-hidden="true"></a>Mode polymorphism</h3>
<p>A let-bound function has so far had only one mode signature, and so different mode use needed two copies or a
(extremely ugly) ppx template. The good news is that inference can now generalise over modes
(<a href="https://github.com/oxcaml/oxcaml/pull/5483">#5483</a>) but the bad news is that there's no syntax yet!</p>
<pre><code class="language-ocaml">(* -extension mode_polymorphism_alpha *)
let id x = x                        (* 'a @ [&lt; 'm] -&gt; 'a @ [&gt; 'm] *)
let keep (r : int ref @ unique) : int ref @ unique = id r
let both (r : int ref) = (id r, id r)
(* without the extension [id] has one mode and [both] is rejected *)
</code></pre>
<h3><a href="https://anil.recoil.org/news.xml#preemption" class="anchor" aria-hidden="true"></a>Preemption</h3>
<p>5.2.0+minus39 had a fledgling <code>Preemption</code> effect, but no actual
handler interface for scheduling when a fiber should be forced to yield. A fiber run under a
preemptible handler in 5.4.0+ox9 now seems to receive that effect when its tick callback asks for
one
(<a href="https://github.com/oxcaml/oxcaml/pull/5913">#5913</a>).</p>
<p>This makes time-slicing of compute-bound fibers expressible in a user-level scheduler (in native
code only). It feels a little weird to have this feature after spending so many decades working in
cooperative-style threads, but I guess preemption has its place too!</p>
<pre><code class="language-ocaml">let preemptions = ref 0
let run work =
  Domain.Tick.with_ ~interval_usec:1000 (fun _ -&gt;
    Effect.Deep.Preemptible.match_with work ()
      { retc = Fun.id; exnc = raise;
        effc = (fun (type a) (e : a Effect.t) -&gt;
          match e with
          | Effect.Preemption -&gt;
            Some (fun (k : (a, _) Effect.Deep.continuation) -&gt;
              incr preemptions; Effect.Deep.continue k ())
          | _ -&gt; None);
        tickc = (fun () -&gt; Effect.Preempt) })
</code></pre>
<h3><a href="https://anil.recoil.org/news.xml#avx-512-operations" class="anchor" aria-hidden="true"></a>AVX 512 operations</h3>
<p>In the land of <a href="https://anil.recoil.org/projects/tessera">Tessera</a>, we really do make heavy use of as many
vector operations as we can get our mittens on, and <a href="https://www.tunbury.org/">Mark Elvers</a> has also
been heavily using <a href="https://www.tunbury.org/2026/10/05/week-40/#tessera-inference-on-endeavour">AMX</a> on
Intel's Endeavour cluster.</p>
<p>Excitingly, OxCaml has a 512-bit vector type now behind a beta flag, with
mask register types including load and store primitives, and also via C stub support
(<a href="https://github.com/oxcaml/oxcaml/pull/6293">#6293</a>). There don't seem to be any intrinsics
yet, so I'm not sure how to use these without going through C, but I guess that's why it's still beta!</p>
<pre><code class="language-ocaml">(* -extension simd_beta *)
type state = { lanes : int64x8#; live : mask#; name : string }
</code></pre>
<p>There have also been bugfixes as vector registers were not preserved across a stack check, resulting
in silent miscompilation of SIMD code that's now been fixed (<a href="https://github.com/oxcaml/oxcaml/pull/6334">#6334</a>).</p>
<h2><a href="https://anil.recoil.org/news.xml#should-you-use-oxcaml-yourself" class="anchor" aria-hidden="true"></a>Should you use OxCaml yourself?</h2>
<p>This is all very bleeding-edge stuff, so unless you're deep into OCaml or very willing
to deal with build issues, I'd wait a little while. If you really want to have a go, then
I recommend my <a href="https://github.com/avsm/ocaml-claude-marketplace">agent OxCaml skills</a> (<code>ocaml-dev/oxcaml</code>)
as they really do make navigating all the new extensions much much easier. You can also
track <a href="https://thicket.dev">Thicket</a> to track changes more regularly.</p>
<p>I'll document in the coming few weeks how my own OxCaml monorepo works. While upgrading
to this latest release, I also had to <a href="https://github.com/ocaml/odoc/pull/1520">port odoc</a>,
and lots of other compiler-specific tooling also needs more work due to the internals
changing rapidly. My monorepo also has extensive forks of existing ecosystem libraries with
their signatures altered to support the <code>portable</code> and <code>local</code> modes, as well as importing
in cool <a href="https://gazagnaire.org/blog/2026-11-02-console.html">new libraries</a> and adapting those
too.</p>
<p>None of these were particularly bad blockers, and the <a href="https://anil.recoil.org/notes/oxcaml-opam-guards">OxCaml guard packages</a> continue to do their job of keeping different
releases apart to avoid build failures from mixing and matching the wrong
ecosystems. The OxCaml compiler itself is rock solid, and the resulting
binaries are extremely fast (otherwise I wouldn't be putting all this effort
into it!). I'm very pleased overall with the output of OxCaml, and the emerging
mode/kind/layout polymorphism will hopefully result in the classic OCaml
ergonomics being restored in the early part of 2027.</p><h1>References</h1><ul><li>Madhavapeddy (2025). Holding an OxCaml tutorial at ICFP/SPLASH 2025. <a href="https://doi.org/10.59350/55bc5-x4p75" target="_blank"><i>10.59350/55bc5-x4p75</i></a></li>
<li>Madhavapeddy (2026). My (very) fast zero-allocation webserver using OxCaml. <a href="https://doi.org/10.59350/9c6bz-kb659" target="_blank"><i>10.59350/9c6bz-kb659</i></a></li>
<li>Sivaramakrishnan et al (2021). Retrofitting effect handlers onto OCaml. ACM. <a href="https://doi.org/10.1145/3453483.3454039" target="_blank"><i>10.1145/3453483.3454039</i></a></li>
<li>Madhavapeddy (2025). Arise Bushel, my sixth generation oxidised website. <a href="https://doi.org/10.59350/0r62w-c8g63" target="_blank"><i>10.59350/0r62w-c8g63</i></a></li>
<li>Lorenzen et al (2024). Oxidizing OCaml with Modal Memory Management. <a href="https://doi.org/10.1145/3674642" target="_blank"><i>10.1145/3674642</i></a></li></ul>
