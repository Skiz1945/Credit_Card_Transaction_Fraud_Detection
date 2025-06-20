## Overview

Unmasking fraud in the shadows of millions of credit card swipes, this project dives into the chaotic world of transaction data to catch the outliers that cost billions. Armed with Python, PostgreSQL, and a battalion of machine learning models, I’ve built a fraud detection system that battles extreme class imbalance to pinpoint suspicious activity. From raw data exploration in `understanding_data.ipynb` to a finely tuned XGBoost model in `md5_xgboost_with_hyperparametertuning.ipynb`, this journey transforms messy transactions into a playbook of precision and recall.

As a data enthusiast with a knack for problem-solving, I’ve wrangled datasets, engineered features, and tested six models, including Random Forest and LightGBM, to find the ultimate fraud-fighter (spoiler: XGBoost at a 0.97 threshold steals the show). Whether you’re a fraud analyst, a machine learning buff, or just curious about data’s detective powers, this project offers a deep dive into catching the bad guys, one transaction at a time.

## Objectives

This project transforms raw credit card transaction data into a robust fraud detection system, starting with `understanding_data.ipynb` and advancing through database integration, feature engineering, and model optimization. The analysis leverages 50 SQL queries, six machine learning models, and a data validation pipeline to deliver actionable insights. Key objectives include:

- **Data Exploration:** Investigate raw transaction data in `understanding_data.ipynb` to understand patterns and class imbalance.
- **Database Integration:** Import data into PostgreSQL using `import_data.py` and execute 50 SQL queries to extract insights and prepare the dataset for modeling.
- **Feature Engineering:** Enhance dataset quality in `feature_engineering.ipynb` with engineered features for better model performance.
- **Data Validation:** Ensure dataset integrity in `data_validation.ipynb` by checking consistency and accuracy.
- **Model Development:** Test six approaches - Random Forest, Random Forest with Class Weights, Random Forest with SMOTE, XGBoost, XGBoost with *Hyperparameter Tuning* in `md5_xgboost_with_hyperparametertuning.ipynb`, and LightGBM - in notebooks `md1_random_forest.ipynb` to `md6_lightgbm.ipynb`.
- **Performance Optimization:** Tune the XGBoost model to achieve a precision of 0.83, a recall of 0.80, and an F1-score of 0.81 at a 0.97 threshold.
- **Advanced Evaluation:** Compute ROC-AUC (0.9967) and conduct cost analysis using an average fraud loss of $530.66 and an investigation cost of $75 to balance financial impact and detection accuracy.

The validated dataset and optimized model, crafted through this process, offer a cost-effective fraud detection solution, striking a balance between fraud capture and operational efficiency to protect financial institutions and consumers.

## Project Structure

### Data Exploration
- **File:** [understanding_data.ipynb](https://github.com/yourusername/credit-card-fraud-detection/blob/main/understanding_data.ipynb)
- **Description:** Launches the project by exploring raw transaction data from `fraudTrain.csv` and `fraudTest.csv` to uncover initial patterns and the severe class imbalance (553,574 non-fraud vs. 2,145 fraud cases). This notebook lays the groundwork for subsequent analysis by assessing data quality, feature distributions, and time-based fraud trends.
- **Key Steps:** Loads datasets, checks for missing values, and converts `trans_date_trans_time` and `dob` to datetime before saving as `train.csv` and `test.csv`. Analyzes fraud distribution (0.39%), numerical columns, categorical features, and time-based patterns to uncover initial insights.

### Database Integration
- **File:** [import_data.py](https://github.com/yourusername/credit-card-fraud-detection/blob/main/import_data.py)
- **Description:** Bridges the gap between raw data from `fraudTrain.csv` and `fraudTest.csv` and analysis by importing into PostgreSQL’s `train_transactions` and `test_transactions` tables. This script, paired with 50 SQL queries, prepares the dataset for modeling by extracting insights and structuring the data.
- **Key Steps:** Loads datasets, converts `trans_date_trans_time` and `dob` to datetime, connects to a local PostgreSQL instance, and imports data into tables, setting the stage for 50 SQL queries.

### Feature Engineering
- **File:** [feature_engineering.ipynb](https://github.com/yourusername/credit-card-fraud-detection/blob/main/feature_engineering.ipynb)
- **Description:** Elevates the project by transforming transaction data from `train.csv` and `test.csv` into a sophisticated feature set designed for fraud detection, drawing on insights from prior SQL analysis. This notebook crafts geospatial features like transaction distances, temporal risk flags (e.g., night hours 22:00–03:00), categorical risk scores (e.g., high-risk categories like 'shopping_net'), demographic indicators (e.g., age bins), and behavioral metrics (e.g., daily transaction frequency), all enriched with visualizations such as fraud rate plots by distance, hour, and category, plus a correlation heatmap to guide feature selection.
- **Key Steps:** Loads datasets with parsed datetime columns, calculates `distance_km` and `log_distance` using geodesic distance with binned fraud rate analysis, extracts `trans_hour`, `trans_day`, and `trans_month` with flags for `is_night`, `is_weekend`, and `is_saturday`, defines risk flags for categories, states, city size, and transaction values, computes `age` and age bins, derives `daily_freq` and `freq_risk`, generates `category_risk_score` and `merchant_risk_score` from fraud rates, creates visualizations for fraud trends and correlations, and saves the final engineered datasets (`fraudTrain_engineered.csv`, `fraudTest_engineered.csv`) with 22 selected features including `amt`, `gender`, and `is_fraud`.

### Data Validation
- **File:** [data_validation.ipynb](https://github.com/yourusername/credit-card-fraud-detection/blob/main/data_validation.ipynb)
- **Description:** Strengthens the project by validating the engineered datasets `fraudTrain_engineered.csv` and `fraudTest_engineered.csv` to ensure data integrity and readiness for modeling. This notebook performs essential checks on missing values, data types, summary statistics, and class distribution, confirming the reliability of the feature engineering process.
- **Key Steps:** Loads engineered datasets, checks for missing values, verifies data types, reviews summary statistics, and analyzes class distribution to ensure consistency with prior fraud rates.

### Model Development
- **File:** [md1_random_forest.ipynb](https://github.com/yourusername/credit-card-fraud-detection/blob/main/md1_random_forest.ipynb)
- **Description:** Establishes the first modeling step by implementing a baseline Random Forest classifier to detect fraudulent transactions, building on the validated datasets. This notebook evaluates the model’s initial performance using classification metrics and a confusion matrix visualization, setting a benchmark for subsequent enhancements.
- **Key Steps:** Loads validated datasets from `engineered_data/fraudTrain_engineered.csv` and `fraudTest_engineered.csv`, applies one-hot encoding to `gender`, trains a Random Forest model, generates predictions, computes classification report metrics, and plots a confusion matrix to assess performance.

- **File:** [md2_random_forest_with_classweight.ipynb](https://github.com/yourusername/credit-card-fraud-detection/blob/main/md2_random_forest_with_classweight.ipynb)
- **Description:** Advances the modeling process by refining the Random Forest classifier with class weights to address the severe class imbalance, building on the validated datasets. This notebook assesses the improved fraud detection sensitivity through classification metrics and a confusion matrix visualization, enhancing the baseline model’s performance.
- **Key Steps:** Loads validated datasets from `engineered_data/fraudTrain_engineered.csv` and `fraudTest_engineered.csv`, applies one-hot encoding to `gender`, trains a Random Forest model with `class_weight='balanced'`, generates predictions, computes classification report metrics, and plots a confusion matrix to evaluate the impact of class weighting.

- **File:** [md3_random_forest_with_smote.ipynb](https://github.com/yourusername/credit-card-fraud-detection/blob/main/md3_random_forest_with_smote.ipynb)
- **Description:** Further refines the modeling approach by applying SMOTE to balance the training data, targeting the severe class imbalance and building on validated datasets to boost fraud recall. This notebook evaluates the enhanced detection capability with classification metrics (recall improved to 0.79 from 0.71) and a confusion matrix visualization, offering a trade-off with reduced precision (0.76 from 0.95) compared to the baseline.
- **Key Steps:** Loads validated datasets from `engineered_data/fraudTrain_engineered.csv` and `fraudTest_engineered.csv`, applies one-hot encoding to `gender`, uses SMOTE to resample the training data, trains a Random Forest model, generates predictions, computes classification report metrics, and plots a confusion matrix to assess the balancing impact.

- **File:** [md4_xgboost.ipynb](https://github.com/yourusername/credit-card-fraud-detection/blob/main/md4_xgboost.ipynb)
- **Description:** Introduces a powerful XGBoost classifier to improve fraud detection, leveraging the validated datasets and addressing class imbalance with `scale_pos_weight`. This notebook explores optimal prediction thresholds (0.4 to 0.99) to balance precision and recall, evaluating performance across multiple metrics to surpass previous models.
- **Key Steps:** Loads validated datasets from `engineered_data/fraudTrain_engineered.csv` and `fraudTest_engineered.csv`, applies one-hot encoding to `gender`, converts object columns to categorical types, trains an XGBoost model with `scale_pos_weight` based on class ratio, generates probability predictions, and tests various thresholds to compute classification report metrics.

- **File:** [md5_xgboost_with_hyperparametertuning.ipynb](https://github.com/yourusername/credit-card-fraud-detection/blob/main/md5_xgboost_with_hyperparametertuning.ipynb)
- **Description:** Optimizes the XGBoost model through hyperparameter tuning and evaluates its performance across various thresholds, incorporating advanced metrics and visualizations to guide threshold selection and assess financial impact.
- **Key Steps:** Loads validated datasets, applies one-hot encoding to `gender`, defines a parameter grid (`max_depth`, `learning_rate`, `n_estimators`, `scale_pos_weight`), performs GridSearchCV with F1 scoring, tests thresholds from 0.8 to 0.99, visualizes results (e.g., confusion matrix, feature importances, precision-recall and ROC curves), and conducts a cost analysis to evaluate financial implications.

- **File:** [md6_lightgbm.ipynb](https://github.com/yourusername/credit-card-fraud-detection/blob/main/md6_lightgbm.ipynb)
- **Description:** Introduces the LightGBM model as an efficient alternative for fraud detection, leveraging validated datasets and addressing class imbalance with `scale_pos_weight` to prioritize recall. This notebook evaluates performance across thresholds (0.8 to 0.99), achieving a peak recall of 0.90 at 0.8 but with precision as low as 0.14, offering a comparative benchmark to prior models.
- **Key Steps:** Loads validated datasets from `engineered_data/fraudTrain_engineered.csv` and `fraudTest_engineered.csv`, applies one-hot encoding to `gender`, defines LightGBM parameters including `scale_pos_weight`, creates LightGBM datasets, trains the model with 100 boosting rounds, generates probability predictions, and tests thresholds to compute classification report metrics with a maximum recall of 0.90.

## Results Summary
This project achieved significant insights in fraud detection using engineered datasets. The baseline Random Forest model set a benchmark with 0.95 precision and 0.71 recall, while SMOTE improved recall to 0.79 at a cost of 0.76 precision. XGBoost with hyperparameter tuning met the target of 0.83 precision, 0.80 recall, and 0.81 F1 at a 0.97 threshold, validated by a $530.66 average fraud loss and $75 investigation cost analysis. LightGBM peaked at 0.90 recall with 0.14 precision at 0.8, highlighting a trade-off. Visualizations (e.g., ROC-AUC 0.9967) and threshold testing guided optimal performance, laying a foundation for real-time fraud systems.

## What I Learned
Through this project, I gained hands-on experience in handling imbalanced datasets, mastering techniques like class weights, SMOTE, and `scale_pos_weight` to improve model sensitivity. I learned the importance of feature engineering, creating diverse features such as geospatial distances and temporal risk flags, which significantly influenced model outcomes. Experimenting with Random Forest, XGBoost, and LightGBM deepened my understanding of precision-recall trade-offs, while threshold adjustments and cost evaluations highlighted real-world fraud detection challenges. Visualizations like confusion matrices and ROC curves enhanced my ability to interpret model performance, while working with PostgreSQL and pandas strengthened my data pipeline skills.

## Challenges I Faced

Hurdles I navigated during the project:

- **Imbalanced Data Handling:** Struggled with the 0.39% fraud rate, requiring careful application of techniques like SMOTE and `scale_pos_weight` to avoid overfitting while boosting recall.
- **Threshold Optimization:** Faced difficulties balancing precision and recall across thresholds (e.g., LightGBM’s 0.90 recall vs. 0.14 precision), demanding iterative testing to minimize false positives.
- **Feature Complexity:** Encountered issues integrating diverse features like `distance_km` and `category_risk_score`, needing robust validation to ensure model reliability.

## Conclusion

This project successfully developed a robust fraud detection framework, culminating in an XGBoost model achieving 0.83 precision, 0.80 recall, and 0.81 F1 at a 0.97 threshold, validated by a cost analysis of $530.66 per fraud versus $75 per investigation. The exploration of Random Forest, SMOTE, and LightGBM (peaking at 0.90 recall) highlighted precision-recall trade-offs and the power of feature engineering with geospatial and temporal features. Future work could integrate real-time data, refine threshold strategies, or explore ensemble methods to further enhance performance, offering a solid foundation for scalable fraud prevention systems.

## Tools I Used

I built this project with a Python-centric data science stack:

- **Python:** The foundation of my analysis, utilizing:
  - **Pandas:** Data loading, manipulation, and feature engineering.
  - **NumPy:** Numerical computations and array operations.
  - **Matplotlib & Seaborn:** Visualization of fraud trends, confusion matrices, and ROC curves.
  - **Scikit-learn:** Baseline modeling with Random Forest and SMOTE.
  - **XGBoost & LightGBM:** Advanced gradient boosting for optimized fraud detection.
- **PostgreSQL:** Database integration for structured data management.
- **Jupyter Notebooks:** Interactive environment for coding and experimentation.
- **Git & GitHub:** Version control and project collaboration.

## Getting Started

- **Requirements:** Python 3.11+, pandas, numpy, matplotlib, seaborn, scikit-learn, xgboost, lightgbm, psycopg2 (for PostgreSQL).
- **Data:** Raw data in `data/fraudTrain.csv` and `fraudTest.csv`; engineered data in `engineered_data/fraudTrain_engineered.csv` and `fraudTest_engineered.csv`.
- **Setup:** Clone the repo, install dependencies via `pip install -r requirements.txt`, and configure PostgreSQL with `train_transactions` and `test_transactions` tables.
- **Run:** Open notebooks (e.g., `feature_engineering.ipynb`, `md5_xgboost_with_hyperparametertuning.ipynb`) in Jupyter to explore the analysis.

## Notes
- Detailed findings and code are in the notebooks (e.g., `md5_xgboost_with_hyperparametertuning.ipynb`).
- For questions or collaboration, contact milandjkc1ds@gmail.com.
- Ensure PostgreSQL is configured with `train_transactions` and `test_transactions` tables for full functionality.