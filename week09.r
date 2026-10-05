# ============================================================
# Krupa Gurav
# 24102C2005
# R PROGRAMMING - NPTEL WEEK 9
# VS CODE COMPATIBLE R SCRIPT
# Topics:
# 1. print()
# 2. cat()
# 3. paste()
# 4. paste0()
# 5. strsplit()
# 6. String indexing
# 7. String to matrix conversion
# 8. nchar()
# 9. nzchar()
# 10. toupper()
# 11. tolower()
# ============================================================


# ============================================================
# 1. PRINT FUNCTION
# ============================================================

# Print a single object
print("Hello R Programming")

# Print a number
print(100)

# print() is mainly used for one object at a time
# The following gives an error because multiple arguments
# are passed to print()
# print("The zero occurs at", 2 * pi, "radians.")


# ============================================================
# 2. PRINT MULTIPLE ITEMS
# ============================================================

# Multiple items can be printed separately
print("The zero occurs at")
print(2 * pi)
print("radians")


# ============================================================
# 3. CAT FUNCTION
# ============================================================

# cat() can combine multiple items into one continuous output
cat("The zero occurs at", 2 * pi, "radians.", "\n")


# ============================================================
# 4. CAT FUNCTION WITH NEW LINE
# ============================================================

# Store current date
d <- date()

# Print date with a message
cat("Today's date is:", d, "\n")


# ============================================================
# 5. CAT FUNCTION WITH sep
# ============================================================

# Create a vector
x <- 1:10

# Print vector normally
x

# Separate values using ++
cat(x, sep = " ++ ")

# Move to a new line
cat("\n")

# Separate values using /
cat(x, sep = " / ")

cat("\n")


# ============================================================
# 6. CAT WITH CALCULATIONS
# ============================================================

# Store value
x <- 7

# Display square
cat("The square of", x, "is", x^2, "!\n")


# ============================================================
# 7. CAT WITH format()
# ============================================================

# Display square root with limited digits
cat(
  "The square root of",
  x,
  "is approximately",
  format(sqrt(x), digits = 3),
  "\n"
)


# ============================================================
# 8. CAT WITH VECTOR
# ============================================================

# Create vector of even numbers
evenno <- c(2, 4, 6, 8, 10)

# Display vector
cat(
  "The first few even numbers are:",
  evenno,
  "...\n"
)


# ============================================================
# 9. CAT WITH fill AND labels
# ============================================================

# Create sequence
x <- 1:10

# Display values with labels
cat(
  x,
  fill = 2,
  labels = paste("(", letters[1:10], "):")
)


# ============================================================
# 10. PASTE FUNCTION
# ============================================================

# paste() combines strings
paste(
  "Everybody",
  "loves",
  "R Programming."
)


# ============================================================
# 11. PASTE WITH sep
# ============================================================

# Use * as separator
paste(
  "Everybody",
  "loves",
  "R Programming.",
  sep = "*"
)

# Use === as separator
paste(
  "Everybody",
  "loves",
  "R Programming.",
  sep = "==="
)


# ============================================================
# 12. PASTE AND CHARACTER CONVERSION
# ============================================================

# Convert numbers to character strings
paste(1:12)

# Alternative
as.character(1:12)


# ============================================================
# 13. PASTE WITH VECTORS
# ============================================================

# Create names vector
names <- c(
  "Prof. Singh",
  "Mr. Venkat",
  "Dr. Jha"
)

# Display names
names

# Create a sentence for every name
paste(
  names,
  "is",
  "a good",
  "person."
)


# ============================================================
# 14. PASTE WITH COLLAPSE
# ============================================================

# Combine all generated strings into one string
paste(
  names,
  "is",
  "a good",
  "person.",
  collapse = ", and "
)


# ============================================================
# 15. PASTE WITH NUMBERS
# ============================================================

paste(
  1,
  " is first",
  2,
  " is second",
  3,
  " is third",
  sep = "#"
)


# ============================================================
# 16. PASTE WITH SPACE INSIDE STRINGS
# ============================================================

# Spaces inside quotes are preserved
paste(
  1,
  " is first ",
  2,
  " is second ",
  3,
  " is third ",
  sep = "#"
)


# ============================================================
# 17. PASTE WITH VECTOR AND sep
# ============================================================

# Create Ex_1, Ex_2, ... Ex_5
x <- paste(
  "Ex",
  1:5,
  sep = "_"
)

# Display vector
x

# Access individual elements
x[1]
x[2]
x[3]
x[5]


# ============================================================
# 18. PASTE WITH collapse
# ============================================================

# Create one single string instead of a vector
x <- paste(
  "Ex",
  1:5,
  sep = "_",
  collapse = ""
)

# Display result
x

# Access the complete string
x[1]


# ============================================================
# 19. DIFFERENCE BETWEEN sep AND collapse
# ============================================================

# sep creates separate elements
x1 <- paste(
  "Ex",
  1:5,
  sep = "_"
)

x1


# collapse joins all elements into one string
x2 <- paste(
  "Ex",
  1:5,
  sep = "_",
  collapse = ""
)

x2


# ============================================================
# 20. PASTE0 FUNCTION
# ============================================================

# paste0() uses no separator by default
paste0(1:10)

# paste() with one vector
paste(1:10)


# ============================================================
# 21. PASTE0 WITH MULTIPLE VECTORS
# ============================================================

# Create ordinal numbers
paste0(
  1:10,
  c("st", "nd", "rd", rep("th", 7))
)


# paste() adds a space by default
paste(
  1:10,
  c("st", "nd", "rd", rep("th", 7))
)


# ============================================================
# 22. STRSPLIT FUNCTION
# ============================================================

# Create a string
x <- "The&!syntax&!of&!paste&!is!&available!&inthe online-help"

# Display original string
x

# Split using !
strsplit(
  x,
  split = "!"
)


# ============================================================
# 23. STRSPLIT USING MULTI-CHARACTER SEPARATOR
# ============================================================

# Split using &!
strsplit(
  x,
  split = "&!"
)


# ============================================================
# 24. STORE STRSPLIT RESULT
# ============================================================

# Store result
y <- strsplit(
  x,
  split = "!&"
)

# Display result
y


# ============================================================
# 25. ACCESS STRSPLIT COMPONENTS
# ============================================================

# Access first component
y[[1]][1]

# Access second component
y[[1]][2]

# Access third component
# This returns NA if it does not exist
y[[1]][3]


# ============================================================
# 26. SPLITTING DATES
# ============================================================

# Create date vector
dates <- c(
  "2020-07-24",
  "2021-08-25",
  "2022-09-26",
  "2023-10-27"
)

# Split dates using "-"
datesplt <- strsplit(
  dates,
  split = "-"
)

# Display result
datesplt


# ============================================================
# 27. CONVERT SPLIT DATES TO CHARACTER MATRIX
# ============================================================

# unlist() converts the list into a vector
# matrix() converts it into a matrix
datemat <- matrix(
  unlist(datesplt),
  nrow = 4,
  ncol = 3,
  byrow = TRUE
)

# Display character matrix
datemat


# ============================================================
# 28. CONVERT SPLIT DATES TO NUMERIC MATRIX
# ============================================================

# Convert split date values to numeric
datematrix <- matrix(
  as.numeric(unlist(datesplt)),
  nrow = 4,
  ncol = 3,
  byrow = TRUE
)

# Display numeric matrix
datematrix


# ============================================================
# 29. SPLIT A STRING INTO INDIVIDUAL CHARACTERS
# ============================================================

# Split every character
strsplit(
  "Shalabh",
  split = ""
)


# ============================================================
# 30. NCHAR FUNCTION
# ============================================================

# nchar() returns number of characters
x <- "R course 24.07.2022"

# Count characters
nchar(x)


# Another string
y <- "Number of participants: 25"

# Count characters
nchar(y)


# ============================================================
# 31. NCHAR WITH CHARACTER VECTOR
# ============================================================

# Create character vector
x <- c(
  "Apple",
  "Banana",
  "Cake"
)

# Count characters in each element
nchar(x)


# ============================================================
# 32. NCHAR WITH NUMERIC VECTOR
# ============================================================

# Numeric vector
y <- c(2, 4, 6)

# Number of characters in each number
nchar(y)


# Numeric values with different number of digits
z <- c(11, 222, 3333)

# Count digits
nchar(z)


# Decimal numbers
z1 <- c(1.1, 2.22, 3.333)

# Count characters
nchar(z1)


# ============================================================
# 33. NZCHAR FUNCTION
# ============================================================

# Create a string
x <- "R course 24.07.2022"

# Check whether string is non-empty
nzchar(x)


# Another string
y <- "Number of participants: 25"

# Check whether string is non-empty
nzchar(y)


# ============================================================
# 34. NZCHAR WITH VECTOR
# ============================================================

# Create character vector
x <- c(
  "Apple",
  "Banana",
  "Cake"
)

# Check non-empty strings
nzchar(x)


# ============================================================
# 35. NZCHAR WITH EMPTY STRING
# ============================================================

# Create vector containing an empty string
y <- c(
  "Apple",
  "",
  "Cake"
)

# Display vector
y

# Check which elements are non-empty
nzchar(y)


# ============================================================
# 36. TOUPPER FUNCTION
# ============================================================

# Create string
x <- "R course will start from 24.07.2022"

# Convert to uppercase
toupper(x)


# ============================================================
# 37. TOLOWER FUNCTION
# ============================================================

# Create uppercase string
z <- "INDIAN INSTITUTE OF TECHNOLOGY"

# Convert to lowercase
tolower(z)


# ============================================================
# 38. COMPLETE STRING MANIPULATION EXAMPLE
# ============================================================

# Original sentence
text <- "R Programming is Powerful"

# Number of characters
nchar(text)

# Convert to uppercase
toupper(text)

# Convert to lowercase
tolower(text)

# Split into words
strsplit(text, split = " ")

# Join words using -
paste(
  "R",
  "Programming",
  "is",
  "Powerful",
  sep = "-"
)

# Join without spaces
paste0(
  "R",
  "Programming",
  "is",
  "Powerful"
)


# ============================================================
# END OF NPTEL WEEK 9
# ============================================================