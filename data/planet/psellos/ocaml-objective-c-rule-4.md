---
title: OCaml, Objective C, Rule 4
description:
url: http://psellos.com/2014/12/2014.12.objc-rule-four.html
date: 2014-12-04T19:00:00-00:00
preview_image:
featured:
authors:
- Psellos
---

<div class="date">December 4, 2014</div>

<p>I recently spent some time tracking down another problem in an OCaml iOS
app. The symptom was that the app would work fine for 5 minutes and 50
seconds, then would crash. The app, named Portland, is very simple; its
only input is a periodic categorization of the spatial orientation of the
phone. The timing of the crash was quite consistent.</p>

<p>It turns out that the same problem can be demonstrated in OS X. At the
risk of revealing just how many errors I make in coding, I thought I&rsquo;d
write up this example also. I can imagine that somebody else might see
the problem some day.</p>

<p>Even an OCaml iOS app will have some parts written in Objective C. The
error showed up because I wanted to have a table in Objective C holding
some OCaml values. I made a tiny example that shows the problem in OS X.
Here is the table in Objective C (<code>table.m</code>):</p>

<pre><code>#include &lt;Foundation/Foundation.h&gt;

#include &quot;caml/memory.h&quot;
#include &quot;caml/alloc.h&quot;

static NSMutableDictionary *g_dict = nil;

static NSString *NSString_val(value sval)
{
    return [NSString stringWithCString: String_val(sval)
                              encoding: NSUTF8StringEncoding];
}

value table_add(value k, value v)
{
    CAMLparam2(k, v);

    if (g_dict == nil)
        g_dict = [NSMutableDictionary dictionary];

    NSNumber *val = [NSNumber numberWithLong: v];
    [g_dict setObject: val forKey: NSString_val(k)];
    CAMLreturn(Val_unit);
}

value table_lookup(value k)
{
    CAMLparam1(k);
    CAMLlocal1(some);

    NSNumber *val;
    if ((val = [g_dict objectForKey: NSString_val(k)]) != nil) {
        some = caml_alloc_tuple(1);
        Store_field(some, 0, [val longValue]);
        CAMLreturn(some);
    }
    CAMLreturn(Val_int(0)); /* None */
}</code></pre>

<p>The table associates a string with an OCaml value. You have to imagine
that I have some reason to retrieve the OCaml value for a string in the
Objective C code. But for this example I&rsquo;ll look up values from OCaml
using <code>table_lookup()</code>.</p>

<p>The OCaml main program looks like this (<code>r4.ml</code>):</p>

<pre><code>external table_add : string -&gt; int list -&gt; unit = &quot;table_add&quot;
external table_lookup : string -&gt; int list option = &quot;table_lookup&quot;

let rec replicate n x = if n &lt;= 0 then [] else x :: replicate (n - 1) x

let rec check iter =
    (* Keep checking whether the &quot;four&quot; entry looks right. If not,
     * return the iteration number where it fails.
     *)
    if iter mod 1000000 = 0 then
        Printf.printf &quot;iteration %d\n%!&quot; iter;
    match table_lookup &quot;four&quot; with
    | Some [_; _; _; _] -&gt; check (iter + 1)
    | _ -&gt; iter

let main () =
    table_add &quot;three&quot; (replicate 3 1);
    table_add &quot;four&quot; (replicate 4 1);
    let failed_iter = check 1 in
    Printf.printf &quot;failed at iteration %d\n&quot; failed_iter

let () = main ()</code></pre>

<p>The program creates two entries in the table. The value for <code>&quot;four&quot;</code> is
the list <code>[1; 1; 1; 1]</code>. Then&mdash;and you know this means something is very
wrong&mdash;it fetches the value for <code>&quot;four&quot;</code> repeatedly and checks that it
has the correct length.</p>

<p>If you compile this and run it on OS X a couple of times, you see the
following:</p>

<pre><code>$ uname -rs
Darwin 13.3.0
$ cc -I /usr/local/lib/ocaml -c table.m
$ ocamlopt -o r4 -cclib '-framework Foundation' r4.ml table.o
$ r4
failed at iteration 131067
$ r4
failed at iteration 131067</code></pre>

<p>So, at iteration 131067 the length of the list for <code>&quot;four&quot;</code> changes to
something other than 4. The first 131066 iterations correspond to the 5
minutes 50 seconds when my iOS app worked fine. Then things go wrong.
Note that 131067 is suspiciously close to a power of 2.</p>

<p>You, reader, are possibly way ahead of me and already see what&rsquo;s wrong.
But what I did was work through the problem carefully with lldb.
Eventually I figured out that I had broken Rule 4:</p>

<blockquote>
  <p><strong>Rule 4</strong> <em>Global variables containing values must be registered with the
  garbage collector using the</em> <code>caml_register_global_root</code> <em>function.</em></p>
</blockquote>

<p>In retrospect this is obvious. OCaml values are subject to change at
every allocation. But they can&rsquo;t change if the GC can&rsquo;t find them, so
they need to be registered. The values in the table aren&rsquo;t registered,
so they become invalid at the first GC. You can find Rule 4 and the
Other Rules here:</p>

<blockquote>
  <p><a href="http://caml.inria.fr/pub/docs/manual-ocaml/intfc.html#sec440">Living in harmony with the garbage collector</a></p>
</blockquote>

<p>One reason it was difficult to code this correctly is that the
<code>NSNumber</code> wrapper class doesn&rsquo;t have an interface for getting a pointer
to the wrapped-up number. I thought about this for a while and ended up
doing the following (corrected <code>table.m</code>):</p>

<pre><code>#include &lt;Foundation/Foundation.h&gt;

#include &quot;caml/memory.h&quot;
#include &quot;caml/alloc.h&quot;

static NSMutableDictionary *g_dict = nil;

static NSString *NSString_val(value sval)
{
    return [NSString stringWithCString: String_val(sval)
                              encoding: NSUTF8StringEncoding];
}

value table_add(value k, value v)
{
    CAMLparam2(k, v);

    if (g_dict == nil)
        g_dict = [NSMutableDictionary dictionary];

    value *vp = malloc(sizeof *vp);
    if (vp == NULL)
        CAMLreturn(Val_unit); /* No memory for adding to table */
    *vp = v;
    caml_register_global_root(vp);
    NSValue *val = [NSValue valueWithPointer: vp];
    [g_dict setObject: val forKey: NSString_val(k)];
    CAMLreturn(Val_unit);
}

value table_lookup(value k)
{
    CAMLparam1(k);
    CAMLlocal1(some);

    NSValue *val;
    if ((val = [g_dict objectForKey: NSString_val(k)]) != nil) {
        some = caml_alloc_tuple(1);
        Store_field(some, 0, * (value *) [val pointerValue]);
        CAMLreturn(some);
    }
    CAMLreturn(Val_int(0)); /* None */
}</code></pre>

<p>Since I can&rsquo;t get pointers to wrapped up values, I make pointers myself
and wrap <em>them</em>.</p>

<p>If you compile and run this corrected version, it looks like this:</p>

<pre><code>$ cc -I /usr/local/lib/ocaml -c table.m
$ ocamlopt -o r4 -cclib '-framework Foundation' r4.ml table.o
$ r4 | head -12
iteration 1000000
iteration 2000000
iteration 3000000
iteration 4000000
iteration 5000000
iteration 6000000
iteration 7000000
iteration 8000000
iteration 9000000
iteration 10000000
iteration 11000000
iteration 12000000</code></pre>

<p>I have every reason to believe the corrected iOS app will run until the
cows come home 12,000,000 times.</p>

<p>I hope this may help some other lonely OCaml developer who sees a crash
after 5 minutes 50 seconds. May we all live in harmony. If you have any
comments or sympathy, leave them below or email me at
<a href="mailto:jeffsco@psellos.com">jeffsco@psellos.com</a>.</p>

<p>Posted by: <a href="http://psellos.com/aboutus.html#jeffreya.scofieldphd">Jeffrey</a></p>

<p></p>

