---
packages: []
discussion: |
  - The Earth can be approximated by an ellipsoid defined by the WGS84 reference system. The [Vincety formulae](http://www.movable-type.co.uk/scripts/latlong-vincenty.html) can be used to calculate distance in this system. The following code is translated from [this site](http://walter.bislins.ch/bloge/index.asp?page=WGS84+JavaScript+Module).
---
let pi = 3.14159265356279
let deg2rad angle =
  angle /. 180. *. pi

let sqr a = a *. a

let wgs84_a = 6378137.
let wgs84_b = 6356752.314245
(* flattening = (a-b)/a *)
let wgs84_f = 1. /. 298.257223563


let wgs84_distance lat1 long1 lat2 long2 =
  let lat1  = deg2rad lat1 in
  let lat2  = deg2rad lat2 in
  let long1 = deg2rad long1 in
  let long2 = deg2rad long2 in

  let u1 = atan ((1.-.wgs84_f) *. tan lat1) in
  let u2 = atan ((1.-.wgs84_f) *. tan lat2) in
  
  let delta_long = long2 -. long1 in

  let sin_u1 = sin u1 in
  let cos_u1 = cos u1 in
  let sin_u2 = sin u2 in
  let cos_u2 = cos u2 in

  let rec aux lambda n =
  begin
    if n = 0 then nan
    else
      let sin_lambda = sin lambda in
      let cos_lambda = cos lambda in
      let sin_sigma = 
        sqrt (sqr(cos_u2 *. sin_lambda)
        +. sqr(cos_u1 *. sin_u2 -. sin_u1 *. cos_u2 *. cos_lambda) ) in
      if sin_sigma = 0. then
        0.
      else
        let cos_sigma     = sin_u1 *. sin_u2 +. cos_u1 *. cos_u2 *. cos_lambda in
        let sigma         = atan2 sin_sigma cos_sigma in
        let sin_alpha     = cos_u1 *. cos_u2 *. sin_lambda /. sin_sigma in
        let sqr_cos_alpha = 1. -. sqr sin_alpha in
        let cos_2sigma_m, c =
          if sqr_cos_alpha <> 0. then
            cos_sigma -. 2. *. sin_u1 *. sin_u2 /. sqr_cos_alpha,
            (wgs84_f /. 16.) *. sqr_cos_alpha *. ( 4. +. wgs84_f *. (4. -. 3. *. sqr_cos_alpha) )
          else 
            -1.,
            0. in
        let d = 2. *. sqr cos_2sigma_m -. 1. in
        let e = sigma
          +. c *. sin sigma *. (cos_2sigma_m +. c *. cos_sigma *. d) in
        
        let lambda' = delta_long +. (1. -. c) *. wgs84_f *. sin_alpha *. e in
        if abs_float(lambda -. lambda') > 1e-13 then
          aux lambda' (n-1)
        else
          let sqr_u  = sqr_cos_alpha *. ( (sqr wgs84_a -. sqr wgs84_b) /. sqr wgs84_b ) in
          let v  = sqrt (1. +. sqr_u) in
          let k1 = (v -. 1.) /. (v +. 1.) in
          let sqr_k1 = sqr k1 in

          let a = (1. +. 0.25 *. sqr_k1) /. (1. -. k1) in
          let b = k1 *. (1. -. 0.375 *. sqr_k1) in
          let c = cos_sigma *. d -.
      (b/.6.) *. cos_2sigma_m *. (4. *. sqr sin_sigma -. 3.) *. (4. *. sqr cos_2sigma_m -. 3.) in

          let _sin_lambda  = sin lambda in
          let _cos_lambda  = cos lambda in
          let delta_sigma = b *. sin_sigma *. (cos_2sigma_m +. 0.25 *. b *. c) in

          wgs84_b *. a *. (sigma -. delta_sigma)
  end
  in
    aux delta_long 100

let deg d m s = float_of_int d +. float_of_int m/.60. +. float_of_int s/.3600.

let lat_paris = deg 48 51 24
let long_paris = deg 2 21 07

let lat_marseille = deg 43 17 47
let long_marseille = deg 5 22 12

let d = wgs84_distance lat_paris long_paris lat_marseille long_marseille
let () = Printf.printf "%f m\n" d

