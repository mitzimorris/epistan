data {
  int<lower=3> N_obs, N_age, N_eth;
  real log_intercept;
}
transformed data {
  int strata = 2 * N_age * N_eth;
}
generated quantities {
  // parameter values
  real alpha = log_intercept;
  real beta_female = normal_rng(0, 1);
  real sigma_age = abs(normal_rng(0, 1));
  vector[N_age] beta_age;
  for (n in 1:N_age) {
    beta_age[n] = normal_rng(0, sigma_age);
  }
  real sigma_eth = abs(normal_rng(0, 1));
  vector[N_eth] beta_eth;
  for (n in 1:N_eth) {
    beta_eth[n] = normal_rng(0, sigma_eth);
  }
  // observations per category (unequal)
  vector[2] pct_sex = [0.4, 0.6]';
  vector[N_age] pct_age = dirichlet_rng(rep_vector(2, N_age));
  vector[N_eth] pct_eth = dirichlet_rng(rep_vector(1, N_eth));

  // data
  int N = strata;
  array[strata] int sex, age, eth, pos_tests, tests;
  array[strata] real prob_pos_test;
  {
    int i = 0;  // local var, not reported
    for (i_sex in 1:2) {
      for (i_age in 1:N_age) {
        for (i_eth in 1:N_eth) {
          i += 1;
          sex[i] = i_sex - 1; // coding M == 0, F == 1
          age[i] = i_age;
          eth[i] = i_eth;
          tests[i] = to_int(pct_sex[i_sex] * pct_age[i_age] * pct_eth[i_eth] * N_obs);
          prob_pos_test[i] = inv_logit(alpha + beta_female * (i_sex - 1) + beta_age[i_age] + beta_eth[i_eth]);
          pos_tests[i] = binomial_rng(tests[i], prob_pos_test[i]);
        }
      }
    }
  }
}
