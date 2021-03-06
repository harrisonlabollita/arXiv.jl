# arXiv.jl
A [Julia](https://julialang.org) wrapper to access the [arXiv API](https://arxiv.org/help/api) and create properly formatted .bib file from the search results.


## About [arXiv API](https://arxiv.org/help/api)

arXiv.jl constructs the api url,

```
http://export.arxiv.org/api/{method_name}?{parameters}
```

and makes an HTTP pull request to get the information and generates the information into a bib file with the proper formatting accepted by most academic journals.


## Installation

```julia
]add arXiv
```

## Examples

Load the arXiv.jl Julia package!

```julia
using arXiv
```

A simple request that will search all search all fields for the keyword = "electron".

```julia
request("electron")
```

Keep an updated bib file with all of your arXiv publications!
```julia
request("LaBollita"; field=author, max_results=5, filename="my_publications")
```

## Contributing
If you have any suggestions or thoughts on how to improve our package please submit and issue or create a pull request. We greatly appreciate it.

## Acknowledgement
Thank you to arXiv for use of its open access interoperability.
