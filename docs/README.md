
# Welcome to arXiv.jl!

## default: 
```julia
request(keyword; field=all_fields, sort_by=relevance, sort_order=descending, max_results=10, filename="arxiv2bib")
```

## details:
`keyword`     A string defining your search request to the arXiv API.

`field`      Field options for your search include: 
						    `title`,
						    `author`,
						    `abstract`,
						    `comment`,
						    `jour_ref` (journal reference),
						    `report_num` (report number),
						    `id_list`,
						    `all_fields`.

`sort_by`     You can sort your results by `relevance`, `lastUpdatedDate`, and `submittedDate`.

`sort_order`  You can sort your results in order of `ascending`, `descending`.

`max_results` An integer defining the maximum number of results we should fetch.

`filename`    Default filename for the generated bib file is arxiv2bib.

## Examples
```jldoctest
julia> request("electron")

julia> request("LaBollita"; field=author, max_results=5, filename="my_publications")
```

# PRs are welcome!
