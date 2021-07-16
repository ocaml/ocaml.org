
type role =
  [ `Chair
  | `Co_chair
  ]

  type important_date = { date : string; info : string }

  type committee_member = {
    name : string;
    role : role option;
    affiliation : string option;
  }
  
  type presentation = {
    title : string;
    authors : string list;
    link : string option;
    video : string option;
    slides : string option;
    additional_links : string list option;
  }
  
  type metadata = {
    title : string;
    location : string option;
    date : string;
    online : bool;
    important_dates : important_date list;
    presentations : presentation list;
    program_committee : committee_member list;
    organising_committee : committee_member list;
  }
  
  type t = {
    title : string;
    slug : string;
    location : string option;
    date : string;
    online : bool;
    important_dates : important_date list;
    presentations : presentation list;
    program_committee : committee_member list;
    organising_committee : committee_member list;
    toc_html : string;
    body_md : string;
    body_html : string;
  }
  
let all = 
[
  { title = {js|OCaml Users and Developers Workshop 2017|js}
  ; slug = {js|ocaml-users-and-developers-workshop-2017|js}
  ; location = Some {js|Oxford, UK|js}
  ; date = {js|2017-09-08|js}
  ; online = false
  ; important_dates = 
 [
  { date = {js|2017-05-31|js};
    info = {js|Abstract submission deadline (any timezone)|js};
  };
  
  { date = {js|2017-06-28|js};
    info = {js|Author notification|js};
  };
  
  { date = {js|2017-09-08|js};
    info = {js|OCaml Workshop|js};
  }]
  ; presentations = 
 [
  { title = {js|A B-tree library for OCaml|js};
    authors = ["Tom Ridge"];
    link = Some {js|workshop/2017/extended-abstract__2017__tom-ridge__a-b-tree-library-for-ocaml.pdf|js};
    video = None;
    slides = Some {js|workshop/2017/slides__2017__tom-ridge__a-b-tree-library-for-ocaml.pdf|js};
    additional_links = None;
  };
  
  { title = {js|A memory model for multicore OCaml|js};
    authors = 
  ["Stephen Dolan"; "KC Sivaramakrishnan"];
    link = Some {js|https://github.com/ocaml/ocaml.org-media/blob/master/meetings/ocaml/2017/extended-abstract__2017__stephen-dolan_kc-sivaramakrishnan__a-memory-model-for-multicore-ocaml.pdf|js};
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|Component-based Program Synthesis in OCaml|js};
    authors = 
  ["Zhanpeng Liang"; "Kanae Tsushima"];
    link = Some {js|https://github.com/ocaml/ocaml.org-media/blob/master/meetings/ocaml/2017/extended-abstract__2017__zhanpeng-liang_kanae-tsushima__component-based-program-synthesis-in-ocaml.pdf|js};
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|Extending OCaml's open|js};
    authors = ["Runhang Li";
                                                              "Jeremy Yallop"];
    link = Some {js|https://github.com/ocaml/ocaml.org-media/blob/master/meetings/ocaml/2017/extended-abstract__2017__runhang-li_jeremy-yallop__extending-ocaml-s-open.pdf|js};
    video = Some {js|https://www.youtube.com/watch?v=rxCMop-dTuc&index=4&list=TLGGpj_CrU7rr7MxMjAxMjAxOA|js};
    slides = None;
    additional_links = Some 
  ["https://github.com/objmagic/ocaml-workshop-17-open-ext-talk"];
  };
  
  { title = {js|Genspio: Generating Shell Phrases In OCaml|js};
    authors = 
  ["Sebastien Mondet"];
    link = Some {js|https://github.com/ocaml/ocaml.org-media/blob/master/meetings/ocaml/2017/extended-abstract__2017__sebastien-mondet__genspio-generating-shell-phrases-in-ocaml.pdf|js};
    video = Some {js|https://www.youtube.com/watch?v=prwLcBUoYiA&index=3&list=TLGGpj_CrU7rr7MxMjAxMjAxOA|js};
    slides = Some {js|http://wr.mondet.org/slides/OCaml2017-Genspio/|js};
    additional_links = Some 
  ["https://github.com/hammerlab/genspio"];
  };
  
  { title = {js|Owl: A General-Purpose Numerical Library in OCaml|js};
    authors = 
  ["Liang Wang"];
    link = Some {js|https://arxiv.org/abs/1707.09616|js};
    video = Some {js|https://www.youtube.com/watch?v=Jyv3tJD1N3o&index=7&list=TLGGpj_CrU7rr7MxMjAxMjAxOA|js};
    slides = Some {js|https://github.com/ocaml/ocaml.org-media/blob/master/meetings/ocaml/2017/slides__2017__liang_wang__owl-a-general-purpose-numerical-library-in-ocaml.pdf|js};
    additional_links = None;
  };
  
  { title = {js|ROTOR: First Steps Towards a Refactoring Tool for OCaml|js};
    authors = 
  ["Reuben N. S. Rowe"; "Simon Thompson"];
    link = Some {js|https://github.com/ocaml/ocaml.org-media/blob/master/meetings/ocaml/2017/extended-abstract__2017__reuben-rowe_simon-thompson__rotor-first-steps-towards-a-refactoring-tool-for-ocaml.pdf|js};
    video = None;
    slides = Some {js|https://github.com/ocaml/ocaml.org-media/blob/master/meetings/ocaml/2017/slides__2017__reuben-rowe_simon-thompson__rotor-first-steps-towards-a-refactoring-tool-for-ocaml.pdf|js};
    additional_links = Some 
  ["https://gitlab.com/trustworthy-refactoring/";
   "https://hub.docker.com/r/reubenrowe/ocaml-rotor"];
  };
  
  { title = {js|Testing with Crowbar|js};
    authors = ["Stephen Dolan";
                                                            "Mindy Preston"];
    link = Some {js|https://github.com/ocaml/ocaml.org-media/blob/master/meetings/ocaml/2017/extended-abstract__2017__stephen-dolan_mindy-preston__testing-with-crowbar.pdf|js};
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|Tezos: the OCaml Crypto-Ledger|js};
    authors = 
  ["Benjamin Canou"; "Grégoire Henry"; "Pierre Chambart";
   "Fabrice Le Fessant"; "Arthur Breitman"];
    link = Some {js|https://github.com/ocaml/ocaml.org-media/blob/master/meetings/ocaml/2017/extended-abstract__2017__benjamin-canou_gregoire-henry_pierre-chambart_fabrice-le-fessant_arthur-breitman__tezos-the-ocaml-crypto-ledger.pdf|js};
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|The State of the OCaml Platform: September 2017|js};
    authors = 
  ["Anil Madhavapeddy"];
    link = Some {js|https://github.com/ocaml/ocaml.org-media/blob/master/meetings/ocaml/2017/slides__2017__anil-madhavapeddy__the-state-of-the-ocaml-platform-september-2017.pdf|js};
    video = Some {js|https://www.youtube.com/watch?v=y-1Zrzdd9KM&index=6&list=TLGGpj_CrU7rr7MxMjAxMjAxOA|js};
    slides = Some {js|https://speakerdeck.com/avsm/ocaml-platform-2017|js};
    additional_links = None;
  };
  
  { title = {js|Wodan: a pure OCaml, flash-aware filesystem library|js};
    authors = 
  ["Gabriel de Perthuis"];
    link = Some {js|https://github.com/ocaml/ocaml.org-media/blob/master/meetings/ocaml/2017/extended-abstract__2017__gabriel-de-perthuis__wodan-a-pure-ocaml-flash-aware-filesystem-library.pdf|js};
    video = None;
    slides = None;
    additional_links = None;
  }]
  ; program_committee = 
 [
  { name = {js|Ashish Agarwal|js};
    role = None;
    affiliation = Some {js|Solvuu, USA|js};
  };
  
  { name = {js|François Bobot|js};
    role = None;
    affiliation = Some {js|CEA, France|js};
  };
  
  { name = {js|Frédéric Bour|js};
    role = None;
    affiliation = Some {js|OCaml Labs, France|js};
  };
  
  { name = {js|Cristiano Calcagno|js};
    role = None;
    affiliation = Some {js|Facebook, UK|js};
  };
  
  { name = {js|Louis Gesbert|js};
    role = None;
    affiliation = Some {js|OcamlPro, France|js};
  };
  
  { name = {js|Sébastien Hinderer|js};
    role = None;
    affiliation = Some {js|INRIA, France|js};
  };
  
  { name = {js|Atsushi Igarashi|js};
    role = None;
    affiliation = Some {js|Kyoto University, Japan|js};
  };
  
  { name = {js|Oleg Kiselyov|js};
    role = None;
    affiliation = Some {js|Tohoku University, Japan|js};
  };
  
  { name = {js|Julia Lawall|js};
    role = None;
    affiliation = Some {js|INRIA/LIP6, France|js};
  };
  
  { name = {js|Sam Lindley|js};
    role = None;
    affiliation = Some {js|The University of Edinburgh, UK|js};
  };
  
  { name = {js|Louis Mandel|js};
    role = None;
    affiliation = Some {js|IBM Research, USA|js};
  };
  
  { name = {js|Zoe Paraskevopoulou|js};
    role = None;
    affiliation = Some {js|Princeton University, USA|js};
  };
  
  { name = {js|Gabriel Scherer|js};
    role = None;
    affiliation = Some {js|Northeastern University, USA|js};
  }]
  ; organising_committee = 
 []
  ; body_md = {js|
OCaml 2017 will open with an invited talk by three frequent
contributors that recently became maintainers of the OCaml
implementation: David Allsopp
([video](https://www.youtube.com/watch?v=10OQHsnyg64&index=2&list=TLGGpj_CrU7rr7MxMjAxMjAxOA)),
Florian Angeletti
([video](https://www.youtube.com/watch?v=HOfdGDSypP4&list=TLGGpj_CrU7rr7MxMjAxMjAxOA&index=5)),
and Sébastien Hinderer
([video](https://www.youtube.com/watch?v=SvnyQWZkHS8&list=TLGGpj_CrU7rr7MxMjAxMjAxOA&index=1)).

Due to the high number of high-quality submissions, we had to have
more posters than in previous editions to fit a one-day
schedule. 


The following works will be presented as posters.

- _ocamli: Interpreted OCaml_ —
  John Whitington  
  [extended abstract](http://www.cs.le.ac.uk/people/jw642/ocamlworkshop.pdf)
  ([local copy](extended-abstract__2017__john_whitington__ocamli-interpreted-ocaml.pdf))

- _mSAT: An OCaml SAT Solver_ —
  Bury Guillaume  
  [extended abstract](https://gbury.eu/public/papers/icfp2017_msat.pdf)
  ([local copy](extended-abstract__2017__guillaume-bury__msat-an-ocaml-sat-solver.pdf))

- _Tyre – Typed Regular Expressions_ —
  Gabriel Radanne  
  ([extended abstract](https://www.irif.fr/~gradanne/papers/tyre/abstract.pdf)
   ([local copy](extended-abstract__2017__gabriel-radanne__tyre-typed-regular-expressions.pdf)))

- _Jbuilder: a modern approach to OCaml development_ —
  Jeremie Dimino, Mark Shinwell  
  ([local copy](extended-abstract__2017__jeremie-dimino_mark-shinwell__jbuilder-a-modern-approach-to-ocaml-development.pdf))


## Call for presentations (past)

### Scope

Presentations and discussions will focus on the OCaml
programming language and its community. We aim to solicit talks
on all aspects related to improving the use or development of
the language and its programming environment, including, for
example (but not limited to):

- compiler developments, new backends, runtime and architectures

- practical type system improvements, such as (but not
  limited to) GADTs, first-class modules, generic programming,
  or dependent types

- new library or application releases, and their design
  rationales

- tools and infrastructure services, and their enhancements

- prominent industrial or experimental uses of OCaml, or
  deployments in unusual situations.

### Presentations

It will be an informal meeting with no formal proceedings. The
presentation material will be available online from the workshop
homepage. The presentations may be recorded, and made available
at a later time.

The main presentation format is a workshop talk, traditionally
around 20 minutes in length, plus question time, but we also
have a poster session during the workshop -- this allows to
present more diverse work, and gives time for discussion. The
program committee will decide which presentations should be
delivered as posters or talks.

### Submission

To submit a presentation, please register a description of the
talk (about 2 pages long) at <https://icfp-ocaml17.hotcrp.com/>
providing a clear statement of what will be provided by the
presentation: the problems that are addressed, the solutions or
methods that are proposed.

LaTeX-produced PDFs are a common and welcome submission
format. For accessibility purposes, we ask PDF submitters to
also provide the sources of their submission in a textual
format, such as .tex sources. Reviewers may read either the
submitted PDF or the text version.

### ML family workshop and post-proceedings

The ML family workshop, held on the previous day, deals with
general issues of the ML-style programming and type systems,
focuses on more research-oriented work that is less specific to
a language in particular (OCaml). There is an overlap between
the two workshops, and we have occasionally transferred
presentations from one to the other in the past. The authors who
feel their submission fits both workshops are encouraged to
mention it at submission time and/or contact the Program Chairs.

We are planning to publish combined post-proceedings and to
invite interested authors of selected presentations to expand
their abstracts for inclusion.


### Questions and contact

Please send any questions to the chair:
`Gabriel Scherer <gabriel.scherer@gmail.com>`|js}
  ; toc_html = {js|<ul>
<li><ul>
<li>Call for presentations (past)
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<p>OCaml 2017 will open with an invited talk by three frequent
contributors that recently became maintainers of the OCaml
implementation: David Allsopp
(<a href="https://www.youtube.com/watch?v=10OQHsnyg64&amp;index=2&amp;list=TLGGpj_CrU7rr7MxMjAxMjAxOA">video</a>),
Florian Angeletti
(<a href="https://www.youtube.com/watch?v=HOfdGDSypP4&amp;list=TLGGpj_CrU7rr7MxMjAxMjAxOA&amp;index=5">video</a>),
and Sébastien Hinderer
(<a href="https://www.youtube.com/watch?v=SvnyQWZkHS8&amp;list=TLGGpj_CrU7rr7MxMjAxMjAxOA&amp;index=1">video</a>).</p>
<p>Due to the high number of high-quality submissions, we had to have
more posters than in previous editions to fit a one-day
schedule.</p>
<p>The following works will be presented as posters.</p>
<ul>
<li>
<p><em>ocamli: Interpreted OCaml</em> —
John Whitington<br />
<a href="http://www.cs.le.ac.uk/people/jw642/ocamlworkshop.pdf">extended abstract</a>
(<a href="extended-abstract__2017__john_whitington__ocamli-interpreted-ocaml.pdf">local copy</a>)</p>
</li>
<li>
<p><em>mSAT: An OCaml SAT Solver</em> —
Bury Guillaume<br />
<a href="https://gbury.eu/public/papers/icfp2017_msat.pdf">extended abstract</a>
(<a href="extended-abstract__2017__guillaume-bury__msat-an-ocaml-sat-solver.pdf">local copy</a>)</p>
</li>
<li>
<p><em>Tyre – Typed Regular Expressions</em> —
Gabriel Radanne<br />
(<a href="https://www.irif.fr/~gradanne/papers/tyre/abstract.pdf">extended abstract</a>
(<a href="extended-abstract__2017__gabriel-radanne__tyre-typed-regular-expressions.pdf">local copy</a>))</p>
</li>
<li>
<p><em>Jbuilder: a modern approach to OCaml development</em> —
Jeremie Dimino, Mark Shinwell<br />
(<a href="extended-abstract__2017__jeremie-dimino_mark-shinwell__jbuilder-a-modern-approach-to-ocaml-development.pdf">local copy</a>)</p>
</li>
</ul>
<h2>Call for presentations (past)</h2>
<h3>Scope</h3>
<p>Presentations and discussions will focus on the OCaml
programming language and its community. We aim to solicit talks
on all aspects related to improving the use or development of
the language and its programming environment, including, for
example (but not limited to):</p>
<ul>
<li>
<p>compiler developments, new backends, runtime and architectures</p>
</li>
<li>
<p>practical type system improvements, such as (but not
limited to) GADTs, first-class modules, generic programming,
or dependent types</p>
</li>
<li>
<p>new library or application releases, and their design
rationales</p>
</li>
<li>
<p>tools and infrastructure services, and their enhancements</p>
</li>
<li>
<p>prominent industrial or experimental uses of OCaml, or
deployments in unusual situations.</p>
</li>
</ul>
<h3>Presentations</h3>
<p>It will be an informal meeting with no formal proceedings. The
presentation material will be available online from the workshop
homepage. The presentations may be recorded, and made available
at a later time.</p>
<p>The main presentation format is a workshop talk, traditionally
around 20 minutes in length, plus question time, but we also
have a poster session during the workshop -- this allows to
present more diverse work, and gives time for discussion. The
program committee will decide which presentations should be
delivered as posters or talks.</p>
<h3>Submission</h3>
<p>To submit a presentation, please register a description of the
talk (about 2 pages long) at <a href="https://icfp-ocaml17.hotcrp.com/">https://icfp-ocaml17.hotcrp.com/</a>
providing a clear statement of what will be provided by the
presentation: the problems that are addressed, the solutions or
methods that are proposed.</p>
<p>LaTeX-produced PDFs are a common and welcome submission
format. For accessibility purposes, we ask PDF submitters to
also provide the sources of their submission in a textual
format, such as .tex sources. Reviewers may read either the
submitted PDF or the text version.</p>
<h3>ML family workshop and post-proceedings</h3>
<p>The ML family workshop, held on the previous day, deals with
general issues of the ML-style programming and type systems,
focuses on more research-oriented work that is less specific to
a language in particular (OCaml). There is an overlap between
the two workshops, and we have occasionally transferred
presentations from one to the other in the past. The authors who
feel their submission fits both workshops are encouraged to
mention it at submission time and/or contact the Program Chairs.</p>
<p>We are planning to publish combined post-proceedings and to
invite interested authors of selected presentations to expand
their abstracts for inclusion.</p>
<h3>Questions and contact</h3>
<p>Please send any questions to the chair:
<code>Gabriel Scherer &lt;gabriel.scherer@gmail.com&gt;</code></p>
|js}
  };
 
  { title = {js|OCaml Users and Developers Workshop 2018|js}
  ; slug = {js|ocaml-users-and-developers-workshop-2018|js}
  ; location = Some {js|St. Louis, Missouri, USA|js}
  ; date = {js|2018-08-23|js}
  ; online = false
  ; important_dates = 
 [
  { date = {js|2018-05-31|js};
    info = {js|Abstract submission deadline (any timezone)|js};
  };
  
  { date = {js|2018-09-27|js};
    info = {js|OCaml Workshop|js};
  }]
  ; presentations = 
 [
  { title = {js|Abusing Format for fun and profits|js};
    authors = 
  ["Gabriel Radanne"; "Frédéric Bour"];
    link = None;
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|MLExplain|js};
    authors = ["Kévin Le Bon";
                                                 "Alan Schmitt"];
    link = None;
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|OCaml on the ESP32 chip: Well-Typed Lightbulbs Await|js};
    authors = 
  ["Lucas Pluvinage"; "Sadiq Jaffer"; "Anil Madhavapeddy"];
    link = None;
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|R&B: Towards bringing functional programming to everyday's web programmer|js};
    authors = 
  ["Hongbo Zhang"; "Cristiano Calcagno"; "Jordan Walke"; "Cheng Lou";
   "Rick Vetter"];
    link = None;
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|RFCs, all the way down!|js};
    authors = ["Romain Calascibetta"];
    link = None;
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|Relit: Implementing Typed Literal Macros in Reason|js};
    authors = 
  ["Charles Chamberlain"; "Cyrus Omar"];
    link = None;
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|The OCaml Platform 1.0|js};
    authors = ["Anil Madhavapeddy";
                                                              "Gemma Gordon"];
    link = None;
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|The OCaml Software Foundation|js};
    authors = ["Michel Mauny";
                                                                    "Yann Régis-Gianas"];
    link = None;
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|The Vecosek Ecosystem|js};
    authors = ["Sebastien Mondet"];
    link = None;
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|This PDF is an OCaml bytecode|js};
    authors = ["Gabriel Radanne"];
    link = None;
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|Wall: rendering vector graphics with OCaml and OpenGL|js};
    authors = 
  ["Frédéric Bour"];
    link = None;
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|Winning on Windows: porting the OCaml Platform|js};
    authors = 
  ["David Allsopp"];
    link = None;
    video = None;
    slides = None;
    additional_links = None;
  }]
  ; program_committee = 
 [
  { name = {js|Andrew Kennedy|js};
    role = Some `Chair;
    affiliation = Some {js|Facebook, London|js};
  };
  
  { name = {js|Stephen Dolan|js};
    role = None;
    affiliation = Some {js|University of Cambridge, UK|js};
  };
  
  { name = {js|Clark Gaebel|js};
    role = None;
    affiliation = Some {js|Jane Street|js};
  };
  
  { name = {js|Nicolás Ojeda Bär|js};
    role = None;
    affiliation = Some {js|LexiFi|js};
  };
  
  { name = {js|Jonathan Protzenko|js};
    role = None;
    affiliation = Some {js|Microsoft Research Redmond, USA|js};
  };
  
  { name = {js|Gabriel Scherer|js};
    role = None;
    affiliation = Some {js|INRIA Saclay, France|js};
  };
  
  { name = {js|Kanae Tsushima|js};
    role = None;
    affiliation = Some {js|National Institute of Informatics, Japan|js};
  };
  
  { name = {js|John Whitington|js};
    role = None;
    affiliation = Some {js|University of Leicester, UK|js};
  }]
  ; organising_committee = 
 []
  ; body_md = {js|
OCaml 2018 will be held on September 27th, 2018 in St. Louis, Missouri, USA, colocated with ICFP 2018.|js}
  ; toc_html = {js||js}
  ; body_html = {js|<p>OCaml 2018 will be held on September 27th, 2018 in St. Louis, Missouri, USA, colocated with ICFP 2018.</p>
|js}
  };
 
  { title = {js|OCaml Workshop 2019|js}
  ; slug = {js|ocaml-workshop-2019|js}
  ; location = Some {js|Berlin, Germany|js}
  ; date = {js|2019-08-23|js}
  ; online = false
  ; important_dates = 
 [
  { date = {js|2019-05-17|js};
    info = {js|Abstract submission deadline (any timezone)|js};
  };
  
  { date = {js|2019-06-30|js};
    info = {js|Author notification|js};
  };
  
  { date = {js|2019-08-23|js};
    info = {js|OCaml Workshop|js};
  }]
  ; presentations = 
 [
  { title = {js|Codept, a whole-project dependency analyzer for OCaml|js};
    authors = 
  ["Florian Angeletti"];
    link = None;
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|MirageOS 4: the dawn of practical build systems for exotic targets|js};
    authors = 
  ["Lucas Pluvinage"; "Romain Calascibetta"; "Rudi Grinberg";
   "Anil Madhavapeddy"];
    link = None;
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|Makecloud: Simple, Fast, Robust CI/CD for the modern era|js};
    authors = 
  ["Adam Ringwood"; "Hezekiah Carty"];
    link = None;
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|The future of OCaml PPX: towards a unified and more robust ecosystem|js};
    authors = 
  ["Nathan Rebours"; "Jeremie Dimino"; "Xavier Clerc"; "Carl Eastlund"];
    link = None;
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|CausalRPC: traceable distributed computation|js};
    authors = 
  ["Craig Ferguson"];
    link = None;
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|The OCaml Platform in 2019|js};
    authors = ["Anil Madhavapeddy";
                                                                  "Gemma Gordon"];
    link = None;
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|Lessons from building a succinct blockchain with OCaml|js};
    authors = 
  ["Nathan Holland"];
    link = None;
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|OwlDE: making ODEs first-class Owl citizens|js};
    authors = 
  ["Marcello Seri"; "Ta-Chu Kao"];
    link = None;
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|Benchmarking the OCaml compiler: our experience|js};
    authors = 
  ["Tom Kelly"];
    link = None;
    video = None;
    slides = None;
    additional_links = None;
  };
  
  { title = {js|Executing Owl Computation on GPU and TPU|js};
    authors = 
  ["Jianxin Zhao"];
    link = None;
    video = None;
    slides = None;
    additional_links = None;
  }]
  ; program_committee = 
 [
  { name = {js|David Allsopp|js};
    role = Some `Chair;
    affiliation = Some {js|University of Cambridge, UK|js};
  };
  
  { name = {js|Raja Boujbel|js};
    role = None;
    affiliation = Some {js|OCamlPro, France|js};
  };
  
  { name = {js|Timothy Bourke|js};
    role = None;
    affiliation = Some {js|INRIA, France|js};
  };
  
  { name = {js|Simon Cruanes|js};
    role = None;
    affiliation = Some {js|Imandra, USA|js};
  };
  
  { name = {js|Emilio Jésus Gallego Arias|js};
    role = None;
    affiliation = Some {js|MINES ParisTech, France|js};
  };
  
  { name = {js|Thomas Gazagnaire|js};
    role = None;
    affiliation = Some {js|Tarides, France|js};
  };
  
  { name = {js|Ivan Gotovchits|js};
    role = None;
    affiliation = Some {js|CMU, USA|js};
  };
  
  { name = {js|Hannes Mehnert|js};
    role = None;
    affiliation = Some {js|robur.io, Germany|js};
  };
  
  { name = {js|Igor Pikovets|js};
    role = None;
    affiliation = Some {js|Ahrefs, Singapore|js};
  };
  
  { name = {js|Thomas Refis|js};
    role = None;
    affiliation = Some {js|Jane Street Europe, UK|js};
  };
  
  { name = {js|KC Sivaramakrishan|js};
    role = None;
    affiliation = Some {js|IIT Madras, India|js};
  }]
  ; organising_committee = 
 []
  ; body_md = {js|
The OCaml Users and Developers Workshop brings together the OCaml community, including users of OCaml in industry, academia, hobbyists and the free software community.

The meeting is an informal community gathering of users of the language, library authors, and developers, using and extending OCaml in new ways.
|js}
  ; toc_html = {js||js}
  ; body_html = {js|<p>The OCaml Users and Developers Workshop brings together the OCaml community, including users of OCaml in industry, academia, hobbyists and the free software community.</p>
<p>The meeting is an informal community gathering of users of the language, library authors, and developers, using and extending OCaml in new ways.</p>
|js}
  };
 
  { title = {js|OCaml Workshop 2020|js}
  ; slug = {js|ocaml-workshop-2020|js}
  ; location = Some {js|Jersey City, New Jersey, USA|js}
  ; date = {js|2020-08-28|js}
  ; online = true
  ; important_dates = 
 [
  { date = {js|2020-05-29|js};
    info = {js|Abstract submission deadline (any timezone)|js};
  };
  
  { date = {js|2020-07-17|js};
    info = {js|Author notification|js};
  };
  
  { date = {js|2020-08-14|js};
    info = {js|Camera-ready Deadline|js};
  };
  
  { date = {js|2020-08-28|js};
    info = {js|OCaml Workshop|js};
  }]
  ; presentations = 
 [
  { title = {js|A Declarative Syntax Definition for OCaml|js};
    authors = 
  ["Luis Eduardo de Souza Amorim"; "Eelco Visser"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/a5b86864-8e43-4138-b6d6-ed48d2d4b63d|js};
    slides = None;
    additional_links = None;
  };
  
  { title = {js|A Simple State-Machine Framework for Property-Based Testing in OCaml|js};
    authors = 
  ["Jan Midtgaard"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/08b429ea-2eb8-427d-a625-5495f4ee0fef|js};
    slides = None;
    additional_links = None;
  };
  
  { title = {js|AD-OCaml: Algorithmic Differentiation for OCaml|js};
    authors = 
  ["Markus Mottl"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/c9e85690-732f-4b03-836f-2ee0fd8f0658|js};
    slides = None;
    additional_links = None;
  };
  
  { title = {js|API Migration: compare transformed|js};
    authors = 
  ["Joseph Harrison"; "Steven Varoumas"; "Simon Thompson"; "Reuben Rowe"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/c46b925b-bd77-404f-ac5d-5dab65047529|js};
    slides = None;
    additional_links = None;
  };
  
  { title = {js|Irmin v2|js};
    authors = ["Clément Pascutto";
                                                "Ioana Cristescu";
                                                "Craig Ferguson";
                                                "Thomas Gazagnaire";
                                                "Romain Liautaud"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/53e497b0-898f-4c85-8da9-39f65ef0e0b1|js};
    slides = None;
    additional_links = None;
  };
  
  { title = {js|LexiFi Runtime Types|js};
    authors = ["Patrik Keller";
                                                            "Marc Lasson"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/cc7e3242-0bef-448a-aa13-8827bba933e3|js};
    slides = None;
    additional_links = None;
  };
  
  { title = {js|OCaml Under The Hood: SmartPy|js};
    authors = ["Sebastien Mondet"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/7446ad4d-4ae2-4e1a-bc38-af8f71e8ebd8|js};
    slides = None;
    additional_links = None;
  };
  
  { title = {js|OCaml-CI: A Zero-Configuration CI|js};
    authors = 
  ["Thomas Leonard"; "Craig Ferguson"; "Kate Deplaix"; "Magnus Skjegstad";
   "Anil Madhavapeddy"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/da88d6ac-7ba1-4261-9308-d03fe21e35b9|js};
    slides = None;
    additional_links = None;
  };
  
  { title = {js|Parallelising your OCaml Code with Multicore OCaml|js};
    authors = 
  ["Sadiq Jaffer"; "Sudha Parimala"; "KC Sivaramakrishnan"; "Tom Kelly";
   "Anil Madhavapeddy"];
    link = Some {js|https://github.com/ocaml-multicore/multicore-talks/tree/master/ocaml2020-workshop-parallel|js};
    video = Some {js|https://watch.ocaml.org/videos/watch/ce20839e-4bfc-4d74-925b-485a6b052ddf|js};
    slides = None;
    additional_links = None;
  };
  
  { title = {js|The ImpFS filesystem|js};
    authors = ["Tom Ridge"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/28545b27-4637-47a5-8edd-6b904daef19c|js};
    slides = None;
    additional_links = None;
  };
  
  { title = {js|The Final Pieces of the OCaml Documentation Puzzle|js};
    authors = 
  ["Jonathan Ludlam"; "Gabriel Radanne"; "Leo White"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/2acebff9-25fa-4733-83cc-620a65b12251|js};
    slides = None;
    additional_links = None;
  };
  
  { title = {js|Types in amber|js};
    authors = ["Paul Steckler";
                                                      "Matthew Ryan"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/99b3dc75-9f93-4677-9f8b-076546725512|js};
    slides = None;
    additional_links = None;
  }]
  ; program_committee = 
 [
  { name = {js|Ivan Gotovchits|js};
    role = Some `Chair;
    affiliation = Some {js|CMU, USA|js};
  };
  
  { name = {js|Florian Angeletti|js};
    role = None;
    affiliation = Some {js|INRIA, France|js};
  };
  
  { name = {js|Chris Casinghino|js};
    role = None;
    affiliation = Some {js|Draper Laboratory, USA|js};
  };
  
  { name = {js|Catherine Gasnier|js};
    role = None;
    affiliation = Some {js|Facebook, USA|js};
  };
  
  { name = {js|Rudi Grinberg|js};
    role = None;
    affiliation = Some {js|OCaml Labs, UK|js};
  };
  
  { name = {js|Oleg Kiselyov|js};
    role = None;
    affiliation = Some {js|Tohoku University, Japan|js};
  };
  
  { name = {js|Andreas Rossberg|js};
    role = None;
    affiliation = Some {js|Dfinity Stiftung, Germany|js};
  };
  
  { name = {js|Marcello Seri|js};
    role = None;
    affiliation = Some {js|University of Groningen, Netherlands|js};
  };
  
  { name = {js|Edwin Torok|js};
    role = None;
    affiliation = Some {js|Citrix, UK|js};
  };
  
  { name = {js|Leo White|js};
    role = None;
    affiliation = Some {js|Jane Street, USA|js};
  };
  
  { name = {js|Greta Yorsh|js};
    role = None;
    affiliation = Some {js|Jane Street, USA|js};
  };
  
  { name = {js|Sarah Zennou|js};
    role = None;
    affiliation = Some {js|Airbus, France|js};
  }]
  ; organising_committee = 
 [
  { name = {js|Ivan Gotovchits|js};
    role = Some `Chair;
    affiliation = None;
  };
  
  { name = {js|Gemma Gordon|js};
    role = Some `Co_chair;
    affiliation = None;
  };
  
  { name = {js|Anil Madhavapeddy|js};
    role = Some `Co_chair;
    affiliation = None;
  };
  
  { name = {js|Frédéric Bour|js};
    role = None;
    affiliation = None;
  };
  
  { name = {js|Enzo Crance|js};
    role = None;
    affiliation = None;
  };
  
  { name = {js|Shon Feder|js};
    role = None;
    affiliation = None;
  };
  
  { name = {js|Sonja Heinze|js};
    role = None;
    affiliation = None;
  };
  
  { name = {js|Shakthi Kannan|js};
    role = None;
    affiliation = None;
  };
  
  { name = {js|Flynn Ludlam|js};
    role = None;
    affiliation = None;
  };
  
  { name = {js|Tim McGilchrist|js};
    role = None;
    affiliation = None;
  };
  
  { name = {js|Sebastien Mondet|js};
    role = None;
    affiliation = None;
  };
  
  { name = {js|Sudha Parimala|js};
    role = None;
    affiliation = None;
  };
  
  { name = {js|Tom Ridge|js};
    role = None;
    affiliation = None;
  };
  
  { name = {js|Marcello Seri|js};
    role = None;
    affiliation = None;
  };
  
  { name = {js|Daniel Tornabene|js};
    role = None;
    affiliation = None;
  };
  
  { name = {js|Shiwei Weng|js};
    role = None;
    affiliation = None;
  }]
  ; body_md = {js|
The OCaml Users and Developers Workshop brings together the OCaml
community, including users of OCaml in industry, academia, hobbyists,
and the free software community.

The meeting is an informal community gathering of users of the language,
library authors, and developers, using and extending OCaml in new ways.
The meeting will be held online this year.
## News

- July 17, 2020: Talks are accepted!
- May 7, 2020: Deadline Extension.
- March 30, 2020: [Workshop annoucement](https://icfp20.sigplan.org/home/ocaml-2020#Call-for-Presentations). The [submission website](https://ocaml2020.hotcrp.com/) is also open.
|js}
  ; toc_html = {js|<ul>
<li><ul>
<li>News
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<p>The OCaml Users and Developers Workshop brings together the OCaml
community, including users of OCaml in industry, academia, hobbyists,
and the free software community.</p>
<p>The meeting is an informal community gathering of users of the language,
library authors, and developers, using and extending OCaml in new ways.
The meeting will be held online this year.</p>
<h2>News</h2>
<ul>
<li>July 17, 2020: Talks are accepted!
</li>
<li>May 7, 2020: Deadline Extension.
</li>
<li>March 30, 2020: <a href="https://icfp20.sigplan.org/home/ocaml-2020#Call-for-Presentations">Workshop annoucement</a>. The <a href="https://ocaml2020.hotcrp.com/">submission website</a> is also open.
</li>
</ul>
|js}
  };
 
  { title = {js|OCaml Workshop 2021|js}
  ; slug = {js|ocaml-workshop-2021|js}
  ; location = None
  ; date = {js|2021-08-27|js}
  ; online = true
  ; important_dates = 
 [
  { date = {js|2021-05-20|js};
    info = {js|Abstract submission deadline|js};
  };
  
  { date = {js|2021-07-18|js};
    info = {js|Author notification|js};
  };
  
  { date = {js|2021-08-27|js};
    info = {js|OCaml Workshop|js};
  }]
  ; presentations = 
 []
  ; program_committee = [
  { name = {js|Frédéric Bour|js};
    role = Some `Chair;
    affiliation = None;
  };
                             
  { name = {js|Mehdi Bouaziz|js};
    role = None;
    affiliation = Some {js|Nomadic Labs, France|js};
  };
                             
  { name = {js|Simon Castellan|js};
    role = None;
    affiliation = Some {js|INRIA, France|js};
  };
                             
  { name = {js|Youyou Cong|js};
    role = None;
    affiliation = Some {js|Tokyo Institute of Technology, Japan|js};
  };
                             
  { name = {js|Kate Deplaix|js};
    role = None;
    affiliation = Some {js|OCaml Labs, UK|js};
  };
                             
  { name = {js|Jun Furuse|js};
    role = None;
    affiliation = Some {js|DaiLambda, Japan|js};
  };
                             
  { name = {js|Joris Giovannangeli|js};
    role = None;
    affiliation = Some {js|Ahrefs Research|js};
  };
                             
  { name = {js|Kihong Heo|js};
    role = None;
    affiliation = Some {js|KAIST, South Korea|js};
  };
                             
  { name = {js|Hugo Heuzard|js};
    role = None;
    affiliation = Some {js|Jane Street|js};
  };
                             
  { name = {js|Vaivaswatha Nagaraj|js};
    role = None;
    affiliation = Some {js|Zilliqa Research, India|js};
  };
                             
  { name = {js|Hakjoo Oh|js};
    role = None;
    affiliation = Some {js|Korea University|js};
  };
                             
  { name = {js|Jonathan Protzenko|js};
    role = None;
    affiliation = Some {js|Microsoft Research Redmond, USA|js};
  };
                             
  { name = {js|Cristina Rosu|js};
    role = None;
    affiliation = Some {js|Jane Street|js};
  };
                             
  { name = {js|Jeffrey A. Scofield|js};
    role = None;
    affiliation = Some {js|Psellos|js};
  };
                             
  { name = {js|Ryohei Tokuda|js};
    role = None;
    affiliation = Some {js|Idein|js};
  }]
  ; organising_committee = 
 [
  { name = {js|Frédéric Bour|js};
    role = Some `Chair;
    affiliation = Some {js|Tarides, France|js};
  }]
  ; body_md = {js|
OCaml 2021 will be a virtual workshop, co-located with ICFP 2021.

Please contact the PC Chair (Frédéric Bour) for any questions.|js}
  ; toc_html = {js||js}
  ; body_html = {js|<p>OCaml 2021 will be a virtual workshop, co-located with ICFP 2021.</p>
<p>Please contact the PC Chair (Frédéric Bour) for any questions.</p>
|js}
  }]

