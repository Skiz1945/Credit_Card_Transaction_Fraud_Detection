-- Query 37: Broaden Merchant Overlap in High-Risk Transactions
/*
Adjust Query 35 to capture merchant activity in late-night, high-value transactions without category restriction.
*/

SELECT 
    merchant,
    COUNT(*) AS transaction_count,
    AVG(is_fraud::float) AS fraud_rate
FROM 
    train_transactions
WHERE 
    merchant IN ('fraud_Rau and Sons', 'fraud_Padberg-Welch', 'fraud_Doyle Ltd', 'fraud_Stracke-Lemke', 
                 'fraud_Bailey-Morar', 'fraud_Goodwin-Nitzsche', 'fraud_Heidenreich PLC', 
                 'fraud_Bradtke PLC', 'fraud_Vandervort-Funk', 'fraud_Koepp-Witting')
    AND amt >= 500
    AND EXTRACT(HOUR FROM trans_date_trans_time) IN (22, 23)
GROUP BY 
    merchant
ORDER BY 
    fraud_rate DESC;

/* no data
Insights:
The absence of data suggests that the conditions of Query 37—likely targeting specific merchants 
involved in late-night (e.g., 22:00–23:00), high-value transactions (e.g., ≥$500)—were too restrictive. 
This could mean that the selected merchants have no activity during these hours, no transactions exceeded the value threshold, 
or the query logic needs adjustment. To make this query more informative, broadening the merchant list or relaxing time 
and amount constraints could help capture relevant data.
*/

-- Query 38: Analyze Fraud in grocery_pos by Merchant for 60+ Age Group
/*
Identify merchants driving fraud in grocery_pos for older cardholders.
-- Data Overview: Lists merchants involved in grocery_pos transactions for cardholders aged 60+, providing transaction counts and fraud rates. 
*/

SELECT 
    merchant,
    COUNT(*) AS transaction_count,
    AVG(is_fraud::float) AS fraud_rate
FROM 
    train_transactions
WHERE 
    category = 'grocery_pos'
    AND DATE_PART('year', AGE(dob)) >= 60
GROUP BY 
    merchant
HAVING 
    COUNT(*) >= 5
ORDER BY 
    fraud_rate DESC
LIMIT 10;


/*
Insights:
These merchants show elevated fraud rates in the grocery_pos category for older cardholders (60+), 
suggesting they may be targeted by fraudsters or have vulnerabilities in their point-of-sale systems. 
The high transaction volumes paired with fraud rates 4–6 times the dataset average highlight these merchants 
as critical areas for fraud detection efforts. The 60+ age group appears particularly vulnerable in this context, 
consistent with broader trends of higher fraud susceptibility among older cardholders.
*/


-- Query 39: Transaction Timing for Compromised Cardholders
/*
Examine the timing of transactions for cardholders with 100% fraud rates from Query 34.
-- Data Overview: Provides transaction details (hour, count, average amount) for three specific credit card numbers 
(577891228931, 676327197445, 4593569795412), grouped by hour of the day.
*/

SELECT 
    cc_num,
    EXTRACT(HOUR FROM trans_date_trans_time) AS hour,
    COUNT(*) AS transaction_count,
    AVG(amt) AS average_amount
FROM 
    train_transactions
WHERE 
    cc_num IN ('676327197445', '4593569795412', '577891228931')
GROUP BY 
    cc_num, hour
ORDER BY 
    cc_num, hour;


/*
Insights:
The pattern of high-value transactions concentrated in late-night hours (22:00–23:00) aligns with previous findings 
that these times are high-risk periods for fraud, especially for high-value transactions. 
This behavior is suspicious, particularly if these cardholders are in the 60+ age group, which is more vulnerable to fraud. 
The combination of higher transaction counts and elevated amounts during these hours suggests potential fraudulent activity, 
possibly indicating compromised cards or targeted attacks.
*/





