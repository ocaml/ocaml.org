type output = {data: Js.Json.t, content: string}

@module("gray-matter") external matter: string => output = "default"
