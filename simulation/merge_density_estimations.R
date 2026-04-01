# ------------------------------------------------------------
# Merge estimation results across polynomial orders
# ------------------------------------------------------------

rm(list = ls())

# Load functions and libraries
source("./set_up/load_libraries.r")
source("./set_up/load_functions.r")

# ------------------------------------------------------------
# Step 1: Identify estimation output files
# ------------------------------------------------------------

files <- list.files(
  "./simulation/density_estimation_output",
  pattern = "^density_[0-9]+\\.rds$"
)

# Extract polynomial order K from filenames
K_values <- as.numeric(str_extract(files, "[0-9]+"))

# Sort files by K
sorted_idx <- order(K_values)
files <- files[sorted_idx]
K_values <- K_values[sorted_idx]

# ------------------------------------------------------------
# Step 2: Load estimation results
# ------------------------------------------------------------

parameters <- vector("list", length(files))
likelihood_chains <- vector("list", length(files))

for (i in seq_along(files)) {
  
  file_path <- file.path("./simulation/density_estimation_output", files[i])
  result_i <- readRDS(file_path)
  
  parameters[[i]] <- result_i$parameters[[1]]
  likelihood_chains[[i]] <- result_i$likelihood_chain[[1]]
}

# ------------------------------------------------------------
# Step 3: Save merged estimation object
# ------------------------------------------------------------

estimation <- list(
  K_values = K_values,
  parameters = parameters,
  likelihood_chains = likelihood_chains
)

saveRDS(
  estimation,
  "./simulation/density_estimation_output/density_estimation.rds"
)