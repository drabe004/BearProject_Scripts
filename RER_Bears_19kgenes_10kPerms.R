#Install Rtools here https://cran.r-project.org/bin/windows/Rtools/
setwd("C:/Users/Danie/Desktop/NEW_RER_FILES")

#add Rtools to the path
writeLines('PATH="${RTOOLS40_HOME}\\usr\\bin;${PATH}"', con = "~/.Renviron")

#check that you can find the make file
Sys.which("make")

#############################################################################
#installing and loading all packages needed for RER
install.packages("ape")
install.packages("phytools")
install.packages("maps")
install.packages("devtools")
install.packages("rlang")
install.packages("RColorBrewer")
install.packages("gplots")
install.packages("Rcpp")
install.packages("geiger")
install.packages("knitr")
install.packages("RcppArmadillo")
install.packages("weights")
install.packages("TreeTools")
install.packages("htmltools")
install.packages("Rsampletrees")
install.packages("Rsampletrees")

library(devtools)
if (!require("RERconverge", character.only=T, quietly=T)) {
  require(devtools)
  install_github("nclark-lab/RERconverge", ref="master") 
  #"ref" can be modified to specify a particular branch
}
(install_github("nclark-lab/RERconverge"))




#### Start here if already installed########################################
library(TreeTools)
library(Rsampletrees)
library(phytools)
library(ape)
library(maps)
library(ggplot2)
library(rlang)
library(devtools)
library(RERconverge)
library(tibble)
library(ape)

rerpath = find.package('RERconverge') #If this errors, there is an issue with installation
print(rerpath)
##Now go into this directory and make a directory. Put your .trees file in it. 
# "C:/Users/Danie/AppData/Local/R/win-library/4.2/RERconverge"



##########Trying Amanda's topology


# Define the correct file path
file_path <- "C:/Users/Danie/Desktop/NEW_RER_FILES/codingtrees.tre"

# Read the tree file
toytreefile <- read.tree(file_path)


#Read in Gene Trees
toytreefile = "codingtrees.tre" 
readTrees("codingtrees")
View(toytreefile)
toyTrees=readTrees(toytreefile)
###########################################################################################################################################################
###Estimating relative evolutionary rates RER with GetAllResiduals
########USE THE new trees file from Amanda 6/21/2024
NEW_mamRERw = getAllResiduals(toyTrees, transform = "sqrt", weighted = T, scale = T)
plot.phylo(toyTrees$masterTree, y.lim = 50, x.lim =.8, cex= 0.5, font = .4)
write.tree(toyTrees$masterTree, "NEW_MasterTREE.tre")
#dev.off()

plot(toyTrees$masterTree)

noneutherians <- c("ornAna2")

H_HIBS = c("ursMar1","mesAur1", 'speTri2', 'marMar1', "rhiSin1" ,"hipArm1" ,"eptFus1" ,"myoLuc2" ,"myoDav1" ,"myoBra1" ,"minNat1" ,"eriEur2" ,"echTel2" ,"eleEdw1")

avgtree=plotTreeHighlightBranches1(toyTrees$masterTree, outgroup=noneutherians,
                                 hlspecies=c("ursMar1","mesAur1", 'speTri2', 'marMar1', "rhiSin1" ,"hipArm1" ,"eptFus1" ,"myoLuc2" ,"myoDav1" ,"myoBra1" ,"minNat1" ,"eriEur2" ,"echTel2" ,"eleEdw1"), hlcols=c("purple"), 
                                 main="Average tree") #plot average tree

saveRDS(NEW_mamRERw, file="NEW_mamRERw.rds")
########################################################################
####Load from a previous run 
#NEW_mamRERw <- readRDS("NEW_mamRERw.rds")
#str(NEW_mamRERw)

##plotRERs
#plot RERs
par(mfrow=c(1,1))
phenvExample <- foreground2Paths(H_HIBS, toyTrees, clade="terminal")
plotRers(NEW_mamRERw,"ABHD8",phenv=phenvExample) #plot RERs


###Make a multitrees object of all genes with RERs as BLs
multirers = returnRersAsTreesAll(toyTrees,NEW_mamRERw)
write.tree(multirers, file='toyRERs.nwk', tree.names=TRUE)

############load from a previous run
multirers = read.tree("toyRERs.nwk", tree.names = TRUE)

###Make a binary tree 
HHIBextantforeground = c("ursMar1","mesAur1", 'speTri2', 'marMar1', "rhiSin1" ,"hipArm1" ,"eptFus1" ,"myoLuc2" ,"myoDav1" ,"myoBra1" ,"minNat1" ,"eriEur2" ,"echTel2" ,"eleEdw1")
HHIB2a = foreground2Tree(HHIBextantforeground, toyTrees, clade="ancestral")

HHIB2b = foreground2Tree(HHIBextantforeground, toyTrees, clade="terminal")

HHIB2c = foreground2Tree(HHIBextantforeground, toyTrees, clade="all")
HHIB2d = foreground2Tree(HHIBextantforeground, toyTrees, clade="all", weighted = TRUE)

##Plot the binary tree
par(mfrow=c(2,2))
plot(HHIB2a,cex=0.6,main="ancestral")
plot(HHIB2b,cex=0.6,main="terminal")
plot(HHIB2c,cex=0.6,main="all unweighted", x.lim=c(0,2.5))
labs2c = round(HHIB2c$edge.length,3)
labs2c[labs2c==0] = NA
edgelabels(labs2c, col = 'black', bg = 'transparent', adj = c(0.5,-0.5),cex = 0.4,frame='n')
plot(HHIB2d,cex=0.6,main="all weighted", x.lim=c(0,2.5))
labs2d = round(HHIBd$edge.length,3)
labs2d[labs2d==0] = NA
edgelabels(labs2d, col = 'black', bg = 'transparent', adj = c(0.5,-0.5),cex = 0.4,frame='n')
15


###Generate Paths

phenvHHIB=tree2Paths(HHIB2d, toyTrees)
phenvHHIB2=foreground2Paths(HHIBextantforeground, toyTrees, clade="all",)
phenvHHIB2b=tree2Paths(HHIB2d, toyTrees)


#Coorelate with phenotypes round 1 using terminal binary tree
corHHIB=correlateWithBinaryPhenotype(NEW_mamRERw, phenvHHIB2, min.sp=10, min.pos=2,
                                       weighted="auto")

##look at the p-values 

head(corHHIB[order(corHHIB$P),])

write.csv(corHHIB, "HillerRERs_FG_toPATHS_all.csv")

##Hist of p-values 
dev.off()
par(mfrow= c(1,2))
hist(corHHIB$P, breaks=20, xlab="Kendall P-value",
     main="P-values for correlation between 19k genes and Hibernation")
hist(corHHIB$p.adj, breaks=20, xlab="Kendall P-value",
     main="Adjusted P-values for correlation between 19k genes and Hibernation")


##PLOT RERs
plotRers(NEW_mamRERw,"toyRERs.nwk",phenv=phenvHHIB2)

#####################################################################################
############Permulations Analysis #################################################
#####################################################################################



HHIB_FG = c("ursMar1","mesAur1", 'speTri2', 'marMar1', "rhiSin1" ,"hipArm1" ,"eptFus1" ,"myoLuc2" ,"myoDav1" ,"myoBra1" ,"minNat1" ,"eriEur2" ,"echTel2" ,"eleEdw1")
sisters_HHIB = list("clade1"=c("myoLuc2", "myoBra1"), "clade2" =c("clade1", "myoDav1"), "clade3"= c("clade2", "eptFus1"), "clade4"= c("clade3", "minNat1"), "clade5"= c("hipArm1", "rhiSin1"))


HHIBFgTree = foreground2TreeClades(HHIB_FG,sisters_HHIB,toyTrees,plotTree=F)
HHIBplot1 = plotTreeHighlightBranches(HHIBFgTree,
                                        hlspecies=which(HHIBFgTree$edge.length==1),
                                        hlcols="blue", main="HIB mammals trait tree")


# Calculating paths from the foreground tree
pathvec = tree2PathsClades(HHIBFgTree, toyTrees)



# Calculate correlation
res = correlateWithBinaryPhenotype(NEW_mamRERw, pathvec, min.sp=10, min.pos=2,
                                   weighted="auto")


#define the root species
root_sp = "ornAna2"


masterTree = toyTrees$masterTree

#perform binary CC permulation
permCC = getPermsBinary(10000, HHIB_FG, sisters_HHIB, root_sp, NEW_mamRERw, toyTrees,
                        masterTree, permmode="cc")



#calculate permulation p-values
permpvalCC = permpvalcor(res,permCC)


##Corrected PVals
install.packages("remotes")
remotes::install_github("kassambara/rstatix", force =TRUE)
library(rstatix)

PermPadj =adjust_pvalue(permpvalCC, p.col = "permpval", output.col = "Adjpval", method = "BH")
View(PermPadj)
write.csv(PermPadj, "HIB_Hiller_10kPerms_adjPvals.csv")


hist(PermPadj$Adjpval, breaks =15)



############################################### ONLY BATS ###############################################
######################### Doing the same analysis with only bats in the Foreground ###########################
#########################################################################################################

HHIBextantforeground3 = c("rhiSin1" ,"hipArm1" ,"eptFus1" ,"myoLuc2" ,"myoDav1" ,"myoBra1" ,"minNat1")
HHIB4a = foreground2Tree(HHIBextantforeground3, toyTrees, clade="ancestral")

HHIB4b = foreground2Tree(HHIBextantforeground3, toyTrees, clade="terminal")

HHIB4c = foreground2Tree(HHIBextantforeground3, toyTrees, clade="all")
HHIB4d = foreground2Tree(HHIBextantforeground3, toyTrees, clade="all", weighted = TRUE)

##Generate Paths
phenvHHIB4=foreground2Paths(HHIBextantforeground3, toyTrees, clade="all")

#Coorelate with phenotypes round 1 using terminal binary tree
corHHIB4=correlateWithBinaryPhenotype(NEW_mamRERw, phenvHHIB4, min.sp=10, min.pos=2,
                                      weighted="auto")

##look at the p-values 

head(corHHIB4[order(corHHIB4$p.adj),])

write.csv(corHHIB4, "HillerRERs_ONLYBats.csv")
