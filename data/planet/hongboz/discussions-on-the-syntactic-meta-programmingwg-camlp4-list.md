---
title: Discussions on the Syntactic Meta Programming(wg-camlp4 list)
description: "There are some interesting discussions in the wg-camlp4 mailing list,
  I wrote a long mail yesterday, I cleaned it a bit, pasted it here\_\u2014\u2014\u2014\_I
  rewrite the whole camlP4(named Fan) f\u2026"
url: https://hongboz.wordpress.com/2013/01/31/discussions-on-the-syntactic-meta-programmingwg-camlp4-list/
date: 2013-01-31T04:47:09-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- hongboz
---

<p>There are some interesting discussions in the wg-camlp4 mailing list, I wrote a long mail yesterday, I cleaned it a bit, pasted it here&nbsp;</p>
<p>&mdash;&mdash;&mdash;</p>
<div>&nbsp;I rewrite the whole camlP4(named Fan) from scratch, building the quotation kit and throw away the crappy grammar parser, so plz believe me&nbsp;<b>that I do understand the whole technology stack of camlP4</b>, if we could reach some consensus, I would be happy to handle over the maintaining of &nbsp;Fan, Fan does not loose any feature compared with camlP4, in fact it has more interesting featrues.</div>
<div>&nbsp;</div>
<div>&nbsp; &nbsp;Let&rsquo;s begin with some easy, not too technical parts which has a significant effect on user experience though:</div>
<div>&nbsp; &nbsp;1. Performance</div>
<div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Performance does matter, it&rsquo;s a shame that &nbsp;the most time spent in compiling the ocaml compiler is dedicated to camlP4, but it is an engineering problem, currently compiling Fan only takes less than 20s, and it can be improved further</div>
<div>&nbsp; &nbsp;2. Building issues</div>
<div>&nbsp; &nbsp; &nbsp; &nbsp; The design of having side effects by dynamic loading is generically a bad idea, in Fan<b>&nbsp;the dynamic loading only register some functionality the Fan support,</b>&nbsp;it&nbsp;<b>does not have any other side effec</b>t, each file stands alone says which (ppx , or filters, or syntax) it want to use with a good default option. so the building is always something like &lsquo;-pp fan pluging1 plugin2 plugin3&rsquo;,&nbsp;<b>the order of pulgings does not matter</b>, also, l<b>oading all the plugins you have does not have any side effect, even better, you can do the static linking all the plugins you collected, the building process is simplified. &nbsp;</b></div>
<div><b>&nbsp;</b>&nbsp;3. Grammar Extension (<b>Language namespace</b>)</div>
<div><b>&nbsp; &nbsp; &nbsp; &nbsp;</b>I concur that grammar extension arbitrarily is a bad idea, and I agree with Gabrier that so far only the quotation(Here &nbsp;quotation means delimited DSL, quosi-quotation means Lisp style macros) is modular, composable, and &nbsp;I also agree with Gabrier -ppx<b>&nbsp;should not be used to do syntax overriding (this should not be called syntax extension actually),&nbsp;</b>that&rsquo;s a terrible idea to do syntax overriding, since the user never understand what&rsquo;s going on underly without reading the Makefile. So here some my suggestion is that some really conevenient syntax extesion, i.e, (let try.. in) should be merged to the built in parser. quotations does not bring too much heavy syntax (imho). In Fan, we proposed the concept of a hierarchical language name space, since once quotation is heavily used, it&rsquo;s really easy to introduce conflict,&nbsp;<b>the language namespace querying is exactly like java package namespace,</b>&nbsp;you can import, close import to save some typing.</div>
<div>&nbsp; &nbsp; Here is a taste</div>
<div>&nbsp; &nbsp;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&ndash;</div>
<div>&nbsp; &nbsp; &nbsp;{:.Fan.Lang.Meta.expr| a + b |} &mdash;&mdash;&gt;&nbsp;</div>
<div>&nbsp; &nbsp; &nbsp;&nbsp;`App (`App ((`Id (`Lid &ldquo;+&rdquo;)), (`Id (`Lid &ldquo;a&rdquo;)))), (`Id (`Lid &ldquo;b&rdquo;)))</div>
<div>&nbsp; &nbsp; &nbsp;{:.Fan.Lang.Meta.N.expr| a + b |} &nbsp;&mdash;&ndash;&gt;</div>
<div>&nbsp; &nbsp; &nbsp;&nbsp;`App</div>
<div>&nbsp; &nbsp; (_loc,</div>
<div>&nbsp; &nbsp; &nbsp; (`App</div>
<div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(_loc, (`Id (_loc, (`Lid (_loc, &ldquo;+&rdquo;)))),</div>
<div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(`Id (_loc, (`Lid (_loc, &ldquo;a&rdquo;)))))),</div>
<div>&nbsp; &nbsp; &nbsp; (`Id (_loc, (`Lid (_loc, &ldquo;b&rdquo;)))))&nbsp;</div>
<div>
<div>&nbsp;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&ndash;</div>
<div>&nbsp;the .Fan.Lang.Meta.expr the first &lsquo;.&rsquo; means it&rsquo;s from the absolute namespace, &nbsp;the&nbsp;<b>N.expr shares exactly the same syntax without location</b>, though</div>
</div>
<div>&nbsp;</div>
<div>&nbsp; &nbsp;4. Portable to diffierrent compiler extensions(like LexiFi&rsquo;s fork of ocaml)</div>
<div>&nbsp; &nbsp; &nbsp; &nbsp;I am pretty sure it&rsquo;s pretty easy to do in Fan, only Ast2pt (dumping the intemediate Ast into Parsetree) part need to be changed to diffierent compilers.
<div>&nbsp;</div>
<div>&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;-</div>
<div>Now let&rsquo;s talk about some internal parts of SMP.</div>
<div>Quasi-Quotation is the essential part of SMP, &nbsp;I am surprised so far that the discussion&nbsp;<b>silently ignores the quasi-quotation,</b>&nbsp;Leo&rsquo;s answer of writing &nbsp; three parsers is neither satisfying nor practical(imho).&nbsp;</div>
<div>&nbsp;</div>
<div>Camlp4 is mainly composed of two parts, one is the extensible parser and&nbsp;<b>the other significant part is Ast Lifting</b>. Since we all agree that extensible parser increases the complexity too much, let&rsquo;s simply ignore that part.</div>
<div>&nbsp;</div>
<div>The Ast Lifting are tightly coupled&nbsp;<b>with the design of the Abstract Syntax Tree.</b>&nbsp; People complain about that Camlp4 Ast is hard to learn and using quasi-quotation to do the pattern match is a bad idea.</div>
<div>&nbsp;</div>
<div>Let me explain the topic a bit:</div>
<div>&nbsp; &nbsp; Camlp4Ast is hard to learn, I agree, it has some alien names that nobody understand what it &nbsp;means, quosi-quotation&nbsp;<b>is definitely a great idea</b>&nbsp;to boom the meta-programming, but my experience here is&nbsp;<b>for very very small Ast fragment, using the Abstract Syntax Tree directly,</b>&nbsp;otherwise Quasi-quotation is a life saver to do the meta programming.</div>
<div>&nbsp; &nbsp;Luckily the quotation kit has nothing to do with the parser part, it&rsquo;s simply several functions(I did some simplify a bit) which turns a normal runtime &nbsp;</div>
<div>value into an Ast node generically,&nbsp;<b>such kind functions are neither easy to write nor easy to read</b>,<b>the idea case is that it should be generated once for all, and all the data types in normal ocaml</b><b>should be derived automatically</b>(some ADT with functions can not be derived).&nbsp;<b>I bet it&rsquo;s mostly likely a nightmare if we maintain 3 parsers for the ocaml grammar while two other parsers dumping to a meta-level</b></div>
<div>&nbsp;&nbsp;</div>
<div>&nbsp; &nbsp;So, how to make Ast Lifting easier,&nbsp;</div>
<div>&nbsp; &nbsp; &nbsp; &nbsp; The first guideline is&nbsp;<b>&ldquo;Don&rsquo;t mixing with records&rdquo;,&nbsp;</b></div>
<div><b>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</b>Once you encoding AST with records, you have to encode the records in the meta level which increases the complexity without bringing any new features,&nbsp;<b>it&rsquo;s simply not worthwhile.</b></div>
<div><b>&nbsp;</b></div>
<div><b>&nbsp; &nbsp; &nbsp; &nbsp;</b>&nbsp;The second guideline is &ldquo;Don&rsquo;t do&nbsp;<b>any&nbsp;</b>syntax desugaring&rdquo; , syntax desguaring makes the semantics of syntax meta programming a bit weird. Syntax desguaring happens everywhere in Parsetree, think about the list literals, it uses the syntax desuaring, if you don&rsquo;t use any syntax desugaring, for example, you want to match the bigarray access, you simply needed to match `Bigarray(..)&rsquo; instead of&nbsp;</div>
<div>
<div>&nbsp;</div>
<div>Pexp_apply</div>
<div>&nbsp; &nbsp; &nbsp; &nbsp; ({pexp_desc=Pexp_ident</div>
<div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{txt= Ldot (Ldot (Lident &ldquo;Bigarray&rdquo;, array), (&ldquo;get&rdquo;|&rdquo;set&rdquo; as gs)) ;_};_},</div>
<div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;label_exprs)</div>
</div>
<div>&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;-</div>
<div>&nbsp; &nbsp; &nbsp; &nbsp;The third guideline is to<b>&nbsp;</b>make it&nbsp;<b>as uniform as possible</b></div>
<div><b>&nbsp; &nbsp; &nbsp; &nbsp;</b>This not only helps the user, but&nbsp;<b>it helps the meta-programming over types to derive some utility types.&nbsp;</b>Take a look at my Ast encoding in Fan&nbsp;<a href="https://github.com/bobzhang/Fan/blob/master/src/Ast.ml" target="_blank">https://github.com/bobzhang/Fan/blob/master/src/Ast.ml</a>&nbsp;(it needs to be polished, plz don&rsquo;t panic when you see variants I use here)</div>
<div><b>&nbsp; &nbsp; &nbsp;&nbsp;</b>The initial Ast has locations and ant support, but<b>&nbsp;here we derive 3 other Asts thanks to my very regular design</b>.<b>&nbsp;AstN is the Ast without locations</b>, the locations are important, but it is simply not too much helpful when you only do the code generation, but it complicates the expanded code a lot),&nbsp;<b>AstA is the Ast without antiquotations(simply remove the ant branch),&nbsp;</b>it is a subtype of Ast(thanks to the choice we use variants here),&nbsp;<b>AstNA is the Ast without neither locations nor antiquotations</b>), it is a subtype of AstN. &nbsp;<b>In practice, I found the Ast without locations is particular helpful when you only do the code generation, it simplifies this part significantly.<i><span style="text-decoration:underline;">&nbsp;The beautif</span></i></b><span style="text-decoration:underline;"><b><i>u</i></b><i>l part is that &nbsp;all the four Ast share the same grammar with the same quosiquotatoin mechanism, as I showed .Fan.Lang.N.expr and .Fan.Lang.expr</i></span></div>
<div>&nbsp; &nbsp; I don&rsquo;t know how many parsers you have to maintain to reach such a goal or it&rsquo;s never going to happen.</div>
<div>&nbsp; &nbsp; Using variants to encode the intermediate ast has a lots of other benefits, but I don&rsquo;t want to cover it in such a short mail.</div>
<div>&nbsp;</div>
<div>&nbsp; &nbsp;So,<b>&nbsp;my proposal is that the community design an Intermediate Ast together, and write a built-in parser to such Intermediate Ast then dump to Parsetree, but I am for that Parsetree still needs to be cleaned a bit but not too much change . &nbsp;</b>I do appreciate you can take something away from Fan, I think the Parsetree is<b>&nbsp;not the ideal part</b>&nbsp;to do SMP, HTH</div>
</div>
<p>&nbsp;</p>

