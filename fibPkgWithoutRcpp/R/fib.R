
fib <- function(n) .Call("fibC", n, package="fibPkgWithoutRcpp")

fib2 <- function(n) .Call("fib2C", n, package="fibPkgWithoutRcpp")
