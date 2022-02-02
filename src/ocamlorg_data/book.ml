
type link = { description : string; uri : string }

type t = 
  { title : string
  ; slug : string
  ; description : string
  ; authors : string list
  ; language : string
  ; published : string
  ; cover : string
  ; isbn : string option
  ; links : link list
  ; rating : int option
  ; featured : bool
  ; body_md : string
  ; body_html : string
  }

let all = 
[
  { title = {js|Apprendre à programmer avec OCaml|js}
  ; slug = {js|apprendre--programmer-avec-ocaml|js}
  ; description = {js|This book is organized into three parts. The first one introduces OCaml and targets beginners, being they programming beginners or simply new to OCaml. Through small programs, the reader is introduced to fundamental concepts of programming and of OCaml. The second and third parts are dedicated to fundamental concepts of algorithmics and should allow the reader to write programs in a structured and efficient way.
|js}
  ; authors = 
 [{js|Jean-Christophe Filliâtre|js}; {js|Sylvain Conchon|js}]
  ; language = {js|french|js}
  ; published = {js|2014|js}
  ; cover = {js|/books/apprendre-a-programmer-avec-ocaml.png|js}
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
  ; published = {js|2004|js}
  ; cover = {js|/books/apprentissage-de-la-programmation-avec-ocaml.jpg|js}
  ; isbn = Some {js|2-7462-0819-9|js}
  ; links = 
 [
      { description = {js|Buy on Amazon.fr|js}
      ; uri = {js|https://www.amazon.com/apprentissage-programmation-avec-ocaml/dp/2746208199|js}
      }]
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
 
  { title = {js|Développement d'applications avec Objective Caml|js}
  ; slug = {js|dveloppement-dapplications-avec-objective-caml|js}
  ; description = {js|"Objective CAML est un langage de programmation : un de plus dira-t-on ! Ils sont en effet déjà nombreux et pourtant il en apparaît constamment de nouveaux. Au delà de leurs disparités, la conception et la genèse de chacun d'eux procèdent d'une motivation partagée : la volonté d'abstraire"
|js}
  ; authors = 
 [{js|Emmanuel Chailloux|js}; {js|Pascal Manoury|js}; {js|Bruno Pagano|js}]
  ; language = {js|french|js}
  ; published = {js|2000|js}
  ; cover = {js|/books/developpement-d-applications-avec-objective-caml.jpg|js}
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
  ; published = {js|2015|js}
  ; cover = {js|/books/initiation-a-la-programmation-fonctionnelle-en-ocaml.jpg|js}
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
 
  { title = {js|Introduzione alla programmazione funzionale|js}
  ; slug = {js|introduzione-alla-programmazione-funzionale|js}
  ; description = {js|Functional programming introduction with OCaml
|js}
  ; authors = 
 [{js|Carla Limongelli|js}; {js|Marta Cialdea|js}]
  ; language = {js|italian|js}
  ; published = {js|2002|js}
  ; cover = {js|/books/introduzione-alla-programmazione-funzionale.gif|js}
  ; isbn = Some {js|88-7488-031-6|js}
  ; links = 
 [
      { description = {js|Order at Amazon.it|js}
      ; uri = {js|https://www.amazon.it/Introduzione-programmazione-funzionale-Marta-Cialdea/dp/8874880316|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { title = {js|More OCaml: Algorithms, Methods & Diversions|js}
  ; slug = {js|more-ocaml-algorithms-methods--diversions|js}
  ; description = {js|In "More OCaml" John Whitington takes a meandering tour of functional programming with OCaml, introducing various language features and describing some classic algorithms.
|js}
  ; authors = 
 [{js|John Whitington|js}]
  ; language = {js|english|js}
  ; published = {js|2014-08-26|js}
  ; cover = {js|/books/more-ocaml-algorithms-methods-diversions.jpg|js}
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
 
  { title = {js|入門OCaml ~プログラミング基礎と実践理解~|js}
  ; slug = {js|ocaml-|js}
  ; description = {js||js}
  ; authors = 
 [{js|OCaml-Nagoya|js}]
  ; language = {js|japanese|js}
  ; published = {js|2007|js}
  ; cover = {js|/books/nyumon-ocaml.jpg|js}
  ; isbn = None
  ; links = 
 [
      { description = {js|Order at Amazon.co.jp|js}
      ; uri = {js|https://www.amazon.co.jp/%E5%85%A5%E9%96%80OCaml-%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0%E5%9F%BA%E7%A4%8E%E3%81%A8%E5%AE%9F%E8%B7%B5%E7%90%86%E8%A7%A3-OCaml-Nagoya/dp/4839923116|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { title = {js|OCaml for Scientists|js}
  ; slug = {js|ocaml-for-scientists|js}
  ; description = {js|This book teaches OCaml programming with special emphasis on scientific applications.
|js}
  ; authors = 
 [{js|Jon D. Harrop|js}]
  ; language = {js|english|js}
  ; published = {js|2005|js}
  ; cover = {js|/books/ocaml-for-scientists.jpg|js}
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
  ; published = {js|2013-06-07|js}
  ; cover = {js|/books/ocaml-from-the-very-beginning.jpg|js}
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
  ; published = {js|2015|js}
  ; cover = {js|/books/ocaml-programacao-funcional-na-practica.jpg|js}
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
 
  { title = {js|OCaml语言编程基础教程|js}
  ; slug = {js|ocaml|js}
  ; description = {js||js}
  ; authors = 
 [{js|G. Chen|js}]
  ; language = {js|chinese|js}
  ; published = {js|2018|js}
  ; cover = {js|/books/ocaml-yuyan-biancheng-jichu-jiaocheng.jpg|js}
  ; isbn = None
  ; links = 
 [
      { description = {js|Order at Epubit.com|js}
      ; uri = {js|https://www.epubit.com/bookDetails?id=N18159|js}
      }]
  ; rating = None
  ; featured = false
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { title = {js|Programmation de droite à gauche et vice-versa|js}
  ; slug = {js|programmation-de-droite--gauche-et-vice-versa|js}
  ; description = {js|Programming with OCaml
|js}
  ; authors = 
 [{js|Pascal Manoury|js}]
  ; language = {js|french|js}
  ; published = {js|2005|js}
  ; cover = {js|/books/programmation-de-droite-a-gauche-et-vice-versa.jpg|js}
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
 
  { title = {js|プログラミング in OCaml ~関数型プログラミングの基礎からGUI構築まで~|js}
  ; slug = {js|-in-ocaml-gui|js}
  ; description = {js||js}
  ; authors = 
 [{js|A. Igarashi (五十嵐 淳)|js}]
  ; language = {js|japanese|js}
  ; published = {js|2007|js}
  ; cover = {js|/books/puroguramingu-in-ocaml.jpg|js}
  ; isbn = None
  ; links = 
 [
      { description = {js|Order at Amazon.co.jp|js}
      ; uri = {js|https://www.amazon.co.jp/%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0-OCaml-%E3%80%9C%E9%96%A2%E6%95%B0%E5%9E%8B%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0%E3%81%AE%E5%9F%BA%E7%A4%8E%E3%81%8B%E3%82%89GUI%E6%A7%8B%E7%AF%89%E3%81%BE%E3%81%A7%E3%80%9C-%E4%BA%94%E5%8D%81%E5%B5%90%E6%B7%B3-ebook/dp/B00QRPI1AS|js}
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
 [{js|Yaron Minsky|js}; {js|Anil Madhavapeddy|js}; {js|Jason Hickey|js}]
  ; language = {js|english|js}
  ; published = {js|2013-11-25|js}
  ; cover = {js|/books/real-world-ocaml.jpg|js}
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
 
  { title = {js|Think OCaml: How to think like a Functional Programmer|js}
  ; slug = {js|think-ocaml-how-to-think-like-a-functional-programmer|js}
  ; description = {js|Introductory programming textbook based on the OCaml language
|js}
  ; authors = 
 [{js|Nicholas Monje|js}; {js|Allen Downey|js}]
  ; language = {js|english|js}
  ; published = {js|2008-06|js}
  ; cover = {js|/books/think-ocaml-how-to-think-like-a-functional-programmer.png|js}
  ; isbn = None
  ; links = 
 [
      { description = {js|Read Online|js}
      ; uri = {js|https://greenteapress.com/thinkocaml/thinkocaml.pdf|js}
      }]
  ; rating = None
  ; featured = false
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
  }]

