library(rstan)
library(bayesplot)

options(mc.cores=parallel::detectCores())
options(mc.cores=1)

data <- read.csv('~/BMS/ch08/SSPI2015.csv')

#年収が0または2500万以上は除外
data %>%
  filter(Y <= 2500) %>%
  filter(Y >0) ->data
#年収を対数化する
data$Y <- log(data$Y)
data.ssp2015 = list(
  y = data$Y,
  N = length(data$Y),
  EDU = data$EDU,
  FEM = data$FEM,
  AGE = data$AGE
)

#本
fit_normal <- stan(file='~/BMS/ch10/model/model-10-1.stan',pars=c('m','s','p','b','log_lik'),
             data=data.ssp2015,seed=1,warmup=500, iter=1500,chains = 4)
summary(fit_normal)$summary[c('m','s','p','b'),c(1,4,8,9,10)]

#[アレンジ1]投資に失敗しても年収は下がらないモデル
fit1 <- stan(file="./stan/model_1.stan",pars=c('m','s','p','b'),
             data=data.ssp2015,seed=1,warmup=500, iter=1500,chains = 4)
summary(fit1)$summary[c('m','s','p','b'),c(1,4,8,9,10)]
mcmc_combo(fit1, pars = c('m','s','p','b'))

#[アレンジ2]成功確率pに個人差があり、それは性別と教育年数で説明できる
fit2 <- stan(file="./stan/model_2.stan",pars=c('m','s','a','b'),
             data=data.ssp2015,seed=1,warmup=500, iter=1500,chains = 4)
summary(fit2)$summary[c('m[1]','s[1]','a[1]','a[2]','b'),c(1,4,8,9,10)]
mcmc_combo(fit2, pars = c('m[1]','s[1]','a[1]','b'))
