open! Import

@react.component
let make = (~title=?, ~kind, ~titleTextColor="", ~children) => {
  let borderStyle = switch kind {
  | #Transparent => ""
  | #Opaque => "bg-white shadow-md rounded-md"
  }
  let title = switch title {
  | None => React.null
  | Some(title) =>
    <div className="flex flex-col sm:flex-row items-start sm:justify-between sm:items-center mb-4">
      <div className={`${titleTextColor} order-2 sm:order-1 font-extrabold text-4xl font-roboto`}>
        {React.string(title)}
      </div>
    </div>
  }
  <div className={`${borderStyle} overflow-hidden px-10 py-8 sm:px-20 sm:py-12`}>
    {title} {children}
  </div>
}
