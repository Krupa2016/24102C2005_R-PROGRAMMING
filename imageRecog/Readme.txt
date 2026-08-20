# Image Recognition and Classification with R

A simple **image recognition and binary image classification project** implemented in **R** using **EBImage, Keras, and TensorFlow**.

The project demonstrates how images can be loaded, explored, resized, reshaped, converted into numerical feature vectors, and classified using a neural network.

## 📌 Project Overview

This project performs binary image classification using a feed-forward neural network.

The workflow is:

```text
Input Images
     ↓
Image Loading using EBImage
     ↓
Image Exploration
     ↓
Resize to 28 × 28
     ↓
Reshape into 2352 features
     ↓
Training / Testing Split
     ↓
One-Hot Encoding
     ↓
Neural Network
     ↓
Model Training
     ↓
Evaluation & Prediction
```

Each image is converted into a numerical representation of:

```text
28 × 28 × 3 = 2352 features
```

where `3` represents the RGB color channels.

## 🛠️ Technologies Used

* **R**
* **EBImage** – image processing and manipulation
* **Keras** – neural network API
* **TensorFlow** – deep learning backend
* **Reticulate** – Python/TensorFlow integration

## 🧠 Neural Network Architecture

The model uses a Sequential neural network:

```text
Input Layer
2352 features
     ↓
Dense Layer
256 neurons
ReLU activation
     ↓
Dense Layer
128 neurons
ReLU activation
     ↓
Output Layer
2 neurons
Softmax activation
```

### Model Configuration

| Parameter         |                    Value |
| ----------------- | -----------------------: |
| Input features    |                     2352 |
| Hidden layer 1    |              256 neurons |
| Hidden layer 2    |              128 neurons |
| Output classes    |                        2 |
| Activation        |                     ReLU |
| Output activation |                  Softmax |
| Optimizer         |                  RMSprop |
| Loss function     | Categorical Crossentropy |
| Epochs            |                       30 |
| Batch size        |                        2 |

## 📂 Dataset Structure

The project uses 12 images divided into two classes.

```text
imageRecog/
│
├── imageR.r
│
├── p1.jpg
├── p2.jpg
├── p3.jpg
├── p4.jpg
├── p5.jpg
├── p6.jpg
│
├── c1.jpg
├── c2.jpg
├── c3.jpg
├── c4.jpg
└── c5.jpg
├── c6.jpg
```

### Training Data

* `p1.jpg` – `p5.jpg` → Class `0`
* `c1.jpg` – `c5.jpg` → Class `1`

### Test Data

* `p6.jpg` → Class `0`
* `c6.jpg` → Class `1`

The training dataset contains **10 images**, while **2 images are reserved for testing**.

## ⚙️ Image Preprocessing

### 1. Image Loading

Images are loaded using the `EBImage` package.

```r
mypic <- list()

for (i in 1:12) {
  mypic[[i]] <- readImage(pics[i])
}
```

### 2. Resizing

Because the original images have different dimensions, all images are resized to:

```text
28 × 28 pixels
```

```r
for (i in 1:12) {
  mypic[[i]] <- resize(mypic[[i]], 28, 28)
}
```

### 3. Reshaping

Each RGB image is converted into a vector containing:

```text
28 × 28 × 3 = 2352
```

features.

The resulting training matrix has the shape:

```text
10 × 2352
```

## 🏷️ Labels

The two classes are represented numerically:

```text
Class 0 → p images
Class 1 → c images
```

Training labels:

```r
trainy <- c(0,0,0,0,0,1,1,1,1,1)
```

Testing labels:

```r
testy <- c(0,1)
```

The labels are converted into one-hot encoded vectors:

```text
0 → [1, 0]
1 → [0, 1]
```

## 🚀 Model Training

The neural network is trained for **30 epochs** with a batch size of **2**.

During training, the model reached:

```text
Training Accuracy: 100%
```

The final training loss was approximately:

```text
0.000086
```

The model's training evaluation produced:

```text
Loss:     0.000073
Accuracy: 100%
```

> **Note:** The dataset contains only 10 training images, so the 100% training accuracy should not be interpreted as evidence of strong generalization. The held-out test images provide a better indication of performance on unseen data.

## ▶️ How to Run

### 1. Install R

Install R and make sure it is available in your system.

### 2. Install Required R Packages

Install the required packages:

```r
install.packages("BiocManager")
BiocManager::install("EBImage")

install.packages("keras")
install.packages("reticulate")
```

### 3. Install TensorFlow

TensorFlow is required as the deep-learning backend.

The project uses the Python environment managed through `reticulate`.

### 4. Set the Project Directory

In `imageR.r`, set the working directory to the location of the project:

```r
setwd("D:/Downloads/imageRecog")
```

Change this path to your own project location.

### 5. Run the Program

From the R terminal:

```r
source("D:/Downloads/imageRecog/imageR.r")
```

## 📊 Results

The model successfully completed all **30 training epochs**.

Example final training output:

```text
Epoch 30/30
5/5
accuracy: 1.0000
loss: 8.6002e-05
```

Training evaluation:

```text
Loss:     7.324915e-05
Accuracy: 1.000000
```

This indicates that the model correctly classified all training samples.

## ⚠️ Limitations

1. **Very small dataset**
   Only 10 images are used for training and 2 for testing.

2. **Risk of overfitting**
   A 100% training accuracy with such a small dataset can indicate that the model has memorized the training examples.

3. **Limited generalization**
   More images are required to reliably evaluate performance on unseen images.

4. **Simple neural network**
   The project uses fully connected dense layers rather than a CNN, which is generally more suitable for image classification.

5. **Legacy Keras compatibility**
   The original project was written using an older R Keras API. The implementation has been adapted to work with the current TensorFlow/Keras environment.

## 🔮 Future Improvements

* Increase the size of the dataset.
* Use data augmentation such as rotation, scaling, and flipping.
* Replace the dense network with a **Convolutional Neural Network (CNN)**.
* Add a proper train/validation/test split.
* Calculate precision, recall, F1-score, and confusion matrix.
* Add visualization of training loss and accuracy.
* Use transfer learning with pretrained CNN architectures.
* Add an interface for uploading a new image and predicting its class.

## 📁 Project Files

```text
imageRecog/
│
├── imageR.r       # Main R implementation
├── p1.jpg         # Class 0 training image
├── p2.jpg         # Class 0 training image
├── p3.jpg         # Class 0 training image
├── p4.jpg         # Class 0 training image
├── p5.jpg         # Class 0 training image
├── p6.jpg         # Class 0 test image
├── c1.jpg         # Class 1 training image
├── c2.jpg         # Class 1 training image
├── c3.jpg         # Class 1 training image
├── c4.jpg         # Class 1 training image
├── c5.jpg         # Class 1 training image
└── c6.jpg         # Class 1 test image
```

