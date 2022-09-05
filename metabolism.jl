##
using COBREXA
using Escher
using CairoMakie
using Tulip
using Colors
##

##
# Download a toy model of Escherichia coli's central metabolism.
download("http://bigg.ucsd.edu/static/models/e_coli_core.json", "e_coli_core.json")

# Download the metabolic map. 
download("http://bigg.ucsd.edu/escher_map_json/e_coli_core.Core%20metabolism", "e_coli_core_map.json")
##