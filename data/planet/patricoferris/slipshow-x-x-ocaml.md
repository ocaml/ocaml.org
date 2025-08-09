---
title: Slipshow x x-ocaml
description:
url: https://patrick.sirref.org/slipshow-x-xocaml/
date: 2025-07-23T00:00:00-00:00
preview_image:
authors:
- https://patrick.sirref.org/Patrick%20Ferris/
source:
ignore:
---


        <p>A short, explanatory post about combining two very fun pieces of work in OCaml.</p>
        <p><a href="https://github.com/panglesd">Paul-Elliot</a> has been building <a href="https://github.com/panglesd/slipshow">Slipshow</a> for some time now where slides are <em>slips</em> and your presentations run vertically. More recently, <a href="https://patrick.sirref.org/artw/">Arthur</a> has built <a href="https://github.com/art-w/x-ocaml">x-ocaml</a>, a web component library for executable OCaml cells embedded into OCaml.</p>
        <p>Using <a href="https://github.com/patricoferris/xocmd">xocmd</a>, a small tool I built for translating markdown codeblocks to x-ocaml components, your Slipshow's can now be <em>executable</em>!</p>
        <pre>xocmd learn-effects.md | slipshow compile - &gt; learn-effects.html</pre>
        <p>
    Take a look at 
    <a href="https://patrick.sirref.org/bafkrmictvc3ap2ah37cbcdoo6rsl7vxqu6srogmgzx6iml45bq7zz5weo4.html">an example</a>!
    (or the 
    <a href="https://patrick.sirref.org/bafkrmib3jugpkznxcftqjvhbbtfqgx4oz2m32p5xloh4nxia3lhxy2momq.md">source markdown</a>).
</p>
        <p>I really like this light-weight approach to building interactive presentations for explaining things in OCaml (e.g. over running a jupyter notebook server).</p>
      
