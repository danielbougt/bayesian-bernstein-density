#' Generate Simulated Order Statistic Data (Uniform)
#'
#' Simulates i.i.d. uniform draws and returns observations corresponding
#' to the K-th order statistic from each sample.
#'
#' @param N Integer. Number of draws per sample.
#' @param K Integer. Order statistic to extract (1 ≤ K ≤ N).
#' @param J Integer. Number of simulated samples.
#'
#' @return Data frame with:
#' \itemize{
#'   \item `x`: observed K-th order statistic
#'   \item `N`: number of draws per sample
#'   \item `K`: order statistic index
#' }
#'
#' @examples
#' gen_sim_data_uniform(N = 4, K = 2, J = 100)
#'
gen_sim_data_uniform <- function(N = 4, K = 4, J = 100) {
  
  if (K > N) {
    stop("K must be less than or equal to N")
  }
  
  # Simulate uniform draws
  draws <- matrix(runif(N * J), nrow = J, ncol = N)
  
  # Sort each row to obtain order statistics
  sorted_draws <- t(apply(draws, 1, sort))
  
  # Extract K-th order statistic
  x <- sorted_draws[, K]
  
  data <- data.frame(
    x = x,
    N = rep(N, J),
    K = rep(K, J)
  )
  
  return(data)
}