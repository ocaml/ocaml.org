---
title: Dotstring representation of binary trees
number: "69"
difficulty: intermediate
tags: [ "binary-tree" ]
---

# Solution

```ocaml
  (* solution pending *)
```

# Statement

We consider again binary trees with nodes that are identified by single
lower-case letters, as in the example of problem “[A string
representation of binary trees][tree-string]”. Such a tree can be
represented by the preorder sequence of its nodes in which dots (.) are
inserted where an empty subtree (nil) is encountered during the tree
traversal. For example, the tree shown in problem “[A string
representation of binary trees][tree-string]” is represented as
'abd..e..c.fg...'. First, try to establish a syntax (BNF or syntax
diagrams) and then write a function `tree_dotstring` which does the
conversion in both directions. Use difference lists.

[tree-string]: #Astringrepresentationofbinarytreesmedium
