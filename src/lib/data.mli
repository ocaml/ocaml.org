module Paper : sig
  type t = [%import: Ood.Papers.Paper.t] [@@deriving yaml]

  include S.Data with type t := t
end

module Papers : sig
  type t = [%import: Ood.Papers.t] [@@deriving yaml]

  include S.FileData with type t := t
end
