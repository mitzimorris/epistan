// 1 binary predictor - population effect
// 2 categorical predictors - group-level effects
// unequal number of observations per category
data {
  int<lower=0> N_obs;
  int<lower=1> N_age, N_eth;
}
transformed data {
  int N = 2 * N_age * N_eth;
}
generated quantities {
  // true parameters
  real sigma_age = abs(std_normal_rng());
  real sigma_eth = abs(std_normal_rng());
  real alpha = normal_rng(-1, 1);  // log-odds success baseline < 0
  real beta_sex = std_normal_rng();
  vector[N_age] beta_age;
  for (n in 1:N_age) {
    beta_age[n] = normal_rng(0, sigma_age);
  }
  vector[N_eth] beta_eth;
  for (n in 1:N_eth) {
    beta_eth[n] = normal_rng(0, sigma_eth);
  }
  // fraction of observations per category
  vector[2] frac_sex = [0.4, 0.6]';
  vector[N_age] frac_age = dirichlet_rng(rep_vector(2, N_age));
  vector[N_eth] frac_eth = dirichlet_rng(rep_vector(1, N_eth));

  // data
  array[N] int tests, pos_tests, sex, age, eth;
  {
    array[N] real mu;  // local var - not reported
    int idx = 0;
    for (i_sex in 0:1) {
      for (i_age in 1:N_age) {
        for (i_eth in 1:N_eth) {
          idx += 1;
          sex[idx] = i_sex;
          age[idx] = i_age;
          eth[idx] = i_eth;
          // tests per strata == product(percentages) * N_obs
          tests[idx] = to_int(frac_sex[i_sex] * frac_age[i_age] * frac_eth[i_eth] * N_obs);
          if (tests[idx] > 0) {
            mu[idx] = alpha + beta_sex * i_sex + beta_age[i_age] + beta_eth[i_eth];
            pos_tests[idx] = binomial_rng(tests[idx], inv_logit(mu[idx]));
          } else {
            pos_tests[idx] = 0;
          }          
        }
      }
    }
  }
}
