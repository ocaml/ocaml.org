type t

val all_packages_latest
  :  unit
  -> (OpamPackage.Version.t * Package.Info.t) OpamPackage.Name.Map.t Lwt.t

val get_package
  :  OpamPackage.Name.t
  -> Package.Info.t OpamPackage.Version.Map.t Lwt.t

val get_package_opt
  :  OpamPackage.Name.t
  -> Package.Info.t OpamPackage.Version.Map.t option Lwt.t

val docs : unit -> Documentation.t
