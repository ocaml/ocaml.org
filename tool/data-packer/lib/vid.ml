(* Video type for scraping - adapted from ood-gen *)

type t = [%import: Data_intf.Video.t] [@@deriving yaml, show]
type video_list = t list [@@deriving yaml, show]
