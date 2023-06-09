val read_opt : string -> string option
val of_string : string -> (Yaml.value, [ `Msg of string ]) result

val find :
  string -> Yaml.value -> (Yaml.value option, [ `Msg of string ]) result

val to_result : none:'e -> 'a option -> ('a, 'e) result
