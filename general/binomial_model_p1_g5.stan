data {
  int<lower=0> N;  // strata (distinct subpopulations)
  int<lower=1> N_age;
  int<lower=1> N_eth;
  int<lower=1> N_foo;
  int<lower=1> N_bar;
  int<lower=1> N_baz;
  array[N] int<lower=0> tests;
  array[N] int<lower=0> pos_tests;
  array[N] int<lower=0, upper=1> sex;
  array[N] int<lower=1, upper=N_age> age;
  array[N] int<lower=1, upper=N_eth> eth;
  array[N] int<lower=1, upper=N_foo> foo;
  array[N] int<lower=1, upper=N_bar> bar;
  array[N] int<lower=1, upper=N_baz> baz;
}
parameters {
  real alpha;   // common intercept
  real beta_sex;
  real<lower=0> sigma_age, sigma_eth, sigma_foo, sigma_bar, sigma_baz;
  vector<multiplier=sigma_age>[N_age] beta_age;
  vector<multiplier=sigma_eth>[N_eth] beta_eth;
  vector<multiplier=sigma_foo>[N_foo] beta_foo;
  vector<multiplier=sigma_bar>[N_bar] beta_bar;
  vector<multiplier=sigma_baz>[N_baz] beta_baz;
}
transformed parameters {
  vector[N] mu = alpha + to_vector(sex) * beta_sex + beta_age[age] + beta_eth[eth]
      + beta_foo[foo] + beta_bar[bar] + beta_baz[baz];
}  
model {
  // likelihood
  pos_tests ~ binomial(tests, inv_logit(mu));
  // priors
  alpha ~ normal(0, 2.5);  // very weak
  sigma_age ~ normal(0, 2.5);
  sigma_eth ~ normal(0, 2.5);
  sigma_foo ~ normal(0, 2.5);
  sigma_bar ~ normal(0, 2.5);
  sigma_baz ~ normal(0, 2.5);
  beta_sex ~  normal(0, 2.5);
  beta_age ~ normal(0, sigma_age);
  beta_eth ~ normal(0, sigma_eth);
  beta_foo ~ normal(0, sigma_foo);
  beta_bar ~ normal(0, sigma_bar);
  beta_baz ~ normal(0, sigma_baz);
}
generated quantities {
  array[N] int pos_tests_rep = binomial_rng(tests, inv_logit(mu));
}
