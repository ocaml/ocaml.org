---
title: MirageOS v2.5 with full TLS support
description:
url: https://mirage.io/blog/announcing-mirage-25-release
date: 2015-06-26T00:00:00-00:00
preview_image:
featured:
authors:
- Amir Chaudhry
---


        <p>Today we're announcing the new release of MirageOS v2.5, which includes
first-class support for SSL/TLS in the MirageOS configuration language. We
introduced the pure OCaml implementation of
<a href="https://mirage.io/blog/introducing-ocaml-tls">transport layer security (TLS)</a> last summer and have been working since
then to improve the integration and create a robust framework.  The recent
releases allow developers to easily build and deploy secure unikernel services
and we've also incorporated numerous bug-fixes and major stability
improvements (especially in the network stack).  The full list of changes is
available on the <a href="https://mirage.io/releases">releases</a> page and the <a href="https://mirage.io/wiki/breaking-changes">breaking API changes</a>
now have their own page.</p>
<p>Over the coming week, we'll share more about the TLS stack by diving into the
results of the <a href="https://mirage.io/blog/announcing-bitcoin-pinata">Bitcoin Pi&ntilde;ata</a>, describing a new workflow for
building secure static sites, and discussing insights on entropy in
virtualised environments.</p>
<p>In the rest of this post, we'll cover why OCaml-TLS matters (and link to some
tools), mention our new domain name, and mention our security advisory
process.</p>
<h3>Why OCaml-TLS matters</h3>
<p>The last year has seen a slew of security flaws, which are even reaching the
mainstream news.  This history of flaws are often the result of implementation
errors and stem from the underlying challenges of interpreting ambiguous
specifications, the complexities of large APIs and code bases, and the use of
unsafe programming practices.  Re-engineering security-critical software
allows the opportunity to use modern approaches to prevent these recurring
issues. In a <a href="https://mirage.io/blog/why-ocaml-tls">separate post</a>, we cover some of the benefits of
re-engineering TLS in OCaml.</p>
<h4>TLS Unix Tools</h4>
<p>To make it even easier to start benefiting from OCaml-TLS, we've also made a
collection of <a href="https://mirage.io/wiki/tls-unix">TLS unix tools</a>.  These are designed to make it
really easy to use a good portion of the stack without having to use Xen. For
example, Unix <code>tlstunnel</code> is being used on <a href="https://realworldocaml.org">https://realworldocaml.org</a>. If
you have <code>stunnel</code> or <code>stud</code> in use somewhere, then replacing it with the
<code>tlstunnel</code> binary is an easy way to try things out.  Please do give this a go
and send us feedback!</p>
<h3>openmirage.org -&gt; mirage.io</h3>
<p>We've also switched our domain over to <strong><a href="https://mirage.io">https://mirage.io</a></strong>, which is a
unikernel running the full stack. We've been discussing this transition for a
while on our <a href="https://mirage.io/wiki/#Weekly-calls-and-release-notes">fortnightly calls</a> and have actually been running this
unikernel in parallel for a while. Setting things up this way has allowed us
to stress test things in the wild and we've made big improvements to the
networking stack as a result.</p>
<p>We now have end-to-end deployments for our secure-site unikernels, which is
largely automated -- going from <code>git push</code> all the way to live site. You can
get an idea of the workflows we have set up by looking over the following
links:</p>
<ul>
<li><a href="http://amirchaudhry.com/heroku-for-unikernels-pt1">Automated unikernel deployment</a> -- Description of the end-to-end flow for one of our sites.
</li>
<li><a href="https://github.com/mirage/mirage-www-deployment">mirage-www-deployment repo</a> -- The repo from which we pull the site you're currently reading! You might find the scripts useful.
</li>
</ul>
<h3>Security disclosure process</h3>
<p>Since we're incorporating more security features, it's important to consider
the process of disclosing issues to us.  Many bugs can be reported as usual on
our <a href="https://github.com/mirage/mirage/issues">issue tracker</a> but if you think you've discovered a
<strong>security vulnerability</strong>, the best way to inform us is described on a new
page at <strong><a href="https://mirage.io/security">https://mirage.io/security</a></strong>.</p>
<h3>Get started!</h3>
<p>As usual, MirageOS v2.5 and the its ever-growing collection of
libraries is packaged with the <a href="https://opam.ocaml.org">OPAM</a> package
manager, so look over the <a href="https://mirage.io/wiki/install">installation instructions</a>
and run <code>opam install mirage</code> to get the command-line
tool. To update from a previously installed version of MirageOS,
simply use the normal workflow to upgrade your packages by using <code>opam update -u</code> (you should do this regularly to benefit from ongoing fixes).
If you're looking for inspiration, you can check out the examples on
<a href="https://github.com/mirage/mirage-skeleton">mirage-skeleton</a> or ask on the <a href="https://mirage.io/community">mailing list</a>. Please do be aware
that existing <code>config.ml</code> files using
the <code>conduit</code> and <code>http</code> constructors might need to be updated -- we've made a
page of <a href="https://mirage.io/wiki/breaking-changes">backward incompatible changes</a> to explain what you need to
do.</p>
<p>We would love to hear your feedback on this release, either on our
<a href="https://github.com/mirage/mirage/issues">issue tracker</a> or <a href="https://mirage.io/community">our mailing lists</a>!</p>

      
