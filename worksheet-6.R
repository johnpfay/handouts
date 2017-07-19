## lm
#Pull in file, with explicit fixes
animals <- read.csv('data/animals.csv', stringsAsFactors = FALSE, na.strings = '')

#Construct the model: wt as a function of foot lenght
fit <- lm(
  log(weight) ~ hindfoot_length,
  data = animals)

#view a summary of the model
summary(fit)

#EX 1: foot length vs weight and species 
fit2 <- lm(
  hindfoot_length ~ weight:species_id,
  data = animals)
summary(fit2)

library(dplyr)
fit2 <- lm(
  hindfoot_lenght ~ weight + species_id,
  data = select
)

animals$species_id <- ...
fit <- lm(
  ...,
  data = animals)

## glm
fitG <- glm(log(weight) ~ species_id,
            gaussian(link = 'identity'),
            data = animals)
summary(fitG)


animals$sex <- factor(animals$sex)
fit.logistical <- glm(sex ~ hindfoot_length,
           family = binomial(link = 'logit'),
           data = animals)

## lme4

# install.packages('lme4')

library(lme4)
fit.lme1 <- lmer(log(weight) ~ (1 + hindfoot_length | species_id),
            data = animals)

fit <- lmer(...,
            data = animals)

## RStan

library(dplyr)
library(rstan)
stanimals <- animals %>%
  select(weight, species_id, hindfoot_length) %>%
  na.omit() %>%
  mutate(log_weight = log(weight),
         species_idx = as.integer(factor(species_id))) %>%
  select(-weight, -species_id)
stanimals <- c(
  N = nrow(stanimals),
  M = max(stanimals$species_idx),
  as.list(stanimals))

samp <- stan(file = 'worksheet-6.stan',
             data = stanimals,
             iter = 1000, chains = 3)
saveRDS(samp, 'stanimals.RDS')
