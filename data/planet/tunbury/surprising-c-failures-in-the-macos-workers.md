---
title: Surprising C++ failures in the macOS workers
description: "@mseri raised issue #175 as the macOS workers cannot find the most basic
  C++ headers. I easily eliminated Obuilder, as opam install mccs.1.1+19 didn\u2019t
  work on the macOS workers natively."
url: https://www.tunbury.org/2025/06/21/macos-sequoia-include-path/
date: 2025-06-21T00:00:00-00:00
preview_image: https://www.tunbury.org/images/sequoia.jpg
authors:
- Mark Elvers
source:
ignore:
---

<p>@mseri raised <a href="https://github.com/ocaml/infrastructure/issues/175">issue #175</a> as the macOS workers cannot find the most basic C++ headers. I easily eliminated <a href="https://github.com/ocurrent/obuilder">Obuilder</a>, as <code class="language-plaintext highlighter-rouge">opam install mccs.1.1+19</code> didn’t work on the macOS workers natively.</p>

<p>On face value, the problem appears pretty common, and there are numerous threads on <a href="https://stackoverflow.com">Stack Overflow</a> such as this <a href="https://stackoverflow.com/questions/77250743/mac-xcode-g-cannot-compile-even-a-basic-c-program-issues-with-standard-libr">one</a>, however, the resolutions I tried didn’t work. I was reluctant to try some of the more intrusive changes like creating a symlink of every header from <code class="language-plaintext highlighter-rouge">/usr/include/</code> to <code class="language-plaintext highlighter-rouge">/Library/Developer/CommandLineTools/usr/include/c++/v1</code> as this doesn’t seem to be what Apple intends.</p>

<p>For the record, a program such as this:</p>

<div class="language-cpp highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="cp">#include</span> <span class="cpf">&lt;iostream&gt;</span><span class="cp">
</span>
<span class="k">using</span> <span class="k">namespace</span> <span class="n">std</span><span class="p">;</span>

<span class="kt">int</span> <span class="nf">main</span><span class="p">()</span> <span class="p">{</span>
    <span class="n">cout</span> <span class="o">&lt;&lt;</span> <span class="s">"Hello World!"</span> <span class="o">&lt;&lt;</span> <span class="n">endl</span><span class="p">;</span>
    <span class="k">return</span> <span class="mi">0</span><span class="p">;</span>
<span class="p">}</span>
</code></pre></div></div>

<p>Fails like this:</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>% c++ hello.cpp <span class="nt">-o</span> hello <span class="nt">-v</span>
Apple clang version 17.0.0 <span class="o">(</span>clang-1700.0.13.3<span class="o">)</span>
Target: x86_64-apple-darwin24.5.0
Thread model: posix
InstalledDir: /Library/Developer/CommandLineTools/usr/bin
 <span class="s2">"/Library/Developer/CommandLineTools/usr/bin/clang"</span> <span class="nt">-cc1</span> <span class="nt">-triple</span> x86_64-apple-macosx15.0.0 <span class="nt">-Wundef-prefix</span><span class="o">=</span>TARGET_OS_ <span class="nt">-Wdeprecated-objc-isa-usage</span> <span class="nt">-Werror</span><span class="o">=</span>deprecated-objc-isa-usage <span class="nt">-Werror</span><span class="o">=</span>implicit-function-declaration <span class="nt">-emit-obj</span> <span class="nt">-dumpdir</span> hello- <span class="nt">-disable-free</span> <span class="nt">-clear-ast-before-backend</span> <span class="nt">-disable-llvm-verifier</span> <span class="nt">-discard-value-names</span> <span class="nt">-main-file-name</span> hello.cpp <span class="nt">-mrelocation-model</span> pic <span class="nt">-pic-level</span> 2 <span class="nt">-mframe-pointer</span><span class="o">=</span>all <span class="nt">-fno-strict-return</span> <span class="nt">-ffp-contract</span><span class="o">=</span>on <span class="nt">-fno-rounding-math</span> <span class="nt">-funwind-tables</span><span class="o">=</span>2 <span class="nt">-target-sdk-version</span><span class="o">=</span>15.4 <span class="nt">-fvisibility-inlines-hidden-static-local-var</span> <span class="nt">-fdefine-target-os-macros</span> <span class="nt">-fno-assume-unique-vtables</span> <span class="nt">-fno-modulemap-allow-subdirectory-search</span> <span class="nt">-target-cpu</span> penryn <span class="nt">-tune-cpu</span> generic <span class="nt">-debugger-tuning</span><span class="o">=</span>lldb <span class="nt">-fdebug-compilation-dir</span><span class="o">=</span>/Users/administrator/x <span class="nt">-target-linker-version</span> 1167.4.1 <span class="nt">-v</span> <span class="nt">-fcoverage-compilation-dir</span><span class="o">=</span>/Users/administrator/x <span class="nt">-resource-dir</span> /Library/Developer/CommandLineTools/usr/lib/clang/17 <span class="nt">-isysroot</span> /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk <span class="nt">-internal-isystem</span> /Library/Developer/CommandLineTools/usr/bin/../include/c++/v1 <span class="nt">-internal-isystem</span> /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/local/include <span class="nt">-internal-isystem</span> /Library/Developer/CommandLineTools/usr/lib/clang/17/include <span class="nt">-internal-externc-isystem</span> /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include <span class="nt">-internal-externc-isystem</span> /Library/Developer/CommandLineTools/usr/include <span class="nt">-Wno-reorder-init-list</span> <span class="nt">-Wno-implicit-int-float-conversion</span> <span class="nt">-Wno-c99-designator</span> <span class="nt">-Wno-final-dtor-non-final-class</span> <span class="nt">-Wno-extra-semi-stmt</span> <span class="nt">-Wno-misleading-indentation</span> <span class="nt">-Wno-quoted-include-in-framework-header</span> <span class="nt">-Wno-implicit-fallthrough</span> <span class="nt">-Wno-enum-enum-conversion</span> <span class="nt">-Wno-enum-float-conversion</span> <span class="nt">-Wno-elaborated-enum-base</span> <span class="nt">-Wno-reserved-identifier</span> <span class="nt">-Wno-gnu-folding-constant</span> <span class="nt">-fdeprecated-macro</span> <span class="nt">-ferror-limit</span> 19 <span class="nt">-stack-protector</span> 1 <span class="nt">-fstack-check</span> <span class="nt">-mdarwin-stkchk-strong-link</span> <span class="nt">-fblocks</span> <span class="nt">-fencode-extended-block-signature</span> <span class="nt">-fregister-global-dtors-with-atexit</span> <span class="nt">-fgnuc-version</span><span class="o">=</span>4.2.1 <span class="nt">-fno-cxx-modules</span> <span class="nt">-fskip-odr-check-in-gmf</span> <span class="nt">-fcxx-exceptions</span> <span class="nt">-fexceptions</span> <span class="nt">-fmax-type-align</span><span class="o">=</span>16 <span class="nt">-fcommon</span> <span class="nt">-fcolor-diagnostics</span> <span class="nt">-clang-vendor-feature</span><span class="o">=</span>+disableNonDependentMemberExprInCurrentInstantiation <span class="nt">-fno-odr-hash-protocols</span> <span class="nt">-clang-vendor-feature</span><span class="o">=</span>+enableAggressiveVLAFolding <span class="nt">-clang-vendor-feature</span><span class="o">=</span>+revert09abecef7bbf <span class="nt">-clang-vendor-feature</span><span class="o">=</span>+thisNoAlignAttr <span class="nt">-clang-vendor-feature</span><span class="o">=</span>+thisNoNullAttr <span class="nt">-clang-vendor-feature</span><span class="o">=</span>+disableAtImportPrivateFrameworkInImplementationError <span class="nt">-D__GCC_HAVE_DWARF2_CFI_ASM</span><span class="o">=</span>1 <span class="nt">-o</span> /var/folders/sh/9c8b7hzd2wb1g2_ky78vqw5r0000gn/T/hello-a268ab.o <span class="nt">-x</span> c++ hello.cpp
clang <span class="nt">-cc1</span> version 17.0.0 <span class="o">(</span>clang-1700.0.13.3<span class="o">)</span> default target x86_64-apple-darwin24.5.0
ignoring nonexistent directory <span class="s2">"/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/local/include"</span>
ignoring nonexistent directory <span class="s2">"/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/SubFrameworks"</span>
ignoring nonexistent directory <span class="s2">"/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/Library/Frameworks"</span>
<span class="c">#include "..." search starts here:</span>
<span class="c">#include &lt;...&gt; search starts here:</span>
 /Library/Developer/CommandLineTools/usr/bin/../include/c++/v1
 /Library/Developer/CommandLineTools/usr/lib/clang/17/include
 /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include
 /Library/Developer/CommandLineTools/usr/include
 /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks <span class="o">(</span>framework directory<span class="o">)</span>
End of search list.
hello.cpp:1:10: fatal error: <span class="s1">'iostream'</span> file not found
    1 | <span class="c">#include &lt;iostream&gt;</span>
      |          ^~~~~~~~~~
1 error generated.
</code></pre></div></div>

<p>That first folder looked strange: <code class="language-plaintext highlighter-rouge">bin/../include/c++/v1</code>. Really? What’s in there? Not much:</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>% <span class="nb">ls</span> <span class="nt">-l</span> /Library/Developer/CommandLineTools/usr/bin/../include/c++/v1
total 40
<span class="nt">-rw-r--r--</span>  1 root  wheel  44544  7 Apr  2022 __functional_03
<span class="nt">-rw-r--r--</span>  1 root  wheel   6532  7 Apr  2022 __functional_base_03
<span class="nt">-rw-r--r--</span>  1 root  wheel   2552  7 Apr  2022 __sso_allocator
</code></pre></div></div>

<p>I definitely have <code class="language-plaintext highlighter-rouge">iostream</code> on the machine:</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>% <span class="nb">ls</span> <span class="nt">-l</span> /Library/Developer/CommandLineTools/SDKs/MacOSX<span class="k">*</span>.sdk/usr/include/c++/v1/iostream
<span class="nt">-rw-r--r--</span>  1 root  wheel  1507  8 Mar 03:36 /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1/iostream
<span class="nt">-rw-r--r--</span>  1 root  wheel  1391 13 Nov  2021 /Library/Developer/CommandLineTools/SDKs/MacOSX12.1.sdk/usr/include/c++/v1/iostream
<span class="nt">-rw-r--r--</span>  1 root  wheel  1583 13 Apr  2024 /Library/Developer/CommandLineTools/SDKs/MacOSX14.5.sdk/usr/include/c++/v1/iostream
<span class="nt">-rw-r--r--</span>  1 root  wheel  1583 13 Apr  2024 /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/c++/v1/iostream
<span class="nt">-rw-r--r--</span>  1 root  wheel  1583 10 Nov  2024 /Library/Developer/CommandLineTools/SDKs/MacOSX15.2.sdk/usr/include/c++/v1/iostream
<span class="nt">-rw-r--r--</span>  1 root  wheel  1507  8 Mar 03:36 /Library/Developer/CommandLineTools/SDKs/MacOSX15.4.sdk/usr/include/c++/v1/iostream
<span class="nt">-rw-r--r--</span>  1 root  wheel  1507  8 Mar 03:36 /Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/c++/v1/iostream
</code></pre></div></div>

<p>I tried on my MacBook, which compiled the test program without issue. However, that was running Monterey, where the workers are running Sequoia. The <em>include</em> paths on my laptop look much better. Where are they configured?</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>% c++ <span class="nt">-v</span> <span class="nt">-o</span> <span class="nb">test </span>test.cpp
Apple clang version 15.0.0 <span class="o">(</span>clang-1500.3.9.4<span class="o">)</span>
Target: x86_64-apple-darwin23.5.0
Thread model: posix
InstalledDir: /Library/Developer/CommandLineTools/usr/bin
 <span class="s2">"/Library/Developer/CommandLineTools/usr/bin/clang"</span> <span class="nt">-cc1</span> <span class="nt">-triple</span> x86_64-apple-macosx14.0.0 <span class="nt">-Wundef-prefix</span><span class="o">=</span>TARGET_OS_ <span class="nt">-Wdeprecated-objc-isa-usage</span> <span class="nt">-Werror</span><span class="o">=</span>deprecated-objc-isa-usage <span class="nt">-Werror</span><span class="o">=</span>implicit-function-declaration <span class="nt">-emit-obj</span> <span class="nt">-mrelax-all</span> <span class="nt">--mrelax-relocations</span> <span class="nt">-disable-free</span> <span class="nt">-clear-ast-before-backend</span> <span class="nt">-disable-llvm-verifier</span> <span class="nt">-discard-value-names</span> <span class="nt">-main-file-name</span> test.cpp <span class="nt">-mrelocation-model</span> pic <span class="nt">-pic-level</span> 2 <span class="nt">-mframe-pointer</span><span class="o">=</span>all <span class="nt">-fno-strict-return</span> <span class="nt">-ffp-contract</span><span class="o">=</span>on <span class="nt">-fno-rounding-math</span> <span class="nt">-funwind-tables</span><span class="o">=</span>2 <span class="nt">-target-sdk-version</span><span class="o">=</span>14.4 <span class="nt">-fvisibility-inlines-hidden-static-local-var</span> <span class="nt">-target-cpu</span> penryn <span class="nt">-tune-cpu</span> generic <span class="nt">-debugger-tuning</span><span class="o">=</span>lldb <span class="nt">-target-linker-version</span> 1053.12 <span class="nt">-v</span> <span class="nt">-fcoverage-compilation-dir</span><span class="o">=</span>/Users/mtelvers/x <span class="nt">-resource-dir</span> /Library/Developer/CommandLineTools/usr/lib/clang/15.0.0 <span class="nt">-isysroot</span> /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk <span class="nt">-I</span>/usr/local/include <span class="nt">-internal-isystem</span> /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1 <span class="nt">-internal-isystem</span> /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/local/include <span class="nt">-internal-isystem</span> /Library/Developer/CommandLineTools/usr/lib/clang/15.0.0/include <span class="nt">-internal-externc-isystem</span> /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include <span class="nt">-internal-externc-isystem</span> /Library/Developer/CommandLineTools/usr/include <span class="nt">-Wno-reorder-init-list</span> <span class="nt">-Wno-implicit-int-float-conversion</span> <span class="nt">-Wno-c99-designator</span> <span class="nt">-Wno-final-dtor-non-final-class</span> <span class="nt">-Wno-extra-semi-stmt</span> <span class="nt">-Wno-misleading-indentation</span> <span class="nt">-Wno-quoted-include-in-framework-header</span> <span class="nt">-Wno-implicit-fallthrough</span> <span class="nt">-Wno-enum-enum-conversion</span> <span class="nt">-Wno-enum-float-conversion</span> <span class="nt">-Wno-elaborated-enum-base</span> <span class="nt">-Wno-reserved-identifier</span> <span class="nt">-Wno-gnu-folding-constant</span> <span class="nt">-fdeprecated-macro</span> <span class="nt">-fdebug-compilation-dir</span><span class="o">=</span>/Users/mtelvers/x <span class="nt">-ferror-limit</span> 19 <span class="nt">-stack-protector</span> 1 <span class="nt">-fstack-check</span> <span class="nt">-mdarwin-stkchk-strong-link</span> <span class="nt">-fblocks</span> <span class="nt">-fencode-extended-block-signature</span> <span class="nt">-fregister-global-dtors-with-atexit</span> <span class="nt">-fgnuc-version</span><span class="o">=</span>4.2.1 <span class="nt">-fno-cxx-modules</span> <span class="nt">-fcxx-exceptions</span> <span class="nt">-fexceptions</span> <span class="nt">-fmax-type-align</span><span class="o">=</span>16 <span class="nt">-fcommon</span> <span class="nt">-fcolor-diagnostics</span> <span class="nt">-clang-vendor-feature</span><span class="o">=</span>+disableNonDependentMemberExprInCurrentInstantiation <span class="nt">-fno-odr-hash-protocols</span> <span class="nt">-clang-vendor-feature</span><span class="o">=</span>+enableAggressiveVLAFolding <span class="nt">-clang-vendor-feature</span><span class="o">=</span>+revert09abecef7bbf <span class="nt">-clang-vendor-feature</span><span class="o">=</span>+thisNoAlignAttr <span class="nt">-clang-vendor-feature</span><span class="o">=</span>+thisNoNullAttr <span class="nt">-mllvm</span> <span class="nt">-disable-aligned-alloc-awareness</span><span class="o">=</span>1 <span class="nt">-D__GCC_HAVE_DWARF2_CFI_ASM</span><span class="o">=</span>1 <span class="nt">-o</span> /var/folders/15/4zw4hb9s40b8cmff3z5bdszc0000gp/T/test-71e229.o <span class="nt">-x</span> c++ test.cpp
clang <span class="nt">-cc1</span> version 15.0.0 <span class="o">(</span>clang-1500.3.9.4<span class="o">)</span> default target x86_64-apple-darwin23.5.0
ignoring nonexistent directory <span class="s2">"/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/local/include"</span>
ignoring nonexistent directory <span class="s2">"/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/Library/Frameworks"</span>
<span class="c">#include "..." search starts here:</span>
<span class="c">#include &lt;...&gt; search starts here:</span>
 /usr/local/include
 /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1
 /Library/Developer/CommandLineTools/usr/lib/clang/15.0.0/include
 /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include
 /Library/Developer/CommandLineTools/usr/include
 /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks <span class="o">(</span>framework directory<span class="o">)</span>
End of search list.
 <span class="s2">"/Library/Developer/CommandLineTools/usr/bin/ld"</span> <span class="nt">-demangle</span> <span class="nt">-lto_library</span> /Library/Developer/CommandLineTools/usr/lib/libLTO.dylib <span class="nt">-no_deduplicate</span> <span class="nt">-dynamic</span> <span class="nt">-arch</span> x86_64 <span class="nt">-platform_version</span> macos 14.0.0 14.4 <span class="nt">-syslibroot</span> /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk <span class="nt">-o</span> <span class="nb">test</span> <span class="nt">-L</span>/usr/local/lib /var/folders/15/4zw4hb9s40b8cmff3z5bdszc0000gp/T/test-71e229.o <span class="nt">-lc</span>++ <span class="nt">-lSystem</span> /Library/Developer/CommandLineTools/usr/lib/clang/15.0.0/lib/darwin/libclang_rt.osx.a
</code></pre></div></div>

<p>I’ve been meaning to upgrade my MacBook, and this looked like the perfect excuse. I updated to Sequoia and then updated the Xcode command-line tools. The test compilation worked, the paths looked good, but I had clang 1700.0.13.5, where the workers had 1700.0.13.3.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>% c++ <span class="nt">-v</span> <span class="nt">-o</span> <span class="nb">test </span>test.cpp
Apple clang version 17.0.0 <span class="o">(</span>clang-1700.0.13.5<span class="o">)</span>
Target: x86_64-apple-darwin24.5.0
Thread model: posix
InstalledDir: /Library/Developer/CommandLineTools/usr/bin
</code></pre></div></div>

<p>I updated the workers to 1700.0.13.5, which didn’t make any difference. The workers still had that funny <code class="language-plaintext highlighter-rouge">/../</code> path, which wasn’t present anywhere else. I searched <code class="language-plaintext highlighter-rouge">/Library/Developer/CommandLineTools/usr/bin/../include/c++/v1 site:stackoverflow.com</code> and the answer is the top <a href="https://stackoverflow.com/a/79606435">match</a>.</p>

<blockquote>
  <p>Rename or if you’re confident enough, delete /Library/Developer/CommandLineTools/usr/include/c++, then clang++ will automatically search headers under /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1 and find your <iostream> header. That directory is very likely an artifact of OS upgrade and by deleting it clang++ will realise that it should search in the header paths of new SDKs.</iostream></p>
</blockquote>

<p>I wasn’t confident, so I moved it, <code class="language-plaintext highlighter-rouge">sudo mv c++ ~</code>. With that done, the test program builds correctly! Have a read of the <a href="https://stackoverflow.com/a/79606435">answer</a> on Stack Overflow.</p>

<p>Now, rather more cavalierly, I removed the folder on all the i7 and m1 workers:</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nv">$ </span><span class="k">for </span>a <span class="k">in</span> <span class="o">{</span>01..04<span class="o">}</span> <span class="p">;</span> <span class="k">do </span>ssh m1-worker-<span class="nv">$a</span>.macos.ci.dev <span class="nb">sudo rm</span> <span class="nt">-r</span> /Library/Developer/CommandLineTools/usr/include/c++ <span class="p">;</span> <span class="k">done</span>
</code></pre></div></div>
