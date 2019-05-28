
library("httr")
library("jsonlite")
library("digest")
library("readr")

#' A base Reference Class for finance.
#'
#' @field app_id app id.
#' @field secret_key app secret key.
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

#' A Stock Reference Class.
#'
#' @field app_id app id.
#' @field secret_key app secret key.
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


#' A Fund Reference Class.
#'
#' @field app_id app id.
#' @field secret_key app secret key.
Fund <- setRefClass(
  "Fund",
  contains = "Finance",
  methods = list(

  )
)


