module Packages =
[%graphql
{| 
{
 static_files_endpoint
 packages {
   versions {
     name
     version
     status
     blessed_universe
     universes {
       status
     }
   }
 }
}
|}]

module Last_update = [%graphql {| 
{
 last_update
}
|}]
