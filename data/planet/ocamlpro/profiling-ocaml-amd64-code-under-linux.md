---
title: Profiling OCaml amd64 code under Linux
description: We have recently worked on modifying the OCaml system to be able to profile
  OCaml code on Linux amd64 systems, using the processor performance counters now
  supported by stable kernels. This page presents this work, funded by Jane Street.
  The patch is provided for OCaml version 4.00.0. If you need it...
url: https://ocamlpro.com/blog/2012_08_08_profiling_ocaml_amd64_code_under_linux
date: 2012-08-08T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    \xC7agdas Bozman\n  "
source:
---

<p>We have recently worked on modifying the OCaml system to be able to profile OCaml code on Linux amd64 systems, using the processor performance counters now supported by stable kernels. This page presents this work, funded by Jane Street.</p>
<p>The patch is provided for OCaml version 4.00.0. If you need it for 3.12.1, some more work is required, as we would need to backport some improvements that were already in the 4.00.0 code generator.</p>
<h2 class="page-subtitle">
  An example: profiling <code>ocamlopt.opt</code>
</h2>
<p>Here is an example of a session of profiling done using both Linux performance tools and a modified OCaml 4.00.0 system (the patch is available at the end of this article).</p>
<p>Linux performance tools are available as part of the Linux kernel (in the <code>linux-tools</code> package on Debian/Ubuntu). Most of the tools are invoked through the <code>perf</code> command, &agrave; la git. For example, we are going to check where the time is spent when calling the <code>ocamlopt.opt</code> command:</p>
<pre><code class="language-bash">perf record -g ./ocamlopt.opt -c -I utils -I parsing -I typing typing/*.ml
</code></pre>
<p>This command generates a file <code>perf.data</code> in the current directory, containing all the events that were received during the execution of the command. These events contain the values of the performance counters in the amd64 processor, and the call-chain (backtrace) at the event.</p>
<p>We can inspect this file using the command:</p>
<pre><code class="language-bash">perf report -g
</code></pre>
<p>The command displays:</p>
<pre><code class="language-bash">Events: 3K cycles
+   9.81%  ocamlopt.opt  ocamlopt.opt           [.] compare_val
+   8.85%  ocamlopt.opt  ocamlopt.opt           [.] mark_slice
+   7.75%  ocamlopt.opt  ocamlopt.opt           [.] caml_page_table_lookup
+   7.40%            as  as                     [.] 0x5812
+   5.60%  ocamlopt.opt  [kernel.kallsyms]      [k] 0xffffffff8103d0ca
+   3.91%  ocamlopt.opt  ocamlopt.opt           [.] sweep_slice
+   3.18%  ocamlopt.opt  ocamlopt.opt           [.] caml_oldify_one
+   3.14%  ocamlopt.opt  ocamlopt.opt           [.] caml_fl_allocate
+   2.84%            as  [kernel.kallsyms]      [k] 0xffffffff81317467
+   1.99%  ocamlopt.opt  ocamlopt.opt           [.] caml_c_call
+   1.99%  ocamlopt.opt  ocamlopt.opt           [.] caml_compare
+   1.75%  ocamlopt.opt  ocamlopt.opt           [.] camlSet__mem_1148
+   1.62%  ocamlopt.opt  ocamlopt.opt           [.] caml_oldify_mopup
+   1.58%  ocamlopt.opt  ocamlopt.opt           [.] camlSet__bal_1053
+   1.46%  ocamlopt.opt  ocamlopt.opt           [.] camlSet__add_1073
+   1.37%  ocamlopt.opt  libc-2.15.so           [.] 0x15cbd0
+   1.37%  ocamlopt.opt  ocamlopt.opt           [.] camlInterf__compare_1009
+   1.33%  ocamlopt.opt  ocamlopt.opt           [.] caml_apply2
+   1.09%  ocamlopt.opt  ocamlopt.opt           [.] caml_modify
+   1.07%            sh  [kernel.kallsyms]      [k] 0xffffffffa07e16fd
+   1.07%            as  libc-2.15.so           [.] 0x97a61
+   0.94%  ocamlopt.opt  ocamlopt.opt           [.] caml_alloc_shr
</code></pre>
<p>Using the arrow keys and the <code>Enter</code> key to expand an item, we can get a better idea of where most of the time is spent:</p>
<pre><code class="language-bash">Events: 3K cycles
+ 9.81%  ocamlopt.opt  ocamlopt.opt           [.] compare_val
- compare_val
- 71.68% camlSet__mem_1148
+ 98.01% camlInterf__add_interf_1121
+ 1.99% camlInterf__add_pref_1158
- 21.48% camlSet__add_1073
- camlSet__add_1073
+ 93.41% camlSet__add_1073
+ 6.59% camlInterf__add_interf_1121
+ 1.44% camlReloadgen__fun_1386
+ 1.43% camlClosure__close_approx_var_1373
+ 1.43% camlSwitch__opt_count_1239
+ 1.34% camlTbl__add_1050
+ 1.20% camlEnv__find_1408
+ 8.85%  ocamlopt.opt  ocamlopt.opt           [.] mark_slice
- 7.75%  ocamlopt.opt  ocamlopt.opt           [.] caml_page_table_lookup
- caml_page_table_lookup
+ 50.03% camlBtype__set_commu_1704
+ 49.97% camlCtype__expand_head_1923
+ 7.40%            as  as                     [.] 0x5812
+ 5.60%  ocamlopt.opt  [kernel.kallsyms]      [k] 0xffffffff8103d0ca
+ 3.91%  ocamlopt.opt  ocamlopt.opt           [.] sweep_slice
Press `?` for help on key bindings
</code></pre>
<p>We notice that a lot of time is spent in the <code>compare_val</code> primitive, called from the <code>Pervasives.compare</code> function, itself called from the <code>Set</code> module in <code>asmcomp/interp.ml</code>. We can locate the corresponding code at the beginning of the file:</p>
<pre><code class="language-ocaml">module IntPairSet =
  Set.Make(struct type t = int * int let compare = compare end)
</code></pre>
<p>Let's replace the polymorphic function <code>compare</code> by a monomorphic function, optimized for pairs of small ints:</p>
<pre><code class="language-ocaml">module IntPairSet =
  Set.Make(struct type t = int * int
                  let compare (a1,b1) (a2,b2) =
                  if a1 = a2 then b1 - b2 else a1 - a2
           end)
</code></pre>
<p>We can now compare the speed of the two versions:</p>
<pre><code class="language-bash">peerocaml:~/ocaml-4.00.0%  time ./ocamlopt.old -c -I utils -I parsing -I typing typing/.ml
./ocamlopt.old  7.38s user 0.56s system 97% cpu 8.106 total
peerocaml:~/ocaml-4.00.0%  time ./ocamlopt.new -c -I utils -I parsing -I typing typing/.ml
./ocamlopt.new  6.16s user 0.50s system 97% cpu 6.827 total
</code></pre>
<p>And we get an interesting speedup ! Now, we can iterate the process, check where most of the time is spent in the new version, optimize the critical path and so on.</p>
<h2 class="page-subtitle">
  Installation of the modified OCaml system
</h2>
<p>A modified OCaml system is required because, for each event, the Linux kernel must attach a backtrace of the stack (call-chain). However, the kernel is not able to use standard DWARF debugging information, and current OCaml stack frames are too complex to be unwinded without this DWARF information. Instead, we had to modify OCaml code generator to follow the same conventions as C for frame pointers, i.e. using saving the frame pointer on function entry and restoring it on function exit. This required to decrease the number of available registers from 13 to 12, using <code>%rbp</code> as the frame pointer, leading to an average 3-5% slowdown in execution time.</p>
<p>The patch for OCaml 4.00.0 is available here:</p>
<p><a href="http://ocamlpro.com//files/omit-frame-pointer-4.00.0.patch">omit-frame-pointer-4.00.0.patch</a> (20 kB, v2, updated 2012/08/13)</p>
<p>To use it, you can use the following recipe, that will compile and install the patched version in ~/ocaml-4.00-with-fp.</p>
<pre><code class="language-shell-session">$ wget http://caml.inria.fr/pub/distrib/ocaml-4.00.0/ocaml-4.00.0.tar.gz
$ tar zxf ~/ocaml-4.00.0.tar.gz
$ cd ocaml-4.00.0
$~/ocaml-4.00.0% wget ocamlpro.com/files/omit-frame-pointer-4.00.0.patch
$~/ocaml-4.00.0% patch -p1 &lt; omit-frame-pointer-4.00.0.patch
$~/ocaml-4.00.0% ./configure -prefix ~/ocaml-4.00-with-fp
$~/ocaml-4.00.0% make world opt opt.opt install
$~/ocaml-4.00.0% cd ~
$ export PATH=$HOME/ocaml-4.00.0-with-fp/bin:$PATH
</code></pre>
<p>It is important to know that the patch modifies OCaml calling convention, meaning that ALL THE MODULES AND LIBRARIES in your application must be recompiled with this version.</p>
<p>On our benchmarks, the slowdown induced by the patch is between 3 and 5%. You can still compile your application without frame pointers, for production, using a new option <code>-fomit-frame-pointer</code> that was added by the patch.</p>
<p>This patch has been submitted for inclusion in OCaml. You can follow its status and contribute to the discussion here:
<a href="http://caml.inria.fr/mantis/view.php?id=5721">http://caml.inria.fr/mantis/view.php?id=5721</a></p>

