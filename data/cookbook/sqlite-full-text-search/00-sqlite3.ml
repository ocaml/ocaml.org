---
packages:
- name: "sqlite3"
  tested_version: "5.4.1"
  used_libraries:
  - sqlite3
discussion: |
  SQLite's [FTS5](https://www.sqlite.org/fts5.html) extension provides full-text
  search over a virtual table. This recipe uses an *external-content* FTS5 table:
  rather than storing a second copy of the text, the index points back at an
  existing table (`content='notes'`, `content_rowid='id'`) and three triggers
  (`after insert`, `after delete`, `after update`) keep it in sync. Queries use the
  `MATCH` operator and `ORDER BY rank` to return the best matches first.

  The `sqlite3` bindings are a thin, untyped layer over the C API. `exec` runs a
  script for its side effects; `prepare`/`bind_values`/`step` drive a prepared
  statement and read columns by position with the matching `column_*` accessor. See
  [the `sqlite3` reference page](https://mmottl.github.io/sqlite3-ocaml/).
---

(* Open or create the database. *)
let db = Sqlite3.db_open "notes.sqlite"

(* `expect_ok` runs a fallible `sqlite3` operation and raises with the database's
   error message if it did not succeed. The bindings return a result code rather
   than raising, so we check it explicitly. *)
let expect_ok db rc =
  match rc with
  | Sqlite3.Rc.OK | Sqlite3.Rc.DONE -> ()
  | rc ->
    failwith (Sqlite3.Rc.to_string rc ^ ": " ^ Sqlite3.errmsg db)

(* Create the base table, the FTS5 index over its `title` and `body` columns, and the
   triggers that keep the index in sync on every write. `exec` runs the whole
   multi-statement script at once. *)
let () =
  expect_ok db
    (Sqlite3.exec db
       {|
         CREATE TABLE notes (
           id    INTEGER PRIMARY KEY,
           title TEXT NOT NULL,
           body  TEXT NOT NULL
         );

         CREATE VIRTUAL TABLE notes_fts USING fts5 (
           title,
           body,
           content='notes',
           content_rowid='id'
         );

         CREATE TRIGGER notes_ai AFTER INSERT ON notes BEGIN
           INSERT INTO notes_fts (rowid, title, body)
           VALUES (new.id, new.title, new.body);
         END;

         CREATE TRIGGER notes_ad AFTER DELETE ON notes BEGIN
           INSERT INTO notes_fts (notes_fts, rowid, title, body)
           VALUES ('delete', old.id, old.title, old.body);
         END;

         CREATE TRIGGER notes_au AFTER UPDATE ON notes BEGIN
           INSERT INTO notes_fts (notes_fts, rowid, title, body)
           VALUES ('delete', old.id, old.title, old.body);
           INSERT INTO notes_fts (rowid, title, body)
           VALUES (new.id, new.title, new.body);
         END;
       |})

type note = { title : string; body : string }

let notes =
  [ { title = "Getting started with OCaml"
    ; body = "OCaml is a functional programming language."
    }
  ; { title = "Pattern matching"
    ; body = "Variants and pattern matching make OCaml expressive."
    }
  ; { title = "Build systems"
    ; body = "Dune is the standard build system for OCaml projects."
    }
  ]

(* Insert the notes through a prepared statement. The trigger above mirrors each row
   into the FTS index automatically — we never write to `notes_fts` directly. *)
let () =
  let stmt =
    Sqlite3.prepare db "INSERT INTO notes (title, body) VALUES (?, ?)"
  in
  List.iter
    (fun note ->
      expect_ok db (Sqlite3.reset stmt);
      expect_ok db
        (Sqlite3.bind_values stmt
           [ Sqlite3.Data.TEXT note.title; Sqlite3.Data.TEXT note.body ]);
      expect_ok db (Sqlite3.step stmt))
    notes;
  ignore (Sqlite3.finalize stmt : Sqlite3.Rc.t)

(* Search the index. `notes_fts MATCH ?` runs the full-text query; joining back to
   `notes` recovers the original rows, and `ORDER BY rank` returns the best matches
   first. `step` yields `Rc.ROW` once per result row and `Rc.DONE` when exhausted. *)
let () =
  let stmt =
    Sqlite3.prepare db
      {|
        SELECT n.title, n.body
        FROM notes_fts f
        JOIN notes n ON n.id = f.rowid
        WHERE notes_fts MATCH ?
        ORDER BY rank
      |}
  in
  expect_ok db (Sqlite3.bind_values stmt [ Sqlite3.Data.TEXT "OCaml" ]);
  let rec loop () =
    match Sqlite3.step stmt with
    | Sqlite3.Rc.ROW ->
      let title = Sqlite3.column_text stmt 0
      and body = Sqlite3.column_text stmt 1 in
      Printf.printf "%s — %s\n" title body;
      loop ()
    | Sqlite3.Rc.DONE -> ()
    | rc -> failwith (Sqlite3.Rc.to_string rc ^ ": " ^ Sqlite3.errmsg db)
  in
  loop ();
  ignore (Sqlite3.finalize stmt : Sqlite3.Rc.t)
