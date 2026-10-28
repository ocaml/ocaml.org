type 'a entry = { value : 'a; expires : float; bytes : int }

type 'a t = {
  max_entries : int;
  max_bytes : int;
  sizer : 'a -> int;
  ttl : float;
  table : (string, 'a entry) Hashtbl.t;
  order : string Queue.t; (* insertion order, for FIFO eviction *)
  mutable total_bytes : int; (* running sum of live entries' [bytes] *)
}

let create ~max_entries ~max_bytes ~sizer ~ttl =
  {
    max_entries;
    max_bytes;
    sizer;
    ttl;
    table = Hashtbl.create 256;
    order = Queue.create ();
    total_bytes = 0;
  }

(* Drop the oldest entry from both the queue and the table, updating the byte
   total. A key is enqueued exactly once (re-stores keep their slot), so the
   popped key is normally live; the [None] branch is only defensive. *)
let evict_oldest t =
  let key = Queue.pop t.order in
  match Hashtbl.find_opt t.table key with
  | Some e ->
      t.total_bytes <- t.total_bytes - e.bytes;
      Hashtbl.remove t.table key
  | None -> ()

(* Evict the oldest entries until the cache is back under *both* bounds. Run
   after inserting, so the just-added entry (now at the queue tail) survives
   unless it alone blows the byte budget. *)
let rec evict t =
  if
    (not (Queue.is_empty t.order))
    && (Hashtbl.length t.table > t.max_entries || t.total_bytes > t.max_bytes)
  then (
    evict_oldest t;
    evict t)

let find t ~now ~key =
  match Hashtbl.find_opt t.table key with
  | Some e when now < e.expires -> Some e.value
  | _ -> None

let store ?ttl t ~now ~key value =
  let ttl = Option.value ttl ~default:t.ttl in
  let bytes = t.sizer value in
  (* Deduct any prior entry's size up front so eviction sees the true total. A
     re-store keeps the key's original FIFO position (not re-enqueued); only a
     genuinely new key is appended to the order queue. *)
  (match Hashtbl.find_opt t.table key with
  | Some e -> t.total_bytes <- t.total_bytes - e.bytes
  | None -> Queue.push key t.order);
  Hashtbl.replace t.table key { value; expires = now +. ttl; bytes };
  t.total_bytes <- t.total_bytes + bytes;
  evict t

let find_or_compute t ~now ~key compute =
  match find t ~now ~key with
  | Some value -> value
  | None ->
      let value = compute () in
      store t ~now ~key value;
      value
