---
title: Adding the Qubes target to Mirage
description:
url: https://mirage.io/blog/qubes-target
date: 2017-03-01T00:00:00-00:00
preview_image:
featured:
authors:
- Mindy Preston
---


        <p>When I got a new laptop in early 2016, I decided to try out this <a href="https://qubesos.org">QubesOS</a> all the cool kids were talking about.  QubesOS also runs a hypervisor, but it nicely supports running multiple virtual machines for typical user tasks, like looking at cat photos with a web browser, viewing a PDF, listening to music, or patching MirageOS.  QubesOS also uses Xen, which means we should be able to even <em>run</em> our MirageOS unikernels on it... right?</p>
<p>The answer is <a href="http://roscidus.com/blog/blog/2016/01/01/a-unikernel-firewall-for-qubesos/">yes, after a fashion</a>.  Thomas Leonard did the hard work of writing <a href="https://github.com/mirage/mirage-qubes">mirage-qubes</a>, a library that interfaces nicely with the QubesOS management layer and allows MirageOS unikernels to boot, configure themselves, and run as managed by the Qubes management system.  That solution is nice for generating, once, a unikernel that you're going to run all the time under QubesOS, but building a unikernel that will boot and run on QubesOS requires QubesOS-specific code in the unikernel itself.  It's very unfriendly for testing generic unikernels, and as the release manager for Mirage 3, I wanted to do that pretty much all the time.</p>
<p>The command-line <code>mirage</code> utility was made to automatically build programs against libraries that are specific to a target only when the user has asked to build for that target, which is the exact problem we have!  So let's try to get to <code>mirage configure -t qubes</code>.</p>
<h2>teach a robot to do human tricks</h2>
<p>In order for Qubes to successfully boot our unikernel, it needs to do at least two (but usually three) things:</p>
<ul>
<li>start a qrexec listener, and respond to requests from dom0
</li>
<li>start a qubes-gui listener, and respond to requests from dom0
</li>
<li>if we're going to do networking (usually we are), get the network configuration from qubesdb
</li>
</ul>
<p>There's code for doing all of these available in the <a href="https://github.com/mirage/mirage-qubes">mirage-qubes</a> library, and a nice example available at <a href="https://github.com/talex5/qubes-mirage-skeleton">qubes-mirage-skeleton</a>.  The example at qubes-mirage-skeleton shows us what we have to plumb into a MirageOS unikernel in order to boot in Qubes.  All of the important stuff is in <code>unikernel.ml</code>.  We need to pull the code that connects to RExec and GUI:</p>
<pre><code class="language-ocaml">(* Start qrexec agent, GUI agent and QubesDB agent in parallel *)
   let qrexec = RExec.connect ~domid:0 () in
   let gui = GUI.connect ~domid:0 () in
</code></pre>
<p><code>qrexec</code> and <code>gui</code> are Lwt threads that will resolve in the records we need to pass to the respective <code>listen</code> functions from the <code>RExec</code> and <code>GUI</code> modules.  We'll state the rest of the program in terms of what to do once they're connected with a couple of monadic binds:</p>
<pre><code class="language-ocaml">    (* Wait for clients to connect *)
    qrexec &gt;&gt;= fun qrexec -&gt;
    let agent_listener = RExec.listen qrexec Command.handler in
</code></pre>
<p><code>agent_listener</code> is called much later in the program.  It's not something we'll use generally in an adaptation of this code for a generic unikernel running on QubesOS -- instead, we'll invoke <code>RExec.listen</code> with a function that disregards input.</p>
<pre><code class="language-ocaml">    gui &gt;&gt;= fun gui -&gt;
    Lwt.async (fun () -&gt; GUI.listen gui);
</code></pre>
<p>We use <code>gui</code> right away, though.  <code>Lwt.async</code> lets us start an Lwt thread that the rest of our program logic isn't impacted by, but needs to be hooked into the event loop.  The function we define in this call asks <code>GUI.listen</code> to handle incoming events for the <code>gui</code> record we got from <code>GUI.connect</code>.</p>
<p><code>qubes-mirage-skeleton</code> does an additional bit of setup:</p>
<pre><code class="language-ocaml">    Lwt.async (fun () -&gt;
      OS.Lifecycle.await_shutdown_request () &gt;&gt;= fun (`Poweroff | `Reboot) -&gt;
      RExec.disconnect qrexec
    );
</code></pre>
<p>This hooks another function into the event loop: a listener which hears shutdown requests from <a href="https://github.com/mirage/mirage-platform/blob/2d044a499824c98ee2f067b71110883e9226d8cf/xen/lib/lifecycle.ml#L21">OS.Lifecycle</a> and disconnects <code>RExec</code> when they're heard.  The <code>disconnect</code> has the side effect of terminating the <code>agent_listener</code> if it's running, as documented in <a href="https://github.com/talex5/mirage-qubes/master/lib/qubes.mli#L130%22">mirage-qubes</a>.</p>
<p><code>qubes-mirage-skeleton</code> then configures its networking (we'll talk about this later) and runs a test to make sure it can reach the outside world.  Once that's finished, it calls the <code>agent_listener</code> defined above, which listens for commands via <code>RExec.listen</code>.</p>
<h2>making mirageos unikernels</h2>
<p>Building MirageOS unikernels is a three-phase process:</p>
<ul>
<li>mirage configure: generate main.ml unifying your code with the devices it needs
</li>
<li>make depend: make sure you have the libraries required to build the final artifact
</li>
<li>make: build your application against the specified configuration
</li>
</ul>
<p>In order to get an artifact that automatically includes the code above, we need to plumb the tasks above into <code>main.ml</code>, and the libraries they depend on into <code>make depend</code>, via <code>mirage configure</code>.</p>
<h2>let's quickly revisit what impl passing usually looks like</h2>
<p>Applications built to run as MirageOS unikernels are written as OCaml functors.  They're parameterized over OCaml modules providing implementations of some functionality, which is stated as a module type.  For example, here's a MirageOS networked &quot;hello world&quot;:</p>
<pre><code class="language-ocaml">module Main (N: Mirage_net_lwt.S) = struct

  let start (n : N.t)  =
    N.write n @@ Cstruct.of_string &quot;omg hi network&quot; &gt;&gt;= function
    | Error e -&gt; Log.warn (fun f -&gt; f &quot;failed to send message&quot;); Lwt.return_unit
    | Ok () -&gt; Log.info (fun f -&gt; f &quot;said hello!&quot;); Lwt.return_unit

end
</code></pre>
<p>Our program is in a module that's parameterized over the module <code>N</code>, which can be any module that matches the module type <code>Mirage_net_lwt.S</code>.  The entry point for execution is the <code>start</code> function, which takes one argument of type <code>N.t</code>.  This is the usual pattern for Mirage unikernels, powered by Functoria's <a href="https://mirage.io/blog/introducing-functoria">invocation of otherworldly functors</a>.</p>
<p>But there are other modules which aren't explicitly passed.  Since MirageOS version 2.9.0, for example, a <code>Logs</code> module has been available to MirageOS unikernels.  It isn't explicitly passed as a module argument to <code>Main</code>, because it's assumed that all unikernels will want to use it, and so it's always made available.  The <code>OS</code> module is also always available, although the implementation will be specific to the target for which the unikernel was configured, and there is no module type to which the module is forced to conform.</p>
<h2>providing additional modules</h2>
<p>Let's look first at fulfilling the <code>qrexec</code> and <code>gui</code> requirements, which we'll have to do for any unikernel that's configured with <code>mirage configure -t qubes</code>.</p>
<p>When we want a module passed to the generated unikernel, we start by making a <code>job</code>.  Let's add one for <code>qrexec</code> to <code>lib/mirage.ml</code>:</p>
<pre><code class="language-ocaml">let qrexec = job
</code></pre>
<p>and we'll want to define some code for what <code>mirage</code> should do if it's determined from the command-line arguments to <code>mirage configure</code> that a <code>qrexec</code> is required:</p>
<pre><code class="language-ocaml">let qrexec_qubes = impl @@ object
  inherit base_configurable
  method ty = qrexec
  val name = Name.ocamlify @@ &quot;qrexec_&quot;
  method name = name
  method module_name = &quot;Qubes.RExec&quot;
  method packages = Key.pure [ package &quot;mirage-qubes&quot; ]
  method configure i =
    match get_target i with
    | `Qubes -&gt; R.ok ()
    | _ -&gt; R.error_msg &quot;Qubes remote-exec invoked for non-Qubes target.&quot;
  method connect _ modname _args =
    Fmt.strf
      &quot;@[&lt;v 2&gt;\\
       %s.connect ~domid:0 () &gt;&gt;= fun qrexec -&gt;@ \\
       Lwt.async (fun () -&gt;@ \\
       OS.Lifecycle.await_shutdown_request () &gt;&gt;= fun _ -&gt;@ \\
       %s.disconnect qrexec);@ \\
       Lwt.return (`Ok qrexec)@]&quot;
      modname modname
end
</code></pre>
<p>This defines a <code>configurable</code> object, which inherits from the <code>base_configurable</code> class defined in Mirage.  The interesting bits for this <code>configurable</code> are the methods <code>packages</code>, <code>configure</code>, and <code>connect</code>. <code>packages</code> is where the dependency on <code>mirage-qubes</code> is declared.  <code>configure</code> will terminate if <code>qrexec_qubes</code> has been pulled into the dependency graph but the user invoked another target (for example, <code>mirage configure -t unix</code>).  <code>connect</code> gives the instructions for generating the code for <code>qrexec</code> in <code>main.ml</code>.</p>
<p>You may notice that <code>connect</code>'s <code>strf</code> call doesn't refer to <code>Qrexec</code> directly, but rather takes a <code>modname</code> parameter.  Most of the modules referred to will be the result of some functor application, and the previous code generation will automatically name them; the only way to access this name is via the <code>modname</code> parameter.</p>
<p>We do something similar for <code>gui</code>:</p>
<pre><code class="language-ocaml">let gui = job

let gui_qubes = impl @@ object
  inherit base_configurable
  method ty = gui
  val name = Name.ocamlify @@ &quot;gui&quot;
  method name = name
  method module_name = &quot;Qubes.GUI&quot;
  method packages = Key.pure [ package &quot;mirage-qubes&quot; ]
  method configure i =
    match get_target i with
    | `Qubes -&gt; R.ok ()
    | _ -&gt; R.error_msg &quot;Qubes GUI invoked for non-Qubes target.&quot;
  method connect _ modname _args =
    Fmt.strf
      &quot;@[&lt;v 2&gt;\\
       %s.connect ~domid:0 () &gt;&gt;= fun gui -&gt;@ \\
       Lwt.async (fun () -&gt; %s.listen gui);@ \\
       Lwt.return (`Ok gui)@]&quot;
      modname modname
end
</code></pre>
<p>For details on what both <code>gui_qubes</code> and <code>qrexec_qubes</code> are actually doing in their <code>connect</code> blocks and why, <a href="http://roscidus.com/blog/blog/2016/01/01/a-unikernel-firewall-for-qubesos/">talex5's post on building the QubesOS unikernel firewall</a>.</p>
<h3>QRExec for nothing, GUI for free</h3>
<p>We'll need the <code>connect</code> function for both of these configurables to be run before the <code>start</code> function of our unikernel.  But we also don't want a corresponding <code>QRExec.t</code> or <code>GUI.t</code> to be passed to our unikernel, nor do we want to parameterize it over the module type corresponding to either module, since either of these would be nonsensical for a non-Qubes target.</p>
<p>Instead, we need to have <code>main.ml</code> take care of this transparently, and we don't want any of the results passed to us.  In order to accomplish this, we'll need to change the final invocation of Functoria's <code>register</code> function from <code>Mirage.register</code>:</p>
<pre><code class="language-ocaml">let qrexec_init = match_impl Key.(value target) [
  `Qubes, qrexec_qubes;
] ~default:Functoria_app.noop

let gui_init = match_impl Key.(value target) [
  `Qubes, gui_qubes;
] ~default:Functoria_app.noop

let register
    ?(argv=default_argv) ?tracing ?(reporter=default_reporter ())
    ?keys ?packages
    name jobs =
  let argv = Some (Functoria_app.keys argv) in
  let reporter = if reporter == no_reporter then None else Some reporter in
  let qubes_init = Some [qrexec_init; gui_init] in
  let init = qubes_init ++ argv ++ reporter ++ tracing in
  register ?keys ?packages ?init name jobs
</code></pre>
<p><code>qrexec_init</code> and <code>gui_init</code> will only take action if the target is <code>qubes</code>; otherwise, the dummy implementation <code>Functoria_app.noop</code> will be used.  The <code>qrexec_init</code> and <code>gui_init</code> values are added to the <code>init</code> list passed to <code>register</code> regardless of whether they are the Qubes <code>impl</code>s or <code>Functoria_app.noop</code>.</p>
<p>With those additions, <code>mirage configure -t qubes</code> will result in a bootable unikernel!  ...but we're not done yet.</p>
<h2>how do I networks</h2>
<p>MirageOS previously had two methods of IP configuration: automatically at boot via <a href="https://github.com/mirage/charrua-core">DHCP</a>, and statically at code, configure, or boot.  Neither of these are appropriate IPv4 interfaces on Qubes VMs: QubesOS doesn't run a DHCP daemon.  Instead, it expects VMs to consult the Qubes database for their IP information after booting.  Since the IP information isn't known before boot, we can't even supply it at boot time.</p>
<p>Instead, we'll add a new <code>impl</code> for fetching information from QubesDB, and plumb the IP configuration into the <code>generic_stackv4</code> function.  <code>generic_stackv4</code> already makes an educated guess about the best IPv4 configuration retrieval method based in part on the target, so this is a natural fit.</p>
<p>Since we want to use QubesDB as an input to the function that configures the IPv4 stack, we'll have to do a bit more work to make it fit nicely into the functor application architecture -- namely, we have to make a <code>Type</code> for it:</p>
<pre><code class="language-ocaml">type qubesdb = QUBES_DB
let qubesdb = Type QUBES_DB

let qubesdb_conf = object
  inherit base_configurable
  method ty = qubesdb
  method name = &quot;qubesdb&quot;
  method module_name = &quot;Qubes.DB&quot;
  method packages = Key.pure [ package &quot;mirage-qubes&quot; ]
  method configure i =
    match get_target i with
    | `Qubes -&gt; R.ok ()
    | _ -&gt; R.error_msg &quot;Qubes DB invoked for non-Qubes target.&quot;
  method connect _ modname _args = Fmt.strf &quot;%s.connect ~domid:0 ()&quot; modname
end

let default_qubesdb = impl qubesdb_conf
</code></pre>
<p>Other than the <code>type qubesdb = QUBES_DB</code> and <code>let qubesdb = Type QUBES_DB</code>, this isn't very different from the previous <code>gui</code> and <code>qrexec</code> examples.  Next, we'll need something that can take a <code>qubesdb</code>, look up the configuration, and set up an <code>ipv4</code> from the lower layers:</p>
<pre><code class="language-ocaml">let ipv4_qubes_conf = impl @@ object
    inherit base_configurable
    method ty = qubesdb @-&gt; ethernet @-&gt; arpv4 @-&gt; ipv4
    method name = Name.create &quot;qubes_ipv4&quot; ~prefix:&quot;qubes_ipv4&quot;
    method module_name = &quot;Qubesdb_ipv4.Make&quot;
    method packages = Key.pure [ package ~sublibs:[&quot;ipv4&quot;] &quot;mirage-qubes&quot; ]
    method connect _ modname = function
      | [ db ; etif; arp ] -&gt; Fmt.strf &quot;%s.connect %s %s %s&quot; modname db etif arp
      | _ -&gt; failwith (connect_err &quot;qubes ipv4&quot; 3)
  end

let ipv4_qubes db ethernet arp = ipv4_qubes_conf $ db $ ethernet $ arp
</code></pre>
<p>Notably, the <code>connect</code> function here is a bit more complicated -- we care about the arguments presented to the function (namely the initialized database, an ethernet module, and an arp module), and we'll pass them to the initialization function, which comes from <code>mirage-qubes.ipv4</code>.</p>
<p>To tell <code>mirage configure</code> that when <code>-t qubes</code> is specified, we should use <code>ipv4_qubes_conf</code>, we'll add a bit to <code>generic_stackv4</code>:</p>
<pre><code class="language-ocaml">let generic_stackv4
    ?group ?config
    ?(dhcp_key = Key.value @@ Key.dhcp ?group ())
    ?(net_key = Key.value @@ Key.net ?group ())
    (tap : network impl) : stackv4 impl =
  let eq a b = Key.(pure ((=) a) $ b) in
  let choose qubes socket dhcp =
    if qubes then `Qubes
    else if socket then `Socket
    else if dhcp then `Dhcp
    else `Static
  in
  let p = Functoria_key.((pure choose)
          $ eq `Qubes Key.(value target)
          $ eq `Socket net_key
          $ eq true dhcp_key) in
  match_impl p [
    `Dhcp, dhcp_ipv4_stack ?group tap;
    `Socket, socket_stackv4 ?group [Ipaddr.V4.any];
    `Qubes, qubes_ipv4_stack ?group tap;
  ] ~default:(static_ipv4_stack ?config ?group tap)
</code></pre>
<p>Now, <code>mirage configure -t qubes</code> with any unikernel that usees <code>generic_stackv4</code> will automatically work!</p>
<h1>So What?</h1>
<p>This means I can configure this website for the Qubes target in my development VM:</p>
<pre><code class="language-bash">4.04.0&#128043;  (qubes-target) mirageos:~/mirage-www/src$ mirage configure -t qubes
</code></pre>
<p>and get some nice invocations of the QRExec and GUI start code, along with the IPv4 configuration from QubesDB:</p>
<pre><code class="language-ocaml">4.04.0&#128043;  (qubes-target) mirageos:~/mirage-www/src$ cat main.ml
(* Generated by mirage configure -t qubes (Tue, 28 Feb 2017 18:15:49 GMT). *)

open Lwt.Infix
let return = Lwt.return
let run =
OS.Main.run

let _ = Printexc.record_backtrace true

module Ethif1 = Ethif.Make(Netif)

module Arpv41 = Arpv4.Make(Ethif1)(Mclock)(OS.Time)

module Qubesdb_ipv41 = Qubesdb_ipv4.Make(Qubes.DB)(Ethif1)(Arpv41)

module Icmpv41 = Icmpv4.Make(Qubesdb_ipv41)

module Udp1 = Udp.Make(Qubesdb_ipv41)(Stdlibrandom)

module Tcp1 = Tcp.Flow.Make(Qubesdb_ipv41)(OS.Time)(Mclock)(Stdlibrandom)

module Tcpip_stack_direct1 = Tcpip_stack_direct.Make(OS.Time)(Stdlibrandom)
  (Netif)(Ethif1)(Arpv41)(Qubesdb_ipv41)(Icmpv41)(Udp1)(Tcp1)

module Conduit_mirage1 = Conduit_mirage.With_tcp(Tcpip_stack_direct1)

module Dispatch1 = Dispatch.Make(Cohttp_mirage.Server_with_conduit)(Static1)
  (Static2)(Pclock)

module Mirage_logs1 = Mirage_logs.Make(Pclock)

let net11 = lazy (
  Netif.connect (Key_gen.interface ())
  )

let time1 = lazy (
  return ()
  )

let mclock1 = lazy (
  Mclock.connect ()
  )

let ethif1 = lazy (
  let __net11 = Lazy.force net11 in
  __net11 &gt;&gt;= fun _net11 -&gt;
  Ethif1.connect _net11
  )

let qubesdb1 = lazy (
  Qubes.DB.connect ~domid:0 ()
  )

let arpv41 = lazy (
  let __ethif1 = Lazy.force ethif1 in
  let __mclock1 = Lazy.force mclock1 in
  let __time1 = Lazy.force time1 in
  __ethif1 &gt;&gt;= fun _ethif1 -&gt;
  __mclock1 &gt;&gt;= fun _mclock1 -&gt;
  __time1 &gt;&gt;= fun _time1 -&gt;
  Arpv41.connect _ethif1 _mclock1
  )

let qubes_ipv411 = lazy (
  let __qubesdb1 = Lazy.force qubesdb1 in
  let __ethif1 = Lazy.force ethif1 in
  let __arpv41 = Lazy.force arpv41 in
  __qubesdb1 &gt;&gt;= fun _qubesdb1 -&gt;
  __ethif1 &gt;&gt;= fun _ethif1 -&gt;
  __arpv41 &gt;&gt;= fun _arpv41 -&gt;
  Qubesdb_ipv41.connect _qubesdb1 _ethif1 _arpv41
  )

let random1 = lazy (
  Lwt.return (Stdlibrandom.initialize ())
  )

let icmpv41 = lazy (
  let __qubes_ipv411 = Lazy.force qubes_ipv411 in
  __qubes_ipv411 &gt;&gt;= fun _qubes_ipv411 -&gt;
  Icmpv41.connect _qubes_ipv411
  )

let udp1 = lazy (
  let __qubes_ipv411 = Lazy.force qubes_ipv411 in
  let __random1 = Lazy.force random1 in
  __qubes_ipv411 &gt;&gt;= fun _qubes_ipv411 -&gt;
  __random1 &gt;&gt;= fun _random1 -&gt;
  Udp1.connect _qubes_ipv411
  )

let tcp1 = lazy (
  let __qubes_ipv411 = Lazy.force qubes_ipv411 in
  let __time1 = Lazy.force time1 in
  let __mclock1 = Lazy.force mclock1 in
  let __random1 = Lazy.force random1 in
  __qubes_ipv411 &gt;&gt;= fun _qubes_ipv411 -&gt;
  __time1 &gt;&gt;= fun _time1 -&gt;
  __mclock1 &gt;&gt;= fun _mclock1 -&gt;
  __random1 &gt;&gt;= fun _random1 -&gt;
  Tcp1.connect _qubes_ipv411 _mclock1
  )

let stackv4_1 = lazy (
  let __time1 = Lazy.force time1 in
  let __random1 = Lazy.force random1 in
  let __net11 = Lazy.force net11 in
  let __ethif1 = Lazy.force ethif1 in
  let __arpv41 = Lazy.force arpv41 in
  let __qubes_ipv411 = Lazy.force qubes_ipv411 in
  let __icmpv41 = Lazy.force icmpv41 in
  let __udp1 = Lazy.force udp1 in
  let __tcp1 = Lazy.force tcp1 in
  __time1 &gt;&gt;= fun _time1 -&gt;
  __random1 &gt;&gt;= fun _random1 -&gt;
  __net11 &gt;&gt;= fun _net11 -&gt;
  __ethif1 &gt;&gt;= fun _ethif1 -&gt;
  __arpv41 &gt;&gt;= fun _arpv41 -&gt;
  __qubes_ipv411 &gt;&gt;= fun _qubes_ipv411 -&gt;
  __icmpv41 &gt;&gt;= fun _icmpv41 -&gt;
  __udp1 &gt;&gt;= fun _udp1 -&gt;
  __tcp1 &gt;&gt;= fun _tcp1 -&gt;
  let config = {Mirage_stack_lwt. name = &quot;stackv4_&quot;; interface = _net11;} in
Tcpip_stack_direct1.connect config
_ethif1 _arpv41 _qubes_ipv411 _icmpv41 _udp1 _tcp1
  )

let nocrypto1 = lazy (
  Nocrypto_entropy_mirage.initialize ()
  )

let tcp_conduit_connector1 = lazy (
  let __stackv4_1 = Lazy.force stackv4_1 in
  __stackv4_1 &gt;&gt;= fun _stackv4_1 -&gt;
  Lwt.return (Conduit_mirage1.connect _stackv4_1)

  )

let conduit11 = lazy (
  let __nocrypto1 = Lazy.force nocrypto1 in
  let __tcp_conduit_connector1 = Lazy.force tcp_conduit_connector1 in
  __nocrypto1 &gt;&gt;= fun _nocrypto1 -&gt;
  __tcp_conduit_connector1 &gt;&gt;= fun _tcp_conduit_connector1 -&gt;
  Lwt.return Conduit_mirage.empty &gt;&gt;= _tcp_conduit_connector1 &gt;&gt;=
fun t -&gt; Lwt.return t
  )

let argv_qubes1 = lazy (
  let filter (key, _) = List.mem key (List.map snd Key_gen.runtime_keys) in
Bootvar.argv ~filter ()
  )

let http1 = lazy (
  let __conduit11 = Lazy.force conduit11 in
  __conduit11 &gt;&gt;= fun _conduit11 -&gt;
  Cohttp_mirage.Server_with_conduit.connect _conduit11
  )

let static11 = lazy (
  Static1.connect ()
  )

let static21 = lazy (
  Static2.connect ()
  )

let pclock1 = lazy (
  Pclock.connect ()
  )

let key1 = lazy (
  let __argv_qubes1 = Lazy.force argv_qubes1 in
  __argv_qubes1 &gt;&gt;= fun _argv_qubes1 -&gt;
  return (Functoria_runtime.with_argv (List.map fst Key_gen.runtime_keys) &quot;www&quot; _argv_qubes1)
  )

let gui1 = lazy (
  Qubes.GUI.connect ~domid:0 () &gt;&gt;= fun gui -&gt;
  Lwt.async (fun () -&gt; Qubes.GUI.listen gui);
  Lwt.return (`Ok gui)
  )

let qrexec_1 = lazy (
  Qubes.RExec.connect ~domid:0 () &gt;&gt;= fun qrexec -&gt;
  Lwt.async (fun () -&gt;
  OS.Lifecycle.await_shutdown_request () &gt;&gt;= fun _ -&gt;
  Qubes.RExec.disconnect qrexec);
  Lwt.return (`Ok qrexec)
  )

let f11 = lazy (
  let __http1 = Lazy.force http1 in
  let __static11 = Lazy.force static11 in
  let __static21 = Lazy.force static21 in
  let __pclock1 = Lazy.force pclock1 in
  __http1 &gt;&gt;= fun _http1 -&gt;
  __static11 &gt;&gt;= fun _static11 -&gt;
  __static21 &gt;&gt;= fun _static21 -&gt;
  __pclock1 &gt;&gt;= fun _pclock1 -&gt;
  Dispatch1.start _http1 _static11 _static21 _pclock1
  )

let mirage_logs1 = lazy (
  let __pclock1 = Lazy.force pclock1 in
  __pclock1 &gt;&gt;= fun _pclock1 -&gt;
  let ring_size = None in
  let reporter = Mirage_logs1.create ?ring_size _pclock1 in
  Mirage_runtime.set_level ~default:Logs.Info (Key_gen.logs ());
  Mirage_logs1.set_reporter reporter;
  Lwt.return reporter
  )

let mirage1 = lazy (
  let __qrexec_1 = Lazy.force qrexec_1 in
  let __gui1 = Lazy.force gui1 in
  let __key1 = Lazy.force key1 in
  let __mirage_logs1 = Lazy.force mirage_logs1 in
  let __f11 = Lazy.force f11 in
  __qrexec_1 &gt;&gt;= fun _qrexec_1 -&gt;
  __gui1 &gt;&gt;= fun _gui1 -&gt;
  __key1 &gt;&gt;= fun _key1 -&gt;
  __mirage_logs1 &gt;&gt;= fun _mirage_logs1 -&gt;
  __f11 &gt;&gt;= fun _f11 -&gt;
  Lwt.return_unit
  )

let () =
  let t =
  Lazy.force qrexec_1 &gt;&gt;= fun _ -&gt;
    Lazy.force gui1 &gt;&gt;= fun _ -&gt;
    Lazy.force key1 &gt;&gt;= fun _ -&gt;
    Lazy.force mirage_logs1 &gt;&gt;= fun _ -&gt;
    Lazy.force mirage1
  in run t
</code></pre>
<p>and we can build this unikernel, then <a href="https://github.com/talex5/qubes-test-mirage">send it to dom0 to be booted</a>:</p>
<pre><code class="language-bash">4.04.0&#128043;  (qubes-target) mirageos:~/mirage-www/src$ make depend
4.04.0&#128043;  (qubes-target) mirageos:~/mirage-www/src$ make
4.04.0&#128043;  (qubes-target) mirageos:~/mirage-www/src$ ~/test-mirage www.xen mirage-test
</code></pre>
<p>and if we check the guest VM logs for the test VM (which on my machine is named <code>mirage-test</code>, as above), we'll see that it's up and running:</p>
<pre><code class="language-bash">.[32;1mMirageOS booting....[0m
Initialising timer interface
Initialising console ... done.
Note: cannot write Xen 'control' directory
Attempt to open(/dev/urandom)!
Unsupported function getpid called in Mini-OS kernel
Unsupported function getppid called in Mini-OS kernel
2017-02-28 18:29:54 -00:00: INF [net-xen:frontend] connect 0
2017-02-28 18:29:54 -00:00: INF [qubes.db] connecting to server...
gnttab_stubs.c: initialised mini-os gntmap
2017-02-28 18:29:54 -00:00: INF [qubes.db] connected
2017-02-28 18:29:54 -00:00: INF [net-xen:frontend] create: id=0 domid=2
2017-02-28 18:29:54 -00:00: INF [net-xen:frontend]  sg:true gso_tcpv4:true rx_copy:true rx_flip:false smart_poll:false
2017-02-28 18:29:54 -00:00: INF [net-xen:frontend] MAC: 00:16:3e:5e:6c:0e
2017-02-28 18:29:54 -00:00: INF [ethif] Connected Ethernet interface 00:16:3e:5e:6c:0e
2017-02-28 18:29:54 -00:00: INF [arpv4] Connected arpv4 device on 00:16:3e:5e:6c:0e
2017-02-28 18:29:54 -00:00: INF [udp] UDP interface connected on 10.137.3.16
2017-02-28 18:29:54 -00:00: INF [tcpip-stack-direct] stack assembled: mac=00:16:3e:5e:6c:0e,ip=10.137.3.16
2017-02-28 18:29:56 -00:00: INF [dispatch] Listening on http://localhost/
</code></pre>
<p>And if we do a bit of firewall tweaking in <code>sys-firewall</code> to grant access from other VMs:</p>
<pre><code class="language-bash">[user@sys-firewall ~]$ sudo iptables -I FORWARD -d 10.137.3.16 -i vif+ -j ACCEPT
</code></pre>
<p>we can verify that things are as we expect from any VM that has the appropriate software -- for example:</p>
<pre><code class="language-bash">4.04.0&#128043;  (qubes-target) mirageos:~/mirage-www/src$ wget -q -O - ht.137.3.16|head -1
&lt;!DOCTYPE html&gt;
</code></pre>
<h1>What's Next?</h1>
<p>The implementation work above leaves a lot to be desired, noted in the <a href="https://github.com/mirage/mirage/pull/553#issuecomment-231529011">comments to the original pull request</a>.  We welcome further contributions in this area, particularly from QubesOS users and developers!  If you have questions or comments, please get in touch on the <a href="https://lists.xenproject.org/cgi-bin/mailman/listinfo/mirageos-devel">mirageos-devel mailing list</a> or on our IRC channel at #mirage on irc.freenode.net !</p>

      
