CREATE TABLE IF NOT EXISTS analysis.tmp_rfm_monetary_value (
   user_id INT NOT NULL PRIMARY KEY,
   monetary_value INT NOT NULL CHECK(monetary_value >= 1 AND monetary_value <= 5)
);

INSERT INTO analysis.tmp_rfm_monetary_value(user_id, monetary_value) 
WITH order_counts AS ( 
SELECT u.id AS user_id
     , SUM(o.payment) AS order_sum
  FROM analysis.Users u
  LEFT JOIN analysis.Orders o
    ON o.user_id = u.id
   AND o.order_status = 'Closed'
   AND EXTRACT(YEAR FROM o.order_ts) = 2022
 GROUP BY u.id
)
SELECT o.user_id
     , ntile(5) OVER(ORDER BY o.order_sum, o.user_id) AS monetary_value
  FROM order_counts AS o;

-- Нужно для сбора статистики, используемой планировщиком
ANALYZE analysis.tmp_rfm_monetary_value;
