---
title: Under the hood with Apple's new Containerization framework
description:
url: https://anil.recoil.org/notes/apple-containerisation
date: 2025-06-11T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
ignore:
---

<p>Apple made a notable <a href="https://developer.apple.com/videos/play/wwdc2025/346/">announcement</a> in <a href="https://developer.apple.com/wwdc25/">WWDC 2025</a> that they've got a new containerisation framework in the new Tahoe beta. This took me right back to the early <a href="https://docs.docker.com/desktop/setup/install/mac-install/">Docker for Mac</a> days in 2016 when we <a href="https://www.docker.com/blog/docker-unikernels-open-source/">announced</a> the first mainstream use of the <a href="https://developer.apple.com/documentation/hypervisor">hypervisor framework</a>, so I couldn't resist taking a quick peek under the hood.</p>
<p>There were two separate things announced: a <a href="https://github.com/apple/containerization">Containerization framework</a> and also a <a href="https://github.com/apple/container">container</a> CLI tool that aims to be an <a href="https://opencontainers.org/">OCI</a> compliant tool to manipulate and execute container images. The former is a general-purpose framework that could be used by Docker, but it wasn't clear to me where the new CLI tool fits in among the existing layers of <a href="https://github.com/opencontainers/runc">runc</a>, <a href="https://containerd.io/">containerd</a> and of course Docker itself. The only way to find out is to take the new release for a spin, since Apple open-sourced everything (well done!).</p>
<h2>Getting up and running</h2>
<p>To get the full experience, I chose to install the <a href="https://www.apple.com/uk/newsroom/2025/06/macos-tahoe-26-makes-the-mac-more-capable-productive-and-intelligent-than-ever/">macOS Tahoe beta</a>, as there have been improvements to the networking frameworks<sup><a href="https://anil.recoil.org/news.xml#fn-1" role="doc-noteref" class="fn-label">[1]</a></sup> that are only present in the new beta. It's essential you only use the <a href="https://developer.apple.com/news/releases/?id=06092025g">Xcode 26 beta</a> as otherwise you'll get Swift link errors against vmnet. I had to force my installation to use the right toolchain via:</p>
<pre><code>sudo xcode-select --switch /Applications/Xcode-beta.app/Contents/Developer
</code></pre>
<p>Once that was done, it was simple to clone and install the <a href="https://github.com/apple/container">container
repo</a> with a <code>make install</code>. The first
thing I noticed is that everything is written in Swift with no Go in sight.
They still use Protobuf for communication among the daemons, as most of the
wider Docker ecosystem does.</p>
<p></p><figure class="image-center"><img src="https://anil.recoil.org/images/macos-ss-1.webp" loading="lazy" class="content-image" alt="I have mixed feelings about the new glass UI in macOS Tahoe. The tabs in the terminal are so low contrast they're impossible to distinguish!" srcset="/images/macos-ss-1.1024.webp 1024w,/images/macos-ss-1.1280.webp 1280w,/images/macos-ss-1.1440.webp 1440w,/images/macos-ss-1.1600.webp 1600w,/images/macos-ss-1.1920.webp 1920w,/images/macos-ss-1.320.webp 320w,/images/macos-ss-1.480.webp 480w,/images/macos-ss-1.640.webp 640w,/images/macos-ss-1.768.webp 768w" title="I have mixed feelings about the new glass UI in macOS Tahoe. The tabs in the terminal are so low contrast they're impossible to distinguish!" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>I have mixed feelings about the new glass UI in macOS Tahoe. The tabs in the terminal are so low contrast they're impossible to distinguish!</figcaption></figure>
<p></p>
<h2>Starting our first Apple container</h2>
<p>Let's start our daemon up and take the <code>container</code> CLI for a spin.</p>
<pre><code class="language-sh">$ container system start
Verifying apiserver is running...
Installing base container filesystem...
No default kernel configured.
Install the recommended default kernel from [https://github.com/kata-containers/kata-containers/releases/download/3.17.0/kata-static-3.17.0-arm64.tar.xz]? [Y/n]: y
Installing kernel... 
⠙ [1/2] Downloading kernel 33% (93.4/277.1 MB, 14.2 MB/s) [5s]
</code></pre>
<p>The first thing we notice is it downloading a full Linux kernel from the <a href="https://github.com/kata-containers/kata-containers">Kata Containers</a> project. This system spins up a VM per container in order to provide more isolation. Although I haven't tracked Kata closely since its <a href="https://techcrunch.com/2017/12/05/intel-and-hyper-partner-with-the-openstack-foundation-to-launch-the-kata-containers-project/">launch</a> in 2017, I did notice it being used to containerise <a href="https://confidentialcomputing.io/">confidential computing enclaves</a> while <a href="https://zatkh.github.io/" class="contact">Zahra Tarkhani</a> and I were working on <a href="https://anil.recoil.org/projects/difc-tee">TEE programming models</a> a few years ago.</p>
<p>The use of Kata tells us that <code>container</code> spins up a new kernel using the
macOS <a href="https://anil.recoil.org/news.xml">Virtualization framework</a> every time a new container is started. This
is ok for production use (where extra isolation may be appropriate in a
multitenant cloud environment) but very memory inefficient for development
(where it's usual to spin up 4-5 VMs for a development environment with a
database etc). In contrast, Docker for Mac <a href="https://speakerdeck.com/avsm/the-functional-innards-of-docker-for-mac-and-windows">uses</a> a single Linux kernel and runs
the containers within that instead.</p>
<p>It's not quite clear to me why Apple chose the extra overheads of a
VM-per-container, but I suspect this might be something to do with running code securely
inside the <a href="https://support.apple.com/en-gb/guide/security/sec59b0b31ff/web">many hardware enclaves</a>
present in modern Apple hardware, a usecase that is on the rise with <a href="https://www.apple.com/uk/apple-intelligence/">Apple
Intelligence</a>.</p>
<h2>Peeking under the hood of the Swift code</h2>
<p>Once the container daemon is running, we can spin up our first container using Alpine, which uses the familiar Docker-style <code>run</code>:</p>
<pre><code class="language-sh">$ time container run alpine uname -a 
Linux 3c555c19-b235-4956-bed8-27bcede642a6 6.12.28 #1 SMP
Tue May 20 15:19:05 UTC 2025 aarch64 Linux
0.04s user 0.01s system 6% cpu 0.733 total
</code></pre>
<p>The container spinup time is noticable, but still less than a second and pretty acceptable for day to day use. This is possible thanks to a custom userspace they implement via a Swift init process that's run by the Linux kernel as the <em>sole</em> binary in the filesystem, and that provides an RPC interface to manage other services. The <a href="https://github.com/apple/containerization/tree/main/vminitd/Sources/vminitd">vminitd</a> is built using the Swift static Linux SDK, which links <a href="https://musl.libc.org/">musl libc</a> under the hood (the same one used by <a href="https://www.alpinelinux.org/">Alpine Linux</a>).</p>
<p>We can see the processes running by using <a href="https://man7.org/linux/man-pages/man1/pstree.1.html">pstree</a>:</p>
<pre><code>|- 29203 avsm /System/Library/Frameworks/Virtualization.framework/
   Versions/A/XPCServices/com.apple.Virtualization.VirtualMachine.xpc/
   Contents/MacOS/com.apple.Virtualization.VirtualMachine
|- 29202 avsm &lt;..&gt;/plugins/container-runtime-linux/
   bin/container-runtime-linux
   --root &lt;..&gt;/f82d3a52-c89b-4ff0-9e71-c7127cb5eee1
   --uuid f82d3a52-c89b-4ff0-9e71-c7127cb5eee1 --debug
|- 28896 avsm &lt;..&gt;/bin/container-network-vmnet
   start --id default
   --service-identifier &lt;..&gt;network.container-network-vmnet.default
|- 28899 avsm &lt;..&gt;/bin/container-core-images start
|- 29202 avsm &lt;..&gt;/bin/container-runtime-linux
   --root &lt;..&gt;/f82d3a52-c89b-4ff0-9e71-c7127cb5eee1
   --uuid f82d3a52-c89b-4ff0-9e71-c7127cb5eee1 --debug
|- 28896 avsm &lt;..&gt;/container-network-vmnet start --id default
   --service-identifier &lt;..&gt;network.container-network-vmnet.default
</code></pre>
<p>You can start to see the overheads of a VM-per-container now, as each container
needs the host process infrastructure to not only run the computation, but also to
feed it with networking and storage IO (which have to be translated from the
host).  Still, its a drop in the ocean for macOS these days, as I'm running 850
processes in the background on my Macbook Air from an otherwise fresh
installation! This isn't the lean, fast MacOS X Cheetah I used on my G4 Powerbook anymore,
sadly.</p>
<h3>Finding the userspace ext4 in Swift</h3>
<p>I then tried to run a more interesting container for my local dev environment:
the <a href="https://hub.docker.com/r/ocaml/opam">ocaml/opam</a> Docker images that we use
in OCaml development.  This showed up an interesting new twist in the Apple
rewrite: they have an entire <a href="https://anil.recoil.org/news.xml">ext4</a> filesystem <a href="https://github.com/apple/containerization/tree/main/Sources/ContainerizationEXT4">implementation written in
Swift</a>!
This is used to extract the OCI images from the Docker registry and then
construct a new filesystem.</p>
<pre><code class="language-sh">$ container run ocaml/opam opam list
⠦ [2/6] Unpacking image for platform linux/arm64 (112,924 entries, 415.9 MB, Zero KB/s) [9m 22s] 
⠹ [2/6] Unpacking image for platform linux/arm64 (112,972 entries, 415.9 MB, Zero KB/s) [9m 23s] 
⠇ [2/6] Unpacking image for platform linux/arm64 (113,012 entries, 415.9 MB, Zero KB/s) [9m 23s] 
⠼ [2/6] Unpacking image for platform linux/arm64 (113,059 entries, 415.9 MB, Zero KB/s) [9m 23s] 
⠋ [2/6] Unpacking image for platform linux/arm64 (113,104 entries, 415.9 MB, Zero KB/s) [9m 24s] 
# Packages matching: installed                                                                      
# Name                # Installed # Synopsis
base-bigarray         base
base-domains          base
base-effects          base
base-threads          base
base-unix             base
ocaml                 5.3.0       The OCaml compiler (virtual package)
ocaml-base-compiler   5.3.0       pinned to version 5.3.0
ocaml-compiler        5.3.0       Official release of OCaml 5.3.0
ocaml-config          3           OCaml Switch Configuration
opam-depext           1.2.3       Install OS distribution packages
</code></pre>
<p>The only hitch here is how slow this process is. The OCaml images do have a lot of individual
files within the layers (not unusual for a package manager), but I was surprised that this took
10 minutes on my modern M4 Macbook Air, versus a few seconds on Docker for Mac.  I <a href="https://github.com/apple/container/issues/136">filed a bug</a> upstream to investigate further since (as with any new implementation) there are many <a href="https://anil.recoil.org/papers/2015-sosp-sibylfs">edge cases</a> when handling filesystems in userspace, and the Apple code seems to have <a href="https://github.com/apple/container/issues/134">other limitations</a> as well.  I'm sure this will all shake out as the framework gets more users, but it's worth bearing in mind if you're thinking of using it in the near term in a product.</p>
<h2>What's conspicuously missing?</h2>
<p>I was super excited when this announcement first happened, since I thought it might be the beginning of a few features I've needed for years and years. But they're missing...</p>
<h3>Running macOS containers: nope</h3>
<p>In OCaml-land, we have gone to ridiculous lengths to be able to run macOS CI on our own infrastructure. <a href="https://patrick.sirref.org" class="contact">Patrick Ferris</a> first wrote a <a href="https://tarides.com/blog/2023-08-02-obuilder-on-macos/">custom snapshotting builder</a> using undocumented interfaces like userlevel sandboxing, subsequently taken over and maintained by <a href="https://tarides.com/blog/author/mark-elvers/" class="contact">Mark Elvers</a>. This is a tremendous amount of work to maintain, but the alternative is to depend on very expensive hosted services to spin up individual macOS VMs which are slow and energy hungry.</p>
<p>What we <em>really</em> need are macOS containers! We have dozens of mechanisms to run Linux ones already, and only a few <a href="https://github.com/dockur/macos">heavyweight alternatives</a> to run macOS itself within macOS. However, the VM-per-container mechanism chosen by Apple might be the gateway to supporting macOS itself in the future. I will be first in line to test this if it happens!</p>
<h3>Running iOS containers: nope</h3>
<p>Waaaay back when we were <a href="https://speakerdeck.com/avsm/the-functional-innards-of-docker-for-mac-and-windows">first writing</a> Docker for Mac, there were no mainstream users of the Apple Hypervisor framework at all (that's why we built and released <a href="https://github.com/moby/hyperkit">Hyperkit</a>. The main benefit we hoped to derive from using Apple-blessed frameworks is that they would make our app App-Store friendly for distribution via those channels.</p>
<p>But while there do exist <a href="https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.security.hypervisor">entitlements</a> to support virtualisation on macOS, there is <em>no</em> support for iOS or iPadOS to this day! All of the trouble to sign binaries and deal with entitlements and opaque Apple tooling only gets it onto the Mac App store, which is a little bit of a graveyard compared to the iOS ecosystem.
This thus remains on my wishlist for Apple: the hardware on modern iPad adevices <em>easily</em> supports virtualisation, but Apple is choosing to cripple these devices from having a decent development experience by not unlocking the software capability by allowing the hypervisor, virtualisation and container frameworks to run on there.</p>
<h3>Running Linux containers: yeah but no GPU</h3>
<p>One reason to run Linux containers on macOS is to handle machine learning workloads. Actually getting this to be performant is tricky, since macOS has its own custom <a href="https://github.com/ml-explore/mlx">MLX-based</a> approach to handling tensor computations. Meanwhile, the rest of the world mostly uses nVidia or AMD interfaces for those GPUs, which is reflected in container images that are distributed.</p>
<p>There is some chatter on the <a href="https://github.com/apple/container/discussions/62#discussioncomment-13414483">apple/container GitHub</a> about getting GPU passthrough working, but I'm still unclear on how to get a more portable GPU ABI. The reason Linux containers work so well is that the Linux kernel provides a very stable ABI, but this breaks down with GPUs badly.</p>
<h1>Does this threaten Docker's dominance?</h1>
<p>I have mixed feelings about the Containerization framework release. On one hand, it's always fun to see more systems code in a new language like Swift, and this is an elegant and clean reimplementation of classic containerisation techniques in macOS. But the release <strong>fails to unlock any real new end-user capabilities</strong>, such as running a decent development environment on my iPad without using cloud services. Come on Apple, you can make that happen; you're getting ever closer every release!</p>
<p>I don't believe that Docker or Orbstack are too threatened by this release at this stage either, despite some reports that <a href="https://appleinsider.com/articles/25/06/09/sorry-docker-macos-26-adds-native-support-for-linux-containers">they're being Sherlocked</a>. The Apple container CLI is quite low-level, and there's a ton of quality-of-life features in the full Docker for Mac app that'll keep me using it, and there seems to be no real blocker from Docker adopting the Containerization framework as one of its optional backends. I prefer having a single VM for my devcontainers to keep my laptop battery life going, so I think Docker's current approach is better for that usecase.</p>
<p>Apple has been a very good egg here by open sourcing all their code, so I believe this will overall help the Linux container ecosystem by adding choice to how we deploy software containers. Well done <a href="https://github.com/crosbymichael">Michael Crosby</a>, <a href="https://github.com/mavenugo">Madhu Venugopal</a> and many of my other former colleagues who are all merrily hackily away on this for doing so!  As an aside, I'm also just revising a couple of papers about the history of using OCaml in several Docker components, and a retrospective look back at the hypervisor architecture backing Docker for Desktop, which will appear in print in the next couple of months (I'll update this post when they appear). But for now, back to my day job of marking undergraduate exam scripts...</p>
<section role="doc-endnotes"><ol>
<li>
<p>vmnet is a networking framework for VMs/containers that I had to <a href="https://github.com/mirage/ocaml-vmnet">reverse engineer</a> back in 2014 to use with OCaml/MirageOS.</p>
<span><a href="https://anil.recoil.org/news.xml#ref-1-fn-1" role="doc-backlink" class="fn-label">↩︎︎</a></span></li></ol></section>

