module arXiv
using Base: Integer
using HTTP
using LightXML
using Dates

macro exported_enum(name, args...)
    esc(quote
        @enum($name, $(args...))
        export $name
        $([:(export $arg) for arg in args]...)
    end)
end

@exported_enum SortBy relevance lastUpdatedDate submittedDate
@exported_enum SortOrder ascending descending
@exported_enum Field title author abstract comment jour_ref report_num id_list all_fields

n2f = Dict(
    title	=> "ti",
    author      => "au",
    abstract    => "abs",
    comment     => "co",
    jour_ref    => "jr",
    report_num  => "rn",
    id_list     => "id",
    all_fields  => "all"
)


include("print_fxn.jl")


struct bib_info 
    url::String
    year::String
    authors::Array{String, 1}
    title::String
    key::String
    journal::String
end

#TODO: arXiv API allows for AND, OR, and ANDNOT searches allowing for people to use different fields
# It would be slick to incorporate this as well
# one idea would be to do field specific searching so like all= , title=, author= , etc. and concatentate this together,
# but let me know if you can think of anything cleaner. Maybe we can write a search struct
# struct search
#    fields
# end

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
        url = strip(content(find_element(entry, "id")))
	year = content(find_element(entry, "published"))[1:4]
	authors = [strip(content(el)) for el in find_all_elements(entry, "author")]
        title = content(find_element(entry, "title"))
        first_author = split(authors[1], " ")
	key = first_author[findmax(length.(first_author))[2]] * year * title[1:4]
        journal = "arXiv:$(url[22:end])" # TODO: this is rigid; might not always work

	push!(bibs, bib_info(url, year, authors, title, key, journal))
    end
    return bibs
end

function request(
    search::String;
    field::Field = all_fields,
    sort_by::SortBy = relevance,
    sort_order::SortOrder = descending,
    max_results::Integer = 10,
    filename::String = "arxiv2bib",
)
    print_searching(search, field, sort_by, sort_order, max_results)
    base = "http://export.arxiv.org/api/query?search_query=$(n2f[field]):"
    base *= "$(search)&"
    base *= "sortBy=$(sort_by)&"
    base *= "sortOrder=$(sort_order)&"
    base *= "max_results=$(max_results)"

    r = HTTP.request(:GET, base)
    xmlString = parse_string(String(r.body))
    master = root(xmlString)
    entries = find_all_elements(master, "entry")
    bib = extract_bib_info(entries)
    bibtex(bib, filename)
end

function bibtex(bibs::Array, filename::String)
    io = open("$(filename).bib", "a")
    println("writing results to $(filename).bib")

    write(io, "generated by arXiv.jl on $(Dates.now())\n")
    for bib in bibs
        write(io, "\n")
        write(io, "@article{$(bib.key),\n")
        write(io, "title={$(bib.title)},\n")
        author_list = ""
        for (a, author) in enumerate(bib.authors)
            if a != length(bib.authors)
                author_list *= "$(author) and "
            else
                author_list *= "$(author)"
            end
        end
        write(io, "author={$(author_list)},\n")
        write(io, "year={$(bib.year)},\n")
        write(io, "journal={$(bib.journal)},\n")
        write(io, "url={$(bib.url)}\n")
        write(io, "}\n")
        write(io, "\n")
    end
    close(io)
end

export request

end # module
