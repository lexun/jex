# Used by "mix format"
locals_without_parens = [resolve_with: 1, resolve_with: 2]

[
  export: [locals_without_parens: locals_without_parens],
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  locals_without_parens: locals_without_parens
]
