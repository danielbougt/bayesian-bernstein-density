# ------------------------------------------------------------
# Simulation setup: generate synthetic order-statistic data
# and prepare basis inputs for estimation
# ------------------------------------------------------------

rm(list = ls())

source("./set_up/load_libraries.r")
source("./set_up/load_functions.r")

set.seed(1)

# ------------------------------------------------------------
# Step 1: Generate simulated data
# ------------------------------------------------------------
# N = number of draws in each sample
# K = order statistic to observe (K = N gives the maximum)
# J = number of simulated observations

data <- gen_sim_data_uniform(N = 2, K = 2, J = 100)

# Add observations from samples of size 3
for (n in 3:3) {
  data_n <- gen_sim_data_uniform(N = n, K = n, J = 100)
  data <- rbind(data, data_n)
}

# Result:
# - 100 observations of the maximum from samples of size 2
# - 100 observations of the maximum from samples of size 3

# ------------------------------------------------------------
# Step 2: Prepare basis inputs for estimation
# ------------------------------------------------------------
# grid = evaluation grid for density / distribution estimation
# K    = maximum Bernstein polynomial order

inputs <- prepare_inputs(
  grid = seq(0, 1, length.out = 1001),
  K = 20
)

# Note:
# If K is increased substantially, proposal variance in the MCMC sampler
# may need to be adjusted for stable performance.

# ------------------------------------------------------------
# Step 3: Save inputs for downstream estimation
# ------------------------------------------------------------

objects_to_save <- list(
  data = data,
  inputs = inputs
)

saveRDS(objects_to_save, "./simulation/data/inputs_for_estimation.rds")