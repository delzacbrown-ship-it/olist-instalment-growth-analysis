SELECT order_id, payment_installments AS max_installments,CASE WHEN payment_installments = 1 THEN 'N' ELSE 'Y' END AS is_installment
FROM '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_order_payments_dataset.csv';




COPY(
    SELECT order_id, MAX(payment_installments) AS max_installments,CASE WHEN MAX(payment_installments) > 1 THEN 'Y' ELSE 'N' END AS is_installment
    FROM '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_order_payments_dataset.csv'
    GROUP BY order_id
)TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/order_payment_flag.csv'
(HEADER, DELIMITER ',');


--old
SELECT order_id, payment_installments AS max_installments,CASE WHEN payment_installments = 1 THEN 'N' ELSE 'Y' END AS is_installment
FROM '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_order_payments_dataset.csv';

--NEW 
SELECT order_id, any_value(payment_installments) AS max_installments,CASE WHEN any_value(payment_installments) = 1 THEN 'N' ELSE 'Y' END AS is_installment
    FROM '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_order_payments_dataset.csv'
    GROUP BY order_id


--new NEW
SELECT order_id, MAX(payment_installments) AS max_installments,CASE WHEN MAX(payment_installments) = 1 THEN 'N' ELSE 'Y' END AS is_installment
FROM '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_order_payments_dataset.csv'
GROUP BY order_id;