type pageContent = {
  title: string,
  pageDescription: option<string>,
}

type output = {data: pageContent, content: string}

let ofMarkdown: string => output
