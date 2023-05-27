---
title: Local MirageOS development with Xen and Virtualbox
description:
url: http://www.skjegstad.com/blog/2015/01/19/mirageos-xen-virtualbox/
date: 2015-01-19T00:00:00-00:00
preview_image:
featured:
authors:
- Magnus Skjegstad
---

<p><a href="http://www.openmirage.org">MirageOS</a> is a library operating system. An application written for MirageOS is compiled to an operating system kernel that only contains the specific functionality required by the application - a <a href="http://queue.acm.org/detail.cfm?id=2566628">unikernel</a>. The MirageOS unikernels can be compiled for different targets, including standalone VMs that run under Xen. The Xen unikernels can be deployed directly to common cloud services such as <a href="http://openmirage.org/wiki/xen-boot">Amazon EC2</a> and <a href="http://christopherbothwell.com/ocaml/mirage/linode/2014/12/08/hello-linode.html">Linode</a>.</p>
<p>I have done a lot of MirageOS development for Xen lately and it can be inconvenient to have to rely on an external server or service to be able to run and debug the unikernel. As an alternative I have set up a VM in Virtualbox with a Xen server. The MirageOS unikernels then run as VMs in Xen, which itself runs in a VM in Virtualbox. With the &quot;Host-only networking&quot; feature in Virtualbox the unikernels are accessible from the host operating system, which can be very useful for testing client/server applications. A unikernel that hosts a web page can for example be tested in a web browser in the host OS. I am hoping that this setup may be useful to others so I am documenting it in this blog post.</p>


<p>My current VM is based on <a href="http://releases.ubuntu.com/14.04/">Ubuntu Server 14.04 LTS</a> with Xen hypervisor 4.4 installed. The steps described in this post should be transferrable to other distributions if they support newer versions of the Xen hypervisor (4.4+). I have also included a list of alternative development environments for Mirage <a href="http://www.skjegstad.com/feeds/ocaml.tag.atom.xml#alternatives">near the end</a>.</p>
<h3>Install the Ubuntu VM</h3>
<p>First, create a new Virtualbox VM with at least 1 GB RAM and 20 GB disk and start the Ubuntu Server installation. How to install Ubuntu in Virtualbox is covered in detail <a href="https://help.ubuntu.com/community/Ubuntu_as_Guest_OS">elsewhere</a>, so I will only briefly describe the most relevant steps. </p>
<p>To keep the VM lightweight, install as few features as possible. We will use SSH to login to the server so select &quot;OpenSSH Server&quot;. You may want to install a desktop environment later, but keep in mind that the graphics support will be limited under two layers of virtualization (Virtualbox + Xen). </p>
<p>Give the Linux VM a hostname that is unique on your network as we will use this to access it with SSH later. I use &quot;virtualxen&quot;. </p>
<p>Add a user you want to use for development, for example &quot;mirage&quot;. </p>
<p>You may also want to reserve some of the disk space for Mirage if you plan to run applications that use block storage. During guided partitioning in the Ubuntu installer, if you choose to use the entire disk, the next question will allow you to specify a percentage of the disk that you want to use. If you plan to use Xen VMs that need direct disk access you should leave some of it for this purpose, for example 50%.</p>
<p>After completing the installation, run apt-get update/upgrade and install the Virtualbox guest utilities, then reboot:</p>
<div class="highlight"><pre>sudo apt-get update
sudo apt-get upgrade
sudo apt-get install virtualbox-guest-utils 
sudo reboot
</pre></div>


<h3>Install the Xen Hypervisor</h3>
<p>After installing the Ubuntu Server VM, your configuration will be as in the following figure. Ubuntu runs in Virtualbox which runs under the main operating system (OS X in my case). </p>
<p><img src="http://www.skjegstad.com/images/blog/mirage_dev/ubuntu_in_vm_overview.jpg" class="center"/></p>
<p>We are now going to install the Xen hypervisor, which will become a thin layer between Virtualbox and the Ubuntu Server installation. The Xen hypervisor will be able to run VMs within the Virtualbox VM and we can use the Ubuntu installation to control Xen. This is the new configuration with Xen:</p>
<p><img src="http://www.skjegstad.com/images/blog/mirage_dev/xen_in_vm_overview.jpg" class="center"/></p>
<p><a href="http://wiki.xen.org/wiki/Dom0">Dom0</a> is the original Ubuntu Server installation and the <a href="http://wiki.xen.org/wiki/DomU">DomU</a>'s will be our future Mirage applications.</p>
<p>To install Xen, log in to Ubuntu and install the Xen hypervisor with the following command. We will also need bridge-utils (for configuring networking), build-essential (development tools) and git (version control):</p>
<div class="highlight"><pre><span class="c"># install hypervisor and other tools</span>
sudo apt-get install xen-hypervisor-4.4-amd64 bridge-utils build-essential git
</pre></div>


<p>After the installation is complete, reboot the Virtualbox VM to start into Xen and the Ubuntu Server installation (which now has become dom0). </p>
<p>Xen can be controlled from dom0 with the <code>xl</code> command. To verify that Ubuntu is running under Xen, log in and run <code>sudo xl list</code> to show a list of running domains. The output should look similar to this:</p>
<div class="highlight"><pre><span class="nv">$ </span>sudo xl list
Name                                        ID   Mem VCPUs       State      Time<span class="o">(</span>s<span class="o">)</span>
Domain-0                                     0  1896     1      r-----         31.7
</pre></div>


<p>The only Xen domain running at this point should be Dom0.</p>
<p>We are now ready to set up networking. </p>
<h3>Networking</h3>
<p>Internet access should work out of the box for dom0, but to enable network access from the domU's we have set up a bridge device that they can connect to. We will call this device br0. Since this is a development environment we also want the unikernels to be accessible from the host operating system (so we can test them), but not from the local network. Virtualbox has a feature that allows this called a host-only network. </p>
<p>To set up the host-only network in Virtualbox we have to shutdown the VM (<code>sudo shutdown -h now</code>). Then go to Preferences in Virtualbox and select the &quot;Network&quot; tab and &quot;Host-only Networks&quot;. Create a new network. Make sure that the built-in DHCP server is disabled - I have not managed to get the built-in DHCP server to work with Mirage, so we will install a DHCP server in dom0 instead. If you already have an existing host-only network and you disabled the DHCP server in this step, remember to restart Virtualbox to make sure that the DHCP server is not running. </p>
<p>After setting up the host-only network, exit preferences and open the settings for the VM. Under the &quot;Network&quot; tab, go to &quot;Adapter 2&quot;, enable it and choose to attach to &quot;Host-only Adapter&quot;. Select the name of the network that you just created in Preferences. Under advanced, select &quot;Allow All&quot; for &quot;Promiscuous mode&quot;. Exit and save.</p>
<p>You can now start the VM with the new network configuration. After booting, edit /etc/network/interfaces to setup up the host-only adapter (eth1) and add it to the bridge (br0). The configuration below is based on the default IP range (192.168.56.x) for host-only networking in Virtualbox - if you have made changes to the default network configuration you may have to update the configuration here as well. </p>
<div class="highlight"><pre><span class="c"># /etc/network/interfaces</span>
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet manual
    pre-up ifconfig <span class="nv">$IFACE</span> up
    post-down ifconfig <span class="nv">$IFACE</span> down

auto br0
iface br0 inet static
    bridge_ports eth1
    address 192.168.56.5
    broadcast 192.168.56.255
    netmask 255.255.255.0
    <span class="c"># disable ageing (turn bridge into switch)</span>
    up /sbin/brctl setageing br0 0
    <span class="c"># disable stp</span>
    up /sbin/brctl stp br0 off
</pre></div>


<p>Next, we install dnsmasq to setup a DHCP server in dom0. This DHCP server will be responsible for assigning IP addresses to the unikernels that attach to br0.</p>
<div class="highlight"><pre><span class="nv">$ </span>sudo apt-get install dnsmasq
</pre></div>


<p>To enable the DHCP server on br0, edit /etc/dnsmasq.conf and add the following lines:</p>
<div class="highlight"><pre><span class="n">interface</span><span class="o">=</span><span class="n">br0</span>
<span class="n">dhcp</span><span class="o">-</span><span class="n">range</span><span class="o">=</span><span class="mf">192.168.56.150</span><span class="p">,</span><span class="mf">192.168.56.200</span><span class="p">,</span><span class="mi">1</span><span class="n">h</span>
</pre></div>


<p>This configures the DHCP server to run on br0 and to dynamically assign IP addresses in the range 192.168.56.150 to 192.168.56.200 with a lease time of 1 hour. </p>
<p>To be able to access dom0 via SSH from the host operating system (outside Virtualbox) we install avahi-daemon. Avahi-daemon enables mDNS, which will allow you to connect to &quot;virtualxen.local&quot; from the host operating system:</p>
<div class="highlight"><pre><span class="nv">$ </span>sudo apt-get install avahi-daemon
</pre></div>


<p>Reboot dom0 to activate the changes (<code>sudo reboot</code>).</p>
<p>You should now be able to connect to dom0 with SSH from the host OS:</p>
<div class="highlight"><pre><span class="nv">$ </span>ssh mirage@virtualxen.local
</pre></div>


<p>Dom0 can also be accessed from the host by using the IP address for br0 that we set above: 192.168.56.5.</p>
<h3>Installing MirageOS in dom0</h3>
<p>Before we can compile MirageOS unikernels we have to install OCaml.</p>
<div class="highlight"><pre><span class="c"># install ocaml and friends</span>
sudo apt-get install ocaml-compiler-libs ocaml-interp ocaml-base-nox ocaml-base ocaml ocaml-nox ocaml-native-compilers camlp4 camlp4-extra m4
</pre></div>


<p>We also need the OCaml package manager, <a href="https://opam.ocaml.org">opam</a>. A new version of opam was recently release and the version that comes with many Linux distros is outdated. To get the latest version (currently 1.2.x) I use <a href="http://0install.net">0install</a> to install opam directly from the installation script provided on the ocaml.org web page. If you don't want to use 0install, a list of other options is available <a href="http://opam.ocaml.org/doc/Install.html">here</a> (including PPA's). </p>
<div class="highlight"><pre><span class="c"># install 0install</span>
sudo apt-get install zeroinstall-injector
<span class="c"># install opam</span>
0install add opam http://tools.ocaml.org/opam.xml
</pre></div>


<p>0install installs applications in ~/bin. To add this directory to your path logout and back in. </p>
<p>After installing opam, run <code>opam init</code> and follow the instructions to complete the installation. Note that the opam commands should not be run with sudo, as it installs everything in ~/.opam in your home directory.</p>
<p>If you want to run the development version of Mirage, you can add mirage-dev as an opam repository. Keep in mind that this repository contains the latest changes to Mirage, which may not always work. <em>The safest option is to skip this step</em>.</p>
<div class="highlight"><pre><span class="c"># optional - add mirage-dev to opam </span>
opam remote add mirage-dev git://github.com/mirage/mirage-dev
</pre></div>


<p>We can now install Mirage:</p>
<div class="highlight"><pre><span class="c"># install libs required to build many mirage apps</span>
sudo apt-get install libssl-dev pkg-config
<span class="c"># install mirage</span>
opam install mirage -v
</pre></div>


<p>After Mirage has been installed you should be able to run the Mirage configuration tool <code>mirage</code>.</p>
<div class="highlight"><pre><span class="nv">$ </span>mirage --version
2.0.0
</pre></div>


<p>If you use emacs or vim I also recommend installing <a href="https://github.com/the-lambda-church/merlin/wiki">Merlin</a>, which provides tab completion, type lookup and many other useful IDE features for OCaml. </p>
<h3>Creating a Mirage VM</h3>
<p>To verify that everything works, we will now download the <a href="https://github.com/mirage/mirage-skeleton">Mirage examples</a> and compile the static website example. This example will start a web server hosting a &quot;Hello world&quot; page that we should be able to access from the host OS. The IP-address will be assigned with DHCP. </p>
<p>First, clone the Mirage examples:</p>
<div class="highlight"><pre><span class="c"># clone mirage-skeleton</span>
git clone http://github.com/mirage/mirage-skeleton.git
</pre></div>


<p>Then go to the <code>mirage-skeleton/static-webpage</code> folder and run <code>env DHCP=true mirage configure --xen</code>. This command will download and install all the required dependencies and then create a Makefile. When the command completes, run <code>make</code> to compile.</p>
<p>If make completes successfully, there will be a file called <code>www.xl</code> that contains the Xen DomU configuration file for the unikernel. By default the line that contains the network interface configuration is commented out. Remove the # in front of the line that begins with 'vif = ...' to enable network support. The <code>www.xl</code> file should look similar to this:</p>
<div class="highlight"><pre><span class="n">name</span> <span class="o">=</span> <span class="err">'</span><span class="n">www</span><span class="err">'</span>
<span class="n">kernel</span> <span class="o">=</span> <span class="err">'</span><span class="o">/</span><span class="n">home</span><span class="o">/</span><span class="n">mirage</span><span class="o">/</span><span class="n">mirage</span><span class="o">-</span><span class="n">skeleton</span><span class="o">/</span><span class="n">static_website</span><span class="o">/</span><span class="n">mir</span><span class="o">-</span><span class="n">www</span><span class="p">.</span><span class="n">xen</span><span class="err">'</span>
<span class="n">builder</span> <span class="o">=</span> <span class="err">'</span><span class="n">linux</span><span class="err">'</span>
<span class="n">memory</span> <span class="o">=</span> <span class="mi">256</span>
<span class="n">on_crash</span> <span class="o">=</span> <span class="err">'</span><span class="n">preserve</span><span class="err">'</span>

<span class="cp"># You must define the network and block interfaces manually.</span>

<span class="cp"># The disk configuration is defined here:</span>
<span class="cp"># http:</span><span class="c1">//xenbits.xen.org/docs/4.3-testing/misc/xl-disk-configuration.txt</span>
<span class="cp"># An example would look like:</span>
<span class="cp"># disk = [ '/dev/loop0,,xvda' ]</span>

<span class="cp"># The network configuration is defined here:</span>
<span class="cp"># http:</span><span class="c1">//xenbits.xen.org/docs/4.3-testing/misc/xl-network-configuration.html</span>
<span class="cp"># An example would look like:</span>
<span class="n">vif</span> <span class="o">=</span> <span class="p">[</span> <span class="err">'</span><span class="n">mac</span><span class="o">=</span><span class="n">c0</span><span class="o">:</span><span class="n">ff</span><span class="o">:</span><span class="n">ee</span><span class="o">:</span><span class="n">c0</span><span class="o">:</span><span class="n">ff</span><span class="o">:</span><span class="n">ee</span><span class="p">,</span><span class="n">bridge</span><span class="o">=</span><span class="n">br0</span><span class="err">'</span> <span class="p">]</span>
</pre></div>


<p>The memory is set to 256 MB by default, but most of the example unikernels require much less than this. The static webserver example runs fine with 16 MB.</p>
<p>You should now be able to start the unikernel using the command <code>sudo xl create www.xl -c</code>: </p>
<div class="highlight"><pre><span class="nx">$</span> <span class="nx">sudo</span> <span class="nx">xl</span> <span class="nx">create</span> <span class="nx">www</span><span class="p">.</span><span class="nx">xl</span> <span class="o">-</span><span class="nx">c</span>
<span class="nx">Parsing</span> <span class="nx">config</span> <span class="nx">from</span> <span class="nx">www</span><span class="p">.</span><span class="nx">xl</span>
<span class="nx">Xen</span> <span class="nx">Minimal</span> <span class="nx">OS</span><span class="o">!</span>
  <span class="nx">start_info</span><span class="o">:</span> <span class="mi">0000000000332000</span><span class="p">(</span><span class="nx">VA</span><span class="p">)</span>
    <span class="nx">nr_pages</span><span class="o">:</span> <span class="mh">0x10000</span>
  <span class="nx">shared_inf</span><span class="o">:</span> <span class="mh">0x5457d000</span><span class="p">(</span><span class="nx">MA</span><span class="p">)</span>
     <span class="nx">pt_base</span><span class="o">:</span> <span class="mi">0000000000335000</span><span class="p">(</span><span class="nx">VA</span><span class="p">)</span>
<span class="nx">nr_pt_frames</span><span class="o">:</span> <span class="mh">0x5</span>
    <span class="nx">mfn_list</span><span class="o">:</span> <span class="mi">00000000002</span><span class="nx">b2000</span><span class="p">(</span><span class="nx">VA</span><span class="p">)</span>
   <span class="nx">mod_start</span><span class="o">:</span> <span class="mh">0x0</span><span class="p">(</span><span class="nx">VA</span><span class="p">)</span>
     <span class="nx">mod_len</span><span class="o">:</span> <span class="mi">0</span>
       <span class="nx">flags</span><span class="o">:</span> <span class="mh">0x0</span>
    <span class="nx">cmd_line</span><span class="o">:</span>
       <span class="nx">stack</span><span class="o">:</span> <span class="mi">0000000000291</span><span class="nx">b40</span><span class="o">-</span><span class="mi">00000000002</span><span class="nx">b1b40</span>
<span class="nx">Mirage</span><span class="o">:</span> <span class="nx">start_kernel</span>
<span class="nx">MM</span><span class="o">:</span> <span class="nx">Init</span>
      <span class="nx">_text</span><span class="o">:</span> <span class="mi">0000000000000000</span><span class="p">(</span><span class="nx">VA</span><span class="p">)</span>
     <span class="nx">_etext</span><span class="o">:</span> <span class="mi">000000000015</span><span class="nx">cc0f</span><span class="p">(</span><span class="nx">VA</span><span class="p">)</span>
   <span class="nx">_erodata</span><span class="o">:</span> <span class="mi">0000000000197000</span><span class="p">(</span><span class="nx">VA</span><span class="p">)</span>
     <span class="nx">_edata</span><span class="o">:</span> <span class="mi">0000000000258220</span><span class="p">(</span><span class="nx">VA</span><span class="p">)</span>
<span class="nx">stack</span> <span class="nx">start</span><span class="o">:</span> <span class="mi">0000000000291</span><span class="nx">b40</span><span class="p">(</span><span class="nx">VA</span><span class="p">)</span>
       <span class="nx">_end</span><span class="o">:</span> <span class="mi">00000000002</span><span class="nx">b1b40</span><span class="p">(</span><span class="nx">VA</span><span class="p">)</span>
  <span class="nx">start_pfn</span><span class="o">:</span> <span class="mi">33</span><span class="nx">d</span>
    <span class="nx">max_pfn</span><span class="o">:</span> <span class="mi">10000</span>
<span class="nx">Mapping</span> <span class="nx">memory</span> <span class="nx">range</span> <span class="mh">0x400000</span> <span class="o">-</span> <span class="mh">0x10000000</span>
<span class="nx">setting</span> <span class="mi">0000000000000000</span><span class="o">-</span><span class="mi">0000000000197000</span> <span class="nx">readonly</span>
<span class="nx">skipped</span> <span class="mi">1000</span>
<span class="nx">MM</span><span class="o">:</span> <span class="nx">Initialise</span> <span class="nx">page</span> <span class="nx">allocator</span> <span class="k">for</span> <span class="mi">3</span><span class="nx">bb000</span><span class="p">(</span><span class="mi">3</span><span class="nx">bb000</span><span class="p">)</span><span class="o">-</span><span class="mi">10000000</span><span class="p">(</span><span class="mi">10000000</span><span class="p">)</span>
<span class="nx">MM</span><span class="o">:</span> <span class="nx">done</span>
<span class="nx">Demand</span> <span class="nx">map</span> <span class="nx">pfns</span> <span class="nx">at</span> <span class="mi">10001000</span><span class="o">-</span><span class="mi">0000002010001000</span><span class="p">.</span>
<span class="nx">Initialising</span> <span class="nx">timer</span> <span class="kr">interface</span>
<span class="nx">Initialising</span> <span class="nx">console</span> <span class="p">...</span> <span class="nx">done</span><span class="p">.</span>
<span class="nx">gnttab_table</span> <span class="nx">mapped</span> <span class="nx">at</span> <span class="mi">0000000010001000</span><span class="p">.</span>
<span class="nx">xencaml</span><span class="o">:</span> <span class="nx">app_main_thread</span>
<span class="nx">getenv</span><span class="p">(</span><span class="nx">OCAMLRUNPARAM</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="kc">null</span>
<span class="nx">getenv</span><span class="p">(</span><span class="nx">CAMLRUNPARAM</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="kc">null</span>
<span class="nx">Unsupported</span> <span class="kd">function</span> <span class="nx">lseek</span> <span class="nx">called</span> <span class="k">in</span> <span class="nx">Mini</span><span class="o">-</span><span class="nx">OS</span> <span class="nx">kernel</span>
<span class="nx">Unsupported</span> <span class="kd">function</span> <span class="nx">lseek</span> <span class="nx">called</span> <span class="k">in</span> <span class="nx">Mini</span><span class="o">-</span><span class="nx">OS</span> <span class="nx">kernel</span>
<span class="nx">Unsupported</span> <span class="kd">function</span> <span class="nx">lseek</span> <span class="nx">called</span> <span class="k">in</span> <span class="nx">Mini</span><span class="o">-</span><span class="nx">OS</span> <span class="nx">kernel</span>
<span class="nx">getenv</span><span class="p">(</span><span class="nx">OCAMLRUNPARAM</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="kc">null</span>
<span class="nx">getenv</span><span class="p">(</span><span class="nx">CAMLRUNPARAM</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="kc">null</span>
<span class="nx">getenv</span><span class="p">(</span><span class="nx">TMPDIR</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="kc">null</span>
<span class="nx">getenv</span><span class="p">(</span><span class="nx">TEMP</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="kc">null</span>
<span class="nx">Netif</span><span class="o">:</span> <span class="nx">add</span> <span class="nx">resume</span> <span class="nx">hook</span>
<span class="nx">Netif</span><span class="p">.</span><span class="nx">connect</span> <span class="mi">0</span>
<span class="nx">Netfront</span><span class="p">.</span><span class="nx">create</span><span class="o">:</span> <span class="nx">id</span><span class="o">=</span><span class="mi">0</span> <span class="nx">domid</span><span class="o">=</span><span class="mi">0</span>
<span class="nx">MAC</span><span class="o">:</span> <span class="nx">c0</span><span class="o">:</span><span class="nx">ff</span><span class="o">:</span><span class="nx">ee</span><span class="o">:</span><span class="nx">c0</span><span class="o">:</span><span class="nx">ff</span><span class="o">:</span><span class="nx">ee</span>
<span class="nx">Manager</span><span class="o">:</span> <span class="nx">connect</span>
<span class="nx">Attempt</span> <span class="nx">to</span> <span class="nx">open</span><span class="p">(</span><span class="err">/dev/urandom)!</span>
<span class="nx">Manager</span><span class="o">:</span> <span class="nx">configuring</span>
<span class="nx">DHCP</span><span class="o">:</span> <span class="nx">start</span> <span class="nx">discovery</span>

<span class="nx">Sending</span> <span class="nx">DHCP</span> <span class="nx">broadcast</span> <span class="p">(</span><span class="nx">length</span> <span class="mi">552</span><span class="p">)</span>
<span class="nx">DHCP</span> <span class="nx">response</span><span class="o">:</span>
<span class="nx">input</span> <span class="nx">ciaddr</span> <span class="mf">0.0</span><span class="p">.</span><span class="mf">0.0</span> <span class="nx">yiaddr</span> <span class="mf">192.168</span><span class="p">.</span><span class="mf">56.178</span>
<span class="nx">siaddr</span> <span class="mf">192.168</span><span class="p">.</span><span class="mf">56.5</span> <span class="nx">giaddr</span> <span class="mf">0.0</span><span class="p">.</span><span class="mf">0.0</span>
<span class="nx">chaddr</span> <span class="nx">c0ffeec0ffee00000000000000000000</span> <span class="nx">sname</span>  <span class="nx">file</span>
<span class="nx">DHCP</span><span class="o">:</span> <span class="nx">offer</span> <span class="nx">received</span><span class="o">:</span> <span class="mf">192.168</span><span class="p">.</span><span class="mf">56.178</span>
<span class="nx">DHCP</span> <span class="nx">options</span><span class="o">:</span> <span class="nx">Offer</span> <span class="o">:</span> <span class="nx">DNS</span> <span class="nx">servers</span><span class="p">(</span><span class="mf">192.168</span><span class="p">.</span><span class="mf">56.5</span><span class="p">),</span> <span class="nx">Routers</span><span class="p">(</span><span class="mf">192.168</span><span class="p">.</span><span class="mf">56.5</span><span class="p">),</span> <span class="nx">Broadcast</span><span class="p">(</span><span class="mf">192.168</span><span class="p">.</span><span class="mf">56.255</span><span class="p">),</span> <span class="nx">Subnet</span> <span class="nx">mask</span><span class="p">(</span><span class="mf">255.255</span><span class="p">.</span><span class="mf">255.0</span><span class="p">),</span> <span class="nx">Unknown</span><span class="p">(</span><span class="mi">59</span><span class="cp">[</span><span class="mi">4</span><span class="cp">]</span><span class="p">),</span> <span class="nx">Unknown</span><span class="p">(</span><span class="mi">58</span><span class="cp">[</span><span class="mi">4</span><span class="cp">]</span><span class="p">),</span> <span class="nx">Lease</span> <span class="nx">time</span><span class="p">(</span><span class="mi">43200</span><span class="p">),</span> <span class="nx">Server</span> <span class="nx">identifer</span><span class="p">(</span><span class="mf">192.168</span><span class="p">.</span><span class="mf">56.5</span><span class="p">)</span>
<span class="nx">Sending</span> <span class="nx">DHCP</span> <span class="nx">broadcast</span> <span class="p">(</span><span class="nx">length</span> <span class="mi">552</span><span class="p">)</span>
<span class="nx">DHCP</span> <span class="nx">response</span><span class="o">:</span>
<span class="nx">input</span> <span class="nx">ciaddr</span> <span class="mf">0.0</span><span class="p">.</span><span class="mf">0.0</span> <span class="nx">yiaddr</span> <span class="mf">192.168</span><span class="p">.</span><span class="mf">56.178</span>
<span class="nx">siaddr</span> <span class="mf">192.168</span><span class="p">.</span><span class="mf">56.5</span> <span class="nx">giaddr</span> <span class="mf">0.0</span><span class="p">.</span><span class="mf">0.0</span>
<span class="nx">chaddr</span> <span class="nx">c0ffeec0ffee00000000000000000000</span> <span class="nx">sname</span>  <span class="nx">file</span>
<span class="nx">DHCP</span><span class="o">:</span> <span class="nx">offer</span> <span class="nx">received</span>
                    <span class="nx">IPv4</span><span class="o">:</span> <span class="mf">192.168</span><span class="p">.</span><span class="mf">56.178</span>
                                        <span class="nx">Netmask</span><span class="o">:</span> <span class="mf">255.255</span><span class="p">.</span><span class="mf">255.0</span>
                                                              <span class="nx">Gateways</span><span class="o">:</span> <span class="cp">[</span><span class="mf">192.168.56.5</span><span class="cp">]</span>
 <span class="nx">sg</span><span class="o">:</span><span class="kc">true</span> <span class="nx">gso_tcpv4</span><span class="o">:</span><span class="kc">true</span> <span class="nx">rx_copy</span><span class="o">:</span><span class="kc">true</span> <span class="nx">rx_flip</span><span class="o">:</span><span class="kc">false</span> <span class="nx">smart_poll</span><span class="o">:</span><span class="kc">false</span>
<span class="nx">ARP</span><span class="o">:</span> <span class="nx">sending</span> <span class="nx">gratuitous</span> <span class="nx">from</span> <span class="mf">192.168</span><span class="p">.</span><span class="mf">56.178</span>
<span class="nx">DHCP</span> <span class="nx">offer</span> <span class="nx">received</span> <span class="nx">and</span> <span class="nx">bound</span> <span class="nx">to</span> <span class="mf">192.168</span><span class="p">.</span><span class="mf">56.178</span> <span class="nx">nm</span> <span class="mf">255.255</span><span class="p">.</span><span class="mf">255.0</span> <span class="nx">gw</span> <span class="cp">[</span><span class="mf">192.168.56.5</span><span class="cp">]</span>
<span class="nx">Manager</span><span class="o">:</span> <span class="nx">configuration</span> <span class="nx">done</span>
</pre></div>


<p>The console output shows the IP address that was assigned to the unikernel (&quot;DHCP offer received and bound...&quot;). In the example above the IP is 192.168.56.178. From the host operating system you should now be able to open this IP in a web browser to see the &quot;Hello Mirage World!&quot; message.</p>
<p>If you login to dom0 in a new terminal <code>xl list</code> will show the running domains, which now includes &quot;www&quot;:</p>
<div class="highlight"><pre><span class="err">$</span> <span class="n">sudo</span> <span class="n">xl</span> <span class="n">list</span>
<span class="n">Name</span>                                        <span class="n">ID</span>   <span class="n">Mem</span> <span class="n">VCPUsStateTime</span><span class="p">(</span><span class="n">s</span><span class="p">)</span>
<span class="n">Domain</span><span class="o">-</span><span class="mi">0</span>                                     <span class="mi">0</span>  <span class="mi">1355</span>     <span class="mi">1</span>     <span class="n">r</span><span class="o">-----</span>    <span class="mf">6691.4</span>
<span class="n">www</span>                                         <span class="mi">33</span>   <span class="mi">256</span>     <span class="mi">1</span>     <span class="o">-</span><span class="n">b</span><span class="o">----</span>       <span class="mf">0.2</span>
</pre></div>


<p>To stop the unikernel, run <code>sudo xl destroy www</code>.</p>
<h3><a name="alternatives">Some alternatives</a></h3>
<p>The environment described in this post is my current development environment and is based on a Xen server running in a Virtualbox VM with the latest versions of opam and Mirage. I use a host-only second network adapter to allow access to the Mirage applications from the host running Virtualbox. </p>
<p>Mirage applications can also be compiled in <a href="http://openmirage.org/wiki/hello-world">Unix mode</a>, which produces an executable that can be executed directly in a Unix-like operating system. Currently OS X seems to be particularly well supported. This mode may often be the easiest way to debug and develop a Mirage application, but not all of Mirage's features are available in this mode and some applications may require low level access to the system - for example to block storage or network interfaces - which may not be available in this mode. </p>
<p>Another approach is to use a <a href="http://cubieboard.org">Cubieboard2</a> with a prebuilt <a href="http://github.com/mirage/xen-arm-builder">Mirage/Xen image</a> to set up a low cost, portable Xen server for development. If you want to have long running Mirage services in your local network or host your own web page this may be a good alternative. Note that compilation times can be slow on this platform compared to an x86 based VM.</p>
<p>An automated VM setup is being developed based on Debian, Vagrant and Packer <a href="http://github.com/mirage/mirage-vagrant-vms">here</a>. This can be useful if you don't want to manually perform the setup steps outlined in this post. Currently this setup uses an older version of Debian which comes with Xen 4.1, but it should be possible to upgrade to Debian Jessie or later.</p>
