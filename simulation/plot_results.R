# ------------------------------------------------------------
# Plot posterior density and distribution estimates
# ------------------------------------------------------------

rm(list = ls())

# Load functions and libraries
source("./set_up/load_libraries.r")
source("./set_up/load_functions.r")

# ------------------------------------------------------------
# Step 1: Load posterior output and simulation inputs
# ------------------------------------------------------------

posterior_output <- readRDS("./simulation/output/posterior.rds")
estimation_inputs <- readRDS("./simulation/data/inputs_for_estimation.rds")

posterior <- posterior_output$posterior
inputs <- estimation_inputs$inputs
data <- estimation_inputs$data

# ------------------------------------------------------------
# Step 2: Prepare posterior plot objects
# ------------------------------------------------------------

density_plot_data <- prepare_posterior_plot(posterior$b_est)
distribution_plot_data <- prepare_posterior_plot(posterior$B_est)

min_data <- min(data$x)
max_data <- max(data$x)

# ------------------------------------------------------------
# Step 3: Construct true density and distribution (simulation benchmark)
# ------------------------------------------------------------

grid <- inputs$grid

true_density_vals <- dunif(
  grid,
)

true_density <- data.frame(
  valuation = grid,
  distribution = true_density_vals,
  category = factor(1),
  line_type_group = factor(1)
)

true_distribution_vals <- punif(
  grid,
)

true_distribution <- data.frame(
  valuation = grid,
  distribution = true_distribution_vals,
  category = factor(1),
  line_type_group = factor(1)
)

# ------------------------------------------------------------
# Step 4: Combine posterior and truth for density plot
# ------------------------------------------------------------

density_plot_matrix <- merge_plot_data(
  density_plot_data$plot_matrix,
  true_density
)

density_plot <- ggplot(
  density_plot_matrix,
  aes(
    x = valuation,
    y = distribution,
    group = category,
    color = line_type_group,
    linetype = line_type_group
  )
) +
  geom_line(linewidth = 0.3) +
  scale_linetype_manual(
    values = c("solid", "dashed", "solid"),
    labels = c("Posterior mean", "95% credible interval", "True density")
  ) +
  scale_color_manual(
    values = c("blue", "blue", "red"),
    labels = c("Posterior mean", "95% credible interval", "True density")
  ) +
  theme(
    legend.title = element_blank(),
    legend.position = "bottom",
    legend.text = element_text(size = 11),
    legend.key = element_blank(),
    panel.background = element_rect(color = "black", fill = "white"),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_blank()
  ) +
  xlab("x") +
  ylab("Density") +
  geom_vline(xintercept = min_data) +
  geom_vline(xintercept = max_data) +
  scale_x_continuous(
    breaks = c(min_data, max_data),
    labels = c("min data", "max data")
  )

ggsave(
  filename = "./simulation/output/density_estimate.png",
  plot = density_plot,
  height = 4,
  width = 4
)


# ------------------------------------------------------------
# Step 5: Combine posterior and truth for distribution plot
# ------------------------------------------------------------

distribution_plot_matrix <- merge_plot_data(
  distribution_plot_data$plot_matrix,
  true_distribution
)

distribution_plot <- ggplot(
  distribution_plot_matrix,
  aes(
    x = valuation,
    y = distribution,
    group = category,
    color = line_type_group,
    linetype = line_type_group
  )
) +
  geom_line(linewidth = 0.3) +
  scale_linetype_manual(
    values = c("solid", "dashed", "solid"),
    labels = c("Posterior mean", "95% credible interval", "True distribution")
  ) +
  scale_color_manual(
    values = c("blue", "blue", "red"),
    labels = c("Posterior mean", "95% credible interval", "True distribution")
  ) +
  theme(
    legend.title = element_blank(),
    legend.position = "bottom",
    legend.text = element_text(size = 11),
    legend.key = element_blank(),
    panel.background = element_rect(color = "black", fill = "white"),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_blank()
  ) +
  xlab("x") +
  ylab("Probability") +
  geom_vline(xintercept = min_data) +
  geom_vline(xintercept = max_data) +
  scale_x_continuous(
    breaks = c(min_data, max_data),
    labels = c("min data", "max data")
  )



ggsave(
  filename = "./simulation/output/distribution_estimate.png",
  plot = distribution_plot,
  height = 4,
  width = 4
)