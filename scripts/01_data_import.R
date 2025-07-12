# =================================================================
# AIRBNB BERLIN DATA IMPORT SCRIPT
# Project: Superhost Premium Analysis
# Author: Gregor Kobilarov
# Date: July 12, 2025
# =================================================================

# Define required packages
required_packages <- c("tidyverse", "here")

# Check and install packages if not already installed
for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cat("📦 Installing package:", pkg, "\n")
    install.packages(pkg)
  }
}

# Load the packages
library(tidyverse)
library(here)

# =================================================================
# DATA SOURCE DOCUMENTATION
# =================================================================
# Source: InsideAirbnb Berlin Dataset
# URL: http://insideairbnb.com/get-the-data/
# Downloaded: July 12, 2025
# File: listings.csv (summary data)
# Size: 2.6MB
# Description: Berlin Airbnb listings with host and pricing data
# =================================================================

# Data import
cat("Loading Berlin Airbnb data...\n")
raw_listings <- read_csv(here("data", "raw", "listings.csv"))

# Basic verification and overview
cat("Data loaded successfully!\n")
cat("Rows:", nrow(raw_listings), "\n")
cat("Columns:", ncol(raw_listings), "\n")

# Quick data quality check
cat("Key variables check:\n")
cat("- host_is_superhost:", sum(!is.na(raw_listings$host_is_superhost)), "non-missing\n")
cat("- room_type:", sum(!is.na(raw_listings$room_type)), "non-missing\n")
cat("- price:", sum(!is.na(raw_listings$price)), "non-missing\n")

cat("✅ Data import complete - ready for cleaning!\n")
