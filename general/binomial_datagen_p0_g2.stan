// no population effect
// 2 categorical predictors - group-level effects
data {
  int<lower=0> N_obs;
  int<lower=1> N_age, N_eth;
}
transformed data {
  int N = N_age * N_eth;
}
generated quantities {
  // true parameters
  real sigma_age = abs(std_normal_rng());
  real sigma_eth = abs(std_normal_rng());
  real alpha = normal_rng(-1, 1);  // log-odds success baseline < 0
  vector[N_age] beta_age;
  for (n in 1:N_age) {
    beta_age[n] = normal_rng(0, sigma_age);
  }
  vector[N_eth] beta_eth;
  for (n in 1:N_eth) {
    beta_eth[n] = normal_rng(0, sigma_eth);
  }
  // data
  int N_tests = N_obs %/% N;  // integer division
  array[N] int<lower=0> tests = rep_array(N_tests, N);
  array[N] int pos_tests, sex, age, eth;
  {
    int idx = 0;  // local vars - not written to output file
    array[N] real mu;
    for (i_age in 1:N_age) {
      for (i_eth in 1:N_eth) {
        idx += 1;
        age[idx] = i_age;
        eth[idx] = i_eth;
        mu[idx] = alpha + beta_age[i_age] + beta_eth[i_eth];
        pos_tests[idx] = binomial_rng(tests[idx], inv_logit(mu[idx]));
      }
    }
  }
}
