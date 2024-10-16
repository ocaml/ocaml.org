---
packages:
- name: "ezsqlite"
  tested_version: "0.4.2"
  used_libraries:
  - ezsqlite
---

(* Open or create (if it doesn't exist) the SQLite database *)
let db = Ezsqlite.load "employees.sqlite"

(* Create the `employees` table.
   The function `run_ign` ("run and ignore") executes the query and discards the database response.
   *)
let () =
  Ezsqlite.run_ign db
    "CREATE TABLE employees (
        name VARCHAR NOT NULL,
        firstname VARCHAR NOT NULL,
        age INTEGER NOT NULL
    )"
    ()

type employee =
  { name:string; firstname:string; age:int }

let employees = [
  {name = "Dupont"; firstname = "Jacques"; age = 36};
  {name = "Legendre"; firstname = "Patrick"; age = 42}
  ]

let () =
(* The function `Ezsqlite.prepare` prepares the statement, so that later actual values
  can be bound to the variables `:name`, `:firstname`, and `:age`. *)
  let stmt = Ezsqlite.prepare db
    {| 
      INSERT into employees
      VALUES (:name, :firstname, :age)
    |}
  in
(* Running these `Ezsqlite` functions in sequence binds the values from the
   `employee` record and executes the query. *)
  let insert_employee (employee: employee) =
    Ezsqlite.clear stmt;
    Ezsqlite.bind_dict stmt
      [":name", Ezsqlite.Value.Text employee.name;
      ":firstname", Ezsqlite.Value.Text
        employee.firstname;
      ":age", Ezsqlite.Value.Integer
        (Int64.of_int employee.age)];
    Ezsqlite.exec stmt
  in
  employees
  |> List.iter insert_employee 

(* The `iter` function executes a query and then maps a given function over all
   rows returned by the database.
   *)
let () =
  let stmt = Ezsqlite.prepare db
    "SELECT name, firstname, age from employees"
  in
  let print_employee row =
(* The `Ezsqlite.text`, `blob`, `int64`, `int`, `double`
   functions can be used to read the values of individual columns.
   
   Note that this is not type-safe, since you need to provide the correct type
   for the column here. *)
    let name = Ezsqlite.text row 0
    and firstname = Ezsqlite.text row 1
    and age = Ezsqlite.int row 2
    in
    Printf.printf "name=%s, firstname=%s, age=%d\n"
      name firstname age
  in
  Ezsqlite.iter stmt print_employee
