---
title: Using ASCII waveforms to test hardware designs
description: "At Jane Street, an \u201Cexpecttest\u201D is atest where you don\u2019t
  manually write the output you\u2019d like to checkyour code against \u2013 instead,
  this output is captured au..."
url: https://blog.janestreet.com/using-ascii-waveforms-to-test-hardware-designs/
date: 2020-06-01T00:00:00-00:00
preview_image: https://blog.janestreet.com/using-ascii-waveforms-to-test-hardware-designs/scientist_testing.jpg
featured:
---

<p>At Jane Street, an <a href="https://blog.janestreet.com/testing-with-expectations">&ldquo;expect
test&rdquo;</a> is a
test where you don&rsquo;t manually write the output you&rsquo;d like to check
your code against &ndash; instead, this output is captured automatically
and inserted by a tool into the testing code itself. If further runs
produce different output, the test fails, and you&rsquo;re presented with
the diff.</p>


