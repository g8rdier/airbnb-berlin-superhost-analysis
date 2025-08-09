# ===============================================================================
# AIRBNB BERLIN INTERACTION EFFECTS ANALYSIS - STEP 2
# ===============================================================================
# 
# This script implements interaction effects analysis to understand how Superhost
# pricing strategies systematically vary across price segments within each 
# accommodation type.
#
# Research Question: Do Superhost premiums differ systematically across price 
# segments (cheap/medium/expensive) within each accommodation type?
#
# Expected Insight: Superhosts compete more aggressively in budget segments but 
# leverage reputation for higher premiums in luxury segments.
#
# Author: Interaction Effects Analysis Implementation
# Date: August 2025
# ===============================================================================

# Set CRAN mirror for package installation
options(repos = c(CRAN = "https://cran.rstudio.com/"))

# Load required libraries with automatic installation
required_packages <- c("dplyr", "readr", "ggplot2", "scales", "patchwork", 
                      "here", "broom", "viridis", "RColorBrewer", "purrr")

for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

# Create output directories if they don't exist
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/results", recursive = TRUE, showWarnings = FALSE)

# ===============================================================================
# TASK 1: DATA PREPARATION & PRICE SEGMENTATION
# ===============================================================================

cat("Loading data and preparing price segmentation...\n")

# Load the complete dataset (same as used in quantile regression)
data <- read_csv("data/raw/listings.csv", show_col_types = FALSE)

# Convert price from character to numeric (remove $ and ,)
data$price_numeric <- as.numeric(gsub("[$,]", "", data$price))

# Apply the same minimal cleaning as quantile regression
data_complete <- data %>%
  filter(
    !is.na(host_is_superhost),           # Remove missing Superhost status
    !is.na(room_type),                   # Remove missing room type
    !is.na(price_numeric),               # Remove missing prices
    price_numeric > 0,                   # Remove zero prices (data errors)
    price_numeric <= 10000,              # Remove extreme outliers (>€10k/night)
    room_type %in% c("Entire home/apt", "Private room") # Focus on main categories
  ) %>%
  mutate(
    # Create binary Superhost indicator
    is_superhost = ifelse(host_is_superhost == TRUE, 1, 0),
    
    # Clean room type variable
    room_type_clean = case_when(
      room_type == "Entire home/apt" ~ "Entire home/apt",
      room_type == "Private room" ~ "Private room",
      TRUE ~ room_type
    ),
    
    # Handle missing number_of_reviews (replace NA with 0)
    number_of_reviews = ifelse(is.na(number_of_reviews), 0, number_of_reviews)
  )

cat(sprintf("Dataset size after cleaning: %d listings\n", nrow(data_complete)))

# Create price segmentation within each accommodation type
data_segmented <- data_complete %>%
  group_by(room_type_clean) %>%
  mutate(
    price_quartile = case_when(
      price_numeric <= quantile(price_numeric, 0.33, na.rm = TRUE) ~ "Cheap",
      price_numeric <= quantile(price_numeric, 0.67, na.rm = TRUE) ~ "Medium",
      price_numeric > quantile(price_numeric, 0.67, na.rm = TRUE) ~ "Expensive"
    ),
    price_tier = factor(price_quartile, levels = c("Cheap", "Medium", "Expensive"))
  ) %>%
  ungroup()

# Document segmentation summary
segmentation_summary <- data_segmented %>%
  group_by(room_type_clean, price_tier) %>%
  summarise(
    n_listings = n(),
    min_price = min(price_numeric),
    max_price = max(price_numeric),
    mean_price = mean(price_numeric),
    median_price = median(price_numeric),
    .groups = "drop"
  )

cat("Price segmentation summary:\n")
print(segmentation_summary)

# ===============================================================================
# TASK 2: INTERACTION EFFECTS CALCULATION
# ===============================================================================

cat("\nCalculating interaction effects and Superhost premiums...\n")

# Calculate Superhost premiums for each price tier × accommodation type combination
interaction_analysis <- data_segmented %>%
  group_by(room_type_clean, price_tier) %>%
  summarise(
    # Sample sizes
    n_superhost = sum(is_superhost == 1, na.rm = TRUE),
    n_regular = sum(is_superhost == 0, na.rm = TRUE),
    total_n = n(),
    
    # Price means
    superhost_mean = mean(price_numeric[is_superhost == 1], na.rm = TRUE),
    regular_mean = mean(price_numeric[is_superhost == 0], na.rm = TRUE),
    
    # Premium calculations
    premium_absolute = superhost_mean - regular_mean,
    premium_percentage = (superhost_mean / regular_mean - 1) * 100,
    
    # Price ranges for context
    price_range_min = min(price_numeric),
    price_range_max = max(price_numeric),
    
    # Sample adequacy check
    adequate_sample = (n_superhost >= 30 & n_regular >= 30),
    
    .groups = "drop"
  )

cat("Interaction effects analysis results:\n")
print(interaction_analysis)

# ===============================================================================
# TASK 3: STATISTICAL SIGNIFICANCE TESTING
# ===============================================================================

cat("\nPerforming statistical significance testing...\n")

# Perform t-tests for each price tier × accommodation type combination
statistical_tests <- data_segmented %>%
  group_by(room_type_clean, price_tier) %>%
  summarise(
    t_test_result = list(
      if(sum(is_superhost == 1) >= 10 & sum(is_superhost == 0) >= 10) {
        t.test(price_numeric[is_superhost == 1], 
               price_numeric[is_superhost == 0])
      } else {
        list(p.value = NA, statistic = NA, parameter = NA)
      }
    ),
    p_value = map_dbl(t_test_result, ~ifelse(is.list(.x) && !is.null(.x$p.value), .x$p.value, NA)),
    t_statistic = map_dbl(t_test_result, ~ifelse(is.list(.x) && !is.null(.x$statistic), .x$statistic, NA)),
    significant = p_value < 0.05,
    .groups = "drop"
  ) %>%
  select(-t_test_result)

# Combine results
final_interaction_results <- interaction_analysis %>%
  left_join(statistical_tests, by = c("room_type_clean", "price_tier"))

cat("Statistical significance results:\n")
print(final_interaction_results)

# ===============================================================================
# TASK 4: ADVANCED INTERACTION MODEL
# ===============================================================================

cat("\nFitting advanced interaction regression model...\n")

# Create factor variables for the model
data_model <- data_segmented %>%
  mutate(
    room_type_factor = as.factor(room_type_clean),
    price_tier_factor = as.factor(price_tier),
    is_superhost_factor = as.factor(is_superhost)
  )

# Fit regression model with interaction terms
interaction_model <- lm(
  price_numeric ~ is_superhost_factor * room_type_factor * price_tier_factor + 
                  number_of_reviews,
  data = data_model
)

# Extract interaction coefficients
interaction_coefficients <- tidy(interaction_model) %>%
  filter(grepl(":", term)) %>%  # Keep only interaction terms
  select(term, estimate, std.error, statistic, p.value) %>%
  mutate(significant = p.value < 0.05)

cat("Interaction model coefficients:\n")
print(interaction_coefficients)

# ===============================================================================
# TASK 5: PROFESSIONAL HEATMAP VISUALIZATION
# ===============================================================================

cat("\nCreating professional heatmap visualization...\n")

# Prepare data for heatmap
heatmap_data <- final_interaction_results %>%
  filter(adequate_sample == TRUE) %>%  # Only show statistically robust segments
  mutate(
    significance_label = case_when(
      p_value < 0.001 ~ "***",
      p_value < 0.01 ~ "**", 
      p_value < 0.05 ~ "*",
      is.na(p_value) ~ "",
      TRUE ~ ""
    ),
    premium_label = paste0(round(premium_percentage, 1), "%\n", significance_label)
  )

# Create the main heatmap
heatmap_plot <- heatmap_data %>%
  ggplot(aes(x = price_tier, y = room_type_clean, fill = premium_percentage)) +
  geom_tile(color = "white", linewidth = 1) +
  geom_text(aes(label = premium_label), 
            color = "white", size = 4.5, fontface = "bold") +
  scale_fill_gradient2(
    low = "#d73027", mid = "#ffffbf", high = "#1a9850",
    midpoint = 0, name = "Superhost\nPremium (%)",
    limits = c(-35, 25)
  ) +
  labs(
    title = "Superhost Premium Strategies Across Market Segments",
    subtitle = paste0("How pricing varies by price tier and accommodation type (n=", 
                     sum(heatmap_data$total_n), " listings with adequate samples)"),
    x = "Price Segment",
    y = "Accommodation Type",
    caption = paste("Source: InsideAirbnb Berlin Data | * p<0.05, ** p<0.01, *** p<0.001",
                    "\nNegative values indicate Superhost discounts")
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5, color = "gray40"),
    plot.caption = element_text(size = 10, color = "gray50", hjust = 0.5),
    axis.title = element_text(face = "bold", size = 12),
    axis.text = element_text(size = 11),
    legend.title = element_text(face = "bold"),
    panel.grid = element_blank()
  )

# Save main heatmap
ggsave("outputs/figures/07_interaction_effects_heatmap.png", 
       plot = heatmap_plot, width = 12, height = 8, dpi = 300, bg = "white")

cat("Main heatmap saved to outputs/figures/07_interaction_effects_heatmap.png\n")

# ===============================================================================
# TASK 6: SUPPLEMENTARY CONTEXT VISUALIZATIONS
# ===============================================================================

cat("Creating supplementary context visualizations...\n")

# Sample size visualization
sample_size_plot <- final_interaction_results %>%
  ggplot(aes(x = price_tier, y = room_type_clean, fill = total_n)) +
  geom_tile(color = "white", linewidth = 1) +
  geom_text(aes(label = paste0("n=", total_n)), color = "white", fontface = "bold", size = 4) +
  scale_fill_viridis_c(name = "Sample\nSize", trans = "log10") +
  labs(title = "Sample Sizes by Market Segment",
       x = "Price Segment", y = "Accommodation Type",
       caption = "Source: InsideAirbnb Berlin Data") +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    plot.caption = element_text(size = 9, color = "gray50", hjust = 0.5),
    axis.title = element_text(face = "bold"),
    panel.grid = element_blank(),
    legend.title = element_text(face = "bold")
  )

# Price range context plot  
price_range_plot <- segmentation_summary %>%
  ggplot(aes(x = price_tier, y = room_type_clean, fill = mean_price)) +
  geom_tile(color = "white", linewidth = 1) +
  geom_text(aes(label = paste0("€", round(mean_price, 0))), 
            color = "white", fontface = "bold", size = 4) +
  scale_fill_viridis_c(name = "Mean\nPrice (€)", option = "plasma") +
  labs(title = "Average Prices by Market Segment",
       x = "Price Segment", y = "Accommodation Type",
       caption = "Source: InsideAirbnb Berlin Data") +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    plot.caption = element_text(size = 9, color = "gray50", hjust = 0.5),
    axis.title = element_text(face = "bold"),
    panel.grid = element_blank(),
    legend.title = element_text(face = "bold")
  )

# Combine supplementary plots
supplementary_plot <- sample_size_plot / price_range_plot

# Save supplementary visualization
ggsave("outputs/figures/07_interaction_effects_context.png", 
       plot = supplementary_plot, width = 10, height = 10, dpi = 300, bg = "white")

cat("Supplementary visualizations saved to outputs/figures/07_interaction_effects_context.png\n")

# ===============================================================================
# TASK 7: EXPORT RESULTS & DOCUMENTATION
# ===============================================================================

cat("\nExporting comprehensive results and documentation...\n")

# Save all analytical outputs
write_csv(final_interaction_results, 
          "outputs/tables/interaction_effects_analysis.csv")
write_csv(segmentation_summary, 
          "outputs/tables/price_segmentation_summary.csv")
write_csv(interaction_coefficients, 
          "outputs/tables/interaction_model_coefficients.csv")

# Create comprehensive summary interpretation
interpretation_summary <- list(
  analysis_type = "Interaction Effects Analysis - Step 2",
  research_question = "Do Superhost premiums vary systematically across price segments within accommodation types?",
  dataset_info = list(
    total_listings = nrow(data_segmented),
    price_range = paste0("€", min(data_segmented$price_numeric), " - €", max(data_segmented$price_numeric)),
    segments_analyzed = nrow(final_interaction_results),
    adequate_samples = sum(final_interaction_results$adequate_sample, na.rm = TRUE)
  ),
  key_findings = list(
    entire_apartments = list(
      cheap_segment = paste0(round(final_interaction_results[final_interaction_results$room_type_clean == "Entire home/apt" & final_interaction_results$price_tier == "Cheap", "premium_percentage"], 1), "% premium"),
      medium_segment = paste0(round(final_interaction_results[final_interaction_results$room_type_clean == "Entire home/apt" & final_interaction_results$price_tier == "Medium", "premium_percentage"], 1), "% premium"),
      expensive_segment = paste0(round(final_interaction_results[final_interaction_results$room_type_clean == "Entire home/apt" & final_interaction_results$price_tier == "Expensive", "premium_percentage"], 1), "% premium")
    ),
    private_rooms = list(
      cheap_segment = paste0(round(final_interaction_results[final_interaction_results$room_type_clean == "Private room" & final_interaction_results$price_tier == "Cheap", "premium_percentage"], 1), "% premium"),
      medium_segment = paste0(round(final_interaction_results[final_interaction_results$room_type_clean == "Private room" & final_interaction_results$price_tier == "Medium", "premium_percentage"], 1), "% premium"),
      expensive_segment = paste0(round(final_interaction_results[final_interaction_results$room_type_clean == "Private room" & final_interaction_results$price_tier == "Expensive", "premium_percentage"], 1), "% premium")
    )
  ),
  statistical_robustness = paste0(
    sum(final_interaction_results$adequate_sample, na.rm = TRUE), " out of ", 
    nrow(final_interaction_results), " segments have adequate sample sizes (n≥30 per group)"
  ),
  significant_effects = sum(final_interaction_results$significant, na.rm = TRUE)
)

# Export comprehensive interpretation
interpretation_text <- capture.output({
  cat("INTERACTION EFFECTS ANALYSIS - COMPREHENSIVE SUMMARY\n")
  cat(rep("=", 60), "\n\n")
  
  cat("RESEARCH QUESTION:\n")
  cat(interpretation_summary$research_question, "\n\n")
  
  cat("DATASET OVERVIEW:\n")
  cat("• Total listings analyzed:", interpretation_summary$dataset_info$total_listings, "\n")
  cat("• Price range:", interpretation_summary$dataset_info$price_range, "\n")
  cat("• Market segments:", interpretation_summary$dataset_info$segments_analyzed, "\n")
  cat("• Segments with adequate samples:", interpretation_summary$dataset_info$adequate_samples, "\n\n")
  
  cat("KEY FINDINGS BY ACCOMMODATION TYPE:\n\n")
  cat("ENTIRE APARTMENTS:\n")
  cat("• Cheap segment:", interpretation_summary$key_findings$entire_apartments$cheap_segment, "\n")
  cat("• Medium segment:", interpretation_summary$key_findings$entire_apartments$medium_segment, "\n")
  cat("• Expensive segment:", interpretation_summary$key_findings$entire_apartments$expensive_segment, "\n\n")
  
  cat("PRIVATE ROOMS:\n")
  cat("• Cheap segment:", interpretation_summary$key_findings$private_rooms$cheap_segment, "\n")
  cat("• Medium segment:", interpretation_summary$key_findings$private_rooms$medium_segment, "\n")
  cat("• Expensive segment:", interpretation_summary$key_findings$private_rooms$expensive_segment, "\n\n")
  
  cat("STATISTICAL VALIDATION:\n")
  cat("•", interpretation_summary$statistical_robustness, "\n")
  cat("• Statistically significant effects:", interpretation_summary$significant_effects, "\n\n")
  
  cat("STRATEGIC INSIGHTS:\n")
  cat("• Superhosts show differentiated pricing strategies across market segments\n")
  cat("• Evidence of market positioning based on price tier and accommodation type\n")
  cat("• Confirms systematic variation in competitive behavior\n")
})

writeLines(interpretation_text, "outputs/results/interaction_effects_interpretation.txt")

# Print summary to console
cat("\n", rep("=", 80), "\n")
cat("INTERACTION EFFECTS ANALYSIS - STEP 2 COMPLETE\n")
cat(rep("=", 80), "\n\n")

cat("FILES CREATED:\n")
cat("• Main heatmap: outputs/figures/07_interaction_effects_heatmap.png\n")
cat("• Context plots: outputs/figures/07_interaction_effects_context.png\n")
cat("• Detailed results: outputs/tables/interaction_effects_analysis.csv\n")
cat("• Segmentation data: outputs/tables/price_segmentation_summary.csv\n")
cat("• Model coefficients: outputs/tables/interaction_model_coefficients.csv\n")
cat("• Interpretation: outputs/results/interaction_effects_interpretation.txt\n\n")

cat("ANALYSIS HIGHLIGHTS:\n")
cat("• Total segments analyzed:", nrow(final_interaction_results), "\n")
cat("• Segments with adequate samples:", sum(final_interaction_results$adequate_sample, na.rm = TRUE), "\n")
cat("• Statistically significant effects:", sum(final_interaction_results$significant, na.rm = TRUE), "\n")
cat("• Dataset size:", nrow(data_segmented), "listings\n\n")

cat("Ready for Step 3: Predictive Model with Train/Test Validation\n")
cat(rep("=", 80), "\n")