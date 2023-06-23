---
title: Dune `concurrent` action
date: "2023-05-31-01"
tags: [dune, platform, feature]
---

Dune 3.8.0 introduced the new `concurrent` action. You can now use it instead of the `progn` action to execute actions concurrently.

For instance:

```
(rule
 (action
  (concurrent
   (with-outputs-to A (echo "I am file A.\n"))
   (with-outputs-to B (echo "I am certainly file B.\n"))
   (with-outputs-to C (echo "I am most certainly file C.\n")))))
```

will write to files `A`, `B` and `C` concurrently.