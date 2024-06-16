---
   packages:
   - name: "re"
     tested_version: "1.11.0"
     used_libraries:
   - re
     discussion: |
   - ** Str Example:** Str provides basic regex support but is not recommended given the advantages of the re package. Note: there is no support for regex patterns like \d and \w.
   - **Advantages of `re`:** Re provides better support for regex syntax encountered in other languages such as python. 
---

(* Sample data for testing *)
let emails =
  [| "oscar.0camel@ocaml.org"
   ; "notAnEmail@jkorg"
   ; "john.doe@yahoo.com"
   ; "tommy_trojan@usc.edu"
   ; "emailScammer@evil.lol"
  |]
;;

(* Function to test patterns *)
let test_pattern validation_func emails =
  print_endline "Email Verification Results:";
  Array.map (fun x -> validation_func x) emails
;;

(* Using Str package. Compare this to an equivalent regex pattern in Python. It will look very different.*)
let validation_pattern =
  Str.regexp {regexp|[A-Za-z0-9]+.?[A-Za-z0-9]+@[a-zA-Z]+\.[a-za-z-a-z]|regexp}
;;

(**[validate_email_str] accepts a string [email]
   and checks it against the validation pattern *)
let validate_email_str email =
  if Str.string_match validation_pattern email 0
  then Printf.printf "%s has a valid email format\n" email
  else Printf.printf "%s has an invalid email format\n" email
;;

(* Test pattern and print results to terminal *)
test_pattern validate_email_str emails

(* Using the Re package. Compared to the Str package this pattern is more readable.*)
let validation_pattern_re = Re.Perl.re "[a-zA-Z0-9.$_!]+@[a-zA-Z0-9]+\\.[a-z]{2,3}"
let email_re = Re.compile validation_pattern_re

(* Validation using Re.Perl regex pattern  *)
let validate_email_re email =
  if Re.execp email_re email
  then Printf.printf "%s has a valid email format\n" email
  else Printf.printf "%s has an invalid email format\n" email
;;

(* Test pattern and print results to terminal *)
test_pattern validate_email_re emails

(* Validate for specific top-level domains. Notice the optional | regex pattern at the end of the pattern.*)
let validation__domain_pattern_re =
  Re.compile (Re.Perl.re "[a-zA-Z0-9.$_!]+@[a-zA-Z0-9]+\\.[com|org|edu|io|gov]")
;;


let validate_email_domain_re email =
  if Re.execp validation__domain_pattern_re email
  then Printf.printf "%s has a valid email format\n" email
  else Printf.printf "!! %s has an invalid email format !!\n" email
;;

(* Test pattern and print results to terminal *)
test_pattern validate_email_domain_re emails
