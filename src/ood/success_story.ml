
type t =
  { title : string
  ; slug : string
  ; image : string option
  ; url : string option
  ; body_md : string
  ; body_html : string
  }
  
let all_en = 
[
  { title = {js|The ASTRÉE Static Analyzer|js}
  ; slug = {js|the-astre-static-analyzer|js}
  ; image = Some {js|/success-stories/astree-thumb.gif|js}
  ; url = Some {js|https://www.astree.ens.fr/|js}
  ; body_md = {js|
*[David Monniaux](https://www-verimag.imag.fr/~monniaux/) (CNRS), member
of the ASTRÉE project, says:* “[ASTRÉE](https://www.astree.ens.fr/) is a
*static analyzer* based on *[abstract
interpretation](https://www.di.ens.fr/%7Ecousot/aiintro.shtml)* that aims
at proving the absence of runtime errors in safety-critical software
written in a subset of the C programming language.”

“Automatically analyzing programs for exactly checking properties such
as the absence of runtime errors is impossible in general, for
mathematical reasons. Static analysis by abstract interpretation works
around this impossibility and proves program properties by
over-approximating the possible behaviors of the program: it is possible
to design pessimistic approximations that, in practice, allow proving
the desired property on a wide range of software.”

“So far, ASTRÉE has proved the absence of runtime errors in the primary
control software of the [Airbus A340
family](https://www.airbus.com/aircraft/previous-generation-aircraft/a340-family.html). This
would be impossible by *software testing*, for testing only considers a
limited *subset* of the test cases, while abstract interpretation
considers a *superset* of all possible outcomes of the system.”

“[ASTRÉE](https://www.astree.ens.fr/) is written in OCaml and is about
44000 lines long (plus external libraries). We needed a language with
good performance (speed and memory usage) on reasonable equipment, easy
support for advanced data structures, and type and memory safety. OCaml
also allows for modular, clear and compact source code and makes it easy
to work with recursive structures such as syntax trees.”
|js}
  ; body_html = {js|<p><em><a href="https://www-verimag.imag.fr/~monniaux/">David Monniaux</a> (CNRS), member
of the ASTRÉE project, says:</em> “<a href="https://www.astree.ens.fr/">ASTRÉE</a> is a
<em>static analyzer</em> based on <em><a href="https://www.di.ens.fr/%7Ecousot/aiintro.shtml">abstract
interpretation</a></em> that aims
at proving the absence of runtime errors in safety-critical software
written in a subset of the C programming language.”</p>
<p>“Automatically analyzing programs for exactly checking properties such
as the absence of runtime errors is impossible in general, for
mathematical reasons. Static analysis by abstract interpretation works
around this impossibility and proves program properties by
over-approximating the possible behaviors of the program: it is possible
to design pessimistic approximations that, in practice, allow proving
the desired property on a wide range of software.”</p>
<p>“So far, ASTRÉE has proved the absence of runtime errors in the primary
control software of the <a href="https://www.airbus.com/aircraft/previous-generation-aircraft/a340-family.html">Airbus A340
family</a>. This
would be impossible by <em>software testing</em>, for testing only considers a
limited <em>subset</em> of the test cases, while abstract interpretation
considers a <em>superset</em> of all possible outcomes of the system.”</p>
<p>“<a href="https://www.astree.ens.fr/">ASTRÉE</a> is written in OCaml and is about
44000 lines long (plus external libraries). We needed a language with
good performance (speed and memory usage) on reasonable equipment, easy
support for advanced data structures, and type and memory safety. OCaml
also allows for modular, clear and compact source code and makes it easy
to work with recursive structures such as syntax trees.”</p>
|js}
  };
 
  { title = {js|Coq|js}
  ; slug = {js|coq|js}
  ; image = Some {js|/success-stories/coq-thumb.jpg|js}
  ; url = Some {js|https://coq.inria.fr/|js}
  ; body_md = {js|
*[Jean-Christophe Filliâtre](https://www.lri.fr/~filliatr/) (CNRS), a
Coq developer, says:* “The [Coq](https://coq.inria.fr/) tool is a system
for manipulating formal mathematical proofs; a proof carried out in Coq
is mechanically verified by the machine. In addition to its applications
in mathematics, Coq also allows certifying the correctness of computer
programs.”

“From the Coq standpoint, OCaml is attractive on multiple grounds.
First, the OCaml language is perfectly suited for symbolic
manipulations, which are of paramount importance in a proof assistant.
Furthermore, OCaml's type system, and particularly its notion of
abstract type, allow securely encapsulating Coq's critical code base,
which guarantees the logical consistency of the whole system. Last,
OCaml's strong type system *de facto* grants Coq's code a high level of
quality: errors such as “segmentation faults” cannot occur during
execution, which is indispensable for a tool whose primary goal is
precisely rigor.”
|js}
  ; body_html = {js|<p><em><a href="https://www.lri.fr/~filliatr/">Jean-Christophe Filliâtre</a> (CNRS), a
Coq developer, says:</em> “The <a href="https://coq.inria.fr/">Coq</a> tool is a system
for manipulating formal mathematical proofs; a proof carried out in Coq
is mechanically verified by the machine. In addition to its applications
in mathematics, Coq also allows certifying the correctness of computer
programs.”</p>
<p>“From the Coq standpoint, OCaml is attractive on multiple grounds.
First, the OCaml language is perfectly suited for symbolic
manipulations, which are of paramount importance in a proof assistant.
Furthermore, OCaml's type system, and particularly its notion of
abstract type, allow securely encapsulating Coq's critical code base,
which guarantees the logical consistency of the whole system. Last,
OCaml's strong type system <em>de facto</em> grants Coq's code a high level of
quality: errors such as “segmentation faults” cannot occur during
execution, which is indispensable for a tool whose primary goal is
precisely rigor.”</p>
|js}
  };
 
  { title = {js|FFTW|js}
  ; slug = {js|fftw|js}
  ; image = Some {js|/success-stories/fftw-thumb.png|js}
  ; url = Some {js|https://www.fftw.org/|js}
  ; body_md = {js|
[FFTW](https://www.fftw.org/) is a [very fast](https://www.fftw.org/benchfft/) C
library for computing Discrete Fourier Transforms (DFT). It uses a powerful
symbolic optimizer written in OCaml which, given an integer N, generates highly
optimized C code to compute DFTs of size N. FFTW was awarded the 1999
[Wilkinson prize](https://en.wikipedia.org/wiki/J._H._Wilkinson_Prize_for_Numerical_Software)
for numerical software.

Benchmarks, performed on a variety of platforms, show that FFTW's
performance is typically superior to that of other publicly available
DFT software, and is even competitive with vendor-tuned codes. In
contrast to vendor-tuned codes, however, FFTW's performance is portable:
the same program will perform well on most architectures without
modification. Hence the name, “FFTW,” which stands for the somewhat
whimsical title of “Fastest Fourier Transform in the West.”
|js}
  ; body_html = {js|<p><a href="https://www.fftw.org/">FFTW</a> is a <a href="https://www.fftw.org/benchfft/">very fast</a> C
library for computing Discrete Fourier Transforms (DFT). It uses a powerful
symbolic optimizer written in OCaml which, given an integer N, generates highly
optimized C code to compute DFTs of size N. FFTW was awarded the 1999
<a href="https://en.wikipedia.org/wiki/J._H._Wilkinson_Prize_for_Numerical_Software">Wilkinson prize</a>
for numerical software.</p>
<p>Benchmarks, performed on a variety of platforms, show that FFTW's
performance is typically superior to that of other publicly available
DFT software, and is even competitive with vendor-tuned codes. In
contrast to vendor-tuned codes, however, FFTW's performance is portable:
the same program will perform well on most architectures without
modification. Hence the name, “FFTW,” which stands for the somewhat
whimsical title of “Fastest Fourier Transform in the West.”</p>
|js}
  };
 
  { title = {js|Haxe|js}
  ; slug = {js|haxe|js}
  ; image = None
  ; url = Some {js|https://haxe.org/|js}
  ; body_md = {js|
[Haxe](https://haxe.org/) is an open source toolkit based on a modern,
high level, strictly typed programming language, a cross-compiler,
a complete cross-platform standard library and ways to access each
platform's native capabilities. The Haxe compiler was entirely written in OCaml.
|js}
  ; body_html = {js|<p><a href="https://haxe.org/">Haxe</a> is an open source toolkit based on a modern,
high level, strictly typed programming language, a cross-compiler,
a complete cross-platform standard library and ways to access each
platform's native capabilities. The Haxe compiler was entirely written in OCaml.</p>
|js}
  };
 
  { title = {js|Jane Street|js}
  ; slug = {js|jane-street|js}
  ; image = Some {js|/success-stories/jane-street-thumb.jpg|js}
  ; url = Some {js|https://janestreet.com/technology/|js}
  ; body_md = {js|
Jane Street is a proprietary trading firm that uses OCaml as its primary
development platform.  Our operation runs at a large scale,
generating billions of dollars of transactions every day from our offices
in Hong Kong, London and New York, with strategies that span many asset classes,
time-zones and regulatory regimes.

Almost all of our software is written in OCaml, from statistical
research code to systems-administration tools to our real-time trading
infrastructure.  OCaml’s type system acts as a rich and
well-integrated set of static analysis tools that help improve the
quality of our code, catching bugs at the earliest possible stage.
Billions of dollars of transactions flow through our systems every day,
so getting it right matters.  At the same time, OCaml is highly productive,
helping us quickly adapt to changing market conditions.

Jane Street has been contributing open-source libraries back to the wider
community for many years, including Core, our alternative standard
library, Async, a cooperative concurrency library,
and several syntax extensions like binprot and sexplib.  All of these can
be found at [https://janestreet.github.io](https://janestreet.github.io).  All in, we've open-sourced
more than 200k lines of code.
|js}
  ; body_html = {js|<p>Jane Street is a proprietary trading firm that uses OCaml as its primary
development platform.  Our operation runs at a large scale,
generating billions of dollars of transactions every day from our offices
in Hong Kong, London and New York, with strategies that span many asset classes,
time-zones and regulatory regimes.</p>
<p>Almost all of our software is written in OCaml, from statistical
research code to systems-administration tools to our real-time trading
infrastructure.  OCaml’s type system acts as a rich and
well-integrated set of static analysis tools that help improve the
quality of our code, catching bugs at the earliest possible stage.
Billions of dollars of transactions flow through our systems every day,
so getting it right matters.  At the same time, OCaml is highly productive,
helping us quickly adapt to changing market conditions.</p>
<p>Jane Street has been contributing open-source libraries back to the wider
community for many years, including Core, our alternative standard
library, Async, a cooperative concurrency library,
and several syntax extensions like binprot and sexplib.  All of these can
be found at <a href="https://janestreet.github.io">https://janestreet.github.io</a>.  All in, we've open-sourced
more than 200k lines of code.</p>
|js}
  };
 
  { title = {js|LexiFi's Modeling Language for Finance|js}
  ; slug = {js|lexifis-modeling-language-for-finance|js}
  ; image = Some {js|/success-stories/lexifi-thumb.jpg|js}
  ; url = Some {js|https://www.lexifi.com/|js}
  ; body_md = {js|
Developed by the company [LexiFi](https://www.lexifi.com/), the Modeling
Language for Finance (MLFi) is the first formal language that accurately
describes the most sophisticated capital market, credit, and investment
products. MLFi is implemented as an extension of OCaml.

MLFi users derive two important benefits from a functional programming
approach. First, the declarative formalism of functional programming
languages is well suited for *specifying* complex data structures and
algorithms. Second, functional programming languages have strong *list
processing* capabilities. Lists play a central role in finance where
they are used extensively to define contract event and payment
schedules.

In addition, MLFi provides crucial business integration capabilities
inherited from OCaml and related tools and libraries. This enables
users, for example, to interoperate with C and Java programs, manipulate
XML schemas and documents, and interface with SQL databases.

Data models and object models aiming to encapsulate the definitions and
behavior of financial instruments were developed by the banking industry
over the past two decades, but face inherent limitations that OCaml
helped overcome.

LexiFi's approach to modeling complex financial contracts received an
academic award in 2000, and the MLFi implementation was elected
“Software Product of the Year 2001” by the magazine *Risk*, the leading
financial trading and risk management publication. MLFi-based solutions
are gaining growing acceptance throughout Europe and are contributing to
spread the use of OCaml in the financial services industry.
|js}
  ; body_html = {js|<p>Developed by the company <a href="https://www.lexifi.com/">LexiFi</a>, the Modeling
Language for Finance (MLFi) is the first formal language that accurately
describes the most sophisticated capital market, credit, and investment
products. MLFi is implemented as an extension of OCaml.</p>
<p>MLFi users derive two important benefits from a functional programming
approach. First, the declarative formalism of functional programming
languages is well suited for <em>specifying</em> complex data structures and
algorithms. Second, functional programming languages have strong <em>list
processing</em> capabilities. Lists play a central role in finance where
they are used extensively to define contract event and payment
schedules.</p>
<p>In addition, MLFi provides crucial business integration capabilities
inherited from OCaml and related tools and libraries. This enables
users, for example, to interoperate with C and Java programs, manipulate
XML schemas and documents, and interface with SQL databases.</p>
<p>Data models and object models aiming to encapsulate the definitions and
behavior of financial instruments were developed by the banking industry
over the past two decades, but face inherent limitations that OCaml
helped overcome.</p>
<p>LexiFi's approach to modeling complex financial contracts received an
academic award in 2000, and the MLFi implementation was elected
“Software Product of the Year 2001” by the magazine <em>Risk</em>, the leading
financial trading and risk management publication. MLFi-based solutions
are gaining growing acceptance throughout Europe and are contributing to
spread the use of OCaml in the financial services industry.</p>
|js}
  };
 
  { title = {js|Liquidsoap|js}
  ; slug = {js|liquidsoap|js}
  ; image = None
  ; url = None
  ; body_md = {js|
[Liquidsoap](https://www.liquidsoap.info/) is clearly well established in the
(internet) radio industry. Liquidsoap is well known as a tool with
unique abilities, and has lots of users including big commercial ones.
It is not developed as a business, but companies develop services or
software on top of it. For example, Sourcefabric develops and sells
Airtime on top of Liquidsoap.
|js}
  ; body_html = {js|<p><a href="https://www.liquidsoap.info/">Liquidsoap</a> is clearly well established in the
(internet) radio industry. Liquidsoap is well known as a tool with
unique abilities, and has lots of users including big commercial ones.
It is not developed as a business, but companies develop services or
software on top of it. For example, Sourcefabric develops and sells
Airtime on top of Liquidsoap.</p>
|js}
  };
 
  { title = {js|The MLdonkey peer-to-peer client|js}
  ; slug = {js|the-mldonkey-peer-to-peer-client|js}
  ; image = Some {js|/success-stories/mldonkey-thumb.jpg|js}
  ; url = Some {js|https://mldonkey.sourceforge.net/Main_Page|js}
  ; body_md = {js|
[MLdonkey](https://mldonkey.sourceforge.net/Main_Page) is a
multi-platform multi-networks peer-to-peer client. It was the first
open-source client to access the eDonkey network. Today, MLdonkey
supports several other large networks, among which Overnet, Bittorrent,
Gnutella, Gnutella2, Fasttrack, Soulseek, Direct-Connect, and Opennap.
Searches can be conducted over several networks concurrently; files are
downloaded from and uploaded to multiple peers concurrently.

*An MLdonkey developer says:* “Early in 2002, we decided to use OCaml to
program a network application in the emerging world of peer-to-peer
systems. The result of our work, MLdonkey, has surpassed our hopes:
MLdonkey is currently the most popular peer-to-peer file-sharing client
according to [free(code)](https://freecode.com/) (formerly “freshmeat.net”),
with about 10,000
daily users. Moreover, MLdonkey is the only client able to connect to
several peer-to-peer networks, to download and share files. It works as
a daemon, running unattended on the computer, and can be controlled
remotely using a choice of three different kinds of interfaces: GTK, web
and telnet.”
|js}
  ; body_html = {js|<p><a href="https://mldonkey.sourceforge.net/Main_Page">MLdonkey</a> is a
multi-platform multi-networks peer-to-peer client. It was the first
open-source client to access the eDonkey network. Today, MLdonkey
supports several other large networks, among which Overnet, Bittorrent,
Gnutella, Gnutella2, Fasttrack, Soulseek, Direct-Connect, and Opennap.
Searches can be conducted over several networks concurrently; files are
downloaded from and uploaded to multiple peers concurrently.</p>
<p><em>An MLdonkey developer says:</em> “Early in 2002, we decided to use OCaml to
program a network application in the emerging world of peer-to-peer
systems. The result of our work, MLdonkey, has surpassed our hopes:
MLdonkey is currently the most popular peer-to-peer file-sharing client
according to <a href="https://freecode.com/">free(code)</a> (formerly “freshmeat.net”),
with about 10,000
daily users. Moreover, MLdonkey is the only client able to connect to
several peer-to-peer networks, to download and share files. It works as
a daemon, running unattended on the computer, and can be controlled
remotely using a choice of three different kinds of interfaces: GTK, web
and telnet.”</p>
|js}
  };
 
  { title = {js|SLAM|js}
  ; slug = {js|slam|js}
  ; image = None
  ; url = Some {js|https://research.microsoft.com/en-us/projects/slam/|js}
  ; body_md = {js|
The [SLAM](https://research.microsoft.com/en-us/projects/slam/) project
originated in Microsoft Research in early 2000. Its goal was to
automatically check that a C program correctly uses the interface to an
external library. The project used and extended ideas from symbolic
model checking, program analysis and theorem proving in novel ways to
address this problem. The SLAM analysis engine forms the core of a new
tool called Static Driver Verifier (SDV) that systematically analyzes
the source code of Windows device drivers against a set of rules that
define what it means for a device driver to properly interact with the
Windows operating system kernel.

*In technical report
[MSR-TR-2004-08](https://research.microsoft.com/apps/pubs/default.aspx?id=70038),
T.Ball, B.Cook, V.Levin and S.K.Rajamani, the SLAM developers, write:*
“The Right Tools for the Job: We developed SLAM using Inria's OCaml
functional programming language. The expressiveness of this language and
robustness of its implementation provided a great productivity boost.”
|js}
  ; body_html = {js|<p>The <a href="https://research.microsoft.com/en-us/projects/slam/">SLAM</a> project
originated in Microsoft Research in early 2000. Its goal was to
automatically check that a C program correctly uses the interface to an
external library. The project used and extended ideas from symbolic
model checking, program analysis and theorem proving in novel ways to
address this problem. The SLAM analysis engine forms the core of a new
tool called Static Driver Verifier (SDV) that systematically analyzes
the source code of Windows device drivers against a set of rules that
define what it means for a device driver to properly interact with the
Windows operating system kernel.</p>
<p><em>In technical report
<a href="https://research.microsoft.com/apps/pubs/default.aspx?id=70038">MSR-TR-2004-08</a>,
T.Ball, B.Cook, V.Levin and S.K.Rajamani, the SLAM developers, write:</em>
“The Right Tools for the Job: We developed SLAM using Inria's OCaml
functional programming language. The expressiveness of this language and
robustness of its implementation provided a great productivity boost.”</p>
|js}
  };
 
  { title = {js|The Unison File Synchronizer|js}
  ; slug = {js|the-unison-file-synchronizer|js}
  ; image = Some {js|/success-stories/unison-thumb.jpg|js}
  ; url = Some {js|https://www.cis.upenn.edu/%7Ebcpierce/unison/|js}
  ; body_md = {js|
[Unison](https://www.cis.upenn.edu/%7Ebcpierce/unison/) is a popular
file-synchronization tool for Windows and most flavors of Unix. It
allows two replicas of a collection of files and directories to be
stored on different hosts (or different disks on the same host),
modified separately, and then brought up to date by propagating the
changes in each replica to the other. Unlike simple mirroring or backup
utilities, Unison can deal with updates to both replicas: updates that
do not conflict are propagated automatically and conflicting updates are
detected and displayed. Unison is also resilient to failure: it is
careful to leave the replicas and its own private structures in a
sensible state at all times, even in case of abnormal termination or
communication failures.

*[Benjamin C. Pierce](https://www.cis.upenn.edu/%7Ebcpierce/) (University
of Pennsylvania), Unison project leader, says:* “I think Unison is a
very clear success for OCaml – in particular, for the extreme
portability and overall excellent engineering of the compiler and
runtime system. OCaml's strong static typing, in combination with its
powerful module system, helped us organize a large and intricate
codebase with a high degree of encapsulation. This has allowed us to
maintain a high level of robustness through years of work by many
different programmers. In fact, Unison may be unique among large OCaml
projects in having been *translated* from Java to OCaml midway through
its development. Moving to OCaml was like a breath of fresh air.”
|js}
  ; body_html = {js|<p><a href="https://www.cis.upenn.edu/%7Ebcpierce/unison/">Unison</a> is a popular
file-synchronization tool for Windows and most flavors of Unix. It
allows two replicas of a collection of files and directories to be
stored on different hosts (or different disks on the same host),
modified separately, and then brought up to date by propagating the
changes in each replica to the other. Unlike simple mirroring or backup
utilities, Unison can deal with updates to both replicas: updates that
do not conflict are propagated automatically and conflicting updates are
detected and displayed. Unison is also resilient to failure: it is
careful to leave the replicas and its own private structures in a
sensible state at all times, even in case of abnormal termination or
communication failures.</p>
<p><em><a href="https://www.cis.upenn.edu/%7Ebcpierce/">Benjamin C. Pierce</a> (University
of Pennsylvania), Unison project leader, says:</em> “I think Unison is a
very clear success for OCaml – in particular, for the extreme
portability and overall excellent engineering of the compiler and
runtime system. OCaml's strong static typing, in combination with its
powerful module system, helped us organize a large and intricate
codebase with a high degree of encapsulation. This has allowed us to
maintain a high level of robustness through years of work by many
different programmers. In fact, Unison may be unique among large OCaml
projects in having been <em>translated</em> from Java to OCaml midway through
its development. Moving to OCaml was like a breath of fresh air.”</p>
|js}
  }]

let all_fr = 
[
  { title = {js|L'analyseur statique ASTRÉE|js}
  ; slug = {js|lanalyseur-statique-astre|js}
  ; image = Some {js|/success-stories/astree-thumb.gif|js}
  ; url = Some {js|https://www.astree.ens.fr/|js}
  ; body_md = {js|
*[David Monniaux](https://www-verimag.imag.fr/~monniaux/) (CNRS), membre
du projet ASTRÉE :* « [ASTRÉE](https://www.astree.ens.fr/) est un
*analyseur statique* basé sur [l'interprétation
abstraite](https://www.di.ens.fr/%7Ecousot/aiintro.shtml) et qui vise à
établir l'absence d'erreurs d'exécution dans des logiciels critiques
écrits dans un sous-ensemble du langage C. »

« Une analyse automatique et exacte visant à vérifier des propriétés
telles que l'absence d'erreurs d'exécution est impossible en général,
pour des raisons mathématiques. L'analyse statique par interprétation
abstraite contourne cette impossibilité, et permet de prouver des
propriétés de programmes, en sur-estimant l'ensemble des comportements
possibles d'un programme. Il est possible de concevoir des
approximations pessimistes qui, en pratique, permettent d'établir la
propriété souhaitée pour une large gamme de logiciels. »

« À ce jour, ASTRÉE a prouvé l'absence d'erreurs d'exécution dans le
logiciel de contrôle primaire de la [famille Airbus
A340](https://www.airbus.com/product/a330_a340_backgrounder.asp). Cela
serait impossible par de simples *tests*, car le test ne considère qu'un
*sous-ensemble* limité des cas, tandis que l'interprétation abstraite
considère un *sur-ensemble* de tous les comportements possibles du
système. »

« [ASTRÉE](https://www.astree.ens.fr/) est écrit en OCaml et mesure
environ 44000 lignes (plus des librairies externes). Nous avions besoin
d'un langage doté d'une bonne performance (en termes de vitesse et
d'occupation mémoire) sur un matériel raisonnable, favorisant l'emploi
de structures de données avancées, et garantissant la sûreté mémoire.
OCaml permet également d'organiser le code source de façon modulaire,
claire et compacte, et facilite la gestion de structures de données
récursives comme les arbres de syntaxe abstraite. »
|js}
  ; body_html = {js|<p><em><a href="https://www-verimag.imag.fr/~monniaux/">David Monniaux</a> (CNRS), membre
du projet ASTRÉE :</em> « <a href="https://www.astree.ens.fr/">ASTRÉE</a> est un
<em>analyseur statique</em> basé sur <a href="https://www.di.ens.fr/%7Ecousot/aiintro.shtml">l'interprétation
abstraite</a> et qui vise à
établir l'absence d'erreurs d'exécution dans des logiciels critiques
écrits dans un sous-ensemble du langage C. »</p>
<p>« Une analyse automatique et exacte visant à vérifier des propriétés
telles que l'absence d'erreurs d'exécution est impossible en général,
pour des raisons mathématiques. L'analyse statique par interprétation
abstraite contourne cette impossibilité, et permet de prouver des
propriétés de programmes, en sur-estimant l'ensemble des comportements
possibles d'un programme. Il est possible de concevoir des
approximations pessimistes qui, en pratique, permettent d'établir la
propriété souhaitée pour une large gamme de logiciels. »</p>
<p>« À ce jour, ASTRÉE a prouvé l'absence d'erreurs d'exécution dans le
logiciel de contrôle primaire de la <a href="https://www.airbus.com/product/a330_a340_backgrounder.asp">famille Airbus
A340</a>. Cela
serait impossible par de simples <em>tests</em>, car le test ne considère qu'un
<em>sous-ensemble</em> limité des cas, tandis que l'interprétation abstraite
considère un <em>sur-ensemble</em> de tous les comportements possibles du
système. »</p>
<p>« <a href="https://www.astree.ens.fr/">ASTRÉE</a> est écrit en OCaml et mesure
environ 44000 lignes (plus des librairies externes). Nous avions besoin
d'un langage doté d'une bonne performance (en termes de vitesse et
d'occupation mémoire) sur un matériel raisonnable, favorisant l'emploi
de structures de données avancées, et garantissant la sûreté mémoire.
OCaml permet également d'organiser le code source de façon modulaire,
claire et compacte, et facilite la gestion de structures de données
récursives comme les arbres de syntaxe abstraite. »</p>
|js}
  };
 
  { title = {js|Coq|js}
  ; slug = {js|coq|js}
  ; image = Some {js|/success-stories/coq-thumb.jpg|js}
  ; url = Some {js|https://coq.inria.fr/|js}
  ; body_md = {js|
*[Jean-Christophe Filliâtre](https://www.lri.fr/%7Efilliatr/) (CNRS), un
des développeurs de Coq :* « L'outil [Coq](https://coq.inria.fr/) est un
système de manipulation de preuves mathématiques formelles ; une preuve
réalisée avec Coq est mécaniquement vérifiée par la machine. Outre ses
applications en mathématiques, l'outil Coq permet également de certifier
la correction de programmes informatiques. »

« L'intérêt de OCaml du point de vue de Coq est multiple. D'une part, le
langage OCaml est parfaitement adapté aux manipulations symboliques, qui
sont prépondérantes dans un assistant de preuve. D'autre part, le
système de types de OCaml, et notamment sa notion de type abstrait,
permet une réelle encapsulation de la partie critique du code de Coq,
garantissant ainsi la cohérence logique de l'ensemble du système. Enfin,
le typage fort de OCaml assure de fait une grande qualité au code de Coq
(tel que l'absence d'erreurs à l'exécution du type « segmentation
fault »), ce qui est indispensable à un outil dont le but premier est
justement la rigueur. »
|js}
  ; body_html = {js|<p><em><a href="https://www.lri.fr/%7Efilliatr/">Jean-Christophe Filliâtre</a> (CNRS), un
des développeurs de Coq :</em> « L'outil <a href="https://coq.inria.fr/">Coq</a> est un
système de manipulation de preuves mathématiques formelles ; une preuve
réalisée avec Coq est mécaniquement vérifiée par la machine. Outre ses
applications en mathématiques, l'outil Coq permet également de certifier
la correction de programmes informatiques. »</p>
<p>« L'intérêt de OCaml du point de vue de Coq est multiple. D'une part, le
langage OCaml est parfaitement adapté aux manipulations symboliques, qui
sont prépondérantes dans un assistant de preuve. D'autre part, le
système de types de OCaml, et notamment sa notion de type abstrait,
permet une réelle encapsulation de la partie critique du code de Coq,
garantissant ainsi la cohérence logique de l'ensemble du système. Enfin,
le typage fort de OCaml assure de fait une grande qualité au code de Coq
(tel que l'absence d'erreurs à l'exécution du type « segmentation
fault »), ce qui est indispensable à un outil dont le but premier est
justement la rigueur. »</p>
|js}
  };
 
  { title = {js|Le système de communication distribuée Ensemble|js}
  ; slug = {js|le-systme-de-communication-distribue-ensemble|js}
  ; image = None
  ; url = Some {js|https://dsl.cs.technion.ac.il/projects/Ensemble/|js}
  ; body_md = {js|
*Ohad Rodeh (IBM Haifa), un des développeurs d'Ensemble :*
« [Ensemble](https://dsl.cs.technion.ac.il/projects/Ensemble/) est un
système de communication de groupe écrit en OCaml, développé à Cornell
et à Hebrew University. À l'auteur d'applications, Ensemble fournit une
librairie de protocoles que l'on peut utiliser pour construire
rapidement des applications distribuées complexes. Pour un chercheur en
systèmes distribués, Ensemble est une boîte à outils hautement modulaire
et reconfigurable : les protocoles de haut niveau fournis aux
applications sont en réalité des piles de minuscules « couches » de
protocoles, dont chacune peut être modifiée ou reconstruite à des fins
d'expérimentation. OCaml a été choisi initialement pour que le code
puisse être vérifié par un prouveur de théorèmes semi-automatique. Ce
code a ensuite fait ses preuves sur le terrain, et nous avons continué à
développer en OCaml. Le système de types fort, les types de données
algébriques, la récupération automatique de la mémoire et
l'environnement d'exécution sont les principales raisons de notre
intérêt pour OCaml. »
|js}
  ; body_html = {js|<p><em>Ohad Rodeh (IBM Haifa), un des développeurs d'Ensemble :</em>
« <a href="https://dsl.cs.technion.ac.il/projects/Ensemble/">Ensemble</a> est un
système de communication de groupe écrit en OCaml, développé à Cornell
et à Hebrew University. À l'auteur d'applications, Ensemble fournit une
librairie de protocoles que l'on peut utiliser pour construire
rapidement des applications distribuées complexes. Pour un chercheur en
systèmes distribués, Ensemble est une boîte à outils hautement modulaire
et reconfigurable : les protocoles de haut niveau fournis aux
applications sont en réalité des piles de minuscules « couches » de
protocoles, dont chacune peut être modifiée ou reconstruite à des fins
d'expérimentation. OCaml a été choisi initialement pour que le code
puisse être vérifié par un prouveur de théorèmes semi-automatique. Ce
code a ensuite fait ses preuves sur le terrain, et nous avons continué à
développer en OCaml. Le système de types fort, les types de données
algébriques, la récupération automatique de la mémoire et
l'environnement d'exécution sont les principales raisons de notre
intérêt pour OCaml. »</p>
|js}
  };
 
  { title = {js|FFTW|js}
  ; slug = {js|fftw|js}
  ; image = Some {js|/success-stories/fftw-thumb.png|js}
  ; url = Some {js|https://www.fftw.org/|js}
  ; body_md = {js|
[FFTW](https://www.fftw.org/) est une librairie C [très
rapide](https://www.fftw.org/benchfft/) permettant d'effectuer des
Transformées de Fourier Discrètes (DFT). Elle emploie un puissant
optimiseur symbolique écrit en OCaml qui, étant donné un entier N,
produit du code C hautement optimisé pour effectuer des DFTs de taille
N. FFTW a reçu en 1999 le [prix
Wilkinson](https://en.wikipedia.org/wiki/J._H._Wilkinson_Prize_for_Numerical_Software)
pour les logiciels de calcul numérique.

Des mesures effectuées sur diverses plate-formes montrent que les
performances de FFTW sont typiquement supérieures à celles des autres
logiciels de DFT disponibles publiquement, et peuvent même concurrencer
le code optimisé proposé par certains fabriquants de processeurs. À la
différence de ce code propriétaire, cependant, les performances de FFTW
sont portables : un même programme donnera de bons résultats sur la
plupart des architectures sans modification. D'où le nom « FFTW, » qui
signifie « Fastest Fourier Transform in the West. »
|js}
  ; body_html = {js|<p><a href="https://www.fftw.org/">FFTW</a> est une librairie C <a href="https://www.fftw.org/benchfft/">très
rapide</a> permettant d'effectuer des
Transformées de Fourier Discrètes (DFT). Elle emploie un puissant
optimiseur symbolique écrit en OCaml qui, étant donné un entier N,
produit du code C hautement optimisé pour effectuer des DFTs de taille
N. FFTW a reçu en 1999 le <a href="https://en.wikipedia.org/wiki/J._H._Wilkinson_Prize_for_Numerical_Software">prix
Wilkinson</a>
pour les logiciels de calcul numérique.</p>
<p>Des mesures effectuées sur diverses plate-formes montrent que les
performances de FFTW sont typiquement supérieures à celles des autres
logiciels de DFT disponibles publiquement, et peuvent même concurrencer
le code optimisé proposé par certains fabriquants de processeurs. À la
différence de ce code propriétaire, cependant, les performances de FFTW
sont portables : un même programme donnera de bons résultats sur la
plupart des architectures sans modification. D'où le nom « FFTW, » qui
signifie « Fastest Fourier Transform in the West. »</p>
|js}
  };
 
  { title = {js|Haxe|js}
  ; slug = {js|haxe|js}
  ; image = None
  ; url = Some {js|https://haxe.org/|js}
  ; body_md = {js|
[Haxe](https://haxe.org/)  est une boîte à outils open source basée sur un 
langage de programmation moderne, de haut niveau, strictement typé, un 
compilateur croisé, une bibliothèque standard multiplateforme complète et 
des moyens d’accéder aux capacités natives de chaque plate-forme.Le compilateur 
Haxe a été entièrement écrit dans OCaml.
|js}
  ; body_html = {js|<p><a href="https://haxe.org/">Haxe</a>  est une boîte à outils open source basée sur un
langage de programmation moderne, de haut niveau, strictement typé, un
compilateur croisé, une bibliothèque standard multiplateforme complète et
des moyens d’accéder aux capacités natives de chaque plate-forme.Le compilateur
Haxe a été entièrement écrit dans OCaml.</p>
|js}
  };
 
  { title = {js|Jane Street|js}
  ; slug = {js|jane-street|js}
  ; image = Some {js|/success-stories/jane-street-thumb.jpg|js}
  ; url = Some {js|https://janestreet.com/technology/|js}
  ; body_md = {js|
Jane Street est une société de négoce propriétaire qui utilise OCaml comme sa 
plate-forme de développement primaire. Notre exploitation fonctionne à grande 
échelle, générant des milliards de dollars de transactions chaque jour à partir 
de nos bureaux de Hong Kong,Londres et New York, avec des stratégies qui couvrent 
de nombreuses classes d’actifs, fuseaux horaires et régimes réglementaires.

Presque tous nos logiciels sont écrits dans OCaml, du code de recherche statistique 
aux outils d’administration des systèmes en retour de notre infrastructure de trading 
en temps réel. Le système de type d’OCaml agit comme un ensemble riche et bien intégré 
d’outils d’analyse statique qui aident à améliorer la qualité de notre code, en 
attrapant les bogues le plus tôt possible. Chaque jour, des milliards de dollars de 
transactions passent par nos systèmes, ce qui fait en sorte que les choses se passent 
bien. Dans le même temps, OCaml est très productif, nous aidant à nous adapter rapidement 
à l’évolution des conditions du marché.

Jane Street contribue aux bibliothèques open-source à l’ensemble de la communauté depuis 
de nombreuses années, y compris Core, notre bibliothèque standard alternative, Async, une 
bibliothèque coopérative de concurrence, et plusieurs extensions syntaxiques comme binprot 
et sexplib.Tous ces éléments peuvent être trouvés à 
[https://janestreet.github.io](https://janestreet.github.io). Au total, nous avons ouvert
plus de 200k lignes de code.
|js}
  ; body_html = {js|<p>Jane Street est une société de négoce propriétaire qui utilise OCaml comme sa
plate-forme de développement primaire. Notre exploitation fonctionne à grande
échelle, générant des milliards de dollars de transactions chaque jour à partir
de nos bureaux de Hong Kong,Londres et New York, avec des stratégies qui couvrent
de nombreuses classes d’actifs, fuseaux horaires et régimes réglementaires.</p>
<p>Presque tous nos logiciels sont écrits dans OCaml, du code de recherche statistique
aux outils d’administration des systèmes en retour de notre infrastructure de trading
en temps réel. Le système de type d’OCaml agit comme un ensemble riche et bien intégré
d’outils d’analyse statique qui aident à améliorer la qualité de notre code, en
attrapant les bogues le plus tôt possible. Chaque jour, des milliards de dollars de
transactions passent par nos systèmes, ce qui fait en sorte que les choses se passent
bien. Dans le même temps, OCaml est très productif, nous aidant à nous adapter rapidement
à l’évolution des conditions du marché.</p>
<p>Jane Street contribue aux bibliothèques open-source à l’ensemble de la communauté depuis
de nombreuses années, y compris Core, notre bibliothèque standard alternative, Async, une
bibliothèque coopérative de concurrence, et plusieurs extensions syntaxiques comme binprot
et sexplib.Tous ces éléments peuvent être trouvés à
<a href="https://janestreet.github.io">https://janestreet.github.io</a>. Au total, nous avons ouvert
plus de 200k lignes de code.</p>
|js}
  };
 
  { title = {js|Le Langage de Modélisation Financière de LexiFi|js}
  ; slug = {js|le-langage-de-modlisation-financire-de-lexifi|js}
  ; image = Some {js|/success-stories/lexifi-thumb.jpg|js}
  ; url = Some {js|https://www.lexifi.com/|js}
  ; body_md = {js|
Développé par la société [LexiFi](https://www.lexifi.com/), le Langage de
Modélisation Financière (MLFi) est le premier langage formel capable de
décrire les produits d'investissement, de crédit et de marché de
capitaux les plus sophistiqués. MLFi est implanté comme une extension
d'OCaml.

Les utilisateurs de MLFi retirent deux importants bénéfices de
l'approche par programmation fonctionnelle. D'abord, le formalisme
déclaratif des langages de programmation fonctionnels est adapté à la
*spécification* de structures de données et d'algorithmes complexes.
Ensuite, ces langages offrent de nombreuses facilités pour la
manipulation des listes. Or, les listes jouent un rôle central en
finance, où elles sont utilisées de façon intensive pour définir des
agendas d'événements de contrats et de paiements.

De plus, MLFi est doté de capacités d'intégration cruciales, héritées
d'OCaml et des outils et librairies qui l'accompagnent, Cela permet aux
utilisateurs, par exemple, d'interopérer avec des programmes C et Java,
de manipuler des schémas et documents XML, et de s'interfacer avec des
bases de données SQL.

Des modèles de données et modèles objets visant à encapsuler les
définitions et le comportement des instruments financiers ont été
développés par l'industrie bancaire depuis deux décennies, mais font
face à des limitations inhérentes qu'OCaml a aidé à surpasser.

L'approche de LexiFi pour la modélisation de contrats financiers
complexes a reçu une récompense académique en 2000, et l'implantation de
MLFi a été nommée « Produit Logiciel de l'Année 2001 » par le magazine
*Risk*, la principale publication dans le domaine des échanges
financiers et de la gestion des risques. Les solutions basées sur MLFi
gagnent en reconnaissance à travers l'Europe et contribuent à répandre
l'utilisation d'OCaml dans l'industrie des services financiers.
|js}
  ; body_html = {js|<p>Développé par la société <a href="https://www.lexifi.com/">LexiFi</a>, le Langage de
Modélisation Financière (MLFi) est le premier langage formel capable de
décrire les produits d'investissement, de crédit et de marché de
capitaux les plus sophistiqués. MLFi est implanté comme une extension
d'OCaml.</p>
<p>Les utilisateurs de MLFi retirent deux importants bénéfices de
l'approche par programmation fonctionnelle. D'abord, le formalisme
déclaratif des langages de programmation fonctionnels est adapté à la
<em>spécification</em> de structures de données et d'algorithmes complexes.
Ensuite, ces langages offrent de nombreuses facilités pour la
manipulation des listes. Or, les listes jouent un rôle central en
finance, où elles sont utilisées de façon intensive pour définir des
agendas d'événements de contrats et de paiements.</p>
<p>De plus, MLFi est doté de capacités d'intégration cruciales, héritées
d'OCaml et des outils et librairies qui l'accompagnent, Cela permet aux
utilisateurs, par exemple, d'interopérer avec des programmes C et Java,
de manipuler des schémas et documents XML, et de s'interfacer avec des
bases de données SQL.</p>
<p>Des modèles de données et modèles objets visant à encapsuler les
définitions et le comportement des instruments financiers ont été
développés par l'industrie bancaire depuis deux décennies, mais font
face à des limitations inhérentes qu'OCaml a aidé à surpasser.</p>
<p>L'approche de LexiFi pour la modélisation de contrats financiers
complexes a reçu une récompense académique en 2000, et l'implantation de
MLFi a été nommée « Produit Logiciel de l'Année 2001 » par le magazine
<em>Risk</em>, la principale publication dans le domaine des échanges
financiers et de la gestion des risques. Les solutions basées sur MLFi
gagnent en reconnaissance à travers l'Europe et contribuent à répandre
l'utilisation d'OCaml dans l'industrie des services financiers.</p>
|js}
  };
 
  { title = {js|Liquidsoap|js}
  ; slug = {js|liquidsoap|js}
  ; image = None
  ; url = None
  ; body_md = {js|
[Liquidsoap](https://www.liquidsoap.info/) est clairement bien établie dans 
l’industrie de la radio (internet).Liquidsoap est bien connu comme un 
outil avec des capacités uniques, et a beaucoup d’utilisateurs, y compris 
les grands commerciaux.Il n’est pas développé comme une entreprise, mais les 
entreprises développent des services ou des logiciels sur le dessus de celui-ci.
Par exemple, Sourcefabric développe et vend du temps d’antenne au-dessus de Liquidsoap.
|js}
  ; body_html = {js|<p><a href="https://www.liquidsoap.info/">Liquidsoap</a> est clairement bien établie dans
l’industrie de la radio (internet).Liquidsoap est bien connu comme un
outil avec des capacités uniques, et a beaucoup d’utilisateurs, y compris
les grands commerciaux.Il n’est pas développé comme une entreprise, mais les
entreprises développent des services ou des logiciels sur le dessus de celui-ci.
Par exemple, Sourcefabric développe et vend du temps d’antenne au-dessus de Liquidsoap.</p>
|js}
  };
 
  { title = {js|Le client pair-à-pair MLdonkey|js}
  ; slug = {js|le-client-pair--pair-mldonkey|js}
  ; image = Some {js|/success-stories/mldonkey-thumb.jpg|js}
  ; url = Some {js|https://mldonkey.sourceforge.net/Main_Page|js}
  ; body_md = {js|
[MLdonkey](https://mldonkey.sourceforge.net/Main_Page) est un client
pair-à-pair multi-plateformes et multi-réseaux. Il a été le premier
client « open source » à permettre l'accès au réseau eDonkey.
Aujourd'hui, MLdonkey autorise également l'accès à plusieurs autres
réseaux importants, parmi lesquels Overnet, Bittorrent, Gnutella,
Gnutella2, Fasttrack, Soulseek, Direct-Connect et Opennap. Il permet
d'effectuer une recherche en parallèle sur plusieurs réseaux, et échange
des fichiers avec de multiples pairs en parallèle.

*Un des développeurs de MLdonkey :* « Début 2002, nous avons décidé
d'utiliser OCaml pour programmer une application réseau dans le monde
émergent des systèmes pair-à-pair. Le résultat de notre travail,
MLdonkey, a surpassé nos espérances : MLdonkey est aujourd'hui le client
de partage de fichiers pair-à-pair le plus populaire, d'après
[freshmeat.net](https://freshmeat.net/), avec environ dix mille
utilisateurs quotidiens. De plus, MLdonkey est le seul client capable de
se connecter à plusieurs réseaux pair-à-pair pour télécharger et
échanger des fichiers. Il fonctionne en tant que démon, c'est-à-dire en
tâche de fond et sans surveillance humaine, et peut être contrôlé à
l'aide d'une interface au choix parmi trois : GTK, web et telnet. »
|js}
  ; body_html = {js|<p><a href="https://mldonkey.sourceforge.net/Main_Page">MLdonkey</a> est un client
pair-à-pair multi-plateformes et multi-réseaux. Il a été le premier
client « open source » à permettre l'accès au réseau eDonkey.
Aujourd'hui, MLdonkey autorise également l'accès à plusieurs autres
réseaux importants, parmi lesquels Overnet, Bittorrent, Gnutella,
Gnutella2, Fasttrack, Soulseek, Direct-Connect et Opennap. Il permet
d'effectuer une recherche en parallèle sur plusieurs réseaux, et échange
des fichiers avec de multiples pairs en parallèle.</p>
<p><em>Un des développeurs de MLdonkey :</em> « Début 2002, nous avons décidé
d'utiliser OCaml pour programmer une application réseau dans le monde
émergent des systèmes pair-à-pair. Le résultat de notre travail,
MLdonkey, a surpassé nos espérances : MLdonkey est aujourd'hui le client
de partage de fichiers pair-à-pair le plus populaire, d'après
<a href="https://freshmeat.net/">freshmeat.net</a>, avec environ dix mille
utilisateurs quotidiens. De plus, MLdonkey est le seul client capable de
se connecter à plusieurs réseaux pair-à-pair pour télécharger et
échanger des fichiers. Il fonctionne en tant que démon, c'est-à-dire en
tâche de fond et sans surveillance humaine, et peut être contrôlé à
l'aide d'une interface au choix parmi trois : GTK, web et telnet. »</p>
|js}
  };
 
  { title = {js|SLAM|js}
  ; slug = {js|slam|js}
  ; image = None
  ; url = Some {js|https://research.microsoft.com/en-us/projects/slam/|js}
  ; body_md = {js|
Le projet [SLAM](https://research.microsoft.com/en-us/projects/slam/) a
débuté à Microsoft Research début 2000. Son but était de vérifier
automatiquement qu'un programme C utilise correctement l'interface d'une
bibliothèque extérieure. Pour répondre à cette question, SLAM utilise de
manière novatrice des idées provenant de la vérification symbolique de
modèles, de l'analyse statique de programmes et de la démonstration
automatique. Le moteur d'analyse SLAM est au coeur d'un nouvel outil
appelé SDV (Vérification Statique de Drivers) qui analyse
systématiquement le code source des drivers (pilotes de périphériques)
Windows et vérifie leur conformité vis-à-vis d'un ensemble de règles qui
caractérisent les interactions correctes entre un driver et le noyau du
système d'exploitation Windows.

*Dans le rapport technique
[MSR-TR-2004-08](https://research.microsoft.com/apps/pubs/default.aspx?id=70038),
T.Ball, B.Cook, V.Levin and S.K.Rajamani, les auteurs de SLAM,
écrivent:* “The Right Tools for the Job: We developed SLAM using Inria's
OCaml functional programming language. The expressiveness of this
language and robustness of its implementation provided a great
productivity boost.”
|js}
  ; body_html = {js|<p>Le projet <a href="https://research.microsoft.com/en-us/projects/slam/">SLAM</a> a
débuté à Microsoft Research début 2000. Son but était de vérifier
automatiquement qu'un programme C utilise correctement l'interface d'une
bibliothèque extérieure. Pour répondre à cette question, SLAM utilise de
manière novatrice des idées provenant de la vérification symbolique de
modèles, de l'analyse statique de programmes et de la démonstration
automatique. Le moteur d'analyse SLAM est au coeur d'un nouvel outil
appelé SDV (Vérification Statique de Drivers) qui analyse
systématiquement le code source des drivers (pilotes de périphériques)
Windows et vérifie leur conformité vis-à-vis d'un ensemble de règles qui
caractérisent les interactions correctes entre un driver et le noyau du
système d'exploitation Windows.</p>
<p><em>Dans le rapport technique
<a href="https://research.microsoft.com/apps/pubs/default.aspx?id=70038">MSR-TR-2004-08</a>,
T.Ball, B.Cook, V.Levin and S.K.Rajamani, les auteurs de SLAM,
écrivent:</em> “The Right Tools for the Job: We developed SLAM using Inria's
OCaml functional programming language. The expressiveness of this
language and robustness of its implementation provided a great
productivity boost.”</p>
|js}
  };
 
  { title = {js|Le synchroniseur de fichiers Unison|js}
  ; slug = {js|le-synchroniseur-de-fichiers-unison|js}
  ; image = Some {js|/success-stories/unison-thumb.jpg|js}
  ; url = Some {js|https://www.cis.upenn.edu/%7Ebcpierce/unison/|js}
  ; body_md = {js|
[Unison](https://www.cis.upenn.edu/%7Ebcpierce/unison/) est un outil de
synchronisation de fichiers populaire, qui fonctionne sous Windows et
sous la plupart des variantes d'Unix. Il permet de stocker deux
répliques d'une collection de fichiers et de répertoires sur deux
machines différentes, ou bien sur deux disques différents d'une même
machine, et de les mettre à jour en propageant les changements de
chacune des répliques vers l'autre. À la différence d'un simple outil de
sauvegarde ou de maintien d'une image miroir, Unison est capable de
gérer la situation où les deux répliques ont été modifiées : les
changements qui n'entrent pas en conflit sont propagés automatiquement,
tandis que les changements incompatibles sont détectés et signalés.
Unison est également résistant aux échecs : il prend soin de laisser les
deux répliques, ainsi que ses propres structures privées, dans un état
cohérent à tout instant, même en cas d'arrêt abrupt ou de panne de
communication.

*[Benjamin C. Pierce](https://www.cis.upenn.edu/%7Ebcpierce/) (University
of Pennsylvania), chef du projet Unison :* « Je pense qu'Unison est un
succès très clair pour OCaml – en particulier, grâce à l'extrême
portabilité et l'excellente conception générale du compilateur et de
l'environnement d'exécution. Le typage statique fort d'OCaml, ainsi que
son puissant système de modules, nous ont aidés à organiser un logiciel
complexe et de grande taille avec un haut degré d'encapsulation. Ceci
nous a permis de préserver un haut niveau de robustesse, au cours de
plusieurs années de travail, et avec la participation de nombreux
programmeurs. En fait, Unison présente la caractéristique, peut-être
unique parmi les projets de grande taille écrits en OCaml, d'avoir été
*traduit* de Java vers OCaml à mi-chemin au cours de son développement.
L'adoption d'OCaml a été comme une bouffée d'air pur. »
|js}
  ; body_html = {js|<p><a href="https://www.cis.upenn.edu/%7Ebcpierce/unison/">Unison</a> est un outil de
synchronisation de fichiers populaire, qui fonctionne sous Windows et
sous la plupart des variantes d'Unix. Il permet de stocker deux
répliques d'une collection de fichiers et de répertoires sur deux
machines différentes, ou bien sur deux disques différents d'une même
machine, et de les mettre à jour en propageant les changements de
chacune des répliques vers l'autre. À la différence d'un simple outil de
sauvegarde ou de maintien d'une image miroir, Unison est capable de
gérer la situation où les deux répliques ont été modifiées : les
changements qui n'entrent pas en conflit sont propagés automatiquement,
tandis que les changements incompatibles sont détectés et signalés.
Unison est également résistant aux échecs : il prend soin de laisser les
deux répliques, ainsi que ses propres structures privées, dans un état
cohérent à tout instant, même en cas d'arrêt abrupt ou de panne de
communication.</p>
<p><em><a href="https://www.cis.upenn.edu/%7Ebcpierce/">Benjamin C. Pierce</a> (University
of Pennsylvania), chef du projet Unison :</em> « Je pense qu'Unison est un
succès très clair pour OCaml – en particulier, grâce à l'extrême
portabilité et l'excellente conception générale du compilateur et de
l'environnement d'exécution. Le typage statique fort d'OCaml, ainsi que
son puissant système de modules, nous ont aidés à organiser un logiciel
complexe et de grande taille avec un haut degré d'encapsulation. Ceci
nous a permis de préserver un haut niveau de robustesse, au cours de
plusieurs années de travail, et avec la participation de nombreux
programmeurs. En fait, Unison présente la caractéristique, peut-être
unique parmi les projets de grande taille écrits en OCaml, d'avoir été
<em>traduit</em> de Java vers OCaml à mi-chemin au cours de son développement.
L'adoption d'OCaml a été comme une bouffée d'air pur. »</p>
|js}
  }]

