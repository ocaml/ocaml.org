---
title: Detecting identity functions in Flambda
description: In some discussions among OCaml developers around the empty type (PR#9459),
  some people mused about the possibility of annotating functions with an attribute
  telling the compiler that the function should be trivial, and always return a value
  strictly equivalent to its argument.Curious about the feas...
url: https://ocamlpro.com/blog/2021_07_16_detecting_identity_functions_in_flambda
date: 2021-07-16T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Leo Boitel\n  "
source:
---

<blockquote>
<p>In some discussions among OCaml developers around the empty type (<a href="https://github.com/ocaml/ocaml/issues/9459">PR#9459</a>), some people mused about the possibility of annotating functions with an attribute telling the compiler that the function should be trivial, and always return a value strictly equivalent to its argument.<br/>Curious about the feasibility of implementing this feature, we advertised an internship with our compiler team aimed at exploring this subject.<br/>We welcomed L&eacute;o Boitel during three months to work on this topic, with Vincent Laviron as mentor, and we're proud to let him show off what he has achieved in this post.</p>
</blockquote>
<h3>The problem at hand</h3>
<p>OCaml's strong typing system is one of its main perks: it allows to write safe code thanks to the abstraction it provides. Most of the basic design mistakes will directly result into a typing error and the user cannot mess up the memory as it is automatically handled by the compiler and runtime.</p>
<p>However, these perks keep a power-user from implementing some optimizations, in particular those linked to memory representation as they cannot be accessed directly.</p>
<p>A good example would be this piece of code:</p>
<pre><code class="language-Ocaml">type return = Ok of int | Failure
let id = function
| Some x -&gt; Ok x
| None -&gt; Failure
</code></pre>
<p>In terms of memory representation, this function is indeed the identity function. <code>Some x</code> and <code>Ok x</code> share the same representation (and so do <code>None</code> and <code>Failure</code>). However, this identity is invisible to the user. Even if the user knows the representation is the same, they would need to use this function to avoid a typing error.</p>
<p>Another good example would be this one:</p>
<pre><code class="language-Ocaml">type record = { a:int; b:int }
let id (x,y) = { a = x; b = y }
</code></pre>
<p>Even if those functions are the identity, they come with a cost: not only do they cost a function call, they reallocate the result instead of just returning their argument directly. Detecting those functions would allow us to produce interesting optimizations.</p>
<h3>Hurdles</h3>
<p>If we want to detect identities, we quickly hit the problem of recursive functions: how does one recognize identity in those cases? Can a function be an identity if it doesn't always terminate, or if it never does?</p>
<p>Once we have a good definition of what exactly an identity function is, we still need to prove that an existing function fits the definition. Indeed, we want to ensure the user that this optimization will not change the observable behavior of the program.</p>
<p>We also want to avoid breaking type safety. As an example, the following function:</p>
<pre><code class="language-Ocaml">let rec fake_id = function
| [] -&gt; 0
| t::q -&gt; fake_id (t::q)
</code></pre>
<p>A naive induction proof would allow us to replace this function with the identity, as <code>[]</code> and <code>0</code> share the same memory representation. However, this is unsafe as applying this to a non-empty list would return a list even if this function has an <code>int</code> type (we'll talk more about it later).</p>
<p>To tackle those challenges, we started the internship with a theoretical study that lasted for three fourths of the allocated time and lastly implemented a practical solution in the Flambda representation of the compiler.</p>
<h3>Theoretical results</h3>
<p>We worked on extensions of lambda-calculus (implemented in OCaml) in order to gradually test our ideas in a simpler framework than the full Flambda.</p>
<h4>Pairs</h4>
<p>We started with a lambda-calculus to which we only added the concept of pairs. To prove identities, every function has to be annotated as identity or not. We then prove these annotations by &beta;-reducing the function bodies. After each recursive reduction, we apply a rule that states that a pair made of the first and second projection of a variable is equal to that variable. We do not reduce applications, but we replace them by the argument if the concerned function is annotated as identity.</p>
<p>Using this method, we maintain a reasonable complexity compared to a full &beta;-reduction which would be unrealistic on a big program.</p>
<p>We then add higher-order capabilities by allowing annotations of the form <code>Annotation &rarr; Annotation</code>. Functions as <code>List.map</code> can that way be abstracted as <code>Id &rarr; Id</code>. Even though this solution doesn't cover every case, most real-world usage are recognized by these patterns.</p>
<h4>Tuple reconstruction</h4>
<p>We then move from just pairs to tuples of arbitrary size. This adds a new problem: if we make a pair out of the first two fields of a variable, this is no longer necessarily that variable, as it may have more than two fields.</p>
<p>We then have two solutions: we can first annotate every projection with the size of the involved tuple to know if we are indeed reconstructing the entire variable. As an example, if we make a pair from the fields of a triplet, we know there is no way to simplify this reconstruction.</p>
<p>Another solution, more ambitious, is to adopt a less restrictive definition of equality and to allow the replacement of <code>(x,y)</code> by <code>(x,y,z)</code>. Indeed, if the variable was typed as a pair, we are guaranteed that the third field will never be accessed. The behavior of the program will therefore never be affected by this extension.</p>
<p>Though this allows to avoid a lot of allocations, it may also increase memory usage in some cases: if the triplet ceases to be used, it won't be deallocated by the Garbage Collector (GC) and the field <code>z</code> will be kept in memory as long as <code>(x,y)</code> is still accessible.</p>
<p>This approach remains interesting to us, as long as it is manually enabled by the user for some specific blocks.</p>
<h4>Recursion</h4>
<p>We now add recursive definitions to our language, through the use of a fixpoint operator.</p>
<p>To prove that a recursive function is the identity, we have to use induction. The main difficulty is to prove that the function indeed terminates to ensure the validity of the induction.</p>
<p>We can separate this into three different levels of safety. The first option is to not prove termination at all, and let the user state which function they know will return. We can then assume the function is the identity and replace its body on that hypothesis. This approach is enough for most practical cases, but its main problem lies in the fact that it allows to write unsafe code (as we've already seen).</p>
<p>Our second option is to limit our induction hypothesis to recursive applications on &quot;smaller&quot; elements than the argument. An element is defined as smaller if it is a projection of the argument or a projection of a smaller element. This is not enough to prove that the function will terminate (the argument might be cyclic, for example) but is enough to ensure type safety. The reason is that any possibly returned value is constructed (as it cannot directly come from a recursive call) and have therefore a defined type. Typing would fail if the function was to return a value that cannot be identified to its argument.</p>
<p>Finally, we may want to establish a perfect equivalence between the function and the identity function before simplifying it. In that case, we propose to create a special annotation for functions that are the identity when applied to a non-cyclical object. We can prove they have this property with the already described induction. The difficulty now lies into applying the simplification only to valid applications: if an object is immutable, wasn't recursively defined and is made of components that also have that property, we can declare that object inductive and simplify applications on it. The inductive state of variables can be propagated during our recursive pass of optimization.</p>
<h3>Block reconstruction</h3>
<p>The representation of blocks in Flambda provides interesting challenges in terms of equality detection, which is often crucial to prove an identity. It is very hard to detect an identical block reconstruction.</p>
<h4>Blocks in Flambda</h4>
<h5>Variants</h5>
<p>The blocks in Flambda come from the existence of variants in OCaml: one type may have several different constructors, as we can see in</p>
<pre><code class="language-Ocaml">type choice = A of int | B of int
</code></pre>
<p>When OCaml is compiled to Flambda, the information used by the constructor is lost and replaced by a tag. The tag is a number contained in the header of the object's memory representation between 0 and 255 that represents which constructor was used. As an example, an element of type <code>choice</code> would have tag <code>0</code> for the <code>A</code> constructor, and <code>1</code> for <code>B</code>.</p>
<p>That tag will be kept at runtime, which will allow for example to implement pattern matching as a simple switch in Flambda, that executes simple comparisons on the tag to know which branch to execute next.</p>
<p>This system complicates our task as Flambda's typing doesn't inform us which type the constructor is supposed to have, and therefore keeps us from easily knowing if two variants are indeed equal.</p>
<h5>Tag generalization</h5>
<p>To complicate things, tags are actually used for any block, meaning tuples, modules or functions (as a matter of fact, almost anything but constant constructors and integers). If the object doesn't have variants, it will usually have tag 0. This tag is never read (as there are no variants to differentiate) but keeps us from simply comparing two tuples, because Flambda will simply see two blocks of unknown tag.</p>
<h5>Inlining</h5>
<p>Finally, this system is optimized by inlining tuples: if a variant has a shape <code>Pair of int * int</code>, it will be often be flattened into a tuple <code>(tag Pair, int, int)</code>.</p>
<p>This also means that variants can have an arbitrary size, which is also unknown in Flambda.</p>
<h4>Existing approach</h4>
<p>A partial solution to the problem already existed in a Pull Request (PR) you can read <a href="https://github.com/ocaml/ocaml/pull/8958">here</a>.</p>
<p>The chosen approach in this PR is the natural one: we use the switch to gain information on the tag of a block, depending on the branch taken. The PR also allows to know the mutability and size of the block in each branch, starting from OCaml (where this information is known as it is explicit in the pattern matching) and propagating the knowledge to Flambda.</p>
<p>This allows to register every block on which a switch is done with their tag, size and mutability. We can then detect if one of them is reconstructed with the use of a <code>Pmakeblock</code> primitive.</p>
<p>Unfortunately, this path has its limits as there are numerous cases where the tag and size could be known without performing a switch on the value. As an example, this doesn't allow the simplification of tuple reconstruction.</p>
<h4>New solution</h4>
<p>Our new solution will have to propagate more information from OCaml into Flambda. This propagation is based on two PRs that already existed for Flambda 2, which annotated in the lambda representation each projection (<code>Pfield</code>) with typing informations. We add <a href="https://github.com/ocaml-flambda/ocaml/commit/fa5de9e64ff1ef04b596270a8107d1f9dac9fb2d">block mutability</a> and <a href="https://github.com/ocaml-flambda/ocaml/pull/53">tag and finally size</a>.</p>
<p>Our first contribution was to translate these PRs to Flambda 1, and to propagate from lambda to Flambda correctly.</p>
<p>We then had access to every necessary information to detect and prove block reconstruction: not only we have a list of blocks that were pattern-matched, we can make a list of partially immutable blocks, meaning blocks for which we know that some fields are immutable.</p>
<p>Here's how we use it:</p>
<h6>Block discovery</h6>
<p>As soon as we find a projection, we verify whether it is done on an immutable block of known size. If so, we add that block to the list of partial blocks. We verify that the information we have on the tag and size are compatible with the already known projections. If all of the fields of the block are known, the block is added to the list of simplifiable blocks.</p>
<p>Of course, we also keep track of known blocks though switches.</p>
<h6>Simplification</h6>
<p>This part is similar to the original PR: when an immutable block is met, we check whether this block is known as simplifiable. In that case we avoid a reallocation.</p>
<p>Compared to the original approach, we also reduced the asymptotic complexity (from quadratic to linear) by registering the association of every projection variable to its index and original block. We also modified some implementation details that could have triggered a bug when associated with our PR.</p>
<h4>Example</h4>
<p>Let's consider this function:</p>
<pre><code class="language-Ocaml">type typ1 = A of int | B of int * int
type typ2 = C of int | D of {x:int; y:int}
let id = function
  | A n -&gt; C n
  | B (x,y) -&gt; D {x; y}
</code></pre>
<p>The current compiler would produce the resulting Flambda output:</p>
<pre><code>End of middle end:
let_symbol
  (camlTest__id_21
    (Set_of_closures (
      (set_of_closures id=Test.8
        (id/5 = fun param/7 -&gt;
          (switch*(0,2) param/7
           case tag 0:
            (let
              (Pmakeblock_arg/11 (field 0&lt;{../../test.ml:4,4-7}&gt; param/7)
               Pmakeblock/12
                 (makeblock 0 (int)&lt;{../../test.ml:4,11-14}&gt;
                   Pmakeblock_arg/11))
              Pmakeblock/12)
           case tag 1:
            (let
              (Pmakeblock_arg/15 (field 1&lt;{../../test.ml:5,4-11}&gt; param/7)
               Pmakeblock_arg/16 (field 0&lt;{../../test.ml:5,4-11}&gt; param/7)
               Pmakeblock/17
                 (makeblock 1 (int,int)&lt;{../../test.ml:5,17-23}&gt;
                   Pmakeblock_arg/16 Pmakeblock_arg/15))
              Pmakeblock/17)))
         free_vars={ } specialised_args={}) direct_call_surrogates={ }
        set_of_closures_origin=Test.1])))
  (camlTest__id_5_closure (Project_closure (camlTest__id_21, id/5)))
  (camlTest (Block (tag 0,  camlTest__id_5_closure)))
End camlTest
</code></pre>
<p>Our optimization allows to detect that this function reconstructs a similar block and therefore can simplify it:</p>
<pre><code>End of middle end:
let_symbol
  (camlTest__id_21
    (Set_of_closures (
      (set_of_closures id=Test.7
        (id/5 = fun param/7 -&gt;
          (switch*(0,2) param/7
           case tag 0 (1): param/7
           case tag 1 (2): param/7))
         free_vars={ } specialised_args={}) direct_call_surrogates={ }
        set_of_closures_origin=Test.1])))
  (camlTest__id_5_closure (Project_closure (camlTest__id_21, id/5)))
  (camlTest (Block (tag 0,  camlTest__id_5_closure)))
End camlTest
</code></pre>
<h4>Possible improvements</h4>
<h5>Equality relaxation</h5>
<p>We can use observational equality studied in the theoretical part for block equality in order to avoid more allocations. The implementation is simple:</p>
<p>When a block is created, to know if it will be allocated, the normal course of action is to check if all of its fields are the known projections of another block, with the same index, and if the block sizes are the same. We can just remove that last check.</p>
<p>Implementing this was a bit more tricky because of several practical details. First, we want that optimization to be only triggered on user-annotated blocks, we had to propagate that annotation to Flambda.</p>
<p>Additionally, if we only implement that optimization, numerous optimization cases will be ignored because unused variables are simplified before our optimization pass. As an example, if a function looks like</p>
<pre><code class="language-Ocaml">let loose_id (a,b,c) = (a,b)
</code></pre>
<p>The <code>c</code> variable will be simplified away before reaching Flambda, and there will be no way to prove that <code>(a,b,c)</code> is immutable as its third field could not be. This problem is being solved on Flambda2 thanks to a PR that propagates mutability information for every block, but we didn't have the time necessary to migrate it on Flambda 1.</p>
<h3>Detecting recursive identities</h3>
<p>Now that we can detect block reconstruction, we're left with solving the problem of recursive functions.</p>
<h4>Unsafe approach</h4>
<p>We began the implementation of a pass that contains no termination proof. The idea is to add the proof later, or to authorize non-terminating functions to be simplified as long as they type correctly (see previously in the theory part).</p>
<p>For now, we trust the user to verify these properties manually.</p>
<p>Hence, we modified the function simplification procedure: when a function with a single argument is modified, we first assume that this function is the identity before simplifying its body. We then check whether the result is equivalent to an identity by recursively going through it, so as to cover as many cases as possible (for example in conditional branchings). If it is the case, the function will be replaced by the identity ; otherwise, we go back to a normal simplification, without the induction hypothesis.</p>
<h4>Constant propagation</h4>
<p>We took some time to improve our code that checks whether the body of a function is an identity or not, so as to handle constant values. It propagates identity information we have on an argument during conditional branching.</p>
<p>This way, on a function like</p>
<pre><code class="language-Ocaml">type truc = A | B | C
let id = function
  | A -&gt; A
  | B -&gt; B
  | C -&gt; C
</code></pre>
<p>or even</p>
<pre><code class="language-Ocaml">let id x = if x=0 then 0 else x
</code></pre>
<p>We can successfully detect identity.</p>
<h4>Examples</h4>
<h5>Recursive functions</h5>
<p>We can now detect recursive identities:</p>
<pre><code class="language-Ocaml">let rec listid = function
  | t::q -&gt; t::(listid q)
  | [] -&gt; []
</code></pre>
<p>Used to compile to:</p>
<pre><code>End of middle end:
let_rec_symbol
  (camlTest__listid_5_closure
    (Project_closure (camlTest__set_of_closures_20, listid/5)))
  (camlTest__set_of_closures_20
    (Set_of_closures (
      (set_of_closures id=Test.11
        (listid/5 = fun param/7 -&gt;
          (if param/7 then begin
            (let
              (apply_arg/13 (field 1&lt;{../../test.ml:9,4-8}&gt; param/7)
               apply_funct/14 camlTest__listid_5_closure
               Pmakeblock_arg/15
                 *(apply*&amp;#091;listid/5]&lt;{../../test.ml:9,15-25}&gt; apply_funct/14
                    apply_arg/13)
               Pmakeblock_arg/16 (field 0&lt;{../../test.ml:9,4-8}&gt; param/7)
               Pmakeblock/17
                 (makeblock 0&lt;{../../test.ml:9,12-25}&gt; Pmakeblock_arg/16
                   Pmakeblock_arg/15))
              Pmakeblock/17)
            end else begin
            (let (const_ptr_zero/27 Const(0a)) const_ptr_zero/27) end))
         free_vars={ } specialised_args={}) direct_call_surrogates={ }
        set_of_closures_origin=Test.1])))
let_symbol (camlTest (Block (tag 0,  camlTest__listid_5_closure)))
End camlTest
</code></pre>
<p>But is now detected as being the identity:</p>
<pre><code>End of middle end:
let_symbol
  (camlTest__set_of_closures_20
    (Set_of_closures (
      (set_of_closures id=Test.13 (listid/5 = fun param/7 -&gt; param/7)
        free_vars={ } specialised_args={}) direct_call_surrogates={ }
        set_of_closures_origin=Test.1])))
  (camlTest__listid_5_closure
    (Project_closure (camlTest__set_of_closures_20, listid/5)))
  (camlTest (Block (tag 0,  camlTest__listid_5_closure)))
End camlTest
</code></pre>
<h5>Unsafe example</h5>
<p>However, we can use the unsafety of the feature to go around the typing system and access a memory address as if it was an integer:</p>
<pre><code class="language-Ocaml">type bugg = A of int*int | B of int
let rec bug = function
  | A (a,b) -&gt; (a,b)
  | B x -&gt; bug (B x)
  
let (a,b) = (bug (B 42))
let _ = print_int b
</code></pre>
<p>This function will be simplified to the identity even though the <code>bugg</code> type is not compatible with tuples; trying to project on the second field of variant b will access an undefined part of memory:</p>
<pre><code>$ ./unsafe.out
47423997875612
</code></pre>
<h4>Possible improvements - short term</h4>
<h5>Function annotation</h5>
<p>A theoretically simple thing to add would be to let the choice of applying unsafe optimizations to the user. We lacked the time to do the work of propagating the information to Flambda, but it would not be hard to implement.</p>
<h5>Order on arguments</h5>
<p>For a safer optimization, we could use the idea developed in the theoretical part to make the optimization correct on non-cyclical objects and more importantly give us typing guarantees to avoid the problem we just saw.</p>
<p>To get this guarantee, we would have to change the simplification pass by adding an optional pair of function-argument to the environment. When this option exists, the pair indicates that we are in the body in the process of simplification and that applications on smaller elements can be simplified as identity. Of course, the pass would need to be modified to remember which elements are not smaller than the previous argument.</p>
<h4>Possible improvements - long term</h4>
<h5>Exclusion of cyclical objects</h5>
<p>As described in the theoretical part, we could recursively deduce which objects are cyclical and attempt to remove them from our optimization. The problem is then that instead of having to replace functions by the identity, we need to add a special annotation that represents <code>IdRec</code>.</p>
<p>This amounts to a lot of added implementation complexity when compiling over several files, as we need access to the interface of already compiled files to know when the optimization can be used.</p>
<p>A possibility would be to use .cmx files to store this information when the file is compiled, but that kind of work would have taken too long to be achieved during the internship. Moreover, the practicality of that choice is far from obvious: it would complexify the optimization pass for a small improvement with respect to a version that would be correct on non-cyclical objects and activated through annotations.</p>

