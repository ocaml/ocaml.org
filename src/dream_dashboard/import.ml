module Result = struct
  include Stdlib.Result

  module Syntax = struct
    let ( let+ ) f t = map t f
  end
end

let ( let@ ) f x = f x

let handle_sys_error f =
  match f () with
  | Ok x -> x
  | Error err -> raise (Error.Exn (Error.of_luv err))

module String_map = Map.Make (String)
