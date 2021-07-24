module arXiv
using Base: Integer
using LightXML
using HTTP
using Dates

include("types.jl")
include("message.jl")
include("xml2bib.jl")
include("bib2tex.jl")

#TODO: arXiv API allows for AND, OR, and ANDNOT searches allowing for people to use different fields
# It would be slick to incorporate this as well
# one idea would be to do field specific searching so like all= , title=, author= , etc. and concatentate this together,
# but let me know if you can think of anything cleaner. Maybe we can write a search struct
# struct search
#    fields
# end

@doc raw"""
                             Welcome to arXiv.jl!

# default: 
```julia
request(keyword; field = all_fields, sort_by = relevance, sort_order = descending, max_results = 10, filename = "arxiv2bib")
```

# details:
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

# Examples
```jldoctest
julia> request("electron")

julia> request("LaBollita"; field=author, max_results=5)
```
"""
function request(
    keyword::String;
    field::Field = all_fields,
    sort_by::SortBy = relevance,
    sort_order::SortOrder = descending,
    max_results::Integer = 10,
    filename::String = "arxiv2bib",
)
    search_msg(keyword, field, sort_by, sort_order, max_results)
    base = "http://export.arxiv.org/api/query?search_query=$(n2f[field]):"
    base *= "$(keyword)&"
    base *= "sortBy=$(sort_by)&"
    base *= "sortOrder=$(sort_order)&"
    base *= "max_results=$(max_results)"

    r = HTTP.request(:GET, base)
    xmlString = parse_string(String(r.body))
    master = root(xmlString)
    entries = find_all_elements(master, "entry")
    bibs = extract_bib_info(entries)
    bibtex(bibs, filename)
end

export request

end # module
