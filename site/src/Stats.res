open! Import

module RowContainer = {
  @react.component
  let make = (~textAlign, ~children) =>
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div className={"max-w-4xl mx-auto " ++ textAlign}> children </div>
    </div>
}

module Box = {
  @react.component
  let make = (~label, ~statValue, ~borderSizes) =>
    <div className={`flex flex-col border-gray-100 py-16 px-4 text-center ` ++ borderSizes}>
      <dt className="order-2 mt-2 text-lg leading-6 font-bold text-black text-opacity-70">
        {React.string(label)}
      </dt>
      <dd className="order-1 text-5xl font-extrabold text-orangedark">
        {React.string(statValue)}
      </dd>
    </div>
}

module Item = {
  type t = {
    label: string,
    value: string,
  }
}

module H2 = {
  @react.component
  let make = (~text) =>
    <h2 className="text-3xl font-extrabold text-gray-900 sm:text-4xl"> {React.string(text)} </h2>
}

@react.component
let make = (~title: string, ~children as items: array<Item.t>) =>
  <div className="pt-12 sm:pt-16">
    <RowContainer textAlign=`text-center`> <H2 text=title /> </RowContainer>
    <div className="mt-10 pb-12 sm:pb-16">
      <RowContainer textAlign=``>
        <dl className="rounded-lg bg-white shadow-lg sm:grid sm:grid-cols-3">
          {
            let len = Belt.Array.length(items)
            React.array(
              items->Belt.Array.mapWithIndex((i, item) => {
                let borderSizes = [
                  "sm:border-0",
                  if i != len - 1 {
                    "border-b sm:border-r"
                  } else {
                    ""
                  },
                  if i != 0 {
                    "border-t sm:border-l"
                  } else {
                    ""
                  },
                ]->Js.String.concatMany(" ")
                <Box label=item.label statValue=item.value borderSizes />
              }),
            )
          }
        </dl>
      </RowContainer>
    </div>
  </div>
