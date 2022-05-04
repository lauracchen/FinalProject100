# finalproject_100

<a href="http://www.youtube.com/watch?feature=player_embedded&v=X0aIhfBREj8
" target="_blank"><img src="http://img.youtube.com/vi/X0aIhfBREj8/0.jpg" 
alt="IMAGE ALT TEXT HERE" width="240" height="180" border="10" /></a>

Visit https://lcchen3.github.io/FinalProject100/ for high-level explanation of the analysis and process.

<b> agb_ownership.R </b>
Takes in AGB and ownership GeoTIFF raster data and forest activity GeoJSON data. Produces conditional density plots for initial relationship examination, linear regression, and Random Forests models. Outputs mapdata.GeoJSON, which has ownership ("layer), activity, and change in AGB data ("delagb") for 30mx30m polygons in forests spanning from Arizona to New Mexico.

<b> mapping.R </b>
Produces chloropleth plots from sf objects by reading in the geoJSON created by agb_ownership. These can be exported as images or PDFs.

<b> index.html </b>
Supports summary webpage/user interface using edited Bootstrap Carousel example template.

Install packages by:
install.packages("PACKAGE NAME") in the terminal

Packages required:
<ul>
  <li>
    sf # package for geospatial df manipulation
  </li>
  <li>
    geojsonio # package used in mapping script
  </li>
  <li>
    ggplot2 # package used in mapping script
  </li>
  <li>
    sp # package used in mapping script
  </li>
  <li>
    RColorBrewer # package used in mapping script
   </li>
   <li>
    rgdal # package for geospatial analysis
   </li>
   <li>
    ggplot2 # package for plotting
   </li>
   <li>
    raster # package for raster manipulation
   </li>
   <li>
    geojsonR #package for geoJSON
   </li>
   <li>
    dplyr #for data manipulation
   </li>
   <li>
    exactextractr #for faster value extraction via C++
   </li>
   <li>
    tictoc #checking run time
   </li>
 </ul>

