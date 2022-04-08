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

let uaparser = User_agent_parser.init ()

let parse s =
  let parsed = User_agent_parser.parse uaparser s in
  let open User_agent_parser in
  let open User_agent_parser.UAParser in
  let open User_agent_parser.OSParser in
  let open User_agent_parser.DeviceParser in
  {
    ua_family = parsed.ua.family;
    ua_major = parsed.ua.major;
    ua_minor = parsed.ua.minor;
    ua_patch = parsed.ua.patch;
    os_family = parsed.os.family;
    os_major = parsed.os.major;
    os_minor = parsed.os.minor;
    os_patch = parsed.os.patch;
    os_patch_minor = parsed.os.patch_minor;
    device_family = parsed.device.family;
    device_brand = parsed.device.brand;
    device_model = parsed.device.model;
  }

let is_bot t =
  let is_google_bot () =
    let regex =
      Str.regexp
        "Googlebot\\(-Mobile\\|-Image\\|-Video\\|-News\\)?\\|Feedfetcher-Google\\|Google-Test\\|Google-Site-Verification\\|Google \
         Web \
         Preview\\|AdsBot-Google\\(-Mobile\\)?\\|Mediapartners-Google\\|Google.*/\\+/web/snippet\\|GoogleProducer"
    in
    Str.string_match regex t.ua_family 0
  in
  let is_generic_bot () =
    let regex =
      Str.regexp
        "[a-z0-9\\-_]*\\(bot\\|crawler\\|archiver\\|transcoder\\|spider\\)"
    in
    Str.string_match regex t.ua_family 0
  in
  if is_google_bot () then true else if is_generic_bot () then true else false
