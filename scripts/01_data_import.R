# scripts/01_data_import.R
library(tidyverse)
library(here)

# Load the manually downloaded file
raw_listings <- read_csv(here("data", "raw", "listings.csv"))

# Basic verification
cat("Data loaded:", nrow(raw_listings), "rows\n")
