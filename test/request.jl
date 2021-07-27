@testset "a simple arXiv API call" begin
	one_entry_bib = request("LaBollita",
				field=author,
				max_results=1,
				filename="test"
				)
	url  = "http://arxiv.org/abs/2008.02237v1"
	year = "2020"
	key  = "Krishna2020Effe"
	@test length(one_entry_bib) == 1
	@test one_entry_bib[1].url == url
	@test one_entry_bib[1].year == year
	@test one_entry_bib[1].key == key
	@test isfile("test.bib") == true

	if isfile("test.bib")
		rm("test.bib")
	end
end
