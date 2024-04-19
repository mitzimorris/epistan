data {
  int N_obs;
}
generated quantities {
  real theta = beta_rng(1, 1);  // chance of success (uniform prior)
  array[N_obs] int y;  // outcome of each bernoulli trial
  for (n in 1:N_obs) {
    y[n] = bernoulli_rng(theta);
  }
}
