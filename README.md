## R Extensions in C versus C++: Judging Size, Speed, and Ease of Use for the Fibonacci Recursion

### Sizes

```sh
fibPkgWithoutRcpp    fibPkgWithRcpp 
            14136             64368 
```


### Runtime

```sh
Unit: microseconds
      expr       min        lq      mean    median        uq       max neval
 c_recurse 14759.728 16418.633 17437.593 17037.995 17855.619  37728.85  1000
 c_wrapped   352.774   353.654   364.479   354.044   356.532   2718.33  1000
       cpp   277.890   280.140   406.076   282.384   298.923 106560.63  1000
```


### Code Snippets

#### C Code with Recursion over SEXP

```c

#include <R.h>
#include <Rinternals.h>

SEXP fibC(SEXP ns) {
    SEXP result = PROTECT(allocVector(REALSXP, 1)); /* real not int for overflow */
    double n = asReal(ns);
    if (n < 2) {
        REAL(result)[0] = n;
        UNPROTECT(1);
        return result;
    }
    SEXP nm1 = PROTECT(allocVector(REALSXP, 1));
    SEXP nm2 = PROTECT(allocVector(REALSXP, 1));
    REAL(nm1)[0] = n - 1;
    REAL(nm2)[0] = n - 2;
    REAL(result)[0] = asReal(fibC(nm1)) + asReal(fibC(nm2));
    UNPROTECT(3);
    return result;
}
```

#### C Code with SEXP Wrapper for Recursion

```c

#include <R.h>
#include <Rinternals.h>

double fib(double n) {
    if (n < 2) return n;
    return fib(n-1) + fib(n-2);
}

SEXP fib2C(SEXP ns) {
    double n = asReal(ns);
    SEXP result = PROTECT(allocVector(REALSXP, 1)); /* real not int for overflow */
    REAL(result)[0] = fib(n);
    UNPROTECT(1);
    return result;
}
```

#### Standard Rcpp Code

```c++
#include <Rcpp.h>

// [[Rcpp::export]]
double fib(double n) {
  if (n < 2) return n;
  return fib(n-1) + fib(n-2);
}
```
