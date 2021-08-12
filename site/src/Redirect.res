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
  <Card title kind={#Opaque}>
    <p className={`text-lg font-roboto`}>
      {React.string(linkTextLeft->Belt.Option.getWithDefault(""))}
      <span className="underline font-bold">
        <Next.Link href={path}> {React.string(linkText)} </Next.Link>
      </span>
      {React.string(linkTextRight->Belt.Option.getWithDefault(""))}
    </p>
  </Card>
}
