---
title: 'Spotlight on Opa app: OpaDo by Tristan Sloughter'
description: We continue  our presentation of the winning apps of the Opa Developer
  Challenge . Today is time for OpaDo, the 2nd place winning entry by ...
url: http://blog.opalang.org/2012/02/spotlight-on-opa-app-opado-by-tristan.html
date: 2012-02-20T13:02:00-00:00
preview_image: https://lh3.googleusercontent.com/blogger_img_proxy/AByxGDSv50cuuFkEH4w783wJF-8Gb3gNx4pIGLXfqC9rOmAcn8IiGjKCnvjW2ZjIA1pwBdDotE0Q8pWMMzb2CfF4OncSI1M4mxPaChOvfY-AtQzbTpvaLlKNYoA=w1200-h630-p-k-no-nu
featured:
authors:
- Adam Koprowski
---

<div class="sectionbody">
<div class="paragraph"><p>We <a href="http://blog.opalang.org/2012/02/spotlight-on-opa-app-opachess-by-mads.html">continue</a> our presentation of the winning apps of the <a href="http://blog.opalang.org/2011/11/opa-developer-challenge-results.html">Opa Developer Challenge</a>. Today is time for OpaDo, the 2nd place winning entry by Tristan Sloughter. OpaDo is a TODO list, that started as a clone of <a href="http://addyosmani.github.com/todomvc">TodoMVC</a>, but then Tristan added some cool features, such as user accounts and even Facebook authentication. We really liked this app as it does what it's supposed to do and does it well. We also appreciated the fact that Tristan wrote a <a href="http://blog.erlware.org/author/kungfooguru/">series of blog posts</a> on developing OpaDo - be sure to check it out. We're also, together with the author, working on some extensions&nbsp;&mdash;&nbsp;stay tuned for details!</p></div>
<div class="sect2">
<h3>Try OpaDo!</h3>
<div class="paragraph"><p>For your convenience we've embedded the OpaDo application in this post, but for best results we suggest you go to <a href="http://opado.org">http://opado.org</a>.</p></div>
<iframe height="480" width="700" src="http://opado.org"></iframe>
</div>
<div class="sect2">
<h3>Interview with the author: Tristan Sloughter</h3>
<a href="http://blog.erlware.org/author/kungfooguru"><img src="http://opalang.org/blog/author_tristan_sloughter.jpg" style="float:left; margin-right: 15px"/></a>
<div class="paragraph"><p><strong>me</strong>: <em>Can you tell us a bit about yourself? What's your experience with web programming? Favorite languages? Web frameworks?</em><br/>
<strong>Tristan Sloughter</strong>: I'm Tristan Sloughter, and I am a professional working full-time for a startup in Chicago (eCDMarket) and on the side on a startup of my own (ClaimsTrade). Both are fully implemented in Erlang, my favorite language. I've been an Erlang programmer since college and have been obsessed with it ever since. For web frameworks there are a number in Erlang, but none have suited my needs or been based on OTP standards enough, so I started Maru, which is still very much a work in progress and is developed in parallel with my development of real world sites in Erlang.</p></div>
<div class="paragraph"><p><strong>me</strong>: <em>Can you tell us a bit about your submission for the contest? How did you come up with the idea? What are your future plans with respect to the application?</em><br/>
<strong>TS</strong>: My submission started as a simple port of the TodoMVC project to Opa, called OpaDo. TodoMVC is an app that many have ported between different Javascript MVC frameworks to show their strengths and to learn. I thought it would be a good project to use to learn Opa and hopefully help others while I did so by blogging about my progress. After implementing the features of TodoMVC, I extended the project to include user accounts and personal todo lists. I intend to continue extending OpaDo. First, I'll be moving the database to CouchDB, not because the Opa database can not handle the app but more as a learning experience. A few other features I'd like to play with to learn Opa better is creating a RESTful interface for users to interact with their todo items and to add some sort of real time collaboration between users and their items, possibly through the PubNub Opa binding I've written.</p></div>
<div class="paragraph"><p><strong>me</strong>: <em>How did you like programming in Opa? Was it different than other technologies you know? Anything that you particularly liked? Anything that could be improved?</em><br/>
<strong>TS</strong>: I really enjoyed working with Opa. While my language of choice has been Erlang and it is an amazing language, working with dynamically typed Erlang and Javascript has been prone to cause great frustration. Opa's type checking that covers both the client and server code is simply amazing and a great time saver. Like those who have worked with OCaml, Haskell or another strongly typed language know, if it compiles there is a good chance it works as well :). Continually I had the compiler catch mistakes that I commonly find and know that if I was using another backend language or Javascript on the frontend it would have taken till I was testing the page and had Firebug open to find the mistake.<br/>
So, I think my favorite features of Opa start small, before even thinking about its advanced architecture for easy network communication and scaling. The fact that it is a strong typed, functional language is its greatest feature. This combined with the ability to embed HTML (I don't know why this bothers others when it is so clean, I think it is perfect) and not having to use Javascript&nbsp;&mdash;&nbsp;and the more advanced features for creating large scale commercial apps&nbsp;&mdash;&nbsp;make Opa something that I think will greatly change the future of web development.<br/>
The main area for improvement, which the Opa team is already tackling head on, is database backends. Working with the embedded Opa database was very productive and much better than dealing with serializing/deserializing to an external relational database and writing complicated queries&nbsp;&mdash;&nbsp;similar to the ease and usefulness of Erlang's embedded database Mnesia. Having the same ease of use as the embedded database extended to CouchDB and MongoDB will be a huge feature.</p></div>
</div>
</div>
