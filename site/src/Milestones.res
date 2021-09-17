open! Import

let percent_complete = "60%"

module Progress = {
  @react.component
  let make = () =>
    <div className="flex flex-col md:flex-row items-center text-center text-white">
      <div className="w-full md:w-3/12 font-bold text-2xl"> {React.string("OCaml.org v3")} </div>
      <div className="w-full md:w-8/12">
        <div className="h-4 relative rounded-full overflow-hidden ring-8 ring-white m-8">
          <div className="w-full h-full bg-white absolute" />
          <div
            className="h-full rounded-full bg-yellowdark absolute"
            style={ReactDOM.Style.make(~width=percent_complete, ())}
          />
        </div>
      </div>
      <div className="w-full md:w-1/12 font-bold text-2xl"> {React.string(percent_complete)} </div>
    </div>
}

module Table = {
  module Item = {
    type t = {
      version: option<string>,
      description: string,
      period: string,
      completion: string,
      results: string,
    }
  }

  let headers = ["version", "description", "period", "completion", "results"]

  @react.component
  let make = (~items: array<Item.t>) => {
    let header = <thead className="bg-gray-50"> <tr> {Js.Array.mapi((x, idx) => {
            <th
              key={Js.Int.toString(idx)}
              scope="col"
              className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              {React.string(x)}
            </th>
          }, headers)->React.array} </tr> </thead>

    let rows = {
      Js.Array.mapi(({Item.version: version, description, period, completion, results}, idx) => {
        <tr key={Js.Int.toString(idx)}>
          <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
            {React.string(
              switch version {
              | None => ""
              | Some(x) => x
              },
            )}
          </td>
          <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
            {React.string(description)}
          </td>
          <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
            {React.string(period)}
          </td>
          <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
            {React.string(completion)}
          </td>
          <td className="px-6 py-4 whitespace-normal text-sm text-gray-500">
            {React.string(results)}
          </td>
        </tr>
      }, items)->React.array
    }

    <div className="flex flex-col">
      <div className="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
        <div className="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
          <div className="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
            <table className="table-auto min-w-full divide-y divide-gray-200">
              header <tbody className="bg-white divide-y divide-gray-200"> rows </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  }
}

type t = {items: array<Table.Item.t>}

@react.component
let make = (~content) => {
  let (hidden, setHidden) = React.useState(_ => true)

  let pb = switch hidden {
  | true => 0
  | false => 8
  }

  <SectionContainer.LargeCentered paddingY={`pb-${Js.Int.toString(pb)}`} bgColor="bg-yellowdark">
    <Progress />
    <div className="flex flex-col items-center">
      <button
        type_="button"
        className="inline-flex items-center pt-0 pb-1.5 border border-transparent text-xs font-medium rounded shadow-sm text-white bg-yellowdark focus:outline-none"
        onClick={_ => setHidden(x => !x)}>
        {React.string(
          "See more " ++
          // TODO: use icons instead of ascii art (: !
          switch hidden {
          | true => "v"
          | false => "^"
          },
        )}
      </button>
    </div>
    <div
      className={switch hidden {
      | true => "hidden"
      | false => ""
      }}>
      <Table items=content.items />
    </div>
  </SectionContainer.LargeCentered>
}
