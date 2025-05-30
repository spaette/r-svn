% File src/library/base/man/seq.POSIXt.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2025 R Core Team
% Distributed under GPL 2 or later

\name{seq.POSIXt}
\alias{seq.POSIXt}
\title{Generate Regular Sequences of Times}
\description{
  The method for \code{\link{seq}} for date-time (\code{"\link{POSIXt}"}) classes.
}
\usage{
\method{seq}{POSIXt}(from, to, by, length.out = NULL, along.with = NULL, \dots)
}
\arguments{
  \item{from}{starting date; optional.}
  \item{to}{end date; optional.}
  \item{by}{increment of the sequence; optional.  See \sQuote{Details}.}
  \item{length.out}{integer, optional.  Desired length of the sequence.}
  \item{along.with}{take the length from the length of this argument.}
  \item{\dots}{arguments passed to or from other methods.}
}
\details{
  \code{by} can be specified in several ways.
  \itemize{
    \item A number, taken to be in seconds.
    \item An object of class \code{\link{difftime}}
    \item A character string, containing one of \code{"sec"},
    \code{"min"}, \code{"hour"}, \code{"day"}, \code{"DSTday"},
    \code{"week"}, \code{"month"}, \code{"quarter"} or \code{"year"}, or a
    \code{\link{pmatch}()}able abbreviation of these.
    This can optionally be preceded by a (positive or negative) integer
    and a space, or followed by \code{"s"}.
  }
  The difference between \code{"day"} and \code{"DSTday"} is that the
  former ignores changes to/from daylight savings time and the latter takes
  the same clock time each day.  \code{"week"} ignores DST (it is a
  period of 144 hours), but \code{"7 DSTdays"} can be used as an
  alternative.  \code{"month"} and \code{"year"} allow for DST.

  The \link{time zone} of the result is taken from \code{from} unless only
  \code{to} is provided: remember that GMT means UTC (and not the time
  zone of Greenwich, England) and so does not have daylight savings time.

  Using \code{"month"} first advances the month without changing the
  day: if this results in an invalid day of the month, it is counted
  forward into the next month: see the examples.
}
\value{
  A vector of class \code{"POSIXct"}, internally of type
  \code{"\link{double}"} or \code{"\link{integer}"}.
}

\seealso{\code{\link{DateTimeClasses}}}

\examples{
## first days of years
seq(ISOdate(1910,1,1), ISOdate(1999,1,1), "years")
## by month
seq(ISOdate(2000,1,1), by = "month", length.out = 12)
seq(ISOdate(2000,1,31), by = "month", length.out = 4)
## quarters
seq(ISOdate(1990,1,1), ISOdate(2000,1,1), by = "quarter") # or "3 months"
## days vs DSTdays: use c() to lose the time zone.
seq(c(ISOdate(2000,3,20)), by = "day", length.out = 10)
seq(c(ISOdate(2000,3,20)), by = "DSTday", length.out = 10)
seq(c(ISOdate(2000,3,20)), by = "7 DSTdays", length.out = 4)

## 24-hour period ending at a fixed time
seq(to = ISOdate(2024,1,2, 3,4,5), by = "hour", length.out = 24)
}
\keyword{manip}
\keyword{chron}
