#' Prepare and Plot Posterior Summaries
#'
#' Converts posterior summary output into a long-format data frame suitable
#' for plotting, and returns both the plotting data and a default ggplot object.
#'
#' @param posterior_frame Numeric matrix or data frame with four columns:
#'   \itemize{
#'     \item column 1: grid values
#'     \item column 2: posterior mean
#'     \item column 3: lower credible bound
#'     \item column 4: upper credible bound
#'   }
#'
#' @return A list with:
#' \itemize{
#'   \item `plot_object`: ggplot object
#'   \item `plot_matrix`: long-format data frame used for plotting
#' }
#'
#' @examples
#' # prepare_posterior_plot(posterior$b_est)
#'
prepare_posterior_plot <- function(posterior_frame) {
  
  n <- nrow(posterior_frame)
  
  plot_matrix <- rbind(
    cbind(posterior_frame[, c(1, 2)], category = 1),
    cbind(posterior_frame[, c(1, 3)], category = 2),
    cbind(posterior_frame[, c(1, 4)], category = 3)
  )
  
  plot_matrix <- as.data.frame(plot_matrix)
  colnames(plot_matrix) <- c("valuation", "distribution", "category")
  
  # Group posterior mean separately from interval bounds
  plot_matrix$line_type_group <- 1
  plot_matrix$line_type_group[(n + 1):(3 * n)] <- 2
  
  plot_matrix$category <- as.factor(plot_matrix$category)
  plot_matrix$line_type_group <- as.factor(plot_matrix$line_type_group)
  
  plot_object <- ggplot2::ggplot(
    plot_matrix,
    ggplot2::aes(x = valuation, y = distribution, group = category)
  ) +
    ggplot2::geom_line(ggplot2::aes(linetype = line_type_group)) +
    ggplot2::theme(legend.position = "bottom") +
    ggplot2::guides(linetype = ggplot2::guide_legend(title = NULL))
  
  return(list(
    plot_object = plot_object,
    plot_matrix = plot_matrix
  ))
}