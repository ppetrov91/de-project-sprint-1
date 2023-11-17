CREATE TABLE IF NOT EXISTS analysis.tmp_rfm_frequency (
   user_id INT NOT NULL PRIMARY KEY,
   frequency INT NOT NULL CHECK(frequency >= 1 AND frequency <= 5)
);

INSERT INTO analysis.tmp_rfm_frequency(user_id, frequency) 
WITH order_counts AS ( 
SELECT u.id AS user_id
     , COUNT(o.user_id) AS order_count
  FROM analysis.Users u
  LEFT JOIN analysis.Orders o
    ON o.user_id = u.id
   AND o.order_status = 'Closed'
   AND EXTRACT(YEAR FROM o.order_ts) = 2022
 GROUP BY u.id
)
SELECT o.user_id
     , ntile(5) OVER(ORDER BY o.order_count, o.user_id) AS frequency
  FROM order_counts AS o;

-- Нужно для сбора статистики, используемой планировщиком
ANALYZE analysis.tmp_rfm_frequency;
