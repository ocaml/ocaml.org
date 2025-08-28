---
title: Containerd on Windows
description: "Everything was going fine until I ran out of disk space. My NVMe, C:
  drive, is only 256GB, but I have a large, 1.7TB SSD available as D:. How trivial,
  change a few paths and carry on, but it wasn\u2019t that simple, or was it?"
url: https://www.tunbury.org/2025/06/27/windows-containerd-3/
date: 2025-06-27T12:00:00-00:00
preview_image: https://www.tunbury.org/images/containerd.png
authors:
- Mark Elvers
source:
ignore:
---

<p>Everything was going fine until I ran out of disk space. My NVMe, <code class="language-plaintext highlighter-rouge">C:</code> drive, is only 256GB, but I have a large, 1.7TB SSD available as <code class="language-plaintext highlighter-rouge">D:</code>. How trivial, change a few paths and carry on, but it wasn’t that simple, or was it?</p>

<p>Distilling the problem down to the minimum and excluding all code written by me, the following command fails, but changing <code class="language-plaintext highlighter-rouge">src=d:\cache\opam</code> to <code class="language-plaintext highlighter-rouge">src=c:\cache\opam</code> works. It’s not the content, as it’s just an empty folder.</p>

<pre><code class="language-cmd">ctr run --rm --cni -user ContainerAdministrator -mount type=bind,src=d:\cache\opam,dst=c:\Users\ContainerAdministrator\AppData\Local\opam mcr.microsoft.com/windows/servercore:ltsc2022 my-container  cmd /c "curl.exe -L -o c:\Windows\opam.exe https://github.com/ocaml/opam/releases/download/2.3.0/opam-2.3.0-x86_64-windows.exe &amp;&amp; opam.exe init --debug-level=3 -y"
</code></pre>

<p>The failure point is the ability to create the lock file <code class="language-plaintext highlighter-rouge">config.lock</code>. Checking the code, the log entry is written before the lock is acquired. If <code class="language-plaintext highlighter-rouge">c:\Users\ContainerAdministrator\AppData\Local\opam</code> is not a bind mount, or the bind mount is on <code class="language-plaintext highlighter-rouge">C:</code>, then it works.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>01:26.722  CLIENT                          updating repository state
01:26.722  GSTATE                          LOAD-GLOBAL-STATE @ C:\Users\ContainerAdministrator\AppData\Local\opam
01:26.723  SYSTEM                          LOCK C:\Users\ContainerAdministrator\AppData\Local\opam\lock (none =&gt; read)
01:26.723  SYSTEM                          LOCK C:\Users\ContainerAdministrator\AppData\Local\opam\config.lock (none =&gt; write)
</code></pre></div></div>

<p>Suffice it to say, I spent a long time trying to resolve this. I’ll mention a couple of interesting points that appeared along the way. Firstly, files created on <code class="language-plaintext highlighter-rouge">D:</code> effectively appear as hard links, and the Update Sequence Number, USN, is 0.</p>

<div class="language-powershell highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">C:\</span><span class="err">&gt;</span><span class="w"> </span><span class="nx">fsutil</span><span class="w"> </span><span class="nx">file</span><span class="w"> </span><span class="nx">layout</span><span class="w"> </span><span class="nx">d:\cache\opam\lock</span><span class="w">

</span><span class="o">*********</span><span class="w"> </span><span class="n">File</span><span class="w"> </span><span class="nx">0x000400000001d251</span><span class="w"> </span><span class="o">*********</span><span class="w">
</span><span class="n">File</span><span class="w"> </span><span class="nx">reference</span><span class="w"> </span><span class="nx">number</span><span class="w">   </span><span class="p">:</span><span class="w"> </span><span class="nx">0x000400000001d251</span><span class="w">
</span><span class="n">File</span><span class="w"> </span><span class="nx">attributes</span><span class="w">         </span><span class="p">:</span><span class="w"> </span><span class="nx">0x00000020:</span><span class="w"> </span><span class="nx">Archive</span><span class="w">
</span><span class="n">File</span><span class="w"> </span><span class="nx">entry</span><span class="w"> </span><span class="nx">flags</span><span class="w">        </span><span class="p">:</span><span class="w"> </span><span class="nx">0x00000000</span><span class="w">
</span><span class="n">Link</span><span class="w"> </span><span class="p">(</span><span class="n">ParentID:</span><span class="w"> </span><span class="nx">Name</span><span class="p">)</span><span class="w">   </span><span class="p">:</span><span class="w"> </span><span class="mi">0</span><span class="n">x000c00000000002d:</span><span class="w"> </span><span class="nx">HLINK</span><span class="w"> </span><span class="nx">Name</span><span class="w">   </span><span class="p">:</span><span class="w"> </span><span class="nx">\cache\opam\lock</span><span class="w">
</span><span class="o">...</span><span class="w">
</span><span class="n">LastUsn</span><span class="w">                 </span><span class="p">:</span><span class="w"> </span><span class="nx">0</span><span class="w">
</span><span class="o">...</span><span class="w">
</span></code></pre></div></div>

<p>The reason behind this is down to Windows defaults:</p>

<ol>
  <li>Windows still likes to create the legacy 8.3 MS-DOS file names on the system volume, <code class="language-plaintext highlighter-rouge">C:</code>, which explains the difference between <code class="language-plaintext highlighter-rouge">HLINK</code> and <code class="language-plaintext highlighter-rouge">NTFS+DOS</code>. Running <code class="language-plaintext highlighter-rouge">fsutil 8dot3name set d: 0</code> will enable the creation of the old-style file names.</li>
  <li>Drive <code class="language-plaintext highlighter-rouge">C:</code> has a USN journal created automatically, as it’s required for Windows to operate, but it isn’t created by default on other drives. Running <code class="language-plaintext highlighter-rouge">fsutil usn createjournal d: m=32000000 a=8000000</code> will create the journal.</li>
</ol>

<div class="language-powershell highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">C:\</span><span class="err">&gt;</span><span class="w"> </span><span class="nx">fsutil</span><span class="w"> </span><span class="nx">file</span><span class="w"> </span><span class="nx">layout</span><span class="w"> </span><span class="nx">c:\cache\opam\lock</span><span class="w">

</span><span class="o">*********</span><span class="w"> </span><span class="n">File</span><span class="w"> </span><span class="nx">0x000300000002f382</span><span class="w"> </span><span class="o">*********</span><span class="w">
</span><span class="n">File</span><span class="w"> </span><span class="nx">reference</span><span class="w"> </span><span class="nx">number</span><span class="w">   </span><span class="p">:</span><span class="w"> </span><span class="nx">0x000300000002f382</span><span class="w">
</span><span class="n">File</span><span class="w"> </span><span class="nx">attributes</span><span class="w">         </span><span class="p">:</span><span class="w"> </span><span class="nx">0x00000020:</span><span class="w"> </span><span class="nx">Archive</span><span class="w">
</span><span class="n">File</span><span class="w"> </span><span class="nx">entry</span><span class="w"> </span><span class="nx">flags</span><span class="w">        </span><span class="p">:</span><span class="w"> </span><span class="nx">0x00000000</span><span class="w">
</span><span class="n">Link</span><span class="w"> </span><span class="p">(</span><span class="n">ParentID:</span><span class="w"> </span><span class="nx">Name</span><span class="p">)</span><span class="w">   </span><span class="p">:</span><span class="w"> </span><span class="mi">0</span><span class="n">x000b0000000271d1:</span><span class="w"> </span><span class="nx">NTFS</span><span class="o">+</span><span class="nx">DOS</span><span class="w"> </span><span class="nx">Name:</span><span class="w"> </span><span class="nx">\cache\opam\lock</span><span class="w">
</span><span class="o">...</span><span class="w">
</span><span class="n">LastUsn</span><span class="w">                 </span><span class="p">:</span><span class="w"> </span><span class="nx">16</span><span class="p">,</span><span class="nx">897</span><span class="p">,</span><span class="nx">595</span><span class="p">,</span><span class="nx">224</span><span class="w">
</span><span class="o">...</span><span class="w">
</span></code></pre></div></div>

<p>Sadly, neither of these insights makes any difference to my problem. I did notice that <code class="language-plaintext highlighter-rouge">containerd</code> 2.1.3 had been released, where I had been using 2.1.1. Upgrading didn’t fix the issue, but it did affect how the network namespaces were created. More later.</p>

<p>I decided to both ignore the problem and try it on another machine. After all, this problem was only a problem because <em>my</em> <code class="language-plaintext highlighter-rouge">C:</code> was too small. I created a QEMU VM with a 40GB <code class="language-plaintext highlighter-rouge">C:</code> and a 1TB <code class="language-plaintext highlighter-rouge">D:</code> and installed everything, and it worked fine with the bind mount on <code class="language-plaintext highlighter-rouge">D:</code> even <em>without</em> any of the above tuning and even with <code class="language-plaintext highlighter-rouge">D:</code> formatted using ReFS, rather than NTFS.</p>

<p>Trying on another physical machine with a single large spinning disk as <code class="language-plaintext highlighter-rouge">C:</code> also worked as anticipated.</p>

<p>In both of these new installations, I used <code class="language-plaintext highlighter-rouge">containerd</code> 2.1.3 and noticed that the behaviour I had come to rely upon seemed to have changed. If you recall, in this <a href="https://www.tunbury.org/2025/06/14/windows-containerd-2/">post</a>, I <em>found</em> the network namespace GUID by running <code class="language-plaintext highlighter-rouge">ctr run</code> on a standard Windows container and then <code class="language-plaintext highlighter-rouge">ctr container info</code> in another window. This no longer worked reliably, as the namespace was removed when the container exited. Perhaps it always should have been?</p>

<p>I need to find out how to create these namespaces. PowerShell has a cmdlet <code class="language-plaintext highlighter-rouge">Get-HnsNetwork</code>, but none of the GUID values there match the currently running namespaces I observe from <code class="language-plaintext highlighter-rouge">ctr container info</code>. The source code of <a href="https://github.com/containerd/containerd">containerd</a> is on GitHub..</p>

<p>When you pass <code class="language-plaintext highlighter-rouge">--cni</code> to the <code class="language-plaintext highlighter-rouge">ctr</code> command, it populates the network namespace from <code class="language-plaintext highlighter-rouge">NetNewNS</code>.  Snippet from <code class="language-plaintext highlighter-rouge">cmd/ctr/commands/run/run_windows.go</code></p>

<div class="language-go highlighter-rouge"><div class="highlight"><pre class="highlight"><code>                <span class="k">if</span> <span class="n">cliContext</span><span class="o">.</span><span class="n">Bool</span><span class="p">(</span><span class="s">"cni"</span><span class="p">)</span> <span class="p">{</span>
                        <span class="n">ns</span><span class="p">,</span> <span class="n">err</span> <span class="o">:=</span> <span class="n">netns</span><span class="o">.</span><span class="n">NewNetNS</span><span class="p">(</span><span class="s">""</span><span class="p">)</span>
                        <span class="k">if</span> <span class="n">err</span> <span class="o">!=</span> <span class="no">nil</span> <span class="p">{</span>
                                <span class="k">return</span> <span class="no">nil</span><span class="p">,</span> <span class="n">err</span>
                        <span class="p">}</span>
                        <span class="n">opts</span> <span class="o">=</span> <span class="nb">append</span><span class="p">(</span><span class="n">opts</span><span class="p">,</span> <span class="n">oci</span><span class="o">.</span><span class="n">WithWindowsNetworkNamespace</span><span class="p">(</span><span class="n">ns</span><span class="o">.</span><span class="n">GetPath</span><span class="p">()))</span>
                <span class="p">}</span>
</code></pre></div></div>

<p><code class="language-plaintext highlighter-rouge">NewNetNS</code> is defined in <code class="language-plaintext highlighter-rouge">pkg/netns/netns_windows.go</code></p>

<div class="language-go highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c">// NetNS holds network namespace for sandbox</span>
<span class="k">type</span> <span class="n">NetNS</span> <span class="k">struct</span> <span class="p">{</span>
        <span class="n">path</span> <span class="kt">string</span>
<span class="p">}</span>

<span class="c">// NewNetNS creates a network namespace for the sandbox.</span>
<span class="k">func</span> <span class="n">NewNetNS</span><span class="p">(</span><span class="n">baseDir</span> <span class="kt">string</span><span class="p">)</span> <span class="p">(</span><span class="o">*</span><span class="n">NetNS</span><span class="p">,</span> <span class="kt">error</span><span class="p">)</span> <span class="p">{</span>
        <span class="n">temp</span> <span class="o">:=</span> <span class="n">hcn</span><span class="o">.</span><span class="n">HostComputeNamespace</span><span class="p">{}</span>
        <span class="n">hcnNamespace</span><span class="p">,</span> <span class="n">err</span> <span class="o">:=</span> <span class="n">temp</span><span class="o">.</span><span class="n">Create</span><span class="p">()</span>
        <span class="k">if</span> <span class="n">err</span> <span class="o">!=</span> <span class="no">nil</span> <span class="p">{</span>
                <span class="k">return</span> <span class="no">nil</span><span class="p">,</span> <span class="n">err</span>
        <span class="p">}</span>

        <span class="k">return</span> <span class="o">&amp;</span><span class="n">NetNS</span><span class="p">{</span><span class="n">path</span><span class="o">:</span> <span class="n">hcnNamespace</span><span class="o">.</span><span class="n">Id</span><span class="p">},</span> <span class="no">nil</span>
<span class="p">}</span>
</code></pre></div></div>

<p>Following the thread, and cutting out a few steps in the interest of brevity, we end up in <code class="language-plaintext highlighter-rouge">vendor/github.com/Microsoft/hcsshim/hcn/zsyscall_windows.go</code> which calls a Win32 API.</p>

<div class="language-go highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">func</span> <span class="n">_hcnCreateNamespace</span><span class="p">(</span><span class="n">id</span> <span class="o">*</span><span class="n">_guid</span><span class="p">,</span> <span class="n">settings</span> <span class="o">*</span><span class="kt">uint16</span><span class="p">,</span> <span class="n">namespace</span> <span class="o">*</span><span class="n">hcnNamespace</span><span class="p">,</span> <span class="n">result</span> <span class="o">**</span><span class="kt">uint16</span><span class="p">)</span> <span class="p">(</span><span class="n">hr</span> <span class="kt">error</span><span class="p">)</span> <span class="p">{</span>
        <span class="n">hr</span> <span class="o">=</span> <span class="n">procHcnCreateNamespace</span><span class="o">.</span><span class="n">Find</span><span class="p">()</span>
        <span class="k">if</span> <span class="n">hr</span> <span class="o">!=</span> <span class="no">nil</span> <span class="p">{</span>
                <span class="k">return</span>
        <span class="p">}</span>
        <span class="n">r0</span><span class="p">,</span> <span class="n">_</span><span class="p">,</span> <span class="n">_</span> <span class="o">:=</span> <span class="n">syscall</span><span class="o">.</span><span class="n">SyscallN</span><span class="p">(</span><span class="n">procHcnCreateNamespace</span><span class="o">.</span><span class="n">Addr</span><span class="p">(),</span> <span class="kt">uintptr</span><span class="p">(</span><span class="n">unsafe</span><span class="o">.</span><span class="n">Pointer</span><span class="p">(</span><span class="n">id</span><span class="p">)),</span> <span class="kt">uintptr</span><span class="p">(</span><span class="n">unsafe</span><span class="o">.</span><span class="n">Pointer</span><span class="p">(</span><span class="n">settings</span><span class="p">)),</span> <span class="kt">uintptr</span><span class="p">(</span><span class="n">unsafe</span><span class="o">.</span><span class="n">Pointer</span><span class="p">(</span><span class="n">namespace</span><span class="p">)),</span> <span class="kt">uintptr</span><span class="p">(</span><span class="n">unsafe</span><span class="o">.</span><span class="n">Pointer</span><span class="p">(</span><span class="n">result</span><span class="p">)))</span>
        <span class="k">if</span> <span class="kt">int32</span><span class="p">(</span><span class="n">r0</span><span class="p">)</span> <span class="o">&lt;</span> <span class="m">0</span> <span class="p">{</span>
                <span class="k">if</span> <span class="n">r0</span><span class="o">&amp;</span><span class="m">0x1fff0000</span> <span class="o">==</span> <span class="m">0x00070000</span> <span class="p">{</span>
                        <span class="n">r0</span> <span class="o">&amp;=</span> <span class="m">0xffff</span>
                <span class="p">}</span>
                <span class="n">hr</span> <span class="o">=</span> <span class="n">syscall</span><span class="o">.</span><span class="n">Errno</span><span class="p">(</span><span class="n">r0</span><span class="p">)</span>
        <span class="p">}</span>
        <span class="k">return</span>
<span class="p">}</span>
</code></pre></div></div>

<p>PowerShell provides <code class="language-plaintext highlighter-rouge">Get-HnsNamespace</code> to list available namespaces. These <em>are</em> the <del>droids</del> values I’ve been looking for to put in <code class="language-plaintext highlighter-rouge">config.json</code>! However, by default there are no cmdlets to create them. The installation PowerShell <a href="https://github.com/microsoft/Windows-Containers/blob/Main/helpful_tools/Install-ContainerdRuntime/install-containerd-runtime.ps1">script</a> for <code class="language-plaintext highlighter-rouge">containerd</code> pulls in <a href="https://github.com/microsoft/SDN/blob/master/Kubernetes/windows/hns.psm1">hns.psm1</a> for <code class="language-plaintext highlighter-rouge">containerd</code>, has a lot of interesting cmdlets, such as <code class="language-plaintext highlighter-rouge">New-HnsNetwork</code>, but not a cmdlet to create a namespace. There is also <a href="https://github.com/microsoft/SDN/blob/master/Kubernetes/windows/hns.v2.psm1">hns.v2.psm1</a>, which does have <code class="language-plaintext highlighter-rouge">New-HnsNamespace</code>.</p>

<div class="language-powershell highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">PS</span><span class="w"> </span><span class="nx">C:\Users\Administrator</span><span class="err">&gt;</span><span class="w"> </span><span class="nx">curl.exe</span><span class="w"> </span><span class="nt">-o</span><span class="w"> </span><span class="nx">hns.v2.psm1</span><span class="w"> </span><span class="nt">-L</span><span class="w"> </span><span class="nx">https://raw.githubusercontent.com/microsoft/SDN/refs/heads/master/Kubernetes/windows/hns.v2.psm1</span><span class="w">
  </span><span class="o">%</span><span class="w"> </span><span class="n">Total</span><span class="w">    </span><span class="o">%</span><span class="w"> </span><span class="nx">Received</span><span class="w"> </span><span class="o">%</span><span class="w"> </span><span class="nx">Xferd</span><span class="w">  </span><span class="nx">Average</span><span class="w"> </span><span class="nx">Speed</span><span class="w">   </span><span class="nx">Time</span><span class="w">    </span><span class="nx">Time</span><span class="w">     </span><span class="nx">Time</span><span class="w">  </span><span class="nx">Current</span><span class="w">
                                 </span><span class="n">Dload</span><span class="w">  </span><span class="nx">Upload</span><span class="w">   </span><span class="nx">Total</span><span class="w">   </span><span class="nx">Spent</span><span class="w">    </span><span class="nx">Left</span><span class="w">  </span><span class="nx">Speed</span><span class="w">
</span><span class="mi">100</span><span class="w"> </span><span class="mi">89329</span><span class="w">  </span><span class="mi">100</span><span class="w"> </span><span class="mi">89329</span><span class="w">    </span><span class="mi">0</span><span class="w">     </span><span class="mi">0</span><span class="w">   </span><span class="mi">349</span><span class="n">k</span><span class="w">      </span><span class="nx">0</span><span class="w"> </span><span class="o">--</span><span class="p">:</span><span class="o">--</span><span class="p">:</span><span class="o">--</span><span class="w"> </span><span class="o">--</span><span class="p">:</span><span class="o">--</span><span class="p">:</span><span class="o">--</span><span class="w"> </span><span class="o">--</span><span class="p">:</span><span class="o">--</span><span class="p">:</span><span class="o">--</span><span class="w">  </span><span class="nx">353k</span><span class="w">

</span><span class="n">PS</span><span class="w"> </span><span class="nx">C:\Users\Administrator</span><span class="err">&gt;</span><span class="w"> </span><span class="nx">Import-Module</span><span class="w"> </span><span class="o">.</span><span class="nx">\hns.v2.psm1</span><span class="w">
</span><span class="n">WARNING:</span><span class="w"> </span><span class="nx">The</span><span class="w"> </span><span class="nx">names</span><span class="w"> </span><span class="nx">of</span><span class="w"> </span><span class="nx">some</span><span class="w"> </span><span class="nx">imported</span><span class="w"> </span><span class="nx">commands</span><span class="w"> </span><span class="nx">from</span><span class="w"> </span><span class="nx">the</span><span class="w"> </span><span class="nx">module</span><span class="w"> </span><span class="s1">'hns.v2'</span><span class="w"> </span><span class="nx">include</span><span class="w"> </span><span class="nx">unapproved</span><span class="w"> </span><span class="nx">verbs</span><span class="w"> </span><span class="nx">that</span><span class="w"> </span><span class="nx">might</span><span class="w"> </span><span class="nx">make</span><span class="w"> </span><span class="nx">them</span><span class="w"> </span><span class="nx">less</span><span class="w"> </span><span class="nx">discoverable.</span><span class="w"> </span><span class="nx">To</span><span class="w"> </span><span class="nx">find</span><span class="w"> </span><span class="nx">the</span><span class="w"> </span><span class="nx">commands</span><span class="w"> </span><span class="nx">with</span><span class="w"> </span><span class="nx">unapproved</span><span class="w"> </span><span class="nx">verbs</span><span class="p">,</span><span class="w"> </span><span class="nx">run</span><span class="w"> </span><span class="nx">the</span><span class="w"> </span><span class="nx">Import-Module</span><span class="w"> </span><span class="nx">command</span><span class="w"> </span><span class="nx">again</span><span class="w"> </span><span class="nx">with</span><span class="w"> </span><span class="nx">the</span><span class="w"> </span><span class="nx">Verbose</span><span class="w"> </span><span class="nx">parameter.</span><span class="w"> </span><span class="nx">For</span><span class="w"> </span><span class="nx">a</span><span class="w"> </span><span class="nx">list</span><span class="w"> </span><span class="nx">of</span><span class="w"> </span><span class="nx">approved</span><span class="w"> </span><span class="nx">verbs</span><span class="p">,</span><span class="w"> </span><span class="nx">type</span><span class="w"> </span><span class="nx">Get-Verb.</span><span class="w">

</span><span class="n">PS</span><span class="w"> </span><span class="nx">C:\Users\Administrator</span><span class="err">&gt;</span><span class="w"> </span><span class="nx">New-HnsNamespace</span><span class="w">
</span><span class="n">HcnCreateNamespace</span><span class="w"> </span><span class="o">--</span><span class="w"> </span><span class="nx">HRESULT:</span><span class="w"> </span><span class="nx">2151350299.</span><span class="w"> </span><span class="nx">Result:</span><span class="w"> </span><span class="p">{</span><span class="s2">"Success"</span><span class="p">:</span><span class="n">false</span><span class="p">,</span><span class="s2">"Error"</span><span class="p">:</span><span class="s2">"Invalid JSON document string. &amp;#123;&amp;#123;CreateWithCompartment,UnknownField}}"</span><span class="p">,</span><span class="s2">"ErrorCode"</span><span class="p">:</span><span class="nx">2151350299</span><span class="p">}</span><span class="w">
</span><span class="n">At</span><span class="w"> </span><span class="nx">C:\Users\Administrator\hns.v2.psm1:2392</span><span class="w"> </span><span class="nx">char:13</span><span class="w">
</span><span class="o">+</span><span class="w">             </span><span class="kr">throw</span><span class="w"> </span><span class="nv">$errString</span><span class="w">
</span><span class="o">+</span><span class="w">             </span><span class="n">~~~~~~~~~~~~~~~~</span><span class="w">
    </span><span class="o">+</span><span class="w"> </span><span class="nx">CategoryInfo</span><span class="w">          </span><span class="p">:</span><span class="w"> </span><span class="nx">OperationStopped:</span><span class="w"> </span><span class="p">(</span><span class="n">HcnCreateNamesp...de</span><span class="s2">":2151350299}:String) [], RuntimeException
    + FullyQualifiedErrorId : HcnCreateNamespace -- HRESULT: 2151350299. Result: {"</span><span class="nx">Success</span><span class="s2">":false,"</span><span class="nx">Error</span><span class="s2">":"</span><span class="nx">Invalid</span><span class="w"> </span><span class="nx">JSON</span><span class="w"> </span><span class="nx">document</span><span class="w"> </span><span class="nx">string.</span><span class="w"> </span><span class="o">&amp;</span><span class="c">#123;&amp;#123;CreateWithCompartment,UnknownField}}","ErrorCode":2151350299}</span><span class="w">
</span></code></pre></div></div>

<p>With a lot of frustration, I decided to have a go at calling the Win32 API from OCaml. This resulted in <a href="https://github.com/mtelvers/hcn-namespace">mtelvers/hcn-namespace</a>, which allows me to create the namespaces by running <code class="language-plaintext highlighter-rouge">hcn-namespace create</code>. These namespaces appear in the output from <code class="language-plaintext highlighter-rouge">Get-HnsNamespace</code> and work correctly in <code class="language-plaintext highlighter-rouge">config.json</code>.</p>

<p>Run <code class="language-plaintext highlighter-rouge">hcn-namespace.exe create</code>, and then populate <code class="language-plaintext highlighter-rouge">"networkNamespace": "&lt;GUID&gt;"</code> with the GUID provided and run with <code class="language-plaintext highlighter-rouge">ctr run --rm -cni --config config.json</code>.</p>
