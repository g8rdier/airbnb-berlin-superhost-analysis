# Berlin Airbnb Superhost Premium Analysis

## Project Overview
Statistical analysis of Superhost pricing differentials across accommodation types in Berlin's Airbnb market, revealing differential pricing patterns between private rooms and entire apartments.

**Study Context:** 5th Semester Business Informatics - Big Data & Data Analytics  
**Statistical Significance:** p < 2.2e-16

## Research Question & Hypothesis
**Research Question:** Do Superhosts achieve different relative price premiums for private rooms compared to entire apartments in Berlin?

**Hypothesis Testing:**
- **H₀:** The relative price premium of Superhosts does not differ significantly between private rooms and entire apartments in Berlin
- **H₁:** The relative price premium of Superhosts differs significantly between private rooms and entire apartments in Berlin

**Result:** **✅ REJECT H₀** - Significant differential pricing confirmed

## Research Findings

### **Key Finding: Inverse Premium Pattern**
| **Accommodation Type** | **Superhost Premium** | **Statistical Significance** |
|------------------------|---------------------|------------------------------|
| **Private Rooms** | **-22.19%** (Superhosts charge less) | p = 1.599e-11 |
| **Entire Places** | **+16.79%** (Superhosts charge more) | p < 2.2e-16 |
| **Differential** | **38.98% difference** | p < 2.2e-16 |

### **Statistical Validation**
- **Statistical Significance:** p < 2.2e-16 (highly significant)
- **Effect Size:** Medium practical significance (Cohen's d = -0.559)
- **Sample Size:** 8,783 analysis-ready listings across all groups
- **Confidence Interval:** 95% CI [-43.52%, -34.45%]
- **Quantile Regression Validation:** Findings confirmed across price distribution (τ=0.25, 0.5, 0.75, 0.9)

## Data Source & Documentation

### **Dataset Information**
- **Source:** InsideAirbnb Berlin Dataset
- **Initial Sample:** 14,187 listings (July 2025)
- **Analysis Sample:** 8,783 listings (after quality filtering)
- **Geographic Scope:** Berlin metropolitan area
- **Data Quality:** Zero missing values in critical variables

### **Extended Analysis**
🔬 **Quantile Regression Analysis** validates findings across price segments:
- **Budget Segment (Q25):** Entire apartments +12.0%, Private rooms +8.3%
- **Luxury Segment (Q90):** Entire apartments +18.7%, Private rooms -30.2%
- **Full Dataset:** 8,808 listings including price outliers (€5-€10,000)
- **Methodology:** Robust statistical approach using bootstrap standard errors

🎯 **Interaction Effects Analysis** reveals strategic pricing differentiation:
- **Market Segmentation:** Price tertiles within accommodation types show systematic patterns
- **Entire Apartments:** +5.3% premium (cheap), +0.04% (medium), -19.9% discount (expensive)
- **Private Rooms:** +14.0% premium (cheap), +0.5% (medium), -40.5% discount (expensive)
- **Statistical Power:** 4 out of 6 segments statistically significant with adequate samples

### **Data Documentation**
📋 Data documentation is available at [`data/README.md`](data/README.md), including:
- Dataset descriptions and variable definitions
- Data processing pipeline documentation
- Quality metrics and sample characteristics
- Source attribution and usage guidelines

### **Data Repository Policy**
**Note:** Raw data files are not included in this repository, following standard best practices for academic projects. This approach:
- Maintains repository efficiency and manageable file sizes
- Respects data source terms and attribution requirements
- Encourages users to obtain fresh data directly from InsideAirbnb
- Ensures reproducibility with current datasets

The `data/raw/` directory structure is maintained for reference, and the import script (`01_data_import.R`) provides clear instructions for obtaining the source data.

## Technology Stack
- **R & RStudio:** Statistical analysis and visualization
- **GitHub:** Version control and documentation
- **Tidyverse:** Data manipulation and analysis
- **Statistical Packages:** effsize, car, psych, nortest
- **Visualization:** ggplot2, scales, patchwork

## Repository Structure & Workflow

### **Directory Organization**
```
airbnb-berlin-superhost-analysis/
├── data/
│ ├── raw/ # Raw data storage (not tracked)
│ │ └── listings.csv # InsideAirbnb data (download required)
│ ├── processed/ # Analysis-ready datasets
│ │ ├── cleaned_airbnb_berlin.csv # Main cleaned dataset (36 variables)
│ │ └── hypothesis_testing_data.csv # Focused dataset (10 variables)
│ └── README.md # Comprehensive data documentation
├── scripts/ # Analysis pipeline (run sequentially)
│ ├── 01_data_import.R # Downloads and validates raw data
│ ├── 02_data_cleaning.R # Preprocessing and quality control
│ ├── 03_exploratory_analysis.R # Statistical exploration and EDA
│ ├── 04_hypothesis_testing.R # Statistical validation and testing
│ ├── 05_visualization.R # Figure generation and export
│ ├── 06_quantile_regression_analysis.R # Extended quantile regression analysis
│ └── 07_interaction_effects_analysis.R # Price segment interaction effects analysis
├── outputs/ # Generated analysis results
│ ├── figures/ # Statistical visualizations (PNG, 300 DPI)
│ │ ├── 01_premium_comparison.png
│ │ ├── 02_price_distributions.png
│ │ ├── 03_sample_sizes.png
│ │ ├── 04_statistical_evidence.png
│ │ ├── 05_combined_academic_presentation.png
│ │ ├── 06_quantile_regression_analysis.png
│ │ ├── 07_interaction_effects_heatmap.png
│ │ └── 07_interaction_effects_context.png
│ ├── tables/ # Summary statistics (CSV format)
│ │ ├── descriptive_statistics.csv
│ │ ├── premium_calculations.csv
│ │ ├── effect_size_summary.csv
│ │ ├── bootstrap_analysis.csv
│ │ ├── quantile_regression_results.csv
│ │ ├── quantile_premiums_by_accommodation.csv
│ │ ├── method_comparison.csv
│ │ ├── interaction_effects_analysis.csv
│ │ ├── price_segmentation_summary.csv
│ │ ├── interaction_model_coefficients.csv
│ │ └── [6 additional statistical tables]
│ └── results/ # Research conclusions
│ ├── hypothesis_test_results.csv
│ ├── detailed_test_statistics.csv
│ ├── academic_summary.txt
│ └── interaction_effects_interpretation.txt
├── reports/ # Academic documentation (planned)
└── README.md # Project overview (this file)
```

### **Analysis Pipeline Workflow**

The analysis follows a **sequential 7-step pipeline** where each script depends on outputs from previous steps:

| **Step** | **Script** | **Input** | **Output** | **Purpose** |
|----------|------------|-----------|------------|-------------|
| **1** | `01_data_import.R` | InsideAirbnb URL | `raw/listings.csv` | Data acquisition and validation |
| **2** | `02_data_cleaning.R` | `raw/listings.csv` | `processed/cleaned_airbnb_berlin.csv` | Quality control and preprocessing |
| **3** | `03_exploratory_analysis.R` | `processed/cleaned_airbnb_berlin.csv` | `tables/`, `hypothesis_testing_data.csv` | Statistical exploration |
| **4** | `04_hypothesis_testing.R` | `hypothesis_testing_data.csv` | `results/`, additional `tables/` | Statistical validation |
| **5** | `05_visualization.R` | All previous outputs | `figures/` | Publication-ready visualizations |
| **6** | `06_quantile_regression_analysis.R` | `raw/listings.csv` | `quantile_regression_*.csv`, `figures/` | Extended quantile regression analysis |
| **7** | `07_interaction_effects_analysis.R` | `raw/listings.csv` | `interaction_effects_*.csv`, `heatmap.png` | Price segment interaction analysis |

### **Automated Directory Creation**
Each script automatically creates required output directories if they don't exist:
- `outputs/figures/`
- `outputs/tables/`
- `outputs/results/`
- `data/processed/`

## Getting Started

### **Prerequisites**
- **R (≥ 4.0)** and **RStudio**
- **Internet connection** for data download
- **Git** for repository cloning

### **Quick Start Guide**

#### **1. Repository Setup**
Clone the repository
```
git clone https://github.com/g8rdier/airbnb-berlin-superhost-analysis.git
cd airbnb-berlin-superhost-analysis
```
Open in RStudio
File -> Open Project -> select airbnb-berlin-superhost-analysis.Rproj


#### **2. Data Acquisition**
The first script will guide you through data download:

Run data import (downloads data automatically)
```
source("scripts/01_data_import.R")
```

This creates `data/raw/listings.csv` (~2.6MB) from InsideAirbnb.

#### **3. Complete Analysis Pipeline**
Run scripts in sequence (each depends on previous outputs):

Complete pipeline execution
```
source("scripts/01_data_import.R") # Creates: raw data
source("scripts/02_data_cleaning.R") # Creates: cleaned datasets + 1 table
source("scripts/03_exploratory_analysis.R") # Creates: 8 tables + hypothesis data
source("scripts/04_hypothesis_testing.R") # Creates: 3 results + 5 tables
source("scripts/05_visualization.R") # Creates: 5 publication figures
source("scripts/06_quantile_regression_analysis.R") # Creates: quantile analysis + visualization
source("scripts/07_interaction_effects_analysis.R") # Creates: interaction analysis + heatmap
```

### **Expected Execution Time**
- **Script 1 (Data Import):** ~30 seconds (download dependent)
- **Script 2 (Data Cleaning):** ~45 seconds  
- **Script 3 (Exploratory Analysis):** ~60 seconds
- **Script 4 (Hypothesis Testing):** ~45 seconds
- **Script 5 (Visualization):** ~30 seconds
- **Script 6 (Quantile Regression):** ~90 seconds (bootstrap standard errors)
- **Script 7 (Interaction Effects):** ~60 seconds (price segmentation and t-tests)
- **Total Pipeline:** ~5-6 minutes

### **Package Dependencies**
All required packages are automatically installed by each script:
- **Core:** `tidyverse`, `here`
- **Statistical:** `effsize`, `car`, `psych`, `nortest`, `quantreg`
- **Visualization:** `ggplot2`, `scales`, `patchwork`, `viridis`, `RColorBrewer`
- **Utilities:** `janitor`, `broom`, `gt`, `purrr`

## Troubleshooting

### **Common Issues**
- **Missing data file errors:** Ensure scripts run in sequence (Script 3 needs Script 2 output)
- **Package installation:** Scripts handle automatic installation, but manual install may be needed: `install.packages("package_name")`
- **Working directory:** Ensure RStudio project is opened or set `setwd()` to repository root
- **Internet connection:** Required for initial data download in Script 1

### **Output Verification**
After running the complete pipeline, verify these outputs exist:
- `data/processed/` → 2 datasets
- `outputs/tables/` → 16+ CSV files (including quantile and interaction analysis)
- `outputs/results/` → 4 research conclusion files (including interaction interpretation)
- `outputs/figures/` → 8 PNG visualizations (including heatmap and context plots)

## Key Research Outputs

### **Visualizations** (outputs/figures/)
- Core premium comparison showing inverse pricing pattern
- Price distribution analysis by host type and accommodation category
- Statistical evidence with confidence intervals and significance testing
- Sample size validation demonstrating adequate statistical power
- Combined dashboard for research overview

### **Statistical Evidence** (outputs/results/)
- Hypothesis testing results with p < 2.2e-16 significance
- Bootstrap analysis validation and effect size summaries  
- Academic summary documentation for peer review

## Methodology

### **Statistical Approach**
- **Multiple validation approaches:** Welch's t-tests, bootstrap analysis, quantile regression, interaction effects
- **Assumption testing:** Normality, variance equality validation  
- **Effect size analysis:** Cohen's d with practical significance interpretation
- **Confidence intervals:** 95% CI for all major estimates
- **Quantile regression:** Analysis across price distribution (τ=0.25, 0.5, 0.75, 0.9) with bootstrap standard errors
- **Interaction analysis:** Price segment stratification with systematic premium testing across market tiers

### **Project Standards**
- **Academic project structure** following data science conventions
- **English documentation** for international accessibility
- **Reproducible research** with complete automation
- **Version control** with systematic development

## Research Impact

### **Academic Significance**
This analysis provides quantitative evidence of differential Superhost pricing patterns:
- **Price Differentiation:** Different pricing approaches by accommodation type
- **Market Behavior:** Evidence of host pricing strategies in sharing economy
- **Platform Economics:** Findings relevant to sharing economy pricing research

### **Practical Implications**
- **For Aspiring Superhosts:** Insights about pricing patterns by accommodation type
- **For Market Analysis:** Evidence of host behavior differentiation in sharing economy
- **For Academic Research:** Contribution to sharing economy and pricing literature

## Author
**Gregor Kobilarov**  
Business Informatics, 5th Semester  
Dual Studies Program  

**Academic Supervisor:** Prof. Dr. rer. nat. Barth  
**Institution:** IU International University of Applied Sciences

## Project Status
**🔄 IN PROGRESS** - August 2025  
**Current Phase:** Extended Analysis - Step 2 of 3 completed  
**Completed:** Hypothesis testing, quantile regression analysis, interaction effects analysis  
**Next Steps:** Predictive modeling with train/test validation

### **Analysis Roadmap**
**✅ STEP 1: QUANTILE REGRESSION ANALYSIS** *(Completed)*
- Validated findings across price distribution (τ=0.25, 0.5, 0.75, 0.9)
- Confirmed inverse pricing pattern with robust methodology
- Full dataset analysis including price outliers

**✅ STEP 2: INTERACTION EFFECTS ANALYSIS** *(Completed)*
- Analyzed Superhost pricing strategies by price segment within accommodation types
- Segmented listings into price tertiles (cheap/medium/expensive) with statistical testing
- Created professional heatmap showing systematic pricing differentiation
- **Key Finding:** Entire apartments: +5.3% cheap, -19.9% expensive; Private rooms: +14.0% cheap, -40.5% expensive

**📋 STEP 3: PREDICTIVE MODEL WITH TRAIN/TEST VALIDATION** *(Planned)*
- Build price prediction model with 70/30 stratified train/test split
- Validate practical applicability with R², RMSE, MAE metrics
- Demonstrate predictive power of Superhost status and accommodation features

---

### **Research Citation**
```
Kobilarov, G. (2025). Differential Superhost Pricing Strategies in Berlin's Airbnb Market:
Evidence of Accommodation-Type Specific Market Segmentation.
Dual Studies Program - Business Informatics, 5th Semester, IU International University, Germany.
```

*This project demonstrates statistical analysis methodology with findings about differential pricing patterns in sharing economy markets, contributing insights to academic literature on platform pricing behavior.*
