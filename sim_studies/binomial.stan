data {
  int<lower=0> N;
  int<lower=1> trials;
  int<lower=0> successes;
}
parameters {
  real<lower=0, upper=1> theta;
}
model {
  theta ~ beta(1, 1);
  successes ~ binomial(trials, theta);
}
