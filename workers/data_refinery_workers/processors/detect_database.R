###
# detect_database.R
# Alex's Lemonade Stand Foundation
# Childhood Cancer Data Lab
#
###

##
# get & read in non-normalized supplementary data
# IDs = identifiers used by submitter
#
# for each version of db package for organism (e.g., v1-v4 in human)
#   calculate the % of IDs in the probes for current package
#   calculate the % of probes in the IDs for current package
#
# save the calculated overlaps as SampleAnnotation (will be number of versions x 2)
# highest_overlap = which version has the highest % of IDs in the probes
#
# if highest_overlap > some high threshold
#   supply as platform/package to Illumina SCAN Rscript
# else
#   we should get the processed data and attempt to convert the IDs to Ensembl gene IDs
##

#######################
# The command interface!
#######################

suppressPackageStartupMessages(library("optparse"))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(lazyeval))
suppressPackageStartupMessages(library(AnnotationDbi))

option_list = list(
  make_option(c("-p", "--platform"), type="character", default="",
              help="Platform", metavar="character"),
  make_option(c("-i", "--inputFile"), type="character", default="",
              help="inputFile", metavar="character"),
  make_option(c("-c", "--column"), type="character", default="",
              help="column", metavar="character")
)

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

platform <- opt$platform
filePath <- opt$inputFile
probeIdColumn <- opt$column

# Load the platform
suppressPackageStartupMessages(library(paste(platform, ".db", sep=""), character.only=TRUE))

# Read the data file
suppressWarnings(exprs <- fread(filePath, stringsAsFactors=FALSE, sep="\t", header=TRUE, autostart=10, data.table=FALSE, check.names=FALSE, fill=TRUE, na.strings="", showProgress=FALSE))
expr_probes <- exprs[probeIdColumn]

# Load these probes
db_name <- paste(platform, ".db", sep="")
database_probes <- AnnotationDbi::keys(get(db_name))

# Calculate the overlap (% of probes in the IDs for current package)
common_probes <- intersect(unlist(expr_probes), database_probes)
percent <- ( length(common_probes) / length(database_probes) ) * 100.0

# Send the result to stdout so parent process can pick it up
write(percent, stdout())

# “the proportion of the IDs in the submitter-processed data can be mapped”
mapped_percent <- ( length(common_probes) / length(unlist(expr_probes)) ) * 100.0

# Send the result to stdout so parent process can pick it up
write(mapped_percent, stdout())
