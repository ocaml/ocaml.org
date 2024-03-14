---
title: 'My experience at IndiaFOSS 2023: Community, Workshop, and Talks'
description: "There are plenty of exciting computer programming events happening in
  India, including the 5 day OCaml retreat that Tarides is hosting in\u2026"
url: https://tarides.com/blog/2024-03-13-my-experience-at-indiafoss-2023-community-workshop-and-talks
date: 2024-03-13T00:00:00-00:00
preview_image: https://tarides.com/static/5b2bd383b72e85e0c2e77394bfeeefd5/20850/indiafoss.png
featured:
authors:
- Tarides
source:
---

<p>There are plenty of exciting computer programming events happening in India, including the <a href="https://ocamlretreat.org">5 day OCaml retreat</a> that Tarides is hosting in Auroville this week &ndash; look out for future posts on that! Another great (and bigger!) event is the annual free and open source software conference <a href="https://indiafoss.net/2023">IndiaFOSS</a> organised by <a href="https://fossunited.org">FOSS united</a>, most recently held in Bengaluru this past October. At the conference, I had the pleasure of presenting on my experience introducing a Code of Conduct (CoC) to an open-source community; I also co-hosted an <a href="https://github.com/Sudha247/learn-ocaml-workshop">OCaml workshop</a> with KC Sivaramakrishnan, Deepali Ande, and Kaustubh M, which offered attendees helpful context and starter exercises in the language.</p>
<p>Sad you weren't there? Don't be &ndash; I'll give you a taste of what you missed so you can get ready for this year's IndiaFOSS!</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/7368dbe2ee334a6d50a74cfcaf759a41/93719/conferencecentre.jpg" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 75.29411764705883%; position: relative; bottom: 0; left: 0; background-image: url('data:image/jpeg;base64,/9j/2wBDABALDA4MChAODQ4SERATGCgaGBYWGDEjJR0oOjM9PDkzODdASFxOQERXRTc4UG1RV19iZ2hnPk1xeXBkeFxlZ2P/2wBDARESEhgVGC8aGi9jQjhCY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2P/wgARCAAPABQDASIAAhEBAxEB/8QAFwAAAwEAAAAAAAAAAAAAAAAAAAECBP/EABUBAQEAAAAAAAAAAAAAAAAAAAEA/9oADAMBAAIQAxAAAAGngkZER//EABkQAAMBAQEAAAAAAAAAAAAAAAECAwAQEf/aAAgBAQABBQKd1AN11VLOTwj3f//EABQRAQAAAAAAAAAAAAAAAAAAABD/2gAIAQMBAT8BP//EABURAQEAAAAAAAAAAAAAAAAAABAR/9oACAECAQE/Aaf/xAAcEAABAwUAAAAAAAAAAAAAAAAAAQIxEBEhImH/2gAIAQEABj8CRuzukKXwRX//xAAcEAACAgIDAAAAAAAAAAAAAAAAATFBESFRYXH/2gAIAQEAAT8h9Pgq5+0Ody4EzI0xDQj/2gAMAwEAAgADAAAAEKM//8QAFhEBAQEAAAAAAAAAAAAAAAAAABEh/9oACAEDAQE/ENR//8QAFhEBAQEAAAAAAAAAAAAAAAAAAAER/9oACAECAQE/EIa//8QAGhABAQEBAQEBAAAAAAAAAAAAAREhADFBYf/aAAgBAQABPxCAUDxsdye/ORjUwxLxMBC6Nn7yWAVactGHt06+RhMO/9k='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/7368dbe2ee334a6d50a74cfcaf759a41/7bf67/conferencecentre.jpg" class="gatsby-resp-image-image" alt="A modern building with big windows and round pillars, with a sign saying 'convention centre'. The picture looks like it was taken in the early morning or evening, with a twilight sky giving the scene a soft orange glow." title="" srcset="/static/7368dbe2ee334a6d50a74cfcaf759a41/651be/conferencecentre.jpg 170w,
/static/7368dbe2ee334a6d50a74cfcaf759a41/d30a3/conferencecentre.jpg 340w,
/static/7368dbe2ee334a6d50a74cfcaf759a41/7bf67/conferencecentre.jpg 680w,
/static/7368dbe2ee334a6d50a74cfcaf759a41/990cb/conferencecentre.jpg 1020w,
/static/7368dbe2ee334a6d50a74cfcaf759a41/c44b8/conferencecentre.jpg 1360w,
/static/7368dbe2ee334a6d50a74cfcaf759a41/93719/conferencecentre.jpg 4000w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#code-of-conduct-for-the-ocaml-community" aria-label="code of conduct for the ocaml community permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Code of Conduct for the OCaml Community</h2>
<p>As I explained in my talk, a CoC outlines the behaviours and responsibilities that people who participate in a community are expected to follow. By having a CoC, communities signal to their participants that they are inclusive and that there are repercussions for bad behaviour and harassment. This can help increase diversity, as people from underrepresented groups feel safer to participate.</p>
<p>My presentation centred on my experience implementing a CoC for the open-source OCaml community. I was part of a team established in 2022 that successfully implemented a CoC with feedback gathered from the OCaml community.</p>
<p>Check out my <a href="https://sudha247.github.io/coc-presentation/#/">presentation slides</a> to gain insight into how we handle enforcement, choose candidates for the enforcement team, smooth the path to adoption, and dispel some common myths about CoCs.</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/5db72c2910d823d699812c033edb46bc/93719/ocamlworkshop.jpg" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 75.29411764705883%; position: relative; bottom: 0; left: 0; background-image: url('data:image/jpeg;base64,/9j/2wBDABALDA4MChAODQ4SERATGCgaGBYWGDEjJR0oOjM9PDkzODdASFxOQERXRTc4UG1RV19iZ2hnPk1xeXBkeFxlZ2P/2wBDARESEhgVGC8aGi9jQjhCY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2P/wgARCAAPABQDASIAAhEBAxEB/8QAFwAAAwEAAAAAAAAAAAAAAAAAAAMEAv/EABUBAQEAAAAAAAAAAAAAAAAAAAAB/9oADAMBAAIQAxAAAAFL5MQ4jF//xAAZEAADAQEBAAAAAAAAAAAAAAABAhEAAyH/2gAIAQEAAQUConLoqi5VJwMxb3//xAAUEQEAAAAAAAAAAAAAAAAAAAAQ/9oACAEDAQE/AT//xAAUEQEAAAAAAAAAAAAAAAAAAAAQ/9oACAECAQE/AT//xAAYEAADAQEAAAAAAAAAAAAAAAAAATEQIf/aAAgBAQAGPwJ07rTpD//EABsQAAMAAgMAAAAAAAAAAAAAAAABETFRIaGx/9oACAEBAAE/IbsWGxnyok12Jo5PRVjg2LUU5pw//9oADAMBAAIAAwAAABD0D//EABYRAQEBAAAAAAAAAAAAAAAAAAABEf/aAAgBAwEBPxCLj//EABYRAQEBAAAAAAAAAAAAAAAAAAABEf/aAAgBAgEBPxC4j//EABoQAQADAAMAAAAAAAAAAAAAAAEAESExQVH/2gAIAQEAAT8Qa4a2uMgHomqbcJUvtugh9MV3XxEA0SqUHupxQAXS48n/2Q=='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/5db72c2910d823d699812c033edb46bc/7bf67/ocamlworkshop.jpg" class="gatsby-resp-image-image" alt="A group of people gathered in a room. They're sitting on chairs in a half-circle formation facing the camera. Most are intently looking at either their own or their neighbour's laptop." title="" srcset="/static/5db72c2910d823d699812c033edb46bc/651be/ocamlworkshop.jpg 170w,
/static/5db72c2910d823d699812c033edb46bc/d30a3/ocamlworkshop.jpg 340w,
/static/5db72c2910d823d699812c033edb46bc/7bf67/ocamlworkshop.jpg 680w,
/static/5db72c2910d823d699812c033edb46bc/990cb/ocamlworkshop.jpg 1020w,
/static/5db72c2910d823d699812c033edb46bc/c44b8/ocamlworkshop.jpg 1360w,
/static/5db72c2910d823d699812c033edb46bc/93719/ocamlworkshop.jpg 4000w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#ocaml-workshop" aria-label="ocaml workshop permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>OCaml Workshop</h2>
<p>We planned to introduce as many curious people as possible to OCaml. The <a href="https://github.com/Sudha247/learn-ocaml-workshop">workshop repo</a> we used has five sections: installation, exercises, a GitHub challenge, a Frogger challenge, and finally some sources. It's still available if you would like to try it!</p>
<p>There were many positive takeaways from the workshop and we had a healthy amount of participants &ndash; around 30 people. We were impressed with how much progress the attendees made with the exercises. Many reported that they enjoyed them and actually discovered that OCaml is fun!</p>
<p>It was helpful to hear the participant's feedback on the process and what could be improved. There were parts of the installation instructions that they thought could be clearer &ndash; including the tutorial on using Stdlib. We knew beforehand that installing OCaml on Windows was difficult, but we realised it would be helpful to find a better portable solution (and maybe encourage people to install WSL beforehand).</p>
<p>Sadly, we didn't have enough space to accommodate everyone who wanted to attend, and we had to turn people away. Whilst this sounds like a good problem to have, we do want to be able to provide everyone with an opportunity to try OCaml. Next time, we should plan ahead and get a bigger space.</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/94d0b1d7a56b3ceedbcae834a6be56fa/93719/indiafosstalk.jpg" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 75.29411764705883%; position: relative; bottom: 0; left: 0; background-image: url('data:image/jpeg;base64,/9j/2wBDABALDA4MChAODQ4SERATGCgaGBYWGDEjJR0oOjM9PDkzODdASFxOQERXRTc4UG1RV19iZ2hnPk1xeXBkeFxlZ2P/2wBDARESEhgVGC8aGi9jQjhCY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2P/wgARCAAPABQDASIAAhEBAxEB/8QAGAAAAgMAAAAAAAAAAAAAAAAAAAQBAgP/xAAVAQEBAAAAAAAAAAAAAAAAAAABAP/aAAwDAQACEAMQAAABzhF2aiwP/8QAGRABAQADAQAAAAAAAAAAAAAAAQIAAxQS/9oACAEBAAEFAulprbsnOq8KBT1rJlP/xAAWEQEBAQAAAAAAAAAAAAAAAAAAEQH/2gAIAQMBAT8Bmo//xAAWEQADAAAAAAAAAAAAAAAAAAAAARH/2gAIAQIBAT8BqKj/xAAbEAADAAIDAAAAAAAAAAAAAAAAARFBkQIhMv/aAAgBAQAGPwKLiqdpGNFyOp7PR//EABwQAAICAgMAAAAAAAAAAAAAAAERACEQQTFhcf/aAAgBAQABPyHlwQKwgOsAHiD4j+JtRqBVbn//2gAMAwEAAgADAAAAEHP/AP/EABgRAAMBAQAAAAAAAAAAAAAAAAABESFR/9oACAEDAQE/EHTGX1H/xAAXEQADAQAAAAAAAAAAAAAAAAAAAREh/9oACAECAQE/EFDRj//EAB0QAQEBAAEFAQAAAAAAAAAAAAERADEhQXGhsfH/2gAIAQEAAT8QkuJAi33l/Px/WJCdPhhNjwqTMbkgXQ19HaBfDf/Z'); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/94d0b1d7a56b3ceedbcae834a6be56fa/7bf67/indiafosstalk.jpg" class="gatsby-resp-image-image" alt="An auditorium with a stage and red and blue curtains surrounding it. A presentation slide is projected onto the centre-back wall of the stage. It has three bullet points which read: freedom in code and community, collaboration, transparency. There are people in red chairs facing the stage and paying attention to the talk." title="" srcset="/static/94d0b1d7a56b3ceedbcae834a6be56fa/651be/indiafosstalk.jpg 170w,
/static/94d0b1d7a56b3ceedbcae834a6be56fa/d30a3/indiafosstalk.jpg 340w,
/static/94d0b1d7a56b3ceedbcae834a6be56fa/7bf67/indiafosstalk.jpg 680w,
/static/94d0b1d7a56b3ceedbcae834a6be56fa/990cb/indiafosstalk.jpg 1020w,
/static/94d0b1d7a56b3ceedbcae834a6be56fa/c44b8/indiafosstalk.jpg 1360w,
/static/94d0b1d7a56b3ceedbcae834a6be56fa/93719/indiafosstalk.jpg 4000w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#interesting-talks" aria-label="interesting talks permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Interesting Talks</h2>
<p>Attending the conference was a welcome opportunity to listen to talks from other organisations. There was a variety of great presentations, and some of my favourites include:</p>
<ul>
<li><strong>Vyakaran - Visualisation Tool for Formal Grammar</strong>
<ul>
<li>Akash Hamirwasia presented Vyakaran, a visualisation tool for formal grammar. While some older tools exist for visualising formal grammar, this is a fresh take on the problem built with modern tools. The talk offered some unconventional wisdom, noting that it's okay to build things from scratch sometimes. He even made the repository public on stage!</li>
</ul>
</li>
<li><strong>Empowering Innovation With the Julia Language</strong>
<ul>
<li>Anant Thazhemadam and Sharan Yalburgi from the Julia team presented how Julia is used in various scientific software. Julia has found a niche and succeeded at it. The carbon-friendliness studies on functional programming languages were especially interesting, as was  understanding how Julia tops them. (And that OCaml is right behind!)</li>
</ul>
</li>
<li><strong>Role of FOSS in Bringing Equity and Quality Learning to Education</strong>
<ul>
<li>Nidhi Anarkat, Co-founder and CEO of NavGurukul, spoke about their initiative to train students from marginalised communities, mainly women, in tech. They provide lodging and boarding and set the students up for tech internships. The initiative has led to many students securing well-paying jobs and elevating their families.  Another member of the initative is Anup Kalbalia, former leader of CodeChef, a popular coding platform in India.</li>
</ul>
</li>
<li><strong>Stories From TinkerSpace: On Building Community Hacker Spaces</strong>
<ul>
<li>Moosa Mehar presented the story of TinkerSpace, a physical hackerspace in Kochi, India. Tinkerspace provides a place for hackers to gather around and hack on stuff. Not only that, it also provides users with a space for running community events. Their space is free to use for participants and funded by non-profit organisations. They're on a path towards self-sustenance.</li>
</ul>
</li>
<li><strong>Illustrations for the Sub-Continent</strong>
<ul>
<li>One of the few design talks of the conference! Sidika Sehgal presented the story behind how the illustration library <em>Obvious</em> was created &ndash; due to a lack of colour/race-inclusive illustrations for human characters. Even better, they decided to open source it, for anyone to use for free. It is nice to have representative and relatable illustrations for the sub-continent.</li>
</ul>
</li>
<li><strong>B(I)LUG: A 25-year Retrospective</strong>
<ul>
<li>Dr Sachin Garg took us through the decades-long journey of the Bangalore Linux User group. It was fascinating to see the history of the internet in India and how Open Source Software (starting from Linux) made its way into the ecosystem. He emphasised that the success of the group is the result of one man's vision, Atul Chitnis.</li>
</ul>
</li>
<li><strong>Co(de)mmunity!</strong>
<ul>
<li>Karkee founded the Villupuram Linux user group in 2013, in a remote village with an abysmal literacy rate where computers were hard to come by. Since then the group and its volunteers have lead many outreach events, persuading many to pursue a career in tech/OSS. They've even gotten approval to set up an IT park in their hometown. I had heard of Karkee and his team's work at <a href="https://tn23.mini.debconf.org">Minidebconf</a> earlier in the year. It was great that the organisers provided them with a platform to showcase their important work. I hope this inspires more OSS activity in unconventional places.</li>
</ul>
</li>
</ul>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#until-next-year" aria-label="until next year permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Until Next Year</h2>
<p>IndiaFOSS is a great conference that I would recommend to anyone interested in free and open-source software. It was nice to meet so many passionate people from all over India and hear about their projects and initiatives. I'm looking forward to attending more conferences and hope to see you around!</p>
<p>Want to keep up with Tarides? You can <a href="https://twitter.com/tarides_">follow us on X</a> (previously known as Twitter) and on <a href="https://www.linkedin.com/company/tarides">LinkedIN</a>.</p>
