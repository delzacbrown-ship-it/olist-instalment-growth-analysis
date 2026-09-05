SELECT ANY_VALUE(r.customer_unique_id) AS customer_unique_id,
ANY_VALUE(r.order_count) AS order_count,
SUM(o.order_value) AS total_spend,
SUM(o.order_value)/ANY_VALUE(r.order_count) AS avg_order_value,
CASE WHEN ANY_VALUE(r.order_count) = 1 THEN '1 order' WHEN ANY_VALUE(r.order_count) = 2 THEN '2 orders' ELSE '3+ orders'
END AS frequency_tier
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/repeat_customers.csv' AS r
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_value_detail.csv' AS o
ON r.order_id = o.order_id
GROUP BY r.customer_unique_id
ORDER BY order_count DESC ;







COPY(
    SELECT ANY_VALUE(b.customer_unique_id) AS customer_unique_id,
    COUNT(b.customer_unique_id) AS order_count,
    SUM(o.order_value) AS total_spend,
    SUM(o.order_value)/COUNT(b.customer_unique_id) AS avg_order_value,
    CASE WHEN COUNT(b.customer_unique_id) = 1 THEN '1 order' WHEN COUNT(b.customer_unique_id) = 2 THEN '2 orders' ELSE '3+ orders'
    END AS frequency_tier
    FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
    LEFT JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_value_detail.csv' AS o
    ON b.order_id = o.order_id
    GROUP BY b.customer_unique_id
    ORDER BY order_count DESC 
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_segmentation_detail.csv'
(HEADER, DELIMITER',')
;




---------



SELECT frequency_tier,
COUNT(customer_unique_id) AS customer_count, 
COUNT(customer_unique_id)*100/(SELECT COUNT(customer_unique_id) FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_segmentation_detail.csv' ) AS pct_of_customers, 
SUM(total_spend) AS total_revenue, 
SUM(total_spend)*100/(SELECT SUM(total_spend) FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_segmentation_detail.csv') AS pct_of_revenue, 
total_revenue/customer_count AS avg_total_spend_per_customer
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_segmentation_detail.csv'
GROUP BY frequency_tier
ORDER BY frequency_tier
;



COPY(
    SELECT frequency_tier,
    COUNT(customer_unique_id) AS customer_count, 
    COUNT(customer_unique_id)*100/(SELECT COUNT(customer_unique_id) FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_segmentation_detail.csv' ) AS pct_of_customers, 
    SUM(total_spend) AS total_revenue, 
    SUM(total_spend)*100/(SELECT SUM(total_spend) FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_segmentation_detail.csv') AS pct_of_revenue, 
    total_revenue/customer_count AS avg_total_spend_per_customer
    FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_segmentation_detail.csv'
    GROUP BY frequency_tier
    ORDER BY frequency_tier
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_segmentation_revenue_by_tier.csv'
(HEADER, DELIMITER ',');