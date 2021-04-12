type t = {
  id: int,
  link: string,
  name: string,
  description: string,
  image: string,
  imageHeight: string,
}

@module("js-yaml") external load: (string, ~options: 'a=?, unit) => array<t> = "load"

let forceInvalidException: JsYaml.forceInvalidException<t> = d => {
  let _ = (
    Js.Int.toString(d.id),
    Js.String.length(d.link),
    Js.String.length(d.name),
    Js.String.length(d.description),
    Js.String.length(d.image),
    Js.String.length(d.imageHeight),
  )
}

let readAll = () => {
  let databasePath = "data/developer_guides.yaml"
  let fileContents = Fs.readFileSync(databasePath)
  let developerGuides = load(fileContents, ())
  Js.Array.forEach(forceInvalidException, developerGuides)
  developerGuides
}
