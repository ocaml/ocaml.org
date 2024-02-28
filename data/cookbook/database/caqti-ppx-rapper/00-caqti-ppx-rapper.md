---
packages:
- name: "caqti"
  version: "1.9.0"
- name: "caqti-lwt"
  version: "1.9.0"
- name: "caqti-driver-sqlite"
  version: "1.9.0"
- name: "ppx_rapper"
  version: "3.1.0"
- name: "ppx_rapper_lwt"
  version: "3.1.0"
sections:
- filename: main.ml
  language: ocaml
  code_blocks:
  - explanation: |
      The `Caqti/ppx_rapper` combo uses a Lwt environment (see concurency cookbook). Let operators `(let*)` and `(let*?)` are define and permits the Lwt promise sequencing. `(let*?)` add an error handling: it extract the result from a returned `Ok result` or stop the execution in case of an `Error err` value.
    code: |
      let (let*) = Lwt.bind
      let (let*?) = Lwt_result.bind
  - explanation: |
      The following function will be used later in this cookbook. It schedule sequentialy a set of queries. Each query from the list `queries` is a function which has an argument which is the connection handle of the database.
    code: |
      let iter_queries queries cnx =
        List.fold_left
          (fun a f -> Lwt_result.bind a (fun () -> f cnx))
          (Lwt.return (Ok ()))
          queries
  - explanation: |
      Table creation: the `CREATE` query is simple: not data in input nor in output. The `execute` type indicates the absence of result. Then when this query is called, `()` is returned (`Ok ()` to be accurate).
    code: |
      let create_query =
        [%rapper
            execute {sql|CREATE TABLE personal
                         (name VARCHAR, firstname VARCHAR, age INTEGER)
                     |sql}
        ]
  - explanation: |
      Insertion query: the `INSERT` query is a query which has some parameters which should be used during the execution  of the query. `name`, `firstname`, `age` will be replaced by the values from the parameter (presented as record because of the `record_out` tag). The `%` notation tell the `ppx_rapper` preprocessor which conversion should be used.
    code: |
      type person = { name:string; firstname:string; age:int }
      let persons = [ {name="Dupont"; firstname="Jacques"; age=36};
                      {name="Legendre"; firstname="Patrick"; age=42} ]
      let insert_query =
        [%rapper
            execute {sql|INSERT INTO personal VALUES
                         (%string{name}, %string{firstname}, %int{age})
                     |sql}
            record_in
        ]
  - explanation: |
      Select query: the `SELECT` query has a `get_many` type, then, it will return a list of values. Each item of the list is a record, as specified by the `record_out` tag.
    code: |
      let select_query =
        [%rapper
            get_many {sql|SELECT @string{name}, @string{firstname}, @int{age}
                          FROM personal
                      |sql}
            record_out
        ]
  - explanation: |
      The main program starts by establishing an Lwt environment. The function `with_connexion` open the database, execute a function with `cnx` database handle. And catch exception to ensure the closure of the database.
    code: |
      let () =
        match Lwt_main.run @@
                Caqti_lwt.with_connection (Uri.of_string "sqlite3:essai.sqlite")
                  (fun cnx ->
  - explanation: |
      Executing queries uses `()` and `cnx` parameters when no values should be passed to the query. The `insert_query` must be called with `record_of_person` and `cnx`. If multiple records from a list should be inserted, `List.map` creates a list of functions which will execute each query when called. The `iter_queries` schedule the queries in sequence.
    code: |
                    let*? () = create_query () cnx in
                    let*? () = iter_queries (List.map insert_query persons) cnx in
                    let*? persons = select_query () cnx in
                    persons |> List.iter (fun person ->
                                   Printf.printf "name=%s, firstname=%s, age=%d\n"
                                   person.name  person.firstname  person.age);
                    Lwt_result.return ())
  - explanation:
      The error handling is simple. The `Lwt_result.bind` called by each `(let*?)` stop the chain of queries at the first error. We just have to check the presence of error. `Caqti_error.show` can be used to convert the error into a text.
    code:
        with
        | Result.Ok () ->
             print_string "OK\n"
        | Result.Error err ->
             print_string (Caqti_error.show err)
- filename: dune
  language: dune
  code_blocks:
  - explanation: |
      Multiple libraries are involved.
    code: |
      (executable
        (name main)
        (libraries
            ppx_rapper_lwt
            lwt lwt.unix
            caqti-lwt
            caqti-driver-sqlite3)
        (preprocess (pps ppx_rapper)))
---

- **Understanding `Caqti` and `ppx_rapper`:** The `Caqti` library permits a portable programming with SQLite, MariaDB and PostgreSQL. The declaration of its queries is a bit complex, the the `ppx_rapper` can be used to convert annotated SQL strings into `Caqti` queries. This preprocessor makes all type conversion transparent and leverage the strong typing of OCaml. The `Lwt` library is a scheduling library which permit concurrent tasks. It has been used because of `ppx_rapper`constraints. See [the Caqti reference page](https://github.com/paurkedal/ocaml-caqti) and [the ppx_rapper reference page](https://github.com/roddyyaga/ppx_rapper).
- **Alternative Libraries:** There are multiple alternative to `Caqti`, but this library proposed a unified interface to 3 database. `gensqlite` and `ppx_sqlexpr` are comparable to `ppx_rapper` but only work with a SQLite only library. `Petrol` supports SQLite and PostgreSQL and permits the type safety by declaring the database schema with OCaml structures (SQL statements are generated).
