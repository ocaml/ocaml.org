type t = {
  id: int,
  link: string,
  title: string,
}

@module("js-yaml") external load: (string, ~options: 'a=?, unit) => array<t> = "load"

let forceInvalidException: JsYaml.forceInvalidException<t> = n => {
  let _ = (Js.Int.toString(n.id), Js.String.length(n.link), Js.String.length(n.title))
}

let readAll = () => {
  let databasePath = "data/news.yaml"
  let fileContents = Fs.readFileSync(databasePath)
  let newsItems = load(fileContents, ())
  Js.Array.forEach(forceInvalidException, newsItems)
  newsItems
}
