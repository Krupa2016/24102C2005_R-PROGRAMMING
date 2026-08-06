# Krupa gurav
# 24102C2005
# BE CMPN C
# Week 03: 
# A. Calculations with Data Vectors : Addition, Subtraction, Multiplication , Division , Power operations, Integer and Modulo divisions
# B. Built in Functions and Assignments
# c.  Matrices



# Addition
vector <- c(2, 3, 4, 5) + c(10, 11, 12, 13)
print(vector)

# Subtraction
vector <- c(2, 3, 4, 5) - c(10, 11, 12, 13)
print(vector)

# Multiplication
vector <- c(2, 3, 4, 5) * c(10, 11, 12, 13)
print(vector)

# Division
vector <- c(2, 3, 4, 5) / c(10, 11, 12, 13)
print(vector)

# Power operations
vector <- c(2, 3, 4, 5) ^ c(10, 11, 12, 13)
print(vector)

# Integer Division
vector <- c(2, 3, 4, 5) %/% c(10, 11, 12, 13)
print(vector)

# Modulo Division
vector <- c(2, 3, 4, 5) %% c(10, 11, 12, 13)
print(vector)




# B. Built in Functions and Assignments
max(1.2, 3.4, -7.8)

min(1.2, 3.4, -7.8)

mean(2, 3, 4)

abs(c(-1, -2, -3, 4, 5))

sqrt(4)

sum(c(2, 3, 5, 7))

prod(c(2, 3, 5, 7))

round(1.23)

log(c(10, 100, 1000))




# C. Matrices
# Example of column-wise filling
x <- matrix(data = 1:8, nrow = 4, ncol = 2)
print(x)

# Example of row-wise filling
y <- matrix(data = 1:8, nrow = 4, ncol = 2, byrow = TRUE)
print(y)

# Using the matrix x (column-wise filled) from the previous example
element_value <- x[3, 2]
print(element_value)

# dimensions
dimensions <- dim(x)
print(dimensions)

num_rows <- nrow(x)
print(num_rows)

num_cols <- ncol(x)
print(num_cols)

data_mode <- mode(x)
print(data_mode)

matrix_attributes <- attributes(x)
print(matrix_attributes)