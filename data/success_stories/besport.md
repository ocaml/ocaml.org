---
title: Social Network for Sports and Athletes
logo: success-stories/besport.svg
card_logo: success-stories/white/besport.svg
background: /success-stories/besport-bg.jpg
theme: red
synopsis: "Be Sport is a sports-devoted open social network for sports fans, clubs, and athletes."
url: https://www.besport.com/news
priority: 4
---

Be Sport is a sports-devoted open social network for sports fans, clubs, and athletes. It targets both amateurs and professionals, allowing everyone to create and organise its events, to disseminate information, and to receive personalised news. It has user pages (with friendship and follow); tree-structured groups for federations, clubs, and teams; tree-structured events for competitions and matches; instant messaging with your friends or groups; a personalised newsfeed; and many sport specific features to help clubs in their activities (calendar of training sessions, collaborative score-keeping, video streaming of events, and more)! It is the biggest sport database in France (160,000 grassroot clubs [98%], 650,000 teams indexed with automatic content update [calendar, scores, rankings, etc.], and a footprint of 1.5 million grassroot events per year, to name just a few).

## Challenge

The challenge was to quickly develop a full-featured social network with all the modern features Facebook implemented over the past decade, and with a quality level comparable to what users are now used to. We needed to develop a web application and both Android and iOS mobile apps.
As Be Sport is a self-financed startup, we needed to find a way to do this with very limited resources with regard to other social networks. We wanted a technology robust enough to make it easy to test features and change them frequently without introducing bugs. We also wanted to create a robust basis that could last for years and provide us a competitive advantage.

## Solution

Be Sport is fully written in OCaml, using the Ocsigen full-stack framework. Ocsigen lets you write web and mobile apps (Android, iOS) with the exact same code, which saves a considerable amount of time. Additionally, the Ocsigen Eliom framework makes it possible to write both the client and server parts of the applications as a single program—fully in OCaml—which makes the communication between the two straightforward. Pages can be generated either on the server or the client, according to your needs. This programming method also reduces the need for interaction between teams and makes development much faster.

## Results

Extensive use of OCaml’s type system allows many properties of the program to be checked at compile time, significantly reducing the number of bugs and the need for unit testing. It’s also much easier to refactor the code and make evolutions without breaking anything, as would happen with the traditional dynamic languages used for the web.

The use of OCaml also helped us with recruitment, the language being particularly popular amongst the best developers.
