
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
  ; logo = None
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
  ; logo = None
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
  ; logo = None
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

