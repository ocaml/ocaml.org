---
title: A tutorial for building web applications with Incr_dom
description: "At Jane Street, our web UIs are built on top of an in-house frameworkcalled
  Incr_dom, modeled inpart on React\u2019s virtualDOM. Rendering differentviews efficien..."
url: https://blog.janestreet.com/a-tutorial-for-building-web-applications-with-incrdom/
date: 2019-01-15T00:00:00-00:00
preview_image: https://blog.janestreet.com/a-tutorial-for-building-web-applications-with-incrdom/incr_dom.png
featured:
---

<p>At Jane Street, our web UIs are built on top of an in-house framework
called <a href="https://github.com/janestreet/incr_dom">Incr_dom</a>, modeled in
part on <a href="https://reactjs.org/docs/faq-internals.html">React&rsquo;s virtual
DOM</a>. Rendering different
views efficiently in response to changes made to a shared model is a
quintessentially incremental computation&mdash;so it should be no surprise
that Incr_dom is built on top of
<a href="https://blog.janestreet.com/introducing-incremental/">Incremental</a>.</p>


