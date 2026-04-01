#' Estimate Variance Term for MCMC Convergence Diagnostics
#'
#' Computes an autocovariance-based variance estimate used in assessing
#' convergence properties of MCMC output.
#'
#' @param data Numeric vector. MCMC draws for a scalar parameter.
#' @param L_S Integer. Base lag multiplier.
#' @param S Integer. Scaling parameter for truncation lag.
#'
#' @return Numeric scalar. Estimated variance term.
estimate_mcmc_tau <- function(data, L_S, S) {
  
  L <- L_S * S
  n <- length(data)
  mu <- mean(data)
  
  cs <- numeric(L)
  
  for (j in 1:L) {
    if (j >= n) break
    
    cs[j] <- sum(
      (data[(j + 1):n] - mu) *
        (data[1:(n - j)] - mu)
    )
  }
  
  cs <- cs / n
  
  tau_est <- cs[1]
  for (s in 2:L) {
    tau_est <- tau_est + 2 * (L - s - 1) / L * cs[s]
  }
  
  return(tau_est)
}