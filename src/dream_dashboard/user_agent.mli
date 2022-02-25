type t = {
  ua_family : string;
  ua_major : string option;
  ua_minor : string option;
  ua_patch : string option;
  os_family : string;
  os_major : string option;
  os_minor : string option;
  os_patch : string option;
  os_patch_minor : string option;
  device_family : string;
  device_brand : string option;
  device_model : string option;
}

val parse : string -> t
val is_bot : t -> bool
