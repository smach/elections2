% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{mass_gis}
\alias{mass_gis}
\title{Data: Massachusetts city and town sf object}
\format{
An sf object with 351 rows of 18 variables:
\describe{
  \item{TOWN_ID}{integer MassGIS Town-ID Code (alphabetical, 1-351)}
  \item{TOWN}{character string with city or town name}
  \item{FIPS_STCO}{number Federal Information Processing Standard (FIPS) State/County Code}
  \item{CCD_MCD}{character string}
  \item{FIPS_PLACE}{character string}
  \item{POP1980}{number with 1980 population}
  \item{POP1990}{number with 1990 population}
  \item{POP2000}{number with 2000 population}
  \item{POPCH80_90}{number with population change}
  \item{POPCH90_00}{number with population change}
  \item{SHAPE_AREA}{number}
  \item{SHAPE_LEN}{number}
  \item{geometry}{polygon data}
  \item{Place}{character string with TOWN as Title Case}
}
}
\source{
\url{https://docs.digital.mass.gov/dataset/massgis-data-community-boundaries-towns}
}
\usage{
mass_gis
}
\description{
A geospatial sf object from a Massachusetts shapefile via Mass GIS
}
\keyword{datasets}
