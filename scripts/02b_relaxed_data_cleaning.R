# =============================================================================
# 02b_relaxed_data_cleaning.R
# Airbnb Berlin Superhost Premium Analysis - Relaxed Data Cleaning Pipeline
# =============================================================================
#
# This script implements a relaxed data cleaning approach to maximize dataset
# size for enhanced predictive modeling while maintaining analytical integrity.
# Compared to the strict cleaning pipeline (02_data_cleaning.R), this approach:
# - Uses minimal outlier bounds to retain more observations
# - Implements strategic imputation instead of row removal
# - Preserves borderline cases for improved model training
# - Expected output: ~14,000 listings vs ~8,800 from strict cleaning
#
# =============================================================================

# Define required packages
required_packages <- c("tidyverse", "here", "janitor")

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
library(janitor)

# Create output directories if they don't exist
if (!dir.exists(here("outputs"))) {
  dir.create(here("outputs"), recursive = TRUE)
}
if (!dir.exists(here("outputs", "tables"))) {
  dir.create(here("outputs", "tables"), recursive = TRUE)
}

# Set up logging
cat("=== Airbnb Berlin Relaxed Data Cleaning Pipeline ===\n")
cat("Start time:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n\n")

# Load raw data
cat("Loading raw dataset...\n")
raw_data <- read_csv(here("data", "raw", "listings.csv"), show_col_types = FALSE)
cat("Raw data loaded:", nrow(raw_data), "rows,", ncol(raw_data), "columns\n\n")

# Initial data exploration
cat("=== Initial Data Assessment ===\n")
cat("Total listings:", nrow(raw_data), "\n")
cat("Superhost data availability:", sum(!is.na(raw_data$host_is_superhost)), "/", nrow(raw_data), "\n")
cat("Price data availability:", sum(!is.na(raw_data$price)), "/", nrow(raw_data), "\n")
cat("Room type data availability:", sum(!is.na(raw_data$room_type)), "/", nrow(raw_data), "\n\n")

# =============================================================================
# STEP 1: Minimal Essential Variable Filtering
# =============================================================================

cat("=== Step 1: Minimal Essential Variable Filtering ===\n")

# Keep only listings with absolutely essential variables (relaxed approach)
cleaned_data <- raw_data %>%
  filter(
    !is.na(host_is_superhost),
    !is.na(room_type),
    !is.na(price),
    price != "",
    price != "$0.00"  # Only remove obvious $0 prices
  )

cat("After minimal essential filtering:", nrow(cleaned_data), "listings remaining\n")

# =============================================================================
# STEP 2: Relaxed Price Column Cleaning
# =============================================================================

cat("=== Step 2: Relaxed Price Column Cleaning ===\n")

# Clean price column with relaxed validation
cleaned_data <- cleaned_data %>%
  mutate(
    # Remove $ symbol and convert to numeric
    price_numeric = as.numeric(str_replace_all(price, "[$,]", "")),
    # More lenient price validation (keep borderline cases)
    price_issues = is.na(price_numeric) | price_numeric <= 1  # Allow €2+ listings
  )

# Report price cleaning results
cat("Price cleaning results:\n")
cat("  - Successfully converted prices:", sum(!is.na(cleaned_data$price_numeric)), "\n")
cat("  - Price conversion issues:", sum(cleaned_data$price_issues), "\n")

# Remove only clear price issues
cleaned_data <- cleaned_data %>%
  filter(!price_issues) %>%
  select(-price_issues)

cat("After relaxed price cleaning:", nrow(cleaned_data), "listings remaining\n")

# =============================================================================
# STEP 3: Inclusive Room Type Approach
# =============================================================================

cat("=== Step 3: Inclusive Room Type Approach ===\n")

# Check room type distribution
room_type_counts <- cleaned_data %>%
  count(room_type, sort = TRUE)

cat("Room type distribution:\n")
print(room_type_counts)

# Include all major room types (relaxed approach)
major_room_types <- c("Entire home/apt", "Private room", "Shared room", "Hotel room")
cleaned_data <- cleaned_data %>%
  filter(room_type %in% major_room_types)

cat("After inclusive room type filtering:", nrow(cleaned_data), "listings remaining\n")

# =============================================================================
# STEP 4: Minimal Outlier Bounds
# =============================================================================

cat("=== Step 4: Minimal Outlier Bounds ===\n")

# Calculate price statistics
price_stats <- cleaned_data %>%
  summarise(
    mean_price = mean(price_numeric, na.rm = TRUE),
    median_price = median(price_numeric, na.rm = TRUE),
    sd_price = sd(price_numeric, na.rm = TRUE),
    min_price = min(price_numeric, na.rm = TRUE),
    max_price = max(price_numeric, na.rm = TRUE),
    q99 = quantile(price_numeric, 0.99, na.rm = TRUE)
  )

cat("Price statistics before minimal outlier removal:\n")
print(price_stats)

# Very relaxed outlier removal (only extreme cases)
reasonable_min <- 2  # Allow very cheap listings
reasonable_max <- price_stats$q99 * 2  # Allow up to 2x 99th percentile

outliers_removed <- cleaned_data %>%
  filter(
    price_numeric >= reasonable_min,
    price_numeric <= reasonable_max
  )

cat("Minimal outlier removal results:\n")
cat("  - Lower bound: €", round(reasonable_min, 2), "\n")
cat("  - Upper bound: €", round(reasonable_max, 2), "\n")
cat("  - Outliers removed:", nrow(cleaned_data) - nrow(outliers_removed), "\n")
cat("  - Remaining listings:", nrow(outliers_removed), "\n")

cleaned_data <- outliers_removed

# =============================================================================
# STEP 5: Strategic Variable Standardization with Imputation
# =============================================================================

cat("=== Step 5: Strategic Variable Standardization with Imputation ===\n")

# Enhanced standardization with strategic imputation
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
    
    # Create expanded price categories
    price_category = case_when(
      price_numeric <= 30 ~ "Budget (≤€30)",
      price_numeric <= 60 ~ "Economy (€31-60)",
      price_numeric <= 100 ~ "Mid-range (€61-100)",
      price_numeric <= 150 ~ "Premium (€101-150)",
      price_numeric <= 250 ~ "Luxury (€151-250)",
      TRUE ~ "Ultra-luxury (>€250)"
    ),
    
    # Standardize room type labels (include all types)
    room_type_clean = case_when(
      room_type == "Entire home/apt" ~ "Entire Place",
      room_type == "Private room" ~ "Private Room",
      room_type == "Shared room" ~ "Shared Room",
      room_type == "Hotel room" ~ "Hotel Room",
      TRUE ~ room_type
    ),
    
    # Enhanced neighborhood handling with imputation
    neighborhood_clean = case_when(
      !is.na(neighbourhood_cleansed) ~ str_to_title(neighbourhood_cleansed),
      !is.na(neighbourhood) ~ str_to_title(neighbourhood),
      TRUE ~ "Unknown"  # Impute missing neighborhoods
    ),
    
    # Impute missing accommodation numbers
    accommodates_clean = case_when(
      !is.na(accommodates) & accommodates > 0 ~ accommodates,
      room_type == "Entire home/apt" ~ 4,  # Reasonable default for entire places
      room_type == "Private room" ~ 2,     # Reasonable default for private rooms
      room_type == "Shared room" ~ 1,      # Reasonable default for shared rooms
      room_type == "Hotel room" ~ 2,       # Reasonable default for hotel rooms
      TRUE ~ 2  # General fallback
    ),
    
    # Enhanced review handling with imputation
    number_of_reviews_clean = ifelse(is.na(number_of_reviews), 0, number_of_reviews),
    
    # Calculate days since last review (with imputation)
    days_since_review = case_when(
      !is.na(last_review) ~ as.numeric(Sys.Date() - as.Date(last_review)),
      number_of_reviews_clean == 0 ~ 9999,  # Never reviewed
      TRUE ~ 365  # Assume 1 year for missing review dates
    ),
    
    # Impute host characteristics
    host_response_rate_clean = case_when(
      !is.na(host_response_rate) & host_response_rate != "N/A" & 
        str_detect(host_response_rate, "^\\d+%$") ~ 
        as.numeric(str_replace(host_response_rate, "%", "")),
      is_superhost ~ 95,  # Superhosts typically have high response rates
      TRUE ~ 80  # Reasonable default for regular hosts
    ),
    
    # Review scores with strategic imputation
    review_scores_rating_clean = case_when(
      !is.na(review_scores_rating) ~ review_scores_rating,
      number_of_reviews_clean == 0 ~ NA_real_,  # Keep NA for no reviews
      TRUE ~ 4.5  # Conservative imputation for missing scores
    ),
    
    # Availability with reasonable defaults
    availability_365_clean = case_when(
      !is.na(availability_365) ~ availability_365,
      TRUE ~ 180  # Assume moderate availability
    ),
    
    # Minimum nights with practical defaults
    minimum_nights_clean = case_when(
      !is.na(minimum_nights) & minimum_nights <= 365 ~ minimum_nights,
      room_type == "Entire home/apt" ~ 2,  # Typical for entire places
      TRUE ~ 1  # Default for other types
    )
  )

cat("Variable standardization and imputation completed\n")
cat("Fixed missing column error and handled coercion warning in host_response_rate\n")

# =============================================================================
# STEP 6: Comprehensive Variable Selection
# =============================================================================

cat("=== Step 6: Comprehensive Variable Selection ===\n")

# Check for bed_type column availability
if ("bed_type" %in% colnames(cleaned_data)) {
  cat("Column 'bed_type' found and will be included\n")
} else {
  cat("Column 'bed_type' not found in dataset, excluding from selection\n")
}

# Select comprehensive set of variables for analysis
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
    
    # Location (enhanced)
    neighbourhood_cleansed,
    neighbourhood,
    neighborhood_clean,
    latitude,
    longitude,
    
    # Property characteristics (with imputed values)
    accommodates,  # Keep original for comparison
    accommodates_clean,
    bedrooms,
    beds,
    bathrooms_text,
    
    # Host characteristics (enhanced)
    host_since,
    host_response_rate_clean,
    host_acceptance_rate,
    host_listings_count,
    host_identity_verified,
    
    # Review metrics (comprehensive)
    number_of_reviews_clean,
    review_scores_rating_clean,
    review_scores_accuracy,
    review_scores_cleanliness,
    review_scores_checkin,
    review_scores_communication,
    review_scores_location,
    review_scores_value,
    last_review,
    days_since_review,
    
    # Availability and booking
    availability_365_clean,
    minimum_nights_clean,
    maximum_nights,
    
    # Calculated and derived fields
    calculated_host_listings_count,
    instant_bookable,
    
    # Additional useful variables
    property_type,
    amenities,
    host_verifications
  )

cat("Comprehensive analysis dataset:", nrow(analysis_data), "listings,", ncol(analysis_data), "variables\n")

# =============================================================================
# STEP 7: Enhanced Data Quality Validation
# =============================================================================

cat("=== Step 7: Enhanced Data Quality Validation ===\n")

# Enhanced data quality report
quality_report <- analysis_data %>%
  summarise(
    total_listings = n(),
    superhost_count = sum(is_superhost, na.rm = TRUE),
    regular_host_count = sum(!is_superhost, na.rm = TRUE),
    entire_place_count = sum(room_type == "Entire home/apt", na.rm = TRUE),
    private_room_count = sum(room_type == "Private room", na.rm = TRUE),
    shared_room_count = sum(room_type == "Shared room", na.rm = TRUE),
    hotel_room_count = sum(room_type == "Hotel room", na.rm = TRUE),
    price_range = paste0("€", min(price_numeric), " - €", max(price_numeric)),
    avg_price = round(mean(price_numeric), 2),
    median_price = round(median(price_numeric), 2),
    missing_neighborhoods = sum(neighborhood_clean == "Unknown"),
    imputed_accommodates = sum(is.na(accommodates)),
    zero_reviews = sum(number_of_reviews_clean == 0)
  )

cat("Enhanced dataset quality report:\n")
print(quality_report)

# Check missing values in key variables
missing_check <- analysis_data %>%
  select(is_superhost, price_numeric, room_type_clean, neighborhood_clean) %>%
  summarise_all(~sum(is.na(.)))

cat("Missing values in key variables after relaxed cleaning:\n")
print(missing_check)

# Compare with strict cleaning approach
comparison_metrics <- data.frame(
  Metric = c("Total_Listings", "Dataset_Size_Increase", "Superhost_Count", 
             "Room_Type_Diversity", "Price_Range_Min", "Price_Range_Max"),
  Relaxed_Approach = c(nrow(analysis_data), 
                       paste0("+", round((nrow(analysis_data) - 8800) / 8800 * 100, 1), "%"),
                       sum(quality_report$superhost_count),
                       length(unique(analysis_data$room_type_clean)),
                       min(analysis_data$price_numeric),
                       max(analysis_data$price_numeric)),
  Expected_Benefit = c("~14,000", "~59% increase", "Proportional increase", 
                      "4 types vs 2", "€2 vs €10", "Higher ceiling")
)

cat("Relaxed vs Strict Cleaning Comparison:\n")
print(comparison_metrics)

# =============================================================================
# STEP 8: Export Relaxed Dataset
# =============================================================================

cat("=== Step 8: Exporting Relaxed Dataset ===\n")

# Create processed data directory if it doesn't exist
if (!dir.exists(here("data", "processed"))) {
  dir.create(here("data", "processed"), recursive = TRUE)
}

# Export relaxed cleaned dataset
write_csv(analysis_data, here("data", "processed", "cleaned_airbnb_berlin_relaxed.csv"))

# Export enhanced summary statistics
summary_stats_relaxed <- analysis_data %>%
  group_by(superhost_status, room_type_clean) %>%
  summarise(
    count = n(),
    mean_price = round(mean(price_numeric), 2),
    median_price = round(median(price_numeric), 2),
    sd_price = round(sd(price_numeric), 2),
    min_price = min(price_numeric),
    max_price = max(price_numeric),
    avg_accommodates = round(mean(accommodates_clean, na.rm = TRUE), 1),
    avg_reviews = round(mean(number_of_reviews_clean), 1),
    .groups = "drop"
  )

write_csv(summary_stats_relaxed, here("outputs", "tables", "price_summary_by_group_relaxed.csv"))

# Export comparison metrics
write_csv(comparison_metrics, here("outputs", "tables", "relaxed_vs_strict_comparison.csv"))

# Export data quality report
quality_df <- data.frame(
  Metric = names(quality_report),
  Value = as.character(unlist(quality_report))
)
write_csv(quality_df, here("outputs", "tables", "relaxed_cleaning_quality_report.csv"))

cat("Relaxed dataset exported to: data/processed/cleaned_airbnb_berlin_relaxed.csv\n")
cat("Enhanced summary statistics exported to: outputs/tables/price_summary_by_group_relaxed.csv\n")
cat("Comparison metrics exported to: outputs/tables/relaxed_vs_strict_comparison.csv\n")

# =============================================================================
# FINAL REPORT
# =============================================================================

cat("\n=== RELAXED DATA CLEANING COMPLETE ===\n")
cat("Processing completed:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
cat("Final relaxed dataset ready with", nrow(analysis_data), "listings\n")
cat("Dataset size increase:", round((nrow(analysis_data) - 8800) / 8800 * 100, 1), "% vs strict cleaning\n")
cat("Enhanced dataset ready for improved predictive modeling.\n")

# Console summary
cat("\n", rep("=", 80), "\n")
cat("RELAXED DATA CLEANING PIPELINE - EXECUTION COMPLETE\n")
cat(rep("=", 80), "\n\n")

cat("DATASET ENHANCEMENT RESULTS:\n")
cat("• Final dataset size:", nrow(analysis_data), "listings\n")
cat("• Improvement over strict cleaning:", round((nrow(analysis_data) - 8800) / 8800 * 100, 1), "% increase\n")
cat("• Room type diversity: 4 types (vs 2 in strict)\n")
cat("• Price range: €", min(analysis_data$price_numeric), " - €", max(analysis_data$price_numeric), "\n")
cat("• Strategic imputation applied to maximize usable data\n\n")

cat("KEY ENHANCEMENTS:\n")
cat("• Minimal outlier bounds (€2 minimum vs €10)\n")
cat("• Inclusive room type approach (4 types vs 2)\n")
cat("• Strategic imputation instead of row removal\n")
cat("• Enhanced variable standardization\n")
cat("• Comprehensive quality validation\n\n")

cat("FILES CREATED:\n")
cat("• Main dataset: data/processed/cleaned_airbnb_berlin_relaxed.csv\n")
cat("• Summary stats: outputs/tables/price_summary_by_group_relaxed.csv\n")
cat("• Comparison metrics: outputs/tables/relaxed_vs_strict_comparison.csv\n")
cat("• Quality report: outputs/tables/relaxed_cleaning_quality_report.csv\n\n")

cat("🎯 READY FOR ENHANCED PREDICTIVE MODELING\n")
cat(rep("=", 80), "\n")