---
title: Irmin v2
description: "We are pleased to announce Irmin\n2.0.0, a major release of the\nGit-like
  distributed branching and storage substrate that underpins\nMirageOS\u2026"
url: https://tarides.com/blog/2019-11-21-irmin-v2
date: 2019-11-21T00:00:00-00:00
preview_image: https://tarides.com/static/d702f060cc02fbcb7329077e2d71741d/0d665/irmin2.png
featured:
---

<p>We are pleased to announce <a href="https://github.com/mirage/irmin/releases">Irmin
2.0.0</a>, a major release of the
Git-like distributed branching and storage substrate that underpins
<a href="https://mirage.io">MirageOS</a>.  We began the release process for all the
components that make up Irmin <a href="https://tarides.com/blog/2019-05-13-on-the-road-to-irmin-v2">back in May
2019</a>, and there
have been close to 1000 commits since Irmin 1.4.0 released back in June 2018. To
celebrate this milestone, we have a new logo and opened a dedicated website:
<a href="https://irmin.org">irmin.org</a>.</p>
<p>Our focus this year has been on ensuring the production success of our
early adopters -- such as the
<a href="https://gitlab.com/tezos/tezos/tree/master/src/lib_storage">Tezos</a> blockchain
and the <a href="https://github.com/moby/datakit">Datakit 9P</a>
stack -- as well as spawning new research projects into the practical
application of distributed and mergeable data stores.  We are also
very pleased to welcome several new maintainers into the Mirage
project for their contributions to Irmin, namely
<a href="https://github.com/icristescu">Ioana Cristescu</a>,
<a href="https://github.com/CraigFe">Craig Ferguson</a>,
<a href="https://github.com/andreas">Andreas Garnaes</a>,
<a href="https://github.com/pascutto">Cl&eacute;ment Pascutto</a> and
<a href="https://github.com/zshipko">Zach Shipko</a>.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#new-major-features" aria-label="new major features permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>New Major Features</h2>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#new-cli" aria-label="new cli permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>New CLI</h3>
<p>While Irmin is normally used as a library, it is obviously useful to
be able to interact with a data store from a shell.  The <code>irmin-unix</code>
opam package now provides an <code>irmin</code> binary that is configured via a
Yaml file and can perform queries and mutations against a Git store.</p>
<div class="gatsby-highlight" data-language="shell"><pre class="language-shell"><code class="language-shell">$ <span class="token builtin class-name">echo</span> <span class="token string">&quot;root: .&quot;</span> <span class="token operator">&gt;</span> irmin.yml
$ irmin init
$ irmin <span class="token builtin class-name">set</span> foo/bar <span class="token string">&quot;testing 123&quot;</span>
$ irmin get foo/bar</code></pre></div>
<p>Try <code>irmin --help</code> to see all the commands and options available.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#tezos-and-irmin-pack" aria-label="tezos and irmin pack permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Tezos and irmin-pack</h3>
<p>Another big user of Irmin is the <a href="https://tezos.com">Tezos blockchain</a>,
and we have been optimising the persistent space usage of Irmin as their
network grows.  Because Tezos doesn&rsquo;t require full Git format support,
we created a hybrid backend that grabs the best bits of Git (e.g. the
packfile mechanism) and engineered a domain-specific backend tailored
for Tezos usage. Crucially, because of the way Irmin is split into
clean libraries and OCaml modules, we only had to modify a small part
of the codebase and could also reuse elements of our
<a href="https://github.com/mirage/ocaml-git">OCaml-git</a> codebase as well.</p>
<p>The <a href="https://github.com/mirage/irmin/pull/615">irmin-pack backend</a> is available
for <a href="https://github.com/mirage/irmin/pull/888">use in the CLI</a> and provides a
significant improvement in disk usage.  There is a corresponding <a href="https://gitlab.com/tezos/tezos/merge_requests/1268">Tezos merge
request</a> using the Irmin
2.0 code that has been integrated downstream and will become available via
their release process in due course.</p>
<p>As part of this development process, we also released an efficient multi-level
index implementation (imaginatively dubbed
<a href="https://github.com/mirage/index">index</a> in opam). Our implementation takes an
arbitrary IO implementation and user-supplied content types and supplies a
standard key-value interface for persistent storage. Index provides instance
sharing by default, so each OCaml runtime shares a common singleton instance.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#irmin-graphql-and-browser-irmin" aria-label="irmin graphql and browser irmin permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Irmin-GraphQL and &ldquo;browser Irmin&rdquo;</h3>
<p>Another new area of huge interest to us is
<a href="https://graphql.org">GraphQL</a> in order to provide frontends with a rich
query language for Irmin-hosted applications.  Irmin 2.0 includes a
built-in GraphQL server so you can <a href="https://twitter.com/cuvius/status/1017136581755457539">manipulate your Git repo via
GraphQL</a>.</p>
<p>If you are interested in (for example) compiling elements of Irmin to
JavaScript or wasm, for usage in frontends, then the Irmin 2.0 release
makes it significantly easier to support this architecture.  We&rsquo;ve
already seen some exploratory efforts <a href="https://github.com/mirage/irmin/issues/681">report issues</a>
when doing this, and we&rsquo;ve had it working ourselves in <a href="http://roscidus.com/blog/blog/2015/04/28/cuekeeper-gitting-things-done-in-the-browser/">Irmin 1.0 Cuekeeper</a>
so we are excited by the potential power of applications built using
this model.  If you have ideas/questions, please get in touch on the
<a href="https://github.com/mirage/irmin/issues">issue tracker</a> with your
usecase.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#wodan" aria-label="wodan permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Wodan</h3>
<p>Irmin&rsquo;s storage layer is also well abstracted, so backends other than
a Unix filesystem or Git are supported.  Irmin can run in highly
diverse and OS-free environments, and so we began engineering the
<a href="https://github.com/mirage/wodan">Wodan filesystem</a> as a
domain-specific filesystem designed for MirageOS, Irmin and modern
flash drives.  See <a href="https://g2p.github.io/research/wodan.pdf">the OCaml Workshop 2017 abstract on
it</a> for more design
rationale.</p>
<p>As part of the Irmin 2.0 release, Wodan is also being prepared for a
release, and you can find <a href="https://github.com/mirage/wodan/tree/master/src/wodan-irmin">Irmin 2.0
support</a>
in the source.  If you&rsquo;d like a standalone block-device based
persistence environment for Irmin, please try this out.  This is the
preferred backend for using Irmin storage in a unikernel.</p>
<p>###&nbsp;Versioned CalDAV</p>
<p>An application pulling all these pieces together is being developed
by our friends at <a href="https://robur.io/About%20Us/Team">Robur</a>: an Irmin-based
<a href="https://github.com/roburio/caldav">CalDAV calendaring server</a>
that even hosts its DNS server using a versioned Irmin store.  We'll
blog more about this as the components get released and stabilised, but
the unikernel enthusiasts among you may want to browse the
<a href="https://github.com/roburio/unikernels/tree/future">Robur unikernels future branch</a>
to see how they are deploying them today.</p>
<p>A huge thank you to all our commercial customers, end users and open-source
developers who have contributed their time, expertise and
financial support to help us achieve our goal of delivering a modern
storage stack in the spirit of Git.  Our next steps for Irmin are to
continue to increase the performance and optimise the storage,
and to build more end-to-end applications using the application core
on top of MirageOS.</p>
