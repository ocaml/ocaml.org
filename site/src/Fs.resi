type dirent = {name: string}

let isDirectory: dirent => bool

type readdirSyncOptions = {withFileTypes: bool}

let readFileSync: string => 'buffer

let readdirSyncEntries: string => array<dirent>
