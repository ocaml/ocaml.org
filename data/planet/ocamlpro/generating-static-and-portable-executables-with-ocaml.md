---
title: Generating static and portable executables with OCaml
description: 'Distributing OCaml software on opam is great (if I dare say so myself),
  but sometimes you need to provide your tools to an audience outside of the OCaml
  community, or just without recompilations or in a simpler way.

  However, just distributing the locally generated binaries requires that the users
  ha...'
url: https://ocamlpro.com/blog/2021_09_02_generating_static_and_portable_executables_with_ocaml
date: 2021-09-02T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Louis Gesbert\n  "
source:
---

<blockquote>
<p>Distributing OCaml software on opam is great (if I dare say so myself), but sometimes you need to provide your tools to an audience outside of the OCaml community, or just without recompilations or in a simpler way.</p>
<p>However, just distributing the locally generated binaries requires that the users have all the needed shared libraries installed, and a compatible libc. It's not something you can assume in general, and even if you don't need any C shared library or are confident enough it will be installed everywhere, the libc issue will arise for anyone using a distribution based on a different kind, or a little older than the one you used to build.</p>
<p>There is no built-in support for generating static executables in the OCaml compiler, and it may seem a bit tricky, but it's not in fact too complex to do by hand, something you may be ready to do for a release that will be published. So here are a few tricks, recipes and advice that should enable you to generate truly portable executables with no external dependency whatsoever. Both Linux and macOS will be treated, but the examples will be based on Linux unless otherwise specified.</p>
</blockquote>
<h2>Example</h2>
<p>I will take as an example a trivial HTTP file server based on <a href="https://github.com/aantron/dream">Dream</a>.</p>
<blockquote>
<details>
    <summary>Sample code</summary>
<h5>fserv.ml</h5>
<pre><code class="language-ocaml">let () = Dream.(run @@ logger @@ static &quot;.&quot;)
</code></pre>
<h5>fserv.opam</h5>
<pre><code class="language-python">opam-version: &quot;2.0&quot;
depends: [&quot;ocaml&quot; &quot;dream&quot;]
</code></pre>
<h5>dune-project</h5>
<pre><code class="language-lisp">(lang dune 2.8)
(name fserv)
</code></pre>
</details>
</blockquote>
<p>The relevant part of our <code>dune</code> file is just:</p>
<pre><code class="language-lisp">(executable
  (public_name fserv)
  (libraries dream))
</code></pre>
<p>This is how we check the resulting binary:</p>
<pre><code class="language-shell-session">$ dune build fserv.exe
      ocamlc .fserv.eobjs/byte/dune__exe__Fserv.{cmi,cmo,cmt}
    ocamlopt .fserv.eobjs/native/dune__exe__Fserv.{cmx,o}
    ocamlopt fserv.exe
$ file _build/default/fserv.exe
_build/default/fserv.exe: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=1991bb9f1d67807411c93f6fb6ec46b4a0ee8ed5, for GNU/Linux 3.2.0, with debug_info, not stripped
$ ldd _build/default/fserv.exe
        linux-vdso.so.1 (0x00007ffe97690000)
        libssl.so.1.1 =&gt; /usr/lib/x86_64-linux-gnu/libssl.so.1.1 (0x00007fd6cc636000)
        libcrypto.so.1.1 =&gt; /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1 (0x00007fd6cc342000)
        libev.so.4 =&gt; /usr/lib/x86_64-linux-gnu/libev.so.4 (0x00007fd6cc330000)
        libpthread.so.0 =&gt; /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007fd6cc30e000)
        libm.so.6 =&gt; /lib/x86_64-linux-gnu/libm.so.6 (0x00007fd6cc1ca000)
        libdl.so.2 =&gt; /lib/x86_64-linux-gnu/libdl.so.2 (0x00007fd6cc1c4000)
        libc.so.6 =&gt; /lib/x86_64-linux-gnu/libc.so.6 (0x00007fd6cbffd000)
        /lib64/ld-linux-x86-64.so.2 (0x00007fd6cced7000)
</code></pre>
<p>(on macOS, replace <code>ldd</code> with <code>otool -L</code>; dune output is obtained with <code>(display short)</code> in <code>~/.config/dune/config</code>)</p>
<p>So let's see how to change this result. Basically, here, <code>libev</code>, <code>libssl</code> and <code>libcrypto</code> are required shared libraries that may not be installed on every system, while all the others are part of the core system:</p>
<ul>
<li><code>linux-vdso</code>, <code>libdl</code> and <code>ld-linux</code> are concerned with the dynamic loading of shared objects ;
</li>
<li><code>libm</code> and <code>libpthread</code> are extensions of the core <code>libc</code> that are tightly bound to it, and always installed.
</li>
</ul>
<h2>Statically linking the libraries</h2>
<p>In simple cases, static linking can be turned on as easily as passing the <code>-static</code> flag to the C compiler: through OCaml you will need to pass <code>-cclib -static</code>. We can add that to our <code>dune</code> file:</p>
<pre><code class="language-lisp">(executable
  (public_name fserv)
  (flags (:standard -cclib -static))
  (libraries dream))
</code></pre>
<p>... which gives:</p>
<pre><code class="language-shell-session">$ dune build fserv.exe
      ocamlc .fserv.eobjs/byte/dune__exe__Fserv.{cmi,cmo,cmt}
    ocamlopt .fserv.eobjs/native/dune__exe__Fserv.{cmx,o}
    ocamlopt fserv.exe
/usr/bin/ld: /usr/lib/gcc/x86_64-linuxgnu/10/../../../x86_64-linux-gnu/libcrypto.a(dso_dlfcn.o): in function `dlfcn_globallookup':
(.text+0x13): warning: Using 'dlopen' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/usr/bin/ld: ~/.opam/4.11.0/lib/ocaml/libunix.a(initgroups.o): in function `unix_initgroups':
initgroups.c:(.text.unix_initgroups+0x1f): warning: Using 'initgroups' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
[...]
$ file _build/default/fserv.exe 
_build/default/fserv.exe: ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked, BuildID[sha1]=9ee3ae1c24fbc291d1f580bc7aaecba2777ee6c2, for GNU/Linux 3.2.0, with debug_info, not stripped
$ ldd _build/default/fserv.exe
        not a dynamic executable
</code></pre>
<p>The executable was generated... and the result <em>seems</em> OK, but we shouldn't skip all these <code>ld</code> warnings. Basically, what <code>ld</code> is telling us is that you shouldn't statically link <code>glibc</code> (it internally uses dynlinking, to libraries that also need <code>glibc</code> functions, and will therefore <strong>still</strong> need to dynlink a second version from the system &#129327;).</p>
<p>Indeed here, we have been statically linking a dynamic linking engine, among other things. Don't do it.</p>
<h3>Linux solution: linking with musl instead of glibc</h3>
<p>The easiest workaround at this point, on Linux, is to compile with <a href="http://musl.libc.org/">musl</a>, which is basically a glibc replacement that can be statically linked. There are some OCaml and gcc variants to automatically use musl (comments welcome if you have been successful with them!), but I have found the simplest option is to use a tiny Alpine Linux image through a Docker container. Here we'll use OCamlPro's <a href="https://hub.docker.com/r/ocamlpro/ocaml">minimal Docker images</a> but anything based on musl should do.</p>
<pre><code class="language-shell-session">$ docker run --rm -it ocamlpro/ocaml:4.12
[...]
~/fserv $ sudo apk add openssl-libs-static
(1/1) Installing openssl-libs-static (1.1.1l-r0)
OK: 161 MiB in 52 packages
~/fserv $ opam switch create . --deps ocaml-system
[...]
~/fserv $ eval $(opam env)
~/fserv $ dune build fserv.exe
~/fserv $ file _build/default/fserv.exe
_build/default/fserv.exe: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, with debug_info, not stripped
~/fserv $ ldd _build/default/fserv.exe
        /lib/ld-musl-x86_64.so.1 (0x7ff41353f000)
</code></pre>
<p>Almost there! We see that we had to install extra packages with <code>apk add</code>: the static libraries might not be already installed and in this case are in a separate package (you would get <code>bin/ld: cannot find -lssl</code>). The last remaining dynamic loader in the output of <code>ldd</code> is because static PIE executable were not supported <a href="https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81498#c1">until recently</a>. To get rid of it, we just need to add <code>-cclib -no-pie</code> (note: a previous revision of this blogpost mentionned <code>-static-pie</code> instead, which may work with recent compilers, but didn't seem to give reliable results):</p>
<pre><code class="language-lisp">(executable
  (public_name fserv)
  (flags (:standard -cclib -static -cclib -no-pie))
  (libraries dream))
</code></pre>
<p>And we are good!</p>
<pre><code class="language-shell-session">~/fserv $ file _build/default/fserv.exe
_build/default/fserv.exe: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, with debug_info, not stripped
~/fserv $ ldd _build/default/fserv.exe
/lib/ld-musl-x86_64.so.1: _build/default/fserv.exe: Not a valid dynamic program
</code></pre>
<blockquote>
<p><strong>Trick</strong>: short script to compile through a Docker container</p>
<p>Passing the context to a Docker container and getting the artefacts back can be bothersome and often causes file ownership issues, so I use the following snippet to pipe them to/from it using <code>tar</code>:</p>
<pre><code class="language-bash">git ls-files -z | xargs -0 tar c | 
docker run --rm -i ocamlpro/ocaml:4.12 
  sh -uexc 
    '{ tar x &amp;&amp;
       opam switch create . ocaml-system --deps-only --locked &amp;&amp;
       opam exec -- dune build --profile=release @install;
     } &gt;&amp;2 &amp;&amp; tar c -hC _build/install/default/bin .' | 
tar vx
</code></pre>
</blockquote>
<h3>The other cases: turning to manual linking</h3>
<p>Sometimes you can't use the above: the automatic linking options may need to be tweaked for static libraries, your app may still need dynlinking support at some point, or you may not have the musl option. On macOS, for example, the libc doesn't have a static version at all (and the <code>-static</code> option of <code>ld</code> is explicitely &quot;only used building the kernel&quot;). Let's get our hands dirty and see how to use a mixed static/dynamic linking scheme. First, we examine how OCaml does the linking usually:</p>
<p>The linking options are passed automatically by OCaml, using information that is embedded in the <code>cm(x)a</code> files, for example:</p>
<pre><code class="language-shell-session">$ ocamlobjinfo $(opam var lwt:lib)/unix/lwt_unix.cma |head
File ~/.opam/4.11.0/lib/lwt/unix/lwt_unix.cma
Force custom: no
Extra C object files: -llwt_unix_stubs -lev -lpthread
Extra C options:
Extra dynamically-loaded libraries: -llwt_unix_stubs
Unit name: Lwt_features
Interfaces imported:
        c21c5d26416461b543321872a551ea0d        Stdlib
        1372e035e54f502dcc3646993900232f        Lwt_features
        3a3ca1838627f7762f49679ce0278ad1        CamlinternalFormatBasics
</code></pre>
<p>Now the linking flags, here <code>-llwt_unix_stubs -lev -lpthread</code> let the C compiler choose the best way to link; in the case of stubs, they will be static (using the <code>.a</code> files &mdash; unless you make special effort to use dynamic ones), but <code>-lev</code> will let the system linker select the shared library, because it is generally preferred. Gathering these flags by hand would be tedious: my preferred trick is to just add the <code>-verbose</code> flag to OCaml (for the lazy, you can just set &mdash; temporarily &mdash; <code>OCAMLPARAM=_,verbose=1</code>):</p>
<pre><code class="language-lisp">(executable
  (public_name fserv)
  (flags (:standard -verbose))
  (libraries dream))
</code></pre>
<pre><code class="language-shell-session">$ dune build
      ocamlc .fserv.eobjs/byte/dune__exe__Fserv.{cmi,cmo,cmt}
    ocamlopt .fserv.eobjs/native/dune__exe__Fserv.{cmx,o}
+ as  -o '.fserv.eobjs/native/dune__exe__Fserv.o' '/tmp/build8eb7e5.dune/camlasm91a0b9.s'
    ocamlopt fserv.exe
+ as  -o '/tmp/build8eb7e5.dune/camlstartupc9267f.o' '/tmp/build8eb7e5.dune/camlstartup1d9915.s'
+ gcc -O2 -fno-strict-aliasing -fwrapv -Wall -Wdeclaration-after-statement -fno-common -fexcess-precision=standard -fno-tree-vrp -ffunction-sections -D_FILE_OFFSET_BITS=64 -D_REENTRANT -DCAML_NAME_SPACE  -Wl,-E -o 'fserv.exe'  '-L~/.opam/4.11.0/lib/bigstringaf' '-L~/.opam/4.11.0/lib/ocaml' '-L~/.opam/4.11.0/lib/ocaml' '-L~/.opam/4.11.0/lib/ocaml' '-L~/.opam/4.11.0/lib/lwt/unix' '-L~/.opam/4.11.0/lib/cstruct' '-L~/.opam/4.11.0/lib/mirage-crypto' '-L~/.opam/4.11.0/lib/mirage-crypto-rng/unix' '-L~/.opam/4.11.0/lib/mtime/os' '-L~/.opam/4.11.0/lib/digestif/c' '-L~/.opam/4.11.0/lib/bigarray-overlap/stubs' '-L~/.opam/4.11.0/lib/ocaml' '-L~/.opam/4.11.0/lib/ssl' '-L~/.opam/4.11.0/lib/ocaml'  '/tmp/build8eb7e5.dune/camlstartupc9267f.o' '~/.opam/4.11.0/lib/ocaml/std_exit.o' '.fserv.eobjs/native/dune__exe__Fserv.o' '~/.opam/4.11.0/lib/dream/dream.a' '~/.opam/4.11.0/lib/dream/sql/dream__sql.a' '~/.opam/4.11.0/lib/dream/http/dream__http.a' '~/.opam/4.11.0/lib/dream/websocketaf/websocketaf.a' '~/.opam/4.11.0/lib/dream/httpaf-lwt-unix/httpaf_lwt_unix.a' '~/.opam/4.11.0/lib/dream/httpaf-lwt/httpaf_lwt.a' '~/.opam/4.11.0/lib/dream/h2-lwt-unix/h2_lwt_unix.a' '~/.opam/4.11.0/lib/dream/h2-lwt/h2_lwt.a' '~/.opam/4.11.0/lib/dream/h2/h2.a' '~/.opam/4.11.0/lib/psq/psq.a' '~/.opam/4.11.0/lib/dream/httpaf/httpaf.a' '~/.opam/4.11.0/lib/dream/hpack/hpack.a' '~/.opam/4.11.0/lib/dream/gluten-lwt-unix/gluten_lwt_unix.a' '~/.opam/4.11.0/lib/lwt_ssl/lwt_ssl.a' '~/.opam/4.11.0/lib/ssl/ssl.a' '~/.opam/4.11.0/lib/dream/gluten-lwt/gluten_lwt.a' '~/.opam/4.11.0/lib/faraday-lwt-unix/faraday_lwt_unix.a' '~/.opam/4.11.0/lib/faraday-lwt/faraday_lwt.a' '~/.opam/4.11.0/lib/dream/gluten/gluten.a' '~/.opam/4.11.0/lib/faraday/faraday.a' '~/.opam/4.11.0/lib/dream/localhost/dream__localhost.a' '~/.opam/4.11.0/lib/dream/graphql/dream__graphql.a' '~/.opam/4.11.0/lib/ocaml/str.a' '~/.opam/4.11.0/lib/graphql-lwt/graphql_lwt.a' '~/.opam/4.11.0/lib/graphql/graphql.a' '~/.opam/4.11.0/lib/graphql_parser/graphql_parser.a' '~/.opam/4.11.0/lib/re/re.a' '~/.opam/4.11.0/lib/dream/middleware/dream__middleware.a' '~/.opam/4.11.0/lib/yojson/yojson.a' '~/.opam/4.11.0/lib/biniou/biniou.a' '~/.opam/4.11.0/lib/easy-format/easy_format.a' '~/.opam/4.11.0/lib/magic-mime/magic_mime_library.a' '~/.opam/4.11.0/lib/fmt/fmt_tty.a' '~/.opam/4.11.0/lib/multipart_form/lwt/multipart_form_lwt.a' '~/.opam/4.11.0/lib/dream/pure/dream__pure.a' '~/.opam/4.11.0/lib/hmap/hmap.a' '~/.opam/4.11.0/lib/multipart_form/multipart_form.a' '~/.opam/4.11.0/lib/rresult/rresult.a' '~/.opam/4.11.0/lib/pecu/pecu.a' '~/.opam/4.11.0/lib/prettym/prettym.a' '~/.opam/4.11.0/lib/bigarray-overlap/overlap.a' '~/.opam/4.11.0/lib/bigarray-overlap/stubs/overlap_stubs.a' '~/.opam/4.11.0/lib/base64/rfc2045/base64_rfc2045.a' '~/.opam/4.11.0/lib/unstrctrd/parser/unstrctrd_parser.a' '~/.opam/4.11.0/lib/unstrctrd/unstrctrd.a' '~/.opam/4.11.0/lib/uutf/uutf.a' '~/.opam/4.11.0/lib/ke/ke.a' '~/.opam/4.11.0/lib/fmt/fmt.a' '~/.opam/4.11.0/lib/base64/base64.a' '~/.opam/4.11.0/lib/digestif/c/digestif_c.a' '~/.opam/4.11.0/lib/stdlib-shims/stdlib_shims.a' '~/.opam/4.11.0/lib/dream/graphiql/dream__graphiql.a' '~/.opam/4.11.0/lib/dream/cipher/dream__cipher.a' '~/.opam/4.11.0/lib/mirage-crypto-rng/lwt/mirage_crypto_rng_lwt.a' '~/.opam/4.11.0/lib/mtime/os/mtime_clock.a' '~/.opam/4.11.0/lib/mtime/mtime.a' '~/.opam/4.11.0/lib/duration/duration.a' '~/.opam/4.11.0/lib/mirage-crypto-rng/unix/mirage_crypto_rng_unix.a' '~/.opam/4.11.0/lib/mirage-crypto-rng/mirage_crypto_rng.a' '~/.opam/4.11.0/lib/mirage-crypto/mirage_crypto.a' '~/.opam/4.11.0/lib/eqaf/cstruct/eqaf_cstruct.a' '~/.opam/4.11.0/lib/eqaf/bigstring/eqaf_bigstring.a' '~/.opam/4.11.0/lib/eqaf/eqaf.a' '~/.opam/4.11.0/lib/cstruct/cstruct.a' '~/.opam/4.11.0/lib/caqti-lwt/caqti_lwt.a' '~/.opam/4.11.0/lib/lwt/unix/lwt_unix.a' '~/.opam/4.11.0/lib/ocaml/threads/threads.a' '~/.opam/4.11.0/lib/ocplib-endian/bigstring/ocplib_endian_bigstring.a' '~/.opam/4.11.0/lib/ocplib-endian/ocplib_endian.a' '~/.opam/4.11.0/lib/mmap/mmap.a' '~/.opam/4.11.0/lib/ocaml/bigarray.a' '~/.opam/4.11.0/lib/ocaml/unix.a' '~/.opam/4.11.0/lib/logs/logs_lwt.a' '~/.opam/4.11.0/lib/lwt/lwt.a' '~/.opam/4.11.0/lib/caqti/caqti.a' '~/.opam/4.11.0/lib/uri/uri.a' '~/.opam/4.11.0/lib/angstrom/angstrom.a' '~/.opam/4.11.0/lib/bigstringaf/bigstringaf.a' '~/.opam/4.11.0/lib/bigarray-compat/bigarray_compat.a' '~/.opam/4.11.0/lib/stringext/stringext.a' '~/.opam/4.11.0/lib/ptime/ptime.a' '~/.opam/4.11.0/lib/result/result.a' '~/.opam/4.11.0/lib/logs/logs.a' '~/.opam/4.11.0/lib/ocaml/stdlib.a' '-lssl_stubs' '-lssl' '-lcrypto' '-lcamlstr' '-loverlap_stubs_stubs' '-ldigestif_c_stubs' '-lmtime_clock_stubs' '-lrt' '-lmirage_crypto_rng_unix_stubs' '-lmirage_crypto_stubs' '-lcstruct_stubs' '-llwt_unix_stubs' '-lev' '-lpthread' '-lthreadsnat' '-lpthread' '-lunix' '-lbigstringaf_stubs' '~/.opam/4.11.0/lib/ocaml/libasmrun.a' -lm -ldl
</code></pre>
<p>There is a lot of noise, but the interesting part is at the end, the <code>-l*</code> options before the standard <code>ocaml/libasmrun -lm -ldl</code>:</p>
<pre><code class="language-shell-session">  '-lssl_stubs' '-lssl' '-lcrypto' '-lcamlstr' '-loverlap_stubs_stubs' '-ldigestif_c_stubs' '-lmtime_clock_stubs' '-lrt' '-lmirage_crypto_rng_unix_stubs' '-lmirage_crypto_stubs' '-lcstruct_stubs' '-llwt_unix_stubs' '-lev' '-lpthread' '-lthreadsnat' '-lpthread' '-lunix' '-lbigstringaf_stubs'
</code></pre>
<h4>Manually linking with glibc (Linux)</h4>
<p>To link these statically, but the glibc dynamically:</p>
<ul>
<li>we disable the automatic generation of linking flags by OCaml with <code>-noautolink</code>
</li>
<li>we pass directives to the linker through OCaml and the C compiler, using <code>-cclib -Wl,xxx</code>. <code>-Bstatic</code> makes static linking the preferred option
</li>
<li>we escape the linking flags we extracted above through <code>-cclib</code>
</li>
</ul>
<pre><code class="language-lisp">(executable
  (public_name fserv)
  (flags (:standard
          -noautolink
          -cclib -Wl,-Bstatic
          -cclib -lssl_stubs                    -cclib -lssl
          -cclib -lcrypto                       -cclib -lcamlstr
          -cclib -loverlap_stubs_stubs          -cclib -ldigestif_c_stubs
          -cclib -lmtime_clock_stubs            -cclib -lrt
          -cclib -lmirage_crypto_rng_unix_stubs -cclib -lmirage_crypto_stubs
          -cclib -lcstruct_stubs                -cclib -llwt_unix_stubs
          -cclib -lev                           -cclib -lthreadsnat
          -cclib -lunix                         -cclib -lbigstringaf_stubs
          -cclib -Wl,-Bdynamic
          -cclib -lpthread))
  (libraries dream))
</code></pre>
<p>Note that <code>-lpthread</code> and <code>-lm</code> are tightly bound to the libc and can't be static in this case, so we moved <code>-lpthread</code> to the end, outside of the static section. The part between the <code>-Bstatic</code> and the <code>-Bdynamic</code> is what will be statically linked, leaving the defaults and the libc dynamic. Result:</p>
<pre><code class="language-shell-session">$ dune build fserv.exe &amp;&amp; ldd _build/default/fserv.exe
      ocamlc .fserv.eobjs/byte/dune__exe__Fserv.{cmi,cmo,cmt}
    ocamlopt .fserv.eobjs/native/dune__exe__Fserv.{cmx,o}
    ocamlopt fserv.exe
$ file _build/default/fserv.exe
_build/default/fserv.exe: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=31c93085284da5d74002218b1d6b61c0efbdefe4, for GNU/Linux 3.2.0, with debug_info, not stripped
$ ldd _build/default/fserv.exe
        linux-vdso.so.1 (0x00007ffe207c5000)
        libpthread.so.0 =&gt; /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f49d5e56000)
        libm.so.6 =&gt; /lib/x86_64-linux-gnu/libm.so.6 (0x00007f49d5d12000)
        libdl.so.2 =&gt; /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f49d5d0c000)
        libc.so.6 =&gt; /lib/x86_64-linux-gnu/libc.so.6 (0x00007f49d5b47000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f49d69bf000)
</code></pre>
<p>The remaining are the base of the dynamic linking / shared object systems, but we got away with <code>libssl</code>, <code>libcrypto</code> and <code>libev</code>, which were the ones possibly absent from target systems. The resulting executable should work on any glibc-based Linux distribution that is recent enough; on older ones you will likely get missing <code>GLIBC</code> symbols.</p>
<p>If you need to distribute that way, it's a good idea to compile on an old release (like Debian 'oldstable' or 'oldoldstable') for maximum portability.</p>
<h4>Manually linking on macOS</h4>
<p>Unfortunately, the linker on macOS doesn't seem to have options to select the static versions of the libraries; the only solution is to get our hands even dirtier, and link directly to the <code>.a</code> files, instead of using <code>-l</code> arguments.</p>
<p>Most of the flags just link with stubs, we can keep them as is: <code>-lssl_stubs</code> <code>-lcamlstr</code> <code>-loverlap_stubs_stubs</code> <code>-ldigestif_c_stubs</code> <code>-lmtime_clock_stubs</code> <code>-lmirage_crypto_rng_unix_stubs</code> <code>-lmirage_crypto_stubs</code> <code>-lcstruct_stubs</code> <code>-llwt_unix_stubs</code> <code>-lthreadsnat</code> <code>-lunix</code> <code>-lbigstringaf_stubs</code></p>
<p>That leaves us with: <code>-lssl</code> <code>-lcrypto</code> <code>-lev</code> <code>-lpthread</code></p>
<ul>
<li><code>lpthread</code> is built-in, we can ignore it
</li>
<li>for the others, we need to lookup the <code>.a</code> file: I use <em>e.g.</em>
<pre><code class="language-shell-session">$ echo $(pkg-config libssl --variable libdir)/libssl.a
~/brew/Cellar/openssl@1.1/1.1.1k/lib/libcrypto.a
</code></pre>
</li>
</ul>
<p>Of course you don't want to hardcode these paths, but let's test for now:</p>
<pre><code class="language-lisp">(executable
  (public_name fserv)
  (flags (:standard
          -noautolink
          -cclib -lssl_stubs           -cclib -lcamlstr
          -cclib -loverlap_stubs_stubs -cclib -ldigestif_c_stubs
          -cclib -lmtime_clock_stubs   -cclib -lmirage_crypto_rng_unix_stubs
          -cclib -lmirage_crypto_stubs -cclib -lcstruct_stubs
          -cclib -llwt_unix_stubs      -cclib -lthreadsnat
          -cclib -lunix                -cclib -lbigstringaf_stubs
          -cclib ~/brew/Cellar/openssl@1.1/1.1.1k/lib/libssl.a
          -cclib ~/brew/Cellar/openssl@1.1/1.1.1k/lib/libcrypto.a
          -cclib ~/brew/Cellar/libev/4.33/lib/libev.a))
  (libraries dream))
</code></pre>
<pre><code class="language-shell-session">$ dune build fserv.exe
      ocamlc .fserv.eobjs/byte/dune__exe__Fserv.{cmi,cmo,cmt}
    ocamlopt .fserv.eobjs/native/dune__exe__Fserv.{cmx,o}
    ocamlopt fserv.exe
$ file _build/default/fserv.exe
_build/default/fserv.exe: Mach-O 64-bit executable x86_64
$ otool -L _build/default/fserv.exe
_build/default/fserv.exe:
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1292.60.1)
</code></pre>
<p>This is as good as it will get!</p>
<h2>Cleaning up the build system</h2>
<p>We have until now been adding the linking flags manually in the <code>dune</code> file; you probably don't want to do that and be restricted to static builds only! Not counting the non-portable link options we have been using...</p>
<h3>The quick&amp;dirty way</h3>
<p>Don't use this in your build system! But for quick testing you can conveniently pass flags to the OCaml compilers using the <code>OCAMLPARAM</code> variable. Combined with the tar/docker snippet above, we get a very simple static-binary generating command:</p>
<pre><code class="language-bash">git ls-files -z | xargs -0 tar c | 
docker run --rm -i ocamlpro/ocaml:4.12 
  sh -uexc '{
    tar x &amp;&amp;
    sudo apk add openssl-libs-static &amp;&amp;
    opam switch create . ocaml-system --deps-only --locked &amp;&amp;
    OCAMLPARAM=_,cclib=-static,cclib=-no-pie opam exec -- dune build --profile=release @install;
  } &gt;&amp;2 &amp;&amp; tar c -hC _build/install/default/bin .' | 
tar vx
</code></pre>
<p>Note that, for releases, you may also want to <code>strip</code> the generated binaries.</p>
<h3>Making it an option of the build system (with dune)</h3>
<p>For something you will want to commit, I recommend to generate the flags in a separate file <code>linking-flags-fserv.sexp</code>:</p>
<pre><code class="language-lisp">(executable
  (public_name fserv)
  (flags (:standard (:include linking-flags-fserv.sexp)))
  (libraries dream))
</code></pre>
<p>The linking flags will depend on the chosen linking mode and on the OS. For the OS, it's easiest to generate them through a script ; for the linking mode, I use an environment variable to optionally turn static linking on.</p>
<pre><code class="language-lisp">(rule
  (with-stdout-to linking-flags-fserv.sexp
    (run ./gen-linking-flags.sh %{env:LINKING_MODE=dynamic} %{ocaml-config:system})))
</code></pre>
<p>This will use the following <code>gen-linking-flags.sh</code> script to generate the file, passing it the value of <code>$LINKING_MODE</code> and defaulting to <code>dynamic</code>. Doing it this way also ensures that <code>dune</code> will properly recompile when the value of the environment variable changes.</p>
<pre><code class="language-bash">#!/bin/sh
set -ue

LINKING_MODE=&quot;$1&quot;
OS=&quot;$2&quot;
FLAGS=
CCLIB=

case &quot;$LINKING_MODE&quot; in
    dynamic)
        ;; # No extra flags needed
    static)
        case &quot;$OS&quot; in
            linux) # Assuming Alpine here
                CCLIB=&quot;-static -no-pie&quot;;;
            macosx)
                FLAGS=&quot;-noautolink&quot;
                CCLIB=&quot;-lssl_stubs -lcamlstr -loverlap_stubs_stubs
                       -ldigestif_c_stubs -lmtime_clock_stubs
                       -lmirage_crypto_rng_unix_stubs -lmirage_crypto_stubs
                       -lcstruct_stubs -llwt_unix_stubs -lthreadsnat -lunix
                       -lbigstringaf_stubs&quot;
                LIBS=&quot;libssl libcrypto libev&quot;
                for lib in $LIBS; do
                    CCLIB=&quot;$CCLIB $(pkg-config $lib --variable libdir)/$lib.a&quot;
                done;;
            *)
                echo &quot;No known static compilation flags for '$OS'&quot; &gt;&amp;2
                exit 1
        esac;;
    *)
        echo &quot;Invalid linking mode '$LINKING_MODE'&quot; &gt;&amp;2
        exit 2
esac

echo '('
for f in $FLAGS; do echo &quot;  $f&quot;; done
for f in $CCLIB; do echo &quot;  -cclib $f&quot;; done
echo ')'
</code></pre>
<p>Then you'll only have to run <code>LINKING_MODE=static dune build fserv.exe</code> to generate the static executable (wrapped in the Docker script above, in the case of Alpine), and can include that in your CI as well.</p>
<p>For real-world examples, you can check <a href="https://github.com/ocaml-sf/learn-ocaml/blob/master/scripts/static-build.sh">learn-ocaml</a> or <a href="https://github.com/ocaml/opam/blob/master/release/Makefile">opam</a>.</p>
<blockquote>
<h2>Related topics</h2>
<ul>
<li><a href="https://github.com/ocaml/opam/releases/download/2.1.0/opam-2.1.0-x86_64-macos">reproducible builds</a> should be a goal when you intend to distribute pre-compiled binaries.
</li>
<li><a href="https://github.com/AltGr/opam-bundle">opam-bundle</a> is a different, heavy-weight approach to distributing opam software to non-OCaml developers, that retains the &quot;compile all from source&quot; policy but provides one big package that bootstraps OCaml, opam and all the dependencies with a single command.-
</li>
</ul>
</blockquote>

