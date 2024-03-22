# Install R packages for hake assessment docker image

install.packages(c("remotes","purrr"))
library(remotes)
library(purrr)

# These are the packages on GitHub, in alphabetical order
github_pac_lst <- c("r4ss/r4ss",
                    "ss3sim/ss3sim",
                    "PIFSCstockassessments/ss3diags")

walk(github_pac_lst, \(pkg){
  install_github(pkg)
})

# These are packages on CRAN. Alphabetical order, each line has the same
# starting letter for each package (new line for new starting letter)
pac_lst <- c(
  "corrplot", "cowplot", "data.table", "data.tree", "date",
  "future", "furrr", "ggpubr", "glue", "grDevices", "grid", "gridExtra", 
  "gridGraphics", "gtable", "knitr", "magick", "parallelly", 
  "RColorBrewer", "readr", "scales", "sf", "tidyverse",
  "tidyselect", "tictoc", "tools", "utils", "with")

install.packages(pac_lst)
