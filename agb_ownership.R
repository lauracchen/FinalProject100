#load libraries
library(rgdal) # package for geospatial analysis
library(ggplot2) # package for plotting
library(raster) # package for raster manipulation
library(sf)

#set wd
setwd("~/1.00/finalproject_100/")

#import AGB, ownership, and activity data
a = "MISR_agb_estimates_20002021.tif"
o14 = "own2014.tif"
o17 = "forest_own1.tif"
o20 = "Public and Private Forest Ownership Conterminous United States (Image Service).tiff"

#agb_data <- stack(x) #GDALinfo(y)
GDALinfo(o17)
GDALinfo(o20)
agb_10 <- raster(a, band = 11) 
agb_20 <- raster(a, band = 21)
own_14 <- raster(o14)
own_20 <- raster(o20)


#PREP AGB DATA
#Calculate percent change
agb_10m <- mask(agb_10,agb_20) #remove NAs from 2010
perc_chng <- (agb_20-agb_10m)/agb_10m
   #remove infs from percent change 
change <- calc(perc_chng,fun = function(x) {x[x==Inf]<- NA; return(x)})

#Transform to level 1, 2, 3
change <- calc(change,fun = function(x) {x[x>=0.05]<- 3; return(x)})
change <- calc(change,fun = function(x) {x[x>(-0.05) & x<0.05]<- 2; return(x)})
change <- calc(change,fun = function(x) {x[x<=(-0.05)]<- 1; return(x)})

#Plot AGB
par(mar = c(1, 1, 1, 1))
pal <- colorRampPalette(c("red","green"))
plot(change,col=pal(3), main ="Aboveground Biomass Change 2010-2020 [Mg/ha]")

#PREP OWNERSHIP DATA
# import, establish dummy binary variables 

own_17m <- mask(own_17,own_20)

#PREP ACTIVITY DATA
# import, establish dummy binary variables
# intersect geometry w 



plot(own_dem,
     main = "Forest ownership")
#hist(agb_20,
    # main = "Histogram of Aboveground Biomass")

#check for nas and remove
#check for passing QA

#predict? - predict how ownership change will affect forest carbon?
#predict how carbon will fare in next few years under different scenarios?
#i.e. randomly assign certain amount of land to certain ownership and predict
#in each, then aggregate
#how much $

#can use extract
#can use as.logical



