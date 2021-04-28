module Paper : sig
  type t = [%import: Ood.Paper.t] [@@deriving yaml]

  include S.Data with type t := t
end

module Papers : sig
  type t = Paper.t list [@@deriving yaml]

  include S.FileData with type t := t
end
