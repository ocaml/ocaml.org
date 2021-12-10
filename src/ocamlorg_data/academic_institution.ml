
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

let all_en = 
[
  { name = {js|Universidade da Beira Interior|js}
  ; slug = {js|universidade-da-beira-interior|js}
  ; description = {js|The University of Beira Interior is a public university located in the city of Covilhã, Portugal.
|js}
  ; url = {js|https://www.ubi.pt/en/|js}
  ; logo = Some {js|/academic_institution/beira.jpg|js}
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Certified Programming|js}
  ; acronym = None
  ; online_resource  = Some {js|https://www.di.ubi.pt/~desousa/PC/pc.html|js}
  };
  
  { name = {js|Computation Theory|js}
  ; acronym = None
  ; online_resource  = Some {js|https://www.di.ubi.pt/~desousa/TC/tcomp.html|js}
  };
  
  { name = {js|Computational Logic|js}
  ; acronym = None
  ; online_resource  = Some {js|https://www.di.ubi.pt/~desousa/LC/lc.html|js}
  };
  
  { name = {js|Functional Programming, Algorithms and Data-structures|js}
  ; acronym = None
  ; online_resource  = Some {js|https://www.di.ubi.pt/~desousa/PF/pf.html|js}
  };
  
  { name = {js|Programming Languages and Compilers Design|js}
  ; acronym = None
  ; online_resource  = Some {js|https://www.di.ubi.pt/~desousa/DLPC/dlpc.html|js}
  };
  
  { name = {js|Proof and Programming Theory|js}
  ; acronym = None
  ; online_resource  = Some {js|https://www.di.ubi.pt/~desousa/TPP/tpp.html|js}
  };
  
  { name = {js|Software Reliability and Security|js}
  ; acronym = None
  ; online_resource  = Some {js|https://www.di.ubi.pt/~desousa/CF/confia.html|js}
  }]
  ; location = Some 
  { long = -7.509000
  ; lat = 40.277900
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|University of Birmingham|js}
  ; slug = {js|university-of-birmingham|js}
  ; description = {js|The University of Birmingham is a public research university located in Edgbaston, Birmingham, United Kingdom. It received its royal charter in 1900 as a successor to Queen's College, Birmingham, and Mason Science College, making it the first English civic or 'red brick' university to receive its own royal charter.
|js}
  ; url = {js|https://www.birmingham.ac.uk/index.aspx|js}
  ; logo = Some {js|/academic_institution/Birmingham.jpg|js}
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Foundations of Computer Science|js}
  ; acronym = Some {js|FOCS1112|js}
  ; online_resource  = Some {js|https://sites.google.com/site/focs1112/|js}
  }]
  ; location = Some 
  { long = -1.930500
  ; lat = 52.450800
  }
  
  ; body_md = {js|
|js}
  ; body_html = {js||js}
  };
 
  { name = {js|Boston College|js}
  ; slug = {js|boston-college|js}
  ; description = {js|Boston College is a private, Jesuit research university in Chestnut Hill, Massachusetts. Founded in 1863, the university has more than 9,300 full-time undergraduates and nearly 5,000 graduate students. 
|js}
  ; url = {js|https://www.bc.edu/|js}
  ; logo = Some {js|/academic_institution/boston.png|js}
  ; continent = {js|North America|js}
  ; courses = 
 [
  { name = {js|Computer Science I|js}
  ; acronym = Some {js|CS1101|js}
  ; online_resource  = Some {js|https://www.cs.bc.edu/~muller/teaching/cs1101/s16/|js}
  }]
  ; location = Some 
  { long = -71.168500
  ; lat = 42.335500
  }
  
  ; body_md = {js|
|js}
  ; body_html = {js||js}
  };
 
  { name = {js|University of Cambridge|js}
  ; slug = {js|university-of-cambridge|js}
  ; description = {js|The University of Cambridge is a collegiate research university in Cambridge, United Kingdom. 
|js}
  ; url = {js|https://www.cam.ac.uk/|js}
  ; logo = Some {js|/academic_institution/cambridge.jpg|js}
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Advanced Functional Programming|js}
  ; acronym = Some {js|L28|js}
  ; online_resource  = Some {js|https://www.cl.cam.ac.uk/teaching/1415/L28/|js}
  }]
  ; location = Some 
  { long = 0.114900
  ; lat = 52.204300
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|ISAE/Supaéro|js}
  ; slug = {js|isaesuparo|js}
  ; description = {js|The Institut supérieur de l'aéronautique et de l'espace is a French engineering school, founded in 1909. It was the world's first dedicated aerospace engineering school.
|js}
  ; url = {js|https://www.isae-supaero.fr/en/|js}
  ; logo = Some {js|/academic_institution/isae.png|js}
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Functional programming and introduction to type systems|js}
  ; acronym = None
  ; online_resource  = None
  }]
  ; location = Some 
  { long = 1.474600
  ; lat = 43.565900
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Aix-Marseille University|js}
  ; slug = {js|aix-marseille-university|js}
  ; description = {js|Aix-Marseille University is a public research university located in the region of Provence, southern France. 
|js}
  ; url = {js|https://www.univ-amu.fr/en|js}
  ; logo = Some {js|/academic_institution/aix.jpg|js}
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Functional Programming|js}
  ; acronym = None
  ; online_resource  = None
  }]
  ; location = Some 
  { long = 5.377400
  ; lat = 43.304800
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Aarhus University|js}
  ; slug = {js|aarhus-university|js}
  ; description = {js|Aarhus University (Danish: Aarhus Universitet, abbreviated AU) is the largest and second oldest research university in Denmark.The university belongs to the Coimbra Group, the Guild, and Utrecht Network of European universities and is a member of the European University Association.
|js}
  ; url = {js|https://international.au.dk/|js}
  ; logo = Some {js|/academic_institution/arhus.png|js}
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|The compilation course (along with Java)|js}
  ; acronym = None
  ; online_resource  = Some {js|https://kursuskatalog.au.dk/en/course/100489/Compilation|js}
  }]
  ; location = Some 
  { long = 10.203000
  ; lat = 56.168100
  }
  
  ; body_md = {js|
|js}
  ; body_html = {js||js}
  };
 
  { name = {js|Brown University|js}
  ; slug = {js|brown-university|js}
  ; description = {js|Brown University is a private Ivy League research university in Providence, Rhode Island. 
|js}
  ; url = {js|https://www.brown.edu/|js}
  ; logo = Some {js|/academic_institution/brown.png|js}
  ; continent = {js|North America|js}
  ; courses = 
 [
  { name = {js|An Integrated introducion (along with Racket, Scala and Java)|js}
  ; acronym = Some {js|CS 17/18|js}
  ; online_resource  = Some {js|https://cs17-spring2021.github.io/|js}
  }]
  ; location = Some 
  { long = -71.402500
  ; lat = 41.826800
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|California Institute of Technology|js}
  ; slug = {js|california-institute-of-technology|js}
  ; description = {js|The California Institute of Technology is a private research university in Pasadena, California. 
|js}
  ; url = {js|https://www.caltech.edu/|js}
  ; logo = Some {js|/academic_institution/caltech.png|js}
  ; continent = {js|North America|js}
  ; courses = 
 [
  { name = {js|Fundamentals of Computer Programming|js}
  ; acronym = None
  ; online_resource  = Some {js|https://users.cms.caltech.edu/~mvanier/|js}
  }]
  ; location = Some 
  { long = -118.125300
  ; lat = 34.137700
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Columbia University|js}
  ; slug = {js|columbia-university|js}
  ; description = {js|Columbia University is a private Ivy League research university in New York City. 
|js}
  ; url = {js|https://www.columbia.edu/|js}
  ; logo = Some {js|/academic_institution/columbia.png|js}
  ; continent = {js|North America|js}
  ; courses = 
 [
  { name = {js|Programming Languages and Translators|js}
  ; acronym = None
  ; online_resource  = Some {js|https://www1.cs.columbia.edu/~sedwards/classes/2014/w4115-fall/index.html|js}
  }]
  ; location = Some 
  { long = -73.962600
  ; lat = 40.807500
  }
  
  ; body_md = {js|
|js}
  ; body_html = {js||js}
  };
 
  { name = {js|Cornell University|js}
  ; slug = {js|cornell-university|js}
  ; description = {js|Cornell University is a private, statutory, Ivy League and land-grant research university in Ithaca, New York. 
|js}
  ; url = {js|https://www.cornell.edu/|js}
  ; logo = Some {js|/academic_institution/cornell.png|js}
  ; continent = {js|North America|js}
  ; courses = 
 [
  { name = {js|Data Structures and Functional Programming|js}
  ; acronym = Some {js|CS 3110|js}
  ; online_resource  = Some {js|https://www.cs.cornell.edu/courses/cs3110/2016fa/|js}
  }]
  ; location = Some 
  { long = -76.473500
  ; lat = 42.453400
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|University Pierre & Marie Curie|js}
  ; slug = {js|university-pierre--marie-curie|js}
  ; description = {js|Pierre and Marie Curie University, titled as UPMC from 2007 to 2017 and also known as Paris 6, was a public research university in Paris, France, from 1971 to 2017. The university was located on the Jussieu Campus in the Latin Quarter of the 5th arrondissement of Paris, France. 
|js}
  ; url = {js|https://www.sorbonne-universite.fr/|js}
  ; logo = Some {js|/academic_institution/curie.jpg|js}
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Types and static analysis|js}
  ; acronym = Some {js|5I555|js}
  ; online_resource  = Some {js|https://www-apr.lip6.fr/~chaillou/Public/enseignement/2014-2015/tas/|js}
  };
  
  { name = {js|Models of programming and languages interoperability|js}
  ; acronym = Some {js|LI332|js}
  ; online_resource  = Some {js|https://www-licence.ufr-info-p6.jussieu.fr/lmd/licence/2014/ue/LI332-2014oct/|js}
  }]
  ; location = Some 
  { long = 2.357500
  ; lat = 48.847100
  }
  
  ; body_md = {js|
|js}
  ; body_html = {js||js}
  };
 
  { name = {js|Epita|js}
  ; slug = {js|epita|js}
  ; description = {js|The École Pour l'Informatique et les Techniques Avancées, more commonly known as EPITA, is a private French grande école specialized in the field of computer science and software engineering created in 1984 by Patrice Dumoucel. 
|js}
  ; url = {js|https://www.epita.fr/|js}
  ; logo = Some {js|/academic_institution/epita.png|js}
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Introduction to Algorithms (Year 1 & 2)|js}
  ; acronym = None
  ; online_resource  = None
  }]
  ; location = Some 
  { long = 2.362800
  ; lat = 48.815700
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Harvard University|js}
  ; slug = {js|harvard-university|js}
  ; description = {js|Harvard University is a private Ivy League research university in Cambridge, Massachusetts. higher education academy. 
|js}
  ; url = {js|https://www.harvard.edu/|js}
  ; logo = Some {js|/academic_institution/harvard.png|js}
  ; continent = {js|North America|js}
  ; courses = 
 [
  { name = {js|Principles of Programming Language Compilation|js}
  ; acronym = Some {js|CS153|js}
  ; online_resource  = None
  };
  
  { name = {js|Introduction to Computer Science II- Abstraction & Design|js}
  ; acronym = Some {js|CS51|js}
  ; online_resource  = None
  }]
  ; location = Some 
  { long = -71.116700
  ; lat = 42.377000
  }
  
  ; body_md = {js|
|js}
  ; body_html = {js||js}
  };
 
  { name = {js|Indian Institute of Technology, Delhi|js}
  ; slug = {js|indian-institute-of-technology-delhi|js}
  ; description = {js|Indian Institute of Technology Delhi is a public technical and research university located in Hauz Khas in South Delhi, Delhi, India. 
|js}
  ; url = {js|https://home.iitd.ac.in/|js}
  ; logo = Some {js|/academic_institution/iitd.png|js}
  ; continent = {js|Asia|js}
  ; courses = 
 [
  { name = {js|Introduction to Computers and Programming (along with Pascal and Java)|js}
  ; acronym = Some {js|CSL 101|js}
  ; online_resource  = Some {js|https://www.cse.iitd.ac.in/~ssen/csl101/details.html|js}
  }]
  ; location = Some 
  { long = 77.192800
  ; lat = 28.545700
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Indian Institute of Technology, Madras|js}
  ; slug = {js|indian-institute-of-technology-madras|js}
  ; description = {js|Indian Institute of Technology Madras is a public technical and research university located in Chennai, India.
|js}
  ; url = {js|https://www.iitm.ac.in/|js}
  ; logo = Some {js|/academic_institution/iitm.png|js}
  ; continent = {js|Asia|js}
  ; courses = 
 [
  { name = {js|Paradigms of Programming|js}
  ; acronym = Some {js|CS 3100|js}
  ; online_resource  = Some {js|https://kcsrk.info/cs3100_m20/|js}
  }]
  ; location = Some 
  { long = 80.233620
  ; lat = 12.991510
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|University of Illinois at Urbana-Champaign|js}
  ; slug = {js|university-of-illinois-at-urbana-champaign|js}
  ; description = {js|The University of Illinois Urbana-Champaign is a public land-grant research university in Illinois in the twin cities of Champaign and Urbana.
|js}
  ; url = {js|https://illinois.edu/|js}
  ; logo = Some {js|/academic_institution/illinois.jpeg|js}
  ; continent = {js|North America|js}
  ; courses = 
 [
  { name = {js|Programming Languages and Compilers|js}
  ; acronym = Some {js|CS 421|js}
  ; online_resource  = Some {js|https://courses.engr.illinois.edu/cs421/fa2014/|js}
  }]
  ; location = Some 
  { long = -88.227200
  ; lat = 40.102000
  }
  
  ; body_md = {js|
|js}
  ; body_html = {js||js}
  };
 
  { name = {js|University of Innsbruck|js}
  ; slug = {js|university-of-innsbruck|js}
  ; description = {js|The University of Innsbruck is a public university in Innsbruck, the capital of the Austrian federal state of Tyrol, founded in 1669. 
|js}
  ; url = {js|https://www.uibk.ac.at/index.html.en|js}
  ; logo = Some {js|/academic_institution/university-of-innsbruck-logo.jpg|js}
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Programming in OCAML|js}
  ; acronym = Some {js|SS 06|js}
  ; online_resource  = Some {js|https://cl-informatik.uibk.ac.at/teaching/ss06/ocaml/schedule.php|js}
  }]
  ; location = Some 
  { long = 11.404100
  ; lat = 47.269200
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|University of California, Los Angeles|js}
  ; slug = {js|university-of-california-los-angeles|js}
  ; description = {js|The University of California, Los Angeles is a public land-grant research university in Los Angeles, California.
|js}
  ; url = {js|https://www.ucla.edu/|js}
  ; logo = Some {js|/academic_institution/ucla.jpg|js}
  ; continent = {js|North America|js}
  ; courses = 
 [
  { name = {js|Programming Languages (along with Python and Java)|js}
  ; acronym = Some {js|CS 131|js}
  ; online_resource  = Some {js|https://web.cs.ucla.edu/classes/winter18/cs131/|js}
  }]
  ; location = Some 
  { long = -118.445200
  ; lat = 34.068900
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|University of Maryland|js}
  ; slug = {js|university-of-maryland|js}
  ; description = {js|The University of Maryland, College Park is a public land-grant research university in College Park, Maryland.
|js}
  ; url = {js|https://www.umd.edu/|js}
  ; logo = Some {js|/academic_institution/maryland.gif|js}
  ; continent = {js|North America|js}
  ; courses = 
 [
  { name = {js|Organization of Programming Languages-(along with Ruby, Prolog, Java)|js}
  ; acronym = Some {js|CMSC 330|js}
  ; online_resource  = Some {js|https://www.cs.umd.edu/class/fall2014/cmsc330/|js}
  }]
  ; location = Some 
  { long = -76.942600
  ; lat = 38.986900
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|University of Massachusetts|js}
  ; slug = {js|university-of-massachusetts|js}
  ; description = {js|The University of Massachusetts is the five-campus public university system and the only public research system in the Commonwealth of Massachusetts. 
|js}
  ; url = {js|https://www.massachusetts.edu/|js}
  ; logo = Some {js|/academic_institution/massachusetts.png|js}
  ; continent = {js|North America|js}
  ; courses = 
 [
  { name = {js|Programming Languages|js}
  ; acronym = Some {js|CS691F|js}
  ; online_resource  = Some {js|https://people.cs.umass.edu/~arjun/courses/cs691f/|js}
  }]
  ; location = Some 
  { long = -71.036500
  ; lat = 42.314200
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|McGill University|js}
  ; slug = {js|mcgill-university|js}
  ; description = {js|McGill University is a public research university located in Montreal, Quebec, Canada.
|js}
  ; url = {js|https://www.mcgill.ca/|js}
  ; logo = Some {js|/academic_institution/mcgill_logo.png|js}
  ; continent = {js|North America|js}
  ; courses = 
 [
  { name = {js|Programming Languages and Paradigms|js}
  ; acronym = Some {js|COMP 302|js}
  ; online_resource  = Some {js|https://www.cs.mcgill.ca/~bpientka/cs302/|js}
  }]
  ; location = Some 
  { long = -73.577200
  ; lat = 45.504800
  }
  
  ; body_md = {js|


|js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université Paris-Diderot|js}
  ; slug = {js|universit-paris-diderot|js}
  ; description = {js|Paris Diderot University, also known as Paris 7, was a French university located in Paris, France. It was one of the seven universities of the Paris public higher education academy. 
|js}
  ; url = {js|https://u-paris.fr/en/|js}
  ; logo = Some {js|/academic_institution/paris.jpg|js}
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Advanced Functional Programming|js}
  ; acronym = Some {js|PFAV|js}
  ; online_resource  = Some {js|https://www.dicosmo.org/CourseNotes/pfav/|js}
  };
  
  { name = {js|Functional Programming|js}
  ; acronym = Some {js|PF5|js}
  ; online_resource  = Some {js|https://www.irif.fr/~treinen/teaching/pf5/|js}
  }]
  ; location = Some 
  { long = 2.382200
  ; lat = 48.827600
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|University of Pennsylvania|js}
  ; slug = {js|university-of-pennsylvania|js}
  ; description = {js|The University of Pennsylvania is a private Ivy League research university in Philadelphia, Pennsylvania.
|js}
  ; url = {js|https://www.upenn.edu/|js}
  ; logo = Some {js|/academic_institution/penn.png|js}
  ; continent = {js|North America|js}
  ; courses = 
 [
  { name = {js|Compilers|js}
  ; acronym = Some {js|CIS341|js}
  ; online_resource  = Some {js|https://www.cis.upenn.edu/~cis341/current/|js}
  };
  
  { name = {js|Programming Languages and Techniques I|js}
  ; acronym = Some {js|CIS120|js}
  ; online_resource  = Some {js|https://www.seas.upenn.edu/~cis120/current/|js}
  }]
  ; location = Some 
  { long = -75.193200
  ; lat = 39.952200
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Princeton University|js}
  ; slug = {js|princeton-university|js}
  ; description = {js|Princeton University is a private Ivy League research university in Princeton, New Jersey. 
|js}
  ; url = {js|https://www.princeton.edu/|js}
  ; logo = Some {js|/academic_institution/princeton.png|js}
  ; continent = {js|North America|js}
  ; courses = 
 [
  { name = {js|Functional Programming|js}
  ; acronym = Some {js|COS 326|js}
  ; online_resource  = Some {js|https://www.cs.princeton.edu/courses/archive/fall14/cos326//|js}
  }]
  ; location = Some 
  { long = -74.655100
  ; lat = 40.343100
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|University of Rennes 1|js}
  ; slug = {js|university-of-rennes-1|js}
  ; description = {js|The University of Rennes 1 is a public university located in the city of Rennes, France. It is under the Academy of Rennes. 
|js}
  ; url = {js|https://international.univ-rennes1.fr/en/welcome-universite-de-rennes-1|js}
  ; logo = Some {js|/academic_institution/reness.png|js}
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Compilation|js}
  ; acronym = Some {js|COMP|js}
  ; online_resource  = None
  };
  
  { name = {js|Semantics|js}
  ; acronym = Some {js|SEM|js}
  ; online_resource  = None
  };
  
  { name = {js|Programming 2|js}
  ; acronym = Some {js|PRG2|js}
  ; online_resource  = None
  }]
  ; location = Some 
  { long = -1.673000
  ; lat = 48.115900
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Rice University|js}
  ; slug = {js|rice-university|js}
  ; description = {js|William Marsh Rice University, commonly known as Rice University, is a private research university in Houston, Texas. 
|js}
  ; url = {js|https://www.rice.edu/|js}
  ; logo = Some {js|/academic_institution/rice.jpg|js}
  ; continent = {js|North America|js}
  ; courses = 
 [
  { name = {js|Principles of Programming Languages|js}
  ; acronym = Some {js|COMP 311|js}
  ; online_resource  = Some {js|https://www.cs.rice.edu/~javaplt/311/info.html|js}
  }]
  ; location = Some 
  { long = -95.401800
  ; lat = 29.717400
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|University of California, San Diego|js}
  ; slug = {js|university-of-california-san-diego|js}
  ; description = {js|The University of California, San Diego(UC San Diego or, colloquially, UCSD) is a public land-grant research university in San Diego, California.
|js}
  ; url = {js|https://ucsd.edu/|js}
  ; logo = Some {js|/academic_institution/ucsd_logo.png|js}
  ; continent = {js|North America|js}
  ; courses = 
 [
  { name = {js|Programming Languages Principles and Paradigms (along with Python and Prolog)|js}
  ; acronym = Some {js|CSE130-a|js}
  ; online_resource  = Some {js|https://cseweb.ucsd.edu/classes/wi14/cse130-a/|js}
  }]
  ; location = Some 
  { long = -117.234000
  ; lat = 32.880100
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|University of Minnesota Twin Cities|js}
  ; slug = {js|university-of-minnesota-twin-cities|js}
  ; description = {js|The University of Minnesota, Twin Cities is a public land-grant research university in the Twin Cities of Minneapolis and Saint Paul, Minnesota. 
|js}
  ; url = {js|https://twin-cities.umn.edu/|js}
  ; logo = Some {js|/academic_institution/twin.svg|js}
  ; continent = {js|North America|js}
  ; courses = 
 [
  { name = {js|Advanced Programming Principles|js}
  ; acronym = Some {js|CSCI 2041|js}
  ; online_resource  = Some {js|https://www-users.cs.umn.edu/~kauffman/2041/syllabus.html|js}
  }]
  ; location = Some 
  { long = -93.227700
  ; lat = 44.974000
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|University of Massachusetts Amherst|js}
  ; slug = {js|university-of-massachusetts-amherst|js}
  ; description = {js|The University of Massachusetts Amherst is a public land-grant research university in Amherst, Massachusetts. 
|js}
  ; url = {js|https://www.umass.edu/|js}
  ; logo = Some {js|/academic_institution/umas.jpeg|js}
  ; continent = {js|North America|js}
  ; courses = 
 [
  { name = {js|University of Massachusetts Amherst|js}
  ; acronym = Some {js|CMPSCI 631|js}
  ; online_resource  = Some {js|https://people.cs.umass.edu/~arjun/main/teaching/631/|js}
  }]
  ; location = Some 
  { long = -72.530100
  ; lat = 42.386800
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|University of Virginia|js}
  ; slug = {js|university-of-virginia|js}
  ; description = {js|The University of Virginia is a public research university in Charlottesville, Virginia. 
|js}
  ; url = {js|https://www.virginia.edu/|js}
  ; logo = Some {js|/academic_institution/virginia.png|js}
  ; continent = {js|North America|js}
  ; courses = 
 [
  { name = {js|Programming Languages|js}
  ; acronym = Some {js|CS 4610|js}
  ; online_resource  = None
  }]
  ; location = Some 
  { long = -78.508000
  ; lat = 38.033600
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|University of Wrocław|js}
  ; slug = {js|university-of-wrocaw|js}
  ; description = {js|The University of Wrocław is a public research university located in Wrocław, Poland. 
|js}
  ; url = {js|https://uni.wroc.pl/en/|js}
  ; logo = Some {js|/academic_institution/wroclaw.jpg|js}
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Functional Programming|js}
  ; acronym = None
  ; online_resource  = Some {js|https://ii.uni.wroc.pl/~lukstafi/pmwiki/index.php?n=Functional.Functional|js}
  }]
  ; location = Some 
  { long = 17.034500
  ; lat = 51.114000
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  }]

let all_fr = 
[
  { name = {js|Université de Beira Interior|js}
  ; slug = {js|universit-de-beira-interior|js}
  ; description = {js|L'Université de Beira Interior est une université publique localisée dans la ville de Covilhã au Portugal.
|js}
  ; url = {js|https://www.ubi.pt/en/|js}
  ; logo = Some {js|/academic_institution/beira.jpg|js}
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Certified Programming|js}
  ; acronym = None
  ; online_resource  = Some {js|https://www.di.ubi.pt/~desousa/PC/pc.html|js}
  };
  
  { name = {js|Computation Theory|js}
  ; acronym = None
  ; online_resource  = Some {js|https://www.di.ubi.pt/~desousa/TC/tcomp.html|js}
  };
  
  { name = {js|Computational Logic|js}
  ; acronym = None
  ; online_resource  = Some {js|https://www.di.ubi.pt/~desousa/LC/lc.html|js}
  };
  
  { name = {js|Functional Programming, Algorithms and Data-structures|js}
  ; acronym = None
  ; online_resource  = Some {js|https://www.di.ubi.pt/~desousa/PF/pf.html|js}
  };
  
  { name = {js|Programming Languages and Compilers Design|js}
  ; acronym = None
  ; online_resource  = Some {js|https://www.di.ubi.pt/~desousa/DLPC/dlpc.html|js}
  };
  
  { name = {js|Proof and Programming Theory|js}
  ; acronym = None
  ; online_resource  = Some {js|https://www.di.ubi.pt/~desousa/TPP/tpp.html|js}
  };
  
  { name = {js|Software Reliability and Security|js}
  ; acronym = None
  ; online_resource  = Some {js|https://www.di.ubi.pt/~desousa/CF/confia.html|js}
  }]
  ; location = Some 
  { long = -7.509000
  ; lat = 40.277900
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université de Birmingham|js}
  ; slug = {js|universit-de-birmingham|js}
  ; description = {js|L'Université de Birmingham est une université publique de recherche localisée dans le quartier d'Edgbastion à Birmingham au Royaume-Uni. Elle a reçu sa charte royale en 1900 en tant que successeuse du Queen's College de Birmingham et du Mason Science College, en faisant la première université civique anglaise ou 'redbrick' à recevoir sa propre charte royale.
|js}
  ; url = {js|https://www.birmingham.ac.uk/index.aspx|js}
  ; logo = Some {js|/academic_institution/Birmingham.jpg|js}
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Foundations of Computer Science|js}
  ; acronym = Some {js|FOCS1112|js}
  ; online_resource  = Some {js|https://sites.google.com/site/focs1112/|js}
  }]
  ; location = Some 
  { long = -1.930500
  ; lat = 52.450800
  }
  
  ; body_md = {js|
|js}
  ; body_html = {js||js}
  };
 
  { name = {js|Boston College|js}
  ; slug = {js|boston-college|js}
  ; description = {js|Le Boston College est une université Jésuite privée de recherche de Chestnut Hill dans le Massachusetts. Fondée en 1863, l'université a plus de 9300 étudiants et étudiantes en licence à temps plein et presque 5000 étudiants et étudiantes en master.
|js}
  ; url = {js|https://www.bc.edu/|js}
  ; logo = Some {js|/academic_institution/boston.png|js}
  ; continent = {js|Amérique du Nord|js}
  ; courses = 
 [
  { name = {js|Computer Science I|js}
  ; acronym = Some {js|CS1101|js}
  ; online_resource  = Some {js|https://www.cs.bc.edu/~muller/teaching/cs1101/s16/|js}
  }]
  ; location = Some 
  { long = -71.168500
  ; lat = 42.335500
  }
  
  ; body_md = {js|
|js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université de Cambridge|js}
  ; slug = {js|universit-de-cambridge|js}
  ; description = {js|L'Université de Cambridge est une université de recherche collégiale de Cambridge au Royaume-Uni.
|js}
  ; url = {js|https://www.cam.ac.uk/|js}
  ; logo = Some {js|/academic_institution/cambridge.jpg|js}
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Advanced Functional Programming|js}
  ; acronym = Some {js|L28|js}
  ; online_resource  = Some {js|https://www.cl.cam.ac.uk/teaching/1415/L28/|js}
  }]
  ; location = Some 
  { long = 0.114900
  ; lat = 52.204300
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|ISAE / Supaéro|js}
  ; slug = {js|isae--suparo|js}
  ; description = {js|L'Institut Supérieur de l'Aéronautique et de l'Espace est une école d'ingénieur française, fondée en 1909. C'était la première école au monde à être dédiée à l'ingénierie de l'aérospatiale.
|js}
  ; url = {js|https://www.isae-supaero.fr/en/|js}
  ; logo = None
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Functional programming and introduction to type systems|js}
  ; acronym = None
  ; online_resource  = None
  }]
  ; location = Some 
  { long = 1.474600
  ; lat = 43.565900
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université d'Aix-Marseille|js}
  ; slug = {js|universit-daix-marseille|js}
  ; description = {js|L'Université d'Aix-Marseille est une université publique de recherche localisée dans la région PACA, dans le sud de la France.
|js}
  ; url = {js|https://www.univ-amu.fr/en|js}
  ; logo = Some {js|/academic_institution/aix.jpg|js}
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Programmation Fonctionnelle|js}
  ; acronym = None
  ; online_resource  = None
  }]
  ; location = Some 
  { long = 5.377400
  ; lat = 43.304800
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université d'Aarhus|js}
  ; slug = {js|universit-daarhus|js}
  ; description = {js|L'Université d'Aarhus (Danois: Aarhus Universitet, abréviation AU) est la plus grande et la seconde plus vieille université de recherche au Danemark. L'université appartient au Groupe de Coimbra, à la Guilde des universités européennes de recherche, au réseau d'Utrecht des universités européennes et est membre de l'Association des universités européennes.
|js}
  ; url = {js|https://international.au.dk/|js}
  ; logo = Some {js|/academic_institution/arhus.png|js}
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Compilation (avec Java)|js}
  ; acronym = None
  ; online_resource  = Some {js|https://kursuskatalog.au.dk/en/course/100489/Compilation|js}
  }]
  ; location = Some 
  { long = 10.203000
  ; lat = 56.168100
  }
  
  ; body_md = {js|
|js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université de Brown|js}
  ; slug = {js|universit-de-brown|js}
  ; description = {js|L'Université de Brown est une université privée de recherche de la Ivy League de Providence dans l'état de Rhode Island.
|js}
  ; url = {js|https://www.brown.edu/|js}
  ; logo = Some {js|/academic_institution/brown.png|js}
  ; continent = {js|Amérique du Nord|js}
  ; courses = 
 [
  { name = {js|An Integrated introducion (avec Racket, Scala et Java)|js}
  ; acronym = Some {js|CS 17/18|js}
  ; online_resource  = Some {js|https://cs17-spring2021.github.io/|js}
  }]
  ; location = Some 
  { long = -71.402500
  ; lat = 41.826800
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Insitut de Technologie de Californie|js}
  ; slug = {js|insitut-de-technologie-de-californie|js}
  ; description = {js|L'Institut de Technologie de Californie est une université privée de recherche de Pasadena en Californie.
|js}
  ; url = {js|https://www.caltech.edu/|js}
  ; logo = Some {js|/academic_institution/caltech.png|js}
  ; continent = {js|Amérique du Nord|js}
  ; courses = 
 [
  { name = {js|Fundamentals of Computer Programming|js}
  ; acronym = None
  ; online_resource  = Some {js|https://users.cms.caltech.edu/~mvanier/|js}
  }]
  ; location = Some 
  { long = -118.125300
  ; lat = 34.137700
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université de Columbia|js}
  ; slug = {js|universit-de-columbia|js}
  ; description = {js|L'Université de Columbia est une université privée de recherche de la Ivy League de la ville de New York.
|js}
  ; url = {js|https://www.columbia.edu/|js}
  ; logo = Some {js|/academic_institution/columbia.png|js}
  ; continent = {js|Amérique du Nord|js}
  ; courses = 
 [
  { name = {js|Programming Languages and Translators|js}
  ; acronym = None
  ; online_resource  = Some {js|https://www1.cs.columbia.edu/~sedwards/classes/2014/w4115-fall/index.html|js}
  }]
  ; location = Some 
  { long = -73.962600
  ; lat = 40.807500
  }
  
  ; body_md = {js|
|js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université de Cornell|js}
  ; slug = {js|universit-de-cornell|js}
  ; description = {js|L'Université de Cornell est une université "land-grant" de recherche privée, statutaire, appartenant à la Ivy League d'Ithaca dans l'état de New York.
|js}
  ; url = {js|https://www.cornell.edu/|js}
  ; logo = Some {js|/academic_institution/cornell.png|js}
  ; continent = {js|Amérique du Nord|js}
  ; courses = 
 [
  { name = {js|Data Structures and Functional Programming|js}
  ; acronym = Some {js|CS 3110|js}
  ; online_resource  = Some {js|https://www.cs.cornell.edu/courses/cs3110/2016fa/|js}
  }]
  ; location = Some 
  { long = -76.473500
  ; lat = 42.453400
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université Pierre & Marie Curie|js}
  ; slug = {js|universit-pierre--marie-curie|js}
  ; description = {js|L'Université Pierre et Marie Curie, intitulée UMPC de 2007 à 2017 et aussi connue comme Paris 6, était une université publique de recherche de Paris en France, de 1971 à 2017. L'université était localisée dans le campus Jussieu du Quartien Latin dans le 5ème arrondissement de Paris en France.
|js}
  ; url = {js|https://www.sorbonne-universite.fr/|js}
  ; logo = Some {js|/academic_institution/curie.jpg|js}
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Typage et Analyse statique|js}
  ; acronym = Some {js|5I555|js}
  ; online_resource  = Some {js|https://www-apr.lip6.fr/~chaillou/Public/enseignement/2014-2015/tas/|js}
  };
  
  { name = {js|Modèles de Programmation et Interopérabilité des Langages|js}
  ; acronym = Some {js|LI332|js}
  ; online_resource  = Some {js|https://www-licence.ufr-info-p6.jussieu.fr/lmd/licence/2014/ue/LI332-2014oct/|js}
  }]
  ; location = Some 
  { long = 2.357500
  ; lat = 48.847100
  }
  
  ; body_md = {js|
|js}
  ; body_html = {js||js}
  };
 
  { name = {js|Epita|js}
  ; slug = {js|epita|js}
  ; description = {js|L'École Pour l'Informatique et les Techniques Avancées, plus communément connue comme EPITA, est une grande école privée française spécialisée dans le domaine de l'informatique et de l'ingénierie logicielle, créée en 1984 par Patrice Dumoucel.
|js}
  ; url = {js|https://www.epita.fr/|js}
  ; logo = None
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Introduction to Algorithms (Year 1 & 2)|js}
  ; acronym = None
  ; online_resource  = None
  }]
  ; location = Some 
  { long = 2.362800
  ; lat = 48.815700
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université d'Harvard|js}
  ; slug = {js|universit-dharvard|js}
  ; description = {js|L'Université d'Harvard est une université privée de recherche de la Ivy League située à Cambridge dans l'état du Massachusetts.
|js}
  ; url = {js|https://www.harvard.edu/|js}
  ; logo = Some {js|/academic_institution/harvard.png|js}
  ; continent = {js|Amérique du Nord|js}
  ; courses = 
 [
  { name = {js|Principles of Programming Language Compilation|js}
  ; acronym = Some {js|CS153|js}
  ; online_resource  = None
  };
  
  { name = {js|Introduction to Computer Science II- Abstraction & Design|js}
  ; acronym = Some {js|CS51|js}
  ; online_resource  = None
  }]
  ; location = Some 
  { long = -71.116700
  ; lat = 42.377000
  }
  
  ; body_md = {js|
|js}
  ; body_html = {js||js}
  };
 
  { name = {js|Institut Indien de Technologie de Delhi|js}
  ; slug = {js|institut-indien-de-technologie-de-delhi|js}
  ; description = {js|L'Institut Indien de Technology de Delhi est une université publique, technique et de recherche localisée dans le quartier de Hauz Khas au sud de Delhi en Inde.
|js}
  ; url = {js|https://home.iitd.ac.in/|js}
  ; logo = Some {js|/academic_institution/iitd.png|js}
  ; continent = {js|Asie|js}
  ; courses = 
 [
  { name = {js|Introduction to Computers and Programming (along with Pascal and Java)|js}
  ; acronym = Some {js|CSL 101|js}
  ; online_resource  = Some {js|https://www.cse.iitd.ac.in/~ssen/csl101/details.html|js}
  }]
  ; location = Some 
  { long = 77.192800
  ; lat = 28.545700
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Institut Indien de Technologie de Madras|js}
  ; slug = {js|institut-indien-de-technologie-de-madras|js}
  ; description = {js|L'Institut Indien de Technologie de Madras est une université publique, technique et de recherche localisée à Chennai en Inde.
|js}
  ; url = {js|https://www.iitm.ac.in/|js}
  ; logo = Some {js|/academic_institution/iitm.png|js}
  ; continent = {js|Asie|js}
  ; courses = 
 [
  { name = {js|Paradigms of Programming|js}
  ; acronym = Some {js|CS 3100|js}
  ; online_resource  = Some {js|https://kcsrk.info/cs3100_m20/|js}
  }]
  ; location = Some 
  { long = 80.233620
  ; lat = 12.991510
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université de l'Illinois Urbana-Champaign|js}
  ; slug = {js|universit-de-lillinois-urbana-champaign|js}
  ; description = {js|L'Université de l'Illinois Urbana-Champaign est une université "land-grant" publique de recherche de l'état de l'Illinois dans les villes jumelles de Champaign et d'Urbana.
|js}
  ; url = {js|https://illinois.edu/|js}
  ; logo = Some {js|/academic_institution/illinois.jpeg|js}
  ; continent = {js|Amérique du Nord|js}
  ; courses = 
 [
  { name = {js|Programming Languages and Compilers|js}
  ; acronym = Some {js|CS 421|js}
  ; online_resource  = Some {js|https://courses.engr.illinois.edu/cs421/fa2014/|js}
  }]
  ; location = Some 
  { long = -88.227200
  ; lat = 40.102000
  }
  
  ; body_md = {js|
|js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université d'Innsbruck|js}
  ; slug = {js|universit-dinnsbruck|js}
  ; description = {js|L'Université d'Innsbruck est une université publique d'Innsbruck, la capitale de l'état fédéral autrichien du Tyrol, fondée en 1669
|js}
  ; url = {js|https://www.uibk.ac.at/index.html.en|js}
  ; logo = Some {js|/academic_institution/university-of-innsbruck-logo.jpg|js}
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Programming in OCAML|js}
  ; acronym = Some {js|SS 06|js}
  ; online_resource  = Some {js|https://cl-informatik.uibk.ac.at/teaching/ss06/ocaml/schedule.php|js}
  }]
  ; location = Some 
  { long = 11.404100
  ; lat = 47.269200
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université de Californie de Los Angeles|js}
  ; slug = {js|universit-de-californie-de-los-angeles|js}
  ; description = {js|L'Université de Californie de Los Angeles est une université "land-grant" publique de recherche de Los Angeles en Californie.
|js}
  ; url = {js|https://www.ucla.edu/|js}
  ; logo = Some {js|/academic_institution/ucla.jpg|js}
  ; continent = {js|Amérique du Nord|js}
  ; courses = 
 [
  { name = {js|Programming Languages (avec Python et Java)|js}
  ; acronym = Some {js|CS 131|js}
  ; online_resource  = Some {js|https://web.cs.ucla.edu/classes/winter18/cs131/|js}
  }]
  ; location = Some 
  { long = -118.445200
  ; lat = 34.068900
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université du Maryland|js}
  ; slug = {js|universit-du-maryland|js}
  ; description = {js|L'Université du Maryland de College Park est une université "land-grant" publique de recherche à College Park dans le Maryland.
|js}
  ; url = {js|https://www.umd.edu/|js}
  ; logo = Some {js|/academic_institution/maryland.gif|js}
  ; continent = {js|Amérique du Nord|js}
  ; courses = 
 [
  { name = {js|Organization of Programming Languages (avec Ruby, Prolog, Java)|js}
  ; acronym = Some {js|CMSC 330|js}
  ; online_resource  = Some {js|https://www.cs.umd.edu/class/fall2014/cmsc330/|js}
  }]
  ; location = Some 
  { long = -76.942600
  ; lat = 38.986900
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université du Massachusetts|js}
  ; slug = {js|universit-du-massachusetts|js}
  ; description = {js|L'Université du Massachusetts est un système universitaire publique à cinq campus et le seul système de recherche publique dans le Commonwealth du Massachusetts.
|js}
  ; url = {js|https://www.massachusetts.edu/|js}
  ; logo = None
  ; continent = {js|Amérique du Nord|js}
  ; courses = 
 [
  { name = {js|Programming Languages|js}
  ; acronym = Some {js|CS691F|js}
  ; online_resource  = Some {js|https://people.cs.umass.edu/~arjun/courses/cs691f/|js}
  }]
  ; location = Some 
  { long = -71.036500
  ; lat = 42.314200
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université McGill|js}
  ; slug = {js|universit-mcgill|js}
  ; description = {js|L'Université McGill est une université publique de recherche localisée à Montréal dans l'état de Québec au Canada.
|js}
  ; url = {js|https://www.mcgill.ca/|js}
  ; logo = Some {js|/academic_institution/mcgill_logo.png|js}
  ; continent = {js|Amérique du Nord|js}
  ; courses = 
 [
  { name = {js|Programming Languages and Paradigms|js}
  ; acronym = Some {js|COMP 302|js}
  ; online_resource  = Some {js|https://www.cs.mcgill.ca/~bpientka/cs302/|js}
  }]
  ; location = Some 
  { long = -73.577200
  ; lat = 45.504800
  }
  
  ; body_md = {js|


|js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université Paris-Diderot|js}
  ; slug = {js|universit-paris-diderot|js}
  ; description = {js|L'Université Paris Diderot, aussi connue sous le nom de Paris 7, était une université française localisée à Paris en France. C'était l'une des sept universités de l'académie de l'enseignement supérieur de Paris. Aujourd'hui, elle appartient à l'Université de Paris.
|js}
  ; url = {js|https://u-paris.fr/en/|js}
  ; logo = None
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Programmation Fonctionnelle Avancées|js}
  ; acronym = Some {js|PFAV|js}
  ; online_resource  = Some {js|https://www.dicosmo.org/CourseNotes/pfav/|js}
  };
  
  { name = {js|Programmation Fonctionnelle|js}
  ; acronym = Some {js|PF5|js}
  ; online_resource  = Some {js|https://www.irif.fr/~treinen/teaching/pf5/|js}
  }]
  ; location = Some 
  { long = 2.382200
  ; lat = 48.827600
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université de Pennsylvanie|js}
  ; slug = {js|universit-de-pennsylvanie|js}
  ; description = {js|L'Université de Pennsylvanie une université privée de recherche de la Ivy League à Philadelphie, en Pennsylvanie.
|js}
  ; url = {js|https://www.upenn.edu/|js}
  ; logo = Some {js|/academic_institution/penn.png|js}
  ; continent = {js|Amérique du Nord|js}
  ; courses = 
 [
  { name = {js|Compilers|js}
  ; acronym = Some {js|CIS341|js}
  ; online_resource  = Some {js|https://www.cis.upenn.edu/~cis341/current/|js}
  };
  
  { name = {js|Programming Languages and Techniques I|js}
  ; acronym = Some {js|CIS120|js}
  ; online_resource  = Some {js|https://www.seas.upenn.edu/~cis120/current/|js}
  }]
  ; location = Some 
  { long = -75.193200
  ; lat = 39.952200
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université de Princeton|js}
  ; slug = {js|universit-de-princeton|js}
  ; description = {js|L'Université de Princeton est une université privée de recherche de la Ivy League à Princeton dans l'état du New Jersey.
|js}
  ; url = {js|https://www.princeton.edu/|js}
  ; logo = Some {js|/academic_institution/princeton.png|js}
  ; continent = {js|Amérique du Nord|js}
  ; courses = 
 [
  { name = {js|Functional Programming|js}
  ; acronym = Some {js|COS 326|js}
  ; online_resource  = Some {js|https://www.cs.princeton.edu/courses/archive/fall14/cos326//|js}
  }]
  ; location = Some 
  { long = -74.655100
  ; lat = 40.343100
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université de Rennes 1|js}
  ; slug = {js|universit-de-rennes-1|js}
  ; description = {js|L'Université de Rennes 1 est une université publique localisée dans la ville de Rennes en France. Elle appartient à l'Académie de Rennes.
|js}
  ; url = {js|https://international.univ-rennes1.fr/en/welcome-universite-de-rennes-1|js}
  ; logo = Some {js|/academic_institution/reness.png|js}
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Compilation|js}
  ; acronym = Some {js|COMP|js}
  ; online_resource  = None
  };
  
  { name = {js|Semantiques|js}
  ; acronym = Some {js|SEM|js}
  ; online_resource  = None
  };
  
  { name = {js|Programmtion 2|js}
  ; acronym = Some {js|PRG2|js}
  ; online_resource  = None
  }]
  ; location = Some 
  { long = -1.673000
  ; lat = 48.115900
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université Rice|js}
  ; slug = {js|universit-rice|js}
  ; description = {js|L'Université William Marsh Rice, généralement connue comme l'Université Rice, est une université privée de recherche à Houston au Texas.
|js}
  ; url = {js|https://www.rice.edu/|js}
  ; logo = Some {js|/academic_institution/rice.jpg|js}
  ; continent = {js|Amérique du Nord|js}
  ; courses = 
 [
  { name = {js|Principles of Programming Languages|js}
  ; acronym = Some {js|COMP 311|js}
  ; online_resource  = Some {js|https://www.cs.rice.edu/~javaplt/311/info.html|js}
  }]
  ; location = Some 
  { long = -95.401800
  ; lat = 29.717400
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université de Californie à San Diego|js}
  ; slug = {js|universit-de-californie--san-diego|js}
  ; description = {js|L'Université de Californie à San Diego (UC San Diego ou, familièrement, UCSD) est une université "land-grant" publique de recherche à San Diego en Californie.
|js}
  ; url = {js|https://ucsd.edu/|js}
  ; logo = Some {js|/academic_institution/ucsd_logo.png|js}
  ; continent = {js|Amérique du Nord|js}
  ; courses = 
 [
  { name = {js|Programming Languages Principles and Paradigms (avec Python et Prolog)|js}
  ; acronym = Some {js|CSE130-a|js}
  ; online_resource  = Some {js|https://cseweb.ucsd.edu/classes/wi14/cse130-a/|js}
  }]
  ; location = Some 
  { long = -117.234000
  ; lat = 32.880100
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université du Minnesota, Twin Cities|js}
  ; slug = {js|universit-du-minnesota-twin-cities|js}
  ; description = {js|L'Université du Minnesota, Twin Cities est une université "land-grant" publique de recherche dans les villes jumelles de Minneapolis et Saint Paul dans le Minnesota.
|js}
  ; url = {js|https://twin-cities.umn.edu/|js}
  ; logo = None
  ; continent = {js|Amérique du Nord|js}
  ; courses = 
 [
  { name = {js|Advanced Programming Principles|js}
  ; acronym = Some {js|CSCI 2041|js}
  ; online_resource  = Some {js|https://www-users.cs.umn.edu/~kauffman/2041/syllabus.html|js}
  }]
  ; location = Some 
  { long = -93.227700
  ; lat = 44.974000
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université du Massachusetts de Amherst|js}
  ; slug = {js|universit-du-massachusetts-de-amherst|js}
  ; description = {js|L'Université du Massachusetts de Amherst est une université "land-grant" publique de recherche à Amherst dans l'état du Massachusetts.
|js}
  ; url = {js|https://www.umass.edu/|js}
  ; logo = Some {js|/academic_institution/umas.jpeg|js}
  ; continent = {js|Amérique du Nord|js}
  ; courses = 
 [
  { name = {js|University of Massachusetts Amherst|js}
  ; acronym = Some {js|CMPSCI 631|js}
  ; online_resource  = Some {js|https://people.cs.umass.edu/~arjun/main/teaching/631/|js}
  }]
  ; location = Some 
  { long = -72.530100
  ; lat = 42.386800
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université de Virginie|js}
  ; slug = {js|universit-de-virginie|js}
  ; description = {js|L'Université de Virgine est une université publique de recherche de Charlottesville en Virgine.
|js}
  ; url = {js|https://www.virginia.edu/|js}
  ; logo = Some {js|/academic_institution/virginia.png|js}
  ; continent = {js|Amérique du Nord|js}
  ; courses = 
 [
  { name = {js|Programming Languages|js}
  ; acronym = Some {js|CS 4610|js}
  ; online_resource  = None
  }]
  ; location = Some 
  { long = -78.508000
  ; lat = 38.033600
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  };
 
  { name = {js|Université de Wrocław|js}
  ; slug = {js|universit-de-wrocaw|js}
  ; description = {js|L'Université de Wrocław est une université publique de recherche localisée à Wrocław en Pologne.
|js}
  ; url = {js|https://uni.wroc.pl/en/|js}
  ; logo = Some {js|/academic_institution/wroclaw.jpg|js}
  ; continent = {js|Europe|js}
  ; courses = 
 [
  { name = {js|Functional Programming|js}
  ; acronym = None
  ; online_resource  = Some {js|https://ii.uni.wroc.pl/~lukstafi/pmwiki/index.php?n=Functional.Functional|js}
  }]
  ; location = Some 
  { long = 17.034500
  ; lat = 51.114000
  }
  
  ; body_md = {js||js}
  ; body_html = {js||js}
  }]

