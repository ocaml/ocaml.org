module String = struct
  include Stdlib.String
  module Map = Map.Make (Stdlib.String)

  let contains_s s1 s2 =
    try
      let len = length s2 in
      for i = 0 to length s1 - len do
        if sub s1 i len = s2 then raise Exit
      done;
      false
    with Exit -> true
end

module List = struct
  include Stdlib.List

  let rec take n = function x :: u when n > 0 -> x :: take (n - 1) u | _ -> []
end
