SELECT customer_unique_id,ANY_VALUE(customer_id) AS  customer_id,ANY_VALUE(order_id) AS order_id, COUNT(customer_unique_id) AS order_count
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv'
GROUP BY customer_unique_id
ORDER BY order_count DESC;

COPY(
    SELECT customer_unique_id,ANY_VALUE(customer_id) AS  customer_id,ANY_VALUE(order_id) AS order_id, COUNT(order_id) AS order_count
    FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv'
    GROUP BY customer_unique_id
    ORDER BY order_count DESC
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/repeat_customers.csv'
(HEADER, DELIMITER ',');