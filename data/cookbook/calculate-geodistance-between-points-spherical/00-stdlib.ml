---
packages: []
discussion: |
  - The Earth surface can be approximated by a 6371 km sphere. Calculating distance between 2 points can be done with the Haversine formula. See [this page](https://www.movable-type.co.uk/scripts/latlong.html).
---
let pi = 3.14159265356279
let deg2rad angle =
  angle /. 180. *. pi

let sqr a = a *. a

let haversine_distance lat1 lon1 lat2 lon2 =
  let r = 6371. in
  let dLat = deg2rad(lat2-.lat1) in
  let dLon = deg2rad(lon2-.lon1) in 
  let a = 
    sqr (sin(dLat/.2.))
    +. cos(deg2rad lat1) *. cos(deg2rad lat2) *. sqr (sin(dLon/.2.))
  in
  let c = 2. *. atan2 (sqrt a) (sqrt(1.-.a)) in 
  r *. c


let deg d m s = float_of_int d +. float_of_int m/.60. +. float_of_int s/.3600.

let lat_paris = deg 48 51 24
let long_paris = deg 2 21 07

let lat_marseille = deg 43 17 47
let long_marseille = deg 5 22 12

let d = haversine_distance lat_paris long_paris lat_marseille long_marseille
let () = Printf.printf "%f km\n" d
