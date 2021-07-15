module arXiv
using HTTP
using LightXML


function extractBibInfo(Entries::Array)
	bibs = []
	for entry in Entries
	    bibDict = Dict()
	    url = strip(content(find_element(entry, "id")))
	    bibDict["url"]     =  url 
	    bibDict["authors"] =  [strip(content(el)) for el in find_all_elements(entry, "author")]
	    bibDict["journal"] =  "arXiv:$(url[22:end])"  # TO-DO: this is rigid might not always work
	    push!(bibs, bibDict)
	end
	return bibs
end

	

function find_all_elements(x::XMLElement, n::AbstractString)
	matched = []
	for c in child_elements(x)
		name(c) == n && push!(matched, c)
	end
	return matched
end



function request(search::String; field="all", sortBy=nothing, sortOrder=nothing)
	r         = HTTP.request(:GET, "http://export.arxiv.org/api/query?search_query=all:$search")
	xmlString = parse_string(String(r.body))
	master    = root(xmlString)
	entries   = find_all_elements(master, "entry")
	bib       = extractBibInfo(entries)
end

function bibtex()

end

end # module
