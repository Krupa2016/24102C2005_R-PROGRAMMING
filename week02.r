# Krupa gurav
# 24102C2005
# BE CMPN C
# Week 02: 
# A. Basic Operations in R
# B. R as a Calculator with Scalars and Data Vectors : Addition, Subtraction, Multiplication & Division




# A. Basic Operations in R

# assigning values to variables
x <- 20
y = "apple"

# Identifying Data Types
is.numeric(x) # Returns TRUE
is.character(y) # Returns TRUE

# Converting Data Types
z = as.numeric(y)

# Handling Infinite Values 
result = 3 / 0 # result becomes Inf
is.finite(result) # Returns FALSE
is.infinite(result) # Returns TRUE
x = 5 + Inf # x becomes Inf
is.finite(x) # Returns FALSE
is.infinite(x) # Returns TRUE









# B. R as a Calculator with Scalars and Data Vectors : Addition, Subtraction, Multiplication & Division

# 1. With Scalars
x<- 10
y<- 5

# Addition
add<- x+y
print(add)

# Subtraction
sub<- x-y
print(sub)

# Multiplication
mul<- x*y
print(mul)

# Division
div<- x/y
print(div)




# 2. With Data Vectors
my_vector <- c(2, 3, 5, 7)

# Addition
add_vector <- my_vector + 2
print(add_vector)

# Subtraction
sub_vector <- my_vector - 1
print(sub_vector)

# Multiplication
mul_vector <- my_vector * 3
print(mul_vector)

# Division
div_vector <- my_vector / 2
print(div_vector)