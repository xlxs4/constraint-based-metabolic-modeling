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

# Save to IO.
function writeio(data, dirname, filename)
    open(constructpath(dirname, filename), "w") do io
      write(io, data)
    end
    return nothing
  end
##

##
# Visualize the metabolism.
function vismetabolism(mappath, reaction_edge_color)
    function _escherplot(reaction_edge_color::Symbol)
        return escherplot(
            mappath; 
            reaction_show_text = true,
            reaction_edge_color = reaction_edge_color,
            metabolite_show_text = true,
            metabolite_node_colors = Dict("glc__D_e" => :red),
            metabolite_node_color = :lightskyblue,
        )
    end

    function _escherplot(reaction_edge_colors::AbstractDict)
        return escherplot(
            mappath; 
            reaction_show_text = true,
            reaction_edge_colors = reaction_edge_colors,
            metabolite_show_text = true,
            metabolite_node_colors = Dict("glc__D_e" => :red),
            metabolite_node_color = :lightskyblue,
        )
    end

    _escherplot(reaction_edge_color)

    hidexdecorations!(current_axis())
    hideydecorations!(current_axis())

    return current_figure()
end
##

##
# Global paths.
const ModelPath = constructpath("data", "e_coli_core.json")
const MapPath = constructpath("data", "e_coli_core_map.json")
const MetabolismPath = constructpath("results", "metabolism.pdf")
const DefReactionsPath = constructpath("results", "default_reactions.pdf")
##

##
# Download a toy model of Escherichia coli's central metabolism.
Downloads.download("http://bigg.ucsd.edu/static/models/e_coli_core.json", ModelPath)

# Download the metabolic map. 
Downloads.download("http://bigg.ucsd.edu/escher_map_json/e_coli_core.Core%20metabolism", MapPath)
##

##
# Save metabolism graph.
save(MetabolismPath, vismetabolism(MapPath, :grey))
##

##
# Simulate E. coli growth.
const model = load_model(ModelPath)
# Flux Balance Analysis (FBA).
const fluxes = flux_balance_analysis_dict(model, Tulip.Optimizer) # flux_summary(fluxes)
##

##
# Save control metabolic reactions graph.
const tolerance = 1e-3
const reaction_edge_colors = Dict(id => :red for (id, flux) ∈ fluxes if abs(flux) > tolerance)
save(DefReactionsPath, vismetabolism(MapPath, reaction_edge_colors))
##
