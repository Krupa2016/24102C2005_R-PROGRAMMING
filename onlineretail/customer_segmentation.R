 # ============================================================
# CUSTOMER SEGMENTATION & PREDICTIVE ANALYTICS
# R implementation for VS Code
# Dataset: UCI Online Retail (Excel or CSV)
#
# Before running:
# 1. Download the UCI Online Retail dataset.
# 2. Put Online Retail.xlsx (or Online Retail.csv) in this folder.
# 3. In VS Code, open this file and run it with the R extension.
#    Alternatively: source("customer_segmentation.R")
#
# Outputs are saved in ./outputs/
# ============================================================

# ------------------------- 0. Setup ---------------------------

required_packages <- c(
  "readxl", "dplyr", "tidyr", "ggplot2", "cluster", "factoextra",
  "caret", "randomForest", "e1071", "pROC", "plotly", "htmlwidgets",
  "scales"
)

missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]
if (length(missing_packages) > 0) {
  install.packages(missing_packages, repos = "https://cloud.r-project.org")
}

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(ggplot2)
  library(cluster)
  library(caret)
  library(randomForest)
  library(e1071)
  library(pROC)
  library(plotly)
  library(htmlwidgets)
  library(scales)
})

set.seed(42)
OUTPUT_DIR <- "outputs"
dir.create(OUTPUT_DIR, showWarnings = FALSE)

# Set this to your dataset path if it is not in the working directory.
DATA_PATH <- "Online Retail.xlsx"

# ---------------------- 1. Load data --------------------------

if (!file.exists(DATA_PATH)) {
  candidates <- c("Online Retail.xlsx", "Online Retail.csv",
                  "online_retail.xlsx", "online_retail.csv")
  found <- candidates[file.exists(candidates)]
  if (length(found) > 0) {
    DATA_PATH <- found[1]
  } else {
    message("Dataset not found in the working directory. Select the file...")
    DATA_PATH <- file.choose()
  }
}

if (grepl("\\.xlsx?$", DATA_PATH, ignore.case = TRUE)) {
  raw <- readxl::read_excel(DATA_PATH)
} else if (grepl("\\.csv$", DATA_PATH, ignore.case = TRUE)) {
  raw <- read.csv(DATA_PATH, stringsAsFactors = FALSE,
                  check.names = FALSE)
} else {
  stop("Unsupported file. Use an .xlsx or .csv dataset.")
}

names(raw) <- trimws(names(raw))
required_cols <- c("InvoiceNo", "Quantity", "InvoiceDate",
                   "UnitPrice", "CustomerID")
missing_cols <- setdiff(required_cols, names(raw))
if (length(missing_cols) > 0) {
  stop("Missing required columns: ", paste(missing_cols, collapse = ", "),
       ". Check that you loaded the UCI Online Retail dataset.")
}

cat("\nRaw rows:", nrow(raw), "\n")
cat("Raw columns:", paste(names(raw), collapse = ", "), "\n")

# -------------------- 2. Preprocessing ------------------------

# Convert fields safely; remove missing customer IDs, cancellations,
# non-positive quantities and non-positive prices.
retail <- raw %>%
  mutate(
    CustomerID = as.character(CustomerID),
    InvoiceNo = as.character(InvoiceNo),
    Quantity = suppressWarnings(as.numeric(Quantity)),
    UnitPrice = suppressWarnings(as.numeric(UnitPrice)),
    InvoiceDate = as.POSIXct(InvoiceDate, tz = "UTC")
  ) %>%
  filter(
    !is.na(CustomerID), CustomerID != "", !is.na(InvoiceDate),
    !is.na(Quantity), !is.na(UnitPrice),
    !grepl("^C", InvoiceNo, ignore.case = TRUE),
    Quantity > 0, UnitPrice > 0
  ) %>%
  mutate(TotalPrice = Quantity * UnitPrice)

if (nrow(retail) == 0) stop("No usable rows remain after preprocessing.")

# Cap extreme transaction values at the 99th percentile to reduce
# the influence of outliers (retained rows are not deleted).
upper_cap <- quantile(retail$TotalPrice, 0.99, na.rm = TRUE)
retail <- retail %>% mutate(TotalPrice = pmin(TotalPrice, upper_cap))

write.csv(retail, file.path(OUTPUT_DIR, "cleaned_transactions.csv"),
          row.names = FALSE)

# ---------------- 3. Customer-level feature engineering -------

analysis_date <- max(retail$InvoiceDate, na.rm = TRUE) + 1

rfm <- retail %>%
  group_by(CustomerID) %>%
  summarise(
    Recency = as.numeric(difftime(analysis_date,
                                  max(InvoiceDate), units = "days")),
    Frequency = n_distinct(InvoiceNo),
    Monetary = sum(TotalPrice, na.rm = TRUE),
    AvgTransactionValue = Monetary / pmax(Frequency, 1),
    TotalQuantity = sum(Quantity, na.rm = TRUE),
    PurchaseFrequency = Frequency /
      pmax(as.numeric(difftime(max(InvoiceDate), min(InvoiceDate),
                               units = "days")) + 1, 1),
    .groups = "drop"
  ) %>%
  filter(if_all(where(is.numeric), is.finite))

if (nrow(rfm) < 4) stop("Not enough customers for clustering.")

write.csv(rfm, file.path(OUTPUT_DIR, "customer_features_RFM.csv"),
          row.names = FALSE)

feature_cols <- c("Recency", "Frequency", "Monetary",
                  "AvgTransactionValue", "TotalQuantity",
                  "PurchaseFrequency")

# Log transform skewed non-negative features, then standardize.
model_features <- rfm %>%
  select(all_of(feature_cols)) %>%
  mutate(across(everything(), ~ log1p(pmax(.x, 0))))

scaled_features <- scale(model_features)
scaled_features[!is.finite(scaled_features)] <- 0

# -------------------- 4. Elbow method -------------------------

max_k <- min(10, nrow(rfm) - 1)
wss <- sapply(1:max_k, function(k) {
  kmeans(scaled_features, centers = k, nstart = 25)$tot.withinss
})

elbow_df <- data.frame(Clusters = 1:max_k, WSS = wss)
p_elbow <- ggplot(elbow_df, aes(Clusters, WSS)) +
  geom_line() + geom_point(size = 3) +
  scale_x_continuous(breaks = 1:max_k) +
  labs(title = "Elbow Method for K-Means",
       x = "Number of clusters (k)", y = "Within-cluster sum of squares") +
  theme_minimal()
ggsave(file.path(OUTPUT_DIR, "01_elbow_method.png"),
       p_elbow, width = 8, height = 5, dpi = 300)
print(p_elbow)

# Choose k after inspecting the elbow graph. Default is 4.
# Change this value if your elbow plot suggests another k.
K <- min(4, max_k)
set.seed(42)
km <- kmeans(scaled_features, centers = K, nstart = 50)
rfm$Cluster <- factor(km$cluster)

# -------------------- 5. Silhouette score ---------------------

sil <- silhouette(km$cluster, dist(scaled_features))
silhouette_avg <- mean(sil[, "sil_width"])
cat("\nK-Means k =", K, "\nAverage silhouette score =",
    round(silhouette_avg, 4), "\n")

png(file.path(OUTPUT_DIR, "02_silhouette_plot.png"),
    width = 1200, height = 800, res = 150)
plot(sil, main = paste("Silhouette Plot (K =", K, ")"))
dev.off()

# ---------------- 6. Hierarchical clustering ------------------

# Use a reproducible sample for the dendrogram if there are many customers.
set.seed(42)
sample_n <- min(1000, nrow(scaled_features))
sample_idx <- sample(seq_len(nrow(scaled_features)), sample_n)
hc <- hclust(dist(scaled_features[sample_idx, , drop = FALSE]),
             method = "ward.D2")

png(file.path(OUTPUT_DIR, "03_hierarchical_dendrogram.png"),
    width = 1400, height = 900, res = 150)
plot(hc, labels = FALSE, hang = -1,
     main = "Hierarchical Clustering Dendrogram (sample)",
     xlab = "Customers", ylab = "Height")
rect.hclust(hc, k = K, border = 2:(K + 1))
dev.off()

hc_groups <- cutree(hc, k = K)
hc_sil <- silhouette(hc_groups,
                     dist(scaled_features[sample_idx, , drop = FALSE]))
cat("Hierarchical sample silhouette score =",
    round(mean(hc_sil[, "sil_width"]), 4), "\n")

# -------------------- 7. PCA visualization --------------------

pca <- prcomp(scaled_features, center = FALSE, scale. = FALSE)
pca_df <- data.frame(
  PC1 = pca$x[, 1],
  PC2 = pca$x[, 2],
  Cluster = rfm$Cluster
)

p_pca <- ggplot(pca_df, aes(PC1, PC2, color = Cluster)) +
  geom_point(alpha = 0.65, size = 1.6) +
  labs(title = "Customer Segments: 2D PCA Projection",
       x = "Principal Component 1", y = "Principal Component 2") +
  theme_minimal()
ggsave(file.path(OUTPUT_DIR, "04_pca_clusters.png"),
       p_pca, width = 8, height = 6, dpi = 300)
print(p_pca)

# -------------------- 8. Cluster profiling --------------------

cluster_profile <- rfm %>%
  group_by(Cluster) %>%
  summarise(
    Customers = n(),
    across(all_of(feature_cols), ~ mean(.x, na.rm = TRUE)),
    .groups = "drop"
  )

write.csv(cluster_profile,
          file.path(OUTPUT_DIR, "05_cluster_profiles.csv"),
          row.names = FALSE)
print(cluster_profile)

# Define the high-value segment as the cluster with the highest
# average Monetary value. This is a data-driven operational definition.
high_value_cluster <- as.character(
  cluster_profile$Cluster[which.max(cluster_profile$Monetary)]
)
rfm$HighValue <- factor(
  ifelse(as.character(rfm$Cluster) == high_value_cluster, "Yes", "No"),
  levels = c("No", "Yes")
)
cat("\nHigh-value cluster:", high_value_cluster, "\n")

# -------------------- 9. Supervised models --------------------

# Avoid leakage: Cluster is used to create the target, not as a predictor.
# Stratified split; scale predictors using training data only.
set.seed(42)
train_idx <- createDataPartition(rfm$HighValue, p = 0.80, list = FALSE)
train_df <- rfm[train_idx, ]
test_df <- rfm[-train_idx, ]

x_train <- model_features[train_idx, , drop = FALSE]
x_test <- model_features[-train_idx, , drop = FALSE]

train_means <- apply(x_train, 2, mean)
train_sds <- apply(x_train, 2, sd)
train_sds[is.na(train_sds) | train_sds == 0] <- 1

x_train_scaled <- scale(x_train, center = train_means, scale = train_sds)
x_test_scaled <- scale(x_test, center = train_means, scale = train_sds)

train_labels <- train_df$HighValue
test_labels <- test_df$HighValue

# Random Forest
set.seed(42)
rf_model <- randomForest(
  x = as.data.frame(x_train_scaled),
  y = train_labels,
  ntree = 300,
  importance = TRUE
)
rf_pred <- predict(rf_model, newdata = as.data.frame(x_test_scaled))
rf_prob <- predict(rf_model, newdata = as.data.frame(x_test_scaled),
                   type = "prob")[, "Yes"]

# SVM with radial kernel and probability estimates
set.seed(42)
svm_model <- e1071::svm(
  x = as.data.frame(x_train_scaled),
  y = train_labels,
  kernel = "radial",
  probability = TRUE,
  scale = FALSE
)
svm_pred_obj <- predict(svm_model, as.data.frame(x_test_scaled),
                        probability = TRUE)
svm_pred <- factor(as.character(svm_pred_obj), levels = levels(test_labels))
svm_prob <- attr(svm_pred_obj, "probabilities")[, "Yes"]

# -------------------- 10. Evaluation --------------------------

evaluate_model <- function(actual, predicted, probability, model_name) {
  actual <- factor(actual, levels = c("No", "Yes"))
  predicted <- factor(predicted, levels = c("No", "Yes"))
  cm <- confusionMatrix(predicted, actual, positive = "Yes")
  roc_obj <- pROC::roc(response = actual, predictor = as.numeric(probability),
                       levels = c("No", "Yes"), direction = "<",
                       quiet = TRUE)
  data.frame(
    Model = model_name,
    Accuracy = unname(cm$overall["Accuracy"]),
    Precision = unname(cm$byClass["Precision"]),
    Recall = unname(cm$byClass["Recall"]),
    F1 = unname(cm$byClass["F1"]),
    ROC_AUC = as.numeric(pROC::auc(roc_obj))
  )
}

metrics <- bind_rows(
  evaluate_model(test_labels, rf_pred, rf_prob, "Random Forest"),
  evaluate_model(test_labels, svm_pred, svm_prob, "SVM")
)
write.csv(metrics, file.path(OUTPUT_DIR, "06_model_metrics.csv"),
          row.names = FALSE)
print(metrics)

png(file.path(OUTPUT_DIR, "07_random_forest_confusion_matrix.png"),
    width = 900, height = 700, res = 130)
print(confusionMatrix(rf_pred, test_labels, positive = "Yes"))
dev.off()

png(file.path(OUTPUT_DIR, "08_svm_confusion_matrix.png"),
    width = 900, height = 700, res = 130)
print(confusionMatrix(svm_pred, test_labels, positive = "Yes"))
dev.off()

# ROC curves
rf_roc <- roc(test_labels, rf_prob, levels = c("No", "Yes"),
              direction = "<", quiet = TRUE)
svm_roc <- roc(test_labels, svm_prob, levels = c("No", "Yes"),
               direction = "<", quiet = TRUE)
png(file.path(OUTPUT_DIR, "09_roc_curves.png"),
    width = 1000, height = 800, res = 140)
plot(rf_roc, col = "blue", main = "ROC Curves: Random Forest vs SVM")
plot(svm_roc, col = "red", add = TRUE)
legend("bottomright",
       legend = c(paste0("Random Forest AUC = ", round(auc(rf_roc), 3)),
                  paste0("SVM AUC = ", round(auc(svm_roc), 3))),
       col = c("blue", "red"), lwd = 2)
dev.off()

# Random Forest feature importance
importance_df <- as.data.frame(randomForest::importance(rf_model))
importance_df$Feature <- rownames(importance_df)
importance_df <- importance_df %>%
  arrange(desc(MeanDecreaseGini))
write.csv(importance_df,
          file.path(OUTPUT_DIR, "10_feature_importance.csv"),
          row.names = FALSE)

p_importance <- ggplot(importance_df,
                       aes(x = reorder(Feature, MeanDecreaseGini),
                           y = MeanDecreaseGini)) +
  geom_col() + coord_flip() +
  labs(title = "Random Forest Feature Importance",
       x = "Feature", y = "Mean Decrease Gini") +
  theme_minimal()
ggsave(file.path(OUTPUT_DIR, "11_feature_importance.png"),
       p_importance, width = 8, height = 5, dpi = 300)
print(p_importance)

# -------------------- 11. Interactive 3D Plotly ----------------

pca3 <- prcomp(scaled_features, center = FALSE, scale. = FALSE)
pca3_df <- data.frame(
  PC1 = pca3$x[, 1],
  PC2 = pca3$x[, 2],
  PC3 = pca3$x[, 3],
  Cluster = rfm$Cluster,
  CustomerID = rfm$CustomerID
)

plot3d <- plot_ly(
  data = pca3_df, x = ~PC1, y = ~PC2, z = ~PC3,
  color = ~Cluster, text = ~paste("Customer:", CustomerID,
                                  "<br>Cluster:", Cluster),
  type = "scatter3d", mode = "markers",
  marker = list(size = 3, opacity = 0.7)
) %>%
  layout(title = "Interactive 3D PCA Customer Clusters",
         scene = list(
           xaxis = list(title = "PC1"),
           yaxis = list(title = "PC2"),
           zaxis = list(title = "PC3")
         ))


htmlwidgets::saveWidget(
  plot3d,
  file.path(OUTPUT_DIR, "12_interactive_3d_clusters.html"),
  selfcontained = FALSE
)

# -------------------- 12. Marketing recommendations -----------

recommendations <- cluster_profile %>%
  mutate(
    Segment = case_when(
      as.character(Cluster) == high_value_cluster ~ "High-value customers",
      Monetary >= median(cluster_profile$Monetary) &
        Recency <= median(cluster_profile$Recency) ~ "Potential loyal customers",
      Recency > median(cluster_profile$Recency) ~ "At-risk / inactive customers",
      TRUE ~ "Regular / developing customers"
    ),
    Recommendation = case_when(
      Segment == "High-value customers" ~
        "VIP rewards, loyalty benefits, early access, and personalized offers.",
      Segment == "Potential loyal customers" ~
        "Cross-sell complementary products and encourage repeat purchases.",
      Segment == "At-risk / inactive customers" ~
        "Win-back campaigns, targeted discounts, and re-engagement emails.",
      TRUE ~
        "Nurture with product recommendations, bundles, and loyalty points."
    )
  )

write.csv(recommendations,
          file.path(OUTPUT_DIR, "13_marketing_recommendations.csv"),
          row.names = FALSE)
print(recommendations)

# -------------------- 13. Summary ------------------------------

summary_lines <- c(
  "CUSTOMER SEGMENTATION & PREDICTIVE ANALYTICS - RESULTS",
  paste("Customers analysed:", nrow(rfm)),
  paste("K-Means clusters:", K),
  paste("K-Means average silhouette:", round(silhouette_avg, 4)),
  paste("High-value cluster:", high_value_cluster),
  "",
  "Model metrics:",
  capture.output(print(metrics)),
  "",
  "Cluster profile:",
  capture.output(print(cluster_profile)),
  "",
  "Marketing recommendations:",
  capture.output(print(recommendations))
)
writeLines(summary_lines, file.path(OUTPUT_DIR, "14_results_summary.txt"))

cat("\nDone! All tables, plots, and the interactive 3D visualization are in: ",
    normalizePath(OUTPUT_DIR), "\n")
