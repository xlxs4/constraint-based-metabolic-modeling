##
using COBREXA
using Escher
using CairoMakie
using Tulip
using Colors
##

##
# Generate a valid OS path.
function constructpath(dirname::AbstractVector{String}, filename)
    return joinpath(dirname..., filename)
end

function constructpath(dirname::AbstractString, filename)
    return joinpath(dirname, filepath)
end

function writeio(data, dirname, filename)
    open(constructpath(dirname, filename), "w") do io
      write(io, data)
    end
    return nothing
  end
##

##
# Download a toy model of Escherichia coli's central metabolism.
download("http://bigg.ucsd.edu/static/models/e_coli_core.json", "e_coli_core.json")

# Download the metabolic map. 
download("http://bigg.ucsd.edu/escher_map_json/e_coli_core.Core%20metabolism", "e_coli_core_map.json")
##

##
# Visualize the metabolism.
escherplot(
    "e_coli_core_map.json"; 
    reaction_show_text = true,
    reaction_edge_color = :grey,
    metabolite_show_text = true,
    metabolite_node_colors = Dict("glc__D_e" => :red),
    metabolite_node_color = :lightskyblue,
)
hidexdecorations!(current_axis())
hideydecorations!(current_axis())
current_figure()
##