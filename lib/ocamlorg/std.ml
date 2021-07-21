module Result = struct
  include Stdlib.Result

  let both a b =
    match a with
    | Error e ->
      Error e
    | Ok a ->
      (match b with Error e -> Error e | Ok b -> Ok (a, b))

  module Syntax = struct
    let ( >>= ) t f = bind t f

    let ( >>| ) t f = map f t

    let ( let* ) = ( >>= )

    let ( let+ ) = ( >>| )

    let ( and+ ) = both
  end
end