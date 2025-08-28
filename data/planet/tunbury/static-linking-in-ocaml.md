---
title: Static linking in OCaml
description: "Most of the time, you don\u2019t think about how your file is linked.
  We\u2019ve come to love dynamically linked files with their small file sizes and
  reduced memory requirements, but there are times when the convenience of a single
  binary download from a GitHub release page is really what you need."
url: https://www.tunbury.org/2025/06/17/static-linking/
date: 2025-06-17T00:00:00-00:00
preview_image: https://www.tunbury.org/images/ocaml-logo.png
authors:
- Mark Elvers
source:
ignore:
---

<p>Most of the time, you don’t think about how your file is linked. We’ve come to love dynamically linked files with their small file sizes and reduced memory requirements, but there are times when the convenience of a single binary download from a GitHub release page is really what you need.</p>

<p>To do this in OCaml, we need to add <code class="language-plaintext highlighter-rouge">-ccopt -static</code> to the <code class="language-plaintext highlighter-rouge">ocamlopt</code>. I’m building with <code class="language-plaintext highlighter-rouge">dune</code>, so I can configure that in my <code class="language-plaintext highlighter-rouge">dune</code> file using a <code class="language-plaintext highlighter-rouge">flags</code> directive.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>(flags (:standard -ccopt -static))
</code></pre></div></div>

<p>This can be extended for maximum compatibility by additionally adding <code class="language-plaintext highlighter-rouge">-ccopt -march=x86-64</code>, which ensures the generated code will run on any x86_64 processor and will not use newer instruction set extensions like SSE3, AVX, etc.</p>

<p>So what about Windows? The Mingw tool chain accepts <code class="language-plaintext highlighter-rouge">-static</code>. Including <code class="language-plaintext highlighter-rouge">(flags (:standard -ccopt "-link -Wl,-static -v"))</code> got my options applied to my <code class="language-plaintext highlighter-rouge">dune</code> build:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>x86_64-w64-mingw32-gcc -mconsole  -L. -I"C:/Users/Administrator/my-app/_opam/lib/ocaml" -I"C:\Users\Administrator\my-app\_opam\lib\mccs" -I"C:\Users\Administrator\my-app\_opam\lib\mccs\glpk/internal" -I"C:\Users\Administrator\my-app\_opam\lib\opam-core" -I"C:\Users\Administrator\my-app\_opam\lib\sha" -I"C:/Users/Administrator/my-app/_opam/lib/ocaml\flexdll" -L"C:/Users/Administrator/my-app/_opam/lib/ocaml" -L"C:\Users\Administrator\my-app\_opam\lib\mccs" -L"C:\Users\Administrator\my-app\_opam\lib\mccs\glpk/internal" -L"C:\Users\Administrator\my-app\_opam\lib\opam-core" -L"C:\Users\Administrator\my-app\_opam\lib\sha" -L"C:/Users/Administrator/my-app/_opam/lib/ocaml\flexdll" -o "bin/main.exe" "C:\Users\ADMINI~1\AppData\Local\Temp\2\build_d62d04_dune\dyndllb7e0e8.o" "@C:\Users\ADMINI~1\AppData\Local\Temp\2\build_d62d04_dune\camlrespec7816"   "-municode" "-Wl,-static"
</code></pre></div></div>

<p>However, <code class="language-plaintext highlighter-rouge">ldd</code> showed that this wasn’t working:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ ldd main.exe | grep mingw
        libstdc++-6.dll =&gt; /mingw64/bin/libstdc++-6.dll (0x7ffabf3e0000)
        libgcc_s_seh-1.dll =&gt; /mingw64/bin/libgcc_s_seh-1.dll (0x7ffac3130000)
        libwinpthread-1.dll =&gt; /mingw64/bin/libwinpthread-1.dll (0x7ffac4b40000)
</code></pre></div></div>

<p>I tried <em>a lot</em> of different variations. I asked Claude… then I asked <a href="https://www.dra27.uk/blog/">@dra27</a> who recalled @kit-ty-kate working on this for opam. <a href="https://github.com/ocaml/opam/pull/5680">PR#5680</a></p>

<p>The issue is the auto-response file, which precedes my static option. We can remove that by adding <code class="language-plaintext highlighter-rouge">-noautolink</code>, but now we must do all the work by hand and build a massive command line.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>(executable
 (public_name main)
 (name main)
 (flags (:standard -noautolink -cclib -lunixnat -cclib -lmccs_stubs -cclib -lmccs_glpk_stubs -cclib -lsha_stubs -cclib -lopam_core_stubs -cclib -l:libstdc++.a -cclib -l:libpthread.a -cclib -Wl,-static -cclib -ladvapi32 -cclib -lgdi32 -cclib -luser32 -cclib -lshell32 -cclib -lole32 -cclib -luuid -cclib -luserenv -cclib -lwindowsapp))
 (libraries opam-client))
</code></pre></div></div>

<p>It works, but it’s not for the faint-hearted.</p>

<p>I additionally added <code class="language-plaintext highlighter-rouge">(enabled_if (= %{os_type} Win32))</code> to my rule so it only runs on Windows.</p>
