open! Import

module CornerTitleLogo = {
  @react.component
  let make = (
    ~title,
    ~graphicUrl,
    ~body,
    ~colored=false,
    ~bordered=true,
    ~largerText=false,
    (),
  ) => {
    let borderStyle = switch bordered {
    | true => "bg-white shadow-md rounded-md"
    | false => ""
    }
    let titleTextColor = switch colored {
    | true => "text-orangedark"
    | false => ""
    }
    let bodyTextSize = switch largerText {
    | true => "text-2xl"
    | false => "text-lg"
    }
    <div className={`${borderStyle} overflow-hidden px-10 py-8 sm:px-20 sm:py-12`}>
      <div
        className="flex flex-col sm:flex-row items-start sm:justify-between sm:items-center mb-4">
        <div className={`${titleTextColor} order-2 sm:order-1 font-extrabold text-4xl font-roboto`}>
          {React.string(title)}
        </div>
        // Note: The image is decorative, so we intentionally provide an empty alt description
        <img className="order-1 sm:order-2 h-32" src=graphicUrl alt="" />
      </div>
      <p className={`${bodyTextSize} font-roboto`}> {React.string(body)} </p>
    </div>
  }
}

module CornerLogoCenterTitle = {
  // optional call to action
  @react.component
  let make = (~title, ~graphicUrl, ~body, ~buttonText=?, ()) => {
    <div className="bg-white overflow-hidden rounded-sm px-4 py-4 sm:px-8 sm:py-8">
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-11">
        <div className="mx-auto sm:mx-0 sm:w-auto sm:col-span-2">
          // Note: The image is decorative, so we intentionally provide an empty alt description
          <img className="max-h-24" src=graphicUrl alt="" />
        </div>
        // TODO: this is essentially an embedded call to action, so reuse the call to action module
        <div className="sm:col-span-8 flex flex-col items-center space-y-8">
          <div className="text-center font-roboto font-extrabold text-4xl font-serif">
            {React.string(title)}
          </div>
          <p className="font-roboto text-xl"> {React.string(body)} </p>
          {switch buttonText {
          | Some(buttonText) =>
            <a
              className="inline-flex items-center justify-center px-4 py-1 border border-transparent text-3xl font-roboto font-bold rounded-md text-white bg-yellow-600 hover:bg-yellow-700">
              {React.string(buttonText)}
            </a>
          | None => <> </>
          }}
        </div>
      </div>
    </div>
  }
}
