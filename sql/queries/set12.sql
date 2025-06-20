-- Query 34: Cardholder Age and Fraud in shopping_net Transactions
/*
Verify if Query 32’s compromised cardholders are in the 60+ age group.
-- Data Overview: This query provides details on cardholders involved in shopping_net transactions, 
including their age, transaction count, average transaction amount, and fraud rate. 
*/

SELECT 
    cc_num,
    DATE_PART('year', AGE(dob)) AS age,
    COUNT(*) AS transaction_count,
    AVG(amt) AS average_amount,
    AVG(is_fraud::float) AS fraud_rate
FROM 
    train_transactions
WHERE 
    cc_num IN ('4806443445305', '30030380240193', '60427851591', '4593569795412', '565399283797', 
               '676148621961', '676327197445', '577891228931', '581293083266', '30427035050508')
GROUP BY 
    cc_num, age
ORDER BY 
    fraud_rate DESC;

/*
Insights:
Cardholders with low transaction counts (8–19) consistently show a 100% fraud rate, 
suggesting these may be compromised accounts or targets of fraudsters testing stolen credentials. 
In contrast, cardholders with high transaction counts (500–2,024) exhibit significantly lower fraud rates (0.44%–2.65%), 
indicating that fraudsters may avoid high-frequency accounts to reduce detection risk. 
Older cardholders (e.g., ages 63 and 77) with high fraud rates suggest potential vulnerability in the 60+ age group, 
while younger cardholders (e.g., age 29) with similar patterns indicate fraud is not exclusively age-specific in this category.
*/


-- Query 35: Merchant Overlap in High-Risk Transactions
/*
Check for overlap between Query 33’s high-volume merchants and prior high-risk merchants.
-- Data Overview: This query aimed to identify overlapping merchants in high-risk transactions.
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
    AND category = 'shopping_net'
    AND amt >= 500
    AND EXTRACT(HOUR FROM trans_date_trans_time) IN (22, 23)
GROUP BY 
    merchant
ORDER BY 
    fraud_rate DESC;


/*
Insights:
The absence of data suggests that the query conditions—likely involving specific merchants, 
the shopping_net category, late-night hours (e.g., 22:00–23:00), and high-value transactions (e.g., ≥$500)—were too restrictive. 
Alternatively, the specified merchants may not be active in shopping_net during the defined time frame, or no overlapping activity exists under these parameters. 
This gap indicates a need to adjust the query to capture relevant data, such as broadening the merchant list or relaxing time and amount constraints.
*/


-- Query 36: Fraud by Transaction Frequency in grocery_pos for 60+ Age Group
/*
Investigate fraud patterns in another high-risk category for older cardholders.
-- Data Overview: This query lists cardholders in the 60+ age group with transactions in the grocery_pos category, showing their transaction counts and fraud rates.
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
The consistent 100% fraud rate across all listed cardholders, coupled with minimal transaction counts (1–3), 
suggests that these accounts may have been specifically targeted for fraud in grocery_pos, possibly via point-of-sale skimming or account takeovers. 
The focus on the 60+ age group aligns with Query 34’s findings of age-related vulnerability, reinforcing that older cardholders may be more susceptible 
due to lower digital security awareness or targeted attacks.
*/

