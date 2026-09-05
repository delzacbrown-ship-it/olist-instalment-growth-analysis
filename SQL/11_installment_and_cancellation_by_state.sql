SELECT c.customer_state AS customer_state,
COUNT(c.customer_state) AS total_orders,
ROUND(SUM(v.order_value),2) AS total_sales,
COUNT(CASE WHEN v.is_installment = 'Y' THEN 1 END) AS installment_orders,
ROUND(SUM(CASE WHEN v.is_installment = 'Y' THEN order_value END),2) AS installment_sales,
ROUND(COUNT(CASE WHEN v.is_installment = 'Y' THEN 1 END)*100 / COUNT(c.customer_state),2) AS pct_installment,
COUNT(CASE WHEN v.order_status = 'canceled' THEN 1 END) AS canceled_orders,
ROUND(COUNT(CASE WHEN v.order_status = 'canceled' THEN 1 END) * 100 / COUNT(c.customer_state),2) AS pct_canceled
FROM '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_customers_dataset.csv' AS c
LEFT JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_value_detail.csv' AS v
ON c.customer_id = v.customer_id
GROUP BY customer_state
ORDER BY total_orders DESC
;


-----


COPY(
    SELECT c.customer_state AS customer_state,
    COUNT(c.customer_state) AS total_orders,
    ROUND(SUM(v.order_value),2) AS total_sales,
    COUNT(CASE WHEN v.is_installment = 'Y' THEN 1 END) AS installment_orders,
    ROUND(SUM(CASE WHEN v.is_installment = 'Y' THEN order_value END),2) AS installment_sales,
    ROUND(COUNT(CASE WHEN v.is_installment = 'Y' THEN 1 END)*100 / COUNT(c.customer_state),2) AS pct_installment,
    COUNT(CASE WHEN v.order_status = 'canceled' THEN 1 END) AS canceled_orders,
    ROUND(COUNT(CASE WHEN v.order_status = 'canceled' THEN 1 END) * 100 / COUNT(c.customer_state),2) AS pct_canceled
    FROM '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_customers_dataset.csv' AS c
    LEFT JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_value_detail.csv' AS v
    ON c.customer_id = v.customer_id
    GROUP BY customer_state
    ORDER BY total_orders DESC
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/installment_and_cancellation_by_state.csv'
(HEADER, DELIMITER',');