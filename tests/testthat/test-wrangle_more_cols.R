library(testthat)
library(elections2)
myfile <- system.file("extdata", "Fake3Columns.xlsx", package = "elections2")
votes_results_3plus <- wrangle_more_cols(myfile, "Red", "Purple")
pct_results_3plus <- wrangle_more_cols(myfile, "Red", "Purple", show_pcts = TRUE)

test_that("wrangle more columns by votes", {
  expect_equal(votes_results_3plus$Winner[1], "Red")
  expect_equal(votes_results_3plus$Winner[4], "Blue")
  expect_equal(votes_results_3plus$Winner[votes_results_3plus$City == "City Ties"], "Blue, Green, Purple")
  expect_equal(votes_results_3plus$Margin[votes_results_3plus$City == "City Ties"], 0)
  expect_equal(votes_results_3plus$Margin[votes_results_3plus$City == "City E"], 100)
  expect_equal(votes_results_3plus$Total[4], 1023 + 2025 + 400 + 1034 + 505)
  expect_equal(votes_results_3plus$RunnerUp[3], "Blue, Green")
  expect_equal(votes_results_3plus$RunnerUp[7], "Green")
  expect_equal(votes_results_3plus$Winner[votes_results_3plus$City == "Total"], "Red")
  expect_equal(votes_results_3plus$RunnerUp[pct_results_3plus$City == "Total"], "Blue")})


test_that("wrangle more columns by percent", {
          expect_equal(pct_results_3plus$Winner[1], "Red")
          expect_equal(pct_results_3plus$Winner[4], "Blue")
          expect_equal(pct_results_3plus$Winner[pct_results_3plus$City == "City Ties"], "Blue, Green, Purple")
          expect_equal(pct_results_3plus$RunnerUp[3], "Blue, Green")
          expect_equal(pct_results_3plus$RunnerUp[7], "Green")
          expect_equal(pct_results_3plus$Winner[pct_results_3plus$City == "Total"], "Red")
          expect_equal(pct_results_3plus$RunnerUp[pct_results_3plus$City == "Total"], "Blue")
          expect_equivalent(pct_results_3plus$Margin[pct_results_3plus$City == "City Ties"], 0)
          expect_equivalent(pct_results_3plus$Blue[1], round(0.04590098, 3))


          })


