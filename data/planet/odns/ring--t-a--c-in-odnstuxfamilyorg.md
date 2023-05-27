---
title: ring -t a -c in odns.tuxfamily.org
description:
url: http://odns.tuxfamily.org/2011/01/28/hello-world/
date: 2011-01-28T06:03:00-00:00
preview_image:
featured:
authors:
- odns
---

<p><code><br/>
$ ring -t A -c IN odns.tuxfamily.org<br/>
odns.tuxfamily.org has address 212.85.158.4<br/>
</code></p>
<p>This is the response I get from the <strong>ring</strong> command line, <em>a DNS lookup utility</em> (similar to other utilities such as &ldquo;host&rdquo; or &ldquo;ring&rdquo; that you may know) installed on my computer, which is using the <strong>ODNS</strong>&lsquo;s Objective Caml API, a <em>library made to query DNS and process DNS message</em>.</p>
<p>The web site is still under heavy writing for contents, in particular documentation for how to use both the DNS lookup utility (ring) &mdash;&nbsp;if you are someone who needs sometimes to query DNS by hand&nbsp;&mdash; and the DNS library (odns) &mdash;&nbsp;if you are a developer willing to query DNS records inside your software.</p>
<p>I would like to thank <a href="http://tuxfamily.org">TuxFamily</a> while I am at it, which is both the host for the current website as for the source code of ODNS/ring.</p>
<p>So today I opened this website and the command on top of this log is here to illustrate this emotional moment in a nice recursive way.</p>

