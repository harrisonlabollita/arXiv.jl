using LightXML: XMLElement
using LightXML: name, child_elements, content, find_element


"""
remove bib info from the xml data pulled from the arXiv API.
"""
function extract_bib_info(entries::Vector{XMLElement})
    bibs = BibInfo[]
    bib = BibInfo()
    bib.authors = String[]
    bib.affiliations = String[]
    for entry in entries
        bib.url = strip(content(find_element(entry, "id")))
        bib.year = content(find_element(entry, "published"))[1:4]
        authors = get_elements_by_tagname(entry, "author")
        names = get_elements_by_tagname.(authors, "name")
        affiliations = get_elements_by_tagname.(authors, "affiliation")
        for a in names, b in a
            push!(bib.authors, content(b))
        end
        for a in affiliations, b in a
            push!(bib.affiliations, content(b))
        end
        bib.title = content(find_element(entry, "title"))
        first_author = split(bib.authors[1], " ")
        bib.key =
            first_author[findmax(length.(first_author))[2]] * bib.year * bib.title[1:4]
        bib.journal = "arXiv:$(bib.url[22:end])" # TODO: this is rigid; might not always work
        push!(bibs, deepcopy(bib))
    end
    return bibs
end
