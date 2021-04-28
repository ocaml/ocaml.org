type pageContent = {
  title: string,
  pageDescription: option<string>,
}

type output = {data: pageContent, content: string}

@module("gray-matter") external matter: string => output = "default"

let forceInvalidException: JsYaml.forceInvalidException<pageContent> = c => {
  let length = Js.Option.getWithDefault("", c.pageDescription) |> Js.String.length
  let _ = (Js.String.length(c.title), length)
}
