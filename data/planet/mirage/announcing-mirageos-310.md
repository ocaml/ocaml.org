---
title: Announcing MirageOS 3.10
description:
url: https://mirage.io/blog/announcing-mirage-310-release
date: 2020-12-08T00:00:00-00:00
preview_image:
featured:
authors:
- Hannes Mehnert
---


        <p>IPv6 and dual (IPv4 and IPv6) stack support https://github.com/mirage/mirage/pull/1187 https://github.com/mirage/mirage/issues/1190</p>
<p>Since a long time, IPv6 code was around in our TCP/IP stack (thanks to @nojb who developed it in 2014). Some months ago, @hannesm and @MagnusS got excited to use it. After we managed to fix some bugs and add some test cases, and writing more code to setup IPv6-only and dual stacks, we are eager to share this support for MirageOS in a released version. We expect there to be bugs lingering around, but duplicate address detection (neighbour solicitation and advertisements) has been implemented, and (unless &quot;--accept-router-advertisement=false&quot;) router advertisements are decoded and used to configure the IPv6 part of the stack. Configuring a static IPv6 address is also possible (with
&quot;--ipv6=2001::42/64&quot;).</p>
<p>While at it, we unified the boot arguments between the different targets: namely, on Unix (when using the socket stack), you can now pass &quot;--ipv4=127.0.0.1/24&quot; to the same effect as the direct stack: only listen on 127.0.0.1 (the subnet mask is ignored for the Unix socket stack).</p>
<p>A dual stack unikernel has &quot;--ipv4-only=BOOL&quot; and &quot;--ipv6-only=BOOL&quot; parameters, so a unikernel binary could support both Internet Protocol versions, while the operator can decide which protocol version to use. I.e. now there are both development-time (stackv4 vs stackv6 vs stackv4v6) choices, as well as the run-time choice (via boot parameter).</p>
<p>I'm keen to remove the stackv4 &amp; stackv6 in future versions, and always develop with dual stack (leaving it to configuration &amp; startup time to decide whether to enable ipv4 and ipv6).</p>
<p>Please also note that the default IPv4 network configuration no longer uses 10.0.0.1 as default gateway (since there was no way to unset the default gateway https://github.com/mirage/mirage/issues/1147).</p>
<p>For unikernel developers, there are some API changes in the Mirage module</p>
<ul>
<li>New &quot;v4v6&quot; types for IP protocols and stacks
</li>
<li>The ipv6_config record was adjusted in the same fashion as the ipv4_config type: it is now a record of a network (V6.Prefix.t) and gateway (V6.t option)
</li>
</ul>
<p>Some parts of the Mirage_key module were unified as well:</p>
<ul>
<li>Arp.ip_address is available (for a dual Ipaddr.t)
</li>
<li>Arg.ipv6_address replaces Arg.ipv6 (for an Ipaddr.V6.t)
</li>
<li>Arg.ipv6 replaces Arg.ipv6_prefix (for a Ipaddr.V6.Prefix.t)
</li>
<li>V6.network and V6.gateway are available, mirroring the V4 submodule
</li>
</ul>
<p>If you're ready to experiment with the dual stack: below is a diff for our basic network example (from mirage-skeleton/device-usage/network) replacing IPv4 with a dual stack, and the tlstunnel unikernel commit
https://github.com/roburio/tlstunnel/commit/2cb3e5aa11fca4b48bb524f3c0dbb754a6c8739b
changed tlstunnel from IPv4 stack to dual stack.</p>
<pre><code class="language-diff">diff --git a/device-usage/network/config.ml b/device-usage/network/config.ml
index c425edb..eabc9d6 100644
--- a/device-usage/network/config.ml
+++ b/device-usage/network/config.ml
@@ -4,9 +4,9 @@ let port =
   let doc = Key.Arg.info ~doc:&quot;The TCP port on which to listen for
incoming connections.&quot; [&quot;port&quot;] in
   Key.(create &quot;port&quot; Arg.(opt int 8080 doc))

-let main = foreign ~keys:[Key.abstract port] &quot;Unikernel.Main&quot; (stackv4
@-&gt; job)
+let main = foreign ~keys:[Key.abstract port] &quot;Unikernel.Main&quot;
(stackv4v6 @-&gt; job)

-let stack = generic_stackv4 default_network
+let stack = generic_stackv4v6 default_network

 let () =
   register &quot;network&quot; [
diff --git a/device-usage/network/unikernel.ml
b/device-usage/network/unikernel.ml
index 5d29111..1bf1228 100644
--- a/device-usage/network/unikernel.ml
+++ b/device-usage/network/unikernel.ml
@@ -1,19 +1,19 @@
 open Lwt.Infix

-module Main (S: Mirage_stack.V4) = struct
+module Main (S: Mirage_stack.V4V6) = struct

   let start s =
     let port = Key_gen.port () in
-    S.listen_tcpv4 s ~port (fun flow -&gt;
-        let dst, dst_port = S.TCPV4.dst flow in
+    S.listen_tcp s ~port (fun flow -&gt;
+        let dst, dst_port = S.TCP.dst flow in
         Logs.info (fun f -&gt; f &quot;new tcp connection from IP %s on port %d&quot;
-                  (Ipaddr.V4.to_string dst) dst_port);
-        S.TCPV4.read flow &gt;&gt;= function
+                  (Ipaddr.to_string dst) dst_port);
+        S.TCP.read flow &gt;&gt;= function
         | Ok `Eof -&gt; Logs.info (fun f -&gt; f &quot;Closing connection!&quot;);
Lwt.return_unit
-        | Error e -&gt; Logs.warn (fun f -&gt; f &quot;Error reading data from
established connection: %a&quot; S.TCPV4.pp_error e); Lwt.return_unit
+        | Error e -&gt; Logs.warn (fun f -&gt; f &quot;Error reading data from
established connection: %a&quot; S.TCP.pp_error e); Lwt.return_unit
         | Ok (`Data b) -&gt;
           Logs.debug (fun f -&gt; f &quot;read: %d bytes:\\n%s&quot; (Cstruct.len b)
(Cstruct.to_string b));
-          S.TCPV4.close flow
+          S.TCP.close flow
       );

     S.listen s
</code></pre>
<p>Other bug fixes include https://github.com/mirage/mirage/issues/1188 (in https://github.com/mirage/mirage/pull/1201) and adapt to charrua 1.3.0 and arp 2.3.0 changes (https://github.com/mirage/mirage/pull/1199).</p>

      
