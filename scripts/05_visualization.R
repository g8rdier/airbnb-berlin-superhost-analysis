# =============================================================================
# 05_visualization.R
# Airbnb Berlin Superhost Premium Analysis - Data Visualization
# Research Question: Do Superhosts achieve different relative price premiums for private rooms vs entire places?
# Key Finding: -22.19% vs +16.79% differential pricing (38.98% difference)
# =============================================================================

# Define required packages
required_packages <- c("tidyverse", "here", "ggplot2", "scales", "RColorBrewer", "patchwork", "viridis")

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
library(ggplot2)
library(scales)
library(RColorBrewer)
library(patchwork)
library(viridis)

# Create output directories if they don't exist
if (!dir.exists(here("outputs", "figures"))) {
  dir.create(here("outputs", "figures"), recursive = TRUE)
}

# Set up logging
cat("=== Airbnb Berlin Superhost Premium - Data Visualization ===\n")
cat("Start time:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n\n")

# Set consistent theme for all plots
theme_academic <- theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5, color = "gray40"),
    axis.title = element_text(size = 11, face = "bold"),
    axis.text = element_text(size = 10),
    legend.title = element_text(size = 11, face = "bold"),
    legend.text = element_text(size = 10),
    strip.text = element_text(size = 11, face = "bold"),
    panel.grid.minor = element_blank(),
    plot.caption = element_text(size = 9, hjust = 0, color = "gray50")
  )

# Define consistent color palette
superhost_colors <- c("Regular Host" = "#E74C3C", "Superhost" = "#3498DB")
room_colors <- c("Private Room" = "#9B59B6", "Entire Place" = "#F39C12")

# =============================================================================
# STEP 1: Data Loading and Preparation
# =============================================================================

cat("=== Step 1: Loading Data and Statistical Results ===\n")

# Load main dataset
data <- read_csv(here("data", "processed", "hypothesis_testing_data.csv"), show_col_types = FALSE)

# Load statistical results
premium_calc <- read_csv(here("outputs", "tables", "premium_calculations.csv"), show_col_types = FALSE)
group_means <- read_csv(here("outputs", "tables", "group_means.csv"), show_col_types = FALSE)
sample_sizes <- read_csv(here("outputs", "tables", "sample_sizes.csv"), show_col_types = FALSE)

cat("Data loaded successfully for visualization:\n")
cat("  - Main dataset:", nrow(data), "listings\n")
cat("  - Statistical tables: Premium calculations, group means, sample sizes\n\n")

# =============================================================================
# STEP 2: Core Finding Visualization - Premium Comparison
# =============================================================================

cat("=== Step 2: Creating Core Research Finding Visualization ===\n")

# Prepare premium data for visualization
premium_data <- premium_calc %>%
  select(room_category, relative_premium_pct) %>%
  mutate(
    premium_direction = ifelse(relative_premium_pct < 0, "Discount", "Premium"),
    premium_abs = abs(relative_premium_pct),
    room_category = factor(room_category, levels = c("Private Room", "Entire Place"))
  )

# Create main finding visualization
p1_premium_comparison <- ggplot(premium_data, aes(x = room_category, y = relative_premium_pct)) +
  geom_col(aes(fill = room_category), width = 0.6, alpha = 0.8) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray40", size = 0.8) +
  geom_text(aes(label = paste0(round(relative_premium_pct, 1), "%"), 
                y = relative_premium_pct + ifelse(relative_premium_pct > 0, 2, -2)), 
            size = 5, fontface = "bold") +
  scale_fill_manual(values = room_colors) +
  scale_y_continuous(labels = scales::percent_format(scale = 1),
                     breaks = seq(-30, 20, 10),
                     limits = c(-30, 25)) +
  labs(
    title = "Superhost Premium by Accommodation Type",
    subtitle = "Superhosts charge 22% LESS for private rooms, 17% MORE for entire places",
    x = "Accommodation Type",
    y = "Superhost Premium (%)",
    caption = "Source: InsideAirbnb Berlin Dataset | Analysis: 8,783 listings"
  ) +
  theme_academic +
  theme(legend.position = "none")

# Save the main finding
ggsave(here("outputs", "figures", "01_superhost_premium_comparison.png"), 
       p1_premium_comparison, width = 10, height = 6, dpi = 300, bg = "white")

cat("✅ Core finding visualization created: 01_superhost_premium_comparison.png\n")

# =============================================================================
# STEP 3: Price Distribution Analysis
# =============================================================================

cat("=== Step 3: Creating Price Distribution Visualizations ===\n")

# Box plot showing price distributions
p2_price_distributions <- ggplot(data, aes(x = room_category, y = price_numeric, fill = host_type)) +
  geom_boxplot(alpha = 0.7, outlier.size = 0.5, outlier.alpha = 0.3) +
  scale_fill_manual(values = superhost_colors) +
  scale_y_continuous(labels = scales::dollar_format(prefix = "€"),
                     trans = "log10",
                     breaks = c(25, 50, 100, 200, 400, 800)) +
  labs(
    title = "Price Distribution by Host Type and Room Category",
    subtitle = "Log scale shows clear pricing differences across groups",
    x = "Accommodation Type",
    y = "Price per Night (€, log scale)",
    fill = "Host Type",
    caption = "Boxes show median and quartiles | Outliers displayed as points"
  ) +
  theme_academic +
  theme(legend.position = "bottom")

# Save price distributions
ggsave(here("outputs", "figures", "02_price_distributions.png"), 
       p2_price_distributions, width = 12, height = 8, dpi = 300, bg = "white")

cat("✅ Price distribution visualization created: 02_price_distributions.png\n")

# =============================================================================
# STEP 4: Statistical Evidence Visualization
# =============================================================================

cat("=== Step 4: Creating Statistical Evidence Visualizations ===\n")

# Create confidence interval visualization
conf_intervals <- data.frame(
  test = c("Private Rooms", "Entire Places", "Premium Difference"),
  estimate = c(-21.19, 24.19, -38.99),
  ci_lower = c(-27.33, 18.52, -43.52),
  ci_upper = c(-15.06, 29.85, -34.45),
  p_value = c("p < 0.001", "p < 0.001", "p < 0.001"),
  significance = c("***", "***", "***")
)

p3_confidence_intervals <- ggplot(conf_intervals, aes(x = reorder(test, estimate), y = estimate)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray40", size = 0.8) +
  geom_errorbar(aes(ymin = ci_lower, ymax = ci_upper), width = 0.2, size = 1.2, color = "#2C3E50") +
  geom_point(size = 4, color = "#E74C3C") +
  geom_text(aes(label = paste0(round(estimate, 1), ifelse(abs(estimate) > 30, "%", "€"))), 
            hjust = -0.3, size = 4, fontface = "bold") +
  geom_text(aes(label = significance, y = ci_upper + 3), 
            size = 5, color = "#E74C3C", fontface = "bold") +
  coord_flip() +
  labs(
    title = "Statistical Test Results with 95% Confidence Intervals",
    subtitle = "All tests show significant differences (*** p < 0.001)",
    x = "Statistical Test",
    y = "Effect Size (€ for price differences, % for premium difference)",
    caption = "Error bars show 95% confidence intervals | *** indicates p < 0.001"
  ) +
  theme_academic

# Save confidence intervals
ggsave(here("outputs", "figures", "03_statistical_evidence.png"), 
       p3_confidence_intervals, width = 12, height = 6, dpi = 300, bg = "white")

cat("✅ Statistical evidence visualization created: 03_statistical_evidence.png\n")

# =============================================================================
# STEP 5: Sample Size and Effect Size Visualization
# =============================================================================

cat("=== Step 5: Creating Sample Size and Effect Size Visualizations ===\n")

# Prepare sample size data
sample_data <- sample_sizes %>%
  pivot_longer(cols = c(`Entire Place`, `Private Room`), 
               names_to = "room_category", values_to = "count") %>%
  mutate(room_category = factor(room_category, levels = c("Private Room", "Entire Place")))

# Sample size visualization
p4_sample_sizes <- ggplot(sample_data, aes(x = room_category, y = count, fill = host_type)) +
  geom_col(position = "dodge", alpha = 0.8, width = 0.7) +
  geom_text(aes(label = scales::comma(count)), 
            position = position_dodge(0.7), vjust = -0.5, size = 4, fontface = "bold") +
  scale_fill_manual(values = superhost_colors) +
  scale_y_continuous(labels = scales::comma_format(), 
                     breaks = seq(0, 5000, 1000),
                     expand = expansion(mult = c(0, 0.1))) +
  labs(
    title = "Sample Sizes by Host Type and Room Category",
    subtitle = "All groups have adequate sample sizes for statistical testing (n > 30)",
    x = "Accommodation Type",
    y = "Number of Listings",
    fill = "Host Type",
    caption = "Total sample: 8,783 listings across all groups"
  ) +
  theme_academic +
  theme(legend.position = "bottom")

# Save sample sizes
ggsave(here("outputs", "figures", "04_sample_sizes.png"), 
       p4_sample_sizes, width = 10, height = 6, dpi = 300, bg = "white")

cat("✅ Sample size visualization created: 04_sample_sizes.png\n")

# =============================================================================
# STEP 6: Comprehensive Summary Dashboard
# =============================================================================

cat("=== Step 6: Creating Comprehensive Research Dashboard ===\n")

# Create a summary statistics table for visualization
summary_stats <- group_means %>%
  select(host_type, room_category, n, mean_price, sd_price) %>%
  mutate(
    price_formatted = paste0("€", round(mean_price, 0), " (±", round(sd_price, 0), ")"),
    room_category = factor(room_category, levels = c("Private Room", "Entire Place"))
  )

# Create text summary for the dashboard
research_summary <- data.frame(
  metric = c("Research Question", "Sample Size", "Key Finding", "Statistical Result", "Effect Size"),
  value = c(
    "Do Superhosts achieve different relative\nprice premiums by accommodation type?",
    "8,783 Berlin Airbnb listings\n(adequate power across all groups)",
    "Private Rooms: -22.19%\nEntire Places: +16.79%\nDifference: 38.98%",
    "REJECT H₀\np < 2.2e-16\n95% CI: [-43.52%, -34.45%]",
    "Medium practical significance\nCohen's d = -0.559\nMeaningful market difference"
  )
)

# Create dashboard layout
p5_dashboard <- (p1_premium_comparison | p4_sample_sizes) / p2_price_distributions

# Save comprehensive dashboard
ggsave(here("outputs", "figures", "05_research_dashboard.png"), 
       p5_dashboard, width = 16, height = 12, dpi = 300, bg = "white")

cat("✅ Research dashboard created: 05_research_dashboard.png\n")

# =============================================================================
# STEP 7: Academic Presentation Figure
# =============================================================================

cat("=== Step 7: Creating Academic Presentation Figure ===\n")

# Create publication-ready main figure
p6_academic_figure <- ggplot(premium_data, aes(x = room_category, y = relative_premium_pct)) +
  geom_col(aes(fill = room_category), width = 0.5, alpha = 0.9) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", size = 0.8) +
  geom_text(aes(label = paste0(ifelse(relative_premium_pct > 0, "+", ""), 
                              round(relative_premium_pct, 1), "%"), 
                y = relative_premium_pct + ifelse(relative_premium_pct > 0, 1.5, -1.5)), 
            size = 6, fontface = "bold", color = "white") +
  scale_fill_manual(values = c("Private Room" = "#8E44AD", "Entire Place" = "#E67E22")) +
  scale_y_continuous(labels = scales::percent_format(scale = 1),
                     breaks = seq(-25, 20, 5),
                     limits = c(-25, 20)) +
  labs(
    title = "Differential Superhost Pricing Strategies in Berlin",
    subtitle = "Statistical evidence of accommodation-type specific market segmentation",
    x = "Accommodation Type",
    y = "Superhost Price Premium (%)",
    caption = "Source: InsideAirbnb Berlin (8,783 listings) | Statistical significance: p < 2.2e-16"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 14, hjust = 0.5, color = "gray30"),
    axis.title = element_text(size = 13, face = "bold"),
    axis.text = element_text(size = 12),
    legend.position = "none",
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    plot.caption = element_text(size = 10, hjust = 0, color = "gray50"),
    plot.margin = margin(20, 20, 20, 20)
  )

# Save academic presentation figure
ggsave(here("outputs", "figures", "06_academic_presentation.png"), 
       p6_academic_figure, width = 12, height = 8, dpi = 300, bg = "white")

cat("✅ Academic presentation figure created: 06_academic_presentation.png\n")

# =============================================================================
# STEP 8: Export Summary and Documentation
# =============================================================================

cat("=== Step 8: Creating Visualization Summary ===\n")

# Create visualization summary
viz_summary <- list(
  figures_created = 6,
  main_findings_visualized = c(
    "Core premium comparison (-22.19% vs +16.79%)",
    "Price distribution analysis by groups",
    "Statistical evidence with confidence intervals",
    "Sample size validation across groups",
    "Comprehensive research dashboard",
    "Academic presentation ready figure"
  ),
  technical_specifications = list(
    resolution = "300 DPI",
    format = "PNG with white background",
    color_palette = "Academic accessible colors",
    theme = "Professional minimal theme"
  ),
  academic_applications = c(
    "Research presentation",
    "Academic report illustration",
    "Conference presentation",
    "Portfolio demonstration"
  )
)

# Export visualization summary
capture.output(print(viz_summary), file = here("outputs", "results", "visualization_summary.txt"))

# Create figure index
figure_index <- data.frame(
  figure_number = 1:6,
  filename = c(
    "01_superhost_premium_comparison.png",
    "02_price_distributions.png", 
    "03_statistical_evidence.png",
    "04_sample_sizes.png",
    "05_research_dashboard.png",
    "06_academic_presentation.png"
  ),
  description = c(
    "Core finding: Differential Superhost premiums by accommodation type",
    "Price distribution analysis showing group differences",
    "Statistical evidence with confidence intervals and significance",
    "Sample size validation demonstrating adequate statistical power",
    "Comprehensive research dashboard combining key visualizations",
    "Publication-ready academic presentation figure"
  ),
  dimensions = c("10x6", "12x8", "12x6", "10x6", "16x12", "12x8"),
  use_case = c(
    "Main research finding presentation",
    "Data exploration and group comparison",
    "Statistical methodology validation", 
    "Research design validation",
    "Comprehensive overview presentation",
    "Academic publication and conference presentation"
  )
)

write_csv(figure_index, here("outputs", "tables", "figure_index.csv"))

cat("Visualization complete. Files created:\n")
cat("  - 6 publication-ready figures in outputs/figures/\n")
cat("  - Visualization summary in outputs/results/\n")
cat("  - Figure index in outputs/tables/\n\n")

# =============================================================================
# FINAL SUMMARY
# =============================================================================

cat("=== DATA VISUALIZATION COMPLETE ===\n")
cat("Processing completed:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
cat("All visualizations successfully created and exported.\n\n")

cat("🎨 VISUALIZATION SUMMARY:\n")
cat("✅ Core Research Finding: Premium comparison visualization\n")
cat("✅ Statistical Evidence: Confidence intervals and significance testing\n") 
cat("✅ Data Quality: Sample size and distribution analysis\n")
cat("✅ Academic Presentation: Publication-ready figures\n")
cat("✅ Comprehensive Dashboard: Multi-panel research overview\n\n")

cat("📊 Ready for academic presentation and portfolio showcase!\n")
cat("Your breakthrough findings about differential Superhost pricing\n")
cat("strategies are now professionally
