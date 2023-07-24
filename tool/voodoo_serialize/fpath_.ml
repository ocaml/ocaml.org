type t = Fpath.t

let of_yojson json = json |> Yojson.Safe.Util.to_string |> Fpath.v
let to_yojson x = `String (Fpath.to_string x)
