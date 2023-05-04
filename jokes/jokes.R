rm(list = ls())

library(tidyverse)
library(lme4)

jdat = read.table("https://raw.githubusercontent.com/espenmei/PSY9185/main/jokes/jokes.dat", header = T, sep = "\t")

# Focus on Joke scores for now
jdat = jdat[!is.na(jdat$Joke), ]

length(unique(jdat$joke_id))
length(unique(jdat$rater_id))
# We have 64 jokes and 31 raters, two jokes were told but did not rate. Eivind?

xtabs(~joke_id + rater_id, jdat)
image(xtabs(~joke_id + rater_id, jdat, sparse = T))
# Should be at least two missing for each rater (columns)

plot(table(jdat$Joke))
# We treat these as continuous

# Model 1 - ignore any grouping factors
m1 = lm(Joke~1, jdat)
summary(m1)
sigma(m1)^2
# The average rating across jokes and raters is 2.17. The variance in ratings across jokes and raters is 0.96

# Model 2 - joke effect
# Some of this variance may be because some jokes are more funny than others
m2 = lmer(Joke~1+(1|joke_id), jdat)
summary(m2)
# The variance in ratings because jokes are different is 0.18
# Some of the residual variance is probably due to differences between raters

# Model 3 - joke and rater effect
m3 = lmer(Joke~1+(1|joke_id)+(1|rater_id), jdat)
summary(m3)
# The variance in ratings because jokes are different is 0.18
# The variance in ratings because raters are different is 0.15
# The residual variance is 0.64
# 
# The within-joke, between-rater intraclass correlation is:
0.18 / (0.18 + 0.15 + 0.64)
# The within-rater, between-joke intraclass correlation is:
0.15 / (0.18 + 0.15 + 0.64)
# 
# The joke effect says something about how much variability there is in how funny jokes are, independent of who rates the joke
# The rater effect says something about how much variability there is between raters in how funny they think jokes are, independent of which joke it is
# Some variance (residuals) is still left due to different raters preferring different jokes (interaction), and other stuff such as measurement error
# 
# What does this mean? I dont know, but
# If there is variability between jokes, I should think about which joke i tell.
# If there is variability between raters, I should think about who I tell jokes to.
# We find both
# There is probably some interaction (part of the residuals), so which joke I should tell depends on who i will tell it to. 

# We can look at the joke effects
re = ranef(m3)
re_joke = re$joke_id[, 1]
plot(sort(re_joke), main = "Joke effect", ylab = "Deviation", pch = 18, col = "blue")
text(sort(re_joke), labels = order(re_joke), cex= 1.0, pos = 2, col = "red")
# We cant trace back and find the jokes 

# And the rater effects
re_rater = re$rater_id[, 1]
plot(sort(re_rater), main = "Rater effect", ylab = "Deviation", pch = 18, col = "blue")
text(sort(re_rater), labels = order(re_rater), cex = 1.0, pos = 2, col = "red")

# Model 4 - explaining the rater effects
# We might try to explain why different raters rate different by modeling how useful they found this exercise.
table(jdat$useful, useNA = "ifany")
# Then we include dummy variables for the categories
jdat_use = filter(jdat, !is.na(useful))
m4 = lmer(Joke~1+useful+(1|joke_id)+(1|rater_id), jdat_use, REML = F)
summary(m4)
# There are some missing values here, so we want to refit model 3 to the non-missing observations.
# Then we have a model to compare against
m5 = lmer(Joke~1+(1|joke_id)+(1|rater_id), jdat_use, REML = F)
summary(m5)
# Then we compare the models to get a joint test of all the coefficients being 0.
anova(m4, m5)
# This is not significant
# Note that we fitted the models with REML = F, which we need to compare models with different fixed effects. 
