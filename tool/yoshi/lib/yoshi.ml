module Config = struct
  type field = { name : string; ftype : string [@key "type"] } [@@deriving yaml]

  type data_item = {
    name : string;
    source : string;
    format : string;
    fields : field list;
  }
  [@@deriving yaml]

  type t = { data : data_item list } [@@deriving yaml]

  let read s =
    let yaml = Yaml.of_string_exn s in
    match of_yaml yaml with Ok t -> t | Error (`Msg err) -> failwith err
end

module Gen = struct
  let string_of_field (field : Config.field) =
    let rec string_of_ftype ftype =
      match ftype with
      | "string" -> "string"
      | "int" -> "int"
      | "float" -> "float"
      | "bool" -> "bool"
      | _ when String.ends_with ~suffix:" option" ftype ->
          let underlying_type = String.sub ftype 0 (String.length ftype - 7) in
          Printf.sprintf "%s option" (string_of_ftype underlying_type)
      | _ -> failwith ("Unsupported field type: " ^ ftype)
    in
    Printf.sprintf "  %s: %s;" field.Config.name
      (string_of_ftype field.Config.ftype)

  let rec string_of_field_value value =
    match value with
    | `String s ->
      Printf.sprintf "\"%s\"" (Str.global_replace (Str.regexp "\"") "\\\"" s)
    | `Int i -> string_of_int i
    | `Float f -> string_of_float f
    | `Bool b -> string_of_bool b
    | `Option None -> "None"
    | `Option (Some v) -> Printf.sprintf "Some (%s)" (string_of_field_value v)

  let gen_record fields_values =
    let field_assignments =
      List.map
        (fun (name, value) ->
          Printf.sprintf "%s = %s" name (string_of_field_value value))
        fields_values
    in
    Printf.sprintf "{ %s }" (String.concat "; " field_assignments)

  let gen_value (data_item : Config.data_item) parsed_data =
    let records = List.map gen_record parsed_data in
    Printf.sprintf "let %s_list = [\n  %s\n]" data_item.name
      (String.concat ";\n  " records)

  let gen_type (data_item : Config.data_item) =
    let field_strings = List.map string_of_field data_item.fields in
    let fields_str = String.concat "\n" field_strings in
    Printf.sprintf "type t = {\n%s\n}" fields_str
end

let rec parse_field_value field_type (field_value : Yaml.value) =
  let parse_option_value underlying_type value =
    match value with
    | `Null -> `Option None
    | _ -> `Option (Some (parse_field_value underlying_type value))
  in
  match field_type with
  | "string" -> (
      match field_value with
      | `String s -> `String s
      | _ -> failwith "Expected a string value")
  | "int" -> (
      match field_value with
      | `Float f when float_of_int (int_of_float f) = f -> `Int (int_of_float f)
      | _ -> failwith "Expected an int value")
  | "float" -> (
      match field_value with
      | `Float f -> `Float f
      | _ -> failwith "Expected a float value")
  | "bool" -> (
      match field_value with
      | `Bool b -> `Bool b
      | _ -> failwith "Expected a bool value")
  | _ when String.ends_with ~suffix:" option" field_type ->
      let underlying_type =
        String.sub field_type 0 (String.length field_type - 7)
      in
      parse_option_value underlying_type field_value
  | _ -> failwith ("Unsupported field type: " ^ field_type)

let parse_data_item_fields (fields : Config.field list) (yaml_item : Yaml.value)
    =
  List.map
    (fun (field : Config.field) ->
      match yaml_item with
      | `O fields_map ->
          let field_value =
            try List.assoc field.name fields_map with Not_found -> `Null
          in
          (field.name, parse_field_value field.ftype field_value)
      | _ -> failwith "Expected an object in the YAML data")
    fields

let parse_data (data_item : Config.data_item) s =
  let yaml = Yaml.of_string_exn s in
  match yaml with
  | `A yaml_items ->
      List.map (parse_data_item_fields data_item.fields) yaml_items
  | _ -> failwith "Expected an array in the YAML data"

let generate_module config_string input_yaml_string =
  let config = Config.read config_string in
  let data_item = List.hd config.data in
  let parsed_data = parse_data data_item input_yaml_string in
  let type_string = Gen.gen_type data_item in
  let value_string = Gen.gen_value data_item parsed_data in
  Printf.sprintf "%s\n\n%s\n" type_string value_string
