library(testthat)
library(elections2)
myfile <- system.file("extdata", "Fake3Columns.xlsx", package = "elections2")
votes_results <- wrangle_more_cols(myfile, "Red", "Purple")
pct_results <- wrangle_more_cols(myfile, "Red", "Purple", show_pcts = TRUE)

test_that("wrangle more columns by votes", {
  expect_equal(votes_results$Winner[1], "Red")
  expect_equal(votes_results$Winner[4], "Blue")
  expect_equal(votes_results$Winner[votes_results$City == "City Ties"], "Blue, Green, Purple")
  expect_equal(votes_results$Margin[votes_results$City == "City Ties"], 0)
  expect_equal(votes_results$Margin[votes_results$City == "City E"], 100)
  expect_equal(votes_results$Total[4], 1023 + 2025 + 400 + 1034 + 505)
  expect_equal(votes_results$RunnerUp[3], "Blue, Green")
  expect_equal(votes_results$RunnerUp[7], "Green")
  expect_equal(votes_results$Winner[votes_results$City == "Total"], "Red")
  expect_equal(votes_results$RunnerUp[pct_results$City == "Total"], "Blue")})


test_that("wrangle more columns by percent", {
          expect_equal(pct_results$Winner[1], "Red")
          expect_equal(pct_results$Winner[4], "Blue")
          expect_equal(pct_results$Winner[pct_results$City == "City Ties"], "Blue, Green, Purple")
          expect_equal(pct_results$RunnerUp[3], "Blue, Green")
          expect_equal(pct_results$RunnerUp[7], "Green")
          expect_equal(pct_results$Winner[pct_results$City == "Total"], "Red")
          expect_equal(pct_results$RunnerUp[pct_results$City == "Total"], "Blue")
          expect_equivalent(pct_results$Margin[pct_results$City == "City Ties"], 0)
          expect_equivalent(pct_results$Blue[1], round(0.04590098, 3))


          })


