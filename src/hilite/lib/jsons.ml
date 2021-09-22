let ocaml = {|{
  "name": "OCaml",
  "scopeName": "source.ocaml",
  "fileTypes": [
    "ml"
  ],
  "patterns": [
    {
      "include": "#directives"
    },
    {
      "include": "#comments"
    },
    {
      "include": "#strings"
    },
    {
      "include": "#characters"
    },
    {
      "include": "#attributes"
    },
    {
      "include": "#extensions"
    },
    {
      "include": "#signatures"
    },
    {
      "include": "#bindings"
    },
    {
      "include": "#keywords"
    },
    {
      "include": "#operators"
    },
    {
      "include": "#literals"
    },
    {
      "include": "#types"
    },
    {
      "include": "#identifiers"
    }
  ],
  "repository": {
    "directives": {
      "patterns": [
        {
          "comment": "line number directive",
          "begin": "^[[:space:]]*(#)[[:space:]]*([[:digit:]]+)",
          "end": "$",
          "beginCaptures": {
            "1": {
              "name": "keyword.other.ocaml"
            },
            "2": {
              "name": "constant.numeric.decimal.integer.ocaml"
            }
          },
          "contentName": "comment.line.directive.ocaml"
        },
        {
          "comment": "topfind directives",
          "begin": "^[[:space:]]*(#)[[:space:]]*(require|list|camlp4o|camlp4r|predicates|thread)",
          "end": "$",
          "beginCaptures": {
            "1": {
              "name": "keyword.other.ocaml"
            },
            "2": {
              "name": "keyword.other.ocaml"
            }
          },
          "patterns": [
            {
              "include": "#strings"
            }
          ]
        },
        {
          "comment": "cppo directives",
          "begin": "^[[:space:]]*(#)[[:space:]]*(define|undef|ifdef|ifndef|if|else|elif|endif|include|warning|error|ext|endext)",
          "end": "$",
          "beginCaptures": {
            "1": {
              "name": "keyword.other.ocaml"
            },
            "2": {
              "name": "keyword.other.ocaml"
            }
          },
          "patterns": [
            {
              "name": "keyword.other.ocaml",
              "match": "\\b(defined)\\b"
            },
            {
              "name": "keyword.other.ocaml",
              "match": "\\\\"
            },
            {
              "include": "#comments"
            },
            {
              "include": "#strings"
            },
            {
              "include": "#characters"
            },
            {
              "include": "#keywords"
            },
            {
              "include": "#operators"
            },
            {
              "include": "#literals"
            },
            {
              "include": "#types"
            },
            {
              "include": "#identifiers"
            }
          ]
        }
      ]
    },
    "comments": {
      "patterns": [
        {
          "comment": "empty comment",
          "name": "comment.block.ocaml",
          "match": "\\(\\*\\*\\)"
        },
        {
          "comment": "ocamldoc comment",
          "name": "comment.doc.ocaml",
          "begin": "\\(\\*\\*",
          "end": "\\*\\)",
          "patterns": [
            {
              "include": "source.ocaml.ocamldoc#markup"
            },
            {
              "include": "#strings-in-comments"
            },
            {
              "include": "#comments"
            }
          ]
        },
        {
          "comment": "block comment",
          "name": "comment.block.ocaml",
          "begin": "\\(\\*",
          "end": "\\*\\)",
          "patterns": [
            {
              "include": "#strings-in-comments"
            },
            {
              "include": "#comments"
            }
          ]
        }
      ]
    },
    "strings-in-comments": {
      "patterns": [
        {
          "comment": "char literal",
          "match": "'(\\\\)?.'"
        },
        {
          "comment": "string literal",
          "begin": "\"",
          "end": "\""
        },
        {
          "comment": "quoted string literal",
          "begin": "\\{[^|]*\\|",
          "end": "\\|[^}]*\\}"
        }
      ]
    },
    "strings": {
      "patterns": [
        {
          "comment": "quoted string literal",
          "name": "string.quoted.braced.ocaml",
          "begin": "\\{(%%?[[:alpha:]_][[:word:]']*(\\.[[:alpha:]_][[:word:]']*)*[[:space:]]*)?[[:lower:]_]*\\|",
          "end": "\\|[[:lower:]_]*\\}",
          "beginCaptures": {
            "1": {
              "name": "keyword.other.extension.ocaml"
            }
          },
          "patterns": [
            {
              "include": "#strings"
            }
          ]
        },
        {
          "comment": "string literal",
          "name": "string.quoted.double.ocaml",
          "begin": "\"",
          "end": "\"",
          "patterns": [
            {
              "comment": "escaped newline",
              "name": "constant.character.escape.ocaml",
              "match": "\\\\$"
            },
            {
              "comment": "escaped backslash",
              "name": "constant.character.escape.ocaml",
              "match": "\\\\\\\\"
            },
            {
              "comment": "escaped quote or whitespace",
              "name": "constant.character.escape.ocaml",
              "match": "\\\\[\"'ntbr ]"
            },
            {
              "comment": "character from decimal ASCII code",
              "name": "constant.character.escape.ocaml",
              "match": "\\\\[[:digit:]]{3}"
            },
            {
              "comment": "character from hexadecimal ASCII code",
              "name": "constant.character.escape.ocaml",
              "match": "\\\\x[[:xdigit:]]{2}"
            },
            {
              "comment": "character from octal ASCII code",
              "name": "constant.character.escape.ocaml",
              "match": "\\\\o[0-3][0-7]{2}"
            },
            {
              "comment": "unicode character escape sequence",
              "name": "constant.character.escape.ocaml",
              "match": "\\\\u\\{[[:xdigit:]]{1,6}\\}"
            },
            {
              "comment": "printf format string",
              "name": "constant.character.printf.ocaml",
              "match": "%[-0+ #]*([[:digit:]]+|\\*)?(.([[:digit:]]+|\\*))?[lLn]?[diunlLNxXosScCfFeEgGhHBbat!%@,]"
            },
            {
              "comment": "unknown escape sequence",
              "name": "invalid.illegal.unknown-escape.ocaml",
              "match": "\\\\."
            }
          ]
        }
      ]
    },
    "characters": {
      "patterns": [
        {
          "comment": "character literal from escaped backslash",
          "name": "string.quoted.other.ocaml constant.character.ocaml",
          "match": "'(\\\\\\\\)'",
          "captures": {
            "1": {
              "name": "constant.character.escape.ocaml"
            }
          }
        },
        {
          "comment": "character literal from escaped quote or whitespace",
          "name": "string.quoted.other.ocaml constant.character.ocaml",
          "match": "'(\\\\[\"'ntbr ])'",
          "captures": {
            "1": {
              "name": "constant.character.escape.ocaml"
            }
          }
        },
        {
          "comment": "character literal from decimal ASCII code",
          "name": "string.quoted.other.ocaml constant.character.ocaml",
          "match": "'(\\\\[[:digit:]]{3})'",
          "captures": {
            "1": {
              "name": "constant.character.escape.ocaml"
            }
          }
        },
        {
          "comment": "character literal from hexadecimal ASCII code",
          "name": "string.quoted.other.ocaml constant.character.ocaml",
          "match": "'(\\\\x[[:xdigit:]]{2})'",
          "captures": {
            "1": {
              "name": "constant.character.escape.ocaml"
            }
          }
        },
        {
          "comment": "character literal from octal ASCII code",
          "name": "string.quoted.other.ocaml constant.character.ocaml",
          "match": "'(\\\\o[0-3][0-7]{2})'",
          "captures": {
            "1": {
              "name": "constant.character.escape.ocaml"
            }
          }
        },
        {
          "comment": "character literal from unknown escape sequence",
          "name": "string.quoted.other.ocaml constant.character.ocaml",
          "match": "'(\\\\.)'",
          "captures": {
            "1": {
              "name": "invalid.illegal.unknown-escape.ocaml"
            }
          }
        },
        {
          "comment": "character literal",
          "name": "string.quoted.other.ocaml constant.character.ocaml",
          "match": "'.'"
        }
      ]
    },
    "attributes": {
      "begin": "\\[(@|@@|@@@)[[:space:]]*([[:alpha:]_]+(\\.[[:word:]']+)*)",
      "end": "\\]",
      "beginCaptures": {
        "1": {
          "name": "keyword.operator.attribute.ocaml"
        },
        "2": {
          "name": "keyword.other.attribute.ocaml",
          "patterns": [
            {
              "name": "keyword.other.ocaml punctuation.other.period punctuation.separator.period",
              "match": "\\."
            }
          ]
        }
      },
      "patterns": [
        {
          "include": "$self"
        }
      ]
    },
    "extensions": {
      "begin": "\\[(%|%%)[[:space:]]*([[:alpha:]_]+(\\.[[:word:]']+)*)",
      "end": "\\]",
      "beginCaptures": {
        "1": {
          "name": "keyword.operator.extension.ocaml"
        },
        "2": {
          "name": "keyword.other.extension.ocaml",
          "patterns": [
            {
              "name": "keyword.other.ocaml punctuation.other.period punctuation.separator.period",
              "match": "\\."
            }
          ]
        }
      },
      "patterns": [
        {
          "include": "$self"
        }
      ]
    },
    "signatures": {
      "begin": "\\b(sig)\\b",
      "end": "\\b(end)\\b",
      "beginCaptures": {
        "1": {
          "name": "keyword.other.ocaml"
        }
      },
      "endCaptures": {
        "1": {
          "name": "keyword.other.ocaml"
        }
      },
      "patterns": [
        {
          "include": "source.ocaml.interface"
        }
      ]
    },
    "bindings": {
      "patterns": [
        {
          "comment": "for loop",
          "match": "\\b(for)[[:space:]]+([[:lower:]_][[:word:]']*)",
          "captures": {
            "1": {
              "name": "keyword.ocaml"
            },
            "2": {
              "name": "entity.name.function.binding.ocaml"
            }
          }
        },
        {
          "comment": "local open/exception/module",
          "match": "\\b(let)[[:space:]]+(open|exception|module)\\b(?!')",
          "captures": {
            "1": {
              "name": "keyword.ocaml"
            },
            "2": {
              "name": "keyword.ocaml"
            }
          }
        },
        {
          "comment": "let expression",
          "match": "\\b(let)[[:space:]]+(?!lazy\\b(?!'))(rec[[:space:]]+)?([[:lower:]_][[:word:]']*)[[:space:]]+(?!,|::)",
          "captures": {
            "1": {
              "name": "keyword.ocaml"
            },
            "2": {
              "name": "keyword.ocaml"
            },
            "3": {
              "name": "entity.name.function.binding.ocaml"
            }
          }
        },
        {
          "comment": "using binding operators",
          "match": "\\b(let|and)([$&*+\\-/=>@^|<][!?$&*+\\-/=>@^|%:]*)[[:space:]]*(?!lazy\\b(?!'))([[:lower:]_][[:word:]']*)[[:space:]]+(?!,|::)",
          "captures": {
            "1": {
              "name": "keyword.ocaml"
            },
            "2": {
              "name": "keyword.ocaml"
            },
            "3": {
              "name": "entity.name.function.binding.ocaml"
            }
          }
        },
        {
          "comment": "first class module packing",
          "match": "\\([[:space:]]*(val)[[:space:]]+([[:lower:]_][[:word:]']*)",
          "captures": {
            "1": {
              "name": "keyword.ocaml"
            },
            "2": {
              "patterns": [
                {
                  "include": "$self"
                }
              ]
            }
          }
        },
        {
          "comment": "locally abstract types",
          "match": "(?:\\(|(:))[[:space:]]*(type)((?:[[:space:]]+[[:lower:]_][[:word:]']*)+)",
          "captures": {
            "1": {
              "name": "keyword.other.ocaml punctuation.other.colon punctuation.colon"
            },
            "2": {
              "name": "keyword.ocaml"
            },
            "3": {
              "name": "entity.name.function.binding.ocaml"
            }
          }
        },
        {
          "comment": "optional labeled argument with type",
          "begin": "(\\?)\\([[:space:]]*([[:lower:]_][[:word:]']*)",
          "beginCaptures": {
            "1": {
              "name": "variable.parameter.optional.ocaml"
            },
            "2": {
              "name": "variable.parameter.optional.ocaml"
            }
          },
          "end": "\\)",
          "patterns": [
            {
              "include": "$self"
            }
          ]
        },
        {
          "comment": "labeled argument with type",
          "begin": "(~)\\([[:space:]]*([[:lower:]_][[:word:]']*)",
          "beginCaptures": {
            "1": {
              "name": "variable.parameter.labeled.ocaml"
            },
            "2": {
              "name": "variable.parameter.labeled.ocaml"
            }
          },
          "end": "\\)",
          "patterns": [
            {
              "include": "$self"
            }
          ]
        },
        {
          "include": "source.ocaml.interface#bindings"
        }
      ]
    },
    "keywords": {
      "patterns": [
        {
          "comment": "reserved ocaml keyword",
          "name": "keyword.other.ocaml",
          "match": "\\b(and|as|assert|begin|class|constraint|do|done|downto|else|end|exception|external|for|fun|function|functor|if|in|include|inherit|initializer|lazy|let|match|method|module|mutable|new|nonrec|object|of|open|private|rec|sig|struct|then|to|try|type|val|virtual|when|while|with)\\b(?!')"
        }
      ]
    },
    "operators": {
      "patterns": [
        {
          "comment": "binding operator",
          "name": "keyword.operator.ocaml",
          "match": "\\b(let|and)[$&*+\\-/=>@^|<][!?$&*+\\-/=>@^|%:]*"
        },
        {
          "comment": "infix symbol",
          "name": "keyword.operator.ocaml",
          "match": "[$&*+\\-/=>@^%<][~!?$&*+\\-/=>@^|%<:.]*"
        },
        {
          "comment": "infix symbol that begins with vertical bar",
          "name": "keyword.operator.ocaml",
          "match": "\\|[~!?$&*+\\-/=>@^|%<:.]+"
        },
        {
          "comment": "vertical bar",
          "name": "keyword.other.ocaml",
          "match": "(?<!\\[)(\\|)(?!\\])"
        },
        {
          "comment": "infix symbol",
          "name": "keyword.operator.ocaml",
          "match": "#[~!?$&*+\\-/=>@^|%<:.]+"
        },
        {
          "comment": "prefix symbol",
          "name": "keyword.operator.ocaml",
          "match": "![~!?$&*+\\-/=>@^|%<:.]*"
        },
        {
          "comment": "prefix symbol",
          "name": "keyword.operator.ocaml",
          "match": "[?~][~!?$&*+\\-/=>@^|%<:.]+"
        },
        {
          "comment": "named operator",
          "name": "keyword.operator.ocaml",
          "match": "\\b(or|mod|land|lor|lxor|lsl|lsr|asr)\\b"
        },
        {
          "comment": "method invocation",
          "name": "keyword.other.ocaml",
          "match": "#"
        },
        {
          "comment": "type annotation",
          "name": "keyword.other.ocaml punctuation.other.colon punctuation.colon",
          "match": ":"
        },
        {
          "comment": "field accessor",
          "name": "keyword.other.ocaml punctuation.other.period punctuation.separator.period",
          "match": "\\."
        },
        {
          "comment": "semicolon separator",
          "name": "keyword.other.ocaml punctuation.separator.terminator punctuation.separator.semicolon",
          "match": ";"
        },
        {
          "comment": "comma separator",
          "name": "keyword.other.ocaml punctuation.comma punctuation.separator.comma",
          "match": ","
        }
      ]
    },
    "literals": {
      "patterns": [
        {
          "comment": "wildcard underscore",
          "name": "constant.language.ocaml",
          "match": "\\b_\\b"
        },
        {
          "comment": "boolean literal",
          "name": "constant.language.ocaml",
          "match": "\\b(true|false)\\b"
        },
        {
          "comment": "floating point decimal literal with exponent",
          "name": "constant.numeric.decimal.float.ocaml",
          "match": "\\b([[:digit:]][[:digit:]_]*(\\.[[:digit:]_]*)?[eE][+-]?[[:digit:]][[:digit:]_]*[g-zG-Z]?)\\b"
        },
        {
          "comment": "floating point decimal literal",
          "name": "constant.numeric.decimal.float.ocaml",
          "match": "\\b([[:digit:]][[:digit:]_]*\\.[[:digit:]_]*[g-zG-Z]?)\\b"
        },
        {
          "comment": "floating point hexadecimal literal with exponent part",
          "name": "constant.numeric.hexadecimal.float.ocaml",
          "match": "\\b((0x|0X)[[:xdigit:]][[:xdigit:]_]*(\\.[[:xdigit:]_]*)?[pP][+-]?[[:digit:]][[:digit:]_]*[g-zG-Z]?)\\b"
        },
        {
          "comment": "floating point hexadecimal literal",
          "name": "constant.numeric.hexadecimal.float.ocaml",
          "match": "\\b((0x|0X)[[:xdigit:]][[:xdigit:]_]*\\.[[:xdigit:]_]*[g-zG-Z]?)\\b"
        },
        {
          "comment": "decimal integer literal",
          "name": "constant.numeric.decimal.integer.ocaml",
          "match": "\\b([[:digit:]][[:digit:]_]*[lLng-zG-Z]?)\\b"
        },
        {
          "comment": "hexadecimal integer literal",
          "name": "constant.numeric.hexadecimal.integer.ocaml",
          "match": "\\b((0x|0X)[[:xdigit:]][[:xdigit:]_]*[lLng-zG-Z]?)\\b"
        },
        {
          "comment": "octal integer literal",
          "name": "constant.numeric.octal.integer.ocaml",
          "match": "\\b((0o|0O)[0-7][0-7_]*[lLng-zG-Z]?)\\b"
        },
        {
          "comment": "binary integer literal",
          "name": "constant.numeric.binary.integer.ocaml",
          "match": "\\b((0b|0B)[0-1][0-1_]*[lLng-zG-Z]?)\\b"
        },
        {
          "comment": "unit literal",
          "name": "constant.language.ocaml strong",
          "match": "\\(\\)"
        },
        {
          "comment": "parentheses",
          "begin": "\\(",
          "end": "\\)",
          "patterns": [
            {
              "include": "$self"
            }
          ]
        },
        {
          "comment": "empty array",
          "name": "constant.language.ocaml strong",
          "match": "\\[\\|\\|\\]"
        },
        {
          "comment": "array",
          "begin": "\\[\\|",
          "end": "\\|\\]",
          "patterns": [
            {
              "include": "$self"
            }
          ]
        },
        {
          "comment": "empty list",
          "name": "constant.language.ocaml strong",
          "match": "\\[\\]"
        },
        {
          "comment": "list",
          "begin": "\\[",
          "end": "]",
          "patterns": [
            {
              "include": "$self"
            }
          ]
        }
      ]
    },
    "types": {
      "patterns": [
        {
          "comment": "type parameter",
          "name": "storage.type.ocaml",
          "match": "'[[:alpha:]][[:word:]']*\\b"
        },
        {
          "comment": "builtin type",
          "name": "support.type.ocaml",
          "match": "\\b(unit|bool|int|int32|int64|nativeint|float|char|bytes|string)\\b"
        }
      ]
    },
    "identifiers": {
      "patterns": [
        {
          "comment": "capital identifier for constructor, exception, or module",
          "name": "constant.language.capital-identifier.ocaml",
          "match": "\\b[[:upper:]][[:word:]']*('|\\b)"
        },
        {
          "comment": "lowercase identifier",
          "name": "source.ocaml",
          "match": "\\b[[:lower:]_][[:word:]']*('|\\b)"
        },
        {
          "comment": "polymorphic variant tag",
          "name": "constant.language.polymorphic-variant.ocaml",
          "match": "\\`[[:alpha:]][[:word:]']*\\b"
        },
        {
          "comment": "empty list (can be used as a constructor)",
          "name": "constant.language.ocaml strong",
          "match": "\\[\\]"
        }
      ]
    }
  }
}|}

let dune = {|{
  "name": "dune",
  "scopeName": "source.dune",
  "fileTypes": [
    "dune",
    "jbuild"
  ],
  "patterns": [
    {
      "include": "#comments"
    },
    {
      "name": "meta.stanza.dune",
      "begin": "\\([[:space:]]*(library|rule|executable|executables|rule|ocamllex|ocamlyacc|menhir|install|alias|copy_files|copy_files#|jbuild_version|include)[[:space:]]",
      "end": "\\)",
      "beginCaptures": {
        "1": {
          "name": "meta.class.stanza.dune"
        }
      },
      "patterns": [
        {
          "include": "$self"
        }
      ]
    },
    {
      "name": "meta.stanza.library.field.dune",
      "begin": "\\([[:space:]]*(name|public_name|synopsis|install_c_headers|ppx_runtime_libraries|c_flags|cxx_flags|c_names|cxx_names|library_flags|c_library_flags|virtual_deps|modes|kind|wrapped|optional|self_build_stubs_archive|no_dynlink|ppx\\.driver)[[:space:]]",
      "end": "\\)",
      "beginCaptures": {
        "1": {
          "name": "keyword.other.dune"
        }
      },
      "patterns": [
        {
          "include": "$self"
        }
      ]
    },
    {
      "name": "meta.stanza.rule.dune",
      "begin": "\\([[:space:]]*(targets|deps|locks|loc|mode|action)[[:space:]]",
      "beginCaptures": {
        "1": {
          "name": "keyword.other.dune"
        }
      },
      "end": "\\)",
      "patterns": [
        {
          "include": "$self"
        }
      ]
    },
    {
      "name": "meta.mono-sexp.dune",
      "match": "\\([[:space:]]*(fallback|optional)[[:space:]]*\\)",
      "captures": {
        "1": {
          "name": "keyword.other.dune"
        }
      }
    },
    {
      "name": "meta.stanza.rule.action.dune",
      "begin": "\\([[:space:]]*(run|chdir|setenv|with-stdout-to|with-stderr-to|with-outputs-to|ignore-stdout|ignore-stderr|ignore-outputs|progn|echo|cat|copy|copy#|system|bash|write-file|diff|diff\\?)[[:space:]]",
      "end": "\\)",
      "beginCaptures": {
        "1": {
          "name": "entity.name.function.action.dune"
        }
      },
      "patterns": [
        {
          "include": "$self"
        }
      ]
    },
    {
      "name": "meta.stanza.install.dune",
      "begin": "\\([[:space:]]*(section)[[:space:]]",
      "end": "\\)",
      "beginCaptures": {
        "1": {
          "name": "keyword.other.dune"
        }
      },
      "patterns": [
        {
          "name": "constant.language.rule.mode.dune",
          "match": "\\b(lib|libexec|bin|sbin|toplevel|share|share_root|etc|doc|stublibs|man|misc)\\b"
        }
      ]
    },
    {
      "name": "meta.stanza.install.dune",
      "begin": "\\([[:space:]]*(files)[[:space:]]",
      "end": "\\)",
      "beginCaptures": {
        "1": {
          "name": "keyword.other.dune"
        }
      },
      "patterns": [
        {
          "include": "$self"
        }
      ]
    },
    {
      "name": "meta.library.kind.dune",
      "begin": "\\([[:space:]]*(normal|ppx_deriver|ppx_rewriter)[[:space:]]",
      "end": "\\)",
      "beginCaptures": {
        "1": {
          "name": "constant.language.rule.mode.dune"
        }
      }
    },
    {
      "name": "meta.stanza.executables.dune",
      "begin": "\\([[:space:]]*(name|link_executables|link_flags|modes)[[:space:]]",
      "end": "\\)",
      "beginCaptures": {
        "1": {
          "name": "keyword.other.dune"
        }
      },
      "patterns": [
        {
          "include": "$self"
        }
      ]
    },
    {
      "name": "meta.stanza.lib-or-exec.buildable.dune",
      "begin": "\\([[:space:]]*(preprocess|preprocessor_deps|lint|modules|modules_without_implementation|libraries|flags|ocamlc_flags|ocamlopt_flags|js_of_ocaml|allow_overlapping_dependencies|per_module)[[:space:]]",
      "end": "\\)",
      "beginCaptures": {
        "1": {
          "name": "keyword.other.dune"
        }
      },
      "patterns": [
        {
          "include": "$self"
        }
      ]
    },
    {
      "name": "meta.stanza.lib-or-exec.buildable.preprocess.dune",
      "begin": "\\([[:space:]]*(no_preprocessing|action|pps)[[:space:]]",
      "end": "\\)",
      "beginCaptures": {
        "1": {
          "name": "keyword.other.dune"
        }
      },
      "patterns": [
        {
          "include": "$self"
        }
      ]
    },
    {
      "name": "meta.stanza.lib-or-exec.buildable.preprocess_deps.dune",
      "begin": "\\([[:space:]]*(file|alias|alias_rec|glob_files|files_recursively_in)[[:space:]]",
      "end": "\\)",
      "beginCaptures": {
        "1": {
          "name": "keyword.other.dune"
        }
      },
      "patterns": [
        {
          "include": "$self"
        }
      ]
    },
    {
      "name": "meta.stanza.lib-or-exec.buildable.libraries.dune",
      "begin": "\\([[:space:]]*(select)[[:space:]]",
      "end": "\\)",
      "beginCaptures": {
        "1": {
          "name": "keyword.other.dune"
        }
      },
      "patterns": [
        {
          "include": "$self"
        }
      ]
    },
    {
      "name": "constant.numeric.dune",
      "match": "\\b\\d+\\b"
    },
    {
      "name": "constant.language.dune",
      "match": "(true|false)"
    },
    {
      "name": "keyword.other.dune",
      "match": "[[:space:]](as|from|->)[[:space:]]"
    },
    {
      "name": "keyword.other.dune",
      "match": "(\\!)"
    },
    {
      "name": "constant.language.flag.dune",
      "match": "(:\\w+)\\b"
    },
    {
      "name": "constant.language.rule.mode.dune",
      "match": "\\b(standard|fallback|promote|promote-until-then)\\b"
    },
    {
      "include": "#string"
    },
    {
      "include": "#variable"
    },
    {
      "include": "#list"
    },
    {
      "include": "#atom"
    }
  ],
  "repository": {
    "comments": {
      "patterns": [
        {
          "name": "comment.block.dune",
          "begin": "#\\|",
          "beginCaptures": {
            "0": {
              "name": "punctuation.definition.comment.begin.dune"
            }
          },
          "end": "\\|#",
          "endCaptures": {
            "0": {
              "name": "punctuation.definition.comment.end.dune"
            }
          },
          "patterns": [
            {
              "include": "#comments"
            }
          ]
        },
        {
          "name": "comment.sexp.dune",
          "begin": "#;[[:space:]]*\\(",
          "end": "\\)",
          "patterns": [
            {
              "include": "#comment-inner"
            }
          ]
        },
        {
          "name": "comment.line.dune",
          "match": ";.*$"
        }
      ]
    },
    "comment-inner": {
      "patterns": [
        {
          "name": "comment.sexp.inner.dune",
          "begin": "\\(",
          "end": "\\)",
          "patterns": [
            {
              "include": "#comment-inner"
            }
          ]
        }
      ]
    },
    "string": {
      "patterns": [
        {
          "name": "string.quoted.double.dune",
          "begin": "(?=[^\\\\])(\")",
          "beginCaptures": {
            "1": {
              "name": "punctuation.definition.string.begin.dune"
            }
          },
          "end": "(\")",
          "endCaptures": {
            "1": {
              "name": "punctuation.definition.string.end.dune"
            }
          },
          "patterns": [
            {
              "name": "constant.character.string.escape.dune",
              "match": "\\\\\""
            },
            {
              "include": "#variable"
            }
          ]
        }
      ]
    },
    "variable": {
      "patterns": [
        {
          "name": "variable.other.dune",
          "match": "\\${[^}]*}"
        }
      ]
    },
    "list": {
      "patterns": [
        {
          "name": "meta.list.dune",
          "begin": "(\\()",
          "end": "(\\))",
          "captures": {
            "1": {
              "name": "entity.tag.list.parenthesis.dune"
            }
          },
          "comment": "ok, for this one, I didn't know what to choose",
          "patterns": [
            {
              "include": "$self"
            }
          ]
        }
      ]
    },
    "atom": {
      "patterns": [
        {
          "name": "meta.atom.dune",
          "match": "\\b[^[[:space:]]]+\\b"
        }
      ]
    }
  }
}|}

let opam = {|{
  "name": "opam",
  "scopeName": "source.ocaml.opam",
  "fileTypes": [
    "opam"
  ],
  "patterns": [
    {
      "include": "#comments"
    },
    {
      "include": "#fields"
    },
    {
      "include": "#values"
    }
  ],
  "repository": {
    "comments": {
      "patterns": [
        {
          "comment": "block comment",
          "name": "comment.block.opam",
          "begin": "\\(\\*",
          "end": "\\*\\)"
        },
        {
          "comment": "line comment",
          "name": "comment.line.opam",
          "begin": "#",
          "end": "$"
        }
      ]
    },
    "fields": {
      "comment": "labeled field",
      "match": "^([[:word:]-]*[[:alpha:]][[:word:]-]*)(:)",
      "captures": {
        "1": {
          "name": "entity.name.tag.opam"
        },
        "2": {
          "name": "keyword.operator.opam"
        }
      }
    },
    "values": {
      "patterns": [
        {
          "comment": "boolean literal",
          "name": "constant.language.opam",
          "match": "\\b(true|false)\\b"
        },
        {
          "comment": "integer literal",
          "name": "constant.numeric.decimal.opam",
          "match": "(\\b|\\-?)[[:digit:]]+\\b"
        },
        {
          "comment": "double-quote string literal",
          "name": "string.quoted.double.opam",
          "begin": "\"",
          "end": "\"",
          "patterns": [
            {
              "include": "#string-elements"
            }
          ]
        },
        {
          "comment": "triple-double-quote string literal",
          "name": "string.quoted.triple-double.opam",
          "begin": "\"\"\"",
          "end": "\"\"\"",
          "patterns": [
            {
              "include": "#string-elements"
            }
          ]
        },
        {
          "comment": "operator",
          "name": "keyword.operator.opam",
          "match": "[!=<>\\|&?:]+"
        },
        {
          "comment": "identifier",
          "match": "\\b([[:word:]+-]+)\\b",
          "name": "variable.parameter.opam"
        }
      ]
    },
    "string-elements": {
      "patterns": [
        {
          "comment": "escaped backslash",
          "name": "constant.character.escape.opam",
          "match": "\\\\\\\\"
        },
        {
          "comment": "escaped quote or whitespace",
          "name": "constant.character.escape.opam",
          "match": "\\\\[\"ntbr\\n]"
        },
        {
          "comment": "character from decimal ASCII code",
          "name": "constant.character.escape.opam",
          "match": "\\\\[[:digit:]]{3}"
        },
        {
          "comment": "character from hexadecimal ASCII code",
          "name": "constant.character.escape.opam",
          "match": "\\\\x[[:xdigit:]]{2}"
        },
        {
          "comment": "variable interpolation",
          "name": "constant.variable.opam",
          "begin": "%\\{",
          "end": "}\\%"
        },
        {
          "comment": "unknown escape sequence",
          "name": "invalid.illegal.unknown-escape.opam",
          "match": "\\\\."
        }
      ]
    }
  }
}|}

