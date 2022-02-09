---
title: "Making \u201Cnever break the build\u201D scale"
description: "I just stumbled across a post fromearlier this year by Graydon Hoare,
  of Rust fame.The post is about what he calls the \u201CNot Rocket Science Rule\u201D,
  which says ..."
url: https://blog.janestreet.com/making-never-break-the-build-scale/
date: 2014-07-06T00:00:00-00:00
preview_image: https://blog.janestreet.com/static/img/header.png
featured:
---

<p>I just stumbled across a <a href="http://graydon2.dreamwidth.org/1597.html">post</a> from
earlier this year by Graydon Hoare, of <a href="http://www.rust-lang.org/">Rust</a> fame.
The post is about what he calls the &ldquo;Not Rocket Science Rule&rdquo;, which says that
you should automatically maintain a repository that never fails its tests. The
advantages of the NRS rule are pretty clear. By ensuring that you never break
the build, you shield people from having to deal with bugs that could easily
have been caught automatically.</p>


