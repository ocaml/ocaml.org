
type t =
  { name : string
  ; slug : string
  ; description : string
  ; image : string option
  ; site : string
  ; locations : string list
  ; consortium : bool
  ; body_md : string
  ; body_html : string
  }

let all = 
[
  { name = "Aesthetic Integration"
  ; slug = "aesthetic-integration"
  ; description = "Aesthetic Integration (AI) is a financial technology startup based in the City of London\n"
  ; image = Some 
 "users/aesthetic-integration.png"
  ; site = "https://www.aestheticintegration.com"
  ; locations = 
 ["United Kingdom"]
  ; consortium = true
  ; body_md = "\nAesthetic Integration (AI) is a financial technology startup based in the City of London. AI's patent-pending formal verification technology is revolutionising the safety, stability and transparency of global financial markets.\n"
  ; body_html = "<p>Aesthetic Integration (AI) is a financial technology startup based in the City of London. AI's patent-pending formal verification technology is revolutionising the safety, stability and transparency of global financial markets.</p>\n"
  };
 
  { name = "Ahrefs"
  ; slug = "ahrefs"
  ; description = "Ahrefs develops custom distributed petabyte-scale storage and runs an internet-wide crawler to collect the index of the whole Web\n"
  ; image = Some 
 "users/ahrefs.png"
  ; site = "https://www.ahrefs.com"
  ; locations = 
 ["Singapore"; "United States"]
  ; consortium = true
  ; body_md = "\nAhrefs develops custom distributed petabyte-scale storage and runs an internet-wide crawler to collect the index of the whole Web. On top of that the company is building various analytical services for end-users. OCaml is the main language of the Ahrefs backend, which is currently processing up to 6 billion pages a day. Ahrefs is a multinational team with roots from Ukraine and offices in Singapore and San Francisco.\n"
  ; body_html = "<p>Ahrefs develops custom distributed petabyte-scale storage and runs an internet-wide crawler to collect the index of the whole Web. On top of that the company is building various analytical services for end-users. OCaml is the main language of the Ahrefs backend, which is currently processing up to 6 billion pages a day. Ahrefs is a multinational team with roots from Ukraine and offices in Singapore and San Francisco.</p>\n"
  };
 
  { name = "American Museum of Natural History"
  ; slug = "american-museum-of-natural-history"
  ; description = "The Computational Sciences Department at the AMNH has been using OCaml for almost a decade in their software package POY for phylogenetic inference\n"
  ; image = Some 
 "users/amnh.png"
  ; site = "https://www.amnh.org/our-research/computational-sciences"
  ; locations = 
 ["United States"]
  ; consortium = false
  ; body_md = "\nThe Computational Sciences Department at the AMNH has been using OCaml for almost a decade in their software package [POY](https://github.com/amnh/poy5) for phylogenetic inference. See [AMNH's GitHub page](https://github.com/AMNH) for more projects.\n"
  ; body_html = "<p>The Computational Sciences Department at the AMNH has been using OCaml for almost a decade in their software package <a href=\"https://github.com/amnh/poy5\">POY</a> for phylogenetic inference. See <a href=\"https://github.com/AMNH\">AMNH's GitHub page</a> for more projects.</p>\n"
  };
 
  { name = "ANSSI"
  ; slug = "anssi"
  ; description = "The ANSSI core missions are: to detect and react to cyber attacks, to prevent threats, to provide advice and support to governmental entities and operators of critical infrastructure, and to keep companies and the general public informed about information security threats\n"
  ; image = Some 
 "users/anssi.png"
  ; site = "https://www.ssi.gouv.fr/"
  ; locations = 
 ["France"]
  ; consortium = false
  ; body_md = "\nThe ANSSI core missions are: to detect and react to cyber attacks, to prevent threats, to provide advice and support to governmental entities and operators of critical infrastructure, and to keep companies and the general public informed about information security threats. See [ANSII's GitHub page](https://github.com/anssi-fr) for some of its OCaml software.\n"
  ; body_html = "<p>The ANSSI core missions are: to detect and react to cyber attacks, to prevent threats, to provide advice and support to governmental entities and operators of critical infrastructure, and to keep companies and the general public informed about information security threats. See <a href=\"https://github.com/anssi-fr\">ANSII's GitHub page</a> for some of its OCaml software.</p>\n"
  };
 
  { name = "Arena"
  ; slug = "arena"
  ; description = "Arena helps organizations hire the right people.\n"
  ; image = Some 
 "users/arena.jpg"
  ; site = "https://www.arena.io"
  ; locations = 
 ["United States"]
  ; consortium = false
  ; body_md = "\nArena helps organizations hire the right people. We do that by applying big data and predictive analytics to the hiring process. This results in less turnover for our clients and less discrimination for individuals. We use OCaml for all of our backend development."
  ; body_html = "<p>Arena helps organizations hire the right people. We do that by applying big data and predictive analytics to the hiring process. This results in less turnover for our clients and less discrimination for individuals. We use OCaml for all of our backend development.</p>\n"
  };
 
  { name = "Be Sport"
  ; slug = "be-sport"
  ; description = "Be Sport's mission is to enhance the value that sport brings to our lives with appropriate use of digital and social media innovations\n"
  ; image = Some 
 "users/besport.png"
  ; site = "https://besport.com/"
  ; locations = 
 ["France"]
  ; consortium = true
  ; body_md = "\nBe Sport's mission is to enhance the value that sport brings to our lives with appropriate use of digital and social media innovations.\n           \nBe Sport is a 100% [OCaml](//ocaml.org/) and [OCsigen](https://ocsigen.org) project, leveraged as the only building blocks to develop the platform. \n"
  ; body_html = "<p>Be Sport's mission is to enhance the value that sport brings to our lives with appropriate use of digital and social media innovations.</p>\n<p>Be Sport is a 100% <a href=\"//ocaml.org/\">OCaml</a> and <a href=\"https://ocsigen.org\">OCsigen</a> project, leveraged as the only building blocks to develop the platform.</p>\n"
  };
 
  { name = "Bloomberg L.P."
  ; slug = "bloomberg-lp"
  ; description = "Bloomberg, the global business and financial information and news leader, gives influential decision makers a critical edge by connecting them to a dynamic network of information, people and ideas\n"
  ; image = Some 
 "users/bloomberg.jpg"
  ; site = "https://www.bloomberg.com"
  ; locations = 
 ["United States"]
  ; consortium = true
  ; body_md = "\nBloomberg, the global business and financial information and news leader, gives influential decision makers a critical edge by connecting them to a dynamic network of information, people and ideas. Bloomberg employs OCaml in an advanced financial derivatives risk management application delivered through its Bloomberg Professional service."
  ; body_html = "<p>Bloomberg, the global business and financial information and news leader, gives influential decision makers a critical edge by connecting them to a dynamic network of information, people and ideas. Bloomberg employs OCaml in an advanced financial derivatives risk management application delivered through its Bloomberg Professional service.</p>\n"
  };
 
  { name = "CACAOWEB"
  ; slug = "cacaoweb"
  ; description = "Cacaoweb is developing an application platform of a new kind. It runs on top of our peer-to-peer network, which happens to be one of the largest in the world\n"
  ; image = Some 
 "users/cacaoweb.png"
  ; site = "https://cacaoweb.org/"
  ; locations = 
 ["United Kingdom"; "Hong Kong"]
  ; consortium = false
  ; body_md = "\nCacaoweb is developing an application platform of a new kind. It runs on top of our peer-to-peer network, which happens to be one of the largest in the world. The capabilities of the platform are diverse and range from multimedia streaming to social communication, offline storage or data synchronisation. We design and implement massively distributed data stores, programming languages, runtime systems and parallel computation frameworks.\n"
  ; body_html = "<p>Cacaoweb is developing an application platform of a new kind. It runs on top of our peer-to-peer network, which happens to be one of the largest in the world. The capabilities of the platform are diverse and range from multimedia streaming to social communication, offline storage or data synchronisation. We design and implement massively distributed data stores, programming languages, runtime systems and parallel computation frameworks.</p>\n"
  };
 
  { name = "CEA"
  ; slug = "cea"
  ; description = "CEA is a French state company, member of the OCaml Consortium.\n"
  ; image = Some 
 "users/cea.png"
  ; site = "https://cea.fr/"
  ; locations = ["France"]
  ; consortium = true
  ; body_md = "\nCEA is a French state company, member of the OCaml Consortium. It uses OCaml mainly to develop a platform dedicated to source-code analysis of C software, called [Frama-C](https://frama-c.com).\n"
  ; body_html = "<p>CEA is a French state company, member of the OCaml Consortium. It uses OCaml mainly to develop a platform dedicated to source-code analysis of C software, called <a href=\"https://frama-c.com\">Frama-C</a>.</p>\n"
  };
 
  { name = "Citrix"
  ; slug = "citrix"
  ; description = "Citrix uses OCaml in XenServer, a world-class server virtualization system.\n"
  ; image = Some 
 "users/citrix.png"
  ; site = "https://www.citrix.com"
  ; locations = 
 ["United Kingdom"]
  ; consortium = true
  ; body_md = "\nCitrix uses OCaml in XenServer, a world-class server virtualization system. Most components of XenServer are released as open source. The open-source XenServer toolstack components implemented in OCaml are bundled in the [XS-opam](https://github.com/xapi-project/xs-opam) repository on GitHub.\n"
  ; body_html = "<p>Citrix uses OCaml in XenServer, a world-class server virtualization system. Most components of XenServer are released as open source. The open-source XenServer toolstack components implemented in OCaml are bundled in the <a href=\"https://github.com/xapi-project/xs-opam\">XS-opam</a> repository on GitHub.</p>\n"
  };
 
  { name = "Coherent Graphics Ltd"
  ; slug = "coherent-graphics-ltd"
  ; description = "Coherent Graphics is a developer of both server tools and desktop software for the processing of PDF documents\n"
  ; image = Some 
 "users/coherent.png"
  ; site = "https://www.coherentpdf.com/"
  ; locations = 
 ["United Kingdom"]
  ; consortium = false
  ; body_md = "\nCoherent Graphics is a developer of both server tools and desktop software for the processing of PDF documents. We use OCaml as a general-purpose high level language, chosen for its expressiveness and speed.\n"
  ; body_html = "<p>Coherent Graphics is a developer of both server tools and desktop software for the processing of PDF documents. We use OCaml as a general-purpose high level language, chosen for its expressiveness and speed.</p>\n"
  };
 
  { name = "Cryptosense"
  ; slug = "cryptosense"
  ; description = "Cryptosense creates security analysis software with a particular focus on cryptographic systems\n"
  ; image = Some 
 "users/cryptosense.png"
  ; site = "https://www.cryptosense.com/"
  ; locations = 
 ["France"]
  ; consortium = false
  ; body_md = "\nBased in Paris, France, Cryptosense creates security analysis software with a particular focus on cryptographic systems. A spin-off of the institute for computer science research (Inria), Cryptosense\226\128\153s founders combine more than 40 years experience in research and industry. Cryptosense provides its solutions to an international client\195\168le in particular in the financial, industrial and government sectors.\n"
  ; body_html = "<p>Based in Paris, France, Cryptosense creates security analysis software with a particular focus on cryptographic systems. A spin-off of the institute for computer science research (Inria), Cryptosense\226\128\153s founders combine more than 40 years experience in research and industry. Cryptosense provides its solutions to an international client\195\168le in particular in the financial, industrial and government sectors.</p>\n"
  };
 
  { name = "Dassault Syst\195\168mes"
  ; slug = "dassault-systmes"
  ; description = "Dassault Syst\195\168mes, the 3DEXPERIENCE Company, provides businesses and people with virtual universes to imagine sustainable innovations.\n"
  ; image = Some 
 "users/dassault.png"
  ; site = "https://www.3ds.com/fr/"
  ; locations = 
 ["France"]
  ; consortium = false
  ; body_md = "\nDassault Syst\195\168mes, the 3DEXPERIENCE Company, provides businesses and people with virtual universes to imagine sustainable innovations.\n"
  ; body_html = "<p>Dassault Syst\195\168mes, the 3DEXPERIENCE Company, provides businesses and people with virtual universes to imagine sustainable innovations.</p>\n"
  };
 
  { name = "Dernier Cri"
  ; slug = "dernier-cri"
  ; description = "Dernier Cri is a French company based in Lille and Paris using functional programming to develop web and mobile applications.\n"
  ; image = Some 
 "users/derniercri.png"
  ; site = "https://derniercri.io"
  ; locations = 
 ["France"]
  ; consortium = false
  ; body_md = "\nDernier Cri is a French company based in Lille and Paris using functional programming to develop web and mobile applications. OCaml is principally used to develop internal tools.\n"
  ; body_html = "<p>Dernier Cri is a French company based in Lille and Paris using functional programming to develop web and mobile applications. OCaml is principally used to develop internal tools.</p>\n"
  };
 
  { name = "Digirati dba Hostnet"
  ; slug = "digirati-dba-hostnet"
  ; description = "Digirati dba Hostnet is a web hosting company.\n"
  ; image = Some 
 "users/hostnet.gif"
  ; site = "https://www.hostnet.com.br/"
  ; locations = 
 ["Brazil"]
  ; consortium = false
  ; body_md = "\nDigirati dba Hostnet is a web hosting company. We use OCaml mostly for internal systems programming and infrastructure services. We have also contributed to the community by releasing a few open source [OCaml libraries](https://github.com/andrenth).\n"
  ; body_html = "<p>Digirati dba Hostnet is a web hosting company. We use OCaml mostly for internal systems programming and infrastructure services. We have also contributed to the community by releasing a few open source <a href=\"https://github.com/andrenth\">OCaml libraries</a>.</p>\n"
  };
 
  { name = "Docker, Inc."
  ; slug = "docker-inc"
  ; description = "Docker provides an integrated technology suite that enables development and IT operations teams to build, ship, and run distributed applications anywhere\n"
  ; image = Some 
 "users/docker.png"
  ; site = "https://www.docker.com"
  ; locations = 
 ["United States"]
  ; consortium = true
  ; body_md = "\nDocker provides an integrated technology suite that enables development and IT operations teams to build, ship, and run distributed applications anywhere. Their native [applications for Mac and Windows](https://blog.docker.com/2016/03/docker-for-mac-windows-beta/), use OCaml code taken from the [MirageOS](https://mirage.io) library operating system project. "
  ; body_html = "<p>Docker provides an integrated technology suite that enables development and IT operations teams to build, ship, and run distributed applications anywhere. Their native <a href=\"https://blog.docker.com/2016/03/docker-for-mac-windows-beta/\">applications for Mac and Windows</a>, use OCaml code taken from the <a href=\"https://mirage.io\">MirageOS</a> library operating system project.</p>\n"
  };
 
  { name = "Esterel Technologies"
  ; slug = "esterel-technologies"
  ; description = "Esterel Technologies is a leading provider of critical systems and software development solutions for the aerospace, defense, rail transportation, nuclear, and industrial and automotive domains\n"
  ; image = Some 
 "users/esterel.jpg"
  ; site = "https://www.esterel-technologies.com/"
  ; locations = 
 ["France"]
  ; consortium = true
  ; body_md = "\nEsterel Technologies is a leading provider of critical systems and software development solutions for the aerospace, defense, rail transportation, nuclear, and industrial and automotive domains.\n"
  ; body_html = "<p>Esterel Technologies is a leading provider of critical systems and software development solutions for the aerospace, defense, rail transportation, nuclear, and industrial and automotive domains.</p>\n"
  };
 
  { name = "Facebook"
  ; slug = "facebook"
  ; description = "Facebook has built a number of major development tools using OCaml"
  ; image = Some 
 "users/facebook.png"
  ; site = "https://www.facebook.com/"
  ; locations = 
 ["United States"]
  ; consortium = true
  ; body_md = "\nFacebook has built a number of major development tools using OCaml. [Hack](https://hacklang.org) is a compiler for a variant of PHP that aims to reconcile the fast development cycle of PHP with the discipline provided by static typing. [Flow](https://flowtype.org) is a similar project that provides static type checking for Javascript.  Both systems are highly responsive, parallel programs that can incorporate source code changes in real time. [Pfff](https://github.com/facebook/pfff/wiki/Main) is a set of tools for code analysis, visualizations, and style-preserving source transformations, written in OCaml, but supporting many languages."
  ; body_html = "<p>Facebook has built a number of major development tools using OCaml. <a href=\"https://hacklang.org\">Hack</a> is a compiler for a variant of PHP that aims to reconcile the fast development cycle of PHP with the discipline provided by static typing. <a href=\"https://flowtype.org\">Flow</a> is a similar project that provides static type checking for Javascript.  Both systems are highly responsive, parallel programs that can incorporate source code changes in real time. <a href=\"https://github.com/facebook/pfff/wiki/Main\">Pfff</a> is a set of tools for code analysis, visualizations, and style-preserving source transformations, written in OCaml, but supporting many languages.</p>\n"
  };
 
  { name = "Fasoo"
  ; slug = "fasoo"
  ; description = "Fasoo uses OCaml to develop a static analysis tool.\n"
  ; image = Some 
 "users/fasoo.png"
  ; site = "https://www.fasoo.com"
  ; locations = 
 ["Korea"]
  ; consortium = false
  ; body_md = "\nFasoo uses OCaml to develop a static analysis tool.\n"
  ; body_html = "<p>Fasoo uses OCaml to develop a static analysis tool.</p>\n"
  };
 
  { name = "Flying Frog Consultancy"
  ; slug = "flying-frog-consultancy"
  ; description = "Flying Frog Consultancy Ltd. consult and write books and software on the use of OCaml in the context of scientific computing.\n"
  ; image = Some 
 "users/flying-frog.png"
  ; site = "https://www.ffconsultancy.com"
  ; locations = 
 ["United Kingdom"]
  ; consortium = false
  ; body_md = "\nFlying Frog Consultancy Ltd. consult and write books and software on the use of OCaml in the context of scientific computing. OCaml excels in the niche of intrinsically complicated programs between large-scale, array-based programs written in languages such as HPF and small-scale, graphical programs written in languages such as Mathematica.\n"
  ; body_html = "<p>Flying Frog Consultancy Ltd. consult and write books and software on the use of OCaml in the context of scientific computing. OCaml excels in the niche of intrinsically complicated programs between large-scale, array-based programs written in languages such as HPF and small-scale, graphical programs written in languages such as Mathematica.</p>\n"
  };
 
  { name = "ForAllSecure"
  ; slug = "forallsecure"
  ; description = "ForAllSecure's mission is to test the world's software and provide actionable information to our customers.\n"
  ; image = Some 
 "users/forallsecure.svg"
  ; site = "https://forallsecure.com"
  ; locations = 
 ["United States"]
  ; consortium = false
  ; body_md = "\nForAllSecure's mission is to test the world's software and provide actionable information to our customers. We have started with Linux. Our mission with Linux is to test all programs in current distributions, such as Debian, Ubuntu, and Red Hat. With time, we will cover other platforms, such as Mac, Windows, and mobile. In the meantime, we promise to do one thing well.\n"
  ; body_html = "<p>ForAllSecure's mission is to test the world's software and provide actionable information to our customers. We have started with Linux. Our mission with Linux is to test all programs in current distributions, such as Debian, Ubuntu, and Red Hat. With time, we will cover other platforms, such as Mac, Windows, and mobile. In the meantime, we promise to do one thing well.</p>\n"
  };
 
  { name = "Framtidsforum"
  ; slug = "framtidsforum"
  ; description = "Framtidsforum I&M sells ExcelEverywhere, which creates web pages that look and function the same as your MS Excel spreadsheet\n"
  ; image = None
  ; site = "https://www.exceleverywhere.com"
  ; locations = 
 ["Sweden"]
  ; consortium = false
  ; body_md = "\nFramtidsforum I&M sells ExcelEverywhere, which creates web pages that look and function the same as your MS Excel spreadsheet. JavaScript is used for calculation. Supports 140 Excel-functions. Typically used for expense report, survey, order forms, reservation forms, employment application, financial advisor, ROI. There are also versions that generate ASP, ASP.NET and JSP/Java code. The compiler is written using OCaml.\n"
  ; body_html = "<p>Framtidsforum I&amp;M sells ExcelEverywhere, which creates web pages that look and function the same as your MS Excel spreadsheet. JavaScript is used for calculation. Supports 140 Excel-functions. Typically used for expense report, survey, order forms, reservation forms, employment application, financial advisor, ROI. There are also versions that generate ASP, ASP.NET and JSP/Java code. The compiler is written using OCaml.</p>\n"
  };
 
  { name = "Galois"
  ; slug = "galois"
  ; description = "Galois has developed a domain specific declarative language for cryptographic algorithms.\n"
  ; image = Some 
 "users/galois.png"
  ; site = "https://www.galois.com"
  ; locations = 
 ["United States"]
  ; consortium = false
  ; body_md = "\nGalois has developed a domain specific declarative language for cryptographic algorithms. One of our research compilers is written in OCaml and makes very extensive use of camlp4.\n"
  ; body_html = "<p>Galois has developed a domain specific declarative language for cryptographic algorithms. One of our research compilers is written in OCaml and makes very extensive use of camlp4.</p>\n"
  };
 
  { name = "Incubaid"
  ; slug = "incubaid"
  ; description = "Incubaid has developed Arakoon, a distributed key-value store that guarantees consistency above anything else.\n"
  ; image = Some 
 "users/Incubaid.png"
  ; site = "https://incubaid.com"
  ; locations = 
 ["Belgium"]
  ; consortium = false
  ; body_md = "\nIncubaid has developed <a href=\"https://github.com/Incubaid/arakoon\">Arakoon</a>, a distributed key-value store that guarantees consistency above anything else. We created Arakoon due to a lack of existing solutions fitting our requirements, and is available as Open Source software.\n\n"
  ; body_html = "<p>Incubaid has developed <a href=\"https://github.com/Incubaid/arakoon\">Arakoon</a>, a distributed key-value store that guarantees consistency above anything else. We created Arakoon due to a lack of existing solutions fitting our requirements, and is available as Open Source software.</p>\n"
  };
 
  { name = "Issuu"
  ; slug = "issuu"
  ; description = "Issuu is a digital publishing platform delivering exceptional reading experiences of magazines, catalogues, and newspapers\n"
  ; image = Some 
 "users/issuu.gif"
  ; site = "https://issuu.com"
  ; locations = ["Denmark"]
  ; consortium = false
  ; body_md = "\nIssuu is a digital publishing platform delivering exceptional reading experiences of magazines, catalogues, and newspapers. Each month Issuu serves over 6 billion page views and 60 million users through their worldwide network. OCaml is used as part of the server-side systems, platforms, and web applications. The backend team is relatively small and the simplicity and scalability of both systems and processes are of vital importance.\n"
  ; body_html = "<p>Issuu is a digital publishing platform delivering exceptional reading experiences of magazines, catalogues, and newspapers. Each month Issuu serves over 6 billion page views and 60 million users through their worldwide network. OCaml is used as part of the server-side systems, platforms, and web applications. The backend team is relatively small and the simplicity and scalability of both systems and processes are of vital importance.</p>\n"
  };
 
  { name = "Jane Street"
  ; slug = "jane-street"
  ; description = "Jane Street is a quantitative trading firm that operates around the clock and around the globe\n"
  ; image = Some 
 "users/jane-street.jpg"
  ; site = "https://janestreet.com"
  ; locations = 
 ["United States"; "United Kingdom"; "Hong Kong"]
  ; consortium = true
  ; body_md = "\nJane Street is a quantitative trading firm that operates around the clock and around the globe. They bring a deep understanding of markets, a scientific approach, and innovative technology to bear on the problem of trading profitably in the world's highly competitive financial markets. They're the largest commercial user of OCaml, using it for everything from research tools to trading systems to systems infrastructure to accounting systems. Jane Street has over 400 OCaml programmers and over 15 million lines of OCaml, powering a technology platform that trades billions of dollars every day. Half a million lines of their code are released [open source](https://opensource.janestreet.com), and they've created key parts of the open-source OCaml ecosystem, like [Dune](https://dune.build). You can learn more by checking out their [tech blog](https://blog.janestreet.com).\n"
  ; body_html = "<p>Jane Street is a quantitative trading firm that operates around the clock and around the globe. They bring a deep understanding of markets, a scientific approach, and innovative technology to bear on the problem of trading profitably in the world's highly competitive financial markets. They're the largest commercial user of OCaml, using it for everything from research tools to trading systems to systems infrastructure to accounting systems. Jane Street has over 400 OCaml programmers and over 15 million lines of OCaml, powering a technology platform that trades billions of dollars every day. Half a million lines of their code are released <a href=\"https://opensource.janestreet.com\">open source</a>, and they've created key parts of the open-source OCaml ecosystem, like <a href=\"https://dune.build\">Dune</a>. You can learn more by checking out their <a href=\"https://blog.janestreet.com\">tech blog</a>.</p>\n"
  };
 
  { name = "Kernelize"
  ; slug = "kernelize"
  ; description = "Kernelyze has developed a novel approximation of two-variable functions that achieves the smallest possible worst-case error among all rank-n approximations.\n"
  ; image = Some 
 "users/kernelyze-llc-logo.png"
  ; site = "https://kernelyze.com/"
  ; locations = 
 ["United States"]
  ; consortium = true
  ; body_md = "\n\nKernelyze has developed a novel approximation of two-variable functions\nthat achieves the smallest possible worst-case error among all rank-n\napproximations."
  ; body_html = "<p>Kernelyze has developed a novel approximation of two-variable functions\nthat achieves the smallest possible worst-case error among all rank-n\napproximations.</p>\n"
  };
 
  { name = "Kong"
  ; slug = "kong"
  ; description = "Kong makes it easy to distribute, monetize, manage and consume cloud APIs.\n"
  ; image = Some 
 "users/mashape.png"
  ; site = "https://www.konghq.com"
  ; locations = 
 ["United States"]
  ; consortium = false
  ; body_md = "\nKong makes it easy to distribute, monetize, manage and consume cloud APIs. Mashape is building a world-class marketplace for cloud APIs driven by a passionate community of developers from all over the world as well as enterprise API management and analytics products. We use OCaml in our [APIAnalytics](https://apianalytics.com) product \226\128\148 as part of a mission-critical, lightweight HTTP proxy.\n"
  ; body_html = "<p>Kong makes it easy to distribute, monetize, manage and consume cloud APIs. Mashape is building a world-class marketplace for cloud APIs driven by a passionate community of developers from all over the world as well as enterprise API management and analytics products. We use OCaml in our <a href=\"https://apianalytics.com\">APIAnalytics</a> product \226\128\148 as part of a mission-critical, lightweight HTTP proxy.</p>\n"
  };
 
  { name = "LexiFi"
  ; slug = "lexifi"
  ; description = "LexiFi is an innovative provider of software applications and infrastructure technology for the capital markets industry.\n"
  ; image = Some 
 "users/lexifi.png"
  ; site = "https://www.janestreet.com"
  ; locations = 
 ["France"]
  ; consortium = true
  ; body_md = "\nLexiFi is an innovative provider of software applications and infrastructure technology for the capital markets industry. LexiFi Apropos is powered by an original formalism for describing financial contracts, the result of a long-term research and development effort."
  ; body_html = "<p>LexiFi is an innovative provider of software applications and infrastructure technology for the capital markets industry. LexiFi Apropos is powered by an original formalism for describing financial contracts, the result of a long-term research and development effort.</p>\n"
  };
 
  { name = "Matrix Lead"
  ; slug = "matrix-lead"
  ; description = "Matrix Lead provides professionals and companies with leading technologies and solutions for spreadsheets. \n"
  ; image = Some 
 "users/matrixlead.png"
  ; site = "https://www.matrixlead.com"
  ; locations = 
 ["France"; "China"]
  ; consortium = false
  ; body_md = "\nMatrix Lead provides professionals and companies with leading technologies and solutions for spreadsheets. We create a range of software to help users better build, verify, optimize and manage their spreadsheets. Our flagship product [10 Studio](https://www.10studio.tech) is a Microsoft Excel add-in that combines our several advanced tools, such as formula editor and spreadsheet verificator. The kernel of our tools is an analyzer that analyzes different properties of spreadsheets (including formulas and VBA macros) especially by abstract interpretation-based static analysis. It was initially developed in the Antiques team of Inria and written in OCaml. Then, we wrap web or .NET languages around the analyzer to make ready-to-use tools.\n"
  ; body_html = "<p>Matrix Lead provides professionals and companies with leading technologies and solutions for spreadsheets. We create a range of software to help users better build, verify, optimize and manage their spreadsheets. Our flagship product <a href=\"https://www.10studio.tech\">10 Studio</a> is a Microsoft Excel add-in that combines our several advanced tools, such as formula editor and spreadsheet verificator. The kernel of our tools is an analyzer that analyzes different properties of spreadsheets (including formulas and VBA macros) especially by abstract interpretation-based static analysis. It was initially developed in the Antiques team of Inria and written in OCaml. Then, we wrap web or .NET languages around the analyzer to make ready-to-use tools.</p>\n"
  };
 
  { name = "MEDIT"
  ; slug = "medit"
  ; description = "MEDIT develops SuMo, an advanced bioinformatic system, for the analysis of protein 3D structures and the identification of drug-design targets. \n"
  ; image = Some 
 "users/medit.jpg"
  ; site = "https://www.medit-pharma.com/"
  ; locations = 
 ["France"]
  ; consortium = false
  ; body_md = "\nMEDIT develops [SuMo, an advanced bioinformatic system](\"https://mjambon.com/\") for the analysis of protein 3D structures and the identification of drug-design targets. SuMo is written entirely in OCaml and provides interfaces to several commercial molecular-modeling packages.\n"
  ; body_html = "<p>MEDIT develops <a href=\"%22https://mjambon.com/%22\">SuMo, an advanced bioinformatic system</a> for the analysis of protein 3D structures and the identification of drug-design targets. SuMo is written entirely in OCaml and provides interfaces to several commercial molecular-modeling packages.</p>\n"
  };
 
  { name = "Microsoft"
  ; slug = "microsoft"
  ; description = "Facebook has built a number of major development tools using OCaml\n"
  ; image = Some 
 "users/microsoft.png"
  ; site = "https://www.microsoft.com"
  ; locations = 
 ["United States"]
  ; consortium = true
  ; body_md = "\n"
  ; body_html = ""
  };
 
  { name = "Mount Sinai"
  ; slug = "mount-sinai"
  ; description = "The Hammer Lab at Mount Sinai develops and uses Ketrew for managing complex bioinformatics workflows.\n"
  ; image = Some 
 "users/mount-sinai.png"
  ; site = "https://www.mountsinai.org"
  ; locations = 
 ["United States"]
  ; consortium = false
  ; body_md = "\nThe [Hammer Lab](\"https://www.hammerlab.org\") at Mount Sinai develops and uses [Ketrew](\"https://github.com/hammerlab/ketrew\") for managing complex bioinformatics workflows. Ketrew includes an embedded domain-specific language to simplify the specification of workflows and an engine for the execution of workflows. Ketrew can be run as a command-line application or as a service.\n"
  ; body_html = "<p>The <a href=\"%22https://www.hammerlab.org%22\">Hammer Lab</a> at Mount Sinai develops and uses <a href=\"%22https://github.com/hammerlab/ketrew%22\">Ketrew</a> for managing complex bioinformatics workflows. Ketrew includes an embedded domain-specific language to simplify the specification of workflows and an engine for the execution of workflows. Ketrew can be run as a command-line application or as a service.</p>\n"
  };
 
  { name = "Mr. Number"
  ; slug = "mr-number"
  ; description = "Mr. Number started as a Silicon Valley startup and developed the Mr. Number app for call blocking, later acquired by WhitePages.\n"
  ; image = Some 
 "users/mrnumber.jpg"
  ; site = "https://mrnumber.com/"
  ; locations = 
 ["United States"]
  ; consortium = false
  ; body_md = "\nMr. Number started as a Silicon Valley startup and developed the Mr. Number app for call blocking, later [acquired by WhitePages](https://allthingsd.com/20130601/whitepages-scoops-up-mr-number-an-android-app-for-blocking-unwanted-calls/). OCaml is used on the server-side as the glue between the various third-party components and services.</p>\n"
  ; body_html = "<p>Mr. Number started as a Silicon Valley startup and developed the Mr. Number app for call blocking, later <a href=\"https://allthingsd.com/20130601/whitepages-scoops-up-mr-number-an-android-app-for-blocking-unwanted-calls/\">acquired by WhitePages</a>. OCaml is used on the server-side as the glue between the various third-party components and services.</p></p>\n"
  };
 
  { name = "MyLife"
  ; slug = "mylife"
  ; description = "MyLife has developed a powerful people search tool that will empower those in need to find anyone, regardless of years past and the life that was built in between.\n"
  ; image = Some 
 "users/mylife.jpg"
  ; site = "https://www.mylife.com/"
  ; locations = 
 ["United States"]
  ; consortium = false
  ; body_md = "\nMyLife has developed a powerful people search tool that will empower those in need to find anyone, regardless of years past and the life that was built in between."
  ; body_html = "<p>MyLife has developed a powerful people search tool that will empower those in need to find anyone, regardless of years past and the life that was built in between.</p>\n"
  };
 
  { name = "Narrow Gate Logic"
  ; slug = "narrow-gate-logic"
  ; description = "Narrow Gate Logic is a company using the OCaml language in business and non-business applications.\n"
  ; image = Some 
 "users/nglogic.png"
  ; site = "https://nglogic.com"
  ; locations = 
 ["Poland"]
  ; consortium = false
  ; body_md = "\nNarrow Gate Logic is a company using the OCaml language in business and non-business applications.\n"
  ; body_html = "<p>Narrow Gate Logic is a company using the OCaml language in business and non-business applications.</p>\n"
  };
 
  { name = "Nomadic Labs"
  ; slug = "nomadic-labs"
  ; description = "Nomadic Labs houses a team focused on Research and Development. Our core competencies are in programming language theory and practice, distributed systems, and formal verification.\n"
  ; image = Some 
 "users/nomadic-labs.png"
  ; site = "https://www.nomadic-labs.com"
  ; locations = 
 ["Paris, France"]
  ; consortium = false
  ; body_md = "\nNomadic Labs houses a team focused on Research and Development. Our\ncore competencies are in programming language theory and practice,\ndistributed systems, and formal verification. Nomadic Labs focuses on\ncontributing to the development of the Tezos core software, including\nthe smart-contract language, Michelson.\n\nTezos infrastructure is entirely implemented in OCaml. It strongly\nrelies on OCaml efficiency and expressivity. For instance, Michelson\nsmart contracts are represented using OCaml GADTs to prevent many\nruntime errors from happening. Safety and correctness are critical for a\nblockchain and we are glad that the OCaml type system allows for a\nform of a lightweight formal method that can be used on a daily basis.\n"
  ; body_html = "<p>Nomadic Labs houses a team focused on Research and Development. Our\ncore competencies are in programming language theory and practice,\ndistributed systems, and formal verification. Nomadic Labs focuses on\ncontributing to the development of the Tezos core software, including\nthe smart-contract language, Michelson.</p>\n<p>Tezos infrastructure is entirely implemented in OCaml. It strongly\nrelies on OCaml efficiency and expressivity. For instance, Michelson\nsmart contracts are represented using OCaml GADTs to prevent many\nruntime errors from happening. Safety and correctness are critical for a\nblockchain and we are glad that the OCaml type system allows for a\nform of a lightweight formal method that can be used on a daily basis.</p>\n"
  };
 
  { name = "OCamlPro"
  ; slug = "ocamlpro"
  ; description = "OCamlPro develops and maintains a development environment for the OCaml language.\n"
  ; image = Some 
 "users/ocamlpro.png"
  ; site = "https://www.ocamlpro.com"
  ; locations = 
 ["France"]
  ; consortium = true
  ; body_md = "\nOCamlPro develops and maintains a development environment for the OCaml language. They provide services for companies deciding to use OCaml. Among these services: trainings, necessary expertise, tools and libraries long-term support, and specific developments to their applicative domains."
  ; body_html = "<p>OCamlPro develops and maintains a development environment for the OCaml language. They provide services for companies deciding to use OCaml. Among these services: trainings, necessary expertise, tools and libraries long-term support, and specific developments to their applicative domains.</p>\n"
  };
 
  { name = "PRUDENT Technologies and Consulting, Inc."
  ; slug = "prudent-technologies-and-consulting-inc"
  ; description = "Prudent Consulting offers IT solutions to large and mid-sized organizations by combining industry experience and technology expertise to help our customers achieve business goals with speed, agility, and great impact.\n"
  ; image = Some 
 "users/prudent.jpg"
  ; site = "https://www.prudentconsulting.com"
  ; locations = 
 ["United States"]
  ; consortium = false
  ; body_md = "\nPrudent Consulting offers IT solutions to large and mid-sized organizations by combining industry experience and technology expertise to help our customers achieve business goals with speed, agility, and great impact.\n"
  ; body_html = "<p>Prudent Consulting offers IT solutions to large and mid-sized organizations by combining industry experience and technology expertise to help our customers achieve business goals with speed, agility, and great impact.</p>\n"
  };
 
  { name = "Psellos"
  ; slug = "psellos"
  ; description = "Psellos is a small group of computer scientists who became intrigued by the idea of coding iOS apps in OCaml.\n"
  ; image = Some 
 "users/psellos.png"
  ; site = "https://www.psellos.com"
  ; locations = 
 ["United States"]
  ; consortium = false
  ; body_md = "\nPsellos is a small group of computer scientists who became intrigued by the idea of coding iOS apps in OCaml. It has worked out better than we expected (you can buy our apps in the iTunes App Store), and at least one other company sells apps built with our tools. Our most recent iOS cross compiler is derived from OCaml 4.00.0."
  ; body_html = "<p>Psellos is a small group of computer scientists who became intrigued by the idea of coding iOS apps in OCaml. It has worked out better than we expected (you can buy our apps in the iTunes App Store), and at least one other company sells apps built with our tools. Our most recent iOS cross compiler is derived from OCaml 4.00.0.</p>\n"
  };
 
  { name = "Sakhalin"
  ; slug = "sakhalin"
  ; description = "Sakhalin develops marine charting apps for Apple iPads and iPhones.\n"
  ; image = None
  ; site = "https://www.seaiq.com"
  ; locations = 
 ["United States"]
  ; consortium = false
  ; body_md = "\nSakhalin develops marine charting apps for Apple iPads and iPhones. The full-featured apps display marine charts, GPS and onboard sensor data, Automatic Identification System, weather data, anchor monitoring, etc. The apps have a wide range of users, from occasional recreational boaters to professional river/harbor pilots that board large freighters. They are free to download and try (with a paid upgrade to enable all features). They are written almost entirely in Ocaml with a minor amount of glue to interface with IOS APIs. Ocaml was chosen because it\n\n 1. enables the rapid development of extremely reliable and high-performance software,\n 2. is a mature stable platform\n 3. has a wide range of libraries. \n \nIt was made possible by the great work done by Psellos in porting OCaml to the Apple iOS platform. Feel free to contact Sakhalin if you have any questions about using OCaml on iOS."
  ; body_html = "<p>Sakhalin develops marine charting apps for Apple iPads and iPhones. The full-featured apps display marine charts, GPS and onboard sensor data, Automatic Identification System, weather data, anchor monitoring, etc. The apps have a wide range of users, from occasional recreational boaters to professional river/harbor pilots that board large freighters. They are free to download and try (with a paid upgrade to enable all features). They are written almost entirely in Ocaml with a minor amount of glue to interface with IOS APIs. Ocaml was chosen because it</p>\n<ol>\n<li>enables the rapid development of extremely reliable and high-performance software,\n</li>\n<li>is a mature stable platform\n</li>\n<li>has a wide range of libraries.\n</li>\n</ol>\n<p>It was made possible by the great work done by Psellos in porting OCaml to the Apple iOS platform. Feel free to contact Sakhalin if you have any questions about using OCaml on iOS.</p>\n"
  };
 
  { name = "Shiro Games"
  ; slug = "shiro-games"
  ; description = "Shiro Games is developing games using Haxe, a language built with a compiler written in OCaml.\n"
  ; image = Some 
 "users/shirogames.png"
  ; site = "https://www.shirogames.com"
  ; locations = 
 ["France"]
  ; consortium = false
  ; body_md = "\nShiro Games is developing games using [Haxe](https://haxe.org/), a language built with a compiler written in OCaml."
  ; body_html = "<p>Shiro Games is developing games using <a href=\"https://haxe.org/\">Haxe</a>, a language built with a compiler written in OCaml.</p>\n"
  };
 
  { name = "SimCorp"
  ; slug = "simcorp"
  ; description = "Multi-asset platform to support investment decision-making and innovation.\n"
  ; image = Some 
 "users/simcorp.png"
  ; site = "https://www.simcorp.com/"
  ; locations = 
 ["United States"]
  ; consortium = true
  ; body_md = "\nMulti-asset platform to support investment decision-making and innovation.\n"
  ; body_html = "<p>Multi-asset platform to support investment decision-making and innovation.</p>\n"
  };
 
  { name = "Sleekersoft"
  ; slug = "sleekersoft"
  ; description = "Specialises in functional programming software development, consultation, and training.\n"
  ; image = Some 
 "users/sleekersoft.png"
  ; site = "https://www.sleekersoft.com"
  ; locations = 
 ["Australia"]
  ; consortium = false
  ; body_md = "\nShiro Games is developing games using [Haxe](https://haxe.org/), a language built with a compiler written in OCaml."
  ; body_html = "<p>Shiro Games is developing games using <a href=\"https://haxe.org/\">Haxe</a>, a language built with a compiler written in OCaml.</p>\n"
  };
 
  { name = "Solvuu"
  ; slug = "solvuu"
  ; description = "Solvuu's software allows users to store big and small data sets, share the data with collaborators, execute computationally intensive algorithms and workflows, and visualize results.\n"
  ; image = Some 
 "users/solvuu.jpg"
  ; site = "https://www.solvuu.com"
  ; locations = 
 ["United States"]
  ; consortium = false
  ; body_md = "\nSolvuu's software allows users to store big and small data sets, share the data with collaborators, execute computationally intensive algorithms and workflows, and visualize results. Its initial focus is on genomics data, which has important implications for healthcare, agriculture, and fundamental research. Virtually all of Solvuu's software stack is implemented in OCaml.\n"
  ; body_html = "<p>Solvuu's software allows users to store big and small data sets, share the data with collaborators, execute computationally intensive algorithms and workflows, and visualize results. Its initial focus is on genomics data, which has important implications for healthcare, agriculture, and fundamental research. Virtually all of Solvuu's software stack is implemented in OCaml.</p>\n"
  };
 
  { name = "Studio Associato 4Sigma"
  ; slug = "studio-associato-4sigma"
  ; description = "4Sigma is a small firm making websites and some interesting web applications.\n"
  ; image = Some 
 "users/4sigma.png"
  ; site = "https://www.4sigma.it"
  ; locations = 
 ["Italy"]
  ; consortium = false
  ; body_md = "\n4Sigma is a small firm making websites and some interesting web applications. OCaml is not the main language used but it is used here and there, particularly in a small server that is a key component of a service we offer our customers."
  ; body_html = "<p>4Sigma is a small firm making websites and some interesting web applications. OCaml is not the main language used but it is used here and there, particularly in a small server that is a key component of a service we offer our customers.</p>\n"
  };
 
  { name = "Tarides"
  ; slug = "tarides"
  ; description = "Tarides builds and maintains open-source infrastructure tools in OCaml like MirageOS, Irmin and OCaml developer tools.\n"
  ; image = Some 
 "users/tarides.png"
  ; site = "https://www.tarides.com"
  ; locations = 
 ["France"]
  ; consortium = false
  ; body_md = "\nWe are building and maintaining open-source infrastructure tools in OCaml:\n\n - [MirageOS](https://mirage.io), the most advanced unikernel project, where we build sandboxes, network and storage protocol implementations as libraries, so we can link them to our applications to run them without the need of an underlying operating system.\n - [Irmin](\"https://irmin.org\"), a Git-like datastore, which allows us to create fully auditable distributed systems which can work offline and be synced when needed.\n - OCaml development tools (build system, code linters, documentation generators, etc), to make us more efficient. \n  \nTarides was founded in early 2018 and is mainly based in Paris, France (remote work is possible).\n\n"
  ; body_html = "<p>We are building and maintaining open-source infrastructure tools in OCaml:</p>\n<ul>\n<li><a href=\"https://mirage.io\">MirageOS</a>, the most advanced unikernel project, where we build sandboxes, network and storage protocol implementations as libraries, so we can link them to our applications to run them without the need of an underlying operating system.\n</li>\n<li><a href=\"%22https://irmin.org%22\">Irmin</a>, a Git-like datastore, which allows us to create fully auditable distributed systems which can work offline and be synced when needed.\n</li>\n<li>OCaml development tools (build system, code linters, documentation generators, etc), to make us more efficient.\n</li>\n</ul>\n<p>Tarides was founded in early 2018 and is mainly based in Paris, France (remote work is possible).</p>\n"
  };
 
  { name = "TrustInSoft"
  ; slug = "trustinsoft"
  ; description = "TrustInSoft is a company that changes the rules in cybersecurity. TrustInSoft is the software publisher of the software analysis Frama-C platform. \n"
  ; image = Some 
 "users/trustinsoft.png"
  ; site = "https://trust-in-soft.com"
  ; locations = 
 ["France"]
  ; consortium = false
  ; body_md = "\nTrustInSoft is a company that changes the rules in cybersecurity. TrustInSoft is the software publisher of the software analysis [Frama-C](https://frama-c.com) platform. Our motto is simple: make the formal methods accessible to the majority of software developers."
  ; body_html = "<p>TrustInSoft is a company that changes the rules in cybersecurity. TrustInSoft is the software publisher of the software analysis <a href=\"https://frama-c.com\">Frama-C</a> platform. Our motto is simple: make the formal methods accessible to the majority of software developers.</p>\n"
  };
 
  { name = "Wolfram MathCore"
  ; slug = "wolfram-mathcore"
  ; description = "Wolfram MathCore uses OCaml to implement its SystemModeler kernel.\n"
  ; image = Some 
 "users/wolfram-mathcore.gif"
  ; site = "https://www.wolframmathcore.com"
  ; locations = 
 ["Sweden"]
  ; consortium = false
  ; body_md = "\nWolfram MathCore uses OCaml to implement its SystemModeler kernel. The kernel's main function is to translate models defined in the Modelica language into executable simulation code. This involves parsing and transforming Modelica code, mathematical processing of equations, code generation of C/C++ simulation code, and numerical runtime computations.\n"
  ; body_html = "<p>Wolfram MathCore uses OCaml to implement its SystemModeler kernel. The kernel's main function is to translate models defined in the Modelica language into executable simulation code. This involves parsing and transforming Modelica code, mathematical processing of equations, code generation of C/C++ simulation code, and numerical runtime computations.</p>\n"
  };
 
  { name = "Zeo Agency"
  ; slug = "zeo-agency"
  ; description = "Zeo is a digital marketing company focused on helping companies to do better in SEO.\n"
  ; image = None
  ; site = "https://www.zeo.org"
  ; locations = 
 ["London, United Kingdom"]
  ; consortium = false
  ; body_md = "\nZeo is a digital marketing company focused on helping companies to do better in SEO. Due to the nature of our business, we manage billions of lines in our database & create insights by using this data. To utilize our needs effectively, we use OCaml in our data crawling & processing part.\n"
  ; body_html = "<p>Zeo is a digital marketing company focused on helping companies to do better in SEO. Due to the nature of our business, we manage billions of lines in our database &amp; create insights by using this data. To utilize our needs effectively, we use OCaml in our data crawling &amp; processing part.</p>\n"
  }]

