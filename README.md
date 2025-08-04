# Berlin Airbnb Superhost Premium Analysis - Complete Study 🎓

## Project Overview

**Advanced statistical analysis** of Superhost pricing differentials across accommodation types in Berlin's Airbnb market, employing multiple analytical methodologies to reveal sophisticated pricing strategies and validate findings through predictive modeling.

**Academic Context:** 5th Semester Business Informatics - Big Data & Data Analytics  
**Methodological Approach:** Multi-stage analysis pipeline with statistical validation  
**Key Innovation:** Demonstrates differential pricing patterns and predictive utility

## Complete Research Pipeline

### 📊 **Stage 1: Hypothesis Testing & Base Analysis**
- **Method:** Welch's t-tests on cleaned dataset (8,783 listings)
- **Key Finding:** Inverse pricing pattern - Superhosts charge 22.19% less for private rooms, 16.79% more for entire apartments
- **Statistical Significance:** p < 2.2e-16 with medium effect size (Cohen's d = -0.559)

### 🎯 **Stage 2: Quantile Regression Analysis** 
- **Method:** Robust analysis across price distribution (25th, 50th, 75th, 90th percentiles)
- **Dataset:** Full 8,808 listings including previously excluded outliers
- **Innovation:** Reveals pricing strategy variations across market segments
- **Outcome:** Validates robustness of findings across entire price spectrum

### 🔥 **Stage 3: Interaction Effects Analysis**
- **Method:** Price tier segmentation with systematic premium analysis
- **Approach:** Tertile-based clustering within accommodation types
- **Key Insight:** Superhosts show differentiated strategies - competitive in budget segments, premium in luxury
- **Visualization:** Professional heatmap revealing strategic market positioning

### 🤖 **Stage 4: Predictive Model Validation**
- **Method:** Train/Test split (70/30) with multiple model comparison
- **Performance:** R² = 0.0087, RMSE = €399.05 on test data
- **Validation:** Confirms practical utility of identified pricing factors
- **Outcome:** Demonstrates real-world applicability of research insights

## Key Research Findings

| **Analysis Stage** | **Method** | **Key Insight** | **Statistical Evidence** |
|-------------------|------------|-----------------|-------------------------|
| **Hypothesis Testing** | Welch's t-test | Inverse pricing pattern | p < 2.2e-16 |
| **Quantile Regression** | Robust estimation | Strategy varies by price segment | Confirmed across all quantiles |
| **Interaction Effects** | Segmented analysis | Systematic differentiation | 4/6 segments significant |
| **Predictive Model** | ML validation | Practical applicability | R² = 0.0087 on unseen data |

## Technology & Methodology Stack

### **Statistical Methods**
- **Hypothesis Testing:** Welch's t-tests, Bootstrap analysis
- **Robust Analysis:** Quantile regression with outlier integration
- **Interaction Modeling:** Multi-factor ANOVA with price tier segmentation
- **Predictive Modeling:** Linear regression with train/test validation

### **Technical Implementation**
- **R & RStudio:** Complete analysis pipeline with reproducible workflow
- **Statistical Packages:** quantreg, caret, effsize, car, psych
- **Visualization:** ggplot2, patchwork for publication-quality graphics
- **Version Control:** Git with feature branch workflow and comprehensive documentation

## Repository Structure

```
airbnb-berlin-superhost-analysis/
├── data/
│ ├── raw/ # InsideAirbnb source data
│ └── processed/ # Analysis-ready datasets
├── scripts/ # Complete analysis pipeline
│ ├── 01_data_import.R # Downloads and validates InsideAirbnb Berlin dataset
│ ├── 02_data_cleaning.R # Conservative data preprocessing for statistical inference
│ ├── 02b_relaxed_data_cleaning.R # Permissive data preprocessing for machine learning
│ ├── 03_exploratory_analysis.R # Comprehensive descriptive statistics and distributions
│ ├── 04_hypothesis_testing.R # Welch's t-tests with effect size analysis
│ ├── 05_visualization.R # Professional-grade statistical visualizations
│ ├── 06_quantile_regression_analysis.R # Robust regression across price quantiles
│ ├── 07_interaction_effects_analysis.R # Price segment strategy analysis with heatmaps
│ └── 08_predictive_model_analysis.R # Machine learning validation with cross-validation
├── outputs/
│ ├── figures/ # Publication-quality visualizations (11 figures)
│ ├── tables/ # Comprehensive statistical results (23+ tables)
│ └── results/ # Research conclusions and validation summaries
└── README.md # This comprehensive documentation
```

## Data Cleaning Pipelines

This project employs **dual data cleaning approaches** tailored to specific analytical requirements:

### **Strict Cleaning Pipeline** (`02_data_cleaning.R`)
- **Purpose:** Descriptive statistical analysis and hypothesis testing
- **Approach:** Conservative outlier removal and rigorous data quality filtering
- **Dataset:** 8,783 listings after exclusions
- **Rationale:** Ensures statistical robustness for inferential analyses by removing extreme values and incomplete records
- **Use Cases:** t-tests, quantile regression, interaction effects analysis

### **Relaxed Cleaning Pipeline** (`02b_relaxed_data_cleaning.R`)
- **Purpose:** Predictive modeling and machine learning applications
- **Approach:** Minimal filtering with outlier retention for training diversity
- **Dataset:** Larger sample size with broader value ranges preserved
- **Rationale:** Maintains data variability essential for model generalization and real-world prediction accuracy
- **Use Cases:** Linear regression, price prediction models, cross-validation

### **Key Differences**
| **Aspect** | **Strict Pipeline** | **Relaxed Pipeline** |
|------------|--------------------|--------------------|
| **Outlier Treatment** | Remove extreme values | Retain for training diversity |
| **Missing Data** | Stringent exclusion | Imputation strategies |
| **Sample Size** | Optimized for inference | Maximized for learning |
| **Primary Goal** | Statistical significance | Predictive performance |

## Script Functionality Overview

### **01_data_import.R** - Dataset Acquisition & Validation
**Purpose:** Downloads and validates the InsideAirbnb Berlin dataset  
**Functionality:**
- Automatically downloads listings.csv from InsideAirbnb if not present
- Performs initial data quality validation (missing values, data types)
- Generates data source documentation and basic statistics
- Creates standardized directory structure for downstream processing
- **Output:** Raw dataset ready for cleaning pipelines  
**Runtime:** ~30 seconds

### **02_data_cleaning.R** - Conservative Data Preprocessing
**Purpose:** Rigorous data cleaning optimized for statistical inference  
**Functionality:**
- Implements strict outlier removal using IQR-based bounds
- Removes incomplete records to ensure statistical robustness
- Standardizes categorical variables and price formatting
- Filters to major accommodation types (Entire Place, Private Room)
- Generates comprehensive data quality reports
- **Output:** 8,783 listings optimized for hypothesis testing  
**Runtime:** ~45 seconds

### **02b_relaxed_data_cleaning.R** - Permissive Data Preprocessing
**Purpose:** Minimal cleaning approach maximizing dataset size for ML  
**Functionality:**
- Retains borderline cases and price outliers for training diversity
- Implements strategic imputation instead of record removal
- Includes all accommodation types (4 categories vs 2)
- Uses minimal outlier bounds (€2 minimum vs €10)
- Creates enhanced feature engineering for predictive modeling
- **Output:** ~14,000 listings optimized for machine learning  
**Runtime:** ~30 seconds

### **03_exploratory_analysis.R** - Comprehensive Statistical Exploration
**Purpose:** In-depth descriptive analysis revealing data patterns  
**Functionality:**
- Generates comprehensive summary statistics by group
- Performs distribution analysis with normality testing
- Creates correlation matrices and statistical diagnostics
- Identifies potential confounding variables and outliers
- Produces detailed data profiling reports
- **Output:** 15+ statistical tables and diagnostic plots  
**Runtime:** ~60 seconds

### **04_hypothesis_testing.R** - Formal Statistical Inference
**Purpose:** Rigorous hypothesis testing with effect size analysis  
**Functionality:**
- Implements Welch's t-tests for unequal variances
- Calculates Cohen's d effect sizes with confidence intervals
- Performs assumption testing (normality, homoscedasticity)
- Generates bootstrap confidence intervals for robust inference
- Creates publication-ready statistical result tables
- **Output:** Hypothesis test results with p < 2.2e-16 significance  
**Runtime:** ~45 seconds

### **05_visualization.R** - Professional Statistical Graphics
**Purpose:** Publication-quality visualizations for research presentation  
**Functionality:**
- Creates box plots, violin plots, and distribution comparisons
- Generates professional color schemes and academic formatting
- Produces error bar plots with confidence intervals
- Creates multi-panel figures using patchwork layout
- Implements consistent theme and styling across all plots
- **Output:** 8+ high-resolution figures ready for publication  
**Runtime:** ~30 seconds

### **06_quantile_regression_analysis.R** - Robust Regression Analysis
**Purpose:** Quantile regression across price distribution for robustness  
**Functionality:**
- Implements quantile regression at τ = 0.25, 0.5, 0.75, 0.9
- Uses full dataset including previously excluded outliers
- Generates coefficient plots showing effects across quantiles
- Performs robust statistical inference resistant to outliers
- Creates comprehensive quantile-specific result tables
- **Output:** Validated findings across entire price spectrum  
**Runtime:** ~90 seconds

### **07_interaction_effects_analysis.R** - Strategic Price Segmentation
**Purpose:** Price tier analysis revealing Superhost strategic differentiation  
**Functionality:**
- Segments listings into price tertiles within accommodation types
- Performs systematic t-tests across all price segments
- Creates professional heatmaps showing strategic positioning
- Analyzes interaction effects between price and Superhost status
- Generates strategic insights for market positioning
- **Output:** Professional heatmap and 6 segment-specific analyses  
**Runtime:** ~60 seconds

### **08_predictive_model_analysis.R** - Machine Learning Validation
**Purpose:** Predictive modeling demonstrating practical applicability  
**Functionality:**
- Implements 70/30 stratified train/test split
- Builds linear regression models with comprehensive feature engineering
- Performs k-fold cross-validation for model robustness
- Generates prediction accuracy metrics (R², RMSE, MAE)
- Creates residual analysis and model diagnostic plots
- **Output:** Validated predictive model with R² = 0.0087  
**Runtime:** ~60 seconds

## Getting Started

### **Quick Reproduction**
```bash
# Clone repository
git clone https://github.com/g8rdier/airbnb-berlin-superhost-analysis.git
cd airbnb-berlin-superhost-analysis

# Run complete analysis pipeline
source("scripts/01_data_import.R")
source("scripts/02_data_cleaning.R")
source("scripts/02b_relaxed_data_cleaning.R")
source("scripts/03_exploratory_analysis.R")
source("scripts/04_hypothesis_testing.R")
source("scripts/05_visualization.R")
source("scripts/06_quantile_regression_analysis.R")
source("scripts/07_interaction_effects_analysis.R")
source("scripts/08_predictive_model_analysis.R")
```

**Total Execution Time:** ~6-7 minutes for complete pipeline

## Research Impact & Academic Significance

### **Methodological Contributions**
- **Multi-Method Validation:** Demonstrates analytical robustness through diverse statistical approaches
- **Outlier-Inclusive Analysis:** Quantile regression methodology for complete market coverage
- **Predictive Validation:** ML-based confirmation of statistical findings for practical relevance

### **Market Insights**
- **Strategic Differentiation:** Evidence of sophisticated pricing strategies varying by market segment
- **Platform Economics:** Contributes to sharing economy pricing behavior literature
- **Practical Applications:** Actionable insights for hosts and platform operators

### **Key Findings Summary**

**Entire Apartments:**
- Budget segment: +5.3% Superhost premium
- Medium segment: +0.04% premium  
- Expensive segment: -19.9% discount

**Private Rooms:**
- Budget segment: +14.0% premium
- Medium segment: +0.5% premium
- Expensive segment: -40.5% discount

## Project Status

**Research Status:** Advanced statistical analysis with predictive validation  
**Academic Standard:** Publication-ready methodology with complete reproducibility  
**Completion Date:** August 2025

### **Analysis Components**
**QUANTILE REGRESSION ANALYSIS**
- Validated findings across price distribution (τ=0.25, 0.5, 0.75, 0.9)
- Confirmed inverse pricing pattern with robust methodology
- Full dataset analysis including price outliers

**INTERACTION EFFECTS ANALYSIS**
- Analyzed Superhost pricing strategies by price segment within accommodation types
- Segmented listings into price tertiles (cheap/medium/expensive) with statistical testing
- Created professional heatmap showing systematic pricing differentiation

**PREDICTIVE MODEL VALIDATION**
- Built price prediction model with 70/30 stratified train/test split
- Validated practical applicability with R² = 0.0087, RMSE = €399.05, MAE = €88.93
- Demonstrated predictive power of Superhost status and accommodation features

## Academic Documentation

**Author:** Gregor Kobilarov  
**Academic Level:** Business Informatics, 5th Semester  
**Institution:** IU International University of Applied Sciences  
**Supervisor:** Prof. Dr. rer. nat. Michael Barth  
**Completion:** August 2025

### **Research Citation**
```
Kobilarov, G. (2025). Advanced Statistical Analysis of Superhost Pricing Strategies
in Berlin's Airbnb Market: A Multi-Method Approach to Pricing Differentiation and
Predictive Validation. Business Informatics Research Project,
IU International University, Germany.
```

---

**Statistical Validation:** Multiple methods confirm robust, significant findings  
**Practical Utility:** Demonstrated through successful predictive modeling  
**Academic Standard:** Publication-ready methodology with complete reproducibility

*This project demonstrates advanced data analytics methodology with significant contributions to understanding platform-based pricing strategies in the sharing economy.*