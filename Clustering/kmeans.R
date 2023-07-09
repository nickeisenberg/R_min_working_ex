library(plotly)
library(ggplot2)
library(data.table)
library(tidyverse)

# generate the data
sample1_x <- rnorm(n = 1000, mean = 0, sd = 1)
sample1_y <- rnorm(n = 1000, mean = 1, sd = 1)
sample2_x <- rnorm(n = 1000, mean = 5, sd = 1)
sample2_y <- rnorm(n = 1000, mean = 3, sd = 1)

# store the data in dataframes and plot
df1 <- data.frame(sample1_x, sample1_y)
df2 <- data.frame(sample2_x, sample2_y)

fig <- plot_ly()
fig <- fig %>%
    add_trace(p = fig, data = df1, name = "Mean (0, 1), SD 1",
              x = ~sample1_x, y = ~sample1_y,
              type = "scatter", mode = "markers")
fig <- fig %>%
    add_trace(p = fig, data = df2, name = "Mean (5, 3), SD 1",
              x = ~sample2_x, y = ~sample2_y,
              type = "scatter", mode = "markers")
fig <- fig %>%
    layout(xaxis = list(title = "x -axis"),
           yaxis = list(title = "y -axis"),
           title = list(text = "Two Clusters of Gaussian Distrubuted Data"))
fig

# add a cluster columns and combine the data to one dataframe
df <- rbind(as.data.table(df1), as.data.table(df2), use.names = FALSE)
clusts <- kmeans(df, 2, 5)
df <- df %>%
    add_column(clusters = clusts$cluster)

# rename the columns
colnames(df)[1: 2] <- c("col1", "col2")

# plot with the clusters colored using ggplot2
fig <- ggplot2::ggplot() +
    ggplot2::geom_point(data = df,
                        aes(x = col1, y = col2, color = clusters)
                        )
fig

# plot with the clusters colored using plotly
print(df)

fig <- plot_ly()
fig <- fig %>%
    add_trace(data = df,
              x = ~col1, y = ~col2,
              color = ~clusters,
              type = "scatter", mode = "markers") %>%
    layout(title = "kmeans")
fig
