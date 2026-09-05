SELECT * , ROUND(((pib_per_capita_2017 + pib_per_capita_2018)/2),2) AS per_capita_avg, ROUND(((gini_2017 + gini_2018)/2),3) AS gini_avg
FROM '/Users/delzamac/Documents/CODING/Olist Project/Brazil income data/ibge_state_income_gini_2017_2018.csv'
;



COPY(
    SELECT * , ROUND(((pib_per_capita_2017 + pib_per_capita_2018)/2),2) AS per_capita_avg, ROUND(((gini_2017 + gini_2018)/2),3) AS gini_avg
    FROM '/Users/delzamac/Documents/CODING/Olist Project/Brazil income data/ibge_state_income_gini_2017_2018.csv'
)TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/state_income_avg'
(HEADER, DELIMITER ',')
;