open! Import

@react.component
let make = (~title, ~renderChild, ~cols, ~children) => {
  let gridCols = switch cols {
  | #_2 => "grid-cols-2"
  | #_3 => "grid-cols-3"
  }
  let cols = switch cols {
  | #_2 => 2
  | #_3 => 3
  }
  let rows =
    children->Belt.Array.length / cols + if mod(children->Belt.Array.length, cols) == 0 {
        0
      } else {
        1
      }
  <div>
    <h2 className="text-center text-white text-7xl font-bold mb-8"> {React.string(title)} </h2>
    <div className={`mx-24 grid ${gridCols} px-28 mx-auto max-w-4xl`}>
      {React.array(
        children->Belt.Array.mapWithIndex((i, child) => {
          let border = {
            let r = i / cols
            let c = mod(i, cols)
            " "->Js.Array.joinWith([
              if r != rows - 1 {
                "border-b-4"
              } else {
                ""
              },
              if c != cols - 1 {
                "border-r-4"
              } else {
                ""
              },
            ])
          }
          <div className=border>
            <div
              className="h-24 flex items-center justify-center px-4 font-bold bg-white mx-8 my-3 rounded">
              <p className="text-center"> {renderChild(child)} </p>
            </div>
          </div>
        }),
      )}
    </div>
  </div>
}
