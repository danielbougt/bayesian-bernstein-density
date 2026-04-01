local({
  required_packages <- c(
    "dplyr",
    "stringr",
    "extraDistr",
    "pracma",
    "ggplot2",
    "latex2exp",
    "mvtnorm"
  )
  
  for (pkg in required_packages) {
    if (!require(pkg, character.only = TRUE)) {
      install.packages(pkg)
      library(pkg, character.only = TRUE)
    }
  }
})