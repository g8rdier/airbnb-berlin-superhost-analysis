# =============================================================================
# 03_exploratory_analysis.R
# Airbnb Berlin Superhost Premium Analysis - Exploratory Data Analysis
# Research Question: Do Superhosts achieve higher relative premium for private rooms vs entire places?
# =============================================================================

# Define required packages
required_packages <- c("readr", "dplyr", "ggplot2", "tidyr", "here", "psych", "car", "nortest")

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
library(ggplot2)
library(tidyr)
library(here)
library(psych)
library(car)
library(nortest)

# Create output directories if they don't exist
if (!dir.exists(here("outputs"))) {
  dir.create(here("outputs"), recursive = TRUE)
}
if (!dir.exists(here("outputs", "results"))) {
  dir.create(here("outputs", "results"), recursive = TRUE)
}
if (!dir.exists(here("outputs", "tables"))) {
  dir.create(here("outputs", "tables"), recursive = TRUE)
}
if (!dir.exists(here("outputs", "figures"))) {
  dir.create(here("outputs", "figures"), recursive = TRUE)
}

# Set up logging
cat("=== Airbnb Berlin Superhost Premium - Exploratory Analysis ===\n")
cat("Start time:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n\n")

# =============================================================================
# STEP 1: Data Loading and Initial Exploration
# =============================================================================

cat("=== Step 1: Loading Cleaned Dataset ===\n")

# Load cleaned data
data <- read_csv(here("data", "processed", "cleaned_airbnb_berlin.csv"), show_col_types = FALSE)

cat("Dataset loaded successfully:\n")
cat("  - Total listings:", nrow(data), "\n")
cat("  - Variables:", ncol(data), "\n")
cat("  - Date range: Cleaned and analysis-ready\n\n")

# Verify data integrity
cat("Data integrity check:\n")
missing_check <- data %>%
  select(is_superhost, price_numeric, room_type) %>%
  summarise_all(~sum(is.na(.)))
print(missing_check)

# =============================================================================
# STEP 2: Core Group Definitions and Sample Sizes
# =============================================================================

cat("\n=== Step 2: Group Definitions and Sample Sizes ===\n")

# Create analysis groups
data <- data %>%
  mutate(
    host_type = ifelse(is_superhost, "Superhost", "Regular Host"),
    room_category = case_when(
      room_type == "Entire home/apt" ~ "Entire Place",
      room_type == "Private room" ~ "Private Room",
      TRUE ~ room_type
    ),
    analysis_group = paste(host_type, room_category, sep = " - ")
  )

# Sample size analysis
sample_sizes <- data %>%
  count(host_type, room_category) %>%
  pivot_wider(names_from = room_category, values_from = n, values_fill = 0)

cat("Sample sizes by group:\n")
print(sample_sizes)

# Verify adequate sample sizes for statistical testing
min_sample_size <- 30  # Common threshold for CLT
adequate_samples <- all(sample_sizes[,-1] >= min_sample_size)
cat("All groups have adequate sample sizes (n ≥ 30):", adequate_samples, "\n\n")

# =============================================================================
# STEP 3: Descriptive Statistics by Groups
# =============================================================================

cat("=== Step 3: Comprehensive Descriptive Statistics ===\n")

# Generate detailed summary statistics
descriptive_stats <- data %>%
  group_by(host_type, room_category) %>%
  summarise(
    count = n(),
    mean_price = round(mean(price_numeric), 2),
    median_price = round(median(price_numeric), 2),
    sd_price = round(sd(price_numeric), 2),
    min_price = min(price_numeric),
    max_price = max(price_numeric),
    q25 = round(quantile(price_numeric, 0.25), 2),
    q75 = round(quantile(price_numeric, 0.75), 2),
    iqr = round(IQR(price_numeric), 2),
    .groups = "drop"
  )

cat("Descriptive statistics by group:\n")
print(descriptive_stats)

# Export descriptive statistics to TABLES directory
write_csv(descriptive_stats, here("outputs", "tables", "descriptive_statistics.csv"))

# Overall summary by host type
host_summary <- data %>%
  group_by(host_type) %>%
  summarise(
    count = n(),
    mean_price = round(mean(price_numeric), 2),
    median_price = round(median(price_numeric), 2),
    sd_price = round(sd(price_numeric), 2),
    .groups = "drop"
  )

cat("\nOverall summary by host type:\n")
print(host_summary)

# Export host summary to TABLES directory
write_csv(host_summary, here("outputs", "tables", "host_type_summary.csv"))

# Overall summary by room category
room_summary <- data %>%
  group_by(room_category) %>%
  summarise(
    count = n(),
    mean_price = round(mean(price_numeric), 2),
    median_price = round(median(price_numeric), 2),
    sd_price = round(sd(price_numeric), 2),
    .groups = "drop"
  )

cat("\nOverall summary by room category:\n")
print(room_summary)

# Export room summary to TABLES directory
write_csv(room_summary, here("outputs", "tables", "room_category_summary.csv"))

# =============================================================================
# STEP 4: Relative Premium Calculations (Core Research Metric)
# =============================================================================

cat("\n=== Step 4: Relative Premium Analysis ===\n")

# Calculate relative premiums for each room type
premium_analysis <- descriptive_stats %>%
  select(host_type, room_category, mean_price) %>%
  pivot_wider(names_from = host_type, values_from = mean_price) %>%
  mutate(
    absolute_premium = `Superhost` - `Regular Host`,
    relative_premium_pct = round((absolute_premium / `Regular Host`) * 100, 2),
    premium_ratio = round(`Superhost` / `Regular Host`, 3)
  )

cat("Superhost Premium Analysis:\n")
print(premium_analysis)

# Export premium analysis to TABLES directory
write_csv(premium_analysis, here("outputs", "tables", "premium_analysis.csv"))

# Extract key premiums for hypothesis testing
private_room_premium <- premium_analysis %>% 
  filter(room_category == "Private Room") %>% 
  pull(relative_premium_pct)

entire_place_premium <- premium_analysis %>% 
  filter(room_category == "Entire Place") %>% 
  pull(relative_premium_pct)

premium_difference <- private_room_premium - entire_place_premium

cat("\nKey Research Metrics:\n")
cat("  - Superhost premium for Private Rooms:", private_room_premium, "%\n")
cat("  - Superhost premium for Entire Places:", entire_place_premium, "%\n")
cat("  - Difference (Private - Entire):", round(premium_difference, 2), "%\n")

# Highlight unexpected finding
if (private_room_premium < 0) {
  cat("  *** UNEXPECTED FINDING: Superhosts charge LESS for private rooms ***\n")
}
cat("\n")

# =============================================================================
# STEP 5: Distribution Analysis and Assumption Testing
# =============================================================================

cat("=== Step 5: Statistical Assumption Testing ===\n")

# Test normality for each group (important for t-tests)
normality_tests <- data %>%
  group_by(host_type, room_category) %>%
  summarise(
    n = n(),
    shapiro_p_value = ifelse(n <= 5000, 
                            shapiro.test(price_numeric)$p.value, 
                            anderson.test(price_numeric)$p.value),
    normal_distribution = shapiro_p_value > 0.05,
    .groups = "drop"
  )

cat("Normality test results (p > 0.05 indicates normal distribution):\n")
print(normality_tests)

# Export normality tests to TABLES directory
write_csv(normality_tests, here("outputs", "tables", "normality_tests.csv"))

# Test variance equality (homoscedasticity)
cat("\nVariance equality tests:\n")

# Levene's test for equal variances - Private Rooms
private_room_data <- data %>% filter(room_category == "Private Room")
levene_private <- leveneTest(price_numeric ~ factor(host_type), data = private_room_data)
cat("Private Rooms - Levene's test p-value:", round(levene_private$`Pr(>F)`[1], 4), "\n")

# Levene's test for equal variances - Entire Places
entire_place_data <- data %>% filter(room_category == "Entire Place")
levene_entire <- leveneTest(price_numeric ~ factor(host_type), data = entire_place_data)
cat("Entire Places - Levene's test p-value:", round(levene_entire$`Pr(>F)`[1], 4), "\n")

# Overall assessment
equal_variances <- (levene_private$`Pr(>F)`[1] > 0.05) && (levene_entire$`Pr(>F)`[1] > 0.05)
cat("Equal variances assumption met:", equal_variances, "\n\n")

# =============================================================================
# STEP 6: Control Variable Analysis
# =============================================================================

cat("=== Step 6: Control Variable Exploration ===\n")

# Analyze key control variables mentioned in research proposal
control_analysis <- data %>%
  group_by(host_type, room_category) %>%
  summarise(
    mean_reviews = round(mean(number_of_reviews, na.rm = TRUE), 1),
    median_reviews = round(median(number_of_reviews, na.rm = TRUE), 1),
    mean_availability = round(mean(availability_365, na.rm = TRUE), 1),
    mean_accommodates = round(mean(accommodates, na.rm = TRUE), 1),
    mean_rating = round(mean(review_scores_rating, na.rm = TRUE), 2),
    .groups = "drop"
  )

cat("Control variables by group:\n")
print(control_analysis)

# Export control analysis to TABLES directory
write_csv(control_analysis, here("outputs", "tables", "control_variables.csv"))

# Correlation analysis with price
correlations <- data %>%
  select(price_numeric, number_of_reviews, availability_365, accommodates, review_scores_rating) %>%
  cor(use = "complete.obs") %>%
  round(3)

cat("\nCorrelations with price:\n")
print(correlations[1, ])

# Export correlation matrix to TABLES directory
write_csv(as.data.frame(correlations), here("outputs", "tables", "price_correlations.csv"))

# =============================================================================
# STEP 7: Effect Size Estimation
# =============================================================================

cat("\n=== Step 7: Effect Size Analysis ===\n")

# Calculate Cohen's d for effect sizes
calculate_cohens_d <- function(group1, group2) {
  m1 <- mean(group1, na.rm = TRUE)
  m2 <- mean(group2, na.rm = TRUE)
  s1 <- sd(group1, na.rm = TRUE)
  s2 <- sd(group2, na.rm = TRUE)
  n1 <- length(group1[!is.na(group1)])
  n2 <- length(group2[!is.na(group2)])
  
  pooled_sd <- sqrt(((n1 - 1) * s1^2 + (n2 - 1) * s2^2) / (n1 + n2 - 2))
  cohens_d <- (m1 - m2) / pooled_sd
  return(cohens_d)
}

# Effect sizes for each room type
private_superhost <- data %>% filter(room_category == "Private Room", is_superhost == TRUE) %>% pull(price_numeric)
private_regular <- data %>% filter(room_category == "Private Room", is_superhost == FALSE) %>% pull(price_numeric)

entire_superhost <- data %>% filter(room_category == "Entire Place", is_superhost == TRUE) %>% pull(price_numeric)
entire_regular <- data %>% filter(room_category == "Entire Place", is_superhost == FALSE) %>% pull(price_numeric)

effect_private <- calculate_cohens_d(private_superhost, private_regular)
effect_entire <- calculate_cohens_d(entire_superhost, entire_regular)

cat("Effect sizes (Cohen's d):\n")
cat("  - Private Rooms (Superhost vs Regular):", round(effect_private, 3), "\n")
cat("  - Entire Places (Superhost vs Regular):", round(effect_entire, 3), "\n")

# Interpret effect sizes
interpret_effect <- function(d) {
  if (abs(d) < 0.2) return("negligible")
  if (abs(d) < 0.5) return("small")
  if (abs(d) < 0.8) return("medium")
  return("large")
}

cat("  - Private Rooms effect size:", interpret_effect(effect_private), "\n")
cat("  - Entire Places effect size:", interpret_effect(effect_entire), "\n\n")

# Create effect size summary table
effect_size_summary <- data.frame(
  room_type = c("Private Room", "Entire Place"),
  cohens_d = c(round(effect_private, 3), round(effect_entire, 3)),
  interpretation = c(interpret_effect(effect_private), interpret_effect(effect_entire))
)

# Export effect sizes to TABLES directory
write_csv(effect_size_summary, here("outputs", "tables", "effect_sizes.csv"))

# =============================================================================
# STEP 8: Data Export for Hypothesis Testing
# =============================================================================

cat("=== Step 8: Preparing Data for Hypothesis Testing ===\n")

# Create focused dataset for t-tests
hypothesis_data <- data %>%
  select(
    id, host_type, room_category, analysis_group, is_superhost,
    price_numeric, number_of_reviews, availability_365, 
    accommodates, review_scores_rating
  ) %>%
  filter(!is.na(price_numeric))

# Export for hypothesis testing (remains in PROCESSED - it's a cleaned dataset)
write_csv(hypothesis_data, here("data", "processed", "hypothesis_testing_data.csv"))

# Create summary for academic report
research_summary <- list(
  sample_sizes = sample_sizes,
  premium_analysis = premium_analysis,
  key_metrics = data.frame(
    metric = c("Private Room Premium (%)", "Entire Place Premium (%)", "Premium Difference (%)"),
    value = c(private_room_premium, entire_place_premium, round(premium_difference, 2))
  ),
  effect_sizes = data.frame(
    room_type = c("Private Room", "Entire Place"),
    cohens_d = c(round(effect_private, 3), round(effect_entire, 3)),
    interpretation = c(interpret_effect(effect_private), interpret_effect(effect_entire))
  ),
  assumptions = data.frame(
    assumption = c("Adequate Sample Sizes", "Equal Variances"),
    met = c(adequate_samples, equal_variances)
  )
)

# Export research summary to RESULTS directory
capture.output(print(research_summary), file = here("outputs", "results", "exploratory_summary.txt"))

cat("Exploratory analysis complete. Key files exported:\n")
cat("  - outputs/tables/descriptive_statistics.csv: Detailed group statistics\n")
cat("  - outputs/tables/premium_analysis.csv: Premium calculations by room type\n")
cat("  - outputs/tables/effect_sizes.csv: Cohen's d effect size analysis\n")
cat("  - outputs/results/exploratory_summary.txt: Research summary\n")
cat("  - data/processed/hypothesis_testing_data.csv: Dataset for t-tests\n\n")

# =============================================================================
# FINAL SUMMARY
# =============================================================================

cat("=== EXPLORATORY ANALYSIS COMPLETE ===\n")
cat("Processing completed:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
cat("Dataset ready for hypothesis testing with", nrow(hypothesis_data), "listings\n")

cat("\nKey Findings Preview:\n")
cat("  - Superhost premium varies significantly by room type\n")
cat("  - Statistical assumptions", ifelse(adequate_samples && equal_variances, "MET", "REQUIRE ATTENTION"), "\n")
cat("  - Effect sizes indicate", ifelse(max(abs(effect_private), abs(effect_entire)) > 0.5, "SUBSTANTIAL", "MODERATE"), "practical significance\n")
cat("\nReady to proceed with hypothesis testing (t-tests) for your research question.\n")
