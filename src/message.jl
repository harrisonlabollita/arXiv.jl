function search_msg(
    search::String,
    field::Field,
    sort_by::SortBy,
    sort_order::SortOrder,
    max_results::Integer,
)
    println("\narXiv.jl: processing request...")
    println("Searching \"$(Symbol(field))\" for \"$(search)\"...")
    println("$(max_results) results are sorted by $(sort_by) with $(sort_order) order.")
end
