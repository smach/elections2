library(testthat)
library(elections2)
myfile <- system.file("extdata", "Fake3Columns.xlsx", package = "elections2")
votes_results_3plus <- wrangle_more_cols(myfile, c("Red", "Blue", "Orange", "Green", "Purple"))
pct_results_3plus <- wrangle_more_cols(myfile, c("Red", "Blue", "Orange", "Green", "Purple"), show_pcts = TRUE)

votes_results_3plus_no_runnerup <- wrangle_more_cols(myfile, c("Red", "Blue", "Orange", "Green", "Purple"), show_runnerup = FALSE)
pct_results_3plus_no_runnerup <- wrangle_more_cols(myfile, c("Red", "Blue", "Orange", "Green", "Purple"), show_pcts = TRUE, show_runnerup = FALSE)

test_that("wrangle more columns by votes", {
  expect_equal(votes_results_3plus$Winner[1], "Red")
  expect_equal(votes_results_3plus$Winner[votes_results_3plus$City == "City D"], "Blue")
  expect_equal(votes_results_3plus$Winner[votes_results_3plus$City == "City B"], "Blue, Green")
  expect_equal(votes_results_3plus$Winner[votes_results_3plus$City == "City Ties"], "Blue, Green, Purple")
  expect_equal(votes_results_3plus$Margin[votes_results_3plus$City == "City Ties"], 0)
  expect_equal(votes_results_3plus$Margin[votes_results_3plus$City == "City E"], 100)
  expect_equal(votes_results_3plus$Total[votes_results_3plus$City == "City D"], 1023 + 2025 + 400 + 1034 + 505)
  expect_equal(votes_results_3plus$RunnerUp[3], "Blue, Green")
  expect_equal(votes_results_3plus$RunnerUp[votes_results_3plus$City == "City F"], "Green")
  expect_equal(votes_results_3plus$Winner[votes_results_3plus$City == "Total"], "Red")
  expect_equal(votes_results_3plus$RunnerUp[pct_results_3plus$City == "Total"], "Blue")
  expect_equal(votes_results_3plus_no_runnerup$Winner[1], "Red")
  expect_equal(votes_results_3plus_no_runnerup$Winner[votes_results_3plus$City == "City D"], "Blue")
  expect_equal(votes_results_3plus_no_runnerup$Winner[votes_results_3plus$City == "City B"], "Blue, Green")


  })


test_that("wrangle more columns by percent", {
          expect_equal(pct_results_3plus$Winner[1], "Red")
          expect_equal(pct_results_3plus$Winner[5], "Blue")
          expect_equal(pct_results_3plus$Winner[pct_results_3plus$City == "City Ties"], "Blue, Green, Purple")
          expect_equal(pct_results_3plus$RunnerUp[3], "Blue, Green")
          expect_equal(pct_results_3plus$RunnerUp[8], "Green")
          expect_equal(pct_results_3plus$Winner[pct_results_3plus$City == "Total"], "Red")
          expect_equal(pct_results_3plus$RunnerUp[pct_results_3plus$City == "Total"], "Blue")
          expect_equivalent(pct_results_3plus$Margin[pct_results_3plus$City == "City Ties"], 0)
          expect_equivalent(pct_results_3plus$Blue[1], round(0.04590098, 3))


          })


