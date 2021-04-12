type t = {
  id: int,
  name: string,
  link: string,
  linkDescription: string,
  image: string,
  imageHeight: string,
  description: string,
}

@module("js-yaml") external load: (string, ~options: 'a=?, unit) => array<t> = "load"

let forceInvalidException: JsYaml.forceInvalidException<t> = s => {
  let _ = (
    Js.Int.toString(s.id),
    Js.String.length(s.name),
    Js.String.length(s.link),
    Js.String.length(s.linkDescription),
    Js.String.length(s.image),
    Js.String.length(s.imageHeight),
    Js.String.length(s.description),
  )
}

let readAll = () => {
  let databasePath = "data/ocaml_powered_software.yaml"
  let fileContents = Fs.readFileSync(databasePath)
  let software = load(fileContents, ())
  Js.Array.forEach(forceInvalidException, software)
  software
}
