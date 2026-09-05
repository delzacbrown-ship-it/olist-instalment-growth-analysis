SELECT 'installment customers' AS customer_group, 
COUNT(CASE WHEN i.installment_customer = 'Y' THEN 1 END) AS total_customers, 
SUM(CASE WHEN i.installment_customer = 'Y' THEN v.order_count END)/total_customers AS avg_order_count,
COUNT(CASE WHEN i.installment_customer = 'Y' AND i.multi_order = 'Y' THEN 1 END) AS repeat_customers, 
repeat_customers*100/total_customers AS pct_repeat_customers,
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_installment_detail.csv' AS i
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_vs_install.csv' AS v
ON i.customer_unique_id = v.customer_unique_id


UNION ALL

SELECT 'Non-installment customers' AS customer_group, 
COUNT(CASE WHEN i.installment_customer = 'N' THEN 1 END) AS total_customers, 
SUM(CASE WHEN i.installment_customer = 'N' THEN v.order_count END)/total_customers AS avg_order_count,
COUNT(CASE WHEN i.installment_customer = 'N' AND i.multi_order = 'Y' THEN 1 END) AS repeat_customers, 
repeat_customers*100/total_customers AS pct_repeat_customers,
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_installment_detail.csv' AS i
JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_vs_install.csv' AS v
ON i.customer_unique_id = v.customer_unique_id

---

COPY(
    SELECT 'installment customers' AS customer_group, 
    COUNT(CASE WHEN i.installment_customer = 'Y' THEN 1 END) AS total_customers, 
    SUM(CASE WHEN i.installment_customer = 'Y' THEN v.order_count END)/total_customers AS avg_order_count,
    COUNT(CASE WHEN i.installment_customer = 'Y' AND i.multi_order = 'Y' THEN 1 END) AS repeat_customers, 
    repeat_customers*100/total_customers AS pct_repeat_customers,
    FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_installment_detail.csv' AS i
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_vs_install.csv' AS v
    ON i.customer_unique_id = v.customer_unique_id


    UNION ALL

    SELECT 'Non-installment customers' AS customer_group, 
    COUNT(CASE WHEN i.installment_customer = 'N' THEN 1 END) AS total_customers, 
    SUM(CASE WHEN i.installment_customer = 'N' THEN v.order_count END)/total_customers AS avg_order_count,
    COUNT(CASE WHEN i.installment_customer = 'N' AND i.multi_order = 'Y' THEN 1 END) AS repeat_customers, 
    repeat_customers*100/total_customers AS pct_repeat_customers,
    FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_installment_detail.csv' AS i
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_vs_install.csv' AS v
    ON i.customer_unique_id = v.customer_unique_id
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/customer_installment_frequency_summary.csv'
(HEADER, DELIMITER ',');