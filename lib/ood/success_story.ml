
type t =
  { title : string
  ; slug : string
  ; image : string option
  ; url : string option
  ; body_md : string
  ; body_html : string
  }
  
let all = 
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

