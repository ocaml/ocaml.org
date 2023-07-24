let rec list_equal f x y =
  match (x, y) with
  | [], [] -> true
  | [], _ | _, [] -> false
  | a :: b, c :: d -> f a c && list_equal f b d
