-- Этот запрос считает общее количество покупателей

SELECT COUNT(customer_id) AS customers_count
FROM customers;

-- Этот запрос вычисляет десятку лучшх продавцов по их суммарной выручке

SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS seller,
    COUNT(s.sales_person_id) AS operations,
    FLOOR(SUM(p.price * s.quantity)) AS income
FROM
    employees AS e
INNER JOIN
    sales AS s ON e.employee_id = s.sales_person_id
LEFT JOIN
    products AS p ON s.product_id = p.product_id
GROUP BY
    e.employee_id, seller
ORDER BY
    income DESC
LIMIT 10;

-- Этот запрос вычисляет информацию о продавцах,
--чья средняя выручка за сделку
--меньше средней выручки за сделку по всем продавцам.

WITH t1 AS (
    SELECT
        CONCAT(e.first_name, ' ', e.last_name) AS seller,
        FLOOR(AVG(p.price * s.quantity)) AS average_income
    FROM
        employees AS e
    INNER JOIN
        sales AS s ON e.employee_id = s.sales_person_id
    LEFT JOIN
        products AS p ON s.product_id = p.product_id
    GROUP BY
        seller
)

SELECT
    seller,
    average_income
FROM
    t1
WHERE
    average_income < (
        SELECT FLOOR(AVG(p.price * s.quantity))
        FROM sales AS s
        INNER JOIN products AS p ON s.product_id = p.product_id
    )
ORDER BY
    average_income;

-- Этот запрос вычисляет информацию о выручке по дням недели.

SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS seller,
    TRIM(TO_CHAR(s.sale_date, 'day')) AS day_of_week,
    FLOOR(SUM(p.price * s.quantity)) AS income
FROM
    employees AS e
INNER JOIN
    sales AS s ON e.employee_id = s.sales_person_id
LEFT JOIN
    products AS p ON s.product_id = p.product_id
GROUP BY
    seller,
    EXTRACT(DOW FROM s.sale_date),
    TRIM(TO_CHAR(s.sale_date, 'day'))
ORDER BY
    CASE
        WHEN EXTRACT(DOW FROM s.sale_date) = 0 THEN 7
        ELSE EXTRACT(DOW FROM s.sale_date)
    END,
    seller;

--этот запрос вычисляет количество покупателей в разных возрастных группах

SELECT
    '16-25' AS age_category,
    COUNT(customer_id) AS age_count
FROM
    customers
WHERE
    age BETWEEN 16 AND 25

UNION ALL

SELECT
    '26-40' AS age_category,
    COUNT(customer_id) AS age_count
FROM
    customers
WHERE
    age BETWEEN 26 AND 40

UNION ALL
SELECT
    '40+' AS age_category,
    COUNT(customer_id) AS age_count
FROM
    customers
WHERE
    age > 40

ORDER BY
    age_category;

--этот запрос предоставляет данные по количеству уникальных покупателей
--и выручке, которую они принесли 

SELECT
    TO_CHAR(s.sale_date, 'YYYY-MM') AS selling_month,
    COUNT(DISTINCT s.customer_id) AS total_customers,
    FLOOR(SUM(s.quantity * p.price)) AS income
FROM
    sales AS s
LEFT JOIN
    products AS p ON s.product_id = p.product_id
GROUP BY
    TO_CHAR(s.sale_date, 'YYYY-MM')
ORDER BY
    selling_month;

--этот запрос предоставляет данные о покупателях,
--совершивших первую покупку в ходе проведения акций

SELECT DISTINCT ON (s.customer_id)
    s.sale_date,
    CONCAT(c.first_name, ' ', c.last_name) AS customer,
    CONCAT(e.first_name, ' ', e.last_name) AS seller
FROM
    sales AS s
INNER JOIN 
    public.customers AS c ON s.customer_id = c.customer_id
INNER JOIN 
    public.employees AS e ON s.sales_person_id = e.employee_id
INNER JOIN 
    public.products AS p ON s.product_id = p.product_id
WHERE
    p.price = 0
ORDER BY
    s.customer_id, s.sale_date;
