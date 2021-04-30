# Exercises 1
# -------------------------------------------------------
# Read the data and store it in a dataframe called xc1
xc1 = read.csv("https://raw.githubusercontent.com/espenmei/PSY9185/main/datasets/xc1.dat")
head(xc1)

# 1.1 - How many students, primary schools and secondary schools are in the data? (hint: unique(), length())
# A student is represented by a row so we can just count the number of rows to get the number of students
nrow(xc1)
# We can find the number of unique primary school ids like this - count the number of unique values
x = unique(xc1$pid)
length(x)
# We can find the number of unique secondary school ids like this - count the number of unique values
length(unique(xc1$sid))

# 1.2 - Cross-tabulate the grouping factors primary and secondary school. What does the table show us? (hint: `table(F1, F2)`)
# We can use the table() function to cross-tabulate these factors
table(xc1$pid, xc1$sid)
# By cross-tabulating primary and secondary school we get the number of students for each combination of primary and secondary school.
# Primary schools are down the rows and secondary schools across the columns.
# We see that most secondary schools have students from several primary schools, and many primary schools have students
# going to different secondary schools.
# We also see that many cells are empty, so these factors are not fully crossed.

# We could also get a sparse table that's easier to look at using xtabs()
xtabs(~pid + sid, xc1, sparse = T)
# This can also produce a informative figure
library(Matrix)
image(xtabs(~pid + sid, xc1, sparse = T))
# The figure gives a visual representation of the table, where the zero cells are white.

# Exercises 2
# -------------------------------------------------------
library(lme4)

# 2.1 - Fit a model for educational attainment with fixed a intercept and random intercepts for both primary and secondary school
# We can fit this like other multilevel models with lmer()
fit21 = lmer(attain ~ 1 + (1|pid) + (1|sid), xc1)
# This says that we model attainment as a function of a fixed/population intercept, a random intercept for each
# primary school and a random intercept for each secondary school
# And we can look at the results with the summary() function
summary(fit21)

# 2.2 - Does primary or secondary school appear to be most important for attainment?
summary(fit21)
# More variance in attainment scores is attributable to primary school than secondary school. Therefore primary schools appear to have
# greater effects on attainment scores

# Exercises 3
# -------------------------------------------------------
# 3.1 - Compute the intraclass correlation for students from the same primary but different secondary school
# As we saw in the slides, the intraclass correlation is equal to the variance of the primary school intercepts divided by the total variance
# We can compute this by hand from the output
summary(fit21)
1.13 / (1.13 + 0.37 + 8.11)
# Or, assign the results to a dataframe and reference that
vc21 = as.data.frame(VarCorr(fit21))
vc21$vcov[1] / sum(vc21$vcov)

# 3.2 - Compute the intraclass correlation for students from the same secondary school but different primary school
# the intraclass correlation is equal to the variance of the secondary school intercepts divided by the total variance
0.37 / (1.3 + 0.37 + 8.11)
vc21$vcov[2] / sum(vc21$vcov)

# 3.3 - Compute the intraclass correlation for students from the same primary and secondary school
# the intraclass correlation is equal to the variance of the primary school intercepts and the variance secondary school intercepts divided by the total variance
(1.13 + 0.37) / (1.3 + 0.37 + 8.11)
sum(vc21$vcov[1:2]) / sum(vc21$vcov)