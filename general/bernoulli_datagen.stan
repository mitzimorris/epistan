data {
  int N;
}
generated quantities {
  real theta = beta_rng(1, 1);  // chance of success (uniform prior)
  array[N] int y;  // outcome of each bernoulli trial
  for (n in 1:N) {
    y[n] = bernoulli_rng(theta);
  }
}
