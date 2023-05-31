---
title: Pretty Printing a Table in Emacs
description:
url: http://rgrinberg.com/posts/emacs-table-display/
date: 2016-12-23T00:00:00-00:00
preview_image:
featured:
authors:
- Rudi Grinberg
---

<p>Recently, I needed to output some relatively small tabular data in Emacs and
<code class="docutils literal notranslate"><span class="pre">message</span></code> was starting to be a bit long in the tooth. Finally, I&rsquo;ve decided to
try my hand at upgrading the visuals for myself. I realize that there&rsquo;s probably
dozens of different ways of pretty-printing tables in Emacs, but I was already
partial to the tabular output used by functions such as <code class="docutils literal notranslate"><span class="pre">list-processes</span></code> and
plugins such as <a href="https://github.com/rejeep/prodigy.el" class="reference external">prodigy</a> (Using org
mode&rsquo;s tables also comes to mind for example). So I&rsquo;ve decided to recreate this
experience for my own tables. The result has been convenient and aesthetically
pleasing enough to share.</p>

