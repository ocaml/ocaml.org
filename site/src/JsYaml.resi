let load: (string, ~options: 'a=?, unit) => Js.Json.t

// [load_json] will use the [JSON_SCHEMA] for loading in a JSON compatible representation of the yaml
let load_json: string => Js.Json.t
