data{
      int N;// sample size
      real y[N];//log of income
}
parameters {
  real <lower=0, upper=1> b; //投資利益率
  real<lower=0, upper=1> p; //成功確率
}

transformed parameters{//y0=10, n=10を仮定
  vector[N] m;
  vector[N] s;
  real <lower=0> y0;// initial capital
  real n;// number of chance
  y0=10;n=10;
  for (i in 1:N){
    m[i] = log(10)+n*log(1)+log(1+b)*n*p;
    s[i] = sqrt(n*p*(1-p))*log((1 + b )/(1));
  }
  }

model {
  y ~ normal(m,s);
}
