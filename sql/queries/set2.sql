-- Query 4: Fraud rate by hour of day
/* Tests if hourly fraud rates align with Python’s 2.88% peak at 22:00–23:00, 
informing time-based ML features.
-- Data Overview: This query calculates the fraud rate and transaction count for each hour of the day.
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
    fraud_rate DESC;

/* Insight:
Fraud is significantly higher late at night (22:00–23:00), suggesting that time-based features 
(e.g., "is_night") could enhance fraud detection models.
*/



-- Query 5: Cardholder fraud and transaction frequency
/* Identifies cardholders with high transaction volumes and fraud rates, 
revealing potential fraud-prone accounts.
-- Data Overview: This query ranks cardholders with >50 transactions by fraud rate, showing transaction counts and fraud counts.
*/

SELECT 
    cc_num, 
    COUNT(*) AS transaction_count, 
    SUM(is_fraud) AS fraud_count, 
    AVG(is_fraud::float) AS fraud_rate
FROM 
    train_transactions
GROUP BY 
    cc_num
HAVING 
    COUNT(*) > 50
ORDER BY 
    fraud_rate DESC
LIMIT 10;

/* Insight:
Insight: Specific cardholders exhibit higher fraud rates, 
possibly indicating compromised accounts or risky behavior,
warranting targeted monitoring.
*/



-- Query 6: Transaction frequency and fraud in high-risk categories
/* Focuses on high-risk categories from Query 1, splitting transactions by amount 
(<$100 vs. ≥$100) to check if fraud is tied to smaller, 
frequent transactions (since Query 3 showed no fraud in high-value transactions).
-- Data Overview: This query examines fraud in high-risk categories (grocery_pos, misc_net, shopping_net), splitting transactions into small (<$100) and large (≥$100).
*/

SELECT 
    category, 
    COUNT(*) AS total_transactions, 
    SUM(CASE WHEN amt < 100 THEN 1 ELSE 0 END) AS small_transactions,
    AVG(CASE WHEN amt < 100 THEN is_fraud::float ELSE NULL END) AS small_tx_fraud_rate,
    SUM(CASE WHEN amt >= 100 THEN 1 ELSE 0 END) AS large_transactions,
    AVG(CASE WHEN amt >= 100 THEN is_fraud::float ELSE NULL END) AS large_tx_fraud_rate
FROM 
    train_transactions
WHERE 
    category IN ('shopping_net', 'misc_net', 'grocery_pos')
GROUP BY 
    category
ORDER BY 
    small_tx_fraud_rate DESC;

/* Insight:
In high-risk categories, fraud is concentrated in transactions ≥$100, 
suggesting a critical threshold for monitoring.
*/

