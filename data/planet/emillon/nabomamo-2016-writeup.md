---
title: NaBoMaMo 2016 writeup
description:
url: http://blog.emillon.org/posts/2017-02-01-nabomamo-2016-writeup.html
date: 2017-02-01T00:00:00-00:00
preview_image:
featured:
authors:
- emillon
---

<p>Hello! It&rsquo;s 2016, it&rsquo;s November, and apparently it rhymes with <a href="http://nabomamo.botally.net/">#NaBoMaMo</a> 2016,
the National Bot Making Month. <a href="https://github.com/emillon/rain-bot">I made a bot!</a>.</p>
<p><em>Full disclosure:</em> it&rsquo;s actually 2017, but I started writing this in 2016 so
it&rsquo;s OK. Also I&rsquo;m not actually from the US, but I&rsquo;ll relax the definition a bit
and let&rsquo;s pretend it means International Bot Making Year. Close enough!</p>
<p>Bots are all the rage - Twitter bots, IRC bots, Telegram bots&hellip; I decided to
make a Slack bot to get more familiar with that API.</p>
<p>I wanted this to be a small project - write and forget, basically. I started by
defining some specs and lock those down:</p>
<ul>
<li>that bot works on Slack</li>
<li>it uses the &ldquo;will it rain in the next hour&rdquo; API from M&eacute;t&eacute;o France.</li>
<li>the bot understands 3 commands:
<ul>
<li>tell you whether it will rain or not.</li>
<li>show you a graph of rain level over the next hour.</li>
<li>tell you when to go out to avoid the rain.</li>
</ul></li>
</ul>
<p>The next step was choosing the tech stack. For hosting itself I was sold on
using Heroku from previous projects (or another PaaS host, for what it&rsquo;s worth)</p>
<p>As for the programming language itself, I hesitated between three choices:</p>
<ol type="1">
<li>focus on the all-included experience: something that has libraries, tooling,
but somehow boring;</li>
<li>focus on the shipping experience: stuff that I use daily, but looking to get
something online quickly;</li>
<li>focus on learning something new.</li>
</ol>
<p>The first one means something like Python or Ruby. I am familiar with the
languages and am pretty sure that there are libraries that can take care of the
Slack API without me having to ever worry about HTTP endpoints. That means also
first-class deployment and hosting.</p>
<p>The second one is about OCaml: it&rsquo;s a programming language I use daily at work,
but the real goal would be to focus on shipping: create a project, write tests,
write implementation, deploy, repeat for new features, forget.</p>
<p>The third one means a totally new programming language. I heard a lot of good
things about Elixir for backend applications and figured that it would be a good
intro project. Learning a new language is always an interesting experience,
because it makes you a better programmer in all languages, and having clear
specs would make this manageable.</p>
<p>The Python/Ruby solution seemed a bit boring. I probably would not learn a lot,
only, maybe add a couple libraries to my toolbelt at most.</p>
<p>Elixir sounds great, but learning a new language and a new project at the same
time is too hard and too time consuming. I would rather write in a new language
something I previously wrote in another language. Though for something small and
focused like this, that could have worked.</p>
<p>I first created the project structure: github repo, ocaml project (topkg, opam,
etc). I like to use TDD for this kind of projects, so I added a small <a href="https://github.com/mirage/alcotest">alcotest</a>
suite. I also created the 12factor separation: a <code>Procfile</code>, a small <code>bin/</code>
shell that reads the application configuration from the environment and starts a
bot from <code>lib/</code>.</p>
<p>I asked myself what to test: the <a href="https://github.com/mirage/ocaml-cohttp">cohttp</a> library is nice, because servers and
clients are built using normal functions that take a request and returns a
response. That makes it possible to test almost everything at the ocaml level
without having to go to the HTTP level. This is especially important since there
is no way to mock values and functions in ocaml. Everything has to be real
objects.</p>
<p>However, even if it was possible to test everything, I decided to just focus on
the domain logic without testing the HTTP part: for example, I would pass data
structures directly to my bot object rather than building a cohttp request.</p>
<p>A part that is important for me even for a small project like that, is to have
some sort of CI: have travis run my test suite, and make a binary ready to be
deployed to Heroku. That way, it is impossible to forget how to make changes,
test and deploy, since this is all in a script.</p>
<p>The other part that needed work is the actual Slack integration. The &ldquo;slash&rdquo;
command API is pretty simple: it is possible to configure a Slack team such that
typing <code>/rain</code> will hit a particular URL. Some options are passed as <code>POST</code> data
and whatever is returned is displayed in Slack.</p>
<p>I set up the Slack integration, wrote a function to distinguish between
<code>/rain</code> and <code>/rain list</code> (using the POST data), and by the end of the second
iteraton I had my second feature implemented, working, and deployed.</p>
<p>All in all, that was pretty great. The code or the bot itself are not
particularly fantastic, but I learned some important lessons:</p>
<ul>
<li>When you do not want to spend a lot of time on a task, invest in planning and
keep the list of features short. That is pretty obvious in the context of paid
work, but this is applies well to hobby programming too.</li>
<li>Know what to test and what not to. Tests are useful to ensure that changes can
be made without breaking everything, but testing that your HTTP library can
parse POST data is a waste of time.</li>
<li>In languages where it is not possible to mock or monkey patch functions,
dependency injection is still possible. One may even argue that it leads to
a better solution, since it removes the coupling between the different
components.</li>
</ul>
<p>You can find <a href="https://github.com/emillon/rain-bot">the source of this bot on Github</a>.
See you next year, <a href="http://nabomamo.botally.net/">#NaBoMaMo</a>!
And thanks to Tully Hansen for organizing this.</p>
