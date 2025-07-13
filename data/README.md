# Data Documentation - Airbnb Berlin Superhost Premium Analysis

## Dataset Overview

This directory contains the data files for the **Airbnb Berlin Superhost Premium Analysis** research project, investigating differential pricing patterns employed by Superhosts across accommodation types in Berlin's sharing economy market.

### Research Context
- **Project**: 5th semester quantitative research methodology
- **Research Question**: Do Superhosts achieve different relative price premiums for private rooms compared to entire apartments in Berlin?
- **Null Hypothesis (H₀)**: The relative price premium of Superhosts does not differ significantly between private rooms and entire apartments in Berlin
- **Alternative Hypothesis (H₁)**: The relative price premium of Superhosts differs significantly between private rooms and entire apartments in Berlin
- **Significance Level**: α = 0.05

---

## Data Source

### **InsideAirbnb Berlin Dataset**
- **Source**: [InsideAirbnb.com](http://insideairbnb.com/get-the-data/)
- **Location**: Berlin, Germany
- **Data Type**: Airbnb listings summary data
- **Collection Date**: July 2025
- **Original File**: `listings.csv` (summary dataset)
- **Original Size**: ~2.6MB
- **Geographic Scope**: Berlin metropolitan area

### **Data Characteristics**
- **Initial Records**: 14,187 Airbnb listings
- **Analysis-Ready Records**: 8,783 listings (after cleaning)
- **Time Period**: Current active listings
- **Geographic Coverage**: All Berlin neighborhoods
- **Data Quality**: High completeness in critical variables

---

## Directory Structure

```
data/
├── raw/ # Original data from InsideAirbnb
│ └── listings.csv # Original dataset (excluded from Git)
├── processed/ # Cleaned, analysis-ready datasets
│ ├── cleaned_airbnb_berlin.csv # Main cleaned dataset
│ └── hypothesis_testing_data.csv # Focused dataset for statistical testing
└── README.md # This documentation file
```

---

## File Descriptions

### **Raw Data (`data/raw/`)**

#### `listings.csv` (Original Dataset)
- **Source**: InsideAirbnb Berlin
- **Records**: 14,187 listings
- **Variables**: ~75 columns including pricing, host information, property details
- **Status**: Excluded from Git repository due to size
- **Access**: Download from InsideAirbnb.com

### **Processed Data (`data/processed/`)**

#### `cleaned_airbnb_berlin.csv` (Main Cleaned Dataset)
- **Records**: 8,783 listings
- **Variables**: 36 key variables for analysis
- **Quality**: Zero missing values in critical variables
- **Processing**: Outlier removal, data type standardization, variable creation

**Key Variables:**
- `id`: Unique listing identifier
- `price_numeric`: Cleaned price in EUR
- `is_superhost`: Boolean superhost status
- `room_type`: Accommodation type (Entire home/apt, Private room)
- `accommodates`: Number of guests
- `number_of_reviews`: Review count
- `review_scores_rating`: Overall rating
- `availability_365`: Days available per year
- Geographic coordinates and neighborhood information

#### `hypothesis_testing_data.csv` (Statistical Analysis Dataset)
- **Records**: 8,783 listings
- **Variables**: 10 focused variables for hypothesis testing
- **Purpose**: Streamlined dataset for statistical validation
- **Quality**: Verified data integrity for t-tests

**Analysis Variables:**
- `host_type`: "Superhost" or "Regular Host"
- `room_category`: "Entire Place" or "Private Room"
- `price_numeric`: Price in EUR
- Control variables: reviews, availability, accommodates, ratings

---

## Data Processing Pipeline

### **1. Data Import** (`scripts/01_data_import.R`)
- Load raw data from InsideAirbnb
- Initial data quality assessment
- Basic variable verification

### **2. Data Cleaning** (`scripts/02_data_cleaning.R`)
- **Filter missing critical variables**: Remove incomplete records
- **Price cleaning**: Convert price strings to numeric values
- **Room type filtering**: Focus on "Entire home/apt" and "Private room"
- **Outlier removal**: 3-sigma rule with €10 minimum threshold
- **Variable standardization**: Create analysis-ready variables
- **Quality validation**: Data integrity checks

### **3. Quality Metrics**
- **Completion Rate**: 100% in critical variables after cleaning
- **Price Range**: €10 - €1,392 (outliers removed)
- **Sample Distribution**: Adequate samples across all analysis groups
- **Geographic Coverage**: All Berlin neighborhoods represented

---

## Sample Characteristics

### **Group Distribution**
| **Host Type** | **Entire Place** | **Private Room** | **Total** |
|---------------|------------------|------------------|-----------|
| **Regular Host** | 4,505 | 1,485 | 5,990 |
| **Superhost** | 2,070 | 723 | 2,793 |
| **Total** | 6,575 | 2,208 | 8,783 |

### **Price Statistics**
| **Metric** | **Entire Place** | **Private Room** |
|------------|------------------|------------------|
| **Mean Price** | €152 | €89 |
| **Median Price** | €125 | €67 |
| **Price Range** | €10 - €1,392 | €12 - €1,200 |

### **Statistical Results**
| **Accommodation Type** | **Superhost Premium** |
|------------------------|---------------------|
| **Private Rooms** | -22.19% |
| **Entire Places** | +16.79% |
| **Differential** | 38.98 percentage points |

---

## Statistical Evidence

### **Hypothesis Testing Results**
- **Hypothesis Result**: REJECT H₀ - Significant differential pricing confirmed
- **Statistical Significance**: p < 2.2e-16 (highly significant)
- **Effect Size**: Medium practical significance (Cohen's d = -0.559)
- **Confidence Interval**: 95% CI [-43.52%, -34.45%]

### **Findings Summary**
The analysis indicates differential pricing patterns:
- **Private Rooms**: Superhosts charge 22.19% less than regular hosts
- **Entire Places**: Superhosts charge 16.79% more than regular hosts  
- **Pattern Difference**: 38.98 percentage points variation by accommodation type

---

## Data Usage Guidelines

### **Academic Research**
- Data processed following academic research standards
- Suitable for statistical analysis and hypothesis testing
- Variables standardized for cross-group comparisons
- Quality validated for reliable inference

### **Statistical Considerations**
- **Non-normal distributions**: Use non-parametric or robust tests
- **Unequal variances**: Apply Welch's t-tests for group comparisons
- **Sample sizes**: All groups adequate for statistical testing (n > 30)
- **Effect sizes**: Small to medium practical significance

### **Limitations**
- **Cross-sectional data**: Point-in-time snapshot, no temporal analysis
- **Selection bias**: Active listings only, no delisted properties
- **Geographic scope**: Berlin only, results may not generalize
- **Platform specific**: Airbnb data only, excludes other platforms

---

## Contact & Citation

### **Project Information**
- **Author**: Gregor Kobilarov
- **Institution**: Dual Studies Program - Business Informatics
- **Academic Level**: 5th semester quantitative research methodology
- **Supervisor**: Prof. Dr. rer. nat. Barth
- **Date**: July 2025

### **Data Citation**
```
InsideAirbnb Berlin Dataset. (2025). Retrieved from http://insideairbnb.com/get-the-data/
Processed for: Airbnb Berlin Superhost Premium Analysis - Quantification of Price Premiums by Accommodation Type
```

### **Repository**
```
GitHub: airbnb-berlin-superhost-analysis
Academic project demonstrating statistical analysis methodology and data science workflow
```

---

## Version History

- **v1.0** (July 2025): Initial data processing and cleaning pipeline
- **Current**: Analysis-ready datasets with statistical validation
- **Status**: Ready for visualization and academic reporting phases

---

*This documentation follows academic data science project standards and provides information for reproducible research and peer evaluation.*
