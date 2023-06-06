---
title: Florian's OCaml compiler weekly, 5 June 2023
description:
url: http://cambium.inria.fr/blog/florian-compiler-weekly-2023-05-06
date: 2023-06-05T08:00:00-00:00
preview_image:
featured:
authors:
- gallium
---




<p>This series of blog post aims to give a short weekly glimpse into my
(Florian Angeletti) daily work on the OCaml compiler. This week, the
focus is on the release of the second alpha for OCaml 5.1.0.</p>


  

<h3>OCaml 5.1.0 second alpha
release:</h3>
<p>The last two weeks I have spent most of my time preparing for the
second alpha release of OCaml 5.1.0. This second alpha has just been
published last Friday. This new alpha release is quite heavy in term of
bug fixes. Indeed, this release contains two major fixes:</p>
<ul>
<li><p><a href="https://github.com/ocaml/ocaml/pull/11903">Garbage
Collector fix</a>: before this second alpha, an idle domain (or more
precisely a non-allocating domain) could slow down considerably the
major collection. Indeed, the work attributed to each domain during a
major collection was scaled in function of the local domain allocation
rate. Consequently, a non-allocating domain would choose to do little to
no GC work, leaving the GC unable to keep up with the real allocation
rate. To solve this issue, the new alpha has introduced a global
accounting for the allocation rate and a global distribution of GC work
along the domains.</p>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/11846">Windows ABI
fix</a>, the full separation of the OCaml and C stacks in OCaml 5.0.0
created an ABI violation on Windows. More precisely, the new OCaml stack
was still satisfying the Windows x64 ABI requirements even if it was no
longer necessary. Contrarily C functions might end up called with a
malformed C stack. With this fix, the OCaml stack has been freed from
the Windows C ABI while the C stack fulfils the correct
requirements.</li>
</ul></li>
</ul>
<p>Slightly less visible, we also have an important fix in the OCaml
compiler-libs and a type system backward compatibility enhancement:</p>
<ul>
<li><p><a href="https://github.com/ocaml/ocaml/pull/12191">compiler-libs
fix</a>: as discussed [previously]
(http://gallium.inria.fr/blog/florian-compiler-weekly-2023-04-24/), the
parser published in OCaml 5.1.0~alpha1 was dropping constraints on value
bindings (for instance <code>let x :&gt; [&gt; X of int] = ...</code>).
This has been fixed in 5.1.0~alpha2. Unfortunately such changes this
late in the release cycle will require more work in the ppxlib
library.</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/pull/12211">type system
compatibility enhancement</a>: similarly, the backward compatibility
improvement that I was discussing in my <a href="http://gallium.inria.fr/blog/florian-compiler-weekly-2023-04-28">last
April blog post</a> has been integrated in this second alpha. This
change restores compatibility with some accidentally compiling OCaml
code by using a more charitable interpretation for type annotation of
the form <code>'a . [&gt; X of 'a ] -&gt; 'a -&gt; 'a</code>.</p></li>
</ul>
<p>Finally, this second alpha release also contains a new backend for
IBM s390x (which was contributed by IBM). Including a new architecture
in an alpha release feels a bit daring. However, new backends have no
effects on existing users and give us a wider testing environment for
the new port. Consequently, I thought that it was sensible to integrate
the new backend in the last alpha.</p>
<p>Overall, this second alpha release feels less stable that I would
have wished, but the release process is definitively going forward. With
this late release out of the door, my current plan is to focus on
releasing a first beta release of OCaml 5.1.0 in the upcoming weeks. If
everything goes well, we could have a final release of OCaml 5.1.0
around mid-July.</p>


