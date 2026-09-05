
--- table 1 

COPY(
    SELECT b.customer_unique_id,
    CASE WHEN max(r.order_count) > 1 THEN 'Y' ELSE 'N' END AS multi_order,
    CASE WHEN (max(v.installments_per_customer)/max(v.order_count)) >= 0.5 THEN 'Y' ELSE 'N' END AS installment_customer
    FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i 
    right JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
    ON i.order_id = b.order_id
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/repeat_customers.csv' AS r
    ON b.customer_unique_id = r.customer_unique_id
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_vs_install.csv' AS v
    ON b.customer_unique_id = v.customer_unique_id
    GROUP BY b.customer_unique_id
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_installment_detail.csv'
(HEADER, DELIMITER',');



-- middle step 


SELECT b.customer_unique_id,r.order_count,
COUNT(CASE WHEN i.is_installment = 'Y' THEN 1 END) AS installments_per_customer
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i 
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
ON i.order_id = b.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/repeat_customers.csv' AS r
ON b.customer_unique_id = r.customer_unique_id
GROUP BY b.customer_unique_id,r.order_count
ORDER BY r.order_count DESC ;
 --
COPY(
SELECT b.customer_unique_id,r.order_count,
COUNT(CASE WHEN i.is_installment = 'Y' THEN 1 END) AS installments_per_customer
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i 
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
ON i.order_id = b.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/repeat_customers.csv' AS r
ON b.customer_unique_id = r.customer_unique_id
GROUP BY b.customer_unique_id,r.order_count
ORDER BY r.order_count DESC 
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_vs_install.csv'
(HEADER, DELIMITER',');



-- FINAL in PERCENT 
COPY(
SELECT 'Repeat customers only' AS customer_group,
COUNT(CASE WHEN multi_order = 'Y' THEN 1 END) AS total_customers,
COUNT(CASE WHEN multi_order = 'Y' AND installment_customer = 'Y' THEN 1 END) AS installment_customers,
installment_customers*100/total_customers AS pct_installment_users,
installment_customers/total_customers AS dec_installment_users
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_installment_detail.csv'

UNION ALL

SELECT 'Repeat customers only' AS customer_group,
COUNT(multi_order) AS total_customers,
COUNT(CASE WHEN installment_customer = 'Y' THEN 1 END) AS installment_customers,
installment_customers*100/total_customers AS pct_installment_users,
installment_customers/total_customers AS dec_installment_users
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_installment_detail.csv'
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/repeat_customer_installment_rate.csv'
(HEADER, DELIMITER ',');



------- THE FIGHT


























-- middle step 
SELECT b.customer_unique_id,r.order_count,
COUNT(CASE WHEN i.is_installment = 'Y' THEN 1 END) AS installments_per_customer
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i 
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
ON i.order_id = b.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/repeat_customers.csv' AS r
ON b.customer_unique_id = r.customer_unique_id
GROUP BY b.customer_unique_id,r.order_count
ORDER BY r.order_count DESC ;
 -
COPY(
SELECT b.customer_unique_id,r.order_count,
COUNT(CASE WHEN i.is_installment = 'Y' THEN 1 END) AS installments_per_customer
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i 
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
ON i.order_id = b.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/repeat_customers.csv' AS r
ON b.customer_unique_id = r.customer_unique_id
GROUP BY b.customer_unique_id,r.order_count
ORDER BY r.order_count DESC 
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_vs_install.csv'
(HEADER, DELIMITER',');
--


SELECT b.customer_unique_id,
r.order_count,
CASE WHEN (v.installments_per_customer/v.order_count) >= 0.5 THEN 'Y' ELSE 'N' END AS installment_customer,
i.max_installments AS max_installments,
i.is_installment
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i 
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
ON i.order_id = b.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/repeat_customers.csv' AS r
ON b.customer_unique_id = r.customer_unique_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_vs_install.csv' AS v
ON b.customer_unique_id = v.customer_unique_id
GROUP BY b.customer_unique_id,r.order_count,i.is_installment,i.max_installments,installment_customer;

 )  (COUNT(CASE WHEN i.is_installment = 'Y' THEN 1 END)/COUNT(r.order_count))>= 0.9 THEN 'Y' ELSE 'N' END AS installment_customer



FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i 
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
ON i.order_id = b.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/repeat_customers.csv' AS r
ON b.customer_unique_id = r.customer_unique_id
GROUP BY b.customer_unique_id,r.order_count,i.max_installments,i.is_installment
ORDER BY r.order_count DESC;

-- 
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
ON i.order_id = b.order_id
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/repeat_customers.csv' AS r
ON b.customer_unique_id = r.customer_unique_id
ORDER BY r.order_count DESC

--
COPY(
    SELECT b.customer_unique_id,r.order_count,CASE WHEN r.order_count = 1 THEN 'N' ELSE 'Y' END AS is_repeat_customer,i.is_installment 
    FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
    ON i.order_id = b.order_id
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/repeat_customers.csv' AS r
    ON b.customer_unique_id = r.customer_unique_id
    ORDER BY r.order_count DESC
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_installment_detail.csv'
(HEADER, DELIMITER',');






 -- updated
COPY(
    SELECT b.customer_unique_id,
    CASE WHEN r.order_count > 1 THEN 'Y' ELSE 'N' END AS multi_order,
    CASE WHEN (v.installments_per_customer/v.order_count) >= 0.5 THEN 'Y' ELSE 'N' END AS installment_customer
    FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i 
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
    ON i.order_id = b.order_id
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/repeat_customers.csv' AS r
    ON b.customer_unique_id = r.customer_unique_id
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_vs_install.csv' AS v
    ON b.customer_unique_id = v.customer_unique_id
    GROUP BY b.customer_unique_id,r.order_count,i.is_installment,i.max_installments,installment_customer
    ORDER BY r.order_count DESC
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_installment_detail.csv'
(HEADER, DELIMITER',');

-- updated 2
COPY(
    SELECT b.customer_unique_id,
    CASE WHEN ANY_VALUE(r.order_count) > 1 THEN 'Y' ELSE 'N' END AS multi_order,
    CASE WHEN (ANY_VALUE(v.installments_per_customer)/ANY_VALUE(v.order_count)) >= 0.5 THEN 'Y' ELSE 'N' END AS installment_customer
    FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv' AS i 
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_order_bridge.csv' AS b
    ON i.order_id = b.order_id
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/repeat_customers.csv' AS r
    ON b.customer_unique_id = r.customer_unique_id
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_vs_install.csv' AS v
    ON b.customer_unique_id = v.customer_unique_id
    GROUP BY b.customer_unique_id
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_installment_detail.csv'
(HEADER, DELIMITER',');


-- in PERCENT 
COPY(
SELECT 'Repeat customers only' AS customer_group,
COUNT(CASE WHEN multi_order = 'Y' THEN 1 END) AS total_customers,
COUNT(CASE WHEN multi_order = 'Y' AND installment_customer = 'Y' THEN 1 END) AS installment_customers,
installment_customers*100/total_customers AS pct_installment_users,
installment_customers/total_customers AS dec_installment_users
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_installment_detail.csv'

UNION ALL

SELECT 'Repeat customers only' AS customer_group,
COUNT(multi_order) AS total_customers,
COUNT(CASE WHEN installment_customer = 'Y' THEN 1 END) AS installment_customers,
installment_customers*100/total_customers AS pct_installment_users,
installment_customers/total_customers AS dec_installment_users
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_installment_detail.csv'
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/repeat_customer_installment_rate.csv'
(HEADER, DELIMITER ',');
--

SELECT 'Repeat customers only' AS customer_group, 
COUNT(CASE WHEN is_repeat_customer = 'Y' THEN 1 END) AS total_customers,
COUNT(CASE WHEN i.installment_customer = 'Y' THEN 1 END) AS installment_customers,
AVG(v.installments_per_customer*100/v.order_count) AS pct_installment_users 


FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_installment_detail.csv' AS i
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_vs_install.csv' AS v
ON i.customer_unique_id = v.customer_unique_id
HAVING i.installment_customer = 'Y'

UNION ALL

SELECT 'Whole customer base' AS customer_group, 
COUNT(is_repeat_customer) AS total_customers,
COUNT(CASE WHEN installment_customer = 'Y' THEN 1 END) AS installment_customers,
AVG(v.installments_per_customer*100/v.order_count) AS pct_installment_users 

FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_installment_detail.csv' AS i
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_vs_install.csv' AS v
ON i.customer_unique_id = v.customer_unique_id
;
---

SELECT AVG(*100/v.order_count) AS pct_installment_users 
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_installment_detail.csv' AS i
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_vs_install.csv' AS v
ON i.customer_unique_id = v.customer_unique_id

-------

SELECT 'Repeat order only' AS customer_group, 
SUM(CASE WHEN v.order_count > 1 THEN v.order_count END) AS total_customers,
SUM(CASE WHEN v.order_count > 1 THEN v.installments_per_customer END) AS installment_customers,
installment_customers*100/total_customers AS pct_installment_users 


FROM (SELECT customer_unique_id, COUNT(CASE WHEN order_count > 1 THEN 1 END) AS multi_count_customer, COUNT(CASE WHEN installment_customer = 'Y' THEN 1 END) AS inst_count_customer
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_installment_detail.csv'
WHERE order_count > 1
GROUP BY customer_unique_id;) AS i
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_vs_install.csv' AS v
ON i.customer_unique_id = v.customer_unique_id

UNION ALL

SELECT 'Whole order base' AS customer_group, 
SUM(v.order_count) AS total_customers,
SUM(v.installments_per_customer) AS installment_customers,
installment_customers*100/total_customers AS pct_installment_users 

FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_installment_detail.csv' AS i
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_vs_install.csv' AS v
ON i.customer_unique_id = v.customer_unique_id
;
---
SELECT 'customer_unique_id' AS customer_unique_id, SUM(CASE WHEN order_count > 1 THEN 1 END), SUM(CASE WHEN installment_customer = 'Y' THEN 1 END)
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_installment_detail.csv'
WHERE order_count > 1;

SELECT 'customer_unique_id' AS customer_unique_id, COUNT(CASE WHEN order_count > 1 THEN 1 END), COUNT(CASE WHEN installment_customer = 'Y' THEN 1 END)
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_installment_detail.csv'
GROUP BY customer_unique_id;




