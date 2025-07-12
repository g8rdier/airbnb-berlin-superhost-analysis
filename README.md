# Berlin Airbnb Superhost Premium Analysis

## Project Overview
Analysis of Superhost premium differences between private rooms and entire homes in Berlin's Airbnb market.

**Study Context:** 5th Semester Business Informatics - Big Data & Data Analytics

## Research Question
**H0:** There is no significant difference in Superhost premium between private rooms and entire homes in Berlin.

## Data Source
- **Source:** InsideAirbnb Berlin Dataset
- **Scope:** ~14,000 listings (as of June 2025)
- **Period:** Current data from InsideAirbnb

## Technology Stack
- **R & RStudio:** Main analysis tool
- **GitHub:** Version control and documentation
- **R Markdown:** Reports and presentation
- **Tidyverse:** Data manipulation and visualization

## Project Structure
```
airbnb-berlin-analysis/
├── data/
│ ├── raw/ # Original data from InsideAirbnb
│ ├── processed/ # Cleaned data
│ └── README.md # Data description
├── scripts/
│ ├── 01_data_import.R # Data loading and import
│ ├── 02_data_cleaning.R # Data cleaning
│ ├── 03_exploratory_analysis.R # EDA
│ ├── 04_hypothesis_testing.R # Statistical tests
│ └── 05_visualization.R # Graphics creation
├── reports/
│ ├── analysis_report.Rmd # Main report
│ └── presentation.Rmd # Presentation
├── outputs/
│ ├── figures/ # Generated graphics
│ ├── tables/ # Exported tables
│ └── results/ # Test results
└── README.md
```


## Reproducing the Analysis
1. Clone repository: `git clone https://github.com/[your-username]/airbnb-berlin-superhost-analysis.git`
2. Install R packages: `renv::restore()`
3. Run scripts in order: `01_data_import.R` through `05_visualization.R`
4. Generate report: `rmarkdown::render("reports/analysis_report.Rmd")`

## Expected Results
- Statistical evaluation of Superhost premium
- Visualization of price differences
- Recommendations for Airbnb hosts

## Author
Gregor Kobilarov - Business Informatics, 5th Semester

## Project Status
**In Development** - Start Date: July 2025

---
*This project is created as part of the "Big Data & Data Analytics" course.*
