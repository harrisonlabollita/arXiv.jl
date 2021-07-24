using LightXML

function find_all_elements(x::XMLElement, n::String)
    matched = XMLElement[]
    for c in child_elements(x)
        name(c) == n && push!(matched, c)
    end
    return matched
end

function extract_bib_info(entries::Vector{XMLElement})
    bibs = BibInfo[]
    bib = BibInfo()
    for entry in entries
        bib.url = strip(content(find_element(entry, "id")))
        bib.year = content(find_element(entry, "published"))[1:4]
        bib.authors = [strip(content(el)) for el in find_all_elements(entry, "author")]
        bib.title = content(find_element(entry, "title"))
        first_author = split(bib.authors[1], " ")
        bib.key =
            first_author[findmax(length.(first_author))[2]] * bib.year * bib.title[1:4]
        bib.journal = "arXiv:$(bib.url[22:end])" # TODO: this is rigid; might not always work
        push!(bibs, deepcopy(bib))
    end
    return bibs
end