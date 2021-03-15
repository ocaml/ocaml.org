module LINK = Markdown.LINK

let s = React.string

module LeftNav = {
  @react.component
  let make = () => {
    <>
      <h2> {s("Contents")} </h2>
      <ul>
        <li> <LINK href="#jane-street"> {s(`Jane Street`)} </LINK> </li>
        <li>
          <LINK href="#the-union-file-synchronizer"> {s(`The Union File Synchronizer`)} </LINK>
        </li>
        <li>
          <LINK href="#the-mldonkey-peer-to-peer-client">
            {s(`The MLdonkey peer-to-peer client`)}
          </LINK>
        </li>
        <li>
          <LINK href="#lexifis-modeling-language-for-finance">
            {s(`LexiFi's Modeling Language for Finance`)}
          </LINK>
        </li>
        <li> <LINK href="#the-coq-proof-assistant"> {s(`The Coq Proof Assistant`)} </LINK> </li>
        <li>
          <LINK href="#the-astree-static-analyzer"> {s(`The ASTRÉE Static Analyzer`)} </LINK>
        </li>
        <li> <LINK href="#slam"> {s(`SLAM`)} </LINK> </li>
        <li> <LINK href="#fftw"> {s(`FFTW`)} </LINK> </li>
        <li> <LINK href="#liquidsoap"> {s(`Liquidsoap`)} </LINK> </li>
        <li> <LINK href="#haxe"> {s(`Haxe`)} </LINK> </li>
      </ul>
    </>
  }
}

let default = () => <>
  <div>
    <nav role="navigation" ariaLabel="Table of Contents"> <LeftNav /> </nav>
    <div>
      <h1> {s(`Success Stories`)} </h1>
      <h2 id="jane-street"> {s(`Jane Street`)} </h2>
      <LINK href="http://janestreet.com/technology/">
        <img src="/static/jane-street.jpeg" alt="Jane Street technology website" />
      </LINK>
      <p>
        {s(`Jane Street is a proprietary trading firm that uses OCaml as its primary development platform. 
          Our operation runs at a large scale, generating billions of dollars of transactions every day from 
          our offices in Hong Kong, London and New York, with strategies that span many asset classes, 
          time-zones and regulatory regimes.`)}
      </p>
      <p>
        {s(`Almost all of our software is written in OCaml, from statistical research code to 
          systems-administration tools to our real-time trading infrastructure. OCaml’s type system acts 
          as a rich and well-integrated set of static analysis tools that help improve the quality 
          of our code, catching bugs at the earliest possible stage. Billions of dollars of transactions 
          flow through our systems every day, so getting it right matters. At the same time, OCaml is 
          highly productive, helping us quickly adapt to changing market conditions.`)}
      </p>
      <p>
        {s(`Jane Street has been contributing open-source libraries back to the wider community for many years, 
          including Core, our alternative standard library, Async, a cooperative concurrency library, and several 
          syntax extensions like binprot and sexplib. All of these can be found at `)}
        <LINK href="http://janestreet.github.io/"> {s(`Jane Street's open source website`)} </LINK>
        {s(`. All in, we've open-sourced more than 200k lines of code.`)}
      </p>
      <h2 id="the-union-file-synchronizer"> {s(`The Unison File Synchronizer`)} </h2>
      <LINK href="/static/unison.png">
        <img src="/static/unison-thumb.jpeg" alt="Unison user interface screenshot" />
      </LINK>
      <p>
        <LINK href="http://www.cis.upenn.edu/%7Ebcpierce/unison/">
          {s(`Unison File Synchronizer`)}
        </LINK>
        {s(` is a popular file-synchronization tool for Windows and most flavors of Unix. It allows two 
          replicas of a collection of files and directories to be stored on different hosts (or different 
          disks on the same host), modified separately, and then brought up to date by propagating the changes 
          in each replica to the other. Unlike simple mirroring or backup utilities, Unison can deal with 
          updates to both replicas: updates that do not conflict are propagated automatically and conflicting 
          updates are detected and displayed. Unison is also resilient to failure: it is careful to leave 
          the replicas and its own private structures in a sensible state at all times, even in case of 
          abnormal termination or communication failures.`)}
      </p>
      <p>
        <em>
          <LINK href="http://www.cis.upenn.edu/%7Ebcpierce/">
            {s(`Benjamin C. Pierce, Unison project leader`)}
          </LINK>
          {s(` at University of Pennsylvania, says:`)}
        </em>
        {s(` "I think Unison is a very clear success for OCaml – in particular, for the extreme portability 
          and overall excellent engineering of the compiler and runtime system. OCaml's strong static typing, 
          in combination with its powerful module system, helped us organize a large and intricate codebase 
          with a high degree of encapsulation. This has allowed us to maintain a high level of robustness 
          through years of work by many different programmers. In fact, Unison may be unique among large OCaml 
          projects in having been `)}
        {s(`translated`)}
        {s(` from Java to OCaml midway through its development. Moving to OCaml was like a breath of fresh air."`)}
      </p>
      <h2 id="the-mldonkey-peer-to-peer-client"> {s(`The MLdonkey peer-to-peer client`)} </h2>
      <LINK href="/static/mldonkey.jpg">
        <img src="/static/mldonkey-thumb.jpg" alt="MLDonkey screenshot" />
      </LINK>
      <p>
        <LINK href="http://mldonkey.sourceforge.net/Main_Page">
          {s(`MLdonkey is a multi-platform multi-networks peer-to-peer client`)}
        </LINK>
        {s(`. It was the first open-source client to access 
          the eDonkey network. Today, MLdonkey supports several other large networks, among which Overnet, Bittorrent, 
          Gnutella, Gnutella2, Fasttrack, Soulseek, Direct-Connect, and Opennap. Searches can be conducted over several 
          networks concurrently; files are downloaded from and uploaded to multiple peers concurrently.`)}
      </p>
      <p>
        <em> {s(`An MLdonkey developer says:`)} </em>
        {s(` "Early in 2002, we decided to use OCaml to program a network application in the emerging world of peer-to-peer 
          systems. The result of our work, MLdonkey, has surpassed our hopes: `)}
        <LINK href="http://freecode.com/">
          {s(`MLdonkey is currently the most popular 
          peer-to-peer file-sharing client according to free(code (formerly "freshmeat.net"))`)}
        </LINK>
        {s(`, with about 10,000 daily users. Moreover, MLdonkey is the only client able 
          to connect to several peer-to-peer networks, to download and share files. It works as a daemon, running 
          unattended on the computer, and can be controlled remotely using a choice of three different kinds of 
          interfaces: GTK, web and telnet."`)}
      </p>
      <h2 id="lexifis-modeling-language-for-finance">
        {s(`LexiFi's Modeling Language for Finance`)}
      </h2>
      <LINK href="/static/lexifi.jpg">
        <img src="/static/lexifi-thumb.jpg" alt="Report produced by LexiFi" />
      </LINK>
      <p>
        <LINK href="http://www.lexifi.com/">
          {s(`LexiFi is the company that developed the Modeling Language for Finance (MLFi)`)}
        </LINK>
        {s(`. MLFi is the first formal language that accurately describes the 
          most sophisticated capital market, credit, and investment products. MLFi is implemented as an extension of OCaml.`)}
      </p>
      <p>
        {s(`MLFi users derive two important benefits from a functional programming approach. First, the declarative formalism 
          of functional programming languages is well suited for `)}
        <em> {s(`specifying`)} </em>
        {s(` complex data structures and algorithms. Second, functional programming languages have strong `)}
        <em> {s(`list processing`)} </em>
        {s(` capabilities. Lists play a central role in finance where they are used extensively to define contract 
          event and payment schedules.`)}
      </p>
      <p>
        {s(`In addition, MLFi provides crucial business integration capabilities inherited from OCaml and related tools 
          and libraries. This enables users, for example, to interoperate with C and Java programs, manipulate XML schemas 
          and documents, and interface with SQL databases.`)}
      </p>
      <p>
        {s(`Data models and object models aiming to encapsulate the definitions and behavior of financial instruments were 
          developed by the banking industry over the past two decades, but face inherent limitations that OCaml helped overcome.`)}
      </p>
      <p>
        {s(`LexiFi's approach to modeling complex financial contracts received an academic award in 2000, and the 
          MLFi implementation was elected "Software Product of the Year 2001" by the magazine `)}
        <em> {s(`Risk`)} </em>
        {s(`, the leading financial trading and risk management publication. MLFi-based solutions are gaining growing 
          acceptance throughout Europe and are contributing to spread the use of OCaml in the financial services industry.`)}
      </p>
      <h2 id="the-coq-proof-assistant"> {s(`The Coq Proof Assistant`)} </h2>
      <LINK href="/static/coq.jpg"> <img src="/static/coq-thumb.jpg" alt="Coq screenshot" /> </LINK>
      <p>
        <em>
          <LINK href="https://www.lri.fr/~filliatr/">
            {s(`Jean-Christophe Filliâtre, a Coq developer`)}
          </LINK>
          {s(` at CNRS, says:`)}
        </em>
        {s(` "`)}
        <LINK href="http://coq.inria.fr/">
          {s(`The Coq tool is a system for manipulating formal mathematical proofs`)}
        </LINK>
        {s(`; a proof carried out in Coq is mechanically 
          verified by the machine. In addition to its applications in mathematics, Coq also allows certifying the 
          correctness of computer programs."`)}
      </p>
      <p>
        {s(`"From the Coq standpoint, OCaml is attractive on multiple grounds. First, the OCaml language is perfectly 
          suited for symbolic manipulations, which are of paramount importance in a proof assistant. Furthermore, 
          OCaml's type system, and particularly its notion of abstract type, allow securely encapsulating Coq's critical 
          code base, which guarantees the logical consistency of the whole system. Last, OCaml's strong type system `)}
        <em> {s(`de facto`)} </em>
        {s(` grants Coq's code a high level of quality: errors such as "segmentation faults" cannot occur during execution, 
          which is indispensable for a tool whose primary goal is precisely rigor."`)}
      </p>
      <h2 id="the-astree-static-analyzer"> {s(`The ASTRÉE Static Analyzer`)} </h2>
      <LINK href="http://www.airbus.com/">
        <img src="/static/astree.gif" alt="Airbus website, user's of ASTRÉE" />
      </LINK>
      <p>
        <em>
          <LINK href="http://www-verimag.imag.fr/~monniaux/">
            {s(`David Monniaux, member of the ASTRÉE project`)}
          </LINK>
          {s(` at CNRS, says:`)}
        </em>
        {s(` "`)}
        <LINK href="http://www.astree.ens.fr/">
          {s(`ASTRÉE is a `)} <em> {s(`static analyzer`)} </em>
        </LINK>
        {s(` based on the `)}
        <em>
          <LINK href="http://www.di.ens.fr/%7Ecousot/aiintro.shtml">
            {s(`concept of abstract interpretation`)}
          </LINK>
        </em>
        {s(` that aims at proving the absence of runtime errors in a safety-critical software written in a subset of the C
          programming language."`)}
      </p>
      <p>
        {s(`"Automatically analyzing programs for exactly checking properties such as the absence of runtime errors is 
          impossible in general, for mathematical reasons. Static analysis by abstract interpretation works around this 
          impossibility and proves program properties by over-approximating the possible behaviors of the program: it 
          is possible to design pessimistic approximations that, in practice, allow proving the desired property on a 
          wide range of software."`)}
      </p>
      <p>
        {s(`"So far, ASTRÉE has proved the absence of runtime errors in the primary control software of the `)}
        <LINK href="https://www.airbus.com/aircraft/previous-generation-aircraft/a340-family.html">
          {s(`Airbus A340 family`)}
        </LINK>
        {s(`. This would be impossible by `)}
        <em> {s(`software testing`)} </em>
        {s(`, for testing only considers a limited `)}
        <em> {s(`subset`)} </em>
        {s(` of the test cases, while abstract interpretation considers a `)}
        <em> {s(`superset`)} </em>
        {s(` of all possible outcomes of the system."`)}
      </p>
      <p>
        {s(`"ASTRÉE is written in OCaml and is about 44000 lines long (plus external libraries). We needed a language with good 
          performance (speed and memory usage) on reasonable equipment, easy support for advanced data structures, and type 
          memory safety. OCaml also allows for modular, clear and compact source code and makes it easy to work with 
          recursive structures such as syntax trees."`)}
      </p>
      <h2 id="slam"> {s(`SLAM`)} </h2>
      <p>
        <LINK href="http://research.microsoft.com/en-us/projects/slam/">
          {s(`The SLAM project's`)}
        </LINK>
        {s(` goal was to automatically check that a C program correctly uses the interface to an external library. It 
          originated in Microsoft Research in early 2000. The project used and extended ideas from symbolic model checking, 
          program analysis and theorem proving in novel ways to address this problem. The SLAM analysis engine forms the 
          core of a new tool called Static Driver Verifier (SDV) that systematically analyzes the source code of Windows 
          device drivers against a set of rules that define what it means for a device driver to properly interact with 
          the Windows operating system kernel.`)}
      </p>
      <p>
        <em>
          {s(`In a `)}
          <LINK href="http://research.microsoft.com/apps/pubs/default.aspx?id=70038">
            {s(`technical report about the SLAM project`)}
          </LINK>
          {s(`, T.Ball, B.Cook, V.Levin and S.K.Rajamani, the SLAM developers, write:`)}
        </em>
        {s(` "The Right Tools for the Job: We developed SLAM using Inria's OCaml functional programming language. The 
          expressiveness of this language and robustness of its implementation provided a great productivity boost."`)}
      </p>
      <h2 id="fftw"> {s(`FFTW`)} </h2>
      <p>
        <LINK href="http://www.fftw.org/">
          {s(`FFTW is a C library for computing Discrete Fourier Transforms`)}
        </LINK>
        {s(` (DFT). It uses a powerful symbolic optimizer written in 
          OCaml which, given an integer N, generates highly optimized C code to compute DFTs of size N. `)}
        <LINK href="https://en.wikipedia.org/wiki/J._H._Wilkinson_Prize_for_Numerical_Software">
          {s(`FFTW was awarded the 1999 Wilkinson prize for numerical software`)}
        </LINK>
        {s(`.`)}
      </p>
      <p>
        <LINK href="http://www.fftw.org/benchfft/">
          {s(`Benchmarks, performed on on a variety of platforms, show that FFTW's performance is typically superior`)}
        </LINK>
        {s(` to that of other publicly available DFT software, and is even competitive with vendor-tuned codes. 
          In contrast to vendor-tuned codes, however, FFTW's performance is portable: the same program will perform 
          well on most architectures without modification. Hence the name, "FFTW," which stands for the somewhat 
          whimsical title of "Fastest Fourier Transform in the West."`)}
      </p>
      <h2 id="liquidsoap"> {s(`Liquidsoap`)} </h2>
      <p>
        <LINK href="http://liquidsoap.fm/">
          {s(`Liquidsoap is clearly well established in the (internet) radio industry`)}
        </LINK>
        {s(`. Liquidsoap is well known as a tool with unique 
          abilities, and has lots of users including big commercial ones. It is not developed as a business, but companies 
          develop services or software on top of it. For example, Sourcefabric develops and sells Airtime on top of Liquidsoap.`)}
      </p>
      <h2> {s(`Haxe`)} </h2>
      <p>
        <LINK href="http://haxe.org/"> {s(`Haxe is an open source toolkit`)} </LINK>
        {s(` based on a modern, high level, strictly typed programming language, a cross-compiler, 
          a complete cross-platform standard library and ways to access each platform's native capabilities. The Haxe compiler 
          was entirely written in OCaml.`)}
      </p>
    </div>
  </div>
</>
