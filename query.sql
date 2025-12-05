select * from customer limit 20


select gender, SUM(purchase_amount) as revenue
from customer
group by gender


select customer id, purchase_amount
from customer
where discount_applied 'Yes' and purchase_amount >= (select AVG (purchase_amount) from customer)



select item_purchased, ROUND (AVG(review_rating:: numeric), 2) as "Average Product Rating"
from customer
group by item_purchased
order by avg(review_rating) desc
limit 5;



select shipping_type,
ROUND (AVG (purchase_amount),2)
from customer
where shipping type in ('Standard', 'Express')
group by shipping_type


select subscription_status,
COUNT (customer_id) as total_customers,
ROUND (AVG (purchase_amount), 2) as avg_spend,
ROUND (SUM (purchase_amount), 2) as total_revenue
from customer
group by subscription_status
order by total_revenue, avg_spend desc;



SELECT 
    item_purchased,
    ROUND(SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) ::numeric 
    / COUNT(*) * 100, 2) AS discount_rate
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;





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

SELECT 
    item_rank,
    category,
    item_purchased,
    total_orders
FROM item_counts
WHERE item_rank <= 3;




SELECT 
    subscription_status,
    COUNT(customer_id) AS repeat_buyers
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status;




