# Krupa gurav
# 24102C2005
# BE CMPN C
# Week 04





# Create a 4x3 matrix with numbers 1 to 12
x <- matrix(nrow = 4, ncol = 3, data = 1:12)
print(x)

# Create a 4x2 matrix where every element is 2
x <- matrix(nrow = 4, ncol = 2, data = 2)
print(x)

# Assign row names
rownames(x) <- c("r1", "r2", "r3", "r4")

# Assign column names
colnames(x) <- c("c1", "c2", "c3")


# Create a 3x3 identity matrix
d <- diag(1, nrow = 3, ncol = 3)
print(d)


# Create a diagonal matrix with 5 on the diagonal
d <- diag(5, nrow = 3, ncol = 3)
print(d)

# Create matrix row-wise
x <- matrix(nrow = 4, ncol = 2, data = 1:8, byrow = TRUE)

# Transpose the matrix
xt <- t(x)

# Display transpose
xt

# Create matrix
x <- matrix(nrow = 4, ncol = 2, data = c(1,2,3,4,5,6,7,8))
# Sum of each row
rowSums(x)
# Sum of each column
colSums(x)

# Create matrix
x <- matrix(nrow = 4, ncol = 2, data = c(1,2,3,4,5,6,7,8))
# Mean of each row
rowMeans(x)
# Mean of each column
colMeans(x)

# Create a 5x3 matrix row-wise
x <- matrix(nrow = 5, ncol = 3, byrow = TRUE, data = 1:15)
# Access 3rd row
x[3, ]
# Access 2nd column
x[, 2]
# Access rows 4 and 5, columns 2 and 3
x[4:5, 2:3]
# Access specific rows and columns
x[c(1,4), c(1,3)]


# Create matrix
x <- matrix(nrow = 4, ncol = 2, data = 1:8, byrow = TRUE)
# Add 5 to every element
x + 5
# Subtract 5 from every element
x - 5
# Multiply every element by 5
5 * x# Divide every element by 2
x / 2


# Create first matrix
x <- matrix(nrow = 4, ncol = 2, data = 1:8, byrow = TRUE)
# Create second matrix
y <- matrix(nrow = 4, ncol = 2, data = 11:18, byrow = TRUE)
# Matrix addition
x + y
# Matrix subtraction
x - y



# Create matrices
x <- matrix(nrow = 3, ncol = 2, data = 1:6, byrow = TRUE)
y <- matrix(nrow = 3, ncol = 2, data = 11:16, byrow = TRUE)
# Combine row-wise
rbind(x, y)
# Combine column-wise
cbind(x, y)

# Create a square matrix
y <- matrix(c(84,100,100,120), nrow = 2, byrow = TRUE)
# Find inverse
solve(y)


# Find eigenvalues and eigenvectors
eigen(y)
# Greater than
5 > 2
# Greater than or equal
5 >= 5
# Less than
3 < 7
# Less than or equal
3 <= 3
# Equal
5 == 5
# Not equal
5 != 3


x <- 8
# Logical OR (checks first element only for ||)
(x < 10) || (x < 2)
x <- c(8,18)
# Element-wise OR
(x < 10) | (x < 2)
# First element only
(x < 10) || (x < 2)


x <- 5
# Logical AND
(x < 10) && (x > 2)
x <- c(8,18)
# Element-wise AND
(x < 10) & (x > 2)
# First element only
(x < 10) && (x > 2)


x <- 1:6
# Values greater than 2 and less than 5
x[(x > 2) & (x < 5)]
# Values greater than 2 or less than 5
x[(x > 2) | (x < 5)]


x <- TRUE
y <- FALSE
# AND
x & y
# OR
x | y
# NOT
!x


# Exclusive OR
xor(TRUE, FALSE)
# Check if TRUE
isTRUE(TRUE)
# Check if FALSE
isFALSE(FALSE)
# Check data type
Logical1 <- (5 > 2)
is.logical(Logical1)