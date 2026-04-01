#' Posterior Summary for Density and Distribution Estimates
#'
#' Computes posterior mean and pointwise credible intervals for the estimated
#' density and distribution functions on a fixed grid, based on MCMC draws.
#'
#' @param K Integer. Polynomial order used in estimation.
#' @param parameter_chain Numeric matrix. MCMC draws for the Bernstein weights
#'   (rows = iterations, columns = parameters).
#' @param grid Numeric vector. Evaluation grid.
#' @param b_bases List. Density basis matrices; `b_bases[[K]]` must have
#'   dimensions length(grid) x K.
#' @param B_bases List. Distribution basis matrices; `B_bases[[K]]` must have
#'   dimensions length(grid) x K.
#' @param ci Numeric scalar. Credible interval level complement. For example,
#'   `ci = 0.05` returns a 95% pointwise credible interval.
#' @param start_p Integer. First iteration to use.
#' @param end_p Integer. Last iteration to use.
#' @param steps Integer. Step size for thinning the chain.
#'
#' @return A list with:
#' \itemize{
#'   \item `b_est`: matrix with columns
#'     \itemize{
#'       \item grid
#'       \item posterior mean of the density
#'       \item lower credible bound
#'       \item upper credible bound
#'     }
#'   \item `B_est`: matrix with columns
#'     \itemize{
#'       \item grid
#'       \item posterior mean of the distribution function
#'       \item lower credible bound
#'       \item upper credible bound
#'     }
#' }
#'
#' @examples
#' # posterior <- posterior_summary(K, parameter_chain, grid, b_bases, B_bases, 0.05, 1000, 10000, 50)
#'
posterior_summary <- function(K, parameter_chain, grid, b_bases, B_bases, ci,
                       start_p, end_p, steps) {
  
  iterations <- seq(from = start_p, to = end_p, by = steps)
  parameter_draws <- parameter_chain[iterations, , drop = FALSE]
  
  # Cumulative sums of weights for CDF construction
  cumulative_weights <- t(apply(parameter_draws, 1, cumsum))
  
  # Transpose so basis matrices can be multiplied directly
  parameter_draws_t <- t(parameter_draws)
  cumulative_weights_t <- t(cumulative_weights)
  
  # Posterior draws of density and distribution function on the grid
  post_b <- b_bases[[K]] %*% parameter_draws_t
  post_B <- B_bases[[K]] %*% cumulative_weights_t
  
  # Posterior means
  b_hat <- rowMeans(post_b)
  B_hat <- rowMeans(post_B)
  
  # Pointwise credible intervals
  ci_fun <- function(x) quantile(x, probs = c(ci / 2, 1 - ci / 2))
  ci_b <- apply(post_b, 1, ci_fun)
  ci_B <- apply(post_B, 1, ci_fun)
  
  b_output <- cbind(grid, b_hat, t(ci_b))
  B_output <- cbind(grid, B_hat, t(ci_B))
  
  colnames(b_output) <- c("grid", "mean", "lower", "upper")
  colnames(B_output) <- c("grid", "mean", "lower", "upper")
  
  return(list(
    b_est = b_output,
    B_est = B_output
  ))
}