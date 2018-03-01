interpRaster <- function(HYDEyear, faoYear){
  
  # Goals
  #   (1) Interpolate the HYDE raster layer to match 0.25-degree resolution grid
  
  # Inputs
  #   (1) justin_global_grid.Rda <-- lat-lon grid for 0.25-degrees
  #   (2) HYDEyear: numeric value in format yyyy
  #   (3) faoYear: numeric value in format yyyy
  
  # Outputs
  #   (1) dataframe porting over HYDE values to match Justin's grid
  
  ## Load and prep Justin's data
  
  # create file information containing Justin's grid
  justinDir1 <- '/Users/nicolejackson/Dropbox/Research/historical_cropland_optimization/data/'
  justinDir2 <- 'data_0.5-degree_resolution/'
  justinFname <- 'justin_0.5-degree_grid.Rda'
  justinFullname <- paste0(justinDir1,
                           justinDir2,
                           justinFname)
  
  # load the dataframe containing Justin's Grid at 0.5-degree resolution
  load(justinFullname) # loads as halfDegreeGrid
  
  # shift the data from the longitude to range from -180 - +180 instead of 0 - 360
  halfDegreeGrid$lon <- halfDegreeGrid$lon - 180
  
  # convert Justin's data to a raster
  justinRaster <- rasterFromXYZ(halfDegreeGrid)
  
  ## Load and clean the HYDE data
  
  # set the projection for the data
  sampleProjection <- CRS("+proj=longlat +datum=WGS84 +ellps=WGS84")
  
  # construct file information for loading HYDE raster
  hydeDir <- '/Users/nicolejackson/Dropbox/Research/historical_cropland_optimization/data/hyde_32/cropland/'
  hydeName <- paste0('cropland',HYDEyear,'AD.asc')
  hydeFname <- paste0(hydeDir, hydeName)
  
  # load the raster
  temp.hyde <- raster(hydeFname,
                      native = TRUE,
                      crs = sampleProjection)
  
  ## Interpolate between the two grids
  
  # set resolution for each raster to get ratio
  resJustin <- 0.5
  resHyde <- 1/12 # note: this is conversion of 5 arc minutes to equivalent degrees
  resRatio <- as.integer(resJustin/resHyde) # ratio of low to high resolution to the nearest integer
  
  # aggregate and resample to get interpolated values for Justin's grid
  newLayer <- aggregate(temp.hyde,
                        fact = resRatio,
                        fun = mean)
  
  # re-sample from nearly low res to Justin's grid
  revisedLayer <- resample(newLayer,
                           justinRaster,
                           method = 'ngb',
                           overwrite = TRUE)
  
  
  ## Convert the updated raster dataframe and export
  
  # convert the interpolated layer to a data.frame
  hydeHalfDegree <- as.data.frame(revisedLayer,
                                xy = TRUE)
  
  # rename the columns
  colnames(hydeHalfDegree) <- c('lon', 'lat', 'farmPct')
  
  ## Export dataframes
  
  # constuct file information for saving gaezPlusJustin
  
  saveDir1 <- '/Users/nicolejackson/Dropbox/Research/historical_cropland_optimization/data/'
  saveDir2 <- 'data_0.5-degree_resolution/'
  saveDir3 <- 'hyde_0.5-degree/'
  saveDir4 <- 'hyde_upconvert_raw_pixels/'
  saveFname <- paste0('hyde_0.5-degree_pixels_',faoYear,'.Rda')
  
  # construct the complete filename
  saveFullname <- paste0(saveDir1,
                         saveDir2,
                         saveDir3,
                         saveDir4,
                         saveFname)
  
  # save gaezPlusJustin
  save(hydeHalfDegree,
       file = saveFullname)
  
  # export the dataframe for use elsewhere
  output <- hydeHalfDegree
  
  }