# Exercises 1
# -------------------------------------------------------
# Read the data and store it in a dataframe called xc1
xc1 = read.csv("https://raw.githubusercontent.com/espenmei/PSY9185/main/datasets/xc1.dat")

# Look at the dataframe
head(xc1)

# 1.1 - How many students, primary schools and secondary schools are in the data? (hint: `length(unique(xc1$pid))`)
# A student is represented by a row so we can just count the number of rows to get the number of students
nrow(xc1)
# We can find the number of unique primary school ids like this - count the number of unique values
length(unique(xc1$pid))
# We can find the number of unique secondary school ids like this - count the number of unique values
length(unique(xc1$sid))

# 1.2 - Cross-tabulate the grouping factors primary and secondary school. What does the table show us? (hint: `xtabs(~pid + sid, xc1)`)
xtabs(~pid + sid, xc1)
# By cross-tabulating primary and secondary school we get the number of students for each combination of primary and secondary school.
# Primary schools are down the rows and secondary schools across the columns.
# We see that most secondary schools have students from several primary schools (look down columns), and many primary schools have students
# going to different secondary schools (look across rows).

# We could also get a sparse table that's easier to look at withe the argument sparse = T
xtabs(~pid + sid, xc1, sparse = T)
# This can also produce a informative figure
library(Matrix)
image(xtabs(~pid + sid, xc1, sparse = T))
# The figure gives a visual representation of the table, where the zero cells are white.

# 1.3 - Can we determine from the table if primary and secondary school are partially or fully crossed?
# Yes. If these were fully crossed, all primary schools would have students in all secondary schools, and all secondary schools would have students from all primary schools.
# There would be no positions in the table with zeros. Primary and secondary school is therefore partially crossed.

# Exercises 2
# -------------------------------------------------------
library(lme4)

# 2.1 - Fit a model for educational attainment with fixed a intercept and random intercepts for secondary school
# We can fit this like other multilevel models with lmer()
fit21 = lmer(attain ~ 1 + (1|sid), xc1)
# This says that we model attainment as a function of a fixed/population intercept and a random intercept for each secondary school.
#
# - Interpret the parameters of the model
summary(fit21)
# The fixed intercept is the average test score across schools.
# The random effect of secondary school is the variance in test scores due to differences between secondary schools.
# The residual variance is the variance in test scores due to differences between students within the same school.
#
# - Try to interpret what these "random school effects" represent
# The random effects may be interpreted as representing the total effect of unobserved characteristics of different schools.
# Schools may differ in several aspects, such as teaching practices and resources, which may impact the average exam results.
# In education research, these school effects are sometimes referred to as "value-added" as they provide estimates
# of the influence schools have on the average student performance.

# 2.2 - Extend the model to have random intercepts for both primary and secondary school
fit22 = lmer(attain ~ 1 + (1|sid) + (1|pid), xc1)

# - Interpret the parameters of the model
summary(fit22)
# The fixed intercept is the average test score across schools.
# The random effect of primary school is the variance in test scores due to differences between primary schools.
# The random effect of secondary school is the variance in test scores between due to differences between secondary schools.
# The residual variance is the variance in test scores due to differences between students belonging to the same combination of primary and secondary school. 
#
# - Does primary or secondary school appear to be most important for attainment?
# More variance is attributable to primary school than secondary school. Therefore differences between primary schools appear to have
# greater effects on attainment scores even at age 16.
# Therefore, there seem to be some long lasting ("carry-over") effect of differences in primary school.
# Secondary schools are usually larger than primary schools, and may be more similar to each other than primary schools are - therefore explain less variability.


# Exercises 3
# -------------------------------------------------------
# 3.1 - Compute the intraclass correlation for students from the same primary but different secondary school
# As we saw in the slides, the intraclass correlation is equal to the variance of the primary school intercepts divided by the total variance
# We can compute this by hand from the output
summary(fit22)
1.13 / (1.13 + 0.37 + 8.11)
# Or, assign the results to a dataframe and reference that
vc22 = as.data.frame(VarCorr(fit22))
vc22$vcov[1] / sum(vc22$vcov)

# 3.2 - Compute the intraclass correlation for students from the same secondary school but different primary school
# the intraclass correlation is equal to the variance of the secondary school intercepts divided by the total variance
0.37 / (1.13 + 0.37 + 8.11)

# 3.3 - Compute the intraclass correlation for students from the same primary and secondary school
# the intraclass correlation is equal to the variance of the primary school intercepts and the variance secondary school intercepts divided by the total variance
(1.13 + 0.37) / (1.13 + 0.37 + 8.11)

# Exercises 4
# -------------------------------------------------------
# 4.1
xc1$pid_sid = paste(xc1$pid, xc1$sid, sep = "_")
length(unique(xc1$pid_sid))
mean(table(xc1$pid_sid))
sd(table(xc1$pid_sid))

# 4.2
fit42 = lmer(attain ~ 1 + (1|pid) + (1|sid) + (1|pid_sid), xc1)
summary(fit42)
# For any given combination of primary and secondary school, We cannot just add up the effects of those primary and secondary schools,
# because there is some effect due to the unique combination of those.
# The estimated variance for the interaction is 0.23. This number reflects any interactions between primary and secondary schools
# (deviations of the means for the combinations of primary and secondary schools from the means implied by the additive effects)
# Residuals is the variability within the groups of children belonging to the same combination of primary and secondary school.

# 4.3
anova(fit22, fit42)
# Tests the null hypothesis that the variance component for the random interaction is zero, against the one-sided alternative that it is greater than 0.
# Note that the sampling distribution assumed under the null is wrong, and the p-value is too big. Can be divided by 2.
# This is Not significant and we can drop the interaction effect from the model.