# From https://github.com/cgrandin/docker-projects/blob/master/hake/Dockerfile

FROM rocker/tidyverse:latest
RUN apt update && apt  -y --no-install-recommends install \
    apt-transport-https \
    build-essential \
    # `flex` is needed for the ADMB compilation
    flex \
    curl \
    git \
    libmagick++-dev 

RUN apt upgrade -y

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

# Install R
COPY install_r_packages.R $HOME
RUN R -e "install.packages('here'); \
          source(here::here('install_r_packages.R'))"
          
RUN rm install_r_packages.R

# Do this to plot in the "plot" panel in RStudio server
RUN R -e "options(device = "RStudioGD")"

COPY rstudio-prefs.json $HOME/.config/rstudio/rstudio-prefs.json
RUN chmod 777 $HOME/.config/rstudio/rstudio-prefs.json

# You will need to run the following in docker
# SS3_TEST_MODELS=$HOME/github/ss3-test-models
# mkdir -p $SS3_TEST_MODELS

# git clone --branch v3.30.22.1 https://github.com/nmfs-ost/ss3-test-models $SS3_TEST_MODELS

# REPO_DIR= $SS3_TEST_MODELS
# docker pull egugliotti/build-admb-ss3-docker:main
# docker run \
#   -it \
#   --rm \
#   -p 8787:8787 \
#   -e PASSWORD=a \
#   -v $REPO_DIR:/home/rstudio/github/ss3-test-models
#   egugliotti/build-admb-ss3-docker:main \
#   bash

# CMD ["/bin/bash"]
# had to use -v instead of --mount type=bind,source=$REPO_DIR,target=/home/rstudio/github/ss3-test-models \ 
