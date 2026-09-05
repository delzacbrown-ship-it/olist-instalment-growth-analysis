SELECT i.customer_state, i.total_orders, i.total_sales, i.pct_installment, i.pct_canceled, s.per_capita_avg , s.gini_avg 
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/installment_and_cancellation_by_state.csv' AS i
LEFT JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/state_income_avg.csv' AS s
ON i.customer_state = s.customer_state
;



COPY(
    SELECT i.customer_state, i.total_orders, i.total_sales, i.pct_installment, i.pct_canceled, s.per_capita_avg , s.gini_avg 
    FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/installment_and_cancellation_by_state.csv' AS i
    RIGHT JOIN '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/state_income_avg.csv' AS s
    ON i.customer_state = s.customer_state
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/income_installment_correlation_detail.csv'
(HEADER, DELIMITER ',')
;



SELECT
ROUND(CORR((pct_installment/100),per_capita_avg),6) AS r_income_vs_installment,
ROUND((CORR((pct_installment/100),per_capita_avg))^2,6) AS r_squared_linear,
ROUND(REGR_SLOPE((pct_installment/100),per_capita_avg),6) AS linear_slope,
ROUND(REGR_INTERCEPT((pct_installment/100),per_capita_avg),6) AS linear_intercept,
ROUND(CORR(LN(pct_installment/100),LN(per_capita_avg)),6) AS r_log_income_vs_installment,
ROUND((CORR(LN(pct_installment/100),LN(per_capita_avg)))^2,6) AS r_squared_log_linear,
ROUND(REGR_SLOPE(LN(pct_installment/100),LN(per_capita_avg)),6) AS log_linear_slope,
ROUND(REGR_INTERCEPT(LN(pct_installment/100),LN(per_capita_avg)),6) AS log_linear_intercept,
ROUND(CORR((pct_canceled),per_capita_avg),6) AS r_income_vs_cancellation,
ROUND(CORR((pct_installment/100),gini_avg),6) AS r_gini_vs_installment,
ROUND(CORR((pct_canceled),gini_avg),6) AS r_gini_vs_cancellation,
REGR_COUNT((pct_installment/100),per_capita_avg) AS n_states
FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/income_installment_correlation_detail.csv';




COPY(
    SELECT
    ROUND(CORR((pct_installment/100),per_capita_avg),6) AS r_income_vs_installment,
    ROUND((CORR((pct_installment/100),per_capita_avg))^2,6) AS r_squared_linear,
    ROUND(REGR_SLOPE((pct_installment/100),per_capita_avg),6) AS linear_slope,
    ROUND(REGR_INTERCEPT((pct_installment/100),per_capita_avg),6) AS linear_intercept,
    ROUND(CORR((pct_installment/100),LN(per_capita_avg)),6) AS r_log_income_vs_installment,
    ROUND((CORR((pct_installment/100),LN(per_capita_avg)))^2,6) AS r_squared_log_linear,
    ROUND(REGR_SLOPE((pct_installment/100),LN(per_capita_avg)),6) AS log_linear_slope,
    ROUND(REGR_INTERCEPT((pct_installment/100),LN(per_capita_avg)),6) AS log_linear_intercept,
    ROUND(CORR((pct_canceled),per_capita_avg),6) AS r_income_vs_cancellation,
    ROUND(CORR((pct_installment/100),gini_avg),6) AS r_gini_vs_installment,
    ROUND(CORR((pct_canceled),gini_avg),6) AS r_gini_vs_cancellation,
    REGR_COUNT((pct_installment/100),per_capita_avg) AS n_states
    FROM '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/income_installment_correlation_detail.csv'
) TO '/Users/delzamac/Documents/CODING/Olist Project/New_CSV/income_installment_correlation_summary.csv'
(HEADER, DELIMITER ',');