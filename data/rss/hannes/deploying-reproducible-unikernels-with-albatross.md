---
title: Deploying reproducible unikernels with albatross
description:
url: https://hannes.robur.coop/Posts/Albatross
date: 2022-11-17T12:41:11-00:00
preview_image:
featured:
---

<h2>Deploying MirageOS unikernels</h2>
<p>More than five years ago, I posted <a href="https://hannes.robur.coop/Posts/VMM">how to deploy MirageOS unikernels</a>. My motivation to work on this topic is that I'm convinced of reduced complexity, improved security, and more sustainable resource footprint of MirageOS unikernels, and want to ease deployment thereof. More than one year ago, I described <a href="https://hannes.robur.coop/Posts/Deploy">how to deploy reproducible unikernels</a>.</p>
<h2>Albatross</h2>
<p>In recent months we worked hard on the underlying infrastructure: <a href="https://github.com/roburio/albatross">albatross</a>. Albatross is the orchestration system for MirageOS unikernels that use solo5 with <a href="https://github.com/Solo5/solo5/blob/master/docs/architecture.md">hvt or spt tender</a>. It deals with three tasks:</p>
<ul>
<li>unikernel creation (destroyal, restart)
</li>
<li>capturing console output
</li>
<li>collecting metrics in the host system about unikernels
</li>
</ul>
<p>An addition to the above is dealing with multiple tenants on the same machine: remote management of your unikernel fleet via TLS, and resource policies.</p>
<h2>History</h2>
<p>The initial commit of albatross was in May 2017. Back then it replaced the shell scripts and manual <code>scp</code> of unikernel images to the server. Over time it evolved and adapted to new environments. Initially a solo5 unikernel would only know of a single network interface, these days there can be multiple distinguished by name. Initially there was no support for block devices. Only FreeBSD was supported in the early days. Nowadays we built daily packages for Debian, Ubuntu, FreeBSD, and have support for NixOS, and the client side is supported on macOS as well.</p>
<h3>ASN.1</h3>
<p>The communication format between the albatross daemons and clients was changed multiple times. I'm glad that albatross uses ASN.1 as communication format, which makes extension with optional fields easy, and also allows &quot;choice&quot; (the sum type) to be not tagged (the binary is the same as no choice type), thus adding choice to an existing grammar, and preserving the old in the default (untagged) case is a decent solution.</p>
<p>So, if you care about backward and forward compatibility, as we do, since we may be in control of which albatross servers are deployed on our machine, but not what albatross versions the clients are using -- it may be wise to look into ASN.1. Recent efforts (json with schema, ...) may solve similar issues, but ASN.1 is as well very tiny in size.</p>
<h2>What resources does a unikernel need?</h2>
<p>A unikernel is just an operating system for a single service, there can't be much it can need.</p>
<h3>Name</h3>
<p>So, first of all a unikernel has a name, or a handle. This is useful for reporting statistics, but also to specify which console output you're interested in. The name is a string with printable ASCII characters (and dash '-' and dot '.'), with a length up to 64 characters - so yes, you can use an UUID if you like.</p>
<h3>Memory</h3>
<p>Another resource is the amount of memory assigned to the unikernel. This is specified in megabyte (as solo5 does), with the range being 10 (below not even a hello world wants to start) to 1024.</p>
<h3>Arguments</h3>
<p>Of course, you can pass via albatross boot parameters to the unikernel. Albatross doesn't impose any restrictions here, but the lower levels may.</p>
<h3>CPU</h3>
<p>Due to multiple tenants, and side channel attacks, it looked right at the beginning like a good idea to restrict each unikernel to a specific CPU. This way, one tenant may use CPU 5, and another CPU 9 - and they'll not starve each other (best to make sure that these CPUs are in different packages). So, albatross takes a number as the CPU, and executes the solo5 tender within <code>taskset</code>/<code>cpuset</code>.</p>
<h3>Fail behaviour</h3>
<p>In normal operations, exceptional behaviour may occur. I have to admit that I've seen MirageOS unikernels that suffer from not freeing all the memory they have allocated. To avoid having to get up at 4 AM just to start the unikernel that went out of memory, there's the possibility to restart the unikernel when it exited. You can even specify on which exit codes it should be restarted (the exit code is the only piece of information we have from the outside what caused the exit). This feature was implemented in October 2019, and has been very precious since then. :)</p>
<h3>Network</h3>
<p>This becomes a bit more complex: a MirageOS unikernel can have network interfaces, and solo5 specifies a so-called manifest with a list of these (name and type, and type is so far always basic). Then, on the actual server there are bridges (virtual switches) configured. Now, these may have the same name, or may need to be mapped. And of course, the unikernel expects a tap interface that is connected to such a bridge, not the bridge itself. Thus, albatross creates tap devices, attaches these to the respective bridges, and takes care about cleaning them up on teardown. The albatross client verifies that for each network interface in the manifest, there is a command-line argument specified (<code>--net service:my_bridge</code> or just <code>--net service</code> if the bridge is named service). The tap interface name is not really of interest to the user, and will not be exposed.</p>
<h3>Block devices</h3>
<p>On the host system, it's just a file, and passed to the unikernel. There's the need to be able to create one, dump it, and ensure that each file is only used by one unikernel. That's all that is there.</p>
<h2>Metrics</h2>
<p>Everyone likes graphs, over time, showing how much traffic or CPU or memory or whatever has been used by your service. Some of these statistics are only available in the host system, and it is also crucial for development purposes to compare whether the bytes sent in the unikernel sum up to the same on the host system's tap interface.</p>
<p>The albatross-stats daemon collects metrics from three sources: network interfaces, getrusage (of a child process), VMM debug counters (to count VM exits etc.). Since the recent 1.5.3, albatross-stats now connects at startup to the albatross-daemon and then retrieves the information which unikernels are up and running, and starts periodically collecting data in memory.</p>
<p>Other clients, being it a dump on your console window, a write into an rrd file (good old MRTG times), or a push to influx, can use the stats data to correlate and better analyse what is happening on the grand scale of things. This helped a lot by running several unikernels with different opam package sets to figure out which opam packages leave their hands on memory over time.</p>
<p>As a side note, if you make the unikernel name also available in the unikernel, it can tag its own metrics with the same identifier, and you can correlate high-level events (such as amount of HTTP requests) with low-level things &quot;allocated more memory&quot; or &quot;consumed a lot of CPU&quot;.</p>
<h2>Console</h2>
<p>There's not much to say about the console, just that the albatross-console daemon is running with low privileges, and reading from a FIFO that the unikernel writes to. It never writes anything to disk, but keeps the last 1000 lines in memory, available from a client asking for it.</p>
<h2>The daemons</h2>
<p>So, the main albatross-daemon runs with superuser privileges to create virtual machines, and opens a unix domain socket where the clients and other daemons are connecting to. The other daemons are executed with normal user privileges, and never write anything to disk.</p>
<p>The albatross-daemon keeps state about the running unikernels, and if it is restarted, the unikernels are started again. Maybe worth to mention that this lead sometimes to headaches (due to data being dumped to disk, and the old format should always be supported), but was also a huge relief to not have to care about creating all the unikernels just because albatross-daemon was killed.</p>
<h2>Remote management</h2>
<p>There's one more daemon program, either albatross-tls-inetd (to be executed by inetd), or albatross-tls-endpoint. They accept clients via a remote TCP connection, and establish a mutual-authenticated TLS handshake. When done, they forward the command to the respective Unix domain socket, and send back the reply.</p>
<p>The daemon itself has a X.509 certificate to authenticate, but the client is requested to show its certificate chain as well. This by now requires TLS 1.3, so the client certificates are sent over the encrypted channel.</p>
<p>A step back, x X.509 certificate contains a public key and a signature from one level up. When the server knows about the root (or certificate authority (CA)) certificate, and following the chain can verify that the leaf certificate is valid. Additionally, a X.509 certificate is a ASN.1 structure with some fixed fields, but also contains extensions, a key-value store where the keys are object identifiers, and the values are key-dependent data. Also note that this key-value store is cryptographically signed.</p>
<p>Albatross uses the object identifier, assigned to Camelus Dromedarius (MirageOS - 1.3.6.1.4.1.49836.42) to encode the command to be executed. This means that once the TLS handshake is established, the command to be executed is already transferred.</p>
<p>In the leaf certificate, there may be the &quot;create unikernel&quot; command with the unikernel image, it's boot parameters, and other resources. Or a &quot;read the console of my unikernel&quot;. In the intermediate certificates (from root to leaf), resource policies are encoded (this path may only have X unikernels running with a total of Y MB memory, and Z MB of block storage, using CPUs A and B, accessing bridges C and D). From the root downwards these policies may only decrease. When a unikernel should be created (or other commands are executed), the policies are verified to hold. If they do not, an error is reported.</p>
<h2>Fleet management</h2>
<p>Of course it is very fine to create your locally compiled unikernel to your albatross server, go for it. But in terms of &quot;what is actually running here?&quot; and &quot;does this unikernel need to be updated because some opam package had a security issues?&quot;, this is not optimal.</p>
<p>Since we provide <a href="https://builds.robur.coop">daily reproducible builds</a> with the current HEAD of the main opam-repository, and these unikernels have no configuration embedded (but take everything as boot parameters), we just deploy them. They come with the information what opam packages contributed to the binary, which environment variables were set, and which system packages were installed with which versions.</p>
<p>The whole result of reproducible builds for us means: we have a hash of a unikernel image that we can lookup in our build infrastructure, and take a look whether there is a newer image for the same job. And if there is, we provide a diff between the packages contributed to the currently running unikernel and the new image. That is what the albatross-client update command is all about.</p>
<p>Of course, your mileage may vary and you want automated deployments where each git commit triggers recompilation and redeployment. The downside would be that sometimes only dependencies are updated and you've to cope with that.</p>
<p>At the moment, there is a client connecting directly to the unix domain sockets, <code>albatross-client-local</code>, and one connecting to the TLS endpoint, <code>albatross-client-bistro</code>. The latter applies compression to the unikernel image.</p>
<h2>Installation</h2>
<p>For Debian and Ubuntu systems, we provide package repositories. Browse the dists folder for one matching your distribution, and add it to <code>/etc/apt/sources.list</code>:</p>
<pre><code>$ wget -q -O /etc/apt/trusted.gpg.d/apt.robur.coop.gpg https://apt.robur.coop/gpg.pub
$ echo &quot;deb https://apt.robur.coop ubuntu-20.04 main&quot; &gt;&gt; /etc/apt/sources.list # replace ubuntu-20.04 with e.g. debian-11 on a debian buster machine
$ apt update
$ apt install solo5 albatross
</code></pre>
<p>On FreeBSD:</p>
<pre><code>$ fetch -o /usr/local/etc/pkg/robur.pub https://pkg.robur.coop/repo.pub # download RSA public key
$ echo 'robur: {
  url: &quot;https://pkg.robur.coop/${ABI}&quot;,
  mirror_type: &quot;srv&quot;,
  signature_type: &quot;pubkey&quot;,
  pubkey: &quot;/usr/local/etc/pkg/robur.pub&quot;,
  enabled: yes
}' &gt; /usr/local/etc/pkg/repos/robur.conf # Check https://pkg.robur.coop which ABI are available
$ pkg update
$ pkg install solo5 albatross
</code></pre>
<p>For other distributions and systems we do not (yet?) provide binary packages. You can compile and install them using opam (<code>opam install solo5 albatross</code>). Get in touch if you're keen on adding some other distribution to our reproducible build infrastructure.</p>
<h2>Conclusion</h2>
<p>After five years of development and operating albatross, feel free to get it and try it out. Or read the code, discuss issues and shortcomings with us - either at the issue tracker or via eMail.</p>
<p>Please reach out to us (at team AT robur DOT coop) if you have feedback and suggestions. We are a non-profit company, and rely on <a href="https://robur.coop/Donate">donations</a> for doing our work - everyone can contribute.</p>

