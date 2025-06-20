-- Query 13: Top Fraudulent Merchants in High-Risk Categories
/* 
Identify problematic merchants in high-risk categories.
-- Data Overview: This query identifies merchants with the highest fraud rates in the 
entertainment, misc_net, and shopping_net categories, 
likely focusing on high-value transactions (e.g., $500+).
*/

SELECT 
    merchant, 
    category, 
    AVG(is_fraud::float) AS fraud_rate, 
    COUNT(*) AS transaction_count
FROM 
    train_transactions
WHERE 
    category IN ('entertainment', 'misc_net', 'shopping_net') AND amt >= 500
GROUP BY 
    merchant, category
ORDER BY 
    fraud_rate DESC
LIMIT 10;

/*
Insight:
While these merchants exhibit a 100% fraud rate, the low transaction counts (1–5) 
suggest that these findings may not be statistically significant. 
This indicates potential fraud concentration in entertainment, 
but more data is needed for reliable conclusions.
*/


-- Query 14: Hourly Fraud Rates Across All Days
/*
Verify if late-night fraud is a broader trend.
-- Data Overview: This query calculates fraud rates and transaction counts for each hour of the day across all transactions.
*/

SELECT 
    EXTRACT(HOUR FROM trans_date_trans_time) AS hour, 
    AVG(is_fraud::float) AS fraud_rate, 
    COUNT(*) AS transaction_count
FROM 
    train_transactions
GROUP BY 
    hour
ORDER BY 
    hour;

/*
Insight:
Fraud rates spike significantly in late-night hours (22:00–23:00), while daytime hours (04:00–21:00) remain low-risk. 
This suggests that time of day is a critical factor in fraud detection.
*/


-- Query 15: Fraud Rate by Age Group and Category
/*
Check if older cardholders are targeted in specific categories.
*/

SELECT 
    CASE 
        WHEN DATE_PART('year', AGE(dob)) < 20 THEN '<20'
        WHEN DATE_PART('year', AGE(dob)) < 30 THEN '20-29'
        WHEN DATE_PART('year', AGE(dob)) < 40 THEN '30-39'
        WHEN DATE_PART('year', AGE(dob)) < 50 THEN '40-49'
        WHEN DATE_PART('year', AGE(dob)) < 60 THEN '50-59'
        ELSE '60+'
    END AS age_group,
    category,
    AVG(is_fraud::float) AS fraud_rate,
    COUNT(*) AS transaction_count
FROM 
    train_transactions
GROUP BY 
    age_group, category
ORDER BY 
    age_group, fraud_rate DESC;

/*
Insight:
Younger users (20-29) are notably vulnerable in grocery_pos, 
while older users (60+) face higher risks in shopping_net and misc_net. 
This points to age-specific fraud patterns that could inform targeted prevention strategies.
*/