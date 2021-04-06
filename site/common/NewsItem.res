type t = {
  id: int,
  link: string,
  title: string,
}

let readAll = () => {
  let databasePath = "data/news.yaml"
  let fileContents = Fs.readFileSync(databasePath)
  let jsonRes = JsYaml.load(fileContents, ())
  let jsonArr = Js.Option.getExn(Js.Json.decodeArray(jsonRes))
  Js.Array.map(o => {
    let dict = Js.Option.getExn(Js.Json.decodeObject(o))
    let id = Belt.Int.fromFloat(
      Js.Option.getExn(Js.Json.decodeNumber(Js.Dict.unsafeGet(dict, "id"))),
    )
    let link = Js.Option.getExn(Js.Json.decodeString(Js.Dict.unsafeGet(dict, "link")))
    let title = Js.Option.getExn(Js.Json.decodeString(Js.Dict.unsafeGet(dict, "title")))
    {
      id: id,
      link: link,
      title: title,
    }
  }, jsonArr)
}
