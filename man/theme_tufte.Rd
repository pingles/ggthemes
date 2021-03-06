\name{theme_tufte}
\alias{theme_tufte}
\title{Tufte Data-Ink Maximized Theme}
\usage{
  theme_tufte(ticks = TRUE, base_family = "serif",
    base_size = 11)
}
\arguments{
  \item{ticks}{\code{logical} Show axis ticks?}

  \item{base_size}{Base font size}

  \item{base_family}{Base font family}
}
\description{
  Theme based on Chapter 6 "Data-Ink Maximization and
  Graphical Design" of Edward Tufte *The Visual Display of
  Quantitative Information*. No border, no axis lines, no
  grids. This theme works best in combination with
  \code{\link{geom_rug}} or \code{\link{geom_rangeframe}}.
}
\details{
  The default font family is set to "serif" as he uses
  serif fonts for labels in "The Visual Display of
  Quantitative Information". The serif font used by Tufte
  in his books is a variant of Bembo, while the sans serif
  font is Gill Sans. If these fonts are installed on your
  system, then you can use them with the package
  \bold{extrafont}.
}
\examples{
# with ticks and range frames
(ggplot(mtcars, aes(wt, mpg))
 + geom_point() + geom_rangeframe()
 + theme_tufte())
# with geom_rug
(ggplot(mtcars, aes(wt, mpg))
 + geom_point() + geom_rug()
 + theme_tufte(ticks=FALSE))
\dontrun{
## Using the Bembo serif family
library(extrafont)
(ggplot(mtcars, aes(wt, mpg))
 + geom_point() + geom_rangeframe()
 + theme_tufte(base_family="BemboStd"))
## Using the Gill Sans sans serif family
(ggplot(mtcars, aes(wt, mpg))
 + geom_point() + geom_rangeframe()
 + theme_tufte(base_family="GillSans"))
}
}
\references{
  Tufte, Edward R. (2001) The Visual Display of
  Quantitative Information, Chapter 6.
}

