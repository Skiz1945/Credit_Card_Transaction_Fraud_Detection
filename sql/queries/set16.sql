-- Query 44: Fraud by Day of Week for High-Risk Hours
/*
Determine if specific days amplify fraud during 22:00–23:00 in shopping_net.
-- Data Overview: This query analyzes fraud rates and transaction counts by day of the week (0 = Sunday, 6 = Saturday) 
for shopping_net transactions during high-risk hours (22:00–23:00).
*/

SELECT 
    EXTRACT(DOW FROM trans_date_trans_time) AS day_of_week,
    AVG(is_fraud::float) AS fraud_rate,
    COUNT(*) AS transaction_count
FROM 
    train_transactions
WHERE 
    category = 'shopping_net'
    AND EXTRACT(HOUR FROM trans_date_trans_time) IN (22, 23)
GROUP BY 
    day_of_week
ORDER BY 
    fraud_rate DESC;

/*
Insights:
Fraud rates peak towards the end of the workweek (Thursday and Friday), suggesting fraudsters may exploit higher transaction volumes
 or reduced vigilance during these days. The lower fraud rates on weekends and early weekdays indicate potential periods of increased merchant oversight or lower fraudster activity. 
This pattern highlights that late-night hours combined with specific days amplify fraud risk in the shopping_net category.
/*


-- Query 45: Age Distribution of Compromised Cardholders
/*
Verify if compromised cardholders from Query 42 are in the 60+ age group.
-- Data Overview:
This query lists compromised cardholders with their ages, transaction counts, and fraud rates. All cardholders have a 100% fraud rate.
*/

SELECT 
    cc_num,
    DATE_PART('year', AGE(dob)) AS age,
    COUNT(*) AS transaction_count,
    AVG(is_fraud::float) AS fraud_rate
FROM 
    train_transactions
WHERE 
    cc_num IN ('4748866581408', '4457486401506', '4629125581019', '577891228931', '501818133297', 
               '676327197445', '676179782773', '503886119844', '501894933032', '4844243189971')
GROUP BY 
    cc_num, age
ORDER BY 
    fraud_rate DESC;

/*
Insights:
The compromised cardholders are exclusively in the 60+ age group, reinforcing the pattern of older cardholders being disproportionately targeted. 
The 100% fraud rates suggest these accounts are either fully compromised or used for testing stolen credentials. 
This indicates a significant vulnerability among older demographics, possibly due to lower awareness or weaker security measures.
*/


-- Query 46: Transaction Patterns for High-Fraud Merchants
/*
Examine transaction timing for merchants with high fraud amounts from Query 43.
-- Data Overview: This query details the hour, transaction count, and average amount for fraudulent transactions at three high-fraud merchants: 
fraud_Bernier, Volkman and Hoeger, fraud_Corwin-Gorczany, and fraud_Dach-Nader
*/

SELECT 
    merchant,
    EXTRACT(HOUR FROM trans_date_trans_time) AS hour,
    COUNT(*) AS transaction_count,
    AVG(amt) AS avg_amount
FROM 
    train_transactions
WHERE 
    merchant IN ('fraud_Corwin-Gorczany', 'fraud_Bernier, Volkman and Hoeger', 'fraud_Dach-Nader')
    AND is_fraud = 1
GROUP BY 
    merchant, hour
ORDER BY 
    merchant, hour;

/*
Insights:
Fraudulent activity at these merchants is heavily concentrated in late-night hours, with higher transaction counts and amounts, 
indicating fraudsters exploit reduced oversight during these times. The sparse daytime fraud suggests that merchants may have stronger controls 
or fraudsters avoid peak hours to minimize detection.
*/
