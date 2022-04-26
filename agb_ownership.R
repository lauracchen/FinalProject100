#load libraries
library(rgdal) # package for geospatial analysis
library(ggplot2) # package for plotting
library(raster) # package for raster manipulation
library(sf) # package for geospatial df manipulation
library(geojsonR) #package for geoJSON
library(dplyr) #for data manipulation

#set wd
setwd("~/1.00/finalproject_100/")

#import AGB, ownership, and activity data
a = "MISR_agb_estimates_20002021.tif"
o10 = "own2010.tif"
o17 = "forest_own1.tif"
anepa = "Activity_Project_Areas_NEPA_(Feature_Layer).geojson"
atsale = "Activity_Project_Areas_Timber_Sale_(Feature_Layer).geojson"
pcoll = "Collaborative_Forest_Landscape_Restoration_Program%3A_Point_(Feature_Layer).geojson"
thaz = "Hazardous_Fuel_Treatment_Reduction%3A_Polygon_(Feature_Layer).geojson"
ahfra = "Healthy_Forest_Restoration_Act_Activities_(Feature_Layer).geojson"
irange = "Range_Vegetation_Improvement_(Feature_Layer).geojson"
nsilvi = "Silviculture_Reforestation_Needs_(Feature_Layer).geojson"
#o20 = "Public and Private Forest Ownership Conterminous United States (Image Service).tiff"

#agb_data <- stack(x) #GDALinfo(y)
agb_10 <- raster(a, band = 11) 
agb_17 <- raster(a, band = 18)
own_10 <- raster(o10)
own_17 <- raster(o17)
nepa <- st_read(anepa)
tsale <- st_read(atsale)
coll <- st_read(pcoll)
haz <- st_read(thaz)
hfra <- st_read(ahfra)
rangi <- st_read(irange)
silvi <- st_read(nsilvi)

#PREP AGB DATA
#Calculate percent change
agb_10m <- mask(agb_10,agb_17) #remove NAs from 2010
perc_chng <- (agb_17-agb_10m)/agb_10m
   #remove infs from percent change 
change <- calc(perc_chng,fun = function(x) {x[x==Inf]<- NA; return(x)})

#Transform to level 1, 2, 3
change <- calc(change,fun = function(x) {x[x>=0.05]<- 3; return(x)})
change <- calc(change,fun = function(x) {x[x>(-0.05) & x<0.05]<- 2; return(x)})
change <- calc(change,fun = function(x) {x[x<=(-0.05)]<- 1; return(x)})

#Plot AGB
par(mar = c(1, 1, 1, 1))
pal <- colorRampPalette(c("red","green"))
plot(change,col=pal(3), main ="Aboveground Biomass Change 2010-2017")

#PREP OWNERSHIP DATA
# import, establish dummy binary variables 
# crop extents to match + remove NAs
own10c <- crop(own_10, extent(-2361675,-285913.9,931625,1647599),snap="near")
own17c <- crop(own_17, extent(own10c),snap="near")
own_10m <- mask(own10c,own17c)

#change ownership to 0 vs. 1 -> public/private
ot10 <- calc(own10c,fun = function(x) {x[x<=3]<- NA; return(x)}) #non-forest
ot10 <- calc(ot10,fun = function(x) {x[x>=9&x<=19]<- 1; return(x)}) #private
ot10 <- calc(ot10,fun = function(x) {x[x==20]<- 0; return(x)}) #public

ot17 <- calc(own17c,fun = function(x) {x[x==8]<- NA; return(x)}) #exclude tribes
ot17 <- calc(ot17,fun = function(x) {x[x<=3]<- 1; return(x)}) #private
ot17 <- calc(ot17,fun = function(x) {x[x>=5&x<=7]<- 0; return(x)}) #public
par(mar = c(1, 1, 1, 1))
pal <- colorRampPalette(c("blue","red"))
plot(ot17,col=pal(3), main ="Ownership 2017")

#remove those that changed (i.e. difference is 1 or -1)
#subtract 2017 from 2010 -> if 1 or -1 -> make NA
#mask 2017 based off of 2010 NAs 


#PREP ACTIVITY + COST DATA
# import, establish dummy binary variables
# simplify to binary activity + costs
# intersect geometry w raster
#extract

#filter only 2010-2016 + need region  #back 1 year
nepa$NEPA_SIGNED_DATE <- as.Date(nepa$NEPA_SIGNED_DATE)
nepa1017<-filter(nepa,NEPA_SIGNED_DATE>"2010-01-01"&NEPA_SIGNED_DATE<"2017-01-01")

tsale1017<-filter(tsale,FY_AWARD>"2010-01-01"&FY_AWARD<"2017-01-01") 

coll1017<-filter(coll,FY_COMPLETED>"2010-01-01"&FY_COMPLETED<"2017-01-01")

haz1017<-filter(haz,FISCAL_YEAR_COMPLETED>"2010-01-01"&FISCAL_YEAR_COMPLETED<"2017-01-01")

hfra$LATEST_REVISION_DATE <- as.Date(hfra$LATEST_REVISION_DATE)
hfra1017<-filter(hfra,LATEST_REVISION_DATE>"2010-01-01"&LATEST_REVISION_DATE<"2017-01-01")

rangi$DATE_COMPLETED <- as.Date(rangi$DATE_COMPLETED)
rangi1017<-filter(rangi,DATE_COMPLETED>"2010-01-01"&DATE_COMPLETED<"2017-01-01")
rangi3 <- filter(rangi1017,ADMIN_REGION_CODE=="03")

silvi1017<-filter(silvi,FY_PLANNED>"2010"&FY_PLANNED<"2016")
silvi3 <- filter(silvi1017,REGION_CODE=="03")
#JOIN ALL TO OWNERSHIP FEATURE CLASS
#CREATE REGRESSION USING RF
#GENERATE FUTURE SCENARIO PREDICTIONS





#check for passing QA

#predict? - predict how ownership change will affect forest carbon?
#predict how carbon will fare in next few years under different scenarios?
#i.e. randomly assign certain amount of land to certain ownership and predict
#in each, then aggregate
#how much $

#can use as.logical



