---
title: Quickcheck for Core
description: "Automated testing is a powerful tool for finding bugs and specifying
  correctnessproperties of code. Haskell\u2019s Quickcheck library is the most well-knownautoma..."
url: https://blog.janestreet.com/quickcheck-for-core/
date: 2015-10-26T00:00:00-00:00
preview_image: https://blog.janestreet.com/static/img/header.png
featured:
---

<p>Automated testing is a powerful tool for finding bugs and specifying correctness
properties of code. Haskell&rsquo;s Quickcheck library is the most well-known
automated testing library, based on over 15 years of research into how to write
property-base tests, generate useful sources of inputs, and report manageable
counterexamples. Jane Street&rsquo;s Core library has not had anything comparable up
until now; version 113.00 of Core finally has a version of Quickcheck,
integrating automated testing with our other facilities like s-expression
reporting for counterexample values, and support for asynchronous tests using
Async.</p>


