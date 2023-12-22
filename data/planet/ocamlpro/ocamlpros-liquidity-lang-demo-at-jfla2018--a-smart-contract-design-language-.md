---
title: "OCamlPro\u2019s Liquidity-lang demo at JFLA2018 \u2013 a smart-contract design
  language "
description: "As a tradition, we took part in this year's  Journ\xE9es Francophones
  des Langages Applicatifs (JFLA 2018) that was chaired by LRI's Sylvie Boldo and
  hosted in Banyuls the last week of January. That was a nice opportunity to present
  a live demo of a multisignature smart-contract entirely written in th..."
url: https://ocamlpro.com/blog/2018_02_08_liquidity_smart_contract_deploy_live_demo_on_tezos_alphanet_jfla2018
date: 2018-02-08T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    \xC7agdas Bozman\n  "
source:
---

<p>As a tradition, we took part in this year's <a href="https://jfla.inria.fr/index.html"> Journ&eacute;es Francophones des Langages Applicatifs</a> (JFLA 2018) that was chaired by LRI's Sylvie Boldo and hosted in Banyuls the last week of January. That was a nice opportunity to present a <a href="https://twitter.com/OCamlPro/status/956574674477047808">live demo</a> of a multisignature smart-contract entirely written in the Liquidity language designed at OCamlPro, and deployed live on the Tezos alphanet <em>(the slides are now available, see at the end of the post)</em>.</p>
<p>Tezos is the only blockchain to use a <em>strongly</em> typed, <em>functional</em> language, with a formal semantic and an interpreter validated by the use of GADTs (generalized abstract data-types). This stack-based language, named <em>Michelson</em>, is somewhat tricky to use as-is, the absence of variables (among others) necessitating to manipulate the stack directly. For this reason, we have developed, starting in June 2017, a higher level language, <em>Liquidity</em>, implementing the type system of Michelson in a subset of OCaml.</p>
<p>In addition to the compiler which allows to compile Liquidity programs to Michelson ones, we have developed a decompiler which, from Michelson code, can recover a Liquidity version, much easier to look at and understand (for humans). This tool is of some significance considering that contracts will be stored on the blockchain in Michelson format, making them more approachable and understandable for end users.</p>
<p>To facilitate designing contracts and foster Liquidity adoption we have also developed a web application. This app offers somewhat bare-bone editors for Liquidity and Michelson, allows compilation in the browser directly, deployment of Liquidity contracts and interaction with them (using the Tezos alphanet).</p>
<p>This blog post presents these different tools in more detail.</p>
<h2>Michelson</h2>
<p>Michelson is a stack-based, functional, statically and strongly typed language. It comes with a set of built-in base types like strings, Booleans, unbounded integers and naturals, lists, pairs, option types, union (of two) types, sets, maps. There also a number of domain dependent types like amounts (in tezzies), cryptographic keys and signatures, dates, <em>etc</em>. A Michelson program consists in a <em>structured</em> sequence of instructions, each of which operates on the stack. The program takes as inputs a parameter as well as a storage and returns a result and a new value for the storage. They can fail at runtime with the instruction <code>FAIL</code>, or another error (call of a failing contract, out of gas, <em>etc.</em>), but most instructions that could fail return an option instead ( <em>e.g</em> <code>EDIV</code> returns <code>None</code> when dividing by zero). The following example is a smart contract which implements a voting system on the blockchain. The storage consists in a map from possible votes (as strings) to integers counting number of votes. A transaction to this contract must be made with an amount (accessible with instruction <code>AMOUNT</code>) greater or equal to 5 tezzies and a parameter which is a valid vote. If one of these conditions is not respected, the execution, and thus the transaction, fail. Otherwise the program retrieves the previous number of votes in the storage and increments them. At the end of the execution, the stack contains the pair composed of the value <code>Unit</code> and the updated map (the new storage).</p>
<pre><code class="language-makefile">parameter string;
storage (map string int);
return unit;
code
  { # Pile = [ Pair parameter storage ]
    PUSH tez &quot;5.00&quot;; AMOUNT; COMPARE; LT;
    IF # Is AMOUNT &lt; 5 tz ?
      { FAIL }
      {
        DUP; DUP; CAR; DIP { CDR }; GET; # GET parameter storage
        IF_NONE # Is it a valid vote ?
          { FAIL }
          { # Some x, x now in the stack
            PUSH int 1; ADD; SOME; # Some (x + 1)
            DIP { DUP; CAR; DIP { CDR } }; SWAP; UPDATE;
            # UPDATE parameter (Some (x + 1)) storage
            PUSH unit Unit; PAIR; # Pair Unit new_storage
          }
      };
  }
</code></pre>
<p>Michelson has several specificities:</p>
<ul>
<li>Typing a Michelson program is done by <em>types propagation</em>, and not <em>&agrave; la Milner</em>. Polymorphic types are forbidden and type annotations are required when a type is ambiguous ( <em>e.g.</em> empty list).
</li>
<li>Functions (<em>lambdas</em>) are pure and are not closures, <em>i.e.</em> they must have an empty environment. For instance, a function passed to another contract as parameter acts in a purely functional way, only accessing the environment of the new contract.
</li>
<li>Method calls is preformed with the instruction <code>TRANSFER_TOKENS</code>: it requires an empty stack (not counting its arguments). It takes as argument the current storage, saves it before the call is made, and finally returns it after the call together with the result. This forces developers to save anything worth saving in the current storage, while keeping in mind that a <em>reentring</em> call can happend (the returned storage might be different).
</li>
</ul>
<p>We won't explain the semantics of Michelson here, a good one in big step form is available <a href="https://gitlab.com/tezos/tezos/blob/alphanet/src/proto/alpha/docs/language.md">here</a>.</p>
<h2>The Liquidity Language</h2>
<p>Liquidity is also a functional, statically and strongly typed language that compiles down to the stack-based language Michelson. Its syntax is a subset of OCaml and its semantic is given by its compilation schema (see below). By making the choice of staying close to Michelson in spirit while offering higher level constraints, Liquidity allows to easily write legible smart contracts with the same safety guaranties offered by Michelson. In particular we decided that it was important to keep the purely functional aspect of the language so that simply reading a contract is not obscured by effects and global state. In addition, the OCaml syntax makes Liquidity an <em>immediately accessible</em> tool to programmers who already know OCaml while its limited span makes the learning curve not too steep.</p>
<p>The following example is a liquidity version of the vote contract. Its inner workings are rather obvious for anyone who has already programmed in a ML-like language.</p>
<pre><code class="language-ocaml">[%%version 0.15]

type votes = (string, int) map

let%init storage (myname : string) =
  Map.add myname 0 (Map [&quot;ocaml&quot;, 0; &quot;pro&quot;, 0])

let%entry main
    (parameter : string)
    (storage : votes)
  : unit * votes =

  let amount = Current.amount() in

  if amount &lt; 5.00tz then
    Current.failwith &quot;Not enough money, at least 5tz to vote&quot;
  else
    match Map.find parameter storage with
    | None -&gt; Current.failwith &quot;Bad vote&quot;
    | Some x -&gt;
        let storage = Map.add parameter (x+1) storage in
        ( (), storage )
</code></pre>
<p>A Liquidity contract starts with an optional version meta-information. The compiler can reject the program if it is written in a too old version of the language or if it is itself not recent enough. Then comes a set of type and function definitions. It is also possible to specify an initial storage (constant, or a non-constant storage initializer) with <code>let%init storage</code>. Here we define a type abbreviation <code>votes</code> for a map from strings to integers. It is the structure that we will use to store our vote counts.</p>
<p>The storage initializer creates a map containing two bindings, <code>&quot;ocaml&quot;</code> to <code>0</code> and <code>&quot;pro&quot;</code> to <code>0</code> to which we add another vote option depending on the argument <code>myname</code> given at deploy time.</p>
<p>The entry point of the program is a function <code>main</code> defined with a special annotation <code>let%entry</code>. It takes as arguments a call parameter (<code>parameter</code>) and a storage (<code>storage</code>) and returns a pair whose first element is the result of the call, and second element is a potentially modified storage.</p>
<p>The above program defines a local variable <code>amount</code> which contains the amount of the transaction which generated the call. It checks that it is greater than 5 tezzies. If not, we fail with an explanatory message. Then the program retrieves the number of votes for the chosen option given as parameter. If the vote is not a valid one (<em>i.e.</em>, there is no binding in the map), execution fails. Otherwise, the current number of votes is bound to the name <code>x</code>. Storage is updated by incrementing the number of votes for the chosen option. The built-in function <code>Map.add</code> adds a new binding (here, it replaces a previously existing binding) and returns the modified map. The program terminates, in the normal case, on its last expression which is its returned value (a pair containing <code>()</code> <em>the contract only modifies the storage</em> and the storage itself).</p>
<p><a href="https://github.com/OCamlPro/liquidity/blob/next/docs/liquidity.md">A reference manual for Liquidity is available here</a>. It gives a relatively complete overview of the available types, built-in functions and constructs of the language.</p>
<h2>Compilation</h2>
<h3>Encodings</h3>
<p>Because Liquidity is a lot richer than Michelson, some types and constructs must be simplified or encoded. <em>Record</em> types are translated to right-associated pairs with as many components as the record has fields. <code>t1</code> is encoded as <code>t1'</code> in the following example.</p>
<pre><code class="language-ocaml">type t1 = { a: int; b: string; c: bool}
type t1&rsquo; = (int * (string * bool))
</code></pre>
<p>Field accesses in a record is translated to accesses in the corresponding tuples (pairs). <em>Sum</em> (or union) types are translated using the built-in <code>variant</code> type (this is the <code>or</code> type in Michelson). <code>t2</code> is encoded as <code>t2'</code> in the following example.</p>
<pre><code class="language-ocaml">type ('a, 'b) variant = Left of 'a | Right of `b

type t2 = A of int | B of string | C
type t2&rsquo; = (int, (string, unit) variant) variant
</code></pre>
<p>Similarly, pattern matching on expressions of a sum type is translated to nested pattern matchings on variant typed expressions. An example translation is the following:</p>
<pre><code class="language-ocaml">match x with
| A i -&gt; something1(i)
| B s -&gt; something2(s)
| C -&gt; something3

match x with
| Left i -&gt; something1(i)
| Right r -&gt; match r with
             | Left s -&gt; something2(s)
             | Right -&gt; something3
</code></pre>
<p>Liquidity also supports closures while Michelson only allows pure lambdas. Closures are translated by <em>lambda-lifting</em>, <em>i.e.</em> encoded as pairs whose first element is a lambda and second element is the closure environment. The resulting lambda takes as argument a pair composed of the closure's argument and environment. Adequate transformations are also performed for built-in functions that take lambdas as arguments ( <em>e.g.</em> in <code>List.map</code>) to allow closures instead.</p>
<h3>Compilation schema</h3>
<p>This little section is a bit more technical, so if you don't care how Liquidity is compiled precisely, you can skip over to the next one.</p>
<p>We note by &Gamma;, [|<em>x</em>|]<sub><em>d</em></sub> &#8866; <em>X</em> &uarr;<sup><em>t</em></sup> compilation of the Liquidity instruction <em>x</em>, in environment &Gamma;. &Gamma; is a map associating variable names to a position in the stack. The compilation algorithm also maintains the size of the current stack (at compilation of instruction <em>x</em>), denoted by <em>d</em> in the previous expression. Below is a non-deterministic version of the compilation schema, the one implemented in the Liquidity compiler being a determinized version.</p>
<p><img src="https://ocamlpro.com/blog/assets/img/formula_compil_schema.png" alt=""/></p>
<p>The result of compiling <em>x</em> is a Michelson instruction (or sequence of instructions) <em>X</em> together with a Boolean transfer information <em>t</em>. The instruction <code>Contract.call</code> (or <code>TRANSFER_TOKENS</code> in Michelson) needs an empty stack to evaluate, so the compiler empties the stack before translating this call. However, the various branches of a Michelson program must have the same <em>stack type</em>. This is why we need to maintain this information so that the compiler can empty stacks in some parts of the program.</p>
<p>Some of the rules have parts annotated with ?<sub><em>b</em></sub>. This suffix denotes a potential reset or erasing. In particular:</p>
<ul>
<li>For sets, &Gamma;?<sub>*b</sub> is &empty; if <em>b</em> evaluates to false, and &Gamma; otherwise.
</li>
<li>For integers, *d?<sub><em>b</em></sub> is <code>0</code> if <em>b</em> evaluates to false, and <em>d</em> otherwise.
</li>
<li>For instructions, (*X)?<sub><em>b</em></sub> is <code>{}</code> if <em>b</em> evaluates to false, and <em>X</em> otherwise.
</li>
</ul>
<p>For instance, by looking at rule CONST, we can see that compiling a Liquidity constant simply consists in pushing this constant on the stack. To handle variables in a simple manner, the rule VAR tells us to look in the environment &Gamma; for the index associated to the variable we want to compile. Then, instruction D(U)<sup>i</sup>P puts at the top of the stack a copy of the element present at depth <em>i</em>. Variables are added to &Gamma; with the Liquidity instruction <code>let ... in</code> or with any instruction that binds an new symbol, like <code>fun</code> for instance.</p>
<h2>Decompilation from Michelson</h2>
<p>While Michelson programs are <em>high level</em> compared to other <em>bytecodes</em>, it remains difficult for a blockchain end-user to understand what a Michelson program does exactly by looking at it. However, following the idea that &quot;code is law&quot;, a user should be able to read a contract and understand its precise semantic. Thus, we have developed a <em>decompiler</em> from Michelson to Liquidity, which allows to recover a much more readable and understandable representation of a program on the blockchain.</p>
<p>The decompilation of Michelson code follows the diagram below where:</p>
<ul>
<li><strong>Cleaning</strong> consists in simplifying Michelson code to accelerate the whole process and simplify the following task. For now it consists in ereasing instructions whose continuation is a failure.
</li>
<li><strong>Symbolic Execution</strong> consists in executing the Michelson program with symbolic inputs, and by replacing every value placed in the stacj by a node containing the instruction that generated it. Each node of this graph can be seen as an expression of the target program, which can be bound to a variable name. Edges to this node represent future occurrences of this variable.
</li>
<li><strong>Decompilation</strong> consists in transforming the graph generated by the previous step in a Liquidity syntax tree. Names for variables are recovered from annotations produced by the Liquidity compiler (in case we decompile a Michelson program that was generated from Liquidty), or are chosen on the fly when no annotation is present (<em>e.g.</em> if the Michelson program was written by hand).
</li>
</ul>
<p>Finally the program is typed (to ensure no mistakes were made), simplified and pretty printed.</p>
<p><img src="https://ocamlpro.com/blog/assets/img/diagram_decomp.png" alt=""/></p>
<h3>Example of decompilation</h3>
<pre><code class="language-Makefile">return int;
storage int;
code {DUP; CAR;
      DIP { CDR; PUSH int 1 };  # stack is: parameter :: 1 :: storage
      IF # if parameter = true
         { DROP; DUP; }         # stack is storage :: storage
         { }                    # stack is 1 :: storage
         ;
      PAIR;
     }
</code></pre>
<p>This example illustrate some of the difficulties of the decompilation process: Liquidity is a purely functional language where each construction is an expression returning a value; Michelson handles the stack directly, which is impossible to concretize in in Liquidity (values in the stack don't have the same type, as opposed to values in a list). In this example, depending on the value of <code>parameter</code> the contract returns either the content of the storage, or the integer <code>1</code>. In the Michelson code, the programmer used the instruction <code>IF</code>, but its branches do not return a value and only operates by modifying (or not) the stack.</p>
<pre><code class="language-ocaml">[%%version 0.15]
type storage = int
let%entry main (parameter : bool) (storage : storage) : (int * storage) =
    ((if parameter then storage else 1 ), storage)
</code></pre>
<p>The above translation to Liquidity also contains an <code>if</code>, but it has to return a value. The graph below is the result of the <em>symbolic execution</em> phase on the Michelson program. The <code>IF</code> instruction is decomposed in several nodes, but does not contain any remaining instruction: the result of this <code>if</code> is in fact the difference between the stack resulting from the execution of the <code>then</code> branch and from the <code>else</code> branch. It is denoted by the node <code>N_IF_END_RESULT 0</code> (if there were multiple of these nodes with different indexes, the result of the <code>if</code> would have been a tuple, corresponding to the multiple changes in the stack).</p>
<p><img src="https://ocamlpro.com/blog/assets/img/graph_test6.png" alt=""/></p>
<h2>Try-Liquidity</h2>
<p>You can go to <a href="http://liquidity-lang.org/edit">https://liquidity-lang.org/edit</a> to try out Liquidity in your browser.</p>
<p>The first thing to do (if you want to deploy and interact with a contract) is to go into the settings menu. There you can set your Tezos private key (use one that you generated for the alphanet for the moment) or the source (<em>i.e.</em> your public key hash, which is derived from your private key if you set it).</p>
<p>You can also change which Tezos node you want to interact with (the first one should do, but you can also set one of your choosing such as one running locally on your machine). The timestamp shown next to the node name indicates how long ago was produced the last block that it knows of. Transactions that you make on a node that is not synchronized will not be included in the main chain.</p>
<p><img src="https://ocamlpro.com/blog/assets/img/screenshot_liqedit_settings.png" alt=""/>
You should now see your account with its balance in the top bar:</p>
<p><img src="https://ocamlpro.com/blog/assets/img/screenshot_liqedit_account.png" alt=""/></p>
<p>In the main editor window, you can select a few Liquidity example contracts or write your own. For this small tutorial, we will select <code>multisig.liq</code> which is a minimal multi-signature wallet contract. It allows anyone to send money to it, but it requires a certain number of predefined owners to agree before making a withdrawal.</p>
<p>Clicking on the button <kbd>Compile</kbd> should make the editor blink green (when there are no errors) and the compiled Michelson will appear on the editor on the right.</p>
<p><img src="https://ocamlpro.com/blog/assets/img/screenshot_liqedit_editor.png" alt=""/>
Let's now deploy this contract on the Tezos alphanet. By going into the <strong>Deploy</strong> (or paper airplane icon) tab, we can choose our set of owners for the multisig contract and the minimum number of owners to be in agreement before a withdrawal can proceed. Here I put down two account addresses for which I possess the private keys, and I want the two owners to agree before any transaction is approved (<code>2p</code> is the natural number 2).</p>
<p><img src="https://ocamlpro.com/blog/assets/img/screenshot_liqedit_deploy.png" alt=""/>
Then I can either forge the deployment operation which is then possible to sign offline and inject in the Tezos chain by other means, or I can directly deploy this contract (if the private key is set in settings). If deployment is successful, we can see both the deployment operation and the new contract on a block explorer by clicking on the provided links.</p>
<p>Now we can query the blockchain to examine our newly deployed contract. Head over to the <strong>Examine</strong> tab. The address field should already be filled with our contract handle. We just have to click on <kbd>Retrieve balance and storage</kbd>.</p>
<p><img src="https://ocamlpro.com/blog/assets/img/screenshot_liqedit_examine1.png" alt=""/>
The contract has 3tz on its balance because we chose to initialize it this way. On the right is the current storage of the contract (in Liquidity syntax) which is a record with four fields. Notice that the <code>actions</code> field is an empty map.</p>
<p>Let's make a few calls to this contract. Head over to the <strong>Call</strong> tab and fill-in the parameter and the amount. We can send for instance 5.00tz with the parameter <code>Pay</code>. Clicking on the button <kbd>Call</kbd> generates a transaction which we can observe on a block explorer. More importantly if we go back to the <strong>Examine</strong> tab, we can now retrieve the new information and see that the storage is unchanged but the balance is 8.00tz.</p>
<p>We can also make a call to withdraw money from the contract. This is done by passing a parameter of the form:</p>
<pre><code class="language-ocaml">Manage (
  Some {
    destination = tz1brR6c9PY3SSfBDu7Qxdhsz3pvNRDwf68a;
    amount = 2tz;
})
</code></pre>
<p>This is a proposition of transfer of funds in the amount of 2.00tz from the contract to the destination <code>tz1brR6c9PY3SSfBDu7Qxdhsz3pvNRDwf68a</code>.</p>
<p><img src="https://ocamlpro.com/blog/assets/img/screenshot_liqedit_call1.png" alt=""/></p>
<p>The balance of the contract has not changed (it is still 8.00tz) but the storage has been modified. That is because this multisig contract requires two owners to agree before proceeding. The proposition is stored in the map <code>actions</code> and is associated to the owner who made said proposition.</p>
<pre><code class="language-ocaml">{
  owners =
    (Set
       [tz1XT2pgiSRWQqjHv5cefW7oacdaXmCVTKrU;
       tz1brR6c9PY3SSfBDu7Qxdhsz3pvNRDwf68a]);
  actions =
    (Map
       [(tz1brR6c9PY3SSfBDu7Qxdhsz3pvNRDwf68a,
          {
            destination = tz1brR6c9PY3SSfBDu7Qxdhsz3pvNRDwf68a;
            amount = 2.00tz
          })]);
  owners_length = 2p;
  min_agree = 2p
}
</code></pre>
<pre><code></code></pre>
<p>We can now open a new browser tab and point it to <a href="http://liquidity-lang.org/edit">https://liquidity-lang.org/edit</a>, but this time we fill in the private key for the second owner <code>tz1XT2pgiSRWQqjHv5cefW7oacdaXmCVTKrU</code>. We choose the multisig contract in the Liquidity editor and fill-in the contract address in the call tab with the same one as in the other session <code>TZ1XvTpoSUeP9zZeCNWvnkc4FzuUighQj918</code> (you can double check the icons for the two contracts are identical). For the the withdrawal to proceed, this owner has to make the exact same proposition so let's make a call with the same parameter:</p>
<pre><code class="language-ocaml">Manage (
  Some {
    destination = tz1brR6c9PY3SSfBDu7Qxdhsz3pvNRDwf68a;
    amount = 2tz;
})
</code></pre>
<p>The call should also succeed. When we examine the contract, we can now see that its balance is down to 6.00tz and that the field <code>actions</code> of its storage has been reinitialized to the empty map. In addition, we can update the balance of our first account (by clicking on the circle arrow icon in the tob bar) to see that it is now up an extra 2.00tz and that was the destination of the proposed (and agreed on) withdrawal. All is well!</p>
<p>We have seen how to compile, deploy, call and examine Liquidity contracts on the Tezos alphanet using our online editor. Experiment with your own contracts and let us know how that works for you!</p>
<ul>
<li>Slides in <a href="https://files.ocamlpro.com/pub/liquidity_slides.en_.pdf">English</a>
</li>
<li>and <a href="https://files.ocamlpro.com/pub/liquidity_slides.pdf">French</a>
</li>
</ul>
<h1>Comments</h1>
<p>fredcy (9 February 2018 at 3 h 14 min):</p>
<blockquote>
<p>It says &ldquo;Here we define a type abbreviation votes [&hellip;]&rdquo; but I don&rsquo;t see any <code>votes</code> symbol in the nearby code.</p>
<p>[Still working through the document. I&rsquo;m eager to try Liquidity rather than write in Michelson.]</p>
</blockquote>
<p>alain (9 February 2018 at 7 h 18 min):</p>
<blockquote>
<p>You are right, thanks for catching this. I&rsquo;ve updated the contract code to use type <code>votes</code>.</p>
</blockquote>
<p>branch (26 February 2019 at 18 h 28 min):</p>
<blockquote>
<p>Why the &ldquo;Deploy&rdquo; button can be inactive, while liquidity contract is compiled successfully?</p>
</blockquote>
<p>alain (6 March 2019 at 15 h 09 min):</p>
<blockquote>
<p>For the Deploy button to become active, you need to specify an initial value for the storage directly in the code of the smart contract. This can be done by writing a constant directly or a function.</p>
</blockquote>
<pre><code class="language-sourcecode">let%init storage = (* the value of your initial storage*)

let%init storage x y z = (* the value of your initial storage, function of x, y and z *)
</code></pre>

