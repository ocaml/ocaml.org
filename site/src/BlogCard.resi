open! Import

module Entry: {
  type t = {
    title: string,
    excerpt: string,
    author: string,
    dateValue: string,
    date: string,
    readingTime: string,
  }
}

@react.component
let make: (
  ~header: string,
  ~description: string,
  ~blog: string,
  ~archiveText: string,
  ~children: (Entry.t, Entry.t, Entry.t),
) => React.element
