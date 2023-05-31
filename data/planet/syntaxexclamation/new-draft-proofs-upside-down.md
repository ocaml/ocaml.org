---
title: 'New draft: Proofs, upside down'
description: "There is a new draft on my web page, that should be of interest to those
  who enjoyed my posts about reversing data structures and the relation between natural
  deduction and sequent calculus. It is \u2026"
url: https://syntaxexclamation.wordpress.com/2013/06/17/new-draft-proofs-upside-down/
date: 2013-06-17T13:17:44-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- syntaxexclamation
---

<p>There is a new draft on my <a href="http://www.pps.univ-paris-diderot.fr/~puech/">web page</a>, that should be of interest to those who enjoyed my posts about <a href="https://syntaxexclamation.wordpress.com/2011/08/31/reversing-data-structures/" title="Reversing data&nbsp;structures">reversing data structures</a> and the <a href="https://syntaxexclamation.wordpress.com/2011/09/01/reverse-natural-deduction-and-get-sequent-calculus/" title="Reverse natural deduction and get sequent&nbsp;calculus">relation between natural deduction and sequent calculus</a>. It is an article submitted to <a href="http://aplas2013.soic.indiana.edu/">APLAS 2013</a>, and it is called&nbsp;<em><a href="http://www.pps.univ-paris-diderot.fr/~puech/upside.pdf" title="Proofs, upside down">Proofs, upside down.</a></em> In a nutshell, I am arguing for the use of functional PL tools, in particular classic functional program transformations, to understand and explain proof theory phenomena. Here, I show that there is the same relationship between natural deduction and (a restriction of) the sequent calculus than between this recursive function:</p>
<pre class="brush: fsharp; title: ; notranslate">
let rec tower_rec = function
  | [] -&gt; 1
  | x :: xs -&gt; x &lowast;&lowast; tower_rec xs

let tower xs = tower_rec xs
</pre>
<p>written in &ldquo;direct style&rdquo;, and that equivalent, iterative version:</p>
<pre class="brush: fsharp; title: ; notranslate">
let rec tower_acc acc = function
  | [] -&gt; acc
  | x :: xs -&gt; tower_acc (x &lowast;&lowast; acc) xs

let tower xs = tower_acc 1 (List.rev xs)
</pre>
<p>written in &ldquo;accumulator-passing style&rdquo;. And that relationship is the composition of CPS-transformation, defunctionalization and reforestation, the well-known transformations we all came to know and love!</p>
<p>I hope you enjoy it. Of course, any comment will be <i>much</i> appreciated, so don&rsquo;t hesitate to drop a line below!</p>
<blockquote><p>
<strong>Proofs, upside down</strong><br/>
<strong>A functional correspondence between&nbsp;natural deduction and the sequent calculus</strong><br/>
It is well-known in proof theory that sequent calculus proofs&nbsp;differ from natural deduction proofs by &ldquo;reversing&rdquo; elimination rules&nbsp;upside down into left introduction rules. It is also well-known that to&nbsp;each recursive, functional program corresponds an equivalent iterative,&nbsp;accumulator-passing program, where the accumulator stores the continuation of the iteration, in &ldquo;reversed&rdquo; order. Here, we compose these remarks and show that a restriction of the intuitionistic sequent calculus,&nbsp;LJT, is exactly an accumulator-passing version of intuitionistic natural&nbsp;deduction NJ. More precisely, we obtain this correspondence by applying&nbsp;a series of off-the-shelf program transformations &agrave; la Danvy et al. on&nbsp;a type checker for the bidirectional &lambda;-calculus, and get a type checker&nbsp;for the &lambda;-calculus, the proof term assignment of LJT. This functional&nbsp;correspondence revisits the relationship between natural deduction and&nbsp;the sequent calculus by systematically deriving the rules of the latter&nbsp;from the former, and allows to derive new sequent calculus rules from&nbsp;the introduction and elimination rules of new logical connectives.
</p></blockquote>

