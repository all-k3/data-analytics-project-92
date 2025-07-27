-- Этот запрос считает общее количество покупателей
select 
    count(customer_id) as customer_count
from 
    customers; 