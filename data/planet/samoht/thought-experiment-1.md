---
title: 'Thought Experiment #1'
description: "Yesterday evening I was at the first\nThought Experiment, a new series\nof
  informal evenings on how \"AI is changing the way we code, find\nvulnerabilities,
  and prove theorems\". It was held at the\nParis School of AI,\nwhich turns out to
  be a few hundred metres from the\nTarides office, and it was cheerfully\norganised
  by\nCaterina Urban and\nKarthik Bhargavan, with whom we are sending\nformally verified
  post-quantum cryptography to space.\nMessage sequence charts for agents\nBenedikt
  Bollig (CNRS, LMF)\nasked whether AI agents can be made to coordinate safely. I
  read\nhis papers on message sequence charts (MSCs) during my PhD, when I\nwas working
  on scenario languages built\non the same formalism, so I was curious to see where
  he would take\nthem twenty years later. The answer is agentic workflows. An MSC\ndraws
  each participant as a lifeline and each message as an arrow\nbetween two of them,
  and that is a good fit for a system of agents:\nthe message-passing structure around
  the LLM calls is where\ndeadlocks and type-mismatched messages live, and that part
  can be\nchecked. His\npaper with Matthias F\xFCgger and Thomas Nowak\n(ISoLA 2026)
  turns this into a small language in which every choice\nand every loop is decided
  by one named participant, who tells the\nothers which branch was taken. A projection
  then generates each\nagent's local program from the global chart, deadlock-free
  by\nconstruction whatever the LLM calls return. There is a Python\nimplementation
  called ZipperGen.\nWriting an exchange down once and cutting out each participant's\npart
  has a long history, from the realisability of MSCs studied by\nAlur, Etessami and
  Yannakakis\nto the multiparty session types of\nHonda, Yoshida and Carbone;\nI spent
  a few years myself generalising these techniques to more\nabstract partial-order
  automata. They stayed\nin papers because a global specification is long and precise,
  the\nproof that an implementation follows it is longer still, and few\nprojects
  could afford to write either by hand. Over the past year\nthat cost has collapsed,
  because models now write the verbose\nparts. So the same ideas are resurfacing twenty
  years later, with\nconcrete applications, and I find that fascinating.\nI have also
  tried to revive those ideas recently, in a new\nframework I called\nocaml-fsm (it
  now\nhandles symbolic state machines too, so I should think of another\nname before
  a proper release :p). It is early days and very much a\nprototype, limited to Mazurkiewicz
  traces for now, with full pomset\nautomata cooking. Used as an oracle, though, it
  has already found\nbugs in reviewed and tested code, such as a security association
  in\nour CCSDS stack that could\nbe neither created nor deleted. Compared with Benedikt's
  agents, it works one\nlevel down, on the finite control of protocols such as\nHTTP/2,\nSSH\nor
  the CCSDS security\nlayer, and at the same level in\nmq, my\nmerge queue, where
  landing a branch is one description of the flow\nbetween the caller, the hook that
  admits the entry, the run that\nholds the lock and the resolver that takes its conflicts.
  The rule\nis one exhaustive OCaml function. The tool evaluates it over the\nfinite
  domains of states and inputs, and reports the states the\ncode can never reach and
  the arrows it can never take, each with\nthe shortest sequence of messages that
  shows it. Fsm.Global.project\ndoes the projection, cutting each party's machine
  out of one\ndescription of the whole exchange, on the\nboxed-pomset theory Lo\xEFc
  H\xE9lou\xEBt and I\nworked out in 2007 (so the talk felt like familiar ground).
  A\nkeepalive protocol is written once for both parties, one arrow per\nmessage,
  and the sender of a message the standard leaves optional\nis the one who decides:\nlet
  keepalive ping =\n  Fsm.Global.v ~name:\"keepalive\" ~initial:Fresh ~roles:[ Client;
  Server ]\n    ~pp_role ~controls:[ Fresh; Live; Over ] ~pp_control:pp_phase\n    ~arrows:\n
  \     [\n        Fsm.Global.arrow ~sender:Client ~receiver:Server Hello;\n        Fsm.Global.arrow
  ~sender:Client ~receiver:Server Ping;\n        Fsm.Global.arrow ~sender:Client ~receiver:Server
  Bye;\n      ]\n    ~pp_message ~error:pp_error ~finals:[ Over ]\n    (fun phase
  (arrow : (role, message) Fsm.Global.arrow) ->\n      match (phase, arrow.message)
  with\n      | Fresh, Hello -> Fsm.goto Live ~effects:[]\n      | Fresh, (Ping |
  Bye) -> Fsm.refuse Not_open ~effects:[]\n      | Live, Hello -> Fsm.refuse Busy
  ~effects:[]\n      | Live, Ping -> ping ()\n      | Live, Bye -> Fsm.goto Over ~effects:[]\n
  \     | Over, (Hello | Ping | Bye) -> Fsm.refuse Finished ~effects:[])\n\nFsm.Global.project
  then gives each party its own automaton. The\nclient may send a ping or not; the
  server takes it whenever it\ncomes.\n# let () = show_party Client \"send ping to
  server\";;\nlive on send ping to server: goto live\nlive on send ping to server:
  reject quiet\nlatitude on send ping to server in live: Example 5.1, recommended
  false\n# let () = show_party Server \"receive ping from client\";;\nlive on receive
  ping from client: goto live\nno latitude\n\nThe realisability check runs when the
  description is built, so a\ntest that constructs it is enough to catch it (the types
  do not,\nyet). If accepting the ping could lead to two different phases, the\nserver
  could not tell from the message which one the client chose,\nso the constructor
  refuses the description. The message names the\ncell, the ping at live, and the
  two phases, live and over, that\nthe receiver would have to choose between without
  being told.\nkeepalive (fun () ->\n    Fsm.may ~clause:\"Example 5.2\"\n      [
  Fsm.goto Live ~effects:[]; Fsm.goto Over ~effects:[] ])\n\nProofs on machine code,
  and the oracle problem\n\xDAlfar Erlingsson (Google\nCloud Security) had the best
  title of the evening, \"Petrifying the\ndungheap: Better software through bookkeeping\".
  His starting point\nis that finding bugs has become so easy that the software we
  all\nbuild on stands revealed as a dungheap. We see it in the OCaml\necosystem too,
  from two directions. The frontier models now write\nOCaml well (a few of us\nwrote
  last year about what it\nwould take), so the bug and security reports reaching the\nOCaml
  compiler and the libraries\naround it have become noticeably better, and a report
  now tends to\ncome with a patch that compiles and a test that fails without it.\nAnd
  Scrutineer,\nAndrew Nesbitt's agentic scanner, finds plenty: by the\nend of September
  a dozen\nOCaml developers were triaging on\nAnil's instance\nand twenty-four fixes
  had been merged in ocaml-tls, ocaml-x509,\nmirage-crypto and others.\nType safety\ndefinitely
  helps here, but there is still a surprising number of bugs lying\naround in our
  nice OCaml libraries.\n\xDAlfar's bookkeeping is for the code that cannot be rewritten
  in a\nsafer language, because its performance and memory footprint have\nto stay
  where they are, and because even its bugs are part of its\ncontract: fix one and
  something that relied on it breaks. The idea\nis to prove pre- and post-conditions
  directly on the machine code,\nwith neither the source nor the\ncompiler in the
  trusted base, and to use the proofs to find\nmemory-safety bugs in software as it
  ships. The proofs are\ngenerated, which raises the question every generated artefact\nraises:
  is the program the proof was built for the program that\nships? His answer is the
  cheapest oracle there is, a byte-for-byte\ncomparison of the generated binaries.\nI
  met the same question\nporting Tailwind to OCaml, where\nmodels wrote much of the
  code. The first check was bytes against\nthe reference compiler's output, then a
  CSS-aware diff, because the\nreference emits spellings that differ without mattering.
  But a\nmodel can change a test and the code it checks in the same commit,\nso the
  check that decides has to share no code with either tool. In\nmy case it is Chrome
  rendering both stylesheets and comparing\npixels. \xDAlfar's bytes and my pixels
  do the same job. Once a model\ngenerates the artefact, the oracle has to sit outside
  anything the\nmodel can touch, and the simpler it is, the easier it is to trust.\nAI
  tools for democracy\nL\xEA Nguy\xEAn Hoang\n(T\xE9l\xE9com Paris) closed with \"AI
  tools to\ndemocratically govern AIs\". He started from the attacks: AI is\nbeing
  used against democracies everywhere, in disinformation and\nin the recommendation
  systems that amplify it. His point is that\nthe same tools can make democracies
  harder to attack, with better\nrecommender systems and tools for building consensus,
  and Taiwan's\ng0v civic-tech community was his running\nexample. (He is also behind
  Tournesol, a\nparticipatory recommender.) I am halfway through\nPlurality by Glen
  Weyl and Audrey\nTang, so the talk landed on prepared ground.\nIt also made me finish
  a small thing I had been playing with,\na page on French public money\nthat lays
  out the official figures, each number linking to the\nEurostat or\nInsee cell it
  came from and the\narithmetic in between.\nIt is a visualisation tool and nothing
  more. I have a few other\nideas for this kind of data (one\nof them is a map of
  every commune, below), and I will write about\nthem if they become something.\n\n
  \ \n    \n    The home page of the public-money page. Each underlined figure opens
  its source.\n  \n  \n    \n    The 35,000 communes, each coloured by the indicator
  per resident furthest above the French average (energy, water, farmland, building
  materials, commuting wages, jobs, industrial CO\u2082), year by year from 2006 to
  2027."
url: https://gazagnaire.org/blog/2026-10-16-thought-experiment-1.html
date: 2026-10-16T00:00:00-00:00
preview_image: https://gazagnaire.org/blog/og/2026-10-16-thought-experiment-1.png
authors:
- Thomas Gazagnaire
source:
ignore:
keywords:
- "arrow"
- "bye"
- "cryptography"
- "fsm"
- "goto"
- "keepalive"
- "live"
- "ping"
- "plurality"
- "ulfar"
---
