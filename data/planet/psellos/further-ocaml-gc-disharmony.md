---
title: Further OCaml GC Disharmony
description:
url: http://psellos.com/2015/01/2015.01.gc-disharmony-bis.html
date: 2015-01-25T19:00:00-00:00
preview_image:
featured:
authors:
- Psellos
---

<div class="date">January 25, 2015</div>

<p>While working on an OCaml app to run in the iPhone Simulator, I
discovered another wrapper code construct that looks plausible but is
incorrect. I was able to reproduce the error in a small example under OS
X, so I am writing it up for the record.</p>

<p>The error is in code that calls from Objective C into OCaml. In an OCaml
iOS app these calls happen all the time, since events originate in iOS.
You can imagine events being formed originally from an Objective C-like
substance, then being remanufactured into an OCaml material and passed
through the interface.</p>

<p>As a teensy example, assume that you want to create a point and a
rectangle in C and pass them to a function in OCaml. To make it
interesting, assume that you want to count the fraction of time a
rectangle with randomly chosen origin and size (uniform values in [0,
1]) contains the point (0.5, 0.5).</p>

<p>Here is some C code that does this (r4b.c):</p>

<pre><code>#include &lt;stdio.h&gt;
#include &lt;stdlib.h&gt;
#include &lt;limits.h&gt;

#define CAML_NAME_SPACE
#include &quot;caml/memory.h&quot;
#include &quot;caml/alloc.h&quot;
#include &quot;caml/callback.h&quot;

double dran()
{
    static unsigned long state = 72;
    state = state * 6364136223846793005L + 1442695040888963407L;
    return (double) state / (double) ULONG_MAX;
}

static value Val_point(double x, double y)
{
    CAMLparam0();
    CAMLlocal3(point, fx, fy);
    point = caml_alloc(2, 0);
    fx = caml_copy_double(x);
    fy = caml_copy_double(y);
    Store_field(point, 0, fx);
    Store_field(point, 1, fy);
    CAMLreturn(point);
}

static value ran_rect()
{
    CAMLparam0();
    CAMLlocal5(rect, fx, fy, fwd, fht);
    rect = caml_alloc(4, 0);
    fx = caml_copy_double(dran());
    fy = caml_copy_double(dran());
    fwd = caml_copy_double(dran());
    fht = caml_copy_double(dran());
    Store_field(rect, 0, fx);
    Store_field(rect, 1, fy);
    Store_field(rect, 2, fwd);
    Store_field(rect, 3, fht);
    CAMLreturn(rect);
}

int main(int ac, char *av[])
{
    CAMLparam0();
    int ct, i;
    CAMLlocal2(point, isinside);
    value *inside;

    caml_main(av);

    point = Val_point(0.5, 0.5);
    inside = caml_named_value(&quot;inside&quot;);

    ct = 0;
    for (i = 0; i &lt; 1000000000; i++) {
        isinside = caml_callback2(*inside, point, ran_rect());
        if (Bool_val(isinside))
            ct++;
    }
    printf(&quot;%d (%f)\n&quot;, ct, (double) ct / (double) 1000000000);
    CAMLreturnT(int, 0);
}</code></pre>

<p>This OCaml code tests whether the point is inside the rectangle
(inside.ml):</p>

<pre><code>let inside (px, py) (x, y, w, h) =
    px &gt;= x &amp;&amp; px &lt;= x +. w &amp;&amp; py &gt;= y &amp;&amp; py &lt;= y +. h

let () = Callback.register &quot;inside&quot; inside</code></pre>

<p>The basic idea is sound, but if you build and run this code in OS X you
see the following:</p>

<pre><code>$ ocamlopt -output-obj -o inside.o inside.ml
$ W=`ocamlopt -where`; clang -I $W -L $W -o r4b r4b.c inside.o -lasmrun
$ r4b
Segmentation fault: 11</code></pre>

<p>You, reader, are probably way ahead of me as usual, but the problem is
in this line:</p>

<pre><code>isinside = caml_callback2(*inside, point, ran_rect());</code></pre>

<p>The problem is that <code>ran_rect()</code> allocates OCaml memory to hold the
rectangle and its float values. Every once in a while, this will cause a
garbage collection. If the OCaml value for <code>point</code> has already been
calculated and saved aside (i.e., if the parameters to <code>caml_callback2</code>
are evaluated left to right), this can cause the calculated value to
become invalid before the call happens. This will lead to trouble:
either a crash (as here) or, worse, the wrong answer.</p>

<p>The solution is to call <code>ran_rect()</code> beforehand:</p>

<pre><code>int main(int ac, char *av[])
{
    CAMLparam0();
    int ct, i;
    CAMLlocal3(point, rect, isinside);
    value *inside;

    caml_main(av);

    point = Val_point(0.5, 0.5);
    inside = caml_named_value(&quot;inside&quot;);

    ct = 0;
    for (i = 0; i &lt; 1000000000; i++) {
        rect = ran_rect();
        isinside = caml_callback2(*inside, point, rect);
        if (Bool_val(isinside))
            ct++;
    }
    printf(&quot;%d (%f)\n&quot;, ct, (double) ct / (double) 1000000000);
    CAMLreturnT(int, 0);
}</code></pre>

<p>This revised version works correctly:</p>

<pre><code>$ ocamlopt -output-obj -o inside.o inside.ml
$ W=`ocamlopt -where`; clang -I $W -L $W -o r4b r4b.c inside.o -lasmrun
$ r4b
140625030 (0.140625)</code></pre>

<p>(If my calculations are correct, the expected fraction is indeed 9/64,
or 0.140625.)</p>

<p>In retrospect the problem is obvious, but I&rsquo;ve wondered for years
whether this construct is OK. As far as I can tell it isn&rsquo;t
explicitly forbidden by any of the <a href="http://caml.inria.fr/pub/docs/manual-ocaml/intfc.html#sec440">GC Harmony Rules</a>. In
many ways, though, it&rsquo;s related to Rule 4: the calculated value to be
passed is like a global value, in that it&rsquo;s outside the reach of the
<code>CAMLlocal()</code> macros.</p>

<p>A good rule of thumb seems to be that you shouldn&rsquo;t write an expression
as an argument to a function if it can cause OCaml allocation. If
necessary, evaluate the expression before the call.</p>

<p>I hope this may help some other humble OCaml developer seeking to attune
his or her life with the Garbage Collector.  If you have any comments or
encouragement, leave them below or email me at <a href="mailto:jeffsco@psellos.com">jeffsco@psellos.com</a>.</p>

<p>Posted by: <a href="http://psellos.com/aboutus.html#jeffreya.scofieldphd">Jeffrey</a></p>

<p></p>

