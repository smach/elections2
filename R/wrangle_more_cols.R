#' Get winner for race with three or more candidates
#'
#' @param election_results_file character string with name of Excel or CSV file in format with election district in 1st col.
#' @param start_col character string name of column starting the results
#' @param end_col character string name of column ending the results. All result cols must be adjacent.
#' @param show_pcts logical TRUE to display results as percents. Defaults to FALSE for vote totals.
#' @param show_runnerup logical TRUE to show 2nd place finisher. Defaults to TRUE.
#' @param show_margin logical TRUE to show margin between 1st and 2nd place. Deaflts to TRUE.
#'
#' @return data frame with results, totals, and district winner by number of votes
#' @export wrangle_more_cols

wrangle_more_cols <- function(election_results_file, start_col, end_col, show_pcts = FALSE, show_runnerup = TRUE, show_margin = TRUE) {
  results_all <- rio::import(election_results_file)

  vote_results <- results_all %>%
    dplyr::rowwise(1) %>%
    dplyr::mutate(
      Votes = list(sort(dplyr::c_across({{start_col}}:{{end_col}}), decreasing = TRUE)),
      Total = sum(dplyr::c_across({{start_col}}:{{end_col}}), na.rm = TRUE),
      Winner = "",
      RunnerUp = "",
      Margin = Votes[1] - Votes[2]
    )  %>%
    dplyr::select(-Votes) %>%
    dplyr::ungroup() %>%
    janitor::adorn_totals("row")

  col_nums <- match(c(start_col, end_col), names(vote_results) )



  for(i in 1:nrow(vote_results)){
    ranks <- rank(vote_results[i,col_nums[1]:col_nums[2]])
    maxrank <- as.numeric(max(ranks))
    ranks_without_max <- ranks[!(ranks %in% maxrank)]
    winners <- names(ranks[ranks==maxrank])
    runnerup <- names(ranks_without_max[ranks_without_max == as.numeric(max(ranks_without_max))])
    vote_results$Winner[i] <- paste(winners, collapse = ", ")
    vote_results$RunnerUp[i] <- paste(runnerup, collapse = ", ")
    if(length(winners) > 1) {
      vote_results$RunnerUp[i] <- ""
    }

  }

  if(!show_runnerup) {
    vote_results$RunnerUp <- NULL
  }


  if(!show_pcts) {
    vote_results <- dplyr::ungroup(vote_results)
    if(!show_margin) {
      vote_results$Margin <- NULL
    }
   return(vote_results)
  } else {



    percent_results <- dplyr::select(vote_results, -Margin, -Total) %>%
      dplyr::ungroup() %>%
      janitor::adorn_percentages() %>%
      janitor::adorn_rounding(3)

      if(show_margin) {
      percent_results <- percent_results %>%
        dplyr::rowwise(1) %>%
      dplyr::mutate(
        Percents = list(sort(dplyr::c_across({{start_col}}:{{end_col}}), decreasing = TRUE)),
        Margin = Percents[1] - Percents[2]
      ) %>%
      dplyr::select(-Percents) %>%
      dplyr::ungroup()
}


    return(percent_results)
  }



}




