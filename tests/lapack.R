## tests of R functions based on the lapack module

## NB: the signs of singular and eigenvectors are arbitrary,
## so there may be differences from the reference output,
## especially when alternative BLAS are used.

options(digits = 4L)
tryCmsg <- function(expr) tryCatch(expr, error = conditionMessage) # typically == *$message

##    -------  examples from ?svd ---------

hilbert <- function(n) { i <- 1:n; 1 / outer(i - 1, i, "+") }
Eps <- 100 * .Machine$double.eps

## The signs of the vectors are not determined here, so don't print
X <- hilbert(9L)[, 1:6]
s <- svd(X); D <- diag(s$d)
stopifnot(abs(X - s$u %*% D %*% t(s$v)) < Eps)#  X = U D V'
stopifnot(abs(D - t(s$u) %*% X %*% s$v) < Eps)#  D = U' X V

## ditto
X <- cbind(1, 1:7)
s <- svd(X); D <- diag(s$d)
stopifnot(abs(X - s$u %*% D %*% t(s$v)) < Eps)#  X = U D V'
stopifnot(abs(D - t(s$u) %*% X %*% s$v) < Eps)#  D = U' X V

# test nu and nv
s <- svd(X, nu = 0L)
s <- svd(X, nu = 7L) # the last 5 columns are not determined here
stopifnot(dim(s$u) == c(7L,7L))
s <- svd(X, nv = 0L)

# test of complex case

X <- cbind(1, 1:7+(-3:3)*1i)
s <- svd(X); D <- diag(s$d)
stopifnot(abs(X - s$u %*% D %*% Conj(t(s$v))) < Eps)
stopifnot(abs(D - Conj(t(s$u)) %*% X %*% s$v) < Eps)



##  -------  tests of random real and complex matrices ------
fixsign <- function(A) {
    A[] <- apply(A, 2L, function(x) x*sign(Re(x[1L])))
    A
}
##			       100  may cause failures here.
eigenok <- function(A, E, Eps=1000*.Machine$double.eps)
{
    print(fixsign(E$vectors))
    print(zapsmall(E$values))
    V <- E$vectors; lam <- E$values
    stopifnot(abs(A %*% V - V %*% diag(lam)) < Eps,
              abs(lam[length(lam)]/lam[1]) < Eps | # this one not for singular A :
              abs(A - V %*% diag(lam) %*% t(V)) < Eps)
}

Ceigenok <- function(A, E, Eps=1000*.Machine$double.eps)
{
    print(fixsign(E$vectors))
    print(signif(E$values, 5))
    V <- E$vectors; lam <- E$values
    stopifnot(Mod(A %*% V - V %*% diag(lam)) < Eps,
              Mod(A - V %*% diag(lam) %*% Conj(t(V))) < Eps)
}

## failed for some 64bit-Lapack-gcc combinations:
sm <- cbind(1, 3:1, 1:3)
eigenok(sm, eigen(sm))
eigenok(sm, eigen(sm, sym=FALSE))

set.seed(123)
sm <- matrix(rnorm(25), 5, 5)
sm <- 0.5 * (sm + t(sm))
eigenok(sm, eigen(sm))
eigenok(sm, eigen(sm, sym=FALSE))

sm[] <- as.complex(sm)
Ceigenok(sm, eigen(sm))
Ceigenok(sm, eigen(sm, sym=FALSE))

sm[] <- sm + rnorm(25) * 1i
sm <- 0.5 * (sm + Conj(t(sm)))
Ceigenok(sm, eigen(sm))
Ceigenok(sm, eigen(sm, sym=FALSE))


##  -------  tests of integer matrices -----------------

set.seed(123)
A <- matrix(rpois(25, 5), 5, 5)

A %*% A
crossprod(A)
tcrossprod(A)

solve(A)
qr(A)
determinant(A, log = FALSE)

rcond(A)
rcond(A, "I")
rcond(A, "1")

eigen(A)
## The signs of the 'u' and 'v/vt' components can vary in the next two
A0 <- svd(A)
A1 <- La.svd(A)
## OK to test == as these are the same Fortran calls.
stopifnot(A1$d == A0$d, A1$u == A0$u, A1$vt == t(A0$v))
## Fix the signs before printing.
s <- rep(sign(A0$u[1,]), each=5); A0$u <- s * A0$u; A0$v <- s * A0$v
A0


As <- crossprod(A)
E <- eigen(As)
E$values
abs(E$vectors) # signs vary
chol(As)
backsolve(As, 1:5)

##  -------  tests of logical matrices -----------------

set.seed(123)
A <- matrix(runif(25) > 0.5, 5, 5)

A %*% A
crossprod(A)
tcrossprod(A)

Q <- qr(A)
zapsmall(Q$qr)
zapsmall(Q$qraux)
determinant(A, log = FALSE) # 0

rcond(A)
rcond(A, "I")
rcond(A, "1")

E <- eigen(A)
zapsmall(E$values)
zapsmall(Mod(E$vectors))
S <- svd(A)
zapsmall(S$d)
S <- La.svd(A)
zapsmall(S$d)

As <- A
As[upper.tri(A)] <- t(A)[upper.tri(A)]
det(As)
E <- eigen(As)
E$values
## The eigenvectors are of arbitrary sign, so we fix the first element to
## be positive for cross-platform comparisons.
Ev <- E$vectors
zapsmall(Ev * rep(sign(Ev[1, ]), each = 5))
solve(As)

## quite hard to come up with an example where this might make sense.
Ac <- A; Ac[] <- as.logical(diag(5))
chol(Ac)

##  -------  tests of non-finite values  -----------------

a <- matrix(NaN, 3, 3,, list(one=1:3, two=letters[1:3]))
b <- cbind(1:3, NA)
dimnames(b) <- list(One=4:6, Two=11:12)
bb <- 1:3; names(bb) <- 11:12
## gave error with LAPACK 3.11.0
## names(dimnames(.)), ("two", "Two") are lost {FIXME?}:
## IGNORE_RDIFF_BEGIN
stopifnot(is.na(print(solve(a, b )))) # is.na(): NA *or* NaN
## IGNORE_RDIFF_END
stopifnot(is.na(print(solve(a, bb)))) # all NaN

A <- a + 0i
A_b <- solve(A, b) # platform dependent result (e.g. OPENBLAS ..)
stopifnot(is.na(A_b))
## IGNORE_RDIFF_BEGIN
A_b
rbind(re = Re(A_b[,2]), im = Im(A_b[,2])) # often was "all NA", now typically "re=NA, im=NaN"
## IGNORE_RDIFF_END


## PR#18541 by Mikael Jagan -- chol()  error & warning message:
x <- diag(-1, 5L)
(chF <- tryCmsg(chol(x, pivot = FALSE))) # dpotrf
(chT <- withCallingHandlers(warning = function(w) ..W <<- conditionMessage(w),
                chol(x, pivot = TRUE ))) # dpstrf
stopifnot(exprs = {
    grepl(" minor .* not positive$", chF) # was "not positive *definite*
    grepl("rank-deficient or not positive definite$", ..W) # was "indefinite*
    ## platform dependent, Mac has several NaN's  chT == -diag(5)
    attr(chT, "rank") %in% 0:1
})
