open! Import

@react.component
let make = (~cardData, ~renderCard, ~title=?) => <>
  {switch title {
  | Some(title) =>
    <h2
      className="font-roboto text-center text-4xl tracking-tight font-extrabold text-gray-900 sm:text-5xl py-6 px-4 sm:py-12 sm:px-6 lg:px-8">
      {React.string(title)}
    </h2>
  | None => <> </>
  }}
  <div className="grid grid-cols-1 lg:grid-cols-2 gap-x-28 gap-y-4 px-8">
    {cardData->Belt.Array.mapWithIndex(renderCard)->React.array}
  </div>
</>
