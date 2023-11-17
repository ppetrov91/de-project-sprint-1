CREATE TABLE IF NOT EXISTS analysis.dm_rfm_segments (
    user_id INT NOT NULL PRIMARY KEY,
    recency INT NOT NULL CHECK(recency >= 1 AND recency <= 5),
    frequency INT NOT NULL CHECK(frequency >= 1 AND frequency <= 5),
    monetary_value INT NOT NULL CHECK(monetary_value >= 1 AND monetary_value <= 5)
);

/* Нужно для ускорения поиска по году заказа, а также для улучшения точности 
   определения расчётного количества строк планировщиком */
CREATE INDEX IF NOT EXISTS orders_year_ix ON production.Orders((extract(year from order_ts)));

ANALYZE production.Orders;
