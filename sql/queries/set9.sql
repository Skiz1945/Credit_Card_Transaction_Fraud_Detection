-- Query 25: Hourly fraud rates for high-value transactions in 'shopping_net'
/*
Investigate if high-value fraud in shopping_net is concentrated during specific hours.
-- Data Overview: This query analyzes fraud rates for shopping_net transactions ≥$500 by hour.
*/

SELECT 
    EXTRACT(HOUR FROM trans_date_trans_time) AS hour,
    AVG(is_fraud::float) AS fraud_rate,
    COUNT(*) AS transaction_count
FROM 
    train_transactions
WHERE 
    category = 'shopping_net' AND amt >= 500
GROUP BY 
    hour
ORDER BY 
    hour;

/*
Insights:
The extraordinarily high fraud rates at 22:00–23:00 (80–82%) confirm that late-night high-value shopping_net 
transactions are a major fraud hotspot, while early morning hours (0:00–3:00) also show significant risk. 
Daytime hours are safer, likely due to increased merchant oversight.
*/


-- Query 26: Fraud rates by category for 60+ age group
/*
Identify which categories are most risky for the 60+ age group.
-- Data Overview: This query examines fraud rates by category for cardholders aged 60+.
*/

SELECT 
    category,
    AVG(is_fraud::float) AS fraud_rate,
    COUNT(*) AS transaction_count
FROM 
    train_transactions
WHERE 
    DATE_PART('year', AGE(dob)) >= 60
GROUP BY 
    category
ORDER BY 
    fraud_rate DESC;

/*
Insights: 
Older cardholders are particularly vulnerable in online (shopping_net, misc_net) 
and grocery (grocery_pos, grocery_net) transactions, with fraud rates significantly higher than the dataset average, 
suggesting age-specific targeting or lower digital security awareness.
*/


-- Query 27: Top merchants with high fraud rates in high-value transactions ($500+)
/*
Determine which merchants have the highest fraud rates in transactions over $500.
-- Data Overview: This query identifies merchants with the highest fraud rates for transactions ≥$500.
*/

SELECT 
    merchant,
    AVG(is_fraud::float) AS fraud_rate,
    COUNT(*) AS transaction_count
FROM 
    train_transactions
WHERE 
    amt >= 500
GROUP BY 
    merchant
ORDER BY 
    fraud_rate DESC
LIMIT 10;


/*
Insights:
The 100% fraud rates are unreliable due to extremely low transaction counts, 
indicating possible targeted fraud attempts or data anomalies rather than widespread merchant vulnerabilities.
*/