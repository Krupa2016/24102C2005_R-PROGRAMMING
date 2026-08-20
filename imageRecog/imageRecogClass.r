# Krupa gurav
# 24102C2005
# BE CMPN C
# Image Recognition and Classification with R.

# Load Packages
library(EBImage)
library(keras)

# To install EBimage package, you can run following 2 lines;
# install.packages("BiocManager") 
# BiocManager::install("EBImage")

# Read images
setwd("D:/Downloads/imageRecog")
pics <- c('p1.jpg', 'p2.jpg', 'p3.jpg', 'p4.jpg', 'p5.jpg', 'p6.jpg',
          'c1.jpg', 'c2.jpg', 'c3.jpg', 'c4.jpg', 'c5.jpg', 'c6.jpg')
mypic <- list()
for (i in 1:12) {mypic[[i]] <- readImage(pics[i])}

# Explore
print(mypic[[1]])
display(mypic[[8]])
summary(mypic[[1]])
hist(mypic[[2]])
str(mypic)

# Resize
for (i in 1:12) {mypic[[i]] <- resize(mypic[[i]], 28, 28)}

# Reshape
for (i in 1:12) {
  mypic[[i]] <- array_reshape(mypic[[i]], c(1, 2352))
}

# Row Bind
# Row Bind
trainx <- NULL

# First class: p1 to p5
for (i in 1:5) {
  trainx <- rbind(trainx, mypic[[i]])
}

# Second class: c1 to c5
for (i in 7:11) {
  trainx <- rbind(trainx, mypic[[i]])
}
str(trainx)

# Test data: p6 and c6
testx <- rbind(mypic[[6]], mypic[[12]])
trainy <- c(0,0,0,0,0,1,1,1,1,1)
testy <- c(0,1)

# One Hot Encoding
trainLabels <- matrix(0, nrow = length(trainy), ncol = 2)
trainLabels[cbind(seq_along(trainy), trainy + 1)] <- 1

testLabels <- matrix(0, nrow = length(testy), ncol = 2)
testLabels[cbind(seq_along(testy), testy + 1)] <- 1

# Model
# Model
model <- keras_model_sequential()

model$add(
  layer_input(shape = c(2352))
)

model$add(
  layer_dense(
    units = 256,
    activation = "relu"
  )
)

model$add(
  layer_dense(
    units = 128,
    activation = "relu"
  )
)

model$add(
  layer_dense(
    units = 2,
    activation = "softmax"
  )
)
summary(model)

# Compile
# Compile
model$compile(
  loss = "categorical_crossentropy",
  optimizer = "rmsprop",
  metrics = list("accuracy")
)

# Fit Model
library(reticulate)
np <- import("numpy")
x_train_py <- np$array(trainx, dtype = "float32")
y_train_py <- np$array(trainLabels, dtype = "float32")
history <- model$fit(
  x = x_train_py,
  y = y_train_py,
  epochs = 30L,
  batch_size = 2L,
  verbose = 1L
)

# Evaluation & Prediction - train data
# Evaluation & Prediction - train data

# Evaluate model
train_results <- model$evaluate(
  x = x_train_py,
  y = y_train_py,
  verbose = 0L
)

print(train_results)

# Predict probabilities
prob <- model$predict(
  x = x_train_py,
  verbose = 0L
)

# Convert probabilities to class predictions
pred <- apply(prob, 1, which.max) - 1

# Confusion table
table(
  Predicted = pred,
  Actual = trainy
)

# Display probabilities and predictions
cbind(
  prob,
  Predicted = pred,
  Actual = trainy
)


# Test data evaluation

x_test_py <- np$array(testx, dtype = "float32")
y_test_py <- np$array(testLabels, dtype = "float32")

test_results <- model$evaluate(
  x = x_test_py,
  y = y_test_py,
  verbose = 0L
)

print(test_results)


# Test predictions

test_prob <- model$predict(
  x = x_test_py,
  verbose = 0L
)

test_pred <- apply(test_prob, 1, which.max) - 1

print(test_prob)

print(
  data.frame(
    Image = c("p6.jpg", "c6.jpg"),
    Actual = testy,
    Predicted = test_pred
  )
)