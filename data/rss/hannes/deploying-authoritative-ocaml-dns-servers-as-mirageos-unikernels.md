---
title: Deploying authoritative OCaml-DNS servers as MirageOS unikernels
description:
url: https://hannes.robur.coop/Posts/DnsServer
date: 2019-12-23T21:30:53-00:00
preview_image:
featured:
---

<h2>Goal</h2>
<p>Have your domain served by OCaml-DNS authoritative name servers. Data is stored in a git remote, and let's encrypt certificates can be requested to DNS. This software is deployed since more than two years for several domains such as <code>nqsb.io</code> and <code>robur.coop</code>. This present the authoritative server side, and certificate library of the OCaml-DNS implementation formerly known as <a href="https://hannes.robur.coop/Posts/DNS">&micro;DNS</a>.</p>
<h2>Prerequisites</h2>
<p>You need to own a domain, and be able to delegate the name service to your own servers.
You also need two spare public IPv4 addresses (in different /24 networks) for your name servers.
A git server or remote repository reachable via git over ssh.
Servers which support <a href="https://github.com/solo5/solo5">solo5</a> guests, and have the corresponding tender installed.
A computer with <a href="https://opam.ocaml.org">opam</a> (&gt;= 2.0.0) installed.</p>
<h2>Data preparation</h2>
<p>Figure out a way to get the DNS entries of your domain in a <a href="https://tools.ietf.org/html/rfc1034">&quot;master file format&quot;</a>, i.e. what bind uses.</p>
<p>This is a master file for the <code>mirage</code> domain, defining <code>$ORIGIN</code> to avoid typing the domain name after each hostname (use <code>@</code> if you need the domain name only; if you need to refer to a hostname in a different domain end it with a dot (<code>.</code>), i.e. <code>ns2.foo.com.</code>). The default time to live <code>$TTL</code> is an hour (3600 seconds).
The zone contains a <a href="https://tools.ietf.org/html/rfc1035#section-3.3.13">start of authority (<code>SOA</code>) record</a> containing the nameserver, hostmaster, serial, refresh, retry, expiry, and minimum.
Also, a single <a href="https://tools.ietf.org/html/rfc1035#section-3.3.11">name server (<code>NS</code>) record</a> <code>ns1</code> is specified with an accompanying <a href="https://tools.ietf.org/html/rfc1035#section-3.4.1">address (<code>A</code>) records</a> pointing to their IPv4 address.</p>
<pre><code class="language-shell">git-repo&gt; cat mirage
$ORIGIN mirage.
$TTL 3600
@	SOA	ns1	hostmaster	1	86400	7200	1048576	3600
@	NS	ns1
ns1     A       127.0.0.1
www	A	1.1.1.1
git-repo&gt; git add mirage &amp;&amp; git commit -m initial &amp;&amp; git push
</code></pre>
<h2>Installation</h2>
<p>On your development machine, you need to install various OCaml packages. You don't need privileged access if common tools (C compiler, make, libgmp) are already installed. You have <code>opam</code> installed.</p>
<p>Let's create a fresh <code>switch</code> for the DNS journey:</p>
<pre><code class="language-shell">$ opam init
$ opam update
$ opam switch create udns 4.09.0
# waiting a bit, a fresh OCaml compiler is getting bootstrapped
$ eval `opam env` #sets some environment variables
</code></pre>
<p>The last command set environment variables in your current shell session, please use the same shell for the commands following (or run <code>eval $(opam env)</code> in another shell and proceed in there - the output of <code>opam switch</code> sohuld point to <code>udns</code>).</p>
<h3>Validation of our zonefile</h3>
<p>First let's check that OCaml-DNS can parse our zonefile:</p>
<pre><code class="language-shell">$ opam install dns-cli #installs ~/.opam/udns/bin/ozone and other binaries
$ ozone &lt;git-repo&gt;/mirage # see ozone --help
successfully checked zone
</code></pre>
<p>Great. Error reporting is not great, but line numbers are indicated (<code>ozone: zone parse problem at line 3: syntax error</code>), <a href="https://github.com/mirage/ocaml-dns/tree/v4.2.0/zone">lexer and parser are lex/yacc style</a> (PRs welcome).</p>
<p>FWIW, <code>ozone</code> accepts <code>--old &lt;filename&gt;</code> to check whether an update from the old zone to the new is fine. This can be used as <a href="https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks">pre-commit hook</a> in your git repository to avoid bad parse states in your name servers.</p>
<h3>Getting the primary up</h3>
<p>The next step is to compile the primary server and run it to serve the domain data. Since the git-via-ssh client is not yet released, we need to add a custom opam repository to this switch.</p>
<pre><code class="language-shell"># git via ssh is not yet released, but this opam repository contains the branch information
$ opam repo add git-ssh git+https://github.com/roburio/git-ssh-dns-mirage3-repo.git
# get the `mirage` application via opam
$ opam install lwt mirage

# get the source code of the unikernels
$ git clone -b future https://github.com/roburio/unikernels.git
$ cd unikernels/primary-git

# let's build the server first as unix application
$ mirage configure --prng fortuna #--no-depext if you have all system dependencies
$ make depend
$ make

# run it
$ ./primary_git
# starts a unix process which clones https://github.com/roburio/udns.git
# attempts to parse the data as zone files, and fails on parse error
$ ./primary-git --remote=https://my-public-git-repository
# this should fail with ENOACCESS since the DNS server tries to listen on port 53

# which requires a privileged user, i.e. su, sudo or doas
$ sudo ./primary-git --remote=https://my-public-git-repository
# leave it running, run the following programs in a different shell

# test it
$ host ns1.mirage 127.0.0.1
ns1.mirage has address 127.0.0.1
$ dig any mirage @127.0.0.1
# a DNS packet printout with all records available for mirage
</code></pre>
<p>That's exciting, the DNS server serving answers from a remote git repository.</p>
<h3>Securing the git access with ssh</h3>
<p>Let's authenticate the access by using ssh, so we feel ready to push data there as well. The primary-git unikernel already includes an experimental <a href="https://github.com/haesbaert/awa-ssh">ssh client</a>, all we need to do is setting up credentials - in the following a RSA keypair and the server fingerprint.</p>
<pre><code class="language-shell"># collect the RSA host key fingerprint
$ ssh-keyscan &lt;git-server&gt; &gt; /tmp/git-server-public-keys
$ ssh-keygen -l -E sha256 -f /tmp/git-server-public-keys | grep RSA
2048 SHA256:a5kkkuo7MwTBkW+HDt4km0gGPUAX0y1bFcPMXKxBaD0 &lt;git-server&gt; (RSA)
# we're interested in the SHA256:yyy only

# generate a ssh keypair
$ awa_gen_key # installed by the make depend step above in ~/.opam/udns/bin
seed is pIKflD07VT2W9XpDvqntcmEW3OKlwZL62ak1EZ0m
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5b2cSSkZ5/MAu7pM6iJLOaX9tJsfA8DB1RI34Zygw6FA0y8iisbqGCv6Z94ZxreGATwSVvrpqGo5p0rsKs+6gQnMCU1+sOC4PRlxy6XKgj0YXvAZcQuxwmVQlBHshuq0CraMK9FASupGrSO8/dW30Kqy1wmd/IrqW9J1Cnw+qf0C/VEhIbo7btlpzlYpJLuZboTvEk1h67lx1ZRw9bSPuLjj665yO8d0caVIkPp6vDX20EsgITdg+cFjWzVtOciy4ETLFiKkDnuzHzoQ4EL8bUtjN02UpvX2qankONywXhzYYqu65+edSpogx2TuWFDJFPHgcyO/ZIMoluXGNgQlP awa@awa.local
# please run your own awa_gen_key, don't use the numbers above
</code></pre>
<p>The public key needs is in standard OpenSSH format and needs to be added to the list of accepted keys on your server - the exact steps depend on your git server, if you're running your own with <a href="https://github.com/tv42/gitosis">gitosis</a>, add it as new public key file and grant that key access to the data repository. If you use gitlab or github, you may want to create a new user account and with the generated key.</p>
<p>The private key is not displayed, but only the seed required to re-generate it, when using the same random number generator, in our case <a href="http://mirleft.github.io/ocaml-nocrypto/doc/Nocrypto.Rng.html">fortuna implemented by nocrypto</a> - used by both <code>awa_gen_key</code> and <code>primary_git</code>. The seed is provided as command-line argument while starting <code>primary_git</code>:</p>
<pre><code class="language-shell"># execute with git over ssh, authenticator from ssh-keyscan, seed from awa_gen_key
$ ./primary_git --authenticator=SHA256:a5kkkuo7MwTBkW+HDt4km0gGPUAX0y1bFcPMXKxBaD0 --seed=pIKflD07VT2W9XpDvqntcmEW3OKlwZL62ak1EZ0m --remote=ssh://git@&lt;git-server&gt;/repo-name.git
# started up, you can try the host and dig commands from above if you like
</code></pre>
<p>To wrap up, we now have a primary authoritative name server for our zone running as Unix process, which clones a remote git repository via ssh on startup and then serves it.</p>
<h3>Authenticated data updates</h3>
<p>Our remote git repository is the source of truth, if you need to add a DNS entry to the zone, you git pull, edit the zone file, remember to increase the serial in the SOA line, run <code>ozone</code>, git commit and push to the repository.</p>
<p>So, the <code>primary_git</code> needs to be informed of git pushes. This requires a communication channel from the git server (or somewhere else, e.g. your laptop) to the DNS server. I prefer in-protocol solutions over adding yet another protocol stack, no way my DNS server will talk HTTP REST.</p>
<p>The DNS protocol has an extension for <a href="https://tools.ietf.org/html/rfc1996">notifications of zone changes</a> (as a DNS packet), usually used between the primary and secondary servers. The <code>primary_git</code> accepts these notify requests (i.e. bends the standard slightly), and upon receival pulls the remote git repository, and serves the fresh zone files. Since a git pull may be rather excessive in terms of CPU cycles and network bandwidth, only authenticated notifications are accepted.</p>
<p>The DNS protocol specifies in another extension <a href="https://tools.ietf.org/html/rfc2845">authentication (DNS TSIG)</a> with transaction signatures on DNS packets including a timestamp and fudge to avoid replay attacks. As key material hmac secrets distribued to both the communication endpoints are used.</p>
<p>To recap, the primary server is configured with command line parameters (for remote repository url and ssh credentials), and serves data from a zonefile. If the secrets would be provided via command line, a restart would be necessary for adding and removing keys. If put into the zonefile, they would be publicly served on request. So instead, we'll use another file, still in zone file format, in the top-level domain <code>_keys</code>, i.e. the <code>mirage._keys</code> file contains keys for the <code>mirage</code> zone. All files ending in <code>._keys</code> are parsed with the normal parser, but put into an authentication store instead of the domain data store, which is served publically.</p>
<p>For encoding hmac secrets into DNS zone file format, the <a href="https://tools.ietf.org/html/rfc4034#section-2"><code>DNSKEY</code></a> format is used (designed for DNSsec). The <a href="https://www.isc.org/bind/">bind</a> software comes with <code>dnssec-keygen</code> and <code>tsig-keygen</code> to generate DNSKEY output: flags is 0, protocol is 3, and algorithm identifier for SHA256 is 163 (SHA384 164, SHA512 165). This is reused by the OCaml DNS library. The key material itself is base64 encoded.</p>
<p>Access control and naming of keys follows the DNS domain name hierarchy - a key has the form name._operation.domain, and has access granted to domain and all subdomains of it. Two operations are supported: update and transfer. In the future there may be a dedicated notify operation, for now we'll use update. The name part is ignored for the update operation.</p>
<p>Since we now embedd secret information in the git repository, it is a good idea to restrict access to it, i.e. make it private and not publicly cloneable or viewable. Let's generate a first hmac secret and send a notify:</p>
<pre><code class="language-shell">$ dd if=/dev/random bs=1 count=32 | b64encode -
begin-base64 644 -
kJJqipaQHQWqZL31Raar6uPnepGFIdtpjkXot9rv2xg=
====
[..]
git-repo&gt; echo &quot;personal._update.mirage. DNSKEY 0 3 163 kJJqipaQHQWqZL31Raar6uPnepGFIdtpjkXot9rv2xg=&quot; &gt; mirage._keys
git-repo&gt; git add mirage._keys &amp;&amp; git commit -m &quot;add hmac secret&quot; &amp;&amp; git push

# now we need to restart the primary git to get the git repository with the key
$ ./primary_git --seed=... # arguments from above, remote git, host key fingerprint, private key seed

# now test that a notify results in a git pull
$ onotify 127.0.0.1 mirage --key=personal._update.mirage:SHA256:kJJqipaQHQWqZL31Raar6uPnepGFIdtpjkXot9rv2xg=
# onotify was installed by dns-cli in ~/.opam/udns/bin/onotify, see --help for options
# further changes to the hmac secrets don't require a restart anymore, a notify packet is sufficient :D
</code></pre>
<p>Ok, this onotify command line could be setup as a git post-commit hook, or run manually after each manual git push.</p>
<h3>Secondary</h3>
<p>It's time to figure out how to integrate the secondary name server. An already existing bind or something else that accepts notifications and issues zone transfers with hmac-sha256 secrets should work out of the box. If you encounter interoperability issues, please get in touch with me.</p>
<p>The <code>secondary</code> subdirectory of the cloned <code>unikernels</code> repository is another unikernel that acts as secondary server. It's only command line argument is a list of hmac secrets used for authenticating that the received data originates from the primary server. Data is initially transferred by a <a href="https://tools.ietf.org/html/rfc5936">full zone transfer (AXFR)</a>, later updates (upon refresh timer or notify request sent by the primary) use <a href="https://tools.ietf.org/html/rfc1995">incremental (IXFR)</a>. Zone transfer requests and data are authenticated with transaction signatures again.</p>
<p>Convenience by OCaml DNS is that transfer key names matter, and are of the form <primary-ip>.<secondary-ip>._transfer.domain, i.e. <code>1.1.1.1.2.2.2.2._transfer.mirage</code> if the primary server is 1.1.1.1, and the secondary 2.2.2.2. Encoding the IP address in the name allows both parties to start the communication: the secondary starts by requesting a SOA for all domains for which keys are provided on command line, and if an authoritative SOA answer is received, the AXFR is triggered. The primary server emits notification requests on startup and then on every zone change (i.e. via git pull) to all secondary IP addresses of transfer keys present for the specific zone in addition to the notifications to the NS records in the zone.</secondary-ip></primary-ip></p>
<pre><code class="language-shell">$ cd ../secondary
$ mirage configure --prng fortuna
# make depend should not be needed since all packages are already installed by the primary-git
$ make
$ ./secondary
</code></pre>
<h3>IP addresses and routing</h3>
<p>Both primary and secondary serve the data on the DNS port (53) on UDP and TCP. To run both on the same machine and bind them to different IP addresses, we'll use a layer 2 network (ethernet frames) with a host system software switch (bridge interface <code>service</code>), the unikernels as virtual machines (or seccomp-sandboxed) via the <a href="https://github.com/solo5/solo5">solo5</a> backend. Using xen is possible as well. As IP address range we'll use 10.0.42.0/24, and the host system uses the 10.0.42.1.</p>
<p>The primary git needs connectivity to the remote git repository, thus on a laptop in a private network we need network address translation (NAT) from the bridge where the unikernels speak to the Internet where the git repository resides.</p>
<pre><code class="language-shell"># on FreeBSD:
# configure NAT with pf, you need to have forwarding enabled
$ sysctl net.inet.ip.forwarding: 1
$ echo 'nat pass on wlan0 inet from 10.0.42.0/24 to any -&gt; (wlan0)' &gt;&gt; /etc/pf.conf
$ service pf restart

# make tap interfaces UP on open()
$ sysctl net.link.tap.up_on_open: 1

# bridge creation, naming, and IP setup
$ ifconfig bridge create
bridge0
$ ifconfig bridge0 name service
$ ifconfig bridge0 10.0.42.1/24

# two tap interfaces for our unikernels
$ ifconfig tap create
tap0
$ ifconfig tap create
tap1
# add them to the bridge
$ ifconfig service addm tap0 addm tap1
</code></pre>
<h3>Primary and secondary setup</h3>
<p>Let's update our zone slightly to reflect the IP changes.</p>
<pre><code class="language-shell">git-repo&gt; cat mirage
$ORIGIN mirage.
$TTL 3600
@	SOA	ns1	hostmaster	2	86400	7200	1048576	3600
@	NS	ns1
@	NS	ns2
ns1     A       10.0.42.2
ns2	A	10.0.42.3

# we also need an additional transfer key
git-repo&gt; cat mirage._keys
personal._update.mirage. DNSKEY 0 3 163 kJJqipaQHQWqZL31Raar6uPnepGFIdtpjkXot9rv2xg=
10.0.42.2.10.0.42.3._transfer.mirage. DNSKEY 0 3 163 cDK6sKyvlt8UBerZlmxuD84ih2KookJGDagJlLVNo20=
git-repo&gt; git commit -m &quot;udpates&quot; . &amp;&amp; git push
</code></pre>
<p>Ok, the git repository is ready, now we need to compile the unikernels for the virtualisation target (see <a href="https://mirage.io/wiki/hello-world#Building-for-Another-Backend">other targets</a> for further information).</p>
<pre><code class="language-shell"># back to primary
$ cd ../primary-git
$ mirage configure -t hvt --prng fortuna # or e.g. -t spt (and solo5-spt below)
# installs backend-specific opam packages, recompiles some
$ make depend
$ make
[...]
$ solo5-hvt --net:service=tap0 -- primary_git.hvt --ipv4=10.0.42.2/24 --ipv4-gateway=10.0.42.1 --seed=.. --authenticator=.. --remote=ssh+git://...
# should now run as a virtual machine (kvm, bhyve), and clone the git repository
$ dig any mirage @10.0.42.2
# should reply with the SOA and NS records, and also the name server address records in the additional section

# secondary
$ cd ../secondary
$ mirage configure -t hvt --prng fortuna
$ make
$ solo5-hvt --net:service=tap1 -- secondary.hvt --ipv4=10.0.42.3/24 --keys=10.0.42.2.10.0.42.3._transfer.mirage:SHA256:cDK6sKyvlt8UBerZlmxuD84ih2KookJGDagJlLVNo20=
# an ipv4-gateway is not needed in this setup, but in real deployment later
# it should start up and transfer the mirage zone from the primary

$ dig any mirage @10.0.42.3
# should now output the same information as from 10.0.42.2

# testing an update and propagation
# edit mirage zone, add a new record and increment the serial number
git-repo&gt; echo &quot;foo A 127.0.0.1&quot; &gt;&gt; mirage
git-repo&gt; vi mirage &lt;- increment serial
git-repo&gt; git commit -m 'add foo' . &amp;&amp; git push
$ onotify 10.0.42.2 mirage --key=personal._update.mirage:SHA256:kJJqipaQHQWqZL31Raar6uPnepGFIdtpjkXot9rv2xg=

# now check that it worked
$ dig foo.mirage @10.0.42.2 # primary
$ dig foo.mirage @10.0.42.3 # secondary got notified and transferred the zone
</code></pre>
<p>You can also check the behaviour when restarting either of the VMs, whenever the primary is available the zone is synchronised. If the primary is down, the secondary still serves the zone. When the secondary is started while the primary is down, it won't serve any data until the primary is online (the secondary polls periodically, the primary sends notifies on startup).</p>
<h3>Dynamic data updates via DNS, pushed to git</h3>
<p>DNS is a rich protocol, and it also has builtin <a href="https://tools.ietf.org/html/rfc2136">updates</a> that are supported by OCaml DNS, again authenticated with hmac-sha256 and shared secrets. Bind provides the command-line utility <code>nsupdate</code> to send these update packets, a simple <code>oupdate</code> unix utility is available as well (i.e. for integration of dynamic DNS clients). You know the drill, add a shared secret to the primary, git push, notify the primary, and voila we can dynamically in-protocol update. An update received by the primary via this way will trigger a git push to the remote git repository, and notifications to the secondary servers as described above.</p>
<pre><code class="language-shell"># being lazy, I reuse the key above
$ oupdate 10.0.42.2 personal._update.mirage:SHA256:kJJqipaQHQWqZL31Raar6uPnepGFIdtpjkXot9rv2xg= my-other.mirage 1.2.3.4

# let's observe the remote git
git-repo&gt; git pull
# there should be a new commit generated by the primary
git-repo&gt; git log

# test it, should return 1.2.3.4
$ dig my-other.mirage @10.0.42.2
$ dig my-other.mirage @10.0.42.3
</code></pre>
<p>So we can deploy further <code>oupdate</code> (or <code>nsupdate</code>) clients, distribute hmac secrets, and have the DNS zone updated. The source of truth is still the git repository, where the primary-git pushes to. Merge conflicts and timing of pushes is not yet dealt with. They are unlikely to happen since the primary is notified on pushes and should have up-to-date data in storage. Sorry, I'm unsure about the error semantics, try it yourself.</p>
<h3>Let's encrypt!</h3>
<p><a href="https://letsencrypt.org/">Let's encrypt</a> is a certificate authority (CA), which certificate is shipped as trust anchor in web browsers. They specified a protocol for <a href="https://tools.ietf.org/html/draft-ietf-acme-acme-05">automated certificate management environment (ACME)</a>, used to get X509 certificates for your services. In the protocol, a certificate signing request (publickey and hostname) is sent to let's encrypt servers, which sends a challenge to proof the ownership of the hostnames. One widely-used way to solve this challenge is running a web server, another is to serve it as text record from the authoritative DNS server.</p>
<p>Since I avoid persistent storage when possible, and also don't want to integrate a HTTP client stack in the primary server, I developed a third unikernel that acts as (hidden) secondary server, performs the tedious HTTP communication with let's encrypt servers, and stores all data in the public DNS zone.</p>
<p>For encoding of certificates, the DANE working group specified <a href="https://tools.ietf.org/html/rfc6698.html#section-7.1">TLSA</a> records in DNS. They are quadruples of usage, selector, matching type, and ASN.1 DER-encoded material. We set usage to 3 (domain-issued certificate), matching type to 0 (no hash), and selector to 0 (full certificate) or 255 (private usage) for certificate signing requests. The interaction is as follows:</p>
<ol>
<li>Primary, secondary, and let's encrypt unikernels are running
</li>
<li>A service (<code>ocertify</code>, <code>unikernels/certificate</code>, or the <code>dns-certify.mirage</code> library) demands a TLS certificate, and has a hmac-secret for the primary DNS
</li>
<li>The service generates a certificate signing request with the desired hostname(s), and performs an nsupdate with TLSA 255 <der encoded="encoded" signing-request="signing-request">
</der></li>
<li>The primary accepts the update, pushes the new zone to git, and sends notifies to secondary and let's encrypt unikernels which (incrementally) transfer the zone
</li>
<li>The let's encrypt unikernel notices while transferring the zone a signing request without a certificate, starts HTTP interaction with let's encrypt
</li>
<li>The let's encrypt unikernel solves the challenge, sends the response as update of a TXT record to the primary nameserver
</li>
<li>The primary pushes the TXT record to git, and notifies secondaries (which transfer the zone)
</li>
<li>The let's encrypt servers request the TXT record from either or both authoritative name servers
</li>
<li>The let's encrypt unikernel polls for the issued certificate and send an update to the primary TLSA 0 <der encoded="encoded" certificate="certificate">
</der></li>
<li>The primary pushes the certificate to git, notifies secondaries (which transfer the zone)
</li>
<li>The service polls TLSA records for the hostname, and use it upon retrieval
</li>
</ol>
<p>Note that neither the signing request nor the certificate contain private key material, thus it is fine to serve them publically. Please also note, that the service polls for the certificate for the hostname in DNS, which is valid (start and end date) certificate and uses the same public key, this certificate is used and steps 3-10 are not executed.</p>
<p>The let's encrypt unikernel does not serve anything, it is a reactive system which acts upon notification from the primary. Thus, it can be executed in a private address space (with a NAT). Since the OCaml DNS server stack needs to push notifications to it, it preserves all incoming signed SOA requests as candidates for notifications on update. The let's encrypt unikernel ensures to always have a connection to the primary to receive notifications.</p>
<pre><code class="language-shell"># getting let's encrypt up and running
$ cd ../lets-encrypt
$ mirage configure -t hvt --prng fortuna
$ make depend
$ make

# run it
$ solo5-hvt --net:service=tap2 -- letsencrypt.hvt --keys=...

# test it
$ ocertify 10.0.42.2 foo.mirage
</code></pre>
<p>For actual testing with let's encrypt servers you need to have the primary and secondary deployed on your remote hosts, and your domain needs to be delegated to these servers. Good luck. And ensure you have backup your git repository.</p>
<p>As fine print, while this tutorial was about the <code>mirage</code> zone, you can stick any number of zones into the git repository. If you use a <code>_keys</code> file (without any domain prefix), you can configure hmac secrets for all zones, i.e. something to use in your let's encrypt unikernel and secondary unikernel. Dynamic addition of zones is supported, just create a new zonefile and notify the primary, the secondary will be notified and pick it up. The primary responds to a signed SOA for the root zone (i.e. requested by the secondary) with the SOA response (not authoritative), and additionally notifications for all domains of the primary.</p>
<h3>Conclusion and thanks</h3>
<p>This tutorial presented how to use the OCaml DNS based unikernels to run authoritative name servers for your domain, using a git repository as the source of truth, dynamic authenticated updates, and let's encrypt certificate issuing.</p>
<p>There are further steps to take, such as monitoring -- have a look at the <code>monitoring</code> branch of the opam repository above, and the <code>future-robur</code> branch of the unikernels repository above, which use a second network interface for reporting syslog and metrics to telegraf / influx / grafana. Some DNS features are still missing, most prominently DNSSec.</p>
<p>I'd like to thank all people involved in this software stack, without other key components, including <a href="https://github.com/mirage/ocaml-git">git</a>, <a href="https://irmin.io/">irmin 2.0</a>, <a href="https://github.com/mirleft/ocaml-nocrypto">nocrypto</a>, <a href="https://github.com/haesbaert/awa-ssh">awa-ssh</a>, <a href="https://github.com/mirage/ocaml-cohttp">cohttp</a>, <a href="https://github.com/solo5/sol5">solo5</a>, <a href="https://github.com/mirage/mirage">mirage</a>, <a href="https://github.com/mmaker/ocaml-letsencrypt">ocaml-letsencrypt</a>, and more.</p>
<p>If you want to support our work on MirageOS unikernels, please <a href="https://robur.coop/Donate">donate to robur</a>. I'm interested in feedback, either via <a href="https://twitter.com/h4nnes">twitter</a>, <a href="https://mastodon.social/@hannesm">hannesm@mastodon.social</a> or via eMail.</p>

