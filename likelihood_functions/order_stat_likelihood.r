#' Likelihood for Order Statistic Observations
#'
#' Computes the likelihood contribution for observations that correspond to
#' order statistics, based on a Bernstein polynomial representation of the
#' underlying distribution.
#'
#' @param K Integer. Polynomial order.
#' @param data Matrix or data frame of observations. Expected columns:
#'   \itemize{
#'     \item column 1: observed value
#'     \item "K": order statistic index
#'     \item "N": total number of draws
#'   }
#' @param theta List of model parameters. The second element is assumed to
#'   contain the Bernstein weights.
#' @param b_bases List of density basis matrices.
#' @param B_bases List of distribution basis matrices.
#' @param grid Numeric vector. Grid used for basis evaluation and interpolation.
#'
#' @return Numeric vector. Likelihood contributions for each observation.
#'
#' @details
#' The function:
#' 1. Constructs the implied CDF and density from Bernstein weights
#' 2. Interpolates these quantities at the observed data points
#' 3. Evaluates the likelihood of each observed order statistic
#'
#' @examples
#' # order_stat_likelihood(K, data, theta, b_bases, B_bases, grid)
#'
order_stat_likelihood <- function(K, data, theta, b_bases, B_bases, grid) {
  
  # Extract polynomial order and weights
  k <- K
  weights <- matrix(theta[[2]], nrow = K, ncol = 1)
  
  # Construct underlying CDF and density from Bernstein bases
  F_vals <- B_bases[[k]] %*% cumsum(weights[1:k, 1])
  f_vals <- b_bases[[k]] %*% weights[1:k, 1]
  
  # Interpolate CDF and density at observed values
  x_obs <- data[, 1]
  F_x <- pchip(grid, F_vals, x_obs)
  f_x <- pchip(grid, f_vals, x_obs)
  
  # Evaluate likelihood contributions for observed order statistics
  likelihood <- order_stat_density(
    f_x,
    F_x,
    data[, "K"],
    data[, "N"]
  )
  
  return(likelihood)
}