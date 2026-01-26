(* Verify round-trip: load YAML → pack → unpack → verify *)

open Data_packer
open Types

let () =
  let bin_file = Sys.argv.(1) in

  Printf.printf "Loading original data...\n";
  let original = Packer.load_all () in
  Printf.printf "  %d testimonials\n" (List.length original.testimonials);
  Printf.printf "  %d academic_testimonials\n" (List.length original.academic_testimonials);
  Printf.printf "  %d jobs\n" (List.length original.jobs);
  Printf.printf "  %d opam_users\n" (List.length original.opam_users);
  Printf.printf "  %d resources\n" (List.length original.resources);

  Printf.printf "\nPacking to %s...\n" bin_file;
  Packer.pack_to_file ~output:bin_file original;

  Printf.printf "\nUnpacking from %s...\n" bin_file;
  let unpacked = Unpacker.unpack_from_file bin_file in
  Printf.printf "  %d testimonials\n" (List.length unpacked.testimonials);
  Printf.printf "  %d academic_testimonials\n" (List.length unpacked.academic_testimonials);
  Printf.printf "  %d jobs\n" (List.length unpacked.jobs);
  Printf.printf "  %d opam_users\n" (List.length unpacked.opam_users);
  Printf.printf "  %d resources\n" (List.length unpacked.resources);

  Printf.printf "\nVerifying data integrity...\n";

  (* Verify counts *)
  assert (List.length original.testimonials = List.length unpacked.testimonials);
  assert (List.length original.academic_testimonials = List.length unpacked.academic_testimonials);
  assert (List.length original.jobs = List.length unpacked.jobs);
  assert (List.length original.opam_users = List.length unpacked.opam_users);
  assert (List.length original.resources = List.length unpacked.resources);

  (* Verify first testimonial if any *)
  (match original.testimonials, unpacked.testimonials with
   | t1 :: _, t2 :: _ ->
       assert (t1.Testimonial.person = t2.Testimonial.person);
       assert (t1.testimony = t2.testimony);
       assert (t1.href = t2.href);
       assert (t1.role = t2.role);
       assert (t1.logo = t2.logo)
   | [], [] -> ()
   | _ -> assert false);

  (* Verify first job if any *)
  (match original.jobs, unpacked.jobs with
   | j1 :: _, j2 :: _ ->
       assert (j1.Job.title = j2.Job.title);
       assert (j1.link = j2.link);
       assert (j1.company = j2.company)
   | [], [] -> ()
   | _ -> assert false);

  Printf.printf "All verifications passed!\n";
  Printf.printf "\nRound-trip successful.\n"
