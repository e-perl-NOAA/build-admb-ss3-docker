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

SHELL ["/bin/bash", "-c"]

# Install R
COPY install_r_packages.R $HOME
RUN R -e "install.packages('here'); \
          source(here::here('install_r_packages.R'))"
          
RUN rm install_r_packages.R

ENV SS3_TEST_MODELS=$HOME/github/nmfs-ost/ss3-test-models
RUN mkdir -p $SS3_TEST_MODELS

COPY rstudio-prefs.json $HOME/.config/rstudio/rstudio-prefs.json
RUN chmod 777 $HOME/.config/rstudio/rstudio-prefs.json

WORKDIR $SS3_TEST_MODELS

# You will need to run the following in docker

# git clone --branch v3.30.22.1 https://github.com/nmfs-ost/ss3-test-models your computer, preferrably somewhere within you $HOME directory.
# Go to your terminal and type in $HOME. This path will differ between windows, mac, and linux machines.
# For example, my home directory on my windows is /c/Users/elizabeth.gugliotti.
# I have my ss3-test-models repo stored under /c/Users/elizabeth.gugliotti/Documents/github_repos/stock-synthesis/ss3-test-models
# I could just write this as $HOME/Documents/github_repos/stock-synthesis/ss3-test-models
# On my mac, which is where I typically use docker it's slightly different

# You will run the code below with the source=$HOME/wherever-you-store-your-files,target=/home/rstudio/wherever-you-want-files-stored
# This will mount local files onto the container for you to use there
# You can also change the password from a to something else if you wish

# docker pull egugliotti/build-admb-ss3-docker:main
# docker run \
#   -it \
#   --rm \
#   -p 8787:8787 \
#   -e PASSWORD=a \
#   --mount type=bind,source=$HOME/Documents/github_repos/ss3-test-models,target=/home/rstudio/github/ss3-test-models \
#   --mount type=bind,source=$HOME/.gitconfig,target=/home/rstudio/.gitconfig \
#   egugliotti/build-admb-ss3-docker:main

# once docker container is running go to your browser and type in http://localhost:8787
# username is rstudio, password is a or whatever you put after password in running the docker image
# CMD ["/bin/bash"]

# Needed to plot in the "plot" panel in Rstudio server
# options(device = "RStudioGD")
