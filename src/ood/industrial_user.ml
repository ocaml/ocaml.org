
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
  { name = {js|Aesthetic Integration|js}
  ; slug = {js|aesthetic-integration|js}
  ; description = {js|Aesthetic Integration (AI) is a financial technology startup based in the City of London
|js}
  ; image = Some {js|/users/aesthetic-integration.png|js}
  ; site = {js|https://www.aestheticintegration.com|js}
  ; locations = 
 [{js|United Kingdom|js}]
  ; consortium = true
  ; body_md = {js|
Aesthetic Integration (AI) is a financial technology startup based in the City of London. AI's patent-pending formal verification technology is revolutionising the safety, stability and transparency of global financial markets.
|js}
  ; body_html = {js|<p>Aesthetic Integration (AI) is a financial technology startup based in the City of London. AI's patent-pending formal verification technology is revolutionising the safety, stability and transparency of global financial markets.</p>
|js}
  };
 
  { name = {js|Ahrefs|js}
  ; slug = {js|ahrefs|js}
  ; description = {js|Ahrefs develops custom distributed petabyte-scale storage and runs an internet-wide crawler to collect the index of the whole Web
|js}
  ; image = Some {js|/users/ahrefs.png|js}
  ; site = {js|https://www.ahrefs.com|js}
  ; locations = 
 [{js|Singapore|js}; {js|United States|js}]
  ; consortium = true
  ; body_md = {js|
Ahrefs develops custom distributed petabyte-scale storage and runs an internet-wide crawler to collect the index of the whole Web. On top of that the company is building various analytical services for end-users. OCaml is the main language of the Ahrefs backend, which is currently processing up to 6 billion pages a day. Ahrefs is a multinational team with roots from Ukraine and offices in Singapore and San Francisco.
|js}
  ; body_html = {js|<p>Ahrefs develops custom distributed petabyte-scale storage and runs an internet-wide crawler to collect the index of the whole Web. On top of that the company is building various analytical services for end-users. OCaml is the main language of the Ahrefs backend, which is currently processing up to 6 billion pages a day. Ahrefs is a multinational team with roots from Ukraine and offices in Singapore and San Francisco.</p>
|js}
  };
 
  { name = {js|American Museum of Natural History|js}
  ; slug = {js|american-museum-of-natural-history|js}
  ; description = {js|The Computational Sciences Department at the AMNH has been using OCaml for almost a decade in their software package POY for phylogenetic inference
|js}
  ; image = Some {js|/users/amnh.png|js}
  ; site = {js|https://www.amnh.org/our-research/computational-sciences|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; body_md = {js|
The Computational Sciences Department at the AMNH has been using OCaml for almost a decade in their software package [POY](https://github.com/amnh/poy5) for phylogenetic inference. See [AMNH's GitHub page](https://github.com/AMNH) for more projects.
|js}
  ; body_html = {js|<p>The Computational Sciences Department at the AMNH has been using OCaml for almost a decade in their software package <a href="https://github.com/amnh/poy5">POY</a> for phylogenetic inference. See <a href="https://github.com/AMNH">AMNH's GitHub page</a> for more projects.</p>
|js}
  };
 
  { name = {js|ANSSI|js}
  ; slug = {js|anssi|js}
  ; description = {js|The ANSSI core missions are: to detect and react to cyber attacks, to prevent threats, to provide advice and support to governmental entities and operators of critical infrastructure, and to keep companies and the general public informed about information security threats
|js}
  ; image = Some {js|/users/anssi.png|js}
  ; site = {js|https://www.ssi.gouv.fr/|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; body_md = {js|
The ANSSI core missions are: to detect and react to cyber attacks, to prevent threats, to provide advice and support to governmental entities and operators of critical infrastructure, and to keep companies and the general public informed about information security threats. See [ANSII's GitHub page](https://github.com/anssi-fr) for some of its OCaml software.
|js}
  ; body_html = {js|<p>The ANSSI core missions are: to detect and react to cyber attacks, to prevent threats, to provide advice and support to governmental entities and operators of critical infrastructure, and to keep companies and the general public informed about information security threats. See <a href="https://github.com/anssi-fr">ANSII's GitHub page</a> for some of its OCaml software.</p>
|js}
  };
 
  { name = {js|Arena|js}
  ; slug = {js|arena|js}
  ; description = {js|Arena helps organizations hire the right people.
|js}
  ; image = Some {js|/users/arena.jpg|js}
  ; site = {js|https://www.arena.io|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; body_md = {js|
Arena helps organizations hire the right people. We do that by applying big data and predictive analytics to the hiring process. This results in less turnover for our clients and less discrimination for individuals. We use OCaml for all of our backend development.|js}
  ; body_html = {js|<p>Arena helps organizations hire the right people. We do that by applying big data and predictive analytics to the hiring process. This results in less turnover for our clients and less discrimination for individuals. We use OCaml for all of our backend development.</p>
|js}
  };
 
  { name = {js|Be Sport|js}
  ; slug = {js|be-sport|js}
  ; description = {js|Be Sport's mission is to enhance the value that sport brings to our lives with appropriate use of digital and social media innovations
|js}
  ; image = Some {js|/users/besport.png|js}
  ; site = {js|https://besport.com/|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = true
  ; body_md = {js|
Be Sport's mission is to enhance the value that sport brings to our lives with appropriate use of digital and social media innovations.
           
Be Sport is a 100% [OCaml](//ocaml.org/) and [OCsigen](https://ocsigen.org) project, leveraged as the only building blocks to develop the platform. 
|js}
  ; body_html = {js|<p>Be Sport's mission is to enhance the value that sport brings to our lives with appropriate use of digital and social media innovations.</p>
<p>Be Sport is a 100% <a href="//ocaml.org/">OCaml</a> and <a href="https://ocsigen.org">OCsigen</a> project, leveraged as the only building blocks to develop the platform.</p>
|js}
  };
 
  { name = {js|Bloomberg L.P.|js}
  ; slug = {js|bloomberg-lp|js}
  ; description = {js|Bloomberg, the global business and financial information and news leader, gives influential decision makers a critical edge by connecting them to a dynamic network of information, people and ideas
|js}
  ; image = Some {js|/users/bloomberg.jpg|js}
  ; site = {js|https://www.bloomberg.com|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = true
  ; body_md = {js|
Bloomberg, the global business and financial information and news leader, gives influential decision makers a critical edge by connecting them to a dynamic network of information, people and ideas. Bloomberg employs OCaml in an advanced financial derivatives risk management application delivered through its Bloomberg Professional service.|js}
  ; body_html = {js|<p>Bloomberg, the global business and financial information and news leader, gives influential decision makers a critical edge by connecting them to a dynamic network of information, people and ideas. Bloomberg employs OCaml in an advanced financial derivatives risk management application delivered through its Bloomberg Professional service.</p>
|js}
  };
 
  { name = {js|CACAOWEB|js}
  ; slug = {js|cacaoweb|js}
  ; description = {js|Cacaoweb is developing an application platform of a new kind. It runs on top of our peer-to-peer network, which happens to be one of the largest in the world
|js}
  ; image = Some {js|/users/cacaoweb.png|js}
  ; site = {js|https://cacaoweb.org/|js}
  ; locations = 
 [{js|United Kingdom|js}; {js|Hong Kong|js}]
  ; consortium = false
  ; body_md = {js|
Cacaoweb is developing an application platform of a new kind. It runs on top of our peer-to-peer network, which happens to be one of the largest in the world. The capabilities of the platform are diverse and range from multimedia streaming to social communication, offline storage or data synchronisation. We design and implement massively distributed data stores, programming languages, runtime systems and parallel computation frameworks.
|js}
  ; body_html = {js|<p>Cacaoweb is developing an application platform of a new kind. It runs on top of our peer-to-peer network, which happens to be one of the largest in the world. The capabilities of the platform are diverse and range from multimedia streaming to social communication, offline storage or data synchronisation. We design and implement massively distributed data stores, programming languages, runtime systems and parallel computation frameworks.</p>
|js}
  };
 
  { name = {js|CEA|js}
  ; slug = {js|cea|js}
  ; description = {js|CEA is a French state company, member of the OCaml Consortium.
|js}
  ; image = Some {js|/users/cea.png|js}
  ; site = {js|https://cea.fr/|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = true
  ; body_md = {js|
CEA is a French state company, member of the OCaml Consortium. It uses OCaml mainly to develop a platform dedicated to source-code analysis of C software, called [Frama-C](https://frama-c.com).
|js}
  ; body_html = {js|<p>CEA is a French state company, member of the OCaml Consortium. It uses OCaml mainly to develop a platform dedicated to source-code analysis of C software, called <a href="https://frama-c.com">Frama-C</a>.</p>
|js}
  };
 
  { name = {js|Citrix|js}
  ; slug = {js|citrix|js}
  ; description = {js|Citrix uses OCaml in XenServer, a world-class server virtualization system.
|js}
  ; image = Some {js|/users/citrix.png|js}
  ; site = {js|https://www.citrix.com|js}
  ; locations = 
 [{js|United Kingdom|js}]
  ; consortium = true
  ; body_md = {js|
Citrix uses OCaml in XenServer, a world-class server virtualization system. Most components of XenServer are released as open source. The open-source XenServer toolstack components implemented in OCaml are bundled in the [XS-opam](https://github.com/xapi-project/xs-opam) repository on GitHub.
|js}
  ; body_html = {js|<p>Citrix uses OCaml in XenServer, a world-class server virtualization system. Most components of XenServer are released as open source. The open-source XenServer toolstack components implemented in OCaml are bundled in the <a href="https://github.com/xapi-project/xs-opam">XS-opam</a> repository on GitHub.</p>
|js}
  };
 
  { name = {js|Coherent Graphics Ltd|js}
  ; slug = {js|coherent-graphics-ltd|js}
  ; description = {js|Coherent Graphics is a developer of both server tools and desktop software for the processing of PDF documents
|js}
  ; image = Some {js|/users/coherent.png|js}
  ; site = {js|https://www.coherentpdf.com/|js}
  ; locations = 
 [{js|United Kingdom|js}]
  ; consortium = false
  ; body_md = {js|
Coherent Graphics is a developer of both server tools and desktop software for the processing of PDF documents. We use OCaml as a general-purpose high level language, chosen for its expressiveness and speed.
|js}
  ; body_html = {js|<p>Coherent Graphics is a developer of both server tools and desktop software for the processing of PDF documents. We use OCaml as a general-purpose high level language, chosen for its expressiveness and speed.</p>
|js}
  };
 
  { name = {js|Cryptosense|js}
  ; slug = {js|cryptosense|js}
  ; description = {js|Cryptosense creates security analysis software with a particular focus on cryptographic systems
|js}
  ; image = Some {js|/users/cryptosense.png|js}
  ; site = {js|https://www.cryptosense.com/|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; body_md = {js|
Based in Paris, France, Cryptosense creates security analysis software with a particular focus on cryptographic systems. A spin-off of the institute for computer science research (Inria), Cryptosense’s founders combine more than 40 years experience in research and industry. Cryptosense provides its solutions to an international clientèle in particular in the financial, industrial and government sectors.
|js}
  ; body_html = {js|<p>Based in Paris, France, Cryptosense creates security analysis software with a particular focus on cryptographic systems. A spin-off of the institute for computer science research (Inria), Cryptosense’s founders combine more than 40 years experience in research and industry. Cryptosense provides its solutions to an international clientèle in particular in the financial, industrial and government sectors.</p>
|js}
  };
 
  { name = {js|Dassault Systèmes|js}
  ; slug = {js|dassault-systmes|js}
  ; description = {js|Dassault Systèmes, the 3DEXPERIENCE Company, provides businesses and people with virtual universes to imagine sustainable innovations.
|js}
  ; image = Some {js|/users/dassault.png|js}
  ; site = {js|https://www.3ds.com/fr/|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; body_md = {js|
Dassault Systèmes, the 3DEXPERIENCE Company, provides businesses and people with virtual universes to imagine sustainable innovations.
|js}
  ; body_html = {js|<p>Dassault Systèmes, the 3DEXPERIENCE Company, provides businesses and people with virtual universes to imagine sustainable innovations.</p>
|js}
  };
 
  { name = {js|Dernier Cri|js}
  ; slug = {js|dernier-cri|js}
  ; description = {js|Dernier Cri is a French company based in Lille and Paris using functional programming to develop web and mobile applications.
|js}
  ; image = Some {js|/users/derniercri.png|js}
  ; site = {js|https://derniercri.io|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; body_md = {js|
Dernier Cri is a French company based in Lille and Paris using functional programming to develop web and mobile applications. OCaml is principally used to develop internal tools.
|js}
  ; body_html = {js|<p>Dernier Cri is a French company based in Lille and Paris using functional programming to develop web and mobile applications. OCaml is principally used to develop internal tools.</p>
|js}
  };
 
  { name = {js|Digirati dba Hostnet|js}
  ; slug = {js|digirati-dba-hostnet|js}
  ; description = {js|Digirati dba Hostnet is a web hosting company.
|js}
  ; image = Some {js|/users/hostnet.gif|js}
  ; site = {js|https://www.hostnet.com.br/|js}
  ; locations = 
 [{js|Brazil|js}]
  ; consortium = false
  ; body_md = {js|
Digirati dba Hostnet is a web hosting company. We use OCaml mostly for internal systems programming and infrastructure services. We have also contributed to the community by releasing a few open source [OCaml libraries](https://github.com/andrenth).
|js}
  ; body_html = {js|<p>Digirati dba Hostnet is a web hosting company. We use OCaml mostly for internal systems programming and infrastructure services. We have also contributed to the community by releasing a few open source <a href="https://github.com/andrenth">OCaml libraries</a>.</p>
|js}
  };
 
  { name = {js|Docker, Inc.|js}
  ; slug = {js|docker-inc|js}
  ; description = {js|Docker provides an integrated technology suite that enables development and IT operations teams to build, ship, and run distributed applications anywhere
|js}
  ; image = Some {js|/users/docker.png|js}
  ; site = {js|https://www.docker.com|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = true
  ; body_md = {js|
Docker provides an integrated technology suite that enables development and IT operations teams to build, ship, and run distributed applications anywhere. Their native [applications for Mac and Windows](https://blog.docker.com/2016/03/docker-for-mac-windows-beta/), use OCaml code taken from the [MirageOS](https://mirage.io) library operating system project. |js}
  ; body_html = {js|<p>Docker provides an integrated technology suite that enables development and IT operations teams to build, ship, and run distributed applications anywhere. Their native <a href="https://blog.docker.com/2016/03/docker-for-mac-windows-beta/">applications for Mac and Windows</a>, use OCaml code taken from the <a href="https://mirage.io">MirageOS</a> library operating system project.</p>
|js}
  };
 
  { name = {js|Esterel Technologies|js}
  ; slug = {js|esterel-technologies|js}
  ; description = {js|Esterel Technologies is a leading provider of critical systems and software development solutions for the aerospace, defense, rail transportation, nuclear, and industrial and automotive domains
|js}
  ; image = Some {js|/users/esterel.jpg|js}
  ; site = {js|https://www.esterel-technologies.com/|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = true
  ; body_md = {js|
Esterel Technologies is a leading provider of critical systems and software development solutions for the aerospace, defense, rail transportation, nuclear, and industrial and automotive domains.
|js}
  ; body_html = {js|<p>Esterel Technologies is a leading provider of critical systems and software development solutions for the aerospace, defense, rail transportation, nuclear, and industrial and automotive domains.</p>
|js}
  };
 
  { name = {js|Facebook|js}
  ; slug = {js|facebook|js}
  ; description = {js|Facebook has built a number of major development tools using OCaml|js}
  ; image = Some {js|/users/facebook.png|js}
  ; site = {js|https://www.facebook.com/|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = true
  ; body_md = {js|
Facebook has built a number of major development tools using OCaml. [Hack](https://hacklang.org) is a compiler for a variant of PHP that aims to reconcile the fast development cycle of PHP with the discipline provided by static typing. [Flow](https://flowtype.org) is a similar project that provides static type checking for Javascript.  Both systems are highly responsive, parallel programs that can incorporate source code changes in real time. [Pfff](https://github.com/facebook/pfff/wiki/Main) is a set of tools for code analysis, visualizations, and style-preserving source transformations, written in OCaml, but supporting many languages.|js}
  ; body_html = {js|<p>Facebook has built a number of major development tools using OCaml. <a href="https://hacklang.org">Hack</a> is a compiler for a variant of PHP that aims to reconcile the fast development cycle of PHP with the discipline provided by static typing. <a href="https://flowtype.org">Flow</a> is a similar project that provides static type checking for Javascript.  Both systems are highly responsive, parallel programs that can incorporate source code changes in real time. <a href="https://github.com/facebook/pfff/wiki/Main">Pfff</a> is a set of tools for code analysis, visualizations, and style-preserving source transformations, written in OCaml, but supporting many languages.</p>
|js}
  };
 
  { name = {js|Fasoo|js}
  ; slug = {js|fasoo|js}
  ; description = {js|Fasoo uses OCaml to develop a static analysis tool.
|js}
  ; image = Some {js|/users/fasoo.png|js}
  ; site = {js|https://www.fasoo.com|js}
  ; locations = 
 [{js|Korea|js}]
  ; consortium = false
  ; body_md = {js|
Fasoo uses OCaml to develop a static analysis tool.
|js}
  ; body_html = {js|<p>Fasoo uses OCaml to develop a static analysis tool.</p>
|js}
  };
 
  { name = {js|Flying Frog Consultancy|js}
  ; slug = {js|flying-frog-consultancy|js}
  ; description = {js|Flying Frog Consultancy Ltd. consult and write books and software on the use of OCaml in the context of scientific computing.
|js}
  ; image = Some {js|/users/flying-frog.png|js}
  ; site = {js|https://www.ffconsultancy.com|js}
  ; locations = 
 [{js|United Kingdom|js}]
  ; consortium = false
  ; body_md = {js|
Flying Frog Consultancy Ltd. consult and write books and software on the use of OCaml in the context of scientific computing. OCaml excels in the niche of intrinsically complicated programs between large-scale, array-based programs written in languages such as HPF and small-scale, graphical programs written in languages such as Mathematica.
|js}
  ; body_html = {js|<p>Flying Frog Consultancy Ltd. consult and write books and software on the use of OCaml in the context of scientific computing. OCaml excels in the niche of intrinsically complicated programs between large-scale, array-based programs written in languages such as HPF and small-scale, graphical programs written in languages such as Mathematica.</p>
|js}
  };
 
  { name = {js|ForAllSecure|js}
  ; slug = {js|forallsecure|js}
  ; description = {js|ForAllSecure's mission is to test the world's software and provide actionable information to our customers.
|js}
  ; image = Some {js|/users/forallsecure.svg|js}
  ; site = {js|https://forallsecure.com|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; body_md = {js|
ForAllSecure's mission is to test the world's software and provide actionable information to our customers. We have started with Linux. Our mission with Linux is to test all programs in current distributions, such as Debian, Ubuntu, and Red Hat. With time, we will cover other platforms, such as Mac, Windows, and mobile. In the meantime, we promise to do one thing well.
|js}
  ; body_html = {js|<p>ForAllSecure's mission is to test the world's software and provide actionable information to our customers. We have started with Linux. Our mission with Linux is to test all programs in current distributions, such as Debian, Ubuntu, and Red Hat. With time, we will cover other platforms, such as Mac, Windows, and mobile. In the meantime, we promise to do one thing well.</p>
|js}
  };
 
  { name = {js|Framtidsforum|js}
  ; slug = {js|framtidsforum|js}
  ; description = {js|Framtidsforum I&M sells ExcelEverywhere, which creates web pages that look and function the same as your MS Excel spreadsheet
|js}
  ; image = None
  ; site = {js|https://www.exceleverywhere.com|js}
  ; locations = 
 [{js|Sweden|js}]
  ; consortium = false
  ; body_md = {js|
Framtidsforum I&M sells ExcelEverywhere, which creates web pages that look and function the same as your MS Excel spreadsheet. JavaScript is used for calculation. Supports 140 Excel-functions. Typically used for expense report, survey, order forms, reservation forms, employment application, financial advisor, ROI. There are also versions that generate ASP, ASP.NET and JSP/Java code. The compiler is written using OCaml.
|js}
  ; body_html = {js|<p>Framtidsforum I&amp;M sells ExcelEverywhere, which creates web pages that look and function the same as your MS Excel spreadsheet. JavaScript is used for calculation. Supports 140 Excel-functions. Typically used for expense report, survey, order forms, reservation forms, employment application, financial advisor, ROI. There are also versions that generate ASP, ASP.NET and JSP/Java code. The compiler is written using OCaml.</p>
|js}
  };
 
  { name = {js|Galois|js}
  ; slug = {js|galois|js}
  ; description = {js|Galois has developed a domain specific declarative language for cryptographic algorithms.
|js}
  ; image = Some {js|/users/galois.png|js}
  ; site = {js|https://www.galois.com|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; body_md = {js|
Galois has developed a domain specific declarative language for cryptographic algorithms. One of our research compilers is written in OCaml and makes very extensive use of camlp4.
|js}
  ; body_html = {js|<p>Galois has developed a domain specific declarative language for cryptographic algorithms. One of our research compilers is written in OCaml and makes very extensive use of camlp4.</p>
|js}
  };
 
  { name = {js|Incubaid|js}
  ; slug = {js|incubaid|js}
  ; description = {js|Incubaid has developed Arakoon, a distributed key-value store that guarantees consistency above anything else.
|js}
  ; image = Some {js|/users/Incubaid.png|js}
  ; site = {js|https://incubaid.com|js}
  ; locations = 
 [{js|Belgium|js}]
  ; consortium = false
  ; body_md = {js|
Incubaid has developed <a href="https://github.com/Incubaid/arakoon">Arakoon</a>, a distributed key-value store that guarantees consistency above anything else. We created Arakoon due to a lack of existing solutions fitting our requirements, and is available as Open Source software.

|js}
  ; body_html = {js|<p>Incubaid has developed <a href="https://github.com/Incubaid/arakoon">Arakoon</a>, a distributed key-value store that guarantees consistency above anything else. We created Arakoon due to a lack of existing solutions fitting our requirements, and is available as Open Source software.</p>
|js}
  };
 
  { name = {js|Issuu|js}
  ; slug = {js|issuu|js}
  ; description = {js|Issuu is a digital publishing platform delivering exceptional reading experiences of magazines, catalogues, and newspapers
|js}
  ; image = Some {js|/users/issuu.gif|js}
  ; site = {js|https://issuu.com|js}
  ; locations = 
 [{js|Denmark|js}]
  ; consortium = false
  ; body_md = {js|
Issuu is a digital publishing platform delivering exceptional reading experiences of magazines, catalogues, and newspapers. Each month Issuu serves over 6 billion page views and 60 million users through their worldwide network. OCaml is used as part of the server-side systems, platforms, and web applications. The backend team is relatively small and the simplicity and scalability of both systems and processes are of vital importance.
|js}
  ; body_html = {js|<p>Issuu is a digital publishing platform delivering exceptional reading experiences of magazines, catalogues, and newspapers. Each month Issuu serves over 6 billion page views and 60 million users through their worldwide network. OCaml is used as part of the server-side systems, platforms, and web applications. The backend team is relatively small and the simplicity and scalability of both systems and processes are of vital importance.</p>
|js}
  };
 
  { name = {js|Jane Street|js}
  ; slug = {js|jane-street|js}
  ; description = {js|Jane Street is a quantitative trading firm that operates around the clock and around the globe
|js}
  ; image = Some {js|/users/jane-street.jpg|js}
  ; site = {js|https://janestreet.com|js}
  ; locations = 
 [{js|United States|js}; {js|United Kingdom|js}; {js|Hong Kong|js}]
  ; consortium = true
  ; body_md = {js|
Jane Street is a quantitative trading firm that operates around the clock and around the globe. They bring a deep understanding of markets, a scientific approach, and innovative technology to bear on the problem of trading profitably in the world's highly competitive financial markets. They're the largest commercial user of OCaml, using it for everything from research tools to trading systems to systems infrastructure to accounting systems. Jane Street has over 400 OCaml programmers and over 15 million lines of OCaml, powering a technology platform that trades billions of dollars every day. Half a million lines of their code are released [open source](https://opensource.janestreet.com), and they've created key parts of the open-source OCaml ecosystem, like [Dune](https://dune.build). You can learn more by checking out their [tech blog](https://blog.janestreet.com).
|js}
  ; body_html = {js|<p>Jane Street is a quantitative trading firm that operates around the clock and around the globe. They bring a deep understanding of markets, a scientific approach, and innovative technology to bear on the problem of trading profitably in the world's highly competitive financial markets. They're the largest commercial user of OCaml, using it for everything from research tools to trading systems to systems infrastructure to accounting systems. Jane Street has over 400 OCaml programmers and over 15 million lines of OCaml, powering a technology platform that trades billions of dollars every day. Half a million lines of their code are released <a href="https://opensource.janestreet.com">open source</a>, and they've created key parts of the open-source OCaml ecosystem, like <a href="https://dune.build">Dune</a>. You can learn more by checking out their <a href="https://blog.janestreet.com">tech blog</a>.</p>
|js}
  };
 
  { name = {js|Kernelize|js}
  ; slug = {js|kernelize|js}
  ; description = {js|Kernelyze has developed a novel approximation of two-variable functions that achieves the smallest possible worst-case error among all rank-n approximations.
|js}
  ; image = Some {js|/users/kernelyze-llc-logo.png|js}
  ; site = {js|https://kernelyze.com/|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = true
  ; body_md = {js|

Kernelyze has developed a novel approximation of two-variable functions
that achieves the smallest possible worst-case error among all rank-n
approximations.|js}
  ; body_html = {js|<p>Kernelyze has developed a novel approximation of two-variable functions
that achieves the smallest possible worst-case error among all rank-n
approximations.</p>
|js}
  };
 
  { name = {js|Kong|js}
  ; slug = {js|kong|js}
  ; description = {js|Kong makes it easy to distribute, monetize, manage and consume cloud APIs.
|js}
  ; image = Some {js|/users/mashape.png|js}
  ; site = {js|https://www.konghq.com|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; body_md = {js|
Kong makes it easy to distribute, monetize, manage and consume cloud APIs. Mashape is building a world-class marketplace for cloud APIs driven by a passionate community of developers from all over the world as well as enterprise API management and analytics products. We use OCaml in our [APIAnalytics](https://apianalytics.com) product — as part of a mission-critical, lightweight HTTP proxy.
|js}
  ; body_html = {js|<p>Kong makes it easy to distribute, monetize, manage and consume cloud APIs. Mashape is building a world-class marketplace for cloud APIs driven by a passionate community of developers from all over the world as well as enterprise API management and analytics products. We use OCaml in our <a href="https://apianalytics.com">APIAnalytics</a> product — as part of a mission-critical, lightweight HTTP proxy.</p>
|js}
  };
 
  { name = {js|LexiFi|js}
  ; slug = {js|lexifi|js}
  ; description = {js|LexiFi is an innovative provider of software applications and infrastructure technology for the capital markets industry.
|js}
  ; image = Some {js|/users/lexifi.png|js}
  ; site = {js|https://www.janestreet.com|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = true
  ; body_md = {js|
LexiFi is an innovative provider of software applications and infrastructure technology for the capital markets industry. LexiFi Apropos is powered by an original formalism for describing financial contracts, the result of a long-term research and development effort.|js}
  ; body_html = {js|<p>LexiFi is an innovative provider of software applications and infrastructure technology for the capital markets industry. LexiFi Apropos is powered by an original formalism for describing financial contracts, the result of a long-term research and development effort.</p>
|js}
  };
 
  { name = {js|Matrix Lead|js}
  ; slug = {js|matrix-lead|js}
  ; description = {js|Matrix Lead provides professionals and companies with leading technologies and solutions for spreadsheets. 
|js}
  ; image = Some {js|/users/matrixlead.png|js}
  ; site = {js|https://www.matrixlead.com|js}
  ; locations = 
 [{js|France|js}; {js|China|js}]
  ; consortium = false
  ; body_md = {js|
Matrix Lead provides professionals and companies with leading technologies and solutions for spreadsheets. We create a range of software to help users better build, verify, optimize and manage their spreadsheets. Our flagship product [10 Studio](https://www.10studio.tech) is a Microsoft Excel add-in that combines our several advanced tools, such as formula editor and spreadsheet verificator. The kernel of our tools is an analyzer that analyzes different properties of spreadsheets (including formulas and VBA macros) especially by abstract interpretation-based static analysis. It was initially developed in the Antiques team of Inria and written in OCaml. Then, we wrap web or .NET languages around the analyzer to make ready-to-use tools.
|js}
  ; body_html = {js|<p>Matrix Lead provides professionals and companies with leading technologies and solutions for spreadsheets. We create a range of software to help users better build, verify, optimize and manage their spreadsheets. Our flagship product <a href="https://www.10studio.tech">10 Studio</a> is a Microsoft Excel add-in that combines our several advanced tools, such as formula editor and spreadsheet verificator. The kernel of our tools is an analyzer that analyzes different properties of spreadsheets (including formulas and VBA macros) especially by abstract interpretation-based static analysis. It was initially developed in the Antiques team of Inria and written in OCaml. Then, we wrap web or .NET languages around the analyzer to make ready-to-use tools.</p>
|js}
  };
 
  { name = {js|MEDIT|js}
  ; slug = {js|medit|js}
  ; description = {js|MEDIT develops SuMo, an advanced bioinformatic system, for the analysis of protein 3D structures and the identification of drug-design targets. 
|js}
  ; image = Some {js|/users/medit.jpg|js}
  ; site = {js|https://www.medit-pharma.com/|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; body_md = {js|
MEDIT develops [SuMo, an advanced bioinformatic system]("https://mjambon.com/") for the analysis of protein 3D structures and the identification of drug-design targets. SuMo is written entirely in OCaml and provides interfaces to several commercial molecular-modeling packages.
|js}
  ; body_html = {js|<p>MEDIT develops <a href="%22https://mjambon.com/%22">SuMo, an advanced bioinformatic system</a> for the analysis of protein 3D structures and the identification of drug-design targets. SuMo is written entirely in OCaml and provides interfaces to several commercial molecular-modeling packages.</p>
|js}
  };
 
  { name = {js|Microsoft|js}
  ; slug = {js|microsoft|js}
  ; description = {js|Facebook has built a number of major development tools using OCaml
|js}
  ; image = Some {js|/users/microsoft.png|js}
  ; site = {js|https://www.microsoft.com|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = true
  ; body_md = {js|
|js}
  ; body_html = {js||js}
  };
 
  { name = {js|Mount Sinai|js}
  ; slug = {js|mount-sinai|js}
  ; description = {js|The Hammer Lab at Mount Sinai develops and uses Ketrew for managing complex bioinformatics workflows.
|js}
  ; image = Some {js|/users/mount-sinai.png|js}
  ; site = {js|https://www.mountsinai.org|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; body_md = {js|
The [Hammer Lab]("https://www.hammerlab.org") at Mount Sinai develops and uses [Ketrew]("https://github.com/hammerlab/ketrew") for managing complex bioinformatics workflows. Ketrew includes an embedded domain-specific language to simplify the specification of workflows and an engine for the execution of workflows. Ketrew can be run as a command-line application or as a service.
|js}
  ; body_html = {js|<p>The <a href="%22https://www.hammerlab.org%22">Hammer Lab</a> at Mount Sinai develops and uses <a href="%22https://github.com/hammerlab/ketrew%22">Ketrew</a> for managing complex bioinformatics workflows. Ketrew includes an embedded domain-specific language to simplify the specification of workflows and an engine for the execution of workflows. Ketrew can be run as a command-line application or as a service.</p>
|js}
  };
 
  { name = {js|Mr. Number|js}
  ; slug = {js|mr-number|js}
  ; description = {js|Mr. Number started as a Silicon Valley startup and developed the Mr. Number app for call blocking, later acquired by WhitePages.
|js}
  ; image = Some {js|/users/mrnumber.jpg|js}
  ; site = {js|https://mrnumber.com/|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; body_md = {js|
Mr. Number started as a Silicon Valley startup and developed the Mr. Number app for call blocking, later [acquired by WhitePages](https://allthingsd.com/20130601/whitepages-scoops-up-mr-number-an-android-app-for-blocking-unwanted-calls/). OCaml is used on the server-side as the glue between the various third-party components and services.</p>
|js}
  ; body_html = {js|<p>Mr. Number started as a Silicon Valley startup and developed the Mr. Number app for call blocking, later <a href="https://allthingsd.com/20130601/whitepages-scoops-up-mr-number-an-android-app-for-blocking-unwanted-calls/">acquired by WhitePages</a>. OCaml is used on the server-side as the glue between the various third-party components and services.</p></p>
|js}
  };
 
  { name = {js|MyLife|js}
  ; slug = {js|mylife|js}
  ; description = {js|MyLife has developed a powerful people search tool that will empower those in need to find anyone, regardless of years past and the life that was built in between.
|js}
  ; image = Some {js|/users/mylife.jpg|js}
  ; site = {js|https://www.mylife.com/|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; body_md = {js|
MyLife has developed a powerful people search tool that will empower those in need to find anyone, regardless of years past and the life that was built in between.|js}
  ; body_html = {js|<p>MyLife has developed a powerful people search tool that will empower those in need to find anyone, regardless of years past and the life that was built in between.</p>
|js}
  };
 
  { name = {js|Narrow Gate Logic|js}
  ; slug = {js|narrow-gate-logic|js}
  ; description = {js|Narrow Gate Logic is a company using the OCaml language in business and non-business applications.
|js}
  ; image = Some {js|/users/nglogic.png|js}
  ; site = {js|https://nglogic.com|js}
  ; locations = 
 [{js|Poland|js}]
  ; consortium = false
  ; body_md = {js|
Narrow Gate Logic is a company using the OCaml language in business and non-business applications.
|js}
  ; body_html = {js|<p>Narrow Gate Logic is a company using the OCaml language in business and non-business applications.</p>
|js}
  };
 
  { name = {js|Nomadic Labs|js}
  ; slug = {js|nomadic-labs|js}
  ; description = {js|Nomadic Labs houses a team focused on Research and Development. Our core competencies are in programming language theory and practice, distributed systems, and formal verification.
|js}
  ; image = Some {js|/users/nomadic-labs.png|js}
  ; site = {js|https://www.nomadic-labs.com|js}
  ; locations = 
 [{js|Paris, France|js}]
  ; consortium = false
  ; body_md = {js|
Nomadic Labs houses a team focused on Research and Development. Our
core competencies are in programming language theory and practice,
distributed systems, and formal verification. Nomadic Labs focuses on
contributing to the development of the Tezos core software, including
the smart-contract language, Michelson.

Tezos infrastructure is entirely implemented in OCaml. It strongly
relies on OCaml efficiency and expressivity. For instance, Michelson
smart contracts are represented using OCaml GADTs to prevent many
runtime errors from happening. Safety and correctness are critical for a
blockchain and we are glad that the OCaml type system allows for a
form of a lightweight formal method that can be used on a daily basis.
|js}
  ; body_html = {js|<p>Nomadic Labs houses a team focused on Research and Development. Our
core competencies are in programming language theory and practice,
distributed systems, and formal verification. Nomadic Labs focuses on
contributing to the development of the Tezos core software, including
the smart-contract language, Michelson.</p>
<p>Tezos infrastructure is entirely implemented in OCaml. It strongly
relies on OCaml efficiency and expressivity. For instance, Michelson
smart contracts are represented using OCaml GADTs to prevent many
runtime errors from happening. Safety and correctness are critical for a
blockchain and we are glad that the OCaml type system allows for a
form of a lightweight formal method that can be used on a daily basis.</p>
|js}
  };
 
  { name = {js|OCamlPro|js}
  ; slug = {js|ocamlpro|js}
  ; description = {js|OCamlPro develops and maintains a development environment for the OCaml language.
|js}
  ; image = Some {js|/users/ocamlpro.png|js}
  ; site = {js|https://www.ocamlpro.com|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = true
  ; body_md = {js|
OCamlPro develops and maintains a development environment for the OCaml language. They provide services for companies deciding to use OCaml. Among these services: trainings, necessary expertise, tools and libraries long-term support, and specific developments to their applicative domains.|js}
  ; body_html = {js|<p>OCamlPro develops and maintains a development environment for the OCaml language. They provide services for companies deciding to use OCaml. Among these services: trainings, necessary expertise, tools and libraries long-term support, and specific developments to their applicative domains.</p>
|js}
  };
 
  { name = {js|PRUDENT Technologies and Consulting, Inc.|js}
  ; slug = {js|prudent-technologies-and-consulting-inc|js}
  ; description = {js|Prudent Consulting offers IT solutions to large and mid-sized organizations by combining industry experience and technology expertise to help our customers achieve business goals with speed, agility, and great impact.
|js}
  ; image = Some {js|/users/prudent.jpg|js}
  ; site = {js|https://www.prudentconsulting.com|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; body_md = {js|
Prudent Consulting offers IT solutions to large and mid-sized organizations by combining industry experience and technology expertise to help our customers achieve business goals with speed, agility, and great impact.
|js}
  ; body_html = {js|<p>Prudent Consulting offers IT solutions to large and mid-sized organizations by combining industry experience and technology expertise to help our customers achieve business goals with speed, agility, and great impact.</p>
|js}
  };
 
  { name = {js|Psellos|js}
  ; slug = {js|psellos|js}
  ; description = {js|Psellos is a small group of computer scientists who became intrigued by the idea of coding iOS apps in OCaml.
|js}
  ; image = Some {js|/users/psellos.png|js}
  ; site = {js|https://www.psellos.com|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; body_md = {js|
Psellos is a small group of computer scientists who became intrigued by the idea of coding iOS apps in OCaml. It has worked out better than we expected (you can buy our apps in the iTunes App Store), and at least one other company sells apps built with our tools. Our most recent iOS cross compiler is derived from OCaml 4.00.0.|js}
  ; body_html = {js|<p>Psellos is a small group of computer scientists who became intrigued by the idea of coding iOS apps in OCaml. It has worked out better than we expected (you can buy our apps in the iTunes App Store), and at least one other company sells apps built with our tools. Our most recent iOS cross compiler is derived from OCaml 4.00.0.</p>
|js}
  };
 
  { name = {js|r2c|js}
  ; slug = {js|r2c|js}
  ; description = {js|r2c is a VC-funded security company headquartered in San Francisco and distributed worldwide
|js}
  ; image = Some {js|/users/r2c.png|js}
  ; site = {js|https://r2c.dev|js}
  ; locations = 
 [{js|California, United States|js}]
  ; consortium = false
  ; body_md = {js|
r2c is a VC-funded security company headquartered in San Francisco and distributed worldwide. The main product as of 2021 is [Semgrep](https://semgrep.dev/), an open-source,syntax-aware grep that supports many languages. OCaml is used extensively for parsing and analyzing source code.

Semgrep was originally open-sourced at Facebook and its roots lie in the Linux refactoring tool, [Coccinelle](https://coccinelle.gitlabpages.inria.fr/website/). r2c continues Semgrep’s development and is [hiring software engineers](https://jobs.lever.co/returntocorp) who specialize in program analysis.|js}
  ; body_html = {js|<p>r2c is a VC-funded security company headquartered in San Francisco and distributed worldwide. The main product as of 2021 is <a href="https://semgrep.dev/">Semgrep</a>, an open-source,syntax-aware grep that supports many languages. OCaml is used extensively for parsing and analyzing source code.</p>
<p>Semgrep was originally open-sourced at Facebook and its roots lie in the Linux refactoring tool, <a href="https://coccinelle.gitlabpages.inria.fr/website/">Coccinelle</a>. r2c continues Semgrep’s development and is <a href="https://jobs.lever.co/returntocorp">hiring software engineers</a> who specialize in program analysis.</p>
|js}
  };
 
  { name = {js|Sakhalin|js}
  ; slug = {js|sakhalin|js}
  ; description = {js|Sakhalin develops marine charting apps for Apple iPads and iPhones.
|js}
  ; image = None
  ; site = {js|https://www.seaiq.com|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; body_md = {js|
Sakhalin develops marine charting apps for Apple iPads and iPhones. The full-featured apps display marine charts, GPS and onboard sensor data, Automatic Identification System, weather data, anchor monitoring, etc. The apps have a wide range of users, from occasional recreational boaters to professional river/harbor pilots that board large freighters. They are free to download and try (with a paid upgrade to enable all features). They are written almost entirely in Ocaml with a minor amount of glue to interface with IOS APIs. Ocaml was chosen because it

 1. enables the rapid development of extremely reliable and high-performance software,
 2. is a mature stable platform
 3. has a wide range of libraries. 
 
It was made possible by the great work done by Psellos in porting OCaml to the Apple iOS platform. Feel free to contact Sakhalin if you have any questions about using OCaml on iOS.|js}
  ; body_html = {js|<p>Sakhalin develops marine charting apps for Apple iPads and iPhones. The full-featured apps display marine charts, GPS and onboard sensor data, Automatic Identification System, weather data, anchor monitoring, etc. The apps have a wide range of users, from occasional recreational boaters to professional river/harbor pilots that board large freighters. They are free to download and try (with a paid upgrade to enable all features). They are written almost entirely in Ocaml with a minor amount of glue to interface with IOS APIs. Ocaml was chosen because it</p>
<ol>
<li>enables the rapid development of extremely reliable and high-performance software,
</li>
<li>is a mature stable platform
</li>
<li>has a wide range of libraries.
</li>
</ol>
<p>It was made possible by the great work done by Psellos in porting OCaml to the Apple iOS platform. Feel free to contact Sakhalin if you have any questions about using OCaml on iOS.</p>
|js}
  };
 
  { name = {js|Shiro Games|js}
  ; slug = {js|shiro-games|js}
  ; description = {js|Shiro Games is developing games using Haxe, a language built with a compiler written in OCaml.
|js}
  ; image = Some {js|/users/shirogames.png|js}
  ; site = {js|https://www.shirogames.com|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; body_md = {js|
Shiro Games is developing games using [Haxe](https://haxe.org/), a language built with a compiler written in OCaml.|js}
  ; body_html = {js|<p>Shiro Games is developing games using <a href="https://haxe.org/">Haxe</a>, a language built with a compiler written in OCaml.</p>
|js}
  };
 
  { name = {js|SimCorp|js}
  ; slug = {js|simcorp|js}
  ; description = {js|Multi-asset platform to support investment decision-making and innovation.
|js}
  ; image = Some {js|/users/simcorp.png|js}
  ; site = {js|https://www.simcorp.com/|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = true
  ; body_md = {js|
Multi-asset platform to support investment decision-making and innovation.
|js}
  ; body_html = {js|<p>Multi-asset platform to support investment decision-making and innovation.</p>
|js}
  };
 
  { name = {js|Sleekersoft|js}
  ; slug = {js|sleekersoft|js}
  ; description = {js|Specialises in functional programming software development, consultation, and training.
|js}
  ; image = Some {js|/users/sleekersoft.png|js}
  ; site = {js|https://www.sleekersoft.com|js}
  ; locations = 
 [{js|Australia|js}]
  ; consortium = false
  ; body_md = {js|
Shiro Games is developing games using [Haxe](https://haxe.org/), a language built with a compiler written in OCaml.|js}
  ; body_html = {js|<p>Shiro Games is developing games using <a href="https://haxe.org/">Haxe</a>, a language built with a compiler written in OCaml.</p>
|js}
  };
 
  { name = {js|Solvuu|js}
  ; slug = {js|solvuu|js}
  ; description = {js|Solvuu's software allows users to store big and small data sets, share the data with collaborators, execute computationally intensive algorithms and workflows, and visualize results.
|js}
  ; image = Some {js|/users/solvuu.jpg|js}
  ; site = {js|https://www.solvuu.com|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; body_md = {js|
Solvuu's software allows users to store big and small data sets, share the data with collaborators, execute computationally intensive algorithms and workflows, and visualize results. Its initial focus is on genomics data, which has important implications for healthcare, agriculture, and fundamental research. Virtually all of Solvuu's software stack is implemented in OCaml.
|js}
  ; body_html = {js|<p>Solvuu's software allows users to store big and small data sets, share the data with collaborators, execute computationally intensive algorithms and workflows, and visualize results. Its initial focus is on genomics data, which has important implications for healthcare, agriculture, and fundamental research. Virtually all of Solvuu's software stack is implemented in OCaml.</p>
|js}
  };
 
  { name = {js|Studio Associato 4Sigma|js}
  ; slug = {js|studio-associato-4sigma|js}
  ; description = {js|4Sigma is a small firm making websites and some interesting web applications.
|js}
  ; image = Some {js|/users/4sigma.png|js}
  ; site = {js|https://www.4sigma.it|js}
  ; locations = 
 [{js|Italy|js}]
  ; consortium = false
  ; body_md = {js|
4Sigma is a small firm making websites and some interesting web applications. OCaml is not the main language used but it is used here and there, particularly in a small server that is a key component of a service we offer our customers.|js}
  ; body_html = {js|<p>4Sigma is a small firm making websites and some interesting web applications. OCaml is not the main language used but it is used here and there, particularly in a small server that is a key component of a service we offer our customers.</p>
|js}
  };
 
  { name = {js|Tarides|js}
  ; slug = {js|tarides|js}
  ; description = {js|Tarides builds and maintains open-source infrastructure tools in OCaml like MirageOS, Irmin and OCaml developer tools.
|js}
  ; image = Some {js|/users/tarides.png|js}
  ; site = {js|https://www.tarides.com|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; body_md = {js|
We are building and maintaining open-source infrastructure tools in OCaml:

 - [MirageOS](https://mirage.io), the most advanced unikernel project, where we build sandboxes, network and storage protocol implementations as libraries, so we can link them to our applications to run them without the need of an underlying operating system.
 - [Irmin]("https://irmin.org"), a Git-like datastore, which allows us to create fully auditable distributed systems which can work offline and be synced when needed.
 - OCaml development tools (build system, code linters, documentation generators, etc), to make us more efficient. 
  
Tarides was founded in early 2018 and is mainly based in Paris, France (remote work is possible).

|js}
  ; body_html = {js|<p>We are building and maintaining open-source infrastructure tools in OCaml:</p>
<ul>
<li><a href="https://mirage.io">MirageOS</a>, the most advanced unikernel project, where we build sandboxes, network and storage protocol implementations as libraries, so we can link them to our applications to run them without the need of an underlying operating system.
</li>
<li><a href="%22https://irmin.org%22">Irmin</a>, a Git-like datastore, which allows us to create fully auditable distributed systems which can work offline and be synced when needed.
</li>
<li>OCaml development tools (build system, code linters, documentation generators, etc), to make us more efficient.
</li>
</ul>
<p>Tarides was founded in early 2018 and is mainly based in Paris, France (remote work is possible).</p>
|js}
  };
 
  { name = {js|TrustInSoft|js}
  ; slug = {js|trustinsoft|js}
  ; description = {js|TrustInSoft is a company that changes the rules in cybersecurity. TrustInSoft is the software publisher of the software analysis Frama-C platform. 
|js}
  ; image = Some {js|/users/trustinsoft.png|js}
  ; site = {js|https://trust-in-soft.com|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; body_md = {js|
TrustInSoft is a company that changes the rules in cybersecurity. TrustInSoft is the software publisher of the software analysis [Frama-C](https://frama-c.com) platform. Our motto is simple: make the formal methods accessible to the majority of software developers.|js}
  ; body_html = {js|<p>TrustInSoft is a company that changes the rules in cybersecurity. TrustInSoft is the software publisher of the software analysis <a href="https://frama-c.com">Frama-C</a> platform. Our motto is simple: make the formal methods accessible to the majority of software developers.</p>
|js}
  };
 
  { name = {js|Wolfram MathCore|js}
  ; slug = {js|wolfram-mathcore|js}
  ; description = {js|Wolfram MathCore uses OCaml to implement its SystemModeler kernel.
|js}
  ; image = Some {js|/users/wolfram-mathcore.gif|js}
  ; site = {js|https://www.wolframmathcore.com|js}
  ; locations = 
 [{js|Sweden|js}]
  ; consortium = false
  ; body_md = {js|
Wolfram MathCore uses OCaml to implement its SystemModeler kernel. The kernel's main function is to translate models defined in the Modelica language into executable simulation code. This involves parsing and transforming Modelica code, mathematical processing of equations, code generation of C/C++ simulation code, and numerical runtime computations.
|js}
  ; body_html = {js|<p>Wolfram MathCore uses OCaml to implement its SystemModeler kernel. The kernel's main function is to translate models defined in the Modelica language into executable simulation code. This involves parsing and transforming Modelica code, mathematical processing of equations, code generation of C/C++ simulation code, and numerical runtime computations.</p>
|js}
  };
 
  { name = {js|Zeo Agency|js}
  ; slug = {js|zeo-agency|js}
  ; description = {js|Zeo is a digital marketing company focused on helping companies to do better in SEO.
|js}
  ; image = None
  ; site = {js|https://www.zeo.org|js}
  ; locations = 
 [{js|London, United Kingdom|js}]
  ; consortium = false
  ; body_md = {js|
Zeo is a digital marketing company focused on helping companies to do better in SEO. Due to the nature of our business, we manage billions of lines in our database & create insights by using this data. To utilize our needs effectively, we use OCaml in our data crawling & processing part.
|js}
  ; body_html = {js|<p>Zeo is a digital marketing company focused on helping companies to do better in SEO. Due to the nature of our business, we manage billions of lines in our database &amp; create insights by using this data. To utilize our needs effectively, we use OCaml in our data crawling &amp; processing part.</p>
|js}
  }]

