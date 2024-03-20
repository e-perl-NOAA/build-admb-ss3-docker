FROM rocker/rstudio:4

RUN apt-get update \
    && apt-get install -y make gcc g++ cmake clang git libssl-dev libxml2 libxml2-dev openssl sudo wget curl \
    && apt-get install --assume-yes make gcc g++ cmake clang git libssl-dev libxml2 libxml2-dev openssl sudo wget curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/

# set CRAN repo to the RStudio mirror
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'))" >> /usr/local/lib/R/etc/Rprofile.site
RUN R -e 'options(download.file.method = "libcurl")'
RUN R -e 'Sys.setenv(R_REMOTES_NO_ERRORS_FROM_WARNINGS="true")'
RUN R -e "install.packages(c('remotes', 'parallel', 'snowfall', 'purrr', 'furrr', 'pak', 'devtools', 'dplyr', 'ggplot2', 'data.table', 'magrittr', 'mvtnorm', 'scales', 'plyr', 'grid', 'png', 'utf8', 'tidyverse', 'httr'))"

RUN R -e 'pak::pkg_install("r4ss/r4ss")' \
    && R -e 'pak::pkg_install("jabbamodel/ss3diags")' \
    && R -e 'pak::pkg_install("ss3sim/ss3sim")'
 #   && R -q -e "pak::pkg_intall('flr/FLCore')" \
 #   && R -q -e "pak::pkg_intall('flr/ggplotFL')" \
 #   && R -q -e "pak::pkg_intall('flr/kobe')"

# CMD ["/bin/bash"]
