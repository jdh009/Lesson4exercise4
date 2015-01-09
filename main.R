### Jeroen Roelofs
### January 08 2015

# Load packages.
library(rgdal)
library(raster)
library(downloader)

# Source Scripts
source("R/Cloud2NA.R")
source("R/CalculateNDVI.R")

# Download data from source. Does not work for windows, got the files by direct download. Can skip this part if needed
# download('https://www.dropbox.com/s/i1ylsft80ox6a32/LC81970242014109-SC20141230042441.tar.gz?dl=0', "data/LC81970242014109-SC20141230042441.tar", quiet = T, mode = "wb")
# download('https://www.dropbox.com/s/akb9oyye3ee92h3/LT51980241990098-SC20150107121947.tar.gz?dl=0', "data/LT51980241990098-SC20150107121947.tar", quiet = T, mode = "wb")

# Unpackage data.
untar("data/LC81970242014109-SC20141230042441.tar", exdir = 'data/LC81970242014109-SC20141230042441/')
untar("data/LT51980241990098-SC20150107121947.tar", exdir = 'data/LT51980241990098-SC20150107121947/')

# Load data Landsat 5 (1990).
Landsat5b3 <- raster("data/LT51980241990098-SC20150107121947//LT51980241990098KIS00_sr_band3.tif")
Landsat5b4 <- raster("data/LT51980241990098-SC20150107121947//LT51980241990098KIS00_sr_band4.tif")
Landsat5Clouds <- raster("data/LT51980241990098-SC20150107121947//LT51980241990098KIS00_cfmask.tif")

# Load data Landsat 8 (2014).
Landsat8b4 <- raster("data/LC81970242014109-SC20141230042441//LC81970242014109LGN00_sr_band4.tif")
Landsat8b5 <- raster("data/LC81970242014109-SC20141230042441//LC81970242014109LGN00_sr_band5.tif")
Landsat8Clouds <- raster("data/LC81970242014109-SC20141230042441//LC81970242014109LGN00_cfmask.tif")

#preprocessing cloud removal
# Remove surface water and replace 'clear Land by NA'
Landsat5Clouds[Landsat5Clouds == 0] <- NA
Landsat8Clouds[Landsat8Clouds == 0] <- NA

#Remove clouds from images
#Landsat5 (CF = Cloud Free)
Landsat5b3CF <- overlay(x = Landsat5b3, y = Landsat5Clouds, fun = cloud2NA)
Landsat5b4CF <- overlay(x = Landsat5b4, y = Landsat5Clouds, fun = cloud2NA)
#Landsat8 (CF = Cloud Free)
Landsat8b4CF <- overlay(x = Landsat8b4, y = Landsat8Clouds, fun = cloud2NA)
Landsat8b5CF <- overlay(x = Landsat8b5, y = Landsat8Clouds, fun = cloud2NA)

#Calculating NDVI for 1990 & 2014
Landsat5NDVI <- CalculateNDVI(Landsat5b3CF, Landsat5b4CF)
Landsat8NDVI <- CalculateNDVI(Landsat8b4CF, Landsat8b5CF)

#Test plot NDVI
# plot(Landsat5NDVI)
# plot(Landsat8NDVI)

# NDVI Change between 1990 & 2014 and Cutting to the overlapping extent
# Warning message: In Landsat5NDVI - Landsat8NDVI : Raster objects have different extents. Result for their intersection is returned
NDVIchanges <- Landsat5NDVI - Landsat8NDVI

# An other way to calculate the extent but with more code and one step extra
# extent <- intersect(Landsat5b3, Landsat8b4)
## extent <- intersect(Landsat5b4, Landsat8b5)
## extent <- intersect(Landsat8b4, Landsat5b3)
## extent <- intersect(Landsat8b5, Landsat5b4)
# extent(extent) 

# Plot result
plot(NDVIchanges)

#Write to disk
writeRaster(NDVIchanges, filename = "Output/NDVIchanges")
