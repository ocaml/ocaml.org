module type Data = sig
  type t

  val lint : string -> (t, [ `Msg of string ]) result
end

module type FileData = sig
  type t

  include Data with type t := t

  val path : string
end

module type FolderData = sig
  type t

  include Data with type t := t

  val path : string
end
