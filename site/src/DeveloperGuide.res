type t = {
  id: int,
  link: string,
  name: string,
  description: string,
  image: string,
  imageHeight: string,
}

let decode = json => {
  open Json.Decode
  {
    id: json |> field("id", int),
    link: json |> field("link", string),
    name: json |> field("name", string),
    description: json |> field("description", string),
    image: json |> field("image", string),
    imageHeight: json |> field("imageHeight", string),
  }
}

let readAll = () => {
  "data/developer_guides.yaml"->Fs.readFileSync->JsYaml.load()->Json.Decode.array(decode)(_)
}
