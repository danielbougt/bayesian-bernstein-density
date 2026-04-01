#' Density of the k-th Order Statistic
#'
#' Computes the density of the k-th order statistic from a sample of size n,
#' given the underlying density f(x) and distribution function F(x).
#'
#' @param f Numeric vector. Values of the underlying density f(x).
#' @param F Numeric vector. Values of the underlying CDF F(x).
#' @param k Integer. Order statistic index, with 1 <= k <= n.
#' @param n Integer. Sample size.
#'
#' @return Numeric vector. Density of the k-th order statistic.
#'
#' @details
#' The density is given by:
#'
#'   f_{k:n}(x) = [n! / ((k-1)!(n-k)!)] * f(x) * F(x)^(k-1) * (1 - F(x))^(n-k)
#'
#' @examples
#' x <- seq(0, 1, length.out = 100)
#' f <- rep(1, length(x))   # Uniform(0,1) density
#' F <- x                   # Uniform(0,1) cdf
#' order_stat_density(f, F, k = 2, n = 5)
#'
order_stat_density <- function(f, F, k, n) {
  
  if (any(k < 1 | k > n)) {
    stop("All elements must satisfy 1 <= k <= n")
  }
  
  coeff <- k * exp(lchoose(n, k))
  
  density_os <- coeff * f * F^(k - 1) * (1 - F)^(n - k)
  
  return(density_os)
}