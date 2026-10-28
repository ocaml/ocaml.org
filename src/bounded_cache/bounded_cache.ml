type 'a entry = { value : 'a; expires : float }

type 'a t = {
  max_entries : int;
  ttl : float;
  table : (string, 'a entry) Hashtbl.t;
  order : string Queue.t; (* insertion order, for FIFO eviction *)
}

let create ~max_entries ~ttl =
  { max_entries; ttl; table = Hashtbl.create 256; order = Queue.create () }

(* Evict oldest entries until below the cap. Keys already gone from [table]
   (e.g. expired and overwritten) are skipped as the queue is drained. *)
let rec evict_to_cap t =
  if Hashtbl.length t.table >= t.max_entries && not (Queue.is_empty t.order)
  then (
    let oldest = Queue.pop t.order in
    Hashtbl.remove t.table oldest;
    evict_to_cap t)

let find t ~now ~key =
  match Hashtbl.find_opt t.table key with
  | Some e when now < e.expires -> Some e.value
  | _ -> None

let store ?ttl t ~now ~key value =
  let ttl = Option.value ttl ~default:t.ttl in
  if not (Hashtbl.mem t.table key) then (
    evict_to_cap t;
    Queue.push key t.order);
  Hashtbl.replace t.table key { value; expires = now +. ttl }

let find_or_compute t ~now ~key compute =
  match find t ~now ~key with
  | Some value -> value
  | None ->
      let value = compute () in
      store t ~now ~key value;
      value
