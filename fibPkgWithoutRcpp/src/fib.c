
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
