using Dates: now

function bibtex(bibs::Vector{BibInfo}, filename::String)
    io = open("$(filename).bib", "a")
    println("writing results to $(filename).bib")

    write(io, "generated by arXiv.jl on $(now())\n")
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