type dirent = {name: string}

@send external isDirectory: dirent => bool = "isDirectory"

type readdirSyncOptions = {withFileTypes: bool}

@module("fs") external readFileSync: string => 'buffer = "readFileSync"

@module("fs") external readdirSync: (string, readdirSyncOptions) => array<dirent> = "readdirSync"

let readdirSyncEntries = path => readdirSync(path, {withFileTypes: true})
