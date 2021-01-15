module LINK = Markdown.LINK

let s = React.string

let pageHeader = `Industrial Users of OCaml`
let pageOverview =
  s(`Ocaml is a popular choice for companies who make use of its features in key
     aspects of their technologies. Some companies that use OCaml code are listed below:`)
let facebookHeader = `Facebook, United States`
let facebookBody = 
  s(`Facebook has built a number of major development tools using OCaml. Hack 
  is a compiler for a variant of PHP that aims to reconcile the fast development 
  cycle of PHP with the discipline provided by static typing. Flow is a similar project 
  that provides static type checking for Javascript. Both systems are highly responsive, 
  parallel programs that can incorporate source code changes in real time. Pfff is a set 
  of tools for code analysis, visualizations, and style-preserving source transformations, 
  written in OCaml, but supporting many languages.`)
let dockerHeader = `Docker, United States`
let dockerBody = 
  s(`Docker provides an integrated technology suite that enables development and IT operations 
  teams to build, ship, and run distributed applications anywhere. Their native applications 
  for Mac and Windows, use OCaml code taken from the MirageOS library operating system project.`)
let taridesHeader = `Tarides, France`
let taridesBody =
  s(`We are building and maintaining open-source infrastructure tools in OCaml: (1) MirageOS, 
  the most advanced unikernel project, where we build sandboxes, network and storage protocol 
  implementations as libraries, so we can link them to our applications to run them without the 
  need of an underlying operating system; (2) Irmin, a Git-like datastore, which allows us to 
  create fully auditable distributed systems which can work offline and be synced when needed; 
  and (3) OCaml development tools (build system, code linters, documentation generators, etc), to 
  make us more efficient. Tarides was founded in early 2018 and is mainly based in Paris, France 
  (remote work is possible).`)
let solvuuHeader = `Solvuu, United States`
let solvuuBody =
  s(`Solvuu's software allows users to store big and small data sets, share the data with 
  collaborators, execute computationally intensive algorithms and workflows, and visualize 
  results. Its initial focus is on genomics data, which has important implications for healthcare, 
  agriculture, and fundamental research. Virtually all of Solvuu's software stack is 
  implemented in OCaml.`)

let default = () =>
  <>
  <article>
    <h1>{s(pageHeader)}</h1>
      <p>{pageOverview}</p>
      <ul>
        <li>
          <img alt="" />
          <h2><LINK href="https://facebook.com">{s(facebookHeader)}</LINK></h2>
          <p>{facebookBody}</p>
        </li>
        <li>          
          <img alt="" />
          <h2><LINK href="https://docker.com">{s(dockerHeader)}</LINK></h2>
          <p>{dockerBody}</p>
        </li>
        <li>
          <img alt="" />
          <h2><LINK href="https://tarides.com">{s(taridesHeader)}</LINK></h2>
          <p>{taridesBody}</p>
        </li>
        <li>
          <img alt="" />
          <h2><LINK href="https://solvuu.com">{s(solvuuHeader)}</LINK></h2>
          <p>{solvuuBody}</p>
        </li>
      </ul>
  </article>
  </>
