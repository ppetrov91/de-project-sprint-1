CREATE OR REPLACE VIEW analysis.Users AS
SELECT u.*
  FROM production.users u;

CREATE OR REPLACE VIEW analysis.OrderItems AS
SELECT oi.*
  FROM production.OrderItems oi;

CREATE OR REPLACE VIEW analysis.OrderStatuses AS
SELECT os.*
  FROM production.OrderStatuses os;

CREATE OR REPLACE VIEW analysis.Products AS
SELECT p.*
  FROM production.Products p;

-- Вместо status_id нужно отобразить значение поля "key" для упрощения дальнейшей фильтрации
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
  JOIN production.OrderStatuses os
    ON os.id = o.status;  