# From https://github.com/cgrandin/docker-projects/blob/master/hake/Dockerfile

FROM rocker/r-ubuntu:22.04
RUN apt update && apt  -y --no-install-recommends install \
    build-essential \
    # `flex` is needed for the ADMB compilation
    flex \
    git

SHELL ["/bin/bash", "-c"]

ENV HOME=/home/container
ENV PATH=$HOME:$PATH
ENV INST=/usr/bin

RUN useradd -m container
WORKDIR $HOME

# Install ADMB and set corresponding environment variables
ENV ADMB_HOME=$INST/admb/build/admb
ENV ADMB_AD2CSV=$INST/admb/contrib/ad2csv
ENV PATH=$ADMB_AD2CSV:$ADMB_HOME/bin:$PATH
COPY clean_admb $ADMB_HOME
COPY install_admb.sh $INST/install_admb.sh
WORKDIR $INST
RUN chmod a+x install_admb.sh
RUN ./install_admb.sh
WORKDIR $HOME

# Install SS3 and set corresponding environment variables
COPY install_ss3.sh $INST/install_ss3.sh
ENV SS3_HOME=$INST/ss3_exe
ENV PATH=$SS3_HOME:$PATH
WORKDIR $INST
RUN chmod a+x install_ss3.sh
RUN ./install_ss3.sh
WORKDIR $HOME

# RUN apt-get update \
#     && apt-get install -y make gcc g++ cmake clang git libssl-dev libxml2 libxml2-dev openssl sudo wget curl \
#     && apt-get install --assume-yes make gcc g++ cmake clang git libssl-dev libxml2 libxml2-dev openssl sudo wget curl \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/

# RUN wget -P ~/ https://github.com/admb-project/admb/archive/master.zip 
#     && unzip ~/master.zip 
#     && mv ~/*-master ~/admb
#     && rm ~/master.zip
#     && cd admb 
#     && make
#     && chmod 755 /usr/local/bin/admb
#     && export PATH=$PATH:/usr/local/bin/admb

# RUN wget -P ~/ https://github.com/nmfs-ost/ss3-source-code/archive/master.zip 
#     && unzip ~/master.zip -d /usr/local/bin
#     && rm ~/master.zip
#     && mv /usr/local/bin/ss3-source-code
#     && rm /usr/local/bin/ss3-source-code-main
#     && chmod 777 /usr/local/bin/ss3-source-code
#     && cd /usr/local/bin/ss3-source-code
#     && mkdir /usr/local/bin/SS330
#     && chmod 777 /usr/local/bin/SS330
#     && /bin/bash ./Make_SS_330_new.sh -b SS330 -p
#     &&  export PATH=$PATH:/usr/local/bin/SS330
    
# set CRAN repo to the RStudio mirror
# RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'))" >> /usr/local/lib/R/etc/Rprofile.site
# RUN R -e 'options(download.file.method = "libcurl")'
# RUN R -e 'Sys.setenv(R_REMOTES_NO_ERRORS_FROM_WARNINGS="true")'
# RUN R -e "install.packages(c('remotes', 'parallel', 'snowfall', 'purrr', 'furrr', 'pak', 'devtools', 'dplyr', 'ggplot2', 'data.table', 'magrittr', 'mvtnorm', 'scales', 'plyr', 'grid', 'png', 'utf8', 'tidyverse', 'httr'))"

# RUN R -e 'pak::pkg_install("r4ss/r4ss")' \
#     && R -e 'pak::pkg_install("jabbamodel/ss3diags")' \
#     && R -e 'pak::pkg_install("ss3sim/ss3sim")'
 #   && R -q -e "pak::pkg_intall('flr/FLCore')" \
 #   && R -q -e "pak::pkg_intall('flr/ggplotFL')" \
 #   && R -q -e "pak::pkg_intall('flr/kobe')"

# CMD ["/bin/bash"]
