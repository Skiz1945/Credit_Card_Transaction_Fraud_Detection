-- Query 28: Merchant-Specific Fraud in Late-Night High-Value 'shopping_net' Transactions for 60+ Age Group
/*
Identify merchants driving fraud in the riskiest context (late-night, high-value shopping_net transactions for older cardholders).
-- This query lists merchants involved in shopping_net transactions ≥$500 between 22:00–23:00 for cardholders aged 60+, 
showing their fraud rates and transaction counts.
*/


SELECT 
    merchant,
    AVG(is_fraud::float) AS fraud_rate,
    COUNT(*) AS transaction_count
FROM 
    train_transactions
WHERE 
    category = 'shopping_net' 
    AND amt >= 500
    AND EXTRACT(HOUR FROM trans_date_trans_time) IN (22, 23)
    AND DATE_PART('year', AGE(dob)) >= 60
GROUP BY 
    merchant
HAVING 
    COUNT(*) >= 10
ORDER BY 
    fraud_rate DESC
LIMIT 10;

/*
Insight:
These merchants are either highly vulnerable to fraud or specifically targeted during late-night, high-value transactions by older cardholders. 
The small sample sizes (10–19 transactions) suggest this may be a niche issue rather than a widespread pattern, 
so caution is needed in generalizing these findings.
*/


-- Query 29: Fraud Rates by Transaction Amount Bins for 60+ Age Group in 'shopping_net'
/*
Examine how fraud rates vary by transaction amount for older cardholders in shopping_net, building on Query 24’s high-value fraud findings.
-- Data Overview: This query examines fraud rates across transaction amount bins for cardholders aged 60+ in the shopping_net category.
*/

SELECT 
    CASE 
        WHEN amt < 50 THEN '<50'
        WHEN amt BETWEEN 50 AND 100 THEN '50-100'
        WHEN amt BETWEEN 100 AND 500 THEN '100-500'
        WHEN amt >= 500 THEN '500+'
    END AS amount_bin,
    AVG(is_fraud::float) AS fraud_rate,
    COUNT(*) AS transaction_count
FROM 
    train_transactions
WHERE 
    category = 'shopping_net'
    AND DATE_PART('year', AGE(dob)) >= 60
GROUP BY 
    amount_bin
ORDER BY 
    fraud_rate DESC;

/*
Insight:
Fraud in shopping_net transactions for the 60+ age group is exclusively concentrated in high-value transactions (≥$500), with nearly half being fraudulent. 
Lower-value bins show no fraud, 
indicating that fraudsters target larger transactions, possibly exploiting older cardholders’ potential lack of online security awareness.
*/


-- Query 30: Fraud Rates by Day of Week for High-Value 'shopping_net' Transactions at 22:00–23:00
/*
Investigate if specific days (e.g., Thursday/Friday from Query 11) amplify late-night fraud in high-value shopping_net transactions.
-- Data Overview: This query analyzes fraud rates by day of the week (0 = Sunday, 6 = Saturday) for shopping_net transactions ≥$500 during 22:00–23:00.
*/

SELECT 
    EXTRACT(DOW FROM trans_date_trans_time) AS day_of_week,
    AVG(is_fraud::float) AS fraud_rate,
    COUNT(*) AS transaction_count
FROM 
    train_transactions
WHERE 
    category = 'shopping_net'
    AND amt >= 500
    AND EXTRACT(HOUR FROM trans_date_trans_time) IN (22, 23)
GROUP BY 
    day_of_week
ORDER BY 
    fraud_rate DESC;

/*
Insight:
High-value shopping_net transactions during 22:00–23:00 have extremely high fraud rates (76%–86%) across all days, 
with slight peaks on Fridays and Thursdays. This suggests late-night hours are a consistent risk period, 
with marginally higher fraud toward the end of the workweek.
*/

