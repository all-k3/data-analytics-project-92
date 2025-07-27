-- Этот запрос считает общее количество покупателей
select 
   count(customer_id) as customer_count
from  
    customers; 

-- Этот запрос вычисляет десятку лучшх продавцов по их суммарной выручке
select 
    concat(e.first_name,' ',e.last_name) as seller,
    count(s.sales_person_id) as operations,
    sum(p.price*s.quantity) as income
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
    trim(to_char(s.sale_date, 'Day')) as day_of_week,
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
    trim(to_char(s.sale_date, 'Day'))
order by
    case 
	    when extract(dow from s.sale_date) = 0 then 7 
	    else extract(dow from s.sale_date) 
    end;