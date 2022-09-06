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
function vismetabolism(mappath, reactionedgecolor)
    function _escherplot(reactionedgecolor::Symbol)
        return escherplot(
            mappath; 
            reaction_show_text = true,
            reaction_edge_color = reactionedgecolor,
            metabolite_show_text = true,
            metabolite_node_colors = Dict("glc__D_e" => :red),
            metabolite_node_color = :lightskyblue,
        )
    end

    function _escherplot(reactionedgecolors::AbstractDict)
        return escherplot(
            mappath; 
            reaction_show_text = true,
            reaction_edge_colors = reactionedgecolors,
            metabolite_show_text = true,
            metabolite_node_colors = Dict("glc__D_e" => :red),
            metabolite_node_color = :lightskyblue,
        )
    end

    _escherplot(reactionedgecolor)

    hidexdecorations!(current_axis())
    hideydecorations!(current_axis())

    return current_figure()
end
##

##
# Global paths.
const MODELPATH = constructpath("data", "e_coli_core.json")
const MAPPATH = constructpath("data", "e_coli_core_map.json")
const METABOLISMPATH = constructpath("results", "metabolism.pdf")
const DEFREACTIONSPATH = constructpath("results", "default_reactions.pdf")
##

##
# Download a toy model of Escherichia coli's central metabolism.
Downloads.download("http://bigg.ucsd.edu/static/models/e_coli_core.json", MODELPATH)

# Download the metabolic map. 
Downloads.download("http://bigg.ucsd.edu/escher_map_json/e_coli_core.Core%20metabolism", MAPPATH)
##

##
# Save metabolism graph.
save(METABOLISMPATH, vismetabolism(MAPPATH, :grey))
##

##
# Simulate E. coli growth.
const model = load_model(MODELPATH)
# Flux Balance Analysis (FBA).
const fluxes = flux_balance_analysis_dict(model, Tulip.Optimizer) # flux_summary(fluxes)
##

##
# Save control metabolic reactions graph.
const tolerance = 1e-3
const reactionedgecolors = Dict(id => :red for (id, flux) ∈ fluxes if abs(flux) > tolerance)
save(DEFREACTIONSPATH, vismetabolism(MAPPATH, reactionedgecolors))
##
