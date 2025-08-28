---
title: Animating 3D models in OCaml with Claude
description: "In the week, Jon mentioned UTM, which uses Apple\u2019s Hypervisor virtualisation
  framework to run ARM64 operating systems on Apple Silicon. It looked awesome, and
  the speed of virtualised macOS was fantastic. It also offers x86_64 emulation; we
  mused how well it would perform running Windows, but found it disappointing."
url: https://www.tunbury.org/2025/06/07/claude-animates-in-ocaml/
date: 2025-06-07T00:00:00-00:00
preview_image: https://www.tunbury.org/images/human.png
authors:
- Mark Elvers
source:
ignore:
---

<p>In the week, Jon mentioned <a href="https://mac.getutm.app">UTM</a>, which uses Apple’s Hypervisor virtualisation framework to run ARM64 operating systems on Apple Silicon. It looked awesome, and the speed of virtualised macOS was fantastic. It also offers x86_64 emulation; we mused how well it would perform running Windows, but found it disappointing.</p>

<p>I was particularly interested in this because I am stuck in the past with macOS Monterey on my Intel Mac Pro ‘trashcan’, as I have a niche Windows application that I can’t live without. A few years ago, I got a prototype running written in Swift. I never finished it as other events got in the way. The learning curve of <a href="https://youtu.be/8Jb3v2HRv_E">SceneKit and Blender</a> was intense. I still had the Collada files on my machine and today, of course, we have Claude.</p>

<p>“How would I animate a Collada (.dae) file using OCaml?”. Claude acknowledged the complexity and proposed that <code class="language-plaintext highlighter-rouge">lablgl</code>, the OCaml bindings for OpenGL, would be a good starting point. Claude obliged and wrote the entire pipeline, giving me opam commands and Dune configuration files.</p>

<p>The code wouldn’t build, so I looked for the API for <code class="language-plaintext highlighter-rouge">labgl</code>. The library seemed old, with no recent activity. I mentioned this to Claude; he was happy to suggest an alternative approach of <code class="language-plaintext highlighter-rouge">tgls</code>, thin OpenGL bindings, with <code class="language-plaintext highlighter-rouge">tsdl</code>, SDL2 bindings, or the higher-level API from <code class="language-plaintext highlighter-rouge">raylib</code>. The idea of a high-level API sounded better, so I asked Claude to rewrite it with <code class="language-plaintext highlighter-rouge">raylib</code>.</p>

<p>The code had some compilation issues. Claude had proposed <code class="language-plaintext highlighter-rouge">Mesh.gen_cube</code>, which didn’t exist. Claude consulted the API documentation and found <code class="language-plaintext highlighter-rouge">gen_mesh_cube</code> instead. This went through several iterations, with <code class="language-plaintext highlighter-rouge">Model.load</code> becoming <code class="language-plaintext highlighter-rouge">load_model</code> and <code class="language-plaintext highlighter-rouge">Model.draw_ex</code> becoming <code class="language-plaintext highlighter-rouge">draw_model_ex</code>, etc. Twenty-two versions later, the code nearly compiles. This block continued to fail with two issues. The first being <code class="language-plaintext highlighter-rouge">Array.find</code> doesn’t exist and the second being that the type inferred for <code class="language-plaintext highlighter-rouge">a</code> was wrong. There are two types and they both contain <code class="language-plaintext highlighter-rouge">target: string;</code>. I manually fixed this with <code class="language-plaintext highlighter-rouge">(a:animation_channel)</code> and used <code class="language-plaintext highlighter-rouge">match Array.find_opt ... with</code> instead of the <code class="language-plaintext highlighter-rouge">try ... with</code>.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c">(* Update animations *)</span>
<span class="k">let</span> <span class="n">update_object_animations</span> <span class="n">objects</span> <span class="n">animations</span> <span class="n">elapsed_time</span> <span class="o">=</span>
  <span class="nn">Array</span><span class="p">.</span><span class="n">map</span> <span class="p">(</span><span class="k">fun</span> <span class="n">obj</span> <span class="o">-&gt;</span>
    <span class="k">try</span>
      <span class="k">let</span> <span class="n">anim</span> <span class="o">=</span> <span class="nn">Array</span><span class="p">.</span><span class="n">find</span> <span class="p">(</span><span class="k">fun</span> <span class="n">a</span> <span class="o">-&gt;</span> <span class="n">a</span><span class="o">.</span><span class="n">target</span> <span class="o">=</span> <span class="n">obj</span><span class="o">.</span><span class="n">name</span><span class="p">)</span> <span class="n">animations</span> <span class="k">in</span>
      <span class="c">(* Loop animation *)</span>
      <span class="k">let</span> <span class="n">loop_time</span> <span class="o">=</span> <span class="n">mod_float</span> <span class="n">elapsed_time</span> <span class="n">anim</span><span class="o">.</span><span class="n">duration</span> <span class="k">in</span>
      <span class="k">let</span> <span class="n">new_transform</span> <span class="o">=</span> <span class="n">interpolate_animation</span> <span class="n">anim</span> <span class="n">loop_time</span> <span class="k">in</span>
      <span class="p">{</span> <span class="n">obj</span> <span class="k">with</span> <span class="n">current_transform</span> <span class="o">=</span> <span class="n">new_transform</span> <span class="p">}</span>
    <span class="k">with</span>
      <span class="nc">Not_found</span> <span class="o">-&gt;</span> <span class="n">obj</span>
  <span class="p">)</span> <span class="n">objects</span>
</code></pre></div></div>

<p>There were still many unused variables, but the code could be built using <code class="language-plaintext highlighter-rouge">dune build --release</code>.</p>

<p>Unfortunately, it couldn’t load my Collada file as the load functions were just stubs! Claude duly obliged and wrote a simple XML parser using regular expressions through the <code class="language-plaintext highlighter-rouge">Str</code> library, but interestingly suggested that I include <code class="language-plaintext highlighter-rouge">xmlm</code> as a dependency. Adding the parser broke the code, and it no longer compiled. The issue was similar to above; the compiler had inferred a type that wasn’t what Claude expected. I fixed this as above. The code also had some issues with the ordering - functions were used before they were defined. Again, this was an easy fix.</p>

<p>The parser still didn’t work, so I suggested ditching the regular expression-based approach and using <code class="language-plaintext highlighter-rouge">xmlm</code> instead. This loaded the mesh; it looked bad, but I could see that it was my mesh. However, it still didn’t animate, and I took a wrong turn here. I told Claude that the Collada file contained both the mesh and the animation, but that’s not right. It has been a while since I created the Collada files, and I had forgotten that the animation and the mesh definitions were in different files.</p>

<p>I asked Claude to improve the parser so that it would expect the animation data to be in the same file as the mesh. This is within the specification for Collada, but this was not the structure of my file.</p>

<p>Is there a better approach than dealing with the complexity of writing a Collada XML parser? What formats are supported by <code class="language-plaintext highlighter-rouge">raylib</code>?</p>

<p>In a new thread, I asked, “Using OCaml with Raylib, what format should I use for my 3D mode and animation data?”. Claude suggested GLTF 2.0. As my animation is in Blender, it can be exported in GLTF format. Let’s try it!</p>

<p>Claude used the <code class="language-plaintext highlighter-rouge">raylib</code> library to read and display a GLTF file and run the animation. The code was much shorter, but … it didn’t compile. I wrote to Claude, “The API for Raylib appears to be different to the one you have used. For example, <code class="language-plaintext highlighter-rouge">camera3d.create</code> doesn’t take named parameters, <code class="language-plaintext highlighter-rouge">camera3d.prespective</code> should be <code class="language-plaintext highlighter-rouge">cameraprojection.perspective</code> etc.”  We set to work, and a dozen versions later, we built it successfully.</p>

<p>It didn’t work, though; the console produced an error over and over:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>Joint attribute data format not supported, use vec4 u8
</code></pre></div></div>

<p>This looked like a problem with the model. I wondered if my GLTF file was compatible with <code class="language-plaintext highlighter-rouge">raylib</code>. I asked Claude if he knew of any validation tools, and he suggested an online viewer. This loaded my file perfectly and animated it in the browser. Claude also gave me some simple code to validate, which only loaded the model.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">main</span> <span class="bp">()</span> <span class="o">=</span>
  <span class="n">init_window</span> <span class="mi">800</span> <span class="mi">600</span> <span class="s2">"Static Model Test"</span><span class="p">;</span>
  <span class="k">let</span> <span class="n">camera</span> <span class="o">=</span> <span class="nn">Camera3D</span><span class="p">.</span><span class="n">create</span>
    <span class="p">(</span><span class="nn">Vector3</span><span class="p">.</span><span class="n">create</span> <span class="mi">25</span><span class="o">.</span><span class="mi">0</span> <span class="mi">25</span><span class="o">.</span><span class="mi">0</span> <span class="mi">25</span><span class="o">.</span><span class="mi">0</span><span class="p">)</span>
    <span class="p">(</span><span class="nn">Vector3</span><span class="p">.</span><span class="n">create</span> <span class="mi">0</span><span class="o">.</span><span class="mi">0</span> <span class="mi">0</span><span class="o">.</span><span class="mi">0</span> <span class="mi">0</span><span class="o">.</span><span class="mi">0</span><span class="p">)</span>
    <span class="p">(</span><span class="nn">Vector3</span><span class="p">.</span><span class="n">create</span> <span class="mi">0</span><span class="o">.</span><span class="mi">0</span> <span class="mi">1</span><span class="o">.</span><span class="mi">0</span> <span class="mi">0</span><span class="o">.</span><span class="mi">0</span><span class="p">)</span>
    <span class="mi">45</span><span class="o">.</span><span class="mi">0</span> <span class="nn">CameraProjection</span><span class="p">.</span><span class="nc">Perspective</span> <span class="k">in</span>

  <span class="k">let</span> <span class="n">model</span> <span class="o">=</span> <span class="n">load_model</span> <span class="s2">"assets/character.gltf"</span> <span class="k">in</span>

  <span class="k">while</span> <span class="n">not</span> <span class="p">(</span><span class="n">window_should_close</span> <span class="bp">()</span><span class="p">)</span> <span class="k">do</span>
    <span class="n">begin_drawing</span> <span class="bp">()</span><span class="p">;</span>
    <span class="n">clear_background</span> <span class="nn">Color</span><span class="p">.</span><span class="n">darkgray</span><span class="p">;</span>
    <span class="n">begin_mode_3d</span> <span class="n">camera</span><span class="p">;</span>
    <span class="n">draw_model</span> <span class="n">model</span> <span class="p">(</span><span class="nn">Vector3</span><span class="p">.</span><span class="n">create</span> <span class="mi">0</span><span class="o">.</span><span class="mi">0</span> <span class="mi">0</span><span class="o">.</span><span class="mi">0</span> <span class="mi">0</span><span class="o">.</span><span class="mi">0</span><span class="p">)</span> <span class="mi">1</span><span class="o">.</span><span class="mi">0</span> <span class="nn">Color</span><span class="p">.</span><span class="n">white</span><span class="p">;</span>
    <span class="n">draw_grid</span> <span class="mi">10</span> <span class="mi">1</span><span class="o">.</span><span class="mi">0</span><span class="p">;</span>
    <span class="n">end_mode_3d</span> <span class="bp">()</span><span class="p">;</span>
    <span class="n">draw_text</span> <span class="s2">"Static Model Test"</span> <span class="mi">10</span> <span class="mi">10</span> <span class="mi">20</span> <span class="nn">Color</span><span class="p">.</span><span class="n">white</span><span class="p">;</span>
    <span class="n">end_drawing</span> <span class="bp">()</span>
  <span class="k">done</span><span class="p">;</span>

  <span class="n">unload_model</span> <span class="n">model</span><span class="p">;</span>
  <span class="n">close_window</span> <span class="bp">()</span>
</code></pre></div></div>

<p>Even this didn’t work! As I said at the top, it’s been a few years since I looked at this, and I still had Blender installed on my machine: version 2.83.4. The current version is 4.4, so I decided to upgrade. The GLTF export in 4.4 didn’t work on my Mac and instead displayed a page of Python warnings about <code class="language-plaintext highlighter-rouge">numpy</code>. On the Blender Forum, this <a href="https://blenderartists.org/t/multiple-addons-giving-numpy-errors-blender-4-4-mac/1590436/2">thread</a> showed me how to fix it. Armed with a new GLTF file, the static test worked. Returning to the animation code showed that it worked with the updated file; however, there are some significant visual distortions. These aren’t present when viewed in Blender, which I think comes down to how the library interpolates between keyframes. I will look into this another day.</p>

<p>I enjoyed the collaborative approach. I’m annoyed with myself for not remembering the separate file with the animation data. However, I think the change of direction from Collada to GLTF was a good decision, and the speed at which Claude can explore ideas is very impressive.</p>
