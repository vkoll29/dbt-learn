{{
    config(
    materialized='view'
    )
}}


with customers as (
    select * from {{ ref('stg_customers') }}
),

employees as (
    select * from {{ ref('stg_employees') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

customer_orders as (
    select
           c.cust_name Customer,
           p.prdct_name Product,
           p.price Price,
           sum(s.quantity) Qty,
           e.emp_name Employee

    from salesdb.dbo.Sales s
    left join customers c on c.customerid = s.customerid
    left join products p on p.productid = s.productid
    left join employees e on e.employeeid = s.salespersonid

    group by cust_name, prdct_name, price, emp_name
)

select * from customer_orders
--order by c.name