-- Query 19: Top merchants in 'shopping_net' with high fraud rates during peak hours (22:00-23:00)
/*
Identify if specific merchants in high-risk categories are more vulnerable during late-night hours.
*/

SELECT 
    merchant, 
    EXTRACT(HOUR FROM trans_date_trans_time) AS hour, 
    AVG(is_fraud::float) AS fraud_rate, 
    COUNT(*) AS transaction_count
FROM 
    train_transactions
WHERE 
    category = 'shopping_net' 
    AND EXTRACT(HOUR FROM trans_date_trans_time) IN (22, 23)
GROUP BY 
    merchant, hour
ORDER BY 
    fraud_rate DESC
LIMIT 10;

/*
Insights:
Specific merchants in the shopping_net category are highly vulnerable to fraud during late-night hours (22:00–23:00), 
suggesting targeted attacks or reduced oversight during these times.
*/


-- Query 20: Fraud rates by age group during peak fraud hours (22:00-23:00)
/*
Assess whether older cardholders (60+) are disproportionately targeted during peak fraud hours.
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
WHERE 
    EXTRACT(HOUR FROM trans_date_trans_time) IN (22, 23)
GROUP BY 
    age_group
ORDER BY 
    fraud_rate DESC;


/*
Insights:
Older cardholders (60+) are disproportionately affected by fraud during late-night hours, 
with a fraud rate over 2.5 times higher than younger groups, possibly due to lower digital security awareness.
*/


-- Query 21: Fraud rates for high-frequency cardholders in high-risk categories
/*
Investigate if frequent transactors are more prone to fraud in high-risk categories.
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
    t.category, 
    AVG(t.is_fraud::float) AS fraud_rate, 
    COUNT(*) AS transaction_count
FROM 
    train_transactions t
JOIN 
    high_freq_cardholders h ON t.cc_num = h.cc_num
WHERE 
    t.category IN ('shopping_net', 'misc_net', 'grocery_pos')
GROUP BY 
    t.category
ORDER BY 
    fraud_rate DESC;

/*
Insights:
Even among cardholders with more than 100 transactions, fraud rates remain elevated in high-risk categories, 
though lower than merchant-specific or time-specific rates.
*/

/*
Key Observations:
- Merchant-Specific Risks: Certain merchants (e.g., fraud_Kerluke-Abshire) 
show extremely high fraud rates during late-night hours, 
indicating potential fraud rings or merchant vulnerabilities.
- Age-Related Vulnerability: Older cardholders (60+) face significantly higher fraud rates during peak fraud hours, 
suggesting targeted exploitation.
- High-Frequency Cardholders: Frequent transactors still face notable fraud risks in high-risk categories, 
though their rates are lower overall.
*/
