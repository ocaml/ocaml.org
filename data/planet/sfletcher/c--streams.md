---
title: 'C++ : Streams'
description: In this blog post , types and functions were presented in OCaml for modeling
  streams. This post takes the action to C++.   First, the type...
url: http://blog.shaynefletcher.org/2016/04/streams-in-c.html
date: 2016-04-03T15:00:00-00:00
preview_image:
featured:
authors:
- Shayne Fletcher
---

<h2></h2>
<p>
In <a href="http://blog.shaynefletcher.org/2016/04/rotate.html">this blog post</a>, types and functions were presented in OCaml for modeling streams. This post takes the action to C++.
</p>
<p>
First, the type definition for a stream.
</p><pre class="prettyprint c++">
struct Nil {};
template &lt;class T&gt; class Cons;

template &lt;class T&gt;
using stream = sum_type &lt;
    Nil
  , recursive_wrapper&lt;Cons&lt;T&gt;&gt;
&gt;;
</pre>
The definition is in terms of the <code>sum_type&lt;&gt;</code> type from the &quot;pretty good sum&quot; library talked about <a href="http://blog.shaynefletcher.org/2015/11/c-sums-with-constructors.html">here</a>.

<p>The definition of <code>Cons&lt;&gt;</code>, will be in terms of &quot;thunks&quot; (suspensions). They're modeled as procedures that when evaluated, compute streams.
</p><pre class="prettyprint c++">
template &lt;class T&gt;
using stream_thunk = std::function&lt;stream&lt;T&gt;()&gt;;
</pre>
To complete the abstraction, a function that given a suspension, &quot;thaws&quot; it.
<pre class="prettyprint c++">
template &lt;class T&gt; inline 
stream&lt;T&gt; force (stream_thunk&lt;T&gt; const&amp; s) { 
  return s (); 
}
</pre>
<p>
The above choices made, here is the definition for <code>Cons&lt;&gt;</code>.
</p><pre class="prettyprint c++">
template &lt;class T&gt;
class Cons {
public:
  using value_type = T;
  using reference = value_type&amp;;
  using const_reference = value_type const&amp;;
  using stream_type = stream&lt;value_type&gt;;

private:
  using stream_thunk_type = stream_thunk&lt;value_type&gt;;

public:
  template &lt;class U, class V&gt;
  Cons (U&amp;&amp; h, V&amp;&amp; t) : 
    h {std::forward&lt;U&gt; (h)}, t {std::forward&lt;V&gt; (t)}
  {}

  const_reference hd () const { return h; }
  stream_type tl () const { return force (t); }

private:
  value_type h;
  stream_thunk_type t;
};
</pre>

<p>
Next, utility functions for working with streams.
</p>
<p>
The function <code>hd ()</code> gets the head of a stream and <code>tl ()</code> gets the stream that remains when the head is stripped off.
</p><pre class="prettyprint c++">
template &lt;class T&gt;
T const hd (stream&lt;T&gt; const&amp; s) {
  return s.template match&lt;T const&amp;&gt; (
      [](Cons&lt;T&gt; const&amp; l) -&gt; T const&amp; { return l.hd (); }
    , [](otherwise) -&gt; T const &amp; { throw std::runtime_error { &quot;hd&quot; }; }
  );
}

template &lt;class T&gt;
stream&lt;T&gt; tl (stream&lt;T&gt; const&amp; l) {
  return l.template match &lt;stream&lt;T&gt;&gt; (
    [] (Cons&lt;T&gt; const&amp; s) -&gt; stream &lt;T&gt; { return s.tl (); }
  , [] (otherwise) -&gt; stream&lt;T&gt; { throw std::runtime_error{&quot;tl&quot;}; }
  );
}
</pre>
 
<p>
The function <code>take ()</code> returns the the first $n$ values of a stream.
</p><pre class="prettyprint c++">
template &lt;class T, class D&gt;
D take (unsigned int n, stream &lt;T&gt; const&amp; s, D dst) {
  return (n == 0) ? dst :
    s.template match&lt;D&gt;(
       [&amp;](Nil const&amp; _) -&gt; D { return  dst; },
       [&amp;](Cons&lt;T&gt; const&amp; l) -&gt; D { 
         return take (n - 1, l.tl (), *dst++ = l.hd ()); }
    );
}
</pre>
<p>
It's time to share a little &quot;hack&quot; I picked up for writing infinite lists.
</p><ul>
<li>To start, forget about streams;</li>
<li>Write your list using regular lists;</li>
<li>Ignore the fact that it won't terminate;</li>
<li>Rewrite in terms of Cons and convert the tail to a thunk.</li>
</ul>

<p>
For example, in OCaml the (non-terminating!) code
</p><pre>
  let naturals = 
    let rec loop x = x :: loop (x + 1) in
  next 0
</pre>
leads to this definition of the stream of natural numbers.
<pre class="prettyprint ml">
let naturals =
 let rec loop x = Cons (x, lazy (loop (x + 1))) in
loop 0
</pre>

<p>
Putting the above to work, a generator for the stream of natural numbers can be written like this.
</p><pre class="prettyprint c++">
class natural_numbers_gen {
private:
  using int_stream = stream&lt;int&gt;;
    
private:
  int start;

private:
  int_stream from (int x) const {
    return int_stream{
      constructor&lt;Cons&lt;int&gt;&gt;{}, x, [=]() { return this-&gt;from (x + 1); }
    };
  }
  
public:
  explicit natural_numbers_gen (int start) : start (start) 
  {}

  explicit operator int_stream() const { return from (start); }
};
</pre>
The first $10$ (say) natural numbers can then be harvested like this.
<pre class="prettyprint c++">
std::vector&lt;int&gt; s;
take (10, stream&lt;int&gt; (natural_numbers_gen{0}), std::back_inserter (s));
</pre>

<p>
The last example, a generator of the Fibonacci sequence. Applying the hack, start with the following OCaml code.
</p><pre>
  let fibonacci_numbers = 
    let rec fib a b = a :: fib b (a + b) in
    fib 0 1
</pre>
The rewrite of this code into streams then leads to this definition.
<pre class="prettyprint ml">
let fibonnaci_sequence = 
  let rec fib a b = Cons (a, lazy (fib b (a + b))) in
fib 0 1
</pre>
Finally, casting the above function into C++ yields the following.
<pre class="prettyprint c++">
class fibonacci_numbers_gen {
private:
  using int_stream = stream&lt;int&gt;;
    
private:
  int start;

private:
  int_stream loop (int a, int b) const {
    return int_stream{
      constructor&lt;Cons&lt;int&gt;&gt;{}, a, [=]() {return this-&gt;loop (b, a + b); }
    };
  }
    
public:
  explicit fibonacci_numbers_gen () 
  {}

  explicit operator int_stream() const { return loop (0, 1); }
  };
</pre>


