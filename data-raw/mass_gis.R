mass_gis <- sf::st_read("inst/extdata/boundaries/BOUNDARY_POLY.shp")
mass_gis$Place <- tools::toTitleCase(tolower(mass_gis$TOWN))
mass_gis <- sf::st_transform(mass_gis, "+proj=longlat +datum=WGS84")
use_data(mass_gis, overwrite = TRUE)
