#' Generate interactive map of turnout
#'
#' Requires data with election district and turnout percent as a decimal between 0 and 1 joined with a shapefile.
#'
#' @param joined_df sf object shapefile of election districts that's been joined with election result
#' @param turnout_col character string name of column with turnout data
#' @param election_district_col character string name of column with election district data - should be name of 1st column from the wrangle_results() data frame
#' @param the_palette character string for color for leaflet colorNumeric function
#' @param map_tiles character string for available leaflet tile providers, defaults to "CartoDB.Positron". See http://leaflet-extras.github.io/leaflet-providers/preview/ for options.
#'
#' @return leaflet map object
#' @export
#'

map_turnout <- function(joined_df, turnout_col,  election_district_col, the_palette = "Greens", map_tiles = "CartoDB.Positron") {

  joined_df <- sf::st_transform(joined_df, "+proj=longlat +datum=WGS84")


  min_max_values <- range(c(joined_df[[turnout_col]], joined_df[[turnout_col]]), na.rm = TRUE)

  map_palette <- colorNumeric(palette = the_palette, domain=c(0, min_max_values[2]))



    map_popup <- glue::glue("<strong>{election_district_col}: {joined_df[[election_district_col]]}: {scales::percent(joined_df[[turnout_col]], accuracy = .1)}")  %>%   lapply(htmltools::HTML)


  my_map<- leaflet() %>%
    addProviderTiles(map_tiles) %>%
    addPolygons(
      data = joined_df,
      stroke = TRUE,
      smoothFactor = 0.2,
      fillOpacity = 0.8,
      fillColor = ~map_palette(joined_df[[turnout_col]]),
      color = "#666",
      weight = 1,
      label = map_popup
    )

  return(my_map)

}


