---
packages:
- name: cryptokit
  tested_version: "1.18"
  used_libraries:
  - cryptokit
---
(* `hmac` computes the MAC (Message Authentication Code) for the given message
   and the given secret key.  The MAC function used is HMAC-SHA256. *)
let hmac ~key msg =
  (* Use HMAC-SHA256 to create a hash function from the given key *)
  let hash = Cryptokit.MAC.hmac_sha256 key in
  (* Run the message through this hash function *)
  Cryptokit.hash_string hash msg

(* Sign the given message.  Return a pair of the message and its MAC. *)
let sign ~key msg =
  (msg, hmac ~key msg)

(* Verify the signature on a message.  Return `true` if the signature is valid,
   `false` otherwise. *)
let verify ~key (msg, mac) =
  hmac ~key msg = mac

(* A simple test. *)
let _ =
  let key = "supercalifragilisticexpialidocious"
  and msg = "Mary Poppins" in
  assert (verify ~key (sign ~key msg))
