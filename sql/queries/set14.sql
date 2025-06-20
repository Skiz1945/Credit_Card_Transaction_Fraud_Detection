-- Adjust Query 37
/*
Broaden the scope to capture late-night, high-value transactions across more merchants or categories.
*/

SELECT 
    merchant,
    COUNT(*) AS transaction_count,
    AVG(is_fraud::float) AS fraud_rate
FROM 
    train_transactions
WHERE 
    amt >= 500
    AND EXTRACT(HOUR FROM trans_date_trans_time) IN (22, 23)
GROUP BY 
    merchant
ORDER BY 
    fraud_rate DESC
LIMIT 10;

/*
Insights:
The 100% fraud rates suggest these merchants are either highly vulnerable during late-night, 
high-value transactions or involved in targeted attacks. Low transaction counts indicate potential outliers rather than systemic fraud hubs.
*/


-- Query 40: Investigate shopping_net for 60+ Age Group
/*
Analyze merchants in the shopping_net category, another high-risk area, to compare with grocery_pos.
*/

SELECT 
    merchant,
    COUNT(*) AS transaction_count,
    AVG(is_fraud::float) AS fraud_rate
FROM 
    train_transactions
WHERE 
    category = 'shopping_net'
    AND DATE_PART('year', AGE(dob)) >= 60
GROUP BY 
    merchant
ORDER BY 
    fraud_rate DESC
LIMIT 10;


/*
Insights:
The 60+ age group is disproportionately targeted in shopping_net, with fraud rates 6–7 times the average, 
pointing to vulnerabilities in online transactions for older cardholders.
*/



