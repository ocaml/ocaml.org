open! Import

type t = {
  title: string,
  linkTextLeft: option<string>,
  linkText: string,
  linkTextRight: option<string>,
}

let contentEn = {
  title: "Redirecting",
  linkTextLeft: Some("If you aren't redirected immediately, "),
  linkText: "please click here to be redirected",
  linkTextRight: Some("."),
}

let content = lang => {
  switch lang {
  | #en => Some(contentEn)
  | _ => None
  }
}

@react.component
let make = (~path, ~content as {title, linkTextLeft, linkText, linkTextRight}) => {
  let router = Next.Router.useRouter()
  React.useEffect0(() => {
    router->Next.Router.push(path)
    None
  })
  let borderStyle = "bg-white shadow-md rounded-md"
  let titleTextColor = ""
  let bodyTextSize = "text-lg"
  <div className={`${borderStyle} overflow-hidden px-10 py-8 sm:px-20 sm:py-12`}>
    <div className="flex flex-col sm:flex-row items-start sm:justify-between sm:items-center mb-4">
      <div className={`${titleTextColor} order-2 sm:order-1 font-extrabold text-4xl font-roboto`}>
        {React.string(title)}
      </div>
    </div>
    <p className={`${bodyTextSize} font-roboto`}>
      {React.string(linkTextLeft->Belt.Option.getWithDefault(""))}
      <span className="underline font-bold">
        <Next.Link href={path}> {React.string(linkText)} </Next.Link>
      </span>
      {React.string(linkTextRight->Belt.Option.getWithDefault(""))}
    </p>
  </div>
}
