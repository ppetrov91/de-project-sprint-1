## 1.3.1. Анализ качества данных

1) В таблице users поле login должно быть уникальным, в настоящий момент соответствующее ограничение в БД отсутствует

  ```SQL
  --Впишите сюда ваш ответ
  SELECT u.login
       , COUNT(1) as cnt
    FROM users u
   GROUP BY u.login
  HAVING COUNT(1) > 1;
  ```

  В данном случае, все логины уникальны.

  Предлагается создать следующий индекс и ограничение уникальности

  ```SQL
  CREATE UNIQUE INDEX users_login_ukey ON production.users (login);

  ALTER TABLE production.users ADD CONSTRAINT users_login_ukey UNIQUE USING INDEX users_login_ukey;
  ```
  
2) В таблице products price должна быть положительной.

   В данном случае это можно проверить с помощью запроса ниже.

   ```SQL
   SELECT p.id
     FROM production.products p
    WHERE p.price <= 0;
   ```

   Также для поля price создано ограничение products_price_cl типа CHECK, что не позволяет 

   цене товара быть отрицательной или нулевой.
   
3) Наименование товара не может быть пустым.

   В СУБД PostgreSQL NULL и пустая строка не является одним и тем же.

   Также может быть ситуация, при которой в наименовании товара могут быть одни пробелы

    В данном случае это можно проверить с помощью запроса ниже.

    ```SQL
     SELECT p.id
       FROM production.products p
      WHERE p.name IS NULL OR trim(p.name) = '';
    ```

4) Cтрока с leading и trailing пробелами и без них являются разными, что может

   вызвать проблемы с уникальностью имён товаров при удалении пробелов.

   Запрос ниже показывает отсутствует leading и trailing пробелов в поле name

  ```SQL
  SELECT p.id
    FROM production.products p
   WHERE length(p.name) != length(trim(p.name));
  ```

5) Запрос ниже показывает отсутствие дубликатов в именах товаров:

   ```SQL
   SELECT TRIM(p.name) as name
        , COUNT(1) as cnt
      FROM production.products p
     GROUP BY TRIM(p.name)
    HAVING COUNT(1) > 1;
   ```

6) Отсутствует ограничение уникальности на поле name, предлагается его создать следующим образом:

  ```SQL 
  CREATE UNIQUE INDEX products_name_ukey ON production.products(name);

  ALTER TABLE production.products ADD CONSTRAINT products_name_ukey UNIQUE USING INDEX products_name_ukey;
  ```

7) Обнаружено отсутствие внешнего ключа между таблицами users и orders. 

   Без пользователя заказ не может существовать, запрос ниже подтверждает это

   ```SQL
   SELECT o.user_id
     FROM production.orders o
    WHERE NOT EXISTS (SELECT 1
                        FROM production.users u
                       WHERE u.id = o.user_id);
   ```

   Предлагается создать внешний ключ для связки таблиц orders и users следующим образом:

   ```SQL
   ALTER TABLE production.orders ADD CONSTRAINT orders_user_id_fk FOREIGN KEY(user_id) REFERENCES production.users(id);
   ```

8) Один пользователь в одну и ту же отметку времени не может создать более одного заказа, 

   запрос ниже подтверждает это:

   ```SQL
   SELECT o.order_ts
        , o.user_id
        , COUNT(1) AS cnt 
     FROM production.orders o
    GROUP BY o.order_ts, o.user_id
    HAVING COUNT(1) > 1;
  ```

9) В настоящий момент представлены данные от 2022-02-12 02:41:28 до 2022-03-14 02:38:36, т.е, за месяц

   Это можно проверить запросом ниже:

   ```SQL
   SELECT MIN(o.order_ts)
        , MAX(o.order_ts) 
     FROM production.orders o;
   ```

10) Значение поля status таблицы production.orders должно совпадать со значением поля id таблицы production.orderstatuses

   Это можно проверить запросом ниже:

   ```SQL
   SELECT o.status
     FROM production.orders o
    WHERE NOT EXISTS (SELECT 1
                        FROM production.orderstatuses os
                       WHERE os.id = o.status);
   ```                    

11) Тип данных полей bonus_payment, payment, cost и bonus_grant numeric(19, 5), это гарантирует сохранение только числовых значений.

## 1.3.2. Описание используемых инструментов для обеспечения качества данных в таблицах схемы production

| Таблицы             | Объект                          | Инструмент                          | Для чего используется                                                                               |
| ------------------- | ------------------------------- | ------------------------------------| ----------------------------------------------------------------------------------------------------|
| production.users    | id int                          | Первичный ключ users_pkey           | Обеспечивает уникальность записей о пользователях                                                   |
| production.users    | login varchar(2048)             | Ограничение NOT NULL                | Обеспечивает отсутствие NULL-значений в поле login                                                  |
| production.users    | login varchar(2048)             | Уникальный ключ users_ukey          | Обеспечивает уникальность пользовательских логинов                                                  |
| production.products | id int                          | Первичный ключ products_pkey        | Обеспечивает уникальность записей о продуктах                                                       |
| production.products | name varchar(2048)              | Ограничение NOT NULL                | Обеспечивает отсутствие NULL-значений в поле name                                                   |
| production.products | price numeric(19,5)             | products_price_check                | Обеспечивает наличие только положительных значений цены товара                                      |
| production.orders   | order_id int                    | Первичный ключ orders               | Обеспечивает уникальность записей о заказах                                                         |
| production.orders   | order_ts timestamp              | Ограничение NOT NULL                | Обеспечивает отсутствие NULL-значений в дате и времени заказа                                       |
| production.orders   | user_id int                     | Ограничение NOT NULL                | Обеспечивает отсутствие NULL-значений в идентификаторах пользователей                               |
| production.orders   | user_id int                     | Внешний ключ orders_user_id_fk      | Обеспечивает наличие только тех идентификаторов пользователей, которые присутствуют в таблице users |
| production.orders   | bonus_payment numeric(19,5)     | Ограничение NOT NULL                | Обеспечивает отсутствие NULL-значений в поле bonus_payment                                          |
| production.orders   | "cost" numeric(19,5)            | Ограничение NOT NULL                | Обеспечивает отсутствие NULL-значений в поле cost                                                   |
| production.orders   | bonus_grant numeric(19,5)       | Ограничение NOT NULL                | Обеспечивает отсутствие NULL-значений в поле bonus_grant                                            |
| production.orders   | "cost", bonus_grant, payment    | Ограничение orders_check типа CHECK | Стоимость заказа = payment + bonus_payment                                                          |
| production.orders   | status int                      | Ограничение NOT NULL                | Обеспечивает отсутствие NULL-значений в поле status                                                 |
