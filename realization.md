# Витрина RFM

## 1.1. Выясните требования к целевой витрине.

**Что сделать**: 

 1. Построить витрину данных для RFM-классификации пользователей приложения на основе успешно выполненных заказов. 
 
 2. Витрину нужно назвать **dm_rfm_segments**. 
 
 3. Сохранить в схему analysis хранилища данных. 
 
 4. Успешный заказ - заказ со статусом Closed.

**Зачем**: подготовить данные для компании-разработчика приложения по доставке еды.

**За какой период**: 2022 год.

**Обновление данных**: не требуется.

**Кому доступна**: всем, но доступ только на чтение.

**Необходимая структура**:

    1. user_id - идентификатор пользователя.
    2. recency - фактор давности, количество прошедшего времени с момента последнего успешного заказа.
                 Число от 1 до 5, где 1 - заказов вообще не было или были очень давно, а 5 - заказы были относительно недавно.

    3. frequency - фактор частоты, количество успешных заказов.
                   Число от 1 до 5, где 1 - наименьшее количество заказов, 5 - наибольшее.

    4. monetary_value - фактор денежной ценности, сумма затрат клиента на успешные заказы.
                        Число от 1 до 5, где 1 - наименьшая сумма, 5 - наибольшая.


## 1.2. Изучите структуру исходных данных.
Результаты представлены в файле [requirements.md](requirements.md)

## 1.3. Проанализируйте качество данных

Результаты представлены в файле [data_quality.md](data_quality.md)


## 1.4. Подготовьте витрину данных

### 1.4.1. Сделайте VIEW для таблиц из схемы production.

Результаты представлены в файле [sql/views.sql](sql/views.sql)

### 1.4.2. Напишите DDL-запрос для создания витрины.

Результаты представлены в файле [sql/datamart_ddl.sql](sql/datamart_ddl.sql)

### 1.4.3. Напишите SQL запрос для заполнения витрины

Результаты представлены в файлах:

  - [sql/tmp_rfm_recency.sql](sql/tmp_rfm_recency.sql)
  - [sql/tmp_rfm_frequency.sql](sql/tmp_rfm_frequency.sql)
  - [sql/tmp_rfm_monetary_value.sql](sql/tmp_rfm_monetary_value.sql)
  - [sql/datamart_query.sql](sql/datamart_query.sql)


## 2. Доработка представлений

Результаты представлены в файле [sql/orders_view.sql](sql/orders_view.sql)

## 3. Итоговый проект
Итоговый проект представлен в репозитории [de-project-sprint-1](https://github.com/ppetrov91/de-project-sprint-1)