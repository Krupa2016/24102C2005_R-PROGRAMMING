# ============================================================
# Krupa Gurav
# 24102C2005
# FOUNDATIONS OF R SOFTWARE - WEEK 12

# Topics:
# 1. Subdivided / Component Bar Plot
# 2. Pie Diagram
# 3. Combining Graphics
# 4. Histogram
# 5. Bivariate Scatter Plot
# 6. Matrix Scatter Plot
# 7. Scatter Plot with Smooth Curve
# 8. 3D Scatter Plot
# 9. Other Graphics Functions
# 10. Writing R Programs
# 11. User Defined Functions
# 12. Functions with Loops
# 13. Functions with if / else if / else
# ============================================================


# ============================================================
# LECTURE 50
# SUBDIVIDED / COMPONENT BAR DIAGRAM
# ============================================================

# Data:
# Number of customers visiting 3 shops during 10-11 AM
# on 4 consecutive days

cust <- matrix(
  nrow = 4,
  ncol = 3,
  data = c(
    2, 20, 30,
    26, 53, 40,
    42, 15, 25,
    30, 75, 100
  ),
  byrow = TRUE
)

# Display matrix
cust


# Basic subdivided bar plot
barplot(cust)


# ============================================================
# ADDING LABELS AND COLOURS
# ============================================================

barplot(
  cust,
  names.arg = c("Shop 1", "Shop 2", "Shop 3"),
  xlab = "Shops",
  ylab = "Days",
  col = c("red", "green", "orange", "brown")
)


# ============================================================
# PIE DIAGRAM
# ============================================================

# Gender data:
# 1 = Male
# 2 = Female

gender <- c(
  1, 2, 1, 2, 1,
  1, 1, 2, 1, 1
)

# Display data
gender


# Basic pie chart
pie(gender)


# ============================================================
# PIE CHART USING TABLE
# ============================================================

pie(table(gender))


# ============================================================
# DIRECTIONS OF FOOD DELIVERY
# ============================================================

# 1 = East
# 2 = West
# 3 = Central

direction <- c(
  1,1,2,1,2,3,2,2,3,3,
  3,1,2,3,2,2,3,1,1,3,
  3,1,2,1,3,3,3,2,2,2,
  2,1,2,2,1,1,1,3,2,2,
  1,2,3,2,2,1,2,3,3,2,
  1,2,2,3,1,1,2,1,2,3,
  2,3,2,2,3,1,2,3,3,3,
  2,1,1,1,2,1,1,2,1,2,
  3,3,1,2,3,3,2,1,2,3,
  2,1,3,2,2,2,2,3,2,2
)

# Basic pie chart
pie(table(direction))


# ============================================================
# PIE CHART WITH COLOURS AND TITLE
# ============================================================

pie(
  table(direction),
  col = c("red", "green", "blue"),
  main = "Directions of food delivery"
)


# ============================================================
# COMBINING GRAPHICS
# ============================================================

# Set plotting area to 1 row and 2 columns
par(mfrow = c(1, 2))

# Bar plot
barplot(table(direction))

# Pie chart
pie(table(direction))


# ============================================================
# COMBINING GRAPHICS - 2 ROWS, 1 COLUMN
# ============================================================

par(mfrow = c(2, 1))

barplot(table(direction))

pie(table(direction))


# Reset plotting area
par(mfrow = c(1, 1))


# ============================================================
# LECTURE 51
# HISTOGRAM
# ============================================================

# Height of 50 persons in centimetres

height <- c(
  166,125,130,142,147,159,159,147,165,156,
  149,164,137,166,135,142,133,136,127,143,
  165,121,142,148,158,146,154,157,124,125,
  158,159,164,143,154,152,141,164,131,152,
  152,161,143,143,139,131,125,145,140,163
)

# Display data
height


# ============================================================
# BASIC HISTOGRAM
# ============================================================

hist(height)


# ============================================================
# HISTOGRAM WITH RELATIVE FREQUENCIES
# ============================================================

hist(
  height,
  freq = FALSE
)


# ============================================================
# HISTOGRAM WITH TITLE, COLOUR AND AXIS LABELS
# ============================================================

hist(
  height,
  main = "Heights of persons",
  col = "green",
  xlab = "Heights",
  ylab = "Number of Persons"
)


# ============================================================
# HISTOGRAM WITH DENSITY
# ============================================================

hist(
  height,
  main = "Heights of persons",
  col = "red",
  xlab = "Heights",
  ylab = "Number of Persons",
  density = 2
)


# ============================================================
# HISTOGRAM WITH INCREASED DENSITY
# ============================================================

hist(
  height,
  main = "Heights of persons",
  col = "red",
  xlab = "Heights",
  ylab = "Number of Persons",
  density = 8
)


# ============================================================
# HISTOGRAM WITH DENSITY AND ANGLE
# ============================================================

hist(
  height,
  main = "Heights of persons",
  col = "red",
  xlab = "Heights",
  ylab = "Number of Persons",
  density = 8,
  angle = 100
)


# ============================================================
# LECTURE 52
# BIVARIATE SCATTER PLOT
# ============================================================

# Marks obtained by 20 students
marks <- c(
  337,316,327,340,374,330,352,353,370,380,
  384,398,413,428,430,438,439,479,460,450
)

# Number of hours studied per week
hours <- c(
  23,25,26,27,30,26,29,32,33,34,
  35,38,39,42,43,44,45,46,44,41
)


# ============================================================
# BASIC SCATTER PLOT
# ============================================================

plot(hours, marks)


# ============================================================
# SCATTER PLOT - POINTS
# ============================================================

plot(
  hours,
  marks,
  type = "p"
)


# ============================================================
# SCATTER PLOT - LINES
# ============================================================

plot(
  hours,
  marks,
  type = "l"
)


# ============================================================
# SCATTER PLOT - BOTH POINTS AND LINES
# ============================================================

plot(
  hours,
  marks,
  type = "b"
)


# ============================================================
# SCATTER PLOT - OVERPLOTTED
# ============================================================

plot(
  hours,
  marks,
  type = "o"
)


# ============================================================
# HISTOGRAM-LIKE VERTICAL LINES
# ============================================================

plot(
  hours,
  marks,
  type = "h"
)


# ============================================================
# STAIR-STEP PLOT
# ============================================================

plot(
  hours,
  marks,
  type = "s"
)


# ============================================================
# SCATTER PLOT WITH LABELS
# ============================================================

plot(
  hours,
  marks,
  xlab = "Number of weekly hours",
  ylab = "Marks obtained",
  main = "Marks obtained versus Number of hours per week"
)


# ============================================================
# MATRIX SCATTER PLOT
# ============================================================

pairs(
  cbind(hours, marks)
)


# ============================================================
# MATRIX SCATTER PLOT WITH LABELS AND COLOUR
# ============================================================

pairs(
  cbind(hours, marks),
  labels = c("Study hours", "Marks obtained"),
  col = "red"
)


# ============================================================
# SCATTER PLOT WITH SMOOTH CURVE
# ============================================================

scatter.smooth(
  hours,
  marks
)


# ============================================================
# SCATTER.SMOOTH WITH ADDITIONAL OPTIONS
# ============================================================

scatter.smooth(
  hours,
  marks,
  lpars = list(
    col = "red",
    lwd = 3,
    lty = 3
  )
)


# ============================================================
# THREE-DIMENSIONAL SCATTER PLOT
# ============================================================

# Install package ONCE if not already installed:
# install.packages("scatterplot3d")

library(scatterplot3d)


# Data for 5 persons

height3d <- c(
  100, 125, 145, 160, 170
)

weight3d <- c(
  30, 35, 50, 65, 70
)

age3d <- c(
  10, 15, 20, 30, 35
)


# Basic 3D scatter plot
scatterplot3d(
  height3d,
  weight3d,
  age3d
)


# ============================================================
# CHANGE DIRECTION OF 3D PLOT
# ============================================================

scatterplot3d(
  height3d,
  weight3d,
  age3d,
  angle = 120
)


# ============================================================
# CHANGE COLOUR OF POINTS
# ============================================================

scatterplot3d(
  height3d,
  weight3d,
  age3d,
  color = "red"
)


# ============================================================
# OTHER GRAPHICS FUNCTIONS
# ============================================================

# contour()  -> contour lines
# dotchart() -> dot chart
# image()    -> colours as third dimension
# mosaicplot() -> categorical data
# persp()    -> perspective surface


# ============================================================
# PERSPECTIVE PLOT
# ============================================================

x <- seq(
  -10,
  10,
  length = 30
)

y <- x


# Function used for z values
f <- function(x, y) {
  r <- sqrt(x^2 + y^2)
  10 * sin(r) / r
}


# Generate z values
z <- outer(
  x,
  y,
  f
)


# Replace NA values
z[is.na(z)] <- 1


# Basic perspective plot
persp(
  x,
  y,
  z,
  theta = 30,
  phi = 30,
  expand = 0.5,
  col = "lightblue"
)


# ============================================================
# DETAILED PERSPECTIVE PLOT
# ============================================================

persp(
  x,
  y,
  z,
  theta = 30,
  phi = 30,
  expand = 0.5,
  col = "lightblue",
  ltheta = 120,
  shade = 0.75,
  ticktype = "detailed",
  xlab = "X",
  ylab = "Y",
  zlab = "Sinc(r)"
)


# ============================================================
# LECTURE 53
# SOME EXAMPLES OF R PROGRAMMING
# ============================================================

# A program consists of instructions/commands written
# in a sequence to obtain a defined outcome.
#
# R programs can be written using functions.
#
# Important points:
# - Identify objective
# - Identify input variables
# - Identify output variables
# - Identify type of variables
# - Initialize variables
# - Use comments with #
# - Vectors/matrices can often be preferred over loops


# ============================================================
# EXAMPLE 1
# USER-DEFINED FUNCTION
# ============================================================

# Input vectors
x <- c(10, 20, 30)

y <- c(1, 2, 3)


# Define function
example1 <- function(x, y) {

  # Number of observations
  n <- length(x)

  # Initialize vectors
  x1 <- 0
  y1 <- 0
  z1 <- 0

  # Loop
  for (i in 1:n) {

    # Square of x
    x1[i] <- x[i]^2

    # Square of y
    y1[i] <- y[i]^2

    # Square of x/y
    z1[i] <- (x[i] / y[i])^2
  }

  # Sum of squared values
  sum_square_x <- sum(x1)

  sum_square_y <- sum(y1)

  sum_square_z <- sum(z1)

  # Calculate g and h
  g <- sum_square_x / sum_square_y

  h <- sum_square_z

  # Display result
  cat(
    "The value of g and h are",
    g,
    "and",
    h,
    "respectively",
    "\n"
  )
}


# Call the function
example1(x, y)


# ============================================================
# EXAMPLE 1 - SECOND DATA SET
# ============================================================

x <- c(
  67, 87, 26, 85, 6, 45
)

y <- c(
  54, 64, 22, 94, 20, 88
)

example1(x, y)


# ============================================================
# EXAMPLE 1 - ALTERNATIVE APPROACH
# ============================================================

example1_alternative <- function(x, y) {

  g <- sum(x^2) / sum(y^2)

  h <- sum((x / y)^2)

  cat(
    "The value of g and h are",
    g,
    "and",
    h,
    "respectively",
    "\n"
  )
}


# Test
x <- c(10, 20, 30)
y <- c(1, 2, 3)

example1_alternative(x, y)


# ============================================================
# EXAMPLE 2
# FUNCTION CALLING ANOTHER FUNCTION
# ============================================================

# Define g(x,y)

g <- function(x, y) {

  (x + log(y)) / y
}


# Define f(x,y)

f <- function(x, y) {

  (
    ((g(x, y))^2) /
      (5 + (g(x, y))^3)
  ) *
    (exp(g(x, y)))^(2/3)
}


# Test Example 2
x <- 10
y <- 20

f(x, y)


# Another example
x <- 1896
y <- 23454

f(x, y)


# ============================================================
# EXAMPLE 2 - CHECK g(x,y)
# ============================================================

g(10, 20)

g(1896, 23454)


# ============================================================
# EXAMPLE 3
# FUNCTION WITH IF / ELSE IF / ELSE
# ============================================================

# Define piecewise function

f3 <- function(x) {

  if (x > 0) {

    exp(
      (x + log(1 + x^3)) / x^2
    )

  } else if (x == 0) {

    10

  } else {

    (2 + x^3) / x
  }
}


# ============================================================
# TEST EXAMPLE 3
# ============================================================

f3(123)

f3(-123)

f3(0)

f3(8)

f3(-4)


# ============================================================
# EXAMPLE 3 - PLOT FUNCTION
# ============================================================

h <- function() {

  # Generate x values
  x <- seq(
    -1,
    5,
    by = 0.2
  )

  # Initialize y
  y <- 0

  # Calculate f(x) for every x
  for (i in 1:length(x)) {

    y[i] <- f3(x[i])
  }

  # Plot
  plot(
    x,
    y,
    type = "l"
  )
}


# Call plotting function
h()


# ============================================================
# EXAMPLE 3 - COMPLETE VERSION
# ============================================================

f3 <- function(x) {

  if (x > 0) {

    exp(
      (x + log(1 + x^3)) / x^2
    )

  } else if (x == 0) {

    10

  } else {

    (2 + x^3) / x
  }
}


h <- function() {

  x <- seq(
    -1,
    5,
    by = 0.2
  )

  y <- 0

  for (i in 1:length(x)) {

    y[i] <- f3(x[i])
  }

  plot(
    x,
    y,
    type = "l"
  )
}


# Execute
h()


# ============================================================
# BASIC USER-DEFINED FUNCTION EXAMPLES
# ============================================================

# Function with one argument

square <- function(x) {

  x^2
}


square(5)

square(10)


# ============================================================
# FUNCTION WITH TWO ARGUMENTS
# ============================================================

addition <- function(x, y) {

  x + y
}


addition(10, 20)


# ============================================================
# FUNCTION WITH MULTIPLE OPERATIONS
# ============================================================

calculate <- function(x, y) {

  sum_value <- x + y

  product_value <- x * y

  difference_value <- x - y

  cat(
    "Sum =", sum_value,
    "\n"
  )

  cat(
    "Product =", product_value,
    "\n"
  )

  cat(
    "Difference =", difference_value,
    "\n"
  )
}


calculate(20, 5)


# ============================================================
# FUNCTION WITH CONDITION
# ============================================================

check_number <- function(x) {

  if (x > 0) {

    cat("Positive number\n")

  } else if (x == 0) {

    cat("Zero\n")

  } else {

    cat("Negative number\n")
  }
}


check_number(10)

check_number(0)

check_number(-5)


# ============================================================
# FUNCTION WITH FOR LOOP
# ============================================================

print_squares <- function(n) {

  for (i in 1:n) {

    print(i^2)
  }
}


print_squares(10)


# ============================================================
# VECTOR-BASED APPROACH
# ============================================================

x <- 1:10

x^2


# Sum of squares
sum(x^2)


# ============================================================
# BASIC PROGRAM STRUCTURE
# ============================================================

my_program <- function(x) {

  # Input processing
  square_value <- x^2

  cube_value <- x^3

  # Output
  cat(
    "Square =", square_value,
    "\n"
  )

  cat(
    "Cube =", cube_value,
    "\n"
  )
}


my_program(5)


# ============================================================
# END OF WEEK 12
# ============================================================