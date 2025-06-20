-- Query 47: Fraud by Merchant and Day of Week in shopping_net
/*
Identify if specific merchants have higher fraud rates on high-risk days (e.g., Thursday, Friday).
-- Data Overview: This query provides fraud rates and transaction counts for specific merchants on different days of the week (0 = Sunday, 6 = Saturday) within the shopping_net category.
*/

SELECT 
    merchant,
    EXTRACT(DOW FROM trans_date_trans_time) AS day_of_week,
    AVG(is_fraud::float) AS fraud_rate,
    COUNT(*) AS transaction_count
FROM 
    train_transactions
WHERE 
    category = 'shopping_net'
GROUP BY 
    merchant, day_of_week
ORDER BY 
    fraud_rate DESC
LIMIT 10;


/*
Insights:
Fraud rates spike mid-to-late week, particularly on Thursdays and Fridays, with fraud_Kozey-Boehm showing a notable peak on Thursday. 
This suggests fraudsters may target specific merchants during these days, possibly exploiting higher transaction volumes or reduced oversight. 
The consistently high fraud rates across multiple merchants indicate systemic vulnerabilities in the shopping_net category during these periods.
*/


-- Query 48: Transaction Amount Distribution for Compromised Cardholders
/*
Analyze transaction amounts for compromised cardholders to detect patterns in fraudulent spending.
-- Data Overview: This query details the minimum, maximum, and average transaction amounts for compromised cardholders with elevated fraud activity.
*/

SELECT 
    cc_num,
    MIN(amt) AS min_amount,
    MAX(amt) AS max_amount,
    AVG(amt) AS avg_amount
FROM 
    train_transactions
WHERE 
    cc_num IN ('501818133297', '501894933032', '503886119844', '577891228931', '676179782773', 
               '676327197445', '4457486401506', '4629125581019', '4748866581408', '4844243189971')
    AND is_fraud = 1
GROUP BY 
    cc_num;


/*
Insights:
Fraudsters appear to initiate small test transactions (e.g., $6.80–$21.86) to confirm card validity 
before executing large fraudulent transactions (up to $1,197.23). The high average amounts ($534–$774) indicate a strategy 
focused on maximizing financial gain, aligning with a pattern of targeting high-value opportunities once a card is compromised.
*/


-- Query 49: Fraud by Merchant, Day of Week, and Hour in shopping_net
/*
Pinpoint specific time windows when fraud peaks for high-risk merchants.
-- Data Overview: This query analyzes fraud rates and transaction counts for specific merchants on particular days and hours within the shopping_net category, 
focusing on high-risk periods.
*/

SELECT 
    merchant,
    EXTRACT(DOW FROM trans_date_trans_time) AS day_of_week,
    EXTRACT(HOUR FROM trans_date_trans_time) AS hour,
    AVG(is_fraud::float) AS fraud_rate,
    COUNT(*) AS transaction_count
FROM 
    train_transactions
WHERE 
    merchant IN ('fraud_Kozey-Boehm', 'fraud_Goyette Inc', 'fraud_Terry-Huel', 'fraud_Kerluke-Abshire', 
                 'fraud_Langworth, Boehm and Gulgowski', 'fraud_Boyer PLC', 'fraud_Mosciski, Ziemann and Farrell', 
                 'fraud_Fisher Inc', 'fraud_Heathcote LLC')
    AND category = 'shopping_net'
GROUP BY 
    merchant, day_of_week, hour
ORDER BY 
    fraud_rate DESC
LIMIT 10;


/*
Insights:
Fraudsters target specific merchants during late-night hours (22:00–23:00), particularly on Thursdays and Fridays, likely exploiting reduced monitoring. 
The moderate transaction counts (7–21) with high fraud rates suggest targeted attacks.
*/


-- Query 50: Cardholders with High Transaction Amounts and Fraud Rates
/*
Identify cardholders most vulnerable to high-value fraud.
-- Data Overview: This query identifies cardholders with high average transaction amounts and fraud rates, highlighting compromised accounts.
*/

SELECT 
    cc_num,
    AVG(amt) AS avg_amount,
    AVG(is_fraud::float) AS fraud_rate,
    COUNT(*) AS transaction_count
FROM 
    train_transactions
GROUP BY 
    cc_num
HAVING 
    AVG(amt) > 500 AND AVG(is_fraud::float) > 0.1
ORDER BY 
    fraud_rate DESC
LIMIT 10;

/*
Insights:
These cardholders are likely fully compromised, with fraudsters executing high-value transactions to maximize gains. 
The 100% fraud rate indicates account takeovers or stolen card usage.
*/

