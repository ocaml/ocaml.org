type pageContent = {
  title: string,
  pageDescription: string,
}

type output = {data: pageContent, content: string}

let matter: string => output

let forceInvalidException: JsYaml.forceInvalidException<pageContent>
