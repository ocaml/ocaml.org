---
title: Unbreaking Scalable Web Development, One Loc at a Time
description: "The Opa platform was created to address the problem of developing secure,
  scalable web applications. Opa is a commercially supported open-source programming
  language designed for web, concurrency, \u2026"
url: https://dutherenverseauborddelatable.wordpress.com/2011/05/23/unbreaking-scalable-web-development-one-loc-at-a-time/
date: 2011-05-23T12:59:29-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- dutherenverseauborddelatable
---

<p style="text-align:justify;"><em>The Opa platform was created to address the problem of developing secure, scalable web applications. Opa is a commercially supported open-source programming language designed for web, concurrency, distribution, scalability and security. We have entered closed beta and the code will be released soon on <a href="http://opalang.org" target="_blank">http://opalang.org</a>, as an <a href="http://owasp.org">Owasp project</a> .<br/>
</em></p>
<ul>
<li><strong>Edit</strong> The video spawned a conversation on <a href="http://www.reddit.com/r/programming/comments/hidsa/opa_one_language_for_all_the_stack_forget/">Reddit</a>.</li>
<li><strong>Edit</strong> Interesting followup on <a href="http://news.ycombinator.com/item?id=2575939">Hacker News</a>.</li>
<li><strong>Edit</strong> Reworked source code &amp; comments for clarity. Thanks for the feedback.</li>
<li><strong>Edit</strong>Come and chat with us <a href="irc://irc.freenode.net/#opalang">on Freenode, channel #opalang </a>.</li>
</ul>
<p style="text-align:justify;">If you are a true coder, sometimes, you meet a problem so irritating, or a solution so clumsy, that challenging it is a matter of engineering pride. I assume that many of the greatest technologies we have today were born from such challenges, from OpenGL to the web itself. The pain of pure LAMP-based web development begat Ruby on Rails, Django or Node.js, as well as the current NoSQL generation. Similarly, the pains of scalable large system development with raw tools begat Erlang, Map/Reduce or Project Voldemort.</p>
<p style="text-align:justify;">Opa was born from the pains of developing scalable, secure web applications. Because, for all the merits of existing solutions, we just knew that we could do much, much better.</p>
<p style="text-align:justify;">Unsurprisingly, getting there was quite a challenge. Between the initial idea and an actual platform lay blood, sweat and code, many experiments and failed prototypes, but finally, we got there. After years of development and real-scale testing, we are now getting ready to release the result.</p>
<p style="text-align:justify;">The parents are proud to finally introduce <a href="http://opalang.org">Opa</a>.<span></span></p>
<h2 style="text-align:justify;">Different means to different ends</h2>
<p style="text-align:justify;">Opa is a new approach to scalable, secure web development.</p>
<p style="text-align:justify;">The core idea behind Opa is that <strong><em>once you use the right paradigm, scalability, security and the web model just happen naturally</em></strong>.</p>
<p style="text-align:justify;">To implement our idea, we had to provide developers with a programming language that was:</p>
<ol>
<li>powerful enough to describe the complete behavior of the web application, including user interface, interactivity, concurrency, general-purpose computations and database manipulation;</li>
<li>clean enough to support automated security analysis;</li>
<li>high-level enough to support transparent distribution, optimization and injection of security checks;</li>
<li>understandable by any developer.</li>
</ol>
<p style="text-align:justify;">This is not a benign idea. Most approaches to web development, to security or scalability rely either on libraries, external tiers, or reflexivity. For all their merits, and even when applied to the best/most modular/most extensible programming languages available, these techniques are still heavily rooted on whichever paradigm is best handled by that language. Some of the results can be impressive &ndash; including your favorite framework, whichever it may be &ndash; but in the end, they are necessarily limited by the underlying tools. Unfortunately, we could not find any existing language &ndash; whether static, dynamic or hybrid &ndash; that could fit all criteria. So, we had to build our own.</p>
<p>This is also not an easy idea for us. We spent years designing, testing, fine-tuning our paradigm, as well as ensuring that the result was indeed usable by any developer.</p>
<h3 style="text-align:justify;"><strong>Opa is a new programming language</strong> and its runtime environment</h3>
<p style="text-align:justify;">With Opa, write your complete application in just one language, and the compiler will transform it into a self-sufficient executable containing:</p>
<ul style="text-align:justify;">
<li>server-side code;</li>
<li>client-side code (cross-browser JavaScript and HTML, generated automatically from your source code);</li>
<li>database code (compiled queries for our own NoSQL, scalable database);</li>
<li>distribution code;</li>
<li>all the glue to connect everything to everything else;</li>
<li>security checks at boundaries;</li>
<li>the HTTP server itself;</li>
<li>the database engine itself;</li>
<li>the distribution layers themselves.</li>
</ul>
<p style="text-align:justify;">Launch this executable locally, or ask it to deploy itself on any number of servers, and your web application is running. <em>Do not</em> deploy or configure a DBMS. <em>Do not</em> deploy or configure a web server. <em>Do not</em> deploy or configure a distributed file system. It just works.</p>
<h2 style="text-align:justify;">Programming with Opa</h2>
<p style="text-align:justify;">Opa may be a new language, but it is quite understandable if you have notions of web development. Let me show you a few simple but complete applications. Should you wish to play with them, I have uploaded the source code of each application on github as AGPL.</p>
<h3>Hello, web</h3>
<p>First variant: 1 eloc</p>
<pre class="brush: fsharp; title: ; notranslate">
 server = one_page_server(&quot;Hello&quot;, -&gt; &lt;&gt;Hello, web!&lt;/&gt;)
</pre>
<div style="text-align:right;"><a href="https://gist.github.com/985817">Fork me on github</a></div>
<p>Second variant: 2 eloc</p>
<pre class="brush: fsharp; title: ; notranslate">
server = Server.simple_dispatch(_ -&gt;
  html(&quot;Hello&quot;, &lt;&gt;Hello, web!&lt;/&gt;)
)
</pre>
<div style="text-align:right;"><a href="https://gist.github.com/985820">Fork me on github</a></div>
<p>Build &amp; launch:</p>
<pre class="brush: bash; title: ; notranslate">
$ opa hello_web.opa
$ ./hello_web.exe
</pre>
<p style="text-align:justify;">That&rsquo;s it. Your application is launched, you can connect with any (recent) browser.</p>
<h3>A minimal (distributed, load-balanced) key-value store</h3>
<p>Source code, in 17 eloc:</p>
<pre class="brush: csharp; title: ; notranslate">
/**
 * Add a path called [/storage] to the schema of our graph database.
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

/**
 * Handle requests.
 *
 * @param request The uri of the request. The URI is converted to
 * a key in [/storage], the method determines what should be done,
 * and in the case of [{post}] requests, the body is used to set
 * the value in the db
 *
 * @return If the request is rejected, [{method_not_allowed}].
 * If the request is a successful [{get}], a &quot;text/plain&quot; resource
 * with the value previously stored. If the request is a [{get}] to
 * an unknown key, a [{wrong_address}].
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
         do /storage[key]
         do Db.remove(@/storage[key])
         Resource.raw_status({success})
   | _ -&gt; Resource.raw_status({method_not_allowed})
  end
)

/**
 * Main entry point: launching the server.
 */
server = Server.simple_request_dispatch(dispatch)
</pre>
<div style="text-align:right;"><a href="https://github.com/Yoric/OpaStorage#fork_box">Fork me on github</a></div>
<p>Build:</p>
<pre class="brush: bash; title: ; notranslate">
$ opa opa_storage.opa
</pre>
<p>Launch on one server</p>
<pre class="brush: bash; title: ; notranslate">
$ ./opa_storage.exe
</pre>
<p>Or auto-deploy and launch on several servers:</p>
<pre class="brush: bash; title: ; notranslate">
$ opa-cloud opa_storage.exe --host localhost --host me@host1 --host me@host2
</pre>
<p style="text-align:justify;">Again, that&rsquo;s it. Key/value pairs are replicated/distributed on the various nodes (default settings are generally ok, but replication factor can be configured if necessary), requests are load-balanced and it just works.</p>
<p style="text-align:justify;">Just as importantly, note that we have not written any single line of code for ensuring security with respect to database injection. By construction, Opa ensures automatically that such injections cannot happen.</p>
<h3>Real-time web chat</h3>
<p>Source code, in 20 eloc:</p>
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

/**
 * {1 User interface}
 */

/**
 * Update the user interface in reaction to reception of a message.
 *
 * This function is meant to be registered with [room] as a callback.
 * Its sole role is to display the new message in [#conversation].
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
  do Network.broadcast({author=author text=Dom.get_value(#entry)}, room)
  Dom.clear_value(#entry)

/**
 * Build the user interface for a client.
 *
 * Pick a random author name which will be used throughout the chat.
 *
 * @return The user interface, ready to be sent by the server to the client
 * on connection.
 */
start() =
(
    author = Random.string(8)
    &lt;div id=#conversation
     onready={_ -&gt; Network.add_callback(user_update, room)}&gt;&lt;/div&gt;
   &lt;input id=#entry  onnewline={_ -&gt; broadcast(author)}/&gt;
   &lt;div class=&quot;button&quot; onclick={_ -&gt; broadcast(author)}&gt;Send!&lt;/div&gt;
)

/**
 * {1 Application}
 */

/**
 * Main entry point.
 *
 * Construct an application called &quot;Chat&quot; (users will see the name in the title bar),
 * embedding statically the contents of directory &quot;resources&quot;, using the global
 * stylesheet &quot;resources/css.css&quot; and the user interface defined in [start].
 */
server = Server.one_page_bundle(&quot;Chat&quot;,
    [@static_resource_directory(&quot;resources&quot;)],
    [&quot;resources/css.css&quot;], start)
</pre>
<p style="text-align:right;"><a href="https://github.com/Yoric/OpaChat#fork_box">Fork me on github</a></p>
<p style="text-align:justify;">Build and launch as above:</p>
<pre class="brush: bash; title: ; notranslate">
$ opa opa_chat.opa

$ opa-cloud opa_chat.exe --host localhost --host me@host1 --host me@host2
</pre>
<p style="text-align:justify;">Users connecting to the launch server are load-balanced among servers. Users connecting to one server can chat transparently with users connected to other servers.</p>
<p style="text-align:justify;">Just as importantly, note that we have not written any single line of code for ensuring security with respect to Cross-Site Scripting. Still, you can try and inject code in this application &ndash; and you will fail. Opa has transparently ensured that this cannot happen.</p>
<h2>Our experience with Opa</h2>
<p style="text-align:justify;">We have used Opa to develop a number of web applications, including CMSes, online games, high-security communication tools or e-Commerce apps.</p>
<p style="text-align:justify;">What can I tell you? In our experience, Opa is awesome <img src="https://s0.wp.com/wp-content/mu-plugins/wpcom-smileys/twemoji/2/72x72/1f642.png" alt="&#128578;" class="wp-smiley" style="height: 1em; max-height: 1em;"/> It saves us considerable amounts of time and pain and it vastly extended the size of projects that we could undertake with small agile teams.</p>
<p style="text-align:justify;">Firstly, Opa handles transparently all communications between the client and the server, and can generate JavaScript or server binary code from the same source, depending on what is required. This considerably simplifies prototyping and agile development, by letting us concentrate on getting things to work first, experimenting and showing to clients second, and freezing the design only much later. Countless times, this also made us very much more flexible with respect to design changes, by letting us instantaneously move (or reuse) server code on the client, or in the database, or vice-versa, without having to port from one language to another, or to reimplement communication protocols, or validation, or to redesign for asynchronicity. The added benefit of automated XSS protection also considerably improved our confidence in such agile code.</p>
<p style="text-align:justify;">Secondly, Opa&rsquo;s paradigm is a natural match for scalability concerns. It favors stateless services, makes sure that state can be easily marked as local (e.g. caches) or shared (e.g. accounts), and it also makes it quite easy to place local caches in front of anything shared. Most of our applications written on one server worked even better on several servers, out-of-the-box. To push scalability even further, marking data as local/shared/cached is extremely simple, which has always helped us experiment quickly, before deciding whether to push such optimizations into production.</p>
<p style="text-align:justify;">On the security side, I&rsquo;m not sure exactly how many men&middot;months Opa saved us by guaranteeing that we were automatically safe against injections (including XSS and SQL/SQL-like), and I&rsquo;m not quite sure how to measure it, but this definitely relieved us of plenty of work, stress and emergency calls.</p>
<h2>How does this work?</h2>
<p>We make it work <img src="https://s0.wp.com/wp-content/mu-plugins/wpcom-smileys/twemoji/2/72x72/1f642.png" alt="&#128578;" class="wp-smiley" style="height: 1em; max-height: 1em;"/></p>
<p style="text-align:justify;">More seriously, last time we counted, including testing, around 100 man&middot;years of R&amp;D had been spent on Opa. We took advantage of that time to make Opa the best solution we could imagine. I&rsquo;ll try and explain some of the key techniques progressively, in a series of blog entries.</p>
<h2>Limitations</h2>
<p style="text-align:justify;">We are extremely proud of everything that is possible with Opa, but, as any product, Opa has limitations.</p>
<p style="text-align:justify;">Firstly, while the Opa compiler and runtime can perform very aggressive optimizations on distribution and database requests for instance, for the moment, some of these optimizations cannot be performed automatically. In such cases, a developer needs to annotate the code here and there, to mark code chunks as safe for such optimizations. We have a number of plans to push forward the automation of these optimizations, but we haven&rsquo;t had a chance to implement them yet.</p>
<p style="text-align:justify;">Other limitations are related to our objectives. Opa is designed for security on the web. Consequently, a number of primitives that are just too dangerous are not accessible for Opa developers, so don&rsquo;t expect to encounter <code>innerHTML</code>, <code>eval()</code>, <code>document.print()</code> or <code>execvp()</code>, for instance. These primitives are available as part of the platform, should you wish to work on extending the runtime, but not as part of the language/library.</p>
<p style="text-align:justify;">Also, as we dedicated Opa to the web, do not look too hard for Gtk or DirectX bindings &ndash; nothing prevent such system bindings, but we have no plans on introducing these ones. Similarly, Opa is designed for scalability, so the language favors stateless programming, or when state is required, as in our web chat, states that can be shared between several instances of a server. So, while Opa will let you write an application with messy state, the design of the language will try and guide you on another way.</p>
<p style="text-align:justify;">We also have a few other limitations, that may be considered anecdotical in this day and age. For instance, the client side of Opa applications that have a client (i.e. non-pure web services) requires JavaScript and will not work with IE6 or Lynx.</p>
<h2>Show me the code!</h2>
<p style="text-align:justify;">Soon, but not quite yet.</p>
<p style="text-align:justify;">We&rsquo;re working full-time on the open-source release. If you are interested, I suggest you visit <a href="http://opalang.org">opalang.org</a> to find some information and documentation or to request invitations to the closed beta. You can also follow our updates&nbsp;<a href="http://twitter.com/#!/opalang">on Twitter</a> or come and chat with us <a href="irc://irc.freenode.net/#opalang">on IRC</a>.</p>

