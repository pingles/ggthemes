##' Tufte's Box Blot
##'
##' Edward Tufte's revision of the box plot erases the box and
##' replaces it with a single middle point.
##'
##' @section Aesthetics:
##' \Sexpr[results=rd,stage=build]{ggplotJrnold:::rd_aesthetics("geom_tufteboxplot", ggplotJrnold:::GeomTufteboxplot)}
##'
##' @references Tufte, Edward R. (2001) The Visual Display of
##' Quantitative Information, Chapter 6.
##'
##' @seealso \code{\link{geom_boxplot}}
##' @inheritParams ggplot2::geom_point
##' @param outlier.colour colour for outlying points
##' @param outlier.shape shape of outlying points
##' @param outlier.size size of outlying points
##' @param fatten a multiplicative factor to fatten the point by
##' @export
##'
##' @examples
##' p <- ggplot(mtcars, aes(factor(cyl), mpg))
##'
##' p + geom_tufteboxplot()
##'
geom_tufteboxplot <- function (mapping = NULL, data = NULL, stat = "boxplot",
                               position = "dodge",
                               outlier.colour = "black", outlier.shape = 16,
                               outlier.size = 2, fatten=4, ...) {
    GeomTufteboxplot$new(mapping = mapping, data = data, stat = stat,
                         position = position, outlier.colour = outlier.colour,
                         outlier.shape = outlier.shape,
                         outlier.size = outlier.size, fatten=fatten, ...)
}

GeomTufteboxplot <- proto(ggplot2:::Geom, {
  objname <- "tufteboxplot"

  reparameterise <- function(., df, params) {
    df$width <- df$width %||%
      params$width %||% (resolution(df$x, FALSE) * 0.9)

    if (!is.null(df$outliers)) {
      suppressWarnings({
        out_min <- vapply(df$outliers, min, numeric(1))
        out_max <- vapply(df$outliers, max, numeric(1))
      })
      df$ymin_final <- pmin(out_min, df$ymin)
      df$ymax_final <- pmax(out_max, df$ymax)
    }
    df
  }

  draw <- function(., data, ..., outlier.colour = NULL,
                   outlier.shape = NULL, outlier.size = 2, fatten=4) {
    common <- data.frame(
      colour = data$colour,
      size = data$size,
      linetype = data$linetype,
      group = NA,
      stringsAsFactors = FALSE
    )

    whiskers <- data.frame(
      x = data$x,
      xend = data$x,
      y = c(data$upper, data$lower),
      yend = c(data$ymax, data$ymin),
      alpha = NA,
      common)

    if (!is.null(data$outliers) && length(data$outliers[[1]] >= 1)) {
      outliers <- data.frame(
        y = data$outliers[[1]],
        x = data$x[1],
        colour = outlier.colour %||% data$colour[1],
        shape = outlier.shape %||% data$shape[1],
        size = outlier.size %||% data$size[1],
        fill = NA,
        alpha = NA,
        stringsAsFactors = FALSE)
      outliers_grob <- GeomPoint$draw(outliers, ...)
    } else {
      outliers_grob <- NULL
    }

    ggname(.$my_name(), grobTree(
      outliers_grob,
      GeomSegment$draw(whiskers, ...),
      GeomPoint$draw(transform(data, y=middle, size=size * fatten), ...)
    ))
   }

  guide_geom <- function(.) "pointrange"
  default_stat <- function(.) StatBoxplot
  default_pos <- function(.) PositionDodge
  default_aes <- function(.) aes(colour = "black", size=0.5, linetype=1, shape=16, fill=NA, alpha = NA)
  required_aes <- c("x", "lower", "upper", "middle", "ymin", "ymax")

})

geom_pointrange <- function (mapping = NULL, data = NULL, stat = "identity", position = "identity", point.size=2, ...) {
  GeomPointrange$new(mapping = mapping, data = data, stat = stat, position = position, point.size=point.size, ...)
}

GeomPointrange <- proto(ggplot2:::Geom, {
  objname <- "pointrange"

  default_stat <- function(.) StatIdentity
  default_aes <- function(.) aes(colour = "black", size=0.5, linetype=1, shape=16, fill=NA, alpha = NA)
  guide_geom <- function(.) "pointrange"
  required_aes <- c("x", "y", "ymin", "ymax")

  draw <- function(., data, scales, coordinates, point.size=2, ...) {
    if (is.null(data$y)) return(GeomLinerange$draw(data, scales, coordinates, ...))
    point.size = point.size %||% data$size[1]
    ggname(.$my_name(),gTree(children=gList(
      GeomLinerange$draw(data, scales, coordinates, ...),
      GeomPoint$draw(transform(data, size = point.size), scales, coordinates, ...)
    )))
  }

  draw_legend <- function(., data, ...) {
    data <- aesdefaults(data, .$default_aes(), list(...))

    grobTree(
      GeomPath$draw_legend(data, ...),
      GeomPoint$draw_legend(transform(data, size = size * 4), ...)
    )
  }

})