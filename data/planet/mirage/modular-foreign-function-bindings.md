---
title: Modular foreign function bindings
description:
url: https://mirage.io/blog/modular-foreign-function-bindings
date: 2014-07-15T00:00:00-00:00
preview_image:
featured:
authors:
- Jeremy Yallop
---


        <p>One of the most frequent questions about MirageOS from developers is
&quot;do I really need to write all my code in OCaml&quot;?  There are, of
course, very good reasons to build the core system in pure OCaml: the
module system permits reusing algorithmic abstractions at scale, and
OCaml's static type checking makes it possible to enforce lightweight
invariants across interfaces.  However, it's ultimately necessary to
support interfacing to existing code, and this blog post will describe
what we're doing to make this possible this without sacrificing the
security benefits afforded by unikernels.</p>
<p>A MirageOS application works by abstracting the <em>logic</em> of the
application from the details of <em>platform</em> that it is compiled for.
The <code>mirage</code> CLI tool parses a configuration file that represents the
desired hardware target, which can be a Unix binary or a specialized
Xen guest OS.  Our foreign function interface design elaborates on
these design principles by separating the <em>description</em> of the C
foreign functions from how we <em>link</em> to that code.  For instance, a
Unix unikernel could use the normal <code>ld.so</code> to connect to a shared
library, while in Xen we would need to interface to that C library
through some other mechanism (for instance, a separate VM could be
spawned to run the untrusted OpenSSL code).  If you're curious about
how this works, this blog post is for you!</p>
<h3>Introducing ctypes</h3>
<p><a href="https://github.com/ocamllabs/ocaml-ctypes">ocaml-ctypes</a> (&quot;ctypes&quot; for short) is a library for
gluing together OCaml code and C code without writing any C.  This
post introduces the ctypes library with a couple of simple examples,
and outlines how OCaml's module system makes it possible to write
high-level bindings to C that are independent of any particular
linking mechanism.</p>
<h3>Hello, C</h3>
<p>Binding a C function using ctypes involves two steps.</p>
<ul>
<li>First, construct an OCaml value that represents the type of the function
</li>
<li>Second, use the type representation and the function name to resolve and bind the function
</li>
</ul>
<p>For example, here's a binding to C's <code>puts</code> function, which prints a string to
standard output and returns the number of characters written:</p>
<pre><code class="language-ocaml">let puts = foreign &quot;puts&quot; (string @-&gt; returning int)
</code></pre>
<p>After the call to <code>foreign</code> the bound function is available to OCaml
immediately.  Here's a call to <code>puts</code> from the interactive top level:</p>
<pre><code class="language-ocaml"># puts &quot;Hello, world&quot;;;
Hello, world
- : int = 13
</code></pre>
<h3>&lt;Hello-C/&gt;</h3>
<p>Now that we've had a taste of ctypes, let's look at a more realistic
example: a program that defines bindings to the <a href="http://www.libexpat.org/">expat</a> XML
parsing library, then uses them to display the structure of an XML
document.</p>
<p>We'll start by describing the types used by expat.  Since ctypes
represents C types as OCaml values, each of the types we need becomes
a value binding in our OCaml program.  The parser object involves an
incomplete (abstract) struct definition and a typedef for a pointer to
a struct:</p>
<pre><code class="language-C">struct xml_ParserStruct;
typedef xml_ParserStruct *xml_Parser;
</code></pre>
<p>In ctypes these become calls to the <code>structure</code> and <code>ptr</code> functions:</p>
<pre><code class="language-ocaml">let parser_struct : [`XML_ParserStruct] structure typ = structure &quot;xml_ParserStruct&quot;
let xml_Parser = ptr parser_struct
</code></pre>
<p>Next, we'll use the type representations to bind some functions.  The
<a href="http://www.xml.com/pub/a/1999/09/expat/reference.html#parsercreate"><code>XML_ParserCreate</code></a>
and
<a href="http://www.xml.com/pub/a/1999/09/expat/reference.html#parserfree"><code>XML_ParserFree</code></a>
functions construct and destroy parser objects.  As with <code>puts</code>, each
function binding involves a simple call to <code>foreign</code>:</p>
<pre><code class="language-ocaml">let parser_create = foreign &quot;XML_ParserCreate&quot;
  (ptr void @-&gt; returning xml_Parser)
let parser_free = foreign &quot;XML_ParserFree&quot;
  (xml_Parser @-&gt; returning void)
</code></pre>
<p>Expat operates primarily through callbacks: when start and end elements are
encountered the parser invokes user-registered functions, passing the tag names
and attributes (along with a piece of user data):</p>
<pre><code class="language-C">typedef void (*start_handler)(void *, char *, char **);
typedef void (*end_handler)(void *, char *);
</code></pre>
<p>In ctypes function pointer types are built using the <code>funptr</code> function:</p>
<pre><code class="language-ocaml">let start_handler =
  funptr (ptr void @-&gt; string @-&gt; ptr string @-&gt; returning void)
let end_handler =
  funptr (ptr void @-&gt; string @-&gt; returning void)
</code></pre>
<p>We can use the <code>start_handler</code> and <code>end_handler</code> type representations to bind
<a href="http://www.xml.com/pub/a/1999/09/expat/reference.html#elementhandler"><code>XML_SetElementHandler</code></a>, the callback-registration function:</p>
<pre><code class="language-ocaml">let set_element_handler = foreign &quot;XML_SetElementHandler&quot;
  (xml_Parser @-&gt; start_handler @-&gt; end_handler @-&gt; returning void)
</code></pre>
<p>The type that OCaml infers for <code>set_element_handler</code> reveals that the function
accepts regular OCaml functions as arguments, since the argument types are
normal OCaml function types:</p>
<pre><code class="language-ocaml">val set_element_handler :
  [ `XML_ParserStruct ] structure ptr -&gt;
  (unit ptr -&gt; string -&gt; string ptr -&gt; unit) -&gt;
  (unit ptr -&gt; string -&gt; unit) -&gt; unit
</code></pre>
<p>There's one remaining function to bind, then we're ready to use the
library.  The
<a href="http://www.xml.com/pub/a/1999/09/expat/reference.html#parse"><code>XML_Parse</code></a>
function performs the actual parsing, invoking the callbacks when tags
are encountered:</p>
<pre><code class="language-ocaml">let parse = foreign &quot;XML_Parse&quot;
  (xml_Parser @-&gt; string @-&gt; int @-&gt; int @-&gt; returning int)
</code></pre>
<p>As before, all the functions that we've bound are available for use
immediately.  We'll start by using them to define a more idiomatic OCaml entry
point to the library.  The <code>parse_string</code> function accepts the start and end
callbacks as labelled arguments, along with a string to parse:</p>
<pre><code class="language-ocaml">let parse_string ~start_handler ~end_handler s =
  let p = parser_create null in
  let () = set_element_handler p start_handler end_handler in
  let _ = parse p s (String.length s) 1 in
  parser_free p
</code></pre>
<p>Using <code>parse_string</code> we can write a program that prints out the names of each
element in an XML document, indented according to nesting depth:</p>
<pre><code class="language-ocaml">let depth = ref 0

let start_handler _ name _ =
  Printf.printf &quot;%*s%s\\n&quot; (!depth * 3) &quot;&quot; name;
  incr depth

let end_handler _ _ =
  decr depth

let () =
  parse_string ~start_handler ~end_handler (In_channel.input_all stdin)
</code></pre>
<p>The full source of the program is <a href="https://github.com/yallop/ocaml-ctypes-expat-example">available on github</a>.</p>
<p>Here's the program in action:</p>
<pre><code class="language-bash">$ ocamlfind opt -thread -package core,ctypes.foreign expat_example.ml \\
   -linkpkg -cclib -lexpat -o expat_example
$ wget -q https://mirage.io/blog/atom.xml -O /dev/stdout \\
  | ./expat_example
feed
   id
   title
   subtitle
   rights
   updated
   link
   link
   contributor
      email
      uri
      name
[...]
</code></pre>
<p>Since this is just a high-level overview we've passed over a number of
details.  The interested reader can find a more comprehensive introduction to
using ctypes in <a href="https://realworldocaml.org/v1/en/html/foreign-function-interface.html">Chapter 19: Foreign Function Interface</a> of <a href="https://realworldocaml.org">Real World OCaml</a>.</p>
<h3>Dynamic vs static</h3>
<p>Up to this point we've been using a single function, <code>foreign</code>, to
make C functions available to OCaml.  Although <code>foreign</code> is simple to
use, there's quite a lot going on behind the scenes.  The two
arguments to <code>foreign</code> are used to dynamically construct an OCaml
function value that wraps the C function: the name is used to resolve
the code for the C function, and the type representation is used to
construct a call frame appropriate to the C types invovled and to the
underlying platform.</p>
<p>The dynamic nature of <code>foreign</code> that makes it convenient for
interactive use, also makes it unsuitable for some environments.
There are three main drawbacks:</p>
<ul>
<li>
<p>Binding functions dynamically involves a certain loss of <em>safety</em>:
since C libraries typically don't maintain information about the
types of the functions they contain, there's no way to check whether
the type representation passed to <code>foreign</code> matches the actual type of
the C function.</p>
</li>
<li>
<p>Dynamically constructing calls introduces a certain <em>interpretative
overhead</em>.  In mitigation, this overhead is much less than might be supposed,
since much of the work can be done when the function is bound rather than
when the call is made, and <code>foreign</code> has been used to bind C functions in
<a href="http://erratique.ch/software/tgls">performance-sensitive applications</a> without problems.</p>
</li>
<li>
<p>The implementation of <code>foreign</code> uses a low-level library, <a href="https://sourceware.org/libffi/">libffi</a>,
to deal with calling conventions across platforms.  While libffi is mature
and widely supported, it's not appropriate for use in every environment.
For example, introducing such a (relatively) large and complex library into
Mirage would compromise many of the benefits of writing the rest of the
system in OCaml.</p>
</li>
</ul>
<p>Happily, there's a solution at hand.  As the introduction hints, <code>foreign</code> is
one of a number of binding strategies, and OCaml's module system makes it easy
to defer the choice of which strategy to use when writing the actual code.
Placing the <code>expat</code> bindings in a functor (parameterised module) makes it
possible to abstract over the linking strategy:</p>
<pre><code class="language-ocaml">module Bindings(F : FOREIGN) =
struct
  let parser_create = F.foreign &quot;XML_ParserCreate&quot;
    (ptr void @-&gt; returning xml_Parser)
  let parser_free = F.foreign &quot;XML_ParserFree&quot;
    (xml_Parser @-&gt; returning void)
  let set_element_handler = F.foreign &quot;XML_SetElementHandler&quot;
    (xml_Parser @-&gt; start_handler @-&gt; end_handler @-&gt; returning void)
  let parse = F.foreign &quot;XML_Parse&quot;
    (xml_Parser @-&gt; string @-&gt; int @-&gt; int @-&gt; returning int)
end
</code></pre>
<p>The <code>Bindings</code> module accepts a single parameter of type <code>FOREIGN</code>, which
encodes the binding strategy to use.  Instantiating <code>Bindings</code> with a module
containing the <code>foreign</code> function used above recovers the
dynamically-constructed bindings that we've been using so far.  However, there
are now other possibilities available.  In particular, we can instantiate
<code>Bindings</code> with code generators that output code to expose the bound functions
to OCaml.  The actual instantiation is hidden behind a couple of convenient
functions, <code>write_c</code> and <code>write_ml</code>, which accept <code>Bindings</code> as a parameter
and write to a <a href="http://caml.inria.fr/pub/docs/manual-ocaml/libref/Format.html#TYPEformatter">formatter</a>:</p>
<pre><code class="language-ocaml">Cstubs.write_c formatter ~prefix:&quot;expat&quot; ~bindings:(module Bindings)
Cstubs.write_ml formatter ~prefix:&quot;expat&quot; ~bindings:(module Bindings)
</code></pre>
<p>Generating code in this way eliminates the concerns associated with
constructing calls dynamically:</p>
<ul>
<li>
<p>The C compiler checks the types of the generated calls against the C
headers (the API), so the safety concerns associated with linking
directly against the C library binaries (the ABI) don't apply.</p>
</li>
<li>
<p>There's no interpretative overhead, since the generated code is
(statically) compiled.</p>
</li>
<li>
<p>The dependency on libffi disappears altogether.</p>
</li>
</ul>
<p>How easy is it in practice to switch between dynamic and static
binding strategies?  It turns out that it's quite straightforward,
even for code that was originally written without parameterisation.
Bindings written using early releases of ctypes used the dynamic
strategy exclusively, since dynamic binding was then the only option
available.  The commit logs for projects that switched over to static
generation and linking (e.g. <a href="https://github.com/whitequark/ocaml-lz4/commit/acc257ea1">ocaml-lz4</a> and
<a href="https://github.com/janestreet/async_ssl/commit/ab5ea6f55e">async-ssl</a>) when it became available show that
moving to the new approach involved only straightforward and localised
changes.</p>
<h3>Local vs remote</h3>
<p>Generating code is safer than constructing calls dynamically, since it
allows the C compiler to check the types of function calls against
declarations.  However, there are some safety problems that even C's
type checking doesn't detect.  For instance, the following call is
type correct (given suitable definitions of <code>p</code> and <code>q</code>), but is
likely to misbehave at run time:</p>
<pre><code class="language-C">memcpy(p, q, SIZE_MAX)
</code></pre>
<p>In contrast, code written purely in OCaml detects and prevents
attempts to write beyond the bounds of allocated objects:</p>
<pre><code class="language-ocaml"># StringLabels.blit ~src ~dst ~src_pos:0 ~dst_pos:0 ~len:max_int;;
Exception: Invalid_argument &quot;String.blit&quot;.
</code></pre>
<p>It seems a shame to weaken OCaml's safety guarantees by linking in C
code that can potentially write to any region of memory, but what is
the alternative?</p>
<p>One possibility is to use <a href="http://en.wikipedia.org/wiki/Privilege_separation">privilege separation</a> to separate
trusted OCaml code from untrusted C functions.  The modular design of
ctypes means that privilege separation can be treated as one more
linking strategy: we can run C code in an entirely separate process
(or for Mirage/Xen, in a separate virtual machine), and instantiate
<code>Bindings</code> with a strategy that forwards calls to the process using
standard inter-process communication.  The remote calling strategy is
not supported in the <a href="https://github.com/ocamllabs/ocaml-ctypes/releases/tag/0.3.2">current release</a> of ctypes, but
it's scheduled for a future version.  As with the switch from dynamic
to static bindings, we anticipate that updating existing bindings to
use cross-process calls will be straightforward.</p>
<p>This introductory post should give you a sense of the power of the unikernel
approach in Mirage.  By turning the FFI into just another library (for the C
interface description) and protocol (for the linkage model), we can use code
generation to map application logic onto the privilege model most suitable for
the target hardware platform.  This starts with Unix processes, continues onto Xen
paravirtualization, and could even extend into <a href="http://www.cl.cam.ac.uk/research/security/ctsrd/cheri/">CHERI</a> fine-grained
compartmentalization.</p>
<h3>Further examples</h3>
<p>Although ctypes is a fairly new library, it's already in use in a
number of projects across a variety of domains: <a href="http://erratique.ch/software/tgls">graphics</a>,
<a href="http://erratique.ch/software/tsdl">multimedia</a>, <a href="https://github.com/whitequark/ocaml-lz4">compression</a>, <a href="https://github.com/dsheets/ocaml-sodium">cryptography</a>,
<a href="https://github.com/nojb/ocaml-gsasl">security</a>, <a href="https://github.com/hcarty/ocaml-gdal">geospatial data</a>, <a href="http://github.com/rgrinberg/onanomsg">communication</a>,
and many others.  Further resources (documentation, forums, etc.) are
available via the <a href="https://github.com/ocamllabs/ocaml-ctypes">home page</a>.</p>

      
