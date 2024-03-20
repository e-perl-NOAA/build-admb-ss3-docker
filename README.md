# ss3-docker

This Dockerfile:
- Uses the [rocker/rstudio:4 image](https://rocker-project.org/images/versioned/rstudio.html)
- Installs R packages using {pak} associated with [stock synthesis (SS3)](https://github.com/nmfs-stock-synthesis/stock-synthesis)
  - {[r4ss](https://github.com/r4ss/r4ss)}
    - Contains the get_ss3_exe() function to download the stock synthesis executable; see the {r4ss} [documentation](https://r4ss.github.io/r4ss/articles/r4ss-intro-vignette.html) for more details
  - {[ss3sim](https://github.com/ss3sim/ss3sim)}
  - {[ss3diags](https://github.com/jabbamodel/ss3diags)}
- Installs R packages for plotting and parallel processing
  - {ggplot2}
  - {snowfall}
  - {furrr}
  - {parallel}
  - etc. (see Dockerfile for the full list of installed packages)

To use this Docker image locally you will need to have Docker Desktop installed on your computer (if you are with NMFS, this will likely involve IT). You can also use this image in Codespaces, although for that I recommend using the ss3 codespaces .devcontainer.json file rather than the docker image.

I suggest that you use the following workflow to pull and run this Dockerfile:
- Run either of these commands in your terminal/command line:
  ```
  docker run -d -e PASSWORD=password -p 8787:8787 ghcr.io/e-gugliotti-noaa/ss3-docker:main # with GitHub Container Registry
  ```
  OR
  ```
  docker run -d -e PASSWORD=password -p 8787:8787 egugliotti/ss3-docker:main  # with DockerHub
  ```
- Open up your preferred browser and type in http://localhost:8787
- Enter the Username (rstudio unless configured otherwise by including `-e USERNAME=username` in the `docker run` command) and the Password (the password you set up in the `docker run` command, in this case, its password).


## Connect to GitHub
- Open up a terminal and enter the following:
  ```
  git config --global user.name "Your Name"
  git config --global user.email "yourname@your.com"
  git config --global credential.helper store
  ```

## Stop image
- Run the following commands
  ```
  docker ps
  ```
  Which will return a list of images running similarly to the following where the value of "NAMES" changes each time:
  ```
  CONTAINER ID   IMAGE                         COMMAND   CREATED          STATUS          PORTS                    NAMES
  e7cde94f3768   e-gugliotti/ss3-docker:main   "/init"   56 seconds ago   Up 55 seconds   0.0.0.0:8787->8787/tcp   gifted_meitner
  ```
  Then run the following, replace `gifted_meitner` with the name returned from docker ps
  ```
  docker stop gifted_meitner
  ```
