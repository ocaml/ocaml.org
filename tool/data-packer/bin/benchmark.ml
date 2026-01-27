(* Benchmark: Compare packing speed vs code generation compilation *)

open Data_packer

let[@warning "-32"] time_it name f =
  let start = Unix.gettimeofday () in
  let result = f () in
  let elapsed = Unix.gettimeofday () -. start in
  Printf.printf "%s: %.3f seconds\n" name elapsed;
  result

let () =
  let iterations = 10 in

  Printf.printf "=== Data Packer Benchmark ===\n\n";

  (* Benchmark: Load and pack *)
  Printf.printf "Benchmarking %d iterations of load + pack:\n" iterations;

  let total_pack_time = ref 0.0 in
  for _ = 1 to iterations do
    let start = Unix.gettimeofday () in
    let data = Packer.load_all () in
    let buf = Packer.pack_to_buffer data in
    let elapsed = Unix.gettimeofday () -. start in
    total_pack_time := !total_pack_time +. elapsed;
    (* Force evaluation *)
    ignore (Bigstringaf.length buf)
  done;

  let avg_pack_time = !total_pack_time /. float_of_int iterations in
  Printf.printf "\nAverage pack time: %.3f seconds\n" avg_pack_time;

  (* Benchmark: Unpack *)
  Printf.printf "\nBenchmarking %d iterations of unpack:\n" iterations;

  (* First create a packed buffer *)
  let data = Packer.load_all () in
  Packer.pack_to_file ~output:"/tmp/bench.bin" data;

  let total_unpack_time = ref 0.0 in
  for _ = 1 to iterations do
    let start = Unix.gettimeofday () in
    let unpacked = Unpacker.unpack_from_file "/tmp/bench.bin" in
    let elapsed = Unix.gettimeofday () -. start in
    total_unpack_time := !total_unpack_time +. elapsed;
    (* Force evaluation *)
    ignore (List.length unpacked.testimonials)
  done;

  let avg_unpack_time = !total_unpack_time /. float_of_int iterations in
  Printf.printf "\nAverage unpack time: %.3f seconds\n" avg_unpack_time;

  Printf.printf "\n=== Summary ===\n";
  Printf.printf "Pack (parse + serialize): %.3f seconds\n" avg_pack_time;
  Printf.printf "Unpack (deserialize): %.3f seconds\n" avg_unpack_time;
  Printf.printf "\nNote: The current approach compiles 119 MiB of OCaml code.\n";
  Printf.printf "With this packer, only a tiny wrapper needs compilation.\n"
