# Constraint-based metabolic modeling

Workflow oneliner examples using various util functions:

- `readcsv(["results", "csv"], "ko_genes_reactions.csv") |> df_to_fluxes |> flux_summary`
- `writeio(readcsv(["results", "csv"], "max_etoh_reactions.csv") |> tomarkdown, constructpath(["results", "markdown"], "max_etoh_reactions.md"))`

![Complete Metabolism Graph](results/svg/metabolism.svg)

---

![Default Metabolic Reaction Set](results/svg/default_reactions.svg)

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

![KO Cytochrome Oxidase Reaction Set](results/svg/ko_genes_reactions.svg)

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
