---
title: Fitting the modular MirageOS TCP/IP stack together
description:
url: https://mirage.io/blog/intro-tcpip
date: 2014-07-17T00:00:00-00:00
preview_image:
featured:
authors:
- Mindy Preston
---


        <p>A critical part of any unikernel is its network stack -- it's difficult to
think of a project that needs a cloud platform or runs on a set-top box with no
network communications.</p>
<p>Mirage provides a number of <a href="https://github.com/mirage/mirage/tree/master/types">module
types</a> that abstract
interfaces at different layers of the network stack, allowing unikernels to
customise their own stack based on their deployment needs. Depending on the
abstractions your unikernel uses, you can fulfill these abstract interfaces
with implementations ranging from the venerable and much-imitated Unix sockets
API to a clean-slate Mirage <a href="https://github.com/mirage/mirage-tcpip">TCP/IP
stack</a> written from the ground up in
pure OCaml!</p>
<p>A Mirage unikernel will not use <em>all</em> these interfaces, but will pick those that
are appropriate for the particular application at hand. If your unikernel just
needs a standard TCP/IP stack, the <code>STACKV4</code> abstraction will be sufficient.
However, if you want more control over the implementation of the different
layers in the stack or you don't need TCP support, you might construct your
stack by hand using just the <a href="https://github.com/mirage/mirage/blob/8b59fbf0b223b3c5c70d4939b5674ecdd7521804/types/V1.mli#L263">NETWORK</a>, <a href="https://github.com/mirage/mirage/blob/8b59fbf0b223b3c5c70d4939b5674ecdd7521804/types/V1.mli#L316">ETHIF</a>, <a href="https://github.com/mirage/mirage/blob/8b59fbf0b223b3c5c70d4939b5674ecdd7521804/types/V1.mli#L368">IPV4</a> and <a href="https://github.com/mirage/mirage/blob/8b59fbf0b223b3c5c70d4939b5674ecdd7521804/types/V1.mli#L457">UDPV4</a> interfaces.</p>
<h2>How a Stack Looks to a Mirage Application</h2>
<p>Mirage provides a high-level interface to a TCP/IP network stack through the module type
<a href="https://github.com/mirage/mirage/blob/8b59fbf0b223b3c5c70d4939b5674ecdd7521804/types/V1.mli#L581">STACKV4</a>.
(Currently this can be included with <code>open V1_LWT</code>, but soon <code>open V2_LWT</code> will also bring this module type into scope as well when Mirage 2.0 is released.)</p>
<pre><code class="language-OCaml">(** Single network stack *)                                                     
module type STACKV4 = STACKV4                                                   
  with type 'a io = 'a Lwt.t                                                    
   and type ('a,'b,'c) config = ('a,'b,'c) stackv4_config                       
   and type ipv4addr = Ipaddr.V4.t                                              
   and type buffer = Cstruct.t 
</code></pre>
<p><code>STACKV4</code> has useful high-level functions, a subset of which are reproduced below:</p>
<pre><code class="language-OCaml">    val listen_udpv4 : t -&gt; port:int -&gt; UDPV4.callback -&gt; unit
    val listen_tcpv4 : t -&gt; port:int -&gt; TCPV4.callback -&gt; unit
    val listen : t -&gt; unit io
</code></pre>
<p>as well as submodules that include functions for data transmission:</p>
<pre><code class="language-OCaml">    module UDPV4 :
      sig
        type callback =
            src:ipv4addr -&gt; dst:ipv4addr -&gt; src_port:int -&gt; buffer -&gt; unit io
        val input :
          listeners:(dst_port:int -&gt; callback option) -&gt; t -&gt; ipv4input
        val write :
          ?source_port:int -&gt;
          dest_ip:ipv4addr -&gt; dest_port:int -&gt; t -&gt; buffer -&gt; unit io
</code></pre>
<pre><code class="language-OCaml">    module TCPV4 :
      sig
        type flow
        type callback = flow -&gt; unit io
        val read : flow -&gt; [ `Eof | `Error of error | `Ok of buffer ] io
        val write : flow -&gt; buffer -&gt; unit io
        val close : flow -&gt; unit io
        val create_connection :
          t -&gt; ipv4addr * int -&gt; [ `Error of error | `Ok of flow ] io
        val input : t -&gt; listeners:(int -&gt; callback option) -&gt; ipv4input
</code></pre>
<p>These should look rather familiar if you've used the Unix sockets
API before, with one notable difference: the stack accepts functional
callbacks to react to events such as a new connection request.  This
permits callers of the library to define the precise datastructures that
are used to store intermediate state (such as active connections).
This becomes important when building very scalable systems that have
to deal with <a href="https://en.wikipedia.org/wiki/C10k_problem">lots of concurrent connections</a>
efficiently.</p>
<h2>Configuring a Stack</h2>
<p>The <code>STACKV4</code> signature shown so far is just a module signature, and you
need to find a concrete module that satisfies that signature.  The known
implementations of a module can be found in the <code>mirage</code> CLI frontend,
which provids the <a href="https://github.com/mirage/mirage/blob/8b59fbf0b223b3c5c70d4939b5674ecdd7521804/lib/mirage.mli#L266">configuration API</a> for unikernels.<br/>
There are currently two implementations for <code>STACKV4</code>: <code>direct</code> and <code>socket</code>.</p>
<pre><code class="language-OCaml">module STACKV4_direct: CONFIGURABLE with                                        
  type t = console impl * network impl * [`DHCP | `IPV4 of ipv4_config]         
                                                                                
module STACKV4_socket: CONFIGURABLE with                                        
  type t = console impl * Ipaddr.V4.t list  
</code></pre>
<p>The <code>socket</code> implementations rely on an underlying OS kernel to provide the
transport, network, and data link layers, and therefore can't be used for a Xen
guest VM deployment.  Currently, the only way to use <code>socket</code> is by configuring
your Mirage project for Unix with <code>mirage configure --unix</code>.  This is the mode
you will most often use when developing high-level application logic that doesn't
need to delve into the innards of the network stack (e.g. a REST website).</p>
<p>The <code>direct</code> implementations use the <a href="https://github.com/mirage/mirage-tcpip">mirage-tcpip</a> implementations of the
transport, network, and data link layers.  When you use this stack, all the network
traffic from the Ethernet level up will be handled in pure OCaml.  This means that the
<code>direct</code> stack will work with either a Xen
guest VM (provided there's a valid network configuration for the unikernel's
running environment of course), or a Unix program if there's a valid <a href="https://en.wikipedia.org/wiki/TUN/TAP">tuntap</a> interface.
<code>direct</code> this works with both <code>mirage configure --xen</code> and <code>mirage configure --unix</code>
as long as there is a corresponding available device when the unikernel is run.</p>
<p>There are a few Mirage functions that provide IPv4 (and UDP/TCP) stack
implementations (of type <code>stackv4 impl</code>), usable from your application code.
The <code>stackv4 impl</code> is generated in <code>config.ml</code> by some logic set when the
program is <code>mirage configure</code>'d - often by matching an environment variable.
This means it's easy to flip between different stack implementations when
developing an application just be recompiling the application.  The <code>config.ml</code>
below allows the developer to build socket code with <code>NET=socket make</code> and
direct code with <code>NET=direct make</code>.</p>
<pre><code class="language-OCaml">let main = foreign &quot;Services.Main&quot; (console @-&gt; stackv4 @-&gt; job)

let net =
  try match Sys.getenv &quot;NET&quot; with
    | &quot;direct&quot; -&gt; `Direct
    | &quot;socket&quot; -&gt; `Socket
    | _        -&gt; `Direct
  with Not_found -&gt; `Direct

let dhcp =
  try match Sys.getenv &quot;ADDR&quot; with
    | &quot;dhcp&quot;   -&gt; `Dhcp
    | &quot;static&quot; -&gt; `Static
    | _ -&gt; `Dhcp
  with Not_found -&gt; `Dhcp

let stack console =
  match net, dhcp with
  | `Direct, `Dhcp   -&gt; direct_stackv4_with_dhcp console tap0
  | `Direct, `Static -&gt; direct_stackv4_with_default_ipv4 console tap0
  | `Socket, _       -&gt; socket_stackv4 console [Ipaddr.V4.any]

let () =
  register &quot;services&quot; [
    main $ default_console $ stack default_console
  ]
</code></pre>
<p>Moreover, it's possible to configure multiple stacks individually for use in
the same program, and to <code>register</code> multiple modules from the same <code>config.ml</code>.
This means functions can be written such that they're aware of the network
stack they ought to be using, and no other - a far cry from developing network
code over most socket interfaces, where it can be quite difficult to separate
concerns nicely.</p>
<pre><code class="language-OCaml">let client = foreign &quot;Unikernel.Client&quot; (console @-&gt; stackv4 @-&gt; job)
let server = foreign &quot;Unikernel.Server&quot; (console @-&gt; stackv4 @-&gt; job) 

let client_netif = (netif &quot;0&quot;)
let server_netif = (netif &quot;1&quot;) 

let client_stack = direct_stackv4_with_dhcp default_console client_netif
let server_stack = direct_stackv4_with_dhcp default_console server_netif

let () = 
  register &quot;unikernel&quot; [
    main $ default_console $ client_stack;
    server $ default_console $ server_stack 
  ]

</code></pre>
<h2>Acting on Stacks</h2>
<p>Most network applications will either want to listen for incoming connections
and respond to that traffic with information, or to connect to some remote
host, execute a query, and receive information.  <code>STACKV4</code> offers simple ways
to define functions implementing either of these patterns.</p>
<h3>Establishing and Communicating Across Connections</h3>
<p><code>STACKV4</code> offers <code>listen_tcpv4</code> and <code>listen_udpv4</code> functions for establishing
listeners on specific ports.  Both take a <code>stack impl</code>, a named <code>port</code>, and a
<code>callback</code> function.</p>
<p>For UDP listeners, which are datagram-based rather than connection-based,
<code>callback</code> is a function of the source IP, destination IP, source port, and the
<code>Cstruct.t</code> that contains the payload data.  Applications that wish to respond
to incoming UDP packets with their own UDP responses (e.g., DNS servers) can
use this information to construct reply packets and send them with
<code>UDPV4.write</code> from within the callback function.</p>
<p>For TCP listeners, <code>callback</code> is a function of <code>TCPV4.flow -&gt; unit Lwt.t</code>.  <code>STACKV4.TCPV4</code> offers <code>read</code>, <code>write</code>, and <code>close</code> on <code>flow</code>s for application writers to build higher-level protocols on top of.</p>
<p><code>TCPV4</code> also offers <code>create_connection</code>, which allows client application code to establish TCP connections with remote servers.  In success cases, <code>create_connection</code> returns a <code>TCPV4.flow</code>, which can be acted on just as the data in a <code>callback</code> above.  There's also a polymorphic variant for error conditions, such as an unreachable remote server.</p>
<h3>A Simple Example</h3>
<p>Some very simple examples of user-level TCP code are included in <a href="https://github.com/mirage/mirage-tcpip/tree/master/examples">mirage-tcpip/examples</a>.  <code>config.ml</code> is identical to the first configuration example above, and will build a <code>direct</code> stack by default.</p>
<p>Imagine a very simple application - one which simply repeats any data back to the sender, until the sender gets bored and wanders off (<a href="https://en.wikipedia.org/wiki/Echo_Protocol">RFC 862</a>, for the curious).</p>
<pre><code class="language-OCaml">open Lwt
open V1_LWT

module Main (C: V1_LWT.CONSOLE) (S: V1_LWT.STACKV4) = struct
  let report_and_close c flow message =
    C.log c message;
    S.TCPV4.close flow

  let rec echo c flow =
    S.TCPV4.read flow &gt;&gt;= fun result -&gt; (
      match result with  
        | `Eof -&gt; report_and_close c flow &quot;Echo connection closure initiated.&quot;
        | `Error e -&gt; 
          let message = 
          match e with 
            | `Timeout -&gt; &quot;Echo connection timed out; closing.\\n&quot;
            | `Refused -&gt; &quot;Echo connection refused; closing.\\n&quot;
            | `Unknown s -&gt; (Printf.sprintf &quot;Echo connection error: %s\\n&quot; s)
             in
          report_and_close c flow message
        | `Ok buf -&gt;
            S.TCPV4.write flow buf &gt;&gt;= fun () -&gt; echo c flow
        ) 

  let start c s = 
    S.listen_tcpv4 s ~port:7 (echo c);
    S.listen s

end
</code></pre>
<p>All the application programmer needs to do is define functionality in relation to <code>flow</code> for sending and receiving data, establish this function as a callback with <code>listen_tcpv4</code>, and start a listening thread with <code>listen</code>.</p>
<h2>More Complex Uses</h2>
<p>An OCaml HTTP server, <a href="http://www.github.com/mirage/ocaml-cohttp">Cohttp</a>, is currently powering this very blog.  A simple static webserver using Cohttp <a href="https://github.com/mirage/mirage-skeleton/tree/master/static_website">is included in <code>mirage-skeleton</code></a>.</p>
<p><a href="https://tls.nqsb.io/">The OCaml-TLS demonstration server</a> announced here <a href="http://mirage.io/blog/introducing-ocaml-tls">just a few days ago</a> is also running atop Cohttp - <a href="https://github.com/mirleft/tls-demo-server">source is available on Github</a>.</p>
<h2>The future</h2>
<p>Mirage's TCP/IP stack is under active development!  <a href="https://github.com/mirage/mirage-tcpip/search?q=TODO&amp;ref=cmdform">Some low-level details</a> are still stubbed out, and we're working on implementing some of the trickier corners of TCP, as well as <a href="http://somerandomidiot.com/blog/2014/05/22/throwing-some-fuzzy-dice/">doing automated testing</a> on the stack.  We welcome testing tools, bug reports, bug fixes, and new protocol implementations!</p>

      
