### README: Code Files

#### Data preparation scripts:
`data_reformat_MEZCAL.R` 

`data_reformat_MBON.R` 

`data_reformat_SPECTRA.R`

These three scripts will prepare post-processed ISIIS binned data for preparation in analyses and modeling.
Each iteration of the ISIIS instrument and data acquisition, and its associated post-processing, formats slightly different data. As such, the data must be cleaned and standardized for the data to be comparable.
Additionally, there are some grouped and derived columns that are created in the process for analyses. 

A final script, `data_concat_all.R`, harmonizes these datasets completely into a full analysis set, ensuring that columns are identical between the different sampling and method schemes.  

#### Analysis scripts 

`random_forest_abundance.R` contains the code used for generating random forest models for abundance, from the data cleaned and concatenated in `data_concat.R`. Model outputs are placed into `./results/rf_models/`, and accumulated local effects plots are saved into `./figs/rf_models`. 


#### Figure generating scripts
`transect_maps.R` generates bathymetric plots with the transect locations in it. The final figure is placed in the `tmp` folder. 

#### Data exploration
`data_exploration.R` has a few data exploratory and figure generating scripts. For example, determining the percent occurance for each class, and plotting the distributions of bin abundance. Outputs of this script is in the `./tmp/data_exploration` subdirectory. 

`RF_treenumber.R` is for determining the best number of trees for random forest analysis, by iterating over different numbers of trees, looking at model metrics/fit,  to reduce over-fitting and maximize time. 

#### Functions
`time_of_day.R` contains a function takes time and returns "day", "night", or "crepuscular". Times are considered to be crepuscular based on solar deposition of 6° below horizon ("civil twilight"). Solar deposition for consideration of dawn and dusk times can also be changed. 


