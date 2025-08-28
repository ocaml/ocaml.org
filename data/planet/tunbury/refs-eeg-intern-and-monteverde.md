---
title: ReFS, EEG Intern and Monteverde
description: In addition to the post from last week covering BON in a Box and OCaml
  Functors, below are some additional notes.
url: https://www.tunbury.org/2025/07/07/refs-monteverde/
date: 2025-07-07T00:00:00-00:00
preview_image: https://www.tunbury.org/images/refs.png
authors:
- Mark Elvers
source:
ignore:
---

<p>In addition to the post from last week covering <a href="https://www.tunbury.org/2025/07/02/bon-in-a-box/">BON in a Box</a> and <a href="https://www.tunbury.org/2025/07/01/ocaml-functors/">OCaml Functors</a>, below are some additional notes.</p>

<h1>Resilient File System, ReFS</h1>

<p>I have previously stated that <a href="https://www.tunbury.org/windows-reflinks">ReFS</a> supports 1 million hard links per file; however, this is not the case. The maximum is considerably lower at 8191. That’s eight times more than NTFS, but still not very many.</p>

<div class="language-powershell highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">PS</span><span class="w"> </span><span class="nx">D:\</span><span class="err">&gt;</span><span class="w"> </span><span class="nx">touch</span><span class="w"> </span><span class="nx">foo</span><span class="w">
</span><span class="n">PS</span><span class="w"> </span><span class="nx">D:\</span><span class="err">&gt;</span><span class="w"> </span><span class="nx">foreach</span><span class="w"> </span><span class="p">(</span><span class="nv">$i</span><span class="w"> </span><span class="kr">in</span><span class="w"> </span><span class="mi">1</span><span class="o">..</span><span class="mi">8192</span><span class="p">)</span><span class="w"> </span><span class="p">{</span><span class="w">
</span><span class="err">&gt;&gt;</span><span class="w">     </span><span class="n">New-Item</span><span class="w"> </span><span class="nt">-ItemType</span><span class="w"> </span><span class="nx">HardLink</span><span class="w"> </span><span class="nt">-Path</span><span class="w"> </span><span class="s2">"foo-</span><span class="nv">$i</span><span class="s2">"</span><span class="w"> </span><span class="nt">-Target</span><span class="w"> </span><span class="s2">"foo"</span><span class="w">
</span><span class="err">&gt;&gt;</span><span class="w"> </span><span class="p">}</span><span class="w">


    </span><span class="n">Directory:</span><span class="w"> </span><span class="nx">D:\</span><span class="w">


</span><span class="n">Mode</span><span class="w">                 </span><span class="nx">LastWriteTime</span><span class="w">         </span><span class="nx">Length</span><span class="w"> </span><span class="nx">Name</span><span class="w">
</span><span class="o">----</span><span class="w">                 </span><span class="o">-------------</span><span class="w">         </span><span class="o">------</span><span class="w"> </span><span class="o">----</span><span class="w">
</span><span class="nt">-a</span><span class="o">----</span><span class="w">        </span><span class="mi">07</span><span class="n">/07/2025</span><span class="w">     </span><span class="nx">01:00</span><span class="w">              </span><span class="nx">0</span><span class="w"> </span><span class="nx">foo-1</span><span class="w">
</span><span class="nt">-a</span><span class="o">----</span><span class="w">        </span><span class="mi">07</span><span class="n">/07/2025</span><span class="w">     </span><span class="nx">01:00</span><span class="w">              </span><span class="nx">0</span><span class="w"> </span><span class="nx">foo-2</span><span class="w">
</span><span class="nt">-a</span><span class="o">----</span><span class="w">        </span><span class="mi">07</span><span class="n">/07/2025</span><span class="w">     </span><span class="nx">01:00</span><span class="w">              </span><span class="nx">0</span><span class="w"> </span><span class="nx">foo-3</span><span class="w">
</span><span class="nt">-a</span><span class="o">----</span><span class="w">        </span><span class="mi">07</span><span class="n">/07/2025</span><span class="w">     </span><span class="nx">01:00</span><span class="w">              </span><span class="nx">0</span><span class="w"> </span><span class="nx">foo-4</span><span class="w">
</span><span class="o">...</span><span class="w">
</span><span class="nt">-a</span><span class="o">----</span><span class="w">        </span><span class="mi">07</span><span class="n">/07/2025</span><span class="w">     </span><span class="nx">01:00</span><span class="w">              </span><span class="nx">0</span><span class="w"> </span><span class="nx">foo-8190</span><span class="w">
</span><span class="nt">-a</span><span class="o">----</span><span class="w">        </span><span class="mi">07</span><span class="n">/07/2025</span><span class="w">     </span><span class="nx">01:00</span><span class="w">              </span><span class="nx">0</span><span class="w"> </span><span class="nx">foo-8191</span><span class="w">
</span><span class="n">New-Item</span><span class="w"> </span><span class="p">:</span><span class="w"> </span><span class="nx">An</span><span class="w"> </span><span class="nx">attempt</span><span class="w"> </span><span class="nx">was</span><span class="w"> </span><span class="nx">made</span><span class="w"> </span><span class="nx">to</span><span class="w"> </span><span class="nx">create</span><span class="w"> </span><span class="nx">more</span><span class="w"> </span><span class="nx">links</span><span class="w"> </span><span class="nx">on</span><span class="w"> </span><span class="nx">a</span><span class="w"> </span><span class="nx">file</span><span class="w"> </span><span class="nx">than</span><span class="w"> </span><span class="nx">the</span><span class="w"> </span><span class="nx">file</span><span class="w"> </span><span class="nx">system</span><span class="w"> </span><span class="nx">supports</span><span class="w">
</span><span class="n">At</span><span class="w"> </span><span class="nx">line:2</span><span class="w"> </span><span class="nx">char:5</span><span class="w">
</span><span class="o">+</span><span class="w">     </span><span class="n">New-Item</span><span class="w"> </span><span class="nt">-ItemType</span><span class="w"> </span><span class="nx">HardLink</span><span class="w"> </span><span class="nt">-Path</span><span class="w"> </span><span class="s2">"foo-</span><span class="nv">$i</span><span class="s2">"</span><span class="w"> </span><span class="nt">-Target</span><span class="w"> </span><span class="s2">"foo"</span><span class="w">
</span><span class="o">+</span><span class="w">     </span><span class="n">~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~</span><span class="w">
    </span><span class="o">+</span><span class="w"> </span><span class="nx">CategoryInfo</span><span class="w">          </span><span class="p">:</span><span class="w"> </span><span class="nx">NotSpecified:</span><span class="w"> </span><span class="p">(:)</span><span class="w"> </span><span class="p">[</span><span class="n">New</span><span class="nt">-Item</span><span class="p">],</span><span class="w"> </span><span class="n">Win32Exception</span><span class="w">
    </span><span class="o">+</span><span class="w"> </span><span class="nx">FullyQualifiedErrorId</span><span class="w"> </span><span class="p">:</span><span class="w"> </span><span class="nx">System.ComponentModel.Win32Exception</span><span class="p">,</span><span class="nx">Microsoft.PowerShell.Commands.NewItemCommand</span><span class="w">
</span></code></pre></div></div>

<p>I had also investigated ReFS block cloning, which removed the requirement to create hard links, and wrote a <a href="https://github.com/mtelvers/ReFS-Clone">ReFS-clone</a> tool for Windows Server 2022. This works well until containerd is used to bind mount a directory on the volume. Once this has happened, attempts to create a block clone fail. To exclude my code as the root cause, I have tried Windows Server 2025, where commands such as <code class="language-plaintext highlighter-rouge">copy</code> and <code class="language-plaintext highlighter-rouge">robocopy</code> automatically perform block clones. Block cloning can be restored by rebooting the machine. I note that restarting containerd is not sufficient.</p>

<p>Removing files and folders on ReFS is impressively fast; however, this comes at a cost: freeing the blocks is a background activity that may take some time to be scheduled.</p>

<h1>File system performance with a focus on ZFS</h1>

<p>Several EEG interns started last week with this <a href="https://anil.recoil.org/ideas/zfs-filesystem-perf">project</a> under my supervision. In brief, we will examine file system performance on the filesystems supported by <a href="https://github.com/ocurrent/obuilder">OBuilder</a> before conducting more detailed investigations into factors affecting ZFS performance.</p>

<h1>Monteverde</h1>

<p>monteverde.cl.cam.ac.uk, has been installed in the rack. It has two AMD EPYC 9965 192-Core Processors, giving a total of 384 cores and 768 threads and 3TB of RAM.</p>

<p><img src="https://www.tunbury.org/images/monteverde.jpg" alt=""></p>

<p>From the logs, there are still some teething issues:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>[130451.620482] Large kmem_alloc(98304, 0x1000), please file an issue at:
                https://github.com/openzfs/zfs/issues/new
[130451.620486] CPU: 51 UID: 0 PID: 8594 Comm: txg_sync Tainted: P           O       6.14.0-23-generic #23-Ubuntu
[130451.620488] Tainted: [P]=PROPRIETARY_MODULE, [O]=OOT_MODULE
[130451.620489] Hardware name: Dell Inc. PowerEdge R7725/0KRFPX, BIOS 1.1.3 02/25/2025
[130451.620490] Call Trace:
[130451.620490]  &lt;TASK&gt;
[130451.620492]  show_stack+0x49/0x60
[130451.620493]  dump_stack_lvl+0x5f/0x90
[130451.620495]  dump_stack+0x10/0x18
[130451.620497]  spl_kmem_alloc_impl.cold+0x17/0x1c [spl]
[130451.620503]  spl_kmem_zalloc+0x19/0x30 [spl]
[130451.620508]  multilist_create_impl+0x3f/0xc0 [zfs]
[130451.620586]  multilist_create+0x31/0x50 [zfs]
[130451.620650]  dmu_objset_sync+0x4c4/0x4d0 [zfs]
[130451.620741]  dsl_pool_sync_mos+0x34/0xc0 [zfs]
[130451.620832]  dsl_pool_sync+0x3c1/0x420 [zfs]
[130451.620910]  spa_sync_iterate_to_convergence+0xda/0x220 [zfs]
[130451.620990]  spa_sync+0x333/0x660 [zfs]
[130451.621056]  txg_sync_thread+0x1f5/0x270 [zfs]
[130451.621137]  ? __pfx_txg_sync_thread+0x10/0x10 [zfs]
[130451.621207]  ? __pfx_thread_generic_wrapper+0x10/0x10 [spl]
[130451.621213]  thread_generic_wrapper+0x5b/0x70 [spl]
[130451.621217]  kthread+0xf9/0x230
[130451.621219]  ? __pfx_kthread+0x10/0x10
[130451.621221]  ret_from_fork+0x44/0x70
[130451.621223]  ? __pfx_kthread+0x10/0x10
[130451.621224]  ret_from_fork_asm+0x1a/0x30
[130451.621226]  &lt;/TASK&gt;
</code></pre></div></div>
