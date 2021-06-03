@module("js-yaml") external load: (string, ~options: 'a=?, unit) => Js.Json.t = "load"

@module("js-yaml") external json_schema: string = "JSON_SCHEMA"

let load_json = s => load(s, ~options={"schema": json_schema}, ())
