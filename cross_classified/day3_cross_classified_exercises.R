# Exercises 1
# -------------------------------------------------------
# Read the data and store it in a dataframe called xc1
xc1 = read.csv("https://raw.githubusercontent.com/espenmei/PSY9185/main/datasets/xc1.dat")
# The data comes from the MLwiN program and consist of test scores from students at age 16. Each row represents a student
# attain - educational attainment score
# pid - primary school identifier
# sid - secondary school identifier

# 1.1 - How many students, primary schools and secondary schools are in the data? (hint: unique(), length())

# 1.2 - Cross-tabulate the grouping factors primary and secondary school. What does the table show us? (hint: `table(F1, F2)`)

# Exercises 2
# -------------------------------------------------------
library(lme4)
# 2.1 - Fit a model for educational attainment with a fixed intercept and random intercepts for both primary and secondary school

# 2.2 - Does primary or secondary school appear to be most important for attainment?

# Exercises 3
# -------------------------------------------------------
# 3.1 - Compute the intraclass correlation for students from the same primary but different secondary school

# 3.2 - Compute the intraclass correlation for students from the same secondary school but different primary school

# 3.3 - Compute the intraclass correlation for students from the same primary and secondary school