module String = struct
  include Stdlib.String
  module Map = Map.Make (Stdlib.String)

  let contains_s = Ocamlorg.Import.String.contains_s
end

module List = struct
  include Stdlib.List

  let rec take n = function x :: u when n > 0 -> x :: take (n - 1) u | _ -> []
end
