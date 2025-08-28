---
title: Tarides Website
description: Bella was in touch as the tarides.com website is no longer building.
  The initial error is that cmarkit was missing, which I assumed was due to an outdated
  PR which needed to be rebased.
url: https://www.tunbury.org/2025/07/24/tarides-website/
date: 2025-07-24T00:00:00-00:00
preview_image: https://www.tunbury.org/images/tarides.png
authors:
- Mark Elvers
source:
ignore:
---

<p>Bella was in touch as the tarides.com website is no longer building. The initial error is that <code class="language-plaintext highlighter-rouge">cmarkit</code> was missing, which I assumed was due to an outdated PR which needed to be rebased.</p>

<div class="language-dockerfile highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c">#20 [build 13/15] RUN ./generate-images.sh</span>
<span class="c">#20 0.259 + dune exec -- src/gen/main.exe file.dune</span>
<span class="c">#20 2.399     Building ocaml-config.3</span>
<span class="c">#20 9.486 File "src/gen/dune", line 7, characters 2-9:</span>
<span class="c">#20 9.486 7 |   cmarkit</span>
<span class="c">#20 9.486       ^^^^^^^</span>
<span class="c">#20 9.486 Error: Library "cmarkit" not found.</span>
<span class="c">#20 9.486 -&gt; required by _build/default/src/gen/main.exe</span>
<span class="c">#20 10.92 + dune build @convert</span>
<span class="c">#20 18.23 Error: Alias "convert" specified on the command line is empty.</span>
<span class="c">#20 18.23 It is not defined in . or any of its descendants.</span>
<span class="c">#20 ERROR: process "/bin/sh -c ./generate-images.sh" did not complete successfully: exit code: 1</span>
</code></pre></div></div>

<p>The site recently moved to Dune Package Management, so this was my first opportunity to dig into how that works. Comparing the current build to the last successful build, I can see that <code class="language-plaintext highlighter-rouge">cmarkit</code> was installed previously but isn’t now.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>#19 [build 12/15] RUN dune pkg lock &amp;&amp; dune build @pkg-install
#19 25.39 Solution for dune.lock:
...
#19 25.39 - cmarkit.dev
...
</code></pre></div></div>

<p>Easy fix, I added <code class="language-plaintext highlighter-rouge">cmarkit</code> to the <code class="language-plaintext highlighter-rouge">.opam</code> file. Oddly, it’s in the <code class="language-plaintext highlighter-rouge">.opam</code> file as a pinned depend. However, the build now fails with a new message:</p>

<div class="language-dockerfile highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c">#21 [build 13/15] RUN ./generate-images.sh</span>
<span class="c">#21 0.173 + dune exec -- src/gen/main.exe file.dune</span>
<span class="c">#21 2.582     Building ocaml-config.3</span>
<span class="c">#21 10.78 File "src/gen/grant.ml", line 15, characters 5-24:</span>
<span class="c">#21 10.78 15 |   |&gt; Hilite.Md.transform</span>
<span class="c">#21 10.78           ^^^^^^^^^^^^^^^^^^^</span>
<span class="c">#21 10.78 Error: Unbound module "Hilite.Md"</span>
<span class="c">#21 10.81 File "src/gen/blog.ml", line 142, characters 5-24:</span>
<span class="c">#21 10.81 142 |   |&gt; Hilite.Md.transform</span>
<span class="c">#21 10.81            ^^^^^^^^^^^^^^^^^^^</span>
<span class="c">#21 10.81 Error: Unbound module "Hilite.Md"</span>
<span class="c">#21 10.82 File "src/gen/page.ml", line 52, characters 5-24:</span>
<span class="c">#21 10.82 52 |   |&gt; Hilite.Md.transform</span>
<span class="c">#21 10.82           ^^^^^^^^^^^^^^^^^^^</span>
<span class="c">#21 10.82 Error: Unbound module "Hilite.Md"</span>
<span class="c">#21 10.94 + dune build @convert</span>
<span class="c">#21 19.46 Error: Alias "convert" specified on the command line is empty.</span>
<span class="c">#21 19.46 It is not defined in . or any of its descendants.</span>
<span class="c">#21 ERROR: process "/bin/sh -c ./generate-images.sh" did not complete successfully: exit code: 1</span>
</code></pre></div></div>

<p>Checking the <a href="https://opam.ocaml.org/packages/hilite/hilite.0.5.0/">hilite</a> package, I saw that there had been a new release last week. The change log lists:</p>

<ul>
  <li>Separate markdown package into an optional hilite.markdown package</li>
</ul>

<p>Ah, commit <a href="https://github.com/patricoferris/hilite/commit/529cb756b05dd15793c181304f438ba1aa48f12a">aaf60f7</a> removed the dependency on <code class="language-plaintext highlighter-rouge">cmarkit</code> by including the function <code class="language-plaintext highlighter-rouge">buffer_add_html_escaped_string</code> in the <code class="language-plaintext highlighter-rouge">hilite</code> source.</p>

<p>Pausing for a moment, if I constrain <code class="language-plaintext highlighter-rouge">hilite</code> to 0.4.0, does the site build? Yes. Ok, so that’s a valid solution. How hard would it be to switch to 0.5.0?</p>

<p>I hit a weird corner case as I was unable to link against <code class="language-plaintext highlighter-rouge">hilite.markdown</code>. I chatted with Patrick, and I recreated my switch, and everything worked.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>File "x/dune", line 3, characters 20-35:
3 |  (libraries cmarkit hilite.markdown))
                        ^^^^^^^^^^^^^^^
Error: Library "hilite.markdown" not found.
-&gt; required by library "help" in _build/default/x
-&gt; required by _build/default/x/.help.objs/native/help__X.cmx
-&gt; required by _build/default/x/help.a
-&gt; required by alias x/all
-&gt; required by alias default
</code></pre></div></div>

<p>Talking with Jon later about a tangential issue of docs for optional submodules gave me a sudden insight into the corner I’d found myself in. The code base depends on <code class="language-plaintext highlighter-rouge">hilite</code>, so after running <code class="language-plaintext highlighter-rouge">opam update</code> (to ensure I would get version 0.5.0), I created a new switch <code class="language-plaintext highlighter-rouge">opam switch create . --deps-only</code>, and opam installed 0.5.0. When I ran <code class="language-plaintext highlighter-rouge">dune build</code>, it reported a missing dependency on <code class="language-plaintext highlighter-rouge">cmarkit</code>, so I dutifully added it as a dependency and ran <code class="language-plaintext highlighter-rouge">opam install cmarkit</code>. Do you see the problem? <code class="language-plaintext highlighter-rouge">hilite</code> only builds the markdown module when <code class="language-plaintext highlighter-rouge">cmarkit</code> is installed. If both packages are listed in the opam file when the switch is created, everything works as expected.</p>

<p>The diff turned out to be pretty straightforward.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code> <span class="k">let</span> <span class="n">html_of_md</span> <span class="o">~</span><span class="n">slug</span> <span class="n">body</span> <span class="o">=</span>
   <span class="nn">String</span><span class="p">.</span><span class="n">trim</span> <span class="n">body</span>
   <span class="o">|&gt;</span> <span class="nn">Cmarkit</span><span class="p">.</span><span class="nn">Doc</span><span class="p">.</span><span class="n">of_string</span> <span class="o">~</span><span class="n">strict</span><span class="o">:</span><span class="bp">false</span>
<span class="o">-</span>  <span class="o">|&gt;</span> <span class="nn">Hilite</span><span class="p">.</span><span class="nn">Md</span><span class="p">.</span><span class="n">transform</span>
<span class="o">+</span>  <span class="o">|&gt;</span> <span class="nn">Hilite_markdown</span><span class="p">.</span><span class="n">transform</span>
   <span class="o">|&gt;</span> <span class="nn">Cmarkit_html</span><span class="p">.</span><span class="n">of_doc</span> <span class="o">~</span><span class="n">safe</span><span class="o">:</span><span class="bp">false</span>
   <span class="o">|&gt;</span> <span class="nn">Soup</span><span class="p">.</span><span class="n">parse</span>
   <span class="o">|&gt;</span> <span class="n">rewrite_links</span> <span class="o">~</span><span class="n">slug</span>
</code></pre></div></div>

<p>Unfortunately, the build still does not complete successfully. When Dune Package Management builds <code class="language-plaintext highlighter-rouge">hilite</code>, it does not build the markdown module even though <code class="language-plaintext highlighter-rouge">cmarkit</code> is installed. I wish there was a <code class="language-plaintext highlighter-rouge">dune pkg install</code> command!</p>

<p>I tried to split the build by creating a .opam file which contained just <code class="language-plaintext highlighter-rouge">ocaml</code> and <code class="language-plaintext highlighter-rouge">cmarkit</code>, but this meant running <code class="language-plaintext highlighter-rouge">dune pkg lock</code> a second time, and that caused me to run straight into <a href="https://github.com/ocaml/dune/issues/11644">issue #11644</a>.</p>

<p>Perhaps I can patch <code class="language-plaintext highlighter-rouge">hilite</code> to make Dune Package Management deal with it as opam does? Jon commented earlier that <code class="language-plaintext highlighter-rouge">cmarkit</code> is listed as a <code class="language-plaintext highlighter-rouge">with-test</code> dependency. opam would use it if it were present, but perhaps Dune Package Management needs to be explicitly told that it can? I will add <code class="language-plaintext highlighter-rouge">cmarkit</code> as an optional dependency.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>depends: [
  "dune" {&gt;= "3.8"}
  "mdx" {&gt;= "2.4.1" &amp; with-test}
  "cmarkit" {&gt;= "0.3.0" &amp; with-test}
  "textmate-language" {&gt;= "0.3.3"}
  "odoc" {with-doc}
]
depopts: [
  "cmarkit" {&gt;= "0.3.0"}
]
</code></pre></div></div>

<p>With my <a href="https://github.com/mtelvers/hilite/tree/depopts">branch</a> of <code class="language-plaintext highlighter-rouge">hilite</code>, the website builds again with Dune Package Management.</p>

<p>I have created a <a href="https://github.com/patricoferris/hilite/pull/27">PR#27</a> to see if Patrick would be happy to update the package.</p>

<p>Feature request for Dune Package Management would be the equivalent of <code class="language-plaintext highlighter-rouge">opam option --global archive-mirrors="https://opam.ocaml.org/cache"</code> as a lengthy <code class="language-plaintext highlighter-rouge">dune pkg lock</code> may fail due to a single <code class="language-plaintext highlighter-rouge">curl</code> failure and need to be restarted from scratch.</p>
