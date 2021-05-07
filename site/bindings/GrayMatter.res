type extracted = {data: Js.Json.t, content: string}

@module("gray-matter") external matter: string => extracted = "default"

type pageContent = {
  title: string,
  pageDescription: option<string>,
}

type output = {data: pageContent, content: string}

let decode = json => {
  open Json.Decode
  {
    title: json |> field("title", string),
    pageDescription: json |> optional(field("pageDescription", string)),
  }
}

let ofMarkdown = fileContents => {
  let parsed = matter(fileContents)
  let pageContent = parsed.data->decode
  {
    data: pageContent,
    content: parsed.content,
  }
}
