## Lightfly R 客户端

### 安装

下载安装包：https://github.com/lightfly-finance/lightfly-r/releases

打开 Rstudio 或者命令行，执行：

```
 library(devtools)
 install_github('lightfly-finance/lightfly-r')
 library('lightfly')
 devtools::load_all()
```


### 使用

```r
stock <- Stock$new(app_id="xxx", secret_key="xxx")
data <- stock$hs300()
```

完整文档： https://www.yuque.com/twn39/bb3s7k
