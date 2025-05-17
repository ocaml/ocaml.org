---
title: How to publish custom Homebrew taps for OCaml
description: Publish custom OCaml Homebrew taps with a simple GitHub workflow.
url: https://anil.recoil.org/notes/custom-homebrew-taps
date: 2025-01-31T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p>Now that I've <a href="https://anil.recoil.org/notes/bushel-lives">switched</a> to a new website, I'm working on open-sourcing its components. I've got a lot of small OCaml scripts that are all work-in-progress, and so not quite suitable to be published to the <a href="https://github.com/ocaml/opam-repository">central opam-repository</a> but I still need be able to run them conveniently on my own <a href="https://anil.recoil.org/news.xml">self-hosted</a> infrastructure.</p>
<p>I mainly use a variety of macOS and Linux hosts<sup><a href="https://anil.recoil.org/news.xml#fn-1" role="doc-noteref" class="fn-label">[1]</a></sup> and I want a workflow as simple as "<code>brew install avsm/ocaml/srcsetter</code>" and have it install a working binary version of my CLI utility. In this case, it's <a href="https://github.com/avsm/srcsetter">srcsetter</a>, a simple tool I knocked up to generate the <a href="https://developer.mozilla.org/en-US/docs/Web/HTML/Responsive_images">responsive images</a> on this website. Luckily, Homebrew has made this <em>really</em> easy for us! They have a <a href="https://docs.brew.sh/BrewTestBot">BrewTestBot</a> that integrates with GitHub Actions to automate the compilation of binary packages for us, all from a convenient PR-like workflow.</p>
<p>First, we need to set up a GitHub Homebrew "tap" repository. Mine is <a href="https://github.com/avsm/homebrew-ocaml">avsm/homebrew-ocaml</a> which allows for the tap to be referred to as <code>avsm/ocaml</code> (Homebrew special-cases these to expand to the full GitHub repository). We then add in a couple of GitHub Actions to activate the testbot:</p>
<ul>
<li><a href="https://github.com/avsm/homebrew-ocaml/blob/main/.github/workflows/tests.yml">.github/workflows/tests.yml</a> runs in response to pull requests to that repository and does a full Brew build of the package.</li>
<li><a href="https://github.com/avsm/homebrew-ocaml/blob/main/.github/workflows/publish.yml">.github/workflows/publish.yml</a> allows us to simply add a <code>pr-pull</code> label to a successful PR and have it be merged automatically by the bot.</li>
</ul>
<p>Secondly, we need to create a Homebrew package for the opam package. For this, I just added a very simple script to the srcsetter repository called <a href="https://github.com/avsm/srcsetter/blob/main/.opambuild.sh">.opambuild.sh</a> which builds a local binary using a temporary opam installation. In the future, we should be able to use <a href="https://preview.dune.build">dune package management</a> to remove the need for this script, but I'm blocked on some <a href="https://github.com/ocaml/dune/issues/11405">teething issues</a> there in the short-term.</p>
<pre><code>export OPAMROOT=`pwd`/_opamroot
export OPAMYES=1
export OPAMCONFIRMLEVEL=unsafe-yes
opam init -ny --disable-sandboxing
opam switch create . 
opam exec -- dune build --profile=release
</code></pre>
<p>Once this is present in the repository we're building, I just need to <a href="https://github.com/avsm/homebrew-ocaml/pull/2">open a pull request</a> with the Homebrew <a href="https://docs.brew.sh/Formula-Cookbook">formula</a> for my CLI tool.</p>
<pre><code>class Srcsetter &lt; Formula
  desc "Webp image generator for responsive HTML sites"
  homepage "https://github.com/avsm/srcsetter/"
  url "https://github.com/avsm/srcsetter.git", branch: "main"
  version "0.0.1"
  license "ISC"

  depends_on "gpatch"
  depends_on "opam"

  def install
    system "bash", "./.opambuild.sh"
    bin.install "_opam/bin/srcsetter"
  end
end
</code></pre>
<p>The formula is fairly self-explanatory: I just point Homebrew at the source repository, give it some descriptive metadata, and tell it to invoke the binary build script and make the sole resulting binary available as the contents of the package.  At this point, the BrewBot will run against the PR and report any build failures on both macOS and Ubuntu. Most of these were swiftly fixed by running <code>brew style</code> (as instructed in the build failures) to take of fairly minor issues.</p>
<p></p><figure class="image-center"><img src="https://anil.recoil.org/images/gh-brewbot-screen.webp" loading="lazy" class="content-image" alt="" srcset="/images/gh-brewbot-screen.1024.webp 1024w,/images/gh-brewbot-screen.1280.webp 1280w,/images/gh-brewbot-screen.1440.webp 1440w,/images/gh-brewbot-screen.1600.webp 1600w,/images/gh-brewbot-screen.1920.webp 1920w,/images/gh-brewbot-screen.320.webp 320w,/images/gh-brewbot-screen.480.webp 480w,/images/gh-brewbot-screen.640.webp 640w,/images/gh-brewbot-screen.768.webp 768w" title="" sizes="(max-width: 768px) 100vw, 33vw"><figcaption></figcaption></figure>
<p></p>
<p>When the PR went green, all I then had to do was to add the <code>pr-pull</code> label, and the bot takes care of uploading the binary artefacts to my <a href="https://github.com/avsm/homebrew-ocaml/releases/tag/srcsetter-0.0.1">homebrew tap repo</a> and merging the PR. It also takes care of adding checksums to the merged Formula, so what actually got merged is:</p>
<pre><code>class Srcsetter &lt; Formula
  desc "Webp image generator for responsive HTML sites"
  homepage "https://github.com/avsm/srcsetter/"
  url "https://github.com/avsm/srcsetter.git", branch: "main"
  version "0.0.1"
  license "ISC"

  bottle do
    root_url "https://github.com/avsm/homebrew-ocaml/releases/download/srcsetter-0.0.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3e1289965d8bcf086db06b18e6c2865f9949a9e1202b8fafa640f3e363b6bd4"
    sha256 cellar: :any_skip_relocation, ventura:       "9b61e8e4be5f777e3ef98672f275909a80c3cc3f82d6886ca1a90b66ea7bb9f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8279f11f30edf865368a3c6f63d811d31c1a9ca019ef86e93afeb6624232850"
  end

  depends_on "gpatch"
  depends_on "opam"

  def install
    system "bash", "./.opambuild.sh"
    bin.install "_opam/bin/srcsetter"
  end
end
</code></pre>
<p>The end result is that <code>brew install avsm/ocaml/srcsetter</code> now works, without me having to cut a release of the tool more centrally. I'd love to incorporate some aspects of this workflow into the OCaml opam-repository, as users are currently responsible for the checksumming generation themselves via <a href="https://discuss.ocaml.org/t/dune-release-version-1-4-0-released/6103">dune-release</a> or <a href="https://opam.ocaml.org/doc/Packaging.html">opam-publish</a>. It's an interesting twist to automate this part of the process and let the humans focus on the core package metadata instead. Thanks for all the help, Brewbot!</p>
<section role="doc-endnotes"><ol>
<li>
<p>Let's leave <a href="https://anil.recoil.org/news.xml">OpenBSD</a> support to another day!</p>
<span><a href="https://anil.recoil.org/news.xml#ref-1-fn-1" role="doc-backlink" class="fn-label">↩︎︎</a></span></li></ol></section>

