type 'a res = ('a, [ `Msg of string ]) result

val drop_last : 'a list -> 'a list

val src_code_to_html : lang:string -> src:string -> string res
(** [src_code_to_html lang code] will highlight [code] in language [lang] and
    return a string *)
