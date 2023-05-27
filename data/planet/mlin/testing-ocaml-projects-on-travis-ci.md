---
title: Testing OCaml projects on Travis CI
description: "Update (Oct 2013):  Anil \_Madhavapeddy has fleshed this out further
  .  This evening I spent some time getting unit tests for my OCaml projec..."
url: http://blog.mlin.net/2013/02/testing-ocaml-projects-on-travis-ci.html
date: 2013-02-11T04:18:00-00:00
preview_image:
featured:
authors:
- Unknown
---

<b>Update (Oct 2013):</b> Anil &nbsp;Madhavapeddy has <a href="http://anil.recoil.org/2013/09/30/travis-and-ocaml.html">fleshed this out further</a>.<br/><br/>
This evening I spent some time getting unit tests for my OCaml projects to run on <a href="https://travis-ci.org/">Travis CI</a>, a free service for continuous integration on public GitHub projects. Although Travis has no built-in OCaml environment, it's straightforward to hijack its C environment to install OCaml and <a href="http://opam.ocamlpro.com/">OPAM</a>, then build an OCaml project and run its tests.<br/>
<br/>
<b>1.</b> Perform the <a href="http://about.travis-ci.org/docs/user/getting-started/">initial setup</a> to get Travis CI watching your GitHub repo (up to and including step two of that guide).<br/>
<br/>
<b>2.</b> Add a <span style="font-family: Courier New, Courier, monospace; font-size: x-small;">.travis.yml</span> file to the root of your repo, with these contents:<br/>
<br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;">language: c</span><br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;">script: bash -ex travis-ci.sh</span><br/>
<br/>
<b>3.</b> Fill in <span style="font-family: Courier New, Courier, monospace; font-size: x-small;">travis-ci.sh</span>, also in the repo root, with something like this:<br/>
<br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;"># OPAM version to install</span><br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;">export OPAM_VERSION=0.9.1</span><br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;"># OPAM packages needed to build tests</span><br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;">export OPAM_PACKAGES='ocamlfind ounit'</span><br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;"><br/></span>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;"># install ocaml from apt</span><br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;">sudo apt-get update -qq</span><br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;">sudo apt-get install -qq ocaml</span><br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;"><br/></span>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;"># install opam</span><br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;">curl -L https://github.com/OCamlPro/opam/archive/${OPAM_VERSION}.tar.gz | tar xz -C /tmp</span><br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;">pushd /tmp/opam-${OPAM_VERSION}</span><br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;">./configure</span><br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;">make</span><br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;">sudo make install</span><br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;">opam init</span><br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;">eval `opam config -env`</span><br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;">popd</span><br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;"><br/></span>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;"># install packages from opam</span><br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;">opam install -q -y ${OPAM_PACKAGES}</span><br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;"><br/></span>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;"># compile &amp; run tests (here assuming OASIS DevFiles)</span><br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;">./configure --enable-tests</span><br/>
<span style="font-family: Courier New, Courier, monospace; font-size: x-small;">make test</span><br/>
<div>
<br/></div>
<div>
<b>4.</b> Add and commit these two new files, and push to GitHub. Travis CI will then execute the tests.</div>
<div>
<br/></div>
<div>
Working examples:&nbsp;<a href="https://github.com/mlin/forkwork">ForkWork</a>,&nbsp;<a href="https://github.com/mlin/yajl-ocaml">yajl-ocaml</a><br/>
<br/></div>
<div>
<div>
Installing OCaml and OPAM add less than two minutes of overhead, leaving plenty of room for your tests within the stated 15-20 minute time limit for open-source builds. I'm sure the above steps could be used as the basis for an eventual OCaml+OPAM environment built-in to Travis CI.</div>
</div>
<br/>
