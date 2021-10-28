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

mutable struct BibInfo
    url::String
    year::String
    authors::Vector{String}
    affiliations::Vector{String} # ! This field is currently not used in bib generation.
    title::String
    key::String
    journal::String
    BibInfo() = new()
end

n2f = Dict{Field,String}(
    title => "ti",
    author => "au",
    abstract => "abs",
    comment => "co",
    jour_ref => "jr",
    report_num => "rn",
    id_list => "id",
    all_fields => "all",
)
