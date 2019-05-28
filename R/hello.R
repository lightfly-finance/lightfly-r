# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

library("httr")
library("jsonlite")
library("digest")
library("readr")

## 基类
Finance <- setRefClass(
  "Finance",
  fields = list(app_id="character", secret_key="character", base_url="character"),
  methods = list(
    ## 签名
    getToken = function (params, path_info) {

      params$path_info = path_info
      params$sign_date = Sys.Date()
      params$app_id = app_id
      query <- sort(params)
      query_string <- toJSON(query, auto_unbox = TRUE)
      hmac(secret_key, as.character(query_string), "sha256")
    },
    sort = function(x) {
      x[order(names(x))]
    },
    fetch = function (path_info, params=list()) {
      base_url <- "http://localhost:8000"
      url <- paste(base_url, path_info, sep = "")
      r <- GET(url, add_headers('X-App-Id'=app_id, 'X-Token'=getToken(params, path_info)))
      content(r, 'text')
    }
  )
)

Stock <- setRefClass(
  "Stock",
  contains = "Finance",
  methods = list(
    hs300 = function() {
      path_info <- "/api/stock/hs300"
      content <- fetch(path_info)
      read_csv(content)
    }
  )
)

Fund <- setRefClass(
  "Fund",
  contains = "Finance",
  methods = list(

  )
)


