SELECT ANY_VALUE(f.order_id) AS order_id, SUM(op.payment_value) AS  order_value ,  ANY_VALUE(f.is_installment) AS is_installment,  ANY_VALUE(f.max_installments) AS max_installments,  ANY_VALUE(o.order_status) AS order_status,  ANY_VALUE(o.order_purchase_timestamp::DATE) AS order_date 
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS f
JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_orders_dataset.csv' AS o
ON f.order_id = o.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_order_payments_dataset.csv' AS op
ON f.order_id = op.order_id
GROUP BY f.order_id
ORDER BY order_date
;


COPY(
    SELECT ANY_VALUE(o.customer_id) AS customer_id,ANY_VALUE(f.order_id) AS order_id, SUM(op.payment_value) AS  order_value ,  MAX(f.is_installment) AS is_installment,  MAX(f.max_installments) AS max_installments,  ANY_VALUE(o.order_status) AS order_status,  ANY_VALUE(o.order_purchase_timestamp::DATE) AS order_date 
    FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS f
    RIGHT JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_orders_dataset.csv' AS o
    ON f.order_id = o.order_id
    RIGHT JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_order_payments_dataset.csv' AS op
    ON f.order_id = op.order_id
    GROUP BY f.order_id
    ORDER BY order_date
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_value_detail.csv'
(HEADER, DELIMITER',')
;



------------------------------------------


--YES
SELECT 'Y' AS is_installment, COUNT(o.is_installment) AS order_count, stddev_pop(y.payment_value) AS stddev_order_value, var_pop(y.payment_value) AS variance_order_value, MIN(y.payment_value) AS min_order_value, quantile_cont(y.payment_value, 0.25) AS p25_order_value, MEDIAN(y.payment_value) AS p50_median_order_value, quantile_cont(y.payment_value, 0.75) AS p75_order_value, quantile_cont(y.payment_value, 0.90) AS p90_order_value, quantile_cont(y.payment_value, 0.95) AS p95_order_value, quantile_cont(y.payment_value, 0.99) AS p99_order_value, MAX(y.payment_value) AS max_order_value, skewness(y.payment_value) AS skewness, kurtosis(y.payment_value) AS kurtosis
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_value_detail.csv' AS o
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_installment_net.csv' AS y
ON o.order_id = y.order_id
WHERE is_installment = 'Y'

UNION ALL
-- NO

SELECT 'N' AS is_installment, COUNT(o.is_installment) AS order_count, stddev_pop(n.payment_value) AS stddev_order_value, var_pop(n.payment_value) AS variance_order_value, MIN(n.payment_value) AS min_order_value, quantile_cont(n.payment_value, 0.25) AS p25_order_value, MEDIAN(n.payment_value) AS p50_median_order_value, quantile_cont(n.payment_value, 0.75) AS p75_order_value, quantile_cont(n.payment_value, 0.90) AS p90_order_value, quantile_cont(n.payment_value, 0.95) AS p95_order_value, quantile_cont(n.payment_value, 0.99) AS p99_order_value, MAX(n.payment_value) AS max_order_value, skewness(n.payment_value) AS skewness, kurtosis(n.payment_value) AS kurtosis
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_value_detail.csv' AS o
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_non_installment_net.csv' AS n
ON o.order_id = n.order_id
WHERE is_installment = 'N'
;



COPY(
    --YES
    SELECT 'Y' AS is_installment, COUNT(o.is_installment) AS order_count, stddev_pop(y.payment_value) AS stddev_order_value, var_pop(y.payment_value) AS variance_order_value, MIN(y.payment_value) AS min_order_value, quantile_cont(y.payment_value, 0.25) AS p25_order_value, MEDIAN(y.payment_value) AS p50_median_order_value, quantile_cont(y.payment_value, 0.75) AS p75_order_value, quantile_cont(y.payment_value, 0.90) AS p90_order_value, quantile_cont(y.payment_value, 0.95) AS p95_order_value, quantile_cont(y.payment_value, 0.99) AS p99_order_value, MAX(y.payment_value) AS max_order_value, skewness(y.payment_value) AS skewness, kurtosis(y.payment_value) AS kurtosis
    FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_value_detail.csv' AS o
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_installment_net.csv' AS y
    ON o.order_id = y.order_id
    WHERE is_installment = 'Y'

    UNION ALL
    -- NO

    SELECT 'N' AS is_installment, COUNT(o.is_installment) AS order_count, stddev_pop(n.payment_value) AS stddev_order_value, var_pop(n.payment_value) AS variance_order_value, MIN(n.payment_value) AS min_order_value, quantile_cont(n.payment_value, 0.25) AS p25_order_value, MEDIAN(n.payment_value) AS p50_median_order_value, quantile_cont(n.payment_value, 0.75) AS p75_order_value, quantile_cont(n.payment_value, 0.90) AS p90_order_value, quantile_cont(n.payment_value, 0.95) AS p95_order_value, quantile_cont(n.payment_value, 0.99) AS p99_order_value, MAX(n.payment_value) AS max_order_value, skewness(n.payment_value) AS skewness, kurtosis(n.payment_value) AS kurtosis
    FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_value_detail.csv' AS o
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_non_installment_net.csv' AS n
    ON o.order_id = n.order_id
    WHERE is_installment = 'N'
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_value_distribution_stats.csv'
(HEADER, DELIMITER',')
;