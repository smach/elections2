
na2zero2 <- function(mydf) {

  for (i in 1:nrow(mydf)) {
    for (j in 1:ncol(mydf)) {
      if (is.na(mydf[i, j]) && (is.numeric(mydf[, j]) ||
                                is.integer(mydf[, j]))) {
        mydf[i, j] <- 0
      }
    }
  }
return(data.table::setDT(mydf))

}
