COPY(
    SELECT p.product_id,p.product_category_name,t.product_category_name_english,p.product_name_lenght,p.product_description_lenght,p.product_photos_qty,p.product_weight_g,p.product_length_cm,p.product_height_cm,p.product_width_cm
    FROM '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/olist_products_dataset.csv' AS p
    JOIN '/Users/delzamac/Documents/CODING/Olist Project/Brazilian E-Commerce Public Dataset by Olist/product_category_name_translation.csv' AS t
    ON p.product_category_name = t.product_category_name
)
TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/olist_products_translated.csv'
(HEADER, DELIMITER ',');
