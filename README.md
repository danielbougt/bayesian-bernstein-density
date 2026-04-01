
# Bayesian Bernstein Density Estimation

This repository implements a Bayesian nonparametric framework to
estimate an unknown distribution from order statistic data (e.g. auction
outcomes). The approach uses Bernstein polynomials to approximate the
distribution, with Dirichlet-distributed weights and inference via
Metropolis–Hastings MCMC. The pipeline includes model selection over
polynomial order, posterior inference, and visualization of estimated
densities and distribution functions.

## Motivation

In many economic and applied settings, we do not observe full data
distributions but only partial information such as order statistics
(e.g. highest bids, top incomes). Recovering the underlying distribution
is essential for understanding behavior, evaluating policies, and
conducting counterfactual analysis.

This project demonstrates how such latent distributions can be estimated
using flexible, nonparametric Bayesian methods.

## Method Overview

- **Bernstein polynomial approximation**  
  The unknown CDF is approximated using Bernstein polynomials, ensuring
  valid densities and flexibility.

- **Likelihood from order statistics**  
  The model uses the analytical density of order statistics to link
  observed data to the latent distribution.

- **Bayesian estimation**

  - Dirichlet prior on polynomial weights  
  - Metropolis–Hastings MCMC for inference

- **Model selection**  
  Polynomial order is selected using marginal likelihood, balancing
  flexibility and overfitting.

- **Posterior inference**  
  The pipeline produces:

  - posterior mean estimates of density and CDF  
  - credible intervals  
  - visual comparisons with true distributions (in simulations)

## How to run

### Full pipeline (recommended)

Run the entire simulation in batch mode:

``` bash
Rscript ./simulation/master.R
```

### Manual execution (optional)

Run scripts step-by-step for more control:

1.  Generate data

``` bash
Rscript ./simulation/generate_data.R
```

2.  Run MCMC estimation (default `K_list=10`, can be changed)

``` bash
Rscript ./simulation/density_estimation.R
```

3.  Merge estimates

``` bash
Rscript ./simulation/merge_density_estimation.R
```

4.  Select model order and compute posterior summaries

``` bash
Rscript ./simulation/model_selection_and_posterior.R
```

5.  Plot results  

``` bash
Rscript ./simulation/plot_results.R
```

## Output

- Estimated density and CDF  
- Credible intervals  
- Comparison to true distribution (simulated data)

## Example output

<div style="display: flex; gap: 20px;">

<img src="./simulation/example_plots/density_example.png" width="45%">
<img src="./simulation/example_plots/CDF_example.png" width="45%">

</div>

<p align="center">

<img src="./simulation/example_plots/examples_legend.png" width="100%">
</p>

## Tools

R (dplyr, stringr, extraDistr, pracma, ggplot2, latex2exp, mvtnorm)

## Key features

- End-to-end Bayesian estimation pipeline
- Flexible nonparametric modelling using Bernstein polynomials  
- Explicit handling of order statistic data
- Model selection via marginal likelihood
- Reproducible and modular code structure
