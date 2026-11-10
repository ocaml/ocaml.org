---
title: 'Alcotest: finding flaky OCaml tests with JUnit reports'
description: Alcotest can now write JUnit reports with no change to your tests, enough
  to chart which tests are flaky and which broke, and tags put a flaky test aside.
  It also nests tests and runs under wasm, and dune-release gets Windows fixes.
url: https://gazagnaire.org/blog/2026-11-09-alcotest-dune-release.html
date: 2026-11-09T00:00:00-00:00
preview_image: https://gazagnaire.org/blog/og/2026-11-09-alcotest-dune-release.png
authors:
- Thomas Gazagnaire
source:
ignore:
keywords:
- alcotest
- dune-release
- flakemap
- flaky
- hello-0
- junit
- reports
- suite
- test
- tests
---

<p>I use <a href="https://github.com/mirage/alcotest">Alcotest</a> and
<a href="https://github.com/tarides/dune-release">dune-release</a> for almost every
<a href="https://ocaml.org/">OCaml</a> package I release: the first runs the tests,
and the second publishes the result on
<a href="https://opam.ocaml.org/">opam</a>. Both had collected issues and pull
requests over the years (the oldest issue I closed this week dates from
2017), so I spent the past week going through them. Alcotest 1.10.0 and
dune-release 2.3.0 are the result. For me, the most useful changes are
that Alcotest can now write JUnit reports without any change to your
tests, and that tests can carry tags. A tool that reads a folder of
reports can tell a flaky test from a broken one, and a tag then puts the
flaky test aside until it is fixed.</p>
<p>dune-release 2.3.0 is on opam, and Alcotest 1.10.0 is about to be. The
<a href="https://github.com/ocaml/opam-repository/pull/31135">opam-repository
CI</a> shows failures in
packages that depend on it, which I want to triage properly first.
Testing it before then is very welcome, with a pin:</p>
<pre><code>$ opam update
$ opam install dune-release
$ opam pin add -n https://github.com/mirage/alcotest.git#1.10.0
$ opam install alcotest
</code></pre>
<h2>Nested tests</h2>
<p>Alcotest suites used to have exactly two levels. <code>suite</code>, <code>test</code> and
<code>group</code> now nest to any depth, and the existing <code>test_case</code> and tuples
keep working next to them. A group's name is joined to its suite's with a
dot, and a regular expression on that name selects what runs:</p>
<div class="grid grid-cols-1 sm:grid-cols-2 gap-4 my-8 items-start">
<div class="min-w-0">
<pre><code class="language-ocaml">open Alcotest

let parse () = check int "parse" 42 (int_of_string "42")
let hex () = check int "hex" 255 (int_of_string "0xff")
let big () = check int "big" 1_000_000 (int_of_string "1000000")
let neg () = check int "neg" (-1) (int_of_string "-1")

let () =
  run "parser"
    [
      suite "int"
        [
          test "parse" parse;
          group "edge" [ test "big" big; test "neg" neg ];
          test "hex" hex;
        ];
    ]
</code></pre>
</div>
<div class="min-w-0">
<pre><code>$ ./test_parser.exe test '^int\.edge'
Testing `parser'.
This run has ID `M0FK86F8'.

  [SKIP]        int               0   parse.
  [OK]          int.edge          0   big.
  [OK]          int.edge          1   neg.
  [SKIP]        int               1   hex.

Full test results in `logs/M0FK86F8'.
Test Successful in 0.001s. 2 tests run.
</code></pre>
</div>
</div>
<p>Nesting was a long-standing request. <a href="https://github.com/craigfe">Craig
Ferguson</a> opened <a href="https://github.com/mirage/alcotest/issues/275">the
issue</a> in 2020, and
followed it with <a href="https://github.com/mirage/alcotest/pull/294">an RFC</a>
the next year: abstract test types nested to any depth, with tags and
source positions.
In the discussion, <a href="https://github.com/emillon">Etienne Millon</a> called the
two-level limit Alcotest's biggest, and <a href="https://github.com/mjambon">Martin
Jambon</a> argued for a flat list with dotted
names instead. <a href="https://github.com/yawaramin">Yawar Amin</a> later proposed
<a href="https://github.com/mirage/alcotest/pull/393">a <code>suite</code> function</a> to make
tests shorter to write. The RFC stalled on its abstract types, which would
have broken every existing test suite. This release takes <code>group</code> from
Craig's RFC, <code>suite</code> and <code>test</code> from Yawar's proposal and the dotted names
from Martin, and adds them next to the existing types rather than in
place of them. The RFC's tags and source positions are in this release
too, in the sections below. Thanks to all of them.</p>
<h2>Failures that point at your test</h2>
<p>Every failure now starts with the file and line of the test, including
uncaught exceptions and failures inside helpers. Here is a test with a bug
(<code>-0</code> does not survive a round trip):</p>
<pre><code class="language-ocaml">let round_trip s =
  Alcotest.(check string) "round trip" s (string_of_int (int_of_string s))

let decimal () = List.iter round_trip [ "1"; "-1"; "-0" ]

let () =
  Alcotest.run "parser"
    [ ("int", [ Alcotest.test_case "decimal" `Quick decimal ]) ]
</code></pre>
<div class="grid grid-cols-1 sm:grid-cols-2 gap-4 my-8 items-start">
<div class="min-w-0">
<pre><code># 1.9.1
File "list.ml", line 114, character 12:
FAIL round trip
</code></pre>
</div>
<div class="min-w-0">
<pre><code># 1.10.0
File "test_parser.ml", line 8, character 16:
FAIL round trip
</code></pre>
</div>
</div>
<p>(The idea and some of the code come from <a href="https://erratique.ch/">Daniel
Bünzli</a>'s <code>B0_testing</code>. A test case written as a
plain tuple can still lack a location, and wasm and js_of_ocaml builds do
not record backtraces, so they print none: <a href="https://github.com/mirage/alcotest/issues/475">this
issue</a> tracks a fix.)</p>
<h2>JUnit reports without touching your tests</h2>
<p><a href="https://docs.gitlab.com/ci/testing/unit_test_reports/">GitLab</a>,
<a href="https://circleci.com/docs/guides/test/collect-test-data/">CircleCI</a> and
<a href="https://plugins.jenkins.io/junit/">Jenkins</a> all read test results as JUnit
XML. Other ecosystems differ in how much work this takes.
<a href="https://docs.pytest.org/en/stable/how-to/output.html">pytest</a>,
<a href="https://docs.deno.com/runtime/reference/cli/test/">Deno</a>,
<a href="https://bun.com/docs/test/reporters">Bun</a> and
<a href="https://nodejs.org/api/test.html#test-reporters">Node.js</a> have an option.
Go needs <a href="https://github.com/gotestyourself/gotestsum">gotestsum</a>, Jest
needs <a href="https://github.com/jest-community/jest-junit">jest-junit</a>, and Rust
needs <a href="https://nexte.st/docs/machine-readable/junit/">nextest</a> (<code>cargo test</code> only offers it on nightly).</p>
<p>In OCaml, <a href="https://github.com/Khady/ocaml-junit"><code>junit_alcotest</code></a> by
<a href="https://github.com/Khady">Louis Roché</a> has written these reports for
Alcotest since 2017. Each test executable calls its <code>run_and_report</code> in
place of <code>Alcotest.run</code>, then writes the report to a path of its choice.
As a layer on top, it only sees what Alcotest's public interface gives it,
which has no source locations. Inside Alcotest, the report can take each
test's file and line from the same place as the failure messages above,
and it can still be written when a test ends the process early.</p>
<p>Alcotest now has <code>--junit</code>, and an environment variable, <code>ALCOTEST_JUNIT</code>,
that goes through dune. Existing tests and dune files need no change to
export JUnit reports. Each run adds its report to <code>_build/_tests/junit</code>:</p>
<div class="grid grid-cols-1 sm:grid-cols-2 gap-4 my-8 items-start">
<div class="min-w-0">
<pre><code>$ ALCOTEST_JUNIT=1 dune test --force
$ ls _build/_tests/junit
parser-20261109-101751-ZGXMDTK7.xml
store-20261109-101749-K6LO6TC3.xml
</code></pre>
</div>
<div class="min-w-0">
<pre><code class="language-yaml"># .gitlab-ci.yml
test:
  variables:
    ALCOTEST_JUNIT: "1"
  script:
    - dune test
  artifacts:
    when: always
    reports:
      junit: _build/_tests/junit/*.xml
</code></pre>
</div>
</div>
<p>Each failure carries its <code>file</code> and <code>line</code>, and the report survives a test
that ends the process. Here, <code>write</code> calls <code>exit</code>, as a library that gives
up might, and the report still names it:</p>
<div class="grid grid-cols-1 sm:grid-cols-2 gap-4 my-8 items-start">
<div class="min-w-0">
<pre><code class="language-ocaml">open Alcotest

let read () = check string "read" "a" "a"
let write () = exit 3
let close () = ()

let () =
  run "store"
    [
      suite "kv"
        [ test "read" read; test "write" write; test "close" close ];
    ]
</code></pre>
</div>
<div class="min-w-0">
<pre><code>&lt;testcase name="read" classname="store.kv" time="0.000"/&gt;
&lt;testcase name="write" classname="store.kv" time="0.000"&gt;
&lt;error message="[crash] The process stopped while
this test was running." type="crash"&gt;
</code></pre>
</div>
</div>
<p>The reports are experimental, which is why they are off by default for now.
I would like to hear from people who use them before deciding whether they
should be on by default and which fields they are missing.</p>
<h2>Flaky or broken?</h2>
<p>Keeping one report per run gives a history that other tools can read. To
try it, I wrote a toy key-value store with two kinds of failure.
<code>cache.lookup</code> loses a race about one run in six (faked with <code>Random</code>,
since a real race does not fail on demand), and after twenty runs I
committed a refactoring of <code>compact</code> that forgets to drop deleted keys:</p>
<pre><code class="language-diff">-  Hashtbl.filter_map_inplace (fun _ v -&gt; Option.map Option.some v) t;
+  Hashtbl.filter_map_inplace (fun _ v -&gt; Some v) t;
</code></pre>
<p><a href="https://github.com/antonsoo/flakemap">flakemap</a> reads the whole history
from that folder (I ran the first twenty runs before the refactoring and the last ten
after it):</p>
<pre><code>$ export ALCOTEST_JUNIT=1
$ for i in $(seq 30); do dune test --force; done
$ flakemap _build/_tests/junit --html flakemap.html
</code></pre>
<figure class="m-0 my-8 not-prose">
  <a href="https://gazagnaire.org/blog/images/alcotest-flakemap.png"><img src="https://gazagnaire.org/blog/images/alcotest-flakemap.png" class="w-full rounded-lg" alt="flakemap's heatmap of five tests over thirty runs: cache.compact passes twenty runs then fails every run after, marked as a defect; cache.lookup fails in four scattered runs, marked as intermittent; the three kv tests pass every run."></a>
  <figcaption class="text-xs text-gray-500 mt-2 leading-tight">The heatmap in flakemap's HTML report, with runs in order from left to right.</figcaption>
</figure>
<p>flakemap marks <code>cache.compact</code> as broken since the twenty-first run, the
first after the refactoring, and <code>cache.lookup</code> as flaky, failing in 13% of
the runs. Nothing was added to the reports for that: each file is a run,
and the test names inside are the rows. flakemap is very new (its
repository dates from September 2026) and orders the runs by the files'
modification times.</p>
<p>I picked flakemap because it was the first tool I found that draws a
history from local JUnit files, and others probably do more, or do it
better. The older <a href="https://gitlab.com/inorton/junit2html">junit2html</a>
draws the same grid with <code>--report-matrix</code>, for instance. That is
the point of a common format, even if with JUnit each tool seems to change
the standard a little. Alcotest gives each failing test a <code>file</code> and a
<code>line</code>, as pytest's <code>xunit1</code> reports do, and GitLab shows that file next
to the failure.</p>
<h2>Putting a flaky test aside</h2>
<p>Once a test is known to be flaky, I would rather skip it in normal runs
and keep running it somewhere else. Tests can now carry tags, and a run picks the tags
it wants with <code>--tags</code> or <code>ALCOTEST_TAGS</code> (a bit like Go's build tags). A
test tagged
<code>`Tag "flaky"</code> is skipped unless the run asks for it, so a nightly job
can keep an eye on it:</p>
<pre><code class="language-diff">-  suite "cache" [ test "lookup" lookup; test "compact" compact ];
+  suite "cache" [ test ~tags:(`Tag "flaky") "lookup" lookup; test "compact" compact ];
</code></pre>
<div class="grid grid-cols-1 sm:grid-cols-2 gap-4 my-8 items-start">
<div class="min-w-0">
<pre><code>$ dune test
  ...
  [SKIP]        cache          0   lookup.
  [OK]          cache          1   compact.

Test Successful in 0.003s. 4 tests run.
</code></pre>
</div>
<div class="min-w-0">
<pre><code>$ ALCOTEST_TAGS=flaky dune test --force
  ...
  [OK]          cache          0   lookup.
  [OK]          cache          1   compact.

Test Successful in 0.001s. 5 tests run.
</code></pre>
</div>
</div>
<p>The JUnit report keeps the skipped test as <code>&lt;skipped/&gt;</code>, and flakemap
leaves those runs out of <code>lookup</code>'s rate rather than counting them as
passes, so a test put aside does not start to look healthy. The built-in
<code>`Slow</code> tag works the same way (<code>-q</code> stops those tests), and tags
combine, as in <code>Tag.(slow &amp;&amp; v "release")</code>.</p>
<h2>The same tests under wasm</h2>
<p>Alcotest now works with
<a href="https://github.com/ocsigen/js_of_ocaml">wasm_of_ocaml</a>, thanks to <a href="https://github.com/hhugo">Hugo
Heuzard</a> and <a href="https://github.com/mefyl">Quentin
Hocquet</a>.
Add one mode to a dune stanza, and <code>dune test</code> runs the tests both ways
(you need <code>wasm_of_ocaml-compiler</code>, Binaryen and Node.js). This is worth
doing because <code>int</code> has 31 bits under wasm and 63 on a 64-bit native build,
and that is easy to forget:</p>
<div class="grid grid-cols-1 sm:grid-cols-2 gap-4 my-8 items-start">
<div class="min-w-0">
<pre><code>(test
 (name test_parser)
 (modes exe wasm)
 (libraries alcotest))
</code></pre>
</div>
<div class="min-w-0">
<pre><code class="language-ocaml">open Alcotest

let gib n = n * 1024 * 1024 * 1024
let five_gib () = check string "5 GiB" "5368709120" (string_of_int (gib 5))
let () = run "sizes" [ suite "gib" [ test "five" five_gib ] ]
</code></pre>
</div>
</div>
<div class="image-grid grid grid-cols-1 sm:grid-cols-2 gap-4 my-8 not-prose">
  <figure class="m-0 cursor-pointer">
    <a href="https://gazagnaire.org/blog/images/alcotest-native.svg"><img src="https://gazagnaire.org/blog/images/alcotest-native.svg" class="w-full rounded-lg" alt="An animated terminal recording: the native test executable runs the five GiB test, which passes."></a>
    <figcaption class="text-xs text-gray-500 mt-2 leading-tight">Native, recorded by <a href="https://gazagnaire.org/blog/2026-10-26-k7.html">k7</a>.</figcaption>
  </figure>
  <figure class="m-0 cursor-pointer">
    <a href="https://gazagnaire.org/blog/images/alcotest-wasm.svg"><img src="https://gazagnaire.org/blog/images/alcotest-wasm.svg" loading="lazy" class="w-full rounded-lg" alt="An animated terminal recording: the same test under Node.js fails, expecting 5368709120 and receiving -1073741824."></a>
    <figcaption class="text-xs text-gray-500 mt-2 leading-tight">wasm, under Node.js.</figcaption>
  </figure>
</div>
<h2>Upgrading Alcotest</h2>
<p>A suite that only uses <code>test_case</code> and tuples should compile unchanged.
Alcotest now requires OCaml 4.14 and dune 3.17, and the empty <code>alcotest-js</code>
package is gone (depend on <code>js_of_ocaml-compiler</code> instead). <code>speed_level</code>
is now an alias of the new <code>tag</code> type, which has more cases than
<code>`Quick</code> and <code>`Slow</code>. Code that restates the old type as
<code>[ `Quick | `Slow ]</code> stops compiling, and a <code>match</code> that handles only
those two cases is no longer exhaustive. The new names <code>test</code>, <code>suite</code> and <code>group</code> can
also hide values of your own. The
<a href="https://github.com/mirage/alcotest/blob/main/CHANGES.md">changelog</a> has
the rest, including UTF-8 in <code>string</code> failures and new testables for
<code>Uchar.t</code> and <code>Iarray.t</code>.</p>
<h2>dune-release on Windows</h2>
<p><code>dune-release distrib</code> and <code>dune-release check</code> now work on Windows,
building on <a href="https://github.com/tarides/dune-release/pull/378">work</a> that
<a href="https://github.com/emillon">Etienne Millon</a> started in 2021, and
the test suite runs there too. <code>publish</code> and <code>opam submit</code> are only tested
there with <code>--dry-run</code>, and <code>tar</code>, <code>bzip2</code> and <code>curl</code> must be in the <code>PATH</code>,
so reports from Windows users are very welcome.</p>
<p>The other change you will notice is from <a href="https://github.com/jberdine">Josh
Berdine</a>: files marked <code>export-ignore</code> in
<code>.gitattributes</code> no longer reach the release archive, as with <code>git archive</code>:</p>
<div class="grid grid-cols-1 sm:grid-cols-2 gap-4 my-8 items-start">
<div class="min-w-0">
<pre><code># .gitattributes
dune-workspace export-ignore
.github/** export-ignore
</code></pre>
</div>
<div class="min-w-0">
<pre><code>$ dune-release distrib
$ tar tjf _build/hello-0.1.0.tbz
hello-0.1.0/.gitattributes
hello-0.1.0/CHANGES.md
hello-0.1.0/LICENSE.md
hello-0.1.0/README.md
hello-0.1.0/dune-project
hello-0.1.0/hello.opam
</code></pre>
</div>
</div>
<p>dune-release also builds with the opam 2.6 libraries (thanks to <a href="https://github.com/vbgl">Vincent
Laporte</a>), <code>publish</code> respects <code>--dev-repo</code> (thanks
to <a href="https://github.com/shonfeder">Shon Feder</a>), and <code>opam submit</code> always
prints the URL of the pull request it opened. Its
<a href="https://github.com/tarides/dune-release/blob/main/CHANGES.md">changelog</a>
has the rest.</p>
<p>Thanks to everyone above and to the other contributors and reviewers named
in the changelogs, some of whom waited for years. Feedback is welcome on the
<a href="https://github.com/mirage/alcotest/issues">Alcotest</a> and
<a href="https://github.com/tarides/dune-release/issues">dune-release</a> issue
trackers. Before 1.10.0 reaches opam, I am most interested in Alcotest
code that stopped compiling, and in how the JUnit reports fare in your CI.
The new features are meant to be backward compatible, unless you write
your own engine or rely on one of its internal types. Apart from the cases
in the upgrading section above, a test suite that breaks is a bug.</p>
