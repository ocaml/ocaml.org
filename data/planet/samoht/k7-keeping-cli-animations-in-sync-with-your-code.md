---
title: 'k7: Keeping CLI Animations in Sync with Your Code'
description: "I have always been a fan of asciinema and of\nCharm's\nVHS. asciinema
  records a\nterminal while you use it, and VHS types a script of commands into a\nterminal
  and films the result. I wanted their animations in the READMEs\nof my projects,
  but I always forgot the syntax of VHS's tape files, and\nI always mistyped a command
  halfway through an asciinema recording (and\nthen started again). I also always
  forgot to re-run those recordings\nwhen my API changed, and they got out of sync
  quickly.\nFortunately, most of my projects already check their command-line output\nwith
  cram\ntests,\ntranscripts of shell commands and of what they print, which\ndune,
  OCaml's build system, runs as tests. Making\nthose tests produce animated images
  was a short stretch, and then, why\nstop there? The result is k7 (how\nthe French
  write cassette, if you say it out loud), a command-line\ntool that records any program,
  whatever its language, as an SVG image\nanimated with CSS alone.\nHere is ls, and
  sl, which I\nregularly enjoy mistyping. Each took one command, such as k7 rec -o
  sl.svg -- sl, which generates an animation you can embed in any HTML\npage (and
  in your projects' READMEs).\n\n  \n    \n    ls, as I meant to type it.\n  \n  \n
  \   \n    sl, as I actually typed it.\n  \n\nAnimations that dune checks\nI was
  not the first to draw a terminal as an animated SVG.\ntermtosvg (now archived) and\nsvg-term-cli
  do it too.\nWhat k7 adds, I think, is that it both writes and plays dune's cram\ntests.\nA
  cram test is a text file that reads like a terminal session. Each\ncommand is indented
  and starts with $ , the output it should print\nsits below it, and any other line
  is a comment:\nPrint a greeting:\n\n  $ printf 'hello\\n'\n  hello\n\ndune test
  runs the commands of each test in a new empty directory and\ncompares what they
  print with the file. When the output changes, dune\nshows the difference, and dune
  promote writes the new output into the\nfile.\nk7 fits into that loop at both ends.
  k7 rec -o hello.t -- printf 'hello\\n' writes the test above (without the comment).
  In the other\ndirection, k7 play types the commands of a cram test into\nbash and
  draws what happens. The\nimage at the top of k7's\nREADME comes from\ndoc/demo.t,\ndrawn
  by k7 play -o doc/demo.svg doc/demo.t. Dune runs the same file\nas a test, so the
  test fails exactly when the image needs drawing again,\nand drawing it again takes
  one command.\n\n  \n    \n    \n      doc/demo.t from k7's repository, typed into
  bash by\n      k7 play.\n    \n  \n\nThe same screen as VHS, every time\nk7 rec
  runs a program on a pseudo-terminal and feeds what it prints to\na terminal emulator,\nmatrix,
  from Thibaut\nMattio's\nmosaic\nproject at Invariant\nSystems. I wanted k7 to draw
  the same screens\nas VHS, which runs xterm.js in a\nbrowser, so I fixed the places
  where matrix and xterm.js disagreed and\nsent the fixes\nupstream.\nEach time the
  program changes the screen, k7 keeps a copy of it, at\nmost 50 times a second (as
  in VHS). Each distinct line of text is\ndefined once, each frame refers to the lines
  it shows, and a single CSS\n@keyframes rule slides the strip of frames, jumping
  to each one at the\ntime the program drew it.\nThis keeps the file small when most
  lines stay put: the image of ls\nabove takes 4 KB. A train crossing the screen is
  the worst case, and the\nimage of sl takes 356 KB. The GIF that VHS made of the
  same sl, on a\nterminal of the same size, takes 2.1 MB. VHS drives a headless browser\nand
  encodes the frames with ffmpeg, and on my\nlaptop it took 53 seconds, against 8
  for k7 rec, about 7 of which were\nsl itself.\nA program like sl has no cram test,
  since its output is an animation\nrather than text. For those, k7 rec -o sl.cast
  -- sl keeps the\nrecording itself, in asciinema's asciicast\nv3 format, and k7 play
  draws it, or any asciinema recording, without running anything.\nRecording is not
  deterministic, but drawing is. Record sl twice and\nthe two recordings differ, because
  the program never prints at quite the\nsame times. Draw one recording twice and
  you get the same file, byte for\nbyte. So dune can check a committed image against
  the recording beside\nit:\n(rule\n (target sl.generated.svg)\n (action\n  (run k7
  play -o %{target} %{dep:sl.cast})))\n\n(rule\n (alias runtest)\n (action\n  (diff
  sl.svg sl.generated.svg)))\n\nA tape syntax the compiler remembers\nThat leaves
  the VHS tape syntax I kept forgetting. k7 plays .tape\nfiles too, and in OCaml,
  the\nK7 library\nbuilds tapes as values instead, so the compiler remembers the syntax
  for\nme:\nlet tape =\n  K7.tape\n    ~settings:K7.[ Font_size 18; Width 1000; Height
  560 ]\n    ~outputs:[ \"demo.gif\" ]\n    K7.[ type' \"dune test\\n\"; wait Prompt;
  sleep (Ms 2000) ]\n\nK7.tape checks the tape against the rules of VHS's parser as
  soon as\nit is built, theme name included, where VHS only notices a misspelt\ntheme
  when it runs the tape. Its tests hold it to vhs validate on 3000\nrandom tape lines,
  as I held my Tailwind rewrite to Tailwind\nitself.\nTrying it\nk7 0.9.0 is in my
  Homebrew\ntap, for macOS and Linux, and\non opam for OCaml 5.4 and later:\n$ brew
  install samoht/tap/k7\n$ opam install k7\n\nA few edge cases are not supported (the
  README lists\nthem), but for\nmost uses it seems to work fine. If k7 draws something
  differently from\nVHS or asciinema, please open an\nissue with the recording\n(k7
  rec -o bug.cast -- yourprogram makes one)."
url: https://gazagnaire.org/blog/2026-10-26-k7.html
date: 2026-10-26T00:00:00-00:00
preview_image: https://gazagnaire.org/blog/og/2026-10-26-k7.png
authors:
- Thomas Gazagnaire
source:
ignore:
keywords:
- "animations"
- "asciinema"
- "cram"
- "parser"
- "recording"
- "svg"
- "tape"
- "terminal"
- "validate"
- "vhs"
---
