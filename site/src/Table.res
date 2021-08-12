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
