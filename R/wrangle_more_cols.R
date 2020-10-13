#' Get winner for race with three or more candidates
#'
#' @param election_results_file character string with name of Excel or CSV file in format with election district in 1st col.
#' @param votes_cols vector of character strings with names of columns containing votes
#' @param show_pcts logical TRUE to display results as percents. Defaults to FALSE for vote totals.
#' @param show_runnerup logical TRUE to show 2nd place finisher. Defaults to TRUE.
#' @param show_margin logical TRUE to show margin between 1st and 2nd place. Defaults to TRUE.
#' @param show_margin_2vs3 logical TRUE to show margin between 2nd and 3rd place. Defaults to FALSE
#'
#' @return data table with results, totals, and district winner by number of votes
#' @export wrangle_more_cols
#' @examples
#' myfile <- system.file("extdata", "Fake3Columns.xlsx", package = "elections2")
#' mydata <- wrangle_more_cols(myfile, c("Red", "Blue", "Green"), show_pcts = TRUE, show_runnerup = FALSE)

wrangle_more_cols <- function(election_results_file, votes_cols, show_pcts = FALSE, show_runnerup = TRUE, show_margin = TRUE, show_margin_2vs3 = FALSE) {
  results_all <- rio::import(election_results_file)
  results_all <- na2zero2(results_all)
  district_col <- names(results_all)[1]
  results_all <- results_all[, c(district_col, votes_cols)]
  col_nums <- match(votes_cols, names(results_all) )
  vote_results <- janitor::adorn_totals(results_all, "row")
  data.table::setDT(vote_results)

  vote_results[, Total := sum(.SD, na.rm = TRUE), by = 1:nrow(vote_results), .SDcols = votes_cols]
  vote_results[, Winner := ""][, RunnerUp := ""][, Margin := 0]
  if(show_margin_2vs3) {
    vote_results[, MarginRunnerUp := 0]
  }

  for(i in 1:nrow(vote_results)){
    ranks <- vote_results[i, ..votes_cols] %>% unlist() %>% rank()
    maxrank <- max(ranks)
    ranks_without_max <- ranks[!(ranks %in% maxrank)]
    winners <- names(ranks[ranks==maxrank])
    if(length(ranks_without_max) > 0) {
    runnerup <- names(ranks_without_max[ranks_without_max == as.numeric(max(ranks_without_max))])
    vote_results$RunnerUp[i] <- paste(runnerup, collapse = ", ")
    vote_results$Winner[i] <- paste(winners, collapse = ", ")
    if(length(winners) > 1) {
      vote_results$RunnerUp[i] <- ""
    }
    } else {
      vote_results$Winner[i] <- ""
      vote_results$RunnerUp[i] <- ""
    }



    sorted_votes <- sort(vote_results[i, ..votes_cols], decreasing = TRUE) %>% unlist()


    vote_results$Margin[i] <- sorted_votes[1] - sorted_votes[2]


    if(show_margin_2vs3) {
      vote_results$MarginRunnerUp[i] <- sorted_votes[2] - sorted_votes[3]
    }

  }


  if(!show_runnerup) {
    vote_results$RunnerUp <- NULL
  }


  if(!show_pcts) {
   # vote_results <- dplyr::ungroup(vote_results)
    if(!show_margin) {
      vote_results$Margin <- NULL
    }
    if(!show_margin_2vs3 & "MarginRunnerUp" %in% names(vote_results)) {
      vote_results$MarginRunnerUp <- NULL
    }
   return(data.table::setDF(vote_results))
  } else {


    if("MarginRunnerUp" %in% names(vote_results)) {
      vote_results$MarginRunnerUp <- NULL
    }
    percent_results <- dplyr::select(vote_results, -Margin, -Total) %>%
  #    dplyr::ungroup() %>%
      janitor::adorn_percentages(na.rm = TRUE) %>%
      janitor::adorn_rounding(3) %>%
      data.table::as.data.table()

    percent_results[, Margin := 0]
    if(show_margin_2vs3) {
    percent_results[, MarginRunnerUp := 0]
    }

      if(show_margin) {
        for(i in 1:nrow(percent_results)) {
        sorted_margins <- sort(percent_results[i, ..votes_cols], decreasing = TRUE) %>% unlist() %>% unname()
        if(!is.null(sorted_margins)) {
        percent_results$Margin[i] <- sorted_margins[1] - sorted_margins[2]
        if(show_margin_2vs3) {
          percent_results$MarginRunnerUp[i] <- sorted_margins[2] - sorted_margins[3]
        }
        } else {
          percent_results$Margin[i] <- NA
          if(show_margin_2vs3) {
          percent_results$MarginRunnerUp[i] <- NA
          }
        }
        }
        # dplyr way:
       #  percent_results <- percent_results %>%
      #  dplyr::rowwise(1) %>%
    #  dplyr::mutate(
    #    Percents = list(sort(dplyr::c_across({{votes_cols}}), decreasing = TRUE)),
    #    Margin = Percents[1] - Percents[2]
   #   ) %>%
  #    dplyr::select(-Percents) %>%
  #    dplyr::ungroup()

}


    return(data.table::setDF(percent_results))
  }



}




