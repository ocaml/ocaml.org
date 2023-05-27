---
title: Dropbox-as-a-Database, the tutorial
description: Yesterday, our Dropbox-as-a-Database  blog post raised a lot of positive
  comments, in particular on Hacker News  and Twitter. To get an idea...
url: http://blog.opalang.org/2012/11/dropbox-as-database-tutorial.html
date: 2012-11-01T15:53:00-00:00
preview_image: https://lh3.googleusercontent.com/blogger_img_proxy/AByxGDSXcxem--37imN1wKQh9OeKaKincVNe4qH77ArtI0LlrWQXs2oCmPSSJDtmcDEDL5SOee5epKfTOnxIo1X_TlrCh9FkvOZ2snJpm6Dmy9-C_IMGSv3hhvBB_2tGWbK0VOxZtISr0YYSy74btR-ToiS8aLbb3Zm-yIzT2TvS7oCrxLl6dycLIqXnJ8ocOvPpOP0lwFEFf2ZiFVBkIRJ5c90JG9x2mOYAvDRY_I2_HHbSJ1vJGjJ5FuiJ0K8QL-0yA0g5v6px9SCRW-z3nyz67DBiYtHhb6olDxmcNWQuS-KHr0-Pc0htDiMInCQzq7YOZYEYq0lrhLQ9=w1200-h630-p-k-no-nu
featured:
authors:
- "C\xE9dric Soulas"
---

<p>Yesterday, our <a href="http://blog.opalang.org/2012/10/dropbox-as-database.html">Dropbox-as-a-Database</a> blog post raised a lot of positive comments, in particular on <a href="http://news.ycombinator.com/item?id=4723087">Hacker News</a> and Twitter. To get an idea of the DaaD concept, I created a <a href="http://servermonitor-cedric.dotcloud.com/">demo application</a> using this new database back-end. </p><p>The demo arousing much interest, we decided not stop here! Today, we are introducing a tutorial to cover all steps of the creation of this application. Not all aspects are covered yet, but the goal is to explain in detail how the one-day demo app was built.</p><p>TL; DR: look at the <a href="https://github.com/cedricss/server-monitor/commits/master">commits</a></p><p><a href="http://server-monitor.herokuapp.com/resources/img/screenshot.png"><img src="https://a248.e.akamai.net/camo.github.com/25780b678024a19f152a85c207ee0a7242dbccfd/687474703a2f2f7365727665722d6d6f6e69746f722e6865726f6b756170702e636f6d2f7265736f75726365732f696d672f73637265656e73686f742e706e67" style="max-width:100%;"/></a></p><p>The tutorial will walk you through:</p><ul><li>create the application View (with HTML templates),</li>
<li>add event handlers (and play with client/server magic),</li>
<li>configure the application (within the app),</li>
<li>interact with the DOM (JavaScript on steroids),</li>
<li>parse user inputs and urls,</li>
<li>use modules, recursive functions, records, block notations, types and pattern matching,</li>
<li>use the Opa path notation to handle data stored in a MongoDB database,</li>
<li>switch from a MongoDB database to a Dropbox one.</li>
</ul><h1><a href="http://www.blogger.com/feeds/2073503406800427577/posts/default#view" name="view" class="anchor"><span class="mini-icon mini-icon-link"></span></a>View</h1><h2><a href="http://www.blogger.com/feeds/2073503406800427577/posts/default#initial-user-interface" name="initial-user-interface" class="anchor"><span class="mini-icon mini-icon-link"></span></a>Initial User Interface</h2><p><a href="http://4.bp.blogspot.com/-npc3b7fES0k/UJKc--_ArdI/AAAAAAAAABU/MOAVB-ZAvO4/s1600/initial-view.png" imageanchor="1" style=""><img src="http://4.bp.blogspot.com/-npc3b7fES0k/UJKc--_ArdI/AAAAAAAAABU/MOAVB-ZAvO4/s1600/initial-view.png" class="no-border"/></a><br/>
</p><p>Let's start with the UI. We create a <code>View</code> module with a <code>page</code> function inside. It will serve the HTML page to users:</p><pre><code>module View {

    function page() {
        &lt;div class=&quot;navbar navbar-fixed-top&quot;&gt;
          ...
        &lt;/div&gt;
        &lt;div style=&quot;margin-top:50px&quot; class=&quot;container&quot;&gt;
        &lt;div class=&quot;row-fluid&quot;&gt;
        &lt;div class=&quot;span6&quot;&gt;
            &lt;h1&gt;Monitor&lt;/h1&gt;
            &lt;form class=&quot;well&quot;&gt;
              ...
            &lt;/form&gt;
        &lt;/div&gt;
        &lt;div class=&quot;span6&quot;&gt;
            &lt;h1&gt;Logs&lt;/h1&gt;
              ...
            &lt;/div&gt;
        &lt;/div&gt;
        &lt;/div&gt;
        &lt;div class=&quot;row-fluid&quot;&gt;
          ...
        &lt;/div&gt;
        &lt;/div&gt;
    }
}
</code></pre><p>As we can see, Opa allows to write HTML directly without quotes, which frees us from the troublesome single and double quotes in pure JavaScript. <br/>
Also, Opa checks the HTML structure automatically. Try removing a closing tag!</p><p>Get the <a href="https://github.com/cedricss/server-monitor/blob/34985981fa40de13c5a9f371f32be2a172e70621/main.opa">full view code on github.</a></p><h2><a href="http://www.blogger.com/feeds/2073503406800427577/posts/default#http-server" name="http-server" class="anchor"><span class="mini-icon mini-icon-link"></span></a>Http Server</h2><p>We setup (outside of the <code>View</code> module) a http server configured to serve the page we just created:</p><pre><code>Server.start(
    Server.http,
    [ { register : { doctype : { html5 } } },
      { title : &quot;hello&quot;, page : View.page }
    ]
)
</code></pre><blockquote><p>With Opa, we can define the client views and events, the http server or even the database within the source code, without any extra directives for the compiler! Of course, code can be split between files, modules, directories...</p></blockquote><h2><a href="http://www.blogger.com/feeds/2073503406800427577/posts/default#compile" name="compile" class="anchor"><span class="mini-icon mini-icon-link"></span></a>Compile</h2><p>We can add a Makefile:</p><pre><code>main.js: main.opa
    opa main.opa

run: main.js
    ./main.js
</code></pre><p>And run the app:</p><pre><code>make run
Http serving on http://localhost:8080
</code></pre><blockquote><p>We can also type <code>opa main.opa --</code>, <code>--</code> meaning &quot;compile and run&quot;. You can add extra runtime options, for example <code>opa main.opa -- --port 9090</code></p></blockquote><h2><a href="http://www.blogger.com/feeds/2073503406800427577/posts/default#bootstrap-theme" name="bootstrap-theme" class="anchor"><span class="mini-icon mini-icon-link"></span></a>Bootstrap theme</h2><p>We want to use the famous default <a href="http://twitter.github.com/bootstrap/">Bootstrap css theme</a> Twitter gave us. We just have to import the theme at the beginning of our file. We also import the glyphicons and the responsive css so the application can work well on different display sizes:</p><pre><code>import stdlib.themes.bootstrap.css
import stdlib.themes.bootstrap.icons
import stdlib.themes.bootstrap.responsive
</code></pre><p>Or shorter:</p><pre><code>import stdlib.themes.bootstrap.{css, icons, responsive}
</code></pre><p>We restart the server to appreciate the style improvement.</p><pre><code>Ctrl-C
make run
</code></pre><p>Get the <a href="https://github.com/cedricss/server-monitor/blob/34985981fa40de13c5a9f371f32be2a172e70621/main.opa">source code at this step on github</a>.</p><h1><a href="http://www.blogger.com/feeds/2073503406800427577/posts/default#add-jobs-client-side" name="add-jobs-client-side" class="anchor"><span class="mini-icon mini-icon-link"></span></a>Add jobs (Client-side)</h1><h2><a href="http://www.blogger.com/feeds/2073503406800427577/posts/default#update-the-dom" name="update-the-dom" class="anchor"><span class="mini-icon mini-icon-link"></span></a>Update the Dom</h2><p>We add a new <code>Action</code> module that will be responsible of the user interface updates. Opa dispatches the code on the server side and the client side automatically, and automates the calls between client and server. To get more control and optimize your code, you can use <code>server</code> and <code>client</code> directives to tweak the compiler default dispatch behavior.</p><p>For example, here we want all user interface related actions to be computed on the client side as much as possible. To do so, we just add a <code>client</code> directive on the module to affect all functions inside it. Let's create two functions inside this module, one to add a job in the list of jobs, one to add a message in the logs:</p><pre><code>client module Action {

    function msg(url, class, msg) {
        // Add a log on top of the logs list
        #info += &lt;div&gt;
                  &lt;span class=&quot;label&quot;&gt;
                    {Date.to_string_time_only(Date.now())}
                  &lt;/span&gt;
                  &lt;span class=&quot;label {class}&quot;&gt;
                    {url} {msg}
                  &lt;/span&gt;
                 &lt;/div&gt;
    }

    function add_job(name, url, uri, freq) {
        // Add a new line on top of the job list
        #jobs += &lt;tr id=#{name}&gt;
                    &lt;td&gt;{url} each {freq} sec&lt;/td&gt;
                    &lt;td&gt;&lt;/td&gt;
                 &lt;/tr&gt;;

    }

}
</code></pre><blockquote><p><strong>Dom Manipulation</strong>: Opa provide many syntax and feature enhancements on top of JavaScript. There is native support of HTML, but also a special syntax to manipulate the Dom: <code>#dom_id = &lt;div&gt;Replace&lt;/div&gt;</code>, <code>#dom_id += &lt;div&gt;Prepend&lt;/div&gt;</code> and <code>#dom_id =+ &lt;div&gt;Append&lt;/div&gt;</code></p></blockquote><h2><a href="http://www.blogger.com/feeds/2073503406800427577/posts/default#parse-user-inputs" name="parse-user-inputs" class="anchor"><span class="mini-icon mini-icon-link"></span></a>Parse User Inputs</h2><p><a href="http://3.bp.blogspot.com/-Ir8uJIQ-dsU/UJKdeOC6nBI/AAAAAAAAABg/9h-2zk1OzmE/s1600/user-inputs.png" imageanchor="1" style=""><img src="http://3.bp.blogspot.com/-Ir8uJIQ-dsU/UJKdeOC6nBI/AAAAAAAAABg/9h-2zk1OzmE/s1600/user-inputs.png" class="no-border"/></a><br/>
</p><p>Inside the <code>Job</code> module, we need to add functions to check the format of user inputs (is it a integer? is it an well formed url?). The following code is based on the default parsers defined in the <a href="http://doc.opalang.org/module/stdlib.core.parser/Parser"><code>Parser</code></a> module.</p><p>Those parsing functions return an <code>option</code>, which is either <code>{none}</code> (it failed to parse the value), or <code>{some:v}</code> where <code>v</code> is the constructed value after the parsing and with the expected type (int, url, etc).</p><pre><code>    function submit_job(_) {

        function p(f, d, error){
            match (f(Dom.get_value(d))) {
            case {none}: 
              msg(&quot;ERROR:&quot;, &quot;label-error&quot;, error);
              none
            case r: r
            // case {some:v}: {some:v} is equivalent
            }
        }

        // Parse form inputs and add the job
        uri  = p(Uri.of_string, #url,  &quot;the url is invalid&quot;);
        name = p(Parser.ident,  #name, &quot;the log name is not a valid ident name&quot;);
        freq = p(Parser.int,    #freq, &quot;the frequency is not an integer&quot;);

        match ((uri, name, freq)) {
        case ({some:uri}, {some:name}, {some:freq}):
          add_job(name, Dom.get_value(#url), uri, freq)
        default: void // some invalid inputs, don't add the job
        }
    }

}
</code></pre><blockquote><ul><li><code>Dom.get_value(#url)</code> returns the value set in the input of id <code>url</code><br/>
</li>
<li>The <code>_</code> argument in the <code>submit_job</code> function means we don't care what is the name and the value of this argument. In this case, it is a value of type <code>Dom.event</code> given by events like <code>onclick</code> or <code>onready</code> (see below).</li>
</ul></blockquote><h2><a href="http://www.blogger.com/feeds/2073503406800427577/posts/default#dom-events" name="dom-events" class="anchor"><span class="mini-icon mini-icon-link"></span></a>Dom events</h2><p>In the <code>View.page</code> function, we update the &quot;Add and run&quot; html button so the <code>submit_job</code> function is called when a user click on it. It's easy to deal with dom events with Opa: we just put the function to call inside curly brackets and attach it to the event:</p><pre><code>&lt;a class=&quot;btn btn-primary&quot; onclick={ Action.submit_job }&gt;
  &lt;i class=&quot;icon-plus icon-white&quot;/&gt; Add and run
&lt;/a&gt;
</code></pre><p><a href="https://github.com/cedricss/server-monitor/commit/cd66d95c5f72d12b32e9f74fe2c7d1b57526aa07">See all the changes we made in this &quot;Add Jobs&quot; section</a>.</p><p>Run your application, then open it in your browser and click &quot;Add an run&quot; button providing both valid and invalid input values: jobs are added in the list of jobs or error messages are printed in the logs.</p><pre><code>Ctrl-C
make run
</code></pre><h2><a href="http://www.blogger.com/feeds/2073503406800427577/posts/default#to-be-continued" name="to-be-continued" class="anchor"><span class="mini-icon mini-icon-link"></span></a>To be continued</h2><p>This is probably enough for today!<br/>
In a next article, we'll discuss about how to monitor the servers behind the job urls and how to control those jobs (play, pause, edit and remove).</p>
