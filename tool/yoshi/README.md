# Yoshi

Yoshi is a command-line tool and library that generates OCaml modules from YAML and Markdown data based on user-defined configurations. It simplifies the process of converting structured data in YAML format into OCaml types and values, making it easy to integrate the data into your OCaml projects.

## Usage

The `yoshi` command-line can be used to generate OCaml modules from YAML data based on a provided configuration file. The basic usage is as follows:

```
yoshi INPUT_FILE [-c CONFIG_FILE] [-o OUTPUT_FILE]
```

- `INPUT_FILE`: Path to the input YAML file containing the data.
- `CONFIG_FILE`: Path to the YAML configuration file that defines the data structure.
- `OUTPUT_FILE` (optional): Path to the output OCaml module file.

If no output file is specified, the generated code will be printed to stdout.

## Example

Suppose you have the following YAML configuration file (`config.yaml`):

```yaml
data:
  - name: videos
    source: input.yaml
    format: yaml
    fields:
      - name: title
        type: string
      - name: author
        type: string
      - name: duration
        type: int
```

And an input YAML file (`input.yaml`) with the following data:

```yaml
- title: "Example Video"
  author: "John Doe"
  duration: 120
```

Using the `yoshi` tool, you can generate an OCaml module with the following command:

```
yoshi -c config.yaml -o output.ml input.yaml
```

The generated `output.ml` file will contain the following OCaml code:


```ocaml
type video = {
  title : string;
  author : string;
  duration : int;
}

let videos = [
  {
    title = "Example Video";
    author = "John Doe";
    duration = 120;
  }
]
```

## Contributing

Contributions to Yoshi are welcome!

## License

Yoshi is released under the ISC License. See the LICENSE file for more details.
