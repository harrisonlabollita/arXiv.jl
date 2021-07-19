module arXiv
using HTTP
using LightXML


function find_all_elements(x::XMLElement, n::AbstractString)
    matched = []
    for c in child_elements(x)
        name(c) == n && push!(matched, c)
    end
    return matched
end

function extract_bib_info(Entries::Array)
    bibs = []
    for entry in Entries
        bibDict = Dict()
        url = strip(content(find_element(entry, "id")))
        bibDict["year"] = content(find_element(entry, "published"))[1:4]
        bibDict["url"] = url
        bibDict["authors"] =
            [strip(content(el)) for el in find_all_elements(entry, "author")]
	first_author = split(bibDict["authors"][1], " ")
	bibDict["key"]     = first_author[findmax(length.(first_author))[2]] * bibDict["year"]
        bibDict["journal"] = "arXiv:$(url[22:end])"  # TODO: this is rigid; might not always work
        bibDict["title"] = content(find_element(entry, "title"))
        push!(bibs, bibDict)
    end
    return bibs
end

function request(
    search::String;
    field = "all",
    sortBy = nothing,
    sortOrder = nothing,
    max_results = nothing,
)
    println("\narXiv.jl: processing request...")
    println("searching $(field) for $(search) with the settings:")
    println("sortBy = $(sortBy)")
    println("sortOrder = $(sortOrder)")
    println("max_results = $(max_results)\n")
    base = "http://export.arxiv.org/api/query?search_query=$(field):"
    base *= "$(search)&"
    if !isnothing(sortBy)
        base *= "sortBy=$(sortBy)&"
    end
    if !isnothing(sortOrder)
        base *= "sortOrder=$(sortOrder)&"
    end
    if !isnothing(max_results)
        base *= "max_results=$(max_results)"
    end
    r = HTTP.request(:GET, base)
    xmlString = parse_string(String(r.body))
    master = root(xmlString)
    entries = find_all_elements(master, "entry")
    bib = extract_bib_info(entries)
    println("writing results to bib file")
    bibtex(bib)
end

function bibtex(bibs::Array; dir = nothing)
    if isnothing(dir)
        open("arxiv2bib.bib", "w") do io
            for bib in bibs
                write(io, "\n")
                write(io, "@article{$(bib["key"]),\n")
		write(io, "title={$(bib["title"])},\n")
                authorList = ""
                for (a, author) in enumerate(bib["authors"])
                    if a != length(bib["authors"])
                        authorList *= "$(author) and "
                    else
                        authorList *= "$(author)"
                    end
                end
                write(io, "author={$(authorList)},\n")
                write(io, "year={$(bib["year"])},\n")
                write(io, "journal={$(bib["journal"])},\n")
                write(io, "url={$(bib["url"])}\n")
                write(io, "}\n")
                write(io, "\n")
            end
        end
    end
end
export request
end # module
