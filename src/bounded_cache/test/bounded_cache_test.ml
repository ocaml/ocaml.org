module C = Bounded_cache

let test_case n = Alcotest.test_case n `Quick
let opt_int = Alcotest.(option int)

let test_hit_miss () =
  let t = C.create ~max_entries:8 ~ttl:10. in
  Alcotest.(check opt_int) "miss on empty" None (C.find t ~now:0. ~key:"k");
  C.store t ~now:0. ~key:"k" 42;
  Alcotest.(check opt_int)
    "hit after store" (Some 42)
    (C.find t ~now:0. ~key:"k");
  Alcotest.(check opt_int) "miss on other key" None (C.find t ~now:0. ~key:"j")

let test_expiry () =
  let t = C.create ~max_entries:8 ~ttl:10. in
  C.store t ~now:0. ~key:"k" 1;
  Alcotest.(check opt_int)
    "fresh within ttl" (Some 1)
    (C.find t ~now:9.9 ~key:"k");
  Alcotest.(check opt_int)
    "expired at ttl boundary" None
    (C.find t ~now:10. ~key:"k");
  Alcotest.(check opt_int) "expired past ttl" None (C.find t ~now:11. ~key:"k")

let test_fifo_eviction () =
  let t = C.create ~max_entries:3 ~ttl:1000. in
  List.iter (fun k -> C.store t ~now:0. ~key:k 0) [ "a"; "b"; "c" ];
  (* Inserting a 4th distinct key evicts the oldest ("a"). *)
  C.store t ~now:0. ~key:"d" 0;
  Alcotest.(check opt_int) "oldest evicted" None (C.find t ~now:0. ~key:"a");
  List.iter
    (fun k ->
      Alcotest.(check bool)
        (k ^ " retained") true
        (C.find t ~now:0. ~key:k <> None))
    [ "b"; "c"; "d" ]

let test_restore_keeps_position () =
  let t = C.create ~max_entries:3 ~ttl:1000. in
  List.iter (fun k -> C.store t ~now:0. ~key:k 0) [ "a"; "b"; "c" ];
  (* Re-store "a": value/timestamp refresh but it must NOT move to the back of
     the FIFO queue (not LRU), so the next insert still evicts "a". *)
  C.store t ~now:1. ~key:"a" 99;
  Alcotest.(check opt_int)
    "value refreshed" (Some 99)
    (C.find t ~now:1. ~key:"a");
  C.store t ~now:2. ~key:"d" 0;
  Alcotest.(check opt_int)
    "re-stored key still evicted first" None
    (C.find t ~now:2. ~key:"a");
  Alcotest.(check opt_int) "b survived" (Some 0) (C.find t ~now:2. ~key:"b")

let test_find_or_compute () =
  let t = C.create ~max_entries:8 ~ttl:10. in
  let calls = ref 0 in
  let compute () =
    incr calls;
    !calls
  in
  let a = C.find_or_compute t ~now:0. ~key:"k" compute in
  let b = C.find_or_compute t ~now:1. ~key:"k" compute in
  Alcotest.(check int) "computed once" 1 !calls;
  Alcotest.(check int) "first value" 1 a;
  Alcotest.(check int) "cached value reused" 1 b;
  (* After expiry it recomputes. *)
  let c = C.find_or_compute t ~now:11. ~key:"k" compute in
  Alcotest.(check int) "recomputed after ttl" 2 !calls;
  Alcotest.(check int) "fresh value" 2 c

let test_expired_overwrite () =
  (* An expired-but-not-yet-evicted key is overwritten cleanly on re-store, and
     does not consume a second capacity slot. *)
  let t = C.create ~max_entries:1 ~ttl:10. in
  C.store t ~now:0. ~key:"k" 1;
  Alcotest.(check opt_int)
    "expired reads as miss" None
    (C.find t ~now:20. ~key:"k");
  C.store t ~now:20. ~key:"k" 2;
  Alcotest.(check opt_int)
    "overwritten value" (Some 2)
    (C.find t ~now:20. ~key:"k")

let () =
  Alcotest.run "bounded_cache"
    [
      ( "core",
        [
          test_case "hit/miss" test_hit_miss;
          test_case "expiry boundary" test_expiry;
          test_case "FIFO eviction" test_fifo_eviction;
          test_case "re-store keeps FIFO position" test_restore_keeps_position;
          test_case "find_or_compute" test_find_or_compute;
          test_case "expired key overwrite" test_expired_overwrite;
        ] );
    ]
