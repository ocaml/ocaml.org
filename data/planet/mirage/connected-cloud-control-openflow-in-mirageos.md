---
title: 'Connected Cloud Control: OpenFlow in MirageOS'
description:
url: https://mirage.io/blog/announcing-mirage-openflow
date: 2012-02-29T00:00:00-00:00
preview_image:
featured:
authors:
- Richard Mortier
---


        <p><strong>Due to continuing development, some of the details in this blog post are now out-of-date. It is archived here.</strong></p>
<p>Something we've been working on for a little while now that we're pretty
excited about is an <a href="http://openflow.org/">OpenFlow</a> implementation for
MirageOS. For those who're not networking types, in short, OpenFlow is a
protocol and framework for devolving network control to software running on
platforms other than the network elements themselves. It consists of three
main parts:</p>
<ul>
<li>a <em>controller</em>, responsible for exercising control over the network;
</li>
<li><em>switches</em>, consisting of switching hardware, with flow tables that apply
forwarding behaviours to matching packets; and
</li>
<li>the <em>protocol</em>, by which controllers and switches communicate.
</li>
</ul>
<p>For more -- and far clearer! -- explanations, see any of the many online
OpenFlow resources such as <a href="http://openflowhub.org">OpenFlowHub</a>.</p>
<p>Within MirageOS we have an OpenFlow implementation in two parts: individual
libraries that provide controller and switch functionality. Linking the switch
library enables your application to become a software-based OpenFlow switch.
Linking in the controller library enables your application to exercise direct
control over OpenFlow network elements.</p>
<p>The controller is modelled after the <a href="http://noxrepo.org/">NOX</a> open-source
controller and currently provides only relatively low-level access to the
OpenFlow primitives: a very cool thing to build on top of it would be a
higher-level abstraction such as that provided by
<a href="http://haskell.cs.yale.edu/?page_id=376">Nettle</a> or
<a href="http://www.frenetic-lang.org/">Frenetic</a>.</p>
<p>The switch is primarily intended as an experimental platform -- it is
hopefully easier to extend than some of the existing software switches while
still being sufficiently high performance to be interesting!</p>
<p>By way of a sample of how it fits together, here's a skeleton for a simple
controller application:</p>
<pre><code class="language-ocaml">type mac_switch = {
  addr: OP.eaddr; 
  switch: OP.datapath_id;
}

type switch_state = {
  mutable mac_cache: 
        (mac_switch, OP.Port.t) Hashtbl.t;
  mutable dpid: OP.datapath_id list
}

let switch_data = {
  mac_cache = Hashtbl.create 7; 
  dpid = [];
} 

let join_cb controller dpid evt =
  let dp = match evt with
      | OE.Datapath_join c -&gt; c
      | _ -&gt; invalid_arg &quot;bogus datapath_join&quot;
  in 
  switch_data.dpid &lt;- switch_data.dpid @ [dp]

let packet_in_cb controller dpid evt =
  (* algorithm details omitted for space *)

let init ctrl = 
  OC.register_cb ctrl OE.DATAPATH_JOIN join_cb;
  OC.register_cb ctrl OE.PACKET_IN packet_in_cb

let main () =
  Net.Manager.create (fun mgr interface id -&gt;
    let port = 6633 in 
    OC.listen mgr (None, port) init
  )
</code></pre>
<p>We've written up some of the gory details of the design, implementation and
performance in a <a href="https://mirage.io/documents/iccsdn12-mirage.pdf">short paper</a> to the
<a href="http://www.ieee-icc.org/">ICC</a>
<a href="http://sdn12.mytestbed.net/">Software Defined Networking</a> workshop. Thanks to
some sterling work by <a href="http://www.cl.cam.ac.uk/~cr409/">Haris</a> and
<a href="mailto:balraj.singh@cl.cam.ac.uk">Balraj</a>, the headline numbers are pretty
good though: the unoptimised Mirage controller implementation is only 30--40%
lower performance than the highly optimised NOX <em>destiny-fast</em> branch, which
drops most of the programmability and flexibility of NOX; but is about <em>six
times</em> higher performance than the fully flexible current NOX release. The
switch's performance  running as a domU virtual machine is indistinguishable
from the current <a href="http://openvswitch.org/">Open vSwitch</a> release.</p>
<p>For more details see <a href="https://mirage.io/documents/iccsdn12-mirage.pdf">the paper</a> or contact
<a href="mailto:mort@cantab.net">Mort</a>,
<a href="mailto:charalampos.rotsos@cl.cam.ac.uk">Haris</a> or
<a href="mailto:anil@recoil.org">Anil</a>. Please do get in touch if you've any comments
or questions, or you do anything interesting with it!</p>

      
