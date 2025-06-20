-- Query 7: Fraud Rate by Day of Week
/* 
Investigate if fraud varies by day (e.g., weekends vs. weekdays), 
extending the time-based analysis from Query 4.
-- Data Overview: This query shows fraud rates and transaction counts for each day of the week (0 = Sunday, 6 = Saturday).
*/

SELECT 
    EXTRACT(DOW FROM trans_date_trans_time) AS day_of_week,
    AVG(is_fraud::float) AS fraud_rate,
    COUNT(*) AS transaction_count
FROM 
    train_transactions
GROUP BY 
    day_of_week
ORDER BY 
    day_of_week;

/*
Insight:
Day of the week alone isn’t a strong fraud indicator, but Thursday and Friday warrant closer 
inspection when combined with other factors.
*/


-- Query 8: Fraud Rate by Transaction Amount Bins
/* 
Generalize Query 6’s amount-based insight across all categories, 
testing if fraud correlates with specific amount ranges.
-- Data Overview: This query groups transactions into amount bins and calculates fraud rates.
*/

SELECT 
    CASE 
        WHEN amt < 10 THEN '<10'
        WHEN amt < 50 THEN '10-50'
        WHEN amt < 100 THEN '50-100'
        WHEN amt < 500 THEN '100-500'
        ELSE '500+'
    END AS amount_bin,
    AVG(is_fraud::float) AS fraud_rate,
    COUNT(*) AS transaction_count
FROM 
    train_transactions
GROUP BY 
    amount_bin
ORDER BY 
    amount_bin;

/*
Insight:
Fraud risk escalates sharply for transactions over $500, with nearly 1 in 4 flagged as fraudulent. 
High-value transactions are a critical focus for fraud detection. 
*/   


-- Query 9: Fraud Rate for Cross-State Transactions
/*
Explore if fraud increases when the merchant’s state differs from the cardholder’s, 
adding a geographic risk factor.
-- Data Overview: This query categorizes transactions by distance (e.g., between cardholder and merchant locations).
*/

SELECT 
    CASE 
        WHEN SQRT(POWER(lat - merch_lat, 2) + POWER(long - merch_long, 2)) < 1 THEN 'Local (<1 degree)'
        WHEN SQRT(POWER(lat - merch_lat, 2) + POWER(long - merch_long, 2)) < 5 THEN 'Regional (1-5 degrees)'
        ELSE 'Distant (>5 degrees)'
    END AS distance_category,
    AVG(is_fraud::float) AS fraud_rate,
    COUNT(*) AS transaction_count
FROM 
    train_transactions
GROUP BY 
    distance_category
ORDER BY 
    distance_category; 

/*
Insight:
Fraud rates are nearly identical across distance categories, 
suggesting distance isn’t a key fraud driver in this dataset.
*/