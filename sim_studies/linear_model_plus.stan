// fit model, produce datasets y_rep and y_sim
data {
  int<lower=0> N;
  vector[N] x;
  vector[N] y;
}
parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
}
model {
  alpha ~ normal(0, 2);
  beta ~ normal(0, 1);
  sigma ~ normal(0, 1);
  y ~ normal(alpha + beta * x, sigma);
}
generated quantities {
  // replicate modeled variate y from the posterior
  array[N] real y_rep = normal_rng(alpha + beta * x, sigma);

  // simulate modeled variate y from the priors and observed data x
  real alpha_sim = normal_rng(0, 2);
  real beta_sim = normal_rng(0, 1);
  real sigma_sim = abs(normal_rng(0, 1));
  array[N] real y_sim = normal_rng(alpha_sim + beta_sim * x, sigma_sim);
}
