---
title: Sub-single-instruction Peano to machine integer conversion
description: It is a rainy end of January in Paris, morale is getting soggier by the
  day, and the bulk of our light exposure needs are now fulfilled by our computer
  screens as the sun seems to have definitively disappeared behind a continuous stream
  of low-hanging clouds. But, all is not lost, the warm rays of c...
url: https://ocamlpro.com/blog/2023_01_23_Pea_No_Op
date: 2023-01-23T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Arthur Carcano\n  "
source:
---

<p></p>
<p><img src="https://ocamlpro.com/blog/assets/img/forgive_me_father.png" alt=""/></p>
<p>It is a rainy end of January in Paris, morale is getting soggier by the day, and the bulk of our light exposure needs are now fulfilled by our computer screens as the sun seems to have definitively disappeared behind a continuous stream of low-hanging clouds. But, all is not lost, the warm rays of comradeship pierce through the bleak afternoons, and our joyful <a href="https://ocamlpro.com/team">party</a> of adventurers once again embarked on an adventure of curiosity and rabbit-hole depth-first-searching.</p>
<p>Last week's quest led us to a treasure coveted by a mere handful of enlightened connoisseurs, but a treasure of tremendous nerdy-beauty, known to the academics as &quot;Sub-single-instruction Peano to machine integer conversion&quot; and to the locals as &quot;How to count how many nested <code>Some</code> there are very very fast by leveraging druidic knowledge about unspecified, undocumented, and unstable behavior of the Rust compiler&quot;.</p>
<h1>Our quest begins</h1>
<p>Our whole quest started when we wanted to learn more about discriminant elision. Discriminant elision in Rust is part of what makes it practical to use <code>Option&lt;&amp;T&gt;</code> in place of <code>*const T</code>. More precisely it is what allows <code>Option&lt;&amp;T&gt;</code> to fit in as much memory as <code>*const T</code>, and not twice as much. To understand why, let's consider an <code>Option&lt;u64&gt;</code>. An <code>u64</code> is 8 bytes in size. An <code>Option&lt;u64&gt;</code> should have at least one more bit, to indicate whether it is a <code>None</code>, or a <code>Some</code>. But bits are not very practical to deal with for computers, and hence this <em>discriminant</em> value -- indicating which of the two variants (<code>Some</code> or <code>None</code>) the value is -- should take up at least one byte. Because of <a href="https://doc.rust-lang.org/reference/type-layout.html#the-default-representation">alignment requirements</a> (and because the size is always a multiple of the alignment) it actually ends up taking 8 bytes as well, so that the whole <code>Option&lt;u64&gt;</code> occupies twice the size of the wrapped <code>u64</code>.</p>
<p>In languages like C, it is very common to pass around pointers, and give them a specific meaning if they are null. Typically, a function like <a href="https://linux.die.net/man/3/lfind"><code>lfind</code></a> which searches for an element in a array will return a pointer to the matching element, and this pointer will be null if no such element was found. In Rust however fallibility is expected to be encoded in the type system. Hence, functions like <a href="https://doc.rust-lang.org/core/iter/trait.Iterator.html#method.find"><code>find</code></a> returns a reference, wrapped in a <code>Option</code>. Because this kind of API is so ubiquitous, it would have been a real hindrance to Rust adoption if it took twice as much space as the C version.</p>
<p>This is why discriminant elision exists. In our <code>Option&lt;&amp;T&gt;</code> example Rust can leverage the same logic as C: <code>&amp;T</code> references in Rust are guaranteed to be -- among other things -- non-null. Hence Rust can choose to encode the <code>None</code> variant as the null value of the variable. Transparently to the user, our <code>Option&lt;&amp;T&gt;</code> now fits on 8 bytes, the same size as a simple <code>&amp;T</code>. But Rust discriminant elision mechanism goes beyond <code>Option&lt;&amp;T&gt;</code> and works for any general type if:</p>
<ol>
<li>The option-like value has one fieldless variant and one single-field variant
</li>
<li>The wrapped type has so-called niche values, that is values that are statically known to never be valid for said type.
</li>
</ol>
<p>Discriminant elision remains under-specified, but more information can be found in the <a href="https://rust-lang.github.io/unsafe-code-guidelines/layout/enums.html#discriminant-elision-on-option-like-enums">FFI guidelines</a>. Note that other unspecified situations seem to benefit from niche optimization (e.g. <a href="https://github.com/rust-lang/rust/pull/94075/">PR#94075</a>).</p>
<h1>Too many options</h1>
<p>Out of curiosity, we wanted to investigate how the Rust compiler represents a series of nested <code>Option</code>. It turns out that up to 255 nested options can be stored into a byte, which is also the theoretical limit. Because this mechanism is not limited to <code>Option</code>, we can use it with (value-level) <a href="https://en.wikipedia.org/wiki/Peano_axioms">Peano integers</a>. Peano integers are a theoretical encoding of integer in &quot;unary base&quot;, but it is enough for this post to consider them a fun little gimmick. If you want to go further, know that Peano integers are more often used at the type-level, to try to emulate type-level arithmetic.</p>
<p>In our case, we are mostly interested in Peano-integers at the value level. We define them as follows:</p>
<pre><code class="language-rust">#![recursion_limit = &quot;512&quot;]
#![allow(dead_code)]

/// An empty enum, a type without inhabitants.
/// Cf: https://en.wikipedia.org/wiki/Bottom_type
enum Null {}

/// PeanoEncoder&lt;Null&gt; is a Peano-type able to represent integers up to 0.
/// If T is a Peano-type able to represent integers up to n
/// PeanoEncoder&lt;T&gt; is a Peano-type able to represent integers up to n+1
#[derive(Debug)]
enum PeanoEncoder&lt;T&gt; {
    Successor(T),
    Zero,
}

macro_rules! times2 {
    ($peano_2x:ident, $peano_x:ident ) =&gt; {
        type $peano_2x&lt;T&gt; = $peano_x&lt;$peano_x&lt;T&gt;&gt;;
    };
}
times2!(PeanoEncoder2, PeanoEncoder);
times2!(PeanoEncoder4, PeanoEncoder2);
times2!(PeanoEncoder8, PeanoEncoder4);
times2!(PeanoEncoder16, PeanoEncoder8);
times2!(PeanoEncoder32, PeanoEncoder16);
times2!(PeanoEncoder64, PeanoEncoder32);
times2!(PeanoEncoder128, PeanoEncoder64);
times2!(PeanoEncoder256, PeanoEncoder128);

type Peano0 = PeanoEncoder&lt;Null&gt;;
type Peano255 = PeanoEncoder256&lt;Null&gt;;
</code></pre>
<p>Note that we cannot simply go for</p>
<pre><code class="language-rust">enum Peano {
    Succesor(Peano),
    Zero,
}
</code></pre>
<p>like in <a href="https://wiki.haskell.org/Peano_numbers">Haskell</a> or OCaml because without indirection the type has <a href="https://doc.rust-lang.org/error_codes/E0072.html">infinite size</a>, and adding indirection would break discriminant elision. What we really have is that we are actually using a <em>type-level</em> Peano-encoding of integers to create a type <code>Peano256</code> that contains <em>value-level</em> Peano-encoding of integers up to 255, as a byte would.</p>
<p>We can define the typical recursive pattern matching based way of converting our Peano integer to a machine integer (a byte).</p>
<pre><code class="language-rust">trait IntoU8 {
    fn into_u8(self) -&gt; u8;
}

impl IntoU8 for Null {
    fn into_u8(self) -&gt; u8 {
        match self {}
    }
}

impl&lt;T: IntoU8&gt; IntoU8 for PeanoEncoder&lt;T&gt; {
    fn into_u8(self) -&gt; u8 {
        match self {
            PeanoEncoder::Successor(x) =&gt; 1 + x.into_u8(),
            PeanoEncoder::Zero =&gt; 0,
        }
    }
}
</code></pre>
<p>Here, according to <a href="https://godbolt.org/z/hfdKdxe19">godbolt</a>, <code>Peano255::into_u8</code> gets compiled to more than 900 lines of assembly, which resembles a binary decision tree with jump-tables at the leaves.</p>
<p>However, we can inspect a bit how rustc represents a few values:</p>
<pre><code class="language-rust">println!(&quot;Size of Peano255: {} byte&quot;, std::mem::size_of::&lt;Peano255&gt;());
for x in [
    Peano255::Zero,
    Peano255::Successor(PeanoEncoder::Zero),
    Peano255::Successor(PeanoEncoder::Successor(PeanoEncoder::Zero)),
] {
    println!(&quot;Machine representation of {:?}: {}&quot;, x, unsafe {
        std::mem::transmute::&lt;_, u8&gt;(x)
    })
}
</code></pre>
<p>which gives</p>
<pre><code>Size of Peano255: 1 byte
Machine representation of Zero: 255
Machine representation of Successor(Zero): 254
Machine representation of Successor(Successor(Zero)): 253
</code></pre>
<p>A pattern seems to emerge. Rustc chooses to represent <code>Peano255::Zero</code> as 255, and each successor as one less.</p>
<p>As a brief detour, let's see what happens for <code>PeanoN</code> with other values of N.</p>
<pre><code class="language-rust">let x = Peano1::Zero;
println!(&quot;Machine representation of Peano1::{:?}: {}&quot;, x, unsafe {
    std::mem::transmute::&lt;_, u8&gt;(x)
});
for x in [
    Peano2::Successor(PeanoEncoder::Zero),
    Peano2::Zero,
] {
    println!(&quot;Machine representation of Peano2::{:?}: {}&quot;, x, unsafe {
        std::mem::transmute::&lt;_, u8&gt;(x)
    })
}
</code></pre>
<p>gives</p>
<pre><code>Machine representation of Peano1::Zero: 1
Machine representation of Peano2::Successor(Zero): 1
Machine representation of Peano2::Zero: 2
</code></pre>
<p>Notice that the representation of Zero is not the same for each <code>PeanoN</code>. What we actually have -- and what is key here -- is that the representation for <code>x</code> of type <code>PeanoN</code> is the same as the representation of <code>Succesor(x)</code> of type <code>PeanoEncoder&lt;PeanoN&gt;</code>, which implies that the machine representation of an integer <code>k</code> in the type <code>PeanoN</code> is <code>n-k</code>.</p>
<p>That detour being concluded, we refocus on <code>Peano255</code> for which we can write a very efficient conversion function</p>
<pre><code class="language-rust">impl Peano255 {
    pub fn transmute_u8(x: u8) -&gt; Self {
        unsafe { std::mem::transmute(u8::MAX - x) }
    }
}
</code></pre>
<p>Note that this function mere existence is very wrong and a sinful abomination to the eye of anything that is holy and maintainable. But provided you run the same compiler version as me on the very same architecture, you may be ok using it. Please don't use it.</p>
<p>In any case <code>transmute_u8</code> gets compiled to</p>
<pre><code>movl    %edi, %eax
notb    %al
retq
</code></pre>
<p>that is a simple function that applies a binary not to its argument register. And in most use cases, this function would actually be inlined and combined with operations above, making it run in less than one processor operation!</p>
<p>And because 255 is so small, we can exhaustively check that the behavior is correct for all values! Take that formal methods!</p>
<pre><code class="language-rust">for i in 0_u8..=u8::MAX {
    let x = Peano255::transmute_u8(i);
    if i % 8 == 0 {
        print!(&quot;{:3} &quot;, i)
    } else if i % 8 == 4 {
        print!(&quot; &quot;)
    }
    let c = if x.into_u8() == i { '&#10003;' } else { '&#10007;' };
    print!(&quot;{}&quot;, c);
    if i % 8 == 7 {
        println!()
    }
}
</code></pre>
<pre><code>  0 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
  8 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
 16 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
 24 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
 32 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
 40 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
 48 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
 56 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
 64 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
 72 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
 80 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
 88 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
 96 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
104 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
112 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
120 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
128 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
136 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
144 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
152 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
160 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
168 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
176 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
184 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
192 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
200 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
208 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
216 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
224 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
232 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
240 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
248 &#10003;&#10003;&#10003;&#10003; &#10003;&#10003;&#10003;&#10003;
</code></pre>
<p>Isn't computer science fun?</p>
<p><em>Note:</em> The code for this blog post is available <a href="https://github.com/OCamlPro/PeaNoOp">here</a>.</p>

