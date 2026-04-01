#' Trapezoidal Numerical Integration
#'
#' Computes a cumulative trapezoidal approximation of the integral:
#'   ∫ f(x) dx
#'
#' @param x_points Numeric vector. Sorted grid points.
#' @param y_points Numeric vector. Function values f(x) evaluated at x_points.
#'
#' @return Numeric vector. Cumulative integral approximation at each interval.
#'
#' @details
#' Uses the trapezoidal rule:
#'   ∫_{x_i}^{x_{i+1}} f(x) dx ≈ (x_{i+1} - x_i) * (f(x_i) + f(x_{i+1})) / 2
#'
#' Returns cumulative sums of these approximations.
#'
#' @examples
#' x <- seq(0, 1, length.out = 100)
#' y <- x^2
#' trapezoid_integration(x, y)
#'
trapezoid_integration <- function(x_points, y_points) {
  
  # Input validation
  if (length(x_points) != length(y_points)) {
    stop("x_points and y_points must have the same length")
  }
  
  if (length(x_points) < 2) {
    stop("At least two points are required for integration")
  }
  
  # Compute interval widths
  dx <- diff(x_points)
  
  # Compute trapezoid heights
  avg_heights <- (y_points[-1] + y_points[-length(y_points)])
  
  # Area contributions
  area <- dx * avg_heights / 2
  
  # Cumulative integral
  cumulative_integral <- cumsum(area)
  
  return(cumulative_integral)
}