---
title: OCaml Compiler Manual HTML Generation
description: "In order to avoid long, confusing URLs on the OCaml Manual pages, we
  set out to create a solution that shortens these URLs, including\u2026"
url: https://tarides.com/blog/2024-07-17-ocaml-compiler-manual-html-generation
date: 2024-07-17T00:00:00-00:00
preview_image: https://tarides.com/static/71ebe0c7b3ff03df0f8cfbf681e8dad8/0132d/compiler-manual.jpg
authors:
- Tarides
source:
---

<p>In order to avoid long, confusing URLs on the OCaml Manual pages, we set out to create a solution that shortens these URLs, including section references, and contains the specific version. The result improves readability and user experience. This article outlines the motivation behind these changes and how we implemented them.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#challenge" aria-label="challenge permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Challenge</h2>
<p>The OCaml HTML manuals have URL references such as <a href="https://v2.ocaml.org/manual/types.html#sss:typexpr-sharp-types">https://v2.ocaml.org/manual/types.html#sss:typexpr-sharp-types</a>, and they do not refer to any specific compiler version. We needed a way to easily share a link with the version number included. The OCaml.org page already has a mention of the compiler version, but it refers to specific <a href="https://ocaml.org/releases">https://ocaml.org/releases</a>.</p>
<p>We wanted a canonical naming convention that is consistent with current and future manual releases. It would also be beneficial to have only one place to store all the manuals, and the users of OCaml.org should never see redirecting URLs in the browser. This will greatly help increase the overall backlink quality when people share the links in conversations, tutorials, blogs, and on the Web. A preferred naming scheme should be something like:</p>
<p><a href="https://v2.ocaml.org/releases/latest/manual/attributes.html">https://v2.ocaml.org/releases/latest/manual/attributes.html</a>
<a href="https://v2.ocaml.org/releases/4.12/manual/attributes.html">https://v2.ocaml.org/releases/4.12/manual/attributes.html</a></p>
<p>Using this, we redirected the v2.ocaml.org to OCaml.org for the production deployment. Also, the changes help in shorter URLs that can be easily remembered and shared. The rel=&quot;canonical&quot; is a perfectly good way to make sure only <a href="https://ocaml.org/manual/latest">https://ocaml.org/manual/latest</a> gets indexed.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#implementation" aria-label="implementation permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Implementation</h2>
<p>After a detailed discussion, the following UI mockup to switch manuals was provided <a href="https://github.com/ocaml/ocaml.org/issues/534#issuecomment-1318570350">via GitHub issue</a>, and <em>Option A</em> was selected.</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/515787f06d67098243babd789c7487e4/e431d/UI-Mockup.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 54.11764705882353%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAALCAYAAAB/Ca1DAAAACXBIWXMAABYlAAAWJQFJUiTwAAACE0lEQVR42k1T2ZKbMBDk//8rVXnI0yZbu+sDY25hBNgSOhGdkexNhapmQGrN0TRZCDv2fUe87vc7imsJzhiMUoircX/bAnaKdHvylgWX/AI+3tJa5Hwjsz7ARDhAKAu+SNyFwqodtlexEAIWFcBlwKx2dLPBlQl0XKFfPPwWSz952bBYnLoVOdMoR0twuPINJ+Yg9ZaIMemNLzhcB+QNR80WdOMD1W1FzQ18+C/hPHFcixxVVYJ1DYa+RU3PQsg03neHNz7jUrVougFVw1C3DJeyxUM5WOvgvUdULmuowke94tAqfHUKn82K91Lg1Bto99Q2Xsdqws/fFY6tQDVvNIVDcXOoZ49xmqHWNfEy6zyijtZvCcZt6d3E9RcMdTDeFY0pwB8Gs3SYBEGS5hSlMlgeAo7OZ81InTWCOpQ495L0VPS84swUHbTQxkJRwj/5gB9vJd5yjkOn00SfjaIzGmyc0Q8jNPGy6U4j9CPKfqaNBWySYLOijkz60sYaKEr6WU749cVS8RMlOcbChI9Wo+45qrrFvDyQrcZT5i1BWU8IiGsxmSIv6QiqXLYjjkX3b1wuN4yPOLKlkS3xTeJmjDx1oKqx4rlXOF4YCS+RD0QyL9uQLdhikrVykiIn3pmSx1iQ1bQLLx7ZxnvSSApIKWH1Cncr4JQkgUOyS/pTKHqrIUXkEccoOHamqMnUrz9le/L/AgqCShl0VxRzAAAAAElFTkSuQmCC'); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/515787f06d67098243babd789c7487e4/c5bb3/UI-Mockup.png" class="gatsby-resp-image-image" alt="UI Mockup" title="" srcset="/static/515787f06d67098243babd789c7487e4/04472/UI-Mockup.png 170w,
/static/515787f06d67098243babd789c7487e4/9f933/UI-Mockup.png 340w,
/static/515787f06d67098243babd789c7487e4/c5bb3/UI-Mockup.png 680w,
/static/515787f06d67098243babd789c7487e4/b12f7/UI-Mockup.png 1020w,
/static/515787f06d67098243babd789c7487e4/b5a09/UI-Mockup.png 1360w,
/static/515787f06d67098243babd789c7487e4/e431d/UI-Mockup.png 1882w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<p>Our proposed changes to the URL are shown below:</p>
<p>Current: <a href="https://v2.ocaml.org/releases/5.1/htmlman/index.html">https://v2.ocaml.org/releases/5.1/htmlman/index.html</a><br/>
Suggested: <code>https://ocaml.org/manual/5.3.0/index.html</code></p>
<p>Current: <a href="https://v2.ocaml.org/releases/5.1/api/Atomic.html">https://v2.ocaml.org/releases/5.1/api/Atomic.html</a><br/>
Suggested: <code>https://ocaml.org/manual/5.3.0/api/Atomic.html</code></p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#html-compiler-manuals" aria-label="html compiler manuals permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>HTML Compiler Manuals</h2>
<p>The HTML manual files are hosted in a separate GitHub repository at <a href="https://github.com/ocaml-web/html-compiler-manuals/">https://github.com/ocaml-web/html-compiler-manuals/</a>. It contains a folder for each compiler version, and it also has the manual HTML files.</p>
<p>A script to automate the process of generating the HTML manuals is also available at <a href="https://github.com/ocaml-web/html-compiler-manuals/blob/main/scripts/build-compiler-html-manuals.sh">https://github.com/ocaml-web/html-compiler-manuals/blob/main/scripts/build-compiler-html-manuals.sh</a>. The script defines two variables, DIR and OCAML_VERSION, where you can specify the location to build the manual and the compiler version to use. It then clones the <code>ocaml/ocaml</code> repository, switches to the specific compiler branch, builds the compiler, and then generates the manuals. The actual commands are listed below for reference:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">echo &quot;Clone ocaml repository ...&quot;
git clone git@github.com:ocaml/ocaml.git

# Switch to ocaml branch
echo &quot;Checkout $OCAML_VERSION branch in ocaml ...&quot;
cd ocaml
git checkout $OCAML_VERSION

# Remove any stale files
echo &quot;Running make clean&quot;
make clean
git clean -f -x

# Configure and build
echo &quot;Running configure and make ...&quot;
./configure
make

# Build web
echo &quot;Generating manuals ...&quot;
cd manual
make web</code></pre></div>
<p>As per the new API requirements, the <code>manual/src/html_processing/Makefile</code> variables are updated as follows:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">WEBDIRMAN = $(WEDBIR)/$(VERSION)
WEBDIRAPI = $(WEBDIRMAN)/API</code></pre></div>
<p>Accordingly, we have also updated the <code>manual/src/html_processing/src/common.ml.in</code> file OCaml variables to reflect the required changes:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">
let web_dir = Filename.parent_dir_name // &quot;webman&quot; // ocaml_version

let docs_maindir = web_dir

let api_page_url = &quot;api&quot;

let manual_page_url = &quot;..&quot;</code></pre></div>
<p>We also include the <a href="https://plausible.ci.dev/js/script.js">https://plausible.ci.dev/js/script.js</a> script to collect view metrics for the HTML pages. The manuals from 3.12 through 5.2 are now available in the <a href="https://github.com/ocaml-web/html-compiler-manuals/tree/main">https://github.com/ocaml-web/html-compiler-manuals/tree/main</a> GitHub repository.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#ocamlorg" aria-label="ocamlorg permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>OCaml.org</h2>
<p>The OCaml.org Dockerfile has a step included to clone the HTML manuals and perform an automated production deployment as shown below:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">RUN git clone https://github.com/ocaml-web/html-compiler-manuals /manual

ENV OCAMLORG_MANUAL_PATH /manual</code></pre></div>
<p>The path to the new GitHub repository has been updated in the configuration file, along with the explicit URL paths to the respective manuals. The v2 URLs from the <code>data/releases/*.md</code> file have been replaced without the v2 URLs, and the <code>manual /releases/</code> redirects have been removed from <code>redirection.ml.</code> The <code>/releases/</code> redirects are now handled in <code>middleware.ml</code>. The caddy configuration to allow the redirection of v2.ocaml.org can be implemented as follows:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">v2.ocaml.org {
	redir https://ocaml.org{uri} permanent
}</code></pre></div>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#call-to-action" aria-label="call to action permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Call to Action</h2>
<p>You are encouraged to checkout the latest <a href="https://github.com/ocaml/ocaml">OCaml compiler from trunk</a> and use the <code>build-compiler-html-manual.sh</code> script to generate the HTML documentation.</p>
<p>Please do report any errors or issues that you face at the following GitHub repository: <a href="https://github.com/ocaml-web/html-compiler-manuals/issues">https://github.com/ocaml-web/html-compiler-manuals/issues</a></p>
<p>If you are interested in working on OCaml.org, please message us on the <a href="http://discord.ocaml.org">OCaml Discord</a> server or reach out to the <a href="https://github.com/ocaml-web//html-compiler-manuals">contributors in GitHub</a>.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#references" aria-label="references permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>References</h2>
<ol>
<li>
<p>(cross-ref) Online OCaml Manual: there should be an easy way to get a fixed-version URL. <a href="https://github.com/ocaml/ocaml.org/issues/534">https://github.com/ocaml/ocaml.org/issues/534</a></p>
</li>
<li>
<p>Use <code>webman/*.html</code> and <code>webman/api</code> for OCaml.org manuals. <a href="https://github.com/ocaml/ocaml/pull/12976">https://github.com/ocaml/ocaml/pull/12976</a></p>
</li>
<li>
<p>Serve OCaml Compiler Manuals. <a href="https://github.com/ocaml/ocaml.org/pull/2150">https://github.com/ocaml/ocaml.org/pull/2150</a></p>
</li>
<li>
<p>Simplify and extend <code>/releases/</code> redirects from legacy v2.ocaml.org URLs. <a href="https://github.com/ocaml/ocaml.org/pull/2448">https://github.com/ocaml/ocaml.org/pull/2448</a></p>
</li>
</ol>
<blockquote>
<p>Tarides is an open-source company first. Our top priorities are to establish and tend to the OCaml community. Similarly, we&rsquo;re dedicated to the <a href="https://github.com/sponsors/tarides">development of the OCaml language</a> and enjoy collaborating with industry partners and individual engineers to continue improving the performance and features of OCaml. We want you to join the OCaml community, test the languages and tools, and actively be part of the language&rsquo;s evolution.</p>
</blockquote>
<blockquote>
<p>Tarides is also always happy to discuss commercial opportunities around OCaml. There are many areas where we can help industrial users to adopt OCaml 5 more quickly, including training, support, custom developments, etc. Please <a href="https://tarides.com/company">contact us</a>  if you are interested in discussing your needs.</p>
</blockquote>
