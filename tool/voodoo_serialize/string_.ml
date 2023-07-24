type t = string

let of_yojson json = json |> Yojson.Safe.Util.to_string
let to_yojson x = `String x
