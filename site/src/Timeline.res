open! Import

module Item = {
  module VerticalBar = {
    @react.component
    let make = (~bgColor: string) =>
      // TODO: receive ml as an argument
      <span className={`absolute top-5 left-5 ml-0.5 h-full w-0.5 ${bgColor}`} ariaHidden=true />
  }

  module Circle = {
    @react.component
    let make = (~bgColor: string) => <div className={`h-11 w-11 ${bgColor} rounded-full flex`} />
  }

  module Date = {
    @react.component
    let make = (~content: string) =>
      // TODO: receive mb as an argument
      <div className="text-3xl font-bold text-gray-900 mb-4"> {React.string(content)} </div>
  }

  module Description = {
    @react.component
    let make = (~content: string) =>
      // TODO: receive mt as an argument
      <div className="mt-2 text-base text-gray-700"> <p> {React.string(content)} </p> </div>
  }

  type t = {date: string, description: string}

  @react.component
  let make = (~item) => {
    let bgColor = "bg-yellowdark"

    <li>
      <div className="relative pb-8">
        <VerticalBar bgColor />
        <div className="relative flex items-start space-x-3">
          <Circle bgColor />
          <div className="min-w-0 flex-1">
            <Date content=item.date /> <Description content=item.description />
          </div>
        </div>
      </div>
    </li>
  }
}

type t = array<Item.t>

@react.component
let make = (~content: t) => {
  <SectionContainer.LargeCentered paddingY="py-12" paddingX="px-4">
    <div className="flow-root">
      <ul className="-mb-8">
        {content
        |> Js.Array.mapi((item, idx) => <Item item key={Js.Int.toString(idx)} />)
        |> React.array}
      </ul>
    </div>
  </SectionContainer.LargeCentered>
}
