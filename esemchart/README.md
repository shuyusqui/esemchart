
<!-- README.md is generated from README.Rmd. Please edit that file -->

# esemchart

<!-- badges: start -->
<!-- badges: end -->

A common task for psychological students is the organization of
statistical output.It can be tough when organizing useful data from lots
of output especially adapting a scale.The goal of esemchart is to
generate tables for parameters and loadings made by lavaan::cfa function
or esemComp package.Using this package may minimize transcription errors
and reduce the time researchers use.

## Installation

You can install the development version of esemchart like so:

``` r
# install.packages(esemchart)
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(esemchart)
library(flextable)
#> Warning: 程辑包'flextable'是用R版本4.1.3 来建造的
## use a data to run a normal CFA model
data2<-lavaan::HolzingerSwineford1939
data2<-data2[,c(7:15)]
model1<-'visual=~x1+x2+x3'
fit<-lavaan::cfa(model1,data2)

# You can transform the output of cfa function to basic table matters 
table<-apa.loading.table(fit,table.number=1,model="cfa")

# Then you can make an APA table for the CFA
la<-c("f1")
item<-list("amo1","amo2","amo3")
create_tab(table,la,item,title="CFA loading",model="cfa")
#> PhantomJS not found. You can install it with webshot::install_phantomjs(). If it is installed, please make sure the phantomjs executable can be found via the PATH variable.
```

``` r

#If you have lots of items loading on different factors,then you can use the itemname function to generate a name list.
namelist<-list(f1=c(1:4),f2=c(5:8))
itemname(namelist,data2)
#> $f1
#> [1] "x1" "x2" "x3" "x4"
#> 
#> $f2
#> [1] "x5" "x6" "x7" "x8"
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
