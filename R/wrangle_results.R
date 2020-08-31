

#' Get election winner and loser by election district from spreadsheet or CSV file
#'
#' @param election_results_file Excel or CSV file of election results with only two candidates (or yes/no for ballot questions). Should have only 3 columns: column 1 the precinct, city, county, state, or other election district; and columns 2 and 3 the candidate names (or yes and no, or any other two choices). Do NOT include any column or row totals.
#'
#' @return data.table with additional columns for total votes, winner, winner percent, loser's percent, winner's vote margin, and winner's percentage point margin.
#' @export
#' @importFrom data.table ":="

wrangle_results <- function(election_results_file) {
  results <- rio::import(election_results_file)

  results <- janitor::adorn_totals(results, c("row", "col"))
  original_names <- names(results)
  names(results) <- c("District", "ChoiceA", "ChoiceB", "Total")
  data.table::setDT(results)
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

  results[[new_col_pct_name]] <- round(results[[election_winner]] / results[["Total"]] , 3)

  loser_col_pct_name <- paste(election_loser, "Pct", sep = "_")

  results[[loser_col_pct_name]] <- round(results[[election_loser]] / results[["Total"]] , 3)
  results[[new_col_margin_name]] <- results[[election_winner]] - results[[election_loser]]

  new_col_pct_margin_name <- paste(new_col_pct_name, "Margin", sep = "_")
  results[[new_col_pct_margin_name]] <- results[[new_col_pct_name]] - results[[loser_col_pct_name]]

  results$Winner <- factor(results$Winner, levels = c(election_winner, election_loser, "Tie", "Unknown"))


  return(results)

}
