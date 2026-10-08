# High-Performance Big Data Analytics Using R

## Laboratory Assignment 8 -- R Programming

This project implements a high-performance and scalable data analytics
workflow using **R** and the **NYC TLC Yellow Taxi Trip Records**
dataset.

The project compares different R programming approaches for large-scale
transportation data, including `data.table`, functional programming,
vectorized operations, sequential processing, and parallel processing.

------------------------------------------------------------------------

## Problem Statement

The New York City Taxi and Limousine Commission (NYC TLC) generates
millions of taxi-trip records containing information such as pickup and
drop-off locations, timestamps, passenger count, trip distance, fare
amount, payment type, and total transaction amount.

The objective of this laboratory assignment is to develop an efficient
and scalable data analytics solution in R and evaluate different
programming approaches based on:

-   Execution time
-   Computational efficiency
-   Memory utilization
-   Scalability
-   Programming complexity
-   Readability

------------------------------------------------------------------------

## Objectives

The project aims to:

-   Process and analyze large-scale NYC taxi trip data using R
-   Perform efficient data manipulation using `data.table`
-   Clean and preprocess taxi trip records
-   Join trip data with the Taxi Zone Lookup Table
-   Analyze taxi travel and demand patterns
-   Analyze fare and revenue characteristics
-   Implement functional programming using `apply()`, `lapply()`, and
    `purrr::map()`
-   Compare functional programming with vectorized and `data.table`
    approaches
-   Implement sequential and parallel processing
-   Use `foreach` and `doParallel` for parallel computation
-   Benchmark different implementations
-   Calculate parallel processing speedup
-   Generate visualizations using `ggplot2`
-   Critically evaluate alternative R programming approaches
-   Recommend a suitable approach for large-scale analytical
    applications

------------------------------------------------------------------------

## Dataset

### NYC TLC Yellow Taxi Trip Records

The project uses the official **NYC Taxi & Limousine Commission (TLC)
Yellow Taxi Trip Records**.

The dataset contains fields such as:

-   Pickup date and time
-   Drop-off date and time
-   Pickup Location ID
-   Drop-off Location ID
-   Passenger count
-   Trip distance
-   Payment type
-   Fare amount
-   Tip amount
-   Tolls amount
-   Total amount

### Dataset Used

The project uses:

-   January 2026 Yellow Taxi Trip Records
-   February 2026 Yellow Taxi Trip Records
-   March 2026 Yellow Taxi Trip Records
-   Taxi Zone Lookup Table

The trip records are stored in **Parquet format**.

Official source:

https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page

> The large Parquet files are not included in this repository because of
> their size. They should be downloaded separately from the official NYC
> TLC website.

------------------------------------------------------------------------

## Project Structure

``` text
R-Lab-8-NYC-Taxi/
│
├── taxi.r
├── README.md
│
├── data/
│   └── taxi_zone_lookup.csv
│
├── plots/
│   ├── trips_by_hour.png
│   ├── trips_by_day.png
│   ├── monthly_demand.png
│   ├── average_fare.png
│   ├── revenue.png
│   ├── payment_type.png
│   └── distance_vs_fare.png
│
└── results/
    └── benchmark_results.csv
```

The large Yellow Taxi files should be placed in the `data/` directory:

``` text
data/
├── yellow_tripdata_2026-01.parquet
├── yellow_tripdata_2026-02.parquet
├── yellow_tripdata_2026-03.parquet
└── taxi_zone_lookup.csv
```

------------------------------------------------------------------------

## Technologies and R Packages

### Programming Language

-   R 4.6.1

### Packages

``` r
data.table
ggplot2
lubridate
foreach
doParallel
microbenchmark
purrr
arrow
```

------------------------------------------------------------------------

## Project Workflow

``` text
NYC TLC Yellow Taxi Dataset
            |
            v
     Data Acquisition
            |
            v
  Data Cleaning & Preparation
            |
            v
    Taxi Zone Lookup Join
            |
            v
 Transportation Data Analytics
            |
      +-----+------+
      |            |
      v            v
 Functional     Vectorized
 Programming   Operations
      |            |
      +-----+------+
            |
            v
        data.table
            |
            v
   Sequential Processing
            |
            v
    Parallel Processing
            |
            v
       Benchmarking
            |
            v
      Visualizations
            |
            v
    Critical Analysis
            |
            v
        Conclusion
```

------------------------------------------------------------------------

# Task 1 -- Data Acquisition and Preparation

The project imports the selected NYC Yellow Taxi Parquet files and
performs preprocessing.

The preprocessing includes:

-   Importing the datasets
-   Inspecting structure and dimensions
-   Checking data types
-   Generating summary statistics
-   Identifying missing values
-   Removing duplicate records
-   Filtering invalid or inconsistent records
-   Converting attributes to appropriate data types
-   Extracting hour
-   Extracting day
-   Extracting day of week
-   Extracting month
-   Removing unnecessary attributes where appropriate
-   Importing the Taxi Zone Lookup Table
-   Joining pickup and drop-off Location IDs with zone information
-   Using `data.table` for efficient filtering, joining, grouping, and
    aggregation

------------------------------------------------------------------------

# Task 2 -- Transportation Data Analytics

The project analyzes important taxi travel and transaction patterns.

## Trip Demand

The analysis includes:

-   Number of trips by hour
-   Taxi demand by day of week
-   Monthly taxi demand

## Fare and Revenue

The analysis includes:

-   Average fare
-   Total revenue
-   Fare trends
-   Revenue trends

## Route Analysis

The project identifies:

-   Most frequently travelled routes
-   Highest-revenue routes
-   Top pickup locations
-   Top drop-off locations

## Distance and Fare

The relationship between trip distance and fare amount is analyzed.

## Payment Analysis

Different payment methods are compared across locations and boroughs.

------------------------------------------------------------------------

# Task 3 -- Functional and Efficient R Programming

Selected analytical operations are implemented using functional
programming techniques:

``` r
apply()
lapply()
purrr::map()
```

Equivalent operations are implemented using:

-   Vectorized R operations
-   `data.table`

The approaches are compared based on:

-   Execution time
-   Computational efficiency
-   Code complexity
-   Readability
-   Memory utilization
-   Suitability for large-scale datasets

------------------------------------------------------------------------

# Task 4 -- Parallel Computing

The dataset is divided into logical partitions for processing.

## Sequential Processing

The selected analytical operation is executed sequentially and its
execution time is recorded.

## Parallel Processing

Parallel processing is implemented using:

``` r
foreach
doParallel
```

Multiple processing cores are used to execute suitable operations
concurrently.

### Speedup

Parallel speedup is calculated as:

``` text
Speedup = Sequential Execution Time / Parallel Execution Time
```

The result is used to determine whether parallel processing provides a
significant performance improvement.

------------------------------------------------------------------------

# Task 5 -- Performance Benchmarking

Performance is evaluated using:

``` r
microbenchmark()
```

and:

``` r
system.time()
```

The project compares:

  -----------------------------------------------------------------------
  Comparison                          Purpose
  ----------------------------------- -----------------------------------
  Base R vs data.table                Compare conventional and optimized
                                      data manipulation

  Functional vs Vectorized            Compare programming approaches

  Functional vs data.table            Compare functional programming with
                                      optimized data manipulation

  Sequential vs Parallel              Measure parallel processing
                                      improvement
  -----------------------------------------------------------------------

The benchmark analysis considers:

-   Execution time
-   Memory requirements
-   Scalability
-   Programming complexity
-   Readability
-   Computational performance

------------------------------------------------------------------------

# Task 6 -- Data Visualization

The project uses `ggplot2` to create visualizations representing
important findings.

Visualizations include:

-   Number of trips by hour
-   Taxi demand by day of week
-   Monthly taxi demand
-   Average fare trends
-   Revenue trends
-   Top pickup locations
-   Top drop-off locations
-   Most frequently travelled routes
-   Highest-revenue routes
-   Payment-type distribution
-   Trip distance vs fare amount

Each visualization should contain:

-   Appropriate title
-   Axis labels
-   Units where applicable
-   Legends where required
-   Brief interpretation

------------------------------------------------------------------------

# Task 7 -- Critical Analysis and Recommendation

The project evaluates the different R programming approaches based on
experimental results.

The analysis addresses:

1.  Which approach provides the best execution performance?
2.  How does `data.table` improve processing of large datasets?
3.  When is functional programming preferable?
4.  When do vectorized operations provide better performance?
5.  What performance improvement is obtained using parallel computing?
6.  Does parallel computing always result in faster execution?
7.  What trade-offs exist between execution speed, memory utilization,
    readability, and scalability?
8.  Which R programming approach is recommended for large-scale
    analytical applications?

The final recommendation is based on actual benchmark and experimental
results.

------------------------------------------------------------------------

# Benchmark Results

The final report should contain a comparison table similar to:

  Approach                Execution Time Memory Usage   Scalability
  ------------ ------------------------- -------------- -------------
  Base R         Measured experimentally Evaluated      Evaluated
  Functional     Measured experimentally Evaluated      Evaluated
  Vectorized     Measured experimentally Evaluated      Evaluated
  data.table     Measured experimentally Evaluated      Evaluated
  Sequential     Measured experimentally Evaluated      Evaluated
  Parallel       Measured experimentally Evaluated      Evaluated

> The final values should be obtained from actual execution of the R
> program.

------------------------------------------------------------------------

# Results and Observations

The project analyzes:

-   Peak taxi travel hours
-   Daily demand patterns
-   Monthly demand
-   Average fare behavior
-   Revenue patterns
-   Frequently travelled routes
-   High-revenue routes
-   Payment preferences
-   Distance versus fare relationship
-   Performance differences between R programming approaches

The final observations should be based on the actual outputs generated
by the implementation.

------------------------------------------------------------------------

# Installation

Install R from:

https://cran.r-project.org/

Install the required packages:

``` r
install.packages(c(
  "data.table",
  "ggplot2",
  "lubridate",
  "foreach",
  "doParallel",
  "microbenchmark",
  "purrr",
  "arrow"
))
```

------------------------------------------------------------------------

# Running the Project

Clone the repository:

``` bash
git clone <YOUR-GITHUB-REPOSITORY-URL>
```

Open the project in VS Code.

Place the dataset files in the `data/` directory:

``` text
data/
├── yellow_tripdata_2026-01.parquet
├── yellow_tripdata_2026-02.parquet
├── yellow_tripdata_2026-03.parquet
└── taxi_zone_lookup.csv
```

Open an R Interactive Terminal in VS Code.

Set the working directory to the project folder:

``` r
setwd("path/to/R-Lab-8-NYC-Taxi")
```

Run the R program:

``` r
source("taxi.r")
```

------------------------------------------------------------------------

# Dataset and GitHub File Policy

The following large files are intentionally excluded from the
repository:

``` text
yellow_tripdata_2026-01.parquet
yellow_tripdata_2026-02.parquet
yellow_tripdata_2026-03.parquet
```

They should be downloaded from the official NYC TLC website.

The Taxi Zone Lookup Table is included in the repository:

``` text
taxi_zone_lookup.csv
```

------------------------------------------------------------------------

# Expected Outputs

Running the project produces analytical and performance results
including:

-   Dataset statistics
-   Cleaned data
-   Hourly demand analysis
-   Daily demand analysis
-   Monthly demand analysis
-   Fare analysis
-   Revenue analysis
-   Route analysis
-   Payment analysis
-   Functional programming results
-   Vectorized results
-   `data.table` results
-   Sequential processing results
-   Parallel processing results
-   Benchmark results
-   Parallel speedup
-   Data visualizations

------------------------------------------------------------------------

# Deliverables

The completed laboratory work includes:

-   Complete R implementation
-   Data preprocessing and cleaning
-   `data.table` implementation
-   Functional programming implementation
-   Vectorized implementation
-   Sequential processing implementation
-   Parallel processing implementation
-   Performance benchmark results
-   Execution-time comparison table
-   Relevant visualizations
-   Interpretation of analytical findings
-   Critical performance analysis
-   Final recommendation
-   Conclusion

------------------------------------------------------------------------

# Learning Outcomes

This project provides practical experience in:

-   Large-scale data processing
-   High-performance R programming
-   Efficient data manipulation
-   Functional programming
-   Vectorized programming
-   Parallel computing
-   Performance benchmarking
-   Code optimization
-   Memory-efficient programming
-   Data visualization
-   Transportation analytics
-   Scalable analytical workflows

------------------------------------------------------------------------

# Conclusion

This laboratory demonstrates the application of R programming techniques
to large-scale transportation data.

Functional, vectorized, `data.table`, sequential, and parallel
approaches are implemented and compared using experimental performance
measurements.

The final recommendation is based on execution time, memory efficiency,
scalability, programming complexity, and readability.

------------------------------------------------------------------------
