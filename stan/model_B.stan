data{
      int N;// sample size
      real y[N];//log of income
}
parameters {
  real <lower=0, upper=1> b; //投資利益率
  real<lower=0, upper=1> p; //成功確率
}
transformed parameters{//y0=10, n=10を仮定
  real m;
  real s;
	real y0;// initial capital
  real n;// number of chance
  y0=10;n=10;
  m = log(y0)+log(1+b)*n*p;
  s = sqrt(n*p*(1-p))*log(1 + b);
}
model {
  y ~ normal(m,s);
}
