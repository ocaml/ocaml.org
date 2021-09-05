open! Import

module Simple = {
  type t = {
    headers: array<string>,
    data: array<array<React.element>>,
  }

  @react.component
  let make = (~content) =>
    <div className="flex flex-col">
      <div className="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
        <div className="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
          <div className="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-orangedark">
                <tr>
                  {content.headers
                  |> Array.map(header =>
                    <th
                      key={header}
                      scope="col"
                      className="px-6 py-3 text-left text-xs font-medium text-white uppercase tracking-wider">
                      {React.string(header)}
                    </th>
                  )
                  |> React.array}
                </tr>
              </thead>
              <tbody>
                {content.data
                |> Array.mapi((idx, item) => {
                  <tr
                    key={string_of_int(idx)}
                    className={mod(idx, 2) === 0 ? "bg-white" : "bg-gray-50"}>
                    {item
                    |> Array.mapi((jdx, cell) =>
                      <td
                        key={string_of_int(jdx)}
                        className="px-6 py-4 text-sm font-medium text-gray-900">
                        cell
                      </td>
                    )
                    |> React.array}
                  </tr>
                })
                |> React.array}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
}

module Regular = {
  type columnSpec<'map> = {
    title: string,
    component: 'map => React.element,
    className: string,
  }

  @react.component
  let make = (~rows: array<'map>, ~children as columns: array<columnSpec<'map>>) => {
    <div className="container py-6 px-4 max-w-7xl mx-auto">
      <div className="overflow-x-auto bg-white rounded-lg shadow overflow-y-auto relative">
        <table
          className="border-collapse table-auto w-full whitespace-no-wrap bg-white table-striped relative">
          <thead>
            {
              let len = Belt.Array.length(columns)
              React.array(
                columns->Belt.Array.mapWithIndexU((. i, column) => {
                  let rounding = {
                    [
                      if i == 0 {
                        "rounded-tl"
                      } else {
                        ""
                      },
                      if i == len - 1 {
                        "rounded-tr"
                      } else {
                        ""
                      },
                    ]->Js.String.concatMany(" ")
                  }
                  <th
                    className={`py-2 px-3 ${rounding} sticky top-0 border-b border-gray-200 bg-yellow-300`}>
                    {React.string(column.title)}
                  </th>
                }),
              )
            }
          </thead>
          <tbody>
            {React.array(
              rows->Belt.Array.mapWithIndex((i, map) =>
                <tr
                  key={"r" ++ string_of_int(i)}
                  className="border-double border-t-4 border-gray-200 hover:bg-yellow-50">
                  {React.array(
                    columns->Belt.Array.map(({title, component, className}) =>
                      <td className> {React.createElement(component, map)} </td>
                    ),
                  )}
                </tr>
              ),
            )}
          </tbody>
        </table>
      </div>
    </div>
  }
}
