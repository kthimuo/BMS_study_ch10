library(rstan)
library(bayesplot)

options(mc.cores=parallel::detectCores())
options(mc.cores=1)

data <- read.csv('~/BMS/ch08/SSPI2015.csv')
data <- data[data$Y>0 & data$Y<2500,]
#年収が0または2500万以上は除外

#年収を対数化する
data$Y <- log(data$Y)
data.ssp2015 = list(
  y = data$Y,
  N = length(data$Y),
  EDU = data$EDU,
  FEM = data$FEM
)

#[プロセスA]
fit_A <- stan(file='~/BMS/ch10/model/model-10-1.stan',pars=c('m','s','p','b','log_lik'),
             data=data.ssp2015,seed=1234,warmup=500, iter=1500,chains = 4)
mcmc_combo(fit_A, pars = c('m','s','p','b'))
summary(fit_A)$summary[c('m','s','p','b'),c(1,4,8,9,10)]

#[プロセスB]投資に失敗しても年収は下がらないモデル
fit_B <- stan(file="./stan/model_B.stan",pars=c('m','s','p','b'),
             data=data.ssp2015,seed=1234,warmup=500, iter=1500,chains = 4)
mcmc_combo(fit_B, pars = c('m','s','p','b'))
summary(fit_B)$summary[c('m','s','p','b'),c(1,4,8,9,10)]

#[プロセスC]成功確率pに個人差があり、それは性別と教育年数で説明できる
fitC <- stan(file="./stan/model_C.stan",
             data=data.ssp2015,seed=1234,warmup=500, iter=1500,chains = 4)
mcmc_combo(fitC, pars = c('m[1]','s[1]','a[1]','a[2]','b'))
summary(fitC)$summary[c('m[1]','s[1]','a[1]','a[2]','b'),c(1,4,8,9,10)]
