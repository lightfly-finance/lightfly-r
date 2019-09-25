library("httr")
library("jsonlite")
library("digest")
library("readr")

#' A base Reference Class for finance.
#'
#' @importFrom methods new
#' @importFrom methods setRefClass
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
      query_string <- jsonlite::toJSON(query, auto_unbox = TRUE)
      digest::hmac(secret_key, as.character(query_string), "sha256")

    },
    sort = function(x) {
      x[order(names(x))]
    },
    fetch = function (path_info, params=list()) {
      base_url <<- "http://lightfly.cn"
      url <- paste(base_url, path_info, sep = "")
      r <- httr::GET(url, query=params, httr::add_headers('X-App-Id'=app_id, 'X-Token'=getToken(params, path_info)))
      httr::content(r, 'text')
    }
  )
)

#' A Stock Reference Class.
#'
#' @exportClass Stock
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
      readr::read_csv(content)
    },
    #' get daily history
    #'
    #' @field symbol symbol.
    #' @field date_from date from.
    #' @field date_to  date to.
    daily_history = function(symbol, date_from, date_to, lang="en") {
      path_info <- "/api/stock/history/daily"
      content <- fetch(path_info, list(
        symbol = symbol,
        date_from = date_from,
        date_to = date_to,
        lang = lang
      ))
      readr::read_csv(content)
    },

    #' get real time stock
    #'
    #' @field symbol symbol.
    stock_realtime = function(symbols) {
      path_info = "/api/stock/realtime"
      content <- fetch(path_info, list(
        symbols = symbols
      ))
      readr::read_csv(content)
    },

    hgs_trade_realtime = function() {
      path_info = "/api/stock/hgs/trade/realtime"
      content <- fetch(path_info)
      readr::read_csv(content)
    },

    hgtong_top10 = function () {
      path_info = "/api/stock/hgtong/top10"
      content <- fetch(path_info)
      readr::read_csv(content)
    },

    sgtong_top10 = function () {
      path_info = "/api/stock/sgtong/top10"
      content <- fetch(path_info)
      readr::read_csv(content)
    },

    ggtong_top10 = function () {
      path_info = "/api/stock/ggtong/top10"
      content <- fetch(path_info)
      readr::read_csv(content)
    },

    stock_index = function () {
      path_info = "/api/stock/index"
      content <- fetch(path_info)
      readr::read_csv(content)
    },

    sh_index_component = function () {
      path_info = "/api/stock/component/shindex"
      content <- fetch(path_info)
      readr::read_csv(content)
    },

    sh_consumption_index_component = function () {
      path_info = "/api/stock/component/shconsumptionindex"
      content <- fetch(path_info)
      readr::read_csv(content)
    },

    sh50_index_component = function () {
      path_info = "/api/stock/component/sh50index"
      content <- fetch(path_info)
      readr::read_csv(content)
    },

    sh_medicine_index_component = function () {
      path_info = "/api/stock/component/shmedicineindex"
      content <- fetch(path_info)
      readr::read_csv(content)
    },

    sz_index_component = function () {
      path_info = "/api/stock/component/szindex"
      content <- fetch(path_info)
      readr::read_csv(content)
    },

    sz_composite_index_component = function () {
      path_info = "/api/stock/component/szcompositeindex"
      content <- fetch(path_info)
      readr::read_csv(content)
    },

    zz500_index_component = function () {
      path_info = "/api/stock/component/zz500index"
      content <- fetch(path_info)
      readr::read_csv(content)
    },

    indicator_main = function (symbol) {
      path_info = "/api/stock/indicator/main"
      content <- fetch(path_info, list(
        symbol = symbol
      ))
      data <- readr::read_csv(content)
      na.omit(t(data))
    },

    profitability = function (symbol) {
      path_info = "/api/stock/indicator/profitability"
      content <- fetch(path_info, list(
        symbol = symbol
      ))
      data <- readr::read_csv(content)
      na.omit(t(data))
    },

    solvency = function (symbol) {
      path_info = "/api/stock/indicator/solvency"
      content <- fetch(path_info, list(
        symbol = symbol
      ))
      data <- readr::read_csv(content)
      na.omit(t(data))
    },

    growth_ability = function (symbol) {
      path_info = "/api/stock/indicator/growthability"
      content <- fetch(path_info, list(
        symbol = symbol
      ))
      data <- readr::read_csv(content)
      na.omit(t(data))
    }


  )
)


#' A Fund Reference Class.
#'
#' @exportClass Fund
#' @field app_id app id.
#' @field secret_key app secret key.
Fund <- setRefClass(
  "Fund",
  contains = "Finance",
  methods = list(
    daily_history = function (symbol, date_from, date_to) {
      path_info <- "/api/fund/history/daily"
      content <- fetch(path_info, list(
        symbol = symbol,
        date_from = date_from,
        date_to = date_to
      ))
      readr::read_csv(content)
    },

    internet_banking = function () {
      path_info = "/api/fund/internet/banking"
      content <- fetch(path_info)
      read_csv(content)
    },

    basic_info = function (symbol) {
      path_info = "/api/fund/basic/info"
      content <- fetch(path_info, list(
        symbol = symbol
      ))

      content
    },
    stocks_holding = function (symbol) {
      path_info = "/api/fund/stocks/holding"
      content <- fetch(path_info, list(
        symbol = symbol
      ))

      read_delim(content, delim = '|')
    }
  )
)


