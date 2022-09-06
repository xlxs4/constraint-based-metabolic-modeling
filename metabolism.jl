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

function generate_flux_edge_colors(fluxes, tolerance, color)
    return Dict(id => color for (id, flux) ∈ fluxes if abs(flux) > tolerance)
end
##

##
# Global paths.
const ModelPath = constructpath("data", "e_coli_core.json")
const MapPath = constructpath("data", "e_coli_core_map.json")
const MetabolismPath = constructpath("results", "metabolism.pdf")
const DefReactionsPath = constructpath("results", "default_reactions.pdf")
const KOReactionsPath = constructpath("results", "ko_genes_reactions.pdf")
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
save(DefReactionsPath, vismetabolism(MapPath, generate_flux_edge_colors(fluxes, tolerance, :red)))
##

##
# Knockout genes b0978 (https://biocyc.org/gene?orgid=ECOLI&id=EG11380)
# and b0734 (https://biocyc.org/gene?orgid=ECOLI&id=EG10174)
# encoding cytochrome oxidases (bo and putative).
const ko_fluxes = flux_balance_analysis_dict(
    model,
    Tulip.Optimizer;
    modifications = [knockout(["b0978", "b0734"])],
)
##

##
# Save KO cytochrome oxidase genes metabolic reactions graph.
save(KOReactionsPath, vismetabolism(MapPath, generate_flux_edge_colors(ko_fluxes, tolerance, :red)))
##
