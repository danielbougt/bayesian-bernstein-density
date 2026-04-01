dirichlet_prior <- function(theta, alpha = NULL) {
  
  weights <- theta[[2]]
  K <- length(weights)
  
  if (is.null(alpha)) {
    alpha <- rep(1, K)
  }
  
  log_prior <- sum((alpha - 1) * log(weights))
  
  return(exp(log_prior))
}