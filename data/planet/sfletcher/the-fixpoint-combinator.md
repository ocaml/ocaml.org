---
title: The fixpoint combinator
description: Consider the following recursive definition of the factorial         function.          \[              FAC
  = \lambda n.\;IF \left(=\;n...
url: http://blog.shaynefletcher.org/2016/09/the-fixpoint-combinator.html
date: 2016-09-27T15:38:00-00:00
preview_image:
featured:
authors:
- Shayne Fletcher
---

    <p> Consider the following recursive definition of the factorial
        function. 
        \[ 
            FAC = \lambda n.\;IF \left(=\;n\;0\right)\;1\;\left(*\;n\;\left(FAC\;\left(-\;n\;1\right)\right)\right) \nonumber
        \] 

       The definition relies on the ability to name a $\lambda$-abstraction
        and then to refer to this name inside the
        $\lambda$-abstraction itself. No such facility is provided by
        the $\lambda$-calculus. $\beta$-abstraction is applying
        $\beta$-reduction backwards to introduce new
        $\lambda$-abstractions, thus $+\;4\;1\leftarrow \left(\lambda
        x.\;+\;x\;1\right)\; 4$. By $\beta$-abstraction on $FAC$, its
        definition can be written 

        \[ 
          FAC = \left(\lambda fac.\;\left(\lambda  n.\;IF\left(=\;n\;0\right)\;1\;\left(*\;n\;\left(fac\;\left(-\;n\;1\right)\right)\right)\right)\right) FAC \nonumber
        \] 

         This definition has taken the form $FAC = g\;FAC$ where $g =
        \left(\lambda fac.\;\left(\lambda
        n.\;IF\left(=\;n\;0\right)\;1\;\left(*\;n\;\left(fac\;\left(-\;n\;1\right)\right)\right)\right)\right)$
        is without recursion. We see also that $FAC$ is a fixed point
        (&quot;fixpoint&quot;) of $g$. It is clear this fixed point can only
        depend on $g$ so supposing there were a function $Y$ which
        takes a function and delivers a fixpoint of the function as
        the result, we'd have $FAC = Y\;g = g\;(Y\;g)$. Under the
        assumption such a function exists, in order to build
        confidence this definition of $FAC$ works, we will try to
        compute $FAC\;1$. Recall

        \[
          \begin{eqnarray}
           &amp;FAC&amp; = Y\;g \nonumber \\
           &amp;g&amp; = \lambda fac.\;\left(\lambda n.\;IF\left(=\;n\;0\right)\;1\;\left(*\;n\;\left(fac\;\left(-\;n\;1\right)\right)\right)\right) \nonumber
          \end{eqnarray}
        \]

        So,

        \[
          \begin{eqnarray}
            FAC\;1 &amp;\rightarrow&amp; (Y\;g)\; 1 \nonumber \\
                   &amp;\rightarrow&amp; (g\;(Y\;g))\;1 \nonumber \\
                   &amp;\rightarrow&amp; (\left(\lambda fac.\;\left(\lambda n.\;IF\left(=\;n\;0\right)\;1\;\left(*\;n\;\left(fac\;\left(-\;n\;1\right)\right)\right)\right)\right) (Y\;g))\; 1 \nonumber \\
                   &amp;\rightarrow&amp; \left(\lambda n.\;IF\left(=\;n\;0\right)\;1\;\left(*\;n\;\left(\left(Y\;g\right)\;\left(-\;n\;1\right)\right)\right)\right)\; 1 \nonumber \\
                   &amp;\rightarrow&amp; *\;1\;\left(\left(Y\;g\right)\;0\right) \nonumber \\
                   &amp;\rightarrow&amp; *\;1\;\left(\left(g\;\left(Y\;g\right)\right)\;0\right) \nonumber \\
                   &amp;\rightarrow&amp; *\;1\;\left(\left(\left(\lambda fac.\;\left(\lambda n.\;IF\left(=\;n\;0\right)\;1\;\left(*\;n\;\left(fac\;\left(-\;n\;1\right)\right)\right)\right)\right)\;\left(Y\;g\right)\right)\;0\right) \nonumber \\
                   &amp;\rightarrow&amp; *\;1\;\left(\left(\lambda n.\;IF\left(=\;n\;0\right)\;1\;\left(*\;n\;\left(\left(Y\;g\right)\;\left(-\;n\;1\right)\right)\right)\right)\;0\right) \nonumber \\
                   &amp;\rightarrow&amp; *\;1\;1 \nonumber \\
                   &amp;=&amp; 1 \nonumber
          \end{eqnarray}
         \]

    </p>

    <p>The $Y$ combinator of the $\lambda$-calculus is defined as the
        $\lambda$-term $Y = \lambda f.\;\left(\lambda
        x.\;f\;\left(x\;x\right)\right)\left(\lambda
        x.\;f\;\left(x\;x\right)\right)$.  $\beta$ reduction of this
        term applied to an arbitrary function $g$ proceeds like this:

        \[
          \begin{eqnarray} 
             Y\;g &amp;\rightarrow&amp; \left(\lambda f.\;\left(\lambda x.\;f\;\left(x\;x\right)\right) \left(\lambda x.\;f\;\left(x\;x\right)\right)\right)\;g  \nonumber \\
                  &amp;\rightarrow&amp; \left(\lambda x.\;g\;\left(x\;x\right)\right) \left(\lambda x.\;g\;\left(x\;x\right)\right) \nonumber \\ 
                  &amp;\rightarrow&amp; g\;\left(\left(\lambda x.\;g\;\left(x\;x\right)\right)\;\left(\lambda  x.\;g\;\left(x\;x\right)\right)\right) \nonumber \\
                  &amp;=&amp; g\;\left(Y\;g\right) 
           \end{eqnarray} 
         \]

        The application of this term has produced a fixpoint of
        $g$. That is, we are satisfied that this term will serve as a
        definition for $Y$ having the property we need and call it the
        &quot;fixpoint combinator&quot;.
    </p>

    <p>In the untyped $\lambda$-calculus, $Y$ can be defined and that
       is sufficient for expressing all the functions that can be
       computed without having to add a special construction to get
       recursive functions. In typed $\lambda$-calculus, $Y$ cannot be
       defined as the term $\lambda x.\;f\;(x\;x)$ does not have a
       finite type. Thus, when implementing recursion in a functional
       programming language it is usual to implement $Y$ as a built-in
       function with the reduction rule $Y\;g \rightarrow g\;(Y\;g)$
       or, in a strict language, $(Y\; g)\;x \rightarrow
       (g\;(Y\;g))\;x$ to avoid infinite recursion.
    </p>

    <p>For an OCaml like language, the idea then is to introduce a
       built-in constant $\mathbf{Y}$ and to denote the function
       defined by $\mathbf{let\;rec}\;f\;x = e$ as
       $\mathbf{Y}(\mathbf{fun}\;f\;x \rightarrow e)$. Intuitivly,
       $\mathbf{Y}$ is a fixpoint operator that associates a
       functional $F$ of type $\alpha \rightarrow \beta$ with a fixpoint $Y(F)$
       of type $\alpha \rightarrow \beta \rightarrow \alpha$, that is, a value having the property
       $\mathbf{Y}\;F = F\;\left(\mathbf{Y}\;F\right)$. The relevant
       deduction rules involving this constant are:

      \[
        \begin{equation}
          \frac{\vdash f\;(Y\;f)\;x \Rightarrow v}
            {\vdash (Y\;f)\;x \Rightarrow v} \tag{App-rec}
        \end{equation}
      \]

      \[
        \begin{equation}
          \frac{\vdash e_{2}\left[Y(\mathbf{fun}\;f\;x \rightarrow e_{1})/f\right] \Rightarrow v}
           {\vdash \mathbf{let\;rec}\;f\;x=e_{1}\;\mathbf{in}\;e_{2} \Rightarrow v} \nonumber \tag {Let-rec} 
        \end{equation}
      \]
    </p>
    <hr/>
    <p>
      References:<br/>
      [1] <cite>The Implementation of Functional Programming Languages</cite>,Simon Peyton Jones, 1987.<br/>
      [2] <cite>The Functional Approach to Programming</cite>, Guy Cousineau, Michel Mauny, 1998.
    </p>


