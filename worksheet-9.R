## Importing vector data

library(sf)
library(rgdal)

#Read in a shapefile (drop the extension)
shp <- 'data/cb_2016_us_county_5m'
counties <- st_read(shp, stringsAsFactors = FALSE)

## Bounding box

library(dplyr)
counties_md <- filter(counties, STATEFP == '24')

## Grid

grid_md <- st_make_grid(counties_md, n = 4)


## Plot layers

plot(grid_md)
plot(counties_md, add = TRUE)
plot(counties_md[,"ALAND"])

## Create geometry

sesync <- st_sfc(
  st_point(c(-76.503394, 38.976546)),
  crs = 4326)

class(sesync)
st_crs(sesync)

counties_md <- st_transform(counties_md, crs = st_crs(sesync))
plot(counties_md$geometry)
plot(sesync, col = "green", pch = 20, add = TRUE)

## Exercise 1
#TIP: always inspect objects when created...
#Find county in which sesync is found
county_id = st_within(sesync, counties_md)[[1]]
theCounty = counties_md[5,]
#theCounty <- st_transform(theCounty, crs = st_crs(sesync))
plot(theCounty$geometry, col = 'red') 
plot(sesync, col = "green", pch = 20, add = TRUE)
plot(counties_md, add = TRUE)



## Coordinate transforms
#read in hucs
shp <- 'data/huc250k'
huc <- st_read(shp)

#Examine projection of huc: note no epsg code, instead a long string
st_crs(huc)

#Create a projection string for the output coord sys
prj <- '+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs'

#Project the 3 datasets
counties_md <- st_transform(counties_md, crs = prj)
st_crs(counties_md)#Check
huc <- st_transform(huc, crs = prj)
sesync <- st_transform(sesync, crs = prj)
plot(counties_md$geometry)
plot(huc$geometry, border = 'blue', add = TRUE)
plot(sesync, col = 'green', pch = 20, add = TRUE)

## Geometric operations on vector layers
#Union (to dissolve)
state_md <- st_union(counties_md)
plot(state_md)

#Intersect with st_intersection
huc_md <- st_intersection(huc, state_md)
plot(huc_md, border = 'blue', col = NA, add = TRUE)

#what happens to attributes?
names(huc_md)

## Exercise 2

...

## Working with raster data

library(raster)
nlcd <- raster('data/nlcd_agg.grd')
class(raster)
nlcd #Check the resolution, coord ref, etc
plot(nlcd) #Show it...

## Crop

extent <- matrix(st_bbox(huc_md), nrow=2)
nlcd <- crop(nlcd, extent)
plot(nlcd)
plot(state_md, add=T)

## Raster data attributes
#Create a factor of raster attributes
lc_types <- nlcd@data@attributes[[1]]$Land.Cover.Class
class(lc_types)

## Raster math

pasture <- mask(nlcd, nlcd == 81, maskvalue = FALSE)
plot(pasture)

nlcd_agg <- ...(nlcd, ..., ...)
...
plot(nlcd_agg)

## Exercise 3

...

## Mixing rasters and vectors: prelude

sesync <- as(..., "Spatial")
huc_md <- as(..., "Spatial")
counties_md <- ...

## Mixing rasters and vectors

plot(nlcd)
plot(sesync, col = 'green', pch = 16, cex = 2, ...)

sesync_lc <- ...(nlcd, sesync)

county_nlcd <- ...

modal_lc <- extract(...)
... <- lc_types[modal_lc + 1]

