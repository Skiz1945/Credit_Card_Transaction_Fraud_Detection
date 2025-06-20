-- Query 16: Top fraudulent merchants in 'shopping_net'
/*
Merchant-specific risks in shopping_net, given its consistent high fraud rates across age groups.
*/

SELECT 
    merchant, 
    AVG(is_fraud::float) AS fraud_rate, 
    COUNT(*) AS transaction_count
FROM 
    train_transactions
WHERE 
    category = 'shopping_net'
GROUP BY 
    merchant
ORDER BY 
    fraud_rate DESC
LIMIT 10;

/*
Insights:
Specific merchants within shopping_net consistently exhibit higher fraud rates, 
suggesting they may be targeted by fraudsters or have vulnerabilities in their transaction systems.
*/


-- Query 17: Fraud rates by category for 60+ age group
/*
Category risks for older users (60+), who exhibit the highest overall fraud rates.
*/

SELECT 
    category, 
    AVG(is_fraud::float) AS fraud_rate, 
    COUNT(*) AS transaction_count
FROM 
    train_transactions
WHERE 
    DATE_PART('year', AGE(dob)) >= 60
GROUP BY 
    category
ORDER BY 
    fraud_rate DESC;

/*
Insights:
For cardholders aged 60+, online shopping (shopping_net), miscellaneous online transactions (misc_net), 
and grocery point-of-sale (grocery_pos) are the most fraud-prone categories, 
while traditional in-person categories like home and health_fitness show minimal fraud.
*/


-- Query 18: Top category-hour combinations for high-risk categories
/*
Time-specific risks in high-risk categories to pinpoint peak fraud windows.
*/

SELECT 
    category, 
    EXTRACT(HOUR FROM trans_date_trans_time) AS hour, 
    AVG(is_fraud::float) AS fraud_rate, 
    COUNT(*) AS transaction_count
FROM 
    train_transactions
WHERE 
    category IN ('shopping_net', 'misc_net', 'grocery_pos')
GROUP BY 
    category, hour
ORDER BY 
    fraud_rate DESC
LIMIT 10;

/*
Insights:
Late-night hours (22:00–23:00) are critical fraud windows, especially for grocery_pos and misc_net, 
where fraud rates spike dramatically. 
shopping_net also shows elevated risk during these hours, though less extreme.
*/


/*
Key Observations:
- Category Trends: shopping_net, misc_net, and grocery_pos are consistently high-risk across age groups and time periods, 
likely due to their online or point-of-sale nature.
- Merchant-Specific Risks: Within shopping_net, merchants like fraud_Kozey-Boehm and fraud_Cormier LLC stand out as fraud hotspots.
- Time Sensitivity: Fraud peaks late at night (22:00–23:00), with grocery_pos showing extraordinarily high fraud rates during these hours, 
possibly indicating automated or coordinated attacks.
*/