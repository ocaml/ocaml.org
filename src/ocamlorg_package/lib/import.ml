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

module String = struct
  include Stdlib.String

  let contains_s s1 s2 =
    try
      let len = String.length s2 in
      for i = 0 to String.length s1 - len do
        if String.sub s1 i len = s2 then raise Exit
      done;
      false
    with
    | Exit ->
      true
end
