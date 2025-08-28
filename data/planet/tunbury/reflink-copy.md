---
title: Reflink Copy
description: "I hadn\u2019t intended to write another post about traversing a directory
  structure or even thinking about it again, but weirdly, it just kept coming up again!"
url: https://www.tunbury.org/2025/07/15/reflink-copy/
date: 2025-07-15T00:00:00-00:00
preview_image: https://www.tunbury.org/images/ocaml-logo.png
authors:
- Mark Elvers
source:
ignore:
---

<p>I hadn’t intended to write another <a href="https://www.tunbury.org/2025/07/08/unix-or-sys/">post</a> about traversing a directory structure or even thinking about it again, but weirdly, it just kept coming up again!</p>

<p>Firstly, Patrick mentioned <code class="language-plaintext highlighter-rouge">Eio.Path.read_dir</code> and Anil mentioned <a href="https://tavianator.com/2023/bfs_3.0.html">bfs</a>. Then Becky commented about XFS reflink performance, and I commented that the single-threaded nature of <code class="language-plaintext highlighter-rouge">cp -r --reflink=always</code> was probably hurting our <a href="https://github.com/ocurrent/obuilder">obuilder</a> performance tests.</p>

<p>Obuilder is written in LWT, which has <code class="language-plaintext highlighter-rouge">Lwt_unix.readdir</code>. What if we had a pool of threads that would traverse the directory structure in parallel and create a reflinked copy?</p>

<p>Creating a reflink couldn’t be easier. There’s an <code class="language-plaintext highlighter-rouge">ioctl</code> call that <em>just</em> does it. Such a contrast to the ReFS copy-on-write implementation on Windows!</p>

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="cp">#include</span> <span class="cpf">&lt;caml/mlvalues.h&gt;</span><span class="cp">
#include</span> <span class="cpf">&lt;caml/memory.h&gt;</span><span class="cp">
#include</span> <span class="cpf">&lt;caml/unixsupport.h&gt;</span><span class="cp">
#include</span> <span class="cpf">&lt;sys/ioctl.h&gt;</span><span class="cp">
#include</span> <span class="cpf">&lt;errno.h&gt;</span><span class="cp">
</span>
<span class="cp">#ifndef FICLONE
#define FICLONE 0x40049409
#endif
</span>
<span class="n">value</span> <span class="nf">caml_ioctl_ficlone</span><span class="p">(</span><span class="n">value</span> <span class="n">dst_fd</span><span class="p">,</span> <span class="n">value</span> <span class="n">src_fd</span><span class="p">)</span> <span class="p">{</span>
    <span class="n">CAMLparam2</span><span class="p">(</span><span class="n">dst_fd</span><span class="p">,</span> <span class="n">src_fd</span><span class="p">);</span>
    <span class="kt">int</span> <span class="n">result</span><span class="p">;</span>

    <span class="n">result</span> <span class="o">=</span> <span class="n">ioctl</span><span class="p">(</span><span class="n">Int_val</span><span class="p">(</span><span class="n">dst_fd</span><span class="p">),</span> <span class="n">FICLONE</span><span class="p">,</span> <span class="n">Int_val</span><span class="p">(</span><span class="n">src_fd</span><span class="p">));</span>

    <span class="k">if</span> <span class="p">(</span><span class="n">result</span> <span class="o">==</span> <span class="o">-</span><span class="mi">1</span><span class="p">)</span> <span class="p">{</span>
        <span class="n">uerror</span><span class="p">(</span><span class="s">"ioctl_ficlone"</span><span class="p">,</span> <span class="n">Nothing</span><span class="p">);</span>
    <span class="p">}</span>

    <span class="n">CAMLreturn</span><span class="p">(</span><span class="n">Val_int</span><span class="p">(</span><span class="n">result</span><span class="p">));</span>
<span class="p">}</span>
</code></pre></div></div>

<p>We can write a reflink copy function as shown below. (Excuse my error handling.) Interestingly, points to note: the permissions set via <code class="language-plaintext highlighter-rouge">Unix.openfile</code> are filtered through umask, and you need to <code class="language-plaintext highlighter-rouge">Unix.fchown</code> before <code class="language-plaintext highlighter-rouge">Unix.fchmod</code> if you want to set the suid bit set.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">external</span> <span class="n">ioctl_ficlone</span> <span class="o">:</span> <span class="nn">Unix</span><span class="p">.</span><span class="n">file_descr</span> <span class="o">-&gt;</span> <span class="nn">Unix</span><span class="p">.</span><span class="n">file_descr</span> <span class="o">-&gt;</span> <span class="kt">int</span> <span class="o">=</span> <span class="s2">"caml_ioctl_ficlone"</span>

<span class="k">let</span> <span class="n">copy_file</span> <span class="n">src</span> <span class="n">dst</span> <span class="n">stat</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">src_fd</span> <span class="o">=</span> <span class="nn">Unix</span><span class="p">.</span><span class="n">openfile</span> <span class="n">src</span> <span class="p">[</span><span class="nc">O_RDONLY</span><span class="p">]</span> <span class="mi">0</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">dst_fd</span> <span class="o">=</span> <span class="nn">Unix</span><span class="p">.</span><span class="n">openfile</span> <span class="n">dst</span> <span class="p">[</span><span class="nc">O_WRONLY</span><span class="p">;</span> <span class="nc">O_CREAT</span><span class="p">;</span> <span class="nc">O_TRUNC</span><span class="p">]</span> <span class="mo">0o600</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">_</span> <span class="o">=</span> <span class="n">ioctl_ficlone</span> <span class="n">dst_fd</span> <span class="n">src_fd</span> <span class="k">in</span>
  <span class="nn">Unix</span><span class="p">.</span><span class="n">fchown</span> <span class="n">dst_fd</span> <span class="n">stat</span><span class="o">.</span><span class="n">st_uid</span> <span class="n">stat</span><span class="o">.</span><span class="n">st_gid</span><span class="p">;</span>
  <span class="nn">Unix</span><span class="p">.</span><span class="n">fchmod</span> <span class="n">dst_fd</span> <span class="n">stat</span><span class="o">.</span><span class="n">st_perm</span><span class="p">;</span>
  <span class="nn">Unix</span><span class="p">.</span><span class="n">close</span> <span class="n">src_fd</span><span class="p">;</span>
  <span class="nn">Unix</span><span class="p">.</span><span class="n">close</span> <span class="n">dst_fd</span><span class="p">;</span>
</code></pre></div></div>

<p>My LWT code created a list of all the files in a directory and then processed the list with <code class="language-plaintext highlighter-rouge">Lwt_list.map_s</code> (serially), returning promises for all the file operations and creating threads for new directory operations up to a defined maximum (8). If there was no thread capacity, it just recursed in the current thread. Copying a root filesystem, this gave me threads for <code class="language-plaintext highlighter-rouge">var</code>, <code class="language-plaintext highlighter-rouge">usr</code>, etc, just as we’d want. Wow! This was slow. Nearly 4 minutes to reflink 1.7GB!</p>

<p>What about using the threads library rather than LWT threads? This appears significantly better, bringing the execution time down to 40 seconds. However, I think a lot of that was down to my (bad) LWT implementation vs my somewhat better threads implementation.</p>

<p>At this point, I should probably note that <code class="language-plaintext highlighter-rouge">cp -r --reflink always</code> on 1.7GB, 116,000 files takes 8.5 seconds on my machine using a loopback XFS. A sequential OCaml version, without the overhead of threads or any need to maintain a list of work to do, takes 9.0 seconds.</p>

<p>Giving up and getting on with other things was very tempting, but there was that nagging feeling of not bottoming out the problem.</p>

<p>Using OCaml Multicore, we can write a true multi-threaded version. I took a slightly different approach, having a work queue of directories to process, and N worker threads taking work from the queue.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>Main Process: Starts with root directory
     ↓
WorkQueue: [process_dir(/root)]
     ↓
Domain 1: Takes work → processes files → adds subdirs to queue
Domain 2: Takes work → processes files → adds subdirs to queue
Domain 3: Takes work → processes files → adds subdirs to queue
     ↓
WorkQueue: [process_dir(/root/usr), process_dir(/root/var), ...]
</code></pre></div></div>

<p>Below is a table showing the performance when using multiple threads compared to the baseline operation of <code class="language-plaintext highlighter-rouge">cp</code> and a sequential copy in OCaml.</p>

<table>
  <thead>
    <tr>
      <th>Copy command</th>
      <th>Duration (sec)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>cp -r –reflink=always</td>
      <td>8.49</td>
    </tr>
    <tr>
      <td>Sequential</td>
      <td>8.80</td>
    </tr>
    <tr>
      <td>2 domains</td>
      <td>5.45</td>
    </tr>
    <tr>
      <td>4 domains</td>
      <td>3.28</td>
    </tr>
    <tr>
      <td>6 domains</td>
      <td>3.43</td>
    </tr>
    <tr>
      <td>8 domains</td>
      <td>5.24</td>
    </tr>
    <tr>
      <td>10 domains</td>
      <td>9.07</td>
    </tr>
  </tbody>
</table>

<p>The code is available on GitHub in <a href="https://github.com/mtelvers/reflink">mtelvers/reflink</a>.</p>
