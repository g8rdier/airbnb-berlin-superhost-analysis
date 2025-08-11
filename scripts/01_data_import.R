# =================================================================
# AIRBNB BERLIN DATA IMPORT SCRIPT
# Project: Superhost Premium Analysis
# Author: Gregor Kobilarov
# Date: July 12, 2025
# =================================================================

# Define required packages (using core packages instead of tidyverse to avoid ragg dependency issues)
required_packages <- c("readr", "dplyr", "here")

# Ubuntu-specific package installation with minimal dependencies
install_ubuntu_safe <- function(pkg) {
  if (Sys.info()["sysname"] == "Linux") {
    cat("🐧 Installing", pkg, "on Ubuntu with minimal dependencies...\n")
    tryCatch({
      # Try binary installation first (fastest)
      install.packages(pkg, type = "both", dependencies = c("Depends", "Imports"))
    }, error = function(e1) {
      cat("⚠️  Binary failed, trying source with essential deps only...\n")
      tryCatch({
        install.packages(pkg, dependencies = c("Depends", "Imports", "LinkingTo"))
      }, error = function(e2) {
        cat("⚠️  Minimal install failed, trying basic install...\n")
        install.packages(pkg, dependencies = FALSE)
      })
    })
  } else {
    install.packages(pkg)
  }
}

# Check and install packages if not already installed
for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cat("📦 Installing package:", pkg, "\n")
    install_ubuntu_safe(pkg)
  }
}

# Load the packages
library(readr)
library(dplyr)
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
