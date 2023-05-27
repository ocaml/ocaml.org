---
title: OCaml 4.01.0 entering Rawhide
description: "After using OCaml for around 10 years it is still my favourite language,
  and it\u2019s amazing how far ahead of other programming languages it remains to
  this day. OCaml 4.01.0 was released on Thu\u2026"
url: https://rwmj.wordpress.com/2013/09/14/ocaml-4-01-0-entering-rawhide/
date: 2013-09-14T06:08:55-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- rjones
---

<p>After using OCaml for around 10 years it is still my favourite language, and it&rsquo;s amazing how far ahead of other programming languages it remains to this day.</p>
<p><a href="https://sympa.inria.fr/sympa/arc/caml-list/2013-09/msg00173.html">OCaml 4.01.0 was released on Thursday</a> and I&rsquo;m putting it into Fedora Rawhide over this weekend.</p>
<p>Debuginfo is now (partially) enabled.  <a href="http://www.ocamlpro.com/blog/2012/08/20/ocamlpro-and-4.00.0.html">The OCaml code generator has produced good quality DWARF information for a while</a>, and now you are able to debug OCaml programs in gdb under Fedora:</p>
<pre>
$ <b>sudo debuginfo-install ocaml ocaml-findlib</b>
$ <b>gdb /usr/bin/ocamlfind</b>
[...]
Reading symbols from /usr/bin/ocamlfind...
Reading symbols from /usr/lib/debug/usr/bin/ocamlfind.debug...done.
done.
(gdb) <b>break frontend.ml:469</b>
Breakpoint 1 at 0x432500: file frontend.ml, line 469.
(gdb) <b>run query findlib -l</b>
Starting program: /usr/bin/ocamlfind query findlib -l

Breakpoint 1, camlFrontend__query_package_1199 () at frontend.ml:469
469	let query_package () =
(gdb) <b>bt</b>
#0  camlFrontend__query_package_1199 () at frontend.ml:469
#1  0x000000000043a4b4 in camlFrontend__main_1670 () at frontend.ml:2231
#2  0x000000000043aa86 in camlFrontend__entry () at frontend.ml:2283
#3  0x000000000042adc9 in caml_program ()
#4  0x00000000004834be in caml_start_program ()
#5  0x000000000048365d in __libc_csu_init ()
#6  0x0000003979821b75 in __libc_start_main (main=0x42aa60 &lt;main&gt;, argc=4, 
    ubp_av=0x7fffffffde38, init=&lt;optimized out&gt;, fini=&lt;optimized out&gt;, 
    rtld_fini=&lt;optimized out&gt;, stack_end=0x7fffffffde28) at libc-start.c:258
#7  0x000000000042aaa9 in _start ()
(gdb) <b>list</b>
464	;;
465	
466	
467	(************************** QUERY SUBCOMMAND ***************************)
468	
469	let query_package () =
470	
471	  let long_format =
472	    &quot;package:     %p\ndescription: %D\nversion:     %v\narchive(s):  %A\nlinkopts:    %O\nlocation:    %d\n&quot; in
473	  let i_format =
</pre>
<p>GDB only understands location data at the moment, so you can&rsquo;t yet query variables (although I understand OCaml generates the correct DWARF info for this, GDB just doesn&rsquo;t know how to print OCaml expressions).</p>
<p>There will also be some limitations on the debuginfo built at first.  At the moment it doesn&rsquo;t include debuginfo for OCaml libraries called from an OCaml program, because of problems that need to be worked out with the toolchain.  Mixed OCaml binary / C library debuginfo does work.</p>

