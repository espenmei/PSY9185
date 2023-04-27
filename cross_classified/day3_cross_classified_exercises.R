# Exercises 1
# -------------------------------------------------------
# Read the data and store it in a dataframe called xc1
xc1 = read.csv("https://raw.githubusercontent.com/espenmei/PSY9185/main/datasets/xc1.dat")
# The data comes from the MLwiN program and consist of test scores from students at age 16. Each row represents a student
# attain - educational attainment score
# pid - primary school identifier (age 5 - 12)
# sid - secondary school identifier (age 12 - 16)

# 1.1 - How many students, primary schools and secondary schools are in the data? (hint: unique(), length())

# 1.2 - Cross-tabulate the grouping factors primary and secondary school. What does the table show us? (hint: `table(F1, F2)`)

# 1.3 - Can we determine from the table if primary and secondary school are partially or fully crossed?

# Exercises 2
# -------------------------------------------------------
library(lme4)
# 2.1 - Fit a model for educational attainment with a fixed intercept and random intercepts for secondary school
# Interpret the parameters of the model
# Try to interpret what these "random school effects" represent

# 2.2 - Extend the model to have random intercepts for both primary and secondary school
# Interpret the parameters of the model
# Does primary or secondary school appear to be most important for attainment?
# Did the variance due to secondary school effects change from the previous model? If so, why could that be?

# Exercises 3
# -------------------------------------------------------
# 3.1 - Compute the intraclass correlation for students from the same primary but different secondary school

# 3.2 - Compute the intraclass correlation for students from the same secondary school but different primary school

# 3.3 - Compute the intraclass correlation for students from the same primary and secondary school

# Exercises 4
# -------------------------------------------------------
# 4.1 - Make a new variable pid_sid that codes the combination of primary and secondary school for each student
# How many levels does this variable have?
# How many students are there in average for each combination of primary and secondary school?
# What is the standard deviation?

# 4.2 - Expand the main effects model from previous exercises to include interaction between primary and secondary school

# 4.3 - Perform a likelihood ratio test to evaluate the null-hypothesis that there is no interaction
