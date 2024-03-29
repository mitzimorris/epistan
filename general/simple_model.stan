data {
  int<lower=1> N;   // num observations
  int<lower=2> K;   // num groups
  array[N] int<lower=1, upper=K> group;
  vector[N] real y;
}
parameters {
  real alpha;
  real<lower=0> sigma;
  real<lower=0> sigma_group;
  vector<multiplier=sigma_group>[K] beta_group;
}
model {
  y ~ normal(alpha + beta_group[group], sigma);
  sum(beta_group) ~ normal(0, 0.001 * N);  // mean beta_group is normal(0, 0.001)
  // priors alpha, sigma, sigma_group
}
