open! Import

type item = {
  title: string,
  description: string,
  url: string,
}

@react.component
let make = (~title, ~buttonText, ~buttonRoute, ~lang, ~children) => {
  let (item1, item2, item3) = children
  let renderItem = (i, item) => {
    <div>
      <p className="text-orangedark text-7xl font-bold"> {React.string(`${string_of_int(i)}.`)} </p>
      // TODO: visual indicator that link will open new tab
      <p className="font-bold">
        <a href=item.url target="_blank"> {React.string(item.title)} </a>
      </p>
      <p> {React.string(item.description)} </p>
    </div>
  }

  <div className="bg-white overflow-hidden shadow rounded-lg py-3 mx-auto max-w-5xl">
    <div className="px-4 py-5 sm:p-6">
      <h2 className="text-center text-orangedark text-7xl font-bold mb-8">
        {React.string(title)}
      </h2>
      <div className="grid grid-cols-3 mb-14 px-9 space-x-6 px-14">
        {React.array(
          [item1, item2, item3]->Belt.Array.mapWithIndex((i, item) => renderItem(i + 1, item)),
        )}
      </div>
      <div className="flex justify-center">
        <Route _to={buttonRoute} lang>
          <a
            className="font-bold inline-flex items-center px-10 py-3 border border-transparent text-base leading-4 font-medium rounded-md shadow-sm text-white bg-orangedark hover:bg-orangedarker">
            {React.string(buttonText)}
          </a>
        </Route>
      </div>
    </div>
  </div>
}
