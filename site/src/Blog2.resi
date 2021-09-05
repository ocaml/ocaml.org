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
  ~entries: array<Entry.t>,
  ~archiveText: string,
) => React.element
