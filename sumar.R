#' Sum two elements
#'
#' @param x First element to sum.
#' @param y Second element to sum.
#' @param negative TRUE if the elements to subtract.
#'
#' @return The sum of the two elements.
#' @export
#'
#' @examples
#' x <- 3
#' y <- 3
#' sumar(x,y)


sumar <- function(x,y,negative=FALSE) {
  z <- x + y
  if (negative) {
    z <- x-y
  }
  z
}