let slice list i k = 
  List.filteri (fun index _ -> index >= i && index <= k) list
