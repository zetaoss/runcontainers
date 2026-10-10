ARG IMAGE
FROM ${IMAGE}
# bob: Rscript runbox.r
RUN echo 'suppressMessages({library(ggplot2); library(dplyr); library(caret)}); cat("hi")' > runbox.r && test "$(Rscript runbox.r)" = hi
