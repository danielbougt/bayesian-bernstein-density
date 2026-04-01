# ------------------------------------------------------------
# Select polynomial order using marginal likelihood estimates
# ------------------------------------------------------------

rm(list = ls())

# Load functions and libraries
source("./set_up/load_libraries.r")
source("./set_up/load_functions.r")

# ------------------------------------------------------------
# Step 1: Load estimation results and inputs
# ------------------------------------------------------------

estimation <- readRDS("./simulation/density_estimation_output/density_estimation.rds")
estimation_inputs <- readRDS("./simulation/data/inputs_for_estimation.rds")

data <- estimation_inputs$data
inputs <- estimation_inputs$inputs

K_values <- estimation$K_values
parameters <- estimation$parameters
likelihood_chains <- estimation$likelihood_chains

# ------------------------------------------------------------
# Step 2: Compute marginal likelihood estimate for each model
# ------------------------------------------------------------

n_models <- length(parameters)

BMS <- numeric(n_models)
model_orders <- numeric(n_models)

for (model in seq_len(n_models)) {
  
  S <- length(likelihood_chains[[model]])
  idx <- seq(from = floor(S / 2), to = S, by = 50)
  
  BMS[model] <- estimate_marginal_likelihood(
    estimates = parameters[[model]][idx, , drop = FALSE],
    likelihood_chain = likelihood_chains[[model]][idx]
  )
  
  model_orders[model] <- K_values[model]
}

# ------------------------------------------------------------
# Step 3: Identify preferred model
# ------------------------------------------------------------

post_K <- dpois(model_orders, 10) * BMS

K_star_index <- which.max(post_K)
K_star <- model_orders[K_star_index]
S_star <- length(likelihood_chains[[K_star_index]])

# ------------------------------------------------------------
# Step 4: Compute posterior summaries for selected model
# ------------------------------------------------------------

posterior <- posterior_summary(
  K_star,
  parameters[[K_star_index]],
  grid = inputs$grid,
  b_bases = inputs$b_bases,
  B_bases = inputs$B_bases,
  ci = 0.05,
  start_p = floor(S_star / 2),
  end_p = S_star,
  steps = 50
)

# ------------------------------------------------------------
# Step 5: Save posterior output
# ------------------------------------------------------------

posterior_output <- list(
  posterior = posterior,
  K_star = K_star,
  K_star_index = K_star_index,
  post_K = post_K,
  BMS = BMS
)

saveRDS(
  posterior_output,
  "./simulation/output/posterior.rds"
)