---
title: Introducing Functoria
description:
url: https://mirage.io/blog/introducing-functoria
date: 2016-02-29T00:00:00-00:00
preview_image:
featured:
authors:
- Gabriel Radanne
---


        <p>For the last few months, I've been working with <a href="http://www.gazagnaire.org">Thomas</a> on improving the <code>mirage</code> tool and
I'm happy to present <a href="https://github.com/mirage/functoria">Functoria</a>, a library to create arbitrary MirageOS-like DSLs. Functoria is independent from <code>mirage</code> and will replace the core engine, which was somewhat bolted on to the tool until now.</p>
<p>This introduces a few breaking changes so please consult
<a href="https://mirage.io/docs/breaking-changes">the breaking changes page</a> to see what is different and how to fix things if needed.
The good news is that it will be much more simple to use, much more flexible,
and will even produce pretty pictures!</p>
<h2>Configuration</h2>
<p>For people unfamiliar with MirageOS, the <code>mirage</code> tool handles configuration of mirage unikernels by reading an OCaml file describing the various pieces and dependencies of the project.
Based on this configuration it will use <a href="http://opam.ocaml.org/">opam</a> to install the dependencies, handle various configuration tasks and emit a build script.</p>
<p>A very simple configuration file looks like this:</p>
<pre><code class="language-ocaml">open Mirage
let main = foreign &quot;Unikernel.Main&quot; (console @-&gt; job)
let () = register &quot;console&quot; [main $ default_console]
</code></pre>
<p>It declares a new functor, <code>Unikernel.Main</code>, which take a console as an argument and instantiates it on the <code>default_console</code>. For more details about unikernel configuration, please read the <a href="https://mirage.io/wiki/hello-world">hello-world</a> tutorial.</p>
<h2>Keys</h2>
<p>A <a href="https://github.com/mirage/mirage/issues/229">much</a> <a href="https://github.com/mirage/mirage/issues/228">demanded</a> <a href="https://github.com/mirage/mirage/issues/231">feature</a> has been the ability to define so-called bootvars.
Bootvars are variables whose value is set either at configure time or at
startup time.</p>
<p>A good example of a bootvar would be the IP address of the HTTP stack. For example, you may wish to:</p>
<ul>
<li>Set a good default directly in the <code>config.ml</code>
</li>
<li>Provide a value at configure time, if you are already aware of deployment conditions.
</li>
<li>Provide a value at startup time, for last minute changes.
</li>
</ul>
<p>All of this is now possible using <strong>keys</strong>. A key is composed of:</p>
<ul>
<li><em>name</em> &mdash; The name of the value in the program.
</li>
<li><em>description</em> &mdash; How it should be displayed/serialized.
</li>
<li><em>stage</em> &mdash; Is the key available only at runtime, at configure time, or both?
</li>
<li><em>documentation</em> &mdash; This is not optional, so you have to write it.
</li>
</ul>
<p>Imagine we are building a multilingual unikernel and we want to pass the
default language as a parameter. The language parameter is an optional string, so we use the <a href="http://mirage.github.io/functoria/Functoria_key.Arg.html#VALopt"><code>opt</code></a> and <a href="http://mirage.github.io/functoria/Functoria_key.Arg.html#VALstring"><code>string</code></a> combinators. We want to be able to define it both
at configure and run time, so we use the stage <code> `Both</code>. This gives us the following code:</p>
<pre><code class="language-ocaml">let lang_key =
  let doc = Key.Arg.info
      ~doc:&quot;The default language for the unikernel.&quot; [ &quot;l&quot; ; &quot;lang&quot; ]
  in
  Key.(create &quot;language&quot; Arg.(opt ~stage:`Both string &quot;en&quot; doc))
</code></pre>
<p>Here, we defined both a long option <code>--lang</code>, and a short one <code>-l</code>, (the format is similar to the one used by <a href="http://erratique.ch/software/cmdliner">Cmdliner</a>).
In the unikernel, the value is retrieved with <code>Key_gen.language ()</code>.</p>
<p>The option is also documented in the <code>--help</code> option for both <code>mirage configure</code> (at configure time) and <code>./my_unikernel</code> (at startup time).</p>
<pre><code>       -l VAL, --lang=VAL (absent=en)
           The default language for the unikernel.
</code></pre>
<p>A simple example of a unikernel with a key is available in <a href="https://github.com/mirage/mirage-skeleton">mirage-skeleton</a> in the <a href="https://github.com/mirage/mirage-skeleton/tree/master/hello"><code>hello</code> directory</a>.</p>
<h3>Switching implementation</h3>
<p>We can do much more with keys, for example we can use them to switch devices at configure time.
To illustrate, let us take the example of dynamic storage, where we want to choose between a block device and a crunch device with a command line option.
In order to do that, we must first define a boolean key:</p>
<pre><code class="language-ocaml">let fat_key =
  let doc = Key.Arg.info
      ~doc:&quot;Use a fat device if true, crunch otherwise.&quot; [ &quot;fat&quot; ]
  in
  Key.(create &quot;fat&quot; Arg.(opt ~stage:`Configure bool false doc))
</code></pre>
<p>We can use the <a href="http://mirage.github.io/functoria/Functoria.html#VALif_impl"><code>if_impl</code></a> combinator to choose between two devices depending on the value of the key.</p>
<pre><code class="language-ocaml">let dynamic_storage =
  if_impl (Key.value fat_key)
    (kv_ro_of_fs my_fat_device)
    (my_crunch_device)
</code></pre>
<p>We can now use this device as a normal storage device of type <code>kv_ro impl</code>! The key is also documented in <code>mirage configure --help</code>:</p>
<pre><code>       --fat=VAL (absent=false)
           Use a fat device if true, crunch otherwise.
</code></pre>
<p>It is also possible to compute on keys before giving them to <code>if_impl</code>, combining multiple keys in order to compute a value, and so on. For more details, see the <a href="http://mirage.github.io/functoria/">API</a> and the various examples available in <a href="https://github.com/mirage/mirage">mirage</a> and <a href="https://github.com/mirage/mirage-skeleton">mirage-skeleton</a>.</p>
<p>Switching keys opens various possibilities, for example a <code>generic_stack</code> combinator is now implemented in <code>mirage</code> that will switch between socket stack, direct stack with DHCP, and direct stack with static IP, depending on command line arguments.</p>
<h2>Drawing unikernels</h2>
<p>All these keys and dynamic implementations make for complicated unikernels. In order to clarify what is going on and help to configure our unikernels, we have a new command: <code>describe</code>.</p>
<p>Let us consider the <code>console</code> example in <a href="https://github.com/mirage/mirage-skeleton">mirage-skeleton</a>:</p>
<pre><code class="language-ocaml">open Mirage

let main = foreign &quot;Unikernel.Main&quot; (console @-&gt; job)
let () = register &quot;console&quot; [main $ default_console]
</code></pre>
<p>This is fairly straightforward: we define a <code>Unikernel.Main</code> functor using a console and we
instantiate it with the default console. If we execute <code>mirage describe --dot</code> in this directory, we will get the following output.</p>
<p><a href="https://mirage.io/graphics/dot/console.svg"><img src="https://mirage.io/graphics/dot/console.svg" alt="A console unikernel" title="My little unikernel"/></a></p>
<p>As you can see, there are already quite a few things going on!
Rectangles are the various devices and you'll notice that
the <code>default_console</code> is actually two consoles: the one on Unix and the one on Xen. We use the <code>if_impl</code> construction &mdash; represented as a circular node &mdash; to choose between the two during configuration.</p>
<p>The <code>key</code> device handles the runtime key handling. It relies on an <code>argv</code> device, which is similar to <code>console</code>. Those devices are present in all unikernels.</p>
<p>The <code>mirage</code> device is the device that brings all the jobs together (and on the hypervisor binds them).</p>
<h2>Data dependencies</h2>
<p>You may have noticed dashed lines in the previous diagram, in particular from <code>mirage</code> to <code>Unikernel.Main</code>. Those lines are data dependencies. For example, the <code>bootvar</code> device has a dependency on the <code>argv</code> device. It means that <code>argv</code> is configured and run first, returns some data &mdash; an array of string &mdash; then <code>bootvar</code> is configured and run.</p>
<p>If your unikernel has a data dependency &mdash; say, initializing the entropy &mdash; you can use the <code>~deps</code> argument on <code>Mirage.foreign</code>. The <code>start</code> function of the unikernel will receive one extra argument for each dependency.</p>
<p>As an example, let us look at the <a href="http://mirage.github.io/functoria/Functoria_app.html#VALapp_info"><code>app_info</code></a> device. This device makes the configuration information available at runtime. We can declare a dependency on it:</p>
<pre><code class="language-ocaml">let main =
  foreign &quot;Unikernel.Main&quot; ~deps:[abstract app_info] (console @-&gt; job)
</code></pre>
<p><a href="https://mirage.io/graphics/dot/info.svg"><img src="https://mirage.io/graphics/dot/info.svg" alt="A unikernel with info" title="My informed unikernel"/></a></p>
<p>The only difference with the previous unikernel is the data dependency &mdash; represented by a dashed arrow &mdash; going from <code>Unikernel.Main</code> to <code>Info_gen</code>. This means that <code>Unikernel.Main.start</code> will take an extra argument of type <code>Mirage_info.t</code> which we can, for example, print:</p>
<pre><code>name: console
libraries: [functoria.runtime; lwt.syntax; mirage-console.unix;
            mirage-types.lwt; mirage.runtime; sexplib]
packages: [functoria.0.1; lwt.2.5.0; mirage-console.2.1.3; mirage-unix.2.3.1;
           sexplib.113.00.00]
</code></pre>
<p>The complete example is available in <a href="https://github.com/mirage/mirage-skeleton">mirage-skeleton</a> in the <a href="https://github.com/mirage/mirage-skeleton/tree/master/app_info"><code>app_info</code> directory</a>.</p>
<h2>Sharing</h2>
<p>Since we have a way to draw unikernels, we can now observe the sharing between various pieces. For example, the direct stack with static IP yields this diagram:</p>
<p><a href="https://mirage.io/graphics/dot/stack.svg"><img src="https://mirage.io/graphics/dot/stack.svg" alt="A stack unikernel" title="My stack unikernel"/></a></p>
<p>You can see that all the sub-parts of the stack have been properly shared. To be merged, two devices must have the same name, keys, dependencies and functor arguments.
To force non-sharing of two devices, it is enough to give them different names.</p>
<p>This sharing also works up to switching keys. The generic stack gives us this diagram:</p>
<p><a href="https://mirage.io/graphics/dot/dynamic.svg"><img src="https://mirage.io/graphics/dot/dynamic.svg" alt="A dynamic stack unikernel" title="My generic unikernel"/></a></p>
<p>If you look closely, you'll notice that there are actually <em>three</em> stacks in the last example: the <em>socket</em> stack, the <em>direct stack with DHCP</em>, and the <em>direct stack with IP</em>. All controlled by switching keys.</p>
<h2>All your functors are belong to us</h2>
<p>There is more to be said about the new capabilities offered by functoria, in particular on how to define new devices. You can discover them by looking at the <a href="https://github.com/mirage/mirage">mirage</a> implementation.</p>
<p>However, to wrap up this blog post, I offer you a visualization of the MirageOS website itself (brace yourself). <a href="https://mirage.io/graphics/dot/www.svg">Enjoy!</a></p>
<p><em>Thanks to <a href="http://mort.io">Mort</a>, <a href="http://somerandomidiot.com">Mindy</a>, <a href="http://amirchaudhry.com">Amir</a> and <a href="https://github.com/yallop">Jeremy</a>
for their comments on earlier drafts.</em></p>

      
