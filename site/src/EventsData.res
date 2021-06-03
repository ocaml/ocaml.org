type t = Ood.Events.t

let decode = json => {
  open Json.Decode
  {
    Ood.Events.events: json |> field("events", list(Event.decode)),
  }
}

let readAll = () => {
  "vendor/ood/data/events.yml"->Fs.readFileSync->JsYaml.load_json->decode
}
