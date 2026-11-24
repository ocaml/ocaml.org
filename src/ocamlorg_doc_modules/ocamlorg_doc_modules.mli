(** The module paths of each package's documentation, as a compact index that
    the server memory-maps instead of parsing.

    CI scrapes the module tree of every package's documentation into a reference
    file (JSONL, see [tool/doc-modules]) and compiles it with {!Writer} into the
    index format below; both are published as release assets. The server maps
    the index with {!Reader.map_file} and answers "which packages define module
    [M]" with {!Reader.providers}, without parsing anything or allocating more
    than the result.

    Format, version 1, all integers unsigned 32-bit little-endian, offsets from
    the start of the file:
    - header, 64 bytes: magic ["DMI1"], format version, package count, key
      count, offsets of the package table, the key table, the postings and the
      strings, length of the body (everything after the header), the MD5 of the
      body (16 bytes), then zeros;
    - package table, sorted by name: per package, offset and length of its name,
      offset and length of its version;
    - key table, sorted by key: per lowercased module path, offset and length of
      the key, index of its first posting and number of postings;
    - postings: package indices, ascending, without duplicates per key;
    - strings.

    The MD5 checks integrity (the transport is HTTPS); it is verified by
    {!Reader.verify}, which also checks every entry. {!Reader.of_bigarray} only
    checks the header, in constant time, and every later access is
    bounds-checked, so a damaged file can make lookups fail but never read
    outside the mapping. *)

val format_version : int

type package = { name : string; version : string; modules : string list }
(** One package: its name, the version its documentation comes from, and its
    module paths (["Lwt_io"], ["Yojson.Safe"]). *)

module Writer : sig
  val to_string : package list -> string
  (** The index of the given packages. Deterministic: the same packages, in any
      order, give the same bytes. Module paths are keyed case-insensitively;
      duplicates are merged. Raises [Invalid_argument] on duplicate package
      names. *)
end

module Reader : sig
  type t

  type bytes_ =
    (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t

  val of_bigarray : bytes_ -> (t, string) result
  (** Check the header (magic, version, sizes, section bounds), in constant
      time. *)

  val of_string : string -> (t, string) result
  (** {!of_bigarray} on a copy of the string. For tests and tools. *)

  val map_file : string -> (t, string) result
  (** Memory-map a file read-only and {!of_bigarray} it. The file descriptor is
      closed at once; the mapping lives until the GC collects the result. *)

  val verify : t -> (unit, string) result
  (** Check the MD5 of the body, then every table entry: string and posting
      references within bounds, tables sorted, package indices valid. Linear in
      the size of the file and allocating; meant for the process that downloads
      a new index, before it is put in place. *)

  val package_count : t -> int
  val key_count : t -> int

  val providers : t -> string -> string list
  (** [providers t path] are the names of the packages whose documentation
      defines the module [path], compared case-insensitively, in name order. A
      binary search over the keys; allocates only the result. [[]] if the path
      is unknown, or if the index turns out to be damaged. *)

  val packages : t -> (string * string) list
  (** All [(name, version)] pairs, in name order. *)
end
