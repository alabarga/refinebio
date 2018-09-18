# Turn warnings into errors because biocLite throws warnings instead
# of error if it fails to install something.
options(warn=2)
options(repos=structure(c(CRAN="https://cloud.r-project.org")))
options(Ncpus=parallel::detectCores())

# Install dev packages
install.packages("devtools")

# Bioconductor packages, installed by devtools::install_url()

# devtools::install_url() requires biocLite.R
source('https://bioconductor.org/biocLite.R')

# Helper function that installs a list of packages based on input URL
install_with_url <- function(main_url, packages) {
  lapply(packages,
         function(pkg) devtools::install_url(paste0(main_url, pkg)))
}

bioc_url <- 'https://bioconductor.org/packages/3.6/bioc/src/contrib/'
bioc_pkgs <- c(
  'affyio_1.48.0.tar.gz',
  'zlibbioc_1.24.0.tar.gz'
)
install_with_url(bioc_url, bioc_pkgs)