CREATE TABLE IF NOT EXISTS analysis.tmp_rfm_recency (
   user_id INT NOT NULL PRIMARY KEY,
   recency INT NOT NULL CHECK(recency >= 1 AND recency <= 5)
);

INSERT INTO analysis.tmp_rfm_recency(user_id, recency)
WITH last_order_dates AS (
SELECT u.id AS user_id
     , MAX(date_trunc('day', o.order_ts)::date) AS last_order_dt
  FROM analysis.Users u
  LEFT JOIN analysis.Orders o
    ON o.user_id = u.id
   AND o.order_status = 'Closed'
   AND EXTRACT(YEAR FROM o.order_ts) = 2022
 GROUP BY u.id
)
SELECT o.user_id
     , ntile(5) OVER(ORDER BY o.last_order_dt NULLS FIRST, o.user_id) AS recency
  FROM last_order_dates AS o;

-- Нужно для сбора статистики, используемой планировщиком
ANALYZE analysis.tmp_rfm_recency;
