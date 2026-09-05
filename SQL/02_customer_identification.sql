SELECT c.customer_unique_id,c.customer_id,o.order_id
FROM '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_customers_dataset.csv' AS c')
JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_orders_dataset.csv' AS o
ON c.customer_id = o.customer_id
LIMIT 5;

COPY(
    SELECT c.customer_unique_id,c.customer_id,o.order_id
    FROM '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_customers_dataset.csv' AS c
    FULL JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_orders_dataset.csv' AS o
    ON c.customer_id = o.customer_id
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv'
(HEADER, DELIMITER ',');