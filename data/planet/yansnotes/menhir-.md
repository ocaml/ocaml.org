---
title: 'Menhir '
description: A little bit about everything, but mostly about fixing annoying tech
  problems, interesting posts I stumbled on.
url: http://yansnotes.blogspot.com/2014/11/menhir.html
date: 2014-11-20T16:51:00-00:00
preview_image:
featured:
authors:
- Unknown
---

<div dir="ltr" style="text-align: left;" trbidi="on">
<div dir="ltr" style="text-align: left;" trbidi="on">
<br/>
<br/>
This blog post about&nbsp; -&nbsp; <a href="http://cristal.inria.fr/~fpottier/menhir/" target="_blank">Menhir</a>.<br/>
<br/>
<br/>
According to Wikipedia:<br/>
<br/>
<blockquote class="tr_bq">
A <b>menhir</b> (French, from <a href="http://en.wikipedia.org/wiki/Breton_language" title="Breton language">Middle Breton</a>: <i>men</i>, &quot;stone&quot; and <i>hir</i>, &quot;long&quot;<sup class="reference"><a href="http://en.wikipedia.org/wiki/Menhir#cite_note-1">[1]</a></sup>), <b>standing stone</b>, <b>orthostat</b>, or <b>lith</b> is a large upright standing stone. </blockquote>
Coincidently, <a href="http://cristal.inria.fr/~fpottier/menhir/" target="_blank">Menhir</a>, is also the name for  LR(1) parser generator for OCaml.<br/>
&nbsp; <br/>
I followed the<a href="https://realworldocaml.org/v1/en/html/parsing-with-ocamllex-and-menhir.html" target="_blank"> recommendation in the Real World OCaml </a>to use it, rather than <b>ocamlyacc</b>:<br/>
<blockquote class="tr_bq">
&quot;Menhir is an alternative parser generator that is generally superior
    to the venerable <b>ocamlyacc</b>, which dates
    back quite a few years. Menhir is mostly compatible with <b>ocamlyacc</b> grammars, and so you can usually just
    switch to Menhir and expect older code to work (with some minor
    differences described in the <a href="http://cristal.inria.fr/~fpottier/menhir/manual.pdf" target="_blank">Menhir manual</a>) </blockquote>
<br/>
I found a few sources online that help you understand Menhir but it took me some time to get my head around it.<br/>
<br/>
This blog (and this post in particular) is mainly for me to record my activities and a way to understand things better. Nevertheless, I hope that by going through and discussing the code I've written, will shorten the learning curve for some of you -&nbsp; or the very least entertain you :)<br/>
<br/>
<i>On y vas!</i> For my purposes, I started by parsing a simple n-tuple string, for the <a href="https://github.com/yansh/MoanaM" target="_blank">MoanaML</a> code.<br/>
<div style="text-align: center;">
<blockquote class="tr_bq">
(?x,hasColor,?y,context)</blockquote>
</div>
Following the instructions <a href="https://realworldocaml.org/v1/en/html/parsing-with-ocamllex-and-menhir.html" target="_blank">in the Real World OCaml</a> I knew that I had to create two files, a namely, <a href="https://github.com/yansh/MoanaML/blob/master/query_parser.mly" target="_blank">Parser.mly</a> and <a href="https://github.com/yansh/MoanaML/blob/master/tuple_lexer.mll" target="_blank">Lexer.mll</a><br/>
<br/>
The parser file is used to construct and parse the grammar. You can define tokens and describe their required sequences.<br/>
<br/>
For example, for the Moana tuple, I defined the following tokens:<br/>
<blockquote class="tr_bq">
%token <string> STRING<br/>%token <string> VAR<br/>%token LEFT_BRACE<br/>%token RIGHT_BRACE<br/>%token START<br/>%token END<br/>%token COMMA<br/>%token EOF </string></string></blockquote>
</div>
&nbsp;I the used them to define the required parsing sequence:<br/>
<blockquote class="tr_bq">
LEFT_BRACE; s = elem; COMMA; p = elem; COMMA; o = elem; COMMA; c&nbsp; = elem; RIGHT_BRACE&nbsp; </blockquote>
<blockquote class="tr_bq">
elem:<br/>
&nbsp;| v = VAR {Variable v}<br/>
&nbsp;| c = STRING {Constant c}&nbsp; </blockquote>
<br/>
The <b>elem</b> is there to differentiate constants and variables and consequently pass the parsed value into a <a href="https://github.com/yansh/MoanaML/blob/master/config.ml#L33" target="_blank">relevant type constructor</a>.<br/>
<br/>
You also define the parsing function and its return type<br/>
<blockquote class="tr_bq">
&nbsp;start &amp;lt config .tuple &amp;gt parse</blockquote>

Now once we have the parser, we can move to the<a href="https://github.com/yansh/MoanaML/blob/master/tuple_lexer.mll" target="_blank"> lexer file</a>.&nbsp; Here we define rules using regular expressions in order to match, capture and convert strings into the previously defined tokens.<br/>
<br/>
In my case: <br/>
<blockquote class="tr_bq">
<br/>
rule lex = parse<br/>
&nbsp; | [' ' '\t' '\n']&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; { lex lexbuf }<br/>
&nbsp; | newline&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; { next_line lexbuf; lex lexbuf }<br/>
&nbsp; | &quot;,&quot;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; { COMMA }<br/>
&nbsp; | &quot;(&quot;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; { LEFT_BRACE }<br/>
&nbsp; | &quot;{&quot;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {START}<br/>
&nbsp; | eof&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {EOF }</blockquote>
<br/>
To do the actual parsing, we use:<br/>
<blockquote class="tr_bq">
Parser.parse_tuple Lexer.lex (Lexing.from_string s) </blockquote>
<a href="https://realworldocaml.org/v1/en/html/parsing-with-ocamllex-and-menhir.html" target="_blank">the Real World OCaml:</a> helps us understand what's happening<br/>
<blockquote class="tr_bq">
<code>[Lexing.from_string]</code> function is used to
    construct a <code>lexbuf [from a string]</code>, which is passed
    with the lexing function [<code>Lexer.lex</code>] to
    the <code>[Parser.parse]</code> functions.</blockquote>
That's all, folks! <br/>
<br/>
<h3 style="text-align: left;">
Pitfalls.</h3>
I was expecting Menhir to provide me with nice exceptions to debug my code, as was promised in <a href="https://realworldocaml.org/v1/en/html/parsing-with-ocamllex-and-menhir.html" target="_blank">the Real World OCaml:</a><br/>
<blockquote class="tr_bq">
The biggest advantage of Menhir is that its error messages are
    generally more human-comprehensible, ...</blockquote>
but it didn't. At least, I couldn't find the way to invoke it.<br/>
In any case, the book does provide you with <a href="https://github.com/realworldocaml/examples/blob/master/code/parsing-test/test.ml#L5-L25" target="_blank">some code</a> to make the debugging a bit easier.<br/>
<br/>
Anyway, online regular expression editor is your friend - I used http://www.regexr.com. Use it to test your regular expression and adjust the lexer accordingly.<br/>
<br/>
One more thing, the order of your lexer rules matters!<br/>
<br/>
Finally, in addition to the <a href="https://realworldocaml.org/v1/en/html/parsing-with-ocamllex-and-menhir.html" target="_blank">the Real World OCaml</a> book chapter, I also found very useful <a href="https://github.com/derdon/menhir-example" target="_blank">this example</a> and this <a href="http://toss.sourceforge.net/ocaml.html" target="_blank">Mini Ocaml tutorial</a>.<br/>
<br/>
That's about it, very simple and elegant once you get your head around it.<br/>
<br/>
<b>Disclaimer: </b>A<i>s I mentioned in the beginning, I am a newbie, so please let me know if I got some of the stuff wrong or there is a more efficient way of doing things. I am more than happy to hear from you guys! </i><br/>
<br/></div>

