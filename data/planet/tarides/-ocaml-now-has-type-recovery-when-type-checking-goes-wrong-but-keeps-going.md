---
title: ' OCaml now has type recovery: when type checking goes wrong, but keeps going'
description: "Merlin, the foundational library that underpins the reference\nimplementation
  of the OCaml Language Server\nProtocol\nprovides a wide range of practical features,
  including commands, code\ncompletion, and much more. It also implements more subtle
  mechanisms\nthat are essential to delivering a smooth and responsive editing\nexperience.
  Indeed, the editing environment for a programming language\nclosely resembles the
  front-end of its compiler. However, whereas a\ncompiler operates on complete, syntactically
  valid programs, an editor\nmust continuously cope with programs that are incomplete,
  temporarily\ninconsistent, and often ill-typed.\nTo handle these transient states,
  Merlin vendors a modified version of\nthe OCaml compiler front-end (primarily the
  parser and the type\nchecker), extending it with two recovery mechanisms:\n\n\nParsing
  Recovery, which synthesises AST nodes to allow parsing\nto continue even in the
  presence of syntax errors.\n\n\nTyping Recovery, which synthesises typed AST nodes,
  allowing\ntype checking to continue even when type errors are encountered.\n\n\nThis
  article  will focus specifically on the second mechanism, typing recovery, and how
  we upstreamed this feature to the mainline OCaml compiler.\nTyping Recovery in Action\nThe
  recovery mechanisms' behaviour is easy to\nobserve in practice. Consider, for example,
  the following OCaml\nprogram:\nlet x = \"ten\"\nlet y = x + 20\nlet z = (y + (2
  * x)) && true\n\nHere, we are faced with three type errors. First, we attempt to
  add\nx and 20, which makes no sense since x has type string.  Next,\nwe attempt
  to multiply x (once again) by 2, which is also\ninvalid. Finally, the expression
  (y + (2 * x)), which is expected to\nhave type int, is instead used as a boolean
  value.\nWhen compiling this program, the OCaml compiler reports only the first\ntype
  error in the compilation unit:\nFile \"lib/test.ml\", line 2, characters 8-9:\n2
  | let y = x + 20\n            ^\nError: The value x has type string but an expression
  was expected of type int\n\nThis is a very sensible design choice. Although OCaml
  has a highly\nsophisticated type system, the language's pervasive type inference\nmeans
  that a single mistake can easily trigger a cascade of secondary\nerrors, obscuring
  the compiler's primary goal: ensuring correctness.\nHowever, applying the same strategy
  in a code editor raises two major\n(and closely related) issues:\n\n\nAn editor
  that reported errors one at a time would provide a rather\npoor user experience.\n\n\nMore
  importantly, if type checking or parsing stopped at the first\nsyntax or type error,
  every feature provided by Merlin that relies\non compiler structures \u2013 namely
  the parsetree and the\ntypedtree \u2013 would immediately become unavailable. This
  would be\nparticularly frustrating because, while actively editing a file,\nthe
  program is almost always in a temporarily invalid state, whether\nsyntactically,
  semantically, or both.\n\n\nFor these reasons, the modified version of the OCaml
  compiler\nfront-end embedded in Merlin always produces valid ASTs (Parsing\nRecovery)
  and typed ASTs (Typing Recovery), allowing the subsequent\nanalysis phases to continue
  operating on programs that are still\nbeing written, whilst collecting errors:\n\n\n\nThese
  two recovery mechanisms, although arguably among the most\ninteresting features
  of the language server, are also one of the main\nreasons why upgrading Merlin to
  support a new OCaml release is such a\nchallenging process. This effort is known
  as OCaml Release\nReadiness. For\nnow, let's take a closer look at why this is the
  case by focussing\nspecifically on Typing Recovery.\nAdapting Typing Recovery Across
  OCaml Versions\nWithout going into too much detail, upgrading Merlin to a new OCaml\nversion
  involves applying patches coming from two different sources:\n\nCompiler patches,
  corresponding to the various changes made to OCaml\nover time;\nMerlin patches,
  which introduce the recoveries.\n\nBecause Typing Recovery is deeply intertwined
  with the various modules\ninvolved in OCaml's type-checking process, applying patches
  from two\ndifferent sources (with different development cycles) makes version\nupgrades
  particularly tedious and introduces two major challenges:\n\n\nEach upgrade takes
  time, because the vendored version of the\ncompiler front-end must be adapted while
  preserving all recovery\ninformation and fixing the analysis issues naturally introduced
  by\nthe evolution of OCaml;\n\n\nHandling new recovery cases can be tedious for
  the people\nresponsible for the upgrade process. Indeed, it is common to apply\npatches
  from the compiler side without having a complete\nunderstanding of their underlying
  rationale. For example, OCaml\n5.5 recently introduced a new feature that was highly
  anticipated\nby the community: module dependent\nfunctions.\nThis addition changes
  how function parameters are handled and\nrequires careful consideration of how recovery
  should behave in\nthese new situations.\n\n\nFor these reasons, Typing Recovery
  could become unstable (within\nreasonable scenarios, of course), sometimes introducing
  small\nregressions and sometimes lacking support for newly introduced\nfeatures.\nReducing
  the Differences Between Merlin and OCaml\nReducing the differences between Merlin's
  vendored version of the\nfront-end and the one maintained by OCaml is therefore
  a crucial task.\nIt not only helps reduce Merlin's maintenance burden, but also
  gives\nOCaml maintainers more control over how they want recovery to be\nhandled
  within the type checker.\nOf course, this represents an additional responsibility
  for the\nmaintainers (another one!), but in practice, developers introducing\nnew
  features in the type checker usually have both a deep\nunderstanding of their implementation
  and a good intuition about how\nrecovery should behave in the presence of errors.\nIntegrating
  Typing Recovery into the Compiler\nAt the time of writing this blog post, the Typing
  Recovery mechanism\nhas been merged into the\ncompiler. In this section,\nwe will
  briefly describe its re-design and direct integration into\nthe compiler's type
  checker.\nTyping Recovery has been part of Merlin since its very beginning.\nAlthough
  its implementation relies on very clever encoding, it has\naged over time, and its
  underlying design has become increasingly\ndifficult to understand. Integrating
  it into the compiler, therefore,\nprovided an opportunity to rethink the mechanism,
  clean it up, and\nmake its behaviour easier to understand. The goal was to enable
  a\nnon-intrusive integration, giving maintainers the tools they need to\nconfidently
  evolve and maintain it in the future.\nHow Recovery Works, at a High Level\nThe
  core of the OCaml type-checker is implemented as a set of\nrecursive functions responsible
  for typing the different syntactic\ncategories of the language, notably expressions,
  patterns, type\ndeclarations, modules, and classes. When a type error is encountered,\nthese
  functions propagate an exception that interrupts the\nconstruction of the typing
  derivation. As mentioned above, the compiler adopts a\nfirst-failure reporting strategy,
  reporting\nonly the first encountered error.\nTo go beyond the first-failure reporting
  strategy, Merlin\ninstruments the main recursive functions of the type-checker in
  order\nto intercept typing exceptions. When an exception is raised, it is\ncaught
  so that it can be recorded (logged), and typing then resumes at the\nrecursive call
  level (locally) on the other independent subterms of\nthe program. Thus, even if
  the typing of a subexpression fails,\nindependent subtrees can still be analysed,
  which makes it possible to\nreport multiple typing errors within a single analysis.\nResuming
  recursion allows new errors to be discovered, but it is not\nsufficient to produce
  an exploitable Typedtree. When a\nsub-derivation fails, Merlin synthesises an artificial
  Typedtree\nnode whose typing judgment is that expected by the context in which it\nis
  inserted, while also preserving the fragments of the derivation\nthat could be constructed
  before the typing failure, even if their\nattachment to the rest of the tree is
  no longer known. These nodes\nhelp preserve the structure of the Typedtree returned
  by the\ntype-checker and maintain language server functionality despite the\npresence
  of errors.\nHowever, these generic mechanisms are not sufficient to cover all\nlanguage
  constructs. Some phases of the type-checker perform\npreliminary checks before recursively
  typing their subterms. When\nthese checks fail, recursion is never engaged, and
  no partial\nderivation is produced. For example, record expressions:\n{ my_fst_field
  = e1;\n  my_snd_field = e2 }\n\nThe type-checker first attempts to resolve my_fst_field
  and\nmy_snd_field. If, for instance, my_fst_field does not exist, it\ngives up without
  attempting to type e1 and e2. This strategy is\nsuboptimal: subexpressions are never
  analysed even though they could\ncontain useful information or independent errors.
  To address this\nissue, Merlin delays the error by assuming that the field exists.\nMerlin
  then temporarily adapts the type-checker by considering that an\nunknown label is
  not necessarily a fatal error, but may correspond to\na field that will be added
  later. Typing then proceeds under this\nassumption, which makes it possible to produce
  partial derivations for\nsubexpressions and to improve the quality of diagnostics.\nAnother
  API for Raising Type Errors\nAs the purpose of Typing Recovery is essentially to
  be managed by\nMerlin, we do not want to make it the default behaviour; it can\ntherefore
  be enabled using a\nflag\n(-typing-recovery) passed to the compiler (which will
  be enabled by\ndefault by Merlin).\nIn order to make error handling explicit, we
  introduce two functions\nintended to replace direct calls to raise in the type-checker.
  When\nthe -typing-recovery flag is not enabled, these functions behave\nexactly
  like raise. In Typing Recovery mode, they record the\nexception in a dedicated structure,
  which will then be processed by\nthe recovery handler.\n\n\nTyping_recovery.log_and_raise
  records the exception before\nre-raising it. It is used when processing cannot continue
  locally\nand captures the general case;\n\n\nTyping_recovery.log_or_raise records
  the exception without\nre-raising it when the context is able to perform local recovery,\nfor
  example, by synthesising an artificial node or by continuing the\ntyping of other
  subterms; it captures more fine-grained cases.\n\n\nThis distinction makes explicit
  the points where recovery is possible\nand those where the exception must necessarily
  be propagated. The API\nguides the implementation of the type-checker and makes
  recovery\ndecisions visible when adding or modifying typing rules.\nToday, we do
  not have a formal criterion to systematically determine\nwhich function to use.
  The integration into the OCaml type-checker was\ntherefore guided by a large set
  of unit tests and empirical\nvalidation. In practice, the choice between the two
  functions depends\non the expected behaviour of recovery, and is validated by observing
  the\nproduced diagnostics. This lack of a general criterion aligns with the\nobservations
  of the paper Merlin: A Language Server for OCaml\n(Experience Report), which notes
  that\nrecovery policies would benefit from a more systematic theoretical\nframework.\nForcing
  User-Facing Error Reporting\nIn Merlin\u2019s historical implementation, the selection
  of exceptions\neligible to trigger a Typing Recovery scenario was mainly based on
  an\nempirical approach. The reimplementation in the compiler made it\npossible to
  identify a simple design invariant: only exceptions\nintended to be reported to
  the user (user-facing errors) should be\nrecorded by the recovery mechanism. Conversely,
  internal type-checker\nexceptions, as well as simply re-raised exceptions (reraise),
  must\nnot be captured.\nTo introduce recovery as a systematic approach, we aim to
  channel\nuser-facing exceptions so that they are always handled through a\npair
  of functions log_and_raise and log_or_raise. To achieve this,\nwe rely on a property
  of the OCaml language: exceptions are\nrepresented by the extensible type\nexn.
  This\nrepresentation makes it possible to control the introduction of new\nexception
  constructors via module interfaces. By making certain\nexception constructors private
  in a module signature, it becomes\npossible to forbid their construction outside
  this module, while still\nallowing them to be deconstructed through pattern matching
  or\nexception handlers. This technique makes it possible to structure\nthe flow
  of user-facing errors and to enforce a systematic passage\nthrough the associated
  logging functions.\n- exception Error of error\n+ module Error : sig \n+   type
  exn += private In_context of error\n+ end = struct\n+   type exn += In_context of
  error\n+\n+   let log_or_raise err = \n+     Type_recovery.log_or_raise (In_context
  err)\n+\n+   let log_and_raise err = \n+     Type_recovery.log_and_raise (In_context
  err)\n+ end\n\nThis transformation also makes it straightforward to rely on the\ncompiler
  to guide the implementation by identifying and handling every\npossible recovery
  case individually and provide a precise API to\nhandle recovery with or without
  resumption.\nClosing Words and Acknowledgements\nAlthough there are still some differences
  between Merlin's vendored\nfront-end and the one maintained by OCaml, this change
  has already\nsignificantly reduced the number of Merlin patches that need to be\napplied.
  In the future, this will greatly simplify the process of\nupgrading to new OCaml
  versions. We recently provided a Merlin\nbranch that anticipates the\n5.6 release
  and relies on the new Typing Recovery mechanism!\nAlthough the next version of OCaml
  will expose the -typing-recovery\nflag to enable this mechanism, the goal is not
  for developers to use\nit directly, but rather for it to be leveraged by tools such
  as\nMerlin.\nHistorically, Typing Recovery was designed and maintained by Merlin's\ntwo
  creators, Fr\xE9d\xE9ric Bour and Thomas\nRefis. It was also maintained over the\nyears
  by Ulysse G\xE9rard. The integration\ninto the compiler was funded by Jane\nStreet.
  The review, conducted by Thomas\nRefis (who contributed greatly to knowledge transfer
  and design\ndiscussions), was funded by The OCaml Software\nFoundation. We would
  also like to thank\nFlorian Angeletti for his quick\nreview, guidance, and detailed
  explanations.\nThis work is part of the broader effort to reduce the gap between\nOCaml
  and Merlin, and it is one of the most significant steps\nin that direction. We believe
  that the integration was carried out in\na smooth and non-intrusive way, minimising
  the impact on maintenance\nwork while drastically reducing the difficulty of future
  version\nupgrades. This will allow us to focus on delivering the best possible\nexperience
  and continuously improve the OCaml code editing\nexperience.\nStay Tuned.\nStay
  In Touch!\nTried out the new update? Connect with us on\nBluesky,\nMastodon,\nThreads,
  and\nLinkedIn or sign up for\nour mailing list to stay updated on our latest projects.
  You can also\nconnect with other OCaml users on\nDiscuss. We look forward to hearing
  your\nthoughts!"
url: https://tarides.com/blog/2026-10-15-ocaml-now-has-type-recovery-when-type-checking-goes-wrong-but-keeps-going
date: 2026-10-15T00:00:00-00:00
preview_image: https://tarides.com/blog/images/recovering_typedtree-1360w.webp
authors:
- Tarides
source:
ignore:
keywords:
- "in_context"
- "log_and_raise"
- "log_or_raise"
- "merlin"
- "pattern matching"
- "recovery"
- "type checker"
- "type inference"
- "type-checker"
- "typing"
---
