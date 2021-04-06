type t = {
  id: int,
  name: string,
  author: string,
  creationDate: string,
  link: string,
}

let readAll = () => {
  let databasePath = "data/talks.yaml"
  let fileContents = Fs.readFileSync(databasePath)
  let jsonRes = JsYaml.load(fileContents, ())
  let jsonArr = Js.Option.getExn(Js.Json.decodeArray(jsonRes))
  Js.Array.map(o => {
    let dict = Js.Option.getExn(Js.Json.decodeObject(o))
    let id = Belt.Int.fromFloat(
      Js.Option.getExn(Js.Json.decodeNumber(Js.Dict.unsafeGet(dict, "id"))),
    )
    let name = Js.Option.getExn(Js.Json.decodeString(Js.Dict.unsafeGet(dict, "name")))
    let author = Js.Option.getExn(Js.Json.decodeString(Js.Dict.unsafeGet(dict, "author")))
    let creationDate = Js.Option.getExn(
      Js.Json.decodeString(Js.Dict.unsafeGet(dict, "creationDate")),
    )
    let link = Js.Option.getExn(Js.Json.decodeString(Js.Dict.unsafeGet(dict, "link")))
    {id: id, name: name, author: author, creationDate: creationDate, link: link}
  }, jsonArr)
}
