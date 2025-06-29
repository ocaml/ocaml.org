type redirection = { old_path : string; new_path : string } [@@deriving yojson]

type t = {
  name : string;
  version : string;
  failed : bool;
  files : string list;
  redirections : redirection list;
}
[@@deriving yojson]

let has_file (v : t) (options : string list) : string option =
  let children = v.files in
  try
    List.find_map
      (fun x ->
        let fname = Fpath.(v x |> rem_ext |> filename) in
        if List.mem fname options then Some fname else None)
      children
  with Not_found -> None

let license_names = [ "LICENSE"; "LICENCE" ]
let readme_names = [ "README"; "Readme"; "readme" ]

let changelog_names =
  [ "CHANGELOG"; "Changelog"; "changelog"; "CHANGES"; "Changes"; "changes" ]

let is_special =
  let names = license_names @ readme_names @ changelog_names in
  fun x -> List.mem x names

let license (v : t) = has_file v license_names
let readme (v : t) = has_file v readme_names
let changelog (v : t) = has_file v changelog_names
