---
title: 'Polymorphic variants : Subtyping and variance'
description: 'Polymorphic variants : subtyping and variance            Polymorphic
  variants : Subtyping and variance           Here ar...'
url: http://blog.shaynefletcher.org/2017/03/polymorphic-variants-subtyping-and.html
date: 2017-03-07T20:05:00-00:00
preview_image:
featured:
authors:
- Shayne Fletcher
---


<html>
  <head>
     
    
    <title>Polymorphic variants : subtyping and variance</title>
  </head>
  <body>
    <h2>Polymorphic variants : Subtyping and variance</h2>
    <p>
    Here are some expressions in the top-level involving polymorphic
    variant types.
    </p><pre>
    # let x = [ `On; `Off ];;
    val x : [&gt; `Off | `On ] list = [ `On; `Off ]
    </pre>
    The notation <code>[&gt; `Off | `On ]</code> represents a type
    that <b>at least</b> contains the constructors <code>`Off</code>
    and <code>`On</code>. Of course, there are an unlimited number of
    such types so <code>[&gt; `Off | `On ]</code> is a set in fact.
    
    <p>
    </p><pre>
    # let n = `Number 1;;
    val n : [&gt; `Number of int ] = `Number 1
    </pre>
    The value <code>n</code> is of a type that <b>at least</b>
    contains the constructor <code>`Number of int</code>.
    
    <p>
    </p><pre>
    # let f = function | `On &rarr; 1 | `Off &rarr; 0 | `Number n &rarr; n;;
    val f : [&lt; `Number of int | `Off | `On ] &rarr; int = &lt;fun&gt;
    </pre>
    The function <code>f</code> accomodates exactly three cases
    corresponding to the
    constructors <code>`Off</code>, <code>`On</code> and <code>`Number
    of int</code>. This informs us that <code>[&lt; `Number of int |
    `Off | `On ]</code> is of a type that <b>at most</b> has the
    constructors <code>`Off</code>, <code>`On</code> and <code>`Number
    of int</code>.
    
    <p>
    The expression <code>(</code>$expr$<code>
    :&gt; </code>$typexpr$<code>)</code> coerces the expression $expr$ to
    type $typexpr$. The expression <code>(</code>$expr$ <code>:</code>
    $typ_{1}$ <code>:&gt;</code> $typ_{2}$ <code>)</code> coerces the
    exprssion $expr$ from $typ_{1}$ to $typ_{2}$. It is only possible
    to coerce an expression $expr$ from type $typ_{1}$ to type
    $typ_{2}$, if the type of $expr$ is an instance of $typ_{1}$ and
    $typ_{1}$ is a subtype of $typ_{2}$.
    </p>
    <p>
    </p><pre>
    # let f x = (x :&gt; [ `A | `B ]);;
    val f : [&lt; `A | `B ] &rarr; [ `A | `B ] = &lt;fun&gt;
    </pre>
    We see <code>x</code> needs to be coercible to type <code>[ `A |
     `B ]</code>. So, we read <code>[&lt; `A | `B ]</code> as a type
     that at most contains the constructors <code>`A</code>
     and <code>`B</code>. <code>[ `A ]</code>, <code>[ `B ]</code>
     and <code>[ `A | `B ]</code> are the subtypes of <code>[ `A | `B
     ]</code>. It follows then that <code>[&lt; `A | `B ]</code> is
     the set of subtypes of <code>[ `A | `B ]</code>.
    
    <p>
    </p><pre>
    # let f x = (x :&gt; [ `A | `B ] * [ `C | `D ]);;
    val f : [&lt; `A | `B ] * [&lt; `C | `D ] &rarr; [ `A | `B ] * [ `C | `D ] = &lt;fun&gt;
    </pre>
    We see <code>x</code> needs to be coercible to <code>[ `A | `B ] *
    [ `C | `D ]</code>. This coercion can only proceed
    if <code>x</code> designates a pair with first component a subtype
    of <code>[ `A | `B ]</code> and second component a subtype
    of <code>[ `C | `D ]</code>. So we see, <code>[&lt; `A | `B ] *
    [&lt; `C | `D ]</code> is the set of subtypes of <code>[ `A | `B ]
    * [ `C | `D ]</code>.
    
    <p>
    </p><pre>
    # let f x = (x  :&gt; [ `A ] &rarr; [ `C | `D ]);;
    val f : ([&gt; `A ] &rarr; [&lt; `C | `D ]) &rarr; [ `A ] &rarr; [ `C | `D ] = &lt;fun&gt;
    </pre>
    We see <code>x</code> needs to be coercible to <code>[ `A ] &rarr; [
    `C | `D ]</code>. This coercion can only proceed if <code>x</code>
    designates an arrow where the argument is of a type that at least
    contains the constructor <code>`A</code>. That is <code>[ `A
    ]</code>, <code>[ `A | ... ]</code> where the &quot;<code>...</code>&quot;
    represent more constructors. From this we see that <code>[&gt;
    `A]</code> is the set of supertypes of <code>[ `A ]</code>. The
    return value of <code>x</code> (by logic we've already
    established) is a subtype of <code>[ `C | `D
    ]</code>. So, <code>[&gt; `A ] &rarr; [&lt; `C | `D ]</code> is the
    set of subtypes of <code>[ `A ] &rarr; [ `C | `D ]</code>.
    
    <p>The transformation represented by <code>f</code> above, has
    coerced an arrow <code>x</code> to a new arrow. The type of the
    argument of <code>x</code> is <code>[&gt; `A ]</code> and the
    type of the argument of the resulting arrow is <code>[ `A
    ]</code>. That is, for the argument, the transformation between
    types has taken a supertype to a subtype. The argument type is
    said to be in a &quot;contravariant&quot; position. On the other hand, the
    result type of <code>x</code> is <code>[&lt; `C | `D ]</code> and
    the arrow that is produced from it, <code>f x</code>, has result
    type <code>[ `C | `D ]</code>. That is, the coercion for the
    result type has taken a subtype to a supertype : the result type
    in <code>x</code> is said to be in &quot;covariant&quot; position.
    </p>
    <p>
    In the following, the type <code>&alpha; t</code> is abstract.
    </p><pre>
    # type &alpha; t;;
    # let f (x : [ `A ] t) = (x :&gt; [ `A | `B ] t);;
    Error: Type [ `A ] t is not a subtype of [ `A | `B ] t 
    </pre>
    Indeed, <code>[ `A ]</code> is a subtype of <code>[ `A | `B
    ]</code> but that, <i>a priori</i>, does not say anything about
    the subtyping relationship between <code>[ `A ] t</code>
    and <code>[ `A | `B ] t</code>. For this coercion to be legal, the
    parameter <code>&alpha;</code> must be given a covariant
    annotation:
    <pre>
    # type +&alpha; t;;
    # let f (x : [ `A ] t) = (x :&gt; [ `A | `B ] t);;
    val f : [ `A ] t &rarr; [ `A | `B ] t = &lt;fun&gt;
    </pre>
    The declaration <code>type +&alpha; t</code> declares that the
    abstract type is covariant in its parameter : if the type $\tau$
    is a subtype of $\sigma$, then $\tau\;t$ is a subtype of
    $\sigma\;t$. Here, $\tau = $<code>[ `A ]</code>, $\sigma =
    $<code>[ `A | `B ]</code>, $\tau$ is a subtype of $\sigma$
    and <code>[ `A ] t</code> is a subtype of <code>[ `A | `B]
    t</code>.
    
    <p>
    Here is a similar example, but this time, in the other direction.
    </p><pre>
    # type &alpha; t;;
    # let f (x : [ `A | `B ] t) = (x :&gt; [ `A ] t);;
    Error: This expression cannot be coerced to type [ `A ] t
    </pre>
    The type variable can be annotated as contravariant however, and
    the coercion function typechecks.
    <pre>
    # type -&alpha; t;;
    # let f (x : [`A | `B] t) = (x :&gt; [ `A ] t);;
    val f : [ `A | `B ] t &rarr; [ `A ] t = &lt;fun&gt;
    </pre>
    The declaration <code>type -&alpha; t</code> declares that the abstract
    type <code>t</code> is contravariant in its parameter : if $\tau$
    is a subtype of $\sigma$ then $\sigma\;t$ is a subtype of
    $\tau\;t$. In this example, $\tau = $<code>[ `A ]</code> and
    $\sigma = $<code>[`A | `B]</code>, $\tau$ is a subtype of $\sigma$
    and
    <code>[ `A | `B ] t</code> is a subtype of <code>[ `A ] t</code>.
    
    <p>
    In the following, <code>type &alpha; t</code> is <b>not</b>
    abstract and variance can be inferred.
    </p><pre>
    # type &alpha; t = {x : &alpha;} ;;
    # let f x = (x : [`A] t :&gt; [`A | `B] t);;
    val f : [ `A ] t &rarr; [ `A | `B ] t = &lt;fun&gt;
    </pre>
    Introducing a constraint however inhibits variance inference.
    <pre>
    # type &alpha; t = {x : &alpha;} constraint &alpha; = [&lt; `A | `B ];;
    # let f x = (x : [ `A ] t :&gt; [ `A | `B ] t);;
    Error: Type [ `A ] t is not a subtype of [ `A | `B ] t 
    </pre>
    This situation can be overcome by introducing a covariance
    annotation.
    <pre>
    # type +&alpha; t = {x : &alpha;} constraint &alpha; = [&lt; `A | `B ];;
    # let f x = (x : [ `A ] t :&gt; [ `A | `B ] t);;
    val f : [ `A ] t &rarr; [ `A | `B ] t = &lt;fun&gt;
    </pre>
    In the following example, <code>&alpha;</code> does not
    participate in the definition of <code>type &alpha; t</code>.
    <pre>
    # type &alpha; t = {x : int};;
    # let f x = (x : [ `A ] t :&gt; [ `B ] t);;
    val f : [ `A ] t &rarr; [ `B ] t = &lt;fun&gt;
    </pre>
    In this case, any conversion between <code>&delta; t</code>
    and <code>&epsilon; t</code> is legal : the
    types <code>&delta;</code> and <code>&epsilon;</code> are not
    required to have a subtyping relation between them.
    
   <hr/>
  </body>
</html>

