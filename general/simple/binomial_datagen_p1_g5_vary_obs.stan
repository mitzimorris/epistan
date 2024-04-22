// 1 binary predictor - population effect
// 2 categorical predictors - group-level effects
// unequal number of observations per category
data {
  int<lower=0> N_obs;
  int<lower=1> N_age, N_eth, N_foo, N_bar, N_baz;
}
transformed data {
  int N = 2 * N_age * N_eth * N_foo * N_bar * N_baz;
}
generated quantities {
  // true parameters
  real sigma_age = abs(std_normal_rng());
  real sigma_eth = abs(std_normal_rng());
  real sigma_foo = abs(std_normal_rng());
  real sigma_bar = abs(std_normal_rng());
  real sigma_baz = abs(std_normal_rng());
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
  vector[N_foo] beta_foo;
  for (n in 1:N_foo) {
    beta_foo[n] = normal_rng(0, sigma_foo);
  }
  vector[N_bar] beta_bar;
  for (n in 1:N_bar) {
    beta_bar[n] = normal_rng(0, sigma_bar);
  }
  vector[N_baz] beta_baz;
  for (n in 1:N_baz) {
    beta_baz[n] = normal_rng(0, sigma_baz);
  }
  // fraction of observations per category
  vector[2] frac_sex = [0.4, 0.6]';
  vector[N_age] frac_age = dirichlet_rng(rep_vector(2, N_age));
  vector[N_eth] frac_eth = dirichlet_rng(rep_vector(1, N_eth));
  vector[N_foo] frac_foo = dirichlet_rng(rep_vector(1, N_foo));
  vector[N_bar] frac_bar = dirichlet_rng(rep_vector(1, N_bar));
  vector[N_baz] frac_baz = dirichlet_rng(rep_vector(1, N_baz));

  // data
  array[N] int tests, pos_tests, sex, age, eth, foo, bar, baz;
  {
    array[N] real mu;  // local var - not reported
    int idx = 0;
    for (i_sex in 0:1) {
      for (i_age in 1:N_age) {
        for (i_eth in 1:N_eth) {
          for (i_foo in 1:N_foo) {
            for (i_bar in 1:N_bar) {
              for (i_baz in 1:N_baz) {
                idx += 1;
                sex[idx] = i_sex;
                age[idx] = i_age;
                eth[idx] = i_eth;
                foo[idx] = i_foo;
                bar[idx] = i_bar;
                baz[idx] = i_baz;
                // tests per strata == product(percentages) * N_obs
                tests[idx] = to_int(frac_sex[i_sex] * frac_age[i_age] * frac_eth[i_eth]
                                    * frac_foo[i_foo] * frac_bar[i_bar] * frac_baz[i_baz]
                                    * N_obs);
                if (tests[idx] > 0) {
                  mu[idx] = alpha + beta_sex * i_sex + beta_age[i_age] + beta_eth[i_eth]
                            + beta_foo[i_foo] + beta_bar[i_bar] + + beta_baz[i_baz];
                  pos_tests[idx] = binomial_rng(tests[idx], inv_logit(mu[idx]));
                } else {
                  pos_tests[idx] = 0;
                }          
              }
            }
          }
        }
      }
    }
  }
}
