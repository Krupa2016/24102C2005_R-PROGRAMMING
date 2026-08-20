# Krupa gurav
# 24102C2005
# BE CMPN C
# Week 05



# Detect Missing Values 
data_vector <- c(11, NA, 13, NA)
is.na(data_vector)

# Mean Without Handling NA
data_vector <- c(11, NA, 13, NA)
mean(data_vector)

# Mean With na.rm = TRUE
data_vector <- c(11, NA, 13, NA)
mean(data_vector, na.rm = TRUE)
tf <- import("tensorflow")

# 4. Find Positions of Missing Values — which(is.na())
data_vector <- c(11, NA, 13, NA)
which(is.na(data_vector))

# 5. Count Missing Values — sum(is.na())
data_vector <- c(11, NA, 13, NA)
sum(is.na(data_vector))

# 6. Check Complete Cases — complete.cases()
data_vector <- c(11, NA, 13, NA)
complete.cases(data_vector)

# 7. Remove Missing Values — na.omit()
data_vector <- c(11, NA, 13, NA)
cleaned_vector <- na.omit(data_vector)
print(cleaned_vector)


# Conditional Statements
# 8. Simple if
x <- 5
if (x > 4) {
  x <- x * 3
}
print(x)

# 9. if-else
x <- 5
if (x == 3) {
  x <- x - 1
} else {
  x <- 2 * x
}
print(x)


# 10. Nested if-else / else if
x <- 5
if (x == 3) {
  x = x - 1
} else if (x < 3) {
  x = x + 5
} else {
  x = 2 * x
}
print(x)


# 11. ifelse() Function
x <- 1:10
result <- ifelse(x < 6, x^2, x + 1)
print(result)


# 12. Even/Odd Using ifelse() and %%
numbers <- c(7, 9, 8, 4)
parity_check <- ifelse(
  numbers %% 2 == 0,
  "even number",
  "odd number"
)
print(parity_check)



# 13. switch() With Integer
switch(2, "apple", "banana", "orange")

# 14. switch() With Character
switch(
  "colour",
  colour = "blue",
  gender = "male",
  volume = 50
)


 
# 15. which() — Find Positions
x <- c(10, 15, 8, 14, 6, 12)
which(x > 10)


# 16. which() With Matrix — arr.ind = TRUE
x_matrix <- matrix(1:9, nrow = 3, byrow = TRUE)
which(x_matrix %% 2 == 1, arr.ind = TRUE)


# 17. which.min() and which.max()
which.min(x)
which.max(x)