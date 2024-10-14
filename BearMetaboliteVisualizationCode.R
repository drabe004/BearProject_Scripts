## Bear Paper Data Vis ## 
##Authors: Myana Anderson and Emma Roback

# libraries to be loaded
library(mixOmics)
library(RColorBrewer)
library(ggplot2)
library(preprocessCore)
library(tidyverse)

##################################################################################

# CARNITINE ANALYSIS #
# comparison between denning periods and generation of boxplot
# ------------------------------------------------------------ #

# load carnitine metabolite data
Acylcarnitines.df <- read.csv("~/Desktop/Acylcarnitinesdf.csv", na.strings = c("","NA"))

# clean dataset to remove all non metabolite variables except denning, then restrict to early and late denning periods only
Acyl.df.clean <- Acylcarnitines.df[,-c(1:4,6:14)]
Acyl.df.clean_subset <- subset(Acyl.df.clean, Denning != "SUMMER")

# normalize, transpose for quantum normalization
n <- length(Acyl.df.clean_subset)
Acyl.norm <- as.data.frame(normalize.quantiles((as.matrix(Acyl.df.clean_subset[,2:n]))))

# merge data
Acyl.norm_combined <- Acyl.df.clean_subset
Acyl.norm_combined[,2:n] <- Acyl.norm

# prep carnitine data
df_carnitine <- Acyl.norm_combined %>%
  reorder_levels(Denning, order = c("EARLY", "LATE"))

df_carnitine %>% 
  group_by(Denning) %>%
  get_summary_stats(C0, type = "common")


res.kruskal <- df_carnitine %>% kruskal_test(C0 ~ Denning)

df_carnitine %>% kruskal_effsize(C0 ~ Denning)

pwc_carnitine <- df_carnitine %>% 
  dunn_test(C0 ~ Denning, p.adjust.method = "bonferroni") 

pwc_C0 <- pwc_carnitine %>% add_xy_position(x = "Denning")

## CARNITINE BOXPLOT ##
ggboxplot(df_carnitine, x = "Denning", y = "C0", fill="Denning") + stat_pvalue_manual(pwc_C0, hide.ns = TRUE, y.position = 12.5, tip.length = 0.05, bracket.size = 0.8, linetype = 1, size = 8, color = "#7F7F7F") + ylab("Carnitine") + xlab("Denning Period") + scale_fill_manual(values = c("#25BEA0","#00557F")) + theme(legend.position = "none", aspect.ratio = 3/3)


# ACETYLCARNITINE ANALYSIS #
# comparison between denning periods and generation of boxplot
# ------------------------------------------------------------ #

# prep acetylcarnitine data
df_acetylcarnitine <- Acyl.norm_combined %>%
  reorder_levels(Denning, order = c("EARLY", "LATE"))

df_acetylcarnitine %>% 
  group_by(Denning) %>%
  get_summary_stats(C2, type = "common")

res.kruskal_ace <- df_acetylcarnitine %>% kruskal_test(C2 ~ Denning)

df_acetylcarnitine %>% kruskal_effsize(C2 ~ Denning)

pwc_acetylcarnitine <- df_acetylcarnitine %>% 
  dunn_test(C2 ~ Denning, p.adjust.method = "bonferroni") 

pwc_C2 <- pwc_acetylcarnitine %>% add_xy_position(x = "Denning")

## ACETYLCARNITINE BOXPLOT ##
ggboxplot(df_acetylcarnitine, x = "Denning", y = "C2", fill="Denning") + stat_pvalue_manual(pwc_C2, hide.ns = TRUE, y.position = 12.5, tip.length = 0.05, bracket.size = 0.8, linetype = 1, size = 8, color = "#7F7F7F") + ylab("acetylcarnitine") + xlab("Denning Period") + scale_fill_manual(values = c("#25BEA0","#00557F")) + theme(legend.position = "none", aspect.ratio = 3/3)

##################################################################################

# METABOLIC ANALYSIS #
# generation of circle correlation plot and metabolite boxplots
# ------------------------------------------------------------ #

# load metabolic indicators data
MI.df <- read.csv("~/Desktop/Metabolism_Indicators.csv", na.strings = c("","NA"))

# clean dataset to remove all non metabolite variables except denning
MI.df.clean <- MI.df[,-c(1:4,6:14)]

# normalize, transpose for quantum normalization
n <- length(MI.df.clean)
MI.norm <- as.data.frame(normalize.quantiles((as.matrix(t(MI.df.clean[,2:n])))))

# transpose back for merging data for denning period
MI.norm.t <- t(MI.norm)

# merge data
MI.norm_combined <- MI.df.clean
MI.norm_combined[,2:n] <- MI.norm.t

df_metabolites <- MI.norm_combined
df_metabolites_no_summer <- df_metabolites %>% filter(Denning != "SUMMER")

group <- df_metabolites_no_summer$Denning
dim(df_metabolites_no_summer); length(group)

## Ratio.of.Acetylcarnitine.to.Carnitine

df_ratio <- df_metabolites_no_summer

df_ratio <- df_ratio %>%
  reorder_levels(Denning, order = c("EARLY", "LATE"))

df_ratio %>% 
  group_by(Denning) %>%
  get_summary_stats(Ratio.of.Acetylcarnitine.to.Carnitine, type = "common")

ratio.kruskal <- df_ratio %>% kruskal_test(Ratio.of.Acetylcarnitine.to.Carnitine ~ Denning)

df_ratio %>% kruskal_effsize(Ratio.of.Acetylcarnitine.to.Carnitine ~ Denning)

pwc_ratio <- df_ratio %>% 
  dunn_test(Ratio.of.Acetylcarnitine.to.Carnitine ~ Denning, p.adjust.method = "bonferroni") 
pwc_ratio

## RATIO BOXPLOT ##
ggboxplot(df_ratio, x = "Denning", y = "Ratio.of.Acetylcarnitine.to.Carnitine", fill = "Denning") +
  stat_pvalue_manual(pwc_R.a2c, hide.ns = TRUE, y.position = 1, tip.length = 0.05, bracket.size = 0.8, bracket.shorten = 0.1, linetype = 1, size = 8, color = "#7F7F7F") +
  ylab("Ratio of Acetylcarnitine to Carnitine") +
  scale_fill_manual(values = c("#25BEA0","#00557F")) + theme(legend.position = "none", aspect.ratio = 3/3)

## B OXIDATION

df_box <- df_metabolites_no_summer

df_box <- df_box %>%
  reorder_levels(Denning, order = c("EARLY", "LATE"))

df_box %>% 
  group_by(Denning) %>%
  get_summary_stats(b.Oxidation, type = "common")

res.kruskal_box <- df_box %>% kruskal_test(b.Oxidation ~ Denning)

df_box %>% kruskal_effsize(b.Oxidation ~ Denning)

pwc_box <- df_box %>% 
  dunn_test(b.Oxidation ~ Denning, p.adjust.method = "bonferroni") 
pwc_box

pwc_bo <- pwc_box %>% add_xy_position(x = "Denning")

ggboxplot(df_box, x = "Denning", y = "b.Oxidation", fill = "Denning") +
  stat_pvalue_manual(pwc_bo, hide.ns = TRUE, y.position = 0.7, tip.length = 0.05, bracket.size = 0.8, bracket.shorten = 0.1, linetype = 1, size = 8, color = "#7F7F7F") +
  ylab("Beta Oxidation") + scale_fill_manual(values = c("#25BEA0","#00557F")) + theme(legend.position = "none", aspect.ratio = 3/3)

## CE

df_ce <- df_metabolites_no_summer

df_ce <- df_ce %>%
  reorder_levels(Denning, order = c("EARLY", "LATE"))

df_ce %>% 
  group_by(Denning) %>%
  get_summary_stats(Carnitine.Esterification, type = "common")

res.kruskal_ce <- df_ce %>% kruskal_test(Carnitine.Esterification ~ Denning)

df_ce %>% kruskal_effsize(Carnitine.Esterification ~ Denning)

pwc_ce <- df_ce %>% 
  dunn_test(Carnitine.Esterification ~ Denning, p.adjust.method = "bonferroni") 

pwc_ce <- pwc_ce %>% add_xy_position(x = "Denning")

ggboxplot(df_ce, x = "Denning", y = "Carnitine.Esterification", fill = "Denning") +
  stat_pvalue_manual(pwc_ce, hide.ns = TRUE, y.position = 1, tip.length = 0.05, bracket.size = 0.8, bracket.shorten = 0.1, linetype = 1, size = 8, color = "#7F7F7F") +
  ylab("ce") + scale_fill_manual(values = c("#25BEA0","#00557F")) + theme(legend.position = "none", aspect.ratio = 3/3)


## PLS-DA model + Circle correlation plot ##

### Number of components in PLS-DA, everything but the denning column
X.mat <- as.matrix(df_metabolites_no_summer[,-1])
plsda.df <- plsda(X.mat,group, ncomp = 10)
perf.plsda.df <- perf(plsda.df, validation = 'Mfold', folds = 3, 
                      progressBar = FALSE,  # Set to TRUE to track progress
                      nrepeat = 50)         # We suggest nrepeat = 50

### Final PLS-DA model
final.plsda.df <- plsda(X.mat,group, ncomp = 5)

### Classification performance
perf.final.plsda.df <- perf(final.plsda.df, validation = 'Mfold', 
                            folds = 3, 
                            progressBar = FALSE, # TRUE to track progress
                            nrepeat = 50) # we recommend 50 
# Overall performance of components
perf.overall <- perf.final.plsda.df$error.rate$BER[, 'max.dist']

# error rate per denning period
perf.err <- perf.final.plsda.df$error.rate.class$max.dist

# Grid of possible keepX values that will be tested for each comp
list.keepX <- c(1:10,  seq(20, 100, 10))
list.keepX

# Some convergence issues may arise but it is ok as this is run on CV folds
tune.splsda.df <- tune.splsda(X.mat, group, ncomp = 6, validation = 'Mfold', 
                              folds = 7, dist = 'max.dist', 
                              test.keepX = list.keepX, nrepeat = 10)

# The optimal number of components according to our one-sided t-tests
tune.splsda.df$choice.ncomp$ncomp

# The optimal keepX parameter according to minimal error rate
tune.splsda.df$choice.keepX

## Final model and performance 
# Optimal number of components based on t-tests on the error rate
ncomp <- 2

# Optimal number of variables to select
select.keepX <- tune.splsda.df$choice.keepX[1:ncomp]  
select.keepX

splsda.df <- splsda(X.mat, group, ncomp = ncomp, keepX = select.keepX) 

set.seed(34)  # For reproducibility 

perf.splsda.df <- perf(splsda.df, folds = 5, validation = "Mfold", 
                       dist = "max.dist", progressBar = FALSE, nrepeat = 10)

# perf.splsda.srbct  # Lists the different outputs
perf.splsda.df$error.rate

# Observe error rate per denning period
perf.splsda.df$error.rate.class

## Variable selection and stability
par(mfrow=c(1,2))
# For component 1
stable.comp1 <- perf.splsda.df$features$stable$comp1

# For component 2
stable.comp2 <- perf.splsda.df$features$stable$comp2

par(mfrow=c(1,1))

# First extract the name of selected var:
select.name <- selectVar(splsda.df, comp = 1)$name

# Then extract the stability values from perf:
stability <- perf.splsda.df$features$stable$comp1[select.name]

## CIRCLE CORRELATION PLOT ## 
plotIndiv(splsda.df, comp = c(1,2),
          ind.names = FALSE,
          col = c("#25BEA0","#00557F"), xlim = c(-8,8), ylim = c(-8,8), 
          ellipse = TRUE, legend = TRUE, 
          style = "ggplot2")
