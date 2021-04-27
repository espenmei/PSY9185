# uncomment and run these lines to install packages
# install.packages("tidyverse")
# install.packages("lme4")

# Exercises 1
# -------------------------------------------------------
# Read the data and store it in a dataframe called Cassidy
Cassidy = read.csv("http://www.mlminr.com/data-sets/Cassady.csv?attredirects=0")

# 1.1 Compute the variance of GPA (hint: var())
# --- put your code here ---

# 1.2 Fit a linear regression model with GPA as dependent variable and anxiety as explanatory variable. Interpret the coefficients (hint: lm())

# 1.3 What is the estimated residual variance from the regression model? Compare it to the variance you computed before in 1. Why are they different? What is going on? (hint: hist(Cassidy$GPA)))

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

# 2.2 How many students does each school have on average? What is the standard deviation?
# First we summarize number of students per school and save the results in a dataframe called Achieve_school
Achieve_school = Achieve %>%
  group_by(school) %>%
  summarise(n = n()) %>%
  ungroup()

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

# Exercises 3
# -------------------------------------------------------
library(lme4)

# 3.1 - Fit a multilevel model for the reading scores with only an intercept term and random intercepts for schools. Interpret the results (hint: ?lmer)

# 3.2 - Compute the intraclass correlation for students from the same school. Are differences between schools important for differences between student's reading scores?

# 3.3 Include gevocab as an explanatory variable in the model. Interpret the results. Compare the school and residual variance to the "unconditional" model in 1

# Exercises 4
# -------------------------------------------------------
# 4.1 - Expand the last model from the previous exercise to allow for random slopes of gevocab over schools. How did that work? (hint: lmer())

# 4.2 - Repeat the exercise above but center the vocabulary scores around the grand mean. Interpret the results (hint: x_center = x - mean(x))

# 4.3 - Perform a likelihood ratio test of whether the random slope is needed in addition to the random intercept (hint: anova(fit1, fit2))

# Exercises 5
# -------------------------------------------------------
# 5.1 - The class identifier only identifies unique classes within schools. Recode the class identifier so that it takes unique values also across schools (hint: paste0())

# 5.2 - Fit an «unconditional» 3-level model for the reading scores with random intercepts for classes nested in schools. Interpret the results

# 5.3 - Compute the intraclass correlation for children from the same schools but different classes. Compute the intraclass correlation for children from the same schools and same classes

# Exercises 6
# -------------------------------------------------------
# 6.1 - Include senroll as a covariate for the random school intercepts. Interpret the results
# It is better to first rescale the variables a bit so that it doesn't take very large numbers (and therefore small coefficients)
Achieve$senroll_s = Achieve$senroll / 100

# 6.2 - Include senroll as a covariate for the random school intercepts and slopes. Interpret the results