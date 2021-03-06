% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dimcalculations.R
\name{dim_calc}
\alias{dim_calc}
\title{Calculates multidimentsional index from linear}
\usage{
dim_calc(wanted, diml)
}
\arguments{
\item{wanted}{linear index}

\item{diml}{vector of usually 3 dimensions describing dimension size}
}
\value{
vector of multidimensional index
}
\description{
Calculates multidimentsional index from linear
}
\note{
can work with arbritary dimensions, but typically uses three

this function does not check whether the final index is in
range of the final dimension, it simply wraps around.

internally uses zero based index for calculation
}
\examples{
\dontrun{
dim_calc(1, c(4, 3))
dim_calc(4, c(4, 3))
dim_calc(5, c(4, 3))
dim_calc(12, c(4, 3))
dim_calc(13, c(4, 3))
}
}
