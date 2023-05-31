---
title: Fan, A langugage to implement languages (I)
description: "This will be a series of blogs introducing a new programming language
  Fan. Fan is OCamlPlus, it provides all features what OCaml provides and a language
  to manipulate programs. I am also seeking co\u2026"
url: https://hongboz.wordpress.com/2012/11/13/fan-a-langugage-to-implement-languages-i/
date: 2012-11-13T05:00:00-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- hongboz
---


<p>This will be a series of blogs introducing a new programming language <a href="https://github.com/bobzhang/Fan">Fan</a>. </p>
<p> Fan is OCamlPlus, it provides all features what <a href="http://caml.inria.fr/">OCaml</a> provides and a language to manipulate programs. I am also <b>seeking collaboration</b> if you are interested in such a fascinating project. </p>
<p> It aims to provide the <code>OCaml + A Compiler Domain Specific Language</code>. The compiler domain is a bit special, it&rsquo;s the compiler domain which can be used by users to create their own domain specific languages, e.g, database query, financial modelling. Our purpose is to make you write a practical compiler <code>in one day</code>, yes, this is not a joke, with the right tools and nice abstraction, it&rsquo;s very promising to help average programmers to create their own languages to fit their domains in a short term. </p>
<p> The compiler domain is a rather large domain, it consists of several sub-domains, so the compiler of Fan itself also benefits from the Domain specific language(DSL). Unlike other bootstrapping model, <b>all features</b> of the previous version of Fan compiler is <b>usable</b> for the next release. Yes, Fan is written using itself, it&rsquo;s really Fun <img src="https://s0.wp.com/wp-content/mu-plugins/wpcom-smileys/twemoji/2/72x72/1f642.png" alt="&#128578;" class="wp-smiley" style="height: 1em; max-height: 1em;"/> </p>
<p> Fan evolved from the <a href="http://brion.inria.fr/gallium/index.php/Camlp4">Camlp4</a>, but with a more ambitious goal and different underlying engines, I will compare them later. </p>
<p> Ok, let&rsquo;s talk business. </p>
<p> Why a new programming language? Because I don&rsquo;t find a programming language make me happy (yet). </p>
<p> Thinking about how you solve a problem. </p>
<p> It&rsquo;s mainly divided into two steps. </p>
<ul>
<li>The first step is to think of an algorithm to tackle the problem,   without ambiguity. This is what we call <b>inherent complexity</b>,   however fancy the programming language it is, you still have to think   of a way to solve it.  </li>
<li>The second step is to map your algorithm into your favourite   language, i.e, Haskell. Ideally, it should be straightforward, but   in reality, it will bring a lot of trouble, and we call it   <b>accidental complexity</b>. </li>
</ul>
<p>   What we can do to enhance a programmer&rsquo;s productivity lies in how to avoid the <b>accidental complexity</b>, the second step. </p>
<p> The problem lies that your favourite language was not designed for your specific domain, it&rsquo;s a <b>general</b> purpose programming language. When you transfer your ideas into your language, you have to do <code>a lot of dirty work</code>. With the help of modern IDE, people may be alleviated a bit, but programs are not just written to execute, its more functional goal is to help exchange ideas. When you want to understand how a piece of program work, you have to do the <code>reverse-engineering</code> to map your programs back into your ideas. Because when you do the translation from your ideas into your programs, you will lose the big picture, the initial brief ideas are mixed with a lot of noises. </p>
<p> This is a sad fact that how programmers do the work nowadays. <img src="https://s0.wp.com/wp-content/mu-plugins/wpcom-smileys/twemoji/2/72x72/1f626.png" alt="&#128550;" class="wp-smiley" style="height: 1em; max-height: 1em;"/> </p>
<p> &ldquo;When you have a hammer, everything is a nail&rdquo;. </p>
<p> One difference between human being and animals is the fact that man can use tools, the fact that man can not only use tools but also create tools makes human-beings so intelligent. It&rsquo;s a sad fact that most programmers still live in the cave-age, they can only accept what tools provided. Smart programmers should create a tool which is best fit for their domain. </p>
<p> So, what&rsquo;s the right way to solve a problem? </p>
<p> When you find some similar problems appear once and again, try to design your language which makes you can express your ideas <b>as isomorphic as possible</b> to the problem&rsquo;s descriptions, then write a compiler to compile the language. Then it&rsquo;s done. People who read your program will understand it straight-forward, you write your programs quickly, everything seems to be perfect, everyone is happy. </p>
<p> Wait, you may find that I am cheating, writing a toy-language is not hard, writing a medium language is painful, creating a general purpose language is too hard, and communicating your legacy library with your new language will drive you crazy. So you may say:&rdquo;let&rsquo;s forget about it&rdquo; and shy away. </p>
<p> Yes, that&rsquo;s true, and that&rsquo;s why I design a new programming language to address such an issue, remember that creating a language itself <b>is a domain</b>, this domain shares some similar abstractions which should be factored out. And to make life happier, you are extending a general purpose programming language to fit your domain instead of creating a brand new language, and they are compiled into <b>the same intermediate representation</b>, like C# and VB, you never have an inter-operation problem. </p>
<p> Once you finished the language for one domain, your productivity will be boosted exponentially in such a domain. </p>
<p> Fan is created to help you achieve such a goal! </p>
<p> There are different abstraction and DSL solutions, next post I will compare them and talk about the solution Fan chooses and its good and bad effects. </p>

