SELECT o.order_purchase_timestamp::DATE AS order_date,
SUM(CASE WHEN ANY_VALUE(i.is_installment) = 'Y' THEN ANY_VALUE(p.payment_value) ELSE 0 END ) OVER(PARTITION BY order_date ORDER BY order_date) AS daily_installment_sales ,
SUM(CASE WHEN ANY_VALUE(i.is_installment) = 'N' THEN ANY_VALUE(p.payment_value) ELSE 0 END ) OVER(PARTITION BY order_date ORDER BY order_date)  AS daily_non_installment_sales ,
SUM(CASE WHEN ANY_VALUE(i.is_installment) = 'Y' THEN ANY_VALUE(p.payment_value) ELSE 0 END ) OVER(ORDER BY order_date) AS running_installment_sales ,
SUM(CASE WHEN ANY_VALUE(i.is_installment) = 'N' THEN ANY_VALUE(p.payment_value) ELSE 0 END ) OVER(ORDER BY order_date) AS running_non_installment_sales 
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i 
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
ON i.order_id = b.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_orders_dataset.csv' AS o
ON i.order_id = o.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_order_payments_dataset.csv' AS p
ON i.order_id = p.order_id
GROUP BY order_date 
;


-----

COPY(
    SELECT o.order_purchase_timestamp::DATE AS order_date,
    SUM(CASE WHEN ANY_VALUE(i.is_installment) = 'Y' THEN ANY_VALUE(p.payment_value) ELSE 0 END ) OVER(PARTITION BY order_date ORDER BY order_date) AS daily_installment_sales,
    SUM(CASE WHEN ANY_VALUE(i.is_installment) = 'N' THEN ANY_VALUE(p.payment_value) ELSE 0 END ) OVER(PARTITION BY order_date ORDER BY order_date) AS daily_non_installment_sales,
    SUM(CASE WHEN ANY_VALUE(i.is_installment) = 'Y' THEN ANY_VALUE(p.payment_value) ELSE 0 END ) OVER(ORDER BY order_date) AS running_installment_sales,
    SUM(CASE WHEN ANY_VALUE(i.is_installment) = 'N' THEN ANY_VALUE(p.payment_value) ELSE 0 END ) OVER(ORDER BY order_date) AS running_non_installment_sales
    FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i 
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
    ON i.order_id = b.order_id
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_orders_dataset.csv' AS o
    ON i.order_id = o.order_id
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_order_payments_dataset.csv' AS p
    ON i.order_id = p.order_id
    GROUP BY order_date
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/installment_cumulative_sales_daily.csv'
(HEADER, DELIMITER',');


----------------------------------------

SELECT 'Y' AS is_installment,
COUNT(CASE WHEN i.is_installment = 'Y' THEN 1 END) AS order_count,
SUM(c.daily_installment_sales) AS total_sales,
total_sales/order_count AS avg_order_value,
(SELECT MEDIAN(payment_value) FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_installment_net.csv') AS median_order_value
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i 
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
ON i.order_id = b.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_orders_dataset.csv' AS o
ON i.order_id = o.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_order_payments_dataset.csv' AS p
ON i.order_id = p.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/installment_cumulative_sales_daily.csv' AS c
ON o.order_purchase_timestamp::DATE = c.order_date
;



SELECT 'Y' AS is_installment,
(SELECT COUNT(payment_value) FROM'/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_installment_net.csv') AS order_count,
SUM(c.daily_installment_sales) AS total_sales,
total_sales/(SELECT COUNT(payment_value) FROM'/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_installment_net.csv')  AS avg_order_value,
(SELECT MEDIAN(payment_value) FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_installment_net.csv') AS median_order_value
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i 
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
ON i.order_id = b.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_orders_dataset.csv' AS o
ON i.order_id = o.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_order_payments_dataset.csv' AS p
ON i.order_id = p.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/installment_cumulative_sales_daily.csv' AS c
ON o.order_purchase_timestamp::DATE = c.order_date
;





SELECT 'N' AS is_installment,
(SELECT COUNT(payment_value) FROM'/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_non_installment_net.csv') AS order_count,
SUM(c.daily_installment_sales) AS total_sales,
total_sales/(SELECT COUNT(payment_value) FROM'/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_non_installment_net.csv')  AS avg_order_value,
(SELECT MEDIAN(payment_value) FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_installment_net.csv') AS median_order_value
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i 
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
ON i.order_id = b.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_orders_dataset.csv' AS o
ON i.order_id = o.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_order_payments_dataset.csv' AS p
ON i.order_id = p.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/installment_cumulative_sales_daily.csv' AS c
ON o.order_purchase_timestamp::DATE = c.order_date
;






COPY(
    SELECT p.order_id , SUM(p.payment_value) AS payment_value FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i INNER JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_order_payments_dataset.csv' AS p
    ON i.order_id = p.order_id WHERE is_installment = 'Y' GROUP BY p.order_id ORDER BY payment_value ASC
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_installment_net.csv'
(HEADER, DELIMITER ',')
;

COPY(
    SELECT p.order_id, SUM(p.payment_value) AS payment_value FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i INNER JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_order_payments_dataset.csv' AS p
    ON i.order_id = p.order_id WHERE is_installment = 'N' GROUP BY p.order_id ORDER BY payment_value ASC
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_non_installment_net.csv'
(HEADER, DELIMITER ',')
;




SELECT MEDIAN(payment_value)
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_installment_net.csv';


SELECT MEDIAN(payment_value)
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_non_installment_net.csv';



------- union time

--- a lot of error around order id having different payment types that throws of the count . all resolved 

SELECT 'Y' AS is_installment,
(SELECT COUNT(payment_value) FROM'/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_installment_net.csv') AS order_count,
(SELECT SUM(payment_value) FROM'/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_installment_net.csv') AS total_sales,
(SELECT SUM(payment_value) FROM'/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_installment_net.csv')/(SELECT COUNT(payment_value) FROM'/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_installment_net.csv')  AS avg_order_value,
(SELECT MEDIAN(payment_value) FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_installment_net.csv') AS median_order_value
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i 
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
ON i.order_id = b.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_orders_dataset.csv' AS o
ON i.order_id = o.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_order_payments_dataset.csv' AS p
ON i.order_id = p.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/installment_cumulative_sales_daily.csv' AS c
ON o.order_purchase_timestamp::DATE = c.order_date
GROUP BY order_count,total_sales,avg_order_value,median_order_value

UNION ALL 


SELECT 'N' AS is_installment,
(SELECT COUNT(payment_value) FROM'/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_non_installment_net.csv') AS order_count,
(SELECT SUM(payment_value) FROM'/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_non_installment_net.csv') AS total_sales,
(SELECT SUM(payment_value) FROM'/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_non_installment_net.csv')/(SELECT COUNT(payment_value) FROM'/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_non_installment_net.csv')  AS avg_order_value,
(SELECT MEDIAN(payment_value) FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_non_installment_net.csv') AS median_order_value
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i 
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
ON i.order_id = b.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_orders_dataset.csv' AS o
ON i.order_id = o.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_order_payments_dataset.csv' AS p
ON i.order_id = p.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/installment_cumulative_sales_daily.csv' AS c
ON o.order_purchase_timestamp::DATE = c.order_date
GROUP BY order_count,total_sales,avg_order_value,median_order_value
;



COPY(
    SELECT 'Y' AS is_installment,
    (SELECT COUNT(payment_value) FROM'/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_installment_net.csv') AS order_count,
    (SELECT SUM(payment_value) FROM'/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_installment_net.csv') AS total_sales,
    (SELECT SUM(payment_value) FROM'/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_installment_net.csv')/(SELECT COUNT(payment_value) FROM'/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_installment_net.csv')  AS avg_order_value,
    (SELECT MEDIAN(payment_value) FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_installment_net.csv') AS median_order_value
    FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i 
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
    ON i.order_id = b.order_id
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_orders_dataset.csv' AS o
    ON i.order_id = o.order_id
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_order_payments_dataset.csv' AS p
    ON i.order_id = p.order_id
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/installment_cumulative_sales_daily.csv' AS c
    ON o.order_purchase_timestamp::DATE = c.order_date
    GROUP BY order_count,total_sales,avg_order_value,median_order_value

    UNION ALL 


    SELECT 'N' AS is_installment,
    (SELECT COUNT(payment_value) FROM'/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_non_installment_net.csv') AS order_count,
    (SELECT SUM(payment_value) FROM'/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_non_installment_net.csv') AS total_sales,
    (SELECT SUM(payment_value) FROM'/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_non_installment_net.csv')/(SELECT COUNT(payment_value) FROM'/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_non_installment_net.csv')  AS avg_order_value,
    (SELECT MEDIAN(payment_value) FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/asc_non_installment_net.csv') AS median_order_value
    FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i 
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
    ON i.order_id = b.order_id
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_orders_dataset.csv' AS o
    ON i.order_id = o.order_id
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_order_payments_dataset.csv' AS p
    ON i.order_id = p.order_id
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/installment_cumulative_sales_daily.csv' AS c
    ON o.order_purchase_timestamp::DATE = c.order_date
    GROUP BY order_count,total_sales,avg_order_value,median_order_value
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/installment_avg_order_value_summary.csv'
(HEADER , DELIMITER ',')