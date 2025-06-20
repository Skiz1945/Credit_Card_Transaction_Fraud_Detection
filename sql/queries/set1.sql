-- Query 1: Fraud rate by category
/* Examines fraud rates by transaction category (e.g., shopping_net)
 to pinpoint high-risk transaction types, 
informing feature selection for machine learning (ML)
*/

SELECT 
    category, 
    AVG(is_fraud::float) AS fraud_rate, 
    COUNT(*) AS transaction_count
FROM 
    train_transactions
GROUP BY 
    category
ORDER BY 
    fraud_rate DESC;

/* Top 5 Categories:
shopping_net: 1.76% fraud rate (97,543 transactions).
misc_net: 1.46% fraud rate (63,287 transactions).
grocery_pos: 1.41% fraud rate (123,638 transactions).
Insight: These categories have fraud rates 2–3.5x higher than the overall 0.58% (from Python), 
indicating they’re high-risk. 
Lower-risk categories (e.g., home, health_fitness) have fraud rates <0.16%.
*/

-- Query 2: Fraud rate by state
/* Analyzes fraud by state to detect geographic trends, 
useful for anomaly detection or region-specific rules.
*/

SELECT 
    state, 
    AVG(is_fraud::float) AS fraud_rate, 
    COUNT(*) AS transaction_count
FROM 
    train_transactions
GROUP BY 
    state
ORDER BY 
    fraud_rate DESC
LIMIT 10;

/* Insight:
DE’s 100% rate is unreliable due to low volume. 
RI and AK have fraud rates ~3–5x the average, suggesting geographic hotspots, 
but transaction counts vary widely.
*/

-- Query 3: High-value transactions (top 5% by amount per card)
/* Investigates whether large transactions (top 5% per cardholder) 
are more likely to be fraudulent, 
supporting outlier-based fraud detection.
*/

WITH percentiles AS (
    SELECT
        cc_num, 
        PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY amt) AS p95_amt
    FROM
        train_transactions
    GROUP BY
        cc_num
)
SELECT
    t.cc_num,
    t.amt,
    t.trans_date_trans_time,
    t.is_fraud
FROM 
    train_transactions t
JOIN percentiles p ON t.cc_num = p.cc_num
WHERE 
    t.amt > p.p95_amt
ORDER BY 
    t.amt DESC
LIMIT 10;

/* Insight:
Insight: High-value transactions (top 5%) don’t appear fraudulent in this sample, 
contrasting with expectations that large amounts might signal fraud. 
This suggests fraud may involve smaller, frequent transactions.
*/



/* 
Key Takeaways:
- High-risk categories (shopping_net, misc_net, grocery_pos) are prime targets for fraud detection rules.
- Geographic analysis needs caution (e.g., DE’s small sample skews results).
- High-value transactions may not be the main fraud vector, prompting exploration of other patterns (e.g., time, frequency).
*/

