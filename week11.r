
# ============================================================
# Krupa Gurav
# 24102C2005
# R PROGRAMMING - NPTEL WEEK 11
# VS CODE COMPATIBLE R SCRIPT
# ============================================================


# ============================================================
# 1. DATA FRAMES
# ============================================================

# Load MASS package
library(MASS)

# Display the painters data frame
painters

# Display summary of School variable
summary(painters$School)

# Display summary of Composition variable
summary(painters$Composition)


# ============================================================
# 2. ATTACH AND DETACH DATA FRAME
# ============================================================

# Attach the painters data frame
attach(painters)

# Now variables can be accessed directly
summary(School)
summary(Composition)

# Detach the data frame
detach(painters)

# After detach(), use painters$VariableName
summary(painters$School)


# ============================================================
# 3. SUBSETTING DATA FRAME
# ============================================================

# Select painters belonging to School F
subset(painters, School == "F")

# Select painters having Composition <= 6
subset(painters, Composition <= 6)

# Equivalent way using indexing
painters[painters[["School"]] == "F", ]


# ============================================================
# 4. SELECTING / REMOVING COLUMNS
# ============================================================

# Select School F and remove columns 3 and 5
# Columns 3 = Colour
# Column 5 = School
subset(
  painters,
  School == "F",
  select = c(-3, -5)
)


# ============================================================
# 5. SPLITTING DATA FRAME
# ============================================================

# Split painters data according to School
splitted <- split(painters, painters$School)

# Display the split data
splitted

# Access individual data frames
splitted$A
splitted$B
splitted$C
splitted$D
splitted$E
splitted$F
splitted$G
splitted$H

# Check whether splitted$A is a data frame
is.data.frame(splitted$A)


# ============================================================
# 6. IMPORTING EXCEL DATA
# ============================================================

# Install package only once if required
# install.packages("readxl")

# Load readxl package
library(readxl)

# Read first sheet of Excel file
data_excel <- read_excel("spexcel.xlsx")

# Display imported data
data_excel

# Read a specific sheet by number
data_excel2 <- read_excel("spexcel.xlsx", sheet = 2)

# Display second sheet
data_excel2


# ============================================================
# 7. ACCESSING EXCEL COLUMNS
# ============================================================

# Access columns having spaces in their names
data_excel$`Variable 1`
data_excel$`Variable 2`

# Calculate mean of a column
mean(data_excel$`Variable 1`)

# Access columns from second sheet
data_excel2$`Variable 4`
data_excel2$`Variable 5`
data_excel2$`Variable 6`

# Calculate mean
mean(data_excel2$`Variable 6`)


# ============================================================
# 8. READING LIMITED ROWS FROM EXCEL
# ============================================================

# Read only first 3 rows
data_excel3 <- read_excel(
  "spexcel.xlsx",
  n_max = 3
)

data_excel3


# ============================================================
# 9. READING A SPECIFIC EXCEL RANGE
# ============================================================

# Read Excel range using A1 notation
data_range <- read_excel(
  "spexcel.xlsx",
  range = "C1:E7"
)

data_range

# Example of R1C1 notation
data_range2 <- read_excel(
  "spexcel.xlsx",
  range = "R1C2:R2C5"
)

data_range2


# ============================================================
# 10. READING SPSS DATA
# ============================================================

# Install package only once if required
# install.packages("foreign")

library(foreign)

# Read SPSS file
# data_spss <- read.spss("datafile.sav")

# Display SPSS data
# data_spss


# ============================================================
# 11. READING HTML TABLE
# ============================================================

# Install package only once if required
# install.packages("XML")

library(XML)

# Read HTML table
# html_data <- readHTMLTable("filename")

# Display HTML data
# html_data


# ============================================================
# 12. OTHER FILE FORMATS
# ============================================================

# MATLAB / Octave
# data <- read.octave("filename")

# SYSTAT
# data <- read.systat("filename")

# SAS XPORT
# data <- read.xport("filename")

# Stata
# data <- read.dta("filename")


# ============================================================
# 13. WRITING DATA TO A FILE
# ============================================================

# Create a vector from 1 to 100
x <- 1:100

# Display vector
x

# Write vector to a file
write(
  x,
  file = "shalabh.txt"
)


# ============================================================
# 14. WRITE CSV FILE
# ============================================================

# Create sample data
student_data <- data.frame(
  Name = c("A", "B", "C", "D"),
  Marks = c(85, 78, 92, 88)
)

# Write data frame to CSV file
write.csv(
  student_data,
  file = "student_data.csv",
  row.names = FALSE
)


# ============================================================
# 15. WRITE TABLE
# ============================================================

# Write data frame to a text file
write.table(
  student_data,
  file = "student_data.txt",
  sep = "\t",
  row.names = FALSE
)


# ============================================================
# 16. ABSOLUTE AND RELATIVE FREQUENCY
# ============================================================

# 1 = Male
# 2 = Female

gender <- c(
  1, 2, 1, 2, 1,
  1, 1, 2, 1, 1
)

# Display gender data
gender

# Absolute frequency
table(gender)

# Relative frequency
table(gender) / length(gender)


# ============================================================
# 17. DIRECTION DATA
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

# Absolute frequency
table(direction)

# Relative frequency
table(direction) / length(direction)


# ============================================================
# 18. QUANTILES
# ============================================================

# Marks of 15 students
marks <- c(
  68, 82, 63, 86, 34,
  96, 41, 89, 29, 51,
  75, 77, 56, 59, 42
)

# Display marks
marks

# Calculate default quantiles
quantile(marks)

# Calculate specified quantiles
quantile(
  marks,
  probs = c(0, 0.25, 0.5, 0.75, 1)
)

# Calculate custom partition values
quantile(
  marks,
  probs = c(0, 0.20, 0.40, 0.60, 0.80, 1)
)


# ============================================================
# 19. SCATTER PLOT
# ============================================================

# Heights of 50 persons
height <- c(
  166,125,130,142,147,159,159,147,165,156,
  149,164,137,166,135,142,133,136,127,143,
  165,121,142,148,158,146,154,157,124,125,
  158,159,164,143,154,152,141,164,131,152,
  152,161,143,143,139,131,125,145,140,163
)

# Scatter plot of height values
plot(height)


# ============================================================
# 20. SCATTER PLOT WITH CUSTOM COLOUR
# ============================================================

# Plot height values
plot(
  height,
  col = "red",
  main = "Height of 50 Persons",
  xlab = "Index",
  ylab = "Height"
)


# ============================================================
# 21. BAR PLOT
# ============================================================

# Bar plot directly from data
barplot(gender)

# Bar plot using absolute frequencies
barplot(table(gender))

# Bar plot using relative frequencies
barplot(
  table(gender) / length(gender)
)


# ============================================================
# 22. BAR PLOT FOR DIRECTION DATA
# ============================================================

# Absolute frequency bar plot
barplot(table(direction))

# Relative frequency bar plot
barplot(
  table(direction) / length(direction)
)


# ============================================================
# 23. USEFUL SUMMARY COMMANDS
# ============================================================

# Number of observations
length(marks)

# Minimum value
min(marks)

# Maximum value
max(marks)

# Mean
mean(marks)

# Median
median(marks)

# Standard deviation
sd(marks)

# Variance
var(marks)

# Summary statistics
summary(marks)


# ============================================================
# END OF NPTEL WEEK 11 CODE
# ============================================================