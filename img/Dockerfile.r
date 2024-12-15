FROM r-base:4.4.2
RUN set -eux \
    && useradd -m -d /home/user01 --system --groups staff user01 \
    && apt-get update && apt-get install -y \
    imagemagick \
    time \
    r-cran-caret \
    r-cran-catools \
    r-cran-cluster \
    r-cran-clustergeneration \
    r-cran-dplyr \
    r-cran-e1071 \
    r-cran-epi \
    r-cran-erm \
    r-cran-ggally \
    r-cran-ggplot2 \
    r-cran-glmnet \
    r-cran-hash \
    r-cran-here \
    r-cran-lattice \
    r-cran-leaps \
    r-cran-lmtest \
    r-cran-lubridate \
    r-cran-mass \
    r-cran-metrics \
    r-cran-mlbench \
    r-cran-nnet \
    r-cran-party \
    r-cran-partykit \
    r-cran-plotly \
    r-cran-psych \
    r-cran-randomforest \
    r-cran-readxl \
    r-cran-reshape \
    r-cran-rocr \
    r-cran-rpart \
    r-cran-rvest \
    r-cran-sampling \
    r-cran-scatterplot3d \
    r-cran-sqldf \
    r-cran-tm \
    && rm -rf /var/lib/apt/lists/* \
    && mv /etc/ImageMagick-7/policy.xml /etc/ImageMagick-7/policy.xmlout

USER user01
WORKDIR /home/user01/
