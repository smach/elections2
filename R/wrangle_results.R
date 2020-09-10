

#' Get election winner and loser by election district from spreadsheet or CSV file
#'
#' @param election_results_file Excel or CSV file of election results with only two candidates (or yes/no for ballot questions).
#' If turnout_columns = FALSE, your spreadsheet should have only 3 required columns:
#' Column 1 the precinct, city, county, state, or other election district; and columns 2 and 3 the candidate names (or yes and no, or any other two choices).
#' Do NOT include any column or row totals.
#' If turnout_columns = TRUE, include columns for total votes cast and total registered voters (but NOT turnout percent).
#' @param turnout_columns logical TRUE if spreadsheet includes columns for total votes cast and total registered voters. Defaults to FALSE.
#' @return data.table with additional columns for total votes, winner, winner percent, loser's percent, winner's vote margin, and winner's percentage point margin.
#' @export wrangle_results
#' @importFrom data.table ":="
#' @import data.table
#'@examples
#' my_election_results <- wrangle_results(system.file("extdata", "FakeElectionResults.xlsx", package = "elections2"))

wrangle_results <- function(election_results_file, turnout_columns = FALSE) {
  results_all <- rio::import(election_results_file)
  results <- results_all[, 1:3]
  results <- janitor::adorn_totals(results, c("row", "col"))

   data.table::setDT(results)

   original_names <- names(results)
  temp_names <- c("District", "ChoiceA", "ChoiceB", "Total")

 names(results) <- temp_names


  results[, Winner := data.table::fcase(
    ChoiceA > ChoiceB, original_names[2],
    ChoiceB > ChoiceA, original_names[3],
    ChoiceA == ChoiceB, "Tie",
    default = "Unknown"
  ) ]


  names(results) <- c(original_names , "Winner")

  election_winner <-   results$Winner[nrow(results)]
  election_loser <- setdiff(names(results)[2:3], election_winner)


  new_col_pct_name <- paste(election_winner, "Pct", sep = "_")

  new_col_margin_name <- paste(paste(election_winner, "Margin", sep = "_")  )

  # results[, (new_col_pct_name) := round(.SD[, ..election_winner] / Total, 3)]

  results[[new_col_pct_name]] <- round(results[[election_winner]] / results[["Total"]] , 3)

  loser_col_pct_name <- paste(election_loser, "Pct", sep = "_")

 #  suppressWarnings(results[, (loser_col_pct_name) := round(.SD[, ..election_loser] / Total, 3)])

  results[[loser_col_pct_name]] <- round(results[[election_loser]] / results[["Total"]] , 3)




  new_col_pct_margin_name <- paste(new_col_pct_name, "Margin", sep = "_")
  results[[new_col_pct_margin_name]] <- results[[new_col_pct_name]] - results[[loser_col_pct_name]]

   results[[new_col_margin_name]] <- results[[election_winner]] - results[[ election_loser]]

 # results[, Winner := factor(Winner, levels = c(election_winner, election_loser, "Tie", "Unknown"))]

  results$Winner <- factor(results$Winner, levels = c(election_winner, election_loser, "Tie", "Unknown"))

if (turnout_columns) {
  results_optional <- results_all[, -c(2:3)]
  results_optional <- janitor::adorn_totals(results_optional, "row")
  results_optional <- results_optional[, -1]
  results_optional$TurnoutPct <- round( (results_optional[[1]] / results_optional[[2]]), 3)
  results <- cbind(results, results_optional)
}
  return(results)
}


