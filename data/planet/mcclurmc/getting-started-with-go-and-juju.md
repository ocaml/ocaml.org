---
title: Getting started with Go and Juju
description: "So this title probably doesn\u2019t even parse correctly if you haven\u2019t
  heard of Google\u2019s Go language our Ubuntu\u2019s Juju service orchestration
  software. I\u2019ve been toying wit\u2026"
url: https://mcclurmc.wordpress.com/2012/11/05/go-lang-and-juju/
date: 2012-11-05T10:07:29-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- mcclurmc
---

<p>So this title probably doesn&rsquo;t even parse correctly if you haven&rsquo;t heard of Google&rsquo;s <a href="http://golang.org/">Go language</a> our Ubuntu&rsquo;s <a href="https://juju.ubuntu.com/">Juju</a> service orchestration software. I&rsquo;ve been toying with the idea of writing a Juju service provider for the <a href="http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/">XenAPI</a>. This would allow people to use Juju to provision services on a pool of <a href="http://xen.org/products/cloudxen.html">XCP</a> or XenServer hosts. Since the Juju team have recently completed the rewrite of Juju from Python to Go, this gives me the perfect reason to teach myself Go.</p>
<p>And I had the perfect opportunity to learn both Go and Juju at last week&rsquo;s <a href="http://uds.ubuntu.com/">Ubuntu Developer Summit</a> in Copenhagen, where I got to meet most of the Juju core team. After one of the Juju planning meetings, Roger Peppe gave me a hands on intro to setting up a Go environment and building Juju. Now I&rsquo;ll share the notes I took, to help would-be Go/Juju hackers to get started. (This isn&rsquo;t an introduction to the Go language, by the way. This is just instructions for setting up the tools necessary for compiling Juju. Check out the <a href="http://tour.golang.org/#1">Go Tour</a> for help learning Go.)</p>
<p>The first thing to do, of course, is to install Go:</p>
<pre class="brush: plain; title: ; notranslate">
# Install go
sudo aptitude install golang golang-mode
</pre>
<p>I haven&rsquo;t been able to get Vim to highlight my Go files, but Emacs and golang-mode work. I&rsquo;ve managed to get go-mode confused a bit, though, including one weird hang that forced me to kill Emacs.</p>
<p>It turns out that Go isn&rsquo;t just a compiler, it&rsquo;s an entire packaging system too. So before you start using Go, you&rsquo;ll need to set up your GOPATH environment variable to point to some directory (any directory will do; I put mine in ~/go). This is where all your Go source code and compiled binaries will live.</p>
<pre class="brush: plain; title: ; notranslate">
# Set up go environment (add this to .bashrc)
export GOPATH=~/go
export PATH=${GOPATH}/go/bin:${PATH}
</pre>
<p>Here&rsquo;s where the package management system comes in. Instead of doing a &lsquo;bzr clone lp:juju-core&rsquo; like I imagined I would, instead you tell Go to go fetch your source code:</p>
<pre class="brush: plain; title: ; notranslate">
# Get juju-core and its dependencies
go get -v launchpad.net/juju-core/...
</pre>
<p>This will tell Go to go to Launchpad and fetch everything under the juju-core path. It will even use bzr to clone the source repo, so you can make changes and commit back to Launchpad. Note the use of the &lsquo;&hellip;&rsquo; wildcard feature. This will match any path after juju-core/. You could also put the &lsquo;&hellip;&rsquo; characters in the middle of a path, as in foo/&hellip;/bar, and it will match paths such as foo/baz/bar and foo/boz/buz/bar. This reminds me a bit of Xpath&rsquo;s &lsquo;//&rsquo; search feature.</p>
<p>Juju-core isn&rsquo;t the only thing that Go downloaded for us. Go ahead and check out your $GOPATH/src directory. There should be a directory called launchpad.net which contains juju-core, but there will also be another directory called labix.org. Where did this come from? It turns out that Go will scan the source files it downloads looking for external dependencies. If those dependencies are prefixed with a network address, go will try to download those as well.</p>
<p>I&rsquo;m not sure how I feel about this, to be honest. It&rsquo;s pretty cool that it can just go out and find dependencies. But how does it deal with version pinning? I&rsquo;m sure there&rsquo;s a good answer to this out there somewhere. (Update: Rog Peppe tells me that the standard way to do this is to encode versions in the library path. I wonder if this would work with a git branch on Github&hellip;)</p>
<p>The &lsquo;go get&rsquo; command both fetched the Juju source and built and installed it. To see how to build Go source on your own, we&rsquo;ll nuke the compiled libraries and tell Go to build and install them again.</p>
<pre class="brush: plain; title: ; notranslate">
# Build and install Juju
rm -rf ${GOPATH}/pkg/linux_amd64/launchpad.net/
cd ${GOPATH}/src/launchpad.net/juju-core
go install ./...
</pre>
<p>One of the best things about Go (and the primary reason Rob Pike developed Go, actually) is the fast compile times. That command above took less than 9 seconds on my laptop. That&rsquo;s all it takes for Go to compile all the juju-core source code, and all its external depedencies. Doing a quick and dirty &lsquo;find ${GOPATH}/src -name &ldquo;*.go&rdquo; | xargs sed &lsquo;/^\s*\/\//d;/^\s*$/d&rsquo; | wc -l&rsquo; gives me 72135 lines of code, so 9 seconds sounds pretty good.</p>
<p>Go also has a great online help feature. Not only can you get help on the core tools through man pages, but you can get library docs &mdash; even for libraries you just downloaded &mdash; using the &lsquo;godoc&rsquo; command. Here&rsquo;s documentation for the entire ec2 package:</p>
<pre class="brush: plain; title: ; notranslate">
# Check out documentation for a package
go doc launchpad.net/.../ec2
</pre>
<p>And here&rsquo;s documentation for a particular exported name of that package:</p>
<pre class="brush: plain; title: ; notranslate">
# Documentation for a type or function (notice we call godoc directly)
godoc launchpad.net/goamz/ec2 Instance
</pre>
<p>If you&rsquo;d rather read your package docs on the web, a great resource is <a href="http://go.pkgdoc.org/">http://go.pkgdoc.org/</a>, which has docs for the standard library as well as many, many third party libraries.</p>
<p>Go will also format your code for you. You can run &lsquo;go fmt &lt;file.go&gt;&rsquo; to format a file in place, or use &lsquo;M-x gofmt&rsquo; in Emacs. I really should bind that to a shortcut.</p>
<pre class="brush: plain; title: ; notranslate">
# Reformat your code
go fmt &lt;file.go&gt;
</pre>
<p>And on top of all that, Go also has a built in test framework. Files which end with _test.go are special and are considered test cases. You can use the command &lsquo;go test&rsquo; to build and execute these tests. There is a built in unit testing library which I won&rsquo;t cover here (because I don&rsquo;t know now to use it yet).</p>
<pre class="brush: plain; title: ; notranslate">
# Run tests in a given directory
go test
</pre>
<p>So that&rsquo;s all you need to get started with Go development for Juju. For a good tutorial on bootstrapping Juju, you can take a look at Juju&rsquo;s <a href="https://juju.ubuntu.com/docs/getting-started.html">Getting Started</a> document.</p>
<p>I&rsquo;ll hopefully follow this blog up with a status report on my XenAPI service provider for Juju, and how I&rsquo;ve modified <a href="https://github.com/kolo/xmlrpc">Dmitry Maksimov&rsquo;s</a> XMLRPC library to work with the XenAPI.</p>

