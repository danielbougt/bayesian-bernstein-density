#' Prepare Bernstein Basis Inputs
#'
#' Constructs the Bernstein polynomial basis objects used for density and
#' distribution estimation on a given grid, for polynomial orders 1 through K.
#'
#' @param grid Numeric vector. Grid points where the density and CDF bases are evaluated.
#' @param K Integer. Maximum polynomial order to prepare.
#'
#' @return A list containing:
#' \itemize{
#'   \item `index`: matrix of grid indices corresponding to split points i / k
#'   \item `b_bases`: list of density basis matrices for orders 1, ..., K
#'   \item `B_bases`: list of distribution basis matrices for orders 1, ..., K
#'   \item `grid`: original evaluation grid
#' }
#'
#' @details
#' For each polynomial order k = 1, ..., K:
#' - `b_bases[[k]]` contains Beta density basis functions
#' - `B_bases[[k]]` contains Bernstein CDF basis functions
#'
#' The `index` object maps split points i/k to the nearest grid location below
#' each split.
#'
#' @examples
#' grid <- seq(0, 1, length.out = 100)
#' basis_inputs <- prepare_inputs(grid, K = 5)
#'
prepare_inputs <- function(grid, K) {
  
  # Split points i / k for all polynomial orders
  splits <- matrix(0, nrow = K, ncol = K)
  for (k in 1:K) {
    splits[1:k, k] <- (1:k) / k
  }
  
  # Indices of grid points corresponding to each split point
  index <- matrix(0, nrow = K, ncol = K)
  for (k in 1:K) {
    for (j in 1:k) {
      index[j, k] <- max(which(grid <= splits[j, k]))
    }
  }
  
  grid_length <- length(grid)
  
  b_bases <- vector("list", K)
  B_bases <- vector("list", K)
  
  grid_data <- matrix(grid, nrow = grid_length, ncol = 1)
  
  # Construct basis matrices for each polynomial order
  for (k in 1:K) {
    b_bases[[k]] <- matrix(0, nrow = grid_length, ncol = k)
    B_bases[[k]] <- matrix(0, nrow = grid_length, ncol = k)
    
    for (j in 1:k) {
      b_bases[[k]][, j] <- dbeta(grid_data[, 1], j, k - j + 1)
      B_bases[[k]][, j] <- choose(k, j) * grid_data[, 1]^j * (1 - grid_data[, 1])^(k - j)
    }
  }
  
  return(list(
    index = index,
    b_bases = b_bases,
    B_bases = B_bases,
    grid = grid
  ))
}