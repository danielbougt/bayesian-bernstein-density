#' Marginal Likelihood Estimation via Importance Sampling
#'
#' Estimates the marginal likelihood (normalizing constant) using an
#' importance sampling approach based on a Gaussian approximation to
#' the posterior distribution.
#'
#' @param estimates Numeric matrix. MCMC draws (rows = iterations, columns = parameters).
#' @param likelihood_chain Numeric vector. Log-likelihood values corresponding to each draw.
#' @param prior Numeric or vector. Prior density evaluated at each draw (optional).
#'
#' @return Numeric scalar. Estimated marginal likelihood constant.
#'
#' @details
#' The method approximates the posterior using a multivariate normal
#' centered at the sample mean, and computes:
#'
#'   c_k = [ E_q ( q(theta) / (p(theta) * L(theta)) ) ]^{-1}
#'
#' where q is the proposal distribution.
#'
#' @examples
#' # ml_estimate <- estimate_marginal_likelihood(estimates, likelihood_chain)
#'
estimate_marginal_likelihood <- function(estimates, likelihood_chain, prior = NULL) {
  
  # Posterior mean and covariance
  mean_estimates <- colMeans(estimates)
  cov_estimates <- cov(estimates)
  # Use a diagonal covariance approximation for stability across model orders.
  # Full covariance estimates from MCMC draws can be noisy and lead to unstable
  # importance weights in marginal likelihood estimation.
  cov_estimates <- diag(diag(cov(estimates)))
  
  # Proposal density q(theta)
  q_density <- mvtnorm::dmvnorm(
    estimates,
    mean = mean_estimates,
    sigma = cov_estimates * 100
  )
  
  # Prior evaluation
  if (is.null(prior)) {
    prior_vals <- apply(estimates, 1, function(x) prod(x))
  } else {
    prior_vals <- prior
  }
  
  # Likelihood evaluation (convert from log-scale)
  likelihood_vals <- exp(likelihood_chain)
  
  # Importance sampling estimator
  weights <- q_density / (prior_vals * likelihood_vals)
  
  normalizing_constant <- 1 / mean(weights)
  
  return(normalizing_constant)
}