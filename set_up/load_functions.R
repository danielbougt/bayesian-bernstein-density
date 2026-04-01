# ------------------------------------------------------------
# Load project functions
# ------------------------------------------------------------

# ------------------------------------------------------------
# Data generation
# ------------------------------------------------------------
source("./generate_data/gen_sim_data_uniform.r")

# ------------------------------------------------------------
# Input preparation (grid, bases)
# ------------------------------------------------------------
source("./auxiliary_functions/prepare_inputs.r")

# ------------------------------------------------------------
# Likelihood and prior
# ------------------------------------------------------------
source("./likelihood_functions/order_stat_likelihood.r")
source("./likelihood_functions/dirichlet_prior.r")

# ------------------------------------------------------------
# Order statistic transformations
# ------------------------------------------------------------
source("./auxiliary_functions/order_stat_density.r")

# ------------------------------------------------------------
# Numerical tools
# ------------------------------------------------------------
source("./auxiliary_functions/trapezoid_integration.r")

# ------------------------------------------------------------
# MCMC sampling
# ------------------------------------------------------------
source("./mh_sampler/mh_propose_weights.r")

# ------------------------------------------------------------
# Convergence diagnostics
# ------------------------------------------------------------
source("./convergence_test/estimate_mcmc_tau.r")
source("./convergence_test/partial_means.r")

# ------------------------------------------------------------
# Model selection
# ------------------------------------------------------------
source("./model_selection/estimate_marginal_likelihood.r")

# ------------------------------------------------------------
# Posterior summaries and plotting
# ------------------------------------------------------------
source("./posterior/posterior_summary.r")
source("./posterior/prepare_posterior_plot.r")
source("./posterior/merge_plot_data.r")