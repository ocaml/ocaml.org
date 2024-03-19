let rec gcd a b = if b = 0 then a else gcd b (a mod b)
let coprime a b = gcd a b = 1
let phi _ = failwith "Not yet implemented"
let factors _ = failwith "Not yet implemented"
let phi_improved _ = failwith "Not yet implemented"
