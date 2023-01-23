module String = struct
  include Stdlib.String

  let contains_s s1 s2 =
    try
      let len = String.length s2 in
      for i = 0 to String.length s1 - len do
        if String.sub s1 i len = s2 then raise Exit
      done;
      false
    with Exit -> true
end

module List = struct
  include Stdlib.List

  let take n xs =
    let rec aux i acc = function
      | [] -> acc
      | _ when i = 0 -> acc
      | y :: ys -> aux (i - 1) (y :: acc) ys
    in
    aux n [] xs |> List.rev

  let skip n xs =
    let rec aux i = function
      | [] -> []
      | l when i = 0 -> l
      | _ :: ys -> aux (i - 1) ys
    in
    aux n xs
end
