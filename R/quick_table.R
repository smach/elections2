


#' Create a quick searchable, sortable table of results with the DT package
#'
#' Features colored bars in percent columns and allows for searching by regular expression
#'
#' @param election_df data table of election results generated by wrangle_results() including Total row
#' @param pagination integer how many rows to display on each color
#' @param win_color character string for color bar in winner's percent column, defaults to "#c2a5cf" (a light purple). Use "none" for no colored bar.
#' @param lose_color character string for color bar in winner's percent column, defaults to "#a6dba0" (a light green). Use "none" for no colored bar.
#' @param n_turnout_cols integer how many turnout columns have been joined to election_df: 0 for no data about turnout; 1 for a column with turnout percent only; or 3 for columns containing total votes cast, total registered voters, and percent turnout. Defaults to 0.
#' @param use_regex_searching logical whether to allow searching by regular expression, defaults to TRUE
#' @return html widget with interactive table of results
#' @export
#'
#' @examples
#' myfile <- system.file("extdata", "FakeElectionResults.xlsx", package = "elections2")
#' my_election_results <- wrangle_results(myfile)
#' quick_table(my_election_results)
#' quick_table(my_election_results, win_color = "none", lose_color = "none")

quick_table <- function(election_df, pagination = 20, win_color = "#c2a5cf", lose_color = "#a6dba0", use_regex_searching = TRUE, n_turnout_cols = 0) {

  names(election_df) <- gsub("_", " ", names(election_df))
  col_with_winners_vote_total <- as.character(election_df$Winner[nrow(election_df)] )

  candidates <- names(election_df)[1:3]
  election_district_col_name <- candidates[1]
  if(candidates[2] != col_with_winners_vote_total) {
    data.table::setcolorder(data.table::setDT(election_df), c(1,3,2))
  }
 # win_pct_col_name <- paste0(col_with_winners_vote_total, "_Pct")
#  lose_pct_col_name <- paste0(names(election_df)[3], "_Pct")

  win_pct_col_name <- paste0(col_with_winners_vote_total, " Pct")
  lose_pct_col_name <- paste0(names(election_df)[3], " Pct")

  # choose which columns to display and format based on n_turnout_cols
  if(n_turnout_cols == 0) {
    display_cols <- 1:9
    comma_cols <- c(2,3,4,9)
    percent_cols <- c(6,7,8)
  } else if (n_turnout_cols == 1) {
    display_cols <- c(1:10)
    comma_cols <- c(2,3,4,8)
    percent_cols <- c(6,7,9,10)
  } else if (n_turnout_cols == 3) {
    display_cols <- c(1:12)
    comma_cols <- c(2,3,4,8, 10, 11)
    percent_cols <- c(6,7,9,12)
  }
data.table::setDF(election_df)



  the_table <- DT::datatable(election_df[, c(display_cols)], rownames = FALSE, filter = 'top',
                             class = "stripe cell-border hover",
                             options = list(
                               pageLength = pagination,
                               search = list(regex = use_regex_searching)
                             )) %>%
    DT::formatCurrency(comma_cols, currency = '', digits = 0) %>%
    DT::formatPercentage(percent_cols, digits = 1)

    if(tolower(win_color) != "none")  {
      the_table <- the_table %>%
    DT::formatStyle(win_pct_col_name,
                    background = DT::styleColorBar( c(0,1), win_color),
                    backgroundSize = '98% 88%',
                    backgroundRepeat = 'no-repeat',
                    backgroundPosition = 'center'
    ) }

  if(tolower(lose_color) != "none")  {
   the_table <- the_table %>%
     DT::formatStyle(lose_pct_col_name,
                    background = DT::styleColorBar( c(0,1), lose_color),
                    backgroundSize = '98% 88%',
                    backgroundRepeat = 'no-repeat',
                    backgroundPosition = 'center'
    )
  }

  return(the_table)

}




#' Create interactive table of results with bar graph for win pct margin
#'
#' @param election_df data frame with results from wrangle_results() or wrangle_more_cols()
#' @param pagination integer number of results on page, defaults to 20
#' @param win_color character string with color hex code
#' @param lose_color character string with color hex code
#'
#' @return reactable interactive HTML table
#' @importFrom data.table ":="
#' @export
#'

quick_table_w_bargraphs <- function(election_df, pagination = 20, win_color  = "#c2a5cf", lose_color = "#a6dba0") {

  col_with_winners_vote_total <- as.character(election_df$Winner[nrow(election_df)] )
  candidates <- names(election_df)[1:3]
  election_district_col_name <- candidates[1]
  if(candidates[2] != col_with_winners_vote_total) {
    data.table::setcolorder(data.table::setDT(election_df), c(1,3,2))
  }
  win_pct_col_name <- paste0(col_with_winners_vote_total, "_Pct")
  lose_pct_col_name <- paste0(names(election_df)[3], "_Pct")
  margin_pct_col_name <- paste0(col_with_winners_vote_total, "_Pct_Margin")
  margin_col_name <- paste0(col_with_winners_vote_total, "_Margin")
  data.table::setDT(election_df)
  names(election_df)[names(election_df) == margin_pct_col_name] <- "Winner_Pct_Margin"
  names(election_df)[names(election_df) == margin_col_name] <- "Winner_Vote_Margin"

  election_df[, Winner := as.character(Winner)]
  # election_df <- election_df[!is.na(Winner_Pct_Margin)]
  election_df[, Winner_Pct_Margin := ifelse(is.na(Winner_Pct_Margin), 0, Winner_Pct_Margin)]
  election_df[, Winner_Vote_Margin := ifelse(is.na(Winner_Vote_Margin), 0, Winner_Vote_Margin)]



    display_cols <- 1:9
    comma_cols <- c(2,3,4,9)
    percent_cols <- c(6,7)


  data.table::setDF(election_df)
  election_df[, percent_cols] <- election_df[, percent_cols] * 100

#### Start table with bar charts ####

  library(htmltools)
  bar_chart_pos_neg <- function(label, value, max_value = 1, height = "16px", pos_fill = win_color, neg_fill = lose_color) {
    neg_chart <- div(style = list(flex = "1 1 0"))
    pos_chart <- div(style = list(flex = "1 1 0"))
    width <- paste0(abs(value / max_value) * 100, "%")

    if (value < 0) {
      bar <- div(style = list(marginLeft = "8px", background = neg_fill, width = width, height = height))
      chart <- div(style = list(display = "flex", alignItems = "center", justifyContent = "flex-end"), label, bar)
      neg_chart <- tagAppendChild(neg_chart, chart)
    } else {
      bar <- div(style = list(marginRight = "8px", background = pos_fill, width = width, height = height))
      chart <- div(style = list(display = "flex", alignItems = "center"), bar, label)
      pos_chart <- tagAppendChild(pos_chart, chart)
    }

    div(style = list(display = "flex"), neg_chart, pos_chart)
  }


  names(election_df) <- gsub("_", " ", names(election_df))

  reactable::reactable(election_df, bordered = TRUE, searchable = TRUE,
            showSortable = TRUE, showSortIcon = TRUE,
            defaultColDef = reactable::colDef(
            format = reactable::colFormat(separators = TRUE),
            headerStyle = list(background = "#f7f7f8")
            ),
            defaultPageSize = pagination,
            columns = list(
    Winner = reactable::colDef(name = "Winner", minWidth = 100),
    `Winner Pct Margin` = reactable::colDef(
      defaultSortOrder = "desc",
      cell = function(value) {
        label <- paste0(round(value * 100), "%")
        bar_chart_pos_neg(label, value)
      },
      align = "center",
      minWidth = 400
    ),
    `Winner Vote Margin` = reactable::colDef(
      defaultSortOrder = "desc",
      cell = function(value) {
        label <- scales::comma(value)
        bar_chart_pos_neg(label, value, max_value = max(abs(election_df$`Winner Vote Margin`[election_df[[1]] != "Total"])))
      },
      align = "center",
      minWidth = 400
    )

  ))


}
