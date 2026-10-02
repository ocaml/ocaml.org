---
title: Combobulate Now Supports OCaml & OxCaml
description: "Code navigation is one of those aspects of programming that can either
  make your experience significantly better, or be such a pain. Most of the time we
  navigate code as text, i.e, searching with regexp, jumping by lines or moving word
  by word. But code isn't text. It has syntactic structure, and being aware of that
  structure when moving and editing opens up a different way of working. This is what
  structural navigation and editing means: operating on the actual constructs of a
  program; expressions, bindings, match arms, module definitions, etc,  instead of
  characters and lines.\nWe have recently improved navigation in OCaml/Oxcaml with
  Combobulate support, and this post will get you up-to-speed on what\u2019s new,
  how it works, and where to try it out!\nWhat Has Structural Navigation in OCaml
  Looked Like Until Now?\nOCaml already has a substrate of structural navigation through
  Merlin (and by extension OCaml-LSP). The jump command gives you a limited form of
  structural movement such as jumping to the next let, match, module, and a few other
  constructs. It is useful, but it's a small subset of what structural navigation
  could be. Previously, this limitation motivated the GopCaml project, which took
  a more ambitious approach to structural editing for OCaml by working directly with
  the compiler's AST.\nMore recently, tree-sitter has introduced a generic abstraction
  over syntax. Given a tree-sitter grammar for a language, you get an incremental
  parser that produces a concrete syntax tree you can query and traverse. OCaml has
  a tree-sitter grammar which is already used in, for example, neocaml-mode where
  it provides syntax highlighting.\nTree-sitter can be seen as the syntactic counterpart
  to LSP: where LSP standardizes semantic features, Tree-sitter provides a common
  protocol for syntax. Much like TextMate grammars provided a generic way to handle
  syntax highlighting across editors, Tree-sitter gives editors syntactic tools such
  as highlighting and navigation.\nCombobulate by Mickey Petersen takes tree-sitter
  in a different direction: it uses the syntax tree for structural navigation and
  editing. It's a minor mode for Emacs that supports many languages, and it now supports
  OCaml.\nWhy Does Combobulate Matter for OCaml?\nOCaml code nests very deeply. Modules
  contain structures, structures contain let bindings, let bindings contain match
  expressions, and match cases can contain further match expressions. Type declarations
  can define records, variants, and GADTs in a single type ... and ... block. Many
  of these constructs can recurse into each other with no fixed limit; this is part
  of what makes OCaml expressive, but it also means that even a small OCaml file produces
  a deep and wide tree-sitter parse tree.\nImplementing structural navigation for
  OCaml is harder than for most languages precisely because of this: the procedures
  that tell Combobulate how to pick the right node at any point have to account for
  potentially infinite nesting at every level. This is also why line-based movement
  becomes incredibly slow and unreliable. Jumping to the next let with an incremental
  search won\u2019t help when there are six of them nested within each other. This
  is why structural navigation, which helps us move by the structure of the code,
  and the relationships between different nodes in the tree, feels natural and makes
  a real difference.\nCombobulate is an important addition to the OCaml ecosystem
  because it perfectly complements tools like Merlin and OCaml-LSP. While Merlin is
  great for semantic intelligence, type checking, autocomplete, and jumping to definitions,
  its structural navigation features (like the jump command) are limited. By letting
  Combobulate handle the purely syntactic, structural movement and editing, the two
  tools work together to provide a comprehensive editing experience: Merlin understands
  what your code means, while Combobulate understands its shape.\nNavigating OCaml
  with Combobulate\nOnce Combobulate is active in your OCaml buffer, you should see
  a \xA9 in the mode line. There is a Magit-style transient UI bound to C-c o o that
  lists every binding, which is handy while you're learning. To inspect the full keymap
  directly, run M-x describe-keymap RET combobulate-key-map.\nWith Combobulate, you
  have different commands to navigate your code in a variety of ways: jumping between
  siblings, jumping between occurrences of words, traversing the node tree sequentially,
  and more.\nNavigation Commands\n\n\nBinding\nSummary\nWhat it does\n\n\nC-M-u /
  C-M-d\nUp/Down into list\nMove in/out to the parent/child node.\n\n\nC-M-n / C-M-p\nForward/Backward
  sibling\nMove to the next/previous sibling at the current level.\n\n\nM-e / M-a\nLogical
  next/previous\nJump to the next/previous logical node, regardless of nesting.\n\n\nM-n
  / M-p\nSequence navigation\nMove between paired sequence points (e.g., jumping from
  the word let to the next occurrence of let).\n\n\nC-M-a / C-M-e\nMove to the start/end
  of defun\nMove to the beginning/end of defun. This is based on best-effort. In nested
  let bindings, it doesn't work very well.\n\nNavigation Examples\nCombobulate primarily
  handles code navigation in terms of two axes:\n\nVertical/Hierarchical (Parents
  and Children): Moving \"up\" (C-M-u) leaves the current node for its enclosing parent,
  while moving \"down\" (C-M-d) descends into the child node at the cursor.\nHorizontal
  (Siblings): Moving forward (C-M-n) or backward (C-M-p) hops between sibling nodes
  at the same syntactic level, such as adjacent match cases, list elements, or record
  fields.\n\nWhen hierarchical or sibling navigation isn't enough, Combobulate also
  offers logical navigation (M-e / M-a). Rather than being constrained to direct parent-child
  or sibling relationships, logical navigation moves sequentially across nodes in
  their logical reading order\u2014allowing you to cross operator boundaries or escape
  deeply nested subtrees.\nSimple Examples\n\n\nNavigating down into a body (C-M-d)\n\"Down\"
  means entering whatever node the cursor is sitting on. The clearest case is descending
  from a module declaration into its contents:\nmodule Counter = struct\n  let value
  = 0\n  let bump x = x + 1\nend\n\nPlace the cursor on module. Press C-M-d thrice
  and the cursor moves to let value = 0. Press C-M-d again and you descend further,
  into the binding itself.\n\n\n\nNavigating up to the parent (C-M-u)\n\"Up\" is the
  inverse: leave the current node and land on its enclosing parent. Suppose the cursor
  is on the number 100 inside a record:\nlet player = { name = \"Ada\"; score = 100
  }\n\nC-M-u jumps to the whole field score = 100. Press it again to land on the record
  { ... }. To move from 100 directly to the let keyword, use C-M-a.\n\n\n\nNavigating
  siblings (C-M-n / C-M-p)\nSiblings are nodes at the same level, like match cases,
  tuple components, record fields, and array elements. Take a match expression:\nmatch
  shape with\n| Circle r    -> pi *. r *. r\n| Square s    -> s *. s\n| Triangle (b,
  h) -> 0.5 *. b *. h\n\nPlace the cursor on the first match arm (Circle r -> ...).
  C-M-n moves to Square s -> .... Again to Triangle .... C-M-p walks back.\n\n\n\nComplex
  Examples\nUsing only parent-child or sibling navigation is not always sufficient
  to navigate OCaml code efficiently. Because OCaml's deep nesting can lead to highly
  nested concrete syntax trees, you need a few more tools in your belt to avoid getting
  stuck.\n\n\nExample 1: Using next-sequent (M-n) and prev-sequent (M-p)\nIn subsequent
  let...in bindings, parent-child/sibling navigation is insufficient and unreliable
  due to how let...in is represented as deeply nested subtrees in the tree-sitter
  grammar. Each successive binding is actually a child of the one before it, meaning
  C-M-p won't walk backwards up the chain. Instead, use sequence navigation to hop
  directly from one let to the next and back.\nlet emit_string_table_section fmt section_name\n
  \ (table : Dwarf_write.string_table) =\n  let buf = Buffer.create 64 in\n  let contents
  = Buffer.contents buf in\n  let i = ref 0 in\n  let len = String.length contents
  in\n  while !i < len do\n    let start = !i in\n    while !i < len && contents.[!i]
  <> '\\x00' do\n      incr i\n    done;\n    let s = String.sub contents start (!i
  - start) in\n    emit_asciz fmt s;\n    if !i < len then incr i\n  done\n\nIf we
  want to move from the let-binding on line 3 to the let-binding on line 6, sequence
  commands M-n and M-p let you jump forward and backward easily.\n\n\n\nExample 2:
  Using logical-next (M-e) and logical-prev (M-a)\nif (x = 1) then true else false\n\nWhen
  the cursor is on if, you can do C-M-d to go to the parenthesis (, then C-M-d again
  to enter x, or C-M-n to go to then and else.\nHowever, if we have the same code
  without the parenthesis:\nif x = 1 then true else false\n\nThere is no direct sibling
  relationship to go from x to then using C-M-d or C-M-n. In this case, we use logical-next
  (M-e) to cross the operator boundary and jump directly to the then branch.\nLogical
  next/prev allows you to move to the next node in the tree irrespective of their
  parent/sibling relationships. It is also incredibly helpful for passing over ->,
  =, and other operators.\n\n\nExample 3: Escaping Deep Subtrees\nIf you are at the
  end of a long top-level item and want to navigate to the beginning of the next top-level
  item, use logical-next (M-e). If you try to use forward sibling navigation (C-M-n)
  from the end of the item, the cursor won't move at all since you are deep inside
  a nested subtree with no siblings to your right. Using M-e lets you jump out of
  the subtree instantly to the next top-level construct.\n\n\nEditing Commands\nBecause
  Combobulate's editing commands are built on top of its navigation primitives, particularly
  sibling navigation, they all work in OCaml without any extra configuration. If you
  can navigate between two nodes, you can edit them.\n\n\nBinding\nSummary\nWhat it
  does\n\n\nC-c o e\nEnvelope prefix\nApply a code template (envelope) at the cursor.
  Press C-h after to see what's available in this context.\n\n\nM-h\nExpand region\nMark
  the current node. Repeat to expand the region to the parent iteratively.\n\n\nC-M-h\nMark
  defun\nMark the current enclosing defun. Repeat to expand to the next enclosing
  defun iteratively.\n\n\nM-N or M-S-n\nDrag forward\nSwap the current node with its
  next sibling, preserving formatting.\n\n\nM-P or M-S-p\nDrag backward\nSwap the
  current node with its previous sibling.\n\n\nC-c o c\nClone node dwim\nDuplicate
  the node at cursor. If ambiguous, you cycle through candidates with a live preview
  (the carousel).\n\n\nC-c o t\nPlace cursors\nPlace multiple cursors (or field-editor
  fields) at every related sibling; e.g. each element of an array, each field in a
  record.\n\nEditing Examples\n\n\nExpanding the region (M-h)\nEach press grows the
  selection to the next syntactic unit. Starting on r inside a function call:\nlet
  area = pi *. r *. r\n\n\nM-h once \u2192 selects r.\nM-h again \u2192 selects pi
  *. r *. r.\nM-h again \u2192 selects the whole let binding.\n\nM-h displays numbers
  indicating where the next enclosing region starts, helping you visualize where the
  cursor will move if you perform a hierarchy-up navigation. Unlike Merlin's type-enclosing
  (which operates on typed AST expressions and requires code to typecheck), Combobulate's
  expansion is purely syntactic: it operates on any concrete syntax node (including
  patterns, type declarations, and comments) even when the code is incomplete or doesn't
  compile.\n\n\nExpanding an envelope (C-c o e)\nEnvelopes are context-aware templates.
  Press C-c o e then C-h to see what's available.\nFor example, to add a module template:\n\n\nPlace
  your cursor where you want to add the template.\n\n\nPress C-c o e to list all available
  templates.\n\n\nPress M to activate the modules template.\n\n\nThe template will
  be added with name as an editable hole:\nmodule name = struct\n\nend\n\n\n\nPress
  TAB to jump between holes.\n\n\n\n\nAdding multiple cursors (C-c o t)\nCursors land
  on every sibling at the current level. This is perfect for bulk-editing collections.
  Place the cursor on any element of an array:\nlet primes = [| 2; 3; 5; 7; 11 |]\n\nPress
  C-c o t t and a cursor is placed on each element. Anything you type happens to all
  five at once!\n\n\nSwapping siblings \u2014 drag forward / backward (M-N / M-P)\nDrag
  transposes the node at the cursor with its neighbor, preserving formatting. Useful
  for reordering elements or record fields:\nlet primes = [| 2; 3; 5; 7; 11 |]\n\nWith
  the cursor on 2, press M-N (or M-S-N) to swap them:\nlet primes = [| 3; 2; 5; 7;
  11 |]\n\n\n\nCloning a node (C-c o c)\nDuplicates the node at the cursor. On a record
  field:\ntype user = {\n  name : string;\n  age  : int;\n}\n\nPlace the cursor on
  name : string and press C-c o c to duplicate it seamlessly.\n\n\nInspection & Search\n\n\nBinding\nSummary\nWhat
  it does\n\n\nC-c o B q\nQuery builder\nOpen the interactive tree-sitter query builder,
  with completion and highlighting, for ad-hoc searches and bulk edits.\n\nQuery Builder
  Example\nOpen a live tree-sitter query builder with C-c o B q. If you have value_definitions
  in your file, you can underline all of them with a blue line using the query:\n(value_definition)
  @hl.blue.underline\n\nSetup\nSince Combobulate is built on tree-sitter you will
  need Emacs 29 or later, as that's when built-in tree-sitter support landed. Install
  Combobulate from the master branch and add the OCaml grammars to your config file.\nTo
  get started with OCaml, add the OCaml grammars to your config file:\n(setq treesit-language-source-alist\n
  \     '((ocaml . (\"https://github.com/tree-sitter/tree-sitter-ocaml\"\n                  \"v0.26.0\"
  \"grammars/ocaml/src\"))\n        (ocaml_interface (\"https://github.com/tree-sitter/tree-sitter-ocaml\"\n
  \                           \"v0.26.0\" \"grammars/interface/src\"))))\n\nRun M-x
  treesit-install-language-grammar for each.\nCombobulate can be used with either
  neocaml-mode or tuareg-mode or tuareg-interface-mode as your major mode. When it's
  working you'll see \xA9 in the mode line, and C-c o o opens the full command palette.\n\nTry
  it out\nOpen up a project you are working on. Place your cursor on a case in a match
  expression and try to teleport to the next sibling.\nYou can check out the PR adding
  OCaml support and the PR adding OxCaml support in the Combobulate repo to explore
  the implementation process in more detail.\nFeedback Welcome\nOCaml's syntax is
  flexible enough that there isn't always one obvious answer to \"what should the
  next sibling be?\" or \"what counts as descending one level?\". We had to make judgment
  calls on a number of corner cases, like what sibling navigation does inside a type
  ... and ... block, how hierarchy behaves around functors, where sibling navigation
  should land in deeply nested expressions. We're happy with the choices we made,
  but we know they won't match everyone's expectations perfectly. If something feels
  off in your workflow, or you think a particular movement should behave differently,
  we'd like to hear about it. Open an issue on the Combobulate repo, make a post on
  Discuss, or contact us to let us know.\nStay in touch  with us on Bluesky, Mastodon,
  and LinkedIn or sign up to our mailing list to stay updated on our latest projects.
  We look forward to hearing from you!"
url: https://tarides.com/blog/2026-10-01-combobulate-now-supports-ocaml-oxcaml
date: 2026-10-01T00:00:00-00:00
preview_image: https://tarides.com/blog/images/blue-lamp-computer-1360w.webp
authors:
- Tarides
source:
ignore:
---
