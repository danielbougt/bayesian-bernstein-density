#' Metropolis-Hastings Proposal for Bernstein Weights
#'
#' Generates a joint proposal for the Bernstein polynomial weights in a
#' Metropolis-Hastings sampler using a multivariate normal proposal
#' distribution, while enforcing the simplex constraint.
#'
#' @param oldParams List. Current parameter state. The second element is assumed
#'   to contain the current weight vector.
#' @param K Integer. Polynomial order / number of weights.
#' @param sigma Optional covariance matrix for the multivariate normal proposal.
#'   If NULL, a default diagonal covariance matrix is used.
#'
#' @return A list with:
#'   \item{newParams}{Updated parameter list containing the proposed weights}
#'   \item{mh_error}{Indicator taking value 1 if no valid proposal was found, otherwise 0}
#'
#' @details
#' The first K-1 weights are proposed jointly from a multivariate normal
#' distribution. The final weight is constructed as:
#'
#'   w_K = 1 - sum_{k=1}^{K-1} w_k
#'
#' The proposal is accepted as valid only if all weights are non-negative.
#' If no valid proposal is found after 20,000 attempts, the function returns
#' an error flag.
#'
#' @examples
#' oldParams <- list(NULL, rep(1/5, 5))
#' mh_propose_weights(oldParams, K = 5)
#'
mh_propose_weights <- function(oldParams, K, sigma = NULL) {
  
  require(mvtnorm)
  
  mh_error <- 0
  
  if (is.null(sigma)) {
    sigma <- diag(K - 1) * 1e-3
    if (K > 20) sigma <- diag(K - 1) * 1e-4
  }
  
  newParams <- oldParams
  
  current_weights <- matrix(newParams[[2]], nrow = K, ncol = 1)
  proposed_weights <- rep(-1, K)
  
  counter <- 0
  
  while (any(proposed_weights < 0)) {
    if (counter == 20000) {
      warning("No admissible proposal found after 20,000 attempts.")
      mh_error <- 1
      break
    }
    
    proposed_partial <- mvtnorm::rmvnorm(
      n = 1,
      mean = current_weights[1:(K - 1), 1],
      sigma = sigma
    )
    
    proposed_weights <- c(proposed_partial, 1 - sum(proposed_partial))
    counter <- counter + 1
  }
  
  newParams[[2]] <- proposed_weights
  
  return(list(newParams = newParams, mh_error = mh_error))
}