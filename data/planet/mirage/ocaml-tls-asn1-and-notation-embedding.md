---
title: 'OCaml-TLS: ASN.1 and notation embedding'
description:
url: https://mirage.io/blog/introducing-asn1
date: 2014-07-11T00:00:00-00:00
preview_image:
featured:
authors:
- David Kaloper
---


        <p><em>This is the fourth in a series of posts that introduce new libraries for a pure OCaml implementation of TLS.
You might like to begin with the <a href="https://mirage.io/blog/introducing-ocaml-tls">introduction</a>.</em></p>
<p><a href="https://github.com/mirleft/ocaml-asn1-combinators">asn1-combinators</a> is a library that allows one to express
<a href="https://en.wikipedia.org/wiki/Abstract_Syntax_Notation_One">ASN.1</a> grammars directly in OCaml, manipulate them as first-class entities,
combine them with one of several ASN encoding rules and use the result to parse
or serialize values.</p>
<p>It is the parsing and serialization backend for our <a href="https://github.com/mirleft/ocaml-x509">X.509</a>
certificate library, which in turn provides certificate handling for
<a href="https://github.com/mirleft/ocaml-tls">ocaml-tls</a>.
We wrote about the X.509 certificate handling <a href="https://mirage.io/blog/introducing-x509">yesterday</a>.</p>
<h3>What is ASN.1, really?</h3>
<p><a href="https://en.wikipedia.org/wiki/Abstract_Syntax_Notation_One">ASN.1</a> (Abstract Syntax Notation, version one) is a way to describe
on-the-wire representation of messages. It is split into two components: a way
to describe the content of a message, i.e. a notation for its abstract syntax,
and a series of standard encoding rules that define the exact byte
representations of those syntaxes. It is defined in ITU-T standards X.680-X.683
and X.690-X.695.</p>
<p>The notation itself contains primitive grammar elements, such as <code>BIT STRING</code> or
<code>GeneralizedTime</code>, and constructs that allow for creation of compound grammars
from other grammars, like <code>SEQUENCE</code>. The notation is probably best introduced
through a real-world example:</p>
<pre><code>-- Simple name bindings
UniqueIdentifier ::= BIT STRING

-- Products
Validity ::= SEQUENCE {
  notBefore Time,
  notAfter  Time
}

-- Sums
Time ::= CHOICE {
  utcTime     UTCTime,
  generalTime GeneralizedTime
}
</code></pre>
<p>(Example from <a href="http://tools.ietf.org/html/rfc5280#appendix-A.2">RFC 5280</a>, the RFC that describes X.509
certificates which heavily rely on ASN.)</p>
<p>The first definition shows that we can introduce an alias for any existing ASN
grammar fragment, in this case the primitive <code>BIT STRING</code>. The second and third
definitions are, at least morally, a product and a sum.</p>
<p>At their very core, ASN grammars look roughly like algebraic data types, with a
range of pre-defined primitive grammar fragments like <code>BIT STRING</code>, <code>INTEGER</code>,
<code>NULL</code>, <code>BOOLEAN</code> or even <code>GeneralizedTime</code>, and a number of combining
constructs that can be understood as denoting sums and products.</p>
<p>Definitions such as the above are arranged into named modules. The standard even
provides for some abstractive capabilities: initially just a macro facility, and
later a form of parameterized interfaces.</p>
<p>To facilitate actual message transfer, a grammar needs to be coupled with an
encoding. By far the most relevant ones are Basic Encoding Rules (BER) and
Distinguished Encoding Rules (DER), although other encodings exist.</p>
<p>BER and DER are tag-length-value (TLV) encodings, meaning that every value is
encoded as a triplet containing a tag that gives the interpretation of its
contents, a length field, and the actual contents which can in turn contain
other TLV triplets.</p>
<p>Let's drop the time from the example above, as time encoding is a little
involved, and assume a simpler version for a moment:</p>
<pre><code>Pair ::= SEQUENCE {
  car Value,
  cdr Value
}

Value ::= CHOICE {
  v_str UTF8String,
  v_int INTEGER
}
</code></pre>
<p>Then two possible BER encodings of a <code>Pair</code> <code>(&quot;foo&quot;, 42)</code> are:</p>
<pre><code>  30         - SEQUENCE            30         - SEQUENCE
  08         - length              0c         - length
  [ 0c       - UTF8String          [ 2c       - UTF8String, compound
    03       - length                07       - length
    [ 66     - 'f'                   [ 0c     - UTF8String
      6f     - 'o'                     01     - length
      6f ]   - 'o'                     [ 66 ] - 'f'
    02       - INTEGER                 0c     - UTF8String
    01       - length                  02     - length
    [ 2a ] ] - 42                      [ 6f   - 'o'
                                         6f ] - 'o'
                                     02       - INTEGER
                                     01       - length
                                     [ 2a ] ] - 42
</code></pre>
<p>The left one is also the only valid DER encoding of this value: BER allows
certain freedoms in encoding, while DER is just a BER subset without those
freedoms. The property of DER that any value has exactly one encoding is useful,
for example, when trying to digitally sign a value.</p>
<p>If this piqued your curiosity about ASN, you might want to take a detour and
check out this <a href="http://luca.ntop.org/Teaching/Appunti/asn1.html">excellent writeup</a>.</p>
<h3>A bit of history</h3>
<p>The description above paints a picture of a technology a little like <a href="https://code.google.com/p/protobuf/">Google's
Protocol Buffers</a> or <a href="https://thrift.apache.org/">Apache Thrift</a>: a way to declaratively
specify the structure of a set of values and derive parsers and serializers,
with the addition of multiple concrete representations.</p>
<p>But the devil is in the detail. For instance, the examples above intentionally
gloss over the fact that often concrete tag values <a href="http://tools.ietf.org/html/rfc5280#page-128">leak</a> into
the grammar specifications for various disambiguation reasons. And ASN has more
than 10 different <a href="http://www.obj-sys.com/asn1tutorial/node128.html">string types</a>, most of which use
long-obsolete character encodings. Not to mention that the full standard is
close to 200 pages of relatively dense language and quite difficult to
follow. In general, ASN seems to have too many features for the relatively
simple task it is solving, and its specification has evolved over decades, apparently
trying to address various other semi-related problems, such as providing a
general <a href="https://en.wikipedia.org/wiki/Information_Object_Class_(ASN.1)">Interface Description Language</a>.</p>
<p>Which is to say, ASN is <em>probably</em> not what you are looking for. So why
implement it?</p>
<p>Developed in the context of the telecom industry around 30 years ago, modified
several times after that and apparently suffering from a lack of a coherent
goal, by the early 90s ASN was still probably the only universal, machine- and
architecture-independent external data representation.</p>
<p>So it came easily to hand around the time RSA Security started publishing its
series of <a href="https://en.wikipedia.org/wiki/PKCS">PKCS</a> standards, aimed at the standardization of
cryptographic material exchange. RSA keys and digital signatures are often
exchanged ASN-encoded.</p>
<p>At roughly the same time, ITU-T started publishing the <a href="https://en.wikipedia.org/wiki/X.500">X.500</a> series
of standards which aimed to provide a comprehensive directory service. Much of
this work ended up as LDAP, but one little bit stands out in particular: the
<a href="https://en.wikipedia.org/wiki/X.509">X.509</a> PKI certificate.</p>
<p>So a few years later, when Netscape tried to build an authenticated and
confidential layer to tunnel HTTP through, they based it on -- amongst other
things -- X.509 certificates. Their work went through several revisions as SSL
and was finally standardized as TLS. Modern TLS still requires X.509.</p>
<p>Thus, even though TLS uses ASN only for encoding certificates (and the odd PKCS1
signature), every implementation needs to know how to deal with ASN. In fact,
many other general cryptographic libraries also need to deal with ASN, as various PKCS
standards mandate ASN as the encoding for exchange of cryptographic material.</p>
<h3>The grammar of the grammar</h3>
<p>As its name implies, ASN was meant to be used with a specialized compiler. ASN
is really a standard for <em>writing down</em> abstract syntaxes, and ASN compilers
provided with the target encoding will generate code in your programming
language of choice that, when invoked, parses to or serializes from ASN.</p>
<p>As long as your programming language of choice is C, C++, Java or C#, obviously
-- there doesn't seem to be one freely available that targets OCaml. In any case, generating code for such a high-level language feels wrong somehow. In
its effort to be language-neutral, ASN needs to deal with things like modules,
abstraction and composition. At this point, most functional programmers reading
this are screaming: &quot;I <em>already</em> have a language that can deal with modules,
abstraction and composition perfectly well!&quot;</p>
<p>So we're left with implementing ASN in OCaml.</p>
<p>One strategy is to provide utility functions for parsing elements of ASN and
simply invoke them in the appropriate order, as imposed by the target grammar.
This amounts to hand-writing the parser and is what TLS libraries in C
typically do.</p>
<p>As of release 1.3.7, <a href="https://github.com/polarssl/polarssl/tree/development/library">PolarSSL</a> includes ~7,500 lines of rather
beautifully written C, that implement a specialized parser for dealing with
X.509. OpenSSL's <a href="https://github.com/openssl/openssl">libcrypto</a> contains ~50,000 lines of C in its
<a href="https://github.com/openssl/openssl/tree/e3ba6a5f834f24aa5ffe9bc1849e3410c87388d5/crypto/asn1">'asn1'</a>, <a href="https://github.com/openssl/openssl/tree/e3ba6a5f834f24aa5ffe9bc1849e3410c87388d5/crypto/x509">'x509'</a> and
<a href="https://github.com/openssl/openssl/tree/e3ba6a5f834f24aa5ffe9bc1849e3410c87388d5/crypto/x509v3">'x509v3'</a> directories, and primarily deals with X.509
specifically as required by TLS.</p>
<p>In both cases, low-level control flow is intertwined with the parsing logic and,
above the ASN parsing level, the code that deals with interpreting the ASN
structure is not particularly concise.
It is certainly a far cry from the (relatively)
simple grammar description ASN itself provides.</p>
<p>Since in BER every value fully describes itself, another strategy is to parse
the input stream without reference to the grammar. This produces a value that
belongs to the general type of all ASN-encoded trees, after which we need to
process the <em>structure</em> according to the grammar. This is similar to a common
treatment of JSON or XML, where one decouples parsing of bytes from the
higher-level concerns about the actual structure contained therein. The problem
here is that either the downstream client of such a parser needs to constantly
re-check whether the parts of the structure it's interacting with are really
formed according to the grammar (probably leading to a tedium of
pattern-matches), or we have to turn around and solve the parsing problem
<em>again</em>, mapping the uni-typed contents of a message to the actual, statically
known structure we require the message to have.</p>
<p>Surely we can do better?</p>
<h3>LAMBDA: The Ultimate Declarative</h3>
<p>Again, ASN is a language with a number of built-in primitives, a few combining
constructs, (recursive) name-binding and a module system. Our target language is
a language with a perfectly good module system and it can certainly express
combining constructs. It includes an abstraction mechanism arguably far simpler
and easier to use than those of ASN, namely, functions. And the OCaml compilers
can already parse OCaml sources. So why not just reuse this machinery?</p>
<p>The idea is familiar. Creating embedded languages for highly declarative
descriptions within narrowly defined problem spaces is the staple of functional
programming. In particular, combinatory parsing has been known, studied and
used for <a href="http://comjnl.oxfordjournals.org/content/32/2/108.short">decades</a>.</p>
<p>However, we also have to diverge from traditional parser combinators in two major ways.
Firstly, a single grammar expression needs to be able to generate
different concrete parsers, corresponding to different ASN encodings. More
importantly, we desire our grammar descriptions to act <strong>bidirectionally</strong>,
producing both parsers and complementary deserializers.</p>
<p>The second point severely restricts the signatures we can support. The usual
monadic parsers are off the table because the expression such as:</p>
<pre><code class="language-OCaml">( (pa : a t) &gt;&gt;= fun (a : a) -&gt;
  (pb : b t) &gt;&gt;= fun (b : b) -&gt;
  return (b, b, a) ) : (b * b * a) t
</code></pre>
<p>... &quot;hides&quot; parts of the parser inside the closures, especially the method of
mapping the parsed values into the output values, and can not be run &quot;in
reverse&quot; [<a href="https://mirage.io/feed.xml#footnote-1">1</a>].</p>
<p>We have a similar problem with <a href="http://www.soi.city.ac.uk/~ross/papers/Applicative.html">applicative functors</a>:</p>
<pre><code class="language-OCaml">( (fun a b -&gt; (b, b, a))
  &lt;$&gt; (pa : a t)
  &lt;*&gt; (pb : b t) ) : (b * b * a) t
</code></pre>
<p>(Given the usual <code>&lt;$&gt; : ('a -&gt; 'b) -&gt; 'a t -&gt; 'b t</code> and <code>&lt;*&gt; : ('a -&gt; 'b) t -&gt; 'a t -&gt; 'b t</code>.) Although the elements of ASN syntax are now exposed, the process
of going from intermediate parsing results to the result of the whole is still
not accessible.</p>
<p>Fortunately, due to the regular structure of ASN, we don't really <em>need</em> the
full expressive power of monadic parsing. The only occurrence of sequential
parsing is within <code>SEQUENCE</code> and related constructs, and we don't need
look-ahead. All we need to do is provide a few specialized combinators to handle
those cases -- combinators the likes of which would be derived in a
more typical setting.</p>
<p>So if we imagine we had a few values, like:</p>
<pre><code class="language-OCaml">val gen_time : gen_time t
val utc_time : utc_time t
val choice   : 'a t -&gt; 'b t -&gt; ('a, 'b) choice t
val sequence : 'a t -&gt; 'b t -&gt; ('a * 'b) t
</code></pre>
<p>Assuming appropriate OCaml types <code>gen_time</code> and <code>utc_time</code> that reflect their
ASN counterparts, and a simple sum type <code>choice</code>, we could express the
<code>Validity</code> grammar above using:</p>
<pre><code class="language-OCaml">type time = (gen_time, utc_time) choice
let time     : time t          = choice gen_time utc_time
let validity : (time * time) t = sequence time time
</code></pre>
<p>In fact, ASN maps quite well to algebraic data types. Its <code>SEQUENCE</code> corresponds
to n-ary products and <code>CHOICE</code> to sums. ASN <code>SET</code> is a lot like <code>SEQUENCE</code>,
except the elements can come in any order; and <code>SEQUENCE_OF</code> and <code>SET_OF</code> are
just lifting an <code>'a</code>-grammar into an <code>'a list</code>-grammar.</p>
<p>A small wrinkle is that <code>SEQUENCE</code> allows for more contextual information on its
components (so does <code>CHOICE</code> in reality, but we ignore that): elements can carry
labels (which are not used for parsing) and can be marked as optional. So
instead of working directly on the grammars, our <code>sequence</code> must work on their
annotated versions. A second wrinkle is the arity of the <code>sequence</code> combinator.</p>
<p>Thus we introduce the type of annotated grammars, <code>'a element</code>, which
corresponds to one <code>,</code>-delimited syntactic element in ASN's own <code>SEQUENCE</code>
grammar, and the type <code>'a sequence</code>, which describes the entire contents (<code>{ ... }</code>) of a <code>SEQUENCE</code> definition:</p>
<pre><code class="language-OCaml">val required : 'a t -&gt; 'a element
val optional : 'a t -&gt; 'a option element
val ( -@ )   : 'a element -&gt; 'b element -&gt; ('a * 'b) sequence
val ( @ )    : 'a element -&gt; 'a sequence -&gt; ('a * 'b) sequence
val sequence : 'a sequence -&gt; 'a t
</code></pre>
<p>The following are then equivalent:</p>
<pre><code>Triple ::= SEQUENCE {
  a INTEGER,
  b BOOLEAN,
  c BOOLEAN OPTIONAL
}
</code></pre>
<pre><code class="language-OCaml">let triple : (int * (bool * bool option)) t =
  sequence (
      required int
    @ required bool
   -@ optional bool
  )
</code></pre>
<p>We can also re-introduce functions, but in a controlled manner:</p>
<pre><code class="language-OCaml">val map : ('a -&gt; 'b) -&gt; ('b -&gt; 'a) -&gt; 'a t -&gt; 'b t
</code></pre>
<p>Keeping in line with the general theme of bidirectionality, we require functions
to come in pairs. The deceptively called <code>map</code> could also be called <code>iso</code>, and
comes with a nice property: if the two functions are truly inverses,
the serialization process is fully reversible, and so is parsing, under
single-representation encodings (DER)!</p>
<h3>ASTs of ASNs</h3>
<p>To go that last mile, we should probably also <em>implement</em> what we discussed.</p>
<p>Traditional parser combinators look a little like this:</p>
<pre><code class="language-OCaml">type 'a p = string -&gt; 'a * string

let bool : bool p = fun str -&gt; (s.[0] &lt;&gt; &quot;\\000&quot;, tail_of_string str)
</code></pre>
<p>Usually, the values inhabiting the parser type are the actual parsing functions,
and their composition directly produces larger parsing functions. We would
probably need to represent them with <code>'a p * 'a s</code>, pairs of a parser and its
inverse, but the same general idea applies.</p>
<p>Nevertheless, we don't want to do this.
The grammars need to support more than one concrete
parser/serializer, and composing what is common between them and extracting out
what is not would probably turn into a tangled mess. That is one reason. The other is that if we encode the grammar purely as
(non-function) value, we can traverse it for various other purposes.</p>
<p>So we turn from what is sometimes called &quot;shallow embedding&quot; to &quot;deep
embedding&quot; and try to represent the grammar purely as an algebraic data type.</p>
<p>Let's try to encode the parser for bools, <code>boolean : bool t</code>:</p>
<pre><code class="language-OCaml">type 'a t =
  | Bool
  ...

let boolean : bool t = Bool
</code></pre>
<p>Unfortunately our constructor is fully polymorphic, of type <code>'a. 'a t</code>. We can
constrain it for the users, but once we traverse it there is nothing left to
prove its intended association with booleans!</p>
<p>Fortunately, starting with the release of <a href="http://ocaml.org/releases/4.00.1.html">OCaml 4.00.0</a>,
OCaml joined the ranks of
languages equipped with what is probably the supreme tool of deep embedding,
<a href="http://en.wikipedia.org/wiki/Generalized_algebraic_data_type">GADTs</a>. Using them, we can do things like:</p>
<pre><code class="language-OCaml">type _ t =
  | Bool   : bool t
  | Pair   : ('a t * 'b t) -&gt; ('a * 'b) t
  | Choice : ('a t * 'b t) -&gt; ('a, 'b) choice t
  ...
</code></pre>
<p>In fact, this is very close to how the library is <a href="https://github.com/mirleft/ocaml-asn1-combinators/blob/4328bf5ee6f20ad25ff7971ee8013f79e5bfb036/src/core.ml#L19">actually</a>
implemented.</p>
<p>There is only one thing left to worry about: ASN definitions can be recursive.
We might try something like:</p>
<pre><code class="language-OCaml">let rec list = choice null (pair int list)
</code></pre>
<p>But this won't work. Being just trees of applications, our definitions never
contain <a href="http://caml.inria.fr/pub/docs/manual-ocaml-400/manual021.html#toc70">statically constructive</a> parts -- this expression could never
terminate in a strict language.</p>
<p>We can get around that by wrapping grammars in <code>Lazy.t</code> (or just closures), but
this would be too awkward to use. Like many other similar libraries, we need to
provide a fixpoint combinator:</p>
<pre><code class="language-OCaml">val fix : ('a t -&gt; 'a t) -&gt; 'a t
</code></pre>
<p>And get to write:</p>
<pre><code class="language-OCaml">let list = fix @@ fun list -&gt; choice null (pair int list)
</code></pre>
<p>This introduces a small problem. So far we simply reused binding inherited
from OCaml without ever worrying about identifiers and references, but with a
fixpoint, the grammar encodings need to be able to somehow express a cycle.</p>
<p>Borrowing an idea from higher-order abstract syntax, we can represent the entire
fixpoint node using exactly the function provided to define it, re-using OCaml's
own binding and identifier resolution:</p>
<pre><code class="language-OCaml">type _ t =
  | Fix : ('a t -&gt; 'a t) -&gt; 'a t
  ...
</code></pre>
<p>This treatment completely sidesteps the problems with variables. We need no
binding environments or De Brujin indices, and need not care about the desired
scoping semantics. A little trade-off is that with this simple encoding it
becomes more difficult to track cycles (when traversing the AST, if we keep
applying a <code>Fix</code> node to itself while descending into it, it looks like an
infinite tree), but with a little opportunistic caching it all plays out well
[<a href="https://mirage.io/feed.xml#footnote-2">2</a>].</p>
<p>The <a href="https://github.com/mirleft/ocaml-asn1-combinators/blob/4328bf5ee6f20ad25ff7971ee8013f79e5bfb036/src/ber_der.ml#L49">parser</a> and <a href="https://github.com/mirleft/ocaml-asn1-combinators/blob/4328bf5ee6f20ad25ff7971ee8013f79e5bfb036/src/ber_der.ml#L432">serializer</a> proper then emerge as interpreters for
this little language of typed trees, traversing them with an input string, and
parsing it in a fully type-safe manner.</p>
<h3>How does it play out?</h3>
<p>The entire ASN library comes down to ~1,700 lines of OCaml, with around ~1,100
more in tests, giving a mostly-complete treatment of BER and DER.</p>
<p>Its main use so far is in the context of the <code>X.509</code> library
(discussed <a href="https://mirage.io/blog/introducing-x509">yesterday</a>). It allowed the
grammar of certificates and RSA keys, together with a number of transformations
from the raw types to more pleasant, externally facing ones, to be written in
~900 <a href="https://github.com/mirleft/ocaml-x509/blob/6c96f11a2c7911ae0b308af9b328aee38f48b270/lib/asn_grammars.ml">lines</a> of OCaml. And the code looks a lot like the
actual standards the grammars were taken from -- the fragment from the beginning
of this article becomes:</p>
<pre><code class="language-OCaml">let unique_identifier = bit_string_cs

let time =
  map (function `C1 t -&gt; t | `C2 t -&gt; t) (fun t -&gt; `C2 t)
      (choice2 utc_time generalized_time)

let validity =
  sequence2
    (required ~label:&quot;not before&quot; time)
    (required ~label:&quot;not after&quot;  time)
</code></pre>
<p>We added <code>~label</code> to <code>'a element</code>-forming injections, and have:</p>
<pre><code class="language-OCaml">val choice2 : 'a t -&gt; 'b t -&gt; [ `C1 of 'a | `C2 of 'b ] t
</code></pre>
<p>To get a sense of how the resulting system eases the translation of standardized
ASN grammars into working code, it is particularly instructive to compare
<a href="https://github.com/polarssl/polarssl/blob/b9e4e2c97a2e448090ff3fcc0f99b8f6dbc08897/library/x509_crt.c#L531">these</a> <a href="https://github.com/mirleft/ocaml-x509/blob/7bd25d152445263d7659c653e4a761222f43c75b/lib/asn_grammars.ml#L772">two</a> definitions.</p>
<p>Reversibility was a major simplifying factor during development. Since the
grammars are traversable, it is easy to generate their <a href="https://github.com/mirleft/ocaml-asn1-combinators/blob/cf1a1ffb4a31d02979a6a0bca8fe58856f8907bf/src/asn_random.ml">random</a>
inhabitants, encode them, parse the result and verify the reversibility still
<a href="https://github.com/mirleft/ocaml-asn1-combinators/blob/cf1a1ffb4a31d02979a6a0bca8fe58856f8907bf/tests/testlib.ml#L83">holds</a>. This can't help convince us the parsing/serializing pair
is actually correct with respect to ASN, but it gives a simple tool to generate
large amounts of test cases and convince us that that pair is <em>equivalent</em>. A
number of hand-written cases then check the conformance to the actual ASN.</p>
<p>As for security, there were two concerns we were aware of. There is a history of
catastrophic <a href="https://technet.microsoft.com/en-us/library/security/ms04-007.aspx">buffer overruns</a> in some ASN.1 implementations,
but -- assuming our compiler and runtime system are correct -- we are immune to
these as we are subject to bounds-checking. And
there are some documented <a href="https://www.viathinksoft.de/~daniel-marschall/asn.1/oid_facts.html">problems</a> with security of X.509
certificate verification due to overflows of numbers in ASN OID types, which we
explicitly guard against.</p>
<p>You can check our security status on our <a href="https://github.com/mirleft/ocaml-asn1-combinators/issues?state=open">issue tracker</a>.</p>
<h4>Footnotes</h4>
<ol>
<li>
<p><a name="footnote-1"> </a> In fact, the problem with embedding functions in
combinator languages, and the fact that in a functional language it is not
possible to extract information from a function other than by applying it,
was discussed more than a decade ago. Such discussions led to the development of
<a href="http://www.haskell.org/arrows/biblio.html#Hug00">Arrows</a>, amongst other things.</p>
</li>
<li>
<p><a name="footnote-2"> </a> Actually, a version of the library used the more
<a href="http://dl.acm.org/citation.cfm?id=1411226">proper</a> encoding to be able to inject results of reducing
referred-to parts of the AST into the referring sites directly, roughly
like <code>Fix : ('r -&gt; ('a, 'r) t) -&gt; ('a, 'r) t</code>. This approach was abandoned because terms need to be polymorphic in <code>'r</code>, and this becomes
impossible to hide from the user of the library, creating unwelcome noise.</p>
</li>
</ol>
<hr/>
<p>Posts in this TLS series:</p>
<ul>
<li><a href="https://mirage.io/blog/introducing-ocaml-tls">Introducing transport layer security (TLS) in pure OCaml</a>
</li>
<li><a href="https://mirage.io/blog/introducing-nocrypto">OCaml-TLS: building the nocrypto library core</a>
</li>
<li><a href="https://mirage.io/blog/introducing-x509">OCaml-TLS: adventures in X.509 certificate parsing and validation</a>
</li>
<li><a href="https://mirage.io/blog/introducing-asn1">OCaml-TLS: ASN.1 and notation embedding</a>
</li>
<li><a href="https://mirage.io/blog/ocaml-tls-api-internals-attacks-mitigation">OCaml-TLS: the protocol implementation and mitigations to known attacks</a>
</li>
</ul>

      
