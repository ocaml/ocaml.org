type t = {
  id: int,
  name: string,
  author: string,
  creationDate: string,
  link: string,
}

@module("js-yaml") external load: (string, ~options: 'a=?, unit) => array<t> = "load"

let forceInvalidException: JsYaml.forceInvalidException<t> = t => {
  let _ = (
    Js.Int.toString(t.id),
    Js.String.length(t.name),
    Js.String.length(t.author),
    Js.String.length(t.creationDate),
    Js.String.length(t.link),
  )
}

let readAll = () => {
  let databasePath = "data/talks.yaml"
  let fileContents = Fs.readFileSync(databasePath)
  let talks = load(fileContents, ())
  Js.Array.forEach(forceInvalidException, talks)
  talks
}
