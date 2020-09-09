#' Get winner for race with three or more candidates
#'
#' @param election_results_file character string with name of Excel or CSV file. File must be in format with election district in column one, and candidate or option raw vote results in columns adjacent to each other.
#' @param start_col character string name of column starting the results
#' @param end_col character string name of column ending the results
#'
#' @return data frame with results, totals, and district winner by number of votes
#' @export wrangle_more_cols

wrangle_more_cols <- function(election_results_file, start_col, end_col) {
  results_all <- rio::import(election_results_file)

  vote_results <- results_all %>%
    dplyr::rowwise(1) %>%
    dplyr::mutate(
      Votes = list(sort(dplyr::c_across({{start_col}}:{{end_col}}), decreasing = TRUE)),
      Total = sum(dplyr::c_across({{start_col}}:{{end_col}}), na.rm = TRUE),
      Winner = "",
      Margin = Votes[1] - Votes[2]
    )  %>%
    dplyr::select(-Votes) %>%
    dplyr::ungroup() %>%
    janitor::adorn_totals("row")

  col_nums <- match(c(start_col, end_col), names(vote_results) )


  for(i in 1:nrow(vote_results)){
    ranks <- rank(vote_results[i,col_nums[1]:col_nums[2]])
    maxrank <- as.numeric(max(ranks))
    winners <- names(ranks[ranks==maxrank])
    vote_results$Winner[i] <- paste(winners, collapse = ", ")
  }


return(vote_results)

}



#' Get winner and percents by district for race with three or more candidates or options
#'
#' @param election_results_file character string with name of Excel or CSV file. File must be in format with election district in column one, and candidate or option raw vote results in columns adjacent to each other.
#' @param start_col character string name of column starting the results
#' @param end_col character string name of column ending the results
#'
#' @return data frame with results, totals, and district winner by percents
#' @export wrangle_more_cols_pcts

wrangle_more_cols_pcts <- function(election_results_file, start_col, end_col) {
  results_all <- rio::import(election_results_file)

  vote_results <- results_all %>%
    dplyr::rowwise(1) %>%
    dplyr::mutate(
      Votes = list(sort(dplyr::c_across({{start_col}}:{{end_col}}), decreasing = TRUE)),
      Total = sum(dplyr::c_across({{start_col}}:{{end_col}}), na.rm = TRUE),
      Winner = "",
      Margin = Votes[1] - Votes[2]
    )  %>%
    dplyr::select(-Votes) %>%
    dplyr::ungroup() %>%
    janitor::adorn_totals("row")

  col_nums <- match(c(start_col, end_col), names(vote_results) )

  percent_results <- vote_results[,c(1, col_nums[1]:col_nums[2])] %>%
    dplyr::ungroup() %>%
    janitor::adorn_percentages()

  percent_results$Winner <- ""

  for(i in 1:nrow(percent_results)){
    ranks <- rank(percent_results[i,col_nums[1]:col_nums[2]])
    maxrank <- as.numeric(max(ranks))
    winners <- names(ranks[ranks==maxrank])
    percent_results$Winner[i] <- paste(winners, collapse = ", ")
  }

  return(percent_results)

}



#' Can I add a new function
#'
#' @param x string
#'
#' @return string
#' @export mytest

mytest <- function(x) {
  print(x)
}

