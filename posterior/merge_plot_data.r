#' Combine Plot Data Frames for Overlaying Multiple Estimates
#'
#' Merges two plot-ready data frames while ensuring that grouping variables
#' (category and line type) remain distinct across datasets.
#'
#' @param df_1 First plot data frame.
#' @param df_2 Second plot data frame.
#'
#' @return Combined data frame suitable for ggplot overlay.
#'
#' @details
#' Both inputs must contain the columns:
#' - `category`: grouping variable for different lines
#' - `line_type_group`: grouping variable for line types (e.g. mean vs CI)
#'
merge_plot_data <- function(df_1, df_2) {
  
  # Copy to avoid modifying originals
  df1 <- df_1
  df2 <- df_2
  
  # Determine offsets
  cat_offset <- max(as.numeric(df1$category))
  line_offset <- max(as.numeric(df1$line_type_group))
  
  # Convert to numeric for shifting
  df1$category <- as.numeric(df1$category)
  df1$line_type_group <- as.numeric(df1$line_type_group)
  
  df2$category <- as.numeric(df2$category) + cat_offset
  df2$line_type_group <- as.numeric(df2$line_type_group) + line_offset
  
  # Combine
  combined <- rbind(df1, df2)
  
  # Convert back to factors
  combined$category <- as.factor(combined$category)
  combined$line_type_group <- as.factor(combined$line_type_group)
  
  return(combined)
}