type t = {
  id: int,
  name: string,
  link: string,
  image: string,
}

let readAll = () => {
  let booksDatabasePath = "data/books.yaml"
  let fileContents = Fs.readFileSync(booksDatabasePath)
  let jsonRes = JsYaml.load(fileContents, ())
  let jsonArr = Js.Option.getExn(Js.Json.decodeArray(jsonRes))
  Js.Array.map(o => {
    let dict = Js.Option.getExn(Js.Json.decodeObject(o))
    let id = Belt.Int.fromFloat(
      Js.Option.getExn(Js.Json.decodeNumber(Js.Dict.unsafeGet(dict, "id"))),
    )
    let name = Js.Option.getExn(Js.Json.decodeString(Js.Dict.unsafeGet(dict, "name")))
    let link = Js.Option.getExn(Js.Json.decodeString(Js.Dict.unsafeGet(dict, "link")))
    let image = Js.Option.getExn(Js.Json.decodeString(Js.Dict.unsafeGet(dict, "image")))
    {id: id, name: name, link: link, image: image}
  }, jsonArr)
}
