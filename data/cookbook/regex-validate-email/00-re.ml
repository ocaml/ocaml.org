---
packages:
  - name: "re"
    tested_version: "1.11.0"
    used_libraries:
      - re
---

(* An array of sample data for testing. *)
let emails =
  [| "oscar.0camel@ocaml.org"
   ; "notAnEmail@jkorg"
   ; "PrivacyFirst@proton.me"
   ; "tommy_trojan@usc.edu"
   ; "emailScammer@evil.lol"
  |]

(* Using the `Re` module from the `re` package, we create a `Perl` flavor
   regular expression and `compile` it.*)
let validate_email_re =
  Re.Perl.re "[a-zA-Z0-9.$_!]+@[a-zA-Z0-9]+\\.[a-z]{2,3}"
  |> Re.compile

(* Using the `Re.execp` function, we check whether the given `regex` matches
  that `email`.
*)
let validate_email regex email =
  if Re.execp regex email
  then Printf.printf "%s has a valid email format\n" email
  else Printf.printf "%s has an invalid email format\n" email

(* Let's test this by mapping the function returned by `(validate_email validate_email_re)`
  over the `emails` array. *)
let () =
  print_endline "Email Verification Results:";
  emails
  |> Array.map (validate_email validate_email_re)

(* Now, we check for specific top-level domains in an email.
  Notice the `|` operator (regular expression OR) at the end of the pattern *)
let validate_email_domain_re =
  Re.Perl.re "[a-zA-Z0-9.$_!]+@[a-zA-Z0-9]+\\.[com|org|edu|io|gov|me]"
  |> Re.compile 

(* Let's test this by mapping the function returned by `(validate_email validate_email_domain_re)`
  over the `emails` array. *)
let () =
  print_endline "Email Verification Results:";
  emails
  |> Array.map (validate_email validate_email_domain_re)
