-- Query 22: Fraud rates for top high-fraud merchants across all hours
/*
Are these high-fraud merchants consistently risky?
-- Data Overview: This query shows fraud rates for specific merchants across all transaction hours.
*/

SELECT 
    merchant, 
    AVG(is_fraud::float) AS fraud_rate, 
    COUNT(*) AS transaction_count
FROM 
    train_transactions
WHERE 
    merchant IN ('fraud_Kerluke-Abshire', 'fraud_Price Inc', 'fraud_Terry-Huel', 'fraud_Kozey-Boehm', 'fraud_Cormier LLC')
GROUP BY 
    merchant
ORDER BY 
    fraud_rate DESC;

/*
Insights:
These merchants exhibit consistently elevated fraud rates, 
suggesting they may be targeted by fraudsters or have vulnerabilities in their transaction systems. 
The variation in fraud rates (1.32% to 2.57%) indicates differing levels of risk across merchants.
*/


-- Query 23: Fraud rates for 60+ age group with high-fraud merchants
/*
Are older cardholders more likely to transact with high-fraud merchants?
-- Data Overview: This query focuses on fraud rates for the 60+ age group transacting with the same high-risk merchants.
*/

SELECT 
    merchant, 
    AVG(is_fraud::float) AS fraud_rate, 
    COUNT(*) AS transaction_count
FROM 
    train_transactions
WHERE 
    DATE_PART('year', AGE(dob)) >= 60 
    AND merchant IN ('fraud_Kerluke-Abshire', 'fraud_Price Inc', 'fraud_Terry-Huel', 'fraud_Kozey-Boehm', 'fraud_Cormier LLC')
GROUP BY 
    merchant
ORDER BY 
    fraud_rate DESC;

/*
Insights:
Older cardholders (60+) experience higher fraud rates when transacting with these merchants, with rates up to 3.94%. 
This suggests that older users may be more vulnerable to fraud, possibly due to lower digital security awareness.
*/


-- Query 24: Fraud rates by transaction amount for high-frequency cardholders in 'shopping_net'
/*
Do high-frequency cardholders show different fraud patterns by transaction amount?
-- Data Overview: This query analyzes fraud rates by transaction amount bins for high-frequency cardholders in the shopping_net category.
*/

WITH high_freq_cardholders AS (
    SELECT 
        cc_num
    FROM 
        train_transactions
    GROUP BY 
        cc_num
    HAVING 
        COUNT(*) > 100
)
SELECT 
    CASE 
        WHEN amt < 50 THEN '<50'
        WHEN amt < 100 THEN '50-100'
        WHEN amt < 500 THEN '100-500'
        ELSE '500+'
    END AS amount_bin,
    AVG(t.is_fraud::float) AS fraud_rate,
    COUNT(*) AS transaction_count
FROM 
    train_transactions t
JOIN 
    high_freq_cardholders h ON t.cc_num = h.cc_num
WHERE 
    t.category = 'shopping_net'
GROUP BY 
    amount_bin
ORDER BY 
    amount_bin;

/*
Insights:
Fraud is entirely concentrated in high-value transactions ($500+) for frequent users in shopping_net, 
with a striking 35.61% fraud rate. 
Lower-value transactions show no fraud, indicating that fraudsters target larger amounts in this category.
*/

/*
Key Observations:
- Merchant-Specific Risks: Certain merchants (e.g., fraud_Kozey-Boehm) consistently exhibit higher fraud rates, especially for older cardholders.
- Age-Related Vulnerability: Older cardholders (60+) face significantly higher fraud rates when transacting with high-risk merchants.
- High-Value Transaction Fraud: In the shopping_net category, fraud is exclusively tied to transactions over $500, 
with an alarmingly high fraud rate of 35.61% for frequent users.
*/
