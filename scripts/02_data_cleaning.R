# =============================================================================
# 02_data_cleaning.R
# Airbnb Berlin Superhost Premium Analysis - Data Cleaning Pipeline
# =============================================================================

# Load required packages
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("here")) install.packages("here")
if (!require("janitor")) install.packages("janitor")

library(tidyverse)
library(here)
library(janitor)

# Set up logging
cat("=== Airbnb Berlin Data Cleaning Pipeline ===\n")
cat("Start time:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n\n")

# Load raw data
cat("Loading raw dataset...\n")
raw_data <- read_csv(here("data", "raw", "listings.csv"))
cat("Raw data loaded:", nrow(raw_data), "rows,", ncol(raw_data), "columns\n\n")

# Initial data exploration
cat("=== Initial Data Assessment ===\n")
cat("Total listings:", nrow(raw_data), "\n")
cat("Superhost data availability:", sum(!is.na(raw_data$host_is_superhost)), "/", nrow(raw_data), "\n")
cat("Price data availability:", sum(!is.na(raw_data$price)), "/", nrow(raw_data), "\n")
cat("Room type data availability:", sum(!is.na(raw_data$room_type)), "/", nrow(raw_data), "\n\n")

# =============================================================================
# STEP 1: Filter Critical Variables
# =============================================================================

cat("=== Step 1: Filtering Critical Variables ===\n")

# Keep only listings with essential variables
cleaned_data <- raw_data %>%
  filter(
    !is.na(host_is_superhost),
    !is.na(room_type),
    !is.na(price),
    price != ""
  )

cat("After filtering missing critical variables:", nrow(cleaned_data), "listings remaining\n")

# =============================================================================
# STEP 2: Price Column Cleaning
# =============================================================================

cat("=== Step 2: Price Column Cleaning ===\n")

# Clean price column
cleaned_data <- cleaned_data %>%
  mutate(
    # Remove $ symbol and convert to numeric
    price_numeric = as.numeric(str_replace_all(price, "[$,]", "")),
    # Log original price issues
    price_issues = is.na(price_numeric) | price_numeric <= 0
  )

# Report price cleaning results
cat("Price cleaning results:\n")
cat("  - Successfully converted prices:", sum(!is.na(cleaned_data$price_numeric)), "\n")
cat("  - Price conversion issues:", sum(cleaned_data$price_issues), "\n")

# Remove listings with price issues
cleaned_data <- cleaned_data %>%
  filter(!price_issues) %>%
  select(-price_issues)

cat("After price cleaning:", nrow(cleaned_data), "listings remaining\n")

# =============================================================================
# STEP 3: Room Type Filtering
# =============================================================================

cat("=== Step 3: Room Type Filtering ===\n")

# Check room type distribution
room_type_counts <- cleaned_data %>%
  count(room_type, sort = TRUE)

cat("Room type distribution:\n")
print(room_type_counts)

# Focus on main room types for analysis
main_room_types <- c("Entire home/apt", "Private room")
cleaned_data <- cleaned_data %>%
  filter(room_type %in% main_room_types)

cat("After filtering to main room types:", nrow(cleaned_data), "listings remaining\n")

# =============================================================================
# STEP 4: Outlier Detection and Removal
# =============================================================================

cat("=== Step 4: Outlier Detection and Removal ===\n")

# Calculate price statistics
price_stats <- cleaned_data %>%
  summarise(
    mean_price = mean(price_numeric, na.rm = TRUE),
    median_price = median(price_numeric, na.rm = TRUE),
    sd_price = sd(price_numeric, na.rm = TRUE),
    min_price = min(price_numeric, na.rm = TRUE),
    max_price = max(price_numeric, na.rm = TRUE)
  )

cat("Price statistics before outlier removal:\n")
print(price_stats)

# Remove extreme outliers (3 standard deviations)
price_mean <- price_stats$mean_price
price_sd <- price_stats$sd_price
lower_bound <- price_mean - 3 * price_sd
upper_bound <- price_mean + 3 * price_sd

# Also set reasonable minimum (avoid €1 listings)
reasonable_min <- 10

outliers_removed <- cleaned_data %>%
  filter(
    price_numeric >= max(lower_bound, reasonable_min),
    price_numeric <= upper_bound
  )

cat("Outlier removal results:\n")
cat("  - Lower bound: €", round(max(lower_bound, reasonable_min), 2), "\n")
cat("  - Upper bound: €", round(upper_bound, 2), "\n")
cat("  - Outliers removed:", nrow(cleaned_data) - nrow(outliers_removed), "\n")
cat("  - Remaining listings:", nrow(outliers_removed), "\n")

cleaned_data <- outliers_removed

# =============================================================================
# STEP 5: Variable Standardization and Creation
# =============================================================================

cat("=== Step 5: Variable Standardization ===\n")

# Standardize and create analysis variables
cleaned_data <- cleaned_data %>%
  mutate(
    # Standardize superhost variable
    is_superhost = case_when(
      host_is_superhost == "t" ~ TRUE,
      host_is_superhost == "f" ~ FALSE,
      TRUE ~ as.logical(host_is_superhost)
    ),
    
    # Create superhost status label
    superhost_status = ifelse(is_superhost, "Superhost", "Regular Host"),
    
    # Create price categories
    price_category = case_when(
      price_numeric <= 50 ~ "Budget (≤€50)",
      price_numeric <= 100 ~ "Mid-range (€51-100)",
      price_numeric <= 200 ~ "Premium (€101-200)",
      TRUE ~ "Luxury (>€200)"
    ),
    
    # Standardize room type labels
    room_type_clean = case_when(
      room_type == "Entire home/apt" ~ "Entire Place",
      room_type == "Private room" ~ "Private Room",
      TRUE ~ room_type
    ),
    
    # Create neighborhood groups (if available)
    neighborhood_clean = str_to_title(neighbourhood_cleansed),
    
    # Calculate days since last review (if available)
    days_since_review = ifelse(
      !is.na(last_review),
      as.numeric(Sys.Date() - as.Date(last_review)),
      NA
    )
  )

# =============================================================================
# STEP 6: Select Final Variables for Analysis
# =============================================================================

cat("=== Step 6: Selecting Analysis Variables ===\n")

# Select key variables for analysis
analysis_data <- cleaned_data %>%
  select(
    # Identifiers
    id,
    name,
    host_id,
    host_name,
    
    # Key analysis variables
    is_superhost,
    superhost_status,
    price_numeric,
    price_category,
    room_type,
    room_type_clean,
    
    # Location
    neighbourhood_cleansed,
    neighborhood_clean,
    latitude,
    longitude,
    
    # Property characteristics
    accommodates,
    bedrooms,
    beds,
    bathrooms_text,
    
    # Host characteristics
    host_since,
    host_response_rate,
    host_acceptance_rate,
    host_listings_count,
    
    # Review metrics
    number_of_reviews,
    review_scores_rating,
    review_scores_accuracy,
    review_scores_cleanliness,
    review_scores_checkin,
    review_scores_communication,
    review_scores_location,
    review_scores_value,
    last_review,
    days_since_review,
    
    # Availability
    availability_365,
    minimum_nights,
    maximum_nights,
    
    # Calculated fields
    calculated_host_listings_count
  )

cat("Final analysis dataset:", nrow(analysis_data), "listings,", ncol(analysis_data), "variables\n")

# =============================================================================
# STEP 7: Data Quality Validation
# =============================================================================

cat("=== Step 7: Data Quality Validation ===\n")

# Final data quality checks
quality_report <- analysis_data %>%
  summarise(
    total_listings = n(),
    superhost_count = sum(is_superhost, na.rm = TRUE),
    regular_host_count = sum(!is_superhost, na.rm = TRUE),
    private_room_count = sum(room_type == "Private room", na.rm = TRUE),
    entire_place_count = sum(room_type == "Entire home/apt", na.rm = TRUE),
    price_range = paste0("€", min(price_numeric), " - €", max(price_numeric)),
    avg_price = round(mean(price_numeric), 2),
    median_price = round(median(price_numeric), 2)
  )

cat("Final dataset quality report:\n")
print(quality_report)

# Check for any remaining missing values in key variables
missing_check <- analysis_data %>%
  select(is_superhost, price_numeric, room_type) %>%
  summarise_all(~sum(is.na(.)))

cat("Missing values in key variables:\n")
print(missing_check)

# =============================================================================
# STEP 8: Export Cleaned Dataset
# =============================================================================

cat("=== Step 8: Exporting Cleaned Dataset ===\n")

# Create processed data directory if it doesn't exist
if (!dir.exists(here("data", "processed"))) {
  dir.create(here("data", "processed"), recursive = TRUE)
}

# Export cleaned dataset
write_csv(analysis_data, here("data", "processed", "cleaned_airbnb_berlin.csv"))

# Export summary statistics
summary_stats <- analysis_data %>%
  group_by(superhost_status, room_type_clean) %>%
  summarise(
    count = n(),
    mean_price = round(mean(price_numeric), 2),
    median_price = round(median(price_numeric), 2),
    sd_price = round(sd(price_numeric), 2),
    min_price = min(price_numeric),
    max_price = max(price_numeric),
    .groups = "drop"
  )

write_csv(summary_stats, here("data", "processed", "price_summary_by_group.csv"))

cat("Cleaned dataset exported to: data/processed/cleaned_airbnb_berlin.csv\n")
cat("Summary statistics exported to: data/processed/price_summary_by_group.csv\n")

# =============================================================================
# FINAL REPORT
# =============================================================================

cat("\n=== DATA CLEANING COMPLETE ===\n")
cat("Processing completed:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
cat("Final dataset ready for analysis with", nrow(analysis_data), "listings\n")
cat("Superhost Premium Analysis can now proceed to exploratory analysis phase.\n")
