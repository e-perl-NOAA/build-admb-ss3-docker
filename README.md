# build-admb-ss3-docker

## SOME BIG SILLY CHANGE

## This Dockerfile
- Uses the [rocker/tidyverse image](https://rocker-project.org/images/versioned/rstudio.html)
- Builds ADMB from source and puts it in the $PATH
- Builds [Stock Synthesis (SS3)](https://github.com/nmfs-ost/ss3-source-code) version 3.30.22.1 and puts in $PATH
- Installs R packages using associated with SS3 including:
  - {[r4ss](https://github.com/r4ss/r4ss)} - Also contains the get_ss3_exe() function to download the SS3 executable if the user would like to use this option; see the {r4ss} [documentation](https://r4ss.github.io/r4ss/articles/r4ss-intro-vignette.html) for more details
  - {[ss3sim](https://github.com/ss3sim/ss3sim)}
  - {[ss3diags](https://github.com/jabbamodel/ss3diags)}
- Installs R packages for plotting and parallel processing
  - {ggplot2}
  - {purrr}
  - {furrr}
  - {parallelly}
  - etc. (see [install_r_packages.R](https://github.com/e-perl-NOAA/build-admb-ss3-docker/blob/main/install_r_packages.R) for the full list of installed packages)

## How to use this Docker image
### Simple Usage
To use this Docker image locally you will need to have Docker Desktop installed on your computer (if you are with NMFS, this will likely involve IT). You can also use this image in Codespaces, although for that I recommend using the ss3 codespaces .devcontainer.json file rather than the docker image.

I suggest that you use the following workflow to pull and run this Dockerfile:
- Run these commands in your terminal/command line:
  ```
  docker pull egugliotti/build-admb-ss3-docker:main
  docker run -it --rm -p 8787:8787 -e PASSWORD=a egugliotti/build-admb-ss3-docker:main
  ```
- Open up your preferred browser and type in http://localhost:8787
- Enter the Username (rstudio unless configured otherwise by including `-e USERNAME=username` in the `docker run` command) and the Password (the password you set up in the `docker run` command, in this case, its a).

### Usage with Mounting Files and .gitconfig file
If you would like to mount local files onto the Docker container to have available for you there, the following is an example of how to do that using the [ss3-test-models GitHub repository](https://github.com/nmfs-ost/ss3-test-models)
- Run `git clone --branch v3.30.22.1 https://github.com/nmfs-ost/ss3-test-models` in a terminal on your computer, preferrably somewhere within you $HOME directory.
- Go to your terminal and type in `$HOME`. This path will differ between windows, mac, and linux machines.
- For example, my home directory on my windows is /c/Users/elizabeth.gugliotti. I have my ss3-test-models repo stored under /c/Users/elizabeth.gugliotti/Documents/github_repos/stock-synthesis/ss3-test-models. I could just write this as $HOME/Documents/github_repos/stock-synthesis/ss3-test-models. On my mac, which is where I typically use docker it's slightly different
- This method also assumes that you have already gone through the step to [connect to GitHub](#connect-to-github) on your local machine so that you have a .gitconfig file to mount on the container and automatically be able to connect to GitHub. This step is not necessary and you can always [connect to GitHub](#connect-to-github) once in the container.

#### Locally
- After cloning the ss3-test-models repo or using model files on your local machine (changing the location and name after $HOME/ to where your model files are), run the following in a terminal:
  ```
  docker run \
   -it \
   --rm \
   -p 8787:8787 \
   -e PASSWORD=a \
   --mount type=bind,source=$HOME/Documents/github_repos/ss3-test-models,target=/home/rstudio/github/ss3-test-models \
   --mount type=bind,source=$HOME/.gitconfig,target=/home/rstudio/.gitconfig \
   egugliotti/build-admb-ss3-docker:main
  ```
- source is where you have your files stored on your machine, target is where you will have your files stored on the container

#### Using GitHub Codespaces
- After cloning the ss3-test-models repo or after opening a codespace in a repo with your model files, run the following in the terminal on codespaces - you shouldn't have a .gitconfig file in a repository so if you want to configure settings in a codespace, you should do that after the container is running using the lines in the [Connect to GitHub](#connect-to-github) section.
  ```
  docker run \
   -it \
   --rm \
   -p 8787:8787 \
   -e PASSWORD=a \
   --mount type=bind,source=$HOME/workspaces/*insert repo name where codespace is opened here*/ss3-test-models,target=/home/rstudio/github/ss3-test-models \
   egugliotti/build-admb-ss3-docker:main
  ```
- A pop-up will appear in codespaces for you to click to open up your port to RStudio in a web browser
- Other options are to go to PORTS right next to TERMINAL and click on the world icon next to the port you created OR to put http://localhost:8787 in your browser

### Connect to GitHub once in the Container
- Open up a terminal and enter the following:
  ```
  git config --global user.name "Your Name"
  git config --global user.email "yourname@your.com"
  git config --global credential.helper store
  ```

## Stop Image
- Run the following commands
  ```
  docker ps
  ```
  Which will return a list of images running similarly to the following where the value of "NAMES" changes each time:
  ```
  CONTAINER ID   IMAGE                               COMMAND   CREATED          STATUS          PORTS                    NAMES
  e7cde94f3768   e-gugliotti/build-admb-ss3-docker   "/init"   56 seconds ago   Up 55 seconds   0.0.0.0:8787->8787/tcp   gifted_meitner
  ```
  Then run the following, replace `gifted_meitner` with the name returned from docker ps
  ```
  docker stop gifted_meitner
  ```
- You can also use the Docker Desktop GUI to stop the image.
