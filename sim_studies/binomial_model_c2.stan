data {
  int<lower=0> N;  // strata (distinct subpopulations)
  int<lower=1> N_age, N_eth;
  array[N] int<lower=0> tests, pos_tests;
  array[N] int<lower=1, upper=N_age> age;
  array[N] int<lower=1, upper=N_eth> eth;
}
parameters {
  real alpha;   // common intercept
  real<lower=0> sigma_age, sigma_eth;  // group-level variance
  vector<multiplier=sigma_age>[N_age] beta_age;  // non-centered parameterization
  vector<multiplier=sigma_eth>[N_eth] beta_eth;
}
transformed parameters {
  vector[N] mu = alpha + beta_age[age] + beta_eth[eth];
}  
model {
  // likelihood
  pos_tests ~ binomial(tests, inv_logit(mu));
  // priors
  alpha ~ normal(0, 2.5);  // very weak
  sigma_age ~ normal(0, 2.5);
  sigma_eth ~ normal(0, 2.5);
  beta_age ~ normal(0, sigma_age);
  beta_eth ~ normal(0, sigma_eth);
}
generated quantities {
  array[N] int pos_tests_rep = binomial_rng(tests, inv_logit(mu));
}
