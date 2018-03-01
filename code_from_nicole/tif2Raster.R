tif2Raster <- function(crop){
  
  # Goals
  #   (1) convert the .tif GAEZ images to rasters
  
  # Inputs
  #   (1) crop: string of crop name
  
  # Outputs
  #   (1) spatial raster ready for interpolation
  
  ## Set file information
  
  # set the file paramters
  fileDir1 <- '/Users/nicolejackson/Dropbox/Research/historical_cropland_optimization/data/gaez_irrigation/'
  fileDir2 <- 'gaez_irrigation_rasters/'
  fName <- paste0(crop,'_irrigation.tif')
  imageName <- paste0(fileDir1,
                      fileDir2,
                      fName)
  
    # load the file
  #   note: coerce coordinate system on the object
  temp.gaez <- raster(imageName,
                      native = TRUE)
  
  ## Export
  
  # export the loaded raster 
  output <- temp.gaez
  
    }
