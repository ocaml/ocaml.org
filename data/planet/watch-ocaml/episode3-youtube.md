---
title: Episode3-Youtube
description: Everything you need to know to install and use the DkML distribution
  of OCaml on Windows. Includes a 5-minute quick install for learners. Includes how
  to setup projects and configuring IDEs for sof...
url: https://watch.ocaml.org/w/awwFLmzJMvQfHzTkTARMdn
date: 2023-12-08T12:14:13-00:00
preview_image: https://watch.ocaml.org/lazy-static/previews/a8a8b99d-ed5a-4526-81a1-9cff0aad49b1.jpg
authors:
- Watch OCaml
source:
---

<p>Everything you need to know to install and use the DkML distribution of OCaml on Windows. Includes a 5-minute quick install for learners. Includes how to setup projects and configuring IDEs for software creators/engineers.</p>
<p>At the time of this video publication, the <a href="http://ocaml.org" target="_blank" rel="noopener noreferrer">ocaml.org</a> website had not been updated to include the instructions in this video. However, the video is self-contained.</p>
<p>Helpful callouts from the video:</p>
<p>1- Using PowerShell to create initial files for a new project:</p>
<p>New-Item dune-project -Value &quot;(lang dune 3.12)&quot;<br/>
New-Item dune -Value &quot;(executable (name main))&quot;<br/>
New-Item <a href="http://main.ml" target="_blank" rel="noopener noreferrer">main.ml</a> -Value &quot;let = print_endline {|Hello! Press ENTER to quit.|} ; input_char stdin&quot;</p>
<p>2- The .ocamlformat to enable formatting of your source code:</p>
<p>version=0.25.1<br/>
profile=conventional<br/>
exp-grouping=preserve<br/>
nested-match=align</p>

