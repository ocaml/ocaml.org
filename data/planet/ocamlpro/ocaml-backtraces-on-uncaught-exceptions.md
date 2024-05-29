---
title: OCaml Backtraces on Uncaught Exceptions
description: 'Uncaught exception: Not_found This blog post probably won''t teach anything
  new to OCaml veterans; but for the others, you might be glad to learn that this
  very basic, yet surprisingly little-known feature of OCaml will give you backtraces
  with source file positions on any uncaught exception. Since i...'
url: https://ocamlpro.com/blog/2024_04_25_ocaml_backtraces_on_uncaught_exceptions
date: 2024-04-25T12:44:14-00:00
preview_image: https://ocamlpro.com/assets/img/logo_ocp_icon.svg
authors:
- "\n    Louis Gesbert\n  "
source:
---

<p></p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/AIGEN_camel_catching_butterflies.jpeg">
      <img src="https://ocamlpro.com/blog/assets/img/AIGEN_camel_catching_butterflies.jpeg" alt="A mystical Camel using its net to catch all uncaught... Butterflies."/>
    </a>
    </p><div class="caption">
      A mystical Camel using its net to catch all uncaught... Butterflies.
    </div>
  
</div>

<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#notfound" class="anchor-link">Uncaught exception: Not_found</a>
          </h2>
<p>This blog post probably won't teach anything new to OCaml veterans; but for
the others, you might be glad to learn that this very basic, yet surprisingly
little-known feature of OCaml will give you backtraces with source file
positions on any uncaught exception.</p>
<p>Since it can save hours of frustrating debugging, my intent is to give some
publicity to this accidentally hidden feature.</p>
<blockquote>
<p>PSA: define <code>OCAMLRUNPARAM=b</code> in your environment.</p>
</blockquote>
<p>For those wanting to go further, I'll then go on with hints and guidelines for
good exception management in OCaml.</p>
<blockquote>
<p>For the details, everything here is documented in <a href="https://caml.inria.fr/pub/docs/manual-ocaml/libref/Printexc.html">the Printexc
module</a>.</p>
</blockquote>
<p></p><div>
<strong>Table of contents</strong>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#notfound">Uncaught exception: Not_found</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#getyourstacktraces">Get your stacktraces!</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#improve">Improve your traces</a>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#reraising">Properly Re-raising exceptions, and finalisers</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#holes">There are holes in my backtrace!</a>
</li>
</ul>
</li>
<li><a href="https://ocamlpro.com/blog/feed#guidelines">Guidelines for exception handling, and Control-C</a>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#backtracesinocaml">Controlling the backtraces from OCaml</a>

</li>
</ul>
</li>
</ul>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#getyourstacktraces" class="anchor-link">Get your stacktraces!</a>
          </h2>
<p>Compile-time errors are good, but sometimes you just have to cope with run-time
failures.</p>
<p>Here is a simple (and buggy) program:</p>
<pre><code class="language-ocaml">let dict = [
    &quot;foo&quot;, &quot;bar&quot;;
    &quot;foo2&quot;, &quot;bar2&quot;;
]

let rec replace = function
  | [] -&gt; []
  | w :: words -&gt; List.assoc w dict :: words

let () =
  let words = Array.to_list Sys.argv in
  List.iter print_endline (replace words)
</code></pre>
<blockquote>
<p><strong>Side note</strong></p>
<p>For purposes of the example, we use <code>List.assoc</code> here; this relies
on OCaml's structural equality, which is often a bad idea in projects, as it
can break in surprising ways when the matched type gets more complex. A more
serious implementation would use <em>e.g.</em> <code>Map.Make</code> with an explicit comparison
function.</p>
</blockquote>
<p>Here is the result of executing this program with no options:</p>
<pre><code class="language-shell-session">$ ./foo
Fatal error: exception Not_found
</code></pre>
<p>This isn't very helpful, but no need for a debugger, lots of <code>printf</code> or tedious
debugging, just do the following:</p>
<pre><code class="language-shell-session">$ export OCAMLRUNPARAM=b
$ ./foo
Fatal error: exception Not_found
Raised at Stdlib__List.assoc in file &quot;list.ml&quot;, line 191, characters 10-25
Called from Foo.replace in file &quot;foo.ml&quot;, line 8, characters 18-35
Called from Foo in file &quot;foo.ml&quot;, line 12, characters 26-41
</code></pre>
<p>Much more helpful! In most cases, this will be enough to find and fix the bug.</p>
<p>If you still don't get the backtrace, you may need to recompile with <code>-g</code> (with
dune, ensure your default profile is <code>dev</code> or specify <code>--profile=dev</code>)</p>
<p>So, now we know where the failure occured... But not on what input. This is
not a matter of backtraces: if that's an issue, define your own exceptions,
with arguments, and raise that rather than the basic <code>Not_found</code>.</p>
<blockquote>
<p><strong>Hint</strong></p>
<p>If you run the program directly from your editor, with a properly
configured OCaml mode, the file positions in the backtrace should be parsed
and become clickable, making navigation very quick and easy.</p>
</blockquote>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#improve" class="anchor-link">Improve your traces</a>
          </h2>
<p>The above works well in general, but depending on the complexity of the
programs, there are some more advanced tricks that may be helpful, to preserve
or improve the backtraces.</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#reraising" class="anchor-link">Properly Re-raising exceptions, and finalisers</a>
          </h3>
<p>It's pretty common to want a finaliser after some processing, here to remove a
temporary file:</p>
<pre><code class="language-ocaml">let with_temp_file basename (f: unit -&gt; 'a) : 'a =
  let filename = Filename.temp_file basename in
  match f filename with
  | result -&gt;
    Sys.remove filename;
    result
  | exception e -&gt;
    Sys.remove filename;
    raise e
</code></pre>
<p>In simple cases this will work, but if <em>e.g.</em> you are using the <code>Printf</code> module
before re-raising, it will break the printed backtrace.</p>
<ul>
<li>
<p><strong>Solution 1</strong>: use <code>Fun.protect ~finally f</code> that handles the backtrace
properly.</p>
</li>
<li>
<p><strong>Solution 2</strong>: manually, use raw backtrace access from the <code>Printexc</code> module:</p>
<pre><code class="language-ocaml">| exception e -&gt;
  let bt = Printexc.get_raw_backtrace () in
  Sys.remove filename;
  Printexc.raise_with_backtrace e bt
</code></pre>
</li>
</ul>
<p>Re-raising exceptions after catching them should always be done in this way.</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#holes" class="anchor-link">There are holes in my backtrace!</a>
          </h3>
<p>Indeed, it may appear that not all function calls show up in the backtrace.</p>
<p>There are two main reasons for that:</p>
<ul>
<li>functions can get inlined by the compiler, so they don't actually appear in
the concrete backtrace at runtime;
</li>
<li>tail-call optimisation also affects the stack, which can be visible here;
</li>
</ul>
<p>Don't run and disable all optimisations though! Some effort has been put in
recording useful debugging information even in these cases. The <a href="https://ocamlpro.com/blog/2024_03_18_the_flambda2_snippets_0/">Flambda pass
of the compiler</a>, which
does <strong>more</strong> inlining, also actually makes it <strong>more</strong> traceable.</p>
<p>As a consequence, switching to Flambda will often give you more helpful
backtraces with recursive functions and tail-calls. It can be done with <code>opam install ocaml-option-flambda</code> (this will recompile the whole opam switch).</p>
<blockquote>
<p><strong>Well, what if my program uses <code>lwt</code>?</strong></p>
<p>Backtraces in this context are a complex matter -- but they can be simulated:
a good practice is to use <code>ppx_lwt</code> and the <code>let%lwt</code> syntax rather than
<code>let*</code> or <code>Lwt.bind</code> directly, because the ppx will insert calls that
reconstruct &quot;fake&quot; backtrace information.</p>
</blockquote>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#guidelines" class="anchor-link">Guidelines for exception handling, and Control-C</a>
          </h2>
<p>Exceptions in OCaml can happen anywhere in the program: besides uses of <code>raise</code>,
system errors can trigger them. In particular, if you want to implement clean
termination on the user pressing <code>Control-C</code> without manually handling signals,
you should call <code>Sys.catch_break true</code> ; you will then get a <code>Sys.Break</code>
exception raised when the user interrupts the program.</p>
<p>Anyway, this is one reason why you must never use <code>try .. with _ -&gt;</code></p>
<pre><code class="language-ocaml">let find_opt x m =
  try Some (Map.find x m)
  with _ -&gt; None
</code></pre>
<p>The programmer was too lazy to write <code>with Not_found</code>. They may think this is OK
since <code>Map.find</code> won't raise anything else. But if <code>Control-C</code> is pressed at the
wrong time, this will catch it, and return <code>None</code> instead of stopping the
program !</p>
<pre><code class="language-ocaml">let find_debug x m =
  try Map.find x m
  with e -&gt;
    let bt = Printexc.get_raw_backtrace () in
    Printf.eprintf &quot;Error on %s!&quot; (to_string x);
    Printexc.raise_with_backtrace e bt
</code></pre>
<p>This version is OK since it re-raises the exception. If you absolutely need to
catch all exceptions, a last resort is to explicitely re-raise &quot;uncatchable&quot;
exceptions:</p>
<pre><code class="language-ocaml">let this_is_a_last_resort =
  try .. with
  | (Sys.Break | Assert_failure _ | Match_failure _) as e -&gt; raise e
  | _ -&gt; ..
</code></pre>
<p>In practice, you'll finally want to catch exceptions from your main function
(<code>cmdliner</code> already offers to do this, for example); catching <code>Sys.Break</code> at
that point will offer a better message than <code>Uncaught exception</code>, give you
control over finalisation and the final exit code (the convention is to use
<code>130</code> for <code>Sys.Break</code>).</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#backtracesinocaml" class="anchor-link">Controlling the backtraces from OCaml</a>
          </h3>
<p>Setting <code>OCAMLRUNPARAM=b</code> in the environment works from the outside, but the
module <a href="https://caml.inria.fr/pub/docs/manual-ocaml/libref/Printexc.html">Printexc</a>
can also be used to enable or disable them from the OCaml program itself.</p>
<ul>
<li><code>Printexc.record_backtrace: bool -&gt; unit</code> toggles the recording of
backtraces. Forcing it <code>off</code> when running tests, or <code>on</code> when a debug flag is
specified, can be good ideas;
</li>
<li><code>Printexc.backtrace_status: unit -&gt; bool</code> checks if recording is enabled.
This can be used when finalising the program to print the backtraces when
enabled;
</li>
</ul>
<blockquote>
<p><strong>Nota Bene</strong></p>
<p>The <code>base</code> library turns <code>on</code> backtraces recording by default. While I
salute an attempt to remedy the issue that this post aims to address, this can
lead to surprises when just linking the library can change the output of a
program (<em>e.g.</em> this might require specific code for cram tests not to display
backtraces)</p>
</blockquote>
<p>The <code>Printexc</code> module also allows to register custom exception printers: if,
following the advice above, you defined your own exceptions with parameters, use
<code>Printexc.register_printer</code> to have that information available when they are
uncaught.</p>
</div>
