---
title: Opentrace
description:
url: https://patrick.sirref.org/open-trace/
date: 2025-05-19T00:00:00-00:00
preview_image:
authors:
- https://patrick.sirref.org/Patrick%20Ferris/
source:
ignore:
---


        <p>Thanks to <a href="https://github.com/koonwen/">Koonwen's</a> excellent <a href="https://github.com/koonwen/ocaml-libbpf">libbpf bindings in OCaml</a>, I have been building a little tool called <code>opentrace</code> to make it easier to track an executable's inputs and outputs.</p>
        <p>This work was inspired my <a href="https://patrick.sirref.org/mdales/">Michael's</a> self-proclaimed "gross hack": <a href="https://github.com/quantifyearth/pyshark">pyshark</a>. Whilst pyshark achieves its goals by injecting code into commonly used python objects and methods, <a href="https://patrick.sirref.org/opentrace/">opentrace</a> uses <a href="https://ebpf.io/">eBPF</a>. By using a lower-level API (hooks in the kernel), <a href="https://patrick.sirref.org/opentrace/">opentrace</a> can remain programming language agnostic. However, less information is none about the user's intent compared to something like pyshark.</p>
        <section>
          <header>
            <h2>Monitoring the System</h2>
          </header>
          <p><a href="https://patrick.sirref.org/opentrace/">opentrace</a> has an <code>all</code> command that will trace the entire system.</p>
          <pre>$ sudo opentrace all --flags=O_WRONLY
pid,cgid,comm,kind,flags,mode,filename,return
16324,4417,".nheko-wrapped",openat,577,438,"/home/patrick/.cache/nheko/nheko/curl_alt_svc_cache.txt",47
16324,4417,".nheko-wrapped",openat,193,33188,"/home/patrick/.cache/nheko/nheko/cr3ZUHqBErIOe3PlwJ1SuU8zFKKxL12VzrRoHYMH.tmp",47
16324,4417,".nheko-wrapped",openat,577,438,"/home/patrick/.cache/nheko/nheko/curl_alt_svc_cache.txt",47
16324,4417,".nheko-wrapped",openat,193,33188,"/home/patrick/.cache/nheko/nheko/QfZTdZSuC56NdcDQ3aMxJc3BhMhAj8PmtYW1zFDP.tmp",47
2530,4235,"systemd",openat,524865,438,"/sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/app.slice/gammastep.service/cgroup.subtree_control",41
2530,4235,"systemd",openat,524545,0,"/sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/app.slice/gammastep.service/memory.min",41
2530,4235,"systemd",openat,524545,0,"/sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/app.slice/gammastep.service/memory.low",41
2530,4235,"systemd",openat,524545,0,"/sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/app.slice/gammastep.service/memory.high",41
2530,4235,"systemd",openat,524545,0,"/sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/app.slice/gammastep.service/memory.max",41</pre>
          <p>The <code>--flags=O_WRONLY</code> argument filters the events where the <code>O_WRONLY</code> flag was set in the call to <code>open</code>.</p>
          <p>We also get the name of the current executable linked to the task ( <code>comm</code>). The <code>-wrapped</code> is an artefact of using Nix.</p>
        </section>
        <section>
          <header>
            <h2>Tracing an Executable</h2>
          </header>
          <p>The primary use case for this tool is to inspect what files your program might be reading and writing.</p>
          <pre>$ sudo opentrace exec --format=json --flags=O_CREAT -- opam list
$ cat trace.json | jq ".[] | .fname"
"/home/patrick/.opam/cshell/.opam-switch/packages/cache"
"/home/patrick/.opam/log/log-118747-29da3d.out"
"/home/patrick/.opam/log/log-118747-29da3d.err"
"/home/patrick/.opam/log/log-118747-29da3d.env"
"/home/patrick/.opam/log/log-118747-29da3d.info"</pre>
          <p>The "flags" argument can specify a small boolean formula for checking the open flags of a particular event with <code>|</code> (or), <code>&amp;</code> (and), and <code>~</code> (not).  Parentheses can be used for precedence.</p>
          <pre>$ sudo opentrace exec --flags="O_WRONLY|O_RDONLY" -- ocaml --version</pre>
        </section>
        <section>
          <header>
            <h2>Spawning Subprocesses</h2>
          </header>
          <p>One feature <a href="https://patrick.sirref.org/opentrace/">opentrace</a> needs (in this proof-of-concept phase) is the ability to also trace subprocesses.</p>
          <p><a href="https://patrick.sirref.org/opentrace/">opentrace</a> is primarily an eBPF program that is loaded into the kernel and communicates with an OCaml program. Events are communicated via a ring buffer and most of the post-processing happens in OCaml. To capture subprocesses, <a href="https://patrick.sirref.org/opentrace/">opentrace</a> creates a new control group (cgroup) and places the new process into that group.  This gives <a href="https://patrick.sirref.org/opentrace/">opentrace</a> a new identifier to track, namely the cgroup.</p>
          <p>So consider the following program.</p>
          <pre class="hilite">            <code><span class="ocaml-keyword-other">let</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-unit">() </span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-constant-language-capital-identifier">Eio_posix</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">run</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">@@</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other">fun</span><span class="ocaml-source"> </span><span class="ocaml-source">env</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">-&gt;</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-constant-language-capital-identifier">Eio</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-constant-language-capital-identifier">Path</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">( </span><span class="ocaml-source">save</span><span class="ocaml-source"> ~</span><span class="ocaml-source">create</span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-source">( </span><span class="ocaml-constant-language-polymorphic-variant">`Or_truncate</span><span class="ocaml-source"> </span><span class="ocaml-constant-numeric-octal-integer">0o664</span><span class="ocaml-source">) </span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source">env</span><span class="ocaml-keyword-other">#</span><span class="ocaml-source">fs</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">/</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">hello.txt</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source">) </span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">hello</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source">) </span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-constant-language-capital-identifier">Eio</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-constant-language-capital-identifier">Process</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">run</span><span class="ocaml-source"> </span><span class="ocaml-source">env</span><span class="ocaml-keyword-other">#</span><span class="ocaml-source">process_mgr</span><span class="ocaml-source">
</span>
<span class="ocaml-source">    </span><span class="ocaml-source">[ </span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">/bin/bash</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">-c</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">echo 'heya' &gt; heya.txt</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source"> </span><span class="ocaml-source">] </span><span class="ocaml-source">
</span></code>
          </pre>
          <p>It first creates a file using direct calls to functions like <code>openat</code>. Then it spawns a process which creates a new file called <code>heya.txt</code>. This happens in a separate process. However, with the <code>--cgroups</code> flag we can capture both interactions with the operating system.</p>
          <pre>$ sudo opentrace exec --cgroups --flags="O_CREAT|O_TRUNC" ./main.exe
pid,cgid,comm,kind,flags,mode,filename,return
153187,530807,"main.exe",openat,526914,436,"hello.txt",5
153192,530807,"bash",openat,577,438,"heya.txt",3</pre>
          <section>
            <header>
              <h3>Eio's Process API</h3>
            </header>
            <p>I have used the <code>Eio_unix</code> <a href="https://ocaml.org/p/eio/latest/doc/Eio_unix/Process/index.html">fork action process API</a> to be able to extend what happens in the child process. Loading most eBPF programs into the kernel requires special privileges hence the need for <code>sudo</code>. When a user requests for a particular program to be executed and traced, <a href="https://patrick.sirref.org/opentrace/">opentrace</a> spawns a process via the Eio Process API. <a href="https://patrick.sirref.org/opentrace/">Opentrace</a> defines a few new so-called "fork actions", little fragments of C code that are run after the call to <code>fork</code> ( <code>clone</code>).  Most likely this ends with a call to <code>execve</code>, but other calls are possible for example <code>setuid</code> allowing <a href="https://patrick.sirref.org/opentrace/">opentrace</a> to change the user of the child process so it does not run as <code>root</code>. Similarly, this is where (if used) we create the cgroup and place the process  into that group.</p>
          </section>
        </section>
        <section>
          <header>
            <h2>Limitations: Io_uring</h2>
          </header>
          <p>Whilst testing <code>opentrace</code> against some of the tools I use nearly daily, I noticed some events were being missed. I tried tracing <a href="https://patrick.sirref.org/forester/">forester</a>, and only the initial read of <code>forest.toml</code> was logged. It dawned on me that the reason for this was that <a href="https://patrick.sirref.org/forester/">forester</a> (via <a href="https://patrick.sirref.org/eio/">eio</a>) was using <a href="https://patrick.sirref.org/io_uring/">io_uring</a> to perform most of the IO. Most attempts to open files were bypassing the open system calls, and instead they were being performed by the kernel after reading a submission request for an <code>openat2</code>-style call!</p>
          <p>This is not news to seasoned, Linux systems programmers. Io_uring <a href="https://blog.0x74696d.com/posts/iouring-and-seccomp/">bypasses <code>SECCOMP</code> filters</a> for exactly the same reasons.</p>
          <pre>$ sudo opentrace exec -- forester build
$ cat trace.csv
pid,cgid,comm,kind,flags,mode,filename,return
155007,535570,"forester",openat,524288,0,"forest.toml",5
155007,535570,"forester",Uring,2621440,0,"",0
155021,535570,"cp",openat,131072,0,"/home/patrick/documents/forest/theme/favicon-32x32.png",4
155007,535570,"forester",Uring,2686976,0,"",0
155007,535570,"iou-wrk-155007",Uring,557634,420,"",0
155007,535570,"iou-wrk-155007",Uring,557634,420,"",0
155007,535570,"iou-wrk-155007",Uring,557634,420,"",0</pre>
          <p>It is interesting to note two things here:</p>
          <ol>
            <li>
              <p>We can tell that <a href="https://patrick.sirref.org/forester/">forester</a> reads the configuration file probably using something like <code>In_channel</code> in OCaml ( <a href="https://git.sr.ht/~jonsterling/ocaml-forester/tree/7f275290e211db2590b0d715d8fb47fc1de36550/item/lib/frontend/Config.mlL22">it does</a>).</p>
            </li>
            <li>
              <p>It appears that Uring is performing IO in both worker threads and directly.</p>
            </li>
          </ol>
          <p>The file paths are empty at the moment as I cannot find a clean way to trace openat submission requests into Uring without it sometimes going very wrong. I have tried quite a few methods (e.g. tracing <code>do_filp_open</code>) and at the moment I am tracing <code>io_openat2</code>, but this seems quite brittle, and often the filename is completely garbled, so I do not set it. If anyone has any ideas to trace Io_uring more reliably, I am all ears!</p>
        </section>
      
