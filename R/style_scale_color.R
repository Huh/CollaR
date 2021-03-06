#' @title Color Scale Constructor for ggplot
#'
#' @description The purpose of style_scale_color is to make our own colors!
#'              This includes the "duck hunt" color palette!
#'
#' @param palette Character name of palette in cllr_palettes
#' @param discrete Boolean; Is the color aesthetic discrete or not?
#' @param reverse Boolean; Should the colors be reversed?
#' @param ... Additional arguments which can be passed to ggplot2::disrete_scale()
#'            or ggplot2::scale_color_gradientn(), used when discrete is
#'            true or false, respectively
#'
#' @details There are four color schemes to choose from:
#'          1) "main" = simple colors, duckhunt; "NULL" value
#'          2) "duckhunt" = palette from duckhunt
#'          3) "cblind" = color blind palette
#'          4) "gray" = gray scale if you're boring
#'          If discrete = F, will pick gradient between discrete colors
#'
#' @return An object of class "ggproto", for use in ggplot2::ggplot
#' @export
#'
#' @examples
#' # Create a scatterplot
#' ggplot2::ggplot(iris, ggplot2::aes(Sepal.Width,Sepal.Length, color=Species)) +
#'   ggplot2::geom_point(size=5) +
#'   style_scale_color()
style_scale_color <- function(palette = "main", discrete = T,
                              reverse = F, ...) {
  pal <- cllr_pal(palette = palette, reverse = reverse)

  if (discrete) {
    ggplot2::discrete_scale("color", paste0("cllr_", palette),
      palette = pal, ...
    )
  } else {
    ggplot2::scale_color_gradientn(colors = pal(256), ...)
  }
}

#' Colors
#'
#' # this is from: coolors.co
# https://www.color-hex.com/color-palette/28194
# Add in grey scale
# and color blind friendly
colors <- c(
  # duck hunt colors
  `azure` = "#32b5fc",
  `green` = "#75cb0b",
  `brown` = "#7e6500",
  `dark blue` = "#00009f",
  `sunset` = "#fc6955",
  # color blind colors
  `magenta` = "#FF01FB",
  `cerulean` = "#02A9EA",
  `lemon glacier` = "#FAFF00",
  `malachite` = "#20BF55",
  `imp blue` = "#0B4F6C",
  # gray scale colors
  `black` = "#171800",
  `light gray` = "#CFD2DC"
)

#' Grab any combination of colors for our palettes
#'
#' @inheritParams style_scale_color

cllr_colors <- function(...) {
  cols <- c(...)
  if (is.null(cols)) {
    return(colors)
  }

  colors[cols]
}

#' Create palettes
#'
#' @description Color palettes stored in a list
#'
cllr_palettes <- list(
  `main` = cllr_colors("azure", "green", "sunset"),
  `duckhunt` = cllr_colors("azure", "green", "brown", "dark blue", "sunset"),
  `cblind` = cllr_colors(
    "magenta", "cerulean",
    "malachite", "lemon glacier", "imp blue"
  ),
  `gray` = cllr_colors("light gray", "black")
)

#' Access Palettes
#'
#' @description Access any of the color palettes available
#'
#' @inheritParams style_scale_color
#'
cllr_pal <- function(palette = "main", reverse = F, ...) {
  pal <- cllr_palettes[[palette]]

  if(reverse){
    pal <- rev(pal)
  }

  grDevices::colorRampPalette(pal, ...)
}
