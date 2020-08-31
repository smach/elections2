

# Downloaded and unzipped Framingham Districts and Precincts from Framingham Data Portal https://data.framinghamma.gov/browse?limitTo=maps updated May 9, 2018

# File: https://data.framinghamma.gov/api/geospatial/9pzx-4i9g?method=export&format=Shapefile

framingham_gis <- sf::st_read("data/FraminghamDistrictsAndPrecincts2018/geo_export_bbdc2912-e946-4345-a38b-334c03b5937b.shp")


usethis::use_data(framingham_gis, overwrite = TRUE)
