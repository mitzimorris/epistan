data {
  int<lower=0> N;
  vector[N] x;
}
generated quantities {
  real alpha_sim = normal_rng(0, 2);
  real beta_sim = normal_rng(0, 1);
  real sigma_sim = abs(normal_rng(0, 1));
  vector[N] x_sim;
  for (n in 1:N) {
    x_sim[n]  = uniform_rng(-5, 5);
  }
  array[N] real y_sim = normal_rng(alpha_sim + beta_sim * x_sim, sigma_sim);
  array[N] real y_sim_x = normal_rng(alpha_sim + beta_sim * x, sigma_sim);
}
