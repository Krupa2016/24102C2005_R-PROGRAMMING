# Customer Segmentation and Predictive Analytics (R)

An R implementation of customer segmentation and high-value customer classification using the UCI Online Retail dataset.

## Overview

This project analyzes e-commerce transaction data to discover customer groups and classify customers belonging to the highest-monetary-value cluster. It includes preprocessing, RFM-style feature engineering, K-Means, hierarchical clustering, silhouette analysis, PCA, Random Forest, SVM, model evaluation, feature importance, and marketing recommendations.

> **Assignment note:** The supplied lab statement mentions Python/Google Colab in its submission instructions, while its justification refers to R. This repository contains the R implementation. Confirm the accepted language and submission format with the instructor.

## Dataset

- **Name:** UCI Online Retail
- **Source:** https://archive.ics.uci.edu/dataset/352/online+retail
- **Raw rows loaded in this run:** 541,909
- **Required input file:** `Online Retail.xlsx` (CSV is also supported)

Download the dataset and place `Online Retail.xlsx` in the project root, next to `customer_segmentation.R`.

## Requirements

- R 4.6.1 (or a compatible recent R version)
- Visual Studio Code with an R extension, or RStudio
- Internet access for first-time package installation

The script checks and installs the following packages if they are missing:

`readxl`, `dplyr`, `tidyr`, `ggplot2`, `cluster`, `factoextra`, `caret`, `randomForest`, `e1071`, `pROC`, `plotly`, `htmlwidgets`, `scales`.

## Run the project

1. Clone this repository:
   ```bash
   git clone <YOUR_REPOSITORY_URL>
   cd <YOUR_REPOSITORY_FOLDER>
   ```
2. Download the UCI dataset and place `Online Retail.xlsx` in the project root.
3. Open the folder in VS Code.
4. Open an R terminal and run:
   ```r
   source("customer_segmentation.R")
   ```

The script creates an `outputs/` directory automatically.

## Workflow

1. **Preprocessing:** removes missing customer IDs/dates, cancellation invoices, non-positive quantities, and non-positive prices; calculates transaction value and caps it at the 99th percentile.
2. **Feature engineering:** creates Recency, Frequency, Monetary, Average Transaction Value, Total Quantity, and Purchase Frequency per customer.
3. **Scaling:** applies `log1p` to non-negative features and standardizes them.
4. **Clustering:** runs K-Means with `k = 4`; creates an elbow plot and computes silhouette score.
5. **Hierarchical clustering:** uses Ward's method on a reproducible sample of up to 1,000 customers and creates a dendrogram.
6. **PCA:** produces a 2D segment plot and an interactive 3D Plotly HTML visualization.
7. **Classification:** defines the high-value class as the K-Means cluster with the highest mean Monetary value; trains Random Forest and radial SVM with an 80/20 stratified split.
8. **Evaluation:** reports Accuracy, Precision, Recall, F1, ROC-AUC, confusion matrices, and Random Forest feature importance.
9. **Recommendations:** creates segment-wise marketing suggestions.

## Results from the executed run

### Clustering

- Customers analyzed: **4,338**
- K-Means clusters: **4**
- K-Means average silhouette: **0.3135**
- Hierarchical sample average silhouette: **0.2709**
- High-value segment: **Cluster 3**

| Cluster | Customers | Mean Recency (days) | Mean Frequency | Mean Monetary |
|---|---:|---:|---:|---:|
| 1 | 754 | 167.0 | 1.16 | 145 |
| 2 | 871 | 145.0 | 1.09 | 533 |
| 3 | 1,039 | 23.3 | 11.0 | 5,365 |
| 4 | 1,674 | 73.6 | 3.17 | 832 |

### Classification

| Model | Accuracy | Precision | Recall | F1 | ROC-AUC |
|---|---:|---:|---:|---:|---:|
| Random Forest | 0.9896 | 0.9760 | 0.9807 | 0.9783 | 0.9995 |
| SVM | 0.9942 | 0.9856 | 0.9903 | 0.9880 | 0.9998 |

SVM performed slightly better on the held-out test set in this run.

## Output files

The script writes generated files to `outputs/`, including:

- `cleaned_transactions.csv`
- `customer_features_RFM.csv`
- `01_elbow_method.png`
- `02_silhouette_plot.png`
- `03_hierarchical_dendrogram.png`
- `04_pca_clusters.png`
- `05_cluster_profiles.csv`
- `06_model_metrics.csv`
- `07_random_forest_confusion_matrix.png`
- `08_svm_confusion_matrix.png`
- `09_roc_curves.png`
- `10_feature_importance.csv`
- `11_feature_importance.png`
- `12_interactive_3d_clusters.html`
- `13_marketing_recommendations.csv`
- `14_results_summary.txt`

## Important interpretation caveat

The target label is created from the K-Means cluster assignment, and the classifiers use the same customer features that were used for clustering. Therefore, the high accuracy values indicate how well the models reproduce the cluster-derived label; they do **not** prove that the models forecast future customer value. The hierarchical silhouette is calculated on a sample, so it is not a strictly like-for-like comparison with the full-data K-Means score.

## Repository structure

```text
.
├── customer_segmentation.R
├── Online Retail.xlsx       # Download separately; do not commit if repository size is an issue
├── outputs/                 # Generated after running the script
└── README.md
```

## License

For academic and educational use. Dataset rights and terms remain with the dataset provider.
