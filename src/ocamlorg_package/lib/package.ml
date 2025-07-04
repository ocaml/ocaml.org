module Name = struct
  include OpamPackage.Name

  let of_string_opt str = try Some (of_string str) with _ -> None
end

module Version = OpamPackage.Version

type t = { name : Name.t; version : Version.t; info : Info.t }

let name t = t.name
let version t = t.version
let info t = t.info
let create ~name ~version info = { name; version; info }
