library(testthat)
library(elections2)

fake_results <- wrangle_results(system.file("extdata", "FakeElectionResults.xlsx", package = "elections2"))

actual_results <- wrangle_results(system.file("extdata", "MarkeyKennedyFramingham2020.xlsx", package = "elections2"))



test_that("wrangle_results works", {
  expect_equal(actual_results$Markey[actual_results$Precinct == "Total"], 8542)
  expect_equal(actual_results$Kennedy[actual_results$Precinct == "Total"], 5668)
  expect_equal(actual_results$Markey[actual_results$Precinct == "5"], 656)
  expect_equal(actual_results$Kennedy[actual_results$Precinct == "18"], 172)
  expect_equivalent(actual_results$Markey_Margin[actual_results$Precinct == "7"], 703-360)
  expect_equivalent(actual_results$Markey_Pct[actual_results$Precinct == "1"], round ( (745 / (745 + 464)), 3) )
  expect_equivalent(actual_results$Markey_Pct_Margin[actual_results$Precinct == "1"], 0.616 - 0.384 )
  expect_equivalent(actual_results$Markey_Pct[actual_results$Precinct == "Total"], round(8542 / (8542 + 5668), 3) )


  expect_equal(as.character(fake_results$Winner[fake_results$Precinct == "1"]), "Marcy" )
  expect_equal(as.character(fake_results$Winner[fake_results$Precinct == "18"]), "Joe" )
  expect_equal(as.character(fake_results$Winner[fake_results$Precinct == "13"]), "Unknown" )
  expect_equal(as.character(fake_results$Winner[fake_results$Precinct == "14"]), "Tie" )
  expect_equal(as.character(fake_results$Winner[fake_results$Precinct == "Total"]), "Marcy" )

})
