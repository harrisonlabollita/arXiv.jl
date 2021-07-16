module arXiv
using HTTP
using LightXML


function extractBibInfo(Entries::Array)
	bibs = []
	for entry in Entries
	    bibDict = Dict()
	    url = strip(content(find_element(entry, "id")))
	    bibDict["year"]    = content(find_element(entry, "published"))[1:4] 
	    bibDict["url"]     =  url 
	    bibDict["authors"] =  [strip(content(el)) for el in find_all_elements(entry, "author")]
	    bibDict["key"]     =  bibDict["authors"][1]*bibDict["year"]
	    bibDict["journal"] =  "arXiv:$(url[22:end])"  # TO-DO: this is rigid might not always work
	    bibDict["title"]   = content(find_element(entry, "title"))
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
	bibtex(bib)
end

function bibtex(bibs::Array; dir=nothing)
	if isnothing(dir)
	   open("arxiv2bib.bib", "w") do io
           	for bib in bibs
			write(io, "\n")
			write(io, "@article{$(bib["key"])\n")
			write(io, "title={$(bib["title"])\n")
			authorList = ""
			for (a, author) in bib["authors"]
			    if a != length(bib["authors"])
			       authorList *= "$(author) and "
			    else
			       authorList *= "$(author)"
			    end
			end
			write(io, "author={$(authorList)},\n")
			write(io, "year={$(bib["year"])},\n")
			write(io, "journal={$(bib["journal"])},\n")
			write(io, "url={$(bib["url"])}")
			write(io, "\n")
		end
	end
    end
end
export request
end # module
