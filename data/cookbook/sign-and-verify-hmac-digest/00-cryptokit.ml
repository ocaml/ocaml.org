---
packages:
- name: cryptokit
  tested_version: "1.18"
  used_libraries:
  - cryptokit
---

(* We use `Cryptokit.MAC.hmac_sha256` to create a hash function using HMAC-SHA256
from the given key, and then apply the hash function to the message. *)
let hmac ~key msg =
  let hash = Cryptokit.MAC.hmac_sha256 key in
  Cryptokit.hash_string hash msg

(* Sign the given message.  Return a pair of the message and its MAC. *)
let sign ~key msg =
  (msg, hmac ~key msg)

(* Verify the signature on a message.  Return `true` if the signature is valid,
   `false` otherwise. *)
let verify ~key (msg, mac) =
  hmac ~key msg = mac

let _ =
  let key = "supercalifragilisticexpialidocious"
  and msg = "Mary Poppins" in
  assert (verify ~key (sign ~key msg))
