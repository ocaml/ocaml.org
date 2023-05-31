---
title: Declarative parse error reporting with Menhir
description:
url: https://www.baturin.org/blog/declarative-parse-error-reporting-with-menhir
date: 2019-08-24T00:00:00-00:00
preview_image:
featured:
authors:
- Daniil Baturin
---


    Many parsers for custom formats aren't very user friendly when it comes to error handling.
At best you get the line and column where the error is, at worst a &ldquo;Parse error&rdquo;
message is all you get. Can we do better? With right tools, we definitely can and it's not that hard.
    
