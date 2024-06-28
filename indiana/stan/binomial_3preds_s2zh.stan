data {
  int<lower=1> N; // number of strata
  int<lower=2> N_age, N_eth;

  array[N] int<lower=0> tests;
  array[N] int<lower=0> pos_tests; // observed outcome
  
   array[N] int<lower=1, upper=2> sex;
  array[N] int<lower=1, upper=N_age> age;
  array[N] int<lower=1, upper=N_eth> eth;

  // hyperparameters
  real<lower=0, upper=1> sens, spec;
  real intercept_prior_mean;
  real<lower=0> intercept_prior_scale;
}
parameters {
  real alpha, beta_sex_raw;
  real<lower=0> sigma_age, sigma_eth;
  vector[N_age - 1] beta_age_raw;
  vector[N_eth - 1] beta_eth_raw;
}
transformed parameters {
  vector[2] beta_sex = [ beta_sex_raw, -beta_sex_raw ]';
  vector<multiplier=sigma_age>[N_age] beta_age = append_row(beta_age_raw, -sum(beta_age_raw));
  vector<multiplier=sigma_eth>[N_eth] beta_eth = append_row(beta_eth_raw, -sum(beta_eth_raw));
  vector[N] pop_prev =  inv_logit(alpha + beta_sex[sex] + beta_age[age] + beta_eth[eth]);
  vector[N] prob_pos_test = pop_prev * sens + (1 - pop_prev) * (1 - spec);
}
model {
  pos_tests ~ binomial(tests, prob_pos_test);  // likelihood

  alpha ~ normal(intercept_prior_mean, intercept_prior_scale);
  beta_sex ~ normal(0, 2.5);
  beta_age~ normal(0, sigma_age);
  beta_eth ~ normal(0, sigma_eth);

  sigma_eth ~ normal(0, 2.5);
  sigma_age ~ normal(0, 2.5);
}
generated quantities {
  array[N] real log_lik;
  for (n in 1:N) {
    log_lik[n] = binomial_lpmf(pos_tests[n] | tests[n], prob_pos_test[n]);
  }
  array[N] int y_rep = binomial_rng(tests, prob_pos_test);
}
