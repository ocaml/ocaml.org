---
title: Peer-Programming in Modern OCaml with ChatGPT and Gemini
description: A recollection of challenging myself to implement a simple tool to generate
  a summary from YouTube videos using Vosk for speech recognition and Ollama for generating
  summaries using LLMs running locally.
url: https://soap.coffee/~lthms/posts/PeerProgrammingWithLLMs.html
date: 2025-06-02T00:00:00-00:00
preview_image: https://soap.coffee/~lthms/img/thinking.png
authors:
- "Thomas Letan\u2019s Blog"
source:
ignore:
---


        
        <h1>Peer-Programming in Modern OCaml with ChatGPT and Gemini</h1><div><span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/ocaml.html" marked="" class="tag">ocaml</a> <span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/vibecoding.html" marked="" class="tag">vibecoding</a> </div>
<p>It is June 2025, and LLMs are everywhere and do everything now. I have never
been a diligent adopter of them myself. The past few months, I started to feel
a bit “left out,” though. Colleagues and friends are starting to integrate
LLM-powered tools into their personal toolkit, with notable successes.</p>
<p>Early May, I decided to challenge myself to implement a simple tool to generate
a summary from YouTube videos using <a href="https://alphacephei.com/vosk/" marked="">Vosk&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> for
speech recognition and <a href="https://ollama.com/" marked="">Ollama&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> for generating summaries
using LLMs running locally. I could hit two birds with one stone—experimenting
with LLMs to write and power software.</p>
<p>I decided to implement as much as possible in OCaml, for two main reasons.
Firstly, this is the main language I use at <code class="hljs language-bash"><span class="hljs-variable">$WORK</span></code>. I wanted to get a
sense of how LLMs could help with the software stack I used 7+ hours a day.
Secondly, it was a good opportunity to catch-up with the OCaml 5 ecosystem
(<a href="https://github.com/ocaml-multicore/eio" marked="">Eio&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a> in particular).</p>
<p>This write-up is a sort of dev log of this exercise. Its main focus is not to
explain in depth the code I ended up writing, but rather to recollect on my
wins and losses in adding LLMs in my developer toolkit.</p>
<h2>TL;DR</h2>
<p>In this article, I am using “Tip” blocks to highlight my key findings and
lessons learned. That being said, for readers in a hurry, here’s how ChatGPT
summarizes these blocks.</p>
<ul>
<li>Prompting is a skill that improves through trial and error—many failed
prompts help build intuition.</li>
<li>LLMs may suggest non-existent functions; using LSP tools helps identify these
quickly.</li>
<li>Standard formats like WAV lead to more accurate LLM outputs.</li>
<li>LLMs without session memory tend to repeat mistakes; shared context is
important.</li>
<li>Structuring commit message prompts (e.g., What / Why / How) produces
consistently good results.</li>
<li>LLMs struggle with libraries like Eio, possibly due to name ambiguity or
unstable APIs.</li>
<li>Providing project-specific context (e.g., via <code class="hljs">direnv</code>) is likely to help
reduce repeated hallucinations.</li>
<li>Prompting LLMs for MR descriptions or commits can eliminate empty submissions
and speed up review.</li>
</ul>
<p>You should still definitely read the full piece, though. I don’t think my
prompt was particularly good 🤫.</p>
<h2>Editor Integration</h2>
<p>My first task was to grant myself the ability to leverage LLMs from my editor.
I had been using the web chat of ChatGPT for a while, but it now felt
antiquated since I had seen a freshly hired coworker get ChatGPT to generate
for themselves a dozen tests directly from VS Code.</p>
<p>I have returned to <a href="https://neovim.io" marked="">Neovim&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> for a few years, and I am not
ready to migrate to VS Code. I would have been surprised if the Vim/Neovim
communities wouldn’t have a viable plugin for me, though.</p>
<p>I asked both ChatGPT and Gemini to find my candidates, but the plugins they
suggested seemed unmaintained, often outdated.</p>
<p>In the end, I found <a href="https://github.com/olimorris/codecompanion.nvim" marked="">CodeCompanion.nvim&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>
by myself, through a good old Google research. I asked ChatGPT why it hadn’t
suggested it to me, and it seems like my prompt were biased. By asking for
“a Neovim ChatGPT plugin” or “a plugin to integrate Gemini to Neovim,” I had
unnecessarily narrowed the LLM scope.</p>
<div class="markdown-alert markdown-alert-tip"><p class="markdown-alert-title"><svg class="octicon octicon-light-bulb mr-2" viewbox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="M8 1.5c-2.363 0-4 1.69-4 3.75 0 .984.424 1.625.984 2.304l.214.253c.223.264.47.556.673.848.284.411.537.896.621 1.49a.75.75 0 0 1-1.484.211c-.04-.282-.163-.547-.37-.847a8.456 8.456 0 0 0-.542-.68c-.084-.1-.173-.205-.268-.32C3.201 7.75 2.5 6.766 2.5 5.25 2.5 2.31 4.863 0 8 0s5.5 2.31 5.5 5.25c0 1.516-.701 2.5-1.328 3.259-.095.115-.184.22-.268.319-.207.245-.383.453-.541.681-.208.3-.33.565-.37.847a.751.751 0 0 1-1.485-.212c.084-.593.337-1.078.621-1.489.203-.292.45-.584.673-.848.075-.088.147-.173.213-.253.561-.679.985-1.32.985-2.304 0-2.06-1.637-3.75-4-3.75ZM5.75 12h4.5a.75.75 0 0 1 0 1.5h-4.5a.75.75 0 0 1 0-1.5ZM6 15.25a.75.75 0 0 1 .75-.75h2.5a.75.75 0 0 1 0 1.5h-2.5a.75.75 0 0 1-.75-.75Z"></path></svg>Tip</p><p>I guess one does not become a prompt engineer in a day. This is actually one
of the reasons I want to use LLMs more seriously. To build myself intuitions
of which prompts work and which don’t. After this project, I have mostly
uncovered a bunch of the latter category 😅.</p>
</div>
<p><a href="https://twitter.com/yurug" marked=""><strong>@yurug</strong>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> had told me he was impressed by Gemini
Pro, so I decided to make it the default adapter for the <code class="hljs">CodeCompanionChat</code>
command. I tried to make Gemini Pro the default model for this adapter, it was
challenging and LLMs weren’t able to help. When I finally found the correct
<code class="hljs">setup</code> option, it turns out I hadn’t generated a token allowing me to use Pro.</p>
<p>Well. That gave me the opportunity to benchmark Gemini Flash, then.</p>
<h2>Speech Recognition with Vosk</h2>
<p>ChatGPT suggested Vosk as a way to get a transcript of an audio file, so it was
also a good opportunity to write bindings (something I had dodged for a long
time for no particular reason).</p>
<p>As of June 2025, there is no OCaml bindings for the <a href="https://github.com/alphacep/vosk-api/blob/master/src/vosk_api.h" marked="">Vosk
API&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>, so my
first task was to write my own as part of a project soberly called
<a href="https://github.com/lthms/ocaml-vosk" marked=""><code class="hljs">ocaml-vosk</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>.</p>
<p>Gemini Flash was able to help me understand how <code class="hljs">ctypes</code> and <code class="hljs">ctypes.foreign</code>
works. This was my first experience interacting with an LLM from my Neovim
window, and it was pretty convincing. It gave me the opportunity to learn that
one can declare opaque types in OCaml (not just via mli files). It makes sense,
but it was news to me.</p>
<p>Then, Gemini suggested me to use <a href="https://ocaml-multicore.github.io/eio/eio/Eio/Switch/" marked="">EIO’s
<code class="hljs language-ocaml"><span class="hljs-type">Switch</span></code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>
to deal with automatic memory management (in place of <code class="hljs">Gc.finalise</code>). It was
the first time I heard about it, and the fact that I learned their existence
from the perspective of resource management (not fiber management) was a good
accident.</p>
<p>The first point of friction came when I started build a high-level interface
for my Vosk bindings. More specifically, given a
<a href="https://ocaml.org/p/cstruct/latest" marked=""><code class="hljs">Cstruct.t</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> value, how do I get a pointer
and a length? It turns out that while both ChatGPT and Gemini Pro know how to
do so, Gemini Flash hallucinates every step of the way.</p>
<p>The solution is actually pretty straightforward.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">let</span> ptr =
  <span class="hljs-type">Ctypes</span>.bigarray_start
    <span class="hljs-type">Ctypes</span>.array1
    (<span class="hljs-type">Cstruct</span>.to_bigarray buffer)
<span class="hljs-keyword">in</span>
<span class="hljs-keyword">let</span> len = buffer.<span class="hljs-type">Cstruct</span>.len <span class="hljs-keyword">in</span>
</code></pre>
<p>Gemini Flash kept suggesting I use <code class="hljs">Ctypes.ptr_add</code> instead, though. Don’t
search for it, it does not exist<label for="fn1" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">While reviewing this article, ChatGPT gently hinted that while
<code class="hljs">ptr_add</code> does not exist, <code class="hljs language-ocaml"><span class="hljs-type">Ctypes</span>.(+@)</code> does. </span>
</span>. When I suggested <code class="hljs">Cstruct.to_bigarray</code>,
it warned me about the fact that this call would create a copy of the
underlying buffer. ChatGPT and Gemini Pro disagreed, and I could convince
myself that they were right by looking at the code. Interestingly, I was also
able to convince Gemini Flash it was wrong by copy/pasting the relevant code
snippet.</p>
<div class="markdown-alert markdown-alert-tip"><p class="markdown-alert-title"><svg class="octicon octicon-light-bulb mr-2" viewbox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="M8 1.5c-2.363 0-4 1.69-4 3.75 0 .984.424 1.625.984 2.304l.214.253c.223.264.47.556.673.848.284.411.537.896.621 1.49a.75.75 0 0 1-1.484.211c-.04-.282-.163-.547-.37-.847a8.456 8.456 0 0 0-.542-.68c-.084-.1-.173-.205-.268-.32C3.201 7.75 2.5 6.766 2.5 5.25 2.5 2.31 4.863 0 8 0s5.5 2.31 5.5 5.25c0 1.516-.701 2.5-1.328 3.259-.095.115-.184.22-.268.319-.207.245-.383.453-.541.681-.208.3-.33.565-.37.847a.751.751 0 0 1-1.485-.212c.084-.593.337-1.078.621-1.489.203-.292.45-.584.673-.848.075-.088.147-.173.213-.253.561-.679.985-1.32.985-2.304 0-2.06-1.637-3.75-4-3.75ZM5.75 12h4.5a.75.75 0 0 1 0 1.5h-4.5a.75.75 0 0 1 0-1.5ZM6 15.25a.75.75 0 0 1 .75-.75h2.5a.75.75 0 0 1 0 1.5h-2.5a.75.75 0 0 1-.75-.75Z"></path></svg>Tip</p><p>Having an LLM suggesting you to use a function which does not exist is <em>very</em>
frustrating. Especially if it happens several times in a row—it recognizes
its mistake and proposes an alternative that is as nonexistant as the first
one.&nbsp;At least, with LSP it is pretty straightforward to know when it happens.</p>
</div>
<p>Using Vosk is one thing, but then I couldn’t find any OCaml package to read
audio files compatible with Vosk expectations. Implementing what I needed in
OCaml gave me more opportunities to learn about EIO, but most importantly, it
showed how having a chat with an LLM directly from my editor was convenient. I
was able to learn about WAV files, RIFF header and subchunks and PCB 16-bit
mono audio data without leaving Neovim. And by giving Gemini access to my
buffer, I troubleshot most of my issues fairly quickly (except when they were
EIO-specific—more on that later).</p>
<div class="markdown-alert markdown-alert-tip"><p class="markdown-alert-title"><svg class="octicon octicon-light-bulb mr-2" viewbox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="M8 1.5c-2.363 0-4 1.69-4 3.75 0 .984.424 1.625.984 2.304l.214.253c.223.264.47.556.673.848.284.411.537.896.621 1.49a.75.75 0 0 1-1.484.211c-.04-.282-.163-.547-.37-.847a8.456 8.456 0 0 0-.542-.68c-.084-.1-.173-.205-.268-.32C3.201 7.75 2.5 6.766 2.5 5.25 2.5 2.31 4.863 0 8 0s5.5 2.31 5.5 5.25c0 1.516-.701 2.5-1.328 3.259-.095.115-.184.22-.268.319-.207.245-.383.453-.541.681-.208.3-.33.565-.37.847a.751.751 0 0 1-1.485-.212c.084-.593.337-1.078.621-1.489.203-.292.45-.584.673-.848.075-.088.147-.173.213-.253.561-.679.985-1.32.985-2.304 0-2.06-1.637-3.75-4-3.75ZM5.75 12h4.5a.75.75 0 0 1 0 1.5h-4.5a.75.75 0 0 1 0-1.5ZM6 15.25a.75.75 0 0 1 .75-.75h2.5a.75.75 0 0 1 0 1.5h-2.5a.75.75 0 0 1-.75-.75Z"></path></svg>Tip</p><p>For widespread encoding like WAV files, LLMs shine particularly bright.</p>
</div>
<p>In the end, EIO-specific code put aside, this task was roughly solved by (1)
writing bindings for the few functions of the Vosk API I needed, and (2)
translating C examples provided by Gemini into good-looking OCaml<label for="fn2" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-left sidenote note"><span class="footnote-p">It’s a little out of scope for this article, but I discovered when
writing the high-level API for Vosk that <code class="hljs language-ocaml"><span class="hljs-type">Switch</span></code>es are very easy
to misuse. It is as simple as (incorrectly) turning an eager function
consuming a buffer into a <code class="hljs">Seq</code>-based alternative, while forgetting the use
of <code class="hljs">Switch.run</code> on top of the function. </span>
</span>.</p>
<p>Witnessing my example program outputting the transcript of audio files as it
was processing them felt pretty good, and I was soon ready to tackle the second
part of this project: prompting a LLM to summarize it.</p>
<h2>Prompting Local LLMs with Ollama</h2>
<p>Similarly to Vosk, there is no on the shelf package available to use Ollama
from an OCaml program. As a consequence, I created a second repository
(<a href="https://github.com/lthms/ocaml-ollama" marked=""><code class="hljs">ocaml-ollama</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a> if you can believe it).</p>
<h3>How It Started</h3>
<p>Turns out, you don’t use Ollama the same way you use Vosk. The latter is a C
library that you can call from your binary, the former actually uses a
client/server architecture. I asked LLMs what was the best solution for
performing HTTP requests with Eio, and <code class="hljs">cohttp-eio</code> came back as a good
candidate. I’m already familiar with <code class="hljs">cohttp</code>, since we are using it at
<code class="hljs language-bash"><span class="hljs-variable">$WORK</span></code>, but it’s actually a transitive dependency (of a framework
called <a href="https://ocaml.org/p/resto/latest" marked=""><code class="hljs">resto</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>).</p>
<p>I am actually a little frustrated with <code class="hljs">resto</code>, so I welcomed the opportunity
to familiar myself a little more with <code class="hljs">cohttp</code> directly. I quickly implemented
the helper fetching the list of models available from a given Ollama instance.</p>
<p>Then, I got myself side tracked.</p>
<h3>More LLMs Lies</h3>
<p>Persistent HTTP connections are a pet peeve of mine. Establishing a TCP
connection, negotiating TLS encryption, all of that takes time—creating a new
socket for each request a daemon really frustrates me as a result.</p>
<p>So I asked.</p>
<blockquote>
<p>Does <code class="hljs">cohttp-eio</code> reuses already established connections when performing two
requests on the same host?</p>
</blockquote>
<p>ChatGPT 4o. Gemini 2.5 Flash. Gemini 2.5 Pro. They all assured me it was the
case, as long as I was careful and reused the same
<code class="hljs language-ocaml"><span class="hljs-type">Cohttp_eio</span>.<span class="hljs-type">Client</span>.t</code> instance. For instance, here is the first few
words of ChatGPT when prompted with this question.</p>
<blockquote>
<p>As of current behavior in <code class="hljs">cohttp-eio-client</code>, <strong>yes</strong>, it does <strong>reuse
already established connections</strong> when making multiple requests to the same
host, provided certain conditions are met.</p>
</blockquote>
<p>It’s a lie. Don’t trust them. They don’t reuse existing HTTP connection.</p>
<p>I was very doubtful, so I asked them how to check this. <code class="hljs">tcpdump</code> was
mentioned<label for="fn3" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">I later discovered <a href="https://github.com/ocaml-multicore/eio-trace" marked=""><code class="hljs">eio-trace</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>
and it would have been much more straightforward to use this tool to
inspect <code class="hljs language-ocaml"><span class="hljs-type">Cohttp_eio</span>.<span class="hljs-type">Client</span></code>’s default behavior. No LLM thought of
that, sadly. </span>
</span>. I got traces I couldn’t read at first glance, so I just
copy/pasted them to the LLMs… and sure enough, they confirmed what I suspected.
<code class="hljs language-ocaml"><span class="hljs-type">Cohttp_eio</span>.<span class="hljs-type">Client</span></code> does not share connections by default. It creates a
socket for each request.</p>
<p>It’s actually pretty easy to convince yourself that it is the case by reading
the implementation of
<a href="https://github.com/mirage/ocaml-cohttp/blob/main/cohttp-eio/src/client.ml#L83" marked=""><code class="hljs language-ocaml"><span class="hljs-type">Cohttp_eio</span>.<span class="hljs-type">Client</span></code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">type</span> connection = <span class="hljs-type">Eio</span>.<span class="hljs-type">Flow</span>.two_way_ty r
<span class="hljs-keyword">type</span> t = sw:<span class="hljs-type">Switch</span>.t -&gt; <span class="hljs-type">Uri</span>.t -&gt; connection

<span class="hljs-comment">(* simplified version of [make], omitting the support for HTTPS *)</span>
<span class="hljs-keyword">let</span> make <span class="hljs-literal">()</span> net : t = <span class="hljs-keyword">fun</span> ~sw uri -&gt;
  (<span class="hljs-type">Eio</span>.<span class="hljs-type">Net</span>.connect ~sw net (unix_address uri) :&gt; connection)
</code></pre>
<p>There is <em>nothing</em> here dealing with persistent connections. <code class="hljs">Eio.Net.connect</code>
uses a switch for resource management, but does not perform any kind of
connection caching.</p>
<p>That’s okay, though. Yak shaving is a real thing. I can stop working on my
Ollama client library for a while, just to <em>fix this</em>.</p>
<h3>The Questionable Side Quest of Implementing a Connection Pool for <code class="hljs">cohttp-eio</code></h3>
<p>The bottom-line of this little adventure is: I should have updated my default
prompt to remind the LLMs that <code class="hljs language-ocaml"><span class="hljs-type">Cohttp_eio</span>.<span class="hljs-type">Body</span>.drain</code> in <em>not</em> a thing.</p>
<p>But let’s start from the beginning. Over the course of a few days, I have
successfully implemented a wrapper on top of <code class="hljs language-ocaml"><span class="hljs-type">Cohttp_eio</span>.<span class="hljs-type">Client</span></code> to
deal with persistent connections. It’s not rocket science, but it’s still a
subtle endeavor, which necessitated a good understanding of Eio and <code class="hljs">cohttp</code>. I
cannot say LLMs were instrumental for the task. They gave me good pointers to
start from, but they also misled me a bunch of times.</p>
<p>Sometimes, the help came in surprising ways. One anecdote in particular
stuck with me. I decided I needed a <code class="hljs language-ocaml">get</code> operation for
<a href="https://ocaml-multicore.github.io/eio/eio/Eio/Pool/" marked=""><code class="hljs language-ocaml"><span class="hljs-type">Eio</span>.<span class="hljs-type">Pool</span></code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>
pools, which sadly only proposes <code class="hljs">use</code>.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-comment">(* Provided by Eio.Pool *)</span>
<span class="hljs-keyword">val</span> use : <span class="hljs-symbol">'a</span> t -&gt; (<span class="hljs-symbol">'a</span> -&gt; <span class="hljs-symbol">'b</span>) -&gt; <span class="hljs-symbol">'b</span>

<span class="hljs-comment">(* Not provided *)</span>
<span class="hljs-keyword">val</span> get : sw:<span class="hljs-type">Switch</span>.t -&gt; <span class="hljs-symbol">'a</span> t -&gt; <span class="hljs-symbol">'a</span>
</code></pre>
<p>The key insight is that <code class="hljs">get</code> allows callers to pick something from the pool,
and only put it back when the switch is released.</p>
<p>My first implementation of <code class="hljs">get</code> was roughly as follows<label for="fn4" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-left sidenote note"><span class="footnote-p">I didn’t even consider asking an LLM to propose me an implementation,
now that I think about it. I really am no vibe coder yet. </span>
</span>.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">open</span> <span class="hljs-type">Eio</span>.<span class="hljs-type">Std</span>

<span class="hljs-keyword">let</span> get ~sw t =
  <span class="hljs-keyword">let</span> x, rx = <span class="hljs-type">Promise</span>.create <span class="hljs-literal">()</span> <span class="hljs-keyword">in</span>
  <span class="hljs-keyword">let</span> never, _ = <span class="hljs-type">Promise</span>.create <span class="hljs-literal">()</span> <span class="hljs-keyword">in</span>
  <span class="hljs-type">Fiber</span>.fork ~sw (<span class="hljs-keyword">fun</span> <span class="hljs-literal">()</span> -&gt;
      <span class="hljs-type">Eio</span>.<span class="hljs-type">Pool</span>.use t @@ <span class="hljs-keyword">fun</span> conn -&gt;
      <span class="hljs-type">Promise</span>.resolve rx conn;
      <span class="hljs-type">Promise</span>.await never);
  <span class="hljs-type">Promise</span>.await x
</code></pre>
<p>And it didn’t work. The resulting program was hanging, because of how
<code class="hljs language-ocaml"><span class="hljs-type">Fiber</span>.fork ~sw</code> works. Basically, the fiber created by <code class="hljs">fork</code> becomes
part of the set of fibers the switch <code class="hljs">sw</code> waits for. Since, in my case, said
fiber would never be resolved, I had created a deadlock.</p>
<p>I asked Gemini Pro 2.5 for help, and out of curiosity, I looked at its
reasoning steps. Very early on, it mentioned <code class="hljs">Fiber.fork_daemon</code>, but
surprisingly <code class="hljs">Fiber.fork_daemon</code> was not mentioned in the final answer<label for="fn5" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">Once again, I had asked the wrong question. I asked for the <code class="hljs">Fiber</code>
equivalent of <code class="hljs">Lwt.async</code>. I had overlooked that <code class="hljs">Lwt.async</code> had a very
particular behavior wrt. exceptions, that Gemini Pro tried very hard to
replicate. I didn’t care at all about the exceptions I could raise, here! </span>
</span>.
Have I not been curious at that time, I would have missed the correct
solution<label for="fn6" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-left sidenote note"><span class="footnote-p"><a href="https://bsky.app/@welltypedwit.ch" marked="">@alice&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#bsky"></use></svg></span></a> provided me the answer a
few minutes later, so I’d have been fine in the end 😅. </span>
</span>.</p>
<p>I think my experience overall was made a little more frustrating than it should
have been because I have never constructed a “context” that I could share
between coding sessions. I haven’t enabled the memory saving setting in
ChatGPT. Besides, everytime I opened Neovim, Gemini was starting from scratch.
I should try to change that, to prevent the LLMs from doing the same mistakes
again and again—typically, the <code class="hljs">Cohttp_eio.Body.drain</code> function they kept
bringing up.</p>
<div class="markdown-alert markdown-alert-tip"><p class="markdown-alert-title"><svg class="octicon octicon-light-bulb mr-2" viewbox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="M8 1.5c-2.363 0-4 1.69-4 3.75 0 .984.424 1.625.984 2.304l.214.253c.223.264.47.556.673.848.284.411.537.896.621 1.49a.75.75 0 0 1-1.484.211c-.04-.282-.163-.547-.37-.847a8.456 8.456 0 0 0-.542-.68c-.084-.1-.173-.205-.268-.32C3.201 7.75 2.5 6.766 2.5 5.25 2.5 2.31 4.863 0 8 0s5.5 2.31 5.5 5.25c0 1.516-.701 2.5-1.328 3.259-.095.115-.184.22-.268.319-.207.245-.383.453-.541.681-.208.3-.33.565-.37.847a.751.751 0 0 1-1.485-.212c.084-.593.337-1.078.621-1.489.203-.292.45-.584.673-.848.075-.088.147-.173.213-.253.561-.679.985-1.32.985-2.304 0-2.06-1.637-3.75-4-3.75ZM5.75 12h4.5a.75.75 0 0 1 0 1.5h-4.5a.75.75 0 0 1 0-1.5ZM6 15.25a.75.75 0 0 1 .75-.75h2.5a.75.75 0 0 1 0 1.5h-2.5a.75.75 0 0 1-.75-.75Z"></path></svg>Tip</p><p>I need to investigate how I can specialize my default prompt for each
software project I am working on. I imagine I can rely on an environment
variable and <a href="https://direnv.net/" marked=""><code class="hljs">direnv</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>.</p>
</div>
<p>Finally, it’s when I worked on this library that I came up with a nice prompt
for Gemini to write my git commit messages for me.</p>
<blockquote>
<p><code class="hljs">@editor</code> <code class="hljs">#buffer</code> Add a git commit title and message. Structure the
description in three sections (What, Why, How). Wrap the sections at 72
columns. Don’t forget the git title, and always insert a new line between the
title and the description.</p>
</blockquote>
<p>This prompt gives pretty cool result. It is still necessary to review it,
because in a few instances I caught false statement in the proposal. But
overall, it gives really meaningful output. Almost <a href="https://github.com/lthms/cohttp-connpool-eio/commits/main/" marked="">all commits of the
library&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a> have been
written with this prompt.</p>
<div class="markdown-alert markdown-alert-tip"><p class="markdown-alert-title"><svg class="octicon octicon-light-bulb mr-2" viewbox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="M8 1.5c-2.363 0-4 1.69-4 3.75 0 .984.424 1.625.984 2.304l.214.253c.223.264.47.556.673.848.284.411.537.896.621 1.49a.75.75 0 0 1-1.484.211c-.04-.282-.163-.547-.37-.847a8.456 8.456 0 0 0-.542-.68c-.084-.1-.173-.205-.268-.32C3.201 7.75 2.5 6.766 2.5 5.25 2.5 2.31 4.863 0 8 0s5.5 2.31 5.5 5.25c0 1.516-.701 2.5-1.328 3.259-.095.115-.184.22-.268.319-.207.245-.383.453-.541.681-.208.3-.33.565-.37.847a.751.751 0 0 1-1.485-.212c.084-.593.337-1.078.621-1.489.203-.292.45-.584.673-.848.075-.088.147-.173.213-.253.561-.679.985-1.32.985-2.304 0-2.06-1.637-3.75-4-3.75ZM5.75 12h4.5a.75.75 0 0 1 0 1.5h-4.5a.75.75 0 0 1 0-1.5ZM6 15.25a.75.75 0 0 1 .75-.75h2.5a.75.75 0 0 1 0 1.5h-2.5a.75.75 0 0 1-.75-.75Z"></path></svg>Tip</p><p>If anything, I don’t think I will never open a Merge Request with an empty
description ever again.</p>
</div>
<p>And that, kids, is how I released
<a href="https://github.com/lthms/cohttp-connpool-eio" marked=""><code class="hljs">cohttp-connpool-eio.0.1</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>.</p>
<h3>Wrapping-up a Minimal Ollama Chat</h3>
<p>Integrating <code class="hljs">cohttp-connpool-eio</code> in my <code class="hljs">ocaml-ollama</code> project led me to find a
bug in the former. More specifically, the <code class="hljs language-ocaml"><span class="hljs-type">Cohttp_connpool_eio</span>.warm</code>
function that can be used to pre-populate a new pool was doing so by performing
a specified <code class="hljs">HEAD</code> request to the host as many time as the pool size<label for="fn7" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">In a later iteration of the library, <code class="hljs">warm</code> only establishes
connections, and does not perform any unnecessary HTTP requests. </span>
</span>.</p>
<p>It worked well against both <code class="hljs">https://www.google.com</code> and
<code class="hljs">https://soap.coffee/~lthms</code>, but when I tried with the Ollama server, it
decided to hang. Why?</p>
<p>Well, I tried asking my new friends the LLMs, but didn’t get any answer I felt
confident with. At this point, my trust in their EIO expertise was rather low,
and I was more skimming through their answer to find a lead I would follow
myself than anything else. In the end, I completely dropped the LLMs here, and
went back to what I usually do: experimenting, and reading code.</p>
<p>I reproduced the issue with <code class="hljs">curl</code>: <code class="hljs">curl -X HEAD</code> hangs as well with Ollama,
while <code class="hljs">curl --head</code> does not. The former tries to read the response body, based
on the response headers (<em>e.g.</em>, <code class="hljs">content-length</code>). The latter doesn’t, because
it knows <code class="hljs">HEAD</code> always omits the body. I am not sure <em>why</em>  the hanging
behavior does not show for <code class="hljs">curl -X HEAD https://www.google.com</code>, though.</p>
<p>But anyway, once the bug was fixed, I could return to playing with Ollama.</p>
<p>I then decided to implement a helper to call <a href="https://github.com/ollama/ollama/blob/main/docs/api.md#generate-a-completion" marked=""><code class="hljs">POST /api/generate</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>.
It is the simplest way with Ollama to generate an LLM’s answer from a prompt.
Interestingly enough, it is a “streamed” RPC using the <code class="hljs">application/x-ndjson</code>
content type. Instead of computing the answer <em>before</em> sending it to the
client, the server instead sends JSON-encoded chunks (<a href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Transfer-Encoding#chunked" marked=""><code class="hljs">transfer-encoding: chunked</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>).</p>
<p>I tried to implement that with <code class="hljs">cohttp-eio</code>, and it failed miserably with
obscure parsing error messages.</p>
<p>After a bit of debugging, it became clear that <code class="hljs language-ocaml"><span class="hljs-type">Eio</span>.<span class="hljs-type">Buf_read</span>.parse</code> was
not behaving as I thought it was, which made me feel paranoid about how
<code class="hljs">cohttp-connpool-eio</code> handles connection releases. In the end, I had to unpack
how the <code class="hljs language-ocaml"><span class="hljs-type">Cohttp_eio</span>.<span class="hljs-type">Body</span>.t</code> work under the hood wrt.
<code class="hljs language-ocaml"><span class="hljs-type">End_of_file</span></code> to move on. Once again, my LLM friends weren’t
particularly helpful: they were hallucinating <code class="hljs">Buf_read</code> functions, and never
considered to mention that <code class="hljs">parse</code> only works for complete response.</p>
<div class="markdown-alert markdown-alert-tip"><p class="markdown-alert-title"><svg class="octicon octicon-light-bulb mr-2" viewbox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="M8 1.5c-2.363 0-4 1.69-4 3.75 0 .984.424 1.625.984 2.304l.214.253c.223.264.47.556.673.848.284.411.537.896.621 1.49a.75.75 0 0 1-1.484.211c-.04-.282-.163-.547-.37-.847a8.456 8.456 0 0 0-.542-.68c-.084-.1-.173-.205-.268-.32C3.201 7.75 2.5 6.766 2.5 5.25 2.5 2.31 4.863 0 8 0s5.5 2.31 5.5 5.25c0 1.516-.701 2.5-1.328 3.259-.095.115-.184.22-.268.319-.207.245-.383.453-.541.681-.208.3-.33.565-.37.847a.751.751 0 0 1-1.485-.212c.084-.593.337-1.078.621-1.489.203-.292.45-.584.673-.848.075-.088.147-.173.213-.253.561-.679.985-1.32.985-2.304 0-2.06-1.637-3.75-4-3.75ZM5.75 12h4.5a.75.75 0 0 1 0 1.5h-4.5a.75.75 0 0 1 0-1.5ZM6 15.25a.75.75 0 0 1 .75-.75h2.5a.75.75 0 0 1 0 1.5h-2.5a.75.75 0 0 1-.75-.75Z"></path></svg>Tip</p><p>My personal conclusion is that ChatGPT and Gemini quickly show their limits
for non-trivial programming task involving Eio and its ecosystem.
I am really curious to understand why. Do they keep hallucinating functions
because Eio is a really generic name, and maybe they are mixing context from
the Python library with the OCaml one? Or is it because the API of Eio has
changed a lot over the years?</p>
<p>I am also wondering how, as a the author of a library, I can fix a similar
situation. Assuming ChatGPT starts assuming false statements about
<code class="hljs">cohttp-connpool-eio</code> for instance, how do I address this? I suspect being
“LLMs-friendly” will be increasingly important for a software library’s
success.</p>
</div>
<p>In the end, ChatGPT and Gemini were just another source of inputs, not the main
driver of my development process.</p>
<h2>Putting Everything Together</h2>
<p>Turns out, you really need just one RPC to generate a summary for a text input,
so it wasn’t long before I could chain everything. I pulled
<code class="hljs">mistral:7b-instruct-v0.2-q4_K_M</code> (over a suggestion by ChatGPT, if I remember
correctly), and got a summary from the video I had downloaded.</p>
<p>Just kidding. Out of nowhere, I decided to pursue yet another side quest, and
gave a try to the fancy <a href="https://dune.readthedocs.io/en/stable/tutorials/dune-package-management/dependencies.html" marked=""><code class="hljs">dune pkg lock</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>
command. <em>Then</em> I was able to <a href="https://soap.coffee/~lthms/files/RhinocerosSummary.html" marked="">generate my
summary</a>, using the following prompt.</p>
<pre><code class="hljs">Generate a summary of the raw transcript of a video provided after
this paragraph. The transcript may be in a language that is not
English, but the summary should always be in English. You should
adopt a neutral point of view (i.e., even if the transcript speaks
in the first person, you should always use the third person). Each
line is an utterance. Keep the summary short and engaging, your
goal is to provide a good overview of what was said.

----

{Vosk output}
</code></pre>
<p>And with this, it was time to wrap-up. And what better way to do so than to
write this little journal entry? So I did, and when I was half way through my
first draft, I fired a new chat buffer to ask for advice from my new friend
Gemini Flash.</p>
<blockquote>
<p>#buffer Here is a very preliminary, incomplete draft of a blogpost. Can you try to
anticipate if it will find an audience?</p>
</blockquote>
<p>It wasn’t long before Gemini turned me down.</p>
<blockquote>
<p>My apologies, but I cannot anticipate whether this blog post will find an
audience. My capabilities are focused on programming-related tasks like code
explanation, review, generation, and tool execution within the Neovim
environment.</p>
<p>Let me know if you have any questions about the code itself, or need
assistance with Neovim.</p>
</blockquote>
<p>🥲<label for="fn8" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-left sidenote note"><span class="footnote-p">Fortunately, ChatGPT was less opinionated. </span>
</span>.</p>
<h2>Final Words</h2>
<p>Although I had already used ChatGPT and other models in the past, this was the
first time I tried to make them a central part of my workflow. I learned a lot
during this experiment, and I now have an integrated setup I enjoy using.</p>
<p>I need to keep digging. Try more models (there are a lot of those now). And get
better at writing good prompts which do not lead the LLMs astray. They are here
to stay, after all. I better learn how to take the most from them.</p>
        
      
