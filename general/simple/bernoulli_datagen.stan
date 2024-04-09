data {
  int N_obs;
}
generated quantities {
  real theta = beta_rng(1, 1);  // prob of success (uniform prior)
  array[N_obs] int y = bernoulli_rng(rep_array(theta, N_obs));
}
