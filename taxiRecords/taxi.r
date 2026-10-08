# ============================================================
# LAB ASSIGNMENT 8
# HIGH-PERFORMANCE BIG DATA ANALYTICS USING R
# NYC TAXI TRIP DATASET
# VS CODE - R EXTENSION COMPATIBLE
# ============================================================


# ============================================================
# 1. INSTALL REQUIRED PACKAGES - RUN ONCE
# ============================================================

# Uncomment this section only the first time

# install.packages(c(
#   "data.table",
#   "ggplot2",
#   "lubridate",
#   "foreach",
#   "doParallel",
#   "microbenchmark",
#   "purrr",
#   "arrow"
# ))


# ============================================================
# 2. LOAD LIBRARIES
# ============================================================

library(data.table)
library(ggplot2)
library(lubridate)
library(foreach)
library(doParallel)
library(microbenchmark)
library(purrr)
library(arrow)


# ============================================================
# 3. FILE PATHS
# ============================================================
taxi_files <- c(
  "data/yellow_tripdata_2026-01.parquet",
  "data/yellow_tripdata_2026-02.parquet",
  "data/yellow_tripdata_2026-03.parquet"
)

zone_file <- "data/taxi_zone_lookup.csv"

# ============================================================
# 4. DATA ACQUISITION
# ============================================================

cat("Reading Yellow Taxi data...\n")

taxi_list <- lapply(taxi_files, function(file) {
  
  cat("Reading:", file, "\n")
  
  dt <- as.data.table(arrow::read_parquet(file))
  
  # Add month from filename
  dt[, source_month := sub(
    ".*yellow_tripdata_(\\d{4}-\\d{2}).*",
    "\\1",
    file
  )]
  
  return(dt)
})

# Combine January + February + March
taxi <- rbindlist(taxi_list, use.names = TRUE, fill = TRUE)

cat("Total rows:", nrow(taxi), "\n")
cat("Total columns:", ncol(taxi), "\n")


# ============================================================
# 5. BASIC DATA INSPECTION
# ============================================================

cat("\n============================================\n")
cat("DATASET INFORMATION\n")
cat("============================================\n")

cat("Rows:", nrow(taxi), "\n")
cat("Columns:", ncol(taxi), "\n")

cat("\nColumn names:\n")
print(names(taxi))

cat("\nStructure:\n")
str(taxi)

cat("\nSummary:\n")
print(summary(taxi))


# ============================================================
# 6. SELECT REQUIRED COLUMNS
# ============================================================

required_cols <- c(
  "tpep_pickup_datetime",
  "tpep_dropoff_datetime",
  "PULocationID",
  "DOLocationID",
  "passenger_count",
  "trip_distance",
  "fare_amount",
  "tip_amount",
  "tolls_amount",
  "total_amount",
  "payment_type"
)

# Keep only columns that exist
required_cols <- required_cols[
  required_cols %in% names(taxi)
]

taxi <- taxi[, ..required_cols]


# ============================================================
# 7. DATA CLEANING
# ============================================================

cat("\n============================================\n")
cat("DATA CLEANING\n")
cat("============================================\n")

# Remove duplicate records
before_duplicates <- nrow(taxi)

taxi <- unique(taxi)

after_duplicates <- nrow(taxi)

cat(
  "Duplicates removed:",
  before_duplicates - after_duplicates,
  "\n"
)


# Remove invalid records
taxi <- taxi[
  !is.na(tpep_pickup_datetime) &
  !is.na(tpep_dropoff_datetime) &
  !is.na(PULocationID) &
  !is.na(DOLocationID) &
  !is.na(trip_distance) &
  !is.na(fare_amount) &
  !is.na(total_amount)
]

# Remove impossible values
taxi <- taxi[
  trip_distance >= 0 &
  fare_amount >= 0 &
  total_amount >= 0 &
  passenger_count >= 0
]

cat("Rows after cleaning:", nrow(taxi), "\n")


# ============================================================
# 8. TEMPORAL FEATURE EXTRACTION
# ============================================================

cat("\n============================================\n")
cat("CREATING TIME FEATURES\n")
cat("============================================\n")

# Convert datetime
taxi[, pickup_datetime :=
      as.POSIXct(
        tpep_pickup_datetime,
        tz = "America/New_York"
      )
]

# Hour
taxi[, hour := hour(pickup_datetime)]

# Day
taxi[, day := day(pickup_datetime)]

# Day of week
taxi[, day_of_week :=
      weekdays(pickup_datetime)
]

# Month
taxi[, month := month(
  pickup_datetime,
  label = TRUE
)]


# ============================================================
# 9. REMOVE UNNECESSARY COLUMNS
# ============================================================

taxi[, tpep_pickup_datetime := NULL]
taxi[, tpep_dropoff_datetime := NULL]


# ============================================================
# 10. LOAD TAXI ZONE LOOKUP
# ============================================================

cat("\n============================================\n")
cat("LOADING TAXI ZONE LOOKUP\n")
cat("============================================\n")

zones <- fread(zone_file)

print(head(zones))


# ============================================================
# 11. JOIN PICKUP ZONE INFORMATION
# ============================================================

setnames(
  zones,
  "LocationID",
  "PULocationID",
  skip_absent = TRUE
)

pickup_zones <- zones[
  ,
  .(
    PULocationID,
    PUZone = Zone,
    PUBorough = Borough
  )
]

taxi <- pickup_zones[
  taxi,
  on = "PULocationID"
]


# ============================================================
# 12. JOIN DROP-OFF ZONE INFORMATION
# ============================================================

zones2 <- fread(zone_file)

setnames(
  zones2,
  "LocationID",
  "DOLocationID",
  skip_absent = TRUE
)

dropoff_zones <- zones2[
  ,
  .(
    DOLocationID,
    DOZone = Zone,
    DOBorough = Borough
  )
]

taxi <- dropoff_zones[
  taxi,
  on = "DOLocationID"
]


cat("\nZone information joined successfully.\n")


# ============================================================
# TASK 2 - TRANSPORTATION DATA ANALYTICS
# ============================================================


# ============================================================
# 13. NUMBER OF TRIPS BY HOUR
# ============================================================

cat("\n============================================\n")
cat("TRIPS BY HOUR\n")
cat("============================================\n")

trips_by_hour <- taxi[
  ,
  .(trips = .N),
  by = hour
][order(hour)]

print(trips_by_hour)


# ============================================================
# 14. TAXI DEMAND BY DAY OF WEEK
# ============================================================

trips_by_day <- taxi[
  ,
  .(trips = .N),
  by = day_of_week
]

print(trips_by_day)


# ============================================================
# 15. MONTHLY TAXI DEMAND
# ============================================================

monthly_demand <- taxi[
  ,
  .(trips = .N),
  by = month
]

print(monthly_demand)


# ============================================================
# 16. AVERAGE FARE BY HOUR
# ============================================================

avg_fare_hour <- taxi[
  ,
  .(
    average_fare = mean(fare_amount, na.rm = TRUE),
    total_revenue = sum(total_amount, na.rm = TRUE)
  ),
  by = hour
][order(hour)]

print(avg_fare_hour)


# ============================================================
# 17. TOP PICKUP-DROPOFF ROUTES
# ============================================================

top_routes <- taxi[
  ,
  .(
    trips = .N,
    total_revenue = sum(total_amount, na.rm = TRUE)
  ),
  by = .(
    PUZone,
    DOZone
  )
][
  order(-trips)
]

cat("\nTop 10 Routes:\n")
print(head(top_routes, 10))


# ============================================================
# 18. HIGHEST REVENUE ROUTES
# ============================================================

highest_revenue_routes <- taxi[
  ,
  .(
    trips = .N,
    total_revenue = sum(total_amount, na.rm = TRUE)
  ),
  by = .(
    PUZone,
    DOZone
  )
][
  order(-total_revenue)
]

cat("\nHighest Revenue Routes:\n")
print(head(highest_revenue_routes, 10))


# ============================================================
# 19. TRIP DISTANCE VS FARE
# ============================================================

distance_fare <- taxi[
  ,
  .(
    average_fare = mean(fare_amount, na.rm = TRUE),
    average_distance = mean(trip_distance, na.rm = TRUE)
  ),
  by = hour
]

print(distance_fare)


# ============================================================
# 20. PAYMENT TYPE ANALYSIS
# ============================================================

payment_analysis <- taxi[
  ,
  .(
    trips = .N,
    total_revenue = sum(total_amount, na.rm = TRUE)
  ),
  by = payment_type
][order(-trips)]

print(payment_analysis)


# ============================================================
# TASK 3 - FUNCTIONAL PROGRAMMING
# ============================================================


# ============================================================
# 21. APPLY()
# ============================================================

cat("\n============================================\n")
cat("FUNCTIONAL PROGRAMMING\n")
cat("============================================\n")

numeric_data <- taxi[
  ,
  .(
    trip_distance,
    fare_amount,
    tip_amount,
    total_amount
  )
]

apply_result <- apply(
  numeric_data,
  2,
  mean,
  na.rm = TRUE
)

cat("\napply() result:\n")
print(apply_result)


# ============================================================
# 22. Lapply()
# ============================================================

numeric_columns <- list(
  trip_distance = taxi$trip_distance,
  fare_amount = taxi$fare_amount,
  tip_amount = taxi$tip_amount,
  total_amount = taxi$total_amount
)

lapply_result <- lapply(
  numeric_columns,
  mean,
  na.rm = TRUE
)

cat("\nlapply() result:\n")
print(lapply_result)


# ============================================================
# 23. PURRR MAP()
# ============================================================

map_result <- map_dbl(
  numeric_columns,
  ~ mean(.x, na.rm = TRUE)
)

cat("\npurrr::map() result:\n")
print(map_result)


# ============================================================
# 24. VECTORIZED OPERATION
# ============================================================

vectorized_result <- c(
  trip_distance = mean(
    taxi$trip_distance,
    na.rm = TRUE
  ),
  fare_amount = mean(
    taxi$fare_amount,
    na.rm = TRUE
  ),
  tip_amount = mean(
    taxi$tip_amount,
    na.rm = TRUE
  ),
  total_amount = mean(
    taxi$total_amount,
    na.rm = TRUE
  )
)

cat("\nVectorized result:\n")
print(vectorized_result)


# ============================================================
# 25. DATA.TABLE IMPLEMENTATION
# ============================================================

datatable_result <- taxi[
  ,
  lapply(
    .(
      trip_distance,
      fare_amount,
      tip_amount,
      total_amount
    ),
    mean,
    na.rm = TRUE
  )
]

cat("\ndata.table result:\n")
print(datatable_result)


# ============================================================
# TASK 4 - SEQUENTIAL PROCESSING
# ============================================================


# ============================================================
# 26. CREATE MONTH/DAY PARTITIONS
# ============================================================

# Use hour partitions for demonstration
partitions <- split(
  taxi,
  by = "hour",
  keep.by = TRUE
)


# ============================================================
# 27. SEQUENTIAL PROCESSING
# ============================================================

cat("\n============================================\n")
cat("SEQUENTIAL PROCESSING\n")
cat("============================================\n")

start_seq <- Sys.time()

sequential_result <- lapply(
  partitions,
  function(x) {
    data.table(
      trips = nrow(x),
      average_fare = mean(
        x$fare_amount,
        na.rm = TRUE
      ),
      total_revenue = sum(
        x$total_amount,
        na.rm = TRUE
      )
    )
  }
)

end_seq <- Sys.time()

sequential_time <- as.numeric(
  difftime(
    end_seq,
    start_seq,
    units = "secs"
  )
)

cat(
  "Sequential time:",
  sequential_time,
  "seconds\n"
)


# ============================================================
# PARALLEL PROCESSING
# ============================================================

cat("\n============================================\n")
cat("PARALLEL PROCESSING\n")
cat("============================================\n")

library(foreach)
library(doParallel)
library(data.table)

# ------------------------------------------------------------
# Create monthly partitions
# month is an ordered factor: Jan, Feb, Mar, ...
# ------------------------------------------------------------

taxi_parts <- list(
  Jan = taxi[month == "Jan"],
  Feb = taxi[month == "Feb"],
  Mar = taxi[month == "Mar"]
)

# Remove empty partitions
taxi_parts <- taxi_parts[
  sapply(taxi_parts, nrow) > 0
]

cat("Number of partitions:", length(taxi_parts), "\n")

# ------------------------------------------------------------
# Use maximum 3 workers because we have 3 partitions
# ------------------------------------------------------------

cores <- min(3, length(taxi_parts))

cat("Number of CPU cores used:", cores, "\n")

# ------------------------------------------------------------
# Create parallel cluster
# ------------------------------------------------------------

cl <- parallel::makeCluster(cores)

doParallel::registerDoParallel(cl)

# ------------------------------------------------------------
# Start timer
# ------------------------------------------------------------

parallel_start <- Sys.time()

# ------------------------------------------------------------
# Parallel monthly processing
# ------------------------------------------------------------

parallel_result <- foreach(
  part = taxi_parts,
  .combine = rbind,
  .packages = "data.table"
) %dopar% {

  dt <- as.data.table(part)

  data.table(
    month = as.character(unique(dt$month)[1]),
    trips = nrow(dt),
    average_fare = mean(dt$fare_amount, na.rm = TRUE),
    total_revenue = sum(dt$total_amount, na.rm = TRUE)
  )
}

# ------------------------------------------------------------
# Stop timer
# ------------------------------------------------------------

parallel_end <- Sys.time()

parallel::stopCluster(cl)

# ------------------------------------------------------------
# Calculate execution time
# ------------------------------------------------------------

parallel_time <- as.numeric(
  difftime(
    parallel_end,
    parallel_start,
    units = "secs"
  )
)

# ------------------------------------------------------------
# Display result
# ------------------------------------------------------------

cat("\nParallel processing result:\n")
print(parallel_result)

cat("\nParallel execution time:",
    round(parallel_time, 4),
    "seconds\n")

# ------------------------------------------------------------
# Calculate speedup
# ------------------------------------------------------------

speedup <- sequential_time / parallel_time

cat("Speedup:",
    round(speedup, 3),
    "x\n")

cat("\n============================================\n")
cat("PARALLEL PROCESSING COMPLETED\n")
cat("============================================\n")


# -------------------------------------------------
# Calculate speedup
# -------------------------------------------------

speedup <- sequential_time / parallel_time

cat("Speedup:",
    round(speedup, 3),
    "x\n")

cat("\n============================================\n")

# ============================================================
# 30. SPEEDUP
# ============================================================



cat("\n============================================\n")
cat("PARALLEL PERFORMANCE\n")
cat("============================================\n")

cat(
  "Sequential Time:",
  sequential_time,
  "seconds\n"
)

cat(
  "Parallel Time:",
  parallel_time,
  "seconds\n"
)

cat(
  "Speedup:",
  speedup,
  "x\n"
)


# ============================================================
# TASK 5 - PERFORMANCE BENCHMARKING
# ============================================================


# ============================================================
# 31. BASE R VS DATA.TABLE
# ============================================================

small_numeric <- taxi$fare_amount

benchmark_results <- microbenchmark(

  Base_R = {
    mean(
      small_numeric,
      na.rm = TRUE
    )
  },

  Vectorized = {
    sum(
      small_numeric,
      na.rm = TRUE
    ) /
      sum(
        !is.na(small_numeric)
      )
  },

  Data_Table = {
    taxi[
      ,
      mean(
        fare_amount,
        na.rm = TRUE
      )
    ]
  },

  times = 10
)

cat("\n============================================\n")
cat("BENCHMARK RESULTS\n")
cat("============================================\n")

print(benchmark_results)

print(summary(benchmark_results))


# ============================================================
# 32. PERFORMANCE COMPARISON TABLE
# ============================================================

performance_table <- data.table(

  Method = c(
    "Sequential",
    "Parallel"
  ),

  Execution_Time_Seconds = c(
    sequential_time,
    parallel_time
  )
)

performance_table[
  ,
  Speedup := sequential_time /
    Execution_Time_Seconds
]

cat("\nPerformance Comparison:\n")
print(performance_table)


# ============================================================
# TASK 6 - DATA VISUALIZATION
# ============================================================


# ============================================================
# 33. TRIPS BY HOUR
# ============================================================

plot_hour <- ggplot(
  trips_by_hour,
  aes(
    x = hour,
    y = trips
  )
) +
  geom_line() +
  geom_point() +
  labs(
    title = "NYC Taxi Trips by Hour",
    x = "Hour of Day",
    y = "Number of Trips"
  ) +
  theme_minimal()

print(plot_hour)


# ============================================================
# 34. TAXI DEMAND BY DAY
# ============================================================

plot_day <- ggplot(
  trips_by_day,
  aes(
    x = day_of_week,
    y = trips
  )
) +
  geom_col() +
  labs(
    title = "Taxi Demand by Day of Week",
    x = "Day",
    y = "Number of Trips"
  ) +
  theme_minimal() +
  theme(
    axis.text.x =
      element_text(angle = 45, hjust = 1)
  )

print(plot_day)


# ============================================================
# 35. AVERAGE FARE BY HOUR
# ============================================================

plot_fare <- ggplot(
  avg_fare_hour,
  aes(
    x = hour,
    y = average_fare
  )
) +
  geom_line() +
  geom_point() +
  labs(
    title = "Average Taxi Fare by Hour",
    x = "Hour",
    y = "Average Fare"
  ) +
  theme_minimal()

print(plot_fare)


# ============================================================
# 36. TRIP DISTANCE VS FARE
# ============================================================

# Sample data to keep visualization fast
plot_data <- taxi[
  sample(
    .N,
    min(.N, 10000)
  )
]

plot_distance <- ggplot(
  plot_data,
  aes(
    x = trip_distance,
    y = fare_amount
  )
) +
  geom_point(alpha = 0.4) +
  labs(
    title = "Trip Distance vs Fare Amount",
    x = "Trip Distance",
    y = "Fare Amount"
  ) +
  theme_minimal()

print(plot_distance)


# ============================================================
# 37. PAYMENT TYPE DISTRIBUTION
# ============================================================

plot_payment <- ggplot(
  payment_analysis,
  aes(
    x = factor(payment_type),
    y = trips
  )
) +
  geom_col() +
  labs(
    title = "Taxi Trips by Payment Type",
    x = "Payment Type",
    y = "Number of Trips"
  ) +
  theme_minimal()

print(plot_payment)


# ============================================================
# TASK 7 - IMPORTANT RESULTS
# ============================================================


cat("\n============================================\n")
cat("IMPORTANT ANALYTICAL RESULTS\n")
cat("============================================\n")


# Peak hour
peak_hour <- trips_by_hour[
  which.max(trips)
]

cat(
  "\nPeak Taxi Hour:",
  peak_hour$hour,
  "\n"
)

cat(
  "Trips during peak hour:",
  peak_hour$trips,
  "\n"
)


# Most popular day
peak_day <- trips_by_day[
  which.max(trips)
]

cat(
  "\nHighest Demand Day:",
  peak_day$day_of_week,
  "\n"
)

cat(
  "Trips:",
  peak_day$trips,
  "\n"
)


# Most popular route
top_route <- top_routes[1]

cat("\nMost Frequent Route:\n")

print(top_route)


# Highest revenue route
revenue_route <- highest_revenue_routes[1]

cat("\nHighest Revenue Route:\n")

print(revenue_route)


# Most common payment type
common_payment <- payment_analysis[1]

cat("\nMost Common Payment Type:\n")

print(common_payment)


# ============================================================
# FINAL RECOMMENDATION
# ============================================================

cat("\n============================================\n")
cat("FINAL CONCLUSION\n")
cat("============================================\n")

cat("
1. data.table is highly suitable for large-scale taxi data
   because it provides efficient filtering, grouping, joining
   and aggregation.

2. Vectorized operations are generally faster than explicit
   loops because they operate efficiently on complete vectors.

3. Functional programming using apply(), lapply() and map()
   provides clean and reusable code.

4. Parallel processing can reduce execution time for
   computationally intensive independent tasks, but it also
   introduces parallelization and data-transfer overhead.

5. The best approach depends on dataset size and operation.
   For large-scale tabular data, data.table is recommended
   as the primary approach.

6. Combining efficient data.table processing, vectorization,
   benchmarking and parallel computing provides a scalable
   analytical workflow.
")


# ============================================================
# END OF LAB ASSIGNMENT
# ============================================================

cat("\n============================================\n")
cat("LAB ASSIGNMENT COMPLETED\n")
cat("============================================\n")



# ============================================================
# SAVE ALL RESULTS, TABLES AND GRAPHS
# ============================================================

cat("\n============================================\n")
cat("SAVING RESULTS AND GRAPHS\n")
cat("============================================\n")

# ------------------------------------------------------------
# Create output folders
# ------------------------------------------------------------

dir.create("results", showWarnings = FALSE)
dir.create("results/graphs", showWarnings = FALSE)
dir.create("results/tables", showWarnings = FALSE)
dir.create("results/benchmarks", showWarnings = FALSE)

# ============================================================
# 1. TRIPS BY HOUR
# ============================================================

trips_by_hour <- taxi[
  ,
  .(trips = .N),
  by = hour
]

setorder(trips_by_hour, hour)

fwrite(
  trips_by_hour,
  "results/tables/trips_by_hour.csv"
)

p_hour <- ggplot(
  trips_by_hour,
  aes(x = hour, y = trips)
) +
  geom_col() +
  labs(
    title = "NYC Yellow Taxi Trips by Hour",
    x = "Hour of Day",
    y = "Number of Trips"
  ) +
  theme_minimal()

print(p_hour)

ggsave(
  "results/graphs/01_trips_by_hour.png",
  p_hour,
  width = 10,
  height = 6,
  dpi = 300
)


# ============================================================
# 2. TRIPS BY DAY OF WEEK
# ============================================================

trips_by_day <- taxi[
  ,
  .(trips = .N),
  by = day_of_week
]

# Correct weekday order
day_order <- c(
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
)

trips_by_day[
  ,
  day_of_week := factor(
    day_of_week,
    levels = day_order
  )
]

setorder(trips_by_day, day_of_week)

fwrite(
  trips_by_day,
  "results/tables/trips_by_day.csv"
)

p_day <- ggplot(
  trips_by_day,
  aes(x = day_of_week, y = trips)
) +
  geom_col() +
  labs(
    title = "NYC Yellow Taxi Trips by Day of Week",
    x = "Day of Week",
    y = "Number of Trips"
  ) +
  theme_minimal()

print(p_day)

ggsave(
  "results/graphs/02_trips_by_day.png",
  p_day,
  width = 10,
  height = 6,
  dpi = 300
)


# ============================================================
# 3. MONTHLY DEMAND
# ============================================================

trips_by_month <- taxi[
  ,
  .(trips = .N),
  by = month
]

month_order <- c(
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
)

trips_by_month[
  ,
  month := factor(
    as.character(month),
    levels = month_order
  )
]

setorder(trips_by_month, month)

fwrite(
  trips_by_month,
  "results/tables/trips_by_month.csv"
)

p_month <- ggplot(
  trips_by_month,
  aes(
    x = month,
    y = trips,
    group = 1
  )
) +
  geom_line() +
  geom_point() +
  labs(
    title = "Monthly Taxi Demand",
    x = "Month",
    y = "Number of Trips"
  ) +
  theme_minimal()

print(p_month)

ggsave(
  "results/graphs/03_monthly_demand.png",
  p_month,
  width = 10,
  height = 6,
  dpi = 300
)


# ============================================================
# 4. AVERAGE FARE BY HOUR
# ============================================================

avg_fare_by_hour <- taxi[
  ,
  .(
    average_fare = mean(
      fare_amount,
      na.rm = TRUE
    ),
    total_revenue = sum(
      total_amount,
      na.rm = TRUE
    )
  ),
  by = hour
]

setorder(avg_fare_by_hour, hour)

fwrite(
  avg_fare_by_hour,
  "results/tables/average_fare_by_hour.csv"
)

p_fare <- ggplot(
  avg_fare_by_hour,
  aes(
    x = hour,
    y = average_fare
  )
) +
  geom_line() +
  geom_point() +
  labs(
    title = "Average Fare by Hour",
    x = "Hour of Day",
    y = "Average Fare ($)"
  ) +
  theme_minimal()

print(p_fare)

ggsave(
  "results/graphs/04_average_fare_by_hour.png",
  p_fare,
  width = 10,
  height = 6,
  dpi = 300
)


# ============================================================
# 5. TOP 10 ROUTES
# ============================================================

top_routes <- taxi[
  !is.na(PUZone) &
  !is.na(DOZone),
  .(
    trips = .N,
    revenue = sum(
      total_amount,
      na.rm = TRUE
    )
  ),
  by = .(
    route = paste(
      PUZone,
      "→",
      DOZone
    )
  )
]

setorder(
  top_routes,
  -trips
)

top_routes <- top_routes[1:min(10, .N)]

fwrite(
  top_routes,
  "results/tables/top_routes.csv"
)

p_routes <- ggplot(
  top_routes,
  aes(
    x = reorder(route, trips),
    y = trips
  )
) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Top 10 Most Frequent Taxi Routes",
    x = "Route",
    y = "Number of Trips"
  ) +
  theme_minimal()

print(p_routes)

ggsave(
  "results/graphs/05_top_routes.png",
  p_routes,
  width = 12,
  height = 8,
  dpi = 300
)


# ============================================================
# 6. PAYMENT METHODS
# ============================================================

payment_summary <- taxi[
  ,
  .(trips = .N),
  by = payment_type
]

payment_summary[
  ,
  payment_type := as.character(payment_type)
]

fwrite(
  payment_summary,
  "results/tables/payment_methods.csv"
)

p_payment <- ggplot(
  payment_summary,
  aes(
    x = payment_type,
    y = trips
  )
) +
  geom_col() +
  labs(
    title = "Taxi Trips by Payment Method",
    x = "Payment Type",
    y = "Number of Trips"
  ) +
  theme_minimal()

print(p_payment)

ggsave(
  "results/graphs/06_payment_methods.png",
  p_payment,
  width = 10,
  height = 6,
  dpi = 300
)


# ============================================================
# 7. DISTANCE VS FARE
# ============================================================

# Use a sample so the 7.9 million point dataset
# does not make the graph unnecessarily huge.

set.seed(123)

distance_sample <- taxi[
  trip_distance > 0 &
  fare_amount > 0
]

if (nrow(distance_sample) > 100000) {
  distance_sample <- distance_sample[
    sample(.N, 100000)
  ]
}

p_distance <- ggplot(
  distance_sample,
  aes(
    x = trip_distance,
    y = fare_amount
  )
) +
  geom_point(
    alpha = 0.2
  ) +
  labs(
    title = "Trip Distance vs Fare Amount",
    x = "Trip Distance (miles)",
    y = "Fare Amount ($)"
  ) +
  theme_minimal()

print(p_distance)

ggsave(
  "results/graphs/07_distance_vs_fare.png",
  p_distance,
  width = 10,
  height = 6,
  dpi = 300
)


# ============================================================
# 8. REVENUE BY HOUR
# ============================================================

revenue_by_hour <- taxi[
  ,
  .(
    total_revenue = sum(
      total_amount,
      na.rm = TRUE
    )
  ),
  by = hour
]

setorder(
  revenue_by_hour,
  hour
)

fwrite(
  revenue_by_hour,
  "results/tables/revenue_by_hour.csv"
)

p_revenue <- ggplot(
  revenue_by_hour,
  aes(
    x = hour,
    y = total_revenue
  )
) +
  geom_col() +
  labs(
    title = "Total Taxi Revenue by Hour",
    x = "Hour of Day",
    y = "Total Revenue ($)"
  ) +
  theme_minimal()

print(p_revenue)

ggsave(
  "results/graphs/08_revenue_by_hour.png",
  p_revenue,
  width = 10,
  height = 6,
  dpi = 300
)


# ============================================================
# 9. SAVE BENCHMARK RESULTS
# ============================================================

if (
  exists("sequential_time") &&
  exists("parallel_time")
) {

  benchmark_results <- data.table(
    Method = c(
      "Sequential",
      "Parallel"
    ),
    Execution_Time_Seconds = c(
      sequential_time,
      parallel_time
    )
  )

  benchmark_results[
    ,
    Speedup := sequential_time /
      Execution_Time_Seconds
  ]

  fwrite(
    benchmark_results,
    "results/benchmarks/benchmark_results.csv"
  )

  print(benchmark_results)
}


# ============================================================
# 10. SAVE SUMMARY
# ============================================================

summary_results <- data.table(
  Metric = c(
    "Total cleaned trips",
    "Average trip distance",
    "Average fare",
    "Average tip",
    "Average total amount"
  ),
  Value = c(
    nrow(taxi),
    mean(taxi$trip_distance, na.rm = TRUE),
    mean(taxi$fare_amount, na.rm = TRUE),
    mean(taxi$tip_amount, na.rm = TRUE),
    mean(taxi$total_amount, na.rm = TRUE)
  )
)

fwrite(
  summary_results,
  "results/tables/summary_statistics.csv"
)


# ============================================================
# COMPLETE
# ============================================================

cat("\n============================================\n")
cat("ALL RESULTS SAVED SUCCESSFULLY\n")
cat("============================================\n")

cat("\nGraphs saved in:\n")
cat("results/graphs/\n")

cat("\nTables saved in:\n")
cat("results/tables/\n")

cat("\nBenchmark saved in:\n")
cat("results/benchmarks/\n")