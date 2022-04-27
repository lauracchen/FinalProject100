# Import, manipulate, and prepare data for RF regression analysis 
# Response variable: Change in AGB 2010-2017; Predictors: Ownership (public/private); management activities

#LOAD LIBRARIES
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


#PREPARE AGB DATA
#Calculate percent change
agb_10m <- mask(agb_10,agb_17) #remove NAs from 2010
perc_chng <- (agb_17-agb_10m)/agb_10m

#Remove infs from percent change 
change <- calc(perc_chng,fun = function(x) {x[x==Inf]<- NA; return(x)})

#Crop AGB data
change<-crop(change,extent(-1500000,-1000000,1100000,1550000))

#Transform to level 1, 2, 3 [decreasing, stable, increasing AGB]
change <- calc(change,fun = function(x) {x[x>=0.05]<- 3; return(x)})
change <- calc(change,fun = function(x) {x[x>(-0.05) & x<0.05]<- 2; return(x)})
change <- calc(change,fun = function(x) {x[x<=(-0.05)]<- 1; return(x)})

#Plot AGB
par(mar = c(1, 1, 1, 1))
pal <- colorRampPalette(c("red","green"))
plot(change,col=pal(3), main ="Aboveground Biomass Change 2010-2017")

#PREP OWNERSHIP DATA
# Crop and resample extents to match + remove NAs
changec <- projectRaster(own_10,crs = crs(change))
#own17cr <- projectRaster(own_17,crs = crs(change))
own10c <- crop(changec, extent(change),snap="in")
#own17c <- crop(own17cr,extent(change),snap="in")

#getting messed up here
#own17c <- crop(own_17, extent(change),snap="in")
extent(own10c)
extent(own17c)
#made same extent but didn't graph correctly
own17r <- raster::resample(own_17,own10c,method="bilinear")
extent(own17c)==extent(own10c)
extent(own17r)
own_10m <- mask(own10c,own17r)

compareCRS(crs(own10c),crs(changec))
#establish dummy var. - 0 = public; 1 = private
ot10 <- calc(own10c,fun = function(x) {x[x<9] <- NA; return(x)}) #non-forest
ot10 <- calc(ot10,fun = function(x) {x[x>=9&x<=19] <- 1; return(x)}) #private
ot10 <- calc(ot10,fun = function(x) {x[x>19] <- 0; return(x)}) #public

#ot17 <- calc(own17r,fun = function(x) {x[x<=4]<- 1; return(x)}) #private
#ot17 <- calc(ot17,fun = function(x) {x[x>=5&x<=7] <- 0; return(x)}) #public
#ot17 <- calc(ot17,fun = function(x) {x[x>7] <- NA; return(x)}) #exclude tribes

ot_10<-crop(ot10,extent(-1500000,-1000000,1100000,1550000))
par(mar = c(1, 1, 1, 1))
pal2 <- colorRampPalette(c("blue","red"))
plot(ot_10,col=pal2(5), main ="Ownership 2010")
##make those that changed ownership NA (i.e. difference is 1 or -1)
##ot10 <- ot10-ot17
##ot10 <- calc(ot10,fun = function(x) {x[x==-1|x==1]<- NA; return(x)}) #changed ownership
##ot17 <- mask(ot17,ot10)


#PREPARE ACTIVITY DATA
#Filter only 2010-2016 + region 3 if possible
nepa$NEPA_SIGNED_DATE <- as.Date(nepa$NEPA_SIGNED_DATE)
nepa1017<-filter(nepa,NEPA_SIGNED_DATE>"2010-01-01"&NEPA_SIGNED_DATE<"2017-01-01"&ADMIN_REGION_CODE=="03")

tsale1017<-filter(tsale,FY_AWARD>"2010-01-01"&FY_AWARD<"2017-01-01"&ADMIN_REGION_CODE=="03")

coll1017<-filter(coll,FY_COMPLETED>"2010-01-01"&FY_COMPLETED<"2017-01-01"&REGION_CODE=="03")

haz1017<-filter(haz,FISCAL_YEAR_COMPLETED>"2010-01-01"&FISCAL_YEAR_COMPLETED<"2017-01-01"&ADMIN_REGION_CODE=="03")

hfra$LATEST_REVISION_DATE <- as.Date(hfra$LATEST_REVISION_DATE)
hfra1017<-filter(hfra,LATEST_REVISION_DATE>"2010-01-01"&LATEST_REVISION_DATE<"2017-01-01")
#extent not cropped

rangi$DATE_COMPLETED <- as.Date(rangi$DATE_COMPLETED)
rangi1017<-filter(rangi,DATE_COMPLETED>"2010-01-01"&DATE_COMPLETED<"2017-01-01"&ADMIN_REGION_CODE=="03")

silvi1017<-filter(silvi,FY_PLANNED>"2010"&FY_PLANNED<"2016"&REGION_CODE=="03")
#extent not cropped


#JOIN AGB TO OWNERSHIP FEATURE CLASS
#change to polygon format, convert to sf
ot_sf <- st_as_sf(rasterToPolygons(ot_10,na.rm=TRUE)) #didn't dissolve to save memory
#assign agb change values to ownership
own_agb <- mutate(ot_sf,agbchange=extract(change,ot_poly))

master <- own_agb
#JOIN ALL ACTIVITIES TO MASTER FEATURE CLASS
#generate 0s for activity variables
master['nepa'] <- 0
master['tsale'] <- 0
master['coll'] <- 0
master['haz'] <- 0
master['hfra']<- 0
master['rangi'] <- 0
master['silvi'] <- 0

#if activity intersects, assign value of 1
master <- for (i in 1:nrow(master)) {
  if (lengths(st_intersects(master, nepa1017)[i])>0) {
    master$nepa[i] <- 1
  } }


#CREATE REGRESSION USING RF


#TEST REGRESSION 


#GENERATE FUTURE SCENARIO PREDICTIONS



#Ideally, would check for passing AGB data for passing quality assurance



