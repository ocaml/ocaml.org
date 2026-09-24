---
title: 'Rewriting Tailwind CSS in OCaml: Is It (Pixel-)Correct?'
description: "I really like Tailwind CSS. Keeping styles\nnext to the HTML makes it
  much easier to keep the two in sync. I can\nsee which styles a component uses without
  tracing selectors across\nfiles, and removing the component doesn't leave me wondering
  which\nCSS rules are still needed elsewhere.\nIn my projects, though, Tailwind also
  brought a Node.js toolchain into\nthe build. I use OCaml for most of my software
  projects, including the\ncode that generates HTML for web applications (like this
  blog!), so\nkeeping a second build loop in sync was awkward. I wanted the same convenience
  within\nOCaml: a component could carry its Tailwind styles with it, and the\nbuild
  could generate both HTML and CSS together. That library became\ntw, which, as of
  its 1.1.0 release,\nbuilds whole Tailwind v4 projects, with their themes and plugins,
  and\nwithout Node.js. It is a drop-in replacement for the Tailwind CLI,\nwhatever
  language your project is written in:\n$ brew install samoht/tap/tw        # or:
  opam install tw\n$ tw -i src/app.css -o dist/app.css\n\nBut how could I tell whether
  it was a faithful replacement? Different\nCSS can produce the same page, and a stylesheet
  that looks plausible\ncan still move a button or break a hover effect. This post
  describes\nthe checks I built to answer that question. Each of them ended up\ntrusting
  something it should not, and in the end I had to let the\nbrowser decide.\nComparing
  the CSS\nTailwind itself gave me the first oracle: an implementation that\nsupplies
  the expected output. I fed the same classes to Tailwind and\ntw, compiled both,
  and compared the resulting CSS. Tailwind's own\nutility and variant fixtures provided
  the first inputs, followed by\nwhole-project stylesheets that made the features
  interact. Each\ndisagreement gave me something small to investigate.\nAt first I
  aimed for identical bytes. That caught details a visual\ninspection would miss:
  a selector escaped incorrectly, a missing\nvariable, a slightly different fractional
  width. It also turned a\nharmless change in whitespace or colour spelling into a
  failure. Once\nI started optimising the output, two compilers producing the same
  file\nwas no longer the result I wanted. I wanted to allow different CSS that\ndid
  the same job.\nSo I needed a CSS-aware comparison. That became\ncascade, which I\nwrote
  about in July: it parses both\nfiles, normalises equivalent spellings, and reports
  the selectors and\ndeclarations that differ. With differences reported by rule,
  porting\nbecame much more pleasant: a change in padding no longer meant reading\na
  line of several thousand characters.\nWho checks the checker?\nThere is a problem
  with writing both the compiler and its checker.\ntw and cascade share CSS machinery:
  tw prints its output through\ncascade, and cascade also minifies it. If both mishandle
  the same\nconstruct, their agreement hides the mistake.\nFor example, here is one
  HTML file and two possible stylesheets. Are\nthey equivalent? Careful: your answer
  could have a big impact on\nyour next software project!\n\n\n<style>\n  .advice
  { position: relative; }\n  .advice > .ocaml { position: absolute; inset: 0; background:
  white; }\n</style>\n<link rel=\"stylesheet\" href=\"a.css\">\n<p class=\"advice\">\n
  \ <span>You should use Rust</span>\n  <span class=\"ocaml\">You should use OCaml</span>\n</p>\n\n\nOne
  HTML page. Change the stylesheet link to b.css to compare.\n\n\n\n/* a.css */\n.ocaml
  { all: unset; }\n.ocaml { visibility: hidden; }\n\n/* b.css: just swap the two rules.
  */\n.ocaml { visibility: hidden; }\n.ocaml { all: unset; }\n\n\nTwo candidate stylesheets.
  The reset and visibility rules trade places.\n\n\n\nThe two rules don't name any
  of the same properties, so a tool that\nlooks at each property separately could
  swap them. But\nall: unset also resets visibility, to its inherited value,\nvisible
  here. With a.css the span is hidden and the reader sees\nRust. With b.css it is
  visible and covers Rust. The positioning rule\nhas higher specificity, so the reset
  doesn't move the span; it only\nchanges whether you can see it.\n\n  \n    \n      a.css\n
  \     \n        You should use Rust\n      \n    \n    \n      b.css\n      \n        You
  should use OCaml\n      \n    \n  \n  \n    The same HTML and declarations, with
  the reset applied in a different order.\n  \n\ncascade reports the change to visibility:\n$
  cascade diff --diff=canonical a.css b.css\nCSS: 54 chars vs 54 chars (0.0% diff)\nChanges:
  1 modified rule\n\n--- a.css\n+++ b.css\n\u2514\u2500 .ocaml\n      - visibility:
  hidden\n\nCatching this kind of mistake mattered more than usual, because since\nlast
  year\na mix of LLMs, some in the cloud and some running locally, has\nwritten much
  of the code in both tools, while I reviewed the changes and\ndecided what to build
  next. That was partly an experiment in how to\ndrive these models towards software
  I would trust, and it only works\nif the tests decide what gets accepted. But a
  model can change a test\nand the code it checks at the same time, and I cannot use
  cascade to\ncheck that cascade is correct. I needed a check that shares no code\nwith
  either tool, and that neither I nor the models could change.\nAsking the browser\nI
  turned to headless Chrome. My first harness loaded a page under each\nstylesheet,
  read every element's computed style through\ngetComputedStyle, and compared the
  values.\nThis had two problems. First, computed values can be written in many\nequivalent
  ways, so the harness used cascade's own value comparator\nto decide which differences
  were real. The checker depended on the\ncode it was supposed to check. Second, computed
  styles are not what\nusers see. cascade minifies background:none to background:0
  0,\none byte shorter and painting exactly the same, yet getComputedStyle\nreports\nbackground-position
  as 0% 0% for one and 0px 0px for the other.\nSo the harness now compares pixels.
  It renders the page under each\nstylesheet, at every viewport width the stylesheets'
  media queries\nmention and in every interaction state they use (:hover, :focus,\nand
  so on), and compares the screenshots. It reads computed styles\nonly where pixels
  differ, to find which property is responsible. The\nsame check is available from
  the command line:\n$ cascade diff --browser --html page.html a.css b.css\nBrowser:
  153.0; viewports: 1024x768; states: none\nRenders that differ: 1\n  1024x768 none:
  149x13 pixels differ at (142,18)\n\nComputed values the elements under those pixels
  disagree on:\n\nbody>p.advice:nth-child(1)>span.ocaml:nth-child(2)\n  visibility:
  hidden -> visible\n\nA test only covers the documents and states it renders, so
  the example\nneeds both spans, just as a hover rule needs a hover test. Some properties
  paint nothing at all:\na cursor, or the timing of a transition. For those, the CSS
  comparison\nis still the only check, and that is why I keep both.\nTesting the diff
  itself\nWith an independent reference, I could then test cascade's\ncomparison directly,
  using mutation testing. The harness takes real\nstylesheets and breaks them mechanically:
  it drops a declaration,\ndrops a rule, swaps two neighbouring declarations or rules,
  or splits a rule in two.\nSome of these mutants change the page, like our reset
  and visibility\nswap. Others are harmless, like removing a declaration that a later\none
  overrides.\nEvery time cascade says a mutant is equivalent to the original,\nChrome
  renders both. If the pixels differ, cascade has missed a\nchange, and that is a
  bug. cascade's verdict is only used to choose\nwhich pairs to render, so it can
  make the test slower but never make\nit pass. Several fixes in cascade 1.2.0 are
  cases where Chrome\ndisagreed with its output. Many others come from a single pattern:\nparts
  of the minifier walked the stylesheet with their own match and a\ncatch-all case,
  so an unfamiliar statement was silently skipped. If\nyou used 1.1.0 to minify a
  page, regenerate it with 1.2.1 and diff the\ntwo.\nThe whole of tailwindcss.com\nThe
  largest test is the Tailwind website itself, which uses far more\nclass combinations
  than any fixture. Every class it uses is compiled\nby both tools and rendered on
  its own element, inside wrappers that\nmake the group-* and peer-* variants match.
  On a full run with\ntw 1.1.0 and cascade 1.2.1, cascade found no difference between\nthe
  two stylesheets, and Chrome agreed at every viewport width and in\nevery interaction
  state. tw's minified output was also slightly\nsmaller than Tailwind's.\nThat run
  still has limits. A variant that tests an ancestor's\nattribute, such as group-data-[checked]:,
  matches on neither side,\nso it is compared but not really exercised. And a few
  classes on\nthe site are documentation placeholders such as blur-[<value>], for\nwhich
  Tailwind emits CSS that no browser accepts and tw emits\nnothing. Both pages render
  the same, so I count that as parity.\nUsing it on your project\ntw reads the same
  CSS entrypoint as the tailwindcss CLI, with\n@theme, @source, custom utilities and
  variants, and the typography\nand forms plugins. It does not run JavaScript, so
  a project still using\ntailwind.config.js needs to move that configuration into
  its CSS\nentrypoint first.\nTo check tw against Tailwind on your own project, add
  --diff. It\ncompiles the project with both tools and explains the differences with\ncascade;
  with --html, it also compares the rendering of one of your\npages in headless Chrome.
  This needs Tailwind 4.3.3 installed locally,\nbut the normal build does not need
  Node.js at all.\n$ tw -i src/app.css --diff --html public/index.html\n\ncascade
  works on CSS from any other tool too, for instance to check\nthat a minifier did
  not change your page:\n$ brew install samoht/tap/cascade   # or: opam install cascade\n$
  cascade diff --diff=canonical input.css output.css\n$ cascade diff --browser --html
  page.html input.css output.css\n\nIn OCaml, I skip the scanning step altogether,
  as each component\ncarries its own styles:\nopen Tw_html\n\nlet card ~title ~body
  =\n  article ~tw:Tw.[ flex; flex_col; gap 4; p 6; rounded_lg ]\n    [ h2 ~tw:Tw.[
  text_xl; font_semibold ] [ txt title ];\n      p [ txt body ] ]\n\nReusing card
  brings its CSS along, without a source scanner or a\nsafelist. The April post shows
  the\nfull workflow.\nGetting your feedback\nThere are probably still bugs that none
  of these tests reach. If\ntw --diff reports a difference on your project, it is
  a bug in\neither the compiler or the comparison, and I would like to hear about\nit:
  a small reproducer on the tw issue\ntracker or by\nemail is perfect. Reviews of
  either\ncodebase are very welcome too. Try it, and tell me what breaks.\nTailwind
  Labs' implementation, documentation and tests have been\nessential to this work,
  and tw depends on the framework they\ncontinue to develop. If you use Tailwind,
  through either compiler,\nplease support the team by\nsponsoring them or buying\na
  Tailwind Plus licence."
url: https://gazagnaire.org/blog/2026-09-23-tailwind-parity.html
date: 2026-09-23T00:00:00-00:00
preview_image: https://gazagnaire.org/blog/og/2026-09-23-tailwind-parity.png
authors:
- Thomas Gazagnaire
source:
ignore:
---
