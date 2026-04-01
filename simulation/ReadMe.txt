To run the simulation:

1. Run: ./simulation/generate/data/gen_data.r
    - data output: ./simulation/inputs_for_estimation.rdata
    Comment: you can adjust the data used by changing the inputs N,K,J

2. Run ./simulation/estimations/density_estimation.r
    - change K_list to contain the order of the polynomials
    - data inputs: ./simulation/inputs_for_estimation.rdata
    - data outputs: ./simulation/density_estimation_output/density_K.rdata (K in K_list)
    
3. Run ./simulation/merge_estimations/merge_density_estimations.r
    - data inputs: ./simulation/density_estimation_output/density_K.rdata (all K that you have used in step 2)
    -data outputs: ./simulation/density_estimation_output/density_estimation.rdata
    
4. Run ./simulation/plotting/plot_estimated_density.r
    -data inputs: ./simulation/inputs_for_estimation.rdata
                  ./simulation/density_estimation_output/density_estimation.rdata
    -plot output: ./simulation/output/x_dens_estimate_K_star_9.pdf
                  ./simulation/output/x_dist_estimate_K_star_9.pdf
    