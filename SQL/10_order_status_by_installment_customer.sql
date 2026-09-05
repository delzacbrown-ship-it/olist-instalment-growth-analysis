SELECT order_status, 
COUNT(order_id) AS total_orders,
COUNT(CASE WHEN is_installment = 'Y' THEN 1 END) AS installment_orders, 
COUNT(CASE WHEN is_installment = 'N' THEN 1 END) AS non_installment_orders,
installment_orders *100/COUNT(order_id) AS pct_installment_orders,
non_installment_orders *100/COUNT(order_id) AS pct_non_installment_orders
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_value_detail.csv'
GROUP BY order_status
ORDER BY total_orders DESC

-- UNION ALL 

COPY(
    SELECT 'ALL ORDERS (baseline)' AS order_status, 
    COUNT(order_id) AS total_orders,
    COUNT(CASE WHEN is_installment = 'Y' THEN 1 END) AS installment_orders, 
    COUNT(CASE WHEN is_installment = 'N' THEN 1 END) AS non_installment_orders,
    installment_orders *100/COUNT(order_id) AS pct_installment_orders,
    non_installment_orders *100/COUNT(order_id) AS pct_non_installment_orders
    FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_value_detail.csv'

    UNION ALL

    SELECT order_status, 
    COUNT(order_id) AS total_orders,
    COUNT(CASE WHEN is_installment = 'Y' THEN 1 END) AS installment_orders, 
    COUNT(CASE WHEN is_installment = 'N' THEN 1 END) AS non_installment_orders,
    installment_orders *100/COUNT(order_id) AS pct_installment_orders,
    non_installment_orders *100/COUNT(order_id) AS pct_non_installment_orders
    FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_value_detail.csv'
    GROUP BY order_status
    ORDER BY total_orders DESC
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_status_by_installment_customer.csv'
(HEADER, DELIMITER ',')