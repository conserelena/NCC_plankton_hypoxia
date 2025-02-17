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

`random_forest_abundance.R` contains the code used for generating random forest models for abundance, from the data 


#### Figure generating scripts
`transect_maps.R` generates bathymetric plots with the transect locations in it. 