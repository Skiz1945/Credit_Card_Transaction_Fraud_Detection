-- Query 41: Fraud by Hour for shopping_net Merchants
/*
Identify peak fraud hours for high-volume merchants from Query 40.
-- Data Overview: This query provides fraud rates and transaction counts by hour for shopping_net merchants,
It includes merchants such as fraud_Baumbach, Feeney and Morar and fraud_Kozey-Boehm.
*/

SELECT 
    merchant,
    EXTRACT(HOUR FROM trans_date_trans_time) AS hour,
    AVG(is_fraud::float) AS fraud_rate,
    COUNT(*) AS transaction_count
FROM 
    train_transactions
WHERE 
    merchant IN ('fraud_Baumbach, Feeney and Morar', 'fraud_Kozey-Boehm', 'fraud_Kerluke-Abshire', 
                 'fraud_Kuhic LLC', 'fraud_Mosciski, Ziemann and Farrell', 'fraud_Goyette Inc', 
                 'fraud_Jast Ltd', 'fraud_Boyer-Reichert', 'fraud_Schumm PLC', 
                 'fraud_Schmeler, Bashirian and Price')
    AND category = 'shopping_net'
GROUP BY 
    merchant, hour
ORDER BY 
    merchant, hour;

/*
Insights:
Late-night hours are a critical fraud window for shopping_net merchants, likely due to reduced monitoring. 
The merchant-specific patterns indicate varying levels of vulnerability or targeting, which could inform tailored fraud prevention strategies.
*/


-- Query 42: Cardholder Behavior in grocery_pos for 60+ Age Group
/*
Detect compromised accounts by analyzing transaction frequency and fraud rates.
-- Data Overview: This query lists cardholders in the 60+ age group with transactions in grocery_pos, including their transaction counts and fraud rates.
*/

SELECT 
    cc_num,
    COUNT(*) AS transaction_count,
    AVG(is_fraud::float) AS fraud_rate
FROM 
    train_transactions
WHERE 
    category = 'grocery_pos'
    AND DATE_PART('year', AGE(dob)) >= 60
GROUP BY 
    cc_num
ORDER BY 
    fraud_rate DESC
LIMIT 10;

/*
Insights:
The 100% fraud rates with low transaction volumes suggest these accounts are either compromised or used to test stolen card details. 
The focus on the 60+ age group reinforces their vulnerability, possibly due to weaker digital security practices.
*/

-- Query 43: Transaction Amounts for High-Fraud Merchants
/*
Examine transaction amount patterns for merchants with 100% fraud rates from Query 37.
-- Data Overview: This query details the minimum, maximum, and average transaction amounts for merchants with 100% fraud rates.
*/

SELECT 
    merchant,
    MIN(amt) AS min_amount,
    MAX(amt) AS max_amount,
    AVG(amt) AS avg_amount
FROM 
    train_transactions
WHERE 
    merchant IN ('fraud_Dare-Marvin', 'fraud_Cummerata-Hilpert', 'fraud_Dach-Nader', 
                 'fraud_Corwin-Gorczany', 'fraud_Cormier, Stracke and Thiel', 
                 'fraud_Bernier, Volkman and Hoeger', 'fraud_Abshire PLC', 
                 'fraud_Beier LLC', 'fraud_Brown-Greenholt', 'fraud_Dibbert-Green')
    AND is_fraud = 1
GROUP BY 
    merchant;

/*
Insights:
High average fraud amounts indicate fraudsters prioritize large transactions to maximize gains before detection. 
Merchants with higher averages may lack robust controls for high-value transactions, making them prime targets.
*/


