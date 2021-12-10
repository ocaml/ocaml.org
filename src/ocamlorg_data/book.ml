
type link = { description : string; uri : string }

type t = 
  { title : string
  ; slug : string
  ; description : string
  ; authors : string list
  ; language : string
  ; published : string option
  ; cover : string option
  ; isbn : string option
  ; links : link list
  ; rating : int option
  ; featured : bool
  ; body_md : string
  ; body_html : string
  }

let all = 
[
  { title = {js|Algorithmen, Datenstrukturen, Funktionale Programmierung: Eine praktische Einführung mit Caml Light|js}
  ; slug = {js|algorithmen-datenstrukturen-funktionale-programmierung-eine-praktische-einfhrung-mit-caml-light|js}
  ; description = {js|In the first part of this book, algorithms are described in a concise and precise manner using Caml Light. The second part provides a tutorial introduction into the language Caml Light and in its last chapter a comprehensive description of the language kernel.
|js}
  ; authors = 
 [{js|Juergen Wolff von Gudenberg|js}]
  ; language = {js|german|js}
  ; published = Some {js|1996|js}
  ; cover = Some {js|/books/wolff.gif|js}
  ; isbn = None
  ; links = 
 []
  ; rating = None
  ; featured = false
  ; body_md = {js|This book gives an introduction to programming where algorithms as well
as data structures are considered functionally. It is intended as an
accompanying book for basic courses in computer science, but it is also
suitable for self-studies. In the first part, algorithms are described
in a concise and precise manner using Caml Light. The second part
provides a tutorial introduction into the language Caml Light and in its
last chapter a comprehensive description of the language kernel.|js}
  ; body_html = {js|<p>This book gives an introduction to programming where algorithms as well
as data structures are considered functionally. It is intended as an
accompanying book for basic courses in computer science, but it is also
suitable for self-studies. In the first part, algorithms are described
in a concise and precise manner using Caml Light. The second part
provides a tutorial introduction into the language Caml Light and in its
last chapter a comprehensive description of the language kernel.</p>
|js}
  };
 
  { title = {js|Apprendre à programmer avec OCaml|js}
  ; slug = {js|apprendre--programmer-avec-ocaml|js}
  ; description = {js|This book is organized into three parts. The first one introduces OCaml and targets beginners, being they programming beginners or simply new to OCaml. Through small programs, the reader is introduced to fundamental concepts of programming and of OCaml. The second and third parts are dedicated to fundamental concepts of algorithmics and should allow the reader to write programs in a structured and efficient way.
|js}
  ; authors = 
 [{js|Jean-Christophe Filliâtre|js}; {js|Sylvain Conchon|js}]
  ; language = {js|french|js}
  ; published = Some {js|2014|js}
  ; cover = Some {js|/books/apprendre_ocaml_cover.png|js}
  ; isbn = Some {js|2-21213-678-1|js}
  ; links = 
 [
      { description = {js|Buy on Amazon.fr|js}
      ; uri = {js|https://www.amazon.fr/Apprendre-programmer-avec-Ocaml-Algorithmes/dp/2212136781/|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js|Computer programming is hard to learn. Being a skillful programmer
requires imagination, anticipation, knowledge in algorithmics, the
mastery of a programming language, and above all experience, as
difficulties are often hidden in details.  This book synthesizes our
experience as teachers and programmers.

The programming style is essential. Given a programming language, the
same algorithm can be written in multiple ways, and some of them can
be both elegant and efficient. This is what the programmer must seek
at all costs and the reason why we choose a programming language for
this book rather than pseudo-code. Our choice is OCaml.

This book is organized into three parts. The first one introduces
OCaml and targets beginners, being they programming beginners or
simply new to OCaml. Through small programs, the reader is introduced
to fundamental concepts of programming and of OCaml. The second and
third parts are dedicated to fundamental concepts of algorithmics and
should allow the reader to write programs in a structured and
efficient way. Algorithmic concepts are directly presented in the
syntax of OCaml and any code snippet from the book is available
online.|js}
  ; body_html = {js|<p>Computer programming is hard to learn. Being a skillful programmer
requires imagination, anticipation, knowledge in algorithmics, the
mastery of a programming language, and above all experience, as
difficulties are often hidden in details.  This book synthesizes our
experience as teachers and programmers.</p>
<p>The programming style is essential. Given a programming language, the
same algorithm can be written in multiple ways, and some of them can
be both elegant and efficient. This is what the programmer must seek
at all costs and the reason why we choose a programming language for
this book rather than pseudo-code. Our choice is OCaml.</p>
<p>This book is organized into three parts. The first one introduces
OCaml and targets beginners, being they programming beginners or
simply new to OCaml. Through small programs, the reader is introduced
to fundamental concepts of programming and of OCaml. The second and
third parts are dedicated to fundamental concepts of algorithmics and
should allow the reader to write programs in a structured and
efficient way. Algorithmic concepts are directly presented in the
syntax of OCaml and any code snippet from the book is available
online.</p>
|js}
  };
 
  { title = {js|Apprentissage de la programmation avec OCaml|js}
  ; slug = {js|apprentissage-de-la-programmation-avec-ocaml|js}
  ; description = {js|This book is targeted towards beginner programmers and provides teaching material for all programmers wishing to learn the functional programming style. The programming features introduced in this book are available in all dialects of the ML language, notably Caml-Light, OCaml and Standard ML.
|js}
  ; authors = 
 [{js|Catherine Dubois|js}; {js|Valérie Ménissier Morain|js}]
  ; language = {js|french|js}
  ; published = Some {js|2004|js}
  ; cover = Some {js|/books/dubois-menissier.gif|js}
  ; isbn = Some {js|2-7462-0819-9|js}
  ; links = 
 []
  ; rating = None
  ; featured = false
  ; body_md = {js|Programming is a discipline by which the strengths of computers can be
harnessed: large amounts of reliable memory, the ability to execute
repetitive tasks relentlessly, and a high computation speed. In order to
write correct programs that fulfill their specified needs, it is
necessary to understand the precise semantics of the programming
language. This book is targeted towards beginner programmers and
provides teaching material for all programmers wishing to learn the
functional programming style. The programming features introduced in
this book are available in all dialects of the ML language, notably
Caml-Light, OCaml and Standard ML. The concepts presented therein and
illustrated in OCaml easily transpose to other programming languages.|js}
  ; body_html = {js|<p>Programming is a discipline by which the strengths of computers can be
harnessed: large amounts of reliable memory, the ability to execute
repetitive tasks relentlessly, and a high computation speed. In order to
write correct programs that fulfill their specified needs, it is
necessary to understand the precise semantics of the programming
language. This book is targeted towards beginner programmers and
provides teaching material for all programmers wishing to learn the
functional programming style. The programming features introduced in
this book are available in all dialects of the ML language, notably
Caml-Light, OCaml and Standard ML. The concepts presented therein and
illustrated in OCaml easily transpose to other programming languages.</p>
|js}
  };
 
  { title = {js|Approche Fonctionnelle de la Programmation|js}
  ; slug = {js|approche-fonctionnelle-de-la-programmation|js}
  ; description = {js|This book uses OCaml as a tool to introduce several important programming concepts.|js}
  ; authors = 
 [{js|Guy Cousineau|js}; {js|Michel Mauny|js}]
  ; language = {js|french|js}
  ; published = Some {js|1995|js}
  ; cover = Some {js|/books/cousineau-mauny-fr.gif|js}
  ; isbn = Some {js|2-84074-114-8|js}
  ; links = 
 [
      { description = {js|Book Website|js}
      ; uri = {js|https://pauillac.inria.fr/cousineau-mauny/main-fr.html|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js|This book uses OCaml as a tool to introduce several important
programming concepts. It is divided in three parts. The first part is an
introduction to OCaml, which presents the language itself, but also
introduces evaluation by rewriting, evaluation strategies and proofs of
programs by induction. The second part is dedicated to the description
of application programs which belong to various fields and might
interest various types of readers or students. Finally, the third part
is dedicated to implementation. It describes interpretation then
compilation, with brief descriptions of memory management and type
synthesis.|js}
  ; body_html = {js|<p>This book uses OCaml as a tool to introduce several important
programming concepts. It is divided in three parts. The first part is an
introduction to OCaml, which presents the language itself, but also
introduces evaluation by rewriting, evaluation strategies and proofs of
programs by induction. The second part is dedicated to the description
of application programs which belong to various fields and might
interest various types of readers or students. Finally, the third part
is dedicated to implementation. It describes interpretation then
compilation, with brief descriptions of memory management and type
synthesis.</p>
|js}
  };
 
  { title = {js|Concepts et outils de programmation|js}
  ; slug = {js|concepts-et-outils-de-programmation|js}
  ; description = {js|The book begins with a functional approach, based on OCaml, and continues with a presentation of an imperative language, namely Ada. It also provides numerous exercises with solutions.
|js}
  ; authors = 
 [{js|Thérèse Accart Hardin|js}; {js|Véronique Donzeau-Gouge Viguié|js}]
  ; language = {js|french|js}
  ; published = Some {js|1992|js}
  ; cover = Some {js|/books/hardin-donzeau-gouge.gif|js}
  ; isbn = Some {js|2-7296-0419-7|js}
  ; links = 
 [
      { description = {js|Order at Amazon.fr|js}
      ; uri = {js|https://www.amazon.fr/exec/obidos/ASIN/2729604197|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js|This book presents a new approach to teaching programming concepts to
beginners, based on language semantics. A simplified semantic model is
used to describe in a precise manner the features found in most
programming languages. This model is powerful enough to explain
typechecking, polymorphism, evaluation, side-effects, modularity,
exceptions. Yet, it is simple enough to be manipulated by hand, so that
students can actually use it to compute. The book begins with a
functional approach, based on OCaml, and continues with a presentation
of an imperative language, namely Ada. It also provides numerous
exercises with solutions.|js}
  ; body_html = {js|<p>This book presents a new approach to teaching programming concepts to
beginners, based on language semantics. A simplified semantic model is
used to describe in a precise manner the features found in most
programming languages. This model is powerful enough to explain
typechecking, polymorphism, evaluation, side-effects, modularity,
exceptions. Yet, it is simple enough to be manipulated by hand, so that
students can actually use it to compute. The book begins with a
functional approach, based on OCaml, and continues with a presentation
of an imperative language, namely Ada. It also provides numerous
exercises with solutions.</p>
|js}
  };
 
  { title = {js|Cours et exercices d'informatique|js}
  ; slug = {js|cours-et-exercices-dinformatique|js}
  ; description = {js|This book was written by teachers at university and in “classes préparatoires”. It is intended for “classes préparatoires” students who study computer science and for students engaged in a computer science cursus up to the masters level. It includes a tutorial of the OCaml language, a course on algorithms, data structures, automata theory, and formal logic, as well as 135 exercises with solutions.
|js}
  ; authors = 
 [{js|Luc Albert|js}]
  ; language = {js|french|js}
  ; published = Some {js|1997|js}
  ; cover = Some {js|/books/albert.gif|js}
  ; isbn = Some {js|2-84180-106-3|js}
  ; links = 
 []
  ; rating = None
  ; featured = false
  ; body_md = {js|This book was written by teachers at university and in “classes
préparatoires”. It is intended for “classes préparatoires” students who
study computer science and for students engaged in a computer science
cursus up to the masters level. It includes a tutorial of the OCaml
language, a course on algorithms, data structures, automata theory, and
formal logic, as well as 135 exercises with solutions.|js}
  ; body_html = {js|<p>This book was written by teachers at university and in “classes
préparatoires”. It is intended for “classes préparatoires” students who
study computer science and for students engaged in a computer science
cursus up to the masters level. It includes a tutorial of the OCaml
language, a course on algorithms, data structures, automata theory, and
formal logic, as well as 135 exercises with solutions.</p>
|js}
  };
 
  { title = {js|Developing Applications with OCaml|js}
  ; slug = {js|developing-applications-with-ocaml|js}
  ; description = {js|A comprehensive (742 page) guide to developing application in the OCaml programming language
|js}
  ; authors = 
 [{js|Emmanuel Chailloux|js}; {js|Pascal Manoury|js}; {js|Bruno Pagano|js}]
  ; language = {js|english|js}
  ; published = Some {js|2002|js}
  ; cover = Some {js|/books/logocaml-oreilly.gif|js}
  ; isbn = None
  ; links = 
 [
      { description = {js|Book Website|js}
      ; uri = {js|https://caml.inria.fr/pub/docs/oreilly-book/index.html|js}
      };
  
      { description = {js|Online|js}
      ; uri = {js|https://caml.inria.fr/pub/docs/oreilly-book/html/index.html|js}
      };
  
      { description = {js|PDF|js}
      ; uri = {js|https://caml.inria.fr/pub/docs/oreilly-book/ocaml-ora-book.pdf|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js|A comprehensive (742 pages) book on OCaml, covering not only the core
language, but also modules, objects and classes, threads and systems
programming, interoperability with C, and runtime tools. This book is a
translation of a French book published by OReilly.|js}
  ; body_html = {js|<p>A comprehensive (742 pages) book on OCaml, covering not only the core
language, but also modules, objects and classes, threads and systems
programming, interoperability with C, and runtime tools. This book is a
translation of a French book published by OReilly.</p>
|js}
  };
 
  { title = {js|Développement d'applications avec Objective Caml|js}
  ; slug = {js|dveloppement-dapplications-avec-objective-caml|js}
  ; description = {js|"Objective CAML est un langage de programmation : un de plus dira-t-on ! Ils sont en effet déjà nombreux et pourtant il en apparaît constamment de nouveaux. Au delà de leurs disparités, la conception et la genèse de chacun d'eux procèdent d'une motivation partagée : la volonté d'abstraire"
|js}
  ; authors = 
 [{js|Emmanuel Chailloux|js}; {js|Pascal Manoury|js}; {js|Bruno Pagano|js}]
  ; language = {js|french|js}
  ; published = Some {js|2000|js}
  ; cover = Some {js|/books/chailloux-manoury-pagano.jpg|js}
  ; isbn = Some {js|2-84177-121-0|js}
  ; links = 
 [
      { description = {js|Online|js}
      ; uri = {js|https://www.pps.jussieu.fr/Livres/ora/DA-OCAML/index.html|js}
      };
  
      { description = {js|Order at Amazon.fr|js}
      ; uri = {js|https://www.amazon.fr/exec/obidos/ASIN/2841771210|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js|A comprehensive (742 pages) book on OCaml, covering not only the core
language, but also modules, objects and classes, threads and systems
programming, and interoperability with C.

"Objective CAML est un langage de programmation : un de plus dira-t-on ! Ils sont en effet déjà nombreux et pourtant il en apparaît constamment de nouveaux. Au delà de leurs disparités, la conception et la genèse de chacun d'eux procèdent d'une motivation partagée : la volonté d'abstraire"|js}
  ; body_html = {js|<p>A comprehensive (742 pages) book on OCaml, covering not only the core
language, but also modules, objects and classes, threads and systems
programming, and interoperability with C.</p>
<p>&quot;Objective CAML est un langage de programmation : un de plus dira-t-on ! Ils sont en effet déjà nombreux et pourtant il en apparaît constamment de nouveaux. Au delà de leurs disparités, la conception et la genèse de chacun d'eux procèdent d'une motivation partagée : la volonté d'abstraire&quot;</p>
|js}
  };
 
  { title = {js|Initiation à la programmation fonctionnelle en OCaml|js}
  ; slug = {js|initiation--la-programmation-fonctionnelle-en-ocaml|js}
  ; description = {js|Le but de ce livre est d’initier le lecteur au style fonctionnel de programmation en utilisant le langage OCaml.
|js}
  ; authors = 
 [{js|Mohammed-Said Habet|js}]
  ; language = {js|french|js}
  ; published = Some {js|2015|js}
  ; cover = Some {js|/books/Initiation_a_la_programmation_fonctionnelle_en_OCaml.jpg|js}
  ; isbn = Some {js|9782332978400|js}
  ; links = 
 [
      { description = {js|Website|js}
      ; uri = {js|https://www.edilivre.com/initiation-a-la-programmation-fonctionnelle-en-ocaml-mohammed-said-habet.html|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js|La programmation fonctionnelle est un style de programmation qui
consiste à considérer les programmes informatiques comme des fonctions
au sens mathématique du terme. Ce style est proposé dans de nombreux
langages de programmation anciens et récents comme OCaml.

Le but de ce livre est d’initier le lecteur au style fonctionnel de
programmation en utilisant le langage OCaml. Cet ouvrage s’adresse
donc principalement aux débutants en informatique. Il peut également
être l’occasion pour les initiés de découvrir le langage de
programmation OCaml.

Le lecteur trouvera une présentation progressive des concepts de
programmation fonctionnelle dans le langage OCaml, illustrée par des
exemples, de nombreux exercices corrigés et d’autres laissés à
l’initiative du lecteur.|js}
  ; body_html = {js|<p>La programmation fonctionnelle est un style de programmation qui
consiste à considérer les programmes informatiques comme des fonctions
au sens mathématique du terme. Ce style est proposé dans de nombreux
langages de programmation anciens et récents comme OCaml.</p>
<p>Le but de ce livre est d’initier le lecteur au style fonctionnel de
programmation en utilisant le langage OCaml. Cet ouvrage s’adresse
donc principalement aux débutants en informatique. Il peut également
être l’occasion pour les initiés de découvrir le langage de
programmation OCaml.</p>
<p>Le lecteur trouvera une présentation progressive des concepts de
programmation fonctionnelle dans le langage OCaml, illustrée par des
exemples, de nombreux exercices corrigés et d’autres laissés à
l’initiative du lecteur.</p>
|js}
  };
 
  { title = {js|Introduction to OCaml|js}
  ; slug = {js|introduction-to-ocaml|js}
  ; description = {js|This book is an introduction to ML programming, specifically for the OCaml programming language from INRIA. OCaml is a dialect of the ML family of languages, which derive from the Classic ML language designed by Robin Milner in 1975 for the LCF (Logic of Computable Functions) theorem prover.
|js}
  ; authors = 
 [{js|Jason Hickey|js}]
  ; language = {js|english|js}
  ; published = Some {js|2008|js}
  ; cover = None
  ; isbn = None
  ; links = 
 [
      { description = {js|PDF|js}
      ; uri = {js|https://courses.cms.caltech.edu/cs134/cs134b/book.pdf|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js|This book is notoriously much more than just an introduction to OCaml,
it describes most of the language, and is accessible.

Abstract: *This book is an introduction to ML programming, specifically for the OCaml programming language from INRIA. OCaml is a dialect of the ML family of languages, which derive from the Classic ML language designed by Robin Milner in 1975 for the LCF (Logic of Computable Functions) theorem prover.*

[PDF](https://courses.cms.caltech.edu/cs134/cs134b/book.pdf)|js}
  ; body_html = {js|<p>This book is notoriously much more than just an introduction to OCaml,
it describes most of the language, and is accessible.</p>
<p>Abstract: <em>This book is an introduction to ML programming, specifically for the OCaml programming language from INRIA. OCaml is a dialect of the ML family of languages, which derive from the Classic ML language designed by Robin Milner in 1975 for the LCF (Logic of Computable Functions) theorem prover.</em></p>
<p><a href="https://courses.cms.caltech.edu/cs134/cs134b/book.pdf">PDF</a></p>
|js}
  };
 
  { title = {js|Introduzione alla programmazione funzionale|js}
  ; slug = {js|introduzione-alla-programmazione-funzionale|js}
  ; description = {js|Functional programming introduction with OCaml
|js}
  ; authors = 
 [{js|Carla Limongelli|js}; {js|Marta Cialdea|js}]
  ; language = {js|italian|js}
  ; published = Some {js|2002|js}
  ; cover = Some {js|/books/limongelli-cialdea.gif|js}
  ; isbn = Some {js|88-7488-031-6|js}
  ; links = 
 []
  ; rating = None
  ; featured = false
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { title = {js|Le Langage Caml|js}
  ; slug = {js|le-langage-caml|js}
  ; description = {js|This book is a comprehensive introduction to programming in OCaml. Usable as a programming course, it introduces progressively the language features and shows them at work on the fundamental programming problems. In addition to many introductory code samples, this book details the design and implementation of six complete, realistic programs in reputedly difficult application areas: compilation, type inference, automata, etc.
|js}
  ; authors = 
 [{js|Xavier Leroy|js}; {js|Pierre Weis|js}]
  ; language = {js|french|js}
  ; published = Some {js|1993|js}
  ; cover = Some {js|/books/le-language-caml-cover.jpg|js}
  ; isbn = Some {js|2-10-004383-8|js}
  ; links = 
 [
      { description = {js|PDF|js}
      ; uri = {js|https://caml.inria.fr/pub/distrib/books/llc.pdf|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js|This book is a comprehensive introduction to programming in OCaml.
Usable as a programming course, it introduces progressively the language
features and shows them at work on the fundamental programming problems.
In addition to many introductory code samples, this book details the
design and implementation of six complete, realistic programs in
reputedly difficult application areas: compilation, type inference,
automata, etc.|js}
  ; body_html = {js|<p>This book is a comprehensive introduction to programming in OCaml.
Usable as a programming course, it introduces progressively the language
features and shows them at work on the fundamental programming problems.
In addition to many introductory code samples, this book details the
design and implementation of six complete, realistic programs in
reputedly difficult application areas: compilation, type inference,
automata, etc.</p>
|js}
  };
 
  { title = {js|Manuel de référence du langage Caml|js}
  ; slug = {js|manuel-de-rfrence-du-langage-caml|js}
  ; description = {js|"Cet ouvrage contient le manuel de référence du langage Caml et la documentation complète du système Caml Light, un environnement de programmation en Caml distribuée gratuitement. Il s’adresse á des programmeurs Caml expérimentés, et non pas aux d'ébutants. Il vient en complément du livre Le langage Caml, des mêmes auteurs chez le même éditeur, qui fournit une introduction progressive au langage Caml et á l’écriture de programmes dans ce langage."
|js}
  ; authors = 
 [{js|Xavier Leroy|js}; {js|Pierre Weis|js}]
  ; language = {js|french|js}
  ; published = Some {js|1993|js}
  ; cover = Some {js|/books/manuel-de-reference-du-langage-caml-cover.jpg|js}
  ; isbn = Some {js|2-7296-0492-8|js}
  ; links = 
 [
      { description = {js|PDF|js}
      ; uri = {js|https://caml.inria.fr/pub/distrib/books/manuel-cl.pdf|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js|Written by two of the implementors of the Caml Light compiler, this
comprehensive book describes all constructs of the programming language
and provides a complete documentation for the Caml Light system.

Intro:  "Cet ouvrage contient le manuel de référence du langage Caml et la documentation complète du système Caml Light, un environnement de programmation en Caml distribuée gratuitement. Il s’adresse á des programmeurs Caml expérimentés, et non pas aux d'ébutants. Il vient en complément du livre Le langage Caml, des mêmes auteurs chez le même éditeur, qui fournit une introduction progressive au langage Caml et á l’écriture de programmes dans ce langage."|js}
  ; body_html = {js|<p>Written by two of the implementors of the Caml Light compiler, this
comprehensive book describes all constructs of the programming language
and provides a complete documentation for the Caml Light system.</p>
<p>Intro:  &quot;Cet ouvrage contient le manuel de référence du langage Caml et la documentation complète du système Caml Light, un environnement de programmation en Caml distribuée gratuitement. Il s’adresse á des programmeurs Caml expérimentés, et non pas aux d'ébutants. Il vient en complément du livre Le langage Caml, des mêmes auteurs chez le même éditeur, qui fournit une introduction progressive au langage Caml et á l’écriture de programmes dans ce langage.&quot;</p>
|js}
  };
 
  { title = {js|More OCaml: Algorithms, Methods & Diversions|js}
  ; slug = {js|more-ocaml-algorithms-methods--diversions|js}
  ; description = {js|In "More OCaml" John Whitington takes a meandering tour of functional programming with OCaml, introducing various language features and describing some classic algorithms.
|js}
  ; authors = 
 [{js|John Whitington|js}]
  ; language = {js|english|js}
  ; published = Some {js|2014-08-26|js}
  ; cover = Some {js|/books/more-ocaml-300-376.png|js}
  ; isbn = None
  ; links = 
 [
      { description = {js|Buy on Amazon|js}
      ; uri = {js|https://www.amazon.com/gp/product/0957671113|js}
      }]
  ; rating = Some 5
  ; featured = true
  ; body_md = {js|In "More OCaml" John Whitington takes a meandering tour of functional
programming with OCaml, introducing various language features and describing
some classic algorithms. The book ends with a large worked example dealing with
the production of PDF files. There are questions for each chapter together with
worked answers and hints.

"More OCaml" will appeal both to existing OCaml programmers who wish to brush up
their skills, and to experienced programmers eager to explore functional
languages such as OCaml. It is hoped that each reader will find something new,
or see an old thing in a new light. For the more casual reader, or those who are
used to a different functional language, a summary of basic OCaml is provided at
the front of the book.|js}
  ; body_html = {js|<p>In &quot;More OCaml&quot; John Whitington takes a meandering tour of functional
programming with OCaml, introducing various language features and describing
some classic algorithms. The book ends with a large worked example dealing with
the production of PDF files. There are questions for each chapter together with
worked answers and hints.</p>
<p>&quot;More OCaml&quot; will appeal both to existing OCaml programmers who wish to brush up
their skills, and to experienced programmers eager to explore functional
languages such as OCaml. It is hoped that each reader will find something new,
or see an old thing in a new light. For the more casual reader, or those who are
used to a different functional language, a summary of basic OCaml is provided at
the front of the book.</p>
|js}
  };
 
  { title = {js|Nouveaux exercices d'algorithmique|js}
  ; slug = {js|nouveaux-exercices-dalgorithmique|js}
  ; description = {js|This book presents 103 exercises and 5 problems about algorithms, for masters students. It attempts to address both practical and theoretical questions. Programs are written in OCaml and expressed in a purely functional style.
|js}
  ; authors = 
 [{js|Michel Quercia|js}]
  ; language = {js|french|js}
  ; published = Some {js|2000|js}
  ; cover = Some {js|/books/quercia.gif|js}
  ; isbn = Some {js|2-7117-8990|js}
  ; links = 
 [
      { description = {js|Order at Amazon.fr|js}
      ; uri = {js|https://www.amazon.fr/exec/obidos/ASIN/3540673873|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js|This book presents 103 exercises and 5 problems about algorithms, for
masters students. It attempts to address both practical and theoretical
questions. Programs are written in OCaml and expressed in a purely
functional style. Problem areas include programming methodology, lists,
formula evaluation, Boolean logic, algorithmic complexity, trees,
languages, and automata.|js}
  ; body_html = {js|<p>This book presents 103 exercises and 5 problems about algorithms, for
masters students. It attempts to address both practical and theoretical
questions. Programs are written in OCaml and expressed in a purely
functional style. Problem areas include programming methodology, lists,
formula evaluation, Boolean logic, algorithmic complexity, trees,
languages, and automata.</p>
|js}
  };
 
  { title = {js|OCaml Book|js}
  ; slug = {js|ocaml-book|js}
  ; description = {js|Introductory programming textbook based on the OCaml language
|js}
  ; authors = 
 [{js|Hongbo Zhang|js}]
  ; language = {js|english|js}
  ; published = Some {js|2011|js}
  ; cover = None
  ; isbn = None
  ; links = 
 [
      { description = {js|GitHub|js}
      ; uri = {js|https://github.com/bobzhang/ocaml-book|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js|This book is a work in progress. It currently includes sections on the
core OCaml language, Camlp4, parsing, various libraries, the OCaml
runtime, interoperating with C, and pearls.|js}
  ; body_html = {js|<p>This book is a work in progress. It currently includes sections on the
core OCaml language, Camlp4, parsing, various libraries, the OCaml
runtime, interoperating with C, and pearls.</p>
|js}
  };
 
  { title = {js|OCaml for Scientists|js}
  ; slug = {js|ocaml-for-scientists|js}
  ; description = {js|This book teaches OCaml programming with special emphasis on scientific applications.
|js}
  ; authors = 
 [{js|Jon D. Harrop|js}]
  ; language = {js|english|js}
  ; published = Some {js|2005|js}
  ; cover = Some {js|/books/harrop-book.gif|js}
  ; isbn = None
  ; links = 
 [
      { description = {js|Book Website|js}
      ; uri = {js|https://www.ffconsultancy.com/products/ocaml_for_scientists/index.html|js}
      };
  
      { description = {js|Ordering Information|js}
      ; uri = {js|https://www.ffconsultancy.com/products/ocaml_for_scientists/index.html|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js|This book teaches OCaml programming with special emphasis on scientific
applications. Many examples are given, covering everything from simple
numerical analysis to sophisticated real-time 3D visualisation using
OpenGL. This book contains over 800 color syntax-highlighted source code
examples and dozens of diagrams that elucidate the power of functional
programming to explain how lightning-fast and yet remarkably-simple
programs can be constructed in the OCaml programming language.|js}
  ; body_html = {js|<p>This book teaches OCaml programming with special emphasis on scientific
applications. Many examples are given, covering everything from simple
numerical analysis to sophisticated real-time 3D visualisation using
OpenGL. This book contains over 800 color syntax-highlighted source code
examples and dozens of diagrams that elucidate the power of functional
programming to explain how lightning-fast and yet remarkably-simple
programs can be constructed in the OCaml programming language.</p>
|js}
  };
 
  { title = {js|OCaml from the very Beginning|js}
  ; slug = {js|ocaml-from-the-very-beginning|js}
  ; description = {js|In "OCaml from the Very Beginning" John Whitington takes a no-prerequisites approach to teaching a modern general-purpose programming language.
|js}
  ; authors = 
 [{js|John Whitington|js}]
  ; language = {js|english|js}
  ; published = Some {js|2013-06-07|js}
  ; cover = Some {js|/books/OCaml_from_beginning.png|js}
  ; isbn = None
  ; links = 
 [
      { description = {js|Buy on Amazon|js}
      ; uri = {js|https://www.amazon.com/gp/product/0957671105|js}
      }]
  ; rating = Some 4
  ; featured = true
  ; body_md = {js|In "OCaml from the Very Beginning" John Whitington takes a
no-prerequisites approach to teaching a modern general-purpose
programming language. Each small, self-contained chapter introduces a
new topic, building until the reader can write quite substantial
programs. There are plenty of questions and, crucially, worked answers
and hints.

"OCaml from the Very Beginning" will appeal both to new programmers, and experienced programmers eager to explore functional languages such as OCaml. It is suitable both for formal use within an undergraduate or graduate curriculum, and for the interested amateur.|js}
  ; body_html = {js|<p>In &quot;OCaml from the Very Beginning&quot; John Whitington takes a
no-prerequisites approach to teaching a modern general-purpose
programming language. Each small, self-contained chapter introduces a
new topic, building until the reader can write quite substantial
programs. There are plenty of questions and, crucially, worked answers
and hints.</p>
<p>&quot;OCaml from the Very Beginning&quot; will appeal both to new programmers, and experienced programmers eager to explore functional languages such as OCaml. It is suitable both for formal use within an undergraduate or graduate curriculum, and for the interested amateur.</p>
|js}
  };
 
  { title = {js|OCaml: Programação Funcional na Prática|js}
  ; slug = {js|ocaml-programao-funcional-na-prtica|js}
  ; description = {js|This book is an introduction to functional programming through OCaml, with a pragmatic focus. The goal is to enable the reader to write real programs in OCaml and understand most of the open source code written in the language.
|js}
  ; authors = 
 [{js|Andrei de Araújo Formiga|js}]
  ; language = {js|portugese|js}
  ; published = Some {js|2015|js}
  ; cover = Some {js|/books/opfp.png|js}
  ; isbn = None
  ; links = 
 [
      { description = {js|Book site|js}
      ; uri = {js|https://andreiformiga.com/livro/ocaml/|js}
      };
  
      { description = {js|Order online from Casa do Código|js}
      ; uri = {js|https://www.casadocodigo.com.br/products/livro-ocaml|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js|This book is an introduction to functional programming through OCaml, with a pragmatic
focus. The goal is to enable the reader to write real programs in OCaml and understand
most of the open source code written in the language. It includes many code examples
illustrating the topics and a few larger projects written in OCaml that showcase the
integration of many language features. These larger
programs include a set of interpreter, compiler and stack machine for a simple
language, and a decision tree learning program for data analysis.|js}
  ; body_html = {js|<p>This book is an introduction to functional programming through OCaml, with a pragmatic
focus. The goal is to enable the reader to write real programs in OCaml and understand
most of the open source code written in the language. It includes many code examples
illustrating the topics and a few larger projects written in OCaml that showcase the
integration of many language features. These larger
programs include a set of interpreter, compiler and stack machine for a simple
language, and a decision tree learning program for data analysis.</p>
|js}
  };
 
  { title = {js|The OCaml System: Documentation and User's Manual|js}
  ; slug = {js|the-ocaml-system-documentation-and-users-manual|js}
  ; description = {js|The official User's Manual for OCaml serving as a complete reference guide|js}
  ; authors = 
 [{js|Damien Doligez|js}; {js|Alain Frisch|js}; {js|Jacques Garrigue|js};
  {js|Didier Rémy|js}; {js|Jérôme Vouillon|js}]
  ; language = {js|english|js}
  ; published = None
  ; cover = Some {js|/books/colour-icon-170x148.png|js}
  ; isbn = None
  ; links = 
 [
      { description = {js|Online|js}
      ; uri = {js|https://ocaml.org/releases/latest/manual.html|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js|This the official User's Manual. It serves as a complete reference guide
to OCaml. Updated for each version of OCaml, it contains the description
of the language, of its extensions, and the documentation of the tools
and libraries included in the official distribution.|js}
  ; body_html = {js|<p>This the official User's Manual. It serves as a complete reference guide
to OCaml. Updated for each version of OCaml, it contains the description
of the language, of its extensions, and the documentation of the tools
and libraries included in the official distribution.</p>
|js}
  };
 
  { title = {js|Option Informatique MP/MP|js}
  ; slug = {js|option-informatique-mpmp|js}
  ; description = {js|This books is a follow-up to the previous one and is intended for second year students in “classes préparatoires”. It deals with trees, algebraic expressions, automata and languages, and OCaml streams. The book contains more than 200 OCaml programs.
|js}
  ; authors = 
 [{js|Denis Monasse|js}]
  ; language = {js|french|js}
  ; published = Some {js|1997|js}
  ; cover = Some {js|/books/monasse-2.jpg|js}
  ; isbn = Some {js|2-7117-8839-3|js}
  ; links = 
 [
      { description = {js|Order at Amazon.fr|js}
      ; uri = {js|https://www.amazon.fr/exec/obidos/ASIN/2711788393|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js|This books is a follow-up to the previous one and is intended for second
year students in “classes préparatoires”. It deals with trees, algebraic
expressions, automata and languages, and OCaml streams. The book
contains more than 200 OCaml programs.|js}
  ; body_html = {js|<p>This books is a follow-up to the previous one and is intended for second
year students in “classes préparatoires”. It deals with trees, algebraic
expressions, automata and languages, and OCaml streams. The book
contains more than 200 OCaml programs.</p>
|js}
  };
 
  { title = {js|Option Informatique MPSI|js}
  ; slug = {js|option-informatique-mpsi|js}
  ; description = {js|This is a computer science course for the first year of “classes préparatoires”. The course begins with an introductory lesson on algorithms and a description of the OCaml language.
|js}
  ; authors = 
 [{js|Denis Monasse|js}]
  ; language = {js|french|js}
  ; published = Some {js|1996|js}
  ; cover = Some {js|/books/monasse-1.gif|js}
  ; isbn = Some {js|2-7117-8831-8|js}
  ; links = 
 []
  ; rating = None
  ; featured = false
  ; body_md = {js|This is a computer science course for the first year of “classes
préparatoires”. The course begins with an introductory lesson on
algorithms and a description of the OCaml language. Then, several
fundamental algorithms are described and illustrated using OCaml
programs. The book adopts a mathematical approach: descriptions of
mathematical objects are related to data structures in the programming
language. This book is suitable for students with some mathematical
background, and for everyone who wants to learn the bases of computer
science.|js}
  ; body_html = {js|<p>This is a computer science course for the first year of “classes
préparatoires”. The course begins with an introductory lesson on
algorithms and a description of the OCaml language. Then, several
fundamental algorithms are described and illustrated using OCaml
programs. The book adopts a mathematical approach: descriptions of
mathematical objects are related to data structures in the programming
language. This book is suitable for students with some mathematical
background, and for everyone who wants to learn the bases of computer
science.</p>
|js}
  };
 
  { title = {js|Programmation de droite à gauche et vice-versa|js}
  ; slug = {js|programmation-de-droite--gauche-et-vice-versa|js}
  ; description = {js|Programming with OCaml
|js}
  ; authors = 
 [{js|Pascal Manoury|js}]
  ; language = {js|french|js}
  ; published = Some {js|2005|js}
  ; cover = Some {js|/books/manoury.png|js}
  ; isbn = Some {js|978-2-916466-05-7|js}
  ; links = 
 [
      { description = {js|Order Online from Paracamplus|js}
      ; uri = {js|https://paracamplus.com|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { title = {js|Programmation en Caml|js}
  ; slug = {js|programmation-en-caml|js}
  ; description = {js|This book is intended for beginners, who will learn basic programming notions. The first part of the book is a programming course that initiates the reader to the OCaml language.
|js}
  ; authors = 
 [{js|Jacques Rouablé|js}]
  ; language = {js|french|js}
  ; published = Some {js|1997|js}
  ; cover = Some {js|/books/rouable.jpg|js}
  ; isbn = Some {js|2-212-08944-9|js}
  ; links = 
 [
      { description = {js|Order at Amazon.fr|js}
      ; uri = {js|https://www.amazon.fr/exec/obidos/ASIN/2212089449|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js|This book is intended for beginners, who will learn basic programming
notions. The first part of the book is a programming course that
initiates the reader to the OCaml language. Important notions are
presented from a practical point of view, and the implementation of some
of these is analyzed and sketched. The second part, the “OCaml
workshop”, is a practical application of these notions to other domains
connected to computer science, logic, automata and grammars.|js}
  ; body_html = {js|<p>This book is intended for beginners, who will learn basic programming
notions. The first part of the book is a programming course that
initiates the reader to the OCaml language. Important notions are
presented from a practical point of view, and the implementation of some
of these is analyzed and sketched. The second part, the “OCaml
workshop”, is a practical application of these notions to other domains
connected to computer science, logic, automata and grammars.</p>
|js}
  };
 
  { title = {js|Programmation fonctionnelle, générique et objet: une introduction avec le langage OCaml|js}
  ; slug = {js|programmation-fonctionnelle-gnrique-et-objet-une-introduction-avec-le-langage-ocaml|js}
  ; description = {js|Programming with OCaml
|js}
  ; authors = 
 [{js|Philippe Narbel|js}]
  ; language = {js|french|js}
  ; published = Some {js|2005|js}
  ; cover = Some {js|/books/narbel.jpg|js}
  ; isbn = Some {js|2-7117-4843-X|js}
  ; links = 
 []
  ; rating = None
  ; featured = false
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { title = {js|Programmazione funzionale, una semplice introduzione|js}
  ; slug = {js|programmazione-funzionale-una-semplice-introduzione|js}
  ; description = {js|Functional programming introduction with OCaml
|js}
  ; authors = 
 [{js|Massimo Maria Ghisalberti|js}]
  ; language = {js|italian|js}
  ; published = Some {js|2015|js}
  ; cover = None
  ; isbn = None
  ; links = 
 [
      { description = {js|Emacs Org source|js}
      ; uri = {js|https://minimalprocedure.pragmas.org/writings/programmazione_funzionale/programmazione_funzionale.org|js}
      };
  
      { description = {js|HTML|js}
      ; uri = {js|https://minimalprocedure.pragmas.org/writings/programmazione_funzionale/programmazione_funzionale.html|js}
      };
  
      { description = {js|PDF|js}
      ; uri = {js|https://minimalprocedure.pragmas.org/writings/programmazione_funzionale/programmazione_funzionale.pdf|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { title = {js|Real World OCaml|js}
  ; slug = {js|real-world-ocaml|js}
  ; description = {js|Learn how to solve day-to-day problems in data processing, numerical computation, system scripting, and database-driven web applications with the OCaml multi-paradigm programming language.
|js}
  ; authors = 
 [{js|Jason Hickey|js}; {js|Anil Madhavapeddy|js}; {js|Yaron Minsky|js}]
  ; language = {js|english|js}
  ; published = Some {js|2013-11-25|js}
  ; cover = Some {js|/books/real-world-ocaml.jpg|js}
  ; isbn = None
  ; links = 
 [
      { description = {js|Read Online|js}
      ; uri = {js|https://dev.realworldocaml.org/|js}
      }]
  ; rating = Some 4
  ; featured = true
  ; body_md = {js|Learn how to solve day-to-day problems in data processing, numerical
computation, system scripting, and database-driven web applications with
the OCaml multi-paradigm programming language. This hands-on book shows
you how to take advantage of OCaml’s functional, imperative, and
object-oriented programming styles with recipes for many real-world
tasks.

You’ll start with OCaml basics, including how to set up a development
environment, and move toward more advanced topics such as the module
system, foreign-function interface, macro language, and the OCaml tools.
Quickly learn how to put OCaml to work for writing succinct and
readable code.|js}
  ; body_html = {js|<p>Learn how to solve day-to-day problems in data processing, numerical
computation, system scripting, and database-driven web applications with
the OCaml multi-paradigm programming language. This hands-on book shows
you how to take advantage of OCaml’s functional, imperative, and
object-oriented programming styles with recipes for many real-world
tasks.</p>
<p>You’ll start with OCaml basics, including how to set up a development
environment, and move toward more advanced topics such as the module
system, foreign-function interface, macro language, and the OCaml tools.
Quickly learn how to put OCaml to work for writing succinct and
readable code.</p>
|js}
  };
 
  { title = {js|Seize problèmes d'informatique|js}
  ; slug = {js|seize-problmes-dinformatique|js}
  ; description = {js|This book offers sixteen problems in computer science, with detailed answers to all questions and complete solutions to algorithmic problems given as OCaml programs.
|js}
  ; authors = 
 [{js|Bruno Petazzoni|js}]
  ; language = {js|french|js}
  ; published = Some {js|2001|js}
  ; cover = Some {js|/books/petazzoni.jpg|js}
  ; isbn = Some {js|3-540-67387-3|js}
  ; links = 
 [
      { description = {js|Springer's Catalog Page|js}
      ; uri = {js|https://www.springeronline.com/sgw/cda/frontpage/0,10735,5-102-22-2042496-0,00.html|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js|This book offers sixteen problems in computer science, with detailed
answers to all questions and complete solutions to algorithmic problems
given as OCaml programs. It deals mainly with automata, finite or
infinite words, formal language theory, and some classical algorithms
such as bin-packing. It is intended for students who attend the optional
computer science curriculum of the “classes préparatoires MPSI/MP”. It
should also be useful to all teachers and computer science students up
to a masters degree.|js}
  ; body_html = {js|<p>This book offers sixteen problems in computer science, with detailed
answers to all questions and complete solutions to algorithmic problems
given as OCaml programs. It deals mainly with automata, finite or
infinite words, formal language theory, and some classical algorithms
such as bin-packing. It is intended for students who attend the optional
computer science curriculum of the “classes préparatoires MPSI/MP”. It
should also be useful to all teachers and computer science students up
to a masters degree.</p>
|js}
  };
 
  { title = {js|The Functional Approach to OCaml|js}
  ; slug = {js|the-functional-approach-to-ocaml|js}
  ; description = {js|Learning about functional programming using OCaml
|js}
  ; authors = 
 [{js|Guy Cousineau|js}]
  ; language = {js|english|js}
  ; published = Some {js|1998|js}
  ; cover = Some {js|/books/cousineau-mauny-en.gif|js}
  ; isbn = Some {js|0-521-57681-4|js}
  ; links = 
 [
      { description = {js|Buy on Amazon.com|js}
      ; uri = {js|https://www.amazon.com/exec/obidos/ASIN/0521571839/qid%3D911812711/sr%3D1-22/102-8668961-8838559|js}
      }]
  ; rating = Some 4
  ; featured = true
  ; body_md = {js|This book uses OCaml as a tool to introduce several important
programming concepts. It is divided in three parts. The first part is an
introduction to OCaml, which presents the language itself, but also
introduces evaluation by rewriting, evaluation strategies and proofs of
programs by induction. The second part is dedicated to the description
of application programs which belong to various fields and might
interest various types of readers or students. Finally, the third part
is dedicated to implementation. It describes interpretation and
compilation, with brief descriptions of memory management and type
synthesis.|js}
  ; body_html = {js|<p>This book uses OCaml as a tool to introduce several important
programming concepts. It is divided in three parts. The first part is an
introduction to OCaml, which presents the language itself, but also
introduces evaluation by rewriting, evaluation strategies and proofs of
programs by induction. The second part is dedicated to the description
of application programs which belong to various fields and might
interest various types of readers or students. Finally, the third part
is dedicated to implementation. It describes interpretation and
compilation, with brief descriptions of memory management and type
synthesis.</p>
|js}
  };
 
  { title = {js|Think OCaml: How to think like a Functional Programmer|js}
  ; slug = {js|think-ocaml-how-to-think-like-a-functional-programmer|js}
  ; description = {js|Introductory programming textbook based on the OCaml language
|js}
  ; authors = 
 [{js|Nicholas Monje|js}; {js|Allen Downey|js}]
  ; language = {js|english|js}
  ; published = Some {js|2008|js}
  ; cover = Some {js|/books/thinkocaml_cover_web.png|js}
  ; isbn = None
  ; links = 
 [
      { description = {js|Read Online|js}
      ; uri = {js|https://greenteapress.com/thinkocaml/thinkocaml.pdf|js}
      }]
  ; rating = None
  ; featured = true
  ; body_md = {js|This book is a work in progress. It is an introductory programming
textbook based on the OCaml language. It is a modified version of
Think Python by Allen Downey. It is intended for newcomers to
programming and also those who know some programming but want to learn
programming in the function-oriented paradigm, or those who simply
want to learn OCaml.|js}
  ; body_html = {js|<p>This book is a work in progress. It is an introductory programming
textbook based on the OCaml language. It is a modified version of
Think Python by Allen Downey. It is intended for newcomers to
programming and also those who know some programming but want to learn
programming in the function-oriented paradigm, or those who simply
want to learn OCaml.</p>
|js}
  };
 
  { title = {js|Unix System Programming in OCaml|js}
  ; slug = {js|unix-system-programming-in-ocaml|js}
  ; description = {js|Learn Unix system programming in OCaml
|js}
  ; authors = 
 [{js|Xavier Leroy|js}; {js|Didier Rémy|js}]
  ; language = {js|english|js}
  ; published = Some {js|2010-05-01|js}
  ; cover = None
  ; isbn = None
  ; links = 
 [
      { description = {js|Online|js}
      ; uri = {js|https://ocaml.github.io/ocamlunix|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js|This is an excellent book on Unix system programming, with an emphasis
on communications between processes. The main novelty of this work is
the use of OCaml, instead of the C language that is customary in systems
programming. This gives an unusual perspective on systems programming
and on OCaml. It is assumed that the reader is familiar with OCaml and
Unix shell commands.|js}
  ; body_html = {js|<p>This is an excellent book on Unix system programming, with an emphasis
on communications between processes. The main novelty of this work is
the use of OCaml, instead of the C language that is customary in systems
programming. This gives an unusual perspective on systems programming
and on OCaml. It is assumed that the reader is familiar with OCaml and
Unix shell commands.</p>
|js}
  };
 
  { title = {js|Using, Understanding and Unraveling OCaml|js}
  ; slug = {js|using-understanding-and-unraveling-ocaml|js}
  ; description = {js|This book describes both the OCaml language and the theoretical grounds behind its powerful type system.
|js}
  ; authors = 
 [{js|Didier Rémy|js}]
  ; language = {js|english|js}
  ; published = Some {js|2002-09-20|js}
  ; cover = None
  ; isbn = None
  ; links = 
 [
      { description = {js|Online|js}
      ; uri = {js|https://caml.inria.fr/pub/docs/u3-ocaml/|js}
      };
  
      { description = {js|PDF|js}
      ; uri = {js|https://caml.inria.fr/pub/docs/u3-ocaml/ocaml.pdf|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js|This book describes both the OCaml language and the theoretical grounds
behind its powerful type system. A good complement to other books on
OCaml it is addressed to a wide audience of people interested in modern programming languages in general, ML-like languages in particular, or simply in OCaml, whether they are programmers or language designers, beginners or knowledgeable readers — little prerequisite is actually assumed.|js}
  ; body_html = {js|<p>This book describes both the OCaml language and the theoretical grounds
behind its powerful type system. A good complement to other books on
OCaml it is addressed to a wide audience of people interested in modern programming languages in general, ML-like languages in particular, or simply in OCaml, whether they are programmers or language designers, beginners or knowledgeable readers — little prerequisite is actually assumed.</p>
|js}
  }]

