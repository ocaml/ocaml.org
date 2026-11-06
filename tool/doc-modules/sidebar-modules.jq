# Module paths of an odoc sidebar.json, for tool/doc-modules/scrape.sh.
#
# A path is the chain of module and module type names from the root of the
# sidebar tree; library headers and pages add no segment, and source trees are
# skipped. Only paths of valid OCaml module names are kept (the rule of the
# decoder in tool/data-packer/lib/doc_modules_parser.ml), at most $max_depth
# deep and $max_paths per package, shallowest first, then alphabetically.
# Prints them on one line, separated by spaces; nothing if there are none.

def paths($p):
  .[]
  | (if .node.kind == "module" or .node.kind == "module-type"
     then $p + [.node.content] else $p end) as $q
  | (if $q != $p then $q else empty end),
    (if .node.kind != "source" then (.children | paths($q)) else empty end);

[paths([])]
| map(select(length <= $max_depth
             and all(.[]; test("^[A-Z][A-Za-z0-9_']*$"))))
| map(join("."))
| unique
| sort_by(split(".") | length)
| .[:$max_paths]
| join(" ")
