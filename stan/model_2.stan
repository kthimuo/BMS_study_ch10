data{
      int N;// sample size
      real y[N];//log of income
      real EDU[N];
      real FEM[N];
      real AGE[N];
}
parameters {
  real <lower=0, upper=1> b; //投資利益率
  vector[2] a;
}

transformed parameters{//y0=10, n=10を仮定
  vector[N] m;
  vector[N] s;
  vector<lower=0, upper=1>[N] p;
	real <lower=0> y0;// initial capital
  real n;// number of chance
  y0=10;n=10;
  for (i in 1:N){
    p[i] = inv_logit(a[1]*EDU[i] + a[2]*FEM[i]);
    m[i] = log(10)+n*log(1)+log((1+b)/(1))*n*p[i];
    s[i] = sqrt(n*p[i]*(1-p[i]))*log((1 + b )/(1));
  }
  }

model {
  y ~ normal(m,s);
}
