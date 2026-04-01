#' Partial-Means Convergence Diagnostic for MCMC Output
#'
#' Compares means from two separated subsamples of the MCMC chain and computes
#' a chi-squared test statistic for each parameter, using autocovariance-based
#' variance estimates.
#'
#' @param estimates Numeric matrix. Rows are MCMC iterations and columns are parameters.
#'
#' @return Numeric vector. P-values for the partial-means convergence test, one per parameter.
#'
#' @details
#' The chain is split into two subsamples:
#' - second quarter of the chain
#' - fourth quarter of the chain
#'
#' For each parameter, the test compares the difference in subsample means,
#' scaled by the sum of long-run variance estimates from each subsample.
#'
#' Small p-values may indicate lack of convergence.
#'
#' @examples
#' draws <- matrix(rnorm(4000), ncol = 4)
#' partial_means(draws)
#'
partial_means <- function(estimates) {
  
  if (!is.matrix(estimates)) {
    stop("estimates must be a numeric matrix")
  }
  
  iterations <- nrow(estimates)
  
  if (iterations < 8) {
    stop("Too few iterations for partial-means diagnostic")
  }
  
  sample_1 <- (floor(iterations / 4) + 1):floor(iterations / 2)
  sample_2 <- (floor(3 * iterations / 4) + 1):iterations
  
  mean_1 <- colMeans(estimates[sample_1, , drop = FALSE])
  mean_2 <- colMeans(estimates[sample_2, , drop = FALSE])
  
  tau_fun <- function(x) estimate_mcmc_tau(x, L_S = 0.01, S = iterations)
  
  tau_1 <- apply(estimates[sample_1, , drop = FALSE], 2, tau_fun)
  tau_2 <- apply(estimates[sample_2, , drop = FALSE], 2, tau_fun)
  
  mean_diffs <- mean_2 - mean_1
  tau_sums <- tau_1 + tau_2
  
  test_stats <- mean_diffs^2 / tau_sums
  p_values <- pchisq(test_stats, df = 1, lower.tail = FALSE)
  
  return(p_values)
}