import pandas as pd
from sqlalchemy import create_engine

# load datasets
fraudTrain = pd.read_csv('data/fraudTrain.csv')
fraudTest = pd.read_csv('data/fraudTest.csv')

# convert datetime columns
fraudTrain['trans_date_trans_time'] = pd.to_datetime(fraudTrain['trans_date_trans_time'])
fraudTrain['dob'] = pd.to_datetime(fraudTrain['dob'])
fraudTest['trans_date_trans_time'] = pd.to_datetime(fraudTest['trans_date_trans_time'])
fraudTest['dob'] = pd.to_datetime(fraudTest['dob'])

# PostgreSQL connection (replace 'your_password' with your actual password)
engine = create_engine('postgresql://postgres:your_password@localhost:5432/fraud_detection')
# import to tables
fraudTrain.to_sql('train_transactions', engine, if_exists='replace', index=False)
fraudTest.to_sql('test_transactions', engine, if_exists='replace', index=False)

print("Data imported successfully!")