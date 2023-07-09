library(keras)
library(ggplot2)
library(dplyr)

clust0_x <- rnorm(1000, 3, 1)
clust0_y <- rnorm(1000, 3, 1)
clust0 <- array(c(clust0_x, clust0_y), dim =  c(1000, 2))
clust0_df <- data.frame(
    x = clust0_x,
    y = clust0_y,
    label = rep(0, 1000)
)

clust1_x <- rnorm(1000, -3, 1)
clust1_y <- rnorm(1000, -3, 1)
clust1 <- array(c(clust1_x, clust1_y), dim =  c(1000, 2))
clust1_df <- data.frame(
    x = clust1_x,
    y = clust1_y,
    label = rep(1, 1000)
)

clust_df <- rbind(clust0_df, clust1_df)

fig <- ggplot(
    clust_df, aes(x = x, y = y)
) + geom_point(aes(colour = label))
fig

shuffled_df <- clust_df[sample(1: nrow(clust_df)), ]

train_set <- shuffled_df[1: 1600, ]
test_set <- shuffled_df[1601: nrow(shuffled_df), ]

model <- keras_model_sequential()
model %>%
    layer_dense(units = 1, activation = "sigmoid", input_shape = c(2))

summary(model)

model %>%
    compile(
        loss = "binary_crossentropy",
        optimizer = optimizer_rmsprop(),
        metrics = c("accuracy")
    )

x_train <- array(unlist(select(train_set, x, y)), dim = c(1600, 2))
y_train <- array(unlist(select(train_set, label)), dim = c(1600, 1))

history <- model %>%
    fit(
        x_train, y_train,
        epochs = 30, batch_size = 32
    )

x_test <- array(unlist(select(test_set, x, y)), dim = c(400, 2))
y_test <- array(unlist(select(test_set, label)), dim = c(400, 1))

predictions <- model %>%
    predict(x_test)
predictions <- floor(predictions * 2)
predictions <- array(predictions, c(400, 1))
pred_df <- data.frame(
    x = x_test[1: nrow(x_test), 1],
    y = x_test[1: nrow(x_test), 2],
    preds = predictions
)

error <- mean(abs(predictions - y_test)) * 100
error

fig <- ggplot(pred_df, aes(x = x, y = y)) + geom_point(aes(colour = preds))
fig

fig <- ggplot(test_set, aes(x = x, y = y)) + geom_point(aes(colour = label))
fig
