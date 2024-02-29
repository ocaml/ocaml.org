---
packages:
- name: "ezsqlite"
  version: "0.4.2"
libraries:
- ezsqlite
discussion: |
  - **Understanding `Ezsqlite`:** The `Ezsqlite` libraies proposes a set of function which permits the usage of a SQLite3 database. They are described in the [`Ezsqlite` library documentation](https://github.com/zshipko/ocaml-ezsqlite/blob/master/lib/ezsqlite.mli). It uses exception for error handling.
  - **Alternative Libraries:** `sqlite3` is an other SQLite library. The `gensqlite` is a preprocessor for `sqlite3`. `sqlexpr` is another SQLite library which comes with a PPX preprocessor. `caqti` is a portable interface which supports SQLite3, MariaDB and PostgreSQL. It may be used with the `ppx_rapper` preprocessor.
---

(* Use the `ezsqlite` library, which permits the use of a SQLite3 database. Before any use, the database much be opened. The `load` creates the database is it doesn't exist: *)
let db = Ezsqlite.load "personal.sqlite"

(* Table creation. The `run_ign` function is used when no values are returned by the query. *)
let () =
  Ezsqlite.run_ign db
    "CREATE TABLE personal (name VARCHAR, firstname VARCHAR, age INTEGER)"
    ()

(* Row insertions. First, the statement is prepared (parsed, compiled), then each ":id" is bound to actual values. Then the query is executed. It is recommended to have constant query strings and use bindings to deal with variable values, especially with values from an unstrusted source. *)
type person = { name:string; firstname:string; age:int }

let persons = [ {name="Dupont"; firstname="Jacques"; age=36};
                {name="Legendre"; firstname="Patrick"; age=42} ]

let () =
  let stmt = Ezsqlite.prepare db
                "INSERT into personal VALUES (:name, :firstname, :age)" in
  persons
  |> List.iter (fun r ->
          Ezsqlite.clear stmt;
          Ezsqlite.bind_dict stmt
            [":name", Ezsqlite.Value.Text r.name;
            ":firstname", Ezsqlite.Value.Text r.firstname;
            ":age", Ezsqlite.Value.Integer (Int64.of_int r.age)];
          Ezsqlite.exec stmt)

(* Selection of rows. The `iter` function can execute a query while executing a given function for each row. The `text`, `blob`, `int64`, `int`, `double` functions can be used to get the values returned by the query. `column` and `Value.is_null` functions can be used if we have to check the nullity (NULL SQL value) of some values.  *)
let () =
  let stmt = Ezsqlite.prepare db
                "SELECT name, firstname, age from personal" in
  Ezsqlite.iter stmt
    (fun stmt ->
      let name=Ezsqlite.text stmt 0
      and firstname=Ezsqlite.text stmt 1
      and age=Ezsqlite.int stmt 2
      in
      Printf.printf "name=%s, firstname=%s, age=%d\n" name firstname age)
