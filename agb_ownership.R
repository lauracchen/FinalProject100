#load libraries
library(rgdal) # package for geospatial analysis
library(ggplot2) # package for plotting
library(raster) # package for raster manipulation

#set wd
setwd("~/1.00/finalproject_100/")

#import AGB and ownership data
x = "MISR_agb_estimates_20002021.tif"
y = "forest_own1.tif"
#GDALinfo(x)
agb_1 <- raster(x)
agb_20 <- raster(x, band = 20)
agb_data <- stack(x)

own_dem <- raster(y)
#GDALinfo(y)


par(mar = c(1, 1, 1, 1))
plot(agb_20,
     main = "Aboveground Biomass [Mg/ha]")

plot(own_dem,
     main = "Forest ownership")
#hist(agb_20,
    # main = "Histogram of Aboveground Biomass")

#check for nas and remove
#check for passing QA
#what other data -> 
#wildfire risk, stewardship contracts, amount of $ spent

#random forests

#predict? - predict how ownership change will affect forest carbon?
#predict how carbon will fare in next few years under different scenarios?
#i.e. randomly assign certain amount of land to certain ownership and predict
#in each, then aggregate
#how much $




