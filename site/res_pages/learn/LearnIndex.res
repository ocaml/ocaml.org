module LINK = Markdown.LINK
module H1 = Markdown.H1
module P = Markdown.P
module UL = Markdown.UL

let s = React.string

module IMG = {
  @react.component
  let make = (~src) => <img src className="float-left mr-2 mb-1" />
}

module Button = {
  @react.component
  let make = (~children, ~href) =>
    <LINK href>
      <a
        className="whitespace-no-wrap text-center text-white font-bold inline-block px-5 py-3 bg-green-800 rounded">
        children
      </a>
    </LINK>
}

module CodeBlock = {
  @react.component
  let make = (~children) =>
    <div className="border border-gray-400 bg-gray-100 mb-3 text-xs p-3 rounded">
      <pre> children </pre>
    </div>
}

module CardHeader = {
  @react.component
  let make = (~children) =>
    <div className="border-b border-gray-500 mb-3">
      <h2 className="text-2xl font-semibold"> children </h2>
    </div>
}

module CardFooter = {
  @react.component
  let make = (~children) => <p className="text-sm"> children </p>
}

let default = () => <>
  <H1> {s(`Learn`)} </H1>
  <div className="flex justify-between space-x-4 mb-4">
    <div className="flex-0 self-start"> <img src="/static/learn-large.svg" /> </div>
    <div className="w-3/5">
      <strong> {s(`What is OCaml?`)} </strong>
      {s(` Ocaml is a general purpose
            industrial-strength programming language with an emphasis on
            expressiveness and safety. It is the technology of choice in `)}
      <LINK href="/learn/companies"> {s(`companies`)} </LINK>
      {s(` where a single mistake can cost millions and speed matters,
            and there is an `)}
      <LINK href="/community"> {s(`active community`)} </LINK>
      {s(` that has developed a `)}
      <LINK href="https://opam.ocaml.org/packages/"> {s(`rich set of libraries`)} </LINK>
      {s(`. It's also a widely used `)}
      <LINK href="/learn/teaching-ocaml"> {s(`teaching language`)} </LINK>
      {s(`. `)}
      <em className="text-xs">
        <LINK href="/learn/description"> {s(`Read more`)} </LINK> {s(`.`)}
      </em>
    </div>
    <div className="flex-1 flex justify-center pt-5">
      <Button href="/docs/install"> {s(`Install OCaml`)} </Button>
    </div>
  </div>
  <div className="flex space-x-8 mb-5">
    <div className="flex-1">
      <CardHeader> <LINK href="/learn/taste"> {s(`Code Examples`)} </LINK> </CardHeader>
      <CodeBlock>
        <em>
          {s(`(* If [1] is the list [e1;...;eN] *)`)} <br /> {s(`(* e1 +. ... +. eN *)`)} <br />
        </em>
        <span className="text-green-700"> {s(`List`)} </span>
        {s(`.fold_left ( +. ) 0. l`)}
        <br />
        <br />
        {s(`(* e1 +. ... +. eN *)`)}
        <br />
        <span className="text-green-700"> {s(`List`)} </span>
        {s(`.fold_left ( +. ) 1. l`)}
        <br />
        <br />
        {s(`(* e1 && ... && eN *)`)}
        <br />
        <span className="text-green-700"> {s(`List`)} </span>
        {s(`.fold_left ( && ) true l`)}
        <br />
        <br />
        {s(`(* Reverse: [eN;...;e1] *)`)}
        <br />
        <span className="text-green-700"> {s(`List`)} </span>
        {s(`.fold_left`)}
        <br />
        {s(`  (`)}
        <span className="text-blue-800"> {s(`fun`)} </span>
        {s(` r e -> e :: r) [] l`)}
        <br />
      </CodeBlock>
      <CardFooter>
        {s(`See more `)}
        <LINK href="/learn/taste"> {s(`Code Examples`)} </LINK>
        {s(`, `)}
        <LINK href="http://pleac.sourceforge.net/pleac_ocaml/"> {s(`Pleac`)} </LINK>
        {s(`, and `)}
        <LINK href="http://rosettacode.org/wiki/Category:OCaml"> {s(`Rosetta`)} </LINK>
        {s(`.`)}
      </CardFooter>
    </div>
    <div className="flex-1">
      <CardHeader>
        <LINK href="/learn/tutorials"> {s(`Tutorials`)} </LINK>
        {s(` & `)}
        <LINK href="/learn/faq"> {s(`FAQ`)} </LINK>
      </CardHeader>
      <UL>
        <li> <LINK href="/learn/tutorials/up_and_running"> {s("Up and Running")} </LINK> </li>
        <li> <LINK href="/learn/tutorials/basic"> {s("Basics")} </LINK> </li>
        <li>
          <LINK href="/learn/tutorials/structure_of_ocaml_programs">
            {s("Structure of OCaml Programs")}
          </LINK>
        </li>
        <li> <LINK href="/learn/tutorials/modules"> {s("Modules")} </LINK> </li>
        <li> <LINK href="/learn/tutorials/map"> {s("Maps (Dictionaries)")} </LINK> </li>
        <li> <LINK href="/learn/tutorials/sets"> {s("Sets")} </LINK> </li>
        <li> <LINK href="/learn/tutorials/hashtbl"> {s("Hash Tables")} </LINK> </li>
        <li>
          <LINK href="/learn/tutorials/comparison_of_standard_containers">
            {s("Comparison of Standard Containers")}
          </LINK>
        </li>
        <li> <LINK href="/learn/faq"> {s("Frequently Asked Questions")} </LINK> </li>
      </UL>
      <CardFooter> <LINK href="/learn/tutorials"> {s("See full list")} </LINK> </CardFooter>
    </div>
    <div className="flex-1">
      <CardHeader> <LINK href="/learn/books"> {s(`Books`)} </LINK> </CardHeader>
      <LINK href="https://realworldocaml.org/">
        <img src="/static/real-world-ocaml.jpeg" className="float-left w-5/12 mr-3" />
      </LINK>
      <LINK href="http://ocaml-book.com/">
        <img src="/static/OCaml_from_beginning.png" className="float-left w-5/12 mb-4" />
      </LINK>
      <span className="clearfix" />
      <P>
        {s(`There are a number of excellent books, with two new 
            titles published in recent years.`)}
      </P>
      <CardFooter> <LINK href="/learn/books"> {s("See full list")} </LINK> </CardFooter>
    </div>
  </div>
  <div className="flex space-x-8 mb-5">
    <div className="flex-1">
      <CardHeader>
        <LINK href="/community/media"> {s(`Online Courses, Slides & Videos`)} </LINK>
      </CardHeader>
      <iframe
        title="A massive open online course on OCaml"
        src="https://www.dailymotion.com/embed/video/x2ymo3x"
        className="max-w-full mb-2"
        allowFullScreen=true
        width="380"
        height="220"
      />
      <P>
        <LINK
          href="https://www.dailymotion.com/video/x2ymo3x_fun-mooc-introduction-to-functional-programming-in-ocaml_school">
          {s(`A massive open online course (MOOC) entirely centered around OCaml`)}
        </LINK>
        <em> {s(` is now available, and runs once a year!`)} </em>
        <br />
        {s(`Learn more, and `)}
        <LINK href="https://www.fun-mooc.fr/courses/course-v1:parisdiderot+56002+session03/about">
          {s(`register now on the FUN platform!`)}
        </LINK>
      </P>
      <iframe
        title="Xavier Leroy presents the state of OCaml 4.02"
        src="https://www.slideshare.net/slideshow/embed_code/43836300"
        allowFullScreen=true
        width="340"
        height="290"
        className="max-w-full mb-3 border border-gray-300"
      />
      <P>
        {s(`An invited talk by Xavier Leroy explaining the current state of OCaml at the `)}
        <LINK href="/meetings/ocaml/2014"> {s(`OCaml Users and Developers WOrkshop 2014`)} </LINK>
        {s(` in Gothenburg, Sweden (`)}
        <LINK href="/meetings/ocaml/2014/OCaml2014-Leroy-slides.pdf"> {s(`PDF slides`)} </LINK>
        {s(`, `)}
        <LINK href="https://www.youtube.com/watch?v=DMzZy1bqj6Q&list=UUP9g4dLR7xt6KzCYntNqYcw">
          {s(`Video`)}
        </LINK>
        {s(`).`)}
      </P>
      <iframe
        title="Yaron Minsky explains how to program effectively in ML"
        src="https://player.vimeo.com/video/14313378"
        allowFullScreen=true
        height="170"
        className="max-w-full max-h-full mb-2"
      />
      <P>
        {s(`A guest lecture given by Yaron Minsky of Jane Street about how to program 
                effectively in ML. The talk was given as part of the intro computer science class 
                at Harvard, CS51, where the students had spent much of the semester programming in 
                OCaml.`)}
      </P>
      <CardFooter>
        <LINK href="/community/media"> {s(`See more slides and videos`)} </LINK>
      </CardFooter>
    </div>
    <div className="flex-1">
      <CardHeader> <LINK href="/learn/companies"> {s(`Industrial Users`)} </LINK> </CardHeader>
      <LINK href="https://janestreet.com"> <IMG src="/static/jane-street.jpeg" /> </LINK>
      <P>
        {s(`Jane Street is a quantitative proprietary trading firm with 
            a unique focus on technology and collaborative problem solvinig. Almost all of 
            our systems are written in OCaml: from statistical research code operating 
            over terabytes of data to systems management tools to our real-time trading 
            infrastructure. And those systems are deployed at real scale: on an average day, 
            our trading represents between 1% and 2% of US equity volume.`)}
      </P>
      <IMG src="/static/facebook.png" />
      <P>
        {s(`To handle their huge PHP codebase, Facebook developed `)}
        <LINK href="https://github.com/facebook/pfff/wiki/Main"> {s(`pfff`)} </LINK>
        {s(`, a set of tools and APIs to perform static analysis, dynamic analysis, code 
            visualizations, code navigations, and style-preserving source-to-source transformations 
            such as refactorings on source code. They also designed `)}
        <em> {s(`Hack`)} </em>
        {s(`, a new statically typed programming language for HHVM, a fast PHP runtime. 
            See Julien Verlaguet's `)}
        <LINK href="http://www.youtube.com/watch?v=gKWNjFagR9k"> {s(`CUFP talk`)} </LINK>
        {s(` and `)}
        <LINK href="http://cufp.org/2013/slides/verlaguet.pdf"> {s(`slides`)} </LINK>
        {s(`.`)}
      </P>
      <CardFooter>
        <LINK href="/learn/companies"> {s(`See more companies using OCaml`)} </LINK>
      </CardFooter>
    </div>
    <div className="flex-1">
      <CardHeader> <LINK href="/learn/success"> {s(`Success Stories`)} </LINK> </CardHeader>
      <LINK href="https://ocaml.org/img/unison.png"> <IMG src="/static/unison-thumb.jpeg" /> </LINK>
      <P>
        <LINK href="http://www.cis.upenn.edu/%7Ebcpierce/unison/"> {s(`Unison`)} </LINK>
        {s(` is an innovative `)}
        <em> {s(`two-way`)} </em>
        {s(` file synchronizer stemming from the `)}
        <LINK href="http://www.cis.upenn.edu/~bcpierce/papers/index.shtml#Synchronization">
          {s(`latest research`)}
        </LINK>
        {s(`. It is resilient to failures and runs on Windows as well as 
                most flavors of Unix, including MacOSX. OCaml helped the authors to
                "organize a large and intricate codebase".`)}
      </P>
      <LINK href="https://ocaml.org/img/lexifi.jpg"> <IMG src="/static/lexifi-thumb.jpeg" /> </LINK>
      <P>
        {s(`Developed by `)}
        <LINK href="http://www.lexifi.com/"> {s(`LexiFi`)} </LINK>
        {s(` the Modeling Language for Finance (MLFi) is the first formal language that 
                accurately describes the most sophisticated capital market, credit, and investment 
                products. MLFii is implemented as an extension of OCaml.`)}
      </P>
      <IMG src="/static/fftw-thumb.png" />
      <P>
        <LINK href="http://www.fftw.org/"> {s(`FFTW`)} </LINK>
        {s(` is a very Fast Fourier Transform library developed at MIT that competes with 
                vendor-tuned codes while remaining platform independent. The code is generated by `)}
        <span className="font-mono border border-gray-400 bg-gray-100 rounded px-1 pt-1">
          {s(`genfft`)}
        </span>
        {s(`, written in OCaml, that `)}
        <LINK href="http://www.fftw.org/pldi99.ps.gz">
          {s(`"discovered" algorithms that were previously unknown`)}
        </LINK>
        {s(`. It was awarded the `)}
        <LINK href="https://en.wikipedia.org/wiki/J._H._Wilkinson_Prize_for_Numerical_Software">
          {s(`J. H. Wilkinson Prize for Numerical Software`)}
        </LINK>
        {s(` that rewards software that 
                "best addresses all phases of the preparation of high quality numerical software."`)}
      </P>
      <CardFooter>
        <LINK href="/learn/success"> {s(`See more success stories`)} </LINK>
      </CardFooter>
    </div>
  </div>
</>
