##
using COBREXA
using Escher
using CairoMakie
using Tulip
using Colors
##

##
import Downloads
##

##
# Generate a valid OS path.
function constructpath(dirname::AbstractVector{String}, filename)
    return joinpath(dirname..., filename)
end

function constructpath(dirname::AbstractString, filename)
    return joinpath(dirname, filename)
end

function constructpath(filename)
    return joinpath(filename)
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
Downloads.download("http://bigg.ucsd.edu/static/models/e_coli_core.json", constructpath("data", "e_coli_core.json"))

# Download the metabolic map. 
Downloads.download("http://bigg.ucsd.edu/escher_map_json/e_coli_core.Core%20metabolism", constructpath("data", "e_coli_core_map.json"))
##

##
# Visualize the metabolism.
escherplot(
    constructpath("data", "e_coli_core_map.json"); 
    reaction_show_text = true,
    reaction_edge_color = :grey,
    metabolite_show_text = true,
    metabolite_node_colors = Dict("glc__D_e" => :red),
    metabolite_node_color = :lightskyblue,
)
hidexdecorations!(current_axis())
hideydecorations!(current_axis())
p = current_figure()
##

##
# Save metabolism graph.
save(constructpath("results", "metabolism.pdf"), p)
##