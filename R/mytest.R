


#' data.table test function
#'
#' @param mycols string
#' @param mydata data.table
#'
#' @return data.table
#' @export
#'
mytest <- function(mycols, mydata) {
  mydt <- mydata[, ..(mycols)]
  return(mydt)
}
