# Berlin Airbnb Superhost Premium Analysis

## Abstract

This study presents a comprehensive statistical analysis of Superhost pricing differentials across accommodation types in Berlin's Airbnb market. The research employs a multi-methodological approach combining hypothesis testing, quantile regression, interaction effects analysis, and predictive modeling to reveal sophisticated pricing strategies and validate findings through machine learning techniques.

**Academic Context:** Business Informatics, 5th Semester - Big Data & Data Analytics  
**Methodological Framework:** Multi-stage analysis pipeline with statistical validation  
**Primary Contribution:** Empirical evidence of differential pricing patterns with predictive utility

## Research Methodology

### Stage 1: Statistical Hypothesis Testing
- **Method:** Welch's t-tests with unequal variance assumption
- **Sample:** 8,783 listings after data cleaning
- **Primary Finding:** Inverse pricing pattern - Superhosts charge 22.19% less for private rooms, 16.79% more for entire apartments
- **Statistical Significance:** p < 2.2e-16 with medium effect size (Cohen's d = -0.559)

### Stage 2: Quantile Regression Analysis
- **Method:** Robust regression across price distribution quantiles (τ = 0.25, 0.5, 0.75, 0.9)
- **Sample:** Complete dataset of 8,808 listings including outliers
- **Objective:** Validate robustness of findings across entire price spectrum
- **Outcome:** Confirmed pricing strategy variations across market segments

### Stage 3: Interaction Effects Analysis
- **Method:** Price tier segmentation with systematic premium analysis
- **Approach:** Tertile-based clustering within accommodation types
- **Key Insight:** Superhosts demonstrate differentiated strategies - competitive pricing in budget segments, premium positioning in luxury tiers
- **Visualization:** Heatmap analysis revealing strategic market positioning

### Stage 4: Predictive Model Validation
- **Method:** Supervised learning with 70/30 stratified train-test split
- **Performance Metrics:** R² = 0.0087, RMSE = €399.05, MAE = €88.93
- **Validation Approach:** K-fold cross-validation for model robustness
- **Outcome:** Empirical confirmation of practical utility for identified pricing factors

## Statistical Evidence Summary

| **Analysis Method** | **Technique** | **Key Finding** | **Statistical Significance** |
|-------------------|-------------|-----------------|---------------------------|
| **Hypothesis Testing** | Welch's t-test | Inverse pricing pattern | p < 2.2e-16 |
| **Quantile Regression** | Robust estimation | Price segment strategy variation | Significant across all quantiles |
| **Interaction Effects** | Segmented analysis | Systematic differentiation | 4/6 segments statistically significant |
| **Predictive Modeling** | Machine learning validation | Practical applicability | R² = 0.0087 on test data |

## Technical Implementation

### Statistical Methods
- **Hypothesis Testing:** Welch's t-tests with bootstrap confidence intervals
- **Robust Analysis:** Quantile regression with outlier integration
- **Interaction Modeling:** Multi-factor ANOVA with price tier segmentation
- **Predictive Modeling:** Linear regression with cross-validation

### Software Environment
- **Platform:** R Statistical Computing Environment (v4.3+)
- **Core Packages:** quantreg, caret, effsize, car, psych, ggplot2, patchwork
- **Visualization:** Publication-quality graphics with academic formatting
- **Reproducibility:** Git version control with comprehensive documentation

## Repository Architecture

```
airbnb-berlin-superhost-analysis/
├── data/
│   ├── raw/                    # InsideAirbnb source data
│   └── processed/              # Analysis-ready datasets
├── scripts/                    # Complete analysis pipeline
│   ├── 01_data_import.R        # Data acquisition and validation
│   ├── 02_data_cleaning.R      # Conservative preprocessing for inference
││   ├── 03_exploratory_analysis.R    # Descriptive statistics and diagnostics
│   ├── 04_hypothesis_testing.R      # Formal statistical inference
│   ├── 05_visualization.R           # Publication-quality graphics
│   ├── 06_quantile_regression_analysis.R  # Robust regression analysis
│   ├── 07_interaction_effects_analysis.R  # Strategic segmentation analysis
│   └── 08_predictive_model_analysis.R     # Machine learning validation
├── outputs/
│   ├── figures/                # Statistical visualizations (11 figures)
│   ├── tables/                 # Comprehensive results (23+ tables)
│   └── results/                # Research conclusions and summaries
└── README.md                   # Project documentation
```

## Data Processing Methodology

This research implements dual data cleaning approaches optimized for distinct analytical objectives:

### Conservative Cleaning Pipeline (`02_data_cleaning.R`)
- **Objective:** Statistical inference and hypothesis testing
- **Approach:** Strict outlier removal using IQR-based bounds
- **Resulting Dataset:** 8,783 listings with rigorous quality control
- **Statistical Rationale:** Ensures robustness for inferential analyses through systematic exclusion of extreme values and incomplete records
- **Applications:** t-tests, quantile regression, interaction effects analysis


## Analytical Components

### 01_data_import.R - Data Acquisition Module
**Function:** Downloads and validates InsideAirbnb Berlin dataset  
**Technical Implementation:**
- Automated retrieval of listings.csv from InsideAirbnb repository
- Data quality validation protocol (missing values, data type verification)
- Source documentation generation with descriptive statistics
- Standardized directory structure initialization
- **Output:** Raw dataset (20,000+ listings) ready for preprocessing
- **Execution Time:** Approximately 30 seconds

### 02_data_cleaning.R - Data Preprocessing Module
**Function:** Comprehensive data preparation for statistical analysis and modeling  
**Technical Implementation:**
- IQR-based outlier detection and removal
- Systematic exclusion of incomplete records
- Categorical variable standardization and price normalization
- Accommodation type filtering (Entire Place, Private Room focus)
- Comprehensive data quality assessment
- **Output:** 8,783 listings optimized for analysis and modeling
- **Execution Time:** Approximately 45 seconds


### 03_exploratory_analysis.R - Descriptive Analysis Module
**Function:** Comprehensive statistical exploration and pattern identification  
**Technical Implementation:**
- Multi-group summary statistics generation
- Distribution analysis with normality testing protocols
- Correlation matrix construction and diagnostic testing
- Confounding variable identification procedures
- Statistical profiling with publication-ready tables
- **Output:** 15+ statistical tables and diagnostic visualizations
- **Execution Time:** Approximately 60 seconds

### 04_hypothesis_testing.R - Statistical Inference Module
**Function:** Formal hypothesis testing with effect size quantification  
**Technical Implementation:**
- Welch's t-tests for populations with unequal variances
- Cohen's d effect size calculation with confidence intervals
- Statistical assumption testing (normality, homoscedasticity)
- Bootstrap confidence interval generation for robust inference
- Publication-ready statistical result compilation
- **Output:** Hypothesis test results with p < 2.2e-16 significance
- **Execution Time:** Approximately 45 seconds

### 05_visualization.R - Statistical Graphics Module
**Function:** Publication-quality visualization for research presentation  
**Technical Implementation:**
- Box plot, violin plot, and distribution comparison graphics
- Academic color scheme implementation with professional formatting
- Confidence interval visualization with error bar plots
- Multi-panel figure composition using patchwork methodology
- Robust PDF compilation using ggsave method for reliable output
- Consistent theme application across all statistical graphics
- **Output:** 8+ high-resolution figures for publication + PDF compilation
- **Execution Time:** Approximately 30 seconds

### 06_quantile_regression_analysis.R - Robust Regression Module
**Function:** Quantile regression across price distribution for robustness validation  
**Technical Implementation:**
- Quantile regression implementation at τ = 0.25, 0.5, 0.75, 0.9
- Complete dataset utilization including previously excluded outliers
- Coefficient visualization across quantile spectrum
- Robust statistical inference resistant to extreme values
- Comprehensive quantile-specific result tabulation
- **Output:** Validated findings across complete price distribution
- **Execution Time:** Approximately 90 seconds

### 07_interaction_effects_analysis.R - Strategic Segmentation Module
**Function:** Price tier analysis revealing strategic differentiation patterns  
**Technical Implementation:**
- Tertile-based price segmentation within accommodation categories
- Systematic t-test implementation across price segments
- Professional heatmap construction for strategic positioning visualization
- Interaction effect analysis between price and Superhost status
- Strategic market positioning insight generation
- **Output:** Professional heatmap and 6 segment-specific analyses
- **Execution Time:** Approximately 60 seconds

### 08_predictive_model_analysis.R - Machine Learning Validation Module
**Function:** Predictive modeling demonstrating practical research applicability  
**Technical Implementation:**
- Stratified 70/30 train-test data partitioning
- Linear regression model construction with comprehensive feature engineering
- K-fold cross-validation for model robustness assessment
- Performance metric calculation (R², RMSE, MAE)
- Residual analysis and diagnostic plot generation
- **Output:** Validated predictive model with quantified performance metrics
- **Execution Time:** Approximately 60 seconds

## Reproduction Protocol

### Complete Analysis Pipeline
```bash
# Repository acquisition
git clone https://github.com/g8rdier/airbnb-berlin-superhost-analysis.git
cd airbnb-berlin-superhost-analysis

# Sequential script execution
source("scripts/01_data_import.R")
source("scripts/02_data_cleaning.R")
source("scripts/03_exploratory_analysis.R")
source("scripts/04_hypothesis_testing.R")
source("scripts/05_visualization.R")
source("scripts/06_quantile_regression_analysis.R")
source("scripts/07_interaction_effects_analysis.R")
source("scripts/08_predictive_model_analysis.R")
```

**Total Pipeline Execution Time:** 5-6 minutes for complete analysis

## Research Contributions

### Methodological Innovations
- **Multi-Method Validation Framework:** Analytical robustness through diverse statistical approaches
- **Outlier-Inclusive Analysis:** Quantile regression methodology ensuring complete market coverage
- **Predictive Validation Protocol:** Machine learning confirmation of statistical findings for practical relevance

### Empirical Insights
- **Strategic Differentiation Evidence:** Quantitative proof of sophisticated pricing strategies across market segments
- **Platform Economics Contribution:** Addition to sharing economy pricing behavior literature
- **Practical Applications:** Actionable insights for accommodation hosts and platform operators

### Key Empirical Findings

**Entire Apartment Accommodation:**
- Budget segment: +5.3% Superhost premium
- Medium segment: +0.04% premium
- Expensive segment: -19.9% discount

**Private Room Accommodation:**
- Budget segment: +14.0% premium
- Medium segment: +0.5% premium
- Expensive segment: -40.5% discount

## Research Status

**Methodological Status:** Multi-method statistical analysis with predictive validation  
**Academic Standard:** Publication-ready methodology with complete reproducibility  
**Completion Date:** August 2025  
**Recent Updates:** Enhanced PDF visualization compilation with reliable ggsave method (August 2025)

### Analytical Components Status

**Quantile Regression Analysis**
- Validated findings across price distribution (τ = 0.25, 0.5, 0.75, 0.9)
- Confirmed inverse pricing pattern through robust methodology
- Complete dataset analysis incorporating price outliers

**Interaction Effects Analysis**
- Systematic analysis of Superhost pricing strategies by price segment within accommodation types
- Tertile-based segmentation with statistical significance testing
- Professional heatmap visualization of systematic pricing differentiation

**Predictive Model Validation**
- Stratified train-test split implementation (70/30 ratio)
- Practical applicability validation: R² = 0.0087, RMSE = €399.05, MAE = €88.93
- Empirical demonstration of Superhost status and accommodation feature predictive power

## Academic Documentation

**Principal Investigator:** Gregor Kobilarov  
**Academic Level:** Business Informatics, 5th Semester  
**Institution:** IU International University of Applied Sciences  
**Research Supervisor:** Prof. Dr. rer. nat. Michael Barth  
**Research Period:** August 2025

### Recommended Citation
```
Kobilarov, G. (2025). Advanced Statistical Analysis of Superhost Pricing Strategies
in Berlin's Airbnb Market: A Multi-Method Approach to Pricing Differentiation and
Predictive Validation. Business Informatics Research Project,
IU International University, Germany.
```

---

**Statistical Validation:** Multiple methodologies confirm robust, statistically significant findings  
**Practical Utility:** Demonstrated through successful predictive modeling implementation  
**Academic Standard:** Publication-ready methodology with complete reproducibility protocols

*This research demonstrates advanced data analytics methodology with significant contributions to understanding platform-based pricing strategies in the sharing economy.*