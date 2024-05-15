---
title: A quick guide to GADTs and why you ain't gonna need them
description: Ever wanted to use a GADT but did not know if you really needed them?
  You probably don't. And here's why.
url: https://practicalocaml.com/a-quick-guide-to-gadts-and-why-you-aint-gonna-need-them/
date: 2023-08-28T13:46:43-00:00
preview_image:
authors:
- Practical OCaml
source:
---

<p>I've been seeing some more posts about how to use and when to use GADTs. GADTs (Generalized Abstract Data Types, I pronounce them &quot;gats&quot; like in &quot;cats&quot; but with a &quot;g&quot;) are an extension to regular ADTs that is usually reserved for very specific scenarios, but its not always clear which those are and why.</p><p>So I figured I'd give this a shot, and write a super small primer on them, by example. We're gonna write a library that didn't need to use GADTs, and along the way we're gonna feel the pains that come with GADTs, and what specific things they are amazing for.</p><p>Buckle on to your camels! &#128043;</p><h2>GADTs by Example</h2><p>Alright usually you'd write your variant as:</p><pre><code class="language-ocaml">type role = 
  | Guest of guest
  | User of user</code></pre><p>and use it as <code>User(user)</code> or <code>Guest(guest)</code>. You can think of these constructors as little functions that go from some arguments to a value of type <code>role</code>. So really <code>Guest</code> &quot;has type&quot; <code>guest -&gt; role</code>. And <code>User</code> has type <code>user -&gt; role</code>.</p><p>A GADT will let you change (a little) the <em>return type</em> of these constructors. So let's see what our <code>role</code> example looks like with GADT syntax.</p><pre><code class="language-ocaml">type role =
  | Guest: guest -&gt; role
  | User: user -&gt; role</code></pre><p>Neat, right? I really like this syntax.</p><p>But in this case, our <code>role</code> type can't be <em>segmented</em> or <em>parametrized. </em>I mean you can just have <code>role</code>, it's not like an <code>option</code> or a <code>list</code> where you can have an <code>int option</code> or <code>bool list</code> and those are more specific types of <code>option</code> or <code>list</code>. This means we can really only return <code>role</code> in any of our constructors, so <strong>you probably don't need GADTs.</strong> </p><p>Let's look at an example that <em>does not need GADTs </em>but uses them anyway.</p><h3>A Validation Library</h3><p>We'll make a validation type that we can use to mark things as validated throughout our app:</p><pre><code class="language-ocaml">type _ validation =
  | Valid: 'thing -&gt; 'thing validation
  | Invalid: 'thing * string -&gt; 'thing validation
  | Pending: 'thing -&gt; 'thing validation</code></pre><p>Note how using our constructors returns different types. If you use <code>Valid(&quot;hello&quot;)</code> you get a <code>string validation</code>, if you use <code>Invalid(2113, &quot;not cool number&quot;)</code> you get an <code>int validation</code>, and so on.</p><p>If we try to make some helper functions they may look like this:</p><pre><code class="language-ocaml">let make : 'thing -&gt; 'thing validation =
  fun x -&gt; Pending x
 
let get : 'x validation -&gt; 'x =
  function
  | Pending x -&gt; x
  | Valid x -&gt; x
  | Invalid (x, _) -&gt; x
  
let errors : 'x validation -&gt; string option =
  function
  | Invalid (_, err) -&gt; Some err
  | _ -&gt; None 
  
let is_valid : 'x validation -&gt; bool =
  function
  | Valid _ -&gt; true
  | _ -&gt; false</code></pre><p>You can imagine how we'll have to check every time we want to open up a validation, to see if its pending, valid, or invalid. This means other devs will have to remember to check if the validation passed before using the value.</p><p>I don't know about you but I'm 100% certain I will forget to do that at least once.</p><p><strong>GADTs can help us here to reduce the space of all the possible types that our variant constructors create. </strong>Right now, we can essentially create any <code>&lt;type&gt; validation</code> by just passing the right value to the constructors. But we could change that, so that you can statically check a value has passed, is pending, or has failed validation. Our new GADT could look like this:</p><pre><code class="language-ocaml">(* we'll make some abstract types to use for differentiating
   the validation states *)
type pending
type failed
type valid

(* our new validation GADT *)
type _ validation =
  | Pending: 'thing -&gt; pending validation
  | Valid: 'thing -&gt; valid validation
  | Failed: 'thing * string -&gt; failed validation</code></pre><p>This means that our functions can have restricted type signatures and smaller implementations. The compiler now knows that there is only one possible type that matches the <code>Valid</code> constructor, so we can't consider the others.</p><pre><code class="language-ocaml">let make x = Pending x

let get (Valid x) = x

let errors (Fail (_, err)) = err</code></pre><p>Great! The downside is that this code doesn't actually type-check. &nbsp;You can't pattern-match and get a value out of <code>Valid x</code> because the compiler &quot;forgot&quot; what type that value had. Let me show you what I mean. This function:</p><pre><code class="language-ocaml">let get (Valid x) = x</code></pre><p>Fails to type with this error:</p><pre><code class="language-ocaml">File &quot;lib/gadt.ml&quot;, line 18, characters 20-21:
18 | let get (Valid x) = x
                         ^
Error: This expression has type $Valid_'thing
       but an expression was expected of type 'a
       The type constructor $Valid_'thing would escape its scope</code></pre><p>And the type of x in the error is <code>$Valid_'thing</code>, which is a weird type. The compiler yells that it would escape its scope. That's how OCaml tells us <em>&quot;Hey I know there should be a type here but I...erhm...don't know anymore what that type *actually* was. So, yeah, can't let you use it. Sorry&quot;</em>.</p><p>So how does one get this value out?</p><p>Turns out that while the compiler won't let this type <em>escape</em>, if you put many things together inside the same constructor, <em>it will remember if the type was the same across all of them</em>. For example, the compiler is completely happy here:</p><pre><code class="language-ocaml">(* we introduce a function in our Valid arguments *)
type 'validity validation = 
  | Valid: 'thing * ('thing -&gt; bool) -&gt; valid validation
  | ...
  
let get_that_bool (Valid (x, fn)) = fn x </code></pre><p>because it understands that once you pack together a <code>'thing</code> and a <code>'thing -&gt; bool</code>, then it's the same <code>'thing</code>. &nbsp;So this will work for any type. &nbsp;And that's both quite powerful and also super non-obvious at first. Like, what is this useful for? </p><p><strong>GADTs can help us hide type information, but still be able to use it later. </strong>In <a href="https://practicalocaml.com/how-i-explore-domain-problems-faster-and-cheaply-in-ocaml/">the last issue of Practical OCaml</a> we created a <code>route</code> type for our web router that uses this pattern to hide the types that different route-handler functions use as inputs, and it lets us put together into a single list, a bunch of routes that have type-safe parameters/body parsing. Pretty cool. </p><p>Anyways, back to our question, to get our Valid value out, we will need to either:</p><ul><li>let the value <em>escape</em></li><li>or turn it into a type that is known outside the GADT, like include a <code>'thing -&gt; string</code> function so we can always just call that function to turn our <code>'thing</code> into a string and return a string</li></ul><p>We want to preserve the type of our value, so we're gonna do the first. Letting our value escape means actually putting <code>'thing</code> in the return type of our constructors. Like this:</p><pre><code class="language-ocaml">type _ validation =
  | Valid: 'thing -&gt; (valid * 'thing) validation
  | ...</code></pre><p>That's actually all we need. Now the compiler can infer the signature of our <code>get</code> function is <code>(valid * 'thing) validation -&gt; 'thing</code>, and it lets us take that <code>'thing</code> out. BAM. Done.</p><p>And yet our validation solution still doesn't help us actually validate anything. We don't have a function that goes from pending to valid, or from pending to invalid. Since our <code>Pending</code> variant doesn't know what a <code>'thing</code> is, it also doesn't know how to validate it. &nbsp;We'll start there:</p><pre><code class="language-ocaml">(* we added a `fn` to our Pending constructor *)
type _ validation =
  | Pending: 'thing * ('thing -&gt; bool) -&gt; pending validation
  | ...
 
let validate (Pending (x, fn)) =
  if fn x
  then Valid x
  else Invalid (x, &quot;invalid value!&quot;)</code></pre><p>We run the compiler, and see the same issue as before: <code>Valid x</code> would have type <code>$Pending_'thing</code>, because our Pending variant doesn't really expose it's internal <code>'thing</code> type... yadda yadda...we can fix that too by letting <code>'thing</code> escape:</p><pre><code class="language-ocaml">type _ validation =
  | Pending: 'thing * ('thing -&gt; bool) -&gt; (pending * 'thing) validation
  | ...</code></pre><p>Aaaand now we run into another issue. Oof. <code>Valid x</code> and <code>Invalid (x, &quot;invalid value!&quot;)</code> have different types &#128584; &ndash; this is a very common &quot;dead end&quot;.</p><p>For now, we are going to wrap 'em up in a <code>result</code> and it will push the problem to future you and me:</p><pre><code class="language-ocaml">let validate (Pending (x, fn)) =
   if fn x
   then Ok (Valid x)
   else Error (Invalid (x, &quot;invalid value!&quot;))</code></pre><p>So now we can use our Extremely Type-Safe Validation Lib:</p><pre><code class="language-ocaml">let _ =
  let user_value = make 2113 (fun x -&gt; x &gt; 0) in
  match validate user_value with
  | Ok value -&gt;
      let age = get value in
      print_int age;
  | Error err -&gt;
      let err = errors err in
      print_string err;
</code></pre><p>Hopefully implementing this has shown some of the reasons why GADTs while powerful are rather painful to work with. </p><p>For completeness's sake here's the full code:</p><pre><code class="language-ocaml">type valid
type invalid
type pending

type _ validation =
  | Pending : 'thing * ('thing -&gt; bool) -&gt; (pending * 'thing) validation
  | Valid : 'thing -&gt; (valid * 'thing) validation
  | Invalid : 'thing * string -&gt; invalid validation

let make x fn = Pending (x, fn)
let get (Valid x) = x
let errors (Invalid (_, err)) = err

let validate (Pending (x, fn)) =
  if fn x then Ok (Valid x) else Error (Invalid (x, &quot;invalid value!&quot;))</code></pre><h2>Conclusion: You Don't Need GADTs</h2><p>Truth is that unless you are Jane Street and <a href="https://blog.janestreet.com/why-gadts-matter-for-performance/?ref=practicalocaml.com">need to optimize the hell out of your compact arrays</a>, or <a href="https://v2.ocaml.org/manual/gadts-tutorial.html?ref=practicalocaml.com">are writing a toy &lambda;-calculus interpreter</a>, you're probably better off without them.</p><p>GADTs can be super useful if you need to:</p><ol><li>hide type information</li><li>restrict the kind of types that can be instantiated</li><li>have more control over the relation between the input and return type of a function</li></ol><p>But GADTs are not only hard to pronounce, they also come with a host of problems. The ones we've seen, and some more that we haven't that need solutions with wizardly names like <em>locally abstract types </em>or <em>polymorphic recursion.</em> Learning about this is fun and great, but sometimes can get in the way of shipping without substantially improving the quality of your product or developer experience.</p><p>So stick to simpler types until you run into one of those 3 problems and I promise you you'll be a productive, happy camelid &#128640;</p><p>Have you implemented typed state machines in some other ways? Have anything to add or challenge? I'd love to hear it! <a href="https://twitter.com/leostera/status/1696157662122065975?ref=practicalocaml.com">Join the x.com thread</a>.</p><p>Happy Cameling! &#128043;</p><hr/><p>Thanks to <a href="https://twitter.com/patricoferris?ref=practicalocaml.com">@patricoferris</a> for pointing out that if you do implement the above pattern, but move outside the current module (for ex. have a submodule for your <code>valid</code>, <code>invalid</code>, <code>pending</code> types), you may run into some undecidability problems that make pattern-matching non-exhaustive. Oof, many words. The gist is, if you see a &quot;This pattern is non-exhaustive&quot; error, try adding a private constructor to your type-tags:</p><pre><code class="language-ocaml">type valid = private | Valid_tag
type invalid = private | Invalid_tag
type pending = private | Pending_tag</code></pre><p>For a more detailed answer, check out this <a href="https://discuss.ocaml.org/t/gadt-pattern-matching-exhaustiveness/7195?ref=practicalocaml.com">OCaml forum post</a>.</p><p></p>
