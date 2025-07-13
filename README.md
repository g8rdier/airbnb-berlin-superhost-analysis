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

## Data Source & Documentation

### **Dataset Information**
- **Source:** InsideAirbnb Berlin Dataset
- **Initial Sample:** 14,187 listings (July 2025)
- **Analysis Sample:** 8,783 listings (after quality filtering)
- **Geographic Scope:** Berlin metropolitan area
- **Data Quality:** Zero missing values in critical variables

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

## Project Structure
```
airbnb-berlin-superhost-analysis/
├── data/
│ ├── raw/ # Data download location (not tracked)
│ ├── processed/ # Cleaned, analysis-ready datasets
│ └── README.md # 📋 Data documentation
├── scripts/
│ ├── 01_data_import.R # Data loading pipeline
│ ├── 02_data_cleaning.R # Statistical preprocessing
│ ├── 03_exploratory_analysis.R # Exploratory data analysis
│ ├── 04_hypothesis_testing.R # Statistical validation
│ └── 05_visualization.R # Figure generation
├── outputs/
│ ├── figures/ # 5 statistical visualizations
│ ├── tables/ # 10+ statistical summary tables
│ └── results/ # Hypothesis testing conclusions
├── reports/ # Academic documentation
└── README.md # Project overview (this file)
```
5. **View results:** Check `outputs/figures/` for visualizations, `outputs/results/` for conclusions

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

## Author
**Gregor Kobilarov**  
Business Informatics, 5th Semester  
Dual Studies Program  

**Academic Supervisor:** Prof. Dr. rer. nat. Barth  
**Institution:** IU International University of Applied Sciences

## Project Status
**✅ COMPLETED** - July 2025  
**Research Status:** Analysis completed with statistically significant findings  
**Documentation Status:** Ready for academic evaluation

---

### **Research Citation**
```
Kobilarov, G. (2025). Differential Superhost Pricing Strategies in Berlin's Airbnb Market:
Evidence of Accommodation-Type Specific Market Segmentation.
Dual Studies Program - Business Informatics, 5th Semester, IU International University, Germany.
```

*This project demonstrates statistical analysis methodology with findings about differential pricing patterns in sharing economy markets, contributing insights to academic literature on platform pricing behavior.*
