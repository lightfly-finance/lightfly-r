
app_id = Sys.getenv('LIGHTFLY_APP_ID')
secret_key = Sys.getenv('LIGHTFLY_SECRET_KEY')


stock = Stock$new(app_id=app_id, secret_key=secret_key)

test_that("fetch hs300 stock data", {
  expect_equal(typeof(stock$hs300()), "list")
})
