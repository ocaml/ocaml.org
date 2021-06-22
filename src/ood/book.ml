
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
  ; body_md : string
  ; body_html : string
  }

let all = 
[
  { title = "Algorithmen, Datenstrukturen, Funktionale Programmierung: Eine praktische Einf\195\188hrung mit Caml Light"
  ; slug = "algorithmen-datenstrukturen-funktionale-programmierung-eine-praktische-einfhrung-mit-caml-light"
  ; description = "In the first part of this book, algorithms are described in a concise and precise manner using Caml Light. The second part provides a tutorial introduction into the language Caml Light and in its last chapter a comprehensive description of the language kernel.\n"
  ; authors = 
 ["Juergen Wolff von Gudenberg"]
  ; language = "german"
  ; published = Some 
 "1996"
  ; cover = Some "books/wolff.gif"
  ; isbn = None
  ; links = 
 []
  ; body_md = "This book gives an introduction to programming where algorithms as well\nas data structures are considered functionally. It is intended as an\naccompanying book for basic courses in computer science, but it is also\nsuitable for self-studies. In the first part, algorithms are described\nin a concise and precise manner using Caml Light. The second part\nprovides a tutorial introduction into the language Caml Light and in its\nlast chapter a comprehensive description of the language kernel."
  ; body_html = "<p>This book gives an introduction to programming where algorithms as well\nas data structures are considered functionally. It is intended as an\naccompanying book for basic courses in computer science, but it is also\nsuitable for self-studies. In the first part, algorithms are described\nin a concise and precise manner using Caml Light. The second part\nprovides a tutorial introduction into the language Caml Light and in its\nlast chapter a comprehensive description of the language kernel.</p>\n"
  };
 
  { title = "Apprendre \195\160 programmer avec OCaml"
  ; slug = "apprendre--programmer-avec-ocaml"
  ; description = "This book is organized into three parts. The first one introduces OCaml and targets beginners, being they programming beginners or simply new to OCaml. Through small programs, the reader is introduced to fundamental concepts of programming and of OCaml. The second and third parts are dedicated to fundamental concepts of algorithmics and should allow the reader to write programs in a structured and efficient way.\n"
  ; authors = 
 ["Jean-Christophe Filliâtre"; "Sylvain Conchon"]
  ; language = "french"
  ; published = Some 
 "2014"
  ; cover = Some "books/apprendre_ocaml_cover.png"
  ; isbn = Some 
 "2-21213-678-1"
  ; links = [
      { description = "Online"
      ; uri = "https://programmer-avec-ocaml.lri.fr/"
      };
                              
      { description = "Order at Amazon.fr"
      ; uri = "https://www.amazon.fr/Apprendre-programmer-avec-Ocaml-Algorithmes/dp/2212136781/"
      }]
  ; body_md = "Computer programming is hard to learn. Being a skillful programmer\nrequires imagination, anticipation, knowledge in algorithmics, the\nmastery of a programming language, and above all experience, as\ndifficulties are often hidden in details.  This book synthesizes our\nexperience as teachers and programmers.\n\nThe programming style is essential. Given a programming language, the\nsame algorithm can be written in multiple ways, and some of them can\nbe both elegant and efficient. This is what the programmer must seek\nat all costs and the reason why we choose a programming language for\nthis book rather than pseudo-code. Our choice is OCaml.\n\nThis book is organized into three parts. The first one introduces\nOCaml and targets beginners, being they programming beginners or\nsimply new to OCaml. Through small programs, the reader is introduced\nto fundamental concepts of programming and of OCaml. The second and\nthird parts are dedicated to fundamental concepts of algorithmics and\nshould allow the reader to write programs in a structured and\nefficient way. Algorithmic concepts are directly presented in the\nsyntax of OCaml and any code snippet from the book is available\nonline."
  ; body_html = "<p>Computer programming is hard to learn. Being a skillful programmer\nrequires imagination, anticipation, knowledge in algorithmics, the\nmastery of a programming language, and above all experience, as\ndifficulties are often hidden in details.  This book synthesizes our\nexperience as teachers and programmers.</p>\n<p>The programming style is essential. Given a programming language, the\nsame algorithm can be written in multiple ways, and some of them can\nbe both elegant and efficient. This is what the programmer must seek\nat all costs and the reason why we choose a programming language for\nthis book rather than pseudo-code. Our choice is OCaml.</p>\n<p>This book is organized into three parts. The first one introduces\nOCaml and targets beginners, being they programming beginners or\nsimply new to OCaml. Through small programs, the reader is introduced\nto fundamental concepts of programming and of OCaml. The second and\nthird parts are dedicated to fundamental concepts of algorithmics and\nshould allow the reader to write programs in a structured and\nefficient way. Algorithmic concepts are directly presented in the\nsyntax of OCaml and any code snippet from the book is available\nonline.</p>\n"
  };
 
  { title = "Apprentissage de la programmation avec OCaml"
  ; slug = "apprentissage-de-la-programmation-avec-ocaml"
  ; description = "This book is targeted towards beginner programmers and provides teaching material for all programmers wishing to learn the functional programming style. The programming features introduced in this book are available in all dialects of the ML language, notably Caml-Light, OCaml and Standard ML.\n"
  ; authors = 
 ["Catherine Dubois"; "Valérie Ménissier Morain"]
  ; language = "french"
  ; published = Some 
 "2004"
  ; cover = Some "books/dubois-menissier.gif"
  ; isbn = Some 
 "2-7462-0819-9"
  ; links = []
  ; body_md = "Programming is a discipline by which the strengths of computers can be\nharnessed: large amounts of reliable memory, the ability to execute\nrepetitive tasks relentlessly, and a high computation speed. In order to\nwrite correct programs that fulfill their specified needs, it is\nnecessary to understand the precise semantics of the programming\nlanguage. This book is targeted towards beginner programmers and\nprovides teaching material for all programmers wishing to learn the\nfunctional programming style. The programming features introduced in\nthis book are available in all dialects of the ML language, notably\nCaml-Light, OCaml and Standard ML. The concepts presented therein and\nillustrated in OCaml easily transpose to other programming languages."
  ; body_html = "<p>Programming is a discipline by which the strengths of computers can be\nharnessed: large amounts of reliable memory, the ability to execute\nrepetitive tasks relentlessly, and a high computation speed. In order to\nwrite correct programs that fulfill their specified needs, it is\nnecessary to understand the precise semantics of the programming\nlanguage. This book is targeted towards beginner programmers and\nprovides teaching material for all programmers wishing to learn the\nfunctional programming style. The programming features introduced in\nthis book are available in all dialects of the ML language, notably\nCaml-Light, OCaml and Standard ML. The concepts presented therein and\nillustrated in OCaml easily transpose to other programming languages.</p>\n"
  };
 
  { title = "Approche Fonctionnelle de la Programmation"
  ; slug = "approche-fonctionnelle-de-la-programmation"
  ; description = "This book uses OCaml as a tool to introduce several important programming concepts."
  ; authors = 
 ["Guy Cousineau"; "Michel Mauny"]
  ; language = "french"
  ; published = Some 
 "1995"
  ; cover = Some "books/cousineau-mauny-fr.gif"
  ; isbn = Some 
 "2-84074-114-8"
  ; links = [
      { description = "Book Website"
      ; uri = "https://pauillac.inria.fr/cousineau-mauny/main-fr.html"
      }]
  ; body_md = "This book uses OCaml as a tool to introduce several important\nprogramming concepts. It is divided in three parts. The first part is an\nintroduction to OCaml, which presents the language itself, but also\nintroduces evaluation by rewriting, evaluation strategies and proofs of\nprograms by induction. The second part is dedicated to the description\nof application programs which belong to various fields and might\ninterest various types of readers or students. Finally, the third part\nis dedicated to implementation. It describes interpretation then\ncompilation, with brief descriptions of memory management and type\nsynthesis."
  ; body_html = "<p>This book uses OCaml as a tool to introduce several important\nprogramming concepts. It is divided in three parts. The first part is an\nintroduction to OCaml, which presents the language itself, but also\nintroduces evaluation by rewriting, evaluation strategies and proofs of\nprograms by induction. The second part is dedicated to the description\nof application programs which belong to various fields and might\ninterest various types of readers or students. Finally, the third part\nis dedicated to implementation. It describes interpretation then\ncompilation, with brief descriptions of memory management and type\nsynthesis.</p>\n"
  };
 
  { title = "Concepts et outils de programmation"
  ; slug = "concepts-et-outils-de-programmation"
  ; description = "The book begins with a functional approach, based on OCaml, and continues with a presentation of an imperative language, namely Ada. It also provides numerous exercises with solutions.\n"
  ; authors = 
 ["Thérèse Accart Hardin"; "Véronique Donzeau-Gouge Viguié"]
  ; language = "french"
  ; published = Some 
 "1992"
  ; cover = Some "books/hardin-donzeau-gouge.gif"
  ; isbn = Some 
 "2-7296-0419-7"
  ; links = [
      { description = "Order at Amazon.fr"
      ; uri = "https://www.amazon.fr/exec/obidos/ASIN/2729604197"
      }]
  ; body_md = "This book presents a new approach to teaching programming concepts to\nbeginners, based on language semantics. A simplified semantic model is\nused to describe in a precise manner the features found in most\nprogramming languages. This model is powerful enough to explain\ntypechecking, polymorphism, evaluation, side-effects, modularity,\nexceptions. Yet, it is simple enough to be manipulated by hand, so that\nstudents can actually use it to compute. The book begins with a\nfunctional approach, based on OCaml, and continues with a presentation\nof an imperative language, namely Ada. It also provides numerous\nexercises with solutions."
  ; body_html = "<p>This book presents a new approach to teaching programming concepts to\nbeginners, based on language semantics. A simplified semantic model is\nused to describe in a precise manner the features found in most\nprogramming languages. This model is powerful enough to explain\ntypechecking, polymorphism, evaluation, side-effects, modularity,\nexceptions. Yet, it is simple enough to be manipulated by hand, so that\nstudents can actually use it to compute. The book begins with a\nfunctional approach, based on OCaml, and continues with a presentation\nof an imperative language, namely Ada. It also provides numerous\nexercises with solutions.</p>\n"
  };
 
  { title = "Cours et exercices d'informatique"
  ; slug = "cours-et-exercices-dinformatique"
  ; description = "This book was written by teachers at university and in \226\128\156classes pr\195\169paratoires\226\128\157. It is intended for \226\128\156classes pr\195\169paratoires\226\128\157 students who study computer science and for students engaged in a computer science cursus up to the masters level. It includes a tutorial of the OCaml language, a course on algorithms, data structures, automata theory, and formal logic, as well as 135 exercises with solutions.\n"
  ; authors = 
 ["Luc Albert"]
  ; language = "french"
  ; published = Some "1997"
  ; cover = Some 
 "books/albert.gif"
  ; isbn = Some "2-84180-106-3"
  ; links = []
  ; body_md = "This book was written by teachers at university and in \226\128\156classes\npr\195\169paratoires\226\128\157. It is intended for \226\128\156classes pr\195\169paratoires\226\128\157 students who\nstudy computer science and for students engaged in a computer science\ncursus up to the masters level. It includes a tutorial of the OCaml\nlanguage, a course on algorithms, data structures, automata theory, and\nformal logic, as well as 135 exercises with solutions."
  ; body_html = "<p>This book was written by teachers at university and in \226\128\156classes\npr\195\169paratoires\226\128\157. It is intended for \226\128\156classes pr\195\169paratoires\226\128\157 students who\nstudy computer science and for students engaged in a computer science\ncursus up to the masters level. It includes a tutorial of the OCaml\nlanguage, a course on algorithms, data structures, automata theory, and\nformal logic, as well as 135 exercises with solutions.</p>\n"
  };
 
  { title = "Developing Applications with OCaml"
  ; slug = "developing-applications-with-ocaml"
  ; description = "A comprehensive (742 page) guide to developing application in the OCaml programming language\n"
  ; authors = 
 ["Emmanuel Chailloux"; "Pascal Manoury"; "Bruno Pagano"]
  ; language = "english"
  ; published = Some 
 "2002"
  ; cover = Some "books/logocaml-oreilly.gif"
  ; isbn = None
  ; links = 
 [
      { description = "Book Website"
      ; uri = "https://caml.inria.fr/pub/docs/oreilly-book/index.html"
      };
  
      { description = "Online"
      ; uri = "https://caml.inria.fr/pub/docs/oreilly-book/html/index.html"
      };
  
      { description = "PDF"
      ; uri = "https://caml.inria.fr/pub/docs/oreilly-book/ocaml-ora-book.pdf"
      }]
  ; body_md = "A comprehensive (742 pages) book on OCaml, covering not only the core\nlanguage, but also modules, objects and classes, threads and systems\nprogramming, interoperability with C, and runtime tools. This book is a\ntranslation of a French book published by OReilly."
  ; body_html = "<p>A comprehensive (742 pages) book on OCaml, covering not only the core\nlanguage, but also modules, objects and classes, threads and systems\nprogramming, interoperability with C, and runtime tools. This book is a\ntranslation of a French book published by OReilly.</p>\n"
  };
 
  { title = "D\195\169veloppement d'applications avec Objective Caml"
  ; slug = "dveloppement-dapplications-avec-objective-caml"
  ; description = "\"Objective CAML est un langage de programmation : un de plus dira-t-on ! Ils sont en effet d\195\169j\195\160 nombreux et pourtant il en appara\195\174t constamment de nouveaux. Au del\195\160 de leurs disparit\195\169s, la conception et la gen\195\168se de chacun d'eux proc\195\168dent d'une motivation partag\195\169e : la volont\195\169 d'abstraire\"\n"
  ; authors = 
 ["Emmanuel Chailloux"; "Pascal Manoury"; "Bruno Pagano"]
  ; language = "french"
  ; published = Some 
 "2000"
  ; cover = Some "books/chailloux-manoury-pagano.jpg"
  ; isbn = Some 
 "2-84177-121-0"
  ; links = [
      { description = "Online"
      ; uri = "https://www.pps.jussieu.fr/Livres/ora/DA-OCAML/index.html"
      };
                              
      { description = "Order at Amazon.fr"
      ; uri = "https://www.amazon.fr/exec/obidos/ASIN/2841771210"
      }]
  ; body_md = "A comprehensive (742 pages) book on OCaml, covering not only the core\nlanguage, but also modules, objects and classes, threads and systems\nprogramming, and interoperability with C.\n\n\"Objective CAML est un langage de programmation : un de plus dira-t-on ! Ils sont en effet d\195\169j\195\160 nombreux et pourtant il en appara\195\174t constamment de nouveaux. Au del\195\160 de leurs disparit\195\169s, la conception et la gen\195\168se de chacun d'eux proc\195\168dent d'une motivation partag\195\169e : la volont\195\169 d'abstraire\""
  ; body_html = "<p>A comprehensive (742 pages) book on OCaml, covering not only the core\nlanguage, but also modules, objects and classes, threads and systems\nprogramming, and interoperability with C.</p>\n<p>&quot;Objective CAML est un langage de programmation : un de plus dira-t-on ! Ils sont en effet d\195\169j\195\160 nombreux et pourtant il en appara\195\174t constamment de nouveaux. Au del\195\160 de leurs disparit\195\169s, la conception et la gen\195\168se de chacun d'eux proc\195\168dent d'une motivation partag\195\169e : la volont\195\169 d'abstraire&quot;</p>\n"
  };
 
  { title = "Initiation \195\160 la programmation fonctionnelle en OCaml"
  ; slug = "initiation--la-programmation-fonctionnelle-en-ocaml"
  ; description = "Le but de ce livre est d\226\128\153initier le lecteur au style fonctionnel de programmation en utilisant le langage OCaml.\n"
  ; authors = 
 ["Mohammed-Said Habet"]
  ; language = "french"
  ; published = Some 
 "2015"
  ; cover = Some "books/Initiation_a_la_programmation_fonctionnelle_en_OCaml.jpg"
  ; isbn = Some 
 "9782332978400"
  ; links = [
      { description = "Website"
      ; uri = "https://www.edilivre.com/initiation-a-la-programmation-fonctionnelle-en-ocaml-mohammed-said-habet.html"
      }]
  ; body_md = "La programmation fonctionnelle est un style de programmation qui\nconsiste \195\160 consid\195\169rer les programmes informatiques comme des fonctions\nau sens math\195\169matique du terme. Ce style est propos\195\169 dans de nombreux\nlangages de programmation anciens et r\195\169cents comme OCaml.\n\nLe but de ce livre est d\226\128\153initier le lecteur au style fonctionnel de\nprogrammation en utilisant le langage OCaml. Cet ouvrage s\226\128\153adresse\ndonc principalement aux d\195\169butants en informatique. Il peut \195\169galement\n\195\170tre l\226\128\153occasion pour les initi\195\169s de d\195\169couvrir le langage de\nprogrammation OCaml.\n\nLe lecteur trouvera une pr\195\169sentation progressive des concepts de\nprogrammation fonctionnelle dans le langage OCaml, illustr\195\169e par des\nexemples, de nombreux exercices corrig\195\169s et d\226\128\153autres laiss\195\169s \195\160\nl\226\128\153initiative du lecteur."
  ; body_html = "<p>La programmation fonctionnelle est un style de programmation qui\nconsiste \195\160 consid\195\169rer les programmes informatiques comme des fonctions\nau sens math\195\169matique du terme. Ce style est propos\195\169 dans de nombreux\nlangages de programmation anciens et r\195\169cents comme OCaml.</p>\n<p>Le but de ce livre est d\226\128\153initier le lecteur au style fonctionnel de\nprogrammation en utilisant le langage OCaml. Cet ouvrage s\226\128\153adresse\ndonc principalement aux d\195\169butants en informatique. Il peut \195\169galement\n\195\170tre l\226\128\153occasion pour les initi\195\169s de d\195\169couvrir le langage de\nprogrammation OCaml.</p>\n<p>Le lecteur trouvera une pr\195\169sentation progressive des concepts de\nprogrammation fonctionnelle dans le langage OCaml, illustr\195\169e par des\nexemples, de nombreux exercices corrig\195\169s et d\226\128\153autres laiss\195\169s \195\160\nl\226\128\153initiative du lecteur.</p>\n"
  };
 
  { title = "Introduction to OCaml"
  ; slug = "introduction-to-ocaml"
  ; description = "This book is an introduction to ML programming, specifically for the OCaml programming language from INRIA. OCaml is a dialect of the ML family of languages, which derive from the Classic ML language designed by Robin Milner in 1975 for the LCF (Logic of Computable Functions) theorem prover.\n"
  ; authors = 
 ["Jason Hickey"]
  ; language = "english"
  ; published = Some "2008"
  ; cover = None
  ; isbn = None
  ; links = 
 [
      { description = "PDF"
      ; uri = "https://courses.cms.caltech.edu/cs134/cs134b/book.pdf"
      }]
  ; body_md = "This book is notoriously much more than just an introduction to OCaml,\nit describes most of the language, and is accessible.\n\nAbstract: *This book is an introduction to ML programming, specifically for the OCaml programming language from INRIA. OCaml is a dialect of the ML family of languages, which derive from the Classic ML language designed by Robin Milner in 1975 for the LCF (Logic of Computable Functions) theorem prover.*\n\n[PDF](https://courses.cms.caltech.edu/cs134/cs134b/book.pdf)"
  ; body_html = "<p>This book is notoriously much more than just an introduction to OCaml,\nit describes most of the language, and is accessible.</p>\n<p>Abstract: <em>This book is an introduction to ML programming, specifically for the OCaml programming language from INRIA. OCaml is a dialect of the ML family of languages, which derive from the Classic ML language designed by Robin Milner in 1975 for the LCF (Logic of Computable Functions) theorem prover.</em></p>\n<p><a href=\"https://courses.cms.caltech.edu/cs134/cs134b/book.pdf\">PDF</a></p>\n"
  };
 
  { title = "Introduzione alla programmazione funzionale"
  ; slug = "introduzione-alla-programmazione-funzionale"
  ; description = "Functional programming introduction with OCaml\n"
  ; authors = 
 ["Carla Limongelli"; "Marta Cialdea"]
  ; language = "italian"
  ; published = Some 
 "2002"
  ; cover = Some "books/limongelli-cialdea.gif"
  ; isbn = Some 
 "88-7488-031-6"
  ; links = []
  ; body_md = ""
  ; body_html = ""
  };
 
  { title = "Le Langage Caml"
  ; slug = "le-langage-caml"
  ; description = "This book is a comprehensive introduction to programming in OCaml. Usable as a programming course, it introduces progressively the language features and shows them at work on the fundamental programming problems. In addition to many introductory code samples, this book details the design and implementation of six complete, realistic programs in reputedly difficult application areas: compilation, type inference, automata, etc.\n"
  ; authors = 
 ["Xavier Leroy"; "Pierre Weis"]
  ; language = "french"
  ; published = Some 
 "1993"
  ; cover = Some "books/le-language-caml-cover.jpg"
  ; isbn = Some 
 "2-10-004383-8"
  ; links = [
      { description = "PDF"
      ; uri = "https://caml.inria.fr/pub/distrib/books/llc.pdf"
      }]
  ; body_md = "This book is a comprehensive introduction to programming in OCaml.\nUsable as a programming course, it introduces progressively the language\nfeatures and shows them at work on the fundamental programming problems.\nIn addition to many introductory code samples, this book details the\ndesign and implementation of six complete, realistic programs in\nreputedly difficult application areas: compilation, type inference,\nautomata, etc."
  ; body_html = "<p>This book is a comprehensive introduction to programming in OCaml.\nUsable as a programming course, it introduces progressively the language\nfeatures and shows them at work on the fundamental programming problems.\nIn addition to many introductory code samples, this book details the\ndesign and implementation of six complete, realistic programs in\nreputedly difficult application areas: compilation, type inference,\nautomata, etc.</p>\n"
  };
 
  { title = "Manuel de r\195\169f\195\169rence du langage Caml"
  ; slug = "manuel-de-rfrence-du-langage-caml"
  ; description = "\"Cet ouvrage contient le manuel de r\195\169f\195\169rence du langage Caml et la documentation compl\195\168te du syst\195\168me Caml Light, un environnement de programmation en Caml distribu\195\169e gratuitement. Il s\226\128\153adresse \195\161 des programmeurs Caml exp\195\169riment\195\169s, et non pas aux d'\195\169butants. Il vient en compl\195\169ment du livre Le langage Caml, des m\195\170mes auteurs chez le m\195\170me \195\169diteur, qui fournit une introduction progressive au langage Caml et \195\161 l\226\128\153\195\169criture de programmes dans ce langage.\"\n"
  ; authors = 
 ["Xavier Leroy"; "Pierre Weis"]
  ; language = "french"
  ; published = Some 
 "1993"
  ; cover = Some "books/manuel-de-reference-du-langage-caml-cover.jpg"
  ; isbn = Some 
 "2-7296-0492-8"
  ; links = [
      { description = "PDF"
      ; uri = "https://caml.inria.fr/pub/distrib/books/manuel-cl.pdf"
      }]
  ; body_md = "Written by two of the implementors of the Caml Light compiler, this\ncomprehensive book describes all constructs of the programming language\nand provides a complete documentation for the Caml Light system.\n\nIntro:  \"Cet ouvrage contient le manuel de r\195\169f\195\169rence du langage Caml et la documentation compl\195\168te du syst\195\168me Caml Light, un environnement de programmation en Caml distribu\195\169e gratuitement. Il s\226\128\153adresse \195\161 des programmeurs Caml exp\195\169riment\195\169s, et non pas aux d'\195\169butants. Il vient en compl\195\169ment du livre Le langage Caml, des m\195\170mes auteurs chez le m\195\170me \195\169diteur, qui fournit une introduction progressive au langage Caml et \195\161 l\226\128\153\195\169criture de programmes dans ce langage.\""
  ; body_html = "<p>Written by two of the implementors of the Caml Light compiler, this\ncomprehensive book describes all constructs of the programming language\nand provides a complete documentation for the Caml Light system.</p>\n<p>Intro:  &quot;Cet ouvrage contient le manuel de r\195\169f\195\169rence du langage Caml et la documentation compl\195\168te du syst\195\168me Caml Light, un environnement de programmation en Caml distribu\195\169e gratuitement. Il s\226\128\153adresse \195\161 des programmeurs Caml exp\195\169riment\195\169s, et non pas aux d'\195\169butants. Il vient en compl\195\169ment du livre Le langage Caml, des m\195\170mes auteurs chez le m\195\170me \195\169diteur, qui fournit une introduction progressive au langage Caml et \195\161 l\226\128\153\195\169criture de programmes dans ce langage.&quot;</p>\n"
  };
 
  { title = "More OCaml: Algorithms, Methods & Diversions"
  ; slug = "more-ocaml-algorithms-methods--diversions"
  ; description = "In \"More OCaml\" John Whitington takes a meandering tour of functional programming with OCaml, introducing various language features and describing some classic algorithms.\n"
  ; authors = 
 ["John Whitington"]
  ; language = "english"
  ; published = Some "2014-08-26"
  ; cover = Some 
 "books/more-ocaml-300-376.png"
  ; isbn = None
  ; links = [
      { description = "Book Website"
      ; uri = "https://ocaml-book.com/more-ocaml-algorithms-methods-diversions/"
      };
                                                             
      { description = "Amazon"
      ; uri = "https://www.amazon.com/gp/product/0957671113"
      }]
  ; body_md = "In \"More OCaml\" John Whitington takes a meandering tour of functional\nprogramming with OCaml, introducing various language features and describing\nsome classic algorithms. The book ends with a large worked example dealing with\nthe production of PDF files. There are questions for each chapter together with\nworked answers and hints.\n\n\"More OCaml\" will appeal both to existing OCaml programmers who wish to brush up\ntheir skills, and to experienced programmers eager to explore functional\nlanguages such as OCaml. It is hoped that each reader will find something new,\nor see an old thing in a new light. For the more casual reader, or those who are\nused to a different functional language, a summary of basic OCaml is provided at\nthe front of the book."
  ; body_html = "<p>In &quot;More OCaml&quot; John Whitington takes a meandering tour of functional\nprogramming with OCaml, introducing various language features and describing\nsome classic algorithms. The book ends with a large worked example dealing with\nthe production of PDF files. There are questions for each chapter together with\nworked answers and hints.</p>\n<p>&quot;More OCaml&quot; will appeal both to existing OCaml programmers who wish to brush up\ntheir skills, and to experienced programmers eager to explore functional\nlanguages such as OCaml. It is hoped that each reader will find something new,\nor see an old thing in a new light. For the more casual reader, or those who are\nused to a different functional language, a summary of basic OCaml is provided at\nthe front of the book.</p>\n"
  };
 
  { title = "Nouveaux exercices d'algorithmique"
  ; slug = "nouveaux-exercices-dalgorithmique"
  ; description = "This book presents 103 exercises and 5 problems about algorithms, for masters students. It attempts to address both practical and theoretical questions. Programs are written in OCaml and expressed in a purely functional style.\n"
  ; authors = 
 ["Michel Quercia"]
  ; language = "french"
  ; published = Some "2000"
  ; cover = Some 
 "books/quercia.gif"
  ; isbn = Some "2-7117-8990"
  ; links = [
      { description = "Order at Amazon.fr"
      ; uri = "https://www.amazon.fr/exec/obidos/ASIN/3540673873"
      }]
  ; body_md = "This book presents 103 exercises and 5 problems about algorithms, for\nmasters students. It attempts to address both practical and theoretical\nquestions. Programs are written in OCaml and expressed in a purely\nfunctional style. Problem areas include programming methodology, lists,\nformula evaluation, Boolean logic, algorithmic complexity, trees,\nlanguages, and automata."
  ; body_html = "<p>This book presents 103 exercises and 5 problems about algorithms, for\nmasters students. It attempts to address both practical and theoretical\nquestions. Programs are written in OCaml and expressed in a purely\nfunctional style. Problem areas include programming methodology, lists,\nformula evaluation, Boolean logic, algorithmic complexity, trees,\nlanguages, and automata.</p>\n"
  };
 
  { title = "OCaml Book"
  ; slug = "ocaml-book"
  ; description = "Introductory programming textbook based on the OCaml language\n"
  ; authors = 
 ["Hongbo Zhang"]
  ; language = "english"
  ; published = Some "2011"
  ; cover = None
  ; isbn = None
  ; links = 
 [
      { description = "GitHub"
      ; uri = "https://github.com/bobzhang/ocaml-book"
      }]
  ; body_md = "This book is a work in progress. It currently includes sections on the\ncore OCaml language, Camlp4, parsing, various libraries, the OCaml\nruntime, interoperating with C, and pearls."
  ; body_html = "<p>This book is a work in progress. It currently includes sections on the\ncore OCaml language, Camlp4, parsing, various libraries, the OCaml\nruntime, interoperating with C, and pearls.</p>\n"
  };
 
  { title = "OCaml for Scientists"
  ; slug = "ocaml-for-scientists"
  ; description = "This book teaches OCaml programming with special emphasis on scientific applications.\n"
  ; authors = 
 ["Jon D. Harrop"]
  ; language = "english"
  ; published = Some "2005"
  ; cover = Some 
 "books/harrop-book.gif"
  ; isbn = None
  ; links = [
      { description = "Book Website"
      ; uri = "https://www.ffconsultancy.com/products/ocaml_for_scientists/index.html"
      };
                                                      
      { description = "Ordering Information"
      ; uri = "https://www.ffconsultancy.com/products/ocaml_for_scientists/index.html"
      }]
  ; body_md = "This book teaches OCaml programming with special emphasis on scientific\napplications. Many examples are given, covering everything from simple\nnumerical analysis to sophisticated real-time 3D visualisation using\nOpenGL. This book contains over 800 color syntax-highlighted source code\nexamples and dozens of diagrams that elucidate the power of functional\nprogramming to explain how lightning-fast and yet remarkably-simple\nprograms can be constructed in the OCaml programming language."
  ; body_html = "<p>This book teaches OCaml programming with special emphasis on scientific\napplications. Many examples are given, covering everything from simple\nnumerical analysis to sophisticated real-time 3D visualisation using\nOpenGL. This book contains over 800 color syntax-highlighted source code\nexamples and dozens of diagrams that elucidate the power of functional\nprogramming to explain how lightning-fast and yet remarkably-simple\nprograms can be constructed in the OCaml programming language.</p>\n"
  };
 
  { title = "OCaml from the very Beginning"
  ; slug = "ocaml-from-the-very-beginning"
  ; description = "In \"OCaml from the Very Beginning\" John Whitington takes a no-prerequisites approach to teaching a modern general-purpose programming language.\n"
  ; authors = 
 ["John Whitington"]
  ; language = "english"
  ; published = Some "2013-06-07"
  ; cover = Some 
 "books/OCaml_from_beginning.png"
  ; isbn = None
  ; links = [
      { description = "Book Website"
      ; uri = "https://ocaml-book.com/"
      };
                                                               
      { description = "Amazon"
      ; uri = "https://www.amazon.com/gp/product/0957671105"
      }]
  ; body_md = "In \"OCaml from the Very Beginning\" John Whitington takes a\nno-prerequisites approach to teaching a modern general-purpose\nprogramming language. Each small, self-contained chapter introduces a\nnew topic, building until the reader can write quite substantial\nprograms. There are plenty of questions and, crucially, worked answers\nand hints.\n\n\"OCaml from the Very Beginning\" will appeal both to new programmers, and experienced programmers eager to explore functional languages such as OCaml. It is suitable both for formal use within an undergraduate or graduate curriculum, and for the interested amateur."
  ; body_html = "<p>In &quot;OCaml from the Very Beginning&quot; John Whitington takes a\nno-prerequisites approach to teaching a modern general-purpose\nprogramming language. Each small, self-contained chapter introduces a\nnew topic, building until the reader can write quite substantial\nprograms. There are plenty of questions and, crucially, worked answers\nand hints.</p>\n<p>&quot;OCaml from the Very Beginning&quot; will appeal both to new programmers, and experienced programmers eager to explore functional languages such as OCaml. It is suitable both for formal use within an undergraduate or graduate curriculum, and for the interested amateur.</p>\n"
  };
 
  { title = "OCaml: Programa\195\167\195\163o Funcional na Pr\195\161tica"
  ; slug = "ocaml-programao-funcional-na-prtica"
  ; description = "This book is an introduction to functional programming through OCaml, with a pragmatic focus. The goal is to enable the reader to write real programs in OCaml and understand most of the open source code written in the language.\n"
  ; authors = 
 ["Andrei de Araújo Formiga"]
  ; language = "portugese"
  ; published = Some 
 "2015"
  ; cover = Some "books/opfp.png"
  ; isbn = None
  ; links = 
 [
      { description = "Book site"
      ; uri = "https://andreiformiga.com/livro/ocaml/"
      };
  
      { description = "Order online from Casa do C\195\179digo"
      ; uri = "https://www.casadocodigo.com.br/products/livro-ocaml"
      }]
  ; body_md = "This book is an introduction to functional programming through OCaml, with a pragmatic\nfocus. The goal is to enable the reader to write real programs in OCaml and understand\nmost of the open source code written in the language. It includes many code examples\nillustrating the topics and a few larger projects written in OCaml that showcase the\nintegration of many language features. These larger\nprograms include a set of interpreter, compiler and stack machine for a simple\nlanguage, and a decision tree learning program for data analysis."
  ; body_html = "<p>This book is an introduction to functional programming through OCaml, with a pragmatic\nfocus. The goal is to enable the reader to write real programs in OCaml and understand\nmost of the open source code written in the language. It includes many code examples\nillustrating the topics and a few larger projects written in OCaml that showcase the\nintegration of many language features. These larger\nprograms include a set of interpreter, compiler and stack machine for a simple\nlanguage, and a decision tree learning program for data analysis.</p>\n"
  };
 
  { title = "The OCaml System: Documentation and User's Manual"
  ; slug = "the-ocaml-system-documentation-and-users-manual"
  ; description = "The official User's Manual for OCaml serving as a complete reference guide"
  ; authors = 
 ["Damien Doligez"; "Alain Frisch"; "Jacques Garrigue"; "Didier Rémy";
  "Jérôme Vouillon"]
  ; language = "english"
  ; published = None
  ; cover = Some 
 "books/colour-icon-170x148.png"
  ; isbn = None
  ; links = [
      { description = "Online"
      ; uri = "https://ocaml.org/releases/latest/manual.html"
      }]
  ; body_md = "This the official User's Manual. It serves as a complete reference guide\nto OCaml. Updated for each version of OCaml, it contains the description\nof the language, of its extensions, and the documentation of the tools\nand libraries included in the official distribution."
  ; body_html = "<p>This the official User's Manual. It serves as a complete reference guide\nto OCaml. Updated for each version of OCaml, it contains the description\nof the language, of its extensions, and the documentation of the tools\nand libraries included in the official distribution.</p>\n"
  };
 
  { title = "Option Informatique MP/MP"
  ; slug = "option-informatique-mpmp"
  ; description = "This books is a follow-up to the previous one and is intended for second year students in \226\128\156classes pr\195\169paratoires\226\128\157. It deals with trees, algebraic expressions, automata and languages, and OCaml streams. The book contains more than 200 OCaml programs.\n"
  ; authors = 
 ["Denis Monasse"]
  ; language = "french"
  ; published = Some "1997"
  ; cover = Some 
 "books/monasse-2.jpg"
  ; isbn = Some "2-7117-8839-3"
  ; links = [
      { description = "Order at Amazon.fr"
      ; uri = "https://www.amazon.fr/exec/obidos/ASIN/2711788393"
      }]
  ; body_md = "This books is a follow-up to the previous one and is intended for second\nyear students in \226\128\156classes pr\195\169paratoires\226\128\157. It deals with trees, algebraic\nexpressions, automata and languages, and OCaml streams. The book\ncontains more than 200 OCaml programs."
  ; body_html = "<p>This books is a follow-up to the previous one and is intended for second\nyear students in \226\128\156classes pr\195\169paratoires\226\128\157. It deals with trees, algebraic\nexpressions, automata and languages, and OCaml streams. The book\ncontains more than 200 OCaml programs.</p>\n"
  };
 
  { title = "Option Informatique MPSI"
  ; slug = "option-informatique-mpsi"
  ; description = "This is a computer science course for the first year of \226\128\156classes pr\195\169paratoires\226\128\157. The course begins with an introductory lesson on algorithms and a description of the OCaml language.\n"
  ; authors = 
 ["Denis Monasse"]
  ; language = "french"
  ; published = Some "1996"
  ; cover = Some 
 "books/monasse-1.gif"
  ; isbn = Some "2-7117-8831-8"
  ; links = []
  ; body_md = "This is a computer science course for the first year of \226\128\156classes\npr\195\169paratoires\226\128\157. The course begins with an introductory lesson on\nalgorithms and a description of the OCaml language. Then, several\nfundamental algorithms are described and illustrated using OCaml\nprograms. The book adopts a mathematical approach: descriptions of\nmathematical objects are related to data structures in the programming\nlanguage. This book is suitable for students with some mathematical\nbackground, and for everyone who wants to learn the bases of computer\nscience."
  ; body_html = "<p>This is a computer science course for the first year of \226\128\156classes\npr\195\169paratoires\226\128\157. The course begins with an introductory lesson on\nalgorithms and a description of the OCaml language. Then, several\nfundamental algorithms are described and illustrated using OCaml\nprograms. The book adopts a mathematical approach: descriptions of\nmathematical objects are related to data structures in the programming\nlanguage. This book is suitable for students with some mathematical\nbackground, and for everyone who wants to learn the bases of computer\nscience.</p>\n"
  };
 
  { title = "Programmation de droite \195\160 gauche et vice-versa"
  ; slug = "programmation-de-droite--gauche-et-vice-versa"
  ; description = "Programming with OCaml\n"
  ; authors = 
 ["Pascal Manoury"]
  ; language = "french"
  ; published = Some "2005"
  ; cover = Some 
 "books/manoury.png"
  ; isbn = Some "978-2-916466-05-7"
  ; links = 
 [
      { description = "Order Online from Paracamplus"
      ; uri = "https://paracamplus.com"
      }]
  ; body_md = ""
  ; body_html = ""
  };
 
  { title = "Programmation en Caml"
  ; slug = "programmation-en-caml"
  ; description = "This book is intended for beginners, who will learn basic programming notions. The first part of the book is a programming course that initiates the reader to the OCaml language.\n"
  ; authors = 
 ["Jacques Rouablé"]
  ; language = "french"
  ; published = Some "1997"
  ; cover = Some 
 "books/rouable.jpg"
  ; isbn = Some "2-212-08944-9"
  ; links = [
      { description = "Order at Amazon.fr"
      ; uri = "https://www.amazon.fr/exec/obidos/ASIN/2212089449"
      }]
  ; body_md = "This book is intended for beginners, who will learn basic programming\nnotions. The first part of the book is a programming course that\ninitiates the reader to the OCaml language. Important notions are\npresented from a practical point of view, and the implementation of some\nof these is analyzed and sketched. The second part, the \226\128\156OCaml\nworkshop\226\128\157, is a practical application of these notions to other domains\nconnected to computer science, logic, automata and grammars."
  ; body_html = "<p>This book is intended for beginners, who will learn basic programming\nnotions. The first part of the book is a programming course that\ninitiates the reader to the OCaml language. Important notions are\npresented from a practical point of view, and the implementation of some\nof these is analyzed and sketched. The second part, the \226\128\156OCaml\nworkshop\226\128\157, is a practical application of these notions to other domains\nconnected to computer science, logic, automata and grammars.</p>\n"
  };
 
  { title = "Programmation fonctionnelle, g\195\169n\195\169rique et objet: une introduction avec le langage OCaml"
  ; slug = "programmation-fonctionnelle-gnrique-et-objet-une-introduction-avec-le-langage-ocaml"
  ; description = "Programming with OCaml\n"
  ; authors = 
 ["Philippe Narbel"]
  ; language = "french"
  ; published = Some "2005"
  ; cover = Some 
 "books/narbel.jpg"
  ; isbn = Some "2-7117-4843-X"
  ; links = []
  ; body_md = ""
  ; body_html = ""
  };
 
  { title = "Programmazione funzionale, una semplice introduzione"
  ; slug = "programmazione-funzionale-una-semplice-introduzione"
  ; description = "Functional programming introduction with OCaml\n"
  ; authors = 
 ["Massimo Maria Ghisalberti"]
  ; language = "italian"
  ; published = Some 
 "2015"
  ; cover = None
  ; isbn = None
  ; links = [
      { description = "Emacs Org source"
      ; uri = "https://minimalprocedure.pragmas.org/writings/programmazione_funzionale/programmazione_funzionale.org"
      };
                                                      
      { description = "HTML"
      ; uri = "https://minimalprocedure.pragmas.org/writings/programmazione_funzionale/programmazione_funzionale.html"
      };
                                                      
      { description = "PDF"
      ; uri = "https://minimalprocedure.pragmas.org/writings/programmazione_funzionale/programmazione_funzionale.pdf"
      }]
  ; body_md = ""
  ; body_html = ""
  };
 
  { title = "Real World OCaml"
  ; slug = "real-world-ocaml"
  ; description = "Learn how to solve day-to-day problems in data processing, numerical computation, system scripting, and database-driven web applications with the OCaml multi-paradigm programming language.\n"
  ; authors = 
 ["Jason Hickey"; "Anil Madhavapeddy"; "Yaron Minsky"]
  ; language = "english"
  ; published = Some 
 "2013-11-25"
  ; cover = Some "books/real-world-ocaml.jpg"
  ; isbn = None
  ; links = 
 [
      { description = "Book Website"
      ; uri = "https://dev.realworldocaml.org/"
      };
  
      { description = "O'Reilly"
      ; uri = "https://shop.oreilly.com/product/0636920024743.do"
      };
  
      { description = "Amazon"
      ; uri = "https://www.amazon.com/Real-World-OCaml-Functional-programming/dp/144932391X/ref=tmm_pap_title_0?ie=UTF8&qid=1385006524&sr=8-1"
      }]
  ; body_md = "Learn how to solve day-to-day problems in data processing, numerical\ncomputation, system scripting, and database-driven web applications with\nthe OCaml multi-paradigm programming language. This hands-on book shows\nyou how to take advantage of OCaml\226\128\153s functional, imperative, and\nobject-oriented programming styles with recipes for many real-world\ntasks.\n\nYou\226\128\153ll start with OCaml basics, including how to set up a development\nenvironment, and move toward more advanced topics such as the module\nsystem, foreign-function interface, macro language, and the OCaml tools.\nQuickly learn how to put OCaml to work for writing succinct and\nreadable code."
  ; body_html = "<p>Learn how to solve day-to-day problems in data processing, numerical\ncomputation, system scripting, and database-driven web applications with\nthe OCaml multi-paradigm programming language. This hands-on book shows\nyou how to take advantage of OCaml\226\128\153s functional, imperative, and\nobject-oriented programming styles with recipes for many real-world\ntasks.</p>\n<p>You\226\128\153ll start with OCaml basics, including how to set up a development\nenvironment, and move toward more advanced topics such as the module\nsystem, foreign-function interface, macro language, and the OCaml tools.\nQuickly learn how to put OCaml to work for writing succinct and\nreadable code.</p>\n"
  };
 
  { title = "Seize probl\195\168mes d'informatique"
  ; slug = "seize-problmes-dinformatique"
  ; description = "This book offers sixteen problems in computer science, with detailed answers to all questions and complete solutions to algorithmic problems given as OCaml programs.\n"
  ; authors = 
 ["Bruno Petazzoni"]
  ; language = "french"
  ; published = Some "2001"
  ; cover = Some 
 "books/petazzoni.jpg"
  ; isbn = Some "3-540-67387-3"
  ; links = [
      { description = "Springer's Catalog Page"
      ; uri = "https://www.springeronline.com/sgw/cda/frontpage/0,10735,5-102-22-2042496-0,00.html"
      }]
  ; body_md = "This book offers sixteen problems in computer science, with detailed\nanswers to all questions and complete solutions to algorithmic problems\ngiven as OCaml programs. It deals mainly with automata, finite or\ninfinite words, formal language theory, and some classical algorithms\nsuch as bin-packing. It is intended for students who attend the optional\ncomputer science curriculum of the \226\128\156classes pr\195\169paratoires MPSI/MP\226\128\157. It\nshould also be useful to all teachers and computer science students up\nto a masters degree."
  ; body_html = "<p>This book offers sixteen problems in computer science, with detailed\nanswers to all questions and complete solutions to algorithmic problems\ngiven as OCaml programs. It deals mainly with automata, finite or\ninfinite words, formal language theory, and some classical algorithms\nsuch as bin-packing. It is intended for students who attend the optional\ncomputer science curriculum of the \226\128\156classes pr\195\169paratoires MPSI/MP\226\128\157. It\nshould also be useful to all teachers and computer science students up\nto a masters degree.</p>\n"
  };
 
  { title = "The Functional Approach to OCaml"
  ; slug = "the-functional-approach-to-ocaml"
  ; description = "Learning about functional programming using OCaml\n"
  ; authors = 
 ["Guy Cousineau"]
  ; language = "english"
  ; published = Some "1998"
  ; cover = Some 
 "books/cousineau-mauny-en.gif"
  ; isbn = Some "0-521-57681-4"
  ; links = 
 [
      { description = "Book Website"
      ; uri = "https://pauillac.inria.fr/cousineau-mauny/main.html"
      };
  
      { description = "Order at Amazon.com"
      ; uri = "https://www.amazon.com/exec/obidos/ASIN/0521571839/qid%3D911812711/sr%3D1-22/102-8668961-8838559"
      }]
  ; body_md = "This book uses OCaml as a tool to introduce several important\nprogramming concepts. It is divided in three parts. The first part is an\nintroduction to OCaml, which presents the language itself, but also\nintroduces evaluation by rewriting, evaluation strategies and proofs of\nprograms by induction. The second part is dedicated to the description\nof application programs which belong to various fields and might\ninterest various types of readers or students. Finally, the third part\nis dedicated to implementation. It describes interpretation and\ncompilation, with brief descriptions of memory management and type\nsynthesis."
  ; body_html = "<p>This book uses OCaml as a tool to introduce several important\nprogramming concepts. It is divided in three parts. The first part is an\nintroduction to OCaml, which presents the language itself, but also\nintroduces evaluation by rewriting, evaluation strategies and proofs of\nprograms by induction. The second part is dedicated to the description\nof application programs which belong to various fields and might\ninterest various types of readers or students. Finally, the third part\nis dedicated to implementation. It describes interpretation and\ncompilation, with brief descriptions of memory management and type\nsynthesis.</p>\n"
  };
 
  { title = "Think OCaml: How to think like a Functional Programmer"
  ; slug = "think-ocaml-how-to-think-like-a-functional-programmer"
  ; description = "Introductory programming textbook based on the OCaml language\n"
  ; authors = 
 ["Nicholas Monje"; "Allen Downey"]
  ; language = "english"
  ; published = Some 
 "2008"
  ; cover = Some "books/thinkocaml_cover_web.png"
  ; isbn = None
  ; links = 
 [
      { description = "Book Website"
      ; uri = "https://greenteapress.com/thinkocaml/index.html"
      };
  
      { description = "PDF"
      ; uri = "https://greenteapress.com/thinkocaml/thinkocaml.pdf"
      }]
  ; body_md = "This book is a work in progress. It is an introductory programming\ntextbook based on the OCaml language. It is a modified version of\nThink Python by Allen Downey. It is intended for newcomers to\nprogramming and also those who know some programming but want to learn\nprogramming in the function-oriented paradigm, or those who simply\nwant to learn OCaml."
  ; body_html = "<p>This book is a work in progress. It is an introductory programming\ntextbook based on the OCaml language. It is a modified version of\nThink Python by Allen Downey. It is intended for newcomers to\nprogramming and also those who know some programming but want to learn\nprogramming in the function-oriented paradigm, or those who simply\nwant to learn OCaml.</p>\n"
  };
 
  { title = "Unix System Programming in OCaml"
  ; slug = "unix-system-programming-in-ocaml"
  ; description = "Learn Unix system programming in OCaml\n"
  ; authors = 
 ["Xavier Leroy"; "Didier Rémy"]
  ; language = "english"
  ; published = Some 
 "2010-05-01"
  ; cover = None
  ; isbn = None
  ; links = [
      { description = "Online"
      ; uri = "https://ocaml.github.io/ocamlunix"
      }]
  ; body_md = "This is an excellent book on Unix system programming, with an emphasis\non communications between processes. The main novelty of this work is\nthe use of OCaml, instead of the C language that is customary in systems\nprogramming. This gives an unusual perspective on systems programming\nand on OCaml. It is assumed that the reader is familiar with OCaml and\nUnix shell commands."
  ; body_html = "<p>This is an excellent book on Unix system programming, with an emphasis\non communications between processes. The main novelty of this work is\nthe use of OCaml, instead of the C language that is customary in systems\nprogramming. This gives an unusual perspective on systems programming\nand on OCaml. It is assumed that the reader is familiar with OCaml and\nUnix shell commands.</p>\n"
  };
 
  { title = "Using, Understanding and Unraveling OCaml"
  ; slug = "using-understanding-and-unraveling-ocaml"
  ; description = "This book describes both the OCaml language and the theoretical grounds behind its powerful type system.\n"
  ; authors = 
 ["Didier Rémy"]
  ; language = "english"
  ; published = Some "2002-09-20"
  ; cover = None
  ; isbn = None
  ; links = 
 [
      { description = "Online"
      ; uri = "https://caml.inria.fr/pub/docs/u3-ocaml/"
      };
  
      { description = "PDF"
      ; uri = "https://caml.inria.fr/pub/docs/u3-ocaml/ocaml.pdf"
      }]
  ; body_md = "This book describes both the OCaml language and the theoretical grounds\nbehind its powerful type system. A good complement to other books on\nOCaml it is addressed to a wide audience of people interested in modern programming languages in general, ML-like languages in particular, or simply in OCaml, whether they are programmers or language designers, beginners or knowledgeable readers \226\128\148 little prerequisite is actually assumed."
  ; body_html = "<p>This book describes both the OCaml language and the theoretical grounds\nbehind its powerful type system. A good complement to other books on\nOCaml it is addressed to a wide audience of people interested in modern programming languages in general, ML-like languages in particular, or simply in OCaml, whether they are programmers or language designers, beginners or knowledgeable readers \226\128\148 little prerequisite is actually assumed.</p>\n"
  }]

