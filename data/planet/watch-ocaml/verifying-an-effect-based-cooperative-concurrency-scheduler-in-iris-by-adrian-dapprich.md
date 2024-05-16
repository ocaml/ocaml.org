---
title: Verifying an Effect-Based Cooperative Concurrency Scheduler in Iris by Adrian
  Dapprich
description: Lightweight asynchronous programming (using futures, goroutines or green
  threads) has been widely adopted to organize programs with many concurrent tasks,
  more than are traditionally feasible with ...
url: https://watch.ocaml.org/w/iQNqZzA8gVmd4RQaycAwx4
date: 2024-01-09T16:23:50-00:00
preview_image: https://watch.ocaml.org/lazy-static/previews/2f456a8e-7413-40c1-99c2-bf4f03b07887.jpg
authors:
- Watch OCaml
source:
---

<p>Lightweight asynchronous programming (using futures, goroutines or green threads) has been widely adopted to organize programs with many concurrent tasks, more than are traditionally feasible with thread-per-task models of concurrency.</p>
<p>With the release of OCaml 5 and its support for effect handlers, the new concurrency library Eio was proposed which aims to replace previous monadic concurrency libraries for OCaml.</p>
<p>In this work we verify the core fiber and promise abstractions of Eio and show their safety and effect safety using the Hazel program logic.</p>
<p>Hazel is built on the Iris framework and allows reasoning about programs with effect handlers. We also adapt the existing proof of the verified CQS datastructure since Eio uses a customized version of CQS for its implementation of promises.</p>
<p>We do not treat some features of Eio like cancellation, because it does not yield a verifiable specification, and resource control using switches, since it is a liveness property.</p>

