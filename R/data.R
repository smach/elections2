#' Data: Framingham precinct sf object
#'
#' A geospatial sf object from a shapefile via the city of Framingham data portal with precinct geometry
#'
#' @format An sf object with 18 rows of 7 variables:
#' \describe{
#'   \item{district}{number with district number}
#'   \item{objectid}{number with city object ID}
#'   \item{precinct}{character string P and precinct number}
#'   \item{precncts_i}{number}
#'   \item{shape_star}{number}
#'   \item{shape_stle}{number}
#'   \item{geometry}{sfc_POLYGON with precinct geospatial data}

#' }
#' @source \url{https://data.framinghamma.gov/Community-Development/Framingham-Districts-and-Precincts/9pzx-4i9g}
"framingham_gis"



#' Data: Massachusetts city and town sf object
#'
#' A geospatial sf object from a Massachusetts shapefile via Mass GIS
#'
#' @format An sf object with 351 rows of 18 variables:
#' \describe{
#'   \item{TOWN_ID}{integer MassGIS Town-ID Code (alphabetical, 1-351)}
#'   \item{TOWN}{character string with city or town name}
#'   \item{FIPS_STCO}{number Federal Information Processing Standard (FIPS) State/County Code}
#'   \item{CCD_MCD}{character string}
#'   \item{FIPS_PLACE}{character string}
#'   \item{POP1980}{number with 1980 population}
#'   \item{POP1990}{number with 1990 population}
#'   \item{POP2000}{number with 2000 population}
#'   \item{POPCH80_90}{number with population change}
#'   \item{POPCH90_00}{number with population change}
#'   \item{SHAPE_AREA}{number}
#'   \item{SHAPE_LEN}{number}
#'   \item{geometry}{polygon data}
#'   \item{Place}{character string with TOWN as Title Case}

#' }
#' @source \url{https://docs.digital.mass.gov/dataset/massgis-data-community-boundaries-towns}
"mass_gis"



