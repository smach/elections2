

#' Convert all NA values to z
#'
#' @param mydf data frame
#'
#' @return data frame with NAs converted to 0s
#'
na2zero2 <- function(mydf) {
  for (i in 1:nrow(mydf)) {
    for (j in 1:ncol(mydf)) {
      if (is.na(mydf[i, j]) && (is.numeric(mydf[, j]) ||
                                is.integer(mydf[, j]))) {
        mydf[i, j] <- 0
      }
    }
  }
return(mydf)

}
