module Company = {
  type t = {
    logoSrc: string,
    name: string,
  }
}

@react.component
let make = (~companies: array<Company.t>) =>
  <div className="max-w-7xl mx-auto py-12 px-4 sm:px-6 lg:py-16 lg:px-8">
    <div className="mt-6 grid grid-cols-2 gap-0.5 md:grid-cols-3 lg:mt-8">
      {companies
      ->Js.Array2.map(c =>
        <div className="col-span-1 flex justify-center py-8 px-8 bg-gray-50">
          <img className="max-h-12" src=c.logoSrc alt=c.name />
        </div>
      )
      ->React.array}
    </div>
  </div>
