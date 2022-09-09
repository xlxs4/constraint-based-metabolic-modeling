# Constraint-based metabolic modeling using COBRA and FBA

A project using a [toy model](https://journals.asm.org/doi/10.1128/ecosalplus.10.2.1)[^1] of some parts of the central metabolism of *Escherichia Coli* to apply COBRA, and specifically FBA, and predict the active chemical reactions under default conditions (aerobic, glucose fed), how the metabolism changes when genes that encode for cytochrome oxidases (bo and putative) are KO (switch from respiration to fermentation), and how FBA can be used to identify a single point in the constrained search space, specifically to maximize ethanol production while ensuring the organism can still grow.
The model includes glycolysis, the TCA or CAC or Krebs cycle, and the electron transport chain.
This project uses the [Julia language](https://julialang.org/) and two main Julia packages: [COBREXA.jl](https://lcsb-biocore.github.io/COBREXA.jl/stable/) and [Escher.jl](https://github.com/stelmo/Escher.jl).
The results are included as CSVs and markdown tables, and visualizations in the form of metabolic maps are also included in SVG and PDF form.
Some utility functions have also been defined for a more seamless exploratory pipeline.

## Metabolism

What is metabolism? It's a set of chemical reactions that can be found in organisms and are key for sustaining life.
They are either reactions that *break down* things (compounds such as glucose) or *synthesize* things (compounds such as proteins, carbohydrates, lipids and nucleic acids).
Usually, breaking compounds down releases energy, while synthesizing compounds consumes energy.
This energy flow happens under very specific rules, as all organisms obey the laws of thermodynamics.
The second law states that in an isolated system the amount of entropy cannot decrease, which seems to contradict the complexity that can be found in living systems.
The key here is that organisms are, in fact, open systems, which exchange matter and energy with their environment; dissipative systems that maintain complexity by increasing the entropy of their environment.
The metabolism of a cell achieves this by coupling the spontaneous processes of breaking down things, with the non-spontaneous processes of synthesizing things.
Some example mechanisms are [bacteriorhodopsin](https://pdb101.rcsb.org/motm/27), or the [redox loop](https://www.sciencedirect.com/science/article/pii/S0014579303003892)[^2]. You can see [this](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5389199/)[^3] for an example.

These chemical reactions are organized into metabolic pathways, along which a chemical gets transformed into another chemical through a series of steps.
Each step happens with the help of an enzyme, which is exactly what couples the reactions to other more thermodynamically favorable ones, catalyze the reactions so that they proceed faster, and regulate the rate at which they occur.
The basic metabolic pathways are found among vastly different species.
For example, the set of carboxylic acids that are best known as the intermediates in the citric acid cycle are present in all known organisms.
Central pathways of metabolism, such as glycolysis and the citric acid cycle, are present in all three domains of living things and were present in the last universal common ancestor (LUCA).
Understanding how metabolism came to be and whether it can actually kickstart life ([example](https://www.pnas.org/doi/full/10.1073/pnas.0912628107)[^4]) is another topic of great study, and while it is a very complex process with a lot of participating intertwined mechanisms, it could have originated as something [much simpler](https://www.nature.com/articles/s41557-020-00560-7)[^5]. Also see [this](https://www.nature.com/articles/nature19776)[^6].

Through metabolism we can also produce biofuels ([here](https://www.science.org/doi/10.1126/science.1114736)[^7], [here](https://link.springer.com/article/10.1007/s00253-007-1163-x)[^8] and [here](https://www.sciencedirect.com/science/article/pii/S0092867421000957)[^9]) or [healthy food](https://www.sciencedirect.com/science/article/pii/S1096717620300331)[^10], [biopolymers](https://www.sciencedirect.com/science/article/pii/S1096717619300886)[^11], [amino acids](https://www.sciencedirect.com/science/article/pii/S1096717619301004)[^12] and more.

## Framework

The enzymes that facilitate all of these chemical reactions are produced through a process which involves some cell genes.
How much of an enzyme is produced has to do with how much the corresponding gene or genes are used (expressed).
Recent advances in Synthetic Biology (such as [being able to modify a single DNA base](https://www.nature.com/articles/nature24644)[^13], [rapidly delete endogenous genes](https://www.nature.com/articles/srep17874)[^14], [insert entirely new genes](https://www.science.org/doi/full/10.1126/science.aac9373)[^15], or onto something more metabolism-related, [regulate enzyme expression](https://www.sciencedirect.com/science/article/pii/S240547122030418X)[^16]) mean that we now can directly intervene and change a cell to have it do our bidding.
That means we now have to understand what exactly to change in the cell to have the desirable results.
In other words, we need to better understand how, systematically, changes at the gene level affect an organism's metabolism.

To do this, we can use a great variety of techniques, some of which can be found [here](https://www.nature.com/articles/nrg3643)[^17].
We use something called COBRA (COnstraint-Based Reconstruction and Analysis) which means you gather details on all of the chemical reactions that are encoded for by the genes of the organisms; the reactions [are linked to specific genes](https://www.nature.com/articles/nbt.3956)[^18].
Then, we can use an optimization technique called [Flux Balance Analysis](https://www.nature.com/articles/nbt.1614)[^19] to predict how the enzymes work, and thus to predict how the reaction set would change if the genes were modified.

The model used in this repository is a [toy model](https://journals.asm.org/doi/10.1128/ecosalplus.10.2.1) of some parts of the central metabolism of *Escherichia Coli*.
It includes glycolysis, the TCA or CAC or Krebs cycle, and the electron transport chain:

![Complete Metabolism Graph](results/svg/metabolism.svg)

Here, the edges are chemical reactions, and the nodes are metabolites.
Glucose (in red) is converted into ATP and other metabolic precursors used to create more cells (biomass).
The majority of these reactions actually exist in *E. coli*, but not those lumped in the bottom right.
These are what's called the biomass objective function, which is a pseudo reaction that groups all the processes that weren't modeled and that convert the metabolites generated by what's been modeled into biomass. 
This is an assumption due to the constraint-based approaches requiring the organisms to have adapted their metabolism, through evolution, to optimize some objective.
The specific assumption taken to hold here is that the metabolism has been tuned to maximize growth rate (biomass).
There initiallly were some studies showing that optimizing the assumed objective function for growth ([here](https://www.nature.com/articles/nature01149)[^20]) and for energy use ([here](https://pubmed.ncbi.nlm.nih.gov/15052634/)[^21] and [here](https://pubmed.ncbi.nlm.nih.gov/14705007/)[^22]) you could predict the metabolic fluxes.
Other studies seemed to question this universality ([here](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1003091)[^23], [here](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1949037/)[^24] and [here](https://pubmed.ncbi.nlm.nih.gov/19888218/)[^25]).
Today the representation of the *in vivo* fluxes is thought of as a Pareto surface created from combining three objective functions: maximizing biomass and ATP generation, and minimizing the fluxes across the whole network ([here](https://www.science.org/doi/10.1126/science.1216882)[^26]).

In FBA, the reaction network is represented in the compact form of a stoichiometric matrix ( $S$ ), as is common, with $m$ rows and $n$ columns, for $n$ chemical reactions and $m$ participating compounds.
The column entries are the stoichiometric coefficients of the metabolites that participate in the corresponding reaction, where there's a negative coefficient if the metabolite is consumed and a positive coefficient if it's produced.
If a metabolite does not participate in a chemical reaction, the corresponding stoichiometric coefficient is zero.
$S$ is a sparse matrix, since the reactions usually involve only a handful of metabolites.
The flux through all the reactions across the network is represented by a vector $v$, of length $n$, for the $n$ reactions.
Respectively, a vector $x$ with length $m$ represents the concentrations of all the metabolites.
You can get the system containing all mass balance equations at steady state by solving for $$\frac{dx}{dt} = 0$$

---

$$Sv = 0$$

Any vector $v$ that satisfies this equation is in the null space of $S$.
In realistic, large-scale models, there are more reactions than there are compounds ( $n > m$ ) which means there are more unknown variables in the system than equations, so there is no single, unique solution to this system.
The solution space is defined by imposing the $Sv = 0$ mass balance constraints and capacity constraints imposed by manually selected lower and upper bounds.
What FBA does is it looks into specific points within that solution space.
For instance, while you might have various viable configurations, you might be interested to see which point within the solution space corresponds to maximizing biomass production, or maximizing the production of a compound, given the already present collection of constraints.

FBA, as a method that seeks to identify optimal points within a constrained space, optimizes an objective function $$Z = c^Tv$$

This can generally be any (linear) combination of fluxes, with $c$ being a vector containing weights that indicate how much a chemical reaction contributes to the objective function.
If optimizing only for a single reaction, e.g. biomass production, $c$ will be a vector of zeros with an entry of one only at the position of the reaction optimizing for.

Lastly, to optimize this system linear programming methods are used to solve $Sv = 0$, given the set of lower and upper bounds on $v$ and a linear combination of fluxes as an objective function.
The resulting flux distribution $v$ maximizes or minimizes the selected objective function.
Because FBA reduces the large-scale, complex metabolic model to a linear program, it is quite performant and scales well.
The FBA computations fall into the broader category of COnstraint-Based Reconstruction and Analysis (COBRA) methods.

## Implementation

This project uses [COBREXA.jl](https://lcsb-biocore.github.io/COBREXA.jl/stable/) (COnstraint-Based Reconstruction and EXascale Analysis), a Julia package, for the computational work; while the backbone - the optimizer - chosen is [Tulip.jl](https://github.com/ds4dm/Tulip.jl), an interior-point solver for linear optimization written purely in Julia.
You can use other solvers if you'd like, as long as it's supported by JuMP; see [this](https://jump.dev/JuMP.jl/stable/installation/#Supported-solvers).
It also uses [Escher.jl](https://github.com/stelmo/Escher.jl), a Julia package that is essentially a [Makie.jl](https://makie.juliaplots.org/stable/index.html) [recipe](https://makie.juliaplots.org/stable/documentation/recipes/) to plot maps of metabolic models.
Lastly, [`CSV.jl`](https://github.com/JuliaData/CSV.jl) is used for importing and exporting the FBA results, [`DataFrames.jl`](https://dataframes.juliadata.org/stable/) are used to have a common data structure for the various processing functions, and [`PrettyTables.jl`](https://github.com/ronisbr/PrettyTables.jl) is used to export the results as Markdown tables.

There are some utility functions defined:

- `constructpath` which allows you to easily generate a valid path for your OS to play around with importing and exporting files, as well as downloads
- `writeio`, to save data to a file. This is used for example to write the results as markdown tables
- `readcsv` and `writecsv`, to import/export data in CSV form
- `tomarkdown`, to convert the results to a markdown table
- `fluxes_to_df` and `df_to_fluxes`, to help with converting back and from a structure COBREXA uses, to a more general-purpose data structure for IO, etc.
- `vismetabolism`, which uses Escher to generate a metabolic map with sensible defaults, and `generate_flux_edge_colors` to help color the reactions according to a customizable tolerance

---

Workflow oneliner examples using various util functions:

- `readcsv(constructpath(["results", "csv"], "ko_genes_reactions.csv")) |> df_to_fluxes |> flux_summary`
- `writeio(readcsv(constructpath(["results", "csv"], "max_etoh_reactions.csv")) |> tomarkdown, constructpath(["results", "markdown"], "max_etoh_reactions.md"))`

---

The rest is pretty straightforward: The toy model gets downloaded and loaded into COBREXA in [`StandardModel`](https://lcsb-biocore.github.io/COBREXA.jl/stable/functions/types/#COBREXA.StandardModel) form, we simulate the growth of *E. coli* under some default conditions (aerobic, glucose fed) and use FBA to predict its growth rate and active chemical reactions.
FBA is performed again, but with some KO genes and with additional constraints to maximize for a specific point in solution space.
The resulting metabolic maps are saved by default, if not already present.

## Results

```julia
# Simulate E. coli growth.
const model = load_model(StandardModel, ModelPath)
# Flux Balance Analysis (FBA).
const fluxes = flux_balance_analysis_dict(model, Tulip.Optimizer)

# Save control metabolic reactions graph.
const tolerance = 1e-3
!isfile(DefReactionsPath) && save(DefReactionsPath, vismetabolism(MapPath, generate_flux_edge_colors(fluxes, tolerance, :red)))
```

At first, we can load the simulated growth in default conditions (aerobic, glucose fed) and perform FBA to predict the cell's growth rate and chemical reactions.
We can then generate the metabolic map with the active chemical reactions highlighted in red:

![Default Metabolic Reaction Set](results/svg/default_reactions.svg)

The model predicts a growth rate of 0.87 1/h when the cell metabolizes 10 mmol glucose/gDW/h.
This is fairly close to the corresponding experimental results.
Some of the reactions are not used (grey dashed lines), which is expected since the metabolism is actively regulated to better perform in the current environment.
Specifically, the cell uses respiration to produce energy.

<details>
<summary>Click to see results table</summary>

|         Reaction         |    Flux     |
|--------------------------|-------------|
|          ACALD           | -5.65944e-9 |
|           PTAr           | 3.41401e-9  |
|          ALCD2x          | -1.4328e-9  |
|           PDH            |   9.28253   |
|           PYK            |   1.75818   |
|           CO2t           |  -22.8098   |
|         EX_nh4_e         |  -4.76532   |
|         MALt2_2          |     0.0     |
|            CS            |   6.00725   |
|           PGM            |  -14.7161   |
|           TKT1           |   1.49698   |
|       EX_mal__L_e        |     0.0     |
|          ACONTa          |   6.00725   |
|         EX_pi_e          |   -3.2149   |
|           GLNS           |  0.223462   |
|           ICL            | 2.89785e-7  |
|         EX_o2_e          |  -21.7995   |
|           FBA            |   7.47738   |
|       EX_gln__L_e        |     0.0     |
|       EX_glc__D_e        |    -10.0    |
|          SUCCt3          | 2.55048e-8  |
|          FORt2           | 1.14358e-7  |
|         G6PDH2r          |   4.95999   |
|          AKGDH           |   5.06438   |
|           TKT2           |   1.1815    |
|           FRD7           |    490.0    |
|          SUCOAS          |  -5.06438   |
| BIOMASS_Ecoli_core_w_GAM |  0.873922   |
|           FBP            | 1.50898e-8  |
|          ICDHyr          |   6.00725   |
|          AKGt2r          | -3.84984e-9 |
|          GLUSy           | 9.04494e-9  |
|           TPI            |   7.47738   |
|           FORt           | -1.33188e-7 |
|          ACONTb          |   6.00725   |
|         EX_ac_e          | 3.41403e-9  |
|          GLNabc          |     0.0     |
|         EX_akg_e         | 3.84984e-9  |
|         EX_fru_e         |     0.0     |
|           RPE            |   2.67848   |
|           ACKr           | -3.41402e-9 |
|           THD2           | 3.37384e-7  |
|           PFL            | 1.88301e-8  |
|           RPI            |   -2.2815   |
|         D_LACt2          | -2.39187e-9 |
|           TALA           |   1.49698   |
|       EX_glu__L_e        |  3.3699e-9  |
|           ATPM           |    8.39     |
|           PPCK           | 5.88221e-8  |
|          ACt2r           | -3.41402e-9 |
|        EX_etoh_e         | 1.43282e-9  |
|           NH4t           |   4.76532   |
|           PGL            |   4.95999   |
|         NADTRHD          |  5.3881e-7  |
|           PGK            |  -16.0235   |
|          LDH_D           | -2.39186e-9 |
|           ME1            | 4.81777e-8  |
|          PIt2r           |   3.2149    |
|         EX_h2o_e         |   29.1758   |
|        EX_succ_e         | 1.53072e-9  |
|          ATPS4r          |   45.514    |
|          PYRt2           | -3.92523e-9 |
|        EX_acald_e        | 4.22665e-9  |
|          EX_h_e          |   17.5309   |
|          GLCpts          |    10.0     |
|          GLUDy           |  -4.54186   |
|          CYTBD           |   43.599    |
|         FUMt2_2          |     0.0     |
|         FRUpts2          |     0.0     |
|           GAPD           |   16.0235   |
|           H2Ot           |  -29.1758   |
|           PPC            |   2.50431   |
|          NADH16          |   38.5346   |
|           PFK            |   7.47738   |
|         EX_for_e         | 1.88301e-8  |
|           MDH            |   5.06438   |
|           PGI            |   4.86086   |
|           O2t            |   21.7995   |
|           ME2            |  1.4966e-7  |
|         EX_pyr_e         | 3.92523e-9  |
|         EX_co2_e         |   22.8098   |
|           GND            |   4.95999   |
|         SUCCt2_2         | 2.39741e-8  |
|           GLUN           | 9.94954e-9  |
|         EX_fum_e         |     0.0     |
|         ETOHt2r          | -1.43281e-9 |
|           ADK1           | 2.86618e-8  |
|          ACALDt          | -4.22664e-9 |
|          SUCDi           |   495.064   |
|       EX_lac__D_e        | 2.39187e-9  |
|           ENO            |   14.7161   |
|           MALS           | 2.89785e-7  |
|          GLUt2r          | -3.36991e-9 |
|           PPS            | 2.86618e-8  |
|           FUM            |   5.06438   |

</details>

---

```julia
# Knockout genes b0978 and b0734
# encoding cytochrome oxidases (bo and putative).
const ko_fluxes = flux_balance_analysis_dict(
    model,
    Tulip.Optimizer;
    modifications = [knockout(["b0978", "b0734"])],
)

# Save KO cytochrome oxidase genes metabolic reactions graph.
!isfile(KOReactionsPath) && save(KOReactionsPath, vismetabolism(MapPath, generate_flux_edge_colors(ko_fluxes, tolerance, :red)))
```

Now, we can knockout (remove) two genes, [b0978](https://biocyc.org/gene?orgid=ECOLI&id=EG11380) and [b0734](https://biocyc.org/gene?orgid=ECOLI&id=EG10174) which encode cytochrome oxidases (bo and putative):

![KO Cytochrome Oxidase Reaction Set](results/svg/ko_genes_reactions.svg)

The metabolism has now been drastically altered, since the cell is now [forced to use a different process](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2607145/)[^27], called fermentation, to grow.
A side-effect of this change is that the cell physiology has changed significantly, and it's growing with a smaller rate (0.21 1/h), but it also produces ethanol and acetate, which can be used as [biofuels](https://www.nature.com/articles/s41598-022-09148-2)[^28], among others.

<details>
<summary>Click to see results table</summary>

|         Reaction         |     Flux     |
|--------------------------|--------------|
|          ACALD           |   -8.27946   |
|           PTAr           |   8.50359    |
|          ALCD2x          |   -8.27946   |
|           PDH            |  6.66064e-8  |
|           PYK            |   8.40427    |
|           CO2t           |   0.378178   |
|         EX_nh4_e         |   -1.15416   |
|         MALt2_2          |     0.0      |
|            CS            |   0.228363   |
|           PGM            |   -19.1207   |
|           TKT1           |  -0.0378665  |
|       EX_mal__L_e        |     0.0      |
|          ACONTa          |   0.228363   |
|         EX_pi_e          |  -0.778644   |
|           GLNS           |  0.0541222   |
|           ICL            |  1.60351e-9  |
|         EX_o2_e          |     0.0      |
|           FBA            |   9.78946    |
|       EX_gln__L_e        |     0.0      |
|       EX_glc__D_e        |    -10.0     |
|          SUCCt3          |  1.4142e-8   |
|          FORt2           |  1.85814e-8  |
|         G6PDH2r          |  1.01601e-7  |
|          AKGDH           |  1.1816e-9   |
|           TKT2           |  -0.114277   |
|           FRD7           |   492.856    |
|          SUCOAS          | -1.18159e-9  |
| BIOMASS_Ecoli_core_w_GAM |   0.211663   |
|           FBP            |  2.38026e-9  |
|          ICDHyr          |   0.228363   |
|          AKGt2r          | -1.90741e-9  |
|          GLUSy           | 8.29697e-10  |
|           TPI            |   9.78946    |
|           FORt           |   -17.8047   |
|          ACONTb          |   0.228363   |
|         EX_ac_e          |   8.50359    |
|          GLNabc          |     0.0      |
|         EX_akg_e         |  1.90734e-9  |
|         EX_fru_e         |     0.0      |
|           RPE            |  -0.152143   |
|           ACKr           |   -8.50359   |
|           THD2           |   3.62919    |
|           PFL            |   17.8047    |
|           RPI            |  -0.152143   |
|         D_LACt2          | -4.91612e-9  |
|           TALA           |  -0.0378665  |
|       EX_glu__L_e        | 9.61386e-10  |
|           ATPM           |     8.39     |
|           PPCK           |  2.06388e-9  |
|          ACt2r           |   -8.50359   |
|        EX_etoh_e         |   8.27946    |
|           NH4t           |   1.15416    |
|           PGL            |  1.01601e-7  |
|         NADTRHD          |  1.11162e-8  |
|           PGK            |   -19.4373   |
|          LDH_D           | -4.91614e-9  |
|           ME1            |  2.02658e-9  |
|          PIt2r           |   0.778644   |
|         EX_h2o_e         |   -7.1158    |
|        EX_succ_e         |  1.00725e-8  |
|          ATPS4r          |   -5.45205   |
|          PYRt2           | -5.00048e-9  |
|        EX_acald_e        |  5.5162e-9   |
|          EX_h_e          |   30.5542    |
|          GLCpts          |     10.0     |
|          GLUDy           |   -1.10003   |
|          CYTBD           |     0.0      |
|         FUMt2_2          |     0.0      |
|         FRUpts2          |     0.0      |
|           GAPD           |   19.4373    |
|           H2Ot           |    7.1158    |
|           PPC            |   0.606541   |
|          NADH16          |  7.28745e-9  |
|           PFK            |   9.78946    |
|         EX_for_e         |   17.8047    |
|           MDH            | -1.34507e-8  |
|           PGI            |   9.95661    |
|           O2t            |     0.0      |
|           ME2            |  5.74003e-9  |
|         EX_pyr_e         |  5.00046e-9  |
|         EX_co2_e         |  -0.378178   |
|           GND            |  1.01601e-7  |
|         SUCCt2_2         |  4.06942e-9  |
|           GLUN           | 7.09021e-10  |
|         EX_fum_e         |     0.0      |
|         ETOHt2r          |   -8.27946   |
|           ADK1           |  3.06499e-9  |
|          ACALDt          | -5.51622e-9  |
|          SUCDi           |   492.856    |
|       EX_lac__D_e        |  4.91611e-9  |
|           ENO            |   19.1207    |
|           MALS           |  1.60347e-9  |
|          GLUt2r          | -9.61448e-10 |
|           PPS            |  3.06496e-9  |
|           FUM            | -7.28752e-9  |

</details>

---

```julia
# Set minimum constraint for cell growth so that the resulting reaction set is viable.
model_with_bounded_production = change_bound(model, "BIOMASS_Ecoli_core_w_GAM", lower = 0.1)
const max_etoh_fluxes = flux_balance_analysis_dict(
    model_with_bounded_production,
    Tulip.Optimizer;
    modifications = [
        change_objective("EX_etoh_e"), # maximze ethanol production
    ],
)

# Save maximum EtOH production metabolic reactions graph.
!isfile(MaxEtOHReactionsPath) && save(MaxEtOHReactionsPath, vismetabolism(MapPath, generate_flux_edge_colors(max_etoh_fluxes, tolerance, :red)))
```

But what if we wanted to take this a step further, and search for the single point where ethanol production is optimized while ensuring that the cell can still grow?
No problem:

![Max Ethanol Production Reaction Set](results/svg/max_etoh_reactions.svg)

<details>
<summary>Click to see results table</summary>

|         Reaction         |     Flux     |
|--------------------------|--------------|
|          ACALD           |   -18.4801   |
|           PTAr           | 9.30969e-13  |
|          ALCD2x          |   -18.4801   |
|           PDH            |   18.6499    |
|           PYK            |   7.35964    |
|           CO2t           |   -18.4713   |
|         EX_nh4_e         |   -0.54528   |
|         MALt2_2          |     0.0      |
|            CS            |   0.10789    |
|           PGM            |   -19.5846   |
|           TKT1           |   -0.01789   |
|       EX_mal__L_e        |     0.0      |
|          ACONTa          |   0.10789    |
|         EX_pi_e          |   -0.36787   |
|           GLNS           |   1.48252    |
|           ICL            | 4.74617e-13  |
|         EX_o2_e          |  -0.0319401  |
|           FBA            |   9.90053    |
|       EX_gln__L_e        |     0.0      |
|       EX_glc__D_e        |    -10.0     |
|          SUCCt3          |   1.15259    |
|          FORt2           |   5.96336    |
|         G6PDH2r          | 3.20267e-11  |
|          AKGDH           | 3.36493e-12  |
|           TKT2           |   -0.05399   |
|           FRD7           |   491.901    |
|          SUCOAS          | -3.30308e-12 |
| BIOMASS_Ecoli_core_w_GAM |     0.1      |
|           FBP            |   0.66076    |
|          ICDHyr          |   0.10789    |
|          AKGt2r          | -2.2679e-12  |
|          GLUSy           |   0.704085   |
|           TPI            |   9.90053    |
|           FORt           |   -6.27626   |
|          ACONTb          |   0.10789    |
|         EX_ac_e          | 1.18871e-12  |
|          GLNabc          |     0.0      |
|         EX_akg_e         | 2.44418e-12  |
|         EX_fru_e         |     0.0      |
|           RPE            |   -0.07188   |
|           ACKr           | -1.01656e-12 |
|           THD2           |   2.22216    |
|           PFL            |    0.3129    |
|           RPI            |   -0.07188   |
|         D_LACt2          | -6.48811e-12 |
|           TALA           |   -0.01789   |
|       EX_glu__L_e        | 2.94048e-12  |
|           ATPM           |   8.83682    |
|           PPCK           |   0.661514   |
|          ACt2r           | -1.10257e-12 |
|        EX_etoh_e         |   18.4801    |
|           NH4t           |   0.54528    |
|           PGL            | 3.20673e-11  |
|         NADTRHD          |   1.68498    |
|           PGK            |   -19.7342   |
|          LDH_D           | -6.48915e-12 |
|           ME1            |   0.775277   |
|          PIt2r           |   0.36787    |
|         EX_h2o_e         |   0.71954    |
|        EX_succ_e         | 1.80232e-11  |
|          ATPS4r          |   0.561831   |
|          PYRt2           | -3.47462e-12 |
|        EX_acald_e        |  3.6606e-12  |
|          EX_h_e          |    2.3189    |
|          GLCpts          |     10.0     |
|          GLUDy           |   0.184375   |
|          CYTBD           |  0.0638802   |
|         FUMt2_2          |     0.0      |
|         FRUpts2          |     0.0      |
|           GAPD           |   19.7342    |
|           H2Ot           |   -0.71954   |
|           PPC            |   2.90079    |
|          NADH16          |  0.0638802   |
|           PFK            |   10.5613    |
|         EX_for_e         |    0.3129    |
|           MDH            |   -1.95271   |
|           PGI            |    9.9795    |
|           O2t            |  0.0319401   |
|           ME2            |   1.17743    |
|         EX_pyr_e         | 3.51713e-12  |
|         EX_co2_e         |   18.4713    |
|           GND            | 3.20642e-11  |
|         SUCCt2_2         |   1.15259    |
|           GLUN           |   0.752862   |
|         EX_fum_e         |     0.0      |
|         ETOHt2r          |   -18.4801   |
|           ADK1           |  0.0662497   |
|          ACALDt          | -3.61812e-12 |
|          SUCDi           |   491.901    |
|       EX_lac__D_e        | 6.48726e-12  |
|           ENO            |   19.5846    |
|           MALS           | 4.99625e-13  |
|          GLUt2r          | -2.80789e-12 |
|           PPS            |  0.0662497   |
|           FUM            | -1.42832e-11 |

</details>

[^1]: Orth, J. D., Fleming, R. M., & Palsson, B. Ø. (2010). Reconstruction and use of microbial metabolic networks: the core Escherichia coli metabolic model as an educational guide. EcoSal plus, 4(1).
[^2]: Jormakka, M., Byrne, B., & Iwata, S. (2003). Protonmotive force generation by a redox loop mechanism. FEBS letters, 545(1), 25-30.
[^3]: Pross, A., & Pascal, R. (2017). How and why kinetics, thermodynamics, and chemistry induce the logic of biological evolution. Beilstein journal of organic chemistry, 13(1), 665-674.
[^4]: Vasas, V., Szathmáry, E., & Santos, M. (2010). Lack of evolvability in self-sustaining autocatalytic networks constraints metabolism-first scenarios for the origin of life. Proceedings of the National Academy of Sciences, 107(4), 1470-1475.
[^5]: Stubbs, R. T., Yadav, M., Krishnamurthy, R., & Springsteen, G. (2020). A plausible metal-free ancestral analogue of the Krebs cycle composed entirely of α-ketoacids. Nature chemistry, 12(11), 1016-1022.
[^6]: Semenov, S. N., Kraft, L. J., Ainla, A., Zhao, M., Baghbanzadeh, M., Campbell, V. E., ... & Whitesides, G. M. (2016). Autocatalytic, bistable, oscillatory networks of biologically relevant organic reactions. Nature, 537(7622), 656-660.
[^7]: Ragauskas, A. J., Williams, C. K., Davison, B. H., Britovsek, G., Cairney, J., Eckert, C. A., ... & Tschaplinski, T. (2006). The path forward for biofuels and biomaterials. science, 311(5760), 484-489.
[^8]: Antoni, D., Zverlov, V. V., & Schwarz, W. H. (2007). Biofuels from microbes. Applied microbiology and biotechnology, 77(1), 23-35.
[^9]: Liu, Y., Cruz-Morales, P., Zargar, A., Belcher, M. S., Pang, B., Englund, E., ... & Keasling, J. D. (2021). Biofuels for a sustainable future. Cell, 184(6), 1636-1647.
[^10]: Kaur, N., Alok, A., Kumar, P., Kaur, N., Awasthi, P., Chaturvedi, S., ... & Tiwari, S. (2020). CRISPR/Cas9 directed editing of lycopene epsilon-cyclase modulates metabolic flux for β-carotene biosynthesis in banana fruit. Metabolic engineering, 59, 76-86.
[^11]: Choi, S. Y., Rhie, M. N., Kim, H. T., Joo, J. C., Cho, I. J., Son, J., ... & Park, S. J. (2020). Metabolic engineering for the synthesis of polyesters: A 100-year journey from polyhydroxyalkanoates to non-natural microbial polyesters. Metabolic engineering, 58, 47-81.
[^12]: Wendisch, V. F. (2020). Metabolic engineering advances and prospects for amino acid production. Metabolic engineering, 58, 17-34.
[^13]: Gaudelli, N. M., Komor, A. C., Rees, H. A., Packer, M. S., Badran, A. H., Bryson, D. I., & Liu, D. R. (2017). Programmable base editing of A• T to G• C in genomic DNA without DNA cleavage. Nature, 551(7681), 464-471.
[^14]: Jensen, S. I., Lennen, R. M., Herrgård, M. J., & Nielsen, A. T. (2015). Seven gene deletions in seven days: fast generation of Escherichia coli strains tolerant to acetate and osmotic stress. Scientific reports, 5(1), 1-10.
[^15]: Galanie, S., Thodey, K., Trenchard, I. J., Filsinger Interrante, M., & Smolke, C. D. (2015). Complete biosynthesis of opioids in yeast. Science, 349(6252), 1095-1100.
[^16]: Donati, S., Kuntz, M., Pahl, V., Farke, N., Beuter, D., Glatter, T., ... & Link, H. (2021). Multi-omics analysis of CRISPRi-knockdowns identifies mechanisms that buffer decreases of enzymes in E. coli metabolism. Cell Systems, 12(1), 56-67.
[^17]: Bordbar, A., Monk, J. M., King, Z. A., & Palsson, B. O. (2014). Constraint-based models predict metabolic and associated cellular functions. Nature Reviews Genetics, 15(2), 107-120.
[^18]: Monk, J. M., Lloyd, C. J., Brunk, E., Mih, N., Sastry, A., King, Z., ... & Palsson, B. O. (2017). iML1515, a knowledgebase that computes Escherichia coli traits. Nature biotechnology, 35(10), 904-908.
[^19]: Orth, J. D., Thiele, I., & Palsson, B. Ø. (2010). What is flux balance analysis?. Nature biotechnology, 28(3), 245-248.
[^20]: Ibarra, R. U., Edwards, J. S., & Palsson, B. O. (2002). Escherichia coli K-12 undergoes adaptive evolution to achieve in silico predicted optimal growth. Nature, 420(6912), 186-189.
[^21]: Carlson, R., & Srienc, F. (2004). Fundamental Escherichia coli biochemical pathways for biomass and energy production: creation of overall flux states. Biotechnology and bioengineering, 86(2), 149-162.
[^22]: Carlson, R., & Srienc, F. (2004). Fundamental Escherichia coli biochemical pathways for biomass and energy production: identification of reactions. Biotechnology and bioengineering, 85(1), 1-19.
[^23]: Harcombe, W. R., Delaney, N. F., Leiby, N., Klitgord, N., & Marx, C. J. (2013). The ability of flux balance analysis to predict evolution of central metabolism scales with the initial distance to the optimum. PLoS computational biology, 9(6), e1003091.
[^24]: Schuetz, R., Kuepfer, L., & Sauer, U. (2007). Systematic evaluation of objective functions for predicting intracellular fluxes in Escherichia coli. Molecular systems biology, 3(1), 119.
[^25]: Molenaar, D., Van Berlo, R., De Ridder, D., & Teusink, B. (2009). Shifts in growth strategies reflect tradeoffs in cellular economics. Molecular systems biology, 5(1), 323.
[^26]: Schuetz, R., Zamboni, N., Zampieri, M., Heinemann, M., & Sauer, U. (2012). Multidimensional optimality of microbial metabolism. Science, 336(6081), 601-604.
[^27]: Portnoy, V. A., Herrgård, M. J., & Palsson, B. Ø. (2008). Aerobic fermentation of D-glucose by an evolved cytochrome oxidase-deficient Escherichia coli strain. Applied and environmental microbiology, 74(24), 7561-7569.
[^28]: Padmanabhan, S., Giridharan, K., Stalin, B., Kumaran, S., Kavimani, V., Nagaprasad, N., ... & Krishnaraj, R. (2022). Energy recovery of waste plastics into diesel fuel with ethanol and ethoxy ethyl acetate additives on circular economy strategy. Scientific Reports, 12(1), 1-13.
