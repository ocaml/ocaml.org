// Overwrite the defaults
joo_global_object.__CM__view = require('@codemirror/basic-setup').EditorView;
joo_global_object.__CM__state = require('@codemirror/basic-setup').EditorState;

// Extensions
joo_global_object.__CM__basic_setup = require('@codemirror/basic-setup').basicSetup;
joo_global_object.__CM__markdown = require('@codemirror/lang-markdown').markdown;
joo_global_object.__CM__dark = require('@codemirror/theme-one-dark');
joo_global_object.__CM__stream_parser = require('@codemirror/stream-parser');
joo_global_object.__CM__mllike = require('@codemirror/legacy-modes/mode/mllike').oCaml;