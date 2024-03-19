(* Simple priority queue where the priorities are integers 0..100.
   The node with the lowest probability comes first. *)
   module Pq = struct
    type 'a t = {data: 'a list array; mutable first: int}
    
    let make() = {data = Array.make 101 []; first = 101}
    
    let add q p x =
      q.data.(p) <- x :: q.data.(p);
      q.first <- min p q.first
      
    let get_min q =
      if q.first = 101 then None else
        match q.data.(q.first) with
        | [] -> assert false
        | x :: tl ->
            let p = q.first in
            q.data.(q.first) <- tl;
            while q.first < 101 && q.data.(q.first) = [] do
              q.first <- q.first + 1
            done;
            Some(p, x)
  end
  
  type tree =
    | Leaf of string
    | Node of tree * tree
  
  let rec huffman_tree q =
    match Pq.get_min q, Pq.get_min q with
    | Some(p1, t1), Some(p2, t2) -> Pq.add q (p1 + p2) (Node(t1, t2)); huffman_tree q
    | Some(_, t), None | None, Some(_, t) -> t
    | None, None -> assert false
  
  (* Build the prefix-free binary code from the tree *)
  let rec prefixes_of_tree prefix = function
    | Leaf s -> [(s, prefix)]
    | Node(t0, t1) ->
        prefixes_of_tree (prefix ^ "0") t0 @
        prefixes_of_tree (prefix ^ "1") t1
  
  let huffman fs =
    if List.fold_left (fun s (_, p) -> s + p) 0 fs <> 100 then
    
      failwith "huffman: sum of weights must be 100";
    let q = Pq.make () in
    List.iter (fun (s, f) -> Pq.add q f (Leaf s)) fs;
    prefixes_of_tree "" (huffman_tree q)
  
