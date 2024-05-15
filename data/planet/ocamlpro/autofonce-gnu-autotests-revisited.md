---
title: Autofonce, GNU Autotests Revisited
description: Since 2022, OCamlPro has been contributing to GnuCOBOL, the only fully
  open-source compiler for the COBOL language. To speed-up our contributions to the
  compiler, we developed a new tool, autofonce, to be able to easily run and modify
  the testsuite of the compiler, originally written as a GNU Autoco...
url: https://ocamlpro.com/blog/2023_03_18_autofonce
date: 2023-06-27T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Fabrice Le Fessant\n  "
source:
---

<p></p>
<p>Since 2022, OCamlPro has been contributing to GnuCOBOL, the only fully
open-source compiler for the COBOL language. To speed-up our
contributions to the compiler, we developed a new tool, <code>autofonce</code>,
to be able to easily run and modify the testsuite of the compiler,
originally written as a GNU Autoconf testsuite. This article describes
this tool, that could be useful for other project testsuites.</p>
<p></p><div>
<strong>Table of contents</strong>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#introduction">Introduction</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#gnucobol">The Gnu Autoconf Testsuite of GnuCOBOL</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#autofonce">Main Features of Autofonce</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#conclusion">Conclusion</a>

</li>
</ul>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/autofonce-2023.png">
      <img src="https://ocamlpro.com/blog/assets/img/autofonce-2023.png" alt="Autofonce is a modern runner for GNU Autoconf Testsuite"/>
    </a>
    </p><div class="caption">
      Autofonce is a modern runner for GNU Autoconf Testsuite
    </div>
  
</div>

<h2>
<a class="anchor"></a>Introduction<a href="https://ocamlpro.com/blog/feed#introduction">&#9875;</a>
          </h2>
<p>Since 2022, OCamlPro has been involved in a big modernization project
for the French state: the goal is to move a large COBOL application,
running on a former Bull mainframe
(<a href="https://fr.wikipedia.org/wiki/General_Comprehensive_Operating_System">GCOS</a>)
to a cluster of Linux computers. The choice was made to use the most
open-source compiler, <a href="https://gnucobol.sourceforge.io/">GnuCOBOL</a>,
that had already been used in such projects.</p>
<p>One of the main problems in such migration projects is that most COBOL
proprietary compilers provide extensions to the COBOL language
standard, that are not supported by other compilers. Fortunately,
GnuCOBOL has good support for several mainstream COBOL dialects, such
as IBM or Micro-Focus ones. Unfortunately, GnuCOBOL had no support at
the time for the GCOS COBOL dialect developed by Bull for its
mainframes.</p>
<p>As a consequence, OCamlPro got involved in the project to extend
GnuCOBOL with the support for the GCOS dialect needed for the
application. This work implied a lot of (sometimes very deep)
<a href="https://github.com/OCamlPro/gnucobol/pulls?q=is:pr%20is:closed">modifications</a>
of the compiler and its runtime library, both of them written in the C
language. And of course, our modifications had first to pass the large
existing testsuite of COBOL examples, and then extend it with new
tests, so that the new dialect would continue to work in the future.</p>
<p>This work lead us to develop <a href="https://github.com/OCamlPro/autofonce"><code>autofonce</code>, a modern open-source
runner</a> for GNU Autoconf
Testsuites, the framework used in GnuCOBOL to manage its
testsuite. Our tool is available on Github, with Linux and Windows
binaries on the <a href="https://github.com/OCamlPro/autofonce/releases">release page</a>.</p>
<h2>
<a class="anchor"></a>The GNU Autoconf Testsuite of GnuCOBOL<a href="https://ocamlpro.com/blog/feed#gnucobol">&#9875;</a>
          </h2>
<p><a href="https://www.gnu.org/software/autoconf/">GNU Autoconf</a> is a set of
powerful tools, developed to help developers of open-source projects
to manage their projects, from configuration steps to testing and
installation. As a very old technology, GNU Autoconf relies heavily on
<a href="https://www.gnu.org/software/m4/manual/m4.html">M4 macros</a> both as
its own development language, and as its extension language, typically
for tests.</p>
<p>In GnuCOBOL, the testsuite is in a <a href="https://github.com/OCamlPro/gnucobol/tree/gcos4gnucobol-3.x/tests">sub-directory <code>tests/</code></a>, containing
a file <a href="https://github.com/OCamlPro/gnucobol/blob/gcos4gnucobol-3.x/tests/testsuite.at"><code>testsuite.at</code></a>, itself including other files from a
sub-directory <a href="https://github.com/OCamlPro/gnucobol/blob/gcos4gnucobol-3.x/tests/testsuite.src"><code>testsuite.src/</code></a>.</p>
<p>As an example, a typical test from <a href="https://github.com/OCamlPro/gnucobol/blob/gcos4gnucobol-3.x/tests/testsuite.src/syn_misc.at">syn_copy.at</a> looks like:</p>
<pre><code class="language-COBOL">AT_SETUP([INITIALIZE constant])
AT_KEYWORDS([misc])
AT_DATA([prog.cob], [
       IDENTIFICATION   DIVISION.
       PROGRAM-ID.      prog.
       DATA             DIVISION.
       WORKING-STORAGE  SECTION.
       01  CON          CONSTANT 10.
       01  V            PIC 9.
       78  C78          VALUE 'A'.
       PROCEDURE DIVISION.
           INITIALIZE CON.
           INITIALIZE V.
           INITIALIZE V, 9.
           INITIALIZE C78, V.
])
AT_CHECK([$COMPILE_ONLY prog.cob], [1], [],
[prog.cob:10: error: invalid INITIALIZE statement
prog.cob:12: error: invalid INITIALIZE statement
prog.cob:13: error: invalid INITIALIZE statement
])
AT_CLEANUP
</code></pre>
<p>Actually, we were quite pleased by the syntax of tests, it is easy to
generate test files (using <code>AT_DATA</code> macro) and to test the execution
of commands (using <code>AT_CHECK</code> macro), checking its exit code, its
standard output and error output separately. It is even possible to
combine checks to run additional checks in case of error or
success. In general, the testsuite is easy to read and complete.</p>
<p>However, there were still some issues:</p>
<ul>
<li>
<p>At every update of the code or the tests, the testsuite runner has to be recompiled;</p>
</li>
<li>
<p>Running the testsuite requires to be in the correct sub-directory,
typically within the <code>_build/</code> sub-directory;</p>
</li>
<li>
<p>By default, tests are ran sequentially, even when many cores are available.</p>
</li>
<li>
<p>The output is pretty verbose, showing all tests that have been executed. Failed tests are often lost in the middle of other successful tests, and you have to wait for the end of the run to start investigating them;</p>
<pre><code class="language-shell">## -------------------------------------------- ##
## GnuCOBOL 3.2-dev test suite: GnuCOBOL Tests. ##
## -------------------------------------------- ##
  
General tests of used binaries
  
  1: compiler help and information                   ok
  2: compiler warnings                               ok
  3: compiler outputs (general)                      ok
  4: compiler outputs (file specified)               ok
  5: compiler outputs (path specified)               ok
  6: compiler outputs (assembler)                    ok
  7: source file not found                           ok
  8: temporary path invalid                          ok
  9: use of full path for cobc                       ok
 10: C Compiler optimizations                        ok
 11: invalid cobc option                             ok
 12: cobcrun help and information                    ok
 13: cobcrun validation                              ok
 14: cobcrun -M DSO entry argument                   ok
 15: cobcrun -M directory/ default                   ok
 [...]
</code></pre>
</li>
<li>
<p>There is no automatic way to update tests, when their output has changed.
Every test has to be updated manually.</p>
</li>
<li>
<p>In case of error, it is not always easy to rerun a specific test
within its directory.</p>
</li>
</ul>
<p>With <code>autofonce</code>, we tried to solve all of these issues...</p>
<h2>
<a class="anchor"></a>Main Features of Autofonce<a href="https://ocamlpro.com/blog/feed#autofonce">&#9875;</a>
          </h2>
<p><code>autofonce</code> is written in a modern language, OCaml, so that it can
handle a large testsuite much faster than GNU Autoconf. Since we do
not expect users to have an OCaml environment set up, we provide
binary versions of <code>autofonce</code> for both Linux (static executable) and
Windows (cross-compiled executable) on Github.</p>
<p><code>autofonce</code> does not use <code>m4</code>, instead, it has a limited support for a
small set of predefined m4 macros, typically supporting m4 escape
sequences (quadrigraphs), but not the addition of new m4 macros, and
neither the execution of shell commands outside of these macros (yes,
testsuites in GNU Autoconf are actually <code>sh</code> shell scripts with m4
macros...). In the case of GnuCOBOL, we were lucky enough that the
testsuite was well written and avoided such problems (we had to fix
only a few of them, such as including shell commands into <code>AT_CHECK</code>
macros). The syntax of tests is <a href="https://ocamlpro.github.io/autofonce/sphinx/format.html">documented here</a>.</p>
<p>Some interesting features of <code>autofonce</code> are :</p>
<ul>
<li>
<p><code>autofonce</code> executes the tests in parallel by default, using as many
cores as available. Only failed tests are printed, so that the
developer can immediately start investigating them;</p>
</li>
<li>
<p><code>autofonce</code> can be run from any directory in the project. A
<a href="https://github.com/OCamlPro/gnucobol/blob/gcos4gnucobol-3.x/.autofonce"><code>.autofonce</code> file</a> has to be present at the root of the project, to
describe where the tests are located and in which environment they
should be executed;</p>
</li>
<li>
<p><code>autofonce</code> makes it easy to re-execute a specific test that failed,
by generating, within the test sub-directory, a script for every
step of the test;</p>
</li>
<li>
<p><code>autofonce</code> provides many options to filter which tests should be
executed. Tests can be specified by number, range of numbers,
keywords, or negative keywords. The complete list of options is
easily printable using <code>autofonce run --help</code> for example;</p>
</li>
</ul>
<p>Additionnally, <code>autofonce</code> implements a powerful promotion mechanism
to update tests, with the <a href="https://ocamlpro.github.io/autofonce/sphinx/commands.html#autofonce-promote"><code>autofonce promote</code>
sub-command</a>. For
example, if you update a warning message in the compiler, you would
like all tests where this message appears to be modified.  With
<code>autofonce</code>, it is as easy as:</p>
<pre><code class="language-shell"># Run all tests at least once
autofonce run
# Print the patch that would be applied in case of promotion
autofonce promote
# Apply the patch above
autofonce promote --apply
# Combine running and promotion 10 times:
autofonce run --auto-promote 10
</code></pre>
<p>The last command iterates promotion 10 times: indeed, since a test may
have multiple checks, and only the first failed check of the test will
be updated during one iteration (because the test aborts at the first
failed check), as many iterations as the maximal number of failed
checks within a test may be needed.</p>
<p>Also, as for GNU Autoconf, <code>autofonce</code> generates a final log file containing the results with a full log of errors and files needed to reproduce the error. This file can be uploaded into the artefacts of a CI system to easily debug errors after a CI failure.</p>
<h2>
<a class="anchor"></a>Conclusion<a href="https://ocamlpro.com/blog/feed#conclusion">&#9875;</a>
          </h2>
<p>During our work on GnuCOBOL, <code>autofonce</code> improved a lot our user
experience of running the testsuite, especially using the
auto-promotion feature to update tests after modifications.</p>
<p>We hope <code>autofonce</code> could be used for other open-source projects that
already use the GNU Autoconf testsuite. Of course, it requires that
the testsuite does not make heavy use of shell features and mainly
relies on standard m4 macros.</p>
<p>We found that the format of GNU Autoconf tests to be quite powerful to
easily check exit codes, standard outputs and error outputs of shell
commands. <code>autofonce</code> could be used to help using this format in
projects, that do not want to rely on an old tool like GNU Autoconf,
and are looking for a much more modern test framework.</p>
</div>
