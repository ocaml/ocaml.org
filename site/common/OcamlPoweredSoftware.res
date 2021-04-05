type t = {
  id: int,
  name: string,
  link: string,
  linkDescription: string,
  image: string,
  imageHeight: string,
  description: string,
}

let readAll = () => {
  let databasePath = "data/ocaml_powered_software.yaml"
  let fileContents = Fs.readFileSync(databasePath)
  let jsonRes = JsYaml.load(fileContents, ())
  let jsonArr = Js.Option.getExn(Js.Json.decodeArray(jsonRes))
  Js.Array.map(o => {
    let dict = Js.Option.getExn(Js.Json.decodeObject(o))
    let id = Belt.Int.fromFloat(
      Js.Option.getExn(Js.Json.decodeNumber(Js.Dict.unsafeGet(dict, "id"))),
    )
    let name = Js.Option.getExn(Js.Json.decodeString(Js.Dict.unsafeGet(dict, "name")))
    let link = Js.Option.getExn(Js.Json.decodeString(Js.Dict.unsafeGet(dict, "link")))
    let linkDescription = Js.Option.getExn(
      Js.Json.decodeString(Js.Dict.unsafeGet(dict, "linkDescription")),
    )

    let image = Js.Option.getExn(Js.Json.decodeString(Js.Dict.unsafeGet(dict, "image")))
    let imageHeight = Js.Option.getExn(Js.Json.decodeString(Js.Dict.unsafeGet(dict, "imageHeight")))
    let description = Js.Option.getExn(Js.Json.decodeString(Js.Dict.unsafeGet(dict, "description")))
    {
      id: id,
      name: name,
      link: link,
      linkDescription: linkDescription,
      image: image,
      imageHeight: imageHeight,
      description: description,
    }
  }, jsonArr)
}
