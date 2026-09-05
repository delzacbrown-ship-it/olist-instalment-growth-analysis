SELECT o.order_id,o.customer_id,i.customer_unique_id,p.payment_value
FROM '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_orders_dataset.csv' AS o
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/repeat_customers.csv' AS i
ON o.order_id = i.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_order_payments_dataset.csv' AS p
ON o.order_id = p.order_id
ORDER BY customer_unique_id
;

COPY(
    SELECT o.order_id,o.customer_id,i.customer_unique_id,p.price
    FROM '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_orders_dataset.csv' AS o
    LEFT JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/repeat_customers.csv' AS i
    ON o.order_id = i.order_id
    LEFT JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_order_items_dataset.csv' AS p
    ON o.order_id = p.order_id
    ORDER BY customer_unique_id
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/sanity_test.csv'
(HEADER, DELIMITER',');




WITH order_totals AS (
    SELECT order_id, SUM(payment_value) AS order_total
    FROM '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_order_payments_dataset.csv'
    GROUP BY order_id
),
order_customer AS (
    SELECT o.order_id, c.customer_unique_id
    FROM '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_orders_dataset.csv' o
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_customers_dataset.csv' c
        ON o.customer_id = c.customer_id
),
customer_rollup AS (
    SELECT
        oc.customer_unique_id,
        COUNT(*)             AS order_count,
        SUM(ot.order_total)  AS total_spend
    FROM order_customer oc
    JOIN order_totals ot ON ot.order_id = oc.order_id
    GROUP BY oc.customer_unique_id
)
SELECT SUM(total_spend) AS revenue_2_orders
FROM customer_rollup
WHERE order_count = 2;