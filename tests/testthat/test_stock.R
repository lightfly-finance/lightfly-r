
add <- function (a, b) {
  a + b
}
test_that("add", {
  expect_equal(add(1, 1), 2)
})
