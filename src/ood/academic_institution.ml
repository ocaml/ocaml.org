
type location = { lat : float; long : float }

type course =
  { name : string
  ; acronym : string option
  ; online_resource : string option
  }

type t =
  { name : string
  ; slug : string
  ; description : string
  ; url : string
  ; logo : string option
  ; continent : string
  ; courses : course list
  ; location : location option
  ; body_md : string
  ; body_html : string
  }

let all = 
[
  { name = "Universidade da Beira Interior"
  ; slug = "universidade-da-beira-interior"
  ; description = "The University of Beira Interior is a public university located in the city of Covilh\195\163, Portugal.\n"
  ; url = "https://www.ubi.pt/en/"
  ; logo = Some 
 "academic_institution/beira.jpg"
  ; continent = "Europe"
  ; courses = 
 [
  { name = "Certified Programming"
  ; acronym = None
  ; online_resource  = Some 
  "https://www.di.ubi.pt/~desousa/PC/pc.html"
  };
  
  { name = "Computation Theory"
  ; acronym = None
  ; online_resource  = Some 
  "https://www.di.ubi.pt/~desousa/TC/tcomp.html"
  };
  
  { name = "Computational Logic"
  ; acronym = None
  ; online_resource  = Some 
  "https://www.di.ubi.pt/~desousa/LC/lc.html"
  };
  
  { name = "Functional Programming, Algorithms and Data-structures"
  ; acronym = None
  ; online_resource  = Some 
  "https://www.di.ubi.pt/~desousa/PF/pf.html"
  };
  
  { name = "Programming Languages and Compilers Design"
  ; acronym = None
  ; online_resource  = Some 
  "https://www.di.ubi.pt/~desousa/DLPC/dlpc.html"
  };
  
  { name = "Proof and Programming Theory"
  ; acronym = None
  ; online_resource  = Some 
  "https://www.di.ubi.pt/~desousa/TPP/tpp.html"
  };
  
  { name = "Software Reliability and Security"
  ; acronym = None
  ; online_resource  = Some 
  "https://www.di.ubi.pt/~desousa/CF/confia.html"
  }]
  ; location = Some 
  { long = 7.509000
  ; lat = 40.277900
  }
  
  ; body_md = ""
  ; body_html = ""
  };
 
  { name = "University of Birmingham"
  ; slug = "university-of-birmingham"
  ; description = "The University of Birmingham is a public research university located in Edgbaston, Birmingham, United Kingdom. It received its royal charter in 1900 as a successor to Queen's College, Birmingham, and Mason Science College, making it the first English civic or 'red brick' university to receive its own royal charter.\n"
  ; url = "https://www.birmingham.ac.uk/index.aspx"
  ; logo = Some 
 "academic_institution/Birmingham.jpg"
  ; continent = "Europe"
  ; courses = 
 [
  { name = "Foundations of Computer Science"
  ; acronym = Some "FOCS1112"
  ; online_resource  = Some 
  "https://sites.google.com/site/focs1112/"
  }]
  ; location = Some 
  { long = 1.930500
  ; lat = 52.450800
  }
  
  ; body_md = "\n"
  ; body_html = ""
  };
 
  { name = "Boston College"
  ; slug = "boston-college"
  ; description = "Boston College is a private, Jesuit research university in Chestnut Hill, Massachusetts. Founded in 1863, the university has more than 9,300 full-time undergraduates and nearly 5,000 graduate students. \n"
  ; url = "https://www.bc.edu/"
  ; logo = Some 
 "academic_institution/boston.png"
  ; continent = "North America"
  ; courses = 
 [
  { name = "Computer Science I"
  ; acronym = Some "CS1101"
  ; online_resource  = Some 
  "https://www.cs.bc.edu/~muller/teaching/cs1101/s16/"
  }]
  ; location = Some 
  { long = 71.168500
  ; lat = 42.335500
  }
  
  ; body_md = "\n"
  ; body_html = ""
  };
 
  { name = "University of Cambridge"
  ; slug = "university-of-cambridge"
  ; description = "The University of Cambridge is a collegiate research university in Cambridge, United Kingdom. \n"
  ; url = "https://www.cam.ac.uk/"
  ; logo = Some 
 "academic_institution/cambridge.jpg"
  ; continent = "Europe"
  ; courses = 
 [
  { name = "Advanced Functional Programming"
  ; acronym = Some "L28"
  ; online_resource  = Some 
  "https://www.cl.cam.ac.uk/teaching/1415/L28/"
  }]
  ; location = Some 
  { long = 0.114900
  ; lat = 52.204300
  }
  
  ; body_md = ""
  ; body_html = ""
  };
 
  { name = "ISAE/Supa\195\169ro"
  ; slug = "isaesuparo"
  ; description = "The Institut sup\195\169rieur de l'a\195\169ronautique et de l'espace is a French engineering school, founded in 1909. It was the world's first dedicated aerospace engineering school.\n"
  ; url = "https://www.isae-supaero.fr/en/"
  ; logo = None
  ; continent = "Europe"
  ; courses = 
 [
  { name = "Functional programming and introduction to type systems"
  ; acronym = None
  ; online_resource  = None
  }]
  ; location = Some 
  { long = 1.474600
  ; lat = 43.565900
  }
  
  ; body_md = ""
  ; body_html = ""
  };
 
  { name = "Aix-Marseille University"
  ; slug = "aix-marseille-university"
  ; description = "Aix-Marseille University is a public research university located in the region of Provence, southern France. \n"
  ; url = "https://www.univ-amu.fr/en"
  ; logo = Some 
 "academic_institution/aix.jpg"
  ; continent = "Europe"
  ; courses = 
 [
  { name = "Functional Programming"
  ; acronym = None
  ; online_resource  = None
  }]
  ; location = Some 
  { long = 5.377400
  ; lat = 43.304800
  }
  
  ; body_md = ""
  ; body_html = ""
  };
 
  { name = "Aarhus University"
  ; slug = "aarhus-university"
  ; description = "Aarhus University (Danish: Aarhus Universitet, abbreviated AU) is the largest and second oldest research university in Denmark.The university belongs to the Coimbra Group, the Guild, and Utrecht Network of European universities and is a member of the European University Association.\n"
  ; url = "https://international.au.dk/"
  ; logo = Some 
 "academic_institution/arhus.png"
  ; continent = "Europe"
  ; courses = 
 [
  { name = "The compilation course (along with Java)"
  ; acronym = None
  ; online_resource  = Some 
  "https://kursuskatalog.au.dk/en/course/100489/Compilation"
  }]
  ; location = Some 
  { long = 10.203000
  ; lat = 56.168100
  }
  
  ; body_md = "\n"
  ; body_html = ""
  };
 
  { name = "Brown University"
  ; slug = "brown-university"
  ; description = "Brown University is a private Ivy League research university in Providence, Rhode Island. \n"
  ; url = "https://www.brown.edu/"
  ; logo = Some 
 "academic_institution/brown.png"
  ; continent = "North America"
  ; courses = 
 [
  { name = "An Integrated introducion (along with Racket, Scala and Java)"
  ; acronym = Some 
  "CS 17/18"
  ; online_resource  = Some "https://cs17-spring2021.github.io/"
  }]
  ; location = Some 
  { long = 71.402500
  ; lat = 41.826800
  }
  
  ; body_md = ""
  ; body_html = ""
  };
 
  { name = "California Institute of Technology"
  ; slug = "california-institute-of-technology"
  ; description = "The California Institute of Technology is a private research university in Pasadena, California. \n"
  ; url = "https://www.caltech.edu/"
  ; logo = Some 
 "academic_institution/caltech.png"
  ; continent = "North America"
  ; courses = 
 [
  { name = "Fundamentals of Computer Programming"
  ; acronym = None
  ; online_resource  = Some 
  "https://users.cms.caltech.edu/~mvanier/"
  }]
  ; location = Some 
  { long = 118.125300
  ; lat = 34.137700
  }
  
  ; body_md = ""
  ; body_html = ""
  };
 
  { name = "Columbia University"
  ; slug = "columbia-university"
  ; description = "Columbia University is a private Ivy League research university in New York City. \n"
  ; url = "https://www.columbia.edu/"
  ; logo = Some 
 "academic_institution/columbia.png"
  ; continent = "North America"
  ; courses = 
 [
  { name = "Programming Languages and Translators"
  ; acronym = None
  ; online_resource  = Some 
  "https://www1.cs.columbia.edu/~sedwards/classes/2014/w4115-fall/index.html"
  }]
  ; location = Some 
  { long = 73.962600
  ; lat = 40.807500
  }
  
  ; body_md = "\n"
  ; body_html = ""
  };
 
  { name = "Cornell University"
  ; slug = "cornell-university"
  ; description = "Cornell University is a private, statutory, Ivy League and land-grant research university in Ithaca, New York. \n"
  ; url = "https://www.cornell.edu/"
  ; logo = Some 
 "academic_institution/cornell.png"
  ; continent = "North America"
  ; courses = 
 [
  { name = "Data Structures and Functional Programming"
  ; acronym = Some 
  "CS 3110"
  ; online_resource  = Some "https://www.cs.cornell.edu/courses/cs3110/2016fa/"
  }]
  ; location = Some 
  { long = 76.473500
  ; lat = 42.453400
  }
  
  ; body_md = ""
  ; body_html = ""
  };
 
  { name = "University Pierre & Marie Curie"
  ; slug = "university-pierre--marie-curie"
  ; description = "Pierre and Marie Curie University, titled as UPMC from 2007 to 2017 and also known as Paris 6, was a public research university in Paris, France, from 1971 to 2017. The university was located on the Jussieu Campus in the Latin Quarter of the 5th arrondissement of Paris, France. \n"
  ; url = "https://www.sorbonne-universite.fr/"
  ; logo = Some 
 "academic_institution/curie.jpg"
  ; continent = "Europe"
  ; courses = 
 [
  { name = "Types and static analysis"
  ; acronym = Some "5I555"
  ; online_resource  = Some 
  "https://www-apr.lip6.fr/~chaillou/Public/enseignement/2014-2015/tas/"
  };
  
  { name = "Models of programming and languages interoperability"
  ; acronym = Some 
  "LI332"
  ; online_resource  = Some "https://www-licence.ufr-info-p6.jussieu.fr/lmd/licence/2014/ue/LI332-2014oct/"
  }]
  ; location = Some 
  { long = 2.357500
  ; lat = 48.847100
  }
  
  ; body_md = "\n"
  ; body_html = ""
  };
 
  { name = "Epita"
  ; slug = "epita"
  ; description = "The \195\137cole Pour l'Informatique et les Techniques Avanc\195\169es, more commonly known as EPITA, is a private French grande \195\169cole specialized in the field of computer science and software engineering created in 1984 by Patrice Dumoucel. \n"
  ; url = "https://www.epita.fr/"
  ; logo = None
  ; continent = "Europe"
  ; courses = 
 [
  { name = "Introduction to Algorithms (Year 1 & 2)"
  ; acronym = None
  ; online_resource  = None
  }]
  ; location = Some 
  { long = 2.362800
  ; lat = 48.815700
  }
  
  ; body_md = ""
  ; body_html = ""
  };
 
  { name = "Harvard University"
  ; slug = "harvard-university"
  ; description = "Harvard University is a private Ivy League research university in Cambridge, Massachusetts. higher education academy. \n"
  ; url = "https://www.harvard.edu/"
  ; logo = Some 
 "academic_institution/harvard.png"
  ; continent = "North America"
  ; courses = 
 [
  { name = "Principles of Programming Language Compilation"
  ; acronym = Some 
  "CS153"
  ; online_resource  = None
  };
  
  { name = "Introduction to Computer Science II- Abstraction & Design"
  ; acronym = Some 
  "CS51"
  ; online_resource  = None
  }]
  ; location = Some 
  { long = 71.116700
  ; lat = 42.377000
  }
  
  ; body_md = "\n"
  ; body_html = ""
  };
 
  { name = "Indian Institute of Technology, Delhi"
  ; slug = "indian-institute-of-technology-delhi"
  ; description = "Indian Institute of Technology Delhi is a public technical and research university located in Hauz Khas in South Delhi, Delhi, India. \n"
  ; url = "https://home.iitd.ac.in/"
  ; logo = Some 
 "academic_institution/iitd.png"
  ; continent = "Asia"
  ; courses = 
 [
  { name = "Introduction to Computers and Programming (along with Pascal and Java)"
  ; acronym = Some 
  "CSL 101"
  ; online_resource  = Some "https://www.cse.iitd.ac.in/~ssen/csl101/details.html"
  }]
  ; location = Some 
  { long = 77.192800
  ; lat = 28.545700
  }
  
  ; body_md = ""
  ; body_html = ""
  };
 
  { name = "University of Illinois at Urbana-Champaign"
  ; slug = "university-of-illinois-at-urbana-champaign"
  ; description = "The University of Illinois Urbana-Champaign is a public land-grant research university in Illinois in the twin cities of Champaign and Urbana.\n"
  ; url = "https://illinois.edu/"
  ; logo = Some 
 "academic_institution/illinois.jpeg"
  ; continent = "North America"
  ; courses = 
 [
  { name = "Programming Languages and Compilers"
  ; acronym = Some 
  "CS 421"
  ; online_resource  = Some "https://courses.engr.illinois.edu/cs421/fa2014/"
  }]
  ; location = Some 
  { long = 88.227200
  ; lat = 40.102000
  }
  
  ; body_md = "\n"
  ; body_html = ""
  };
 
  { name = "University of Innsbruck"
  ; slug = "university-of-innsbruck"
  ; description = "The University of Innsbruck is a public university in Innsbruck, the capital of the Austrian federal state of Tyrol, founded in 1669. \n"
  ; url = "https://www.uibk.ac.at/index.html.en"
  ; logo = Some 
 "academic_institution/university-of-innsbruck-logo.jpg"
  ; continent = "Europe"
  ; courses = 
 [
  { name = "Programming in OCAML"
  ; acronym = Some "SS 06"
  ; online_resource  = Some 
  "https://cl-informatik.uibk.ac.at/teaching/ss06/ocaml/schedule.php"
  }]
  ; location = Some 
  { long = 11.404100
  ; lat = 47.269200
  }
  
  ; body_md = ""
  ; body_html = ""
  };
 
  { name = "University of California, Los Angeles"
  ; slug = "university-of-california-los-angeles"
  ; description = "The University of California, Los Angeles is a public land-grant research university in Los Angeles, California.\n"
  ; url = "https://www.ucla.edu/"
  ; logo = Some 
 "academic_institution/ucla.jpg"
  ; continent = "North America"
  ; courses = 
 [
  { name = "Programming Languages (along with Python and Java)"
  ; acronym = Some 
  "CS 131"
  ; online_resource  = Some "https://web.cs.ucla.edu/classes/winter18/cs131/"
  }]
  ; location = Some 
  { long = 118.445200
  ; lat = 34.068900
  }
  
  ; body_md = ""
  ; body_html = ""
  };
 
  { name = "University of Maryland"
  ; slug = "university-of-maryland"
  ; description = "The University of Maryland, College Park is a public land-grant research university in College Park, Maryland.\n"
  ; url = "https://www.umd.edu/"
  ; logo = Some 
 "academic_institution/maryland.gif"
  ; continent = "North America"
  ; courses = 
 [
  { name = "Organization of Programming Languages-(along with Ruby, Prolog, Java)"
  ; acronym = Some 
  "CMSC 330"
  ; online_resource  = Some "https://www.cs.umd.edu/class/fall2014/cmsc330/"
  }]
  ; location = Some 
  { long = 76.942600
  ; lat = 38.986900
  }
  
  ; body_md = ""
  ; body_html = ""
  };
 
  { name = "University of Massachusetts"
  ; slug = "university-of-massachusetts"
  ; description = "The University of Massachusetts is the five-campus public university system and the only public research system in the Commonwealth of Massachusetts. \n"
  ; url = "https://www.massachusetts.edu/"
  ; logo = None
  ; continent = "North America"
  ; courses = 
 [
  { name = "Programming Languages"
  ; acronym = Some "CS691F"
  ; online_resource  = Some 
  "https://people.cs.umass.edu/~arjun/courses/cs691f/"
  }]
  ; location = None
  ; body_md = ""
  ; body_html = ""
  };
 
  { name = "McGill University"
  ; slug = "mcgill-university"
  ; description = "McGill University is a public research university located in Montreal, Quebec, Canada.\n"
  ; url = "https://www.mcgill.ca/"
  ; logo = Some 
 "academic_institution/mcgill_logo.png"
  ; continent = "North America"
  ; courses = 
 [
  { name = "Programming Languages and Paradigms"
  ; acronym = Some 
  "COMP 302"
  ; online_resource  = Some "https://www.cs.mcgill.ca/~bpientka/cs302/"
  }]
  ; location = Some 
  { long = 73.577200
  ; lat = 45.504800
  }
  
  ; body_md = "\n\n\n"
  ; body_html = ""
  };
 
  { name = "Universit\195\169 Paris-Diderot"
  ; slug = "universit-paris-diderot"
  ; description = "Paris Diderot University, also known as Paris 7, was a French university located in Paris, France. It was one of the seven universities of the Paris public higher education academy. \n"
  ; url = "https://u-paris.fr/en/"
  ; logo = None
  ; continent = "Europe"
  ; courses = 
 [
  { name = "Advanced Functional Programming"
  ; acronym = Some "PFAV"
  ; online_resource  = Some 
  "https://www.dicosmo.org/CourseNotes/pfav/"
  };
  
  { name = "Functional Programming"
  ; acronym = Some "PF5"
  ; online_resource  = Some 
  "https://www.irif.fr/~treinen/teaching/pf5/"
  }]
  ; location = Some 
  { long = 2.382200
  ; lat = 48.827600
  }
  
  ; body_md = ""
  ; body_html = ""
  };
 
  { name = "University of Pennsylvania"
  ; slug = "university-of-pennsylvania"
  ; description = "The University of Pennsylvania is a private Ivy League research university in Philadelphia, Pennsylvania.\n"
  ; url = "https://www.upenn.edu/"
  ; logo = Some 
 "academic_institution/penn.png"
  ; continent = "North America"
  ; courses = 
 [
  { name = "Compilers"
  ; acronym = Some "CIS341"
  ; online_resource  = Some 
  "https://www.cis.upenn.edu/~cis341/current/"
  };
  
  { name = "Programming Languages and Techniques I"
  ; acronym = Some 
  "CIS120"
  ; online_resource  = Some "https://www.seas.upenn.edu/~cis120/current/"
  }]
  ; location = Some 
  { long = 75.193200
  ; lat = 39.952200
  }
  
  ; body_md = ""
  ; body_html = ""
  };
 
  { name = "Princeton University"
  ; slug = "princeton-university"
  ; description = "Princeton University is a private Ivy League research university in Princeton, New Jersey. \n"
  ; url = "https://www.princeton.edu/"
  ; logo = Some 
 "academic_institution/princeton.png"
  ; continent = "North America"
  ; courses = 
 [
  { name = "Functional Programming"
  ; acronym = Some "COS 326"
  ; online_resource  = Some 
  "https://www.cs.princeton.edu/courses/archive/fall14/cos326//"
  }]
  ; location = Some 
  { long = 74.655100
  ; lat = 40.343100
  }
  
  ; body_md = ""
  ; body_html = ""
  };
 
  { name = "University of Rennes 1"
  ; slug = "university-of-rennes-1"
  ; description = "The University of Rennes 1 is a public university located in the city of Rennes, France. It is under the Academy of Rennes. \n"
  ; url = "https://international.univ-rennes1.fr/en/welcome-universite-de-rennes-1"
  ; logo = Some 
 "academic_institution/reness.png"
  ; continent = "Europe"
  ; courses = 
 [
  { name = "Compilation"
  ; acronym = Some "COMP"
  ; online_resource  = None
  };
  
  { name = "Semantics"
  ; acronym = Some "SEM"
  ; online_resource  = None
  };
  
  { name = "Programming 2"
  ; acronym = Some "PRG2"
  ; online_resource  = None
  }]
  ; location = Some 
  { long = 1.673000
  ; lat = 48.115900
  }
  
  ; body_md = ""
  ; body_html = ""
  };
 
  { name = "Rice University"
  ; slug = "rice-university"
  ; description = "William Marsh Rice University, commonly known as Rice University, is a private research university in Houston, Texas. \n"
  ; url = "https://www.rice.edu/"
  ; logo = Some 
 "academic_institution/rice.jpg"
  ; continent = "North America"
  ; courses = 
 [
  { name = "Principles of Programming Languages"
  ; acronym = Some 
  "COMP 311"
  ; online_resource  = Some "https://www.cs.rice.edu/~javaplt/311/info.html"
  }]
  ; location = Some 
  { long = 95.401800
  ; lat = 29.717400
  }
  
  ; body_md = ""
  ; body_html = ""
  };
 
  { name = "University of California, San Diego"
  ; slug = "university-of-california-san-diego"
  ; description = "The University of California, San Diego(UC San Diego or, colloquially, UCSD) is a public land-grant research university in San Diego, California.\n"
  ; url = "https://ucsd.edu/"
  ; logo = Some 
 "academic_institution/ucsd_logo.png"
  ; continent = "North America"
  ; courses = 
 [
  { name = "Programming Languages Principles and Paradigms (along with Python and Prolog)"
  ; acronym = Some 
  "CSE130-a"
  ; online_resource  = Some "https://cseweb.ucsd.edu/classes/wi14/cse130-a/"
  }]
  ; location = Some 
  { long = 117.234000
  ; lat = 32.880100
  }
  
  ; body_md = ""
  ; body_html = ""
  };
 
  { name = "University of Minnesota Twin Cities"
  ; slug = "university-of-minnesota-twin-cities"
  ; description = "The University of Minnesota, Twin Cities is a public land-grant research university in the Twin Cities of Minneapolis and Saint Paul, Minnesota. \n"
  ; url = "https://twin-cities.umn.edu/"
  ; logo = None
  ; continent = "North America"
  ; courses = 
 [
  { name = "Advanced Programming Principles"
  ; acronym = Some "CSCI 2041"
  ; online_resource  = Some 
  "https://www-users.cs.umn.edu/~kauffman/2041/syllabus.html"
  }]
  ; location = Some 
  { long = 93.227700
  ; lat = 44.974000
  }
  
  ; body_md = ""
  ; body_html = ""
  };
 
  { name = "University of Massachusetts Amherst"
  ; slug = "university-of-massachusetts-amherst"
  ; description = "The University of Massachusetts Amherst is a public land-grant research university in Amherst, Massachusetts. \n"
  ; url = "https://www.umass.edu/"
  ; logo = Some 
 "academic_institution/umas.jpeg"
  ; continent = "North America"
  ; courses = 
 [
  { name = "University of Massachusetts Amherst"
  ; acronym = Some 
  "CMPSCI 631"
  ; online_resource  = Some "https://people.cs.umass.edu/~arjun/main/teaching/631/"
  }]
  ; location = Some 
  { long = 72.530100
  ; lat = 42.386800
  }
  
  ; body_md = ""
  ; body_html = ""
  };
 
  { name = "University of Virginia"
  ; slug = "university-of-virginia"
  ; description = "The University of Virginia is a public research university in Charlottesville, Virginia. \n"
  ; url = "https://www.virginia.edu/"
  ; logo = Some 
 "academic_institution/virginia.png"
  ; continent = "North America"
  ; courses = 
 [
  { name = "Programming Languages"
  ; acronym = Some "CS 4610"
  ; online_resource  = None
  }]
  ; location = Some 
  { long = 78.508000
  ; lat = 38.033600
  }
  
  ; body_md = ""
  ; body_html = ""
  };
 
  { name = "University of Wroc\197\130aw"
  ; slug = "university-of-wrocaw"
  ; description = "The University of Wroc\197\130aw is a public research university located in Wroc\197\130aw, Poland. \n"
  ; url = "https://uni.wroc.pl/en/"
  ; logo = Some 
 "academic_institution/wroclaw.jpg"
  ; continent = "Europe"
  ; courses = 
 [
  { name = "Functional Programming"
  ; acronym = None
  ; online_resource  = Some 
  "https://ii.uni.wroc.pl/~lukstafi/pmwiki/index.php?n=Functional.Functional"
  }]
  ; location = Some 
  { long = 17.034500
  ; lat = 51.114000
  }
  
  ; body_md = ""
  ; body_html = ""
  }]

