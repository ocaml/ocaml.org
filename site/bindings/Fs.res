@module("fs") external readFileSync: string => 'buffer = "readFileSync"

@module("fs") external readdirSync: string => array<string> = "readdirSync"
