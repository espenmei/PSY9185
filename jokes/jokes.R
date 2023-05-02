rm(list = ls())

library(tidyverse)
library(lme4)

jdat = read.table("https://raw.githubusercontent.com/espenmei/PSY9185/main/jokes/jokes.dat", header = T, sep = "\t")

# Focus on Joke scores for now
jdat = jdat[!is.na(jdat$Joke), ]

length(unique(jdat$joke_id))
length(unique(jdat$rater_id))

xtabs(~joke_id + rater_id, jdat)

image(xtabs(~joke_id + rater_id, jdat, sparse = T))

# 1
m1 = lm(Joke~1, jdat)
summary(m1)
# The average rating across jokes and raters is b0. And the variance in ratings
# across jokes and raters is
sigma(m1)^2

# 2 joke effect
# Some of this variance may be because some jokes are more funny than others
m2 = lmer(Joke~1+(1|joke_id), jdat)
summary(m2)
# The variance in ratings because jokes are different is
# Some of the residual variance is probably due to differences between raters

# 3
m3 = lmer(Joke~1+(1|joke_id)+(1|rater_id), jdat)
summary(m3)
# The variance in ratings because jokes are different is
# The variance in ratings because raters are different is
# 
# The joke effect says something about how much variability there is in how funny jokes are, independent of who rates the joke
# The rater effect says something about how much variability there is between raters in how funny they think jokes are, independent of which joke it is
# Some variance is still left due to different raters preferring different jokes (interaction), and other stuff such as measurement error

# If there is variability between jokes, I should think about which joke i tell.
# If there is variability between raters, I should think about who I tell it to.
# We find both

# We can look at the joke effects
re = ranef(m3)
re_joke = re$joke_id[, 1]
which.max(re_joke)
plot(sort(re_joke), main = "Joke effect", ylab = "Deviation", pch = 18, col = "blue")
text(sort(re_joke), labels = order(re_joke), cex=1.0, pos=2, col="red")

# And the rater effects
re_rater = re$rater_id[, 1]
plot(sort(re_rater), main = "Rater effect", ylab = "Deviation", pch = 18, col = "blue")
text(sort(re_rater), labels = order(re_rater), cex=1.0, pos=2, col="red")
