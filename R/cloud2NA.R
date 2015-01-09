### Jeroen Roelofs
### January 08 2015

# Value replacement function
cloud2NA <- function(x, y){
  x[y != 0] <- NA
  return(x)
}