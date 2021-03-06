\name{scale_shape_tableau}
\alias{scale_shape_tableau}
\title{Tableau shape scales}
\usage{
  scale_shape_tableau(palette = "default", ...)
}
\arguments{
  \item{palette}{Palette name}

  \item{...}{common discrete scale parameters: \code{name},
  \code{breaks}, \code{labels}, \code{na.value},
  \code{limits} and \code{guide}.  See
  \code{\link{discrete_scale}} for more details}
}
\description{
  Shape scales used by
  \href{http://www.tableausoftware.com/}{Trableau}.
}
\examples{
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
p <- qplot(carat, price, data=dsamp, shape=clarity)
p + scale_shape_tableau()
}

