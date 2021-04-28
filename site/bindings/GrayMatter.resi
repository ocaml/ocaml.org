type pageContent = {
  title: string,
  pageDescription: option<string>,
}

type output = {data: pageContent, content: string}

let matter: string => output

let forceInvalidException: JsYaml.forceInvalidException<pageContent>
