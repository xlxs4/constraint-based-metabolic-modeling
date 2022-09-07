##
using COBREXA
using Escher
using CairoMakie
using Tulip # You can use other optimizers if you'd like, like GLPK.jl
using Colors
##
# TODO: extension-agnostic paths
##
using CSV
using DataFrames
using PrettyTables
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
##

##
# Save to IO.
function writeio(data, path)
    open(path, "w") do io
        write(io, data)
    end
    return nothing
end
##

##
# CSV IO.
function readcsv(path)
    return CSV.File(path, stringtype=String) |> DataFrame
end

function writecsv(data, path)
    CSV.write(path, data)
end
##

##
# Convert to Markdown table.
function tomarkdown(data, header = names(data))
    conf = set_pt_conf(tf = tf_markdown, alignment = :c)
    return pretty_table_with_conf(conf, String, data; header = header)
end
##

##
function fluxes_to_df(fluxes)
    return DataFrame(Reaction = collect(keys(fluxes)), Flux = collect(values(fluxes)))
end

function df_to_fluxes(df)
    return Dict(eachrow(df))
end
##

##
# Visualize the metabolism.
function vismetabolism(mappath, reaction_edge_color, resolution = (800, 600))
    function _escherplot!(reaction_edge_color::Symbol)
        escherplot!(
            mappath; 
            reaction_show_text = true,
            reaction_edge_color = reaction_edge_color,
            metabolite_show_text = true,
            metabolite_node_colors = Dict("glc__D_e" => :red),
            metabolite_node_color = :lightskyblue,
        )

        return nothing
    end

    function _escherplot!(reaction_edge_colors::AbstractDict)
        escherplot!(
            mappath; 
            reaction_show_text = true,
            reaction_edge_colors = reaction_edge_colors,
            metabolite_show_text = true,
            metabolite_node_colors = Dict("glc__D_e" => :red),
            metabolite_node_color = :lightskyblue,
        )

        return nothing
    end

    f = Figure(resolution = resolution)
    ax = Axis(f[1, 1])

    _escherplot!(reaction_edge_color)

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
const MetabolismPath = constructpath(["results", "pdf"], "metabolism.pdf")
const DefReactionsPath = constructpath(["results", "pdf"], "default_reactions.pdf")
const KOReactionsPath = constructpath(["results", "pdf"], "ko_genes_reactions.pdf")
const MaxEtOHReactionsPath = constructpath(["results", "pdf"], "max_etoh_reactions.pdf")
##

##
# Download a toy model of Escherichia coli's central metabolism.
!isfile(ModelPath) && Downloads.download("http://bigg.ucsd.edu/static/models/e_coli_core.json", ModelPath)

# Download the metabolic map. 
!isfile(MapPath) && Downloads.download("http://bigg.ucsd.edu/escher_map_json/e_coli_core.Core%20metabolism", MapPath)
##

##
# Save metabolism graph.
!isfile(MetabolismPath) && save(MetabolismPath, vismetabolism(MapPath, :grey))
##

##
# Simulate E. coli growth.
const model = load_model(StandardModel, ModelPath)
# Flux Balance Analysis (FBA).
const fluxes = flux_balance_analysis_dict(model, Tulip.Optimizer) # flux_summary(fluxes)
##

##
# Save control metabolic reactions graph.
const tolerance = 1e-3
!isfile(DefReactionsPath) && save(DefReactionsPath, vismetabolism(MapPath, generate_flux_edge_colors(fluxes, tolerance, :red)))
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
!isfile(KOReactionsPath) && save(KOReactionsPath, vismetabolism(MapPath, generate_flux_edge_colors(ko_fluxes, tolerance, :red)))
##

##
# Set minimum constraint for cell growth so that the resulting reaction set is viable.
model_with_bounded_production = change_bound(model, "BIOMASS_Ecoli_core_w_GAM", lower = 0.1)
const max_etoh_fluxes = flux_balance_analysis_dict(
    model_with_bounded_production,
    Tulip.Optimizer;
    modifications = [
        change_objective("EX_etoh_e"), # maximze ethanol production
    ],
)
##

##
# Save maximum EtOH production metabolic reactions graph.
!isfile(MaxEtOHReactionsPath) && save(MaxEtOHReactionsPath, vismetabolism(MapPath, generate_flux_edge_colors(max_etoh_fluxes, tolerance, :red)))
#
##
