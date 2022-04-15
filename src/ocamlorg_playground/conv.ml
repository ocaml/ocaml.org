(* Brr_rpc_helper *)

(** Conversion functions for turning {!Rpc.t} into {!Jv.t} and vice-versa *)

open Js_top_worker_rpc
(** These are independent of any particular API being implemented, and should be
    part of the rpc library ideally. *)

module Conv : sig
  type t = Js_top_worker_rpc.Rpc.t

  val to_jv : t -> Jv.t
  val of_jv : Jv.t -> t

  (** include Jv.CONV with type t := Rpc.t -- causes an error *)
end = struct
  type t = Rpc.t

  let rec to_jv rpc =
    let mk ty v = Jv.obj [| ("ty", Jv.of_string ty); ("v", v) |] in
    match rpc with
    | Rpc.Int i -> mk "int" (Jv.of_int (Int64.to_int i))
    | Int32 i -> mk "int32" (Jv.of_int (Int32.to_int i))
    | Bool b -> mk "bool" (Jv.of_bool b)
    | Float f -> mk "float" (Jv.of_float f)
    | String s -> mk "string" (Jv.of_string s)
    | DateTime s -> mk "datetime" (Jv.of_string s)
    | Enum xs -> mk "enum" (Jv.of_jv_list (List.map to_jv xs))
    | Dict xs ->
        (* make a special property '__keys__' that is a list of all the keys *)
        let keys = Jv.of_jv_list (List.map Jv.of_string (List.map fst xs)) in
        let l = List.map (fun (k, v) -> (k, to_jv v)) xs in
        mk "dict" (Jv.obj (Array.of_list (("__keys__", keys) :: l)))
    | Base64 x -> mk "base64" (Jv.of_string x)
    | Null -> mk "null" Jv.false'

  let rec of_jv jv =
    let ty = Jv.get jv "ty" |> Jv.to_string in
    let v = Jv.get jv "v" in
    match ty with
    | "int" -> Rpc.Int (Int64.of_int (Jv.to_int v))
    | "int32" -> Rpc.Int32 (Int32.of_int (Jv.to_int v))
    | "bool" -> Rpc.Bool (Jv.to_bool v)
    | "float" -> Rpc.Float (Jv.to_float v)
    | "string" -> Rpc.String (Jv.to_string v)
    | "datetime" -> Rpc.DateTime (Jv.to_string v)
    | "enum" -> Rpc.Enum (Jv.to_list of_jv v)
    | "dict" ->
        let keys = Jv.to_list Jv.to_string (Jv.get v "__keys__") in
        let kvs = List.map (fun k -> (k, of_jv (Jv.get v k))) keys in
        Rpc.Dict kvs
    | "base64" -> Base64 (Jv.to_string v)
    | "null" -> Null
    | _ -> failwith "Unknown type"
end

let jv_of_rpc_call : Rpc.call -> Jv.t =
 fun call ->
  Jv.obj
    [|
      ("name", Jv.of_string call.name);
      ("params", Jv.of_list Conv.to_jv call.params);
      ("is_notification", Jv.of_bool call.is_notification);
    |]

let rpc_call_of_jv : Jv.t -> Rpc.call =
 fun jv ->
  let name = Jv.get jv "name" |> Jv.to_string in
  let params = Jv.get jv "params" |> Jv.to_list Conv.of_jv in
  let is_notification = Jv.get jv "is_notification" |> Jv.to_bool in
  { name; params; is_notification }

let jv_of_rpc_response : Rpc.response -> Jv.t =
 fun response ->
  Jv.obj
    [|
      ("success", Jv.of_bool response.success);
      ("contents", Conv.to_jv response.contents);
      ("is_notification", Jv.of_bool response.is_notification);
    |]

let rpc_response_of_jv : Jv.t -> Rpc.response =
 fun jv ->
  let success = Jv.get jv "success" |> Jv.to_bool in
  let contents = Jv.get jv "contents" |> Conv.of_jv in
  let is_notification = Jv.get jv "is_notification" |> Jv.to_bool in
  { success; contents; is_notification }
