---
title: Converting a code base from camlp4 to ppx
description: As with many projects in the OCaml world, at Jane Street we have been
  working onmigrating from camlp4 to ppx. After having developed equivalent ppx rewriters...
url: https://blog.janestreet.com/converting-a-code-base-from-camlp4-to-ppx/
date: 2015-07-08T00:00:00-00:00
preview_image: https://blog.janestreet.com/static/img/header.png
featured:
---

<p>As with many projects in the OCaml world, at Jane Street we have been working on
migrating from camlp4 to ppx. After having developed equivalent ppx rewriters
for our camlp4 syntax extensions, the last step is to actually translate the
code source of all our libraries and applications from the camlp4 syntax to the
standard OCaml syntax with extension points and attributes.</p>


