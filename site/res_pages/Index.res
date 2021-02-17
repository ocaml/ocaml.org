let s = React.string

let contentEn = {
  "heroHeader": `Welcome to a World of OCaml`,
  "heroBody": `OCaml is a general purpose industrial-strength programming language with an emphasis on expressiveness and 
    safety.`,
  "installOcaml": `Install OCaml`,
  "aboutOcaml": `About OCaml`,
  "statsTitle": `OCaml in Numbers`,
  "activeMembers": `Active Members`, 
  "industrySatisfaction": `Industry Satisfaction`,
  "averagePRsPerWeek": `Average PRs per Week`,
  "activeMembersValue": `2000+`,
  "industrySatisfactionPercent": `97%`,
  "averagePRsPerWeekValue": `450`,
  "opamHeader": `Opam: the OCaml Package Manager`,
  "opamBody": `Opam is a source-based package manager for OCaml. It supports multiple simultaneous compiler 
    installations, flexible package constraints, and a Git-friendly development workflow.`,
  "opamLinkText": `Go to opam.ocaml.org`,
  "quote": `OCaml helps us to quickly adopt to changing market conditions, and go from prototypes to production 
    systems with less effort ... Billions of dollars of transactions flow through our systems every day, so getting 
    it right matters.`,
  "organizationName": `Jane Street`,
  "speaker": `Yaron Minsky`,
  "organizationLogo": `/static/js.svg`
}

@react.component
let make = (~content=contentEn) =>
  <>
  <div className="lg:relative">
    <div className="mx-auto max-w-7xl w-full pt-16 pb-20 text-center lg:py-48 lg:text-left">
      <div className="px-4 lg:w-1/2 sm:px-8 xl:pr-16">
        <h1 className="text-4xl tracking-tight font-extrabold text-gray-900 sm:text-5xl md:text-6xl lg:text-5xl xl:text-6xl">{s(content["heroHeader"])}</h1>
        <p className="mt-3 max-w-md mx-auto text-lg text-gray-500 sm:text-xl md:mt-5 md:max-w-3xl">{s(content["heroBody"])}</p>
        <div className="mt-10 sm:flex sm:justify-center lg:justify-start">
          <div className="rounded-md shadow">
            <a href="#" className="w-full flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-white bg-orangedark hover:bg-orangedarker md:py-4 md:text-lg md:px-10"> {s(content["installOcaml"])} </a>
          </div>
          <div className="mt-3 rounded-md shadow sm:mt-0 sm:ml-3">
            <a href="#" className="w-full flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-orangedark bg-white hover:bg-gray-50 md:py-4 md:text-lg md:px-10"> {s(content["aboutOcaml"])} </a>
          </div>
        </div>
      </div>
    </div>
    <div className="relative w-full h-64 sm:h-72 md:h-96 lg:absolute lg:inset-y-0 lg:right-0 lg:w-1/2 lg:h-full">
      <img className="absolute inset-0 w-full h-full object-cover" src="/static/oc-sq.jpeg" alt="" />
    </div>
  </div>
  
  <div className="pt-12 sm:pt-16">
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div className="max-w-4xl mx-auto text-center">
        <h2 className="text-3xl font-extrabold text-gray-900 sm:text-4xl">{s(content["statsTitle"])}</h2>
      </div>
    </div>
    <div className="mt-10 pb-12 sm:pb-16">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="max-w-4xl mx-auto">
          <dl className="rounded-lg bg-white shadow-lg sm:grid sm:grid-cols-3">
            <div className="flex flex-col border-b border-gray-100 py-16 text-center sm:border-0 sm:border-r">
              <dt className="order-2 mt-2 text-lg leading-6 font-bold text-black text-opacity-70">{s(content["activeMembers"])}</dt>
              <dd className="order-1 text-5xl font-extrabold text-orangedark">{s(content["activeMembersValue"])}</dd>
            </div>
            <div className="flex flex-col border-t border-b border-gray-100 py-16 text-center sm:border-0 sm:border-l sm:border-r">
              <dt className="order-2 mt-2 text-lg leading-6 font-bold text-black text-opacity-70">{s(content["industrySatisfaction"])}</dt>
              <dd className="order-1 text-5xl font-extrabold text-orangedark">{s(content["industrySatisfactionPercent"])}</dd>
            </div>
            <div className="flex flex-col border-t border-gray-100 py-16 text-center sm:border-0 sm:border-l">
              <dt className="order-2 mt-2 text-lg leading-6 font-bold text-black text-opacity-70">{s(content["averagePRsPerWeek"])}</dt>
              <dd className="order-1 text-5xl font-extrabold text-orangedark">{s(content["averagePRsPerWeekValue"])}</dd>
            </div>
          </dl>
        </div>
      </div>
    </div>
  </div>

  <div className="pt-12 sm:pt-16 pb-14 sm:flex sm:max-w-5xl sm:mx-auto px-4 sm:px-6 lg:px-8">
    <div className="mb-4 flex-shrink-0 sm:mb-0 sm:mr-4">
      <img className="h-36" src="/static/opam.png" ariaHidden=true />
    </div>
    <div>
      <h4 className="text-2xl font-bold">{s(content["opamHeader"])}</h4>
      <p className="mt-1">{s(content["opamBody"])}</p>
      <p className="text-right pr-5"><a className=" text-yellow-600" href="https://opam.ocaml.org" target="_blank">{s(content["opamLinkText"] ++ ` >`)}</a></p>
    </div>
  </div>


  <section className="pt-5 pb-20 overflow-hidden md:pt-6 mb:pb-24 lg:pt-10 lg:pb-40">
    <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <svg className="absolute top-full right-full transform translate-x-1/3 -translate-y-1/4 lg:translate-x-1/2 xl:-translate-y-1/2" width="404" height="404" fill="none" viewBox="0 0 404 404" role="img" ariaLabelledby="svg-testimonial-org">
        <title id="svg-testimonial-org">{s(content["organizationName"])}</title>
        <defs>
          <pattern id="ad119f34-7694-4c31-947f-5c9d249b21f3" x="0" y="0" width="20" height="20" patternUnits="userSpaceOnUse">
            <rect x="0" y="0" width="4" height="4" className="text-gray-200" fill="currentColor" />
          </pattern>
        </defs>
        <rect width="404" height="404" fill="url(#ad119f34-7694-4c31-947f-5c9d249b21f3)" />
      </svg>

      <div className="relative">
        <img className="mx-auto h-24" src=content["organizationLogo"] alt=content["organizationName"] />
        <blockquote className="mt-10">
          <div className="max-w-3xl mx-auto text-center text-2xl leading-9 font-medium text-gray-900">
            <p><span className="text-orangedark">{s(`”`)}</span>{s(content["quote"])}<span className="text-orangedark">{s(`”`)}</span></p>
          </div>
          <footer className="mt-0">
            <div className="md:flex md:items-center md:justify-center">
              <div className="mt-3 text-center md:mt-0 md:ml-4 md:flex md:items-center">
                <div className="text-base font-medium text-gray-900">{s(content["speaker"])}</div>

                <svg className="hidden md:block mx-1 h-5 w-5 text-orangedark" fill="currentColor" viewBox="0 0 20 20">
                  <path d="M11 0h3L9 20H6l5-20z" />
                </svg>

                <div className="text-base font-medium text-gray-500">{s(content["organizationName"])}</div>
              </div>
            </div>
          </footer>
        </blockquote>
      </div>
    </div>
  </section>
  </>

let default = make
