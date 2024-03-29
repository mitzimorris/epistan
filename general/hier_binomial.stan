data {
  int<lower=1> N; // number of strata
  int<lower=3> N_age, N_eth;
  vector<lower=0, upper=1>[N] sex; // 0 = male, 1 = female
  array[N] int<lower=1, upper=N_age> age;
  array[N] int<lower=1, upper=N_eth> eth;
  array[N] int<lower=0> tests;
  array[N] int<lower=0> pos_tests; // observed outcome
}
parameters {
  real alpha, beta_female;
  real<lower=0> sigma_age, sigma_eth;
  vector<multiplier=sigma_age>[N_age] beta_age;
  vector<multiplier=sigma_eth>[N_eth] beta_eth;
}
model {
  num_pos ~ binomial(tests,
                     alpha + beta_female * sex + beta_age[age] + beta_eth[eth]);
  // priors
  alpha ~ normal(0, 5);
  beta_female ~ normal(0, 2.5);
  beta_age ~ normal(0, sigma_age);
  beta_eth ~ normal(0, sigma_eth);
  sigma_age ~ normal(0, 2.5);
  sigma_eth ~ normal(0, 2.5);
}                     
