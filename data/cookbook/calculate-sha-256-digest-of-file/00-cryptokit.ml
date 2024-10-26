---
packages:
- name: cryptokit
  tested_version: "1.18"
  used_libraries:
  - cryptokit
---
(* `sha256sum` computes the SHA-256 digest of the given file,
   and prints it in hexadecimal. *)
let sha256sum filename =
  (* We select SHA-256 as the hash function *)
  let hash = Cryptokit.Hash.sha256() in
  (* We open the given file in binary mode (no end-of-line translation) *)
  let digest =
    In_channel.with_open_bin filename
      (fun ic -> 
        (* We run the contents of the file through the hash function *)
        Cryptokit.hash_channel hash ic) in
  (* We convert the hash (32 bytes) to hexadecimal (64 hexadecimal digits) *)
  let hex_digest =
    Cryptokit.transform_string (Cryptokit.Hexa.encode()) digest in
  (* We print the hexadecimal hash and the filename *)
  Printf.printf "%s  %s\n" hex_digest filename

(* The entry point for this program calls `sha256sum` on each filename
   passed as argument on the command line. *)
let _ =
  for i = 1 to Array.length Sys.argv - 1 do
    sha256sum Sys.argv.(i)
  done

