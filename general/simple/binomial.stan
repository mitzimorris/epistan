data {
  int<lower=0> N;
  array[N] int<lower=0,upper=1> y;
}
transformed data {
  int sum_y = sum(y);
}
parameters {
  real<lower=0,upper=1> theta;
}
model {
  theta ~ beta(1, 1);
  sum_y ~ binomial(N, theta);
}
