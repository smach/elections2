# elections2
Wrangle and Visualize Election Data 
Easily analyze your election results data with the election2 package. One command calculates winners and percents for each election district row as well as overall totals.

Then, take those results and turn them into interactive tables, bar charts, and maps with functions like `bargraph_of_margins()`, `quick_table()`, and `map_election_results()`.

election2 is designed for journalists, hobbyists, analysts, and data geeks who want to quickly go from a spreadsheet or CSV file with raw vote totals to visualizations that help you see trends behind the data.

Note: This package is not on CRAN, so you need to install it from GitHub with the R package and function of your choice, such as

`devtools::install_github("smach/elections2", build_vignettes = TRUE)`


## Data wrangling

To use elections2 for your elections data, start with one of the package functions that wrangle a spreadsheet or CSV file with election results. You've got two options: `wrangle_results()` to generate detailed results from a file _with only two candidates or choices;_ and `wrangle_more_cols()` for results with _more than two choices._

### Data with only 2 choices

`wrangle_results()` is for when you want to compare the performance of only two candidates or a yes-no ballot question. That means you don't wish to include additional results such as third parties, write-ins, or blanks.

The function returns winner, percents, and percent and vote margins  for each row as well as an overall total. The function also has a turnout_columns option if your data includes columns for vote totals and total registered voters and you'd like to calculate turnout percentage.

After running `wrangle_results()` on your data, you can use this package's visualization functions on the results to create tables, bar graphs, and maps.

#### Data format

`wrangle_results()` needs your data to be in a very specific format.

If your CSV file or spreadsheet doesn't include turnout data, that election results file _must_ be in the following 3-column format:

**Column 1** should be the election districts (such as precinct, city, county, etc.). 
**Columns 2 and 3** should be the candidates' names, "Yes" and "No" for ballot questions, etc. The values should be _raw vote totals_ and not percents.

Do _not_ include any column or row totals in the file!

If your data _does_ have turnout information, set turnout_columns = TRUE as an argument in `wrangle_results()`. Your data needs to have total number of votes in column 4 and total number of registered voters in column 5. _Don't_ include a column for turnout percent, as this will be calculated by `wrangle_results()`.

```
library(elections2)
results_file <- system.file("extdata", "FakeElectionResults.xlsx", package = "elections2")

my_election_data <- wrangle_results(results_file)

```

You can see result of `wrangle_results()` with a command such as:


`head(my_election_data, n = 3)`


It includes a Total row.

Per a user request, wrangle_results() _also_ can take the name of a data frame with data in the proper format. The name of the object _must_ be in quotation marks.

### Data with 3 or more choices

To analyze and visualize election results with three or more choices -- a crowded primary or a multi-party election, for example -- use the `wrangle_more_cols()` function. 

For this function, your results spreadsheet or CSV should have the election district (precinct, city, etc.) in the first column. Vote totals (for candidates, parties, etc.) should be in a format with one column for each candidate Don't include a total row or column, since those will be calculated.

`wrangle_more_cols()` has two required arguments: election_results_file, the file name; and votes_cols, a vector of character strings with all the vote columns by candidate/party/option. votes_cols can also be an vector of integers with column index numbers instead of names if the optional argument use_column_numbers is set to TRUE.

Per a user request, `wrangle_more_cols()` _also_ can take the name of a data frame with data in the proper format. The name of the object _must_ be in quotation marks.

`wrangle_more_cols()` also has five optional logical arguments: show_pcts to return results as percents instead of total votes, show_runnerup to include a column with the 2nd-place finisher, show_margin to display a column with the difference between the 1st- and 2nd-place finishers,  show_margin_2vs3 to show the difference between the 2nd- and 3rd-place finishers, and use_column_numbers if you want to use column index numbers instead of column names for the vector of vote columns.

In the example below, I have a file of fake results for the "Red", "Blue", and "Green" parties. I'd like to show results as percents, and I don't want a column for the runner up:

```
myfile <- system.file("extdata", "Fake3Columns.xlsx", package = "elections2")

mydata <- wrangle_more_cols(myfile, c("Red", "Blue", "Green"), show_pcts = TRUE, show_runnerup = FALSE)

head(mydata)

```

`wrangle_more_cols()` has four optional arguments: show_pcts to return results as percents instead of total votes, show_runnerup to include a column with the 2nd-place finisher, show_margin to display a column with the difference between the 1st- and 2nd-place finishers, and show_margin_2vs3 to show the difference between the 2nd- and 3rd-place finishers. 

## Visualizations

**Interactive tables** Use the `quick_table()` or `quick_table_more_cols()` functions. See the tables vignette with `vignette("tables", package = "elections2")` for more.

**Bar charts** Use the `bar_graph_of_winner_pct_margins()` function. See the barcharts vignette with `vignette("barcharts", package = "elections2")` for more info.

**Election results maps** See the maps vignette: `vignette("maps", package = "elections2")

**Turnout maps** See the turnout maps vignette: `vignette("map_turnout", package = "elections2")



