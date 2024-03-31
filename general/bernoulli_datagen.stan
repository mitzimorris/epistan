data {
  int N_obs;
}
generated quantities {
  int N = N_obs;
  array[N_obs] int test_results;  // observed outcomes
  real theta = uniform_rng(0.0, 1.0);  // probability of success
  for (n in 1:N) {
    test_results[n] = bernoulli_rng(theta);
  }
}
