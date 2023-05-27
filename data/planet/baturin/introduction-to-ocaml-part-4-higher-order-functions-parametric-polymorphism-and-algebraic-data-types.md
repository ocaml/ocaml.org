---
title: 'Introduction to OCaml, part 4: higher order functions, parametric polymorphism
  and algebraic data types'
description:
url: https://www.baturin.org/blog/introduction-to-ocaml-part-4-higher-order-functions-parametric-polymorphism-and-algebraic-data-types
date: 2018-08-12T00:00:00-00:00
preview_image:
featured:
authors:
- Daniil Baturin
---


    So far we have only worked with functions that take value of a single type known beforehand.
However, we have already seen functions whose types were left without explanation, such as
<code>let hello _ = print_endline &quot;hello world&quot;</code> that we used to demonstrate the wildcard pattern.
<br/>
What is its type? If you enter it into the REPL, you will see that it's <code>'a -&gt; unit</code>.
What does the mysterious 'a mean? Simply put, it's a placeholder for any type.
Essentially, a variable for types &mdash;a <em>type variable</em>.
    
