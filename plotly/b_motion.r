library(dplyr)
library(plotly)

domain <- seq(0, 1, by = .01)
noise <- sqrt(.01) * rnorm(length(domain))
bm <- cumsum(noise)

df <- data.frame(
    dom = domain,
    path = bm
)

plotly_fig <- plot_ly(data = df, type = "scatter", "mode" = "lines") %>%
    add_trace(x = ~dom, y = ~path)
plotly_fig <- fig %>%
    layout(
        showlegend = FALSE
    )
plotly_fig

ggplot_fig <- ggplot(
    data = df, mapping = aes(x = dom, y = path)
) + geom_point(aes(colour = path))
ggplot_fig
