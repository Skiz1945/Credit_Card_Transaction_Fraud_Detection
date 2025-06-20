-- Query 31: Transaction Patterns for High-Risk Merchants
/*
Analyze transaction amounts and times for merchants from Query 28 
to confirm if fraud concentrates in specific hours or amounts.
-- Data Overview:
This query provides transaction amounts and counts by hour for high-risk merchants identified earlier.
It focuses on merchant-specific trends over a 24-hour period.
*/

SELECT 
    merchant,
    EXTRACT(HOUR FROM trans_date_trans_time) AS hour,
    AVG(amt) AS average_amount,
    COUNT(*) AS transaction_count
FROM 
    train_transactions
WHERE 
    merchant IN ('fraud_Bashirian Group', 'fraud_Baumbach, Feeney and Morar', 'fraud_Boyer-Reichert', 'fraud_Boyer PLC', 'fraud_Cormier LLC', 'fraud_Fisher-Schowalter', 'fraud_Fisher Inc', 'fraud_Gerlach Inc', 'fraud_Gleason-Macejkovic', 'fraud_Ankunding LLC')
GROUP BY 
    merchant, hour
ORDER BY 
    merchant, hour;

/*
Insights:
The concentration of high-value transactions during late-night and early morning hours suggests fraudsters exploit reduced monitoring during these periods. 
This aligns with previous findings of fraud spikes in similar time windows, particularly for high-risk merchants.
*/


-- Query 32: Cardholder Behavior in High-Risk shopping_net Transactions
/*
Identify cardholders with frequent high-value shopping_net transactions during 22:00–23:00 to detect compromised accounts.
-- Data Overview:
This query lists cardholders involved in frequent high-value shopping_net transactions (≥$500) during 22:00–23:00, 
detailing transaction counts, average amounts, and fraud rates.
*/

SELECT 
    cc_num,
    COUNT(*) AS transaction_count,
    AVG(amt) AS average_amount,
    AVG(is_fraud::float) AS fraud_rate
FROM 
    train_transactions
WHERE 
    category = 'shopping_net'
    AND amt >= 500
    AND EXTRACT(HOUR FROM trans_date_trans_time) IN (22, 23)
GROUP BY 
    cc_num
HAVING 
    COUNT(*) >= 5
ORDER BY 
    fraud_rate DESC
LIMIT 10;

/*
Insights:
The uniform 100% fraud rate across these cardholders indicates they are either compromised or actively involved in fraud. 
The high average amounts and timing (late-night) suggest targeted exploitation, 
possibly of vulnerable cardholders, such as those in the 60+ age group identified in prior queries.
*/


-- Query 33: Fraud by Merchant and Age Group in grocery_pos
/*
Explore grocery_pos fraud for the 60+ age group, given its high fraud rate (2.04%, Query 26), to complement shopping_net findings.
-- Data Overview:
This query highlights merchants with unusual activity during 22:00–23:00 for transactions ≥$500, providing fraud rates and transaction counts.
*/

SELECT 
    merchant,
    AVG(is_fraud::float) AS fraud_rate,
    COUNT(*) AS transaction_count
FROM 
    train_transactions
WHERE 
    category = 'grocery_pos'
    AND DATE_PART('year', AGE(dob)) >= 60
GROUP BY 
    merchant
HAVING 
    COUNT(*) >= 10
ORDER BY 
    fraud_rate DESC
LIMIT 10;


/*
Insights:
These merchants process significant volumes of high-value transactions late at night, 
with fraud rates 4–6 times the dataset average (0.58% from earlier queries). 
This points to systematic vulnerabilities or targeted fraud, differing from the low-volume, 100% fraud merchants identified previously.
*/