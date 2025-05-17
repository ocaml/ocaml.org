---
title: Dreaming of an ARM OCaml
description: Getting OCaml running on an ARM-based Dreamplug device with Debian and
  native code generation.
url: https://anil.recoil.org/notes/dreamplug-debian-and-ocaml
date: 2012-02-25T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p>I’ve been meaning to play with <a href="http://www.plugcomputer.org/">Plug
Computers</a> for some time now, as I need a
low-power embedded system around the house. I recently bought a <a href="http://soekris.com/products/net6501.html">Soekris
Net6501</a> (a pretty powerful
Intel CPU, that even has VT support), but had annoying
<a href="http://marc.info/?l=soekris-tech&amp;m=132915532912206&amp;w=2">issues</a> getting
it working reliably. I ordered an ARM-based
<a href="http://www.newit.co.uk/shop/products.php?cat=21">Dreamplug</a> as an
alternative (and as a bonus, the Dreamplug is 6x cheaper than the
Soekris!). Here are my notes on getting it to work.</p>
<p><a href="http://www.flickr.com/photos/tlamer/5693063642/" title="dreamplug by tlamer, on Flickr"><img src="http://farm6.staticflickr.com/5230/5693063642_47aa7c4c99.jpg" alt="dreamplug"></a></p>
<p>Requirements:</p>
<ul>
<li>Aside from the Dreamplug itself, make sure you order the optional
JTAG module. This provides a serial console that is essential to
getting any development done with it.</li>
<li>I also grabbed the extra 16GB Class 10 SLC SD Card, to act as my
home directory.</li>
<li>You will also need another functional system running Debian (or a VM
on your Mac; whatever is easiest). The JTAG drivers for the USB
serial are easiest to get running on Linux.</li>
</ul>
<p>The Dreamplug arrived with a working installation, but running the
absolutely ancient Debian Lenny. A dist-upgrade through to Wheezy led to
bricking it almost immediately, and so I did a fresh installation from
scratch.</p>
<p>For a fresh installation, place a USB stick of suitable size (greater
than 2GB is best) into your functional Debian installation. Then:</p>
<ul>
<li>
<p>The Marvell bootloader boots from a VFAT partition, so you will need
two partitions. The first should be a small <code>fat16</code> (I picked 150MB)
and the remainder an <code>ext3</code> partition for Linux itself. There are
good instructions available on the
<a href="https://trac.torproject.org/projects/tor/wiki/doc/DebianDreamPlug">Tor/Dreamplug</a>
wiki which show you how to do this.</p>
</li>
<li>
<p>I grabbed the latest kernel (at this time, 3.2.7) from
<a href="http://sheeva.with-linux.com/sheeva/3/3.2/3.2.7/">with-linux</a>, and
installed it with the following commands (assuming your USB stick is
<code>/dev/sdb</code>).</p>
<pre><code>$ sudo mount /dev/sdb1 /mnt
$ sudo cp uImage /mnt
$ sudo umount /mnt
</code></pre>
</li>
<li>
<p>You now need to use <code>debootstrap</code> to install a fresh root image.
Because it is ARM and your main PC is probably an x86, you will need
to setup the QEMU CPU emulator. An extremely cool feature of QEMU is
that it can do <a href="http://wiki.debian.org/QemuUserEmulation">transparent
emulation</a> of foreign
binaries, so you can chroot directly into the ARM filesystem and run
commands as if they were x86. The <code>qemu-deboostrap</code> command will
take care of this for you, if you perform the steps below (again,
assuming your USB stick is <code>/dev/sdb</code>).</p>
<pre><code>$ sudo apt-get install qemu-user-static debootstrap
$ sudo mount /dev/sdb2 /mnt
$ sudo mkdir -p /mnt/usr/bin
$ sudo cp /usr/bin/qemu-arm-static /mnt/usr/bin/
$ sudo qemu-debootstrap --arch=armel wheezy http://ftp.uk.debian.org/debian/
</code></pre>
</li>
<li>
<p>Now grab the kernel modules from the same place as your uImage (for
3.2.7, from
<a href="http://sheeva.with-linux.com/sheeva/3/3.2/3.2.7/sheeva-3.2.7-Modules.tar.gz">here</a>).
Then, chroot into your fresh installation and untar them.</p>
<pre><code>$ cd /mnt
$ sudo tar -zxvf ~/sheeva-3.2.7-Modules.tar.gz
$ sudo chroot /mnt
$ depmod -a
# edit /etc/network/interfaces
# edit /etc/resolv.conf
</code></pre>
</li>
<li>
<p>The wireless setup involves some extremely crap firmware which
relentlessly kernel panicked for me, so I just disabled it by adding
the following to <code>/etc/modprobe.d/dpwifiap.conf</code>, as I only want
wired access:</p>
<pre><code>blacklist libertas
blacklist libertas_sdio
</code></pre>
</li>
<li>
<p>From there on, put the USB stick into the Dreamplug, and follow the
rest of the boot instructions from the <a href="https://trac.torproject.org/projects/tor/wiki/doc/DebianDreamPlug">Tor
wiki</a>
to interact with the Marvell BIOS and boot from the USB stick. I
copied the contents of the USB stick onto the internal MicroSD, and
it all boots standalone now.</p>
</li>
</ul>
<h2>OCaml on ARM</h2>
<p>One of the reasons I wanted an ARM-based setup is to experiment with the
OCaml native code generation. <a href="http://www.home.unix-ag.org/bmeurer/index.html">Benedikt
Meurer</a> has been doing
some excellent work on <a href="http://old.nabble.com/New-ARM-backend-merged-into-trunk-td33262083.html">improving code
generation</a>
for embedded systems, including support for 16-bit Thumb code, exception
backtraces, and dynamic linking and profiling.</p>
<p>Once Linux was up and running, compiling up the latest ocaml-trunk was
straightforward.</p>
<pre><code>    $ sudo apt-get install build-essential git
    $ git clone http://github.com/OCamlPro/ocp-ocaml svn-trunk
    $ cd ocp-ocaml
    $ ./configure &amp;&amp; make world opt opt.opt install
</code></pre>
<p>This compiles the bytecode and native code compilers, and then compiles
them again using the native code generator. This takes a while to do on
the poor little ARM CPU. Once that finished, I compiled up a few simple
modules and they worked great! Since the trunk of OCaml is a development
branch, you may run into a few packaging issues (use the very latest
OASIS to regenerate any <code>setup.ml</code>, and you will need a small patch
until <a href="http://caml.inria.fr/mantis/view.php?id=5503">PR 5503</a> is
applied).</p>
<p>Incidentally, if anyone is interested in working on a
<a href="http://openmirage.org">Mirage</a> port to ARM as an internship in the
<a href="http://www.cl.cam.ac.uk/research/srg/netos/">Cambridge Computer Lab</a>,
do get in touch with me...</p>

