let read_file () =
  match Bos.OS.File.read (Fpath.v "netlify-cms.yaml") with
  | Ok yml -> yml
  | _ -> failwith "failed to read file"

let netlify = Alcotest.of_pp (Netlify.Pp.pp ())

let test_netlify_cms () =
  match Netlify.of_yaml (Yaml.of_string_exn @@ read_file ()) with
  | Ok config ->
      let config_string = Fmt.str "%a" (Netlify.Pp.pp ()) config in
      let rederived_config =
        Netlify.of_yaml (Yaml.of_string_exn config_string) |> Rresult.R.get_ok
      in
      Alcotest.check netlify "same configuration" config rederived_config
  | Error (`Msg m) -> failwith ("NETLIFY ERROR" ^ m)

let () =
  let open Alcotest in
  run "Netlify"
    [
      ("config-generation", [ test_case "Generation" `Quick test_netlify_cms ]);
    ]
