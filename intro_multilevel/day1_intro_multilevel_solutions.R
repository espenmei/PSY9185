# Exercises 1
# -------------------------------------------------------
# Read the data and store it in a dataframe called Cassidy
Cassidy = read.csv("http://www.mlminr.com/data-sets/Cassady.csv?attredirects=0")

# 1.1 Compute the variance of GPA (hint: var())
# This does not work because of missing values (represented by NA in R)
var(Cassidy$GPA)
# We can check explicitly how many NA is in the data vector
sum(is.na(Cassidy$GPA))
# Note that R often require you to be explicit about how to handle missing
# With missing values you can often use the argument na.rm = T
var(Cassidy$GPA, na.rm = T)

# 1.2 Fit a linear regression model with GPA as dependent variable and anxiety as explanatory variable. Interpret the coefficients
# (hint: lm())
# Fit a regression model with lm() and save the results to fit1
fit1 = lm(GPA ~ CTA.tot, data = Cassidy)
# Then the results can be inspected like this
summary(fit1)
# The expected GPA value when anxiety is zero is 3.6, the expected GPA value decreases by -.014 per unit increase in anxiety

# 1.3 What is the estimated residual variance from the regression model? Compare it to the variance you computed before in 1. Why are they different? What is going on? (hint: hist(Cassidy$GPA)))
# We can get the residual variance by squaring the residual sd from the output
summary(fit1)
# Or like this
sigma(fit1)^2
# If we compare it to the variance it is MUCH smaller
var(Cassidy$GPA, na.rm = T)
# Why is this?
#First we did not use the same observations. 19 observations had missing values on GPA, but 46 had missing values on GPA and anxiety
sum(is.na(Cassidy$GPA))
summary(fit1)
# But lets look a bit more on the data
hist(Cassidy$GPA)
# There is an extreme outlier here. Was the outlier included in the regression?
# Pick out the data that was includes in the regression
Cassidy_filter = na.omit(Cassidy[, c("GPA", "CTA.tot")])
hist(Cassidy_filter$GPA)
# We see that the outlier is not there. So this is probably the reason for the big difference
# Ii is good practice to inspect the data before trying to answer substantive questions

# lets try to use the same observations when computing the variance as in the regression model
var(Cassidy_filter$GPA)
# Now they are much closer
# Now we can compare again
sigma(fit1)^2
# The residual variance is smaller because part of the variation in GPA has been explained by CTA.tot

# Exercises 2
# -------------------------------------------------------
library(tidyverse)

Achieve = read.csv("http://www.mlminr.com/data-sets/Achieve.csv?attredirects=0")

# Some student are repeated in the dataset. For the exercises we just remove these individuals
# This can be done with functions from "tidyverse" that does operations on the dataframe per group
Achieve = Achieve %>%
  group_by(id) %>%
  filter(n() == 1) %>%
  ungroup()

# 2.1 How many schools are in the data set? (hint: unique(), length())
unique_school = unique(Achieve$school) # Gives the unique school ids
length(unique_school) # Gives the number of unique school ids

# 2.2 How many students does each school have on average? What is the standard deviation?
# First we summarize number of students per school and save the results in a dataframe called Achieve_school
Achieve_school = Achieve %>%
  group_by(school) %>%
  summarise(n = n()) %>%
  ungroup()
# Then we can compute the mean and standard deviation
mean(Achieve_school$n)
sd(Achieve_school$n)

# 2.3 Run the code for exercise 2.3. What does it show?
# The following code computes the average and standard deviation of reading scores per school
Achieve_school_read = Achieve %>%
  group_by(school) %>%
  summarise(geread_mean = mean(geread),
            geread_sd = sd(geread)) %>%
  ungroup()
# Then we make a figure
ggplot(Achieve_school_read, aes(x = factor(school), y = geread_mean)) +
  geom_point() +
  geom_pointrange(aes(ymin = geread_mean - geread_sd,
                      ymax = geread_mean + geread_sd)) +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank())
# The figure plots schools along the x-axis and average reading score per school on the y-axis (the black dots)
# The vertical lines show the standard deviation per school above and below the average
# The figure shows us that there are differences in the average reading scores between schools (the dots),
# and there is variability in reading scores within schools (the vertical lines)

# Exercises 3
# -------------------------------------------------------
library(lme4)

# 3.1 - Fit a multilevel model for the reading scores with only an intercept term and random intercepts for schools. Interpret the results (hint: ?lmer)
# Here we specify that reading scores is a function of a fixed intercept and a random intercept that varies over schools
fit31 = lmer(geread ~ 1 + (1|school), data = Achieve)
# We can the look at the output
summary(fit31)
# The average score is 4.3
# The variance in reading scores due to differences between schools is 0.39
# The variance in reading scores due to differences within schools is 5.04

# 3.2 - Compute the intraclass correlation for students from the same school. Are differences between schools important for differences between student's reading scores?
# We can compute this from the output
summary(fit31)
0.39 / (0.39 + 5.04)
# Or like this
vc31 = as.data.frame(VarCorr(fit31))
vc31$vcov[1] / sum(vc31$vcov)
# The correlation in reading scores between students from the same school is low, because the variability between schools
# is low compared to the variability within schools. Therefore differences between schools does not appear
# very important for explaining differences in reading scores between students

# 3.3 Include gevocab as an explanatory variable in the model. Interpret the results. Compare the school and residual variance to the "unconditional" model in 1
# We do this just as with the lm() function. We don't have to explicitly include the intercept now because ti is assumed that we want it
fit32 = lmer(geread ~ 1 + gevocab + (1|school), data = Achieve)
summary(fit32)
# The expected reading score when vocabulary score is zero is 2.02
# When vocabulary scores increases by one point, the expected increase in reading scores in 0.51 points.
# After accounting for vocabulary scores, the variance in reading scores between schools in 0.09 and the variance within schools is 3.67 (variance around the school specific regression line).
# Compared to the previous model without the covariate, both the within and between school variance has decreased.
# Why is that? We can consider vocabulary scores as a level-1 covariate as it is measured on students.
# However, level-1 covariates can vary also at level-2, both within and between schools.
# Vocabulary scores appear to explain variability at both levels.

anova(fit31, fit32)

# Exercises 4
# -------------------------------------------------------
# 4.1 - Expand the last model from the previous exercise to allow for random slopes of gevocab over schools. How did that work? (hint: lmer())
fit41 = lmer(geread ~ 1 + gevocab + (1 + gevocab|school), data = Achieve)
summary(fit41)
# The estimation did not converge. At least not on my computer. Therefore we should not trust the results.
# But why did it not work?
# With random slope models, the total residual variance is not constant, and depends on the values of the covariate.
# At some points the intercept variance and correlation with the slope can become very large or small.
# It is therefore generally a good idea to center covariates around their average.

# 4.2 - Repeat the exercise above but center the vocabulary scores around the grand mean. Interpret the results (hint: x_center = x - mean(x))
Achieve$gevocab_c = Achieve$gevocab - mean(Achieve$gevocab)
fit42 = lmer(geread ~ 1 + gevocab_c + ( 1 + gevocab_c|school), data = Achieve)
summary(fit42)
# The fixed effects are the population or average intercept and slope. Which is 4.34 and 0.52.
# This model has two more random effect parameters. The random slope variance and the correlation between the random intercepts and slopes.
# The variance in the intercepts (at the mean level of vocabulary scores) between schools is 0.10.
# The variance in the slopes between schools is 0.02. It can be easier to look at the standard deviation, which is 0.14.
# We see that since the mean slope is 0.52 in the population about 95% of schools will have slopes within
# 0.52 - 2 * 0.14 = 0.24 to 0.52 + 2 * 0.14 = 0.80 (since we assume they are normally distributed).
# So almost all schools will have a positive slope, but some more than others.
# Lastly, the correlation between intercepts and slopes is 0.52. Schools with larger average reading scores (for
# students with average vocabulary scores) also tend to have larger slopes.
# Further interpretation requires domain knowledge.

# 4.3 - Perform a likelihood ratio test of whether the random slope is needed in addition to the random intercept (hint: anova(fit1, fit2))
anova(fit32, fit42)
# The test is significant, meaning that the null hypothesis of zero slope variance is rejected.

# lmer minimizes the 2 x negative log likelihood (deviance in output), which we want as low as possible
# Therefore we want the highest value of log likelihood (closest to positive infinity). Lowest (closest to negative infinity value of deviance, AIC and BIC)

# Exercises 5
# -------------------------------------------------------
# 5.1 - The class identifier only identifies unique classes within schools. Recode the class identifier so that it takes unique values also across schools (hint: paste0())
Achieve$class_school = paste0(Achieve$class, "_", Achieve$school)
# It is better to be explicit about the nesting than relying on lmer() fixing it. Easy to forget.
# And not always easy to see with big datasets

# 5.2 - Fit an «unconditional» 3-level model for the reading scores with random intercepts for classes nested in schools. Interpret the results
# When the nesting has been explicitly defined, it is straight forward to specify a 3-level model
# Just specify the grouping factors
fit51 = lmer(geread ~ 1 + (1|class_school) + (1|school), Achieve)
summary(fit51)
# The average reading score is 4.3. The between school variance is 0.31 and the between class-within school
# variance is 0.27.

# 5.3 - Compute the intraclass correlation for children from the same schools but different classes. Compute the intraclass correlation for children from the same schools and same classes
# We can get the numbers from the output
summary(fit51)
# The intraclass correlation for children from the same school and different classes is
0.3115 / (0.3115 + 0.2703 + 4.8505)
# The intraclass correlation for children from the same school and same classes is
(0.3115 + 0.2703) / (0.3115 + 0.2703 + 4.8505)
# Alternatively we could could compute by reference to variables
vc51 = as.data.frame(VarCorr(fit51))
vc51$vcov[2] / sum(vc51$vcov)
sum(vc51$vcov[1:2]) / sum(vc51$vcov)

# Exercises 6
# -------------------------------------------------------
# 6.1 - Include senroll as a covariate for the random school intercepts. Interpret the results
# It is better to first rescale the variables a bit so that it doesn't take very large numbers (and therefore small coefficients)
Achieve$senroll_s = Achieve$senroll / 100
# We now measure numbers of students in hundreds
fit61 = lmer(geread ~ gevocab_c + senroll_s + (1+gevocab_c|school), data = Achieve)
summary(fit61)
# There is practically no differences in average reading scores comparing schools that differ with 100 students

# 6.2 - Include senroll as a covariate for the random school intercepts and slopes. Interpret the results
fit62 = lmer(geread ~ gevocab_c + senroll_s + gevocab_c:senroll_s + (1+gevocab_c|school), data = Achieve)
summary(fit62)
# # There is practically no differences in the slopes of vocabulary scores comparing schools that differ with 100 students