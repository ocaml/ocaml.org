---
title: New Formatting Options in OCamlFormat
date: "2023-03-06-01"
tags: [ocamlformat, platform]
---

Starting in OCamlFormat 0.25.1, we've also added new values to the `if-then-else` and `break-cases` options. Now you can use the `vertical` value to format these expressions in a more readable and consistent way.

These options are not set by default but you can try them out by customizing your `.ocamlformat` file as usual.

Here are a few examples:

- `if-then-else = vertical`
```diff
-  let epi = if Option.is_some next then fmt "@\n" else fmt_opt epi in
+  let epi =
+    if Option.is_some next then
+      fmt "@\n"
+    else
+      fmt_opt epi
+  in
```

```diff
-    if tree_depth tree > depth then node_depth_truncate_ depth node
-    else (* already short enough; don't bother truncating *)
+    if tree_depth tree > depth then
+      node_depth_truncate_ depth node
+    else
+      (* already short enough; don't bother truncating *)
       node
```

- `break-cases = vertical`

```diff
-| Ok (`Version | `Help) -> Stdlib.exit 0
-| Error _ -> Stdlib.exit 1
+| Ok (`Version | `Help) ->
+    Stdlib.exit 0
+| Error _ ->
+    Stdlib.exit 1
```

```diff
-    ~f:(function `Int _ | `Float _ -> true | _ -> false)
+    ~f:(function
+      | `Int _
+      | `Float _ ->
+          true
+      | _ ->
+          false)
```
