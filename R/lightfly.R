
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
      base_url <<- "http://129.211.11.159"
      url <- paste(base_url, path_info, sep = "")
      r <- GET(url, query=params, add_headers('X-App-Id'=app_id, 'X-Token'=getToken(params, path_info)))
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

    #' get HS300
    hs300 = function() {
      path_info <- "/api/stock/hs300"
      content <- fetch(path_info)
      read_csv(content)
    },
    #' get daily history
    #'
    #' @field symbol symbol
    #' @field date_from date from
    #' @field date_to  date to
    daily_history = function(symbol, date_from, date_to) {
      path_info <- "/api/stock/history/daily"
      content <- fetch(path_info, list(
        symbol = symbol,
        date_from = date_from,
        date_to = date_to
      ))
      read_csv(content)
    },

    #' get real time stock
    #'
    #' @field symbol symbol
    stock_realtime = function(symbols) {
      path_info = "/api/stock/realtime"
      content <- fetch(path_info, list(
        symbols = symbols
      ))
      read_csv(content)
    },

    hgs_trade_realtime = function() {
      path_info = "/api/stock/hgs/trade/realtime"
      content <- fetch(path_info)
      read_csv(content)
    },

    hgtong_top10 = function () {
      path_info = "/api/stock/hgtong/top10"
      content <- fetch(path_info)
      read_csv(content)
    },

    sgtong_top10 = function () {
      path_info = "/api/stock/sgtong/top10"
      content <- fetch(path_info)
      read_csv(content)
    },

    ggtong_top10 = function () {
      path_info = "/api/stock/ggtong/top10"
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


