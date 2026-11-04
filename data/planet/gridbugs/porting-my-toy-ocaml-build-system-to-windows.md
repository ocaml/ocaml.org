---
title: Porting my Toy OCaml Build System to Windows
description: "Alice is my toy OCaml build system project where I ask \u201CWhat if
  Cargo but for OCaml?\u201D. My main priority when designing Alice is accessibility
  but perhaps a more suitable term would be inclusivity as my goal is for the tool
  to be usable by as many people as possible."
url: https://www.gridbugs.org/porting-my-toy-ocaml-build-system-to-windows/
date: 2025-08-28T00:00:00-00:00
preview_image: https://www.gridbugs.org/porting-my-toy-ocaml-build-system-to-windows/screenshot.png
authors:
- Gridbugs
source:
ignore:
keywords:
- alice
- build
- downloading
- exe
- foo
- ocamllsp
- opt
- relocatable
- tmp
- windows
---

<p><img src="https://www.gridbugs.org/porting-my-toy-ocaml-build-system-to-windows/banner.jpg" alt="A grassy hill with a blue sky containing a single cloud. The closest thing to the Windows XP Bliss wallpaper within walking distance of my home."></p>
<p><a href="https://github.com/alicecaml/alice">Alice</a> is my toy OCaml build system
project where I ask “What if <a href="https://doc.rust-lang.org/stable/cargo/">Cargo</a>
but for OCaml?”. My main priority when designing Alice is accessibility but
perhaps a more suitable term would be <em>inclusivity</em> as my goal is for the tool
to be usable by as many people as possible. Alice is still in its infancy and is
currently used by <em>nobody</em> but if the day comes when it becomes a viable tool
for building OCaml software I would hate to systematically exclude a potential
user base because of baked-in assumptions made early in its design.</p>
<p>I do most of my development on Linux and macOS which means I’m likely to
make design decisions favouring those systems, possibly at the expense of
potential users on other systems. In particular, because Windows differs so much
from other popular OSes due to it not being Unix-based, there’s a significant
risk of excluding Windows users if I don’t make a conscious effort to support
them.</p>
<p>Like most people who grew up in the 2000s or later I was introduced to
computing on home and school computers running Windows (Windows 98 in my case!).
I started playing with Linux in 2009 and it gradually became my daily driver
but it took a huge amount of free time messing around with different distros and
learning the tools and conventions to get to my level of comfort. I’m also
fortunate enough to have the means to afford a Mac. But people who learnt
Windows first and lack the time, money, or inclination to switch to a
Unix-based OS will remain Windows users. So when Windows users are excluded from
a tool, who is <em>really</em> being excluded?</p>
<p>Today I’m going to port Alice to Windows.</p>
<p>To prepare for this work I’ve compiled a relocatable OCaml compiler toolchain for
Windows based on <a href="https://www.dra27.uk/blog/">David Allsopp</a>’s patches to allow
the compiler to be moved after its initial installation. See <a href="https://www.youtube.com/watch?v=5JDSUCx-tPw">this talk from
ICFP 2022</a> for more info. Without
this work every user would need to compile the OCaml compiler on their machine before
using it. It’s important to me that a user of Alice can get started writing
OCaml as quickly as possible with no hurdles. Building the compiler from source can
take over 10 minutes and I don’t want users’ first experience of Alice to be
waiting such a long time. I don’t think I would have started working on Alice
at all if distributing a pre-compiled relocatable compiler wasn’t an option.</p>
<p>Technically I could have used opam to bootstrap my development environment as it works
<a href="https://www.gridbugs.org/sound-on-ocaml-on-windows/#trying-again-with-msys2">perfectly fine</a>
on Windows but one cool feature of Alice is that it can download pre-compiled
development tools for you. Alice can’t build itself (yet!) but I still want to
eat my own dogfood when I can, and so I’m testing out the prebuilt toolchain
while developing Alice. I haven’t updated Alice to be able to install the
dev tools prebuilt for Windows yet, but I have a handy
<a href="https://github.com/alicecaml/alice/blob/main/boot/x86_64-windows.sh">shell script</a>
that sets up a development environment for working on Alice using the same tools
as Alice would install if it <em>was</em> already built. Classic bootstrapping problem.</p>
<p>I’m using powershell and I have <a href="https://www.msys2.org/">msys2</a> installed so
some commands will look very Unix-y. Alice itself will work fine on Windows once
ported but I barely know what I’m doing in powershell so I’ll stick to what I
know (ie. Unix commands from msys2) while setting up my environment!</p>
<p>This command installed a prebuilt compiler toolchain to <code>D:\alice\current</code>:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS D:\src\alice&gt; sh boot\x86_64-windows.sh D:\alice
</span></code></pre>
<p>The result:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS D:\src\alice&gt; ls D:\alice\current\bin\
</span><span>
</span><span>
</span><span>    Directory: D:\alice\current\bin
</span><span>
</span><span>
</span><span>Mode                 LastWriteTime         Length Name
</span><span>----                 -------------         ------ ----
</span><span>-a----        2025-08-28     02:07         451937 flexlink.byte.exe
</span><span>-a----        2025-08-28     02:08        4706378 flexlink.exe
</span><span>-a----        2025-08-28     02:08        4706378 flexlink.opt.exe
</span><span>-a----        2025-08-28     02:08       24365426 ocaml.exe
</span><span>-a----        2025-08-28     02:08        3394118 ocamlc.byte.exe
</span><span>-a----        2025-08-28     02:08       13950043 ocamlc.exe
</span><span>-a----        2025-08-28     02:08       13950043 ocamlc.opt.exe
</span><span>...
</span></code></pre>
<p>In addition to the compiler, this command installed <code>ocamlformat</code> and <code>ocamllsp</code>,
which I also pre-compiled for Windows in preparation for this work.</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS D:\src\alice&gt; Get-Command ocamlformat
</span><span>
</span><span>CommandType     Name               Version    Source
</span><span>-----------     ----               -------    ------
</span><span>Application     ocamlformat.exe    0.0.0.0    D:\alice\current\bin\ocamlformat.exe
</span><span>
</span><span>
</span><span>PS D:\src\alice&gt; Get-Command ocamllsp
</span><span>
</span><span>CommandType     Name               Version    Source
</span><span>-----------     ----               -------    ------
</span><span>Application     ocamllsp.exe       0.0.0.0    D:\alice\current\bin\ocamllsp.exe
</span></code></pre>
<p>The other development tool I’ll need is <code>dune</code>. Alice uses Dune’s relatively new
package-management features and these have not yet been ported to Windows so
I’ve needed to hack Dune a little bit to make it work here. I already did this
work while building <code>ocamlformat</code> and <code>ocamllsp</code> with Dune package management on
Windows. Most hacks were to those projects’ lockfiles rather than to Dune itself.
I kept a
<a href="https://github.com/alicecaml/alice/blob/1c934ce6eb096130659268e913e4da54b7b2853c/tool-build-scripts/5.3.1/windows-notes.md">log</a>
of everything I needed to change. I may be referring to it in order to get Alice
to build with Dune on Windows.</p>
<p>I built Dune from source on Windows using opam while building <code>ocamlformat</code> and
<code>ocamllsp</code> and that’s the Dune executable I’ll be using for today’s work on
Alice.</p>
<p>Ok so I have all the tools I need, let’s see if Alice builds on Windows:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS D:\src\alice&gt; dune build
</span><span>File "dune.lock/lock.dune", lines 18-29, characters 1-288:
</span><span>18 |  ((arch x86_64)
</span><span>19 |   (os linux)
</span><span>20 |   (sys-ocaml-version 5.3.1+relocatable))
</span><span>....
</span><span>27 |  ((arch arm64)
</span><span>28 |   (os macos)
</span><span>29 |   (sys-ocaml-version 5.3.1+relocatable)))
</span><span>Error: The lockdir does not contain a solution compatible with the current
</span><span>platfort.
</span><span>The current platform is:
</span><span>- arch = x86_64
</span><span>- os = win32
</span><span>- os-distribution = win32
</span><span>- os-family = windows
</span><span>- os-version = 10.0.22621
</span><span>- sys-ocaml-version = 5.3.1+relocatable
</span><span>Hint: Try adding the following to dune-workspace:
</span><span>Hint: (lock_dir (solve_for_platforms ((arch x86_64) (os win32))))
</span><span>Hint: ...and then rerun 'dune pkg lock'
</span></code></pre>
<p>I’ve seen this error before while building <code>ocamlformat</code>. Alice has <a href="https://github.com/alicecaml/alice-opam-repo">its own
little opam repository</a> which
allows it to use the pre-compiled relocatable OCaml toolchain. The relocatable
OCaml toolchain has a version which is not released on the main opam repository
which means the <code>ocaml-system</code> package can’t be used, so I needed to make a new
version of <code>ocaml-system</code> matching the version of the pre-compiled toolchain
(<code>5.3.1+relocatable</code>). I did this months ago when first getting Alice working
on Linux and macOS but the version of the <code>ocaml-system</code> package originally had
some logic preventing its installation on Windows (copied from the upstream
<code>ocaml-system</code> package), but that logic turned out to be unnecessary for my use
case so I just
<a href="https://github.com/alicecaml/alice-opam-repo/commit/781db10863f3b7a3507842e88d0d3beeebd264ad">deleted it</a>.
However I did so recently and that change hasn’t made its way into Alice yet.
Making that change to Alice was
straightforward:</p>
<pre data-lang="patch" style="background-color:#ffffff;color:#323232;" class="language-patch "><code class="language-patch" data-lang="patch"><span>diff --git a/dune-workspace b/dune-workspace
</span><span>index bc77561..8d8b9db 100644
</span><span style="background-color:#ffecec;font-weight:bold;font-style:italic;color:#bd2c00;">---</span><span style="font-style:italic;color:#969896;"> a/dune-workspace
</span><span style="background-color:#eaffea;font-weight:bold;font-style:italic;color:#55a532;">+++</span><span style="font-style:italic;color:#969896;"> b/dune-workspace
</span><span style="font-weight:bold;font-style:italic;color:#969896;">@@ -7,7 +7,7 @@
</span><span> (repository
</span><span>  (name alice_frozen)
</span><span>  (url
</span><span style="background-color:#ffecec;color:#323232;">-  git+https://github.com/alicecaml/alice-opam-repo#9957c6334ca7ea18a973ea2fa9e3e56ab9c85eeb))
</span><span style="background-color:#eaffea;font-weight:bold;color:#55a532;">+</span><span style="background-color:#eaffea;color:#323232;">  git+https://github.com/alicecaml/alice-opam-repo#781db10863f3b7a3507842e88d0d3beeebd264ad))
</span><span>
</span><span> (repository
</span><span>  (name upstream_frozen)
</span><span>diff --git a/dune.lock/lock.dune b/dune.lock/lock.dune
</span><span>index 5ef36e2..fdc34a5 100644
</span><span style="background-color:#ffecec;font-weight:bold;font-style:italic;color:#bd2c00;">---</span><span style="font-style:italic;color:#969896;"> a/dune.lock/lock.dune
</span><span style="background-color:#eaffea;font-weight:bold;font-style:italic;color:#55a532;">+++</span><span style="font-style:italic;color:#969896;"> b/dune.lock/lock.dune
</span><span style="font-weight:bold;font-style:italic;color:#969896;">@@ -12,7 +12,7 @@
</span><span>   ((source
</span><span>     https://github.com/ocaml-dune/opam-overlays.git#2a9543286ff0e0656058fee5c0da7abc16b8717d))
</span><span>   ((source
</span><span style="background-color:#ffecec;color:#323232;">-    https://github.com/alicecaml/alice-opam-repo#9957c6334ca7ea18a973ea2fa9e3e56ab9c85eeb))))
</span><span style="background-color:#eaffea;font-weight:bold;color:#55a532;">+</span><span style="background-color:#eaffea;color:#323232;">    https://github.com/alicecaml/alice-opam-repo#781db10863f3b7a3507842e88d0d3beeebd264ad))))
</span><span>
</span><span> (solved_for_platforms
</span><span>  ((arch x86_64)
</span><span style="font-weight:bold;font-style:italic;color:#969896;">@@ -26,4 +26,10 @@
</span><span>   (sys-ocaml-version 5.3.1+relocatable))
</span><span>  ((arch arm64)
</span><span>   (os macos)
</span><span style="background-color:#eaffea;font-weight:bold;color:#55a532;">+</span><span style="background-color:#eaffea;color:#323232;">  (sys-ocaml-version 5.3.1+relocatable))
</span><span style="background-color:#eaffea;font-weight:bold;color:#55a532;">+</span><span style="background-color:#eaffea;color:#323232;"> ((arch x86_64)
</span><span style="background-color:#eaffea;font-weight:bold;color:#55a532;">+</span><span style="background-color:#eaffea;color:#323232;">  (os win32)
</span><span style="background-color:#eaffea;font-weight:bold;color:#55a532;">+</span><span style="background-color:#eaffea;color:#323232;">  (sys-ocaml-version 5.3.1+relocatable))
</span><span style="background-color:#eaffea;font-weight:bold;color:#55a532;">+</span><span style="background-color:#eaffea;color:#323232;"> ((arch arm64)
</span><span style="background-color:#eaffea;font-weight:bold;color:#55a532;">+</span><span style="background-color:#eaffea;color:#323232;">  (os win32)
</span><span>   (sys-ocaml-version 5.3.1+relocatable)))
</span></code></pre>
<p>Trying to build again:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS D:\src\alice&gt; dune build
</span><span>    Building ocaml-system.5.3.1+relocatable
</span><span>    Building ocaml-config.3
</span><span>    Building ocaml.5.3.1+relocatable
</span><span> Downloading xdg.3.19.1
</span><span>    Building xdg.3.19.1
</span><span>    Building base-unix.base
</span><span>Shared cache miss [bc92329a7327ee6a16f45fa75edf32e5] (_build/_fetch/checksum/md5=a460f01d409d51b7d537429881bfa276/dir): error: Unix.Unix_error(Unix.EXDEV, "link", "_build/_fetch/checksum/md5=a460f01d409d51b7d537429881bfa276/dir/.gitignore")
</span><span> Downloading ISO8601.0.2.6
</span><span>    Building ISO8601.0.2.6
</span><span> Downloading menhirLib.20240715
</span><span> Downloading menhirSdk.20240715
</span><span> Downloading menhirCST.20240715
</span><span>    Building menhirLib.20240715
</span><span>    Building menhirSdk.20240715
</span><span>    Building menhirCST.20240715
</span><span> Downloading menhir.20240715
</span><span>    Building menhir.20240715
</span><span>Shared cache miss [919bb687d0058dc8265afa905483f2bd] (_build/_fetch/checksum/sha256=1d4e9c16ed9e24d46dd757ce94adc7fc8b2068eb5ff7cd2a70fce08135a752ef/dir): error: Unix.Unix_error(Unix.EXDEV, "link", "_build/_fetch/checksum/sha256=1d4e9c16ed9e24d46dd757ce94adc7fc8b2068eb5ff7cd2a70fce08135a752ef/dir/.gitignore")
</span><span> Downloading toml.7.1.0
</span><span>    Building toml.7.1.0
</span><span> Downloading stdlib-shims.0.3.0
</span><span>    Building stdlib-shims.0.3.0
</span><span> Downloading sha.1.15.4
</span><span>    Building sha.1.15.4
</span><span>    Building seq.base
</span><span> Downloading re.1.13.2
</span><span>    Building re.1.13.2
</span><span>Shared cache miss [806d141e2f359f01b7662634ccd5886d] (_build/_fetch/checksum/sha256=796d5791e2bf7b3bff200cf5057a7a1878439ebcd74ed0f1088cf86756d52be6/dir): error: Unix.Unix_error(Unix.EXDEV, "link", "_build/_fetch/checksum/sha256=796d5791e2bf7b3bff200cf5057a7a1878439ebcd74ed0f1088cf86756d52be6/dir/.gitignore")
</span><span> Downloading fileutils.0.6.6
</span><span>    Building fileutils.0.6.6
</span><span> Downloading ordering.3.19.1
</span><span> Downloading pp.2.0.0
</span><span>    Building pp.2.0.0
</span><span>    Building ordering.3.19.1
</span><span> Downloading dyn.3.19.1
</span><span>    Building dyn.3.19.1
</span><span> Downloading climate.0.8.0
</span><span>    Building climate.0.8.0
</span></code></pre>
<p>That worked!</p>
<p>I thought I might have to apply some of the hacks I wrote about while getting
<code>ocamlformat</code> and <code>ocamllsp</code> to build
(<a href="https://github.com/alicecaml/alice/blob/1c934ce6eb096130659268e913e4da54b7b2853c/tool-build-scripts/5.3.1/windows-notes.md">here</a>)
but fortunately not. Most of those problems come from the dependency on packages
that don’t use Dune as their build system, and I’ve avoided such packages in
Alice.</p>
<p>The <code>Shared cache miss</code> errors are benign, and I think related to
the fact that my user account in on a different partition to the project I’m
building, though it’s odd that it doesn’t happen for all the dependencies.</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS D:\src\alice&gt; ls .\_build\default\alice\src\alice.exe
</span><span>
</span><span>
</span><span>    Directory: D:\src\alice\_build\default\alice\src
</span><span>
</span><span>
</span><span>Mode                 LastWriteTime         Length Name
</span><span>----                 -------------         ------ ----
</span><span>-ar---        2025-08-28     02:51        7180768 alice.exe
</span><span>
</span><span>
</span><span>PS D:\src\alice&gt; ls .\_build\install\default\bin\
</span><span>
</span><span>
</span><span>    Directory: D:\src\alice\_build\install\default\bin
</span><span>
</span><span>
</span><span>Mode                 LastWriteTime         Length Name
</span><span>----                 -------------         ------ ----
</span><span>-ar---        2025-08-28     02:51        7180768 alice.exe
</span><span>-ar---        2025-08-28     02:51        4825269 alice_demo.exe
</span></code></pre>
<p>One difference I observe between building Alice on Windows verses Unix-based
OSes is that on Windows it’s very slow to compile. It took over 7 minutes.
One possibility is that I’m building Alice from a spinning disk drive. I use
this same computer for most of my OCaml development but usually booted into
Linux and I don’t remember if I use an SSD or spinning disk for that work but
I’ve never run into this type of performance issue there.</p>
<p>The <code>Shared cache miss</code> errors suggest something is going wrong accessing Dune’s
cache, and I see that rebuilding the project causes dependencies to be
downloaded again which also suggests a cache problem. As an experiment I deleted
the Dune cache from my Mac (a 2020 Macbook Air) and rebuilt Alice there, and from a
cold cache it took about a minute compared to 10 seconds building from scratch
on my Mac from a warm cache, so the caching issue on Windows probably has an
impact on the build time but it’s clearly not the full story.</p>
<p>I tried copying the project into my Windows user account which <em>is</em> on an SSD, and the
same partition as Dune’s cache. Rebuilding from a clean project with a cold
cache took almost 9 minutes this time but there were no cache errors. I think
this rules out the explanation that my spinning disk is the problem. Rebuilding
from a clean project a second time still caused the dependencies to be
re-downloaded so I’m not sure if the cache is even enabled (but then why the
cache errors when I was on a different drive?).</p>
<p>Anyway incremental builds are still pretty fast and that’s
all I’ll be needing today so I’ll move on. The goal of this project isn’t to
debug Dune performance issues on Windows.</p>
<p>Now that I have Alice building on Windows the next step is to make sure
<code>ocamlformat</code> and <code>ocamllsp</code> work and integrate them into my editor. I built
binary versions of these tools for Windows in preparation for today’s work but I
didn’t test them yet.</p>
<p>I’m going to be using Neovim with the same
<a href="https://github.com/gridbugs/dotfiles/tree/main/nvim">configuration</a> as I use
for development on Linux and macOS. It starts an <code>ocamllsp</code> server upon opening
an OCaml source file and autoformats the code with <code>ocamlformat</code> whenever I
save an OCaml source file.</p>
<p>Both of these tools worked flawlessly on the first try.</p>
<p>The next step is to add Windows support to the <code>alice tools get</code> command which
downloads the OCaml development tools for the current platform. Alice currently
has no concept of Windows at all, and running that command on my machine prints
<code>Unknown system: MSYS_NT-10.0-22631</code>.</p>
<p>When Alice installs tools it creates a “root” which is a directory resembling a
typical Unix filesystem root, with subdirectories like <code>bin</code> and <code>share</code>. This
lets it include things like manual pages when installing tools as well as the
tools themselves. Over time I expect to support multiple different versions of the compiler
though currently <code>5.3.1+relocatable</code> is the only supported version. Similar
to <a href="https://rustup.rs/"><code>rustup</code></a> it’s possible to change the
global root that is considered “active” by running the command <code>alice tools change</code>. This creates a symlink at <code>~/.alice/current</code> pointing to (say)
<code>~/.alice/roots/5.3.1+relocatable</code>.</p>
<p>The problem is that creating a symlink on Windows requires admin permissions.
My solution is to copy the selected root into <code>~/.alice/current</code> instead.</p>
<p>Now it works:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS D:\src\alice&gt; alice tools get
</span><span>Fetching ocaml.5.3.1+relocatable...Done!
</span><span>Unpacking ocaml.5.3.1+relocatable...Done!
</span><span>Successfully installed ocaml.5.3.1+relocatable!
</span><span>
</span><span>Fetching ocamllsp.1.22.0...Done!
</span><span>Unpacking ocamllsp.1.22.0...Done!
</span><span>Successfully installed ocamllsp.1.22.0!
</span><span>
</span><span>Fetching ocamlformat.0.27.0...Done!
</span><span>Unpacking ocamlformat.0.27.0...Done!
</span><span>Successfully installed ocamlformat.0.27.0!
</span><span>
</span><span>No current root was found so making 5.3.1+relocatable the current root.
</span></code></pre>
<p>Even though that command installed the same version of the tools I’m already
using, I updated my <code>PATH</code> variable to include <code>$HOME\.alice\current\bin</code>,
so now I have:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS D:\src\alice&gt; Get-Command ocamlopt
</span><span>
</span><span>CommandType     Name          Version    Source
</span><span>-----------     ----          -------    ------
</span><span>Application     ocamlopt.exe  0.0.0.0    C:\Users\steph\.alice\current\bin\ocamlopt.exe
</span></code></pre>
<p>Next up let’s see if it’s possible to create a new project using Alice on
Windows:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS D:\tmp&gt; alice new foo
</span><span>Created new executable project in D:\tmp\foo
</span><span>
</span><span>PS D:\tmp&gt; find foo
</span><span>foo
</span><span>foo/.gitignore
</span><span>foo/Alice.toml
</span><span>foo/src
</span><span>foo/src/main.ml
</span></code></pre>
<p>Can we build it?</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS D:\tmp\foo&gt; alice build
</span><span>Program "ocamldep.opt" not found!
</span></code></pre>
<p>I do have <code>ocamldep.opt</code> installed as part of the OCaml compiler toolchain
however I suspect the <code>.exe</code> extension is causing the problem:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS D:\tmp\foo&gt; Get-Command ocamldep.opt
</span><span>
</span><span>CommandType Name             Version Source
</span><span>----------- ----             ------- ------
</span><span>Application ocamldep.opt.exe 0.0.0.0 C:\Users\steph\.alice\current\bin\ocamldep.opt.exe
</span></code></pre>
<p>I updated Alice to include the <code>.exe</code> on Windows. I also needed to update the
invocation of <code>ocamlopt.opt</code> to <code>ocamlopt.opt.exe</code>. After this change
<code>alice build</code> could run successfully.</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS D:\tmp\foo&gt; alice build
</span><span>PS D:\tmp\foo&gt; ls .\build\
</span><span>
</span><span>
</span><span>    Directory: D:\tmp\foo\build
</span><span>
</span><span>
</span><span>Mode                 LastWriteTime         Length Name
</span><span>----                 -------------         ------ ----
</span><span>-a----        2025-08-29     10:25        3134570 foo.exe
</span><span>-a----        2025-08-29     10:25            180 main.cmi
</span><span>-a----        2025-08-29     10:25            196 main.cmx
</span><span>-a----        2025-08-29     10:18             38 main.ml
</span><span>-a----        2025-08-29     10:25           1226 main.o
</span><span>
</span><span>PS D:\tmp\foo&gt; .\build\foo.exe
</span><span>Hello, World!
</span></code></pre>
<p>Alice has some commands for cleaning and running a project too:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS D:\tmp\foo&gt; alice clean
</span><span>PS D:\tmp\foo&gt; alice run
</span></code></pre>
<p>Need to add some more printouts so it’s more clear when a command completes
successfully! In the case of <code>alice run</code> something did go wrong since it didn’t
print “Hello, World!”. When I press enter again I see “Hello, World!” print at
the next prompt:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS D:\tmp\foo&gt; alice run
</span><span>PS D:\tmp\foo&gt; Hello, World!
</span></code></pre>
<p>Alice runs programs with <code>Unix.execv</code>. Here’s its documentation:</p>
<blockquote>
<p><code>execv prog args</code> execute the program in file <code>prog</code>, with the arguments <code>args</code>, and the current process environment. Note that the first argument, <code>args.(0)</code>, is by convention the filename of the program being executed, just like <code>Sys.argv.(0)</code>. These <code>execv*</code> functions never return: on success, the current program is replaced by the new one.</p>
<p>On Windows: the CRT simply spawns a new process and exits the current one. This will have unwanted consequences if e.g. another process is waiting on the current one. Using <code>create_process</code> or one of the <code>open_process_*</code> functions instead is recommended.</p>
<p><em><strong>@raise</strong></em> <code>Unix_error</code> on failure</p>
</blockquote>
<p>As the docs suggest I replaced <code>Unix.execv</code> with <code>Unix.create_process</code>.</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS D:\tmp\foo&gt; alice run
</span><span>Hello, World!
</span></code></pre>
<p>Next I want to test <code>alice dot</code> which prints the graphviz dot sourcecode for the
build graph:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS D:\tmp\foo&gt; alice dot
</span><span>digraph {
</span><span>  "foo" -&gt; {"main.cmx", "main.o"}
</span><span>  "main.cmx" -&gt; {"main.ml"}
</span><span>  "main.o" -&gt; {"main.ml"}
</span><span>}
</span></code></pre>
<p>The <code>.exe</code> is missing from the executable name. Windows obviously allows file
extensions like <code>.exe</code> to be omitted under some conditions since <code>alice run</code> was
able to execute <code>foo.exe</code> without its extension. It would still be better to
include the file extension here and in any other debug output printed by Alice.
Another place where the extension is missing is from the build commands
themselves. Rerunning the build with verbose logging:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS D:\tmp\foo&gt; alice build -vv
</span><span>[DEBUG] copying source file: main.ml
</span><span>[DEBUG] running build command: ocamlopt.opt.exe -g -c main.ml
</span><span>[DEBUG] running build command: ocamlopt.opt.exe -g -o foo main.cmx
</span></code></pre>
<p>The OCaml compiler is clearly able to add the appropriate extension even though
it was omitted from <code>-o foo</code> but it would still be better to update the build
rules so that on Windows they use the correct extension for executable files.</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS D:\tmp\foo&gt; alice build -vv
</span><span>[DEBUG] copying source file: main.ml
</span><span>[DEBUG] running build command: ocamlopt.opt.exe -g -c main.ml
</span><span>[DEBUG] running build command: ocamlopt.opt.exe -g -o foo.exe main.cmx
</span><span>
</span><span>PS D:\tmp\foo&gt; alice dot
</span><span>digraph {
</span><span>  "foo.exe" -&gt; {"main.cmx", "main.o"}
</span><span>  "main.cmx" -&gt; {"main.ml"}
</span><span>  "main.o" -&gt; {"main.ml"}
</span><span>}
</span></code></pre>
<p>Just for fun here’s a render of the graph made with <code>alice dot | dot -Tsvg &gt; graph.svg</code>
showing dependencies between build artifacts and source files.</p>
<p><img src="https://www.gridbugs.org/porting-my-toy-ocaml-build-system-to-windows/graph.svg" alt="A directed graph with nodes labeled with file names and edges representing build dependencies"></p>
<p>I added a second source file and interface to exercise Alice on a slightly less
trivial case:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>PS D:\tmp\foo&gt; alice build -vv
</span><span>[DEBUG] copying source file: foo.mli
</span><span>[DEBUG] running build command: ocamlopt.opt.exe -g -c foo.mli
</span><span>[DEBUG] copying source file: foo.ml
</span><span>[DEBUG] running build command: ocamlopt.opt.exe -g -c foo.ml
</span><span>[DEBUG] copying source file: main.ml
</span><span>[DEBUG] running build command: ocamlopt.opt.exe -g -c main.ml
</span><span>[DEBUG] running build command: ocamlopt.opt.exe -g -o foo.exe foo.cmx main.cmx
</span></code></pre>
<p><img src="https://www.gridbugs.org/porting-my-toy-ocaml-build-system-to-windows/graph2.svg" alt="A directed graph with nodes labeled with file names and edges representing build dependencies"></p>
<p>I did a little more work not directly relating to supporting Windows but which
will make it easier for Alice to find the OCaml compiler, assuming the toolchain
was installed by Alice. If Alice would run an external program (such as the
OCaml compiler) and the program isn’t in the user’s <code>PATH</code> variable then Alice
will run the program from the current root (like <code>~/.alice/current</code>). This
will make Alice easier to set up since it removes the need to add
<code>~/.alice/current/bin</code> to <code>PATH</code>.</p>
<p>And now Alice works on Windows!</p>
<p>You need to be in Powershell rather than CMD.exe, and you’ll need a C compiler
like LLVM installed an in your <code>PATH</code> for the OCaml compiler to work
correctly. After that, as long as <code>alice.exe</code> is in your <code>PATH</code>, just run
run <code>alice tools get</code> to install the OCaml compiler and dev tools, <code>alice new &lt;NAME&gt;</code>
to make a new project, and <code>alice run</code> from within the new project’s directory
to run the project.</p>
<p><img src="https://www.gridbugs.org/porting-my-toy-ocaml-build-system-to-windows/screenshot.png" alt="A screenshot of a powershell session with the commands get started with Alice"></p>
<p>Alice is highly experimental and far from ready for everyday use. The next step
will be allowing Alice packages to depend on each other.</p>
