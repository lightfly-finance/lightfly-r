## Lightfly R 客户端

### 安装

下载安装包：https://github.com/lightfly-finance/lightfly-r/releases

打开 Rstudio 或者命令行，执行：

```
library(devtools)
install_github('lightfly-finance/lightfly-r')
library('lightfly')
```


### 使用

```r
stock <- new("Stock", app_id="xxx", secret_key="xxx")
data <- stock$hs300()
```

### 结合 quantmod

```
library(devtools)
install_github('lightfly-finance/lightfly-r')
install.packages("quantmod")
library(quantmod)
library('lightfly')

stock <- new("Stock", app_id="xxx", secret_key="xxx")
data <- stock$daily_history("sh000001", "2019-01-01", "2019-09-26")
result <- data[, 4:7]
result$Volume <- data$Volume
result$Date <- data$Date
ts <- as.xts(result[, 1:5], order.by = result$Date)
chartSeries(ts, name="上证指数")
addCCI()
addMACD()
addRSI()
addBBands()
```

完整文档： https://www.yuque.com/twn39/bb3s7k
