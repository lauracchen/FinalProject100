# finalproject_100

<a href="http://www.youtube.com/watch?feature=player_embedded&v=X0aIhfBREj8
" target="_blank"><img src="http://img.youtube.com/vi/X0aIhfBREj8/0.jpg" 
alt="IMAGE ALT TEXT HERE" width="240" height="180" border="10" /></a>

Visit https://lcchen3.github.io/FinalProject100/ for high-level explanation of the analysis and process.

agb_ownership.R


mapping.R
This file produces chloropleth plots from sf objects by reading in the geoJSON created by agb_ownership. These can be exported as images or PDFs.

Install packages by:
install.packages("PACKAGE NAME") in the terminal

Packages required:
sf # package for geospatial df manipulation
geojsonio # package used in mapping script
sp # package used in mapping script
rgdal # package for geospatial analysis
ggplot2 # package for plotting
raster # package for raster manipulation
geojsonR #package for geoJSON
dplyr #for data manipulation
exactextractr #for faster value extraction via C++
tictoc #checking run time

