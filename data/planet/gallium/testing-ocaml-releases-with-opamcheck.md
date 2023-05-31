---
title: Testing OCaml releases with opamcheck
description:
url: http://gallium.inria.fr/blog/an-ocaml-release-story-1
date: 2019-12-02T08:00:00-00:00
preview_image:
featured:
authors:
- gallium
---



  <p>I (Florian Angeletti) have started working at Inria Paris this
August. A part of my new job is to help deal with the day-to-day care
for the OCaml compiler, particularly during the release process. This
blog post is short glimpse into the life of an OCaml release.</p>


  

  
  <h3>OCaml and the opam
repository</h3>
<p>Currently, the song of the OCaml development process is a canon with
two voices: a compiler release spends the first 6 months of its life as
the &ldquo;trunk&rdquo; branch of the OCaml compiler git repository. Then after
those 6 first months, it is named and given a branch on its own. For
instance, this happened on October 18 2019 for OCaml 4.10. Starting from
this point, the branch is frozen: only bug fixes are accepted, whereas
new development happens in trunk again. Our objective is then to release
the new version 3 months later. If we succeed, there are at most two
branches active at the same time.</p>
<div class="highlight"><pre><span></span>    Dev
    Dev
    Dev
    Dev
    Dev
    Dev
    Bug  Dev
    Bug  Dev
    RCs  Dev
         Dev
         Dev
         Dev
         Bug  Dev
         Bug  Dev
         RCs  Dev
              Dev
              Dev
              Dev
              Bug
              Bug
              Rcs
</pre></div>

<p>However, the OCaml compiler does not live in isolation. It makes
little point to release a new version of OCaml which is not compatible
with other parts of the OCaml ecosystem.</p>
<p>The release cycle of OCaml 4.08 was particularly painful from this
point of view: we refactored parts of the compiler API that were not
previously versioned by ocaml-migrate-parsetree, making it more
difficult to update. In turn, without a working version of
ocaml-migrate-parsetree, ppxses could not be built, breaking all
packages that depends on ppxs. It took months to correct the issue. This
slip of schedule affected the 4.09.0 release and can still be felt on
the 4.11 schedule.</p>
<h3>Catching knifes before the
fall</h3>
<p>Lesson learned, we need to test the packages on the opam repository
more often. Two tools in current usage can automate such testing:
opamcheck and opam-health-check.</p>
<p>The two tools attack the problem with a different angle. The
opam-health-check monitoring tool is developed to check the health of
the opam repository, for released OCaml versions.</p>
<p>In a complementary way, opamcheck was built by Damien Doligez to
check how well new versions of the OCaml compiler fare in term of
building the opam repository.</p>
<p>A typical difference between opamcheck and opam-health-check is that
opamcheck is biased towards newer versions of the compiler: if an opam
package builds on the latest unreleased version of the compiler, we
don&rsquo;t need to test it with older compilers. After all, we are mostly
interested in packages that are broken by the new release. The handful
of packages that may be coincidentally fixed by an unreleased compiler
are at most a curiosity; pruning those unlikely events save us some
precious time.</p>
<p>Since I started at Inria, in the midst of the first beta of OCaml
4.09.0, I have been working with opamcheck to monitor the health of the
opam repository.</p>
<p>The aim here is twofold. First, we want to detect expected breakages
that are just a sign that a package needs to be updated in advance. The
earliest we catch those, the more time the maintainers have to patch
their packages before the new release. Second, we want to detect
unexpected compatibility issues and breakages.</p>
<p>One fun example of such unexpected compatibility issue appeared in
the 4.09.0 release cycle. When I first used opamcheck to test the state
of the first 4.09.0 beta, there was a quite problematic broken package:
dune. This was quite stunning at first, because the 4.09.0 version of
OCaml contained mostly bug fixes and small quality-of-life improvements.
That was at least what I had few days before told to few worried
people&hellip;</p>
<p>So what was happening here? The issue stemmed from a small change of
behaviour in presence of missing cmis: dune was relying on an
unspecified OCaml compiler behaviour in such cases, and this behaviour
had been altered by a mostly unrelated improvement in the
typechecker.</p>
<p>This change of behaviour was patched and dune worked fine in the
second beta release of 4.09. And this time, the next run of opamcheck
confirmed that that 4.09.0 was a quiet release.</p>
<p>This is currently the main use of opamcheck: check the health status
of the opam repository on unreleased version of OCaml before
opam-health-check more extensive coverage takes the relay. One of our
objective for the future 4.10.0 release is to keep a much more extensive
test coverage, before the first beta.</p>
<h3>Opam and the PRs</h3>
<p>There is another possible use that is probably much more useful to
the anxious OCaml developer: opamcheck can be used to check that a PR or
an experimental branch does not break opam packages. A good example is
<a href="https://github.com/ocaml/ocaml/issues/8900">#8900</a>: this PR
proposes to remove the special handling of abstract types defined inside
the current module. This special case looks nice locally, but it enables
to write some code which is valid if and only if it is located in the
right module, without any possibility to correct this behaviour by
precising module signatures.</p>
<p>It is therefore quite tempting to try to remove this special case
from the typechecker, but it is reasonable?</p>
<p>This was another task for opamcheck. First, I added a new opamcheck
option to easily check any pull request on the OCaml compiler. After
some work, there was some good news: this pattern is mostly unused in
the current opam repository.</p>
<p>Knowing if there are any opam packages that rely on this feature is
definitively a big help when taking those decisions.</p>
<h3>Using opamcheck</h3>
<p>So if you are a worried OCaml developer and want to test your fancy
compiler PR on the anvil of the opam repositoy, what are the magical
incantations?</p>
<p>One option is to download the docker image
<code>octachron/opamchek</code> with</p>
<div class="highlight"><pre><span></span>docker pull octachron/opamcheck
</pre></div>

<p>Beware that the image weights around 7 Gio. If you want to build
opamcheck locally, you first need to clone the current opamcheck
repository</p>
<div class="highlight"><pre><span></span>git clone https://github.com/Octachron/ocaml.git
</pre></div>

<p>You probably need to install the following opam packages</p>
<div class="highlight"><pre><span></span>opam install minisat opam-file-format
</pre></div>

<p>And run the common magic</p>
<div class="highlight"><pre><span></span>cd opamcheck
make
</pre></div>

<p>Now, there are two use modes, you can launch opamcheck directly (or
inside a VM), or use the available dockerfiles. In this short blog post,
I will present the later option: it has the advantages of being
relatively lightweight in term of configuration, and makes it easier to
test your legions of PRs simultaneously (you don&rsquo;t have legions of PRs,
do you?) If you went with the manual road above, you need to first build
the image with</p>
<div class="highlight"><pre><span></span>make docker
</pre></div>

<p>This installs all external dependency on the docker image. That may
take a while (and a good amount of space).</p>
<p>Once the image is built or downloaded, there are three main options
to run it. If you want to compare several versions of the compiler
(given as switch names), let&rsquo;s say 4.05 and 4.08.1+flambda, you can
<code>run</code>:</p>
<div class="highlight"><pre><span></span>docker run -v opamcheck:/app/log -p <span class="m">8080</span>:80 --name<span class="o">=</span>opamcheck opamcheck run -online-summary<span class="o">=</span><span class="m">10</span> <span class="m">4</span>.05.0 <span class="m">4</span>.08.1+flambda
</pre></div>

<p>The name option is the docker container maps. The <code>-p</code>
option maps the port <code>80</code> of the container to
<code>8080</code> this is used to connect to the http server embedded in
the image. Finally, the <code>-v</code> precise where the opamcheck log
repository is mounted in the host file system. If you forget this
option, the log a random docker volume will be used. Here, it will be at
<code>/var/lib/docker/volumes/opamcheck</code>.</p>
<p>During opamcheck run, the progress can be checked with either</p>
<div class="highlight"><pre><span></span>sudo tail -f /var/lib/docker/volumes/opamcheck_log/_data/results
</pre></div>

<p>or by pointing a web browser to
<code>localhost:8080/fullindex.html</code>. Note that the first summary
is only generated after the OCaml compiler is built and all
uninstallable packages have been discovered. On my machine, this rounds
up at a 15 minutes wait before the first summary is generated. Later
update should be more frequent</p>
<p>The result should look like this <a href="https://opamcheck.polychoron.fr/4.10_2019_12_02/fullindex.html">summary
run</a> for OCaml 4.10.0. The integer parameter in
<code>-online-summary=n</code> corresponds to the update period for this
html summary. If the option is not provided, the html summary is only
built at the end of the run.</p>
<p>If you are more interested by testing a specific PR, for instance <a href="https://github.com/ocaml/ocaml/issues/8900">#8900</a>, the
<code>prmode</code> will work better</p>
<div class="highlight"><pre><span></span>docker run opamcheck --name<span class="o">=</span>opamcheck prmode -pr <span class="m">8900</span> <span class="m">4</span>.09.0
</pre></div>

<p>This command tries to rebase the given PR on top of the given OCaml
version (switch name); it fails immediately if the PR cannot be rebased;
in this case you should use the latest &lsquo;trunk&rsquo; switch as base or use the
<code>branch</code> option, described a bit below. When possible, it is
a good idea to use a released version as the base, as it will be
compatible with more opam packages than the current trunk.</p>
<p>If the branch that you want to test is not yet a PR, or needs some
manual rebasing to be compared against a specific compiler version,
there is a branch flag. For instance, let&rsquo;s say that you have a branch
&ldquo;my_very_experimental_branch&rdquo; at the location nowhere.org. You can
run</p>
<div class="highlight"><pre><span></span>docker run opamcheck --name<span class="o">=</span>opamcheck prmode -branch https://nowhere.org:my_very_experimental_branch <span class="m">4</span>.09.0
</pre></div>

<p>This command downloads the branch at nowhere.org and compare it
against the <code>4.09.0</code> switch.</p>
<p>Currently, a full run of opamcheck takes one or two days: you will
likely get the results before your first PR review. A limitation is the
false positive rate: most opam package descriptions are incomplete or
out of date, so packages will fail for reasons unrelated to your PR.
Unfortunately, this means that there are still some manual triage needed
at the end of an opamcheck run.</p>
<p>There are four main objectives for opamcheck in the next months:</p>
<ul>
<li>improve the usability</li>
<li>share more code with opam-health-check, at least on the
frontend</li>
<li>reduce the false positive rate</li>
<li>reduce the time required by a CI run</li>
</ul>
<p>If you want to check on future development for opamcheck, and a
potentially more up-to-date readme, you can have a look at <a href="https://github.com/Octachron/opamcheck">Octachron/opamcheck</a>.</p>


  
