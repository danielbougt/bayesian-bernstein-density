Technical Details
================
Daniel Bougt-Hernnäs
2026-04-01

## Overview

This project estimates a bounded distribution $F(x)$ with density $f(x)$
using a semi-nonparametric Bayesian approach based on Bernstein
polynomials.

## Model

- Data: $x_1, ..., x_n \sim F(x)$

- Density: $$
  f(x \mid w, K) = \sum_{k=1}^K w_k \, \text{Beta}(x; k, K-k+1)
  $$

- Constraints:

  - $w_k \ge 0$
  - $\sum w_k = 1$

- CDF: $$
  F(x \mid w, K) = \sum_{k=1}^K W_k \binom{K}{k} x^k (1-x)^{K-k}, \quad W_k = \sum_{j=1}^k w_j
  $$

## Prior

- $w \mid K \sim \text{Dirichlet}(1, ..., 1)$

## Inference

Posterior: $$
p(w \mid K, \text{data})
$$

Estimated using Metropolis–Hastings MCMC.

## Estimation

Using posterior samples $w^{(s)}$:

- Density: $$
  \hat f(x) = \frac{1}{S} \sum_{s=1}^S f(x \mid w^{(s)}, K)
  $$

- CDF: $$
  \hat F(x) = \frac{1}{S} \sum_{s=1}^S F(x \mid w^{(s)}, K)
  $$

## Model Selection

- Polynomial order $K$ selected via marginal likelihood.

## Data Generating Process in Simulation

- Underlying distribution: uniform  
- Observations:
  - 100 draws of the maximum from samples of size 2  
  - 100 draws of the maximum from samples of size 3

Only the highest order statistics are observed.

## Project Structure

- `auxiliary_functions`: helper functions for likelihood  
- `convergence_test`: MCMC convergence diagnostics  
- `generate_data`: data generation for simulation
- `likelihood_functions`: customizable likelihood
- `mh_sampler`: proposal mechanism  
- `model_selection`: selects polynomial order $K$ via marginal
  likelihood  
- `posterior`: tools for posterior analysis  
- `set_up`: package loading and setup  
- `simulation`: simulation scripts and examples

## References

- Aryal, G., Grundl, S., Kim, D., & Zhu, Y. (2018). Empirical relevance
  of ambiguity in first-price auctions. Journal of econometrics, 204(2),
  189-206. <https://doi.org/10.1016/j.jeconom.2018.02.001>
- Bougt-Hernnäs, D., Ghosh, G., Liu, H. (2025) Ambiguity and the
  declining price anomamly: estimation of a sequential auction model.
  Working paper.
  <https://www.dropbox.com/s/ootgqafk97u9qlg/Empirical_Ambiguity.pdf?dl=0>
- Petrone, S. (1999). Random Bernstein Polynomials. Scandinavian journal
  of statistics, 26(3), 373-393.
  <https://doi.org/10.1111/1467-9469.00155> Petrone, S. (1999). Bayesian
  density estimation using bernstein polynomials. Canadian journal of
  statistics, 27(1), 105-126. <https://doi.org/10.2307/3315494>
