data {
  int<lower=0> N;
  int<lower=0> n_success;
}
parameters {
  real<lower=0,upper=1> theta;
}
model {
  theta ~ beta(1, 1);
  n_success ~ binomial(N, theta);
}
