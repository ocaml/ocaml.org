---
title: Adventures with BuildKit
description: "I\u2019ve been doing battle the last few days with Docker, and in particular
  trying to persuade BuildKit to do what I wanted. I find Docker leans towards being
  a deployment tool, rather than a development tool which is to say that it\u2019s
  exceedingly useful for both, but when I encounter problems trying to persuade it
  to do what I\u2019m after for development, it tends to feel I\u2019m not using it
  for the purpose for which it was intended."
url: https://www.dra27.uk/blog/platform/2025/07/29/taming-buildkit.html
date: 2025-07-29T00:00:00-00:00
preview_image:
authors:
- ""
source:
ignore:
---

<p>I’ve been doing battle the last few days with Docker, and in particular trying
to persuade BuildKit to do what I wanted. I find Docker leans towards being a
deployment tool, rather than a development tool which is to say that it’s
exceedingly useful for both, but when I encounter problems trying to persuade it
to do what I’m after for development, it tends to feel I’m not using it for the
purpose for which it was intended.</p>

<p>Anyway, maybe documenting the journey will reveal how much of this view is my
own ignorance and it will definitely consolidate a few useful tricks in one
place ready for next time.</p>

<p>Docker shines when I’m at the stage of needing to test multiple configurations
or versions of what I’m doing against one bit of code that I’m working on. Its
<a href="https://docs.docker.com/build/building/multi-stage/">multi-stage builds</a>
provide a very convenient and tidy way to fan out a single build tree into
multiple configurations (versus, say, using multiple worktrees, etc.) and the
<a href="https://docs.docker.com/build/buildkit/">BuildKit</a> backend adds parallelism.
Couple of that with an unnecessarily large number of CPU cores, more RAM than
existed in the world when I was a child, and many terrabytes of cache, and
you’re sorted!</p>

<p>I’ve been working on meta-programming the installation targets for OCaml’s build
system to allow them to do things other than simply installing OCaml (generating
opam <code class="language-plaintext highlighter-rouge">.install</code> files, cloning scripts and so forth). The commit series for that
got plugged into the branch set for Relocatable OCaml and fairly painlessly
backported. It’s all GNU make macros and so forth - no type system helping and
various bits that have shifted around over the past few releases. I’d devised a
series of manual tests for the branch <a href="https://github.com/dra27/ocaml/commits/opam-install-file">against trunk OCaml</a>,
a little bit of glue to generate a <code class="language-plaintext highlighter-rouge">Dockerfile</code>, and the testing against the
backports could be automated. Our <a href="https://images.ci.ocaml.org">base images</a> are
a useful starting point:</p>

<div class="language-Dockerfile highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">FROM</span><span class="w"> </span><span class="s">ocaml/opam:ubuntu-24.04-opam</span><span class="w"> </span><span class="k">AS</span><span class="w"> </span><span class="s">base</span>

<span class="k">RUN </span><span class="nb">sudo </span>apt-get update <span class="o">&amp;&amp;</span> <span class="nb">sudo </span>apt-get <span class="nb">install</span> <span class="nt">-y</span> gawk autoconf2.69
<span class="k">RUN </span><span class="nb">sudo </span>apt-get <span class="nb">install</span> <span class="nt">-y</span> vim

<span class="k">ENV</span><span class="s"> OPAMYES="1" OCAMLCONFIRMLEVEL="unsafe-yes" OPAMPRECISETRACKING="1"</span>
<span class="k">RUN </span><span class="nb">sudo ln</span> <span class="nt">-f</span> /usr/bin/opam-2.3 /usr/bin/opam <span class="o">&amp;&amp;</span> opam update

<span class="k">RUN </span>git clone https://github.com/dra27/ocaml.git
<span class="k">WORKDIR</span><span class="s"> ocaml</span>
</code></pre></div></div>

<p>That sets up an image we can then use as a fanout for running the actual tests,
which is then a whole series of (generated) fragments. The first bit sets up the
compiler before my changes:</p>

<div class="language-Dockerfile highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">FROM</span><span class="w"> </span><span class="s">base</span><span class="w"> </span><span class="k">AS</span><span class="w"> </span><span class="s">test-4.14-relocatable</span>
<span class="k">RUN </span>git checkout 32d46126b2b993a7ac526a339c85d528d3a280cd <span class="o">||</span> git fetch origin <span class="o">&amp;&amp;</span> git checkout 32d46126b2b993a7ac526a339c85d528d3a280cd
<span class="k">RUN </span>./configure <span class="nt">-C</span> <span class="nt">--prefix</span> <span class="nv">$PWD</span>/_opam <span class="nt">--docdir</span> <span class="nv">$PWD</span>/_opam/doc/ocaml <span class="nt">--enable-native-toplevel</span> <span class="nt">--with-relative-libdir</span><span class="o">=</span>../lib/ocaml <span class="nt">--enable-runtime-search</span><span class="o">=</span>always <span class="nt">--enable-runtime-search-target</span>
<span class="k">RUN </span>make <span class="nt">-j</span>
<span class="k">RUN </span>make <span class="nb">install</span>
<span class="k">RUN </span><span class="nb">mv </span>_opam _opam.ref
</code></pre></div></div>

<p>The <code class="language-plaintext highlighter-rouge">git checkout foo || git fetch origin &amp;&amp; git checkout foo</code> is a neat little
bit of Docker fu: first try to checkout the commit you need and only if that
fails do a Git pull. That means that if something gets changed while developing,
only the containers which need to pull will do so, preserving caching (if we
re-did the clone in <code class="language-plaintext highlighter-rouge">base</code>, it’d invalidate <em>all</em> the builds so far).</p>

<p>Then it actually does the battery of tests:</p>

<div class="language-Dockerfile highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">RUN </span>git checkout e1794e2548a1e8f6dc11841b0ac9ad159ca89988 <span class="o">||</span> git fetch origin <span class="o">&amp;&amp;</span> git checkout e1794e2548a1e8f6dc11841b0ac9ad159ca89988
<span class="k">RUN </span>make <span class="nb">install</span> <span class="o">&amp;&amp;</span> diff <span class="nt">-Nrq</span> _opam _opam.ref <span class="o">&amp;&amp;</span> <span class="nb">rm</span> <span class="nt">-rf</span> _opam
<span class="k">RUN </span>git checkout 86ecf4399873045d7eca03560d9ac84eebae38e8 <span class="o">||</span> git fetch origin <span class="o">&amp;&amp;</span> git checkout 86ecf4399873045d7eca03560d9ac84eebae38e8
<span class="k">RUN if </span><span class="nb">grep</span> ...
<span class="k">RUN if </span><span class="nb">test</span> <span class="nt">-n</span> ...
<span class="k">RUN </span>git checkout 671122db576cb0e6531cf1fa3b18af225f840c36 <span class="o">||</span> git fetch origin <span class="o">&amp;&amp;</span> git checkout 671122db576cb0e6531cf1fa3b18af225f840c36
<span class="k">RUN if </span><span class="nb">grep</span> <span class="s1">'^ROOTDIR *='</span> <span class="k">*</span> <span class="nt">-rIl</span> ...
<span class="k">RUN </span>git checkout fbf12456dd47d758d1858bd6edf8dd3310a7ca3b <span class="o">||</span> git fetch origin <span class="o">&amp;&amp;</span> git checkout fbf12456dd47d758d1858bd6edf8dd3310a7ca3b
<span class="k">RUN if </span><span class="nb">grep</span> <span class="s1">'INSTALL_\(DATA\|PROG\)'</span> ...
<span class="k">RUN </span>make <span class="nb">install</span> <span class="o">&amp;&amp;</span> diff <span class="nt">-Nrq</span> _opam _opam.ref <span class="o">&amp;&amp;</span> <span class="nb">rm</span> <span class="nt">-rf</span> _opam
<span class="k">RUN if </span><span class="nb">test</span> <span class="nt">-n</span> <span class="s2">"</span><span class="si">$(</span>make <span class="nv">INSTALL_MODE</span><span class="o">=</span>list ...
<span class="k">RUN </span>make <span class="nv">INSTALL_MODE</span><span class="o">=</span>display <span class="nb">install</span>
<span class="k">RUN </span>make <span class="nv">INSTALL_MODE</span><span class="o">=</span>opam <span class="nv">OPAM_PACKAGE_NAME</span><span class="o">=</span>ocaml-variants <span class="nb">install</span>
<span class="k">RUN </span>make <span class="nv">INSTALL_MODE</span><span class="o">=</span>clone <span class="nv">OPAM_PACKAGE_NAME</span><span class="o">=</span>ocaml-variants <span class="nb">install</span>
<span class="k">RUN </span><span class="nb">test</span> <span class="o">!</span> <span class="nt">-d</span> _opam
<span class="k">RUN </span>opam switch create <span class="nb">.</span> <span class="nt">--empty</span> <span class="o">&amp;&amp;</span> opam pin add <span class="nt">--no-action</span> <span class="nt">--kind</span><span class="o">=</span>path ocaml-variants .
<span class="k">RUN </span>opam <span class="nb">install </span>ocaml-variants <span class="nt">--assume-built</span>
</code></pre></div></div>

<p>The nifty part is that if one individual branch needed tweaking, the script to
generate the <code class="language-plaintext highlighter-rouge">Dockerfile</code> puts the new commit shas in there and BuildKit then
rebuilds just the parts needed. The whole thing then just needs tying together
with something that forces the builds to be “necessary”:</p>

<div class="language-Dockerfile highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">FROM</span><span class="w"> </span><span class="s">base</span><span class="w"> </span><span class="k">AS</span><span class="w"> </span><span class="s">collect</span>
<span class="k">WORKDIR</span><span class="s"> /home/opam</span>
<span class="k">COPY</span><span class="s"> --from=test-4.08-vanilla /home/opam/ocaml/config.cache cache-4.08-vanilla</span>
<span class="k">COPY</span><span class="s"> --from=test-4.08-relocatable /home/opam/ocaml/config.cache cache-4.08-relocatable</span>
<span class="k">COPY</span><span class="s"> --from=test-4.09-vanilla /home/opam/ocaml/config.cache cache-4.09-vanilla</span>
<span class="k">COPY</span><span class="s"> --from=test-4.09-relocatable /home/opam/ocaml/config.cache cache-4.09-relocatable</span>
<span class="k">COPY</span><span class="s"> --from=test-4.10-vanilla /home/opam/ocaml/config.cache cache-4.10-vanilla</span>
<span class="k">COPY</span><span class="s"> --from=test-4.10-relocatable /home/opam/ocaml/config.cache cache-4.10-relocatable</span>
...
<span class="k">COPY</span><span class="s"> --from=test-5.2-relocatable /home/opam/ocaml/config.cache cache-5.2-relocatable</span>
<span class="k">COPY</span><span class="s"> --from=test-5.3-vanilla /home/opam/ocaml/config.cache cache-5.3-vanilla</span>
<span class="k">COPY</span><span class="s"> --from=test-5.3-relocatable /home/opam/ocaml/config.cache cache-5.3-relocatable</span>
<span class="k">COPY</span><span class="s"> --from=test-5.4-vanilla /home/opam/ocaml/config.cache cache-5.4-vanilla</span>
<span class="k">COPY</span><span class="s"> --from=test-5.4-relocatable /home/opam/ocaml/config.cache cache-5.4-relocatable</span>
<span class="k">COPY</span><span class="s"> --from=test-trunk-vanilla /home/opam/ocaml/config.cache cache-trunk-vanilla</span>
<span class="k">COPY</span><span class="s"> --from=test-trunk-relocatable /home/opam/ocaml/config.cache cache-trunk-relocatable</span>
</code></pre></div></div>

<p>The purpose of that last step is just to extract <em>something</em> from all the other
containers to force them to be built. <a href="https://github.com/dra27/relocatable/tree/main/test-install">It worked really nicely</a>,
the testing identified a few slips here and there with the commit series, and it
was very efficient to re-test it after any tweaks.</p>

<p>So… having got that working, I wanted to make sure that changes I’d made to
the <a href="https://github.com/dra27/relocatable/commits/main/stack">monster script</a>
that reconstitutes Relocatable OCaml back at the beginning of the month were
working on all of the older lock files. Partly because things should be <em>always</em>
be reproducible, but also because I have needed to go back to older iterations
of Relocatable OCaml, I added a lockfile system to it last year. For example,
<a href="https://github.com/dra27/ocaml/commit/ef758648dd743bd471d17d8183a3ee5b6d9da61b">ef758648dd</a>
describes the exact branches which contributed to the OCaml Workshop 2022 talk
on Relocatable OCaml. It takes a list of branch commands:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>fix-autogen@4.08 6b37fcefa88a21f5972ca64e1af89e060df6a83c
fcommon@4.08 2c36ba5c19967b69c879bc0a9f5336886eb8df6b
sigaltstack 044768019090c2aeeb02b4d0fb4ddf13d75be8c6
sigaltstack-4.09@fixup 8302a9cd4f931f232e40078048d02d35a7075f05
fix-4.09.1-configure@4.09 7e1f5a33e0cdd3f051a5c5ab76f1d097270e232e
install-bytecode@4.08 1287da77f952166e1c60d93da0e756b2ba7d33b7
win-reconfigure@4.08 162af3f1ff477a6a0e34816fe855ef474c07b273
mingw-headers@4.09 78e3c94924b07ff2941a6313b35fca8bd0fc7ce1
makefile-tweaks@4.09 6a2af5c14176e06275ff4da7dc6a14fd4f49093a
static-libgcc@4.11 260ec0f27682822f255f8cf64cf4e4faa6fa8088
config.guess@4.11 7efc39d9bcb943375c35dd024c60e21c8fecda6a
config.guess-4.09@4.09 185183104b4d559eb5f24fc1d0d2531976f1ee0e
fix-binutils-2.36@4.11 5b1560952044faee8b2502b3595c0598e7402513
fix-mingw-lld@4.11 5443fec22245ff37fda7e2ce8ad554daf11fa0df
...
</code></pre></div></div>
<p>and crunches that to produce a commit series for each required version:</p>
<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>backport-5.0 b5c11faed67511e25a2ee9cac953362b6b165a37
backport-4.14 0598df18732107619f4d500f9c372e648b6c0174
backport-4.13 f2cd54453f7c4684af8fdb2c2c1d4b14119d077f
backport-4.12 de72889271d8875589a0e9690ab220f9ffcc4eb1
backport-4.11 a15f4a165ae27929fec94e05b65257126883eafd
backport-4.10 e95093194d0ec378de3d86033bd011b3d8cb7eb2
backport-4.09 4ee19334d40a5a5c0a69de53a8e77eb3f6fc5829
backport-4.08 52ec6c2f54e9d8c0fb950e7b4a2016ec9a624756
</code></pre></div></div>
<p>Now, it should always be possible to build a given lock with the <code class="language-plaintext highlighter-rouge">stack</code> script
from the date it was made, but it’s actually more useful to be able to build it
with the latest one - the problem is that occasionally things go wrong. So… I
have a <code class="language-plaintext highlighter-rouge">Dockerfile</code> a la the one above which tests whether each lock is still
buildable.</p>

<p>So, what I’d hoped was going to work was to put each lock in an image, just like
with the testing, build it with a “known good” version of the script, then add
additional <code class="language-plaintext highlighter-rouge">RUN</code> lines to each of the images to use a newer version of the
<code class="language-plaintext highlighter-rouge">stack</code> script and then debug as I went, being able to take advantage of the
bootstrap caching from the previous stages so that it wouldn’t be tortuously
slow. Docker seemed to have other ideas, though. I guess because there were so
many artefacts flying around, some of those intermediate layers were being
evicted from the cache. I tried cranking up <code class="language-plaintext highlighter-rouge">builder.gc.defaultKeepStorage</code>, but
to no avail. I switched to the containerd imagge storage backend and tried using
<code class="language-plaintext highlighter-rouge">--cache-to</code>, which allows cranking the cache aggressiveness with <code class="language-plaintext highlighter-rouge">mode=max</code>.
That seemed to work, but at the cost of waiting ages at the end of each build
for all the intermediate to be exported.</p>

<p>I’d just about given up, but then I had an idea to turn the problem on its HEAD:
instead of fighting Docker and trying to convince it that all these intermediate
builds were precious, how about making it that the final container (the
“collect” bit) actually contained all the artefacts? In this case, the most
“precious” artefact that’s wanted is any bootstraps of OCaml done as part of the
commit series - they’re computationally expensive to perform, and the <code class="language-plaintext highlighter-rouge">stack</code>
script already has a trick where it scours the <code class="language-plaintext highlighter-rouge">reflog</code> looking for previous
instances of the same bootstrap. The <code class="language-plaintext highlighter-rouge">base</code> stage is similar to the previous
test - but before fanning out, this time another <code class="language-plaintext highlighter-rouge">builder</code> stage is added:</p>

<div class="language-Dockerfile highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">FROM</span><span class="w"> </span><span class="s">base</span><span class="w"> </span><span class="k">AS</span><span class="w"> </span><span class="s">builder</span>
<span class="k">RUN </span><span class="o">&lt;&lt;</span><span class="no">End</span><span class="sh">-of-Script</span>
  git clone --shared relocatable build
  cd build
  git submodule init ocaml
  git clone /home/opam/relocatable/ocaml --shared --no-checkout .git/modules/ocaml
  mv .git/modules/ocaml/.git/* .git/modules/ocaml/
  rmdir .git/modules/ocaml/.git
  cp ../relocatable/.git/modules/ocaml/hooks/pre-commit .git/modules/ocaml/hooks/
  git submodule update ocaml
  cd ocaml
  git remote set-url origin https://github.com/dra27/ocaml.git
  git remote add --fetch upstream https://github.com/ocaml/ocaml.git

  ...
End-of-Script
<span class="k">WORKDIR</span><span class="s"> /home/opam/build/ocaml</span>
</code></pre></div></div>

<p>There’s some fun Git trickery combining with Docker caching. The <code class="language-plaintext highlighter-rouge">base</code> stage
did the main clone - so <code class="language-plaintext highlighter-rouge">/home/opam/relocatable</code> is a normal clone of
<a href="https://github.com/dra27/relocatable">dra27/relocatable</a> and then
<code class="language-plaintext highlighter-rouge">/home/opam/relocatable/ocaml</code> is an initialised submodule cloning
<a href="https://github.com/dra27/ocaml">dra27/ocaml</a> and also with <a href="https://github.com/ocaml/ocaml">ocaml/ocaml</a>
fetched. That’s a lot of stuff, and <code class="language-plaintext highlighter-rouge">/home/opam/relocatable/.git/modules/ocaml</code>
is 562M. So the <code class="language-plaintext highlighter-rouge">builder</code> stage does two tricks: firstly it clones the <em>local</em>
copy of relocatable again, but using <code class="language-plaintext highlighter-rouge">--shared</code>. Then it does a similar trick
with the submodule (for some reason I couldn’t get to the bottom, while
<code class="language-plaintext highlighter-rouge">git submodule update</code> supports most of <code class="language-plaintext highlighter-rouge">git clone</code>’s obscure arguments, it
doesn’t support <code class="language-plaintext highlighter-rouge">--shared</code>, so the trick with moving things around does the
clone for it. The result of that is a copy of the relocatable clone, but with
none of the commits copied. That’s subtly different from using worktrees - it
means that each parallel build will exactly store just the new commits it adds
into its git repo. That means 50-350MB per image, instead of 600-950MB, so a
considerable saving.</p>

<p>The trick then is to copy those Git clones back as part of the collection stage:</p>

<div class="language-Dockerfile highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">FROM</span><span class="w"> </span><span class="s">base</span><span class="w"> </span><span class="k">AS</span><span class="w"> </span><span class="s">collector</span>
<span class="k">COPY</span><span class="s"> --chown=opam:opam --from=lock-818afcc496 /home/opam/build/.git/modules/ocaml builds/818afcc496/.git</span>
<span class="k">COPY</span><span class="s"> --from=lock-818afcc496 /home/opam/build/log logs/log-818afcc496</span>
<span class="k">RUN </span><span class="nb">sed</span> <span class="nt">-i</span> <span class="nt">-e</span> <span class="s1">'/worktree/d'</span> builds/818afcc496/.git/config
<span class="k">COPY</span><span class="s"> --chown=opam:opam --from=lock-727272c2ee /home/opam/build/.git/modules/ocaml builds/727272c2ee/.git</span>
<span class="k">COPY</span><span class="s"> --from=lock-727272c2ee /home/opam/build/log logs/log-727272c2ee</span>
<span class="k">RUN </span><span class="nb">sed</span> <span class="nt">-i</span> <span class="nt">-e</span> <span class="s1">'/worktree/d'</span> builds/727272c2ee/.git/config
<span class="k">COPY</span><span class="s"> --chown=opam:opam --from=lock-8d9989f22a /home/opam/build/.git/modules/ocaml builds/8d9989f22a/.git</span>
<span class="k">COPY</span><span class="s"> --from=lock-8d9989f22a /home/opam/build/log logs/log-8d9989f22a</span>
<span class="k">RUN </span><span class="nb">sed</span> <span class="nt">-i</span> <span class="nt">-e</span> <span class="s1">'/worktree/d'</span> builds/8d9989f22a/.git/config
<span class="k">COPY</span><span class="s"> --chown=opam:opam --from=lock-032059697e /home/opam/build/.git/modules/ocaml builds/032059697e/.git</span>
<span class="k">COPY</span><span class="s"> --from=lock-032059697e /home/opam/build/log logs/log-032059697e</span>
...
</code></pre></div></div>

<p>Of course, that quickly resulted in too many layers, so in fact it’s fanned out
into a series of “collector” images so that at the end of the build, the
directory <code class="language-plaintext highlighter-rouge">builds</code> contains the Git repository from each of the builds, but not
any source artefacts. That can then all be plumbed into the <em>original</em> repo to
create the final image:</p>

<div class="language-Dockerfile highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">FROM</span><span class="s"> base</span>
<span class="k">COPY</span><span class="s"> --chown=opam:opam --from=collector /home/opam/builds builds</span>
<span class="k">COPY</span><span class="s"> --chown=opam:opam --from=collector /home/opam/logs logs</span>
<span class="k">COPY</span><span class="s"> --from=reflog /home/opam/HEAD .</span>
<span class="k">RUN </span><span class="nb">cat </span>HEAD <span class="o">&gt;&gt;</span> relocatable/.git/modules/ocaml/logs/HEAD <span class="o">&amp;&amp;</span> <span class="nb">rm</span> <span class="nt">-f</span> HEAD
<span class="k">COPY</span><span class="s"> &lt;&lt;EOF relocatable/.git/modules/ocaml/objects/info/alternates</span>
/home/opam/builds/ef758648dd/.git/objects
/home/opam/builds/b026116679/.git/objects
/home/opam/builds/511e988096/.git/objects
...
/home/opam/builds/590e211336/.git/objects
/home/opam/builds/b5aa73d89c/.git/objects
EOF
<span class="k">WORKDIR</span><span class="s"> /home/opam/relocatable/ocaml</span>
<span class="k">RUN </span><span class="o">&lt;&lt;</span><span class="no">End</span><span class="sh">-of-Script</span>
  cat &gt;&gt; rebuild &lt;&lt;"EOF"
  head="$(git -C ../../builds/ef758648dd rev-parse --short relocatable-cache)"
  for lock in b026116679 511e988096 d2939babd4 be8c62d74b c007288549 ...; do
    while IFS= read -r line; do
      args=($line)
      if [[ ${#args[@]} -gt 2 ]]; then
        parents=("${args[@]:3}")
        head=$(git show --no-patch --format=%B ${args[0]} | git commit-tree -p $head ${parents[@]/#/-p } ${args[1]})
      fi
    done &lt; &lt;(git -C ../../builds/$lock log --format='%h %t %p' --first-parent --reverse relocatable-cache)
  done
  git branch relocatable-cache $head
EOF
  bash rebuild
  rm rebuild
  for lock in ef758648dd b026116679 511e988096 d2939babd4 ...; do
    script --return --append --command "../stack $lock" ../log
  done
End-of-Script
</code></pre></div></div>

<p>Et voilà! One final image that contains all those precious bootstraps unified
and where the storage overhead of the parallel builds is kept to a minimum…
and, as a result of that, BuildKit’s cache seems to be working for me, rather
than against 🥳</p>
