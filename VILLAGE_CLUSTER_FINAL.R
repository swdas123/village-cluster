# 
# 
# Data = read.csv('/home/lenovo/Downloads/RSTUDIO_WORKSPACE/ML_NEW/clustering_BLR_PCA_CDB_2918_F_Census.csv', header = TRUE)
# str(Data)
# dim(Data)
# levels(Data$Level)
# levels(Data$Total.Rural.Urban)
# 
# # Considering only RURAL VILLAGES
# RVill <- Data[(Data$Level == "VILLAGE" & Data$Total.Rural.Urban == "Rural"),]
# str(RVill)
# dim(RVill)
# 
# 
# #Adding 7 more parameters that will act as KPI for clustering
# #1.GenderEqualityRatio need to be moderate/high
# RVill$GenderEqualityRatio=(RVill$Total.Population.Female + RVill$Population.in.the.age.group.0.6.Female)/(RVill$Total.Population.Person + RVill$Population.in.the.age.group.0.6.Person)
# #2.BackwardClassRatio need to be low
# RVill$BackwardClassRatio=(RVill$Scheduled.Castes.population.Person + RVill$Scheduled.Tribes.population.Person)/RVill$Total.Population.Person
# #3.FemaleLiteracyRatio need to be high
# RVill$FemaleLiteracyRatio=RVill$Literates.Population.Female  / RVill$Total.Population.Person
# #4.UnemployedRatio need to be low
# RVill$UnemployedRatio=RVill$Non.Working.Population.Person / RVill$Total.Population.Person
# #5.FulltimeWorkerRatio need to be high
# RVill$FulltimeWorkerRatio=(RVill$Main.Working.Population.Person + RVill$Main.Cultivator.Population.Person+ RVill$Main.Agricultural.Labourers.Population.Person + RVill$Main.Household.Industries.Population.Person +RVill$Main.Other.Workers.Population.Person)/RVill$Total.Population.Person
# 
# #6.ChildLabourRatio need to low
# ChildLabour3_6=RVill$Marginal.Worker.Population.3_6.Person + RVill$Marginal.Cultivator.Population.3_6.Person + RVill$Marginal.Agriculture.Labourers.Population.3_6.Person + RVill$Marginal.Household.Industries.Population.3_6.Person + RVill$Marginal.Other.Workers.Population.Person.3_6.Person
# ChildLabour0_3=RVill$Marginal.Worker.Population.0_3.Person + RVill$Marginal.Cultivator.Population.0_3.Person + RVill$Marginal.Agriculture.Labourers.Population.0_3.Person + RVill$Marginal.Household.Industries.Population.0_3.Person + RVill$Marginal.Other.Workers.Population.0_3.Person
# RVill$ChildLabourRatio=(ChildLabour0_3+ChildLabour3_6)/(RVill$Total.Population.Person+RVill$Population.in.the.age.group.0.6.Person)
# 
# #7.MarginalWorkerRatio need to low compared to FulltimeWorkerRatio
# RVill$MarginalWorkerRatio=(RVill$Marginal.Worker.Population.Person + RVill$Marginal.Cultivator.Population.Person + RVill$Marginal.Agriculture.Labourers.Population.Person + RVill$Marginal.Household.Industries.Population.Person + RVill$Marginal.Other.Workers.Population.Person)/RVill$Total.Population.Person
# 
# summary(RVill)
# 
# RVill$GenderEqualityRatio=ifelse(is.na(RVill$GenderEqualityRatio), mean(RVill$GenderEqualityRatio,na.rm=TRUE), RVill$GenderEqualityRatio)
# RVill$BackwardClassRatio=ifelse(is.na(RVill$BackwardClassRatio), mean(RVill$BackwardClassRatio,na.rm=TRUE), RVill$BackwardClassRatio)
# RVill$FemaleLiteracyRatio=ifelse(is.na(RVill$FemaleLiteracyRatio), mean(RVill$FemaleLiteracyRatio,na.rm=TRUE), RVill$FemaleLiteracyRatio)
# RVill$UnemployedRatio=ifelse(is.na(RVill$UnemployedRatio), mean(RVill$UnemployedRatio,na.rm=TRUE), RVill$UnemployedRatio)
# RVill$FulltimeWorkerRatio=ifelse(is.na(RVill$FulltimeWorkerRatio), mean(RVill$FulltimeWorkerRatio,na.rm=TRUE), RVill$FulltimeWorkerRatio)
# RVill$ChildLabourRatio=ifelse(is.na(RVill$ChildLabourRatio), mean(RVill$ChildLabourRatio,na.rm=TRUE), RVill$ChildLabourRatio)
# RVill$MarginalWorkerRatio=ifelse(is.na(RVill$MarginalWorkerRatio), mean(RVill$MarginalWorkerRatio,na.rm=TRUE), RVill$MarginalWorkerRatio)
# summary(RVill)
# #given 96 columns, added 7 more parameter, total=96+7=103
# myData <- RVill[,97:103]
# dim(myData)
# names(myData)
# myData=as.data.frame(lapply(myData,scale))
# library(factoextra)
# 
# myData.pca=prcomp(myData,center = T,scale. = T)
# fviz_pca(prcomp(myData))
# fviz_pca_ind(myData.pca)
# fviz_pca_var(myData.pca)
# 
# summary(myData.pca)
# names(myData.pca)
# 
# kmData <- myData.pca$x[,c(1:5)]
# kmData
# plot(kmData, pch = 8)
# 
# #---------
# library(clustertend)
# 
# # Compute Hopkins statistic 
# set.seed(123) 
# hopkins(kmData, n=nrow(kmData)-1)  #0.1703847
# fviz_dist(dist(kmData))
# 
# #--------------
# fviz_nbclust(kmData, kmeans, method = "wss")
# fviz_nbclust(kmData, kmeans, method = "silhouette")
# fviz_nbclust(kmData, kmeans, method = "gap_stat")
# 
# # library("NbClust")
# # res5=NbClust(kmData, distance = "euclidean", min.nc = 2,method = "complete", index = "alllong")
# # res5$All.index
# # res5$Best.nc
# 
# #--------------------
# set.seed(20) # to ensure reproducibility of results
# km <- kmeans(kmData, 4, nstart = 200)
# fviz_cluster(km,data=kmData)
# 
# # Analysing model performance
# km$size #Finding out cluster sizes  # 136  52  67 333
# km$centers #Centroids of clusters
# 
# #------------
# 
# # Adding cluster classes 
# class(RVill)
# RVill$Cluster <- factor(km$cluster)
# 
# 
# #Added cluster class and exporting the dataset to csv so that we can import that in Tableau and visualize the clustering.
# write.csv(RVill, file="/home/lenovo/Downloads/RSTUDIO_WORKSPACE/ML_NEW/clusterFinal.csv")
# 
# # Average Features of each cluster
# aggregate(data = RVill, GenderEqualityRatio ~ Cluster, mean)
# aggregate(data = RVill, BackwardClassRatio ~ Cluster, mean)
# aggregate(data = RVill, FemaleLiteracyRatio ~ Cluster, mean)
# aggregate(data = RVill, UnemployedRatio ~ Cluster, mean)
# aggregate(data = RVill, FulltimeWorkerRatio ~ Cluster, mean)
# aggregate(data = RVill, MarginalWorkerRatio ~ Cluster, mean)
# aggregate(data = RVill, ChildLabourRatio ~ Cluster, mean)
# 
# aggregate(data = RVill, Total.Population.Person ~ Cluster, mean)
# 
# summary(RVill)
# 
# #--------------------------------
# #---
# #----------OBSERVATION
# #---
# #--------------------------------
# # 
# #   CLUSTER 4 –-- MORE DEVELOPED COMPARED TO THE REST OF CLUSTERS
# # 2ND HIGHEST POPULATION  (1719)
# # LEAST BACKWARD CLASS (SC/ST) POP,
# # LEAST UNEMPLOYED POP., 
# # FULLTIME WORKERS ARE MORE
# # MARGINAL WORKERS AND CHILD LABOURERS ARE LEAST 
# # GENDER EQUALITY IS HIGH
# # 
# # diadv: BUT THE FEMALE LITERACY RATE  & UNEMPLOYMENT  NEED TO BE IMPROVED
# #
# # -----------------------------------------------------------------------------
# #   CLUSTER 1 – pop(978) MODERATELY DEV.....
# # MORE FULL TIME WORKERS & 
# # LESS MARGINAL WORKERS, AND CHILD LABOURERS 
# # GENDER EQUALITY IS HIGH
# # 
# # 
# # disadv: NO. OF BACKWARD CLASS POP. & UNEMPLOYED POP ARE ON HIGHER SIDE
# #
# # -------------------------------------------------------------------------------
# #   CLUSTER 2 -- MORE DEVELOPED THAN CLUSTER 1
# # HIGHEST POP (2030)
# # NO. OF FULL TIME WORKERS ARE HIGHEST
# # UNEMPLOYMENT IS ALSO LESS
# # LESS MARGINAL WORKERS AND CHILD LABOURERS
# # GENDER EQUALITY IS ALSO MODERATE
# # 
# # disadv: LEAST NO. OF FULLTIME WORKERS & HIGHEST NO. OF MARGINAL WORKERS
# # 
# # -------------------------------------------------------------------------------
# #   CLUSTER 3 –LEAST POP=(901) ----LEAST DEVELOPED COMPARED TO THE REST OF CLUSTERS
# # HIGHEST NUMBER OF CHILD LABOURERS
# # MORE MARGINAL WORKERS
# # UNEMPLOYMENT IS ALSO HIGH
# # FEMALE LITERACY RATE IS ALSO LOW
# 
