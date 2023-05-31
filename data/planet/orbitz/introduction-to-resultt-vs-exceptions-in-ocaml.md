---
title: Introduction to Result.t vs Exceptions in Ocaml
description: This post uses Jane St's Core suite.  Specifically the Result  module.  It
  assumes some basic knowledge of Ocaml.  Please check out Ocaml.o...
url: http://functional-orbitz.blogspot.com/2013/01/introduction-to-resultt-vs-exceptions.html
date: 2013-01-03T22:55:00-00:00
preview_image:
featured:
authors:
- orbitz
---

<p>
<i>This post uses Jane St's Core suite.  Specifically the <code>Result</code> module.  It assumes some basic knowledge of Ocaml.  Please check out <a href="http://ocaml.org">Ocaml.org</a> for more Ocaml reading material.</i>
</p>

<p>
There are several articles and blog posts out there arguing for or against return values over exceptions.  I'll add to the discussion with my reasons for using return values in the place of exceptions in Ocaml.
</p>

<h3>What's the difference?</h3>
<p>
Why does the debate even exist?  Because each side has decent arguments for why their preference is superior when it comes to writing reliable software.  Pro-return-value developers, for example, argue that their code is easier identify if the code is wrong simply by reading it (if it isn't handling a return value of a function, it's wrong), while exception based code requires understanding all of the functions called to determine if and how they will fail.  Pro-exception developers argue that it is much harder to get their program into an undefined state because an exception has to be handled or else the program fails, where in return based code one can simply forget to check a function's return value and the program continues on in an undefined state. 
</p>

<p>
I believe that Ocaml has several features that make return values the preferable way to handle errors.  Specifically variants, polymorphic variants, exhaustive pattern matching, and a powerful static type system make return values attractive.
</p>

<p>
This debate is only worth your time if you are really passionate about writing software that has fairly strong guarantees about its quality in the face of errors.  For a majority of software, it doesn't matter which paradigm you choose.  Most errors will be stumbled upon during debugging and fairly soon after going into production or through writing unit and integration tests.  But, tests cannot catch everything.  And in distributed and concurrent code rare errors can now become common errors and it can be near impossible to reconstruct the conditions that caused it.  But in some cases it is possible to make whole classes of errors either impossible or catchable at compile-time with some discipline.  Ocaml is at least one language that makes this possible.
</p>

<h3>Checked exceptions</h3>
<p>
A quick aside on checked exceptions, as in Java.  Checked exceptions provide some of the functionality I claim is valuable, the main problem with how checked exceptions are implemented in Java (the only language I have any experience in that uses them), is they have a very heavy syntax, to the point where using them can seem too burdensome.
</p>

<h3>The Claim</h3>
<p>
The claim is that if one cares about ensuring they are handling all failure cases in their software, return-values are superior to exceptions because, with the help of a good type system, their handling can be validated at compile-time.  Ocaml provides a fairly light, non intrusive, syntax to make this feasible.
</p>

<h3>Good Returns</h3>
<p>
The goal of a good return value based error handling system is to make sure that all errors are handled at compile-time.  This is because there is no way to enforce this at run-time, as an exception does.  This is a good reason to prefer exceptions in a dynamically typed language like Python or Ruby, your static analyzers are few and far between.
</p>

<p>
In C this is generally accomplished by using a linting tool that will report an error if a function's return value is ignored in a call.  This is why you might see <code>printf</code> casted to <code>void</code> in some code, to make it clear the return value is meant to be ignored.  But a problem with this solution is that it only enforces that the developer handles the return value, not all possible errors.  For example, POSIX functions return a value saying the function failed and put the actual failure in <code>errno</code>.  How, then, to enforce that all of the possible failures are handled?  Without encoding all of that information in a linting tool, the options in C (and most languages) are pretty weak. Linting tools are also separate from the compiler and vary in quality.  Writing code that takes proper advantage of a linting tool, in C, is a skill all of its own as well.
</p>

<h3>Better Returns</h3>
<p>
Ocaml supports exceptions but the compiler provides no guarantees that the exceptions are actually handled anywhere in the code.  So what happens if the documentation of a function is incomplete or a dependent function is changed to add a new exception being thrown?  The compiler won't help you.
</p>

<p>
But Ocaml's rich type system, combined with some discipline, gives you more power than a C linter.  The primary strength is that Ocaml lets you encode information in your types.  For example, in POSIX many functions return an integer to indicate error.  But an <code>int</code> has no interesting meaning to the compiler other than it holds values between <code>INT_MIN</code> and <code>INT_MAX</code>.  In Ocaml, we can instead create a type to represent the errors a function can return and the compiler can enforce that all possible errors are handled in some way thanks to exhaustive pattern matching.
</p>

<h3>An Example</h3>
<p>
What does all of this look like?  Below a contrived example. The goal is to provide a function, called <code>parse_person</code> that takes a string and turns it into a <code>person</code> record.  The requirements of the code is that if a valid person cannot be parsed out, the part of the string that failed is specified in the error message.
</p>

<p>
Here is a version using exceptions, <a href="https://github.com/orbitz/blog_post_src/blob/master/intro_return_t/ex1.ml">ex1.ml</a>:
</p>


<pre><code><b><font color="#000080">open</font></b> <b><font color="#000080">Core</font></b><font color="#990000">.</font><font color="#009900">Std</font>

<b><font color="#0000FF">exception</font></b> <font color="#009900">Int_of_string</font> <b><font color="#0000FF">of</font></b> <font color="#009900">string</font>

<b><font color="#0000FF">exception</font></b> <font color="#009900">Bad_line</font> <b><font color="#0000FF">of</font></b> <font color="#009900">string</font>
<b><font color="#0000FF">exception</font></b> <font color="#009900">Bad_name</font> <b><font color="#0000FF">of</font></b> <font color="#009900">string</font>
<b><font color="#0000FF">exception</font></b> <font color="#009900">Bad_age</font> <b><font color="#0000FF">of</font></b> <font color="#009900">string</font>
<b><font color="#0000FF">exception</font></b> <font color="#009900">Bad_zip</font> <b><font color="#0000FF">of</font></b> <font color="#009900">string</font>

<b><font color="#0000FF">type</font></b> person <font color="#990000">=</font> <font color="#FF0000">{</font> name <font color="#990000">:</font> <font color="#990000">(</font><font color="#009900">string</font> <font color="#990000">*</font> <font color="#009900">string</font><font color="#990000">)</font>
              <font color="#990000">;</font> age  <font color="#990000">:</font> <b><font color="#000080">Int</font></b><font color="#990000">.</font>t
              <font color="#990000">;</font> zip  <font color="#990000">:</font> <font color="#009900">string</font>
              <font color="#FF0000">}</font>

<i><font color="#9A1900">(* A little helper function *)</font></i>
<b><font color="#0000FF">let</font></b> int_of_string s <font color="#990000">=</font>
  <b><font color="#0000FF">try</font></b>
    <b><font color="#000080">Int</font></b><font color="#990000">.</font>of_string s
  <b><font color="#0000FF">with</font></b>
    <font color="#990000">|</font> <font color="#009900">Failure</font> _ <font color="#990000">-&gt;</font>
      raise <font color="#990000">(</font><font color="#009900">Int_of_string</font> s<font color="#990000">)</font>

<b><font color="#0000FF">let</font></b> parse_name name <font color="#990000">=</font>
  <b><font color="#0000FF">match</font></b> <b><font color="#000080">String</font></b><font color="#990000">.</font>lsplit2 <font color="#990000">~</font>on<font color="#990000">:</font>' ' name <b><font color="#0000FF">with</font></b>
    <font color="#990000">|</font> <font color="#009900">Some</font> <font color="#990000">(</font>first_name<font color="#990000">,</font> last_name<font color="#990000">)</font> <font color="#990000">-&gt;</font>
      <font color="#990000">(</font>first_name<font color="#990000">,</font> last_name<font color="#990000">)</font>
    <font color="#990000">|</font> <font color="#009900">None</font> <font color="#990000">-&gt;</font>
      raise <font color="#990000">(</font><font color="#009900">Bad_name</font> name<font color="#990000">)</font>

<b><font color="#0000FF">let</font></b> parse_age age <font color="#990000">=</font>
  <b><font color="#0000FF">try</font></b>
    int_of_string age
  <b><font color="#0000FF">with</font></b>
    <font color="#990000">|</font> <font color="#009900">Int_of_string</font> _ <font color="#990000">-&gt;</font>
      raise <font color="#990000">(</font><font color="#009900">Bad_age</font> age<font color="#990000">)</font>

<b><font color="#0000FF">let</font></b> parse_zip zip <font color="#990000">=</font>
  <b><font color="#0000FF">try</font></b>
    ignore <font color="#990000">(</font>int_of_string zip<font color="#990000">);</font>
    <b><font color="#0000FF">if</font></b> <b><font color="#000080">String</font></b><font color="#990000">.</font>length zip <font color="#990000">=</font> <font color="#993399">5</font> <b><font color="#0000FF">then</font></b>
      zip
    <b><font color="#0000FF">else</font></b>
      raise <font color="#990000">(</font><font color="#009900">Bad_zip</font> zip<font color="#990000">)</font>
  <b><font color="#0000FF">with</font></b>
    <font color="#990000">|</font> <font color="#009900">Int_of_string</font> _ <font color="#990000">-&gt;</font>
      raise <font color="#990000">(</font><font color="#009900">Bad_zip</font> zip<font color="#990000">)</font>

<b><font color="#0000FF">let</font></b> parse_person s <font color="#990000">=</font>
  <b><font color="#0000FF">match</font></b> <b><font color="#000080">String</font></b><font color="#990000">.</font>split <font color="#990000">~</font>on<font color="#990000">:</font>'<font color="#990000">\</font>t' s <b><font color="#0000FF">with</font></b>
    <font color="#990000">|</font> <font color="#990000">[</font>name<font color="#990000">;</font> age<font color="#990000">;</font> zip<font color="#990000">]</font> <font color="#990000">-&gt;</font>
      <font color="#FF0000">{</font> name <font color="#990000">=</font> parse_name name
      <font color="#990000">;</font> age  <font color="#990000">=</font> parse_age age
      <font color="#990000">;</font> zip  <font color="#990000">=</font> parse_zip zip
      <font color="#FF0000">}</font>
    <font color="#990000">|</font> _ <font color="#990000">-&gt;</font>
      raise <font color="#990000">(</font><font color="#009900">Bad_line</font> s<font color="#990000">)</font>

<b><font color="#0000FF">let</font></b> <font color="#990000">()</font> <font color="#990000">=</font>
  <i><font color="#9A1900">(* Pretend input came from user *)</font></i>
  <b><font color="#0000FF">let</font></b> input <font color="#990000">=</font> <font color="#FF0000">&quot;Joe Mama\t25\t11425&quot;</font> <b><font color="#0000FF">in</font></b>
  <b><font color="#0000FF">try</font></b>
    <b><font color="#0000FF">let</font></b> person <font color="#990000">=</font> parse_person input <b><font color="#0000FF">in</font></b>
    printf <font color="#FF0000">&quot;Name: %s %s\nAge: %d\nZip: %s\n&quot;</font>
      <font color="#990000">(</font>fst person<font color="#990000">.</font>name<font color="#990000">)</font>
      <font color="#990000">(</font>snd person<font color="#990000">.</font>name<font color="#990000">)</font>
      person<font color="#990000">.</font>age
      person<font color="#990000">.</font>zip
  <b><font color="#0000FF">with</font></b>
    <font color="#990000">|</font> <font color="#009900">Bad_line</font> l <font color="#990000">-&gt;</font>
      printf <font color="#FF0000">&quot;Bad line: '%s'\n&quot;</font> l
    <font color="#990000">|</font> <font color="#009900">Bad_name</font> name <font color="#990000">-&gt;</font>
      printf <font color="#FF0000">&quot;Bad name: '%s'\n&quot;</font> name
    <font color="#990000">|</font> <font color="#009900">Bad_age</font> age <font color="#990000">-&gt;</font>
      printf <font color="#FF0000">&quot;Bad age: '%s'\n&quot;</font> age
    <font color="#990000">|</font> <font color="#009900">Bad_zip</font> zip <font color="#990000">-&gt;</font>
      printf <font color="#FF0000">&quot;Bad zip: '%s'\n&quot;</font> zip
</code></pre>

<p>
<a href="https://github.com/orbitz/blog_post_src/blob/master/intro_return_t/ex2.ml">ex2.ml</a> is a basic translation of the above but using variants.  The benefit is that the type system will ensure that all failure case are handled.  The problem is the code is painful to read and modify.  Every function that can fail has its own variant type to represent success and error.  Composing the functions is painful since every thing returns a different type.  We have to create a type that can represent all of the failures the other functions returned.  It would be nice if each function could return an error and we could use that value instead.  It would also be nice if everything read as a series of steps, rather than pattern matching on a tuple which makes it hard to read.
</p>

<p>
<a href="https://github.com/orbitz/blog_post_src/blob/master/intro_return_t/ex3.ml">ex3.ml</a> introduces Core's <code>Result.t</code> type.  The useful addition is that we only need to define a type for <code>parse_person</code>.  Every other function only has one error condition so we can just encode the error in the <code>Error</code> variant.  This is still hard to read, though.  The helper functions aren't so bad but the main function is still painful.
</p>

<p>
While the previous solutions have solved the problem of ensuring that all errors are handled, they introduced the problem of being painful to develop with.  The main problem is that nothing composes.  The helpers have their own error types and for every call to them we have to check their return and then encompass their error in any function above it.  What would be nice is if the compiler could automatically union all of the error codes we want to return from itself and any function it called.  Enter polymorphic variants.
</p>

<p>
<a href="https://github.com/orbitz/blog_post_src/blob/master/intro_return_t/ex4.ml">ex4.ml</a> Shows the version with polymorphic variants.  The nice bit of refactoring we were able to do is in <code>parse_person</code>.  Rather than an ugly match, the calls to the helper functions can be sequenced:
</p>

<pre><code><b><font color="#0000FF">let</font></b> parse_person s <font color="#990000">=</font>
  <b><font color="#0000FF">match</font></b> <b><font color="#000080">String</font></b><font color="#990000">.</font>split <font color="#990000">~</font>on<font color="#990000">:</font>'<font color="#990000">\</font>t' s <b><font color="#0000FF">with</font></b>
    <font color="#990000">|</font> <font color="#990000">[</font>name<font color="#990000">;</font> age<font color="#990000">;</font> zip<font color="#990000">]</font> <font color="#990000">-&gt;</font>
      <b><font color="#0000FF">let</font></b> <b><font color="#000080">open</font></b> <b><font color="#000080">Result</font></b><font color="#990000">.</font><font color="#009900">Monad_infix</font> <b><font color="#0000FF">in</font></b>
      parse_name name <font color="#990000">&gt;&gt;=</font> <b><font color="#0000FF">fun</font></b> name <font color="#990000">-&gt;</font>
      parse_age  age  <font color="#990000">&gt;&gt;=</font> <b><font color="#0000FF">fun</font></b> age  <font color="#990000">-&gt;</font>
      parse_zip  zip  <font color="#990000">&gt;&gt;=</font> <b><font color="#0000FF">fun</font></b> zip  <font color="#990000">-&gt;</font>
      <font color="#009900">Ok</font> <font color="#FF0000">{</font> name<font color="#990000">;</font> age<font color="#990000">;</font> zip <font color="#FF0000">}</font>
    <font color="#990000">|</font> _ <font color="#990000">-&gt;</font>
      <font color="#009900">Error</font> <font color="#990000">(</font>`<font color="#009900">Bad_line</font> s<font color="#990000">)</font>
</code></pre>

<p>
Don't worry about the monad syntax, it's really just to avoid the nesting to make the sequencing easier on the eyes.  Except for the <code>&gt;&gt;=</code>, this looks a lot like code using exceptions.  There is a nice linear flow and only the success path is shown.  But! The compiler will ensure that all failures are handled.
</p>

<p>
The final version of the code is <a href="https://github.com/orbitz/blog_post_src/blob/master/intro_return_t/ex5.ml">ex5.ml</a>.  This takes ex4 and rewrites portions of it to be prettier.  As a disclaimer, I'm sure someone else would consider writing this differently even with the same restrictions I put on it, I might even write it different on a different day, but this version of the code demonstrates the points I am making.
</p>

<p>
A few points of comparison between ex1 and ex5:
</p>

<p>
</p><ul>
<li>The body of <code>parse_person</code> is definitely simpler and easier to read in the exception code.  It is short and concise.</li>
<li>The rest of the helper functions are a bit of a toss-up between the exception and return-value code.  I think one could argue either direction.</li>
<li>The return-value code has fulfilled my requirements in terms of handling failures.  The compiler will complain if any failure <code>parse_person</code> could return is not handled.  If I add another error type the code will not compile.  It also fulfilled the requirements without bloating the code.  The return-value code and exception code are roughly the same number of lines.  Their flows are roughly equal.  But the return-value code is much safer.</li>
</ul>


<h3>Two Points</h3>
<p>
It's not all sunshine and lollipops.  There are two issues to consider:
</p>

<p>
</p><ul>
<li><b>Performance</b> - Exceptions in Ocaml are really, really, fast.  Like any performance issue, I suggest altering code only when needed based on measurements and encapsulating those changes as well as possible.  This also means if you want to provide a safe and an exception version of a function, you should probably implement the safe version in terms of the exception verson.</li>
<li><b>Discipline</b> - I referred to discipline a few times above.  This whole scheme is very easy to mess up with a single mistake: pattern matching on anything (<code>_</code>).  The power of exhaustive pattern matching means you need to match on every error individually.  This is effectively for the same reason catching the exception base class in other languages is such a bad idea, you lose a lot of information.</li>
</ul>



<h3>Conclusion</h3>
<p>
The example given demonstrates an important point: code can become much safer at compile time without detriment to its length or readability.  The cost is low and the benefit is high.  This is a strong reason to prefer a return-value based solution over exceptions in Ocaml.
</p>

