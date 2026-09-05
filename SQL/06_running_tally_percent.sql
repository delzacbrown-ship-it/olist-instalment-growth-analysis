SELECT o.order_purchase_timestamp::DATE AS order_date ,
COUNT(i.is_installment)AS daily_orders,
COUNT(CASE WHEN i.is_installment = 'Y' THEN 1 END) AS daily_installment_orders,
daily_installment_orders/daily_orders AS daily_pct_installment,
SUM(daily_installment_orders) OVER (ORDER BY order_date) / SUM(daily_orders) OVER (ORDER BY order_date) AS running_pct_installment
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i 
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
ON i.order_id = b.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/repeat_customers.csv' AS r
ON b.customer_unique_id = r.customer_unique_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_orders_dataset.csv' AS o
ON b.order_id = o.order_id
GROUP BY order_date
ORDER BY order_date ASC ;

---------

COPY(
SELECT o.order_purchase_timestamp::DATE AS order_date ,
COUNT(i.is_installment)AS daily_orders,
COUNT(CASE WHEN i.is_installment = 'Y' THEN 1 END) AS daily_installment_orders,
daily_installment_orders/daily_orders AS daily_pct_installment,
SUM(daily_installment_orders) OVER (ORDER BY order_date) / SUM(daily_orders) OVER (ORDER BY order_date) AS running_pct_installment
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i 
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
ON i.order_id = b.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/repeat_customers.csv' AS r
ON b.customer_unique_id = r.customer_unique_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_orders_dataset.csv' AS o
ON b.order_id = o.order_id
GROUP BY order_date
ORDER BY order_date ASC 
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/installment_daily_tally.csv'
(HEADER, DELIMITER ',');


