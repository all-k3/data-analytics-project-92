-- Этот запрос считает общее количество покупателей
select 
   count(customer_id) as customers_count
from  
    customers; 

-- Этот запрос вычисляет десятку лучшх продавцов по их суммарной выручке
select 
    concat(e.first_name,' ',e.last_name) as seller,
    count(s.sales_person_id) as operations,
    floor(sum(p.price*s.quantity)) as income
from 
    employees e
inner join 
    sales s on e.employee_id=s.sales_person_id
left join 
    products p on s.product_id=p.product_id
group by 1 order by income desc
limit 10; 

-- Этот запрос вычисляет информацию о продавцах, чья средняя выручка за сделку меньше средней выручки за сделку по всем продавцам.
with t1 as(
    select 
        concat(e.first_name,' ',e.last_name) as seller,
        floor(avg(p.price*s.quantity)) as average_income
    from 
        employees e
    inner join 
        sales s on e.employee_id=s.sales_person_id
    left join 
        products p on s.product_id=p.product_id
    group by 
        1)
select 
    seller,
    average_income
from
    t1
where 
    average_income < (select    
                            floor(avg(p.price*s.quantity)) 
                        from 
                            sales s 
                        inner join 
                            products p on s.product_id=p.product_id)
order by 
    average_income; 

-- Этот запрос вычисляет информацию о выручке по дням недели.
select 
    concat(e.first_name,' ',e.last_name) as seller,
    trim(to_char(s.sale_date, 'day')) as day_of_week,
    floor(sum(p.price*s.quantity)) as income
from 
    employees e
inner join 
    sales s on e.employee_id=s.sales_person_id
left join 
    products p on s.product_id=p.product_id
group by 
    seller,
    extract(dow from s.sale_date),
    trim(to_char(s.sale_date, 'day'))
order by
    case 
	    when extract(dow from s.sale_date) = 0 then 7 
	    else extract(dow from s.sale_date) 
    end, seller;


--этот запрос вычисляет количество покупателей в разных возрастных группах

select 
    '16-25' AS age_category,
    count(customer_id) as age_count
from 
    customers 
where age between 16 and 25

union all

select
    '26-40' AS age_category,
    count(customer_id) as age_count
from 
    customers 
where age between 26 and 40

union all  

select 
   '40+' AS age_category,
   count(customer_id) as age_count
from 
    customers 
where age > 40;

--этот запрос предоставляет данные по количеству уникальных покупателей и выручке, которую они принесли 

select 
    to_char(sale_date, 'YYYY-MM') as selling_month,
    COUNT(distinct customer_id) as total_customers,
    FLOOR(SUM(quantity*p.price)) as income
from sales s
left join 
    products p on s.product_id = p.product_id
group by 
    selling_month 
order by 
    selling_month;

--этот запрос предоставляет данные о покупателях, совершивших первую покупку в ходе проведения акций
      
select distinct on (s.customer_id)
    concat(c.first_name, ' ', c.last_name) as customer,
    s.sale_date,
    concat(e.first_name, ' ', e.last_name) as seller
from 
    sales s
join 
    customers c on s.customer_id = c.customer_id
join 
    employees e on s.sales_person_id = e.employee_id
join 
    products p on s.product_id = p.product_id
where 
    p.price = 0
order by 
    s.customer_id, s.sale_date;

