---
title: Centralizing distributed version control, revisited
description: 7 years ago, I wrote a blogpostabout how we at Jane Street were using
  our distributed version control system(hg, though the story would be the same for
  git) ...
url: https://blog.janestreet.com/centralizing-distributed-version-control-revisited/
date: 2015-03-04T00:00:00-00:00
preview_image: https://blog.janestreet.com/static/img/header.png
featured:
---

<p>7 years ago, I wrote a <a href="https://blog.janestreet.com/centralizing-distributed-version-control/" title="Centralizing Distributed Version Control">blog
post</a>
about how we at Jane Street were using our distributed version control system
(<code class="highlighter-rouge">hg</code>, though the story would be the same for <code class="highlighter-rouge">git</code>) in a partially centralized
way. Essentially, we built a centralized repo and a continuous integration
system whose job was to merge in new changesets. The key responsibility of this
system was to make sure that a change was rejected unless it merged, compiled
and <a href="http://graydon2.dreamwidth.org/1597.html" title="The Not Rocket Science Rule">tested
cleanly</a>.</p>


