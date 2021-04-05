type t = {
  id: int,
  link: string,
  name: string,
  description: string,
  image: string,
  imageHeight: string,
}

let readAll = () => {
  let databasePath = "data/developer_guides.yaml"
  let fileContents = Fs.readFileSync(databasePath)
  let jsonRes = JsYaml.load(fileContents, ())
  let jsonArr = Js.Option.getExn(Js.Json.decodeArray(jsonRes))
  Js.Array.map(o => {
    let dict = Js.Option.getExn(Js.Json.decodeObject(o))
    let id = Belt.Int.fromFloat(
      Js.Option.getExn(Js.Json.decodeNumber(Js.Dict.unsafeGet(dict, "id"))),
    )
    let link = Js.Option.getExn(Js.Json.decodeString(Js.Dict.unsafeGet(dict, "link")))
    let name = Js.Option.getExn(Js.Json.decodeString(Js.Dict.unsafeGet(dict, "name")))
    let description = Js.Option.getExn(Js.Json.decodeString(Js.Dict.unsafeGet(dict, "description")))
    let image = Js.Option.getExn(Js.Json.decodeString(Js.Dict.unsafeGet(dict, "image")))
    let imageHeight = Js.Option.getExn(Js.Json.decodeString(Js.Dict.unsafeGet(dict, "imageHeight")))
    {
      id: id,
      link: link,
      name: name,
      description: description,
      image: image,
      imageHeight: imageHeight,
    }
  }, jsonArr)
}
