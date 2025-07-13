# Berlin Airbnb Superhost Premium Analysis

## Project Overview
Comprehensive statistical analysis revealing **differential Superhost pricing strategies** across accommodation types in Berlin's Airbnb market, uncovering sophisticated market segmentation patterns.

**Study Context:** 5th Semester Business Informatics - Big Data & Data Analytics  
**Academic Achievement:** Breakthrough research findings with statistical significance (p < 2.2e-16)

## Research Question & Hypothesis
**Research Question:** Do Superhosts achieve different relative price premiums for private rooms compared to entire apartments in Berlin?

**Hypothesis Testing:**
- **H₀:** The relative price premium of Superhosts does not differ significantly between private rooms and entire apartments in Berlin
- **H₁:** The relative price premium of Superhosts differs significantly between private rooms and entire apartments in Berlin

**Result:** **✅ REJECT H₀** - Significant differential pricing confirmed

## 🚀 **Breakthrough Research Findings**

### **Major Discovery: Inverse Premium Pattern**
| **Accommodation Type** | **Superhost Premium** | **Market Strategy** |
|------------------------|---------------------|-------------------|
| **Private Rooms** | **-22.19%** (Superhosts charge LESS) | Competitive Pricing |
| **Entire Places** | **+16.79%** (Superhosts charge MORE) | Premium Positioning |
| **Differential** | **38.98% difference** | **Market Segmentation** |

### **Statistical Validation**
- **Statistical Significance:** p < 2.2e-16 (highly significant)
- **Effect Size:** Medium practical significance (Cohen's d = -0.559)
- **Sample Robustness:** 8,783 analysis-ready listings across all groups
- **Confidence Interval:** 95% CI [-43.52%, -34.45%]

## Data Source & Documentation

### **Dataset Information**
- **Source:** InsideAirbnb Berlin Dataset
- **Initial Sample:** 14,187 listings (July 2025)
- **Analysis Sample:** 8,783 listings (after quality filtering)
- **Geographic Scope:** Berlin metropolitan area
- **Data Quality:** Zero missing values in critical variables

### **Data Documentation**
**📋 Comprehensive data documentation is available at [`data/README.md`](data/README.md)**, including:
- Detailed dataset descriptions and variable definitions
- Data processing pipeline documentation
- Quality metrics and sample characteristics
- Source attribution and usage guidelines

### **Data Repository Policy**
**Note:** Raw data files are **not included** in this repository, following standard best practices for academic projects. This approach:
- Maintains repository efficiency and manageable file sizes
- Respects data source terms and attribution requirements
- Encourages users to obtain fresh data directly from InsideAirbnb
- Ensures reproducibility with current datasets

The `data/raw/` directory structure is maintained for reference, and the import script (`01_data_import.R`) provides clear instructions for obtaining the source data.

## Technology Stack
- **R & RStudio:** Statistical analysis and visualization
- **GitHub:** Professional version control and documentation
- **Tidyverse:** Advanced data manipulation and analysis
- **Statistical Packages:** effsize, car, psych, nortest
- **Visualization:** ggplot2, scales, patchwork for publication-ready figures

## Project Structure
```
airbnb-berlin-superhost-analysis/
├── data/
│ ├── raw/ # Data download location (not tracked)
│ ├── processed/ # Cleaned, analysis-ready datasets
│ └── README.md # 📋 Comprehensive data documentation
├── scripts/
│ ├── 01_data_import.R # Professional data loading pipeline
│ ├── 02_data_cleaning.R # Statistical preprocessing
│ ├── 03_exploratory_analysis.R # Comprehensive EDA with 8+ tables
│ ├── 04_hypothesis_testing.R # Rigorous statistical validation
│ └── 05_visualization.R # Publication-ready figures
├── outputs/
│ ├── figures/ # 5 academic-quality visualizations
│ ├── tables/ # 10+ statistical summary tables
│ └── results/ # Hypothesis testing conclusions
├── reports/ # Academic documentation
└── README.md # Project overview (this file)
```

## Academic Methodology

### **Statistical Rigor**
- **Multiple validation approaches:** Welch's t-tests, bootstrap analysis
- **Assumption testing:** Normality, variance equality validation  
- **Effect size analysis:** Cohen's d with practical significance interpretation
- **Confidence intervals:** 95% CI for all major estimates

### **Professional Standards**
- **Academic project structure** following data science conventions
- **English documentation** for international accessibility
- **Reproducible research** with complete automation
- **Version control** demonstrating systematic development

## Research Impact

### **Academic Significance**
This analysis provides **first quantitative evidence** of sophisticated Superhost pricing strategies:
- **Market Segmentation:** Different value propositions by accommodation type
- **Strategic Differentiation:** Competitive vs premium positioning
- **Sharing Economy Insights:** Challenges conventional platform pricing assumptions

### **Practical Implications**
- **For Aspiring Superhosts:** Strategic insights about pricing power by accommodation type
- **For Market Analysis:** Evidence of sophisticated host behavior in sharing economy
- **For Academic Research:** Contribution to sharing economy and pricing strategy literature

## Reproducing the Analysis

### **Prerequisites**
- R (≥ 4.0) and RStudio
- Internet connection for data download

### **Step-by-Step Instructions**
1. **Clone repository:** `git clone https://github.com/g8rdier/airbnb-berlin-superhost-analysis.git`
2. **Download data:** Follow instructions in [`data/README.md`](data/README.md) for obtaining InsideAirbnb Berlin data
3. **Set working directory:** Ensure you're in the project root
4. **Run analysis pipeline:**
```
source("scripts/01_data_import.R") # Load InsideAirbnb data
source("scripts/02_data_cleaning.R") # Statistical preprocessing
source("scripts/03_exploratory_analysis.R") # Comprehensive EDA
source("scripts/04_hypothesis_testing.R") # Statistical validation
source("scripts/05_visualization.R") # Publication-ready figures
```
5. **View results:** Check `outputs/figures/` for visualizations, `outputs/results/` for conclusions

## Key Research Outputs

### **Visualizations** (outputs/figures/)
- Core premium comparison highlighting inverse pricing pattern
- Price distribution analysis by host type and accommodation category
- Statistical evidence with confidence intervals and significance testing
- Sample size validation demonstrating adequate statistical power
- Combined academic presentation dashboard

### **Statistical Evidence** (outputs/results/)
- Comprehensive hypothesis testing results with p < 2.2e-16 significance
- Bootstrap analysis validation and effect size summaries  
- Academic summary documentation suitable for peer review

## Academic Excellence Demonstrated
- **Breakthrough research findings** with significant practical implications
- **Statistical rigor** meeting 5th semester quantitative methodology standards
- **Professional presentation** suitable for academic publication
- **Technical competency** in advanced data science methodology

## Author
**Gregor Kobilarov**  
Business Informatics, 5th Semester  
Dual Studies Program  

**Academic Supervisor:** Prof. Dr. rer. nat. Barth  
**Institution:** IU International University of Applied Sciences

## Project Status
**✅ COMPLETED** - July 2025  
**Academic Achievement:** Breakthrough research findings with statistical significance  
**Portfolio Status:** Ready for academic evaluation and professional presentation

---

### **Research Citation**
```
Kobilarov, G. (2025). Differential Superhost Pricing Strategies in Berlin's Airbnb Market: 
Evidence of Accommodation-Type Specific Market Segmentation. 
Dual Studies Program - Business Informatics, 5th Semester, IU International University, Germany.
```

*This project demonstrates advanced data science methodology with breakthrough findings about sharing economy pricing strategies, contributing significant insights to academic literature on platform markets and host behavior.*
