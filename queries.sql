-- Этот запрос считает общее количество покупателей
SELECT 
    COUNT(customerId) AS customers_count
FROM Customer c;