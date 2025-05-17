---
title: Camel Spotting in Paris
description: Report from the 2011 OCaml Users Meeting in Paris, covering talks on
  js_of_ocaml, OCaml on PIC, and more.
url: https://anil.recoil.org/notes/ocaml-users-group
date: 2011-04-15T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p>I'm at the <a href="https://forge.ocamlcore.org/plugins/mediawiki/wiki/ocaml-meeting/index.php/OCamlMeeting2011">2011 OCaml Users Group</a> in Paris, reporting on some splendid talks this year. It looked like around 60-70 people in the room, and I had the pleasure of meeting users all the way from <a href="http://ru.linkedin.com/pub/dmitry-bely/4/955/717">Russia</a> to <a href="http://ashishagarwal.org/about/">New York</a> as well as all the Europeans!</p>
<h3>Js_of_ocaml</h3>
<p>First up was <a href="http://www.lsv.ens-cachan.fr/~chambart/">Pierre Chambart</a> talking about the <a href="http://ocsigen.org/js_of_ocaml/">js_of_ocaml</a> compiler. It compiles OCaml bytecode directly to Javascript, with few external dependencies. Since the bytecode format changes very rarely, it is simpler to maintain than alternatives (such as Jake Donham’s <a href="https://github.com/jaked/ocamljs">ocamljs</a>) that require patching the compiler tool-chain. Javascript objects are mapped to dynamic OCaml objects via a light-weight <code>##</code> operator, so you can simply write code like:</p>
<pre><code>  class type window = object
      method alert : js_string t -&gt; unit meth
      method name : js_string t prop
    end
    let window : window t =
      JS.Unsafe.variable "window"
    
    let () = 
      window##alert ( window##name)
      name &lt;- Js.string "name"
</code></pre>
<p>Overloading is handled similarly to <a href="http://pyobjc.sourceforge.net/">PyObjC</a>, with each parameter combination being mapped into a uniquely named function. <a href="https://github.com/raphael-proust">Raphael Proust</a> then demonstrated a cool game he wrote using via <a href="https://github.com/raphael-proust/raphael">bindings</a> to the <a href="http://raphaeljs.com/">Raphael</a> Javascript vector graphics library. Performance of <code>js_of_ocaml</code> is good compared to writing it by hand, and they have have quite a few <a href="http://ocsigen.org/js_of_ocaml/doc/1.0.2/manual/performances">benchmarks</a> on their website.</p>
<p>Overall the project looks very usable: the main omissions are Bigarray, no dynlink, no Str (replaced by native regexps), no recursive modules or weak references. None of these missing features seem very critical for the sorts of applications that <code>js_of_ocaml</code> is intended for.</p>
<h3>OCaml on a PIC (OCAPIC)</h3>
<p>Next up Phillipe Wang presented something completely different: <a href="http://www.algo-prog.info/ocaml_for_pic/web/index.php">running OCaml on tiny 8-bit PIC microcontrollers</a>!  These PICs have 4-128Kb of flash (to store the code), and from 256 <em>bytes</em> to 4 kilobytes. Not a lot of room to waste there. He demonstrated an example with a game with 24 physical push buttons that beat humans at a conference (JFLA).</p>
<p>It works by translating OCaml bytecode through several stages: <code>ocamlclean</code> to eliminate dead code in the bytecode (which would be very useful for native code too!), a compression step that does run-length encoding, and then translation to PIC assembly. They have a replacement stop-and-copy GC (150 lines of assembly) and a full collection cycle runs in less than 1.5ms. Integers are 15-bits (with 1 bit reserved) and the block representation is the same as native OCaml. Very cool project!</p>
<h3>Frama-C</h3>
<p>We went onto static analysis and <a href="http://www.linkedin.com/pub/julien-signoles/24/5a9/4b4">Julien Signoles</a> presented <a href="http://frama-c.com/">Frama-C</a>, a powerful static analysis tool for real-world C. It forks the <a href="http://www.eecs.berkeley.edu/~necula/cil/">CIL</a> project from Berkeley and adds <a href="http://ocamlgraph.lri.fr/">ocamlgraph</a> and GUI support. He demonstrated a simple loop counter plugin to count them in C code, and the homepage has many interesting <a href="http://frama-c.com/plugins.html">plugins</a> maintained by the community.</p>
<p>I hadn’t realised that CIL was still maintained in the face of <a href="http://clang.llvm.org/">clang</a>, so it’s nice to see it live on as part of Frama-C.</p>
<h3>Ocsigen</h3>
<p>The ever-cheerful <a href="http://www.pps.jussieu.fr/~balat/">Vincent Balat</a> updated us about the <a href="http://ocsigen.org">Ocsigen</a> web framework, including unveiling their exciting new logo! This was written using an amazing <a href="http://ocsigen.org/tutorial/tutorial1">collaborative editor</a> that lets users edit in real time.</p>
<p>Ocsigen is based around <em>services</em> of type <code>service: parameters -&gt; page</code>. Services are first-class values, and can be registered dynamically and associated with sessions. The code for the collaborative editor was about 100 lines of code.</p>
<p>There is a syntax extension to distinguish between client and server side code, and both can be written in the same service (invoking <code>js_of_ocaml</code> to compile the client code to Javascript). They have bindings to <a href="http://code.google.com/closure/">Google Closure</a> in order to provide UI support. There is a really nice “bus” service to pass messages between the server and the client, with seamless integration of <a href="http://ocsigen.org/lwt">Lwt</a> to hide the details of communication to the browser.</p>
<p>Ocsigen is looking like a very mature project at this point, and I’m very keen to integrate it with <a href="http://www.openmirage.org">Mirage</a> to specialise the into micro-kernels. A task for the hacking day tomorrow morning I think!</p>
<h3>Mirage</h3>
<p>I talked about <a href="http://www.openmirage.org">Mirage</a>, hurrah! Good questions about why we need a block device (and not just use NFS), and I replied that everything is available as the library and the programmer can choose depending on their needs (the core goal of <a href="http://en.wikipedia.org/wiki/Exokernel">exokernels</a>).</p>
<p>A highlight for me was lunch where I finally met <a href="http://people.redhat.com/~rjones/">Richard Jones</a>, who is one of the other OCaml and cloud hackers out there. Wide ranging conversation about what the cool stuff going in <a href="http://www.linux-kvm.org/page/Main_Page">KVM</a> and Red Hat in general. Richard also gave a short talk about how they use OCaml to generate hundreds of thousands of lines of code in <a href="http://libguestfs.org/">libguestfs</a>. There are bindings for pretty much every major language, and it is all generated from an executable specification. He notes that “normal” programmers love the OCaml type safety without explicit annotations, and that it is a really practical language for the working programmer. The <a href="http://xen.org">Xen Cloud Platform</a> also has a similar <a href="https://github.com/xen-org/xen-api/blob/master/ocaml/idl/datamodel.ml">generator</a> for XenAPI bindings, so I definitely agree with him about this!</p>
<h3>OCaml Future</h3>
<p><a href="http://pauillac.inria.fr/~xleroy/">Xavier “superstar” Leroy</a> then gave an update of OCaml development. Major new features in 3.12.0 are first-class modules, polymorphic recursion, local module opens, and richer operations over module signatures. Version 3.12.1 is coming out soon, with bug fixes (in camlp4 and ocamlbuild mainly), and better performance on x86_64: turns out a new <code>mov</code> instruction change improves floating point performance on <code>x86_64</code>.</p>
<p>OCaml 3.13 has no release date, but several exciting features are in the pipeline. Firstly, more lightweight first-class modules by permitting some annotations to be inferred by the context, and it introduces patterns to match and bind first-class module values. Much more exciting is support for GADTs (Generalised Algebraic Data Types). This permits more type constraints to be enforced at compile time:</p>
<pre><code>  type _ t =
      | IntLit : int -&gt; int t
      | Pair : 'a t * 'b t -&gt; ('a * 'b) t
      | App : ('a -&gt; 'b) t * 'a t -&gt; 'b t
      | Abs : ('a -&gt; 'b) -&gt; ('a -&gt; 'b) t
     
    let rec eval : type s . s t -&gt; s = function
      | IntLit x -&gt; x (* s = int here *)
      | Pair (x,y) -&gt; (eval x, eval y) (* s = 'a * 'b here *)
      | App (f,a) -&gt; (eval f) (eval a)
      | Abs f -&gt; f
</code></pre>
<p>In this example of a typed interpreter, the <code>eval</code> function is annotated with a <code>type s . s t -&gt; s</code> type that lets each branch of the pattern match have a constrained type for <code>s</code> depending on the use. This reminded me of Edwin Brady’s <a href="http://www.cs.st-andrews.ac.uk/~eb/writings/icfp10.pdf">partial evaluation</a> work using dependent types, but a much more restricted version suitable for OCaml.</p>
<p>There are some really interesting uses for GADTs:</p>
<ul>
<li>Enforcing invariants in data structures, as with the typed interpreter example above.</li>
<li>Reflecting types into values means that libraries such as our own <a href="http://github.com/mirage/dyntype">dyntype</a> can be expressed in the core language without lots of camlp4 hacks. Finally, this should make typed I/O generators for XML, JSON and other network formats much simpler.</li>
</ul>
<p>The challenges in the implementation are that principle type inference is now impossible (so some annotation is required), and pattern matching warnings are also trickier.</p>
<p>From the IDE perspective, the third bit of work is to have the OCaml compiler save the full abstract syntax tree annotation with source locations, scoping information, types (declared and inferred) and addition user-defined annotations. This generalises the <code>-annot</code> flag and can help projects like <a href="http://jun.furuse.info/hacks/ocamlspotter">OCamlSpotter</a>, <a href="http://ocamlwizard.lri.fr/">OCamlWizard</a>, <a href="http://www.algo-prog.info/ocaide/">OcaIDE</a>, etc. It also helps code-generators driven by type-generators (such as our <a href="http://github.com/mirage/orm">SQL ORM</a> or <a href="http://oss.wink.com/atdgen/">ATDgen</a>).</p>
<p>The OCaml consortium has new members; <a href="http://mlstate.com">MLState</a> and <a href="http://mylife.com">MyLife</a>, and <a href="http://www.esterel-technologies.com/">Esterel</a>, <a href="http://www.ocamlpro.com">OCamlPro</a> and one unnamed new member are joining. The consortium goals are to sell permissive licensing (BSD) to members, and sound off new features with the serious users. Three companies are now doing commercial development (Gerd, OCamlCore, OCamlPro) which is growing the community nicely.</p>
<h3>JoCaml</h3>
<p><a href="http://pauillac.inria.fr/~maranget/">Luc Maranget</a> (who looks like an archetypal mad professor!) gave a great rundown on <a href="http://jocaml.inria.fr/">JoCaml</a>, a distributed programming extension to OCaml. This extends the compiler with join-definitions (a compiler patch), and a small bit of runtime support (using Thread), and significant extensions for concurrent and distributed programming in a type-safe way.</p>
<p>It extends the syntax with three new keywords: <code>def</code>, <code>spawn</code> and <code>reply</code>, and new usage for <code>or</code> and <code>&amp;</code> (you should be using <code>||</code> and <code>&amp;&amp;</code> anyway). Binary libraries remain compatible between matching versions of JoCaml and OCaml. An example of JoCaml code is:</p>
<pre><code>  let create n =
      def st(rem) &amp; tick() = st(rem-1)
      or st(0) &amp; wait() = reply to wait in
      spawn st(n) ; { tick=tick; wait=wait; }
    
    type t = {
      tick: unit Join.chan;
      wait: unit -&gt; unit;
    }
</code></pre>
<p>After <code>n</code> messages to <code>tick</code>, the <code>wait</code> barrier function will be called.</p>
<pre><code>  let c = create n
    let () =
      for k = 0 to 9 do
       spawn begin printf "%i" k; c.tick ()
      done;
      c.wait ()
</code></pre>
<p>Here we asynchronously print the numbers of <code>0</code> to <code>9</code>, and then the <code>wait</code> call acts as a barrier until it finishes. JoCaml is useful for distributed fork-join parallelism tasks such as raytracing, but with the type system support of OCaml. It is a bit like MapReduce, but without the data partitioning support of Hadoop (and is more light-weight). It would be quite interesting to combine some of the JoCaml extensions with the dynamic dataflow graphs in our own <a href="http://www.cl.cam.ac.uk/research/srg/netos/ciel/">CIEL</a> distributed execution engine.</p>
<h3>Forgetful Memoisation in OCaml</h3>
<p><a href="http://www.lri.fr/~bobot/">Francois Bobot</a> talks about the problem of memoizing values so that they can be re-used (e.g. in a cache). Consider a standard memoiser:</p>
<pre><code>  let memo_f =
      let cache = H.create () in
      fun k -&gt;
        try H.find cache k
        with Not_found -&gt;
          let v = f k in
          H.add cache k v;
          v
    
    let v1 = memo_f k1
    let v2 = memo_f k2 in (* k2 = k1 in O(1) *)
</code></pre>
<p>If a key is not reachable from anywhere other than the heap, we want to eliminate it from the cache also. The first solution is a normal hashtable, but this results in an obvious memory leak since a key held in the cache marks it as reachable. A better solution is using OCaml <a href="http://caml.inria.fr/pub/docs/manual-ocaml/libref/Weak.html">weak pointers</a> that permit references to values without holding on to them (see <a href="http://www.pps.jussieu.fr/~li/software/weaktbl/doc/html/Weaktbl.html">Weaktbl</a> by <a href="http://www.pps.jussieu.fr/~li/">Zheng Li</a> who is now an OCaml hacker at Citrix). The problem with Weaktbl is that if the value points to the key, forming a cycle which will never be reclaimed.</p>
<p>Francois solves this by using <a href="http://en.wikipedia.org/wiki/Ephemeron">Ephemerons</a> from Smalltalk.  They use the rule that the value can be reclaimed if the key or the ephemeron itself can be reclaimed by the GC, and have a signature like:</p>
<pre><code>  module Ephemeron : sig type ('a,'b) t
      val create : 'a -&gt; 'b -&gt; ('a,'b) t
      val check : ('a,'b) t -&gt; bool
      val get : ('a,'b) t -&gt; 'b option
      val get_key : ('a,'b) t -&gt; 'a option
    end
</code></pre>
<p>The implementation in OCaml patches the runtime to use a new tag for ephemerons, and the performance graphs in his <a href="https://forge.ocamlcore.org/docman/view.php/77/134/memoization2011.pdf">slides</a> look good. This is an interesting topic for me since we need efficient memoisation in Mirage I/O (see the effects on DNS performance in the <a href="https://anil.recoil.org/papers/2007-eurosys-melange.pdf">Eurosys paper</a> which used Weaktbl). When asked if the OCaml patch will be upstreamed, <a href="http://gallium.inria.fr/~doligez/">Damien Doligez</a> did not like the worst-case complexity of long chains of ephemerons in the GC, and there are several approaches under consideration to alleviate this without too many changes to the runtime, but Francois believes the current complexity is not too bad in practise.</p>
<h3>Oasis and website</h3>
<p><a href="http://sylvain.le-gall.net/">Sylvain</a> came on stage later to give a demonstration of <a href="http://oasis.forge.ocamlcore.org/oasis-db.html">OASIS</a>, an equivalent of <a href="http://www.haskell.org/cabal/">Cabal</a> for Haskell or <a href="http://www.cpan.org/">CPAN</a> for Perl. It works with a small <code>_oasis</code> file that describes the project, and then the OASIS tool auto-generates <code>ocamlbuild</code> files from it (this reminds me of Perl’s <a href="http://perldoc.perl.org/ExtUtils/MakeMaker.html">MakeMaker</a>). Once the files are auto-generated, it is self-contained and there is no further dependency on OASIS itself.</p>
<ul>
<li>Gallery
<figure class="image-right"><img src="https://anil.recoil.org/images/ocaml-users-1.webp" loading="lazy" class="content-image" alt="How many OCaml hackers does it take to change a lightbulb?" srcset="/images/ocaml-users-1.320.webp 320w,/images/ocaml-users-1.480.webp 480w,/images/ocaml-users-1.640.webp 640w" title="How many OCaml hackers does it take to change a lightbulb?" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>How many OCaml hackers does it take to change a lightbulb?</figcaption></figure>

<figure class="image-right"><img src="https://anil.recoil.org/images/ocaml-users-3.webp" loading="lazy" class="content-image" alt="Wearing bibs at French Teppinyaki" srcset="/images/ocaml-users-3.320.webp 320w,/images/ocaml-users-3.480.webp 480w,/images/ocaml-users-3.640.webp 640w" title="Wearing bibs at French Teppinyaki" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>Wearing bibs at French Teppinyaki</figcaption></figure>

<figure class="image-right"><img src="https://anil.recoil.org/images/ocaml-users-2.webp" loading="lazy" class="content-image" alt="Team Mirage cheeses it up" srcset="/images/ocaml-users-2.320.webp 320w,/images/ocaml-users-2.480.webp 480w,/images/ocaml-users-2.640.webp 640w" title="Team Mirage cheeses it up" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>Team Mirage cheeses it up</figcaption></figure>
</li>
</ul>
<p>OASIS works with either an existing build system in a project, or can be integrated more closely with <code>ocamlbuild</code> by advanced users. Lots of projects are already using OASIS (from Cryptokit to Lwt to the huge <a href="http://caml.inria.fr/cgi-bin/hump.en.cgi?contrib=641">Jane Street Core</a>). He is also working on a distribution mechanism on a central website, which should make for convenient OCaml packaging when it is finished and gets more adoption from the community.</p>
<p>Finally, <a href="http://ashishagarwal.org/">Ashish Agarwal</a> led a discussion on how OCaml can improve its web presence for beginners. Lots of good ideas here (some of which we implemented when reworking the <a href="http://cufp.org">CUFP</a> website last year). Looking forward to seeing what happens next year in this space! I really enjoyed the day; the quality of talks was very high, and many engaging discussions from all involved!</p>
<p></p><figure class="image-center"><img src="https://anil.recoil.org/images/sf-ocaml.webp" loading="lazy" class="content-image" alt="" srcset="/images/sf-ocaml.320.webp 320w,/images/sf-ocaml.480.webp 480w,/images/sf-ocaml.640.webp 640w" title="" sizes="(max-width: 768px) 100vw, 33vw"><figcaption></figcaption></figure>
<p></p>
<p>Of course, not all of the OCaml community action is in France. The ever-social <a href="http://www.twitter.com/jakedonham">Jake Donham</a> organised the First Ever San Francisco User Group that I attended when I was over there a few weeks ago. Ok, admittedly it was mainly French people there too, but it was excellent to meet up with <a href="http://www.linkedin.com/pub/mika-illouz/0/a02/7b4">Mika</a>, <a href="http://martin.jambon.free.fr/">Martin</a>, <a href="http://www.linkedin.com/pub/julien-verlaguet/20/10a/b57">Julien</a>, <a href="http://fr.linkedin.com/in/henribinsztok">Henri</a> and of course Jake when over there.</p>
<p>We should definitely have more of these fun local meetups, and a number of other OCaml hackers I mentioned it to want to attend next time in the Bay Area, if only to cry into their drinks about the state of multi-core... <em>just kidding</em>, <a href="http://www.ocamlpro.com">OCamlPro</a> is hard at work fixing that after all :-)</p>

