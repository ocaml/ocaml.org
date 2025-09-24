---
title: Vulkan graphics in OCaml vs C
description:
url: https://roscidus.com/blog/blog/2025/09/20/ocaml-vulkan/
date: 2025-09-20T09:00:00-00:00
preview_image:
authors:
- Thomas Leonard
source:
ignore:
---

<p>I convert my Vulkan test program from C to OCaml and compare the results,
then continue the Vulkan tutorial in OCaml, adding 3D, textures and depth buffering.</p>

<p><strong>Table of Contents</strong></p>
<ul>
<li><a href="https://roscidus.com/#introduction">Introduction</a>
</li>
<li><a href="https://roscidus.com/#running-it-yourself">Running it yourself</a>
</li>
<li><a href="https://roscidus.com/#the-direct-port">The direct port</a>
<ul>
<li><a href="https://roscidus.com/#labelled-arguments">Labelled arguments</a>
</li>
<li><a href="https://roscidus.com/#enums-and-bit-fields">Enums and bit-fields</a>
</li>
<li><a href="https://roscidus.com/#optional-fields">Optional fields</a>
</li>
<li><a href="https://roscidus.com/#loading-shaders">Loading shaders</a>
</li>
<li><a href="https://roscidus.com/#logging">Logging</a>
</li>
<li><a href="https://roscidus.com/#error-handling">Error handling</a>
</li>
</ul>
</li>
<li><a href="https://roscidus.com/#refactored-version">Refactored version</a>
<ul>
<li><a href="https://roscidus.com/#olivine-wrappers">Olivine wrappers</a>
</li>
<li><a href="https://roscidus.com/#using-fibers--effects-for-control-flow">Using fibers / effects for control flow</a>
</li>
<li><a href="https://roscidus.com/#using-the-cpu-and-gpu-in-parallel">Using the CPU and GPU in parallel</a>
</li>
<li><a href="https://roscidus.com/#resizing-and-resource-lifetimes">Resizing and resource lifetimes</a>
</li>
</ul>
</li>
<li><a href="https://roscidus.com/#the-3d-version">The 3D version</a>
</li>
<li><a href="https://roscidus.com/#garbage-collection">Garbage collection</a>
</li>
<li><a href="https://roscidus.com/#conclusions">Conclusions</a>
</li>
</ul>
<p>( this post also appeared on <a href="https://lobste.rs/s/pzhqdb/vulkan_graphics_ocaml_vs_c">Lobsters</a> )</p>
<h2>Introduction</h2>
<p>In <a href="https://roscidus.com/blog/blog/2025/06/24/graphics/">Investigating Linux graphics</a>,
I wrote a little C program to help me learn about GPUs by drawing a triangle.
But I wondered if using OCaml instead would make my life easier.
It didn't, because there were no released OCaml Vulkan bindings,
but I found some <a href="https://github.com/Octachron/olivine">unfinished ones</a> by Florian Angeletti.
The bindings are generated mostly automatically from <a href="https://github.com/KhronosGroup/Vulkan-Docs/tree/main/xml">the Vulkan XML specification</a>,
and with <a href="https://github.com/talex5/olivine/commits/blog">a bit of effort</a> I got them working well enough to
continue with the <a href="https://docs.vulkan.org/tutorial/latest/00_Introduction.html">Vulkan tutorial</a>,
which resulted in this nice <a href="https://sketchfab.com/3d-models/viking-room-a49f1b8e4f5c4ecf9e1fe7d81915ad38">Viking room</a>:</p>
<p><a href="https://roscidus.com/blog/images/vulkan-ocaml/viking.png"><span class="caption-wrapper center"><img src="https://roscidus.com/blog/images/vulkan-ocaml/viking.png" title="Vulkan tutorial in OCaml" class="caption"><span class="caption-text">Vulkan tutorial in OCaml</span></span></a></p>
<p>In this post, I'll be looking at how the C code compares to the OCaml.
First, I did a direct line-by-line port of the C, then I refactored it to take better advantage of OCaml.</p>
<p>(Note: the Vulkan tutorial is actually <a href="https://docs.vulkan.org/tutorial/latest/_attachments/28_model_loading.cpp">using C++</a>, but I'm comparing my C version to OCaml)</p>
<h2>Running it yourself</h2>
<p>If you want to try it yourself (note: it requires Wayland):</p>
<pre><code>git clone https://github.com/talex5/vulkan-test -b ocaml
cd vulkan-test
nix develop
dune exec -- ./src/main.exe 200
</code></pre>
<p>As the OCaml Vulkan bindings (Olivine) are unreleased,
I included a copy of my patched version in <code>vendor/olivine</code>.
The <code>dune exec</code> command will build them automatically.</p>
<p>The <code>ocaml</code> branch above just draws one triangle.
If you want to see the 3D room pictured above, use <code>ocaml-3d</code> instead:</p>
<pre><code>git clone https://github.com/talex5/vulkan-test -b ocaml-3d
cd vulkan-test
nix develop
make download-example
dune exec -- ./src/main.exe 10000 viking_room.obj viking_room.png
</code></pre>
<h2>The direct port</h2>
<p>Porting the code directly, line by line, was pretty straight-forward:</p>
<p><a href="https://roscidus.com/blog/images/vulkan-ocaml/meld.png"><span class="caption-wrapper center"><img src="https://roscidus.com/blog/images/vulkan-ocaml/meld.png" title="Comparing the code with meld" class="caption"><span class="caption-text">Comparing the code with meld</span></span></a></p>
<p><a href="https://github.com/talex5/vulkan-test/tree/direct-port/src">The code</a> ended up slightly shorter, but not by much:</p>
<pre><code> 28 files changed, 1223 insertions(+), 1287 deletions(-)
</code></pre>
<p>This is only approximate; sometimes I added or removed blank lines, etc.
Some things were a bit easier and others a bit harder. It mostly balanced out.</p>
<p>As an example, one thing that makes the OCaml shorter is that arrays are passed as a single item,
whereas C takes the length separately.
On the other hand, single-item arrays can be passed in C by just giving the address of the pointer,
whereas OCaml requires an array to be constructed separately.
Also, I had to include some bindings for the libdrm C library.</p>
<h3>Labelled arguments</h3>
<p>The OCaml bindings use labelled arguments
(e.g. the <code>VK_TRUE</code> argument in the screenshot above became <code>~wait_all:true</code> in the OCaml),
which is longer but clearer.</p>
<p>The OCaml code uses functions to create C structures, which looks pretty similar due to labels.
For example:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
</pre></td><td class="code"><pre><code class="c"><span class="line"><span class="k">const</span><span class="w"> </span><span class="n">VkSemaphoreGetFdInfoKHR</span><span class="w"> </span><span class="n">get_fd_info</span><span class="w"> </span><span class="o">=</span><span class="w"> </span><span class="p">{</span>
</span><span class="line"><span class="w">    </span><span class="p">.</span><span class="n">sType</span><span class="w"> </span><span class="o">=</span><span class="w"> </span><span class="n">VK_STRUCTURE_TYPE_SEMAPHORE_GET_FD_INFO_KHR</span><span class="p">,</span>
</span><span class="line"><span class="w">    </span><span class="p">.</span><span class="n">semaphore</span><span class="w"> </span><span class="o">=</span><span class="w"> </span><span class="n">semaphore</span><span class="p">,</span>
</span><span class="line"><span class="w">    </span><span class="p">.</span><span class="n">handleType</span><span class="w"> </span><span class="o">=</span><span class="w"> </span><span class="n">VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_SYNC_FD_BIT</span><span class="p">,</span>
</span><span class="line"><span class="p">};</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>becomes:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">get_fd_info</span> <span class="o">=</span> <span class="nn">Vkt</span><span class="p">.</span><span class="nn">Semaphore_get_fd_info_khr</span><span class="p">.</span><span class="n">make</span> <span class="bp">()</span>
</span><span class="line">    <span class="o">~</span><span class="n">semaphore</span>
</span><span class="line">    <span class="o">~</span><span class="n">handle_type</span><span class="o">:</span><span class="nn">Vkt</span><span class="p">.</span><span class="nn">External_semaphore_handle_type_flags</span><span class="p">.</span><span class="n">sync_fd</span>
</span><span class="line"><span class="k">in</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>An advantage is that the <code>sType</code> field gets filled in automatically.</p>
<h3>Enums and bit-fields</h3>
<p>Enumerations and bit-fields are namespaced, which is a lot clearer
as you can see which part is the name of the enum and which part is the particular value.
For example, <code>VK_ATTACHMENT_STORE_OP_STORE</code> becomes <code>Vkt.Attachment_store_op.Store</code>.
Also, OCaml usually knows the expected type and you can omit the module, so:</p>
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
</pre></td><td class="code"><pre><code class="c"><span class="line"><span class="n">VkAttachmentDescription</span><span class="w"> </span><span class="n">colorAttachment</span><span class="w"> </span><span class="o">=</span><span class="w"> </span><span class="p">{</span>
</span><span class="line"><span class="w">    </span><span class="p">.</span><span class="n">format</span><span class="w"> </span><span class="o">=</span><span class="w"> </span><span class="n">format</span><span class="p">,</span>
</span><span class="line"><span class="w">    </span><span class="p">.</span><span class="n">samples</span><span class="w"> </span><span class="o">=</span><span class="w"> </span><span class="n">VK_SAMPLE_COUNT_1_BIT</span><span class="p">,</span>
</span><span class="line"><span class="w">    </span><span class="p">.</span><span class="n">loadOp</span><span class="w"> </span><span class="o">=</span><span class="w"> </span><span class="n">VK_ATTACHMENT_LOAD_OP_CLEAR</span><span class="p">,</span><span class="w">  </span><span class="c1">// Clear framebuffer before rendering</span>
</span><span class="line"><span class="w">    </span><span class="p">.</span><span class="n">storeOp</span><span class="w"> </span><span class="o">=</span><span class="w"> </span><span class="n">VK_ATTACHMENT_STORE_OP_STORE</span><span class="p">,</span>
</span><span class="line"><span class="w">    </span><span class="p">.</span><span class="n">stencilLoadOp</span><span class="w"> </span><span class="o">=</span><span class="w"> </span><span class="n">VK_ATTACHMENT_LOAD_OP_DONT_CARE</span><span class="p">,</span>
</span><span class="line"><span class="w">    </span><span class="p">.</span><span class="n">stencilStoreOp</span><span class="w"> </span><span class="o">=</span><span class="w"> </span><span class="n">VK_ATTACHMENT_STORE_OP_DONT_CARE</span><span class="p">,</span>
</span><span class="line"><span class="w">    </span><span class="p">.</span><span class="n">initialLayout</span><span class="w"> </span><span class="o">=</span><span class="w"> </span><span class="n">VK_IMAGE_LAYOUT_UNDEFINED</span><span class="p">,</span>
</span><span class="line"><span class="w">    </span><span class="p">.</span><span class="n">finalLayout</span><span class="w"> </span><span class="o">=</span><span class="w"> </span><span class="n">VK_IMAGE_LAYOUT_GENERAL</span><span class="p">,</span>
</span><span class="line"><span class="p">};</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>becomes</p>
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
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">color_attachment</span> <span class="o">=</span> <span class="nn">Vkt</span><span class="p">.</span><span class="nn">Attachment_description</span><span class="p">.</span><span class="n">make</span> <span class="bp">()</span>
</span><span class="line">    <span class="o">~</span><span class="n">format</span><span class="o">:</span><span class="n">format</span>
</span><span class="line">    <span class="o">~</span><span class="n">samples</span><span class="o">:</span><span class="nn">Vkt</span><span class="p">.</span><span class="nn">Sample_count_flags</span><span class="p">.</span><span class="n">n1</span>
</span><span class="line">    <span class="o">~</span><span class="n">load_op</span><span class="o">:</span><span class="nc">Clear</span>	<span class="c">(* Clear framebuffer before rendering *)</span>
</span><span class="line">    <span class="o">~</span><span class="n">store_op</span><span class="o">:</span><span class="nc">Store</span>
</span><span class="line">    <span class="o">~</span><span class="n">stencil_load_op</span><span class="o">:</span><span class="nc">Dont_care</span>
</span><span class="line">    <span class="o">~</span><span class="n">stencil_store_op</span><span class="o">:</span><span class="nc">Dont_care</span>
</span><span class="line">    <span class="o">~</span><span class="n">initial_layout</span><span class="o">:</span><span class="nc">Undefined</span>
</span><span class="line">    <span class="o">~</span><span class="n">final_layout</span><span class="o">:</span><span class="nc">General</span>
</span><span class="line"><span class="k">in</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Bit-fields and enums get their own types (they're not just integers), so you can't use them in the wrong place
or try to combine things that aren't bit-fields (and so the <code>_BIT</code> suffix isn't needed).
One particularly striking example of the difference is that</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
</pre></td><td class="code"><pre><code class="c"><span class="line"><span class="p">.</span><span class="n">colorWriteMask</span><span class="w"> </span><span class="o">=</span>
</span><span class="line"><span class="w">    </span><span class="n">VK_COLOR_COMPONENT_R_BIT</span><span class="w"> </span><span class="o">|</span>
</span><span class="line"><span class="w">    </span><span class="n">VK_COLOR_COMPONENT_G_BIT</span><span class="w"> </span><span class="o">|</span>
</span><span class="line"><span class="w">    </span><span class="n">VK_COLOR_COMPONENT_B_BIT</span><span class="w"> </span><span class="o">|</span>
</span><span class="line"><span class="w">    </span><span class="n">VK_COLOR_COMPONENT_A_BIT</span><span class="p">,</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>becomes</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="o">~</span><span class="n">color_write_mask</span><span class="o">:</span><span class="nn">Vkt</span><span class="p">.</span><span class="nn">Color_component_flags</span><span class="p">.</span><span class="o">(</span><span class="n">r</span> <span class="o">+</span> <span class="n">g</span> <span class="o">+</span> <span class="n">b</span> <span class="o">+</span> <span class="n">a</span><span class="o">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>The <code>Vkt.Color_component_flags.(...)</code> brings all the module's symbols into scope,
including the <code>+</code> operator for combining the flags.</p>
<h3>Optional fields</h3>
<p>The specification says which fields are optional. In C you can ignore that, but OCaml enforces it.
This can be annoying sometimes, e.g.</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
</pre></td><td class="code"><pre><code class="c"><span class="line"><span class="p">.</span><span class="n">blendEnable</span><span class="w"> </span><span class="o">=</span><span class="w"> </span><span class="n">VK_FALSE</span><span class="p">,</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>becomes</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="o">~</span><span class="n">blend_enable</span><span class="o">:</span><span class="bp">false</span>
</span><span class="line"><span class="o">~</span><span class="n">src_color_blend_factor</span><span class="o">:</span><span class="nc">One</span>
</span><span class="line"><span class="o">~</span><span class="n">dst_color_blend_factor</span><span class="o">:</span><span class="nc">Zero</span>
</span><span class="line"><span class="o">~</span><span class="n">color_blend_op</span><span class="o">:</span><span class="nc">Add</span>
</span><span class="line"><span class="o">~</span><span class="n">src_alpha_blend_factor</span><span class="o">:</span><span class="nc">One</span>
</span><span class="line"><span class="o">~</span><span class="n">dst_alpha_blend_factor</span><span class="o">:</span><span class="nc">Zero</span>
</span><span class="line"><span class="o">~</span><span class="n">alpha_blend_op</span><span class="o">:</span><span class="nc">Add</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>because the spec says these are all non-optional, rather than that they are only needed when blending is enabled.</p>
<p>There's a similar situation with the Wayland code:
the OCaml compiler requires you to provide a handler for all possible events.
For example, OCaml forced me to write a handler for the window <code>close</code> event
(and so closing the window works in the OCaml version, but not in the C one).
Likewise, if the compositor returns an error from <code>create_immed</code> the OCaml version logs it,
while the C version ignored the error message, because the C compiler didn't remind me about that.</p>
<h3>Loading shaders</h3>
<p>Loading the shaders was easier.
The C version has code to load the shader bytecode from disk, but in the OCaml I used <a href="https://github.com/johnwhitington/ppx_blob">ppx_blob</a>
to include it at compile time, producing a self-contained executable file:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="n">load_shader_module</span> <span class="n">device</span> <span class="o">[%</span><span class="n">blob</span> <span class="s2">"./vert.spv"</span><span class="o">]</span>
</span></code></pre></td></tr></tbody></table></div></figure><h3>Logging</h3>
<p>OCaml has a somewhat standard logging library, so I was able to get the logs messages shown as I wanted
without having to pipe the output through <code>awk</code>.
And, as a bonus, the log messages get written in the correct order now.
e.g. the C libwayland logs:</p>
<pre><code>wl_display#1.delete_id(3)
...
wl_callback#3.done(59067)
</code></pre>
<p>which appears to show a callback firing some time after it was deleted,
while <a href="https://github.com/talex5/ocaml-wayland">ocaml-wayland</a> logs:</p>
<pre><code>&lt;- wl_callback@3.done callback_data:1388855
&lt;- wl_display@1.delete_id id:3
</code></pre>
<h3>Error handling</h3>
<p>The OCaml bindings return a <code>result</code> type for functions that can return errors,
using polymorphic variants to say exactly which errors can be returned by each function.
That's clever, but I found it pretty useless in practice and I followed the Olivine example code
in immediately turning every <code>Error</code> result into an exception.
You can then handle errors at a higher level (unlike the C, which just calls <code>exit</code>).
Maybe Olivine should be changed to do that itself.</p>
<p>I thought I'd been rigorous about checking for errors in the C, but I missed some places (e.g. <code>vkMapMemory</code>).
The OCaml compiler forced me to handle those too, of course.</p>
<h2>Refactored version</h2>
<p>One reason to switch to OCaml was because I was finding it hard to see how all the C code fit together.
I felt that the overall structure was getting lost in the noise.
While the initial OCaml version was similar to the C,
I think <a href="https://github.com/talex5/vulkan-test/tree/ocaml/src">the refactored version</a> is quite a bit easier to read.</p>
<p>Moving code to separate files is much easier than in C.
There, you typically need to write a header file too, and then include it from the other files.
But in the OCaml I could just move e.g. <code>export_semaphore</code> to <code>export</code> in a new file called <code>semaphore.ml</code> and
refer to it as <code>Semaphore.export</code>.
Because each file gets its own namespace, you don't have to guess where functions are defined,
and you don't get naming conflicts between symbols in different files.
The build system (dune) automatically builds all modules in the correct order.</p>
<h3>Olivine wrappers</h3>
<p>I added a <code>vulkan</code> directory with wrappers around the auto-generated Vulkan functions
with the aim of removing some noise.
For example, the wrappers take OCaml lists and convert them to C arrays as needed,
and raise exceptions on error instead of returning a result type.</p>
<p>Sometimes they do more, as in the case of <code>queue_submit</code>.
That took separate <code>wait_semaphores</code> and <code>wait_dst_stage_mask</code> arrays,
requiring them to be the same length.
By taking a list of tuples, the wrapper avoids the possibility of this error.
The old submit code:</p>
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
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">wait_semaphores</span> <span class="o">=</span> <span class="nn">Vkt</span><span class="p">.</span><span class="nn">Semaphore</span><span class="p">.</span><span class="n">array</span> <span class="o">[</span><span class="n">t</span><span class="o">.</span><span class="n">image_available</span><span class="o">]</span> <span class="k">in</span>
</span><span class="line"><span class="k">let</span> <span class="n">wait_stages</span> <span class="o">=</span> <span class="o">[</span><span class="nn">Vkt</span><span class="p">.</span><span class="nn">Pipeline_stage_flags</span><span class="p">.</span><span class="n">color_attachment_output</span><span class="o">]</span> <span class="k">in</span>
</span><span class="line"><span class="k">let</span> <span class="n">submit_info</span> <span class="o">=</span> <span class="nn">Vkt</span><span class="p">.</span><span class="nn">Submit_info</span><span class="p">.</span><span class="n">make</span> <span class="bp">()</span>
</span><span class="line">    <span class="o">~</span><span class="n">wait_semaphores</span>
</span><span class="line">    <span class="o">~</span><span class="n">wait_dst_stage_mask</span><span class="o">:(</span><span class="nn">A</span><span class="p">.</span><span class="n">of_list</span> <span class="nn">Vkt</span><span class="p">.</span><span class="nn">Pipeline_stage_flags</span><span class="p">.</span><span class="n">ctype</span> <span class="n">wait_stages</span><span class="o">)</span>
</span><span class="line">    <span class="o">~</span><span class="n">command_buffers</span><span class="o">:(</span><span class="nn">Vkt</span><span class="p">.</span><span class="nn">Command_buffer</span><span class="p">.</span><span class="n">array</span> <span class="o">[</span><span class="n">t</span><span class="o">.</span><span class="n">command_buffer</span><span class="o">])</span>
</span><span class="line">    <span class="o">~</span><span class="n">signal_semaphores</span><span class="o">:(</span><span class="nn">Vkt</span><span class="p">.</span><span class="nn">Semaphore</span><span class="p">.</span><span class="n">array</span> <span class="o">[</span><span class="n">frame_state</span><span class="o">.</span><span class="n">render_finished</span><span class="o">])</span>
</span><span class="line"><span class="k">in</span>
</span><span class="line"><span class="nn">Vkc</span><span class="p">.</span><span class="n">queue_submit</span> <span class="n">t</span><span class="o">.</span><span class="n">graphics_queue</span> <span class="bp">()</span>
</span><span class="line">  <span class="o">~</span><span class="n">submits</span><span class="o">:(</span><span class="nn">Vkt</span><span class="p">.</span><span class="nn">Submit_info</span><span class="p">.</span><span class="n">array</span> <span class="o">[</span><span class="n">submit_info</span><span class="o">])</span>
</span><span class="line">  <span class="o">~</span><span class="n">fence</span><span class="o">:</span><span class="n">t</span><span class="o">.</span><span class="n">in_flight_fence</span> <span class="o">&lt;?&gt;</span> <span class="s2">"queue_submit"</span><span class="o">;</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>becomes:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="nn">Vulkan</span><span class="p">.</span><span class="nn">Cmd</span><span class="p">.</span><span class="n">submit</span> <span class="n">device</span> <span class="n">t</span><span class="o">.</span><span class="n">command_buffer</span>
</span><span class="line">  <span class="o">~</span><span class="n">wait</span><span class="o">:[</span><span class="n">t</span><span class="o">.</span><span class="n">image_available</span><span class="o">,</span> <span class="nn">Vkt</span><span class="p">.</span><span class="nn">Pipeline_stage_flags</span><span class="p">.</span><span class="n">color_attachment_output</span><span class="o">]</span>
</span><span class="line">  <span class="o">~</span><span class="n">signal_semaphores</span><span class="o">:[</span><span class="n">frame_state</span><span class="o">.</span><span class="n">render_finished</span><span class="o">]</span>
</span><span class="line">  <span class="o">~</span><span class="n">fence</span><span class="o">:</span><span class="n">t</span><span class="o">.</span><span class="n">in_flight_fence</span><span class="o">;</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Sometimes the new API drops features I don't use (or don't currently understand).
For example, my new <code>submit</code> only lets you submit one command buffer at a time
(though each buffer can have many commands).</p>
<p>I moved various generic helper functions like <code>find_memory_type</code> to the wrapper library,
getting them out of the main application code.</p>
<p>Separating out these libraries made the code longer, but I think it makes it easier to read:</p>
<pre><code> 20 files changed, 843 insertions(+), 663 deletions(-)
</code></pre>
<h3>Using fibers / effects for control flow</h3>
<p>The C code has a single thread with a single stack,
using callbacks to redraw when the compositor is ready.
OCaml has fibers (light-weight cooperative threads), so we can use a plain loop:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">while</span> <span class="n">t</span><span class="o">.</span><span class="n">frame</span> <span class="o">&lt;</span> <span class="n">frame_limit</span> <span class="k">do</span>
</span><span class="line">  <span class="k">let</span> <span class="n">next_frame_due</span> <span class="o">=</span> <span class="nn">Window</span><span class="p">.</span><span class="n">frame</span> <span class="n">window</span> <span class="k">in</span>
</span><span class="line">  <span class="n">draw_frame</span> <span class="n">t</span><span class="o">;</span>
</span><span class="line">  <span class="nn">Promise</span><span class="p">.</span><span class="n">await</span> <span class="n">next_frame_due</span><span class="o">;</span>
</span><span class="line">  <span class="n">t</span><span class="o">.</span><span class="n">frame</span> <span class="o">&lt;-</span> <span class="n">t</span><span class="o">.</span><span class="n">frame</span> <span class="o">+</span> <span class="mi">1</span>
</span><span class="line"><span class="k">done</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>The <code>Promise.await</code> suspends this fiber, allowing e.g. the Wayland code to handle incoming events.
I find that makes the logic easier to follow.</p>
<h3>Using the CPU and GPU in parallel</h3>
<p>Next I split off the input handling from the huge <code>render.ml</code> file into <a href="https://github.com/talex5/vulkan-test/tree/ocaml/src/input.ml">input.ml</a>.</p>
<p>The Vulkan tutorial creates one uniform buffer for the input data for each frame-buffer, but this seems wasteful.
I think we only need at most two: one for the GPU to read, and one for the CPU to write for the next frame,
if we want to do that in parallel.</p>
<p>To allow this parallel operation I also had to create a pair of command buffers.
The <a href="https://github.com/talex5/vulkan-test/tree/ocaml/src/duo.ml">duo.ml</a> module holds the two (input, command-buffer) jobs and swaps them on submit.</p>
<h3>Resizing and resource lifetimes</h3>
<p>When the window size changes we need to destroy the old swap-chain and recreate all the images, views
and framebuffers.
My C code didn't bother, and just kept things at 640x480.</p>
<p>The main problem here is how to clean up the old resources.
We could use the garbage collector, but the framebuffers are rather large and I'd like to get them freed promptly.
Also, Vulkan requires things to be freed in the correct order, which the GC wouldn't ensure.</p>
<p>I added code to free resources by having each constructor take a <code>sw</code> switch argument.
When the switch is turned off, all resources attached to it are freed.
That makes it easy to scope things to the stack: when the <code>Switch.run</code> block ends, all resources it created are freed.</p>
<p>But the life-cycle of the swap-chain is a little complicated.
I don't want to clutter the main application loop with the logic of adapting to size changes.
Again, OCaml's fibers system makes it easy to have multiple stacks so I have another fiber run:</p>
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
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">render_loop</span> <span class="n">t</span> <span class="n">duo</span> <span class="o">=</span>
</span><span class="line">  <span class="k">while</span> <span class="bp">true</span> <span class="k">do</span>
</span><span class="line">    <span class="k">let</span> <span class="n">geometry</span> <span class="o">=</span> <span class="nn">Window</span><span class="p">.</span><span class="n">geometry</span> <span class="n">t</span><span class="o">.</span><span class="n">window</span> <span class="k">in</span>
</span><span class="line">    <span class="nn">Switch</span><span class="p">.</span><span class="n">run</span> <span class="o">@@</span> <span class="k">fun</span> <span class="n">sw</span> <span class="o">-&gt;</span>
</span><span class="line">    <span class="k">let</span> <span class="n">framebuffers</span> <span class="o">=</span> <span class="n">create_swapchain</span> <span class="o">~</span><span class="n">sw</span> <span class="n">t</span> <span class="n">geometry</span> <span class="k">in</span>
</span><span class="line">    <span class="k">while</span> <span class="n">geometry</span> <span class="o">=</span> <span class="nn">Window</span><span class="p">.</span><span class="n">geometry</span> <span class="n">t</span><span class="o">.</span><span class="n">window</span> <span class="k">do</span>
</span><span class="line">      <span class="k">let</span> <span class="n">fb</span> <span class="o">=</span> <span class="nn">Vulkan</span><span class="p">.</span><span class="nn">Swap_chain</span><span class="p">.</span><span class="n">get_framebuffer</span> <span class="n">framebuffers</span> <span class="k">in</span>
</span><span class="line">      <span class="k">let</span> <span class="n">redraw_needed</span> <span class="o">=</span> <span class="n">next_as_promise</span> <span class="n">t</span><span class="o">.</span><span class="n">redraw_needed</span> <span class="k">in</span>
</span><span class="line">      <span class="k">let</span> <span class="n">job</span> <span class="o">=</span> <span class="nn">Duo</span><span class="p">.</span><span class="n">get</span> <span class="n">duo</span> <span class="k">in</span>
</span><span class="line">      <span class="n">record_commands</span> <span class="n">t</span> <span class="n">job</span> <span class="n">fb</span><span class="o">;</span>
</span><span class="line">      <span class="nn">Duo</span><span class="p">.</span><span class="n">submit</span> <span class="n">duo</span> <span class="n">fb</span> <span class="n">job</span><span class="o">.</span><span class="n">command_buffer</span><span class="o">;</span>
</span><span class="line">      <span class="nn">Window</span><span class="p">.</span><span class="n">attach</span> <span class="n">t</span><span class="o">.</span><span class="n">window</span> <span class="o">~</span><span class="n">buffer</span><span class="o">:</span><span class="n">fb</span><span class="o">.</span><span class="n">wl_buffer</span><span class="o">;</span>
</span><span class="line">      <span class="nn">Promise</span><span class="p">.</span><span class="n">await</span> <span class="n">redraw_needed</span>
</span><span class="line">    <span class="k">done</span>
</span><span class="line">  <span class="k">done</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>The C code created a fixed set of 4 framebuffers on each resize, but the OCaml only creates them as needed.
When dragging the window to resize that means we may only need to create one at each size,
and when keeping a steady size, it seems I only need 3 framebuffers with Sway.</p>
<p>The main loop changes slightly so that it just triggers the <code>render_loop</code> fiber:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">while</span> <span class="n">render</span><span class="o">.</span><span class="n">frame</span> <span class="o">&lt;</span> <span class="n">frame_limit</span> <span class="k">do</span>
</span><span class="line">  <span class="k">let</span> <span class="n">next_frame_due</span> <span class="o">=</span> <span class="nn">Window</span><span class="p">.</span><span class="n">frame</span> <span class="n">window</span> <span class="k">in</span>
</span><span class="line">  <span class="nn">Render</span><span class="p">.</span><span class="n">trigger_redraw</span> <span class="n">render</span><span class="o">;</span>
</span><span class="line">  <span class="nn">Promise</span><span class="p">.</span><span class="n">await</span> <span class="n">next_frame_due</span><span class="o">;</span>
</span><span class="line">  <span class="n">render</span><span class="o">.</span><span class="n">frame</span> <span class="o">&lt;-</span> <span class="n">render</span><span class="o">.</span><span class="n">frame</span> <span class="o">+</span> <span class="mi">1</span>
</span><span class="line"><span class="k">done</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>I'm not sure if freeing the framebuffers immediately is safe,
since in theory the GPU might still be using them if the display server requests a new frame
at a new size before the previous one has finished rendering on the GPU.
Possibly freed OCaml resources should instead get added to
a list of things to free on the C side the next time the GPU is idle.</p>
<h2>The 3D version</h2>
<p>Although it looks a lot more impressive, the <a href="https://github.com/talex5/vulkan-test/commit/ocaml-3d">3D version</a> isn't that much more work than the 2D triangle.</p>
<p>I used the <a href="https://github.com/Chris00/ocaml-cairo">Cairo</a> library to load the PNG file with the textures
and then added a Vulkan <em>sampler</em> for it.
The shader code has to be modified to read the colour from the texture.
The most complex bit is that the texture needs to be copied
from Cairo's memory to host memory that's visible to the GPU,
and from there to fast local memory on the GPU (see <a href="https://github.com/talex5/vulkan-test/tree/ocaml-3d/src/texture.ml">texture.ml</a>).</p>
<p>Other changes needed:</p>
<ul>
<li>There's a bit of matrix stuff to position the model and project it in 3D.
</li>
<li>I added <a href="https://github.com/talex5/vulkan-test/tree/ocaml-3d/src/obj_format.ml">obj_format.ml</a> to parse the model data.
</li>
<li>The pipeline adds a depth buffer so near things obscure things behind them, regardless of the drawing order.
</li>
</ul>
<p>I didn't get my C version to do the 3D bits, but for comparison here's the Vulkan tutorial's official <a href="https://docs.vulkan.org/tutorial/latest/_attachments/28_model_loading.cpp">C++ version</a>.</p>
<h2>Garbage collection</h2>
<p>To render smoothly at 60Hz, we have about 16ms for each frame.
You might wonder if using a garbage collector would introduce pauses and cause us to miss frames,
but this doesn't seem to be a problem.</p>
<p>In C, you can improve performance for frame-based applications by using a <a href="https://en.wikipedia.org/wiki/Region-based_memory_management">bump allocator</a>:</p>
<ol>
<li>Create a fixed buffer with enough space for every allocation needed for one frame.
</li>
<li>Allocate memory just by allocating sequentially in the region (bumping the next-free-address pointer).
</li>
<li>At the end of each frame, reset the pointer.
</li>
</ol>
<p>This makes allocation really fast and freeing things at the end costs nothing.
Implementing this in C requires special code,
but OCaml works this way by default, allocating new values sequentially onto the <em>minor heap</em>.
At the end of each frame, we can call <code>Gc.minor</code> to reset the heap.</p>
<p><code>Gc.minor</code> scans the stack looking for pointers to values that are still in use
and copies any it finds to the <em>major heap</em>.
However, since we're at the end of the frame, the stack is pretty much empty and there's almost nothing to scan.
I captured a trace of running the 3D room version with a forced minor GC at the end of every frame:</p>
<pre><code>make &amp;&amp; eio-trace run ./_build/default/src/main.exe
</code></pre>
<p><a href="https://roscidus.com/blog/images/vulkan-ocaml/trace-3d.png"><span class="caption-wrapper center"><img src="https://roscidus.com/blog/images/vulkan-ocaml/trace-3d.png" title="Tracing the full 3D version" class="caption"><span class="caption-text">Tracing the full 3D version</span></span></a></p>
<p>The four long grey horizontal bars are the main fibers.
From top to bottom they are:</p>
<ul>
<li>The main application loop (incrementing the frame counter and triggering the render loop fiber).
</li>
<li>An <a href="https://github.com/talex5/ocaml-wayland">ocaml-wayland</a> fiber, receiving messages from the display server
(and spawning some short-lived sending fibers).
</li>
<li>The <code>render_loop</code> fiber (sending graphics commands to the GPU).
</li>
<li>A fiber used internally by the IO system.
</li>
</ul>
<p>The green sections show when each fiber is running and the yellow background indicates when the process is sleeping.
The thin red columns indicate time spent in GC (which we're here triggering after every frame).</p>
<p>If I remove the forced <code>Gc.minor</code> after each frame then the GC happens less often,
but can take a bit longer when it does.
Still not nearly long enough to miss the deadline for rendering the frame though.</p>
<p>Collection of the major heap is done incrementally in small slices and doesn't cause any trouble.</p>
<p>So, we're only using a tiny fraction of the available time.
Also, I suspect the CPU is running in a slow power-saving mode due to all the sleeping;
if we had more work to do then it would probably speed up.</p>
<h2>Conclusions</h2>
<p>Doing Vulkan programming in OCaml has advantages (clearer code, easier refactoring),
but also disadvantages (unfinished and unreleased Vulkan bindings, some friction using a C API from OCaml,
and I had to write more support code, such as some bindings for libdrm).</p>
<p>As a C API, Vulkan is not safe and will happily segfault if passed incorrect arguments.
The OCaml bindings do not fix this, and so care is still needed.
I didn't bother about that because it wasn't a problem in practice,
and properly protecting against use-after-free will probably require some changes to OCaml
(e.g. <a href="https://github.com/ocaml/ocaml/pull/389">unmapping memory</a> isn't safe without something like the "modes" being prototyped in
<a href="https://oxcaml.org/">OxCaml</a>).</p>
<p>I'm slowly upstreaming my changes to Olivine; hopefully this will all be easier to use one day!</p>

