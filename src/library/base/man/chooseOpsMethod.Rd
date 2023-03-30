% File src/library/base/man/chooseOpsMethod.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2023 R Core Team
% Distributed under GPL 2 or later

\name{chooseOpsMethod}
\title{Choose the Appropriate Method for Ops}
\usage{chooseOpsMethod(x, y, mx, my, cl, reverse)}
\alias{chooseOpsMethod}

\description{
  \code{chooseOpsMethod} is a function called by the Ops Group Generic when two
  suitable methods are found for a given call. It determines which method to
  use for the operation based on the objects being dispatched.

  The function is first called with \code{reverse = FALSE}, where
  \code{x} corresponds to the first argument and \code{y} to the second
  argument of the group generic call. If \code{chooseOpsMethod()} returns
  \code{FALSE} for \code{x}, then \code{chooseOpsMethod} is called again,
  with \code{x} and \code{y} swapped, \code{mx} and \code{my} swapped,
  and \code{reverse = TRUE}.
}

\arguments{
  \item{x,y}{The objects being dispatched on by the group generic.}
  \item{mx,my}{The methods found for objects \code{x} and \code{y}.}
  \item{cl}{The call to the group generic.}
  \item{reverse}{A logical value indicating whether \code{x} and \code{y} are
      reversed from the way they were supplied to the generic.}
}

\seealso{
  \code{\link[=S3groupGeneric]{Ops}}
}

\value{
  This function must return either \code{TRUE} or \code{FALSE}. A value of
  \code{TRUE} indicates that method \code{mx} should be used.
}
\keyword{methods}
\examples{

# Create two objects with custom Ops methods
foo_obj <- structure(1, class = "foo")
bar_obj <- structure(1, class = "bar")

`+.foo` <- function(e1, e2) "foo"
Ops.bar <- function(e1, e2) "bar"

invisible(foo_obj + bar_obj) # Warning: Incompatible methods

chooseOpsMethod.bar <- function(x, y, mx, my, cl, reverse) TRUE

stopifnot(exprs = {
  identical(foo_obj + bar_obj, "bar")
  identical(bar_obj + foo_obj, "bar")
})

# cleanup
rm(foo_obj, bar_obj, `+.foo`, Ops.bar, chooseOpsMethod.bar)
}
