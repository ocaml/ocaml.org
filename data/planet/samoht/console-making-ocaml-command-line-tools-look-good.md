---
title: 'console: Making OCaml Command-Line Tools Look Good'
description: An OCaml library for command-line tools that draw live tables and progress
  rows like full-screen apps but keep their output in the scrollback, shown with imitations
  of docker and cargo.
url: https://gazagnaire.org/blog/2026-11-02-console.html
date: 2026-11-02T00:00:00-00:00
preview_image: https://gazagnaire.org/blog/og/2026-11-02-console.png
authors:
- Thomas Gazagnaire
source:
ignore:
keywords:
- console
- eio
- parser
- rgb
- rows
- scrollback
- task
- terminal
- theme
- view
---

<p>A command-line tool can print lines, which stay in the terminal's
scrollback but look plain. Or it can take over the screen like a
full-screen app, which looks good until it exits and takes its output
with it. I wanted the looks of the second and the scrollback of the
first, so I wrote
<a href="https://github.com/samoht/ocaml-console">console</a>, an
<a href="https://ocaml.org/">OCaml</a> library for tables, trees and live progress
rows that print into the scrollback. Its first version, 0.9.0, is now on
<a href="https://opam.ocaml.org/">opam</a>:</p>
<pre><code>$ opam install console console-eio
</code></pre>
<p>It comes in two parts. <code>console</code> is a set of pure, composable widgets.
Each one is a three-dimensional object, drawn in the room it is given (a
width and a height) at a given time, so the same widget can be printed
once or animated. There are enough of them to write <a href="https://github.com/samoht/ocaml-console/blob/0.9.0/examples/camel/main.ml">a command-line
game where a camel jumps over
lambdas</a>,
or <a href="https://github.com/samoht/ocaml-console/blob/0.9.0/examples/stocks/main.ml">a stock
ticker</a>.
<code>console-eio</code> is the driver that feeds them the clock, the keyboard and
the terminal's size changes, through
<a href="https://github.com/ocaml-multicore/eio">Eio</a> for now. Both need OCaml
5.4, on Linux or macOS.</p>
<div class="image-grid grid grid-cols-1 sm:grid-cols-2 gap-4 my-8 not-prose">
  <figure class="m-0 cursor-pointer">
    <a href="https://gazagnaire.org/blog/images/console-camel.svg"><img src="https://gazagnaire.org/blog/images/console-camel.svg" class="w-full rounded-lg" alt="An animated terminal recording: a camel drawn in block characters runs along the ground and jumps over lambdas while a score counts up."></a>
    <figcaption class="text-xs text-gray-500 mt-2 leading-tight">
      <a href="https://github.com/samoht/ocaml-console/blob/0.9.0/examples/camel/main.ml">examples/camel/main.ml</a>,
      recorded by <a href="https://gazagnaire.org/blog/2026-10-26-k7.html">k7</a>.
    </figcaption>
  </figure>
  <figure class="m-0 cursor-pointer">
    <a href="https://gazagnaire.org/blog/images/console-stocks.svg"><img src="https://gazagnaire.org/blog/images/console-stocks.svg" loading="lazy" class="w-full rounded-lg" alt="An animated stock ticker in a terminal: a table of invented tickers with prices coloured by their last move and a sparkline per row, and a histogram of the day's returns."></a>
    <figcaption class="text-xs text-gray-500 mt-2 leading-tight">
      A trading day on an invented exchange:
      <a href="https://github.com/samoht/ocaml-console/blob/0.9.0/examples/stocks/main.ml">examples/stocks/main.ml</a>,
      recorded by <a href="https://gazagnaire.org/blog/2026-10-26-k7.html">k7</a>.
    </figcaption>
  </figure>
</div>
<h2>It looks like a TUI, but you can scroll</h2>
<p>The recordings in this post look like full-screen terminal applications,
but none of them is one. A full-screen program switches the terminal to
its alternate screen, which suits an editor. A build or a test run is
different, as its output is read after it ends, in a CI log or by an LLM
agent that ran it. So
console redraws only the few rows at the bottom that are still running,
and everything a program printed is still there when it ends.</p>
<p>OCaml is a great language for command-line tools, and I have written or
maintained a few of them over the years, <a href="https://opam.ocaml.org/">opam</a>
among them (<a href="https://github.com/AltGr">Louis Gesbert</a> later made its
output much nicer). But I have always looked jealously at the tools of
other ecosystems, and I have brought one to OCaml before, with <a href="https://gazagnaire.org/blog/2026-04-21-tailwind-ocaml.html">Tailwind
without Node</a>. Docker's
<a href="https://github.com/moby/buildkit">BuildKit</a>, cargo, uv and pnpm print lines into the scrollback and redraw only a small
live region below them, and they look good doing it. I wanted the same
for OCaml, with a pure OCaml API and output versatile enough for all my
tools, including the one I am writing to deploy applications to
satellites with <a href="https://gazagnaire.org/blog/2026-05-14-borealis.html">SpaceOS</a>.</p>
<p>OCaml already had some of the pieces.
<a href="https://github.com/c-cube/printbox">printbox</a> prints boxes, tables and
trees, and <a href="https://github.com/CraigFe/progress">progress</a> draws progress
bars. But I could not combine them, because a box cannot redraw and a
progress bar cannot sit in a table. console has a single type of view for
both, so the live rows are built from the same tables, trees and panels
as the output that stays in the scrollback. Most libraries keep the size
and the time in mutable state, as Bubble Tea does in its model. A console
widget takes both as arguments, so it can nest in any other widget and
still move.</p>
<p>console borrows a lot from Python's <a href="https://github.com/Textualize/rich">Rich</a>,
which it is modelled on, and from
<a href="https://github.com/console-rs/indicatif">indicatif</a> in Rust and Charm's
<a href="https://github.com/charmbracelet/lipgloss">lipgloss</a> in Go. Full-screen
frameworks such as Charm's <a href="https://github.com/charmbracelet/bubbletea">Bubble Tea</a>
or OCaml's <a href="https://github.com/pqwy/notty">notty</a> solve a different
problem. The README's <a href="https://github.com/samoht/ocaml-console#related-work">related
work</a> lists the rest.</p>
<p>To see how far a single type of view goes, I imitated the output of the
tools I use every day. None of these is the real tool: each is a short console
program that draws its rows the way that tool does, and its source is in
the repository's
<a href="https://github.com/samoht/ocaml-console/tree/main/examples">examples</a>
directory. So you can now pick your favourite package manager, and have
your OCaml tool look like it:</p>
<div class="image-grid grid grid-cols-1 sm:grid-cols-2 gap-4 my-8 not-prose">
  <figure class="m-0 cursor-pointer">
    <a href="https://gazagnaire.org/blog/images/console-opam.svg"><img src="https://gazagnaire.org/blog/images/console-opam.svg" loading="lazy" class="w-full rounded-lg" alt="An imitation of opam install dune cmdliner fmt: the plan, a line per action as it ends, and one status line shared by the running jobs."></a>
    <figcaption class="text-xs text-gray-500 mt-2 leading-tight"><a href="https://github.com/samoht/ocaml-console/blob/0.9.0/examples/opam/main.ml"><code>opam install</code></a></figcaption>
  </figure>
  <figure class="m-0 cursor-pointer">
    <a href="https://gazagnaire.org/blog/images/console-cargo.svg"><img src="https://gazagnaire.org/blog/images/console-cargo.svg" loading="lazy" class="w-full rounded-lg" alt="An imitation of cargo build: Compiling lines for a dozen crates in the scrollback, and one line redrawn below naming the units that run."></a>
    <figcaption class="text-xs text-gray-500 mt-2 leading-tight"><a href="https://github.com/samoht/ocaml-console/blob/0.9.0/examples/cargo/main.ml"><code>cargo build</code></a></figcaption>
  </figure>
  <figure class="m-0 cursor-pointer">
    <a href="https://gazagnaire.org/blog/images/console-pnpm.svg"><img src="https://gazagnaire.org/blog/images/console-pnpm.svg" loading="lazy" class="w-full rounded-lg" alt="An imitation of pnpm install: a progress line, the box of a running install script, then the dependencies added and the time it took."></a>
    <figcaption class="text-xs text-gray-500 mt-2 leading-tight"><a href="https://github.com/samoht/ocaml-console/blob/0.9.0/examples/pnpm/main.ml"><code>pnpm install</code></a></figcaption>
  </figure>
  <figure class="m-0 cursor-pointer">
    <a href="https://gazagnaire.org/blog/images/console-docker.svg"><img src="https://gazagnaire.org/blog/images/console-docker.svg" loading="lazy" class="w-full rounded-lg" alt="An imitation of docker buildx build: a header counting steps, one row per Dockerfile step with its time on the right, and the layers and last log lines of the running step under it."></a>
    <figcaption class="text-xs text-gray-500 mt-2 leading-tight"><a href="https://github.com/samoht/ocaml-console/blob/0.9.0/examples/docker/main.ml"><code>docker buildx build</code></a></figcaption>
  </figure>
  <figure class="m-0 cursor-pointer">
    <a href="https://gazagnaire.org/blog/images/console-brew.svg"><img src="https://gazagnaire.org/blog/images/console-brew.svg" loading="lazy" class="w-full rounded-lg" alt="An imitation of brew install wget: the bottles of wget and its dependencies download side by side, each row with a spinner, its sizes and a bar, and a check mark in the scrollback when it is done."></a>
    <figcaption class="text-xs text-gray-500 mt-2 leading-tight"><a href="https://github.com/samoht/ocaml-console/blob/0.9.0/examples/brew/main.ml"><code>brew install</code></a></figcaption>
  </figure>
  <figure class="m-0 cursor-pointer">
    <a href="https://gazagnaire.org/blog/images/console-nix.svg"><img src="https://gazagnaire.org/blog/images/console-nix.svg" loading="lazy" class="w-full rounded-lg" alt="An imitation of nix build: the plan printed once, then a single status line counting builds, copies and downloads and naming the latest activity."></a>
    <figcaption class="text-xs text-gray-500 mt-2 leading-tight"><a href="https://github.com/samoht/ocaml-console/blob/0.9.0/examples/nix/main.ml"><code>nix build</code></a></figcaption>
  </figure>
  <figure class="m-0 cursor-pointer">
    <a href="https://gazagnaire.org/blog/images/console-uv.svg"><img src="https://gazagnaire.org/blog/images/console-uv.svg" loading="lazy" class="w-full rounded-lg" alt="An imitation of uv sync: resolving, downloading wheels side by side, installing, then the list of installed packages."></a>
    <figcaption class="text-xs text-gray-500 mt-2 leading-tight"><a href="https://github.com/samoht/ocaml-console/blob/0.9.0/examples/uv/main.ml"><code>uv sync</code></a></figcaption>
  </figure>
  <figure class="m-0 cursor-pointer">
    <a href="https://gazagnaire.org/blog/images/console-apt.svg"><img src="https://gazagnaire.org/blog/images/console-apt.svg" loading="lazy" class="w-full rounded-lg" alt="An imitation of apt install curl: what apt and dpkg print scrolls above a bottom line showing the download, then dpkg's Progress bar."></a>
    <figcaption class="text-xs text-gray-500 mt-2 leading-tight"><a href="https://github.com/samoht/ocaml-console/blob/0.9.0/examples/apt/main.ml"><code>apt install</code></a></figcaption>
  </figure>
</div>
<h2>Tasks and their logs</h2>
<p>A program reports its work as tasks. While a task runs, its row shows
its latest lines in a window of <code>~log_lines</code> of them: its
<a href="https://erratique.ch/software/logs">Logs</a> messages, the lines given to
<code>Task.log</code> and what it prints with <code>Fmt.pr</code>. The window folds away when
the task succeeds, as BuildKit's does. When the task fails, it stays
under its <code>✗</code> line:</p>
<pre><code class="language-ocaml">open Console

let build root =
  Task.run root "compile" (fun step -&gt;
      Task.log step "ocamlopt parser.ml";
      Logs.warn (fun m -&gt; m "parser.ml: unused variable x"));
  Task.run root "test" (fun step -&gt;
      Task.log step "test_parser: 11 passed";
      Task.log step "test_lexer: expected 3, got 4";
      Task.fail step);
  Task.fail ~message:"1 test failed" root

let () =
  Eio_main.run @@ fun env -&gt;
  Console_eio.run ~clock:(Eio.Stdenv.mono_clock env) ~label:"Building" build
</code></pre>
<p>The rows go to standard error, which leaves standard output to the
program. Piped into another program with both, nothing is redrawn, and
each line is printed once (left). On a terminal, the rows of the tasks
still running are redrawn in place, under a table of the steps that
changes as they go (right, from another example). A warning logged
outside a task stays above the rows once that task succeeds:</p>
<div class="grid grid-cols-1 sm:grid-cols-2 gap-4 my-8 items-start">
<div class="min-w-0">
<pre><code>$ ./build.exe 2&gt;&amp;1 | cat
• compile
  › compile: ocamlopt parser.ml
  ! compile: parser.ml: unused variable x
✓ compile  0.0s
• test
  › test: test_parser: 11 passed
  › test: test_lexer: expected 3, got 4
✗ test  0.0s  failed
✗ Building 0.0s (2/2)
✗ 1 test failed
</code></pre>
</div>
<figure class="image-grid m-0 cursor-pointer not-prose">
    <a href="https://gazagnaire.org/blog/images/console-display.svg"><img src="https://gazagnaire.org/blog/images/console-display.svg" loading="lazy" class="w-full rounded-lg" alt="An animated terminal recording: a gradient title and a table of three build steps above the live rows; fetch and compile run side by side with their latest commands under them, a warning stays in the scrollback, then the tests run and the build completes."></a>
    <figcaption class="text-xs text-gray-500 mt-2 leading-tight">
      <a href="https://github.com/samoht/ocaml-console/blob/0.9.0/examples/display/main.ml">examples/display/main.ml</a>,
      recorded by <a href="https://gazagnaire.org/blog/2026-10-26-k7.html">k7</a>.
    </figcaption>
  </figure>
</div>
<h2>Themes</h2>
<p>console comes with a bunch of themes, all shown in the
<a href="https://github.com/samoht/ocaml-console#themes">README</a>, and you can
define your own. The default theme uses
the terminal's own colours. Others follow existing colour schemes, such
as <a href="https://draculatheme.com/">Dracula</a> and
<a href="https://ethanschoonover.com/solarized/">Solarized</a>. <code>Theme.matrix</code> and
<code>Theme.rainbow</code> are animated.</p>
<div class="image-grid grid grid-cols-1 sm:grid-cols-2 gap-4 my-8 not-prose">
  <figure class="m-0 cursor-pointer">
    <a href="https://gazagnaire.org/blog/images/console-theme-matrix.svg"><img src="https://gazagnaire.org/blog/images/console-theme-matrix.svg" loading="lazy" class="w-full rounded-lg" alt="Theme.matrix: a file tree, two finished tasks, a table of two packages and two running progress rows in green, with digital rain running along the frames."></a>
    <figcaption class="text-xs text-gray-500 mt-2 leading-tight"><a href="https://github.com/samoht/ocaml-console/blob/0.9.0/examples/themes/main.ml"><code>Theme.matrix</code></a></figcaption>
  </figure>
  <figure class="m-0 cursor-pointer">
    <a href="https://gazagnaire.org/blog/images/console-theme-rainbow.svg"><img src="https://gazagnaire.org/blog/images/console-theme-rainbow.svg" loading="lazy" class="w-full rounded-lg" alt="Theme.rainbow: the same tree, table and progress rows, with a rainbow sweeping round the frames."></a>
    <figcaption class="text-xs text-gray-500 mt-2 leading-tight"><a href="https://github.com/samoht/ocaml-console/blob/0.9.0/examples/themes/main.ml"><code>Theme.rainbow</code></a></figcaption>
  </figure>
</div>
<div class="image-grid grid grid-cols-1 sm:grid-cols-2 gap-4 my-8 not-prose">
  <figure class="m-0 cursor-pointer">
    <a href="https://gazagnaire.org/blog/images/console-theme-default.svg"><img src="https://gazagnaire.org/blog/images/console-theme-default.svg" loading="lazy" class="w-full rounded-lg" alt="Theme.default: the same tree, table and progress rows, in the terminal's own colours."></a>
    <figcaption class="text-xs text-gray-500 mt-2 leading-tight"><a href="https://github.com/samoht/ocaml-console/blob/0.9.0/examples/themes/main.ml"><code>Theme.default</code></a></figcaption>
  </figure>
  <figure class="m-0 cursor-pointer">
    <a href="https://gazagnaire.org/blog/images/console-theme-dos.svg"><img src="https://gazagnaire.org/blog/images/console-theme-dos.svg" loading="lazy" class="w-full rounded-lg" alt="Theme.dos: the same tree, table and progress rows in amber, with double-line frames and marks in brackets."></a>
    <figcaption class="text-xs text-gray-500 mt-2 leading-tight"><a href="https://github.com/samoht/ocaml-console/blob/0.9.0/examples/themes/main.ml"><code>Theme.dos</code></a></figcaption>
  </figure>
  <figure class="m-0 cursor-pointer">
    <a href="https://gazagnaire.org/blog/images/console-theme-dracula.svg"><img src="https://gazagnaire.org/blog/images/console-theme-dracula.svg" loading="lazy" class="w-full rounded-lg" alt="Theme.dracula: the same tree, table and progress rows in Dracula's colours."></a>
    <figcaption class="text-xs text-gray-500 mt-2 leading-tight"><a href="https://github.com/samoht/ocaml-console/blob/0.9.0/examples/themes/main.ml"><code>Theme.dracula</code></a></figcaption>
  </figure>
  <figure class="m-0 cursor-pointer">
    <a href="https://gazagnaire.org/blog/images/console-theme-solarized-light.svg"><img src="https://gazagnaire.org/blog/images/console-theme-solarized-light.svg" loading="lazy" class="w-full rounded-lg" alt="Theme.solarized_light: the same tree, table and progress rows on Solarized's light background."></a>
    <figcaption class="text-xs text-gray-500 mt-2 leading-tight"><a href="https://github.com/samoht/ocaml-console/blob/0.9.0/examples/themes/main.ml"><code>Theme.solarized_light</code></a></figcaption>
  </figure>
</div>
<h2>Putting views together</h2>
<p>Tables, trees, panels and bars can all be put inside one another, a bit
like boxes in an HTML page. Here, for instance, a tree of files sits
next to a small panel, which has a sparkline inside it:</p>
<pre><code class="language-ocaml">open Console

let tree =
  let leaf s = Tree.v (View.text s) [] in
  Tree.view
  @@ Tree.v (View.text "lib")
       [ leaf "view.ml"; leaf "table.ml"; leaf "panel.ml" ]

let build =
  Panel.view ~title:(View.text "Build")
    (View.vcat
       [
         View.text "time   1.2s";
         View.hcat
           [ View.text "trend"; Bar.sparkline [ 3.; 5.; 2.; 8.; 6.; 9. ] ];
       ])

let () =
  Console_tty.setup ();
  Fmt.pr "%a@." View.pp (View.hcat [ tree; build ])
</code></pre>
<pre><code>lib           ╭──── Build ────╮
├── view.ml   │ time   1.2s   │
├── table.ml  │ trend  ▂▄▁▇▅█ │
└── panel.ml  ╰───────────────╯
</code></pre>
<p>The same goes for bar charts, and for the live rows themselves. So a
program can keep a summary table above its running tasks, or give each
of its builds a column of its own:</p>
<div class="image-grid grid grid-cols-1 sm:grid-cols-2 gap-4 my-8 not-prose">
  <figure class="m-0 cursor-pointer">
    <a href="https://gazagnaire.org/blog/images/console-charts.svg"><img src="https://gazagnaire.org/blog/images/console-charts.svg" loading="lazy" class="w-full rounded-lg" alt="A week's load as a bar chart in a panel, then a table of three machine metrics, each with a sparkline of the last hour and its current value."></a>
    <figcaption class="text-xs text-gray-500 mt-2 leading-tight"><a href="https://github.com/samoht/ocaml-console/blob/0.9.0/examples/charts/main.ml"><code>Bar.chart</code> and <code>Bar.sparkline</code> in a panel and a table</a></figcaption>
  </figure>
  <figure class="m-0 cursor-pointer">
    <a href="https://gazagnaire.org/blog/images/console-columns.svg"><img src="https://gazagnaire.org/blog/images/console-columns.svg" loading="lazy" class="w-full rounded-lg" alt="Two builds running side by side: a table of their status at the top, the tree of each build's steps in a column of its own, and the summary at the bottom."></a>
    <figcaption class="text-xs text-gray-500 mt-2 leading-tight"><a href="https://github.com/samoht/ocaml-console/blob/0.9.0/examples/columns/main.ml">Two builds side by side, with <code>View.hcat</code></a></figcaption>
  </figure>
</div>
<h2>Not only progress bars</h2>
<p>The live rows can draw more than progress bars, like the camel at the
top of this post. I also built a simulated
<a href="https://en.wikipedia.org/wiki/Winamp">Winamp</a> 2 player out of console's
ordinary widgets. Two panels hold the player and the playlist. Vertical
bars draw the spectrum analyser, whose bands are a few sines and some
seeded noise, so every run draws the same frames. Horizontal bars draw
the volume, the balance and the seek bar, and plain text laid out with
<code>View.hcat</code> and <code>View.vcat</code> gives the LCD digits and the scrolling title.
A theme of its own then gives it Winamp's colours, with the analyser's
palette from Winamp's default skin:</p>
<div class="grid grid-cols-1 sm:grid-cols-2 gap-4 my-8 items-start">
<div class="min-w-0">
<pre><code class="language-ocaml">open Console

let rgb = Color.rgb
let green = rgb 0 232 0

(* Winamp's default analyser colours (viscolor.txt), from the bottom up. *)
let viscolor =
  [
    rgb 24 132 8;
    rgb 41 206 16;
    rgb 148 222 33;
    rgb 222 165 24;
    rgb 214 90 0;
    rgb 239 49 16;
  ]

let theme =
  Theme.v ~name:"winamp" ~accent:green ~palette:viscolor
    ~muted:(rgb 150 150 150) ~background:(rgb 41 41 57) ~border:Border.single
    ~header:Style.(bold + fg (rgb 214 214 222))
    ()

let () = Console_tty.setup ~theme ()
</code></pre>
</div>
<figure class="image-grid m-0 cursor-pointer not-prose">
    <a href="https://gazagnaire.org/blog/images/console-music.svg"><img src="https://gazagnaire.org/blog/images/console-music.svg" loading="lazy" class="w-full rounded-lg" alt="An animated imitation of Winamp 2 in a terminal: LCD digits for the elapsed time, a scrolling title, a green spectrum analyser with falling peaks, a seek bar and a playlist."></a>
    <figcaption class="text-xs text-gray-500 mt-2 leading-tight">
      <a href="https://github.com/samoht/ocaml-console/blob/0.9.0/examples/music/main.ml">examples/music/main.ml</a>,
      recorded by <a href="https://gazagnaire.org/blog/2026-10-26-k7.html">k7</a>.
    </figcaption>
  </figure>
</div>
<h2>Keeping the terminal at the edge</h2>
<p>The goal is for console to work with the libraries OCaml command-line
tools already use. A view prints with
<a href="https://erratique.ch/software/fmt">Fmt</a> on any formatter, and
<code>Console_tty.setup</code> takes the same style renderer as <code>Fmt_tty</code>, so a
<code>--color</code> flag from <code>Fmt_cli</code> works unchanged.
<a href="https://erratique.ch/software/logs">Logs</a> works unmodified too, as the
tasks above show.</p>
<p>For tables and trees, that is easy, as each of them is just a value that
a formatter function prints, a bit like the view in <a href="https://guide.elm-lang.org/architecture/">the Elm
architecture</a>. The live rows
are trickier, as they depend on time and on the size of the terminal.
So the display never reads the clock or asks the terminal for its size
itself: it is given a function for each, and a formatter to write to.
<code>console-eio</code> provides them for Eio programs, and the tests provide a
buffer and a clock that they move by hand.</p>
<p>This is the same idea as in
<a href="https://www.usenix.org/conference/usenixsecurity15/technical-sessions/presentation/kaloper-mersinjak">nqsb-TLS</a>,
the TLS stack of <a href="https://mirageos.org/">MirageOS</a>. Its core takes bytes
and returns bytes, and leaves the network to its caller. console is less strict, as its display
still writes to the formatter it is given instead of returning what to
write. But the clock and the terminal stay outside, and that is what
makes the recordings reproducible.</p>
<h2>Recording the animations</h2>
<p>A library like this one is shown by its animations, and I changed the
code every day while writing it. Recorded by hand, with
<a href="https://github.com/charmbracelet/vhs">VHS</a> or
<a href="https://asciinema.org/">asciinema</a>, the images in the README would have
stopped matching the code within a week. So I wrote
<a href="https://github.com/samoht/ocaml-k7">k7</a>, a small language-agnostic tool,
to record them (see <a href="https://gazagnaire.org/blog/2026-10-26-k7.html">last week's post</a>). Under a
mocked clock, a console program's output no longer depends on how fast the machine is, so k7
draws the same SVG image, animated with CSS alone, on every run. Each
image is then a test. <a href="https://dune.build/">dune</a> draws it again from
its program and diffs it against the one in the repository, so the
images change with the code.</p>
<h2>What's next</h2>
<p>I will move my own tools to console over the next few weeks, before
cutting a 1.0 release, starting with the ones in my Homebrew tap and the
<a href="https://gazagnaire.org/blog/2026-05-14-borealis.html">SpaceOS</a> CLI. I tried a few ideas over the
last six months in an <a href="https://tangled.org/gazagnaire.org/ocaml-console">experimental
playground</a>, but the
<a href="https://github.com/samoht/ocaml-console">GitHub repository</a> is now the
official one, and the one released on opam. I will delete the playground
once all my tools have moved. Feedback is welcome on its <a href="https://github.com/samoht/ocaml-console/issues">issue
tracker</a>.</p>
