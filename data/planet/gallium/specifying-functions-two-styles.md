---
title: 'Specifying Functions: Two Styles'
description:
url: http://gallium.inria.fr/blog/function-specs-2023-05-12
date: 2023-05-12T08:00:00-00:00
preview_image:
featured:
authors:
- gallium
---



<p>In this post, I discuss two approaches to writing formal
specifications for (possibly curried) functions of multiple arguments. I
refer to these two styles as <em>callee-side reasoning</em> and
<em>caller-side reasoning</em>. While the former style is very much
standard, the latter style is perhaps relatively little known.</p>





<h3>Specifying Functions: Two
Styles</h3>
<p>In OCaml, the definitions <code>let f = fun (x1, x2) -&gt; e</code>
and <code>let g = fun x1 -&gt; fun x2 -&gt; e</code> both define
functions. The function <code>f</code> is <em>uncurried</em>: it expects
one argument, which must be a pair. The function <code>g</code> is
<em>curried</em>: it expects one argument and returns a function of one
argument.</p>
<p>In both cases, the function invocation process is non-atomic. From
the moment where the function application <code>f (v1, v2)</code> or
<code>g v1 v2</code> begins, until the moment where the function body
<code>e</code> is executed, in a context where the name <code>x1</code>
is bound to the value <code>v1</code> and the name <code>x2</code> is
bound to the value <code>v2</code>, a number of computation steps take
place. In the case of the function application <code>f (v1, v2)</code>,
the pair <code>(v1, v2)</code> is first transmitted to the function;
then, this pair is decomposed; and only then is the function body
executed. In the case of the function application <code>g v1 v2</code>,
the value <code>v1</code> is first transmitted to the function; then,
some kind of nameless function, or closure, is returned; then, the value
<code>v2</code> is transmitted to this nameless function; and only then
is the function body executed.</p>
<p>In either case, the purpose of the function invocation process is to
eventually bind the formal parameters <code>x1</code> and
<code>x2</code> to the actual arguments <code>v1</code> and
<code>v2</code>. However, the details of the process vary. Furthermore,
in the case of a curried function, this process can be
<em>interrupted</em> in the middle and resumed at a later time, because
<em>partial applications</em> are permitted: the function application
<code>g v1</code> returns a perfectly valid function of one
argument.</p>
<p>How does one describe the behavior of the functions <code>f</code>
and <code>g</code> in precise informal prose or in a formal program
logic, such as Hoare logic or Separation Logic?</p>
<p>Two distinct approaches emerge, depending on <em>who</em> reasons
about the function invocation process: the callee, or the caller?</p>
<p>In the first style, <em>callee-side reasoning</em>, one publishes a
specification of <em>the function</em>; whereas in the second style,
<em>caller-side reasoning</em>, one publishes a specification of <em>the
function&rsquo;s body</em>.</p>
<h4>Callee-Side Reasoning</h4>
<p>It may seem more natural to let the callee reason about the function
invocation process. Indeed, this process is then analyzed just once, at
the function definition site, as opposed to once at each call site.
Furthermore, this approach results in more abstract specifications,
along the following lines:</p>
<ul>
<li><p>After the definition <code>let f = fun (x1, x2) -&gt; e</code>,
the name <code>f</code> is bound to some value <code>v</code> such that,
for all values <code>v1</code> and <code>v2</code>, the application of
<code>v</code> to the pair <code>(v1, v2)</code> results in &hellip;</p></li>
<li><p>After the definition
<code>let g = fun x1 -&gt; x2 -&gt; e</code>, the name <code>g</code> is
bound to some value <code>v</code> such that, for all values
<code>v1</code> and <code>v2</code>, the application of <code>v</code>
to the values <code>v1</code> and <code>v2</code> result in &hellip;</p></li>
</ul>
<p>In these specifications, the value <code>v</code> remains abstract.
It is a runtime representation of a function (presumably a code pointer
or some kind of closure), but the caller does not have to know.</p>
<p>This is the most common style.</p>
<p>An upside of this style is its high level of abstraction: functions
are viewed as abstract objects.</p>
<p>A downside of this style is that it does not support partial
applications in a very natural way. The above specification of
<code>g</code> describes only what happens when <code>g</code> is
applied to <em>two</em> values <code>v1</code> and <code>v2</code>. If
one wishes to allow the partial application <code>g v1</code>, then one
must write a more complex specification. This is possible, but slightly
cumbersome.</p>
<h4>Caller-Side Reasoning</h4>
<p>The other, less common, approach is to publish a specification of the
function&rsquo;s <em>body</em>, along the following lines:</p>
<ul>
<li>For all values <code>v1</code> and <code>v2</code>, if the names
<code>x1</code> and <code>x2</code> are bound to the values
<code>v1</code> and <code>v2</code>, then the execution of the
expression <code>e</code> results in &hellip;</li>
</ul>
<p>Then, the functions <code>f</code> and <code>g</code> can be
described in a concrete manner, along the following lines:</p>
<ul>
<li><p>After the definition <code>let f = fun (x1, x2) -&gt; e</code>,
the name <code>f</code> is bound to the function
<code>fun (x1, x2) -&gt; e</code>.</p></li>
<li><p>After the definition
<code>let g = fun x1 -&gt; x2 -&gt; e</code>, the name <code>g</code> is
bound to the function <code>fun x1 -&gt; fun x2 -&gt; e</code>.</p></li>
</ul>
<p>These are not traditional specifications in the tradition of Floyd
and Hoare. Instead of describing the <em>abstract behavior of an
application</em> of the functions <code>f</code> or <code>g</code>, they
are <em>concrete descriptions of the runtime values</em> that represent
the functions <code>f</code> and <code>g</code>.</p>
<p>It is then up to the caller, at each call site, to reason about the
function invocation process.</p>
<p>A downside of this style is its lower level of abstraction: functions
are viewed as concrete values whose runtime representation is exposed.
(For example, whether a function is recursive or not recursive becomes
visible.)</p>
<p>An upside of this style is that it naturally offers support for
partial applications, without any extra effort. The above specifications
expose sufficient information for the caller to reason about a partial
application.</p>
<h4>Bottom Line</h4>
<p>As far as I know, the existence of these two styles is discussed
nowhere in the literature. I can see two reasons why this is so:</p>
<ul>
<li><p>The distinction between these styles arises only because the
function invocation process is not atomic. In a language where n-ary
functions are primitive, the function invocation process atomically
binds <code>x1</code> to <code>v1</code> and <code>x2</code> to
<code>v2</code>. The program logic can take care of reasoning about this
step, so neither the callee nor the caller need to reason about
it.</p></li>
<li><p>Caller-side reasoning is less abstract and requires a mixture of
Hoare-style reasoning (that is, reasoning in terms of logical
assertions) and symbolic execution (that is, reasoning by simulating
steps of execution). The tradition and culture of Hoare-style reasoning
is so prevalent that this style may seem quite alien to most researchers
and practitioners.</p></li>
</ul>


