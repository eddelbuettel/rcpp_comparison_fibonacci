#!/usr/bin/env r

## prep
installAndStripAndSize <- function(pkgname, installed) {
    stopifnot(dir.exists(pkgname))
    if (!pkgname %in% installed) install.packages(pkgname, repos=NULL)
    lib <- system.file("libs", paste0(pkgname, .Platform$dynlib.ext), package=pkgname)
    file.info(lib)$size
}

installed <- installed.packages()[,1]
Sys.setenv("_R_SHLIB_STRIP_"=1)  		# R 3.6.0 or later
res <- sapply(c("fibPkgWithoutRcpp", "fibPkgWithRcpp"),
              installAndStripAndSize, installed)
print(res)


library(microbenchmark)

n <- 30

res <- microbenchmark(c_recurse=fibPkgWithoutRcpp::fib(n),
                      c_wrapped=fibPkgWithoutRcpp::fib2(n),
                      cpp=fibPkgWithRcpp::fib(n),
                      times=1000L,
                      setup=set.seed(123),
                      control=list(order="block"))
print(res)
if (requireNamespace("ggplot2")) {
  library(ggplot2)
  pdf("comparison.pdf")
  autoplot(res)
  dev.off()
}
