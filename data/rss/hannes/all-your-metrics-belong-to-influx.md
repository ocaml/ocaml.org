---
title: All your metrics belong to influx
description:
url: https://hannes.robur.coop/Posts/Monitoring
date: 2022-03-08T11:26:31-00:00
preview_image:
featured:
---

<h1>Introduction to monitoring</h1>
<p>At <a href="https://robur.coop">robur</a> we use a range of MirageOS unikernels. Recently, we worked on improving the operations story thereof. One part is shipping binaries using our <a href="https://builds.robur.coop">reproducible builds infrastructure</a>. Another part is, once deployed we want to observe what is going on.</p>
<p>I first got into touch with monitoring - collecting and graphing metrics - with <a href="https://oss.oetiker.ch/mrtg/">MRTG</a> and <a href="https://munin-monitoring.org/">munin</a> - and the simple network management protocol <a href="https://en.wikipedia.org/wiki/Simple_Network_Management_Protocol">SNMP</a>. From the whole system perspective, I find it crucial that the monitoring part of a system does not add pressure. This favours a push-based design, where reporting is done at the disposition of the system.</p>
<p>The rise of monitoring where graphs are done dynamically (such as <a href="https://grafana.com/">Grafana</a>) and can be programmed (with a query language) by the operator are very neat, it allows to put metrics in relation after they have been recorded - thus if there's a thesis why something went berserk, you can graph the collected data from the past and prove or disprove the thesis.</p>
<h1>Monitoring a MirageOS unikernel</h1>
<p>From the operational perspective, taking security into account - either the data should be authenticated and integrity-protected, or being transmitted on a private network. We chose the latter, there's a private network interface only for monitoring. Access to that network is only granted to the unikernels and metrics collector.</p>
<p>For MirageOS unikernels, we use the <a href="https://github.com/mirage/metrics">metrics</a> library - which design shares the idea of <a href="https://erratique.ch/software/logs">logs</a> that only if there's a reporter registered, work is performed.  We use the Influx line protocol via TCP to report via <a href="https://www.influxdata.com/time-series-platform/telegraf/">Telegraf</a> to <a href="https://www.influxdata.com/">InfluxDB</a>. But due to the design of <a href="https://github.com/mirage/metrics">metrics</a>, other reporters can be developed and used -- prometheus, SNMP, your-other-favourite are all possible.</p>
<p>Apart from monitoring metrics, we use the same network interface for logging via syslog. Since the logs library separates the log message generation (in the OCaml libraries) from the reporting, we developed <a href="https://github.com/hannesm/logs-syslog">logs-syslog</a>, which registers a log reporter sending each log message to a syslog sink.</p>
<p>We developed a small library for metrics reporting of a MirageOS unikernel into the <a href="https://github.com/roburio/monitoring-experiments">monitoring-experiments</a> package - which also allows to dynamically adjust log level and disable or enable metrics sources.</p>
<h2>Required components</h2>
<p>Install from your operating system the packages providing telegraf, influxdb, and grafana.</p>
<p>Setup telegraf to contain a socket listener:</p>
<pre><code>[[inputs.socket_listener]]
  service_address = &quot;tcp://192.168.42.14:8094&quot;
  keep_alive_period = &quot;5m&quot;
  data_format = &quot;influx&quot;
</code></pre>
<p>Use a unikernel that reports to Influx (below the heading &quot;Unikernels (with metrics reported to Influx)&quot; on <a href="https://builds.robur.coop">builds.robur.coop</a>) and provide <code>--monitor=192.168.42.14</code> as boot parameter. Conventionally, these unikernels expect a second network interface (on the &quot;management&quot; bridge) where telegraf (and a syslog sink) are running. You'll need to pass <code>--net=management</code> and <code>--arg='--management-ipv4=192.168.42.x/24'</code> to albatross-client-local.</p>
<p>Albatross provides a <code>albatross-influx</code> daemon that reports information from the host system about the unikernels to influx. Start it with <code>--influx=192.168.42.14</code>.</p>
<h2>Adding monitoring to your unikernel</h2>
<p>If you want to extend your own unikernel with metrics, follow along these lines.</p>
<p>An example is the <a href="https://github.com/roburio/dns-primary-git">dns-primary-git</a> unikernel, where on the branch <code>future</code> we have a single commit ahead of main that adds monitoring. The difference is in the unikernel configuration and the main entry point. See the <a href="https://builds.robur.coop/job/dns-primary-git-monitoring/build/latest/">binary builts</a> in contrast to the <a href="https://builds.robur.coop/job/dns-primary-git/build/latest/">non-monitoring builts</a>.</p>
<p>In config, three new command line arguments are added: <code>--monitor=IP</code>, <code>--monitor-adjust=PORT</code> <code>--syslog=IP</code> and <code>--name=STRING</code>. In addition, the package <code>monitoring-experiments</code> is required. And a second network interface <code>management_stack</code> using the prefix <code>management</code> is required and passed to the unikernel. Since the syslog reporter requires a console (to report when logging fails), also a console is passed to the unikernel. Each reported metrics includes a tag <code>vm=&lt;name&gt;</code> that can be used to distinguish several unikernels reporting to the same InfluxDB.</p>
<p>Command line arguments:</p>
<pre><code class="language-patch">   let doc = Key.Arg.info ~doc:&quot;The fingerprint of the TLS certificate.&quot; [ &quot;tls-cert-fingerprint&quot; ] in
   Key.(create &quot;tls_cert_fingerprint&quot; Arg.(opt (some string) None doc))
 
+let monitor =
+  let doc = Key.Arg.info ~doc:&quot;monitor host IP&quot; [&quot;monitor&quot;] in
+  Key.(create &quot;monitor&quot; Arg.(opt (some ip_address) None doc))
+
+let monitor_adjust =
+  let doc = Key.Arg.info ~doc:&quot;adjust monitoring (log level, ..)&quot; [&quot;monitor-adjust&quot;] in
+  Key.(create &quot;monitor_adjust&quot; Arg.(opt (some int) None doc))
+
+let syslog =
+  let doc = Key.Arg.info ~doc:&quot;syslog host IP&quot; [&quot;syslog&quot;] in
+  Key.(create &quot;syslog&quot; Arg.(opt (some ip_address) None doc))
+
+let name =
+  let doc = Key.Arg.info ~doc:&quot;Name of the unikernel&quot; [&quot;name&quot;] in
+  Key.(create &quot;name&quot; Arg.(opt string &quot;ns.nqsb.io&quot; doc))
+
 let mimic_impl random stackv4v6 mclock pclock time =
   let tcpv4v6 = tcpv4v6_of_stackv4v6 $ stackv4v6 in
   let mhappy_eyeballs = mimic_happy_eyeballs $ random $ time $ mclock $ pclock $ stackv4v6 in
</code></pre>
<p>Requiring <code>monitoring-experiments</code>, registering command line arguments:</p>
<pre><code class="language-patch">     package ~min:&quot;3.7.0&quot; ~max:&quot;3.8.0&quot; &quot;git-mirage&quot;;
     package ~min:&quot;3.7.0&quot; &quot;git-paf&quot;;
     package ~min:&quot;0.0.8&quot; ~sublibs:[&quot;mirage&quot;] &quot;paf&quot;;
+    package &quot;monitoring-experiments&quot;;
+    package ~sublibs:[&quot;mirage&quot;] ~min:&quot;0.3.0&quot; &quot;logs-syslog&quot;;
   ] in
   foreign
-    ~keys:[Key.abstract remote_k ; Key.abstract axfr]
+    ~keys:[
+      Key.abstract remote_k ; Key.abstract axfr ;
+      Key.abstract name ; Key.abstract monitor ; Key.abstract monitor_adjust ; Key.abstract syslog
+    ]
     ~packages
</code></pre>
<p>Added console and a second network stack to <code>foreign</code>:</p>
<pre><code class="language-patch">     &quot;Unikernel.Main&quot;
-    (random @-&gt; pclock @-&gt; mclock @-&gt; time @-&gt; stackv4v6 @-&gt; mimic @-&gt; job)
+    (console @-&gt; random @-&gt; pclock @-&gt; mclock @-&gt; time @-&gt; stackv4v6 @-&gt; mimic @-&gt; stackv4v6 @-&gt; job)
+
</code></pre>
<p>Passing a console implementation (<code>default_console</code>) and a second network stack (with <code>management</code> prefix) to <code>register</code>:</p>
<pre><code class="language-patch">+let management_stack = generic_stackv4v6 ~group:&quot;management&quot; (netif ~group:&quot;management&quot; &quot;management&quot;)
 
 let () =
   register &quot;primary-git&quot;
-    [dns_handler $ default_random $ default_posix_clock $ default_monotonic_clock $
-     default_time $ net $ mimic_impl]
+    [dns_handler $ default_console $ default_random $ default_posix_clock $ default_monotonic_clock $
+     default_time $ net $ mimic_impl $ management_stack]
</code></pre>
<p>Now, in the unikernel module the functor changes (console and second network stack added):</p>
<pre><code class="language-patch">@@ -4,17 +4,48 @@
 
 open Lwt.Infix
 
-module Main (R : Mirage_random.S) (P : Mirage_clock.PCLOCK) (M : Mirage_clock.MCLOCK) (T : Mirage_time.S) (S : Mirage_stack.V4V6) (_ : sig e
nd) = struct
+module Main (C : Mirage_console.S) (R : Mirage_random.S) (P : Mirage_clock.PCLOCK) (M : Mirage_clock.MCLOCK) (T : Mirage_time.S) (S : Mirage
_stack.V4V6) (_ : sig end) (Management : Mirage_stack.V4V6) = struct
 
   module Store = Irmin_mirage_git.Mem.KV(Irmin.Contents.String)
   module Sync = Irmin.Sync(Store)
</code></pre>
<p>And in the <code>start</code> function, the command line arguments are processed and used to setup syslog and metrics monitoring to the specified addresses. Also, a TCP listener is waiting for monitoring and logging adjustments if <code>--monitor-adjust</code> was provided:</p>
<pre><code class="language-patch">   module D = Dns_server_mirage.Make(P)(M)(T)(S)
+  module Monitoring = Monitoring_experiments.Make(T)(Management)
+  module Syslog = Logs_syslog_mirage.Udp(C)(P)(Management)
 
-  let start _rng _pclock _mclock _time s ctx =
+  let start c _rng _pclock _mclock _time s ctx management =
+    let hostname = Key_gen.name () in
+    (match Key_gen.syslog () with
+     | None -&gt; Logs.warn (fun m -&gt; m &quot;no syslog specified, dumping on stdout&quot;)
+     | Some ip -&gt; Logs.set_reporter (Syslog.create c management ip ~hostname ()));
+    (match Key_gen.monitor () with
+     | None -&gt; Logs.warn (fun m -&gt; m &quot;no monitor specified, not outputting statistics&quot;)
+     | Some ip -&gt; Monitoring.create ~hostname ?listen_port:(Key_gen.monitor_adjust ()) ip management);
     connect_store ctx &gt;&gt;= fun (store, upstream) -&gt;
     load_git None store upstream &gt;&gt;= function
     | Error (`Msg msg) -&gt;
</code></pre>
<p>Once you compiled the unikernel (or downloaded a binary with monitoring), and start that unikernel by passing <code>--net:service=tap0</code> and <code>--net:management=tap10</code> (or whichever your <code>tap</code> interfaces are), and as unikernel arguments <code>--ipv4=&lt;my-ip-address&gt;</code> and <code>--management-ipv4=192.168.42.2/24</code> for IPv4 configuration, <code>--monitor=192.168.42.14</code>, <code>--syslog=192.168.42.10</code>, <code>--name=my.unikernel</code>, <code>--monitor-adjust=12345</code>.</p>
<p>With this, your unikernel will report metrics using the influx protocol to 192.168.42.14 on port 8094 (every 10 seconds), and syslog messages via UDP to 192.168.0.10 (port 514). You should see your InfluxDB getting filled and syslog server receiving messages.</p>
<p>When you configure <a href="https://grafana.com/docs/grafana/latest/getting-started/getting-started-influxdb/">Grafana to use InfluxDB</a>, you'll be able to see the data in the data sources.</p>
<p>Please reach out to us (at team AT robur DOT coop) if you have feedback and suggestions.</p>

