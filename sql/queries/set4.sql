-- Query 10: Fraud rate by category for high-value transactions ($500+)
/*
Which categories (e.g., shopping_net) drive the 23.34% fraud rate in the $500+ bin?
-- Data Overview: This query shows fraud rates for transactions ≥$500, grouped by category.
*/

SELECT 
    category, 
    AVG(is_fraud::float) AS fraud_rate, 
    COUNT(*) AS transaction_count
FROM 
    train_transactions
WHERE 
    amt >= 500
GROUP BY 
    category
ORDER BY 
    fraud_rate DESC;

/*
Insight:
Fraud in high-value transactions is concentrated in entertainment, misc_net, and shopping_net. 
Categories with no fraud might have better prevention measures or be less appealing to fraudsters.
*/

-- Query 11: Hourly fraud rates on high-fraud days (Thursday and Friday)
/*
Are there specific hours on Thursday and Friday with elevated fraud?
-- Data Overview: This query calculates hourly fraud rates on Thursday and Friday.
*/

SELECT 
    EXTRACT(HOUR FROM trans_date_trans_time) AS hour, 
    AVG(is_fraud::float) AS fraud_rate, 
    COUNT(*) AS transaction_count
FROM 
    train_transactions
WHERE 
    EXTRACT(DOW FROM trans_date_trans_time) IN (4, 5)  -- Thursday and Friday
GROUP BY 
    hour
ORDER BY 
    hour;

/*
Insight:
Late-night hours on Thursday and Friday are particularly vulnerable, 
suggesting a need for time-specific fraud monitoring.
*/

-- Query 12: Fraud rate by cardholder age group
/*
Are certain age groups more vulnerable to fraud?
-- Data Overview: This query groups cardholders by age and calculates fraud rates.
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
    AVG(is_fraud::float) AS fraud_rate,
    COUNT(*) AS transaction_count
FROM 
    train_transactions
GROUP BY 
    age_group
ORDER BY 
    age_group;

/*
Insight:
Older cardholders (60+) have the highest fraud rate, 
possibly due to lower digital security awareness.
*/
