---
title: Learning a New Language
description: "Generally, every program I write, regardless of what useful thing it
  actually does, and regardless of what programming language it is written in, has
  to do certain things, which usually includes Im\u2026"
url: https://gaius.tech/2019/02/10/learning-a-new-language/
date: 2019-02-10T10:55:04-00:00
preview_image: https://gaiustech.files.wordpress.com/2018/07/cropped-lynx.jpg?w=180
featured:
authors:
- gaius
---

<p>Generally, every program I write, regardless of what useful thing it actually does, and regardless of what programming language it is written in, has to do certain things, which usually includes</p>
<ul>
<li><b>Importing a library</b> and calling functions contained within that library</li>
<li><b>Handling datatypes</b> such as converting between strings and integers, and knowing when this is implicit or explicit, how dates and times work, and so on</li>
<li><b>Getting command line parameters</b> or <b>parsing a configuration file</b></li>
<li><b>Writing log messages</b> such as to files or <a href="https://www.freedesktop.org/software/systemd/man/sd_journal_print.html#">the system log</a></li>
<li><b>Handling errors and exceptions</b></li>
<li><b>Connecting to services</b> such as a database, a REST API, a <a href="https://kafka.apache.org">message bus</a> etc</li>
<li><b>Reading and writing files</b> to the disk, or to <a href="https://azure.microsoft.com/en-gb/services/storage/blobs/">blob storage</a> or <a href="https://cloud.google.com/appengine/docs/standard/python/blobstore/">whatever it&rsquo;s called</a> this week</li>
<li><b>Spawning threads and processes</b> and communicating between them</li>
<li><b>Building a package</b> whether that&rsquo;s a self-contained binary, an RPM, an OCI container, whatever is native to that language and the platform</li>
</ul>
<p>It&rsquo;s easy to find examples of most of these things using resources such as <a href="http://rosettacode.org/wiki/Rosetta_Code">Rosetta Code</a> and my first real program will be a horrific cut and paste mess &ndash; but it will get me started and I&rsquo;ll soon refine it and absorb the idiomatic patterns of the language and soon be writing fluently in it, and knowing my way around the ecosystem, what libraries are available, which are the strengths and weaknesses of the language, the libraries, the community and so on. Once you have done this a few times it becomes easy and you can stop worrying so much about being a &ldquo;language X programmer&rdquo; and concentrate on the important stuff, which is the problem domain you are working in. </p>

