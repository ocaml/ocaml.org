module C = Bounded_cache

let test_case n = Alcotest.test_case n `Quick
let opt_int = Alcotest.(option int)
let opt_string = Alcotest.(option string)

(* Entry-count-bounded cache: the byte budget is effectively off. *)
let create_n ~max_entries ~ttl =
  C.create ~max_entries ~max_bytes:max_int ~sizer:(fun _ -> 1) ~ttl

(* Byte-bounded string cache: the entry cap is effectively off. *)
let create_b ~max_bytes ~ttl =
  C.create ~max_entries:max_int ~max_bytes ~sizer:String.length ~ttl

let test_hit_miss () =
  let t = create_n ~max_entries:8 ~ttl:10. in
  Alcotest.(check opt_int) "miss on empty" None (C.find t ~now:0. ~key:"k");
  C.store t ~now:0. ~key:"k" 42;
  Alcotest.(check opt_int)
    "hit after store" (Some 42)
    (C.find t ~now:0. ~key:"k");
  Alcotest.(check opt_int) "miss on other key" None (C.find t ~now:0. ~key:"j")

let test_expiry () =
  let t = create_n ~max_entries:8 ~ttl:10. in
  C.store t ~now:0. ~key:"k" 1;
  Alcotest.(check opt_int)
    "fresh within ttl" (Some 1)
    (C.find t ~now:9.9 ~key:"k");
  Alcotest.(check opt_int)
    "expired at ttl boundary" None
    (C.find t ~now:10. ~key:"k");
  Alcotest.(check opt_int) "expired past ttl" None (C.find t ~now:11. ~key:"k")

let test_fifo_eviction () =
  let t = create_n ~max_entries:3 ~ttl:1000. in
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
  let t = create_n ~max_entries:3 ~ttl:1000. in
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
  let t = create_n ~max_entries:8 ~ttl:10. in
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
  let t = create_n ~max_entries:1 ~ttl:10. in
  C.store t ~now:0. ~key:"k" 1;
  Alcotest.(check opt_int)
    "expired reads as miss" None
    (C.find t ~now:20. ~key:"k");
  C.store t ~now:20. ~key:"k" 2;
  Alcotest.(check opt_int)
    "overwritten value" (Some 2)
    (C.find t ~now:20. ~key:"k")

let test_per_entry_ttl () =
  (* [?ttl] on store overrides the cache-wide default for that entry only
     (negative caching); a later default store on the same key restores the full
     TTL. *)
  let t = create_n ~max_entries:8 ~ttl:100. in
  C.store t ~ttl:10. ~now:0. ~key:"neg" 1;
  C.store t ~now:0. ~key:"pos" 2;
  Alcotest.(check opt_int)
    "short-ttl entry fresh" (Some 1)
    (C.find t ~now:9.9 ~key:"neg");
  Alcotest.(check opt_int)
    "short-ttl entry expired" None
    (C.find t ~now:10. ~key:"neg");
  Alcotest.(check opt_int)
    "default-ttl entry unaffected" (Some 2)
    (C.find t ~now:10. ~key:"pos");
  C.store t ~now:10. ~key:"neg" 3;
  Alcotest.(check opt_int)
    "re-store with default ttl" (Some 3)
    (C.find t ~now:109. ~key:"neg")

let test_byte_budget_eviction () =
  (* Storing past the byte budget evicts FIFO until back under it; the
     just-stored entry survives. *)
  let t = create_b ~max_bytes:10 ~ttl:1000. in
  C.store t ~now:0. ~key:"a" "aaaa" (* 4 bytes, total 4 *);
  C.store t ~now:0. ~key:"b" "bbbb" (* 4 bytes, total 8 *);
  C.store t ~now:0. ~key:"c" "cccc" (* 4 bytes, total 12 > 10: evict "a" *);
  Alcotest.(check opt_string)
    "oldest evicted to fit budget" None
    (C.find t ~now:0. ~key:"a");
  Alcotest.(check opt_string)
    "second entry retained" (Some "bbbb")
    (C.find t ~now:0. ~key:"b");
  Alcotest.(check opt_string)
    "new entry retained" (Some "cccc")
    (C.find t ~now:0. ~key:"c")

let test_oversized_entry_dropped () =
  (* A single value larger than the whole budget is dropped (after flushing the
     older entries ahead of it): the cache never retains more than
     [max_bytes]. *)
  let t = create_b ~max_bytes:10 ~ttl:1000. in
  C.store t ~now:0. ~key:"a" "aaaa";
  C.store t ~now:0. ~key:"big" (String.make 11 'x');
  Alcotest.(check opt_string)
    "oversized entry not retained" None
    (C.find t ~now:0. ~key:"big");
  Alcotest.(check opt_string)
    "older entry evicted on the way" None
    (C.find t ~now:0. ~key:"a");
  (* The cache still works afterwards. *)
  C.store t ~now:0. ~key:"b" "bb";
  Alcotest.(check opt_string)
    "cache usable after oversized store" (Some "bb")
    (C.find t ~now:0. ~key:"b")

let test_restore_updates_total () =
  (* Re-storing a key replaces its accounted size rather than adding to it:
     after shrinking "k" from 8 to 2 bytes, a further 7-byte entry fits within
     the 10-byte budget without any eviction. *)
  let t = create_b ~max_bytes:10 ~ttl:1000. in
  C.store t ~now:0. ~key:"k" "aaaaaaaa" (* 8 bytes *);
  C.store t ~now:0. ~key:"k" "aa" (* re-store: total drops to 2 *);
  C.store t ~now:0. ~key:"j" "bbbbbbb" (* 7 bytes, total 9 <= 10 *);
  Alcotest.(check opt_string)
    "shrunk entry retained" (Some "aa")
    (C.find t ~now:0. ~key:"k");
  Alcotest.(check opt_string)
    "new entry fits without eviction" (Some "bbbbbbb")
    (C.find t ~now:0. ~key:"j")

let test_expired_eviction_releases_bytes () =
  (* An entry past its (short, per-entry) TTL reads as a miss but its bytes stay
     accounted until it is evicted in FIFO turn — at which point the released
     budget lets later entries fit. *)
  let t = create_b ~max_bytes:10 ~ttl:1000. in
  C.store t ~ttl:1. ~now:0. ~key:"neg" "nnnn" (* 4 bytes, expires at 1 *);
  C.store t ~now:5. ~key:"b" "bbbb" (* 4 bytes, total 8: "neg" still counted *);
  Alcotest.(check opt_string)
    "expired entry reads as miss" None
    (C.find t ~now:5. ~key:"neg");
  C.store t ~now:5. ~key:"c" "cccc" (* total 12 > 10: evict "neg", total 8 *);
  Alcotest.(check opt_string)
    "live entry kept once expired bytes released" (Some "bbbb")
    (C.find t ~now:5. ~key:"b");
  Alcotest.(check opt_string)
    "new entry retained" (Some "cccc")
    (C.find t ~now:5. ~key:"c")

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
          test_case "per-entry ttl override" test_per_entry_ttl;
        ] );
      ( "byte budget",
        [
          test_case "FIFO until under budget" test_byte_budget_eviction;
          test_case "oversized entry dropped" test_oversized_entry_dropped;
          test_case "re-store updates byte total" test_restore_updates_total;
          test_case "expired eviction releases bytes"
            test_expired_eviction_releases_bytes;
        ] );
    ]
