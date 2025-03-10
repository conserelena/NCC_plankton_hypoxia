source("./code/data_concat.R")

library(dplyr)
library(caret)
library(gt)
library(iml)

enviro_vars_model <- c("Year", "Oxygen", "Depth", "chl.ug.l", "Temperature", 
                       "Salinity", "Transect_ID", "time_of_day")

taxa_interest <- c("chaetognath", "copepod_calanoid_calanus", "copepod_cyclopoid_oithona", "copepod_cyclopoid_oithona_eggs",
                   "crustacean_euphausiid", "ctenophore_lobate", "fish_clupeiformes", "fish_sebastes", "hydromedusae_narcomedusae_solmaris",
                   "protist_acantharia", "siphonophore_physonect", "tunicate_doliolid", "tunicate_salp")

all_data <- all_data %>%
  filter(Transect != "CM" | Transect != "RR")

for (subvar in taxa_interest){
  training_data <- cbind(select(all_data2, all_of(enviros)), select(all_data2, all_of(subvar)))
  dir.create(paste0("./results/models_100m/", subvar))
  ind <- which(colnames(training_data) == subvar)
  colnames(training_data)[ind] <- "taxa"
  model_caret <- train(taxa~ ., data = training_data,
                     method = "ranger",
                     num.trees = 1200,
                     importance = "permutation",
                     trControl = fit_control)

  saveRDS(model_caret, file=paste0("./results/models_100m/", subvar, "/model_", subvar))
  var_imp<-varImp(model_caret)
  variable_df <- data.frame("variable" = rownames(var_imp$importance), "importance" = var_imp$importance)
  rownames(variable_df) <- NULL
  variable_df <- variable_df[order(variable_df$Overall, decreasing = TRUE),]
  g_t <- variable_df %>% gt()
  gtsave(g_t, filename = paste0("./results/models_100m/", subvar, "/",subvar , "_variable_importance_enviro.html"))
  model_info <- model_caret$results
  ind <- which.min(model_info$RMSE)
  best_model <- model_info[ind,]
  best_model_gt <- best_model %>% gt()
  gtsave(best_model_gt, filename = paste0("./results/models_100m/", subvar, 
                                          "/best_model_", subvar,".html"))
  mod <- Predictor$new(model_caret, data= training_data, y=training_data$taxa)

  feat_eff_oxy <- FeatureEffect$new(mod, feature = "Oxygen", method = "ale", grid.size=50)
  g_o <- plot(feat_eff_oxy) + theme_bw() + xlab(expression(paste("Oxygen (ml ", l^-1,")")))+
    theme(axis.text=element_text(size=16),
          axis.title=element_text(size=20))+
    xlim(0,8)+
    geom_hline(yintercept=0, color="red") +
    geom_vline(xintercept = 1.46, color = "blue", linetype = "dashed")
  ggsave(g_o, filename = paste0("./figs/rf_models/", subvar, "/ale/ale_oxy_", 
                                subvar, ".jpg"))

  feat_eff_depth <-  FeatureEffect$new(mod, feature = "Depth", 
                                       method = "ale", grid.size=50)
  g_d <- plot(feat_eff_depth) + scale_x_reverse() + theme_bw() + 
    theme(axis.text=element_text(size=16),                                                                   axis.title=element_text(size=20)) +
  geom_hline(yintercept = 0, color="red")+
  xlab("Depth (m)")+
  xlim(100,0)

  ggsave(g_d, filename = paste0("./figs/rf_models/", subvar, "/ale/ale_depth_",
                                subvar, ".jpg"))
}

