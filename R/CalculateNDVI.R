### Jeroen Roelofs
### January 08 2015

#Function for calculating NDVI

CalculateNDVI <- function(x, y) {
  ndvi <- (y - x) / (x + y) # NDVI = (NIR - R) / (NIR + R)
  return(ndvi)
}