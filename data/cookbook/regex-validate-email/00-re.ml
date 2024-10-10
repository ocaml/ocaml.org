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
   ; "laurent.baffy@club-internet.fr"
   ; "lauren@baffy.email"
   ; "tommy_trojan@usc.edu"
   ; "emailScammer@evil.lol"
  |]

(* Using the `Re` module from the `re` package, we create a `Perl` flavor
   regular expression and `compile` it. The regular expression comes from
   http://emailregex.com and is derived from RFC5322 *)
let validate_email_rfc5322_re =
Re.Perl.re "^(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\\\[\x01-\x09\x0b\x0c\x0e-\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\\])$"
  |> Re.no_case
  |> Re.compile

(* A simpler regular expression can be used, but may fail to match
   valid addresses *)
let validate_email_simple_re =
  Re.Perl.re "^[a-zA-Z0-9.$_!+-]+@[a-zA-Z0-9-]+\\.[a-z]{2,3}$"
  |> Re.compile

(* Using the `Re.execp` function, we check whether the given `regex` matches
  that `email`.
*)
let validate_email regex email =
  if Re.execp regex email
  then Printf.printf "%s has a valid email format\n" email
  else Printf.printf "%s has an invalid email format\n" email

(* Let's test this by mapping the function returned by `validate_email` and each regex.
  over the `emails` array. *)
let () =
  print_endline "Email Verification Results (RFC5322):";
  emails
  |> Array.iter (validate_email validate_email_rfc5322_re)
let () =
  print_endline "Email Verification Results (simple regex):";
  emails
  |> Array.iter (validate_email validate_email_simple_re)

(* Now, we check for specific top-level domains in an email.
  Notice the `|` operator (regular expression OR) at the end of the pattern *)
let validate_email_domain_re =
  Re.Perl.re "^[a-zA-Z0-9.$_!]+@[a-zA-Z0-9]+\\.(com|org|edu|io|gov|me)$"
  |> Re.compile 

(* Let's test this by mapping the function returned by `(validate_email validate_email_domain_re)`
  over the `emails` array. *)
let () =
  print_endline "Email Verification Results:";
  emails
  |> Array.iter (validate_email validate_email_domain_re)
