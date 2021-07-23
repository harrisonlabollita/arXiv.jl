function print_searching(
    search::String,
    field::Field,
    sort_by::SortBy,
    sort_order::SortOrder,
    max_results::Integer,
)
    println("\narXiv.jl: processing request...")
    println("searching $(n2f(field)) for $(search) with the settings:")
    println("sortBy = $(sort_by)")
    println("sortOrder = $(sort_order)")
    println("max_results = $(max_results)\n")
end
