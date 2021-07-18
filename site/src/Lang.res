type t = [#en | #fr | #es]

let name = (~lang=?, t) => {
  switch (Belt.Option.getWithDefault(lang, t), t) {
  // English
  | (#en, #en) => j`English`
  | (#en, #fr) => j`French`
  | (#en, #es) => j`Spanish`
  // French
  | (#fr, #en) => j`Anglais`
  | (#fr, #fr) => j`Français`
  | (#fr, #es) => j`Espagnol`
  // Spanish
  | (#es, #en) => j`Inglés`
  | (#es, #fr) => j`Francés`
  | (#es, #es) => j`Español`
  }
}

let ofString = t =>
  switch t {
  | "en" => Some(#en)
  | "fr" => Some(#fr)
  | "es" => Some(#es)
  | _ => None
  }

let ofStringExn = t =>
  switch ofString(t) {
  | Some(t) => t
  | None => failwith(`BUG: Unsupported lang: ${t}`)
  }

let toString = t =>
  switch t {
  | #en => "en"
  | #fr => "fr"
  | #es => "es"
  }

let toJson = t => t->toString->Js.Json.string
let ofJson = json => json->Js.Json.decodeString->Belt.Option.flatMap(ofString)
