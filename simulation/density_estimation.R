# ------------------------------------------------------------
# Density estimation via Metropolis-Hastings
# ------------------------------------------------------------

rm(list = ls())

# Load required libraries and functions
source("./set_up/load_libraries.r")
source("./set_up/load_functions.r")

set.seed(1)

# ------------------------------------------------------------
# Step 1: Load simulation inputs
# ------------------------------------------------------------

estimation_inputs <- readRDS("./simulation/data/inputs_for_estimation.rds")
data <- estimation_inputs$data
inputs <- estimation_inputs$inputs

# ------------------------------------------------------------
# Step 2: Select polynomial orders to estimate
# ------------------------------------------------------------
# K = order of the Bernstein polynomial model
# Run the estimation separately for each K in K_list.
# Model comparison can be performed afterwards.

K_list <- c(10)

# ------------------------------------------------------------
# Step 3: Estimate the model for each K
# ------------------------------------------------------------

for (K in K_list) {
  
  parameters <- vector("list", length = 1)
  likelihood_chains <- vector("list", length = 1)
  
  # Initial number of MCMC iterations
  S <- 20000
  
  # Storage objects
  likelihood_chain <- numeric(S)
  parameter_chain <- matrix(0, nrow = S, ncol = K)
  
  # Likelihood wrapper
  likelihood_fn <- function(theta) {
    order_stat_likelihood(
      K = K,
      data = data,
      theta = theta,
      b_bases = inputs$b_bases,
      B_bases = inputs$B_bases,
      grid = inputs$grid
    )
  }
  
  # Initial parameter draw
  theta_current <- list(
    K = K,
    weight_k = rdirichlet(1, rep(1, K))
  )
  
  # Initial log-posterior
  log_post_current <-
    sum(log(dirichlet_prior(theta_current))) +
    sum(log(likelihood_fn(theta_current)))
  
  # Convergence setup
  convergence_pvalues <- rep(0, K)
  convergence_checked <- FALSE
  
  start_iter <- 1
  end_iter <- S
  
  tic()
  
  while (min(convergence_pvalues) < 0.01) {
    
    # If convergence is not yet achieved, extend the chain
    if (convergence_checked) {
      likelihood_chain <- c(likelihood_chain, numeric(10000))
      parameter_chain <- rbind(parameter_chain, matrix(0, nrow = 10000, ncol = K))
      start_iter <- end_iter + 1
      end_iter <- end_iter + 10000
    }
    
    for (s in start_iter:end_iter) {
      
      mh_counter <- 0
      
      # Proposal covariance
      if (s <= 100) {
        sigma_proposal <- diag(K - 1) * 1e-3
        if (K > 20) sigma_proposal <- diag(K - 1) * 1e-4
      } else {
        sigma_proposal <- cov(parameter_chain[1:(s - 1), 1:(K - 1), drop = FALSE]) * 2.4 / (K - 1)
      }
      
      # Generate admissible proposal
      proposal <- mh_propose_weights(
        theta_current,
        K,
        sigma = sigma_proposal
      )
      
      while (proposal$mh_error == 1) {
        mh_counter <- mh_counter + 1
        
        proposal <- mh_propose_weights(
          theta_current,
          K,
          sigma = sigma_proposal
        )
        
        if (mh_counter == 5) break
      }
      
      if (proposal$mh_error == 1) {
        break
      }
      
      theta_proposed <- proposal$newParams
      
      log_post_proposed <-
        sum(log(dirichlet_prior(theta_proposed))) +
        sum(log(likelihood_fn(theta_proposed)))
      
      accept_prob <- min(exp(log_post_proposed - log_post_current), 1)
      
      if (runif(1) <= accept_prob) {
        theta_current <- theta_proposed
        log_post_current <- log_post_proposed
      }
      
      likelihood_chain[s] <- log_post_current
      parameter_chain[s, ] <- theta_current[[2]]
      
      if ((s / end_iter * 100) %% 1 == 0) {
        toc()
        print(paste0(round((s / end_iter) * 100), "% completed"))
        tic()
      }
    }
    
    convergence_pvalues <- partial_means(parameter_chain)
    convergence_checked <- TRUE
  }
  
  toc()
  
  parameters[[1]] <- parameter_chain
  likelihood_chains[[1]] <- likelihood_chain
  
  results <- list(
    parameters = parameters,
    likelihood_chain = likelihood_chains
  )
  
  output_file <- paste0(
    "./simulation/density_estimation_output/density_",
    K,
    ".rds"
  )
  
  saveRDS(results, output_file)
}