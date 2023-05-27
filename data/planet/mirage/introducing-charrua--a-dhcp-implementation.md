---
title: "Introducing Charrua \u2014 a DHCP implementation"
description:
url: https://mirage.io/blog/introducing-charrua-dhcp
date: 2015-12-29T00:00:00-00:00
preview_image:
featured:
authors:
- Christiano Haesbaert
---


        <p>Almost every network needs to support
<a href="https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol">DHCP</a>
(Dynamic
Host Configuration Protocol), that is, a way for clients to request network
parameters from the environment. Common parameters are an IP address, a network
mask, a default gateway and so on.</p>
<p>DHCP can be seen as a critical security component, since it deals usually with
unauthenticated/unknown peers, therefore it is of special interest to run a
server as a self-contained MirageOS unikernel.</p>
<p><a href="http://www.github.com/haesbaert/charrua-core">Charrua</a> is a DHCP implementation
written in OCaml and it started off as an excuse to learn more about the language.
While in development it got picked up on the MirageOS mailing lists and became one
of the <a href="https://github.com/mirage/mirage-www/wiki/Pioneer-Projects">Pioneer
Projects</a>.</p>
<p>The name <code>Charrua</code> is a reference to the, now extinct, semi-nomadic people of
southern South America &mdash; nowadays it is also used to refer to Uruguayan
nationals. The logic is that DHCP handles dynamic (hence nomadic) clients.</p>
<p>The library is platform agnostic and works outside of MirageOS as well. It
provides two main modules:
<a href="http://haesbaert.github.io/charrua-core/api/Dhcp_wire.html">Dhcp_wire</a> and
<a href="http://haesbaert.github.io/charrua-core/api/Dhcp_server.html">Dhcp_server</a>.</p>
<h3>Dhcp_wire</h3>
<p><a href="http://haesbaert.github.io/charrua-core/api/Dhcp_wire.html">Dhcp_wire</a> provides
basic functions for dealing with the protocol, essentially
marshalling/unmarshalling and helpers for dealing with the various DHCP options.</p>
<p>The central record type of
<a href="http://haesbaert.github.io/charrua-core/api/Dhcp_wire.html">Dhcp_wire</a> is a
<a href="http://haesbaert.github.io/charrua-core/api/Dhcp_wire.html#TYPEpkt">pkt</a>, which
represents a full DHCP packet, including layer 2 and layer 3 data as well as the
many possible DHCP options. The most important functions are:</p>
<pre><code class="language-ocaml">val pkt_of_buf : Cstruct.t -&gt; int -&gt; [&gt; `Error of string | `Ok of pkt ]
val buf_of_pkt : pkt -&gt; Cstruct.t
</code></pre>
<p><a href="http://haesbaert.github.io/charrua-core/api/Dhcp_wire.html#VALpkt_of_buf">pkt_of_buf</a> takes
a <a href="https://github.com/mirage/ocaml-cstruct">Cstruct.t</a> buffer and a length and it
then attempts to build a DHCP packet. Unknown DHCP options are ignored, invalid
options or malformed data are not accepted and you get an <code> `Error of string</code>.</p>
<p><a href="http://haesbaert.github.io/charrua-core/api/Dhcp_wire.html#VALbuf_of_pkt">buf_of_pkt</a> is
the mirror function, but it never fails.  It could for instance fail in case of
two duplicate DHCP options, but that would imply too much policy in a
marshalling function.</p>
<p>The DHCP options from RFC2132 are implemented in
<a href="http://haesbaert.github.io/charrua-core/api/Dhcp_wire.html#TYPEdhcp_option">dhcp_option</a>.
There are more, but the most common ones look like this:</p>
<pre><code class="language-ocaml">type dhcp_option =
  | Subnet_mask of Ipaddr.V4.t
  | Time_offset of int32
  | Routers of Ipaddr.V4.t list
  | Time_servers of Ipaddr.V4.t list
  | Name_servers of Ipaddr.V4.t list
  | Dns_servers of Ipaddr.V4.t list
  | Log_servers of Ipaddr.V4.t list
</code></pre>
<h3>Dhcp_server</h3>
<p><a href="http://haesbaert.github.io/charrua-core/api/Dhcp_server.html">Dhcp_server</a>
Provides a library for building a DHCP server and is divided into two sub-modules:
<a href="http://haesbaert.github.io/charrua-core/api/Dhcp_server.Config.html">Config</a>,
which handles the building of a suitable DHCP server configuration record and
<a href="http://haesbaert.github.io/charrua-core/api/Dhcp_server.Config.html">Input</a>,
which handles the input of DHCP packets.</p>
<p>The logic is modelled in a pure functional style and
<a href="http://haesbaert.github.io/charrua-core/api/Dhcp_server.html">Dhcp_server</a> does
not perform any IO of its own. It works by taking an input
<a href="http://haesbaert.github.io/charrua-core/api/Dhcp_wire.html#TYPEpkt">packet</a>,
a
<a href="http://haesbaert.github.io/charrua-core/api/Dhcp_server.Config.html#TYPEt">configuration</a>
and returns a possible reply to be sent by the caller, or an error/warning:</p>
<h4>Input</h4>
<pre><code class="language-ocaml">type result = 
| Silence                 (* Input packet didn't belong to us, normal nop event. *)
| Reply of Dhcp_wire.pkt  (* A reply packet to be sent on the same subnet. *)
| Warning of string       (* An odd event, could be logged. *)
| Error of string         (* Input packet is invalid, or some other error ocurred. *)

val input_pkt : Dhcp_server.Config.t -&gt; Dhcp_server.Config.subnet -&gt;
   Dhcp_wire.pkt -&gt; float -&gt; result
(** input_pkt config subnet pkt time Inputs packet pkt, the resulting action
    should be performed by the caller, normally a Reply packet is returned and
    must be sent on the same subnet. time is a float representing time as in
    Unix.time or MirageOS's Clock.time. **)
</code></pre>
<p>A typical main server loop would work by:</p>
<ol>
<li>Reading a packet from the network.
</li>
<li>Unmarshalling with <a href="http://haesbaert.github.io/charrua-core/api/Dhcp_wire.html#VALpkt_of_buf">Dhcp_wire.pkt_of_buf</a>.
</li>
<li>Inputting the result with <a href="http://haesbaert.github.io/charrua-core/api/Dhcp_server.Input.html#VALinput_pkt">Dhcp_server.Input.input_pkt</a>.
</li>
<li>Sending the reply, or logging the event from the <a href="http://haesbaert.github.io/charrua-core/api/Dhcp_server.Input.html#VALinput_pkt">Dhcp_server.Input.input_pkt</a> call.
</li>
</ol>
<p>A mainloop example can be found in
<a href="https://github.com/mirage/mirage-skeleton/blob/master/dhcp/unikernel.ml#L28">mirage-skeleton</a>:</p>
<pre><code class="language-ocaml">  let input_dhcp c net config subnet buf =
    let open Dhcp_server.Input in
    match (Dhcp_wire.pkt_of_buf buf (Cstruct.len buf)) with
    | `Error e -&gt; Lwt.return (log c (red &quot;Can't parse packet: %s&quot; e))
    | `Ok pkt -&gt;
      match (input_pkt config subnet pkt (Clock.time ())) with
      | Silence -&gt; Lwt.return_unit
      | Warning w -&gt; Lwt.return (log c (yellow &quot;%s&quot; w))
      | Error e -&gt; Lwt.return (log c (red &quot;%s&quot; e))
      | Reply reply -&gt;
        log c (blue &quot;Received packet %s&quot; (Dhcp_wire.pkt_to_string pkt));
        N.write net (Dhcp_wire.buf_of_pkt reply)
        &gt;&gt;= fun () -&gt;
        log c (blue &quot;Sent reply packet %s&quot; (Dhcp_wire.pkt_to_string reply));
        Lwt.return_unit
</code></pre>
<p>As stated,
<a href="http://haesbaert.github.io/charrua-core/api/Dhcp_server.Input.html#VALinput_pkt">Dhcp_server.Input.input_pkt</a>
does not perform any IO of its own, it only deals with the logic of analyzing a
DHCP packet and building a possible answer, which should then be sent by the
caller. This allows a design where all the side effects are controlled in one
small chunk, which makes it easier to understand the state transitions since they
are made explicit.</p>
<p>At the time of this writing,
<a href="http://haesbaert.github.io/charrua-core/api/Dhcp_server.Input.html#VALinput_pkt">Dhcp_server.Input.input_pkt</a>
is not side effect free, as it manipulates a database of leases, this will be
changed in the next version to be pure as well.</p>
<p>Storing leases in permanent storage is also unsupported at this time and
should be available soon, with Irmin and other backends. The main idea is to
always return a new lease database for each input, or maybe just the updates to
be applied, and in this scenario, the caller would be able to store the database in
permanent storage as he sees fit.</p>
<h4>Configuration</h4>
<p>This project started independently of MirageOS and at that time, the best
configuration I could think of was the well known <code>ISC</code> <code>dhcpd.conf</code>. Therefore,
the configuration uses the same format but it does not support the myriad of
options of the original one.</p>
<pre><code class="language-ocaml">  type t = {
    addresses : (Ipaddr.V4.t * Macaddr.t) list;
    subnets : subnet list;
    options : Dhcp_wire.dhcp_option list;
    hostname : string;
    default_lease_time : int32;
    max_lease_time : int32;
  }

  val parse : string -&gt; (Ipaddr.V4.Prefix.addr * Macaddr.t) list -&gt; t
  (** [parse cf l] Creates a server configuration by parsing [cf] as an ISC
      dhcpd.conf file, currently only the options at [sample/dhcpd.conf] are
      supported. [l] is a list of network addresses, each pair is the output
      address to be used for building replies and each must match a [network
      section] of [cf]. A normal usage would be a list of all interfaces
      configured in the system *)
</code></pre>
<p>Although it is a great format, it doesn't exactly play nice with MirageOS and
OCaml, since the unikernel needs to parse a string at runtime to build the
configuration, this requires a file IO backend and other complications. The
next version should provide OCaml helpers for building the configuration, which
would drop the requirements of a file IO backend and facilitate writing tests.</p>
<h3>Building a simple server</h3>
<p>The easiest way is to follow the <a href="https://github.com/mirage/mirage-skeleton/blob/master/dhcp/README.md">mirage-skeleton DHCP
README</a>.</p>
<h3>Future</h3>
<p>The next steps would be:</p>
<ul>
<li>Provide helpers for building the configuration.
</li>
<li>Expose the lease database in an immutable structure, possibly a <code>Map</code>, adding
also support/examples for <a href="https://github.com/mirage/irmin">Irmin</a>.
</li>
<li>Use <a href="https://github.com/mirage/functoria">Functoria</a> to pass down the
configuration in <a href="https://github.com/mirage/mirage-skeleton/blob/master/dhcp/README.md">mirage-skeleton</a>. Currently
it is awkward since the user has to edit <code>unikernel.ml</code> and <code>config.ml</code>, with
<a href="https://github.com/mirage/functoria">Functoria</a> we would be able to have it
much nicer and only touch <code>config.ml</code>.
</li>
<li>Convert MirageOS DHCP client code to use <a href="http://haesbaert.github.io/charrua-core/api/Dhcp_wire.html">Dhcp_wire</a>, or perhaps add a
client logic functionality to <a href="http://www.github.com/haesbaert/charrua-core">Charrua</a>.
</li>
</ul>
<h3>Finishing words</h3>
<p>This is my first real project in OCaml and I'm more or less a newcomer to
functional programming as well, my background is mostly kernel hacking as an
ex-OpenBSD developer.
I'd love to hear how people are actually using it and any problems they're
finding, so please do let me know via the
<a href="https://github.com/haesbaert/charrua-core/issues">issue tracker</a>!</p>
<p>Prior to this project I had no contact with any of the MirageOS folks, but I'm
amazed about how easy the interaction and communication with the community has been,
everyone has been incredibly friendly and supportive. I'd say MirageOS is a gold
project for anyone wanting to work with smart people and hack OCaml.</p>
<p>My many thanks to <a href="http://anil.recoil.org">Anil</a>, <a href="http://mort.io">Richard</a>, <a href="https://github.com/hannesm">Hannes</a>, <a href="https://twitter.com/amirmc">Amir</a>, Scott, Gabriel and others.
Thanks also to <a href="http://roscidus.com/blog/">Thomas</a> and <a href="https://github.com/Chris00/">Christophe</a> for comments on this post.
I also
would like to thank my <a href="https://www.genua.de">employer</a> for letting me work on this
project in our hackathons.</p>

      
