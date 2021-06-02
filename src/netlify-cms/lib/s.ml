module type Widget = sig
  type t [@@deriving yaml]

  val widget_name : string
end
