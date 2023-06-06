---
title: 'Conversion operations of the lambda-calculus '
description: Conversion            Abstract           This note provides a super lightweight
  explanation of the three     conversion ...
url: http://blog.shaynefletcher.org/2016/10/conversion-operations-of-lambda-calculus.html
date: 2016-10-05T20:27:00-00:00
preview_image:
featured:
authors:
- Shayne Fletcher
---


<html>
  <head>
     
    
    <title>Conversion</title>
  </head>
  <body>
    <h4>Abstract</h4>
    <p>
    This note provides a super lightweight explanation of the three
    conversion operations of the $\lambda$-calculus known
    (cryptically) as $\alpha$, $\beta$ and $\eta$ conversions
    respectively (borrowed fairly freely from the delightful reference
    given at the bottom.)
    </p>

    <h4>Syntax vs. semantics</h4>
    <p>
      The $\textbf{syntax}$ of the language of $\textit{$\lambda$-
      expressions}$ is
      \[
      \begin{eqnarray}
      &lt;exp&gt; &amp; ::= &amp; &lt;constant&gt;\;\; &amp; \text{Constants} \nonumber \\
                  &amp; \mid &amp; &lt;variable&gt;\;\; &amp; \text{Variables} \nonumber \\
                  &amp; \mid &amp; &lt;exp&gt; &lt;exp&gt;\;\; &amp; \text{Applications} \nonumber \\
                  &amp; \mid &amp; \lambda&lt;variable&gt;.&lt;exp&gt;\;\; &amp; \text{Abstractions} \nonumber
      \end{eqnarray}
      \]
    The $\textbf{semantics}$ of the the $\lambda$-calculus is defined
    by three $\textit{conversion rules}$. To understand them 
    requires the terminology of $\textit{free}$ and
    $\textit{bound}$ variables. An occurence of a variable in a
    $\lambda$-expression is bound if there is an enclosing abstraction
    that binds it, and is free otherwise. For example, in $\lambda x.+\;
    ((\lambda y. +\;y\; z)\;7)\;x$, $x$ and $y$ appear bound whereas $z$
    appears free.
    </p>

    <h4>$\beta$-conversion</h4>
    <p>
      $\beta$-reduction describes how to apply a function to an
      argument. For example, $\left(\lambda x.+\;x\;1\right)\; 4$
      denotes the application of a particular $\lambda$-abstraction to
      the argument $4$. The result of applying a $\lambda$-abstraction
      to an argument is an instance of the body of the
      $\lambda$-abstraction in which (free) occurences of the formal
      parameter in the body are replaced with (copies of) the
      argument. Thus, $\left(\lambda x.+\;x\;1\right)\; 4 \rightarrow
      +\;4\;1 \rightarrow 5$. In the event there are no occurences of
      the formal parameter in the abstraction body, the argument is
      discarded unused so, $(\lambda x.\;3)\;4 \rightarrow 3$. Care is
      needed when formal parameter names are not unique. For example,

      \[
      \begin{eqnarray}
      &amp; &amp; \left(\lambda x.\;\left(\lambda x.+ \left(-\;x\;1\right)\right)\;x\;3\right)\; 9 \nonumber \\
      &amp; \rightarrow &amp; \left(\lambda x.+ \left(-\;x\;1\right)\right)\;9\;3 \nonumber \\
      &amp; \rightarrow &amp; +\;\left(-\;9\;1\right)\;3 \nonumber \\
      &amp; \rightarrow &amp; +\;8\;3 \nonumber \\
      &amp; \rightarrow &amp; 11 \nonumber
      \end{eqnarray}
      \]

      The key point of that example is that we did not substitue for
      the inner $x$ in the first reduction because it was not free in
      the body of the outer $\lambda x$ abstraction. Indeed, in the
      OCaml top-level we observe
      </p><pre>
       # (fun x -&gt; (fun x -&gt; ( + ) (( - ) x 1)) x 3) 9 ;;
       - : int = 11
      </pre>
      or equivalently, in C++,
      <pre>
      auto add = [](int x) { return [=](int y) { return x + y; }; };
      auto sub = [](int x) { return [=](int y) { return x - y; }; };
      [=](int x) { 
        return [=](int x) {
          return add (sub (x) (1)); 
          } (x) (3); 
      } (9) ; //is the value '11'
      </pre>

    The $\beta$-rule applied backwards is called $\beta$-abstraction
    and written with a backwards reduction arrow '$\leftarrow$'. Thus,
    $+\;4\;1 \leftarrow (\lambda x.\;+\;1\;x)\;4$. $\beta$-conversion
    means reduction or abstraction and is written with a double-ended
    arrow augmented with a $\beta$ (in order to distinguish it from
    other forms of conversion). So, $+\;4\;1
    \underset{\beta}{\leftrightarrow} (\lambda x.\;+\;1\;x)\;4$.  One
    way to look at $\beta$ conversion is that it is saying something
    about $\lambda$-expressions that look different but mean the same
    thing.
    

    <h4>$\alpha$-conversion</h4>
    <p>
    It seems obvious that the two abstractions $\lambda x.+\;x\;1$ and
    $\lambda y.+\;y\;1$ &quot;ought&quot; to be equivalent. $\alpha$-conversion
    allows us to change the name of a formal parameter as long as it
    is done consistently. So we write $\lambda x.+\;x\;1
    \underset{\alpha}{\leftrightarrow} \lambda y.+\;y\;1$. Of course,
    the newly introduced name must not occur free in the body of the
    original $\lambda$-abstraction.
    </p>

    <h4>$\eta$-conversion</h4>
    <p>
      This last conversion rule exists to to complete our intuition
      about what $\lambda$-abstractions &quot;ought&quot; to be equivalent. The
      rule is this : If $f$ denotes a function, $x$ a variable that
      does not occur free in $f$, then $\lambda x.f\;x
      \underset{\eta}{\leftrightarrow} f$. For example, in OCaml if we
      define <code>f</code> by
      <code>let f x = x + 1</code> then clearly 
      <code>fun x -&gt; f x</code> produces the same results for
      all values <code>x</code> in the domain of <code>f</code>.
    </p>

    <h4>Summary</h4>
    <p>
    The first section provides a set of formal rules for constructing
    expressions (the BNF grammar). Using the notation
    $E\;\left[M/x\right]$ to mean the expression $E$ with $M$
    substituted for free occurrences of $x$ we can succintly state the
    the rules for converting one expression into an equivalent one as
    \[
    \begin{eqnarray}
    x\;\left[M/x\right] &amp; = &amp; M \nonumber \\
    c\;\left[M/x\right] &amp; = &amp; c\;\;\text{where $c$ is any variable or constant other than $x$} \nonumber  \\
    \left(E\;F\right)\;\left[M/x\right] &amp; = &amp; E\left[M/x\right]\; F\left[M/x\right]\; \nonumber \\
    \left(\lambda x.E\right)\;\left[M/x\right] &amp; = &amp; \lambda x.E \nonumber \\
    \left(\lambda y.E\right)\;\left[M/x\right] &amp;   &amp; \text{where $y$ is any variable other than $x$} \nonumber \\
                                               &amp; = &amp; \lambda y.E\left[M/x\right]\;\text{if $x$ does not occur free in E or $y$ does not occur free in $M$} \nonumber \\
                                               &amp; = &amp; \lambda z.\left(E\left[z/y\right]\right)\left[M/x\right]\;\text{otherwise}\nonumber \\

    \end{eqnarray}
    \]
    </p>
    <hr/>
    <p>
      References:<br/>
      [1] <cite>The Implementation of Functional Programming Languages</cite> by Simon L. Peyton Jones. 1987.</p>
    
  </body>
</html>

