# MAPPING IN LEAFLET
library(leaflet)
library(mapview)
library(geojsonio)
library(rmapshaper)
library(sp)

memory.limit(100000)
#import as sp object and simplify geometry to reduce memory use
data <- geojsonio::geojson_read("mapdata.geojson", what = "sp")
tic()
simp_data <- ms_simplify(data,sys=TRUE)
toc()

#AGB change map
tic()
bins = c(1, 2, 3)
pal <- colorBin("BuPu", domain = data$delagb, bins = bins)
mymap <- leaflet(data) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  setView(lng = -111.2604, lat = 33.8885, zoom = 12)
mymap %>% addPolygons(
  fillColor = ~pal(delagb),
  weight = 1,
  opacity = 1,
  color = 'white',
  dashArray = "3",
  fillOpacity = 0.8
) %>%
  addLegend(
    pal = pal, 
    values = ~delagb, 
    opacity = 0.8,
    title = "Change in AGB",
    position = "bottomright")
mymap
toc()

#Save image
library(mapview)
mapshot(map1, file = "~/map_own.png")