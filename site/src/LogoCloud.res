open! Import

module CompanyOptionalLogo = {
  type t = {
    logoSrc: option<string>,
    name: string,
    website: string,
  }
}

module Company = {
  type t = {
    logoSrc: string,
    name: string,
    website: string,
  }
}

type t = [
  | #LogoOnly(array<Company.t>)
  | #LogoWithText(array<CompanyOptionalLogo.t>)
]

module CompanyCard = {
  type t = [
    | #Optional(CompanyOptionalLogo.t)
    | #Required(Company.t)
  ]

  let logo = (~src, ~name) => <img className="w-24 my-9 rounded max-h-20" src alt=name />

  let logoFiller = <span className="h-20 my-9 pl-4" />

  @react.component
  let make = (~company: t) => {
    let (website, name) = switch company {
    | #Optional(c) => (c.website, c.name)
    | #Required(c) => (c.website, c.name)
    }
    // TODO: accessibility - should the link include the div or only the contents?
    // TODO: accessibility - warn opening a new tab
    <a href=website target="_blank" className="py-1 px-1">
      <div
        className="col-span-1 flex justify-center items-center space-x-8 py-8 px-4 bg-gray-50 h-40">
        {switch company {
        | #Optional({logoSrc: Some(logoSrc)}) => logo(~src=logoSrc, ~name)
        | #Optional(_) => logoFiller
        | #Required({logoSrc}) => logo(~src=logoSrc, ~name)
        }}
        {switch company {
        | #Optional(_) =>
          <span className="text-center text-lg font-bold font-roboto my-9 ">
            {React.string(name)}
          </span>
        | #Required(_) => <> </>
        }}
      </div>
    </a>
  }
}

@react.component
let make = (~companies) =>
  <div className="max-w-4xl mx-auto py-12 px-4 sm:px-6 lg:py-16 lg:px-8">
    <div className="mt-6 grid grid-cols-1 gap-0.5 md:grid-cols-3 lg:mt-8">
      {switch companies {
      | #LogoOnly(companies) =>
        companies->Js.Array2.map((c: Company.t) =>
          <CompanyCard key=c.name company={#Required(c)} />
        )
      | #LogoWithText(companies) =>
        companies->Js.Array2.map((c: CompanyOptionalLogo.t) =>
          <CompanyCard key=c.name company={#Optional(c)} />
        )
      }->React.array}
    </div>
  </div>
