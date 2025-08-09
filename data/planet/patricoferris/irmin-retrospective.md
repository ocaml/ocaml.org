---
title: Irmin Retrospective
description:
url: https://patrick.sirref.org/irmin-retro/
date: 2025-08-07T00:00:00-00:00
preview_image:
authors:
- https://patrick.sirref.org/Patrick%20Ferris/
source:
ignore:
---


        <p><a href="https://patrick.sirref.org/irmin/">Irmin</a> is an OCaml library for building <em>branchable</em> and <em>mergeable</em> data stores. The data is <em>mergeable</em> in the sense of <a href="https://patrick.sirref.org/kcrsk-mrdts-2022/">mergeable replicated data types</a>.</p>
        <p>I have been using Irmin for over five years to build different kinds of interesting data stores including:</p>
        <ul>
          <li>
            <p>A <a href="https://github.com/patricoferris/omditor">simple markdown-based note-taking web application</a>.</p>
          </li>
          <li>
            <p>A <a href="https://github.com/carboncredits/retirement-db">content-addressed database</a>.</p>
          </li>
          <li>
            <p>Mentoring an intern who <a href="https://tarides.com/blog/2022-08-02-irmin-in-the-browser/">worked on Irmin in the browser</a>.</p>
          </li>
          <li>
            <p>Most recently, an <a href="https://patrick.sirref.org/shelter/">Irmin-backed shell session manager</a>.</p>
          </li>
        </ul>
        <p>I was asked to provide some feedback recently on <a href="https://patrick.sirref.org/irmin/">Irmin</a>, so I thought writing a little retrospective here would be a good way to do that. The remit for the retrospective was about improving <a href="https://patrick.sirref.org/irmin/">Irmin</a>, so the content is focussed on pain points and areas of improvement.</p>
        <pre class="hilite">          <code><span class="ocaml-comment-block">(* </span><span class="ocaml-comment-block"> An in-memory Irmin store </span><span class="ocaml-comment-block">*) </span><span class="ocaml-source">
</span>
<span class="ocaml-keyword-other">module</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Store</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Irmin_mem</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-constant-language-capital-identifier">KV</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-constant-language-capital-identifier">Make</span><span class="ocaml-source">( </span><span class="ocaml-constant-language-capital-identifier">Irmin</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-constant-language-capital-identifier">Contents</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-constant-language-capital-identifier">String</span><span class="ocaml-source">) </span><span class="ocaml-source">
</span></code>
        </pre>
        <section>
          <header>
            <h2>What is Irmin?</h2>
          </header>
          <p><a href="https://patrick.sirref.org/irmin/">Irmin</a>, at its simplest, is a key-value database. Users associate keys with values and can query and update these bindings.</p>
          <p>Additionally, this database supports versioning. This means independent snapshots of the database can coexist and users can switch between them and update them without fear of interfering with other versions.</p>
          <p>Different versions of the database can be combined by <em>merging</em>. When you set up your instance of an <a href="https://patrick.sirref.org/irmin/">Irmin</a> database, you also provide it with a <a href="https://patrick.sirref.org/kcrsk-mrdts-2022/">merge function</a>.</p>
          <pre class="hilite">            <code><span class="ocaml-keyword-other">#</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other">#</span><span class="ocaml-source">show_type</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Irmin</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-constant-language-capital-identifier">Merge</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">f</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source">
</span>
<span class="ocaml-keyword-other">type</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other">nonrec</span><span class="ocaml-source"> </span><span class="ocaml-storage-type">'a</span><span class="ocaml-source"> </span><span class="ocaml-source">f</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source">
</span>
<span class="ocaml-source">    </span><span class="ocaml-source">old</span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-storage-type">'a</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Irmin</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-constant-language-capital-identifier">Merge</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">promise</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">-&gt;</span><span class="ocaml-source">
</span>
<span class="ocaml-source">    </span><span class="ocaml-storage-type">'a</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">-&gt;</span><span class="ocaml-source"> </span><span class="ocaml-storage-type">'a</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">-&gt;</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-storage-type">'a</span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Irmin</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-constant-language-capital-identifier">Merge</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">conflict</span><span class="ocaml-source">) </span><span class="ocaml-source"> </span><span class="ocaml-source">result</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Lwt</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">t</span><span class="ocaml-source">
</span></code>
          </pre>
        </section>
        <section>
          <header>
            <h2>Design and API</h2>
          </header>
          <p><a href="https://patrick.sirref.org/irmin/">Irmin</a>'s API is very git-inspired. There is a large overlap of shared vocabulary and concepts: <em>repositories</em>, <em>branches</em>, <em>commits</em>, <em>heads</em> etc.</p>
          <p>Probably the most confusing aspect of this is the notion of a <code>Store</code>. When I was describing <a href="https://patrick.sirref.org/irmin/">Irmin</a> above, I used the term <em>database</em> to help distinguish between some of these concepts. In Irmin's documentation, it is used for multiple related (but different) concepts. In " <a href="https://irmin.org/tutorial/getting-started/creating-a-store">Creating a Store</a>" stores refer to the entire database, whereas in the <a href="https://patrick.sirref.org/irmin/">Irmin</a> API docs we have that:</p>
          <blockquote>
            <p>There are two kinds of store in Irmin: the ones based on persistent named branches and the ones based temporary detached heads.</p>
          </blockquote>
          <p>For <a href="https://patrick.sirref.org/irmin/">Irmin</a> library users, a <code>Store.t</code> can be thought of as a checkout of the database at a particular revision. This may be from a branch or a specific commit.</p>
          <pre class="hilite">            <code><span class="ocaml-keyword-other">#</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Store</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">of_branch</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source">
</span>
<span class="ocaml-keyword-operator">-</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Store</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">repo</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">-&gt;</span><span class="ocaml-source"> </span><span class="ocaml-support-type">string</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">-&gt;</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Store</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">t</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Lwt</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">t</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">&lt;</span><span class="ocaml-keyword-other">fun</span><span class="ocaml-keyword-operator">&gt;</span><span class="ocaml-source">
</span>
<span class="ocaml-keyword-other">#</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Store</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">of_commit</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source">
</span>
<span class="ocaml-keyword-operator">-</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Store</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">commit</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">-&gt;</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Store</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">t</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Lwt</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">t</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">&lt;</span><span class="ocaml-keyword-other">fun</span><span class="ocaml-keyword-operator">&gt;</span><span class="ocaml-source">
</span></code>
          </pre>
          <p>The overloading of the term is confusing. I think it leaves users unsure about what other people might mean when they say "store". Being careful with these terms, and the contexts in which they are used, would help avoid this confusion.</p>
          <section>
            <header>
              <h3>Module and Functor Soup</h3>
            </header>
            <p>Undoubtedly for a majority of use-cases and users, <a href="https://patrick.sirref.org/irmin/">Irmin</a> is over-functorised. Nearly every module requires that you must apply some functor to access any useful code. In general, a user will have to interact with the <a href="https://mirage.github.io/irmin/irmin/Irmin/module-type-S/Schema/index.html"><code>Schema</code> module</a> when describing the types they want to instantiate their store with.</p>
            <p>To counteract this, Irmin has plenty of <code>KV</code> modules that provide a <code>Make</code> functor that only requires a user to provide a suitable <em>content</em> module for their store (i.e. something that provides a type, a runtime representation  of that type and a merge function).</p>
            <pre class="hilite">              <code><span class="ocaml-keyword-other">#</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other">#</span><span class="ocaml-source">show_module</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Irmin_mem</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-constant-language-capital-identifier">KV</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source">
</span>
<span class="ocaml-keyword-other">module</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">KV</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-keyword-other">sig</span><span class="ocaml-source">
</span>
<span class="ocaml-source">    </span><span class="ocaml-keyword">type</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">endpoint</span><span class="ocaml-source"> = unit
</span>
<span class="ocaml-source">    </span><span class="ocaml-keyword">type</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">metadata</span><span class="ocaml-source"> = unit
</span>
<span class="ocaml-source">    </span><span class="ocaml-keyword">type</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">hash</span><span class="ocaml-source">
</span>
<span class="ocaml-source">    </span><span class="ocaml-keyword">type</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">info</span><span class="ocaml-source"> = Store.info
</span>
<span class="ocaml-source">    </span><span class="ocaml-keyword">type</span><span class="ocaml-source"> </span><span class="ocaml-source">('h, _) </span><span class="ocaml-entity-name-function-binding">contents_key</span><span class="ocaml-source"> = 'h
</span>
<span class="ocaml-source">    </span><span class="ocaml-keyword">type</span><span class="ocaml-source"> </span><span class="ocaml-source">'h </span><span class="ocaml-entity-name-function-binding">node_key</span><span class="ocaml-source"> = 'h
</span>
<span class="ocaml-source">    </span><span class="ocaml-keyword">type</span><span class="ocaml-source"> </span><span class="ocaml-source">'h </span><span class="ocaml-entity-name-function-binding">commit_key</span><span class="ocaml-source"> = 'h
</span>
<span class="ocaml-source">    </span><span class="ocaml-keyword-other-ocaml">module</span><span class="ocaml-source"> Make : (C : Irmin__.Contents.S) -&gt; </span><span class="ocaml-keyword-other-ocaml">sig</span><span class="ocaml-source"> ... </span><span class="ocaml-keyword-other">end</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-keyword-other">end</span><span class="ocaml-source">
</span></code>
            </pre>
            <p>I think it is fair to say the documentation is hard to follow as it is a module and functor soup. For example, looking at <code>irmin.3.11.0</code>, starting at <a href="https://ocaml.org/p/irmin/latest/doc/index.html">the toplevel documentation page</a> our path to finding this paricular module and functor is as follows:</p>
            <ol>
              <li>
                <p>We jump into <a href="https://ocaml.org/p/irmin/latest/doc/irmin.mem/Irmin_mem/index.html"><code>Irmin_mem</code></a> from the nicely written landing page.</p>
              </li>
              <li>
                <p>We scroll down to find <a href="https://ocaml.org/p/irmin/latest/doc/irmin.mem/Irmin_mem/index.html%23module-KV">the KV module</a>.</p>
              </li>
              <li>
                <p>We now make sense of the module's signature by following the <a href="https://ocaml.org/p/irmin/latest/doc/irmin/Irmin/module-type-KV_maker/index.html">KV_maker link</a>.</p>
              </li>
              <li>
                <p>We see a <code>Make (C : Contents.S) : sig ... end</code> at the end of the module, and <a href="https://ocaml.org/p/irmin/latest/doc/irmin/Irmin/module-type-KV_maker/Make/index.html%23module-Schema">we navigate through that</a>.</p>
              </li>
              <li>
                <p>Finally we have come to our journey's end, and find the <a href="https://ocaml.org/p/irmin/latest/doc/irmin/Irmin/module-type-KV_maker/Make/index.html%23module-Schema">schema module</a> with type constraints like <code>type Branch.t = string</code>.</p>
              </li>
            </ol>
            <p>There is a big assumption there that you know what the <code>Schema</code> module is telling you and how it relates to your "store".</p>
            <p>There is a counter-argument here, in that Irmin is incredibly flexible in terms of what you can use as types for your keys, branches, hashes etc. I was quite easily able to produce <a href="https://github.com/patricoferris/ocaml-cid/blob/main/test/irmin_cid.ml">Irmin stores that use CIDs (self-describing content identifiers) </a> for example.</p>
            <p>I think there is a middle ground. For Irmin to be usable it needs to reduce the complexity of the API. The complexity is due to, in large part, over-functorisation. If the functors cannot be removed then perhaps better documentation or more <a href="https://ocaml.org/p/irmin-containers/latest/doc/irmin-containers/Irmin_containers/index.html">introductory libraries like irmin-containers</a> would be helpful. Perhaps a <em>standalone</em> library that acts as an interface to Irmin stores would be helpful. I find myself time and again implementing <a href="https://github.com/fn06/shelter/blob/main/src/lib/store.ml">something like that</a>.</p>
          </section>
          <section>
            <header>
              <h3>Backends Galore</h3>
            </header>
            <p>Irmin has plenty of backends including <a href="https://ocaml.org/p/irmin-git/latest">a git-compatible one</a>, <a href="https://ocaml.org/p/irmin-mirage/latest">a MirageOS backend</a>, <a href="https://ocaml.org/p/irmin-indexeddb/latest">an in-browser IndexedDB backend</a> and even a <a href="https://github.com/andreas/irmin-fdb">FoundationDB backend</a>.</p>
            <p><a href="https://patrick.sirref.org/irmin/">Irmin</a> needs to have fewer, better tested backends. Of course, some of these are likely driven by funding and use-case specific details. However, I think by focusing on a few key backends and striving for solid performance but also strong consitency guarantees, <a href="https://patrick.sirref.org/irmin/">Irmin</a> would become a more viable candidate for potential users. I also believe the browser backend plays a key part to making this work in order to facilate <a href="https://lofi.so/">local-first applications</a>.</p>
          </section>
          <section>
            <header>
              <h3>Syncing Remote Stores</h3>
            </header>
            <p>The <a href="https://ocaml.org/p/irmin/3.11.0/doc/irmin/Irmin/Sync/index.html">synchronisation mechanisms in Irmin</a> are powerful, but often the API is very confusing. For example, with the git-compatible Unix backend, nested deep in the documentation is the function required to create a <a href="https://ocaml.org/p/irmin-git/latest/doc/irmin-git.unix/Irmin_git_unix/Maker/Make/index.html%23val-remote">remote endpoint</a>. Once they have found this function, using it is not easy as it requires them to learn about the <a href="https://ocaml.org/p/mimic/latest"><code>Mimic.ctx</code></a>, which is an abstraction of the networking stack!</p>
          </section>
          <section>
            <header>
              <h3>Do Fewer Things and Do Them Well</h3>
            </header>
            <p>Irmin is simultaneously a database that supports: content-addressing, merging, key-value lookup, branches, transactions, complete OS portability etc. I think, in short, it tries to do too many things and comes up short on some of them in ways that really matter.</p>
            <p>When building the <a href="https://github.com/carboncredits/retirement-db">content-addressed database</a> I needed strong guarantees about some atomic actions to perform on the underlying store. For example, <a href="https://github.com/mirage/irmin/issues/2073">setting the value and accessing the commit associated with it</a> which was not possible with the API at that time in an atomic way. This kind of missing functionality is probably only understood after users stumble across it, but it also makes the library feel less focused and ready for production use-cases.</p>
          </section>
        </section>
        <section>
          <header>
            <h2>Documentation</h2>
          </header>
          <p>It will probably come as no surprise that one of the main limitations of using <a href="https://patrick.sirref.org/irmin/">Irmin</a> is the lack of documentation and tutorials. This is a particular pain point as the API is not very straightforward.</p>
          <p>A while back, I started an <a href="https://patricoferris.github.io/irmin-book/">Irmin book</a> intending to help document the kinds of things real-world users would need in order to use <a href="https://patrick.sirref.org/irmin/">Irmin</a> in earnest. For example: ways to <a href="https://patricoferris.github.io/irmin-book/contents/versioned-data.html">deal with type migrations</a> or <a href="https://patricoferris.github.io/irmin-book/arch/runtime-types.html">primers on runtime types</a>. I still believe this sort of work would be invaluable, but there is a large cost to completing it, and it is not clear if there is enough interest in the project to warrant such an effort.</p>
          <p>The <a href="https://irmin.org/tutorial/introduction/">tutorials on the irmin website</a> are still good starting points for most new users. But they quickly lack the depth for real-world scenarios.</p>
        </section>
        <section>
          <header>
            <h2>Feature Wishlist</h2>
          </header>
          <p>What follows are additional ideas for improving <a href="https://patrick.sirref.org/irmin/">Irmin</a>.</p>
          <section>
            <header>
              <h3>Heterogeneous Stores</h3>
            </header>
            <p>For all of [Irmin]'s abstraction and functorisation, there is a very clear  missing feature for lots of first-time users of the library: you can only store values of a single type.</p>
            <p>This leads to a few common workarounds:</p>
            <ul>
              <li>
                <p>Storing a serealised version of your values, essentially escaping the type-system and implementing a form of dynamic typing.</p>
              </li>
              <li>
                <p>Growing your value to hold lots of different types via some large variant type.</p>
              </li>
            </ul>
            <p>Both of these options are feasible and have been used in practice. However, they are workarounds. A long time ago <a href="https://craigfe.io/">CraigFe</a> created an <a href="https://github.com/mirage/irmin/issues/909">RFC for heterogeneous stores</a>, which I think about a lot. The main idea is to augment <a href="https://patrick.sirref.org/irmin/">Irmin</a> paths (keys)  to be GADTs that carry type information about the kinds of values they access (similar to <a href="https://ocaml.org/p/hmap">heterogeneuous variants of other data structures</a>). Something like this alongside a simplified  API would make Irmin more appealing as a library for persistent data storage.</p>
          </section>
          <section>
            <header>
              <h3>Real-world Retrospectives</h3>
            </header>
            <p>This echos some thoughts from the <em>Documentation</em> section. There are some very real-world <a href="https://patrick.sirref.org/irmin/">Irmin</a> use-cases out there. For example, for a long time (I'm not  sure if this is still the case) parts of the <a href="https://ocaml.org/p/tezos-context/latestdependencies">Tezos blockchain were using Irmin</a> which uses the <a href="https://ocaml.org/p/irmin-pack/latest">irmin-pack</a> backend. Does this make irmin-pack the best tested backend and perhaps should be the default backend for new users? Or is it hyper-specific to the Tezos use case? There are <a href="https://tarides.com/blog/2020-09-01-introducing-irmin-pack/">blogs on tarides.com about the irmin-pack backend</a>, but they might be outdated and should not be the first place to find advice on which Irmin backend to use.</p>
          </section>
          <section>
            <header>
              <h3>Active Development and Engagement</h3>
            </header>
            <p>As far as I know, <a href="https://patrick.sirref.org/irmin/">Irmin</a> was at the forefront of technologies that have come to be described as <a href="https://lofi.so/">local-first</a>. There is a growing interest in this area (particularly as it acts as a counter-argument to an increasingly  online, centralised model). I highly recommend reading <a href="https://patrick.sirref.org/ink%20&amp;%20switch's%20essay%20on%20the%20matter/">Ink &amp; Switch's essay on the matter</a>. And it would be great to see more research via <a href="https://patrick.sirref.org/irmin/">Irmin</a> at things like <a href="https://lu.ma/localfirstswunconf-stlouis">the lofi unconference</a> and the <a href="https://2023.splashcon.org/home/plf-2023">PLF workshop at SPLASH 2023</a>!</p>
            <p>Thank you for reading! And thank you to all the <a href="https://patrick.sirref.org/irmin/">Irmin</a> contributors. I hope this might be useful in the future for building the next-generation <a href="https://patrick.sirref.org/irmin/">Irmin</a>!</p>
          </section>
        </section>
      
