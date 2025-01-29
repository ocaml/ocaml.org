---
packages:
- name: argon2
  tested_version: "1.0.2"
  used_libraries:
  - argon2
---

(* Configuration for password hashing based on OWASP recommendations and Argon2
   default values. Note this example uses only the recommended "Argon2id"
   variation.
   References:
   - https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
   - https://github.com/P-H-C/phc-winner-argon2 *)
let t_cost = 2 and
    m_cost = 65536 and
    parallelism = 1 and
    hash_len = 32 and
    salt_len = 10

(* The hash output length. *)
let encoded_len =
  Argon2.encoded_len ~t_cost ~m_cost ~parallelism ~salt_len ~hash_len ~kind:ID

(* Generate a salt string for a given length using only characters in the range
   "A-Z". This is a simplistic generator and should be replaced with
   cryptographically secure random number generator ("mirage-crypto", for
   example). *)
let gen_salt len =
  let rand_char _ = 65 + (Random.int 26) |> char_of_int in
  String.init len rand_char

(* Return an encoded hash string for the given password. The encoded password
   contains the required metadata for future verification. *)
let hash_password passwd =
  Result.map Argon2.ID.encoded_to_string
    (Argon2.ID.hash_encoded
        ~t_cost ~m_cost ~parallelism ~hash_len ~encoded_len
        ~pwd:passwd ~salt:(gen_salt salt_len))

(* Verifie if the encoded hash string matches the given password. *)
let verify encoded_hash pwd =
  match Argon2.verify ~encoded:encoded_hash ~pwd ~kind:ID with
  | Ok true_or_false -> true_or_false
  | Error VERIFY_MISMATCH -> false
  | Error e -> raise (Failure (Argon2.ErrorCodes.message e))

let () =
  let hashed_pwd = Result.get_ok (hash_password "my insecure password") in
  Printf.printf "Hashed password: %s\n" hashed_pwd;
  let fst_attempt = "my secure password" in
  Printf.printf "'%s' is correct? %B\n" fst_attempt (verify hashed_pwd fst_attempt);
  let snd_attempt = "my insecure password" in
  Printf.printf "'%s' is correct? %B\n" snd_attempt (verify hashed_pwd snd_attempt)
