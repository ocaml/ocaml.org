
type t =
  { name : string
  ; slug : string
  ; description : string
  ; logo : string option
  ; url : string
  ; locations : string list
  ; consortium : bool
  ; featured : bool
  ; body_md : string
  ; body_html : string
  }
  
let all_en = 
[
  { name = {js|Aesthetic Integration|js}
  ; slug = {js|aesthetic-integration|js}
  ; description = {js|Aesthetic Integration (AI) is a financial technology startup based in the City of London
|js}
  ; logo = Some {js|/users/aesthetic-integration.png|js}
  ; url = {js|https://www.aestheticintegration.com|js}
  ; locations = 
 [{js|United Kingdom|js}]
  ; consortium = true
  ; featured = true
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
  ; logo = Some {js|/users/ahrefs.png|js}
  ; url = {js|https://www.ahrefs.com|js}
  ; locations = 
 [{js|Singapore|js}; {js|United States|js}]
  ; consortium = true
  ; featured = true
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
  ; logo = Some {js|/users/amnh.png|js}
  ; url = {js|https://www.amnh.org/our-research/computational-sciences|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/anssi.png|js}
  ; url = {js|https://www.ssi.gouv.fr/|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/arena.jpg|js}
  ; url = {js|https://www.arena.io|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Arena helps organizations hire the right people. We do that by applying big data and predictive analytics to the hiring process. This results in less turnover for our clients and less discrimination for individuals. We use OCaml for all of our backend development.|js}
  ; body_html = {js|<p>Arena helps organizations hire the right people. We do that by applying big data and predictive analytics to the hiring process. This results in less turnover for our clients and less discrimination for individuals. We use OCaml for all of our backend development.</p>
|js}
  };
 
  { name = {js|Be Sport|js}
  ; slug = {js|be-sport|js}
  ; description = {js|Be Sport's mission is to enhance the value that sport brings to our lives with appropriate use of digital and social media innovations
|js}
  ; logo = Some {js|/users/besport.png|js}
  ; url = {js|https://besport.com/|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = true
  ; featured = true
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
  ; logo = Some {js|/users/bloomberg.jpg|js}
  ; url = {js|https://www.bloomberg.com|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = true
  ; featured = true
  ; body_md = {js|
Bloomberg, the global business and financial information and news leader, gives influential decision makers a critical edge by connecting them to a dynamic network of information, people and ideas. Bloomberg employs OCaml in an advanced financial derivatives risk management application delivered through its Bloomberg Professional service.|js}
  ; body_html = {js|<p>Bloomberg, the global business and financial information and news leader, gives influential decision makers a critical edge by connecting them to a dynamic network of information, people and ideas. Bloomberg employs OCaml in an advanced financial derivatives risk management application delivered through its Bloomberg Professional service.</p>
|js}
  };
 
  { name = {js|CACAOWEB|js}
  ; slug = {js|cacaoweb|js}
  ; description = {js|Cacaoweb is developing an application platform of a new kind. It runs on top of our peer-to-peer network, which happens to be one of the largest in the world
|js}
  ; logo = Some {js|/users/cacaoweb.png|js}
  ; url = {js|https://cacaoweb.org/|js}
  ; locations = 
 [{js|United Kingdom|js}; {js|Hong Kong|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/cea.png|js}
  ; url = {js|https://cea.fr/|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = true
  ; featured = true
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
  ; logo = Some {js|/users/citrix.png|js}
  ; url = {js|https://www.citrix.com|js}
  ; locations = 
 [{js|United Kingdom|js}]
  ; consortium = true
  ; featured = true
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
  ; logo = Some {js|/users/coherent.png|js}
  ; url = {js|https://www.coherentpdf.com/|js}
  ; locations = 
 [{js|United Kingdom|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/cryptosense.png|js}
  ; url = {js|https://www.cryptosense.com/|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/dassault.png|js}
  ; url = {js|https://www.3ds.com/fr/|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/derniercri.png|js}
  ; url = {js|https://derniercri.io|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/hostnet.gif|js}
  ; url = {js|https://www.hostnet.com.br/|js}
  ; locations = 
 [{js|Brazil|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/docker.png|js}
  ; url = {js|https://www.docker.com|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = true
  ; featured = true
  ; body_md = {js|
Docker provides an integrated technology suite that enables development and IT operations teams to build, ship, and run distributed applications anywhere. Their native [applications for Mac and Windows](https://blog.docker.com/2016/03/docker-for-mac-windows-beta/), use OCaml code taken from the [MirageOS](https://mirage.io) library operating system project. |js}
  ; body_html = {js|<p>Docker provides an integrated technology suite that enables development and IT operations teams to build, ship, and run distributed applications anywhere. Their native <a href="https://blog.docker.com/2016/03/docker-for-mac-windows-beta/">applications for Mac and Windows</a>, use OCaml code taken from the <a href="https://mirage.io">MirageOS</a> library operating system project.</p>
|js}
  };
 
  { name = {js|Esterel Technologies|js}
  ; slug = {js|esterel-technologies|js}
  ; description = {js|Esterel Technologies is a leading provider of critical systems and software development solutions for the aerospace, defense, rail transportation, nuclear, and industrial and automotive domains
|js}
  ; logo = Some {js|/users/esterel.jpg|js}
  ; url = {js|https://www.esterel-technologies.com/|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = true
  ; featured = true
  ; body_md = {js|
Esterel Technologies is a leading provider of critical systems and software development solutions for the aerospace, defense, rail transportation, nuclear, and industrial and automotive domains.
|js}
  ; body_html = {js|<p>Esterel Technologies is a leading provider of critical systems and software development solutions for the aerospace, defense, rail transportation, nuclear, and industrial and automotive domains.</p>
|js}
  };
 
  { name = {js|Facebook|js}
  ; slug = {js|facebook|js}
  ; description = {js|Facebook has built a number of major development tools using OCaml|js}
  ; logo = Some {js|/users/facebook.png|js}
  ; url = {js|https://www.facebook.com/|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = true
  ; featured = true
  ; body_md = {js|
Facebook has built a number of major development tools using OCaml. [Hack](https://hacklang.org) is a compiler for a variant of PHP that aims to reconcile the fast development cycle of PHP with the discipline provided by static typing. [Flow](https://flowtype.org) is a similar project that provides static type checking for Javascript.  Both systems are highly responsive, parallel programs that can incorporate source code changes in real time. [Pfff](https://github.com/facebook/pfff/wiki/Main) is a set of tools for code analysis, visualizations, and style-preserving source transformations, written in OCaml, but supporting many languages.|js}
  ; body_html = {js|<p>Facebook has built a number of major development tools using OCaml. <a href="https://hacklang.org">Hack</a> is a compiler for a variant of PHP that aims to reconcile the fast development cycle of PHP with the discipline provided by static typing. <a href="https://flowtype.org">Flow</a> is a similar project that provides static type checking for Javascript.  Both systems are highly responsive, parallel programs that can incorporate source code changes in real time. <a href="https://github.com/facebook/pfff/wiki/Main">Pfff</a> is a set of tools for code analysis, visualizations, and style-preserving source transformations, written in OCaml, but supporting many languages.</p>
|js}
  };
 
  { name = {js|Fasoo|js}
  ; slug = {js|fasoo|js}
  ; description = {js|Fasoo uses OCaml to develop a static analysis tool.
|js}
  ; logo = Some {js|/users/fasoo.png|js}
  ; url = {js|https://www.fasoo.com|js}
  ; locations = 
 [{js|Korea|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/flying-frog.png|js}
  ; url = {js|https://www.ffconsultancy.com|js}
  ; locations = 
 [{js|United Kingdom|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/forallsecure.png|js}
  ; url = {js|https://forallsecure.com|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
ForAllSecure's mission is to test the world's software and provide actionable information to our customers. We have started with Linux. Our mission with Linux is to test all programs in current distributions, such as Debian, Ubuntu, and Red Hat. With time, we will cover other platforms, such as Mac, Windows, and mobile. In the meantime, we promise to do one thing well.
|js}
  ; body_html = {js|<p>ForAllSecure's mission is to test the world's software and provide actionable information to our customers. We have started with Linux. Our mission with Linux is to test all programs in current distributions, such as Debian, Ubuntu, and Red Hat. With time, we will cover other platforms, such as Mac, Windows, and mobile. In the meantime, we promise to do one thing well.</p>
|js}
  };
 
  { name = {js|Functori|js}
  ; slug = {js|functori|js}
  ; description = {js|Functori is a R&D company created by experienced engineers in programming languages (particularly OCaml), formal verification (automated reasoning, model checking, ...), and blockchain technology (core, smart contracts and applications development).
|js}
  ; logo = Some {js|/users/functori.png|js}
  ; url = {js|https://www.functori.com|js}
  ; locations = 
 [{js|Paris, France|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
In addition to contributing tools and libraries in OCaml and for the
OCaml community, we are participating in the development of the Tezos
blockchain in various ways:

 - core development,
 - building open-source tooling and libraries for the community (like
indexers/crawlers, libraries to interact with the Tezos blockchain,
etc.),
 - participating in the development of innovative projects for
our clients,
 - auditing code for our clients,
 - consulting and training.

Functori was founded in 2021 and is based in Paris (France), with
people working remotely all around the world.
|js}
  ; body_html = {js|<p>In addition to contributing tools and libraries in OCaml and for the
OCaml community, we are participating in the development of the Tezos
blockchain in various ways:</p>
<ul>
<li>core development,
</li>
<li>building open-source tooling and libraries for the community (like
indexers/crawlers, libraries to interact with the Tezos blockchain,
etc.),
</li>
<li>participating in the development of innovative projects for
our clients,
</li>
<li>auditing code for our clients,
</li>
<li>consulting and training.
</li>
</ul>
<p>Functori was founded in 2021 and is based in Paris (France), with
people working remotely all around the world.</p>
|js}
  };
 
  { name = {js|Galois|js}
  ; slug = {js|galois|js}
  ; description = {js|Galois has developed a domain specific declarative language for cryptographic algorithms.
|js}
  ; logo = Some {js|/users/galois.png|js}
  ; url = {js|https://www.galois.com|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/Incubaid.png|js}
  ; url = {js|https://incubaid.com|js}
  ; locations = 
 [{js|Belgium|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/issuu.gif|js}
  ; url = {js|https://issuu.com|js}
  ; locations = 
 [{js|Denmark|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/jane-street.jpg|js}
  ; url = {js|https://janestreet.com|js}
  ; locations = 
 [{js|United States|js}; {js|United Kingdom|js}; {js|Hong Kong|js}]
  ; consortium = true
  ; featured = true
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
  ; logo = Some {js|/users/kernelyze-llc-logo.png|js}
  ; url = {js|https://kernelyze.com/|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = true
  ; featured = true
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
  ; logo = Some {js|/users/mashape.png|js}
  ; url = {js|https://www.konghq.com|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/lexifi.png|js}
  ; url = {js|https://www.lexifi.com|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = true
  ; featured = true
  ; body_md = {js|
LexiFi is an innovative provider of software applications and infrastructure technology for the capital markets industry. LexiFi Apropos is powered by an original formalism for describing financial contracts, the result of a long-term research and development effort.
|js}
  ; body_html = {js|<p>LexiFi is an innovative provider of software applications and infrastructure technology for the capital markets industry. LexiFi Apropos is powered by an original formalism for describing financial contracts, the result of a long-term research and development effort.</p>
|js}
  };
 
  { name = {js|Matrix Lead|js}
  ; slug = {js|matrix-lead|js}
  ; description = {js|Matrix Lead provides professionals and companies with leading technologies and solutions for spreadsheets. 
|js}
  ; logo = Some {js|/users/matrixlead.png|js}
  ; url = {js|https://www.matrixlead.com|js}
  ; locations = 
 [{js|France|js}; {js|China|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/medit.jpg|js}
  ; url = {js|https://www.medit-pharma.com/|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
MEDIT develops [SuMo, an advanced bioinformatic system]("https://mjambon.com/") for the analysis of protein 3D structures and the identification of drug-design targets. SuMo is written entirely in OCaml and provides interfaces to several commercial molecular-modeling packages.
|js}
  ; body_html = {js|<p>MEDIT develops <a href="%22https://mjambon.com/%22">SuMo, an advanced bioinformatic system</a> for the analysis of protein 3D structures and the identification of drug-design targets. SuMo is written entirely in OCaml and provides interfaces to several commercial molecular-modeling packages.</p>
|js}
  };
 
  { name = {js|Microsoft|js}
  ; slug = {js|microsoft|js}
  ; description = {js|Microsoft Corporation is an American multinational technology corporation which produces computer software, consumer electronics, personal computers, and related services.
|js}
  ; logo = Some {js|/users/microsoft.png|js}
  ; url = {js|https://www.microsoft.com|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = true
  ; featured = true
  ; body_md = {js|
Microsoft Corporation is an American multinational technology corporation which produces computer software, consumer electronics, personal computers, and related services.
|js}
  ; body_html = {js|<p>Microsoft Corporation is an American multinational technology corporation which produces computer software, consumer electronics, personal computers, and related services.</p>
|js}
  };
 
  { name = {js|Mount Sinai|js}
  ; slug = {js|mount-sinai|js}
  ; description = {js|The Hammer Lab at Mount Sinai develops and uses Ketrew for managing complex bioinformatics workflows.
|js}
  ; logo = Some {js|/users/mount-sinai.png|js}
  ; url = {js|https://www.mountsinai.org|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/mrnumber.jpg|js}
  ; url = {js|https://mrnumber.com/|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/mylife.jpg|js}
  ; url = {js|https://www.mylife.com/|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
MyLife has developed a powerful people search tool that will empower those in need to find anyone, regardless of years past and the life that was built in between.|js}
  ; body_html = {js|<p>MyLife has developed a powerful people search tool that will empower those in need to find anyone, regardless of years past and the life that was built in between.</p>
|js}
  };
 
  { name = {js|Narrow Gate Logic|js}
  ; slug = {js|narrow-gate-logic|js}
  ; description = {js|Narrow Gate Logic is a company using the OCaml language in business and non-business applications.
|js}
  ; logo = Some {js|/users/nglogic.png|js}
  ; url = {js|https://nglogic.com|js}
  ; locations = 
 [{js|Poland|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/nomadic-labs.png|js}
  ; url = {js|https://www.nomadic-labs.com|js}
  ; locations = 
 [{js|Paris, France|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/ocamlpro.png|js}
  ; url = {js|https://www.ocamlpro.com|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = true
  ; featured = true
  ; body_md = {js|
OCamlPro develops and maintains a development environment for the OCaml language. They provide services for companies deciding to use OCaml. Among these services: trainings, necessary expertise, tools and libraries long-term support, and specific developments to their applicative domains.|js}
  ; body_html = {js|<p>OCamlPro develops and maintains a development environment for the OCaml language. They provide services for companies deciding to use OCaml. Among these services: trainings, necessary expertise, tools and libraries long-term support, and specific developments to their applicative domains.</p>
|js}
  };
 
  { name = {js|PRUDENT Technologies and Consulting, Inc.|js}
  ; slug = {js|prudent-technologies-and-consulting-inc|js}
  ; description = {js|Prudent Consulting offers IT solutions to large and mid-sized organizations by combining industry experience and technology expertise to help our customers achieve business goals with speed, agility, and great impact.
|js}
  ; logo = Some {js|/users/prudent.jpg|js}
  ; url = {js|https://www.prudentconsulting.com|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/psellos.png|js}
  ; url = {js|https://www.psellos.com|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Psellos is a small group of computer scientists who became intrigued by the idea of coding iOS apps in OCaml. It has worked out better than we expected (you can buy our apps in the iTunes App Store), and at least one other company sells apps built with our tools. Our most recent iOS cross compiler is derived from OCaml 4.00.0.|js}
  ; body_html = {js|<p>Psellos is a small group of computer scientists who became intrigued by the idea of coding iOS apps in OCaml. It has worked out better than we expected (you can buy our apps in the iTunes App Store), and at least one other company sells apps built with our tools. Our most recent iOS cross compiler is derived from OCaml 4.00.0.</p>
|js}
  };
 
  { name = {js|r2c|js}
  ; slug = {js|r2c|js}
  ; description = {js|r2c is a VC-funded security company headquartered in San Francisco and distributed worldwide
|js}
  ; logo = Some {js|/users/r2c.png|js}
  ; url = {js|https://r2c.dev|js}
  ; locations = 
 [{js|California, United States|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/seaiq.png|js}
  ; url = {js|https://www.seaiq.com|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Sakhalin develops marine charting apps for Apple iPads and iPhones. The full-featured apps display marine charts, GPS and onboard sensor data, Automatic Identification System, weather data, anchor monitoring, etc. The apps have a wide range of users, from occasional recreational boaters to professional river/harbor pilots that board large freighters. They are free to download and try (with a paid upgrade to enable all features). They are written almost entirely in Ocaml with a minor amount of glue to interface with IOS APIs. Ocaml was chosen because it

 1. enables the rapid development of extremely reliable and high-performance software,
 2. is a mature stable platform
 3. has a wide range of libraries. 
 
It was made possible by the great work done by Psellos in porting OCaml to the Apple iOS platform. Feel free to contact Sakhalin if you have any questions about using OCaml on iOS.
|js}
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
  ; logo = Some {js|/users/shirogames.png|js}
  ; url = {js|https://www.shirogames.com|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Shiro Games is developing games using [Haxe](https://haxe.org/), a language built with a compiler written in OCaml.|js}
  ; body_html = {js|<p>Shiro Games is developing games using <a href="https://haxe.org/">Haxe</a>, a language built with a compiler written in OCaml.</p>
|js}
  };
 
  { name = {js|SimCorp|js}
  ; slug = {js|simcorp|js}
  ; description = {js|Multi-asset platform to support investment decision-making and innovation.
|js}
  ; logo = Some {js|/users/simcorp.png|js}
  ; url = {js|https://www.simcorp.com/|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = true
  ; featured = true
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
  ; logo = Some {js|/users/sleekersoft.png|js}
  ; url = {js|https://www.sleekersoft.com|js}
  ; locations = 
 [{js|Australia|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Specialises in functional programming software development, consultation, and training.
|js}
  ; body_html = {js|<p>Specialises in functional programming software development, consultation, and training.</p>
|js}
  };
 
  { name = {js|Solvuu|js}
  ; slug = {js|solvuu|js}
  ; description = {js|Solvuu's software allows users to store big and small data sets, share the data with collaborators, execute computationally intensive algorithms and workflows, and visualize results.
|js}
  ; logo = Some {js|/users/solvuu.jpg|js}
  ; url = {js|https://www.solvuu.com|js}
  ; locations = 
 [{js|United States|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/4sigma.png|js}
  ; url = {js|https://www.4sigma.it|js}
  ; locations = 
 [{js|Italy|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
4Sigma is a small firm making websites and some interesting web applications. OCaml is not the main language used but it is used here and there, particularly in a small server that is a key component of a service we offer our customers.|js}
  ; body_html = {js|<p>4Sigma is a small firm making websites and some interesting web applications. OCaml is not the main language used but it is used here and there, particularly in a small server that is a key component of a service we offer our customers.</p>
|js}
  };
 
  { name = {js|Tarides|js}
  ; slug = {js|tarides|js}
  ; description = {js|Tarides builds and maintains open-source infrastructure tools in OCaml like MirageOS, Irmin and OCaml developer tools.
|js}
  ; logo = Some {js|/users/tarides.png|js}
  ; url = {js|https://www.tarides.com|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/trustinsoft.png|js}
  ; url = {js|https://trust-in-soft.com|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
TrustInSoft is a company that changes the rules in cybersecurity. TrustInSoft is the software publisher of the software analysis [Frama-C](https://frama-c.com) platform. Our motto is simple: make the formal methods accessible to the majority of software developers.|js}
  ; body_html = {js|<p>TrustInSoft is a company that changes the rules in cybersecurity. TrustInSoft is the software publisher of the software analysis <a href="https://frama-c.com">Frama-C</a> platform. Our motto is simple: make the formal methods accessible to the majority of software developers.</p>
|js}
  };
 
  { name = {js|Wolfram MathCore|js}
  ; slug = {js|wolfram-mathcore|js}
  ; description = {js|Wolfram MathCore uses OCaml to implement its SystemModeler kernel.
|js}
  ; logo = Some {js|/users/wolfram-mathcore.gif|js}
  ; url = {js|https://www.wolframmathcore.com|js}
  ; locations = 
 [{js|Sweden|js}]
  ; consortium = false
  ; featured = true
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
  ; logo = Some {js|/users/zeo.svg|js}
  ; url = {js|https://www.zeo.org|js}
  ; locations = 
 [{js|London, United Kingdom|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Zeo is a digital marketing company focused on helping companies to do better in SEO. Due to the nature of our business, we manage billions of lines in our database & create insights by using this data. To utilize our needs effectively, we use OCaml in our data crawling & processing part.
|js}
  ; body_html = {js|<p>Zeo is a digital marketing company focused on helping companies to do better in SEO. Due to the nature of our business, we manage billions of lines in our database &amp; create insights by using this data. To utilize our needs effectively, we use OCaml in our data crawling &amp; processing part.</p>
|js}
  }]

let all_fr = 
[
  { name = {js|Aesthetic Integration|js}
  ; slug = {js|aesthetic-integration|js}
  ; description = {js|Aesthetic Integration (AI) est une startup financière basée dans la City de Londres
|js}
  ; logo = Some {js|/users/aesthetic-integration.png|js}
  ; url = {js|https://www.aestheticintegration.com|js}
  ; locations = 
 [{js|Royaume-Uni|js}]
  ; consortium = true
  ; featured = true
  ; body_md = {js|
Aesthetic Integration (AI) est une startup financière basée dans la City de Londres. Sa technologie de vérification formelle de brevets déposés révolutionne la sureté, la stabilité et la transparence des marchés financiers globaux.
|js}
  ; body_html = {js|<p>Aesthetic Integration (AI) est une startup financière basée dans la City de Londres. Sa technologie de vérification formelle de brevets déposés révolutionne la sureté, la stabilité et la transparence des marchés financiers globaux.</p>
|js}
  };
 
  { name = {js|Ahrefs|js}
  ; slug = {js|ahrefs|js}
  ; description = {js|Ahrefs développe des systèmes de stockages sur mesure allant jusqu'aux pétaoctets et fait tourner un robot d'exploration d'Internet pour indexer le web tout entier
|js}
  ; logo = Some {js|/users/ahrefs.png|js}
  ; url = {js|https://www.ahrefs.com|js}
  ; locations = 
 [{js|Singapour|js}; {js|États-Unis|js}]
  ; consortium = true
  ; featured = true
  ; body_md = {js|
Ahrefs développe des systèmes de stockages sur mesure allant jusqu'aux pétaoctets et fait tourner un robot d'exploration d'Internet pour indexer le web tout entier. À partir de cette entreprise sont construits différents services d'analyses pour les utilisateurs finaux. OCaml est le langage principal du backend de Ahrefs, qui traite jusqu'à 6 milliards de pages par jour. Ahrefs est une équipe multinationale ayant des racines en Ukraine et des bureaux à Singapour et San Francisco.
|js}
  ; body_html = {js|<p>Ahrefs développe des systèmes de stockages sur mesure allant jusqu'aux pétaoctets et fait tourner un robot d'exploration d'Internet pour indexer le web tout entier. À partir de cette entreprise sont construits différents services d'analyses pour les utilisateurs finaux. OCaml est le langage principal du backend de Ahrefs, qui traite jusqu'à 6 milliards de pages par jour. Ahrefs est une équipe multinationale ayant des racines en Ukraine et des bureaux à Singapour et San Francisco.</p>
|js}
  };
 
  { name = {js|American Museum of Natural History|js}
  ; slug = {js|american-museum-of-natural-history|js}
  ; description = {js|Le Département des Sciences Computationnelles du AMNH utilise OCaml depuis presque une décennie pour leur suite de logiciels POY pour site d'interférence phylogénétique: "https://www.amnh.org/our-research/computational-sciences"
|js}
  ; logo = Some {js|/users/amnh.png|js}
  ; url = {js|https://www.amnh.org/our-research/computational-sciences|js}
  ; locations = 
 [{js|États-Unis|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Le Département des Sciences Computationnelles du AMNH utilise OCaml depuis presque une décennie pour leur suite de logiciels POY pour site d'interférence phylogénétique: "https://www.amnh.org/our-research/computational-sciences". Voir la [Page GitHub de l'AMNH](https://github.com/AMNH) pour plus de projets.
|js}
  ; body_html = {js|<p>Le Département des Sciences Computationnelles du AMNH utilise OCaml depuis presque une décennie pour leur suite de logiciels POY pour site d'interférence phylogénétique: &quot;https://www.amnh.org/our-research/computational-sciences&quot;. Voir la <a href="https://github.com/AMNH">Page GitHub de l'AMNH</a> pour plus de projets.</p>
|js}
  };
 
  { name = {js|ANSSI|js}
  ; slug = {js|anssi|js}
  ; description = {js|Les missions principales de l'ANSSI sont : de détecter et réagir à des cyberattaques, de prévenir des menaces, de fournir du conseil et du support à des entités gouvernemental et à des opérateurs d'infrastructures critiques, et de garder les entreprises et le grand public informé sur des menaces pour la sécurité des informations
|js}
  ; logo = Some {js|/users/anssi.png|js}
  ; url = {js|https://www.ssi.gouv.fr/|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Les missions principales de l'ANSSI sont : de détecter et réagir à des cyberattaques, de prévenir des menaces, de fournir du conseil et du support à des entités gouvernemental et à des opérateurs d'infrastructures critiques, et de garder les entreprises et le grand public informé sur des menaces pour la sécurité des informations. Voir [la page Github de l'ANSSI](https://github.com/anssi-fr) pour certains de ses logiciels en OCaml.
|js}
  ; body_html = {js|<p>Les missions principales de l'ANSSI sont : de détecter et réagir à des cyberattaques, de prévenir des menaces, de fournir du conseil et du support à des entités gouvernemental et à des opérateurs d'infrastructures critiques, et de garder les entreprises et le grand public informé sur des menaces pour la sécurité des informations. Voir <a href="https://github.com/anssi-fr">la page Github de l'ANSSI</a> pour certains de ses logiciels en OCaml.</p>
|js}
  };
 
  { name = {js|Arena|js}
  ; slug = {js|arena|js}
  ; description = {js|Arena aide les organisations à embaucher les bonnes personnes.
|js}
  ; logo = Some {js|/users/arena.jpg|js}
  ; url = {js|https://www.arena.io|js}
  ; locations = 
 [{js|États-Unis|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Arena aide les organisations à embaucher les bonnes personnes. Nous réalisons cela en appliquant le Big Data et l'analyse prédictive au processus de recrutement. Cela résulte à moins de roulement pour nos clients et à moins de discrimination pour les individus. Nous utilisons OCaml pour tout notre backend de développement.
|js}
  ; body_html = {js|<p>Arena aide les organisations à embaucher les bonnes personnes. Nous réalisons cela en appliquant le Big Data et l'analyse prédictive au processus de recrutement. Cela résulte à moins de roulement pour nos clients et à moins de discrimination pour les individus. Nous utilisons OCaml pour tout notre backend de développement.</p>
|js}
  };
 
  { name = {js|Be Sport|js}
  ; slug = {js|be-sport|js}
  ; description = {js|La mission de Be Sport est d'augmenter la valeur que le sport apporte dans nos vies avec une utilisation appropriée des innovations numériques et des réseaux sociaux.
|js}
  ; logo = Some {js|/users/besport.png|js}
  ; url = {js|https://besport.com/|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = true
  ; featured = true
  ; body_md = {js|
La mission de Be Sport est d'augmenter la valeur que le sport apporte dans nos vies avec une utilisation appropriée des innovations numériques et des réseaux sociaux.

Be Sport un projet 100% en [OCaml](https://ocaml.org) et [OCsigen](https://ocsigen.org), qui sont les seules briques de base pour développer la plateforme
|js}
  ; body_html = {js|<p>La mission de Be Sport est d'augmenter la valeur que le sport apporte dans nos vies avec une utilisation appropriée des innovations numériques et des réseaux sociaux.</p>
<p>Be Sport un projet 100% en <a href="https://ocaml.org">OCaml</a> et <a href="https://ocsigen.org">OCsigen</a>, qui sont les seules briques de base pour développer la plateforme</p>
|js}
  };
 
  { name = {js|Bloomberg L.P.|js}
  ; slug = {js|bloomberg-lp|js}
  ; description = {js|Bloomberg, le leader mondial de l'information et des actualités commerciales et financières, donne aux décideurs influents un avantage décisif en les connectant à un réseau dynamique d'informations, de personnes et d'idées
|js}
  ; logo = Some {js|/users/bloomberg.jpg|js}
  ; url = {js|https://www.bloomberg.com|js}
  ; locations = 
 [{js|États-Unis|js}]
  ; consortium = true
  ; featured = true
  ; body_md = {js|
Bloomberg, le leader mondial de l'information et des actualités commerciales et financières, donne aux décideurs influents un avantage décisif en les connectant à un réseau dynamique d'informations, de personnes et d'idées. Bloomberg utilise OCaml dans une application avancée de gestion des risques liés aux produits financiers dérivés, fournie par son service Bloomberg Professional.
|js}
  ; body_html = {js|<p>Bloomberg, le leader mondial de l'information et des actualités commerciales et financières, donne aux décideurs influents un avantage décisif en les connectant à un réseau dynamique d'informations, de personnes et d'idées. Bloomberg utilise OCaml dans une application avancée de gestion des risques liés aux produits financiers dérivés, fournie par son service Bloomberg Professional.</p>
|js}
  };
 
  { name = {js|CACAOWEB|js}
  ; slug = {js|cacaoweb|js}
  ; description = {js|Cacaoweb développe une plateforme d'applications d'un nouveau genre. Elle fonctionne sur notre réseau pair-à-pair, qui se trouve être l'un des plus importants au monde
|js}
  ; logo = Some {js|/users/cacaoweb.png|js}
  ; url = {js|https://cacaoweb.org/|js}
  ; locations = 
 [{js|Royaume-Uni|js}; {js|Hong Kong|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Cacaoweb développe une plateforme d'applications d'un nouveau genre. Elle fonctionne sur notre réseau pair à pair, qui se trouve être l'un des plus importants au monde. Les capacités de la plateforme sont diverses et vont du streaming multimédia à la communication sociale, en passant par le stockage hors ligne ou la synchronisation des données. Nous concevons et mettons en oeuvre : des systèmes de stockage de données massivement distribuées, des langages de programmation, des systèmes d'exécution et des frameworks de calculs parallèles.
|js}
  ; body_html = {js|<p>Cacaoweb développe une plateforme d'applications d'un nouveau genre. Elle fonctionne sur notre réseau pair à pair, qui se trouve être l'un des plus importants au monde. Les capacités de la plateforme sont diverses et vont du streaming multimédia à la communication sociale, en passant par le stockage hors ligne ou la synchronisation des données. Nous concevons et mettons en oeuvre : des systèmes de stockage de données massivement distribuées, des langages de programmation, des systèmes d'exécution et des frameworks de calculs parallèles.</p>
|js}
  };
 
  { name = {js|CEA|js}
  ; slug = {js|cea|js}
  ; description = {js|CEA est une entreprise publique française, membre du Consortium OCaml
|js}
  ; logo = Some {js|/users/cea.png|js}
  ; url = {js|https://cea.fr/|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = true
  ; featured = true
  ; body_md = {js|
Le CEA est une entreprise publique française, membre du Consortium OCaml. Ils utilisent OCaml principalement pour développer une plateforme dédiée à l'analyse du code source des logiciels C, appelée [Frama-C] (https://frama-c.com).
|js}
  ; body_html = {js|<p>Le CEA est une entreprise publique française, membre du Consortium OCaml. Ils utilisent OCaml principalement pour développer une plateforme dédiée à l'analyse du code source des logiciels C, appelée [Frama-C] (https://frama-c.com).</p>
|js}
  };
 
  { name = {js|Citrix|js}
  ; slug = {js|citrix|js}
  ; description = {js|Citrix utilise OCaml dans XenServer, un système de virtualisation de serveurs de classe mondiale.
|js}
  ; logo = Some {js|/users/citrix.png|js}
  ; url = {js|https://www.citrix.com|js}
  ; locations = 
 [{js|United Kingdom|js}; {js|Royaume-Uni|js}]
  ; consortium = true
  ; featured = true
  ; body_md = {js|
Citrix utilise OCaml dans XenServer, un système de virtualisation de serveurs de classe mondiale. La plupart des composants de XenServer sont publiés en open source. Les composants open source de la boîte à outils XenServer implémentés en OCaml sont regroupés dans le dépôt [XS-opam](https://github.com/xapi-project/xs-opam) sur GitHub.
|js}
  ; body_html = {js|<p>Citrix utilise OCaml dans XenServer, un système de virtualisation de serveurs de classe mondiale. La plupart des composants de XenServer sont publiés en open source. Les composants open source de la boîte à outils XenServer implémentés en OCaml sont regroupés dans le dépôt <a href="https://github.com/xapi-project/xs-opam">XS-opam</a> sur GitHub.</p>
|js}
  };
 
  { name = {js|Coherent Graphics Ltd|js}
  ; slug = {js|coherent-graphics-ltd|js}
  ; description = {js|Coherent Graphics est un développeur d'outils de serveur et de logiciels de bureau pour le traitement des documents PDF
|js}
  ; logo = Some {js|/users/coherent.png|js}
  ; url = {js|https://www.coherentpdf.com/|js}
  ; locations = 
 [{js|Royaume-Uni|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Coherent Graphics est un développeur d'outils de serveur et de logiciels de bureau pour le traitement des documents PDF. Nous utilisons OCaml comme langage de haut niveau polyvalent, choisi pour son expressivité et sa rapidité.
|js}
  ; body_html = {js|<p>Coherent Graphics est un développeur d'outils de serveur et de logiciels de bureau pour le traitement des documents PDF. Nous utilisons OCaml comme langage de haut niveau polyvalent, choisi pour son expressivité et sa rapidité.</p>
|js}
  };
 
  { name = {js|Cryptosense|js}
  ; slug = {js|cryptosense|js}
  ; description = {js|Cryptosense crée des logiciels d'analyse de la sécurité avec un accent particulier sur les systèmes cryptographiques
|js}
  ; logo = Some {js|/users/cryptosense.png|js}
  ; url = {js|https://www.cryptosense.com/|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Basée à Paris, en France, Cryptosense crée des logiciels d'analyse de sécurité avec un accent particulier sur les systèmes cryptographiques. Venant de l'Institut de recherche en informatique (INRIA), les fondateurs de Cryptosense combinent plus de 40 ans d'expérience dans la recherche et l'industrie. Cryptosense fournit ses solutions à une clientèle internationale, notamment dans les secteurs financier, industriel et gouvernemental.
|js}
  ; body_html = {js|<p>Basée à Paris, en France, Cryptosense crée des logiciels d'analyse de sécurité avec un accent particulier sur les systèmes cryptographiques. Venant de l'Institut de recherche en informatique (INRIA), les fondateurs de Cryptosense combinent plus de 40 ans d'expérience dans la recherche et l'industrie. Cryptosense fournit ses solutions à une clientèle internationale, notamment dans les secteurs financier, industriel et gouvernemental.</p>
|js}
  };
 
  { name = {js|Dassault Systèmes|js}
  ; slug = {js|dassault-systmes|js}
  ; description = {js|Dassault Systèmes, la société 3DEXPERIENCE, fournit aux entreprises et aux particuliers des univers virtuels pour imaginer des innovations durables
|js}
  ; logo = Some {js|/users/dassault.png|js}
  ; url = {js|https://www.3ds.com/fr/|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Dassault Systèmes, la société 3DEXPERIENCE, fournit aux entreprises et aux particuliers des univers virtuels pour imaginer des innovations durables.
|js}
  ; body_html = {js|<p>Dassault Systèmes, la société 3DEXPERIENCE, fournit aux entreprises et aux particuliers des univers virtuels pour imaginer des innovations durables.</p>
|js}
  };
 
  { name = {js|Dernier Cri|js}
  ; slug = {js|dernier-cri|js}
  ; description = {js|Dernier Cri est une entreprise française basée à Lille et à Paris qui utilise la programmation fonctionnelle pour développer des applications web et mobiles
|js}
  ; logo = Some {js|/users/derniercri.png|js}
  ; url = {js|https://derniercri.io|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Dernier Cri est une entreprise française basée à Lille et à Paris qui utilise la programmation fonctionnelle pour développer des applications web et mobiles. OCaml est principalement utilisé pour développer des outils internes.
|js}
  ; body_html = {js|<p>Dernier Cri est une entreprise française basée à Lille et à Paris qui utilise la programmation fonctionnelle pour développer des applications web et mobiles. OCaml est principalement utilisé pour développer des outils internes.</p>
|js}
  };
 
  { name = {js|Digirati dba Hostnet|js}
  ; slug = {js|digirati-dba-hostnet|js}
  ; description = {js|Digirati dba Hostnet est une société d'hébergement web
|js}
  ; logo = Some {js|/users/hostnet.gif|js}
  ; url = {js|https://www.hostnet.com.br/|js}
  ; locations = 
 [{js|Brésil|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Digirati dba Hostnet est une société d'hébergement web. Nous utilisons OCaml principalement pour la programmation des systèmes internes et des services d'infrastructure. Nous avons également contribué à la communauté en publiant quelques [bibliothèques OCaml open source](https://github.com/andrenth).
|js}
  ; body_html = {js|<p>Digirati dba Hostnet est une société d'hébergement web. Nous utilisons OCaml principalement pour la programmation des systèmes internes et des services d'infrastructure. Nous avons également contribué à la communauté en publiant quelques <a href="https://github.com/andrenth">bibliothèques OCaml open source</a>.</p>
|js}
  };
 
  { name = {js|Docker, Inc.|js}
  ; slug = {js|docker-inc|js}
  ; description = {js|Docker fournit une suite technologique intégrée qui permet aux équipes de développement et d'exploitation informatique de créer, de distribuer et d'exécuter des applications distribuées partout
|js}
  ; logo = Some {js|/users/docker.png|js}
  ; url = {js|https://www.docker.com|js}
  ; locations = 
 [{js|États-Unis|js}]
  ; consortium = true
  ; featured = true
  ; body_md = {js|
Docker fournit une suite technologique intégrée qui permet aux équipes de développement et d'exploitation informatique de créer, de distribuer et d'exécuter des applications distribuées partout. Leurs [applications natives pour Mac et Windows](https://blog.docker.com/2016/03/docker-for-mac-windows-beta/) utilisent du code OCaml tiré du projet de système d'exploitation en bibliothèque [MirageOS](https://mirage.io).
|js}
  ; body_html = {js|<p>Docker fournit une suite technologique intégrée qui permet aux équipes de développement et d'exploitation informatique de créer, de distribuer et d'exécuter des applications distribuées partout. Leurs <a href="https://blog.docker.com/2016/03/docker-for-mac-windows-beta/">applications natives pour Mac et Windows</a> utilisent du code OCaml tiré du projet de système d'exploitation en bibliothèque <a href="https://mirage.io">MirageOS</a>.</p>
|js}
  };
 
  { name = {js|Esterel Technologies|js}
  ; slug = {js|esterel-technologies|js}
  ; description = {js|Esterel Technologies est un des principaux fournisseurs de systèmes critiques et de solutions de développement de logiciels pour les secteurs de l'aérospatiale, de la défense, du transport ferroviaire, du nucléaire, de l'industrie et de l'automobile
|js}
  ; logo = Some {js|/users/esterel.jpg|js}
  ; url = {js|https://www.esterel-technologies.com/|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = true
  ; featured = true
  ; body_md = {js|
Esterel Technologies est un des principaux fournisseurs de systèmes critiques et de solutions de développement de logiciels pour les secteurs de l'aérospatiale, de la défense, du transport ferroviaire, du nucléaire, de l'industrie et de l'automobile
|js}
  ; body_html = {js|<p>Esterel Technologies est un des principaux fournisseurs de systèmes critiques et de solutions de développement de logiciels pour les secteurs de l'aérospatiale, de la défense, du transport ferroviaire, du nucléaire, de l'industrie et de l'automobile</p>
|js}
  };
 
  { name = {js|Facebook|js}
  ; slug = {js|facebook|js}
  ; description = {js|Facebook a construit un certain nombre d'outils de développement importants en utilisant OCaml|js}
  ; logo = Some {js|/users/facebook.png|js}
  ; url = {js|https://www.facebook.com/|js}
  ; locations = 
 [{js|États-Unis|js}]
  ; consortium = true
  ; featured = true
  ; body_md = {js|
Facebook a construit un certain nombre d'outils de développement importants en utilisant OCaml. [Hack](https://hacklang.org) est un compilateur pour une variante de PHP qui vise à concilier le cycle de développement rapide de PHP avec la discipline fournie par le typage statique. [Flow](https://flowtype.org) est un projet similaire qui fournit une vérification statique des types pour JavaScript.  Les deux systèmes sont des programmes fonctionnant en parallèle, très réactifs, capables d'intégrer les modifications du code source en temps réel. [Pfff](https://github.com/facebook/pfff/wiki/Main) est un ensemble d'outils pour l'analyse du code, les visualisations et les transformations de sources préservant le style, écrit en OCaml, mais supportant de nombreux langages.
|js}
  ; body_html = {js|<p>Facebook a construit un certain nombre d'outils de développement importants en utilisant OCaml. <a href="https://hacklang.org">Hack</a> est un compilateur pour une variante de PHP qui vise à concilier le cycle de développement rapide de PHP avec la discipline fournie par le typage statique. <a href="https://flowtype.org">Flow</a> est un projet similaire qui fournit une vérification statique des types pour JavaScript.  Les deux systèmes sont des programmes fonctionnant en parallèle, très réactifs, capables d'intégrer les modifications du code source en temps réel. <a href="https://github.com/facebook/pfff/wiki/Main">Pfff</a> est un ensemble d'outils pour l'analyse du code, les visualisations et les transformations de sources préservant le style, écrit en OCaml, mais supportant de nombreux langages.</p>
|js}
  };
 
  { name = {js|Fasoo|js}
  ; slug = {js|fasoo|js}
  ; description = {js|Fasoo utilise OCaml pour développer un outil d'analyse statique
|js}
  ; logo = Some {js|/users/fasoo.png|js}
  ; url = {js|https://www.fasoo.com|js}
  ; locations = 
 [{js|Corée du Sud|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Fasoo utilise OCaml pour développer un outil d'analyse statique.
|js}
  ; body_html = {js|<p>Fasoo utilise OCaml pour développer un outil d'analyse statique.</p>
|js}
  };
 
  { name = {js|Flying Frog Consultancy|js}
  ; slug = {js|flying-frog-consultancy|js}
  ; description = {js|Flying Frog Consultancy Ltd. consulte et écrit des livres et des logiciels sur l'utilisation d'OCaml dans le contexte du calcul scientifique
|js}
  ; logo = Some {js|/users/flying-frog.png|js}
  ; url = {js|https://www.ffconsultancy.com|js}
  ; locations = 
 [{js|Royaume-Uni|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Flying Frog Consultancy Ltd. consulte et écrit des livres et des logiciels sur l'utilisation d'OCaml dans le contexte du calcul scientifique. OCaml excelle dans la niche des programmes intrinsèquement compliqués entre les programmes à grande échelle, basés sur des tableaux, écrits dans des langages tels que HPF et les programmes graphiques à petite échelle écrits dans des langages tels que Mathematica.
|js}
  ; body_html = {js|<p>Flying Frog Consultancy Ltd. consulte et écrit des livres et des logiciels sur l'utilisation d'OCaml dans le contexte du calcul scientifique. OCaml excelle dans la niche des programmes intrinsèquement compliqués entre les programmes à grande échelle, basés sur des tableaux, écrits dans des langages tels que HPF et les programmes graphiques à petite échelle écrits dans des langages tels que Mathematica.</p>
|js}
  };
 
  { name = {js|ForAllSecure|js}
  ; slug = {js|forallsecure|js}
  ; description = {js|La mission de ForAllSecure est de tester les logiciels du monde entier et de fournir des informations exploitables à ses clients
|js}
  ; logo = Some {js|/users/forallsecure.svg|js}
  ; url = {js|https://forallsecure.com|js}
  ; locations = 
 [{js|États-Unis|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
La mission de ForAllSecure est de tester les logiciels du monde entier et de fournir des informations exploitables à ses clients. Nous avons commencé par Linux. Notre mission avec Linux est de tester tous les programmes des distributions actuelles, tels que Debian, Ubuntu et Red Hat. Avec le temps, nous couvrirons d'autres plateformes, comme Mac, Windows et les mobiles. En attendant, nous promettons de bien faire les choses.
|js}
  ; body_html = {js|<p>La mission de ForAllSecure est de tester les logiciels du monde entier et de fournir des informations exploitables à ses clients. Nous avons commencé par Linux. Notre mission avec Linux est de tester tous les programmes des distributions actuelles, tels que Debian, Ubuntu et Red Hat. Avec le temps, nous couvrirons d'autres plateformes, comme Mac, Windows et les mobiles. En attendant, nous promettons de bien faire les choses.</p>
|js}
  };
 
  { name = {js|Functori|js}
  ; slug = {js|functori|js}
  ; description = {js|Functori est une société de R&D créée par des ingénieurs experts en langages de programmation (notamment OCaml), la vérification formelle (raisonnement automatisé, model checking, ...), et la technologie blockchain (coeur/noyau, smart contracts et développement d'applications).
|js}
  ; logo = Some {js|/users/functori.png|js}
  ; url = {js|https://www.functori.com|js}
  ; locations = 
 [{js|Paris, France|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
En plus de contribuer à des outils et des bibliothèques en OCaml et
pour la communauté OCaml, nous participons au développement de la
blockchain Tezos de diverses manières :

 - développement du coeur/noyau,
 - construction d'outils et de bibliothèques open-source pour la
communauté (comme des indexeurs/crawlers, des bibliothèques pour
interagir avec la blockchain Tezos, etc.)
 - participation au développement de projets innovants pour nos
clients,
 - audit de code pour nos clients,
 - conseil et formation.

Functori a été fondée en 2021 et est basée à Paris (France), avec des
personnes travaillant à distance dans le monde entier.
|js}
  ; body_html = {js|<p>En plus de contribuer à des outils et des bibliothèques en OCaml et
pour la communauté OCaml, nous participons au développement de la
blockchain Tezos de diverses manières :</p>
<ul>
<li>développement du coeur/noyau,
</li>
<li>construction d'outils et de bibliothèques open-source pour la
communauté (comme des indexeurs/crawlers, des bibliothèques pour
interagir avec la blockchain Tezos, etc.)
</li>
<li>participation au développement de projets innovants pour nos
clients,
</li>
<li>audit de code pour nos clients,
</li>
<li>conseil et formation.
</li>
</ul>
<p>Functori a été fondée en 2021 et est basée à Paris (France), avec des
personnes travaillant à distance dans le monde entier.</p>
|js}
  };
 
  { name = {js|Galois|js}
  ; slug = {js|galois|js}
  ; description = {js|Galois a développé un langage déclaratif dédié pour les algorithmes cryptographiques
|js}
  ; logo = Some {js|/users/galois.png|js}
  ; url = {js|https://www.galois.com|js}
  ; locations = 
 [{js|États-Unis|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Galois a développé un langage déclaratif dédié pour les algorithmes cryptographiques. L'un de nos compilateurs de recherche est écrit en OCaml et fait un usage très intensif de camlp4.
|js}
  ; body_html = {js|<p>Galois a développé un langage déclaratif dédié pour les algorithmes cryptographiques. L'un de nos compilateurs de recherche est écrit en OCaml et fait un usage très intensif de camlp4.</p>
|js}
  };
 
  { name = {js|Incubaid|js}
  ; slug = {js|incubaid|js}
  ; description = {js|Incubaid a développé Arakoon, un système de stockage distribué, fonctionnant par valeur clé, qui garantit avant tout la cohérence
|js}
  ; logo = Some {js|/users/Incubaid.png|js}
  ; url = {js|https://incubaid.com|js}
  ; locations = 
 [{js|Belgique|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Incubaid a développé <a href="https://github.com/Incubaid/arakoon">Arakoon</a>, un système de stockage distribué, fonctionnant par valeur clé, qui garantit avant tout la cohérence. Nous avons créé Arakoon en raison d'un manque de solutions existantes répondant à nos besoins, et il est disponible en tant que logiciel libre.
|js}
  ; body_html = {js|<p>Incubaid a développé <a href="https://github.com/Incubaid/arakoon">Arakoon</a>, un système de stockage distribué, fonctionnant par valeur clé, qui garantit avant tout la cohérence. Nous avons créé Arakoon en raison d'un manque de solutions existantes répondant à nos besoins, et il est disponible en tant que logiciel libre.</p>
|js}
  };
 
  { name = {js|Issuu|js}
  ; slug = {js|issuu|js}
  ; description = {js|Issuu est une plateforme d'édition numérique offrant des expériences de lecture exceptionnelles de magazines, de catalogues et de journaux
|js}
  ; logo = Some {js|/users/issuu.gif|js}
  ; url = {js|https://issuu.com|js}
  ; locations = 
 [{js|Danemark|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Issuu est une plateforme d'édition numérique offrant des expériences de lecture exceptionnelle de magazines, catalogues et journaux. Chaque mois, Issuu sert plus de 6 milliards de pages et 60 millions d'utilisateurs à travers son réseau mondial. OCaml est utilisé dans le cadre des systèmes côté serveur, des plateformes et des applications web. L'équipe backend est relativement petite et la simplicité et l'évolutivité des systèmes et des processus sont d'une importance vitale.
|js}
  ; body_html = {js|<p>Issuu est une plateforme d'édition numérique offrant des expériences de lecture exceptionnelle de magazines, catalogues et journaux. Chaque mois, Issuu sert plus de 6 milliards de pages et 60 millions d'utilisateurs à travers son réseau mondial. OCaml est utilisé dans le cadre des systèmes côté serveur, des plateformes et des applications web. L'équipe backend est relativement petite et la simplicité et l'évolutivité des systèmes et des processus sont d'une importance vitale.</p>
|js}
  };
 
  { name = {js|Jane Street|js}
  ; slug = {js|jane-street|js}
  ; description = {js|Jane Street est une société de trading quantitatif qui opère 24 heures sur 24 et dans le monde entier
|js}
  ; logo = Some {js|/users/jane-street.jpg|js}
  ; url = {js|https://janestreet.com|js}
  ; locations = 
 [{js|États-Unis|js}; {js|Royaume-Uni|js}; {js|Hong Kong|js}]
  ; consortium = true
  ; featured = true
  ; body_md = {js|
Jane Street est une société de trading quantitatif qui opère 24 heures sur 24 et dans le monde entier. Elle apporte une profonde compréhension des marchés, une approche scientifique et une technologie innovante pour résoudre le problème de la négociation rentable sur les marchés financiers mondiaux hautement compétitifs. Ils sont le plus grand utilisateur commercial d'OCaml, l'utilisant pour tout, des outils de recherche aux systèmes de négociation en passant par l'infrastructure des systèmes et les systèmes de comptabilité. Jane Street compte plus de 400 programmeurs OCaml et plus de 15 millions de lignes d'OCaml, alimentant une plateforme technologique qui négocie des milliards de dollars chaque jour. Un demi-million de lignes de leur code sont publiées [open source](https://opensource.janestreet.com), et ils ont créé des éléments clés de l'écosystème OCaml open source, comme [Dune](https://dune.build). Vous pouvez en savoir plus en consultant leur [blog technique](https://blog.janestreet.com).
|js}
  ; body_html = {js|<p>Jane Street est une société de trading quantitatif qui opère 24 heures sur 24 et dans le monde entier. Elle apporte une profonde compréhension des marchés, une approche scientifique et une technologie innovante pour résoudre le problème de la négociation rentable sur les marchés financiers mondiaux hautement compétitifs. Ils sont le plus grand utilisateur commercial d'OCaml, l'utilisant pour tout, des outils de recherche aux systèmes de négociation en passant par l'infrastructure des systèmes et les systèmes de comptabilité. Jane Street compte plus de 400 programmeurs OCaml et plus de 15 millions de lignes d'OCaml, alimentant une plateforme technologique qui négocie des milliards de dollars chaque jour. Un demi-million de lignes de leur code sont publiées <a href="https://opensource.janestreet.com">open source</a>, et ils ont créé des éléments clés de l'écosystème OCaml open source, comme <a href="https://dune.build">Dune</a>. Vous pouvez en savoir plus en consultant leur <a href="https://blog.janestreet.com">blog technique</a>.</p>
|js}
  };
 
  { name = {js|Kernelize|js}
  ; slug = {js|kernelize|js}
  ; description = {js|Kernelyze a développé une nouvelle approximation des fonctions à deux variables qui permet d'obtenir la plus petite erreur possible dans le pire des cas parmi toutes les approximations de rang n
|js}
  ; logo = Some {js|/users/kernelyze-llc-logo.png|js}
  ; url = {js|https://kernelyze.com/|js}
  ; locations = 
 [{js|États-Unis|js}]
  ; consortium = true
  ; featured = true
  ; body_md = {js|
Kernelyze a développé une nouvelle approximation des fonctions à deux variables qui permet d'obtenir la plus petite erreur possible dans le pire des cas parmi toutes les approximations de rang n.
|js}
  ; body_html = {js|<p>Kernelyze a développé une nouvelle approximation des fonctions à deux variables qui permet d'obtenir la plus petite erreur possible dans le pire des cas parmi toutes les approximations de rang n.</p>
|js}
  };
 
  { name = {js|Kong|js}
  ; slug = {js|kong|js}
  ; description = {js|Kong facilite la distribution, la monétisation, la gestion et la consommation des APIs dans le cloud
|js}
  ; logo = Some {js|/users/mashape.png|js}
  ; url = {js|https://www.konghq.com|js}
  ; locations = 
 [{js|États-Unis|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Kong facilite la distribution, la monétisation, la gestion et la consommation des API dans le cloud. Mashape construit une place de marché de classe mondiale pour les API dans le cloud, animée par une communauté passionnée de développeurs du monde entier, ainsi que des produits de gestion et d'analyse des API d'entreprise. Nous utilisons OCaml dans notre produit [APIAnalytics](https://apianalytics.com) - dans le cadre d'un proxy HTTP léger et critique.
|js}
  ; body_html = {js|<p>Kong facilite la distribution, la monétisation, la gestion et la consommation des API dans le cloud. Mashape construit une place de marché de classe mondiale pour les API dans le cloud, animée par une communauté passionnée de développeurs du monde entier, ainsi que des produits de gestion et d'analyse des API d'entreprise. Nous utilisons OCaml dans notre produit <a href="https://apianalytics.com">APIAnalytics</a> - dans le cadre d'un proxy HTTP léger et critique.</p>
|js}
  };
 
  { name = {js|LexiFi|js}
  ; slug = {js|lexifi|js}
  ; description = {js|LexiFi est un fournisseur innovant d'applications logicielles et de technologies d'infrastructure pour l'industrie des marchés financiers.
|js}
  ; logo = Some {js|/users/lexifi.png|js}
  ; url = {js|https://www.lexifi.com|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = true
  ; featured = true
  ; body_md = {js|
LexiFi est un fournisseur innovant d'applications logicielles et de technologies d'infrastructure pour l'industrie des marchés financiers. LexiFi Apropos est alimenté par un formalisme original pour décrire les contrats financiers, résultat d'un effort de recherche et de développement à long terme.
|js}
  ; body_html = {js|<p>LexiFi est un fournisseur innovant d'applications logicielles et de technologies d'infrastructure pour l'industrie des marchés financiers. LexiFi Apropos est alimenté par un formalisme original pour décrire les contrats financiers, résultat d'un effort de recherche et de développement à long terme.</p>
|js}
  };
 
  { name = {js|Matrix Lead|js}
  ; slug = {js|matrix-lead|js}
  ; description = {js|Matrix Lead fournit aux professionnels et aux entreprises des technologies des solutions de pointe pour les feuilles de calcul
|js}
  ; logo = Some {js|/users/matrixlead.png|js}
  ; url = {js|https://www.matrixlead.com|js}
  ; locations = 
 [{js|France|js}; {js|Chine|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Matrix Lead fournit aux professionnels et aux entreprises des technologies des solutions de pointe pour les feuilles de calcul. Nous créons une gamme de logiciels pour aider les utilisateurs à mieux construire, vérifier, optimiser et gérer leurs feuilles de calcul. Notre produit phare [10 Studio](https://www.10studio.tech) est un complément de Microsoft Excel qui combine plusieurs outils avancés, tels que l'éditeur de formules et le vérificateur de feuilles de calcul. Le noyau de nos outils est un analyseur qui analyse les différentes propriétés des feuilles de calcul (y compris les formules et les macros VBA), notamment par une analyse statique basée sur l'interprétation abstraite. Il a été initialement développé dans l'équipe Antiques d'INRIA et écrit en OCaml. Ensuite, nous avons enveloppé des langages web ou .NET autour de l'analyseur pour en faire des outils prêts à l'emploi.
|js}
  ; body_html = {js|<p>Matrix Lead fournit aux professionnels et aux entreprises des technologies des solutions de pointe pour les feuilles de calcul. Nous créons une gamme de logiciels pour aider les utilisateurs à mieux construire, vérifier, optimiser et gérer leurs feuilles de calcul. Notre produit phare <a href="https://www.10studio.tech">10 Studio</a> est un complément de Microsoft Excel qui combine plusieurs outils avancés, tels que l'éditeur de formules et le vérificateur de feuilles de calcul. Le noyau de nos outils est un analyseur qui analyse les différentes propriétés des feuilles de calcul (y compris les formules et les macros VBA), notamment par une analyse statique basée sur l'interprétation abstraite. Il a été initialement développé dans l'équipe Antiques d'INRIA et écrit en OCaml. Ensuite, nous avons enveloppé des langages web ou .NET autour de l'analyseur pour en faire des outils prêts à l'emploi.</p>
|js}
  };
 
  { name = {js|MEDIT|js}
  ; slug = {js|medit|js}
  ; description = {js|MEDIT développe SuMo, un système bio-informatique avancé, pour l'analyse des structures 3D des protéines et l'identification de cibles pour la conception de médicaments
|js}
  ; logo = Some {js|/users/medit.jpg|js}
  ; url = {js|https://www.medit-pharma.com/|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
MEDIT développe [SuMo, un système bio-informatique avancé]("https://mjambon.com/") pour l'analyse des structures 3D des protéines et l'identification de cibles pour la conception de médicaments. SuMo est entièrement écrit en OCaml et fournit des interfaces à plusieurs progiciels commerciaux de modélisation moléculaire.
|js}
  ; body_html = {js|<p>MEDIT développe <a href="%22https://mjambon.com/%22">SuMo, un système bio-informatique avancé</a> pour l'analyse des structures 3D des protéines et l'identification de cibles pour la conception de médicaments. SuMo est entièrement écrit en OCaml et fournit des interfaces à plusieurs progiciels commerciaux de modélisation moléculaire.</p>
|js}
  };
 
  { name = {js|Microsoft|js}
  ; slug = {js|microsoft|js}
  ; description = {js|Microsoft Corporation est une société technologique multinationale américaine qui produit des logiciels, de l'électronique grand public, des ordinateurs personnels et des services connexes.
|js}
  ; logo = Some {js|/users/microsoft.png|js}
  ; url = {js|https://www.microsoft.com|js}
  ; locations = 
 [{js|États-Unis|js}]
  ; consortium = true
  ; featured = true
  ; body_md = {js|
Microsoft Corporation est une société technologique multinationale américaine qui produit des logiciels, de l'électronique grand public, des ordinateurs personnels et des services connexes.

|js}
  ; body_html = {js|<p>Microsoft Corporation est une société technologique multinationale américaine qui produit des logiciels, de l'électronique grand public, des ordinateurs personnels et des services connexes.</p>
|js}
  };
 
  { name = {js|Mount Sinai|js}
  ; slug = {js|mount-sinai|js}
  ; description = {js|Le laboratoire Hammer de Mount Sinai développe et utilise Ketrew pour gérer des flux de travail complexes en bio-informatique
|js}
  ; logo = Some {js|/users/mount-sinai.png|js}
  ; url = {js|https://www.mountsinai.org|js}
  ; locations = 
 [{js|États-Unis|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Le [Hammer Lab]("https://www.hammerlab.org") de Mount Sinai développe et utilise [Ketrew]("https://github.com/hammerlab/ketrew") pour gérer des flux de travail complexes en bio-informatique. Ketrew comprend un langage dédié pour simplifier la spécification des flux de travail et un moteur pour l'exécution des flux de travail. Ketrew peut être exécuté comme une application en ligne de commande ou comme un service.
|js}
  ; body_html = {js|<p>Le <a href="%22https://www.hammerlab.org%22">Hammer Lab</a> de Mount Sinai développe et utilise <a href="%22https://github.com/hammerlab/ketrew%22">Ketrew</a> pour gérer des flux de travail complexes en bio-informatique. Ketrew comprend un langage dédié pour simplifier la spécification des flux de travail et un moteur pour l'exécution des flux de travail. Ketrew peut être exécuté comme une application en ligne de commande ou comme un service.</p>
|js}
  };
 
  { name = {js|Mr. Number|js}
  ; slug = {js|mr-number|js}
  ; description = {js|Mr. Number est une startup de la Silicon Valley qui a développé l'application Mr. Number pour le blocage des appels, rachetée depuis par WhitePages
|js}
  ; logo = Some {js|/users/mrnumber.jpg|js}
  ; url = {js|https://mrnumber.com/|js}
  ; locations = 
 [{js|États-Unis|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Mr. Number a démarré en tant que startup de la Silicon Valley et a développé l'application Mr. Number pour le blocage des appels, qui a ensuite été [rachetée par WhitePages](https://allthingsd.com/20130601/whitepages-scoops-up-mr-number-an-android-app-for-blocking-unwanted-calls/). OCaml est utilisé du côté serveur comme colle entre les divers composants et services tiers.
|js}
  ; body_html = {js|<p>Mr. Number a démarré en tant que startup de la Silicon Valley et a développé l'application Mr. Number pour le blocage des appels, qui a ensuite été <a href="https://allthingsd.com/20130601/whitepages-scoops-up-mr-number-an-android-app-for-blocking-unwanted-calls/">rachetée par WhitePages</a>. OCaml est utilisé du côté serveur comme colle entre les divers composants et services tiers.</p>
|js}
  };
 
  { name = {js|MyLife|js}
  ; slug = {js|mylife|js}
  ; description = {js|MyLife a développé un puissant outil de recherche de personnes qui permettra à ceux qui en ont besoin de trouver n'importe qui, quelles que soient les années passées et la vie qui s'est construite entre-temps
|js}
  ; logo = Some {js|/users/mylife.jpg|js}
  ; url = {js|https://www.mylife.com/|js}
  ; locations = 
 [{js|États-Unis|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
MyLife a développé un puissant outil de recherche de personnes qui permettra à ceux qui en ont besoin de trouver n'importe qui, quelles que soient les années passées et la vie qui s'est construite entre-temps.
|js}
  ; body_html = {js|<p>MyLife a développé un puissant outil de recherche de personnes qui permettra à ceux qui en ont besoin de trouver n'importe qui, quelles que soient les années passées et la vie qui s'est construite entre-temps.</p>
|js}
  };
 
  { name = {js|Narrow Gate Logic|js}
  ; slug = {js|narrow-gate-logic|js}
  ; description = {js|Narrow Gate Logic est une entreprise qui utilise le langage OCaml dans des applications commerciales et non commerciales
|js}
  ; logo = Some {js|/users/nglogic.png|js}
  ; url = {js|https://nglogic.com|js}
  ; locations = 
 [{js|Pologne|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Narrow Gate Logic est une entreprise qui utilise le langage OCaml dans des applications commerciales et non commerciales.
|js}
  ; body_html = {js|<p>Narrow Gate Logic est une entreprise qui utilise le langage OCaml dans des applications commerciales et non commerciales.</p>
|js}
  };
 
  { name = {js|Nomadic Labs|js}
  ; slug = {js|nomadic-labs|js}
  ; description = {js|Nomadic Labs abrite une équipe axée sur la recherche et le développement. Nos compétences fondamentales sont dans la théorie et la pratique des langages de programmation, les systèmes distribués, et la vérification formelle
|js}
  ; logo = Some {js|/users/nomadic-labs.png|js}
  ; url = {js|https://www.nomadic-labs.com|js}
  ; locations = 
 [{js|Paris, France|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Nomadic Labs abrite une équipe axée sur la recherche et le développement. Nos
compétences fondamentales sont dans la théorie et la pratique des langages de programmation,
les systèmes distribués, et la vérification formelle. Nomadic Labs se concentre sur
la contribution au développement du logiciel de base de Tezos, notamment
le langage de contrat intelligent, Michelson.

L'infrastructure de Tezos est entièrement implémentée en OCaml. Elle s'appuie fortement
sur l'efficacité et l'expressivité d'OCaml. Par exemple, les contrats intelligents Michelson
sont représentés à l'aide de GADTs OCaml afin d'éviter de nombreuses erreurs d'exécution.
La sécurité et la correction sont essentielles pour une blockchain et nous sommes heureux
que le système de types OCaml permette une forme de méthode formelle légère qui peut être
utilisée quotidiennement.
|js}
  ; body_html = {js|<p>Nomadic Labs abrite une équipe axée sur la recherche et le développement. Nos
compétences fondamentales sont dans la théorie et la pratique des langages de programmation,
les systèmes distribués, et la vérification formelle. Nomadic Labs se concentre sur
la contribution au développement du logiciel de base de Tezos, notamment
le langage de contrat intelligent, Michelson.</p>
<p>L'infrastructure de Tezos est entièrement implémentée en OCaml. Elle s'appuie fortement
sur l'efficacité et l'expressivité d'OCaml. Par exemple, les contrats intelligents Michelson
sont représentés à l'aide de GADTs OCaml afin d'éviter de nombreuses erreurs d'exécution.
La sécurité et la correction sont essentielles pour une blockchain et nous sommes heureux
que le système de types OCaml permette une forme de méthode formelle légère qui peut être
utilisée quotidiennement.</p>
|js}
  };
 
  { name = {js|OCamlPro|js}
  ; slug = {js|ocamlpro|js}
  ; description = {js|OCamlPro développe et maintient un environnement de développement pour le langage OCaml
|js}
  ; logo = Some {js|/users/ocamlpro.png|js}
  ; url = {js|https://www.ocamlpro.com|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = true
  ; featured = true
  ; body_md = {js|
OCamlPro développe et maintient un environnement de développement pour le langage OCaml. Ils fournissent des services aux entreprises qui décident d'utiliser OCaml. Parmi ces services : des formations, l'expertise nécessaire, des outils et des bibliothèques, un support à long terme, et des développements spécifiques à leurs domaines d'application.
|js}
  ; body_html = {js|<p>OCamlPro développe et maintient un environnement de développement pour le langage OCaml. Ils fournissent des services aux entreprises qui décident d'utiliser OCaml. Parmi ces services : des formations, l'expertise nécessaire, des outils et des bibliothèques, un support à long terme, et des développements spécifiques à leurs domaines d'application.</p>
|js}
  };
 
  { name = {js|PRUDENT Technologies and Consulting, Inc.|js}
  ; slug = {js|prudent-technologies-and-consulting-inc|js}
  ; description = {js|Prudent Consulting propose des solutions informatiques aux grandes et moyennes entreprises en combinant l'expérience du secteur et l'expertise technologique pour aider nos clients à atteindre leurs objectifs commerciaux avec rapidité, agilité et grand impact.
|js}
  ; logo = Some {js|/users/prudent.jpg|js}
  ; url = {js|https://www.prudentconsulting.com|js}
  ; locations = 
 [{js|États-Unis|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Prudent Consulting propose des solutions informatiques aux grandes et moyennes entreprises en combinant l'expérience du secteur et l'expertise technologique pour aider nos clients à atteindre leurs objectifs commerciaux avec rapidité, agilité et grand impact.
|js}
  ; body_html = {js|<p>Prudent Consulting propose des solutions informatiques aux grandes et moyennes entreprises en combinant l'expérience du secteur et l'expertise technologique pour aider nos clients à atteindre leurs objectifs commerciaux avec rapidité, agilité et grand impact.</p>
|js}
  };
 
  { name = {js|Psellos|js}
  ; slug = {js|psellos|js}
  ; description = {js|Psellos est un petit groupe d'informaticiens qui ont été intrigués par l'idée de coder des applications iOS en OCaml
|js}
  ; logo = Some {js|/users/psellos.png|js}
  ; url = {js|https://www.psellos.com|js}
  ; locations = 
 [{js|États-Unis|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Psellos est un petit groupe d'informaticiens qui ont été intrigués par l'idée de coder des applications iOS en OCaml. Cela a fonctionné mieux que prévu (vous pouvez acheter nos applications dans l'App Store d'iTunes), et au moins une autre société vend des applications construites avec nos outils. Notre compilateur croisé iOS le plus récent est dérivé d'OCaml 4.00.0.
|js}
  ; body_html = {js|<p>Psellos est un petit groupe d'informaticiens qui ont été intrigués par l'idée de coder des applications iOS en OCaml. Cela a fonctionné mieux que prévu (vous pouvez acheter nos applications dans l'App Store d'iTunes), et au moins une autre société vend des applications construites avec nos outils. Notre compilateur croisé iOS le plus récent est dérivé d'OCaml 4.00.0.</p>
|js}
  };
 
  { name = {js|r2c|js}
  ; slug = {js|r2c|js}
  ; description = {js|r2c est une société de sécurité financée par capital-risque, dont le siège est à San Francisco et qui est répartie dans le monde entier
|js}
  ; logo = Some {js|/users/r2c.png|js}
  ; url = {js|https://r2c.dev|js}
  ; locations = 
 [{js|Californie, États-Unis|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
r2c est une société de sécurité financée par VC dont le siège est à San Francisco et qui est répartie dans le monde entier. Son principal produit est [Semgrep](https://semgrep.dev/), un grep open source, sensible à la syntaxe, qui supporte de nombreux langages. OCaml est largement utilisé pour l'analyse syntaxique et l'analyse du code source.

Semgrep était à l'origine un produit open source de chez Facebook et ses racines se trouvent dans l'outil de refactoring de Linux, [Coccinelle](https://coccinelle.gitlabpages.inria.fr/website/). r2c poursuit le développement de Semgrep et [recrute des ingénieurs logiciels](https://jobs.lever.co/returntocorp) spécialisé dans l'analyse de programmes.
|js}
  ; body_html = {js|<p>r2c est une société de sécurité financée par VC dont le siège est à San Francisco et qui est répartie dans le monde entier. Son principal produit est <a href="https://semgrep.dev/">Semgrep</a>, un grep open source, sensible à la syntaxe, qui supporte de nombreux langages. OCaml est largement utilisé pour l'analyse syntaxique et l'analyse du code source.</p>
<p>Semgrep était à l'origine un produit open source de chez Facebook et ses racines se trouvent dans l'outil de refactoring de Linux, <a href="https://coccinelle.gitlabpages.inria.fr/website/">Coccinelle</a>. r2c poursuit le développement de Semgrep et <a href="https://jobs.lever.co/returntocorp">recrute des ingénieurs logiciels</a> spécialisé dans l'analyse de programmes.</p>
|js}
  };
 
  { name = {js|Sakhalin|js}
  ; slug = {js|sakhalin|js}
  ; description = {js|Sakhalin développe des applications de cartographie marine pour les iPads et iPhones d'Apple
|js}
  ; logo = Some {js|/users/seaiq.png|js}
  ; url = {js|https://www.seaiq.com|js}
  ; locations = 
 [{js|United States|js}; {js|États-Unis|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Sakhalin développe des applications de cartographie marine pour les iPads et iPhones d'Apple. Ces applications affichent des cartes marines, des données GPS et des capteurs embarqués, le système d'identification automatique, des données météorologiques, la surveillance des ancres, etc. Ces applications sont destinées à un large éventail d'utilisateurs, du plaisancier occasionnel au pilote professionnel de rivière ou de port qui monte à bord de gros cargos. Elles sont gratuites à télécharger et à essayer (avec une mise à niveau payante pour activer toutes les fonctionnalités). Elles sont écrites presque entièrement en Ocaml, avec une petite quantité de colle pour l'interface avec les API d'IOS. Ocaml a été choisi parce qu'il

 1. permet le développement rapide de logiciels extrêmement fiables et performants,
 2. est une plateforme stable et mature
 3. dispose d'un large éventail de bibliothèques. 

Cela a été rendu possible grâce à l'excellent travail effectué par Psellos pour porter OCaml sur la plateforme iOS d'Apple. N'hésitez pas à contacter Sakhalin si vous avez des questions sur l'utilisation d'OCaml sur iOS.
|js}
  ; body_html = {js|<p>Sakhalin développe des applications de cartographie marine pour les iPads et iPhones d'Apple. Ces applications affichent des cartes marines, des données GPS et des capteurs embarqués, le système d'identification automatique, des données météorologiques, la surveillance des ancres, etc. Ces applications sont destinées à un large éventail d'utilisateurs, du plaisancier occasionnel au pilote professionnel de rivière ou de port qui monte à bord de gros cargos. Elles sont gratuites à télécharger et à essayer (avec une mise à niveau payante pour activer toutes les fonctionnalités). Elles sont écrites presque entièrement en Ocaml, avec une petite quantité de colle pour l'interface avec les API d'IOS. Ocaml a été choisi parce qu'il</p>
<ol>
<li>permet le développement rapide de logiciels extrêmement fiables et performants,
</li>
<li>est une plateforme stable et mature
</li>
<li>dispose d'un large éventail de bibliothèques.
</li>
</ol>
<p>Cela a été rendu possible grâce à l'excellent travail effectué par Psellos pour porter OCaml sur la plateforme iOS d'Apple. N'hésitez pas à contacter Sakhalin si vous avez des questions sur l'utilisation d'OCaml sur iOS.</p>
|js}
  };
 
  { name = {js|Shiro Games|js}
  ; slug = {js|shiro-games|js}
  ; description = {js|Shiro Games développe des jeux en utilisant Haxe, un langage construit avec un compilateur écrit en OCaml
|js}
  ; logo = Some {js|/users/shirogames.png|js}
  ; url = {js|https://www.shirogames.com|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Shiro Games développe des jeux en utilisant [Haxe](https://haxe.org/), un langage construit avec un compilateur écrit en OCaml.
 
|js}
  ; body_html = {js|<p>Shiro Games développe des jeux en utilisant <a href="https://haxe.org/">Haxe</a>, un langage construit avec un compilateur écrit en OCaml.</p>
|js}
  };
 
  { name = {js|SimCorp|js}
  ; slug = {js|simcorp|js}
  ; description = {js|Plateforme multiactifs pour soutenir la prise de décision et l'innovation en matière d'investissement
|js}
  ; logo = Some {js|/users/simcorp.png|js}
  ; url = {js|https://www.simcorp.com/|js}
  ; locations = 
 [{js|États-Unis|js}]
  ; consortium = true
  ; featured = true
  ; body_md = {js|
Plateforme multiactifs pour soutenir la prise de décision et l'innovation en matière d'investissement.

|js}
  ; body_html = {js|<p>Plateforme multiactifs pour soutenir la prise de décision et l'innovation en matière d'investissement.</p>
|js}
  };
 
  { name = {js|Sleekersoft|js}
  ; slug = {js|sleekersoft|js}
  ; description = {js|Spécialisé dans le développement de logiciels de programmation fonctionnelle, la consultation et la formation
|js}
  ; logo = Some {js|/users/sleekersoft.png|js}
  ; url = {js|https://www.sleekersoft.com|js}
  ; locations = 
 [{js|Australie|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Spécialisé dans le développement de logiciels de programmation fonctionnelle, la consultation et la formation
|js}
  ; body_html = {js|<p>Spécialisé dans le développement de logiciels de programmation fonctionnelle, la consultation et la formation</p>
|js}
  };
 
  { name = {js|Solvuu|js}
  ; slug = {js|solvuu|js}
  ; description = {js|Le logiciel de Solvuu permet aux utilisateurs de stocker des ensembles de données, grands et petits, de partager les données avec des collaborateurs, d'exécuter des algorithmes et des flux de travail à forte intensité de calcul et de visualiser les résultats.
|js}
  ; logo = Some {js|/users/solvuu.jpg|js}
  ; url = {js|https://www.solvuu.com|js}
  ; locations = 
 [{js|États-Unis|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Le logiciel de Solvuu permet aux utilisateurs de stocker des ensembles de données, grands et petits, de partager les données avec des collaborateurs, d'exécuter des algorithmes et des flux de travail à forte intensité de calcul et de visualiser les résultats. L'entreprise se concentre initialement sur les données génomiques, qui ont des implications importantes pour les soins de santé, l'agriculture et la recherche fondamentale. La quasi-totalité de la pile logicielle de Solvuu est implémentée en OCaml.
|js}
  ; body_html = {js|<p>Le logiciel de Solvuu permet aux utilisateurs de stocker des ensembles de données, grands et petits, de partager les données avec des collaborateurs, d'exécuter des algorithmes et des flux de travail à forte intensité de calcul et de visualiser les résultats. L'entreprise se concentre initialement sur les données génomiques, qui ont des implications importantes pour les soins de santé, l'agriculture et la recherche fondamentale. La quasi-totalité de la pile logicielle de Solvuu est implémentée en OCaml.</p>
|js}
  };
 
  { name = {js|Studio Associato 4Sigma|js}
  ; slug = {js|studio-associato-4sigma|js}
  ; description = {js|4Sigma est une petite entreprise qui réalise des sites web et quelques applications web intéressantes
|js}
  ; logo = Some {js|/users/4sigma.png|js}
  ; url = {js|https://www.4sigma.it|js}
  ; locations = 
 [{js|Italie|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
4Sigma est une petite entreprise qui réalise des sites web et quelques applications web intéressantes. OCaml n'est pas le principal langage utilisé, mais il est utilisé ici et là, notamment dans un petit serveur qui est un élément clé d'un service que nous offrons à nos clients.
|js}
  ; body_html = {js|<p>4Sigma est une petite entreprise qui réalise des sites web et quelques applications web intéressantes. OCaml n'est pas le principal langage utilisé, mais il est utilisé ici et là, notamment dans un petit serveur qui est un élément clé d'un service que nous offrons à nos clients.</p>
|js}
  };
 
  { name = {js|Tarides|js}
  ; slug = {js|tarides|js}
  ; description = {js|Tarides construit et maintient des outils d'infrastructure open source en OCaml comme MirageOS, Irmin et des outils de développement d'OCaml
|js}
  ; logo = Some {js|/users/tarides.png|js}
  ; url = {js|https://www.tarides.com|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Nous construisons et maintenons des outils d'infrastructure open source en OCaml :

 - [MirageOS](https://mirage.io), le projet unikernel le plus avancé, dans lequel nous construisons des sandboxes, des implémentations de protocoles de réseau et de stockage sous forme de bibliothèques, afin de pouvoir les lier à nos applications pour les exécuter sans avoir besoin d'un système d'exploitation sous-jacent.
 - [Irmin]("https://irmin.org"), une base de données de type Git, qui nous permet de créer des systèmes distribués entièrement contrôlables, pouvant fonctionner hors ligne et être synchronisés si nécessaire.
 - Des outils de développement d'OCaml (système de construction, linters de code, générateurs de documentation, etc.), pour nous rendre plus efficaces.

Tarides a été fondée début 2018 et est principalement basée à Paris, France (le travail à distance est possible).
|js}
  ; body_html = {js|<p>Nous construisons et maintenons des outils d'infrastructure open source en OCaml :</p>
<ul>
<li><a href="https://mirage.io">MirageOS</a>, le projet unikernel le plus avancé, dans lequel nous construisons des sandboxes, des implémentations de protocoles de réseau et de stockage sous forme de bibliothèques, afin de pouvoir les lier à nos applications pour les exécuter sans avoir besoin d'un système d'exploitation sous-jacent.
</li>
<li><a href="%22https://irmin.org%22">Irmin</a>, une base de données de type Git, qui nous permet de créer des systèmes distribués entièrement contrôlables, pouvant fonctionner hors ligne et être synchronisés si nécessaire.
</li>
<li>Des outils de développement d'OCaml (système de construction, linters de code, générateurs de documentation, etc.), pour nous rendre plus efficaces.
</li>
</ul>
<p>Tarides a été fondée début 2018 et est principalement basée à Paris, France (le travail à distance est possible).</p>
|js}
  };
 
  { name = {js|TrustInSoft|js}
  ; slug = {js|trustinsoft|js}
  ; description = {js|TrustInSoft est une entreprise qui change les règles de la cybersécurité. TrustInSoft est l'éditeur du logiciel d'analyse de la plateforme Frama-C
|js}
  ; logo = Some {js|/users/trustinsoft.png|js}
  ; url = {js|https://trust-in-soft.com|js}
  ; locations = 
 [{js|France|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
TrustInSoft est une entreprise qui change les règles de la cybersécurité. TrustInSoft est l'éditeur de la plateforme d'analyse logicielle [Frama-C](https://frama-c.com). Notre devise est simple : rendre les méthodes formelles accessibles à la majorité des développeurs de logiciels.
|js}
  ; body_html = {js|<p>TrustInSoft est une entreprise qui change les règles de la cybersécurité. TrustInSoft est l'éditeur de la plateforme d'analyse logicielle <a href="https://frama-c.com">Frama-C</a>. Notre devise est simple : rendre les méthodes formelles accessibles à la majorité des développeurs de logiciels.</p>
|js}
  };
 
  { name = {js|Wolfram MathCore|js}
  ; slug = {js|wolfram-mathcore|js}
  ; description = {js|Wolfram MathCore utilise OCaml pour implémenter son noyau SystemModeler
|js}
  ; logo = Some {js|/users/wolfram-mathcore.gif|js}
  ; url = {js|https://www.wolframmathcore.com|js}
  ; locations = 
 [{js|Suède|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Wolfram MathCore utilise OCaml pour implémenter son noyau SystemModeler. La fonction principale du noyau est de traduire les modèles définis dans le langage Modelica en code de simulation exécutable. Cela implique l'analyse et la transformation du code Modelica, le traitement mathématique des équations, la génération du code de simulation C/C++ et les calculs numériques d'exécution.
|js}
  ; body_html = {js|<p>Wolfram MathCore utilise OCaml pour implémenter son noyau SystemModeler. La fonction principale du noyau est de traduire les modèles définis dans le langage Modelica en code de simulation exécutable. Cela implique l'analyse et la transformation du code Modelica, le traitement mathématique des équations, la génération du code de simulation C/C++ et les calculs numériques d'exécution.</p>
|js}
  };
 
  { name = {js|Zeo Agency|js}
  ; slug = {js|zeo-agency|js}
  ; description = {js|Zeo est une société de marketing numérique dont l'objectif est d'aider les entreprises à faire mieux en matière de référencement
|js}
  ; logo = None
  ; url = {js|https://www.zeo.org|js}
  ; locations = 
 [{js|Londres, Royaume-Uni|js}]
  ; consortium = false
  ; featured = true
  ; body_md = {js|
Zeo est une société de marketing numérique dont l'objectif est d'aider les entreprises à faire mieux en matière de référencement. En raison de la nature de notre activité, nous gérons des milliards de lignes dans notre base de données et créons des informations en utilisant ces données. Pour répondre efficacement à nos besoins, nous utilisons OCaml dans notre partie exploration et traitement des données.
|js}
  ; body_html = {js|<p>Zeo est une société de marketing numérique dont l'objectif est d'aider les entreprises à faire mieux en matière de référencement. En raison de la nature de notre activité, nous gérons des milliards de lignes dans notre base de données et créons des informations en utilisant ces données. Pour répondre efficacement à nos besoins, nous utilisons OCaml dans notre partie exploration et traitement des données.</p>
|js}
  }]

