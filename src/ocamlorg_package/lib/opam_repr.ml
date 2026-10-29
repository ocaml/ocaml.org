(* [Repr] combinators for the opam leaf types and opam maps that appear in the
   persisted package state. These are not derivable by [ppx_repr] (the opam
   types are abstract / live in another library), so they are written once here
   and shared by [Info], [Packages_stats], and [Ocamlorg_package]. *)

let name : OpamPackage.Name.t Repr.t =
  Repr.map Repr.string OpamPackage.Name.of_string OpamPackage.Name.to_string

let version : OpamPackage.Version.t Repr.t =
  Repr.map Repr.string OpamPackage.Version.of_string
    OpamPackage.Version.to_string

let package_flag : OpamTypes.package_flag Repr.t =
  Repr.map Repr.string OpamTypesBase.pkg_flag_of_string
    OpamTypesBase.string_of_pkg_flag

(* Generic combinator for an OpamStd map, (de)serialized through its bindings.
   [bindings] yields a sorted list and decoding rebuilds via [add], so the
   round-trip is order-insensitive. *)
let map ~empty ~add ~bindings k_repr v_repr =
  Repr.map
    (Repr.list (Repr.pair k_repr v_repr))
    (List.fold_left (fun m (k, v) -> add k v m) empty)
    bindings
