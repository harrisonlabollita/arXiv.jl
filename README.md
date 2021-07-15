# arXiv.jl

## Under development


## Example
From the Julia REPL, (once we load the package and export the function request we won't need the preface)

```
bib = Main.arXiv.request("electron")
```
This returns a list of bib entries as a dictionary. The function bibtex will be used to write this list of bibs to a bib file.
