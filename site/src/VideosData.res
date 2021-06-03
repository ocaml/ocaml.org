type t = Ood.Videos.t

let decode = json => {
  open Json.Decode
  {
    Ood.Videos.videos: json |> field("videos", list(Video.decode)),
  }
}

let readAll = () => {
  "vendor/ood/data/videos.yml"->Fs.readFileSync->JsYaml.load_json->decode
}
