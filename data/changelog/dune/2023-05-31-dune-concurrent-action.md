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
   (write-file A "I am file A.\n")
   (write-file B "I am certainly file B.\n")
   (write-file C "I am most certainly file C.\n"))))
```

will write to files `A`, `B` and `C` concurrently.