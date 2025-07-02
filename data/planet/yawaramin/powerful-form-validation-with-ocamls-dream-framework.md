---
title: Powerful form validation with OCaml's Dream framework
description: Accessing the power of static typing for server-side form validation
  and error reporting
url: https://dev.to/yawaramin/powerful-form-validation-with-ocamls-dream-framework-4ggj
date: 2024-12-01T17:24:21-00:00
preview_image: https://media2.dev.to/dynamic/image/width=1000,height=500,fit=cover,gravity=auto,format=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fgvu9jty5b0z2w3tvvq9y.png
authors:
- Yawar Amin
source:
ignore:
---

<p>I'VE been a long-time proponent of the power of HTML forms and how natural they make it to build web pages that allow users to input data. Recently, I got a chance to refurbish an old internal application we use at work using <a href="https://htmx.org/" rel="noopener noreferrer">htmx</a> and Scala's Play Framework. In this app we often use HTML forms to submit information. For example:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight html"><code><span class="nt">&lt;form</span> <span class="na">id=</span><span class="s">new-user-form</span> <span class="na">method=</span><span class="s">post</span> <span class="na">action=</span><span class="s">/users</span> <span class="na">hx-post=</span><span class="s">/users</span><span class="nt">&gt;</span>
  <span class="nt">&lt;input</span> <span class="na">name=</span><span class="s">name</span> <span class="na">required</span><span class="nt">&gt;</span>
  <span class="nt">&lt;input</span> <span class="na">type=</span><span class="s">email</span> <span class="na">name=</span><span class="s">email</span> <span class="na">required</span><span class="nt">&gt;</span>
  <span class="nt">&lt;input</span> <span class="na">type=</span><span class="s">checkbox</span> <span class="na">name=</span><span class="s">accept-terms</span> <span class="na">value=</span><span class="s">true</span><span class="nt">&gt;</span>
  <span class="nt">&lt;button</span> <span class="na">type=</span><span class="s">submit</span><span class="nt">&gt;</span>Add User<span class="nt">&lt;/button&gt;</span>
<span class="nt">&lt;/form&gt;</span>
</code></pre>

</div>



<p>Play has <a href="https://www.playframework.com/documentation/3.0.x/ScalaForms" rel="noopener noreferrer">great support</a> for decoding submitted HTML form data into values of custom types and reporting all validation errors that may have occurred, which allowed me to render the errors directly alongside the forms themselves using the Constraint Validation API. I wrote about that in a <a href="https://dev.to/yawaramin/handling-form-errors-in-htmx-3ncg">previous post</a>.</p>

<p>But in the OCaml world, the situation was not that advanced. We had some basic tools for parsing form data into a key-value pair list:</p>

<ul>
<li><a href="https://ocaml.org/p/uri/4.2.0/doc/Uri/index.html#val-query_of_encoded" rel="noopener noreferrer">Uri.query_of_encoded</a></li>
<li><a href="https://ocaml.org/p/dream/latest/doc/Dream/index.html#val-form" rel="noopener noreferrer">Dream.form</a></li>
</ul>

<p>But if we wanted to decode this list into a custom type, we'd need something more sophisticated, like maybe <a href="https://ocaml.org/p/conformist/latest/doc/Conformist/index.html" rel="noopener noreferrer">conformist</a>. <del>However, conformist has the issue that it reports only one error at a time.</del> Actually, conformist has a separate <code>validate</code> function that can report all errors together!</p>

<p>If we have to decode a form submission like:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code>accept-terms: true
</code></pre>

</div>



<p>We would want to see a <em>list</em> of validation errors, like this:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code>name: required
email: required
</code></pre>

</div>



<h2>
  
  
  dream-html form validation
</h2>

<p>Long story short, I decided we needed a more ergonomic form validation experience in OCaml. And since I already maintain a <a href="https://ocaml.org/p/dream-html" rel="noopener noreferrer">package</a> which adds type-safe helpers on top of the Dream web framework, I thought it would make a good addition. Let's take a it for a spin in the REPL:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code>$ utop -require dream-html
# type add_user = {
    name : string;
    email : string;
    accept_terms : bool;
  };;

# let add_user =
    let open Dream_html.Form in
    let+ name = required string "name"
    and+ email = required string "email"
    and+ accept_terms = optional bool "accept-terms" in
    {
      name;
      email;
      accept_terms = Option.value accept_terms ~default:false;
    };;
</code></pre>

</div>



<p>Now we have a value <code>add_user : add_user Dream_html.Form.t</code>, which is a decoder to our custom type. Let's try it:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code># Dream_html.Form.validate add_user [];;
- : (add_user, (string * string) list) result =
Error [("email", "error.required"); ("name", "error.required")]
</code></pre>

</div>



<p>We get back a list of form validation errors, with field names and error message keys (this allows localizing the app).</p>

<p>Let's try a successful decode:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code># Dream_html.Form.validate add_user ["name", "Bob"; "email", "bob@example.com"];;
- : (add_user, (string * string) list) result =
Ok {name = "Bob"; email = "bob@example.com"; accept_terms = false}

# Dream_html.Form.validate add_user ["name", "Bob"; "email", "bob@example.com"; "accept-terms", "true"];;
- : (add_user, (string * string) list) result =
Ok {name = "Bob"; email = "bob@example.com"; accept_terms = true}
</code></pre>

</div>



<p>Let's check for a type error:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code># Dream_html.Form.validate add_user ["name", "Bob"; "email", "bob@example.com"; "accept-terms", "1"];;
- : (add_user, (string * string) list) result =
Error [("accept-terms", "error.expected.bool")]
</code></pre>

</div>



<p>It wants a <code>bool</code>, ie only <code>true</code> or <code>false</code> values. You can make sure your checkboxes always send <code>true</code> on submission by setting <code>value=true</code>.</p>

<h2>
  
  
  Custom value decoders
</h2>

<p>You can decode custom data too. Eg suppose your form has inputs that are supposed to be <a href="https://ocaml.org/p/decimal/latest/doc/Decimal/index.html" rel="noopener noreferrer">decimal numbers</a>:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight html"><code><span class="nt">&lt;input</span> <span class="na">name=</span><span class="s">height-m</span> <span class="na">required</span><span class="nt">&gt;</span>
</code></pre>

</div>



<p>You can write a custom data decoder that can parse a decimal number:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight ocaml"><code><span class="o">#</span> <span class="o">#</span><span class="n">require</span> <span class="s2">"decimal"</span><span class="p">;;</span>
<span class="o">#</span> <span class="k">let</span> <span class="n">decimal</span> <span class="n">s</span> <span class="o">=</span>
    <span class="k">try</span> <span class="nc">Ok</span> <span class="p">(</span><span class="nn">Decimal</span><span class="p">.</span><span class="n">of_string</span> <span class="n">s</span><span class="p">)</span>
    <span class="k">with</span> <span class="nc">Invalid_argument</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="nc">Error</span> <span class="s2">"error.expected.decimal"</span><span class="p">;;</span>
</code></pre>

</div>



<p>Now we can use it:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight ocaml"><code><span class="k">let</span><span class="o">+</span> <span class="n">height_m</span> <span class="o">=</span> <span class="n">required</span> <span class="n">decimal</span> <span class="s2">"height-m"</span>
<span class="o">...</span>
</code></pre>

</div>



<h2>
  
  
  Adding constraints to the values
</h2>

<p>You can add further constraints to values that you decode. Eg, in most form submissions it doesn't make sense for any strings to be empty. So let's define a helper that constrains strings to be non-empty:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight ocaml"><code><span class="k">let</span> <span class="n">nonempty</span> <span class="o">=</span>
  <span class="n">ensure</span> <span class="s2">"expected.nonempty"</span> <span class="p">((</span> <span class="o">&lt;&gt;</span> <span class="p">)</span> <span class="s2">""</span><span class="p">)</span> <span class="n">required</span> <span class="kt">string</span>
</code></pre>

</div>



<p>Now we can write the earlier form definition with stronger constraints for the strings:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight ocaml"><code><span class="k">let</span> <span class="n">add_user</span> <span class="o">=</span>
  <span class="k">let</span> <span class="k">open</span> <span class="nn">Dream_html</span><span class="p">.</span><span class="nc">Form</span> <span class="k">in</span>
  <span class="k">let</span><span class="o">+</span> <span class="n">name</span> <span class="o">=</span> <span class="n">nonempty</span> <span class="s2">"name"</span>
  <span class="ow">and</span><span class="o">+</span> <span class="n">email</span> <span class="o">=</span> <span class="n">nonempty</span> <span class="s2">"email"</span>
  <span class="ow">and</span><span class="o">+</span> <span class="n">accept_terms</span> <span class="o">=</span> <span class="n">optional</span> <span class="kt">bool</span> <span class="s2">"accept-terms"</span> <span class="k">in</span>
  <span class="p">{</span>
    <span class="n">name</span><span class="p">;</span>
    <span class="n">email</span><span class="p">;</span>
    <span class="n">accept_terms</span> <span class="o">=</span> <span class="nn">Option</span><span class="p">.</span><span class="n">value</span> <span class="n">accept_terms</span> <span class="o">~</span><span class="n">default</span><span class="o">:</span><span class="bp">false</span><span class="p">;</span>
  <span class="p">}</span>
</code></pre>

</div>



<h2>
  
  
  Validating forms in Dream handlers
</h2>

<p>In a Dream application, the built-in form handling would look something like this:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight ocaml"><code><span class="c">(* POST /users *)</span>
<span class="k">let</span> <span class="n">post_users</span> <span class="n">request</span> <span class="o">=</span>
  <span class="k">match</span><span class="o">%</span><span class="n">lwt</span> <span class="nn">Dream</span><span class="p">.</span><span class="n">form</span> <span class="n">request</span> <span class="k">with</span>
  <span class="o">|</span> <span class="nt">`Ok</span> <span class="p">[</span><span class="s2">"accept-terms"</span><span class="o">,</span> <span class="n">accept_terms</span><span class="p">;</span> <span class="s2">"email"</span><span class="o">,</span> <span class="n">email</span><span class="p">;</span> <span class="s2">"name"</span><span class="o">,</span> <span class="n">name</span><span class="p">]</span> <span class="o">-&gt;</span>
    <span class="c">(* ...success... *)</span>
  <span class="o">|</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="nn">Dream</span><span class="p">.</span><span class="n">empty</span> <span class="nt">`Bad_Request</span>
</code></pre>

</div>



<p>But with our form validation abilities, we can do something more:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight ocaml"><code><span class="c">(* POST /users *)</span>
<span class="k">let</span> <span class="n">post_users</span> <span class="n">request</span> <span class="o">=</span>
  <span class="k">match</span><span class="o">%</span><span class="n">lwt</span> <span class="nn">Dream_html</span><span class="p">.</span><span class="n">form</span> <span class="n">add_user</span> <span class="n">request</span> <span class="k">with</span>
  <span class="o">|</span> <span class="nt">`Ok</span> <span class="p">{</span> <span class="n">name</span><span class="p">;</span> <span class="n">email</span><span class="p">;</span> <span class="n">accept_terms</span> <span class="p">}</span> <span class="o">-&gt;</span>
    <span class="c">(* ...success... *)</span>
  <span class="o">|</span> <span class="nt">`Invalid</span> <span class="n">errors</span> <span class="o">-&gt;</span>
    <span class="nn">Dream</span><span class="p">.</span><span class="n">json</span> <span class="o">~</span><span class="n">code</span><span class="o">:</span><span class="mi">422</span> <span class="p">(</span> <span class="c">(* ...turn the error list into a JSON object... *)</span> <span class="p">)</span>
  <span class="o">|</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="nn">Dream</span><span class="p">.</span><span class="n">empty</span> <span class="nt">`Bad_Request</span>
</code></pre>

</div>



<h2>
  
  
  Decoding variant type values
</h2>

<p>Of course, variant types are a big part of programming in OCaml, so you might want to decode a form submission into a value of a variant type. Eg,<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight ocaml"><code><span class="k">type</span> <span class="n">user</span> <span class="o">=</span>
<span class="o">|</span> <span class="nc">Logged_out</span>
<span class="o">|</span> <span class="nc">Logged_in</span> <span class="k">of</span> <span class="p">{</span> <span class="n">admin</span> <span class="o">:</span> <span class="kt">bool</span> <span class="p">}</span>
</code></pre>

</div>



<p>You could have a form submission that looked like this:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code>type: logged-out
</code></pre>

</div>



<p>Or:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code>type: logged-in
admin: true
</code></pre>

</div>



<p>Etc.</p>

<p>To decode this kind of submission, you can break it down into decoders for each case, then join them together with <code>Dream_html.Form.( or )</code>, eg:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight ocaml"><code><span class="k">let</span> <span class="n">logged_out</span> <span class="o">=</span>
  <span class="k">let</span><span class="o">+</span> <span class="n">_</span> <span class="o">=</span> <span class="n">ensure</span> <span class="s2">"expected.type"</span> <span class="p">((</span> <span class="o">=</span> <span class="p">)</span> <span class="s2">"logged-out"</span><span class="p">)</span> <span class="n">required</span> <span class="kt">string</span> <span class="s2">"type"</span> <span class="k">in</span>
  <span class="nc">Logged_out</span>

<span class="k">let</span> <span class="n">logged_in</span> <span class="o">=</span>
  <span class="k">let</span><span class="o">+</span> <span class="n">_</span> <span class="o">=</span> <span class="n">ensure</span> <span class="s2">"expected.type"</span> <span class="p">((</span> <span class="o">=</span> <span class="p">)</span> <span class="s2">"logged-in"</span><span class="p">)</span> <span class="n">required</span> <span class="kt">string</span> <span class="s2">"type"</span>
  <span class="ow">and</span><span class="o">+</span> <span class="n">admin</span> <span class="o">=</span> <span class="n">required</span> <span class="kt">bool</span> <span class="s2">"admin"</span> <span class="k">in</span>
  <span class="nc">Logged_in</span> <span class="p">{</span> <span class="n">admin</span> <span class="p">}</span>

<span class="k">let</span> <span class="n">user</span> <span class="o">=</span> <span class="n">logged_out</span> <span class="ow">or</span> <span class="n">logged_in</span>
</code></pre>

</div>



<p>Let's try it:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code># validate user [];;
- : (user, (string * string) list) result =
Error [("admin", "error.required"); ("type", "error.required")]

# validate user ["type", "logged-out"];;
- : (user, (string * string) list) result = Ok Logged_out

# validate user ["type", "logged-in"];;
- : (user, (string * string) list) result = Error [("admin", "error.required")]

# validate user ["type", "logged-in"; "admin", ""];;
- : (user, (string * string) list) result =
Error [("admin", "error.expected.bool")]

# validate user ["type", "logged-in"; "admin", "true"];;
- : (user, (string * string) list) result = Ok (Logged_in { admin = true })
</code></pre>

</div>



<p>As you can see, the decoder can handle either case and all the requirements therein.</p>

<h2>
  
  
  Decoding queries into custom types
</h2>

<p>The decoding functionality works not just with 'forms' but also with queries eg <code>/foo?a=1&amp;b=2</code>. Of course, here we are using 'forms' as a shorthand for the <code>application/x-www-form-urlencoded</code> data that is submitted with a POST request, but actually an HTML form that has <code>action=get</code> submits its input data as a <em>query,</em> part of the URL, not as form data. A little confusing, but the key thing to remember is that Dream can work with both, and so can dream-html.</p>

<p>In Dream, you can get query data using functions like <code>let a = Dream.query request "a"</code>. But if you are submitting more sophisticated data via the query, you can decode them into a custom type using the above form decoding functionality. Eg suppose you want to decode <a href="https://en.wikipedia.org/wiki/UTM_parameters#Parameters" rel="noopener noreferrer">UTM parameters</a> into a custom type:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight ocaml"><code><span class="k">type</span> <span class="n">utm</span> <span class="o">=</span> <span class="p">{</span>
  <span class="n">source</span> <span class="o">:</span> <span class="kt">string</span> <span class="n">option</span><span class="p">;</span>
  <span class="n">medium</span> <span class="o">:</span> <span class="kt">string</span> <span class="n">option</span><span class="p">;</span>
  <span class="n">campaign</span> <span class="o">:</span> <span class="kt">string</span> <span class="n">option</span><span class="p">;</span>
  <span class="n">term</span> <span class="o">:</span> <span class="kt">string</span> <span class="n">option</span><span class="p">;</span>
  <span class="n">content</span> <span class="o">:</span> <span class="kt">string</span> <span class="n">option</span><span class="p">;</span>
<span class="p">}</span>

<span class="k">let</span> <span class="n">utm</span> <span class="o">=</span>
  <span class="k">let</span><span class="o">+</span> <span class="n">source</span> <span class="o">=</span> <span class="n">optional</span> <span class="kt">string</span> <span class="s2">"utm_source"</span>
  <span class="ow">and</span><span class="o">+</span> <span class="n">medium</span> <span class="o">=</span> <span class="n">optional</span> <span class="kt">string</span> <span class="s2">"utm_medium"</span>
  <span class="ow">and</span><span class="o">+</span> <span class="n">campaign</span> <span class="o">=</span> <span class="n">optional</span> <span class="kt">string</span> <span class="s2">"utm_campaign"</span>
  <span class="ow">and</span><span class="o">+</span> <span class="n">term</span> <span class="o">=</span> <span class="n">optional</span> <span class="kt">string</span> <span class="s2">"utm_term"</span>
  <span class="ow">and</span><span class="o">+</span> <span class="n">content</span> <span class="o">=</span> <span class="n">optional</span> <span class="kt">string</span> <span class="s2">"utm_content"</span> <span class="k">in</span>
  <span class="p">{</span> <span class="n">source</span><span class="p">;</span> <span class="n">medium</span><span class="p">;</span> <span class="n">campaign</span><span class="p">;</span> <span class="n">term</span><span class="p">;</span> <span class="n">content</span> <span class="p">}</span>
</code></pre>

</div>



<p>Now, you can use this very similarly to a POST form submission:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight ocaml"><code><span class="k">let</span> <span class="n">some_page</span> <span class="n">request</span> <span class="o">=</span>
  <span class="k">match</span> <span class="nn">Dream_html</span><span class="p">.</span><span class="n">query</span> <span class="n">utm</span> <span class="n">request</span> <span class="k">with</span>
  <span class="o">|</span> <span class="nt">`Ok</span> <span class="p">{</span> <span class="n">source</span><span class="p">;</span> <span class="n">medium</span><span class="p">;</span> <span class="n">campaign</span><span class="p">;</span> <span class="n">term</span><span class="p">;</span> <span class="n">content</span> <span class="p">}</span> <span class="o">-&gt;</span>
    <span class="c">(* ...success... *)</span>
  <span class="o">|</span> <span class="nt">`Invalid</span> <span class="n">errors</span> <span class="o">-&gt;</span> <span class="c">(* ...handle errors... *)</span>
</code></pre>

</div>



<p>And the cool thing is, since they are literally the same form definition, you can switch back and forth between making your request handle POST form data or GET query parameters, with very few changes.</p>

<h2>
  
  
  So...
</h2>

<p>Whew. That was a lot. And I didn't really dig into the even more advanced use cases. But hopefully at this point you might be convinced that forms and queries are now easy to handle in Dream. Of course, you might not really need all this power. For simple use cases, you can probably get away with Dream's built-in capabilities. But for larger apps that maybe need to handle a lot of forms, I think it can be useful.</p>


