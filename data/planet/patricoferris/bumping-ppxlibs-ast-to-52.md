---
title: Bumping Ppxlib's AST to 5.2
description:
url: https://patrick.sirref.org/ppxlib-5-2/
date: 2025-02-18T00:00:00-00:00
preview_image:
authors:
- https://patrick.sirref.org/Patrick%20Ferris/
source:
ignore:
---


        <p><a href="https://patrick.sirref.org/ppxlib/">Ppxlib</a> is a libary for building OCaml preprocessors. Users can generate OCaml code <em>from</em> OCaml code (derivers) or replace parts of OCaml code with other OCaml code (rewriters).</p>
        <p>At the core of <a href="https://patrick.sirref.org/ppxlib/">ppxlib</a> is the OCaml parsetree; a data structure in the compiler that represents OCaml source code. <a href="https://patrick.sirref.org/ppxlib/">Ppxlib</a> makes a distinction between the source parsetree (based on the version of the OCaml compiler you are using) and <a href="https://patrick.sirref.org/ppxlib/">ppxlib</a>'s parsetree (a copy of <em>some</em> parsetree from the compiler).</p>
        <p>In <a href="https://discuss.ocaml.org/t/ann-ppxlib-0-36-0">ppxlib.0.36.0</a>, the internal AST was bumped from the AST of OCaml 4.14.0, to the AST of OCaml 5.2.0. This post discusses some of the internal mechanisms that allows ppxlib to support multiple compilers and how this bump broke a lot of backwards compatibility.</p>
        <section>
          <header>
            <h2>Manual Migrations in Ppxlib</h2>
          </header>
          <p>It is possible to perform migrations between parsetrees manually using the <code>ppxlib.ast</code> package.</p>
          <pre class="hilite">            <code><span class="ocaml-keyword-other">open</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Ppxlib</span><span class="ocaml-source">
</span>
<span class="ocaml-keyword-other">open</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Ast_builder</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-constant-language-capital-identifier">Make</span><span class="ocaml-source">( </span><span class="ocaml-keyword-other">struct</span><span class="ocaml-source"> </span><span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">loc</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Location</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">none</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other">end</span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">pp_expr</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Format</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">printf</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-constant-character-printf">%a </span><span class="ocaml-constant-character-printf">%! </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Pp_ast</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">( </span><span class="ocaml-source">expression</span><span class="ocaml-source"> ?</span><span class="ocaml-source">config</span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-constant-language-capital-identifier">None</span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-source">
</span>
<span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">loc</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Location</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">none</span><span class="ocaml-source">
</span>
<span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">str</span><span class="ocaml-source"> </span><span class="ocaml-source">txt</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-source">{ </span><span class="ocaml-source"> </span><span class="ocaml-source">txt</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source"> </span><span class="ocaml-source">loc</span><span class="ocaml-source"> </span><span class="ocaml-source">} </span><span class="ocaml-source">
</span>
<span class="ocaml-source">
</span>
<span class="ocaml-keyword-other">module</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">To_408</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> 
</span>
<span class="ocaml-source">  </span><span class="ocaml-constant-language-capital-identifier">Ppxlib_ast</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-constant-language-capital-identifier">Convert</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-constant-language-capital-identifier">Ppxlib_ast</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-constant-language-capital-identifier">Js</span><span class="ocaml-source">) </span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-constant-language-capital-identifier">Ppxlib_ast__</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-constant-language-capital-identifier">Versions</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-constant-language-capital-identifier">OCaml_408</span><span class="ocaml-source">) </span><span class="ocaml-source">
</span></code>
          </pre>
          <p>The <code>Ppxlib_ast.Js</code> module is <a href="https://patrick.sirref.org/ppxlib/">ppxlib</a>'s AST (since <code>ppxlib.0.36.0</code> OCaml 5.2.0). We can use functions  provided by the <code>Convert</code> functor to copy parts of the AST from one version to another. Usually there is very little difference between the versioned parsetrees.</p>
          <pre class="hilite">            <code><span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">func</span><span class="ocaml-source"> </span><span class="ocaml-source">arg</span><span class="ocaml-source"> </span><span class="ocaml-source">body</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-source">pexp_fun</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Nolabel</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">None</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source">ppat_var</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source">str</span><span class="ocaml-source"> </span><span class="ocaml-source">arg</span><span class="ocaml-source">) </span><span class="ocaml-source">) </span><span class="ocaml-source"> </span><span class="ocaml-source">body</span><span class="ocaml-source">
</span>
<span class="ocaml-source">
</span>
<span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">add_expr</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-source">func</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">x</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source">func</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">y</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source">eapply</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source">evar</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">Int.add</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source">) </span><span class="ocaml-source"> </span><span class="ocaml-source">[ </span><span class="ocaml-source"> </span><span class="ocaml-source">evar</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">x</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source"> </span><span class="ocaml-source">evar</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">y</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source"> </span><span class="ocaml-source">] </span><span class="ocaml-source">) </span><span class="ocaml-source">) </span><span class="ocaml-source">
</span></code>
          </pre>
          <p>The above excerpt of OCaml code produces an expression in the language. More accurately, a function that has two arguments. If we print the simplified AST we can see that the arguments are stored together in a list.</p>
          <pre class="hilite">            <code><span class="ocaml-keyword-other">#</span><span class="ocaml-source"> </span><span class="ocaml-source">pp_expr</span><span class="ocaml-source"> </span><span class="ocaml-source">add_expr</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source"> 
</span>
<span class="ocaml-constant-language-capital-identifier">Pexp_function</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-source">( </span><span class="ocaml-source"> </span><span class="ocaml-source">[ </span><span class="ocaml-source"> </span><span class="ocaml-source">{ </span><span class="ocaml-source"> </span><span class="ocaml-source">pparam_loc</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-source">__loc</span><span class="ocaml-source">
</span>
<span class="ocaml-source">      </span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source"> </span><span class="ocaml-source">pparam_desc</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Pparam_val</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Nolabel</span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">None</span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Ppat_var</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">x</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-source">      </span><span class="ocaml-source">} </span><span class="ocaml-source">
</span>
<span class="ocaml-source">    </span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source"> </span><span class="ocaml-source">{ </span><span class="ocaml-source"> </span><span class="ocaml-source">pparam_loc</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-source">__loc</span><span class="ocaml-source">
</span>
<span class="ocaml-source">      </span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source"> </span><span class="ocaml-source">pparam_desc</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Pparam_val</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Nolabel</span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">None</span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Ppat_var</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">y</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-source">      </span><span class="ocaml-source">} </span><span class="ocaml-source">
</span>
<span class="ocaml-source">    </span><span class="ocaml-source">] </span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">None</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Pfunction_body</span><span class="ocaml-source">
</span>
<span class="ocaml-source">      </span><span class="ocaml-source">( </span><span class="ocaml-constant-language-capital-identifier">Pexp_apply</span><span class="ocaml-source">
</span>
<span class="ocaml-source">         </span><span class="ocaml-source">( </span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Pexp_ident</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-constant-language-capital-identifier">Ldot</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Lident</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">Int</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">add</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source">) </span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-source">         </span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-source">[ </span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Nolabel</span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Pexp_ident</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-constant-language-capital-identifier">Lident</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">x</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source">) </span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-source">           </span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Nolabel</span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Pexp_ident</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-constant-language-capital-identifier">Lident</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">y</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source">) </span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-source">           </span><span class="ocaml-source">] </span><span class="ocaml-source">
</span>
<span class="ocaml-source">         </span><span class="ocaml-source">) </span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-keyword-operator">-</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-source"> </span><span class="ocaml-support-type">unit</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-unit">() </span><span class="ocaml-source">
</span></code>
          </pre>
          <p>This is a relatively new feature of the parsetree, if we migrate the expression down to <code>4.08</code> we see it is represented differently. The output is a little too verbose to be readable, and there's no good way to show the AST, so you will just have to take my word.</p>
          <pre class="hilite">            <code><span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">expr_408</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">To_408</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">copy_expression</span><span class="ocaml-source"> </span><span class="ocaml-source">add_expr</span><span class="ocaml-source">
</span>
<span class="ocaml-source">
</span></code>
          </pre>
        </section>
        <section>
          <header>
            <h2>Function Arity in the OCaml Parsetree</h2>
          </header>
          <p>OCaml 5.2 introduced a new way to represent functions. Before 5.2, all functions were represented with single arity. Functions with multiple arguments would return functions as their body. For example:</p>
          <pre class="hilite">            <code><span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">add</span><span class="ocaml-source"> </span><span class="ocaml-source">x</span><span class="ocaml-source"> </span><span class="ocaml-source">y</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-source">x</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">+</span><span class="ocaml-source"> </span><span class="ocaml-source">y</span><span class="ocaml-source">
</span>
<span class="ocaml-source">
</span></code>
          </pre>
          <p>A two-argument <code>add</code> function would be represented in the parsetree as <code>fun x -&gt; fun y -&gt; x + y</code>. Using the nodes from the parsetree (with some details removed) it would be <code>Pexp_fun (x, Pexp_fun (y, Pexp_apply ...))</code>.</p>
          <p>Now, since OCaml 5.2, functions can be expressed with their syntactic arity intact. The function <code>add</code> would look something like <code>Pexp_function ([ x; y ], Pfunction_body (Pexp_apply ...))</code>. Both arguments are stored as a list.</p>
          <p>The constructor <code>Pexp_function</code> was not a new addition to the parsetree. It used to represent pattern-matching expressions like <code>function A -&gt; 1</code>. This can now be expressed as a function body of <code>Pfunction_cases</code>.</p>
          <p>Whilst these additions and modifications to the parsetree are arguably a better design, it has caused chaos in terms of <a href="https://patrick.sirref.org/ppxlib/">ppxlib</a>'s reverse dependencies!</p>
        </section>
        <section>
          <header>
            <h2>Coalescing Function Arguments</h2>
          </header>
          <p>In <a href="https://patrick.sirref.org/ppxlib/">ppxlib</a> <code>0.36.0</code>, functions from <code>Ast_builder</code> will help ppx authors produce maximum arity functions. However, functions from <code>Ast_helper</code> will not do this.</p>
          <pre class="hilite">            <code><span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">ast_helper_func</span><span class="ocaml-source"> </span><span class="ocaml-source">arg</span><span class="ocaml-source"> </span><span class="ocaml-source">body</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-constant-language-capital-identifier">Ast_helper</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-constant-language-capital-identifier">Exp</span><span class="ocaml-keyword-other-ocaml punctuation-other-period punctuation-separator">.</span><span class="ocaml-source">fun_</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Nolabel</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">None</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source">ppat_var</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source">str</span><span class="ocaml-source"> </span><span class="ocaml-source">arg</span><span class="ocaml-source">) </span><span class="ocaml-source">) </span><span class="ocaml-source"> </span><span class="ocaml-source">body</span><span class="ocaml-source">
</span>
<span class="ocaml-source">
</span>
<span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">ast_helper_expr</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-source">ast_helper_func</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">x</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source">ast_helper_func</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">y</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source">eapply</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source">evar</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">Int.equal</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source">) </span><span class="ocaml-source"> </span><span class="ocaml-source">[ </span><span class="ocaml-source"> </span><span class="ocaml-source">evar</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">x</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source"> </span><span class="ocaml-source">evar</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">y</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source"> </span><span class="ocaml-source">] </span><span class="ocaml-source">) </span><span class="ocaml-source">) </span><span class="ocaml-source">
</span></code>
          </pre>
          <p>Here we recreate our helper function to create function expressions using <code>Ast_helper.Exp.fun_</code> instead. We can now show the difference between the <code>expr</code> expression and the <code>ast_helper_expr</code> expression.</p>
          <pre class="hilite">            <code><span class="ocaml-keyword-other">#</span><span class="ocaml-source"> </span><span class="ocaml-source">pp_expr</span><span class="ocaml-source"> </span><span class="ocaml-source">add_expr</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source">
</span>
<span class="ocaml-constant-language-capital-identifier">Pexp_function</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-source">( </span><span class="ocaml-source"> </span><span class="ocaml-source">[ </span><span class="ocaml-source"> </span><span class="ocaml-source">{ </span><span class="ocaml-source"> </span><span class="ocaml-source">pparam_loc</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-source">__loc</span><span class="ocaml-source">
</span>
<span class="ocaml-source">      </span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source"> </span><span class="ocaml-source">pparam_desc</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Pparam_val</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Nolabel</span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">None</span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Ppat_var</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">x</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-source">      </span><span class="ocaml-source">} </span><span class="ocaml-source">
</span>
<span class="ocaml-source">    </span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source"> </span><span class="ocaml-source">{ </span><span class="ocaml-source"> </span><span class="ocaml-source">pparam_loc</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-source">__loc</span><span class="ocaml-source">
</span>
<span class="ocaml-source">      </span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source"> </span><span class="ocaml-source">pparam_desc</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Pparam_val</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Nolabel</span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">None</span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Ppat_var</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">y</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-source">      </span><span class="ocaml-source">} </span><span class="ocaml-source">
</span>
<span class="ocaml-source">    </span><span class="ocaml-source">] </span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">None</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Pfunction_body</span><span class="ocaml-source">
</span>
<span class="ocaml-source">      </span><span class="ocaml-source">( </span><span class="ocaml-constant-language-capital-identifier">Pexp_apply</span><span class="ocaml-source">
</span>
<span class="ocaml-source">         </span><span class="ocaml-source">( </span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Pexp_ident</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-constant-language-capital-identifier">Ldot</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Lident</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">Int</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">add</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source">) </span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-source">         </span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-source">[ </span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Nolabel</span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Pexp_ident</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-constant-language-capital-identifier">Lident</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">x</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source">) </span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-source">           </span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Nolabel</span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Pexp_ident</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-constant-language-capital-identifier">Lident</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">y</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source">) </span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-source">           </span><span class="ocaml-source">] </span><span class="ocaml-source">
</span>
<span class="ocaml-source">         </span><span class="ocaml-source">) </span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-keyword-operator">-</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-source"> </span><span class="ocaml-support-type">unit</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-unit">() </span><span class="ocaml-source">
</span></code>
          </pre>
          <p>Above, we see a function expression with arity <em>two</em>. Below, we see nested function expressions each with arity <em>one</em>.</p>
          <pre class="hilite">            <code><span class="ocaml-keyword-other">#</span><span class="ocaml-source"> </span><span class="ocaml-source">pp_expr</span><span class="ocaml-source"> </span><span class="ocaml-source">ast_helper_expr</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source">
</span>
<span class="ocaml-constant-language-capital-identifier">Pexp_function</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-source">( </span><span class="ocaml-source"> </span><span class="ocaml-source">[ </span><span class="ocaml-source"> </span><span class="ocaml-source">{ </span><span class="ocaml-source"> </span><span class="ocaml-source">pparam_loc</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-source">__loc</span><span class="ocaml-source">
</span>
<span class="ocaml-source">      </span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source"> </span><span class="ocaml-source">pparam_desc</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Pparam_val</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Nolabel</span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">None</span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Ppat_var</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">x</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-source">      </span><span class="ocaml-source">} </span><span class="ocaml-source">
</span>
<span class="ocaml-source">    </span><span class="ocaml-source">] </span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">None</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Pfunction_body</span><span class="ocaml-source">
</span>
<span class="ocaml-source">      </span><span class="ocaml-source">( </span><span class="ocaml-constant-language-capital-identifier">Pexp_function</span><span class="ocaml-source">
</span>
<span class="ocaml-source">         </span><span class="ocaml-source">( </span><span class="ocaml-source"> </span><span class="ocaml-source">[ </span><span class="ocaml-source"> </span><span class="ocaml-source">{ </span><span class="ocaml-source"> </span><span class="ocaml-source">pparam_loc</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-source">__loc</span><span class="ocaml-source">
</span>
<span class="ocaml-source">             </span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source"> </span><span class="ocaml-source">pparam_desc</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Pparam_val</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Nolabel</span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">None</span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Ppat_var</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">y</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-source">             </span><span class="ocaml-source">} </span><span class="ocaml-source">
</span>
<span class="ocaml-source">           </span><span class="ocaml-source">] </span><span class="ocaml-source">
</span>
<span class="ocaml-source">         </span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">None</span><span class="ocaml-source">
</span>
<span class="ocaml-source">         </span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Pfunction_body</span><span class="ocaml-source">
</span>
<span class="ocaml-source">             </span><span class="ocaml-source">( </span><span class="ocaml-constant-language-capital-identifier">Pexp_apply</span><span class="ocaml-source">
</span>
<span class="ocaml-source">                </span><span class="ocaml-source">( </span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Pexp_ident</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-constant-language-capital-identifier">Ldot</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Lident</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">Int</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">equal</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source">) </span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-source">                </span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-source">[ </span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Nolabel</span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Pexp_ident</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-constant-language-capital-identifier">Lident</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">x</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source">) </span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-source">                  </span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Nolabel</span><span class="ocaml-keyword-other-ocaml punctuation-comma punctuation-separator">,</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Pexp_ident</span><span class="ocaml-source"> </span><span class="ocaml-source">( </span><span class="ocaml-constant-language-capital-identifier">Lident</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">y</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source">) </span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-source">                  </span><span class="ocaml-source">] </span><span class="ocaml-source">
</span>
<span class="ocaml-source">                </span><span class="ocaml-source">) </span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-source">         </span><span class="ocaml-source">) </span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-source">) </span><span class="ocaml-source">
</span>
<span class="ocaml-keyword-operator">-</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-source"> </span><span class="ocaml-support-type">unit</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-unit">() </span><span class="ocaml-source">
</span></code>
          </pre>
        </section>
        <section>
          <header>
            <h2>Ramifications for Ppxlib Users</h2>
          </header>
          <p>Many, many, <em>many</em> ppxes broke after migrating the <a href="https://patrick.sirref.org/ppxlib/">ppxlib</a> AST to 5.2. Mostly, this is due to pattern-matching. Downstream users of <a href="https://patrick.sirref.org/ppxlib/">ppxlib</a> frequently pattern-match directly against the parsetree. However, nodes such as <code>Pexp_fun</code> no longer exist and <code>Pexp_function</code> has completely different constructor arguments!</p>
          <p>Patching all the ppxes has been quite difficult. Most ppxes only deal with single arguments at a time (e.g. <code>Pexp_fun x</code>) but now they must handle zero or more arguments at a time. (In the zero case, this will always correspond to a pattern-matching <code>function</code>).</p>
          <p>Here is a non-exhaustive list of some of the ppxes that have been patched. It may useful for other ppx authors who wish to upgrade to <code>ppxlib.0.36.0</code>:</p>
          <ul>
            <li>
              <p>
                <a href="https://github.com/patricoferris/ppx_deriving_yaml/pull/58">https://github.com/patricoferris/ppx_deriving_yaml/pull/58</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://github.com/mirage/ocaml-rpc/pull/181">https://github.com/mirage/ocaml-rpc/pull/181</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://gitlab.com/o-labs/ppx_deriving_jsoo/-/merge_requests/1">https://gitlab.com/o-labs/ppx_deriving_jsoo/-/merge_requests/1</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://github.com/ocaml-community/sedlex/pull/160">https://github.com/ocaml-community/sedlex/pull/160</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://github.com/ocaml-sys/config.ml/pull/22">https://github.com/ocaml-sys/config.ml/pull/22</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://github.com/vogler/ppx_distr_guards/pull/2">https://github.com/vogler/ppx_distr_guards/pull/2</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://github.com/ocaml-gospel/gospel/pull/424">https://github.com/ocaml-gospel/gospel/pull/424</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://github.com/teamwalnut/graphql-ppx/pull/299">https://github.com/teamwalnut/graphql-ppx/pull/299</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://github.com/ocsigen/lwt/pull/1033">https://github.com/ocsigen/lwt/pull/1033</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://gitlab.com/gopiandcode/ppx-inline-alcotest/-/merge_requests/3">https://gitlab.com/gopiandcode/ppx-inline-alcotest/-/merge_requests/3</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://github.com/dariusf/ppx_interact/pull/3">https://github.com/dariusf/ppx_interact/pull/3</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://github.com/ocaml-ppx/ppx_deriving_yojson/pull/160">https://github.com/ocaml-ppx/ppx_deriving_yojson/pull/160</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://github.com/lpcic/elpi/pull/276">https://github.com/LPCIC/elpi/pull/276</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://github.com/mirage/repr/pull/110">https://github.com/mirage/repr/pull/110</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://github.com/programingisthefuture/ppx_default/pull/3">https://github.com/ProgramingIsTheFuture/ppx_default/pull/3</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://github.com/codinuum/vlt/pull/3">https://github.com/codinuum/vlt/pull/3</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://github.com/sim642/ppx_deriving_hash/pull/6">https://github.com/sim642/ppx_deriving_hash/pull/6</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://github.com/ocsigen/tyxml/pull/340">https://github.com/ocsigen/tyxml/pull/340</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://github.com/sim642/ppx_viewpattern/pull/2">https://github.com/sim642/ppx_viewpattern/pull/2</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://github.com/little-arhat/ppx_jsobject_conv/pull/11">https://github.com/little-arhat/ppx_jsobject_conv/pull/11</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://github.com/robur-coop/lun/pull/1">https://github.com/robur-coop/lun/pull/1</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://gitlab.com/o-labs/ppx_deriving_encoding/-/merge_requests/4">https://gitlab.com/o-labs/ppx_deriving_encoding/-/merge_requests/4</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://github.com/francoisthire/bam/pull/12">https://github.com/francoisthire/bam/pull/12</a>
              </p>
            </li>
            <li>
              <p>
                <a href="https://github.com/xguerin/bitstring/pull/36">https://github.com/xguerin/bitstring/pull/36</a>
              </p>
            </li>
          </ul>
          <p>This release has emphasised the tension between using pattern-matching on algebraic datatypes and wanting to reduce downstream breakages (e.g. using abstract datatypes). This <a href="https://www.cambridge.org/core/journals/journal-of-functional-programming/article/pattern-matching-with-abstract-data-types1/04DD26A0E6CA3A1E87E0E6AE8BC02EED">tension is not new</a>.</p>
        </section>
        <section>
          <header>
            <h2>The Future of Ppxlib</h2>
          </header>
          <p><a href="https://patrick.sirref.org/ppxlib/">Ppxlib</a> is not going anywhere anytime soon. We have committed to trying to keep the internal AST up to date with the latest OCaml release. In fact, there is already a PR for <a href="https://github.com/ocaml-ppx/ppxlib/pull/558">the 5.3 bump</a>!</p>
          <p>There have been many discussions about simplifying this process, but so far the time and effort to build a <a href="https://patrick.sirref.org/ppxlib/">ppxlib</a> that will result in fewer breakages is too high (see <a href="https://github.com/ocaml-ppx/ppx">an attempt using views</a>).</p>
          <p>Thank you to Tarides and Jane Street for funding my time to work on this release and all the chaos it has caused.</p>
          <p>Happy preprocessing!</p>
        </section>
      
