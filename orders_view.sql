-- Нужно для ускорения поиска последней даты изменения статуса заказа
CREATE INDEX IF NOT EXISTS orderstatuslog_order_id_dttm_status_id_ix 
    ON production.orderstatuslog USING btree (order_id, dttm DESC, status_id);

ANALYZE production.orderstatuslog;

CREATE OR REPLACE VIEW analysis.Orders AS
SELECT o.order_id
     , o.order_ts
     , o.user_id
     , o.bonus_payment
     , o.payment
     , o.cost
     , o.bonus_grant
     , os."key" as order_status
  FROM production.Orders o
  JOIN (SELECT DISTINCT ON (osl.order_id) osl.order_id
             , osl.status_id
          FROM production.OrderStatusLog osl
         ORDER BY osl.order_id, osl.dttm DESC
       ) osl
    ON (osl.order_id = o.order_id)
  JOIN production.OrderStatuses os
    ON os.id = osl.status_id;
