🛍️ *Customer Shopping Behaviour – Data Engineering & Analytics Project*
📘 Overview



<img width="1920" height="1080" alt="Screenshot 2025-12-05 222200" src="https://github.com/user-attachments/assets/95f4cfaa-1182-42bd-a746-c8cd10ec7d82" />


This project focuses on:
✔ Loading and cleaning a retail customer dataset using Python + Pandas
✔ Handling missing values and feature engineering
✔ Uploading the cleaned dataset into a PostgreSQL database
✔ Performing business insights using SQL analytics

The outcome enables better understanding of customer purchases, product trends, discount behavior, and loyalty patterns.

📂 Dataset Description

File Used: customer_shopping_behavior.csv

Total Columns: 17
Includes:

Customer demographics (Age, Gender, Location)

Shopping details (Item Purchased, Category, Season)

Price and promotion info (Discount Applied, Subscription Status)

Behavioral data (Previous Purchases, Payment Frequency)

Dataset was successfully loaded using Pandas.

🧼 Data Cleaning & Preparation
Missing Values Treatment

review_rating contained null values → filled using median rating within each category:

df['review_rating'] = df.groupby('category')['review_rating'].transform(lambda x: x.fillna(x.median()))

Normalize Column Names
df.columns = df.columns.str.lower().str.replace(' ', '_')

Feature Engineering

📌 Age segmentation:

labels = ['Young Adult', 'Adult', 'Middle-aged', 'Senior']
df['age_group'] = pd.qcut(df['age'], q=4, labels=labels)


📌 Purchase frequency in days:

frequency_mapping = {
    'Fortnightly': 14, 'Weekly': 7, 'Monthly': 30,
    'Quarterly': 90, 'Bi-Weekly': 14,
    'Annually': 365, 'Every 3 Months': 90
}
df['purchase_frequency_days'] = df['frequency_of_purchases'].map(frequency_mapping)


📌 Removed redundant column:

df.drop('promo_code_used', axis=1, inplace=True)


✔ Final dataset had no missing values

🗄 PostgreSQL Integration
Successful Database Connection
conn = psycopg2.connect(
    database="customer_behaviour",
    user="postgres",
    password="1234",
    host="localhost",
    port="5432"
)
print("Connected Successfully!")

Export DataFrame to SQL Table
from sqlalchemy import create_engine

engine = create_engine("postgresql+psycopg2://postgres:1234@localhost:5432/customer_behaviour")
df.to_sql("customer", engine, if_exists="replace", index=False)

print("Data uploaded successfully!")


📌 Data stored in:
Database: customer_behaviour
Table: customer

📊 SQL Business Insights
1️⃣ Top-selling items per category
WITH item_counts AS (
SELECT 
    category,
    item_purchased,
    COUNT(customer_id) AS total_orders,
    ROW_NUMBER() OVER (
        PARTITION BY category 
        ORDER BY COUNT(customer_id) DESC
    ) AS item_rank
FROM customer
GROUP BY category, item_purchased
)
SELECT item_rank, category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <= 3
ORDER BY category, item_rank;

2️⃣ Repeat buyers & subscription behavior
SELECT 
    subscription_status,
    COUNT(customer_id) AS repeat_buyers
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status;

🧠 Skills Learned
Area	Skills
Python	Pandas, Data Cleaning, Feature Engineering
Databases	PostgreSQL, SQLAlchemy, psycopg2
SQL	Window Functions, Aggregations, CTE
Business Insight	Customer Segmentation, Product Performance
🏁 Conclusion

This project demonstrates a full data pipeline:
➡ Data Cleaning → Feature Engineering → Database Storage → SQL Analysis

You can now build:

📊 BI dashboards (Power BI / Tableau)

🤖 Customer prediction models

🧠 Marketing insights reports

🔮 Future Improvements

✔ Add Primary Keys & Constraints
✔ Advanced SQL analytics (LTV, churn, clustering)
✔ Visualization Dashboard in Power BI







