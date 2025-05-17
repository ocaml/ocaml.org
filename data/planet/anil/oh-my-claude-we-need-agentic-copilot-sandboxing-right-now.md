---
title: Oh my Claude, we need agentic copilot sandboxing right now
description: Claude Code auto-generates OCaml bindings, but lacks robust sandboxing.
url: https://anil.recoil.org/notes/claude-copilot-sandbox
date: 2025-03-02T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p><a href="https://github.com/yminsky" class="contact">Yaron Minsky</a> nerdsniped me last week into getting OCaml to drive the 80s-retro <a href="https://www.adafruit.com/product/2345">RGB Matrix</a> displays. I grabbed one from the local Pi Store and soldered it together with help from <a href="https://mynameismwd.org" class="contact">Michael Dales</a>. But instead of writing OCaml bindings by hand, we thought we'd try out the latest agentic CLI called <a href="https://github.com/kodu-ai/claude-code">Claude Code</a> released <a href="https://ai-claude.net/">last week</a> to see if we could entirely autogenerate the bindings.</p>
<p></p><div class="video-center"><iframe title="" width="100%" height="315px" src="https://crank.recoil.org/videos/embed/59cb8699-9cb0-46d0-a9d9-a82338fd7452" frameborder="0" allowfullscreen="" sandbox="allow-same-origin allow-scripts allow-popups allow-forms"></iframe></div><p></p>
<p><em>TL;DR:</em> Claude Coder generated working OCaml code almost from scratch, ranging from C bindings to high-level OCaml interface files and even Cmdliner terms, but needs a more sophisticated sandboxing model before something goes horribly wrong. So much potential and so much danger awaits us. Coincidentally <a href="https://web.eecs.umich.edu/~comar/" class="contact">Cyrus Omar</a> and <a href="https://patrick.sirref.org" class="contact">Patrick Ferris</a> and I <a href="https://anil.recoil.org/papers/2024-hope-bastion">wrote</a> about this a few months ago. Read on...</p>
<h2>Wiring up the display to my Raspberry Pi</h2>
<p>The RGB Matrix display has a very nice C++ <a href="https://github.com/hzeller/rpi-rgb-led-matrix">rpi-rgb-led-matrix</a> library, so I fired up my Raspberry Pi 4 to get an OCaml development environment going by using that. The included <a href="https://github.com/hzeller/rpi-rgb-led-matrix/tree/master/examples-api-use">demo</a> immediately gave me a disappointingly noisy display, but my larger-than-usual 64x64 display turned out to just need a jumper soldered.</p>
<p></p><figure class="image-center"><img src="https://anil.recoil.org/images/rgb-matrix-hat-ocaml-2.webp" loading="lazy" class="content-image" alt="Deploying my local friendly agentic soldering machine otherwise known as Michael Dales" srcset="/images/rgb-matrix-hat-ocaml-2.1024.webp 1024w,/images/rgb-matrix-hat-ocaml-2.1280.webp 1280w,/images/rgb-matrix-hat-ocaml-2.1440.webp 1440w,/images/rgb-matrix-hat-ocaml-2.1600.webp 1600w,/images/rgb-matrix-hat-ocaml-2.1920.webp 1920w,/images/rgb-matrix-hat-ocaml-2.2560.webp 2560w,/images/rgb-matrix-hat-ocaml-2.320.webp 320w,/images/rgb-matrix-hat-ocaml-2.3840.webp 3840w,/images/rgb-matrix-hat-ocaml-2.480.webp 480w,/images/rgb-matrix-hat-ocaml-2.640.webp 640w,/images/rgb-matrix-hat-ocaml-2.768.webp 768w" title="Deploying my local friendly agentic soldering machine otherwise known as Michael Dales" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>Deploying my local friendly agentic soldering machine otherwise known as Michael Dales</figcaption></figure>
<p></p>
<p>As soon that was soldered, the examples worked great out of the box, so I could get on with some agentic OCaml coding. Thanks <a href="https://mynameismwd.org" class="contact">Michael Dales</a> and <a href="https://web.makespace.org/">CamMakespace</a>!</p>
<h2>Building OCaml bindings using Claude Coder</h2>
<p><a href="https://github.com/yminsky" class="contact">Yaron Minsky</a> and I first played around with using <a href="https://dev.realworldocaml.org/foreign-function-interface.html">ocaml-ctypes</a> to build the bindings by hand, but quickly switched over to trying out Claude Sonnet 3.7, first in VSCode and then directly on the Pi CLI via <a href="https://github.com/anthropics/claude-code">Claude Code</a>. The latter fires up an interactive session where you not only input prompts, but it can also <em>run shell commands</em> including builds.</p>
<p>The very first hurdle was sorting out the build rules. This is the one place where Claude failed badly; it couldn't figure out <a href="https://dune.readthedocs.io/en/latest/quick-start.html">dune files</a> at all, nor the intricate linking flags required to find and link to the C++ library. I made those changes quickly by hand, leaving just a stub <code>librgbmatrix_stubs.c</code> that linked successfully with the main C++ library, but didn't do much beyond that.  I also added a near-empty <code>rgb_matrix.ml</code> and <code>rgb_matrix.mli</code> interface files to have a place for the OCaml side of the interface.</p>
<p></p><figure class="image-center"><img src="https://anil.recoil.org/images/claude-coder-ss-1.webp" loading="lazy" class="content-image" alt="The Claude Code CLI runs fine on the Raspberry Pi 4, since most of the heavy computation is done on their end." srcset="/images/claude-coder-ss-1.1024.webp 1024w,/images/claude-coder-ss-1.1280.webp 1280w,/images/claude-coder-ss-1.1440.webp 1440w,/images/claude-coder-ss-1.1600.webp 1600w,/images/claude-coder-ss-1.1920.webp 1920w,/images/claude-coder-ss-1.320.webp 320w,/images/claude-coder-ss-1.480.webp 480w,/images/claude-coder-ss-1.640.webp 640w,/images/claude-coder-ss-1.768.webp 768w" title="The Claude Code CLI runs fine on the Raspberry Pi 4, since most of the heavy computation is done on their end." sizes="(max-width: 768px) 100vw, 33vw"><figcaption>The Claude Code CLI runs fine on the Raspberry Pi 4, since most of the heavy computation is done on their end.</figcaption></figure>
<p></p>
<p>After that, it was just a matter of "asking the Claude Code CLI" via a series of prompts to get it to fill in the code blanks I'd left. The VSCode Copilot editing mode has to be told which files to look at within the project for its context, but I didn't have to do that with the Claude Code CLI.</p>
<p>Instead, I just prompted it to generate C stubs from the <a href="https://github.com/hzeller/rpi-rgb-led-matrix/blob/master/include/led-matrix-c.h">led-matrix-c.h</a> C interface (so it didn't get distracted attempting to bind C++ to OCaml, which isn't a winning proposition). It duly generated reasonable low-level bindings, along with the right OCaml interface files by suggesting edits to the files I'd created earlier.  At this point, I got a very basic "hello world" circle going (with the test binary also built by Claude).</p>
<p></p><figure class="image-center"><img src="https://anil.recoil.org/images/rgb-matrix-hat-ocaml-3.webp" loading="lazy" class="content-image" alt="The OCaml bindings and concentric circles were all auto-generated by Claude Sonnet 3.7" srcset="/images/rgb-matrix-hat-ocaml-3.1024.webp 1024w,/images/rgb-matrix-hat-ocaml-3.1280.webp 1280w,/images/rgb-matrix-hat-ocaml-3.1440.webp 1440w,/images/rgb-matrix-hat-ocaml-3.1600.webp 1600w,/images/rgb-matrix-hat-ocaml-3.1920.webp 1920w,/images/rgb-matrix-hat-ocaml-3.2560.webp 2560w,/images/rgb-matrix-hat-ocaml-3.320.webp 320w,/images/rgb-matrix-hat-ocaml-3.3840.webp 3840w,/images/rgb-matrix-hat-ocaml-3.480.webp 480w,/images/rgb-matrix-hat-ocaml-3.640.webp 640w,/images/rgb-matrix-hat-ocaml-3.768.webp 768w" title="The OCaml bindings and concentric circles were all auto-generated by Claude Sonnet 3.7" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>The OCaml bindings and concentric circles were all auto-generated by Claude Sonnet 3.7</figcaption></figure>
<p></p>
<p>Although the binding generation built fine, they did segfault when I first ran the test binary!  Claude 3.7 bound some C/OCaml functions with more than 5 arguments, which are a special case in OCaml due to <a href="https://ocaml.org/manual/5.3/intfc.html#ss:c-prim-impl">differing bytecode and native code ABIs</a>.  Although Claude <em>almost</em> got it right, it subtly mixed up the order of the <code>external</code> binding on the OCaml side. The correct version is:</p>
<pre><code>external set_pixels_native :
  t -&gt; int -&gt; int -&gt; int -&gt; int -&gt; Color.t array -&gt; unit =
  "caml_led_canvas_set_pixels_bytecode" "caml_led_canvas_set_pixels"
</code></pre>
<p>The bytecode C stub comes first, and the native code second, but Claude swapped them which lead to memory corruption. This mixup would ordinarily be rather hard to spot, but the <a href="https://valgrind.org/">valgrind</a> backtrace lead me to the problem very quickly (but only because I'm very familiar with the OCaml FFI!).  I couldn't convince Claude to fix this with prompting as it kept making the same mistake, so I swapped the arguments manually and committed the results by hand.</p>
<h2>Generating higher level OCaml interfaces and docstrings</h2>
<p>Once the basics were in place, I then asked it to then refine the OCaml interface to be higher-level; for example instead of a <code>string</code> for the hardware mode, could it scan the C header file, find the appropriate <code>#defines</code>, and generate corresponding OCaml <a href="https://dev.realworldocaml.org/variants.html">variant types</a>? Incredibly, it not only did this, but <em>also</em> generated appropriate OCamldoc annotations for those types from the C header files.</p>
<p></p><figure class="image-center"><img src="https://anil.recoil.org/images/claude-coder-ss-2.webp" loading="lazy" class="content-image" alt="These OCamldoc entries are generated automatically from the C header files" srcset="/images/claude-coder-ss-2.1024.webp 1024w,/images/claude-coder-ss-2.1280.webp 1280w,/images/claude-coder-ss-2.1440.webp 1440w,/images/claude-coder-ss-2.1600.webp 1600w,/images/claude-coder-ss-2.1920.webp 1920w,/images/claude-coder-ss-2.320.webp 320w,/images/claude-coder-ss-2.480.webp 480w,/images/claude-coder-ss-2.640.webp 640w,/images/claude-coder-ss-2.768.webp 768w" title="These OCamldoc entries are generated automatically from the C header files" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>These OCamldoc entries are generated automatically from the C header files</figcaption></figure>
<p></p>
<p>The Claude Code CLI then helpfully summarises all the changes, and also offers execute dune to check the result works! This is starting to get a bit mad...</p>
<p></p><figure class="image-center"><img src="https://anil.recoil.org/images/claude-coder-ss-3.webp" loading="lazy" class="content-image" alt="Claude offers to do the dune build after making code changes" srcset="/images/claude-coder-ss-3.1024.webp 1024w,/images/claude-coder-ss-3.1280.webp 1280w,/images/claude-coder-ss-3.1440.webp 1440w,/images/claude-coder-ss-3.1600.webp 1600w,/images/claude-coder-ss-3.1920.webp 1920w,/images/claude-coder-ss-3.320.webp 320w,/images/claude-coder-ss-3.480.webp 480w,/images/claude-coder-ss-3.640.webp 640w,/images/claude-coder-ss-3.768.webp 768w" title="Claude offers to do the dune build after making code changes" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>Claude offers to do the dune build after making code changes</figcaption></figure>
<p></p>
<p></p><figure class="image-center"><img src="https://anil.recoil.org/images/claude-coder-ss-4.webp" loading="lazy" class="content-image" alt="It can also navigate the output of commands to see if the desired outcome is successful" srcset="/images/claude-coder-ss-4.1024.webp 1024w,/images/claude-coder-ss-4.1280.webp 1280w,/images/claude-coder-ss-4.1440.webp 1440w,/images/claude-coder-ss-4.1600.webp 1600w,/images/claude-coder-ss-4.1920.webp 1920w,/images/claude-coder-ss-4.320.webp 320w,/images/claude-coder-ss-4.480.webp 480w,/images/claude-coder-ss-4.640.webp 640w,/images/claude-coder-ss-4.768.webp 768w" title="It can also navigate the output of commands to see if the desired outcome is successful" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>It can also navigate the output of commands to see if the desired outcome is successful</figcaption></figure>
<p></p>
<p></p><figure class="image-center"><img src="https://anil.recoil.org/images/claude-coder-ss-5.webp" loading="lazy" class="content-image" alt="The patches to the interface and implementation added in more abstract types as requested" srcset="/images/claude-coder-ss-5.1024.webp 1024w,/images/claude-coder-ss-5.1280.webp 1280w,/images/claude-coder-ss-5.1440.webp 1440w,/images/claude-coder-ss-5.1600.webp 1600w,/images/claude-coder-ss-5.1920.webp 1920w,/images/claude-coder-ss-5.320.webp 320w,/images/claude-coder-ss-5.480.webp 480w,/images/claude-coder-ss-5.640.webp 640w,/images/claude-coder-ss-5.768.webp 768w" title="The patches to the interface and implementation added in more abstract types as requested" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>The patches to the interface and implementation added in more abstract types as requested</figcaption></figure>
<p></p>
<p>The OCaml interfaces generated here required a little iteration to get right, with some manual tweaks. Claude, for some reason, generated duplicate entries for some type definitions, which OCaml doesn't permit. I fixed those manually very quickly, and then asked Claude Code to commit the changes to git for me. It generated a <a href="https://github.com/yminsky/rpi-rgb-led-matrix/pull/3/commits/70c7739696ca207245dfdbc80c5d6d08fe2fce79">good summary commit message</a>. The interfaces were all documented with docs from the C header file, such as:</p>
<pre><code>type multiplexing =
  | DirectMultiplexing (* 0: Direct multiplexing *)
  | Stripe             (* 1: Stripe multiplexing *)
  | Checker            (* 2: Checker multiplexing (typical for 1:8) *)
  | Spiral             (* 3: Spiral multiplexing *)
  | ZStripe            (* 4: Z-Stripe multiplexing *)
  | ZnMirrorZStripe    (* 5: ZnMirrorZStripe multiplexing *)
  | Coreman            (* 6: Coreman multiplexing *)
  | Kaler2Scan         (* 7: Kaler2Scan multiplexing *)
  | ZStripeUneven      (* 8: ZStripeUneven multiplexing *)
  | P10MapperZ         (* 9: P10MapperZ multiplexing *)
  | QiangLiQ8          (* 10: QiangLiQ8 multiplexing *)
  | InversedZStripe    (* 11: InversedZStripe multiplexing *)
  | P10Outdoor1R1G1_1  (* 12: P10Outdoor1R1G1_1 multiplexing *)
  | P10Outdoor1R1G1_2  (* 13: P10Outdoor1R1G1_2 multiplexing *)
                       (* ...etc &lt;snipped&gt; *)
  | Custom of int      (* Custom multiplexing as an integer *)
</code></pre>
<p>Pretty good! After that, I couldn't resist pushing it a bit further. I asked the CLI to generate me a good command-line interface using <a href="https://github.com/dbuenzli/cmdliner">Cmdliner</a>, which is normally a fairly intricate process that involves remembering the <a href="https://erratique.ch/software/cmdliner/doc/Cmdliner/Term/index.html">Term/Arg DSL</a>. But Claude aced this; it generated a huge series of CLI converter functions like this:</p>
<pre><code>(* scan_mode conversion *)
  let scan_mode_conv =
    let parse s =
      match String.lowercase_ascii s with
      | "progressive" -&gt; Ok Progressive
      | "interlaced" -&gt; Ok Interlaced
      | _ -&gt; Error (`Msg "scan_mode must be 'progressive' or 'interlaced'")
    in
    let print fmt m =
      Format.fprintf fmt "%s"
        (match m with
         | Progressive -&gt; "progressive"
         | Interlaced -&gt; "interlaced")
    in
    Arg.conv (parse, print)
</code></pre>
<p>These are not entirely what I'd write, as <a href="https://erratique.ch/software/cmdliner/doc/Cmdliner/Arg/index.html#val-enum">Cmdliner.Arg.enum</a> would suffice, but they're fine as-is and could be refactored later. I even got it to complete the job and generate a combined options parsing function for the (dozens) of command-line arguments, which would have been <em>very</em> tedious to do by hand:</p>
<pre><code>(* Apply options from command line to Options.t *)
let apply_options options
    ~rows ~cols ~chain_length ~parallel ~hardware_mapping ~brightness 
    ~pwm_bits ~pwm_lsb_nanoseconds ~pwm_dither_bits ~scan_mode ~row_address_type 
    ~multiplexing ~disable_hardware_pulsing ~show_refresh_rate ~inverse_colors
    ~led_rgb_sequence ~pixel_mapper_config ~panel_type ~limit_refresh_rate_hz 
    ~disable_busy_waiting =
  Options.set_rows options rows;
  Options.set_cols options cols;
  Options.set_chain_length options chain_length;
  Options.set_parallel options parallel;
  Options.set_hardware_mapping options hardware_mapping;
  Options.set_brightness options brightness;
  Options.set_pwm_bits options pwm_bits;
  Options.set_pwm_dither_bits options pwm_dither_bits;
  Options.set_scan_mode options scan_mode;
  Options.set_pixel_mapper_config options pixel_mapper_config;
  Options.set_panel_type options panel_type;
  Options.set_limit_refresh_rate_hz options limit_refresh_rate_hz;
  Options.set_disable_busy_waiting options disable_busy_waiting;
  (* ...etc &lt;snipped&gt; *)
  options
</code></pre>
<p>Once this compiled, I asked for a rotating 3D cube demo, and it duly used the bindings to give me a full command-line enabled generator which you can see below. I just ran:</p>
<pre><code>rotating_block_generator.exe --disable-hardware-pulsing -c 64 -r 64 --hardware-mapping=adafruit-hat  --gpio-slowdown=2
</code></pre>
<p>and I had a spinning cube on my display! The code model had no problem with the matrix transformations required to render the cool spinning effect.</p>
<p></p><div class="video-center"><iframe title="" width="100%" height="315px" src="https://crank.recoil.org/videos/embed/59cb8699-9cb0-46d0-a9d9-a82338fd7452" frameborder="0" allowfullscreen="" sandbox="allow-same-origin allow-scripts allow-popups allow-forms"></iframe></div><p></p>
<p>Of course, I had to pay the piper for the truckload of GPUs that drove this code model. At one point, the Claude Code agent got into a loop that I had to manually interrupt as it kept oscillating on a code fix without ever finding the right solution. This turned out to have sucked up quite a lot of money from my Claude API account!</p>
<p></p><figure class="image-center"><img src="https://anil.recoil.org/images/claude-coder-ss-6.webp" loading="lazy" class="content-image" alt="This post cost me a cup of coffee and a boatload of energy" srcset="/images/claude-coder-ss-6.1024.webp 1024w,/images/claude-coder-ss-6.1280.webp 1280w,/images/claude-coder-ss-6.1440.webp 1440w,/images/claude-coder-ss-6.1600.webp 1600w,/images/claude-coder-ss-6.1920.webp 1920w,/images/claude-coder-ss-6.320.webp 320w,/images/claude-coder-ss-6.480.webp 480w,/images/claude-coder-ss-6.640.webp 640w,/images/claude-coder-ss-6.768.webp 768w" title="This post cost me a cup of coffee and a boatload of energy" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>This post cost me a cup of coffee and a boatload of energy</figcaption></figure>
<p></p>
<p>Overall, I'm impressed. There's clearly some <a href="https://arxiv.org/abs/2502.18449">RL or SFT</a> required to teach the code model the specifics of OCaml and its tooling, but the basics are already incredible. <a href="https://toao.com" class="contact">Sadiq Jaffer</a>, <a href="https://github.com/jonludlam" class="contact">Jon Ludlam</a> and I are having a go at this in the coming months.</p>
<h2>Claude Code is powerful, but it can do...anything...to your machine</h2>
<p>The obvious downside of this whirlwind binding exercise is that while the NPM-based Claude Code asks nicely before it runs shell commands, <em>it doesn't have to ask</em>. I happened to run it inside a well-sandboxed <a href="https://docker.com">Docker</a> container on my rPi, but most people probably won't. And in general, we need a more sophisticated security model; running the agent within a coarse sandbox that limits access to the file system, the network, and other sensitive resources is too restrictive, as we want to provide access to these resources for certain agentic tasks!</p>
<p>So in a happy coincidence, this leads to a line of research that <a href="https://web.eecs.umich.edu/~comar/" class="contact">Cyrus Omar</a> and <a href="https://patrick.sirref.org" class="contact">Patrick Ferris</a> started last year with something we <a href="https://anil.recoil.org/news/2024-hope-bastion-1">presented at HOPE 2024</a>. We explored how to express more precise constraints on what an AI can do by the use of the scary-sounding <a href="https://anil.recoil.org/papers/2024-hope-bastion.pdf">Dijkstra monad</a>.  It's far easier to understand by perusing the <a href="https://anil.recoil.org/slides/2024-hope-bastion-slides.pdf">slides</a> of the talk, or watch <a href="https://web.eecs.umich.edu/~comar/" class="contact">Cyrus Omar</a>'s great <a href="https://www.youtube.com/watch?v=U9H9xU-8-qc&amp;list=PLyrlk8Xaylp7OQNLeCGS0j2fjEnvIWL9u">video presentation</a>.</p>
<p>We're mainly concerned with situations where the AI models are running over sensitive codebases or datasets. Consider three scenarios we want to handle, which are very logical extensions from the above agentic coding one:</p>
<ol>
<li>Modify or ignore sensor data to minimize the extent of habitat loss in a <a href="https://anil.recoil.org/papers/2024-terracorder">biodiversity monitoring</a> setup. <em>But we may want to be able to delete duplicate sensor data in some phases of the analysis.</em></li>
<li>Leak location sightings of vulnerable species to poachers. <em>But we still want to be able to work with this data to design effective interventions — we want a sandbox that limits information flows, in a statistical sense (differential privacy).</em></li>
<li>Enact an intervention that may not satisfy legal constraints. <em>We want a sandbox that requires that a sound causal argument has been formulated</em></li>
</ol>
<p>For each of these, we could use a <a href="https://en.wikipedia.org/wiki/Capability-based_security">capability security</a> model where access to sensitive data and effects can occur only via unforgeable capabilities granted explicitly. And the generation of that specification could also be done via code LLMs, but needs to target a verification friendly language like <a href="https://fstar-lang.com">Fstar</a>. The prototype <a href="https://patrick.sirref.org" class="contact">Patrick Ferris</a> built looks like this:</p>
<pre><code>module type CapDataAccess (readonly : list dir, writable : list dir)
  (* abstract monad *)
  type Cmd a
  val return : a -&gt; Cmd a
  val bind : Cmd a -&gt; ( a -&gt; Cmd b ) -&gt; Cmd b
  (* only allows access to given directories *)
  val readfile : path -&gt; Cmd string
  (* only allows writes to writable dirs *)
  val writefile : path -&gt; string -&gt; Cmd ()
</code></pre>
<p>And then you can use this rich specification to add constraints, for example see this <a href="https://github.com/patricoferris/hope-2024/tree/main/simple-json">JSON parsing example</a> from the Fstar prototype:</p>
<pre><code>(* Following IUCN's Globally Endangered (GE) scoring *)
let datamap = [
"iberian-lynx.geojson", O [ "rarity", Int 2 ];
"bornean-elephant.geojson", O [ "rarity", Int 3 ]
]

(* We add some additional predicates on the files allowed to be used *)
@|-1,9 +1,10 ==========================================
| (ensures (fun _ -&gt; True))
| (requires (fun _ _ local_trace -&gt;
| dont_delete_any_file local_trace /\
+| all_paths_are_not_endangered readonly /\
| only_open_some_files local_trace readonly))
|}
</code></pre>
<p>Once you have this specification, then it's a matter of implementing fine-grained OS-level sandboxing policies to interpret and enforce them. Spoiler: we're working on such a system, so I'll write about that just as soon as it's more self-hosting; this area is moving incredibly fast.</p>
<small class="credits">
<p>Thanks to <a href="https://mynameismwd.org" class="contact">Michael Dales</a> for help soldering. For the curious, here's the <a href="https://github.com/yminsky/rpi-rgb-led-matrix/pull/3">PR with the code</a>, but it shouldn't go anywhere near any real use until we've had a chance to review the bindings carefully. There needs to be a new, even more buyer-beware no-warranty license for AI generated code!</p>
</small>

