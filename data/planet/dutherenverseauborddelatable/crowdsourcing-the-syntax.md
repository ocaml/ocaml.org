---
title: Crowdsourcing the syntax
description: "Feedback from Opa testers suggests that we can improve the syntax and
  make it easier for developers new to Opa to read and write code. We have spent some
  time both inside the Opa team and with the \u2026"
url: https://dutherenverseauborddelatable.wordpress.com/2011/05/30/crowdsourcing-the-syntax/
date: 2011-05-30T10:22:24-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- dutherenverseauborddelatable
---

<p style="text-align:justify;"><em>Feedback from Opa testers suggests that we can improve the syntax and make it easier for developers new to Opa to read and write code. We have spent some time both inside the Opa team and with the testers designing two possible revisions to the syntax. Feedback on both possible revisions, as well as alternative ideas, are welcome.</em></p>
<p style="text-align:justify;">A few days ago, we announced the <a href="http://www.opalang.org">Opa platform</a>, and I&rsquo;m happy to announce that things are going very well. We have received numerous applications for the closed preview &ndash; we now have onboard people from Mozilla, Google and Twitter, to quote but a few, from many startups, and even from famous defense contractors &ndash; and I&rsquo;d like to start this post by thanking all the applicants. It&rsquo;s really great to have you guys &amp; gals and your feedback. We are still accepting applications, by the way.</p>
<p style="text-align:justify;">Speaking of feedback, we got plenty of it, too, on just about everything Opa, much of it on the syntax. This focus on syntax is only fair, as syntax is both the first thing a new developer sees of a language and something that they have to live with daily. And feedback on the syntax indicates rather clearly that our syntax, while being extremely concise, was perceived as too exotic by many developers.</p>
<p style="text-align:justify;">Well, we aim to please, so we have spent some time with our testers working on possible syntax revisions, and we have converged on two possible syntaxes. In this post, I will walk you through syntax changes. Please keep in mind that we are very much interested in feedback, so do not hesitate to contact us, either by leaving comments on this blog, by <a href="irc://irc.freenode.net/#opalang">IRC</a>, or at <a href="mailto:feedback@opalang.org">feedback@opalang.org</a> .</p>
<p style="text-align:justify;padding-left:30px;"><strong>Important note</strong>: that we will continue supporting the previous syntax for some time and we will provide tools to automatically convert from the previous syntax to the revised syntax.</p>
<p>Let me walk you through syntax changes.</p>
<p><span></span></p>
<h2>Edit</h2>
<ul>
<li>Fixed typoes.</li>
<li>Removed most comments from revised versions, they were redundant.</li>
</ul>
<h2>Hello, web</h2>
<h3>Original syntax</h3>
<pre class="brush: fsharp; title: ; notranslate">
start() = &lt;&gt;Hello, web!&lt;/&gt;
server = one_page_server(&quot;Hello&quot;, start)
</pre>
<p>or, equivalently,</p>
<pre class="brush: fsharp; title: ; notranslate">
server = one_page_server(&quot;Hello&quot;, -&gt; &lt;&gt;Hello, web!&lt;/&gt;)
</pre>
<p>This application involves the following operations:</p>
<ul>
<li>define some HTML content &ndash; note that this is actually a data structure, <em>not</em> inline HTML;</li>
<li>put this content in a either a function called start (first version) or an anonymous function (second version);</li>
<li>call function one_page_server to build a server;</li>
<li>use this server as our main server.</li>
</ul>
<h3>Revised syntax, candidate 1</h3>
<pre class="brush: jscript; title: ; notranslate">
/**
 * The function defining our user interface.
 */
start() {
  &lt;&gt;Hello, web!&lt;/&gt; //HTML-like content.
  //As the last value of the function, this is the result.
}

/**
 * Create and start a server delivering user interface [start]
 */
start_server(one_page_server(&quot;Hello&quot;, start))
</pre>
<p style="text-align:right;"><a href="https://gist.github.com/995020">Fork me on github</a></p>
<p>or, equivalently</p>
<pre class="brush: jscript; title: ; notranslate">
/**
 * The function defining our user interface.
 */
start = -&gt; &lt;&gt;Hello, web!&lt;/&gt; //HTML-like content.
  //Using the syntax for anonymous functions

/**
 * Create and start a server delivering user interface [start]
 */
start_server(one_page_server(&quot;Hello&quot;, start))
</pre>
<p style="text-align:right;"><a href="https://gist.github.com/998663">Fork me on github</a></p>
<p>or, equivalently</p>
<pre class="brush: jscript; title: ; notranslate">
start_server(one_page_server(&quot;Hello&quot;, -&gt; &lt;&gt;Hello, web!&lt;/&gt; ));
</pre>
<p style="text-align:right;"><a href="https://gist.github.com/995032">Fork me on github</a></p>
<h4>Rationale of the redesign</h4>
<ul>
<li>JS-style <strong>{}</strong> around function bodies indicate clearly where a function starts and where a function ends, which makes it easier for people who do not know the language to make sense of source code;</li>
<li>an explicit call to function start_server makes it more discoverable and intelligible that you can define several servers in one application.</li>
</ul>
<h4>Not redesigned</h4>
<ul>
<li>the HTML-like for user interface &ndash; feedback indicates that developers understand it immediately;</li>
<li>anonymous functions can still be written with <strong>-&gt;</strong> &ndash; this syntax is both lightweight and readable;</li>
<li>the fact that the last value of a function is its result &ndash; now that we have the curly braces, it&rsquo;s clear, and it fits much better with our programming paradigm than a <strong>return</strong> that would immediately stop the flow of the function and would not interact too nicely with our concurrency model;</li>
<li>the syntax of comments &ndash; it works as it is.</li>
</ul>
<h3>Revised syntax, candidate 2</h3>
<pre class="brush: jscript; title: ; notranslate">
/**
 * The function defining our user interface.
 */
def start():
  &lt;&gt;Hello, web!&lt;/&gt; //HTML-like content.
  //As the last value of the function, this is the result.

/**
 * Create and start a server delivering user interface [start]
 */
server:
   one_page_server(&quot;Hello&quot;, start)
</pre>
<p style="text-align:right;"><a href="https://gist.github.com/998667">Fork me on github</a></p>
<p>or, equivalently</p>
<pre class="brush: jscript; title: ; notranslate">
server:
   one_page_server(&quot;Hello&quot;, def(): &lt;&gt;Hello, web!&lt;/&gt;)
</pre>
<p style="text-align:right;"><a href="https://gist.github.com/998669">Fork me on github</a></p>
<h4>Redesign and rationale</h4>
<ul>
<li>Python-style meaningful indents force readable pagination;</li>
<li>in the second version, Python-inspired anonymous &ldquo;<strong>def</strong>&rdquo; makes it easier to spot anonymous functions and their arguments &ndash; note that this is not quite Python &ldquo;<strong>lambda</strong>&ldquo;, as there is no semantic difference between what an anonymous function can do and what a named function can do ;</li>
<li>Keyword <strong>server:</strong> is clearer than declaration <strong>server =</strong> .</li>
</ul>
<h4>Not redesigned</h4>
<p>as above</p>
<h2>Distributed key-value store</h2>
<h3>Original syntax</h3>
<pre class="brush: fsharp; title: ; notranslate">
/**
 * Add a path called [/storage] to the schema of our
 * graph database.
 *
 * This path is used to store one value with type
 * [stringmap(option(string))]. A [stringmap] is a dictionary.
 * An [option(string)] is an optional [string],
 * i.e. a value that may either be a string or omitted.
 *
 * This path therefore stores an association from [string]
 * (the key) to either a [string] (the value) or nothing
 * (no value).
 */
db /storage: stringmap(option(string))
</pre>
<p style="text-align:justify;">This extract adds a path to the database schema and provides the type of the value stored at this path. Note that Opa offers a graph database. Each path contains exactly <em>one</em> value. To store several values at one path, we actually store a container, which integrates nicely into the graph. Here, Opa will detect that what we are storing is essentially a table, and will automatically optimize storage to take advantage of this information.</p>
<pre class="brush: fsharp; title: ; notranslate">
/**
 * Handle requests.
 *
 * @param request The uri of the request. The URI is converted
 * to a key in [/storage], the method determines what should be
 * done, and in the case of [{post}] requests, the body is used
 * to set the value in the db
 *
 * @return If the request is rejected, [{method_not_allowed}].
 * If the request is a successful [{get}], a &quot;text/plain&quot;
 * resource with the value previously stored. If the request
 * is a [{get}] to an unknown key, a [{wrong_address}].
 * Otherwise, a [{success}].
 */
dispatch(request) =
(
  key = List.to_string(request.uri.path)
  match request.method with
   | {some = {get}}    -&gt;
     match /storage[key] with
       | {none}        -&gt; Resource.raw_status({wrong_address})
       | {some = value}-&gt; Resource.raw_response(value,
               &quot;text/plain&quot;, {success})
     end
   | {some = {post}}   -&gt;
         do /storage[key] &lt;- request.body
         Resource.raw_status({success})
   | {some = {delete}} -&gt;
         do Db.remove(@/storage[key])
         Resource.raw_status({success})
   | _ -&gt; Resource.raw_status({method_not_allowed})
  end
)
</pre>
<p>This extract&nbsp; inspects the HTTP method of the request to decide what to do with the request &ndash; this is called &ldquo;pattern-matching&rdquo;. First case handles GET and performs further matching on the database to determine whether the key is already associated to a value.</p>
<pre class="brush: fsharp; title: ; notranslate">
/**
 * Main entry point: launching the server.
 */
server = Server.simple_request_dispatch(dispatch)
</pre>
<p>Finally, this extract launches the server.</p>
<h3>Revised syntax, candidate 1</h3>
<p style="text-align:right;"><a href="https://gist.github.com/993180">Fork me on github</a></p>
<pre class="brush: jscript; title: ; notranslate">
db {
  option&lt;string&gt; /storage[string];
}
</pre>
<p>or, equivalently,</p>
<pre class="brush: jscript; title: ; notranslate">
db option&lt;string&gt; /storage[string];
</pre>
<h4>Redesigns and rationale</h4>
<ul>
<li>The type of the value appears before the value &ndash; this is more understandable by developers used to C-style syntax.</li>
<li>Syntactic sugar makes it clear that the path is indexed by strings &ndash; this syntax matches the syntax used to place requests or to update the value.</li>
<li>Allowing braces around schema declaration is a good visual clue.</li>
<li>We now use &lt;&gt; for generics syntax &ndash; again, this matches the syntax of C++, Java, C# and statically typed JS extensions.</li>
</ul>
<h4>Not redesigned</h4>
<ul>
<li>Keyword <strong>db</strong> &ndash; we need a keyword to make it clear that we are talking about the database.</li>
</ul>
<pre class="brush: jscript; title: ; notranslate">
dispatch(request) {
  key = List.to_string(request.uri.path);
  match(request.method) {
    case {some: {get}}:
       &nbsp;match(/storage[key]) {
           case {none}:  Resource.raw_status({wrong_address});
           case {some: value}: Resource.raw_response(value,
              &quot;text/plain&quot;, {success});
        }
    case {some: {post}}: {
         /storage[key] &lt;- request.body;
         Resource.raw_status({success})
    }
    case {some: {delete}}: {
         Db.remove(@/storage[key]);
         Resource.raw_status({success});
    }
    case *: Resource.raw_status({method_not_allowed});
  }
}
</pre>
<h4>Redesigns and rationale</h4>
<ul>
<li>Pattern-matching syntax&nbsp; becomes&nbsp; <strong>match</strong>(&hellip;) { <strong>case</strong> case_1: &hellip;; <strong>case</strong> case_2: &hellip;; &hellip; } &ndash; this syntax resembles that of <strong>switch</strong>(), and is therefore more understandable by developers who are not accustomed to pattern-matching. Note that pattern-matching is both more powerful than switch and has a different branching mechanism, so reusing keywords switch and default would have mislead developers.</li>
<li>Records now use <strong>:</strong> instead of <strong>=</strong>, as in JavaScript &ndash; now that we use curly braces, this is necessary to ensure that there is a visual difference between blocks and structures.</li>
</ul>
<h4>Not redesigned</h4>
<ul>
<li>Operator <strong>&lt;-</strong> for updating a database path &ndash; we want developers to be aware that this operation is very different from =, which serves to define new values.</li>
<li>The syntax for paths &ndash; it&rsquo;s simple, concise and it&rsquo;s an immediate cue that we are dealing with a persistent value.</li>
</ul>
<pre class="brush: jscript; title: ; notranslate">
start_server(Server.simple_request_dispatch(dispatch))
</pre>
<p>No additional redesigns or rationales.</p>
<h3>Revised syntax, candidate 2</h3>
<p style="text-align:right;"><a href="https://gist.github.com/993279">Fork me on github</a></p>
<pre class="brush: jscript; title: ; notranslate">
db:
 &nbsp;/storage[string] as option(string)
</pre>
<h4>Redesigns and rationale</h4>
<ul>
<li>Again, Python-style meaningful indents force readable pagination;</li>
<li>syntactic sugar makes it clear that the path is indexed by strings &ndash; this syntax matches the syntax used to place requests or to update the value;</li>
<li>keyword <strong>as</strong> (inspired by Boo) replaces <strong>:</strong> (which is used pervasively in Python syntax);</li>
<li>python-style keyword <strong>db:</strong> is more visible than <strong>db</strong>.</li>
</ul>
<h4>Not redesigned</h4>
<ul>
<li>We still use parentheses for generic types &ndash; no need to clutter the syntax with Java-like Foo&lt;Bar&gt;</li>
</ul>
<pre class="brush: jscript; title: ; notranslate">
def dispatch(request):
  key = List.to_string(request.uri.path)
  match request.method:
    case {some = {get}}:
       match /storage[key]:
          case {none}:        Resource.raw_status({wrong_address})
          case {some: value}: Resource.raw_response(value,
                &quot;text/plain&quot;, {success});
    case {some = {post}}:
         /storage[key] &lt;- request.body
         Resource.raw_status({success})
    case {some = {delete}}:
         Db.remove(@/storage[key])
         Resource.raw_status({success})
    case *:
         Resource.raw_status({method_not_allowed})
</pre>
<h4>Redesigns and rationale</h4>
<ul>
<li>Pattern-matching syntax&nbsp; becomes&nbsp; <strong>match</strong>: and <strong>case</strong> &hellip;: &hellip; .</li>
</ul>
<h4>Not redesigned</h4>
<p>As above</p>
<pre class="brush: jscript; title: ; notranslate">
server:
   Server.simple_request_dispatch(dispatch)
</pre>
<p>No further redesign.</p>
<h2>Web chat</h2>
<h3>Original syntax</h3>
<pre class="brush: csharp; title: ; notranslate">
/**
 * {1 Network infrastructure}
 */

/**
 * The type of messages sent by a client to the chatroom
 */
type message = {author: string /**Arbitrary, untrusted, name*/
              ; text: string&nbsp; /**Content entered by the user*/}

/**
 * A structure for routing and broadcasting values of type
 * [message].
 *
 * Clients can send values to be broadcasted or register
 * callbacks to be informed of the broadcast. Note that
 * this routing can work cross-client and cross-server.
 *
 * For distribution purposes, this network will be
 * registered to the network as &quot;mushroom&quot;.
 */
room = Network.cloud(&quot;mushroom&quot;): Network.network(message)
</pre>
<p>In this extract, we define a type and the distribution infrastructure to broadcast value changes between servers or between clients and servers. Needless to say, these two lines hide some very powerful core concepts of Opa.</p>
<pre class="brush: csharp; title: ; notranslate">
/**
 * Update the user interface in reaction to reception
 * of a message.
 *
 * This function is meant to be registered with [room]
 * as a callback. Its sole role is to display the new message
 * in [#conversation].
 *
 * @param x The message received from the chatroom
 */
user_update(x) =
(
  line = &lt;div&gt;
     &lt;div&gt;{x.author}:&lt;/div&gt;
     &lt;div&gt;{x.text}&lt;/div&gt;
  &lt;/div&gt;
  do Dom.transform([#conversation +&lt;- line ])
  Dom.scroll_to_bottom(#conversation)
)

/**
 * Broadcast text to the [room].
 *
 * Read the contents of [#entry], clear these contents and send
 * the message to [room].
 *
 * @param author The name of the author. Will be included in the
 * message broadcasted.
 */
broadcast(author) =
  do Network.broadcast({author=author
     text=Dom.get_value(#entry)}, room)
  Dom.clear_value(#entry)

/**
 * Build the user interface for a client.
 *
 * Pick a random author name which will be used throughout
 * the chat.
 *
 * @return The user interface, ready to be sent by the server to
 * the client on connection.
 */
start() =
(
    author = Random.string(8)
    &lt;div id=#conversation
     onready={_ -&gt; Network.add_callback(user_update, room)}&gt;&lt;/div&gt;
    &lt;input id=#entry  onnewline={_ -&gt; broadcast(author)}/&gt;
    &lt;div onclick={_ -&gt; broadcast(author)}&gt;Send!&lt;/div&gt;
)
</pre>
<p>In this extract, we define the user interface and connect it to the aforementioned distribution mechanism. Again, we describe the user interface as a datastructure in a HTML-like syntax.</p>
<pre class="brush: csharp; title: ; notranslate">
/**
 * Main entry point.
 *
 * Construct an application called &quot;Chat&quot; (users
 * will see the name in the title bar), embedding
 * statically the contents of directory &quot;resources&quot;,
 * using the global stylesheet &quot;resources/css.css&quot;
 * and the user interface defined in [start].
 */
server = Server.one_page_bundle(&quot;Chat&quot;,
    [@static_resource_directory(&quot;resources&quot;)],
    [&quot;resources/css.css&quot;], start)
</pre>
<p>Finally, as usual, we define our main entry point, with our user interface and a bundle of resources.</p>
<h3>Revised syntax, candidate 1</h3>
<p style="text-align:right;"><a href="https://gist.github.com/993179">Fork me on github</a></p>
<pre class="brush: jscript; title: ; notranslate">
type message = {author: string /**Arbitrary, untrusted, name*/
               ,text:   string} /**Content entered by the user*/

Network.network&lt;message&gt; room = Network.cloud(&quot;mushroom&quot;)

user_update(x) {
  line = &lt;div&gt;
     &lt;div&gt;{x.author}:&lt;/div&gt;
     &lt;div&gt;{x.text}&lt;/div&gt;
  &lt;/div&gt;;
  Dom.transform([#conversation +&lt;- line ]);//Note: If we want to change the syntax of actions, now is the right time
  Dom.scroll_to_bottom(#conversation)
}

broadcast(author){
  Network.broadcast({author=author,
    text:Dom.get_value(#entry)}, room);
  Dom.clear_value(#entry)
}

start() {
  author = Random.string(8);
  &lt;div id=#conversation
    onready={ * -&gt; Network.add_callback(user_update, room) }&gt;&lt;/div&gt;
  &lt;input id=#entry&nbsp; onnewline={ * -&gt; broadcast(author) }/&gt;
  &lt;div onclick={ * -&gt; broadcast(author) }&gt;Send!&lt;/div&gt;
}

start_server(Server.one_page_bundle(&quot;Chat&quot;,
   [@static_resource_directory(&quot;resources&quot;)],
   [&quot;resources/css.css&quot;], start))

</pre>
<h3>Revised syntax, candidate 2</h3>
<p style="text-align:right;"><a href="https://gist.github.com/993277">Fork me on github</a></p>
<pre class="brush: jscript; title: ; notranslate">
type message:
   author as string //Arbitrary, untrusted, name
   text   as string   //Content entered by the user

room = Network.cloud(&quot;mushroom&quot;) as Network.network(message)
</pre>
<h4>Redesign and rationale</h4>
<ul>
<li>We introduce a Python-ish/Boo-ish syntax for defining types.</li>
<li>Again, we use <strong>as</strong> instead of <strong>:</strong> for type annotations.</li>
</ul>
<pre class="brush: jscript; title: ; notranslate">
def user_update(x):
  line = &lt;div&gt;
    &lt;div&gt;{x.author}:&lt;/div&gt;
    &lt;div&gt;{x.text}&lt;/div&gt;
  &lt;/div&gt;
  Dom.transform([#conversation +&lt;- line ])//Note: If we want to change the syntax of actions, now is the right time
  Dom.scroll_to_bottom(#conversation)

def broadcast(author):
   message = new:
      author: author
      text:   Dom.get_value(#entry)
   Network.broadcast(message, room)
   Dom.clear_value(#entry)
</pre>
<h4>Redesign and rationale</h4>
<ul>
<li>We introduce a new keyword <strong>new:</strong> to define immediate records &ndash; we find this both clearer than the Python syntax for defining objects as dictionaries, and more suited to both our paradigm and our automated analysis.</li>
</ul>
<pre class="brush: jscript; title: ; notranslate">
def start():
   author = Random.string(8)
   html:
    &lt;div id=#conversation onready={def *: Network.add_callback(user_update, room)}&gt;&lt;/div&gt;
    &lt;input id=$entry onnewline={def *: broadcast(author)}/&gt;
    &lt;div onclick={def *: broadcast(author)}&gt;Send!&lt;/div&gt;
</pre>
<h4>Redesign and rationale</h4>
<ul>
<li>We introduce keyword <strong>html:</strong> to introduce a block of HTML-like notations. A similar keyword <strong>xml:</strong> will be used when producing XML documents with a XML-like notation.</li>
</ul>
<pre class="brush: jscript; title: ; notranslate">
server:
  Server.one_page_bundle(&quot;Chat&quot;,
    [@static_resource_directory(&quot;resources&quot;)],
    [&quot;resources/css.css&quot;], start)
</pre>
<p>No additional change here.</p>
<h2>What now?</h2>
<p style="text-align:justify;">At this stage, we have not switched syntax yet and we have the following options:</p>
<ul>
<li>keep our current syntax;</li>
<li>adopt revised syntax 1, <em>or a variant thereof</em> &ndash; so, start coding a conversion tool, the new syntax itself, and start updating the documentation;</li>
<li>adopt revised syntax 2, <em>or a variant thereof</em> &ndash; so, start coding a conversion tool, the new syntax itself, and start updating the documentation;</li>
</ul>
<p style="text-align:justify;">Yes, I mention variants, because I am certain that many among you will have interesting ideas. So please feel free to express yourselves.</p>
<p>You can provide feedback:</p>
<ul>
<li>on this blog;</li>
<li>by e-mail, at feedback@opalang.org;</li>
<li>on <a href="irc://irc.freenode.net/#opalang">IRC</a>.</li>
</ul>
<p>Remember, we are still <a href="http://opalang.org">accepting applications for the preview</a>.</p>

