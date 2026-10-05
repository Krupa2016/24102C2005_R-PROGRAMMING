# ============================================================
# Krupa Gurav
# 24102C2005
# R PROGRAMMING - NPTEL WEEK 6
# VS CODE COMPATIBLE R SCRIPT
# Topics:
# 1. for loop
# 2. Nested for loop
# 3. break
# 4. next
# 5. while loop
# 6. repeat loop
# 7. Functions
# 8. Sequences
# ============================================================


# ============================================================
# 1. FOR LOOP
# ============================================================

# Syntax:
# for (name in vector) {
#   commands
# }

# Print squares of numbers from 1 to 5
for (i in 1:5) {
  print(i^2)
}


# ============================================================
# 2. FOR LOOP USING A VECTOR
# ============================================================

# Create a vector
numbers <- c(2, 4, 6, 7)

# Print square of every element
for (i in numbers) {
  print(i^2)
}


# ============================================================
# 3. FOR LOOP WITH IF CONDITION
# ============================================================

# Create a vector
x <- c(2, 4, 6, 8, 10, 12)

# Function to count values satisfying a condition
excount <- function(x) {
  
  # Initialize counter
  count <- 0
  
  # Loop through every value
  for (xval in x) {
    
    # Check condition
    if (xval / 2 > 3) {
      count <- count + 1
    }
  }
  
  # Display count
  print(count)
}

# Call function
excount(x)


# ============================================================
# 4. NESTED FOR LOOP
# ============================================================

# Create two character vectors
child <- c("child1", "child2", "child3")
sweet <- c("sweet1", "sweet2", "sweet3")

# Outer loop
for (x in child) {
  
  # Inner loop
  for (y in sweet) {
    
    # Combine and print values
    print(paste(x, y))
  }
}


# ============================================================
# 5. BREAK COMMAND
# ============================================================

# Create a vector of drinks
drink <- c("coffee", "lemonade", "tea", "juice")

# Loop through drinks
for (x in drink) {
  
  # Stop loop when tea is found
  if (x == "tea") {
    break
  }
  
  # Print current drink
  print(x)
}


# ============================================================
# 6. NEXT COMMAND
# ============================================================

# Create a vector of drinks
drink <- c("coffee", "lemonade", "tea", "juice")

# Skip lemonade
for (x in drink) {
  
  # Skip current iteration
  if (x == "lemonade") {
    next
  }
  
  # Print remaining drinks
  print(x)
}


# ============================================================
# 7. NEXT COMMAND - SKIP TEA
# ============================================================

# Create drink vector
drink <- c("coffee", "lemonade", "tea", "juice")

# Skip tea
for (x in drink) {
  
  if (x == "tea") {
    next
  }
  
  print(x)
}


# ============================================================
# 8. WHILE LOOP
# ============================================================

# Initialize variable
i <- 1

# Execute while condition is TRUE
while (i < 10) {
  
  # Print square
  print(i^2)
  
  # Increase i by 2
  i <- i + 2
}


# ============================================================
# 9. WHILE LOOP WITH USER INPUT
# ============================================================

# Function to calculate sum using while loop
sumfunction <- function() {
  
  # Initialize sum
  sum <- 0
  
  # Take input from user
  number <- as.integer(
    readline(prompt = "Please select any number less than 25: ")
  )
  
  # Continue while number is <= 25
  while (number <= 25) {
    
    # Add number to sum
    sum <- sum + number
    
    # Increase number by 1
    number <- number + 1
  }
  
  # Display result
  print(
    paste(
      "The sum of numbers received from the While Loop:",
      sum
    )
  )
}

# Call the function
# sumfunction()


# ============================================================
# 10. REPEAT LOOP
# ============================================================

# Initialize variable
i <- 1

# Repeat loop
repeat {
  
  # Print square
  print(i^2)
  
  # Increase i by 2
  i <- i + 2
  
  # Stop loop when i becomes greater than 10
  if (i > 10) {
    break
  }
}


# ============================================================
# 11. REPEAT LOOP WITH NEXT
# ============================================================

# Initialize variable
i <- 1

repeat {
  
  # Increase i
  i <- i + 1
  
  # Skip values less than 10
  if (i < 10) {
    next
  }
  
  # Print square
  print(i^2)
  
  # Stop when i reaches 13
  if (i >= 13) {
    break
  }
}


# ============================================================
# 12. BUILT-IN FUNCTIONS
# ============================================================

# Create a vector
x <- c(10, 20, 30, 40, 50)

# Sum of values
sum(x)

# Product of values
prod(x)

# Mean of values
mean(x)

# Maximum value
max(x)

# Minimum value
min(x)


# ============================================================
# 13. USER-DEFINED FUNCTION - ONE VARIABLE
# ============================================================

# Define function to calculate square
abc <- function(x) {
  x^2
}

# Call function
abc(3)
abc(6)
abc(9)


# ============================================================
# 14. USER-DEFINED FUNCTION - TWO VARIABLES
# ============================================================

# Function to calculate x^2 + y^2
abc <- function(x, y) {
  x^2 + y^2
}

# Call function
abc(3, 4)
abc(10, 10)
abc(-2, -3)


# ============================================================
# 15. FUNCTION WITH TRIGONOMETRIC OPERATIONS
# ============================================================

# Define function
abc <- function(x) {
  sin(x)^2 + cos(x)^2 + x
}

# Call function
abc(9)
abc(99)
abc(-15)


# ============================================================
# 16. FUNCTION WITHOUT ARGUMENT
# ============================================================

# Define function without input argument
abc <- function() {
  
  # Loop from 1 to 3
  for (i in 1:3) {
    
    # Print cube
    print(i^3)
  }
}

# Call function
abc()


# ============================================================
# 17. SEQUENCES USING seq()
# ============================================================

# Basic sequence
seq(from = 2, to = 4)

# Reverse sequence
seq(from = 4, to = 2)

# Sequence containing negative numbers
seq(from = -4, to = 4)


# ============================================================
# 18. SEQUENCE WITH CONSTANT INCREMENT
# ============================================================

# Generate sequence from 10 to 20 with increment 2
seq(
  from = 10,
  to = 20,
  by = 2
)


# ============================================================
# 19. SEQUENCE WITH CONSTANT DECREMENT
# ============================================================

# Generate sequence from 20 to 10 with decrement 2
seq(
  from = 20,
  to = 10,
  by = -2
)


# ============================================================
# 20. SEQUENCE WITH FRACTIONAL DECREMENT
# ============================================================

# Generate sequence from 3 to -2
# with decrement of 0.5
seq(
  from = 3,
  to = -2,
  by = -0.5
)


# ============================================================
# 21. SEQUENCE WITH PREDEFINED LENGTH
# ============================================================

# Generate 10 values ending at 10
seq(
  to = 10,
  length.out = 10
)


# ============================================================
# 22. SEQUENCE STARTING FROM 10
# ============================================================

# Generate 10 values starting from 10
seq(
  from = 10,
  length.out = 10
)


# ============================================================
# 23. SEQUENCE WITH FRACTIONAL INCREMENT
# ============================================================

# Generate 10 values with increment 0.1
seq(
  from = 10,
  length.out = 10,
  by = 0.1
)


# ============================================================
# 24. SEQUENCE WITH DECREMENT
# ============================================================

# Generate 10 values with decrement 2
seq(
  from = 10,
  length.out = 10,
  by = -2
)


# ============================================================
# 25. SEQUENCE WITH FRACTIONAL DECREMENT
# ============================================================

# Generate 5 values with decrement 0.2
seq(
  from = 10,
  length.out = 5,
  by = -0.2
)


# ============================================================
# END OF NPTEL WEEK 6 CODE
# ============================================================