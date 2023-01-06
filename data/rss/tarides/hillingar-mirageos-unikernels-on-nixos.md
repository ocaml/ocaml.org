---
title: 'Hillingar: MirageOS Unikernels on NixOS'
description: "NixOS allows reproducible deployments of systems by managing configuration
  declaratively.\nMirageOS is a unikernel creation framework that\u2026"
url: https://tarides.com/blog/2022-12-14-hillingar-mirageos-unikernels-on-nixos
date: 2022-12-14T00:00:00-00:00
preview_image: https://tarides.com/static/ba47ed1e2b7a5e9dc869229c7e9e073f/d6138/hillingar.png
featured:
---



<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 512px; ">
      <a href="https://tarides.com/static/ba47ed1e2b7a5e9dc869229c7e9e073f/01e7c/hillingar.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 100%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAACXBIWXMAAAsTAAALEwEAmpwYAAAE9ElEQVQ4yzXQWXMa2RnG8f4YqUqlKrmZm9xlKpl4PLJjLdbEWkDWyMZazCYWIYRYJLFoYdGCFmIksTSigabphkaskj2Z3Hiqknyxf8q4cvGr51yc87xvHeE6e8f55R3xY5HkicjxqUj6vMRNViL7ocJ19isxJ1ErStRKErmcxPGFRCZbpSzKZG7q3OTrVMsywvF5mZNzifSlxNlFhfSFxGWmSiEnIxbqI5VSnVqpSk2sUi/XyN7IJC9kLq8b1KotdLXFvdqkrWgIV5kq19kqYq6GmJcp5mRKhTrlgoxUrHNX/FqazRS4zRQoF2vk8gq3eZVKucm9ptNv6bRVHaXWQigVFMpFhWpJoXbXGKmICuLt1y3zuTr5nMyBP0zM4SF79oG7Ow2ppCJXmjQVnXajjVrXqVdbCHJZQ5FUGpJKvdKkJmmUxTpX53lyuTpFUeMf5x/Y33Sy73VzkThFklrUKk0a8j3NRget0UFROtRqHYRquYUstUZlSrVJvfJlukLy8IzUfgpRbJCJHxC3GTh2v+MqvEW1qqMoXRSlR73RR2kMRmSlj1AqapSKKnfi/2nkbqr4rA6ijnXSiVOSAQ+HW04Otr2cRnYo5Ks01CGKOkDVhmjNIdqX1AYI5bLOFxVJp1rRqVV0Cjdl9jb9JHbCpI9SxJx2EtY50u4FktZZbk5OaOmPtFsDOvqQe304On8hyLUudbmLIndpyB1UpUtq/5ittTVCNitH/gAnwW2OvVYOPHbE5C5350l0rUfvfjjSaQ9HxV19gKAqfVSlh9booSnd0cXTaJKg2ULE6SAd3iN/luQqkcC18p5sOs1V6mT0z4/9jzx0hzz2Hxl2Hxl2hgid1oCu3qfX6tNv92lUFDLJFInQDkGHg3gwyJ7DRnxjjfB7I4n1Rc52d7lX2ww6Qz49/JNO8562ds9j7wHhY6fHp26PUXa6DFs6Sf8W0dVZAitLRNdt+FdMxFw2Yp4NcokY+dM0nz995LHd5vb0FDGT4edej1/6XYTPD31+fRjw6+OAz8MeD5pKPn1JatvL3oaXVGiXdGSfq3iSqDfAh5MzDn0Bohub+NesSDd5/vuvj/znlyH//rmPUCjUKYkNbnN1CgWF25zMfiTF0ss5Fl5MY3j+kunvxpj5y1OeffNHnvzhG779ze8Y++3viYUOKdW6FESVkqRTrrQRXNsp3Nsp7BsH2JxRNraO8HgiTL4wMvXCwPSEkR/H55l5Mcv8xByG8TlWDCY8dh++0DFmV5S3tl1M6xHeOWMIrp1LHKFz1rdTBGwmNl1uLJtx7FuHOAMp3DtpvHsX+KMZgrEMgegVkfg1O/tX7EXP2D+8wB+K4wse4QsdISyu7WKyR1l1H2FaXse05h5NWrKEMJq2eLWwwfS8i4XlEHPmCEZLFIM5zIIljGk9xoojylYwQTicIroXR/jTEyPfPjHy5x8W+X58me8nV/jr8yW+G/uJp38zMTaxwtjkKuPzbqZMIabeBvn78g5TbwJMLHpZtu1hc0UxW4Isvd1EGJu18WzGwtiMmbGZ96P84ZWZ5zNWpowOXi15eGMOsuyI8NoS5vnrbZ7ObzK56OONOYTVGcH4LsDsWx/Ti5sIs0tOfny9zqTByrjBytSCnckFOxNGG+NzVsbnLLw02Hn9zsuyOcCzGdfoscMT5adVPy8X3KzadvAFjtgOHPI/tU3v5FLvZV8AAAAASUVORK5CYII='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/ba47ed1e2b7a5e9dc869229c7e9e073f/01e7c/hillingar.png" class="gatsby-resp-image-image" alt="hillingar" title="hillingar" srcset="/static/ba47ed1e2b7a5e9dc869229c7e9e073f/04472/hillingar.png 170w,
/static/ba47ed1e2b7a5e9dc869229c7e9e073f/9f933/hillingar.png 340w,
/static/ba47ed1e2b7a5e9dc869229c7e9e073f/01e7c/hillingar.png 512w" sizes="(max-width: 512px) 100vw, 512px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<p>NixOS allows reproducible deployments of systems by managing configuration declaratively.
MirageOS is a unikernel creation framework that creates targeted operating systems for high-level applications that can run on a hypervisor.
By building MirageOS unikernels with Nix, we can enable reproducible builds of these unikernels and enable easy deployment on NixOS systems.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#introduction" aria-label="introduction permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Introduction</h2>
<p>The Domain Name System (DNS) is a critical component of the modern Internet, allowing domain names to be mapped to IP addresses, mailservers, and more.
This allows users to access services independent of their location in the Internet using human-readable names.
We can host a DNS server ourselves to have authoritative control over our domain, protect the privacy of those using our server, increase reliability by not relying on a third party DNS provider, and allow greater customisation of the records served.
However, it can be quite challenging to deploy one's own server reliably and reproducibly.
The Nix deployment system aims to address this.
With a NixOS machine, deploying a DNS server is as simple as:</p>
<div class="gatsby-highlight" data-language="nix"><pre class="language-nix"><code class="language-nix"><span class="token punctuation">{</span>
  services<span class="token punctuation">.</span>bind <span class="token operator">=</span> <span class="token punctuation">{</span>
    enable <span class="token operator">=</span> <span class="token boolean">true</span><span class="token punctuation">;</span>
    zones<span class="token punctuation">.</span><span class="token string">&quot;freumh.org&quot;</span> <span class="token operator">=</span> <span class="token punctuation">{</span>
      master <span class="token operator">=</span> <span class="token boolean">true</span><span class="token punctuation">;</span>
      file <span class="token operator">=</span> <span class="token string">&quot;freumh.org.zone&quot;</span><span class="token punctuation">;</span>
    <span class="token punctuation">}</span><span class="token punctuation">;</span>
  <span class="token punctuation">}</span><span class="token punctuation">;</span>
<span class="token punctuation">}</span></code></pre></div>
<p>Which we can then query with:</p>
<div class="gatsby-highlight" data-language="bash"><pre class="language-bash"><code class="language-bash">$ <span class="token function">dig</span> freumh.org @ns1.freumh.org +short
<span class="token number">135.181</span>.100.27</code></pre></div>
<p>To enable the user to query our domain without specifying the nameserver, we have to create a glue record with our registrar pointing <code>ns1.freumh.org</code> to the IP address of our DNS-hosting machine.</p>
<p>You might notice this configuration is running the venerable bind<sup><a href="https://tarides.com/feed.xml#fn-1" class="footnote-ref">1</a></sup>, which is written in C.
As an alternative, using functional, high-level, type-safe programming languages to create network applications can greatly benefit safety and usability whilst maintaining performant execution.
One such language is OCaml.</p>
<p>MirageOS<sup><a href="https://tarides.com/feed.xml#fn-2" class="footnote-ref">2</a></sup> is a deployment method for these OCaml programs.
Instead of running them as a traditional Unix process, we instead create a specialised 'unikernel' operating system to run the application.
They offer reduced image sizes through dead code elimination, as well as improved security and efficiency.</p>
<p>However, to deploy a Mirage unikernel with NixOS, one must use the imperative deployment methodologies native to the OCaml ecosystem, thus eliminating the benefit of reproducible systems that Nix offers.
This blog post will explore how we enabled reproducible deployments of Mirage unikernels by building them with Nix.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#mirageos" aria-label="mirageos permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>MirageOS</h2>
<div style="text-align: center;">
  <img src="https://tarides.com/mirage-logo.svg" style="height: 300px; max-width: 100%"/>
</div>
<p><sup><a href="https://tarides.com/feed.xml#fn-3" class="footnote-ref">3</a></sup></p>
<p>MirageOS is a library operating system that allows users to create unikernels, which are specialised operating systems that include both low-level operating system code and high-level application code in a single kernel and a single address space.
It was the first such 'unikernel creation framework', but comes from a long lineage of OS research, such as the exokernel library OS architecture.
Embedding application code in the kernel allows for dead-code elimination, removing OS interfaces that are unused, which reduces the unikernel's attack surface and offers improved efficiency.</p>
<div style="text-align: center;">
  <img src="https://tarides.com/mirage-diagram.svg" style="height: 300px; max-width: 100%"/>
</div>
<p>Contrasting software layers in existing VM appliances vs. unikernel's standalone kernel compilation approach <a href="https://tarides.com/feed.xml#madhavapeddyUnikernelsLibraryOperating2013">[3]</a></p>
<p>Mirage unikernels are written OCaml<sup><a href="https://tarides.com/feed.xml#fn-4" class="footnote-ref">4</a></sup>.
OCaml is more practical for systems programming than other functional programming languages, such as Haskell.
It supports falling back on impure imperative code or mutable variables when warranted.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#nix" aria-label="nix permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Nix</h2>
<div style="text-align: center;">
  <img src="https://tarides.com/nix-snowflake.svg" style="height: 300px; max-width: 100%"/>
</div>
<p>Nix snowflake<sup><a href="https://tarides.com/feed.xml#fn-5" class="footnote-ref">5</a></sup>.</p>
<p>Nix is a deployment system that uses cryptographic hashes to compute unique paths for components<sup><a href="https://tarides.com/feed.xml#fn-6" class="footnote-ref">6</a></sup> that are stored in a read-only directory: the Nix store, at <code>/nix/store/&lt;hash&gt;-&lt;name&gt;</code>.
This provides several benefits, including concurrent installation of multiple versions of a package, atomic upgrades, and multiple user environments.</p>
<p>Nix uses a declarative domain-specific language (DSL), also called Nix, to build and configure software.
The snippet used to deploy the DNS server is in fact a Nix expression.
This example doesn't demonstrate it, but Nix is Turing complete.
Nix does not, however, have a type system.</p>
<p>We used the DSL to write derivations for software that describe how to build said software with input components and a build script.
This Nix expression is then 'instantiated' to create 'store derivations' (<code>.drv</code> files), which is the low-level representation of how to build a single component.
This store derivation is 'realised' into a built artefact, hereafter referred to as 'building.'</p>
<p>Possibly the simplest Nix derivation uses <code>bash</code> to create a single file containing <code>Hello, World!</code>:</p>
<div class="gatsby-highlight" data-language="nix"><pre class="language-nix"><code class="language-nix"><span class="token punctuation">{</span> pkgs <span class="token operator">?</span> <span class="token function">import</span> <span class="token operator">&lt;</span>nixpkgs<span class="token operator">&gt;</span> <span class="token punctuation">{</span>  <span class="token punctuation">}</span> <span class="token punctuation">}</span><span class="token punctuation">:</span>

<span class="token keyword">builtins</span><span class="token punctuation">.</span><span class="token function">derivation</span> <span class="token punctuation">{</span>
  name <span class="token operator">=</span> <span class="token string">&quot;hello&quot;</span><span class="token punctuation">;</span>
  system <span class="token operator">=</span> <span class="token keyword">builtins</span><span class="token punctuation">.</span><span class="token function">currentSystem</span><span class="token punctuation">;</span>
  builder <span class="token operator">=</span> <span class="token string">&quot;<span class="token interpolation"><span class="token antiquotation important">$</span><span class="token punctuation">{</span>nixpkgs<span class="token punctuation">.</span>bash<span class="token punctuation">}</span></span>/bin/bash&quot;</span><span class="token punctuation">;</span>
  args <span class="token operator">=</span> <span class="token punctuation">[</span> <span class="token string">&quot;-c&quot;</span> <span class="token string">''echo &quot;Hello, World!&quot; &gt; $out''</span> <span class="token punctuation">]</span><span class="token punctuation">;</span>
<span class="token punctuation">}</span></code></pre></div>
<p>Note that <code>derivation</code> is a function that we're calling with one argument, which is a set of attributes.</p>
<p>We can instantiate this Nix derivation to create a store derivation:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">$ nix-instantiate default.nix
/nix/store/5d4il3h1q4cw08l6fnk4j04a19dsv71k-hello.drv
$ nix show-derivation /nix/store/5d4il3h1q4cw08l6fnk4j04a19dsv71k-hello.drv
{
  &quot;/nix/store/5d4il3h1q4cw08l6fnk4j04a19dsv71k-hello.drv&quot;: {
    &quot;outputs&quot;: {
      &quot;out&quot;: {
        &quot;path&quot;: &quot;/nix/store/4v1dx6qaamakjy5jzii6lcmfiks57mhl-hello&quot;
      }
    },
    &quot;inputSrcs&quot;: [],
    &quot;inputDrvs&quot;: {
      &quot;/nix/store/mnyhjzyk43raa3f44pn77aif738prd2m-bash-5.1-p16.drv&quot;: [
        &quot;out&quot;
      ]
    },
    &quot;system&quot;: &quot;x86_64-linux&quot;,
    &quot;builder&quot;: &quot;/nix/store/2r9n7fz1rxq088j6mi5s7izxdria6d5f-bash-5.1-p16/bin/bash&quot;,
    &quot;args&quot;: [ &quot;-c&quot;, &quot;echo \&quot;Hello, World!\&quot; &gt; $out&quot; ],
    &quot;env&quot;: {
      &quot;builder&quot;: &quot;/nix/store/2r9n7fz1rxq088j6mi5s7izxdria6d5f-bash-5.1-p16/bin/bash&quot;,
      &quot;name&quot;: &quot;hello&quot;,
      &quot;out&quot;: &quot;/nix/store/4v1dx6qaamakjy5jzii6lcmfiks57mhl-hello&quot;,
      &quot;system&quot;: &quot;x86_64-linux&quot;
    }
  }
}</code></pre></div>
<p>And build the store derivation:</p>
<div class="gatsby-highlight" data-language="sh"><pre class="language-sh"><code class="language-sh">$ nix-store --realise /nix/store/5d4il3h1q4cw08l6fnk4j04a19dsv71k-hello.drv
/nix/store/4v1dx6qaamakjy5jzii6lcmfiks57mhl-hello
$ cat /nix/store/4v1dx6qaamakjy5jzii6lcmfiks57mhl-hello
Hello, World!</code></pre></div>
<p>Most Nix tooling does these two steps together:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">nix-build default.nix
this derivation will be built:
  /nix/store/q5hg3vqby8a9c8pchhjal3la9n7g1m0z-hello.drv
building '/nix/store/q5hg3vqby8a9c8pchhjal3la9n7g1m0z-hello.drv'...
/nix/store/zyrki2hd49am36jwcyjh3xvxvn5j5wml-hello</code></pre></div>
<p>Nix realisations (hereafter referred to as 'builds') are done in isolation to ensure reproducibility.
Projects often rely on interacting with package managers to make sure all dependencies are available and may implicitly rely on system configuration at build time.
To prevent this, every Nix derivation is built in isolation (without network access or access to the global file system) with only other Nix derivations as inputs.</p>
<blockquote>
<p>The name Nix is derived from the Dutch word <em>niks</em>, meaning nothing; build actions do not see anything that has not been explicitly declared as an input.</p>
</blockquote>
<h4 style="position:relative;"><a href="https://tarides.com/feed.xml#nixpkgs" aria-label="nixpkgs permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Nixpkgs</h4>
<p>You may have noticed a reference to <code>nixpkgs</code> in the above derivation.
As every input to a Nix derivation also has to be a Nix derivation, one can imagine the tedium involved in creating a Nix derivation for every dependency of your project.
However, Nixpkgs<sup><a href="https://tarides.com/feed.xml#fn-7" class="footnote-ref">7</a></sup> is a large repository of software packaged in Nix, where a package is a Nix derivation.
We can use packages from Nixpkgs as inputs to a Nix derivation, as we've done with <code>bash</code>.</p>
<p>There is also a command line package manager installing packages from Nixpkgs, which is why people often refer to Nix as a package manager.
While Nix, and therefore Nix package management, is primarily source-based (since derivations describe how to build software from source), binary deployment is an optimisation of this.
Since packages are built in isolation and entirely determined by their inputs, binaries can be transparently deployed by downloading them from a remote server instead of building the derivation locally.</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/d593fbd512695940ef53b14d87fcc371/ce6cc/nixpkgs.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 64.70588235294117%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAANCAIAAAAmMtkJAAAACXBIWXMAAB2HAAAdhwGP5fFlAAACoElEQVQoz2MoLCzk4OCQkZGRlJRUVVVR11A3MtAzNDOVUFSQlBAXExOTlpbm5ubu6ur6////nz9//iMBhuTkZAYGBkZGRmFBQRMjfTMTAw87G2EnUzZ/W0U1VX5eXkZGRgYGhtra2v/////+/RuLZllpKXVVZWMTXT9/x+QIP0s9YyFNBX19LWN9XV4eHgYGhroKkOYvX7/8+vXrz58/P3/+/PXrF0NCYiIDA4OTs4WFlZ6lpYlXkJmjlY6/vlSqPZuJMmuwr6uxgQ4DA0NkZsq1e7cvXbz49OnTr1+/3rp16979+wyJiYmsTCwmRvo6esrOvtoBiTrednIdsSLLyqUrErX37tg0a3IXAwNDVHTgtWsXT506ffHixffv39+8dfPxkycMyckpfEKsVu6KPqly8W1S8Y3yqWlaE2tNV3Ra1yarJYZ5OZjriwkLpEeH3rx0/vDRo2fPnfv8+fONGzcePXrEkJaSpmclntGrndQln9gjkdgi7ewv4mDFG2DDpivPwiMjLBpbwCSjlpWb/enbt4cPH7x89fLnz5+v37z++PEjQ1pKurIZc2qfSmKXbHy7mE+alLmBkYdBmJdhmKS4kkxRve7+V8Jh4c3VlViiKikhWUKRLaZWNaZVwiOb38rAtNyza3rCqgXpWxIs09gcgvhKpzLwC9RVV/3////Xr1///v37//8/hGRISEhgZ2OxcdF0iZI3NFLJd2lcmb1vY8GJzYWnZ8Wvs9Z1VTU0AEVVXR2WeE5KTmJgYNDTV7O217XTcO0Mm7Mx/8Sesqu7Si9PiFrqauyqpiyHUzMkkbCysNpbWljrW2c7Vc9L3jw7aX2lX6exohUTExMzMzOBFMbCwsLEyMjKyirMI6ojY6QmocXNDkpYDAwMeDQDAHFkZ7hp116OAAAAAElFTkSuQmCC'); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/d593fbd512695940ef53b14d87fcc371/c5bb3/nixpkgs.png" class="gatsby-resp-image-image" alt="nixpkgs" title="nixpkgs" srcset="/static/d593fbd512695940ef53b14d87fcc371/04472/nixpkgs.png 170w,
/static/d593fbd512695940ef53b14d87fcc371/9f933/nixpkgs.png 340w,
/static/d593fbd512695940ef53b14d87fcc371/c5bb3/nixpkgs.png 680w,
/static/d593fbd512695940ef53b14d87fcc371/b12f7/nixpkgs.png 1020w,
/static/d593fbd512695940ef53b14d87fcc371/b5a09/nixpkgs.png 1360w,
/static/d593fbd512695940ef53b14d87fcc371/ce6cc/nixpkgs.png 1551w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<p>Visualisation of Nixpkgs<sup><a href="https://tarides.com/feed.xml#fn-8" class="footnote-ref">8</a></sup></p>
<h4 style="position:relative;"><a href="https://tarides.com/feed.xml#nixos" aria-label="nixos permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>NixOS</h4>
<p>NixOS<sup><a href="https://tarides.com/feed.xml#fn-9" class="footnote-ref">9</a></sup> is a Linux distribution built with Nix from a modular, purely functional specification.
It has no traditional filesystem hierarchy (FSH), like <code>/bin</code>, <code>/lib</code>, <code>/usr</code>, but instead stores all components in <code>/nix/store</code>.
The system configuration is managed by Nix and configured with Nix expressions.
NixOS modules are Nix files containing chunks of system configuration that can be composed to build a full NixOS system<sup><a href="https://tarides.com/feed.xml#fn-10" class="footnote-ref">10</a></sup>.
While many NixOS modules are provided in the Nixpkgs repository, they can also be written by an individual user.
For example, the expression used to deploy a DNS server is a NixOS module.
Together these modules form the configuration which builds the Linux system as a Nix derivation.</p>
<p>NixOS minimises global mutable state that -- without knowing it -- you might rely on being set up in a certain way.
For example, you might follow instructions to run a series of shell commands and edit some files to get a piece of software working.
You may subsequently be unable to reproduce the result because you've forgotten some intricacy or are now using a different version of the software.
Nix forces you to encode this in a reproducible way, which is extremely useful for replicating software configurations and deployments, aiming to solve the 'It works on my machine' problem.
Docker is often used to fix this configuration problem, but Nix aims to be more reproducible.
This can be frustrating at times because it can make it harder to get a project off the ground, but the benefits often outweigh the downsides.</p>
<p>Nix uses pointers (implemented as symlinks) to system dependencies, which are Nix derivations for programs or pieces of configuration files.
This means NixOS supports atomic upgrades, as the pointers to the new packages are only updated when the install succeeds; the old versions can be kept until garbage collection.
This also allows NixOS to trivially supports rollbacks to previous system configurations, as the pointers can be restored to their previous state.
Every new system configuration creates a GRUB entry, so you can boot previous systems even from your UEFI/BIOS.
Finally, NixOS also supports partial upgrades: while Nixpkgs also has one global coherent package set, one can use multiple instances of Nixpkgs (i.e., channels) at once, as this Nix store allows multiple versions of a dependency to be stored.</p>
<p>To summarise the parts of the Nix ecosystem that we've discussed:</p>
<div style="text-align: center;">
  <img src="https://tarides.com/nix-stack.svg" style="height: 300px; max-width: 100%"/>
</div>
<h4 style="position:relative;"><a href="https://tarides.com/feed.xml#flakes" aria-label="flakes permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Flakes</h4>
<p>We also use Nix flakes for this project.
Without going into too much depth, they enable hermetic evaluation of Nix expressions and provide a standard way to compose Nix projects.
With flakes, instead of using a Nixpkgs repository version from a 'channel'<sup><a href="https://tarides.com/feed.xml#fn-11" class="footnote-ref">11</a></sup>, we pin Nixpkgs as an input to every Nix flake, be it a project build with Nix or a NixOS system.
Integrated with flakes, there is also a new <code>nix</code> command aimed at improving the Nix UI.
You can read more detail about flakes in a series of blog posts by Eelco Dolstra on the topic<sup><a href="https://tarides.com/feed.xml#fn-12" class="footnote-ref">12</a></sup>.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#deploying-unikernels" aria-label="deploying unikernels permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Deploying Unikernels</h2>
<p>Now that we understand what Nix and Mirage are, and we've motivated the desire to deploy Mirage unikernels on a NixOS machine, what's stopping us from doing just that?
To support deploying a Mirage unikernel, like for a DNS server, we need to write a NixOS module for it.</p>
<p>A paired-down<sup><a href="https://tarides.com/feed.xml#fn-13" class="footnote-ref">13</a></sup> version of the bind NixOS module, the module used in our Nix expression for deploying a DNS server on NixOS (<a href="https://tarides.com/feed.xml#cb1">&sect;</a>), is:</p>
<div class="gatsby-highlight" data-language="nix"><pre class="language-nix"><code class="language-nix"><span class="token punctuation">{</span> config<span class="token punctuation">,</span> lib<span class="token punctuation">,</span> pkgs<span class="token punctuation">,</span> <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span> <span class="token punctuation">}</span><span class="token punctuation">:</span>

<span class="token keyword">with</span> lib<span class="token punctuation">;</span>

<span class="token punctuation">{</span>
  options <span class="token operator">=</span> <span class="token punctuation">{</span>
    services<span class="token punctuation">.</span>bind <span class="token operator">=</span> <span class="token punctuation">{</span>
      enable <span class="token operator">=</span> mkEnableOption <span class="token string">&quot;BIND domain name server&quot;</span><span class="token punctuation">;</span>
      
      zones <span class="token operator">=</span> mkOption <span class="token punctuation">{</span>
        <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span>
      <span class="token punctuation">}</span><span class="token punctuation">;</span>
    <span class="token punctuation">}</span><span class="token punctuation">;</span>
  <span class="token punctuation">}</span><span class="token punctuation">;</span>

  config <span class="token operator">=</span> mkIf cfg<span class="token punctuation">.</span>enable <span class="token punctuation">{</span>
    systemd<span class="token punctuation">.</span>services<span class="token punctuation">.</span>bind <span class="token operator">=</span> <span class="token punctuation">{</span>
      description <span class="token operator">=</span> <span class="token string">&quot;BIND Domain Name Server&quot;</span><span class="token punctuation">;</span>
      after <span class="token operator">=</span> <span class="token punctuation">[</span> <span class="token string">&quot;network.target&quot;</span> <span class="token punctuation">]</span><span class="token punctuation">;</span>
      wantedBy <span class="token operator">=</span> <span class="token punctuation">[</span> <span class="token string">&quot;multi-user.target&quot;</span> <span class="token punctuation">]</span><span class="token punctuation">;</span>

      serviceConfig <span class="token operator">=</span> <span class="token punctuation">{</span>
        ExecStart <span class="token operator">=</span> <span class="token string">&quot;<span class="token interpolation"><span class="token antiquotation important">$</span><span class="token punctuation">{</span>pkgs<span class="token punctuation">.</span>bind<span class="token punctuation">.</span>out<span class="token punctuation">}</span></span>/sbin/named&quot;</span><span class="token punctuation">;</span>
      <span class="token punctuation">}</span><span class="token punctuation">;</span>
    <span class="token punctuation">}</span><span class="token punctuation">;</span>
  <span class="token punctuation">}</span><span class="token punctuation">;</span>
<span class="token punctuation">}</span></code></pre></div>
<p>Notice the reference to <code>pkgs.bind</code>.
This is the Nixpkgs repository Nix derivation for the <code>bind</code> package.
Recall that every input to a Nix derivation is itself a Nix derivation (<a href="https://tarides.com/feed.xml#nixpkgs">&sect;</a>); in order to use a package in a Nix expression -- i.e., a NixOS module -- we need to build said package with Nix.
Once we build a Mirage unikernel with Nix, we can write a NixOS module to deploy it.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#building-unikernels" aria-label="building unikernels permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Building Unikernels</h2>
<p>Mirage uses the package manager for OCaml called opam<sup><a href="https://tarides.com/feed.xml#fn-14" class="footnote-ref">14</a></sup>.
Dependencies in opam, as is common in programming language package managers, have a file which -- among other metadata, build/install scripts -- specifies dependencies and their version constraints.
For example<sup><a href="https://tarides.com/feed.xml#fn-15" class="footnote-ref">15</a></sup></p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">...
depends: [
  &quot;arp&quot; { ?monorepo &amp; &gt;= &quot;3.0.0&quot; &amp; &lt; &quot;4.0.0&quot; }
  &quot;ethernet&quot; { ?monorepo &amp; &gt;= &quot;3.0.0&quot; &amp; &lt; &quot;4.0.0&quot; }
  &quot;lwt&quot; { ?monorepo }
  &quot;mirage&quot; { build &amp; &gt;= &quot;4.2.0&quot; &amp; &lt; &quot;4.3.0&quot; }
  &quot;mirage-bootvar-solo5&quot; { ?monorepo &amp; &gt;= &quot;0.6.0&quot; &amp; &lt; &quot;0.7.0&quot; }
  &quot;mirage-clock-solo5&quot; { ?monorepo &amp; &gt;= &quot;4.2.0&quot; &amp; &lt; &quot;5.0.0&quot; }
  &quot;mirage-crypto-rng-mirage&quot; { ?monorepo &amp; &gt;= &quot;0.8.0&quot; &amp; &lt; &quot;0.11.0&quot; }
  &quot;mirage-logs&quot; { ?monorepo &amp; &gt;= &quot;1.2.0&quot; &amp; &lt; &quot;2.0.0&quot; }
  &quot;mirage-net-solo5&quot; { ?monorepo &amp; &gt;= &quot;0.8.0&quot; &amp; &lt; &quot;0.9.0&quot; }
  &quot;mirage-random&quot; { ?monorepo &amp; &gt;= &quot;3.0.0&quot; &amp; &lt; &quot;4.0.0&quot; }
  &quot;mirage-runtime&quot; { ?monorepo &amp; &gt;= &quot;4.2.0&quot; &amp; &lt; &quot;4.3.0&quot; }
  &quot;mirage-solo5&quot; { ?monorepo &amp; &gt;= &quot;0.9.0&quot; &amp; &lt; &quot;0.10.0&quot; }
  &quot;mirage-time&quot; { ?monorepo }
  &quot;mirageio&quot; { ?monorepo }
  &quot;ocaml&quot; { build &amp; &gt;= &quot;4.08.0&quot; }
  &quot;ocaml-solo5&quot; { build &amp; &gt;= &quot;0.8.1&quot; &amp; &lt; &quot;0.9.0&quot; }
  &quot;opam-monorepo&quot; { build &amp; &gt;= &quot;0.3.2&quot; }
  &quot;tcpip&quot; { ?monorepo &amp; &gt;= &quot;7.0.0&quot; &amp; &lt; &quot;8.0.0&quot; }
  &quot;yaml&quot; { ?monorepo &amp; build }
]
...</code></pre></div>
<p>Each of these dependencies will have its own dependencies with their own version constraints.
As we can only link one dependency into the resulting program, we need to solve a set of dependency versions that satisfies these constraints.
This is not an easy problem.
In fact, it's NP-complete <sup><a href="https://tarides.com/feed.xml#fn-16" class="footnote-ref">16</a></sup>.
Opam uses the Zero Install<sup><a href="https://tarides.com/feed.xml#fn-17" class="footnote-ref">17</a></sup> SAT solver for dependency resolution.</p>
<p>Nixpkgs has a large number of OCaml packages<sup><a href="https://tarides.com/feed.xml#fn-18" class="footnote-ref">18</a></sup>, which we could provide as build inputs to a Nix derivation.
However, Nixpkgs has one global coherent set of package versions<sup><a href="https://tarides.com/feed.xml#fn-19" class="footnote-ref">19</a></sup>.
The support for installing multiple versions of a package concurrently comes from the fact that they are stored at a unique path and can be referenced separately, or symlinked, where required.
So different projects or users that use a different version of Nixpkgs won't conflict, but Nix does not do any dependency version resolution -- everything is pinned.
This is a problem for opam projects with version constraints that can't be satisfied with a static instance of Nixpkgs.</p>
<p>Luckily, a project from Tweag already exists (<code>opam-nix</code>) to deal with this<sup><a href="https://tarides.com/feed.xml#fn-20" class="footnote-ref">20</a></sup>.
This project uses the opam dependency versions solver inside a Nix derivation, and then creates derivations from the resulting dependency versions.</p>
<p>This still doesn't support building our Mirage unikernels, though.
Unikernels quite often need to be cross-compiled: compiled to run on a platform other than the one they're being built on.
A common target, Solo5<sup><a href="https://tarides.com/feed.xml#fn-21" class="footnote-ref">21</a></sup>, is a sandboxed execution environment for unikernels.
It acts as a minimal shim layer to interface between unikernels and different hypervisor backends.
Solo5 uses a different <code>glibc</code> which requires cross-compilation.
Mirage 4<sup><a href="https://tarides.com/feed.xml#fn-22" class="footnote-ref">22</a></sup> supports cross compilation with toolchains in the Dune build system<sup><a href="https://tarides.com/feed.xml#fn-23" class="footnote-ref">23</a></sup>.
This uses a host compiler installed in an opam switch (a virtual environment) as normal, as well as a target compiler<sup><a href="https://tarides.com/feed.xml#fn-24" class="footnote-ref">24</a></sup>.
But the cross-compilation context of packages is only known at build time, as some metaprogramming modules may require preprocessing with the host compiler.
To ensure that the right compilation context is used, we have to provide Dune with all our sources' dependencies.
A tool called <code>opam-monorepo</code> was created to do just that<sup><a href="https://tarides.com/feed.xml#fn-25" class="footnote-ref">25</a></sup>.</p>
<p>We extended the <code>opam-nix</code> project to support the <code>opam-monorepo</code> workflow with this pull request: <a href="https://github.com/tweag/opam-nix/pull/18">github.com/tweag/opam-nix/pull/18</a>.
This is very low-level support for building Mirage unikernels with Nix, however.
In order to provide a better user experience, we also created the Hillinar Nix flake: <a href="https://github.com/ryanGibb/hillingar">github.com/RyanGibb/hillingar</a>.
This wraps the Mirage tooling and <code>opam-nix</code> function calls so that a simple high-level flake can be dropped into a Mirage project to support building it with Nix.
To add Nix build support to a unikernel, simply:</p>
<div class="gatsby-highlight" data-language="bash"><pre class="language-bash"><code class="language-bash"><span class="token comment"># create a flake from hillingar's default template</span>
$ nix flake new <span class="token builtin class-name">.</span> -t github:/RyanGibb/hillingar
<span class="token comment"># substitute the name of the unikernel you're building</span>
$ <span class="token function">sed</span> -i <span class="token string">'s/throw &quot;Put the unikernel name here&quot;/&quot;&lt;unikernel-name&gt;&quot;/g'</span> flake.nix
<span class="token comment"># build the unikernel with Nix for a particular target</span>
$ nix build <span class="token builtin class-name">.</span><span class="token comment">#&lt;target&gt;</span></code></pre></div>
<p>For example, see the flake for building the Mirage website as a unikernel with Nix: <a href="https://github.com/RyanGibb/mirage-www/blob/master/flake.nix">github.com/RyanGibb/mirage-www/blob/master/flake.nix</a>.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#evaluation" aria-label="evaluation permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Evaluation</h2>
<p>Hillingar's primary limitations are (1) complex integration is required with the OCaml ecosystem to solve dependency version constraints using <code>opam-nix</code>, and (2) that cross-compilation requires cloning all sources locally with <code>opam-monorepo</code> (<a href="https://tarides.com/feed.xml#dependency-management">&sect;</a>).
Another issue that proved an annoyance during this project is the Nix DSL's dynamic typing.
When writing simple derivations this often isn't a problem, but when writing complicated logic, it quickly gets in the way of productivity.
The runtime errors produced can be very hard to parse.
Thankfully there is work towards creating a typed language for the Nix deployment system, such as Nickel<sup><a href="https://tarides.com/feed.xml#fn-26" class="footnote-ref">26</a></sup>.
However gradual typing is hard, and Nickel still isn't ready for real-world use despite being open-sourced (in a week as of writing this) for two years.</p>
<p>A glaring omission is that despite it being the primary motivation, we haven't actually written a NixOS module for deploying a DNS server as a unikernel.
There are still questions about how to provide zone file data declaratively to the unikernel and manage the runtime of deployed unikernels.
One option to do the latter is Albatross<sup><a href="https://tarides.com/feed.xml#fn-27" class="footnote-ref">27</a></sup>, which has recently had support for building with Nix added<sup><a href="https://tarides.com/feed.xml#fn-28" class="footnote-ref">28</a></sup>.
Albatross aims to provision resources for unikernels such as network access, share resources for unikernels between users, and monitor unikernels with a Unix daemon.
Using Albatross to manage some of the inherent imperative processes behind unikernels, as well as share access to resources for unikernels for other users on a NixOS system, could simplify the creation and improve the functionality of a NixOS module for a unikernel.</p>
<p>There also exists related work in the reproducible building of Mirage unikernels.
Specifically, improving the reproducibility of opam packages (as Mirage unikernels are opam packages themselves)<sup><a href="https://tarides.com/feed.xml#fn-29" class="footnote-ref">29</a></sup>.
Hillingar differs in that it only uses opam for version resolution, instead using Nix to provide dependencies, which provides reproducibility with pinned Nix derivation inputs and builds in isolation by default.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h2>
<p>To summarise, this project was motivated (<a href="https://tarides.com/feed.xml#introduction">&sect;</a>) by deploying unikernels on NixOS (<a href="https://tarides.com/feed.xml#deploying-unikernels">&sect;</a>).
Towards this end, we added support for building MirageOS unikernels with Nix:
we extended <code>opam-nix</code> to support the <code>opam-monorepo</code> workflow and created the Hillingar project to provide a usable Nix interface (<a href="https://tarides.com/feed.xml#building-unikernels">&sect;</a>).</p>
<p>While only the first was the primary motivation, the benefits of building unikernels with Nix are:</p>
<ul>
<li>Reproducible and low-config unikernel deployment using NixOS modules is enabled.</li>
<li>Nix allows reproducible builds pinning system dependencies and composing multiple language environments. For example, the OCaml package <code>conf-gmp</code> is a 'virtual package' that relies on a system installation of the C/Assembly library <code>gmp</code> (The GNU Multiple Precision Arithmetic Library). Nix easily allows us to depend on this package in a reproducible way.</li>
<li>We can use Nix to support building on different systems (<a href="https://tarides.com/feed.xml#cross-compilation">&sect;</a>).</li>
</ul>
<p>To conclude, while NixOS and MirageOS take fundamentally very different approaches, they're both trying to bring some kind of functional programming paradigm to operating systems.
NixOS does this in a top-down manner, trying to tame Unix with functional principles like laziness and immutability<sup><a href="https://tarides.com/feed.xml#fn-30" class="footnote-ref">30</a></sup>; whereas, MirageOS does this by throwing Unix out the window and rebuilding the world from scratch in a very much bottom-up approach.
Despite these two projects having different motivations and goals, Hillingar aims to get the best from both worlds by marrying the two.</p>
<hr/>
<p>To dive deeper, please see a more detailed article on my <a href="https://ryan.freumh.org/blog/hillingar">personal blog</a>.</p>
<p>If you have a unikernel, consider trying to build it with Hillingar, and please report any problems at <a href="https://github.com/RyanGibb/hillingar/issues">github.com/RyanGibb/hillingar/issues</a>!</p>
<div class="footnotes">
<hr/>
<ol>
<li><a href="https://www.isc.org/bind/">ISC bind</a> has many <a href="https://www.cvedetails.com/product/144/ISC-Bind.html?vendor_id=64">CVE's</a><a href="https://tarides.com/feed.xml#fnref-1" class="footnote-backref">&#8617;</a></li>
<li> <a href="https://mirage.io">mirage.io</a> <a href="https://tarides.com/feed.xml#fnref-2" class="footnote-backref">&#8617;</a></li>
<li>Credits to Takayuki Imada<a href="https://tarides.com/feed.xml#fnref-3" class="footnote-backref">&#8617;</a></li>
<li>Barring the use of <a href="https://mirage.io/blog/modular-foreign-function-bindings">foreign function interfaces</a> (FFIs).<a href="https://tarides.com/feed.xml#fnref-4" class="footnote-backref">&#8617;</a></li>
<li>As 'nix' means snow in Latin. Credits to Tim Cuthbertson.<a href="https://tarides.com/feed.xml#fnref-5" class="footnote-backref">&#8617;</a></li>
<li>NB: we will use component, dependency, and package somewhat interchangeably in this blog post, as they all fundamentally mean the same thing -- a piece of software.<a href="https://tarides.com/feed.xml#fnref-6" class="footnote-backref">&#8617;</a></li>
<li> <a href="https://github.com/nixos/nixpkgs">github.com/nixos/nixpkgs</a> <a href="https://tarides.com/feed.xml#fnref-7" class="footnote-backref">&#8617;</a></li>
<li><a href="https://www.tweag.io/blog/2022-09-13-nixpkgs-graph/">www.tweag.io/blog/2022-09-13-nixpkgs-graph/</a><a href="https://tarides.com/feed.xml#fnref-8" class="footnote-backref">&#8617;</a></li>
<li><a href="https://nixos.org">nixos.org</a><a href="https://tarides.com/feed.xml#fnref-9" class="footnote-backref">&#8617;</a></li>
<li><a href="https://nixos.org/manual/nixos/stable/index.html#sec-writing-modules">NixOS manual Chapter 66. Writing NixOS Modules</a>.<a href="https://tarides.com/feed.xml#fnref-10" class="footnote-backref">&#8617;</a></li>
<li><a href="https://nixos.org/manual/nix/stable/package-management/channels.html">nixos.org/manual/nix/stable/package-management/channels.html</a><a href="https://tarides.com/feed.xml#fnref-11" class="footnote-backref">&#8617;</a></li>
<li><a href="https://www.tweag.io/blog/2020-05-25-flakes/">tweag.io/blog/2020-05-25-flakes</a><a href="https://tarides.com/feed.xml#fnref-12" class="footnote-backref">&#8617;</a></li>
<li>The full module can be found <a href="https://github.com/NixOS/nixpkgs/blob/fe76645aaf2fac3baaa2813fd0089930689c53b5/nixos/modules/services/networking/bind.nix">here</a><a href="https://tarides.com/feed.xml#fnref-13" class="footnote-backref">&#8617;</a></li>
<li><a href="https://opam.ocaml.org/">opam.ocaml.org</a><a href="https://tarides.com/feed.xml#fnref-14" class="footnote-backref">&#8617;</a></li>
<li>For <a href="https://github.com/mirage/mirage-www">mirage-www</a> targetting <code>hvt</code>.<a href="https://tarides.com/feed.xml#fnref-15" class="footnote-backref">&#8617;</a></li>
<li><a href="https://research.swtch.com/version-sat">research.swtch.com/version-sat</a><a href="https://tarides.com/feed.xml#fnref-16" class="footnote-backref">&#8617;</a></li>
<li><a href="https://0install.net">0install.net</a><a href="https://tarides.com/feed.xml#fnref-17" class="footnote-backref">&#8617;</a></li>
<li><a href="https://github.com/NixOS/nixpkgs/blob/9234f5a17e1a7820b5e91ecd4ff0de449e293383/pkgs/development/ocaml-modules/">github.com/NixOS/nixpkgs pkgs/development/ocaml-modules</a><a href="https://tarides.com/feed.xml#fnref-18" class="footnote-backref">&#8617;</a></li>
<li>Bar some exceptional packages that have multiple major versions packaged, like Postgres.<a href="https://tarides.com/feed.xml#fnref-19" class="footnote-backref">&#8617;</a></li>
<li><a href="https://github.com/tweag/opam-nix">github.com/tweag/opam-nix</a><a href="https://tarides.com/feed.xml#fnref-20" class="footnote-backref">&#8617;</a></li>
<li><a href="https://github.com/Solo5/solo5">github.com/Solo5/solo5</a><a href="https://tarides.com/feed.xml#fnref-21" class="footnote-backref">&#8617;</a></li>
<li><a href="https://mirage.io/blog/announcing-mirage-40">mirage.io/blog/announcing-mirage-40</a><a href="https://tarides.com/feed.xml#fnref-22" class="footnote-backref">&#8617;</a></li>
<li><a href="https://dune.build">dune.build</a><a href="https://tarides.com/feed.xml#fnref-23" class="footnote-backref">&#8617;</a></li>
<li><a href="https://github.com/mirage/ocaml-solo5">github.com/mirage/ocaml-solo5</a><a href="https://tarides.com/feed.xml#fnref-24" class="footnote-backref">&#8617;</a></li>
<li><a href="https://github.com/tarides/opam-monorepo">github.com/tarides/opam-monorepo</a><a href="https://tarides.com/feed.xml#fnref-25" class="footnote-backref">&#8617;</a></li>
<li><a href="https://www.tweag.io/blog/2020-10-22-nickel-open-sourcing/">www.tweag.io/blog/2020-10-22-nickel-open-sourcing</a><a href="https://tarides.com/feed.xml#fnref-26" class="footnote-backref">&#8617;</a></li>
<li><a href="https://hannes.robur.coop/Posts/VMM">hannes.robur.coop/Posts/VMM</a><a href="https://tarides.com/feed.xml#fnref-27" class="footnote-backref">&#8617;</a></li>
<li><a href="https://github.com/roburio/albatross/pull/120">https://github.com/roburio/albatross/pull/120</a><a href="https://tarides.com/feed.xml#fnref-28" class="footnote-backref">&#8617;</a></li>
<li><a href="https://hannes.nqsb.io/Posts/ReproducibleOPAM">hannes.nqsb.io/Posts/ReproducibleOPAM</a><a href="https://tarides.com/feed.xml#fnref-29" class="footnote-backref">&#8617;</a></li>
<li><a href="https://www.tweag.io/blog/2022-07-14-taming-unix-with-nix/">tweag.io/blog/2022-07-14-taming-unix-with-nix</a><a href="https://tarides.com/feed.xml#fnref-30" class="footnote-backref">&#8617;</a></li>
</ol>
</div>
