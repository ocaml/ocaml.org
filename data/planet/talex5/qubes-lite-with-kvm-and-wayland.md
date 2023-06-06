---
title: Qubes-lite with KVM and Wayland
description:
url: https://roscidus.com/blog/blog/2021/03/07/qubes-lite-with-kvm-and-wayland/
date: 2021-03-07T15:00:00-00:00
preview_image:
featured:
authors:
- Thomas Leonard
---

<p>I've been running QubesOS as my main desktop since 2015.
It provides good security, by running applications in different Xen VMs.
However, it is also quite slow and has some hardware problems.
I've recently been trying out NixOS, KVM, Wayland and SpectrumOS,
and attempting to create something similar with more modern/compatible/faster technology.</p>
<p>This post gives my initial impressions of these tools and describes my current setup.</p>

<p><strong>Table of Contents</strong></p>
<ul>
<li><a href="https://roscidus.com/#qubesos">QubesOS</a>
</li>
<li><a href="https://roscidus.com/#nixos">NixOS</a>
<ul>
<li><a href="https://roscidus.com/#nix-store">nix-store</a>
</li>
<li><a href="https://roscidus.com/#nix-instantiate">nix-instantiate</a>
</li>
<li><a href="https://roscidus.com/#nix-pkgs">nix-pkgs</a>
</li>
<li><a href="https://roscidus.com/#nix-env">nix-env</a>
</li>
<li><a href="https://roscidus.com/#nixos-1">NixOS</a>
</li>
<li><a href="https://roscidus.com/#installing-nixos">Installing NixOS</a>
</li>
<li><a href="https://roscidus.com/#thoughts-on-nixos">Thoughts on NixOS</a>
</li>
</ul>
</li>
<li><a href="https://roscidus.com/#why-use-virtual-machines">Why use virtual machines?</a>
</li>
<li><a href="https://roscidus.com/#spectrumos">SpectrumOS</a>
</li>
<li><a href="https://roscidus.com/#wayland">Wayland</a>
<ul>
<li><a href="https://roscidus.com/#protocol">Protocol</a>
</li>
<li><a href="https://roscidus.com/#copying-text">Copying text</a>
</li>
<li><a href="https://roscidus.com/#security">Security</a>
</li>
</ul>
</li>
<li><a href="https://roscidus.com/#future-work">Future work</a>
</li>
</ul>
<p>( this post also appeared on <a href="https://news.ycombinator.com/item?id=26378854">Hacker News</a> and
<a href="https://lobste.rs/s/cisgn2/qubes_lite_with_kvm_wayland">Lobsters</a> )</p>
<h2>QubesOS</h2>
<p><a href="https://www.qubes-os.org/">QubesOS</a> aims to provide &quot;a reasonably secure operating system&quot;.
It does this by running multiple virtual machines under the Xen hypervisor.
Each VM's windows have a different colour and tag, but they appear together as a single desktop.
The VMs I run include:</p>
<ul>
<li><code>com</code> for email and similar (the only VM that sees my email password).
</li>
<li><code>dev</code> for software development.
</li>
<li><code>shopping</code> (the only VM that sees my card number).
</li>
<li><code>personal</code> (with no Internet access)
</li>
<li><code>untrusted</code> (general browsing)
</li>
</ul>
<p>The desktop environment itself is another Linux VM (<code>dom0</code>), used for managing the other VMs.
Most of the VMs are running Fedora (the default for Qubes), although I run Debian in <code>dev</code>.
There are also a couple of system VMs; one for dealing with the network hardware,
and one providing a firewall between the VMs.</p>
<p>You can run <code>qvm-copy</code> in a VM to copy a file to another VM.
<code>dom0</code> pops up a dialog box asking which VM should receive the file, and it arrives there
as <code>~/QubesIncoming/$source_vm/$file</code>.
You can also press Ctrl-Shift-C to copy a VM's clipboard to the global clipboard, and then
press Ctrl-Shift-V in a window of the target VM to copy to that VM's clipboard,
ready for pasting into an application.</p>
<p>I think Qubes does a very good job at providing a secure environment.</p>
<p>However, it has poor hardware compatibility and it feels sluggish, even on a powerful machine.
I bought a new machine a while ago and found that the motherboard only provided a single video output, limited to 30Hz.
This meant I had to buy a discrete graphics card. With the card enabled, the machine <a href="https://github.com/QubesOS/qubes-issues/issues/5459">fails to resume from suspend</a>,
and locks up from time to time (it's completely stable with the card removed or disabled).
I spent some time trying to understand the driver code, but I didn't know enough about graphics, the Linux kernel, PCI suspend, or Xen to fix it.</p>
<p>I was also having some other problems with QubesOS:</p>
<ul>
<li>Graphics performance is terrible (especially on a 4k monitor).
Qubes disables graphics acceleration in VMs for security reasons, but it was slow even for software rendering.
</li>
<li>It recently started freezing for a couple of seconds from time to time - annoying when you're trying to type.
</li>
<li>It uses LVM thin-pools for VM storage, which I don't understand, and which sometimes need repairing (haven't lost any data, though).
</li>
<li>dom0 is out-of-date and generally not usable.
This is intentional (you should be using VMs),
but my security needs aren't that high and it would be nice to be able to do video conferencing these days.
Also, being able to print over USB and use bluetooth would be handy.
</li>
</ul>
<p>Anyway, I decided it was time to try something new.
Linux now has its own built-in hypervisor (KVM), and I thought that would probably work better with my hardware.
I was also keen to try out Wayland, which is built around shared-memory and I thought it might therefore work better with VMs.
How easy would it be to recreate a Qubes-like environment directly on Linux?</p>
<h2>NixOS</h2>
<p>I've been meaning to try <a href="https://nixos.org/">NixOS</a> properly for some time. Ever since I started using Linux, its package management has struck me as absurd. On Debian, Fedora, etc, installing a package means letting it put files wherever it likes; which effectively gives the package author root on your system. Not a good base for sandboxing!</p>
<p>Also, they make it difficult to try out 3rd-party software, or to test newer versions of just some packages.</p>
<p>In 2003 I created <a href="https://0install.net/">0install</a> to address these problems, and Nix has very similar goals. I thought Nix was a few years younger, but looking at its Git history the first commit was on Mar 12, 2003. I announced the first preview of 0install just two days later, so both projects must have started writing code within a few days of each other!</p>
<p>NixOS is made up of quite a few components. Here is what I've learned so far:</p>
<h3>nix-store</h3>
<p>The store holds the files of all the programs, and is the central component of the system.
Each version of a package goes in its own directory (or file), at <code>/nix/store/$HASH</code>.
You can add data to the store directly, like this:</p>
<pre><code>$ echo hello &gt; file

$ nix-store --add-fixed sha256 file
/nix/store/1vap48aqggkk52ijn2prxzxv7cnzvs0w-file

$ cat /nix/store/1vap48aqggkk52ijn2prxzxv7cnzvs0w-file
hello
</code></pre>
<p>Here, the store location is calculated from the hash of the contents of the file we added (as with <code>0install store add</code> or <code>git hash-object</code>).</p>
<p>However, you can also add things to the store by asking Nix to run a build script.
For example, to compile some source code:</p>
<ol>
<li>You add the source code and some build instructions (a &quot;derivation&quot; file) to the store.
</li>
<li>You ask the store to build the derivation. It runs your build script in a container sandbox.
</li>
<li>The results are added to the store, using the hash of the build instructions (not the hash of the result) as the directory name.
</li>
</ol>
<p>If a package in the store depends on another one (at build time or run time), it just refers to it by its full path.
For example, a bash script in the store will start something like:</p>
<pre><code>#! /nix/store/vnyfysaya7sblgdyvqjkrjbrb0cy11jf-bash-4.4-p23/bin/bash
...
</code></pre>
<p>If two users want to use the same build instructions, the second one will see that the hash already exists and can just reuse that.
This allows users to compile software from source and share the resulting binaries, without having to trust each other.</p>
<p>Ideally, builds should be reproducible.
To encourage this, builds which use the hash of the build instructions for the result path are built in a sandbox without network access.
So, you can't submit a build job like &quot;Download and compile whatever is the latest version of Vim&quot;.
But you can discover the latest version yourself and then submit two separate jobs to the store:</p>
<ol>
<li>&quot;Download Vim 8.2, with hash XXX&quot; (a fixed-output job, which therefore has network access)
</li>
<li>&quot;Build Vim from hash XXX&quot;
</li>
</ol>
<p>You can run <code>nix-collect-garbage</code> to delete everything from the store that isn't reachable via the symlinks under <code>/nix/var/nix/gcroots/</code>.
Users can put symlinks to things they care about keeping in <code>/nix/var/nix/gcroots/per-user/$USER/</code>.</p>
<p>By default, the store is also configured with a trusted binary cache service,
and will try to download build results from there instead of compiling locally when possible.</p>
<h3>nix-instantiate</h3>
<p>Writing derivation files by hand is tedious, so Nix provides a templating language to create them easily.
The Nix language is dynamically typed and based around maps/dictionaries (which it confusingly refers to as &quot;sets&quot;).
<code>nix-instantiate file.nix</code> will generate a derivation from <code>file.nix</code> and add it to the store.</p>
<p>An Nix file looks like this:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
</pre></td><td class="code"><pre><code class="nix"><span class="line"><span class="nb">derivation</span> <span class="p">{</span> <span class="ss">system =</span> <span class="s2">&quot;x86_64-linux&quot;</span><span class="p">;</span> <span class="ss">builder =</span> <span class="o">.</span><span class="l">/myfile</span><span class="p">;</span> <span class="ss">name =</span> <span class="s2">&quot;foo&quot;</span><span class="p">;</span> <span class="p">}</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Running <code>nix-instantiate</code> on this will:</p>
<ol>
<li>Add <code>myfile</code> to the store.
</li>
<li>Add the generated <code>foo.drv</code> to the store, including the full store path of <code>myfile</code>.
</li>
</ol>
<h3>nix-pkgs</h3>
<p>Writing Nix expressions for every package you want would also be tedious.
The <a href="https://github.com/NixOS/nixpkgs">nixpkgs</a> Git repository contains a Nix expression that evaluates to a set of derivations,
one for each package in the distribution.
It also contains a library of useful helper functions for packages
(e.g. it knows how to handle GNU autoconf packages automatically).</p>
<p>Rather than evaluating the whole lot, you use <code>-A</code> to ask for a single package.
For example, you can use <code>nix-instantiate ./nixpkgs/default.nix -A firefox</code> to generate a derivation for Firefox.</p>
<p><code>nix-build</code> is a quick way to create a derivation with <code>nix-instantiate</code> and build it with <code>nix-store</code>.
It will also create a <code>./result</code> symlink pointing to its path in the store,
as well as registering <code>./result</code> with the garbage collector under <code>/nix/var/nix/gcroots/auto/</code>.
For example, to build and run Firefox:</p>
<pre><code>nix-build ./nixpkgs/default.nix -A firefox
./result/bin/firefox
</code></pre>
<p>If you use nixpkgs without making any changes, it will be able to download a pre-built binary from the cache service.</p>
<h3>nix-env</h3>
<p>Keeping track of all these symlinks would be tedious too,
but you can collect them all together by making a package that depends on every application you want.
Its build script will produce a <code>bin</code> directory full of symlinks to the applications.
Then you could just point your <code>$PATH</code> variable at that <code>bin</code> directory in the store.</p>
<p>To make updating easier, you will actually add <code>~/.nix-profile/bin/</code> to <code>$PATH</code> and
update <code>.nix-profile</code> to point at the latest build of your environment package.</p>
<p>This is essentially what <code>nix-env</code> does, except with yet more symlinks to allow for
switching between multiple profiles, and to allow rolling back to previous environments
if something goes wrong.</p>
<p>For example, to install Firefox so you can run it via <code>$PATH</code>:</p>
<pre><code>nix-env -i firefox
</code></pre>
<h3>NixOS</h3>
<p>Finally, just as <code>nix-env</code> can create a user environment with <code>bin</code>, <code>man</code>, etc,
a similar process can create a root filesystem for a Linux distribution.</p>
<p><code>nixos-rebuild</code> reads the <code>/etc/nixos/configuration.nix</code> configuration file,
generates a system environment,
and then updates grub and the <code>/run/current-system</code> symlink to point to it.</p>
<p>In fact, it also lists previous versions of the system environment in the grub file, so
if you mess up the configuration you can just choose an earlier one from the boot
menu to return to that version.</p>
<h3>Installing NixOS</h3>
<p>To install NixOS you boot one of the live images at <a href="https://nixos.org">https://nixos.org</a>.
Which you use only affects the installation UI, not the system you end up with.</p>
<p>The manual walks you through the installation process, showing how to partition
the disk, format and mount the partitions, and how to edit the configuration file.
I like this style of installation, where it teaches you things instead of just doing it for you.
Most of the effort in switching to a new system is learning about it, so I'd rather
spend 3 hours learning stuff following an installation guide than use a 15-minute
single-click installer that teaches me nothing.</p>
<p>The configuration file (<code>/etc/nixos/configuration.nix</code>) is just another Nix expression.
Most things are set to off by default (I approve), but can be changed easily.
For example, if you want sound support you change that setting to <code>sound.enable = true</code>,
and if you also want to use PulseAudio then you set <code>hardware.pulseaudio.enable = true</code> too.</p>
<p>Every system service supported by NixOS is controlled from here,
with all kinds of options, from <code>programs.vim.defaultEditor = true</code> (so you don't get trapped in <code>nano</code>)
to <code>services.factorio.autosave-interval</code>.
Use <code>man configuration.nix</code> to see the available settings.</p>
<p>NixOS defaults to an X11 desktop, but I wanted to try Wayland (and <a href="https://github.com/swaywm/sway">Sway</a>).
Based on the <a href="https://nixos.wiki/wiki/Sway">NixOS wiki</a> instructions, I used this:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
<span class="line-number">8</span>
<span class="line-number">9</span>
<span class="line-number">10</span>
<span class="line-number">11</span>
<span class="line-number">12</span>
<span class="line-number">13</span>
<span class="line-number">14</span>
</pre></td><td class="code"><pre><code class="nix"><span class="line">  programs<span class="o">.</span><span class="ss">sway =</span> <span class="p">{</span>
</span><span class="line">    <span class="ss">enable =</span> <span class="no">true</span><span class="p">;</span>
</span><span class="line">    wrapperFeatures<span class="o">.</span><span class="ss">gtk =</span> <span class="no">true</span><span class="p">;</span> <span class="c1"># so that gtk works properly</span>
</span><span class="line">    <span class="ss">extraSessionCommands =</span> <span class="s2">&quot;export MOZ_ENABLE_WAYLAND=1&quot;</span><span class="p">;</span>
</span><span class="line">    <span class="ss">extraPackages =</span> <span class="k">with</span> pkgs<span class="p">;</span> <span class="p">[</span>
</span><span class="line">      swaylock
</span><span class="line">      swayidle
</span><span class="line">      xwayland
</span><span class="line">      wl-clipboard
</span><span class="line">      mako
</span><span class="line">      alacritty
</span><span class="line">      dmenu
</span><span class="line">    <span class="p">];</span>
</span><span class="line">  <span class="p">};</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>The <code>xwayland</code> bit is important; without that you can't run any X11 applications.</p>
<p>My only complaint with the NixOS installation instructions is that following them will leave you with an unencrypted system,
which isn't very useful.
When partitioning, you have to skip ahead to the LUKS section of the manual, which just gives some options but no firm advice.
I created two primary partitions: a 1G unencrypted <code>/boot</code>, and a LUKS partition for the rest of the disk.
Then I created an LVM volume group from the <code>/dev/mapper/crypted</code> device and added the other partitions in that.</p>
<p>Once the partitions are mounted and the configuration file is complete,
<code>nixos-install</code> downloads everything and configures grub.
Then you reboot into the new system.</p>
<p>Once running the new system you can made further edits to the configuration file there in the same way,
and use <code>nixos-rebuild switch</code> to generate a new system.
It seems to be pretty good at updating the running system to the new settings, so you don't normally need to reboot
after making changes.</p>
<p>The big mistake I made was forgetting to add <code>/boot</code> to fstab.
When I ran <code>nixos-rebuild</code> it put all the grub configuration on the encrypted partition, rendering the system unbootable.
I fixed that with <code>chattr +i /boot</code> on the unmounted partition.
That way, trying to rebuild with <code>/boot</code> unmounted will just give an error message.</p>
<h3>Thoughts on NixOS</h3>
<p>I've been using the system for a few weeks now and I've had no problems with Nix so far.
Nix has been fast and reliable and there were fairly up-to-date packages for everything I wanted
(I'm using the stable release).
There is a lot to learn, but plenty of documentation.</p>
<p>When I wanted a newer package (<code>socat</code> with vsock support, only just released) I just told Nix to install it from the latest Git checkout of nixpkgs.
Unlike on Debian and similar systems, doing this doesn't interfere with any other packages (such as forcing a system-wide upgrade of libc).</p>
<p>I think Nix does download more data than most other systems, but networks are fast enough now that it doesn't seem to matter.
For example, let's say you're running Python 3.9.0 and you want to update to 3.9.1:</p>
<ul>
<li>
<p>With <strong>Debian</strong>: <code>apt-get upgrade</code> downloads the new version, which gets unpacked over the old one.
As the files are unpacked, the system moves through an exciting series of intermediate states no-one has thought about.
Running programs may crash as they find their library versions changing under them (though it's usually OK).
Only root can update software.</p>
</li>
<li>
<p>With <strong>0install</strong>: <code>0install update</code> downloads the new version, unpacking it to a new directory.
Running programs continue to use the old version.
When a new program is started, 0install notices the update and runs the solver again.
If the program is compatible with the new Python then it uses that. If not, it continues with the old one.
You can run any previous version if there is a problem.</p>
</li>
<li>
<p>With <strong>Nix</strong>: <code>nix-env -u</code> downloads the new version, unpacking it to a new directory.
It also downloads (or rebuilds) every package depending on Python, creating new directories for each of them.
It then creates a new environment with symlinks to the latest version of everything.
Running programs continue to use the old version.
Starting a new program will use the new version.
You can revert the whole environment back to the previous version if there is a problem.</p>
</li>
<li>
<p>With <strong>Docker</strong>: <code>docker pull</code> downloads the new version of a single application,
downloading most or all of the application's packages, whether Python related or not.
Existing containers continue running with the old version.
New containers will default to using the new version.
You can specify which version to use when starting a program.
Other applications continue using the old version of Python until their authors update them
(you must update each application individually, rather than just updating Python itself).</p>
</li>
</ul>
<p>The main problem with NixOS is that it's quite different to other Linux systems, so there's a lot to relearn.
Also, existing knowledge about how to edit <code>fstab</code>, <code>sudoers</code>, etc, isn't so useful, as you have to provide all configuration in Nix syntax.
However, having a single (fairly sane) syntax for everything is a nice bonus, and being able to generate things using the templating language is useful.
For example, for my network setup I use a bunch of tap devices (one for each of my VMs).
It was easy to write a little Nix function (<code>mktap</code>) to generate them all from a simple list.
Here's that section of my <code>configuration.nix</code>:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
<span class="line-number">8</span>
<span class="line-number">9</span>
<span class="line-number">10</span>
<span class="line-number">11</span>
<span class="line-number">12</span>
<span class="line-number">13</span>
<span class="line-number">14</span>
<span class="line-number">15</span>
<span class="line-number">16</span>
<span class="line-number">17</span>
<span class="line-number">18</span>
<span class="line-number">19</span>
<span class="line-number">20</span>
<span class="line-number">21</span>
<span class="line-number">22</span>
<span class="line-number">23</span>
<span class="line-number">24</span>
<span class="line-number">25</span>
<span class="line-number">26</span>
</pre></td><td class="code"><pre><code class="nix"><span class="line">  <span class="ss">networking =</span> <span class="p">{</span>
</span><span class="line">    <span class="ss">useDHCP =</span> <span class="no">false</span><span class="p">;</span>
</span><span class="line">    <span class="ss">interfaces =</span>
</span><span class="line">      <span class="k">let</span> <span class="ss">mktap =</span> ip<span class="p">:</span> <span class="p">{</span>
</span><span class="line">          <span class="ss">virtual =</span> <span class="no">true</span><span class="p">;</span>
</span><span class="line">          <span class="ss">virtualOwner =</span> <span class="s2">&quot;tal&quot;</span><span class="p">;</span>
</span><span class="line">          ipv4<span class="o">.</span><span class="ss">addresses =</span> <span class="p">[</span>
</span><span class="line">            <span class="p">{</span> <span class="ss">address =</span> ip<span class="p">;</span> <span class="ss">prefixLength =</span> <span class="mi">31</span><span class="p">;</span> <span class="p">}</span>
</span><span class="line">          <span class="p">];</span>
</span><span class="line">        <span class="p">};</span>
</span><span class="line">      <span class="k">in</span>
</span><span class="line">      <span class="p">{</span>
</span><span class="line">        eno2<span class="o">.</span><span class="ss">useDHCP =</span> <span class="no">true</span><span class="p">;</span>
</span><span class="line">        wlo1<span class="o">.</span><span class="ss">useDHCP =</span> <span class="no">true</span><span class="p">;</span>
</span><span class="line">        <span class="ss">tapdev =</span> mktap <span class="s2">&quot;10.0.0.2&quot;</span><span class="p">;</span>
</span><span class="line">        <span class="ss">tapcom =</span> mktap <span class="s2">&quot;10.0.0.4&quot;</span><span class="p">;</span>
</span><span class="line">        <span class="ss">tapshopping =</span> mktap <span class="s2">&quot;10.0.0.6&quot;</span><span class="p">;</span>
</span><span class="line">        <span class="ss">tapbanking =</span> mktap <span class="s2">&quot;10.0.0.8&quot;</span><span class="p">;</span>
</span><span class="line">        <span class="ss">tapuntrusted =</span> mktap <span class="s2">&quot;10.0.0.10&quot;</span><span class="p">;</span>
</span><span class="line">      <span class="p">};</span>
</span><span class="line">    <span class="ss">nat =</span> <span class="p">{</span>
</span><span class="line">      <span class="ss">enable =</span> <span class="no">true</span><span class="p">;</span>
</span><span class="line">      <span class="ss">externalInterface =</span> <span class="s2">&quot;eno2&quot;</span><span class="p">;</span>
</span><span class="line">      <span class="ss">internalIPs =</span> <span class="p">[</span> <span class="s2">&quot;10.0.0.0/8&quot;</span> <span class="p">];</span>
</span><span class="line">    <span class="p">};</span>
</span><span class="line">  <span class="p">};</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Overall, I'm very happy with NixOS so far.</p>
<h2>Why use virtual machines?</h2>
<p>With NixOS I had a nice host environment, but after using Qubes I wanted to run my applications in VMs.</p>
<p>The basic problem is that Linux is the only thing that knows how to drive all the hardware,
but Linux security is not ideal. There are several problems:</p>
<ol>
<li>Linux is written in C.
This makes security bugs rather common and, more importantly, means that a bug in one part of the code
can impact any other part of the code. Nothing is secure unless everything is secure.
</li>
<li>Linux has a rather large API (hundreds of syscalls).
</li>
<li>The Linux (Unix) design predates the Internet, and security has been somewhat bolted on afterwards.
</li>
</ol>
<p>For example, imagine that we want to run a program with access to the network, but not to the graphical display.
We can create a new Linux container for it using <a href="https://github.com/containers/bubblewrap">bubblewrap</a>, like this:</p>
<pre><code>$ ls -l /run/user/1000/wayland-0 /tmp/.X11-unix/X0
srwxr-xr-x 1 tal users 0 Feb 18 16:41 /run/user/1000/wayland-0
srwxr-xr-x 1 tal users 0 Feb 18 16:41 /tmp/.X11-unix/X0

$ bwrap \
    --ro-bind / / \
    --dev /dev \
    --tmpfs /home/tal \
    --tmpfs /run/user \
    --tmpfs /tmp \
    --unshare-all --share-net \
    bash

$ ls -l /run/user/1000/wayland-0 /tmp/.X11-unix/X0
ls: cannot access '/run/user/1000/wayland-0': No such file or directory
ls: cannot access '/tmp/.X11-unix/X0': No such file or directory
</code></pre>
<p>The container has an empty home directory, empty <code>/tmp</code>, and no access to the display sockets.
If we run Firefox in this environment then... it opens its window just fine!
How? <code>strace</code> shows what happened:</p>
<pre><code>connect(4, {sa_family=AF_UNIX, sun_path=&quot;/run/user/1000/wayland-0&quot;}, 27) = -1 ENOENT (No such file or directory)
socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC, 0) = 4
connect(4, {sa_family=AF_UNIX, sun_path=@&quot;/tmp/.X11-unix/X0&quot;}, 20) = 0
</code></pre>
<p>After failing to connect to Wayland, it then tried using X11 (via Xwayland) instead. Why did that work?
If the first byte of the socket pathname is <code>\0</code> then Linux instead interprets it as an &quot;abstract&quot; socket address,
not subject to the usual filesystem permission rules.</p>
<p>Trying to anticipate these kinds of special cases is just too much work.
Linux really wants everything on by default, and you have to find and disable every feature individually.
By contrast, virtual machines tend to have integrations with the host off by default.
The also tend to have much smaller APIs (e.g. just reading and writing disk blocks or network frames),
with the rich Unix API entirely inside the VM, provided by a separate instance of Linux.</p>
<h2>SpectrumOS</h2>
<p>I was able to set up a qemu guest and restore my <code>dev</code> Qubes VM in that, but it didn't integrate nicely with the rest of the desktop.
Installing ssh allowed me to connect in with <code>ssh -Y dev</code>, allowing apps in the VM to open an X connection to Xwayland on the host.
That was somewhat usable, but still a bit slower than Qubes had been (which was already a bit too slow).</p>
<p>Searching for a way to forward the Wayland connection directly, I came across the <a href="https://spectrum-os.org/">SpectrumOS</a> project.
SpectrumOS aims to use one virtual machine per application, using shared directories so that VM files are stored on the host,
simplifying management.
It uses <a href="https://chromium.googlesource.com/chromiumos/platform/crosvm/">crosvm</a> from the ChromiumOS project instead of qemu, because it has a driver that allows forwarding Wayland connections
(and also because it's written in Rust rather than C).
The project's single developer is currently taking a break from the project, and says &quot;I'm currently working towards a proof of concept&quot;.</p>
<p>However, there is some useful stuff in the <a href="https://spectrum-os.org/git/nixpkgs/">SpectrumOS repository</a> (which is a fork of nixpkgs).
In particular, it contains:</p>
<ul>
<li>A version of Linux with the <code>virtwl</code> kernel module, which connects to crosvm's Wayland driver.
</li>
<li>A package for <a href="https://chromium.googlesource.com/chromiumos/platform2/+/refs/heads/main/vm_tools/sommelier/">sommelier</a>, which connects applications to <code>virtwl</code>.
</li>
<li>A Nix expression to build a root filesystem for the VM.
</li>
</ul>
<p>Building that, I was able to run the project's demo, which runs the Wayfire compositor inside the VM, appearing in a window on the host.
Dragging the nested window around, the pixels flowed smoothly across my screen in exactly the way that pixels on QubesOS don't.</p>
<p>This was encouraging, but I didn't want to run a nested window manager.
I tried running Firefox directly (without Wayfire),
but it complained that sommelier didn't provide a new enough version of something, and
running weston-terminal immediately segfaulted sommelier.</p>
<p>Why do we need the sommelier process anyway?
The problem is that, while <code>virtwl</code> mostly proxies Wayland messages directly, it can't send arbitrary FDs to the host.
For example, if you want to forward a writable stream from an application to <code>virtwl</code>
you must first create a pipe from the host using a special <code>virtwl</code> ioctl,
then read from that and copy the data to the application's regular Linux pipe.</p>
<p>With <a href="https://spectrum-os.org/lists/hyperkitty/list/discuss@spectrum-os.org/thread/VP3KJV3JYWSLJTUKDT3MAKIABZGDCSPN/">help from the mailing list</a>, I managed to get it somewhat usable:</p>
<ul>
<li>I enabled <code>VIRTIO_FS</code>, allowing me to mount a host directory into the VM (for sharing files).
</li>
<li>I created some tap devices (as mentioned above) to get guest networking going.
</li>
<li>Adding ext4 to the kernel image allowed me to mount the VM's LVM partition.
</li>
<li>Setting <code>FONTCONFIG_FILE</code> got some usable fonts (otherwise, there was no monospace font for the terminal).
</li>
<li>I hacked sommelier to claim it supported the latest protocols, which got Firefox running.
</li>
<li>Configuring sommelier for Xwayland let X applications run.
</li>
<li>I replaced the non-interactive <code>bash</code> shell with <code>fish</code> so I could edit commands.
</li>
<li>I ran <code>(while true; do socat vsock-listen:5000 exec:dash; done)</code> at the end of the VM's boot script.
Then I could start e.g. the VM's Firefox with <code>echo 'firefox&amp;' | socat stdin vsock-connect:7:5000</code>
on the host, allowing me to add launchers for guest applications.
</li>
</ul>
<p>Making changes to the root filesystem was fairly easy once I'd read the Nix manuals.
To add an application (e.g. <code>libreoffice</code>), you import it at the start of <a href="https://spectrum-os.org/git/nixpkgs/tree/pkgs/os-specific/linux/spectrum/rootfs/default.nix">rootfs/default.nix</a> and add it to the <code>path</code> variable.
The Nix expression gets the transitive dependencies of <code>path</code> from the Nix store and packs them into a squashfs image.</p>
<p>True, my squashfs image is getting a bit big.
Maybe I should instead make a minimal squashfs boot image, plus a shared directory of hard links to the required files.
That would allow sharing the data with the host.
I could also just share the whole <code>/nix/store</code> directory, if I wanted to make all host software available to guests.</p>
<p>I made another Nix script to add various VM boot commands to my host environment.
For example, running <code>qvm-start-shopping</code> boots my shopping VM using crosvm,
with the appropriate LVM data partition, network settings, and shared host directory.</p>
<p>I think, ideally, this would be a systemd socket-activated user service rather than a shell script.
Then attempting to run Firefox by sending a command to the VM socket would cause systemd to boot the VM
(if not already running).
For now, I boot each VM manually in a terminal and then press Win-Shift-2 to banish it to workspace 2,
with all the other VM root consoles.</p>
<p>The <code>virlwl</code> Wayland forwarding feels pretty fast (much faster than Qubes' X graphics).</p>
<h2>Wayland</h2>
<p>I now had a mostly functional Qubes-like environment, running most of my applications in VMs,
with their windows appearing on the host desktop like any other application.
However, I also had some problems:</p>
<ul>
<li>A stated goal of Wayland is &quot;every frame is perfect&quot;. However, applications generally seemed to open at the wrong size and then jump to their correct size, which was a bit jarring.
</li>
<li>Vim opened its window with the scrollbar at the far left of the window, making the text invisible until you resized the window.
</li>
<li>Wayland is supposed to have better support for high-DPI displays.
However, this doesn't work with Xwayland, which turns everything blurry,
and the <a href="https://news.ycombinator.com/item?id=19360176">recommended work-around</a> is to use a scale-factor of 1
and configure each application to use bigger fonts.
This is easy enough with X applications (e.g. set <code>ft.dpi: 150</code> with <code>xrdb</code>), but Wayland apps must be configured individually.
</li>
<li>Wayland doesn't have cursor themes and you have to configure every application individually to use a larger cursor too.
</li>
<li>Copying text didn't seem to work reliably. Sometimes there would be a long delay, after which the text might or might not appear. More often, it would just paste something completely different and unexpected. Even when it did paste the right text, it would often have ^M characters inserted into it.
</li>
</ul>
<p>I decided it was time to learn more about Wayland.
I discovered <a href="https://wayland-book.com/">wayland-book.com</a>, which does a good job of introducing it
(though the book is only half finished at the moment).</p>
<h3>Protocol</h3>
<p>One very nice feature of Wayland is that you can run any Wayland application with <code>WAYLAND_DEBUG=1</code>
and it will display a fairly readable trace of all the Wayland messages it sends and receives.
Let's look at a simple application that just connects to the server (compositor) and opens a window:</p>
<pre><code>$ WAYLAND_DEBUG=1 test.exe
-&gt; wl_display@1.get_registry registry:+2
-&gt; wl_display@1.sync callback:+3
</code></pre>
<p>The client connects to the server's socket at <code>/run/user/1000/wayland-0</code> and sends two messages
to object 1 (of type <code>wl_display</code>), which is the only object available in a new connection.
The <code>get_registry</code> request asks the server to add the registry to the conversation and call it object 2.
The <code>sync</code> request just asks the server to confirm it got it, using a new callback object (with ID 3).</p>
<p>Both clients and servers can add objects to the conversation.
To avoid numbering conflicts, clients assign low numbers and servers pick high ones.</p>
<p>On the wire, each message gives the object ID, the operation ID, the length in bytes, and then the arguments.
Objects are thought of as being at the server, so the client sends request messages <em>to</em> objects,
while the server emits event messages <em>from</em> objects.
At the wire level there's no difference though.</p>
<p>When the server gets the <code>get_registry</code> request it adds the registry,
which immediately emits one event for each available service, giving the maximum supported version.
The client receives these messages, followed by the callback notification from the <code>sync</code> message:</p>
<pre><code>&lt;- wl_registry@2.global name:0 interface:&quot;wl_compositor&quot; version:4
&lt;- wl_registry@2.global name:1 interface:&quot;wl_subcompositor&quot; version:1
&lt;- wl_registry@2.global name:2 interface:&quot;wl_shm&quot; version:1
&lt;- wl_registry@2.global name:3 interface:&quot;xdg_wm_base&quot; version:1
&lt;- wl_registry@2.global name:4 interface:&quot;wl_output&quot; version:2
&lt;- wl_registry@2.global name:5 interface:&quot;wl_data_device_manager&quot; version:3
&lt;- wl_registry@2.global name:6 interface:&quot;zxdg_output_manager_v1&quot; version:3
&lt;- wl_registry@2.global name:7 interface:&quot;gtk_primary_selection_device_manager&quot; version:1
&lt;- wl_registry@2.global name:8 interface:&quot;wl_seat&quot; version:5
&lt;- wl_callback@3.done callback_data:1129040
</code></pre>
<p>The callback tells the client it has seen all the available services, and so it now picks the ones it wants.
It has to choose a version no higher than the one offered by the server.
Protocols starting with <code>wl_</code> are from the core Wayland protocol; the others are extensions.
The leading <code>z</code> in <code>zxdg_output_manager_v1</code> indicates that the protocol is &quot;unstable&quot; (under development).</p>
<p>The protocols are defined in various XML files, which are scattered over the web.
The core protocol is defined in <a href="https://github.com/wayland-project/wayland/blob/master/protocol/wayland.xml">wayland.xml</a>.
These XML files can be used to generate typed bindings for your programming language of choice.</p>
<p>Here, the application picks <code>wl_compositor</code> (for managing drawing surfaces), <code>wl_shm</code> (for sharing memory with the server),
and <code>xdg_wm_base</code> (for desktop windows).</p>
<pre><code>-&gt; wl_registry@2.bind name:0 id:+4(wl_compositor:v4)
-&gt; wl_registry@2.bind name:2 id:+5(wl_shm:v1)
-&gt; wl_registry@2.bind name:3 id:+6(xdg_wm_base:v1)
</code></pre>
<p>The bind message is unusual in that the client gives the interface and version of the object it is creating.
For other messages, both sides know the type from the schema, and the version is always the same as the parent object.
Because the client chose the new IDs, it doesn't need to wait for the server;
it continues by using the new objects to create a top-level window:</p>
<pre><code>-&gt; wl_compositor@4.create_surface id:+7
-&gt; xdg_wm_base@6.get_xdg_surface id:+8 surface:7
-&gt; xdg_surface@8.get_toplevel id:+9
-&gt; xdg_toplevel@9.set_title title:&quot;example app&quot;
-&gt; wl_surface@7.commit 
</code></pre>
<p>This API is pretty strange.
The core Wayland protocol says how to make generic drawing surfaces, but not how to make windows,
so the application is using the <code>xdg_wm_base</code> extension to do that.
Logically, there's only one object here (a toplevel window),
but it ends up making three separate Wayland objects representing the different aspects of it.</p>
<p>The <code>commit</code> tells the server that the client has finished setting up the window and the server should
now do something with it.</p>
<p>The above was all in response to the callback firing.
The client now processes the last message in that batch, which is the server destroying the callback:</p>
<pre><code>&lt;- wl_display@1.delete_id id:3
</code></pre>
<p>Object destruction is a bit strange in Wayland.
Normally, clients ask for things to be destroyed (by sending a &quot;destructor&quot; message)
and the server confirms by sending <code>delete_id</code> from object 1.
But this isn't symmetrical: there is no standard way for a client to confirm deletion when the server calls
a destructor (such as the callback's <code>done</code>), so these have to be handled on a case-by-case basis.
Since callbacks don't accept any messages, there is no need for the client to confirm that it got the <code>done</code>
message and the server just sends a delete message immediately.</p>
<p>The client now waits for the server to respond to all the messages it sent about the new window,
and gets a bunch of replies:</p>
<pre><code>&lt;- wl_shm@5.format format:0
&lt;- wl_shm@5.format format:1
&lt;- wl_shm@5.format format:875709016
&lt;- wl_shm@5.format format:875708993
&lt;- xdg_wm_base@6.ping serial:1129043
-&gt; xdg_wm_base@6.pong serial:1129043
&lt;- xdg_toplevel@9.configure width:0 height:0 states:&quot;&quot;
&lt;- xdg_surface@8.configure serial:1129042
-&gt; xdg_surface@8.ack_configure serial:1129042
</code></pre>
<p>It gets some messages telling it what pixel formats are supported, a ping message (which the server sends from time to time to check the client is still alive),
and a configure message giving the size for the new window.
Oddly, Sway has set the size to 0x0, which means the client should choose whatever size it likes.</p>
<p>The client picks a suitable default size, allocates some shared memory (by opening a tmpfs file and immediately unlinking it),
shares the file descriptor with the server (<code>create_pool</code>), and then carves out a portion of the memory to use as a buffer for the pixel data:</p>
<pre><code>-&gt; wl_shm@5.create_pool id:+3 fd:(fd) size:1228800
-&gt; wl_shm_pool@3.create_buffer id:+10 offset:0 width:640 height:480 stride:2560 format:1
-&gt; wl_shm_pool@3.destroy 
</code></pre>
<p>In this case it used the whole memory region. It could also have allocated two buffers for double-buffering.
The client then draws whatever it wants into the buffer (mapping the file into its memory and writing to it directly),
attaches the buffer to the window's surface, marks the whole area as &quot;damaged&quot; (in need of being redrawn) and calls <code>commit</code>,
telling the server the surface is ready for display:</p>
<pre><code>-&gt; wl_surface@7.attach buffer:10 x:0 y:0
-&gt; wl_surface@7.damage x:0 y:0 width:2147483647 height:2147483647
-&gt; wl_surface@7.commit 
</code></pre>
<p>At this point the window appears on the screen!
The server lets the client know it has finished with the buffer and the client destroys it:</p>
<pre><code>&lt;- wl_display@1.delete_id id:3
&lt;- wl_buffer@10.release 
-&gt; wl_buffer@10.destroy 
</code></pre>
<p>Although the window is visible, the content is the wrong size.
Sway now suddenly remembers that it's a tiling window manager.
It sends another <code>configure</code> event with the correct size, causing the client to allocate a fresh memory pool of the correct size,
allocate a fresh buffer from it, redraw everything at the new size, and tell the server to draw it.</p>
<pre><code>&lt;- xdg_toplevel@9.configure width:1534 height:1029 states:&quot;&quot;
...
</code></pre>
<p>This process of telling the client to pick a size and then overruling it explains why Firefox draws itself incorrectly at first and then flickers into position a moment later. It probably also explains why Vim tries to open a 0x0 window.</p>
<h3>Copying text</h3>
<p>A bit of searching revealed that the <code>^M</code> problem is a known <a href="https://github.com/swaywm/wlroots/issues/1839">Sway bug</a>.</p>
<p>However, the main reason copying text wasn't working turned out to be a limitation in the design of the core <code>wl_data_device_manager</code> protocol.
The normal way to copy text on X11 is to select the text you want to copy,
then click the middle mouse button where you want it (or press Shift-Insert).</p>
<p>X also supports a clipboard mechanism, where you select text, then press Ctrl-C, then click at the destination, then press Ctrl-V.
The original Wayland protocol only supports the clipboard system, not the selection, and so Wayland compositors have added selection support through extensions.
Sommelier didn't proxy these extensions, leading to failure when copying in or out of VMs.</p>
<p>I also found that the reason weston-terminal wouldn't start was because I didn't have anything in my clipboard,
and sommelier was trying to dereference a null pointer.</p>
<p>One problem with the Wayland protocol is that it's very hard to proxy.
Although the wire protocol gives the length in bytes of each message, it doesn't say how many file descriptors it has.
This means that you can't just pass through messages you don't understand, because you don't know which FDs go with which message.
Also, the wire protocol doesn't give types for FDs (nor does the schema),
which is a problem for anything that needs to proxy across a VM boundary or over a network.</p>
<p>This all meant that VMs could only use protocols explicitly supported by sommelier, and sommelier limited the version too.
Which means that supporting extra extensions or new versions means writing (and debugging) loads of C++ code.</p>
<p>I didn't have time to write and debug C++ code for every missing Wayland protocol, so I took a short-cut:
I wrote my own Wayland library, <a href="https://github.com/talex5/ocaml-wayland">ocaml-wayland</a>, and then used that to write my own version of sommelier.
With that, adding support for copying text was fairly easy.</p>
<p>For each Wayland interface we need to handle each incoming message from the client and forward it to the host,
and also forward each message from the host to the client.
Here's <a href="https://github.com/talex5/wayland-virtwl-proxy/blob/29333ac7e6071a1c08ece77b513f4b0ee3ee8f8e/relay.ml#L587">the code</a> to handle the &quot;selection&quot; event in OCaml,
which we receive from the host and send to the client (<code>c</code>):</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">method</span> <span class="n">on_selection</span> <span class="o">_</span> <span class="n">offer</span> <span class="o">=</span> <span class="nn">C</span><span class="p">.</span><span class="nn">Wl_data_device</span><span class="p">.</span><span class="n">selection</span> <span class="n">c</span> <span class="o">(</span><span class="nn">Option</span><span class="p">.</span><span class="n">map</span> <span class="n">to_client</span> <span class="n">offer</span><span class="o">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>The host passes us an &quot;offer&quot; argument, which is a previously-created host offer object.
We look up the corresponding client object with <code>to_client</code> and pass that as the argument
to the client.</p>
<p>For comparison, here's <a href="https://chromium.googlesource.com/chromiumos/platform2/+/7ea49bbabed436e608a0b8974ec90366a787d841/vm_tools/sommelier/sommelier-data-device-manager.cc#492">sommelier's equivalent</a> to this line of code, in C++:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
<span class="line-number">8</span>
<span class="line-number">9</span>
<span class="line-number">10</span>
</pre></td><td class="code"><pre><code class="c"><span class="line"><span class="k">static</span> <span class="kt">void</span> <span class="n">sl_data_device_selection</span><span class="p">(</span><span class="kt">void</span><span class="o">*</span> <span class="n">data</span><span class="p">,</span>
</span><span class="line">                                     <span class="k">struct</span> <span class="nc">wl_data_device</span><span class="o">*</span> <span class="n">data_device</span><span class="p">,</span>
</span><span class="line">                                     <span class="k">struct</span> <span class="nc">wl_data_offer</span><span class="o">*</span> <span class="n">data_offer</span><span class="p">)</span> <span class="p">{</span>
</span><span class="line">  <span class="k">struct</span> <span class="nc">sl_host_data_device</span><span class="o">*</span> <span class="n">host</span> <span class="o">=</span> <span class="n">static_cast</span><span class="o">&lt;</span><span class="n">sl_host_data_device</span><span class="o">*&gt;</span><span class="p">(</span>
</span><span class="line">      <span class="n">wl_data_device_get_user_data</span><span class="p">(</span><span class="n">data_device</span><span class="p">));</span>
</span><span class="line">  <span class="k">struct</span> <span class="nc">sl_host_data_offer</span><span class="o">*</span> <span class="n">host_data_offer</span> <span class="o">=</span>
</span><span class="line">      <span class="n">static_cast</span><span class="o">&lt;</span><span class="n">sl_host_data_offer</span><span class="o">*&gt;</span><span class="p">(</span><span class="n">wl_data_offer_get_user_data</span><span class="p">(</span><span class="n">data_offer</span><span class="p">));</span>
</span><span class="line">
</span><span class="line">  <span class="n">wl_data_device_send_selection</span><span class="p">(</span><span class="n">host</span><span class="o">-&gt;</span><span class="n">resource</span><span class="p">,</span> <span class="n">host_data_offer</span><span class="o">-&gt;</span><span class="n">resource</span><span class="p">);</span>
</span><span class="line"><span class="p">}</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>I think this is a great demonstration of the difference between &quot;type safety&quot; and &quot;type ceremony&quot;.
The C++ code is covered in types, making the code very hard to read, yet it crashes at runtime because it
fails to consider that <code>data_offer</code> can be <code>NULL</code>.</p>
<p>By contract, the OCaml version has no type annotations, but the compiler would reject if I forgot to handle this (with <code>Option.map</code>).</p>
<h3>Security</h3>
<p>According to <a href="https://wiki.gnome.org/Initiatives/Wayland/PrimarySelection">the GNOME wiki</a>, the original justification for not supporting selection copies was
&quot;security concerns with unexpected data stealing if the mere act of selecting a text fragment makes it available to all running applications&quot;.
The implication is that applications stealing data instead from the clipboard is OK,
and that you should therefore never put anything confidential on the clipboard.</p>
<p>This seemed a bit odd, so I read the <a href="https://wayland.freedesktop.org/docs/html/ch04.html#sect-Protocol-Security-and-Authentication">security section</a> of the Wayland specification to learn more about its security model.
That section of the specification is fairly short, so I'll reproduce it here in full:</p>
<blockquote>
<p><strong>Security and Authentication</strong></p>
<ul>
<li>mostly about access to underlying buffers, need new drm auth mechanism (the grant-to ioctl idea), need to check the cmd stream?
</li>
<li>getting the server socket depends on the compositor type, could be a system wide name, through fd passing on the session dbus. or the client is forked by the compositor and the fd is already opened.
</li>
</ul>
</blockquote>
<p>It looks like implementations have to figure things out for themselves.</p>
<p>The main advantage of Wayland over X11 here is that Wayland mostly isolates applications from each other.
In X11 applications collaborate together to manage a tree of windows, and any application can access any window.
In the Wayland protocol, each application's connection only includes that application's objects.
Applications only get events relevant to their own windows
(for example, you only get pointer motion events while the pointer is over your window).
Communication between applications (e.g. copy-and-paste or drag-and-drop) is all handled though the compositor.</p>
<p>Also, to request the contents of the clipboard you need to quote the serial number of the mouse click or key press that triggered it.
If it's too far in the past, the compositor can ignore the request.</p>
<p>I've also heard people say that security is the reason you can't take screenshots with Wayland.
However, Sway lets you take screenshots, and this worked even from inside a VM through virtwl.
I didn't add screenshot support to the proxy, because I don't want VMs to be able to take screenshots,
but the proxy isn't a security tool (it runs inside the VM, which isn't trusted).</p>
<p>Clearly, the way to fix this was with a new compositor.
One that would offer a different Wayland socket to each VM, tag the windows with the VM name, colour the frames,
confirm copies across VM boundaries, and work with Vim.
Luckily, I already had a handy pure-OCaml Wayland protocol library available.
Unluckily, at this point I ran out of holiday.</p>
<h2>Future work</h2>
<p>There are quite a few things left to do here:</p>
<ul>
<li>
<p>One problem with <code>virtwl</code> is that, while we can receive shared memory FDs <em>from</em> the host, we can't export guest memory <em>to</em> the host.
This is unfortunate, because in Wayland the shared memory for window contents is allocated by the application from guest memory,
and the proxy therefore has to copy each frame. If the host provided the memory to the guest, this wouldn't be needed.
There is a <code>wl_drm</code> protocol for allocating video memory, which might help here, but I don't know how that works and,
like many Wayland specifications, it seems to be in the process of being replaced by something else.
Also, if we're going to copy the memory, we should at least only copy the damaged region, not the whole thing.
I only got this code working just far enough to run the Wayland applications I use (mainly Firefox and Evince).</p>
</li>
<li>
<p>I'm still using ssh to proxy X11 connections (mainly for Vim and gitk).
I'd prefer to run Xwayland in the VM, but it seems you need to provide a bit of <a href="https://wayland.freedesktop.org/docs/html/ch05.html">extra support</a> for that,
which I haven't implemented yet.
Sommelier can do this, but then copying doesn't work.</p>
</li>
<li>
<p>The host Wayland compositor needs to be aware of VMs, so it can colour the titles appropriately and
limit access to privileged operations.</p>
</li>
<li>
<p>For the full Qubes experience, the network card should be handled by a VM, with another VM managing the firewall.
Perhaps the <a href="https://github.com/mirage/qubes-mirage-firewall/">Mirage unikernel firewall</a> could be made to work on KVM too.
I'm not sure how guest-to-guest communication works with KVM.</p>
</li>
</ul>
<p>However, because the host NixOS environment is a fully-working Linux system,
I can always trade off some security to get things working
(e.g. by doing video conferencing directly on the host).</p>
<p>I hope the SpectrumOS project will resume at some point,
or that Qubes will find a solution to its hardware compatibility and performance problems.</p>

