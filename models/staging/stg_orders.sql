with source_data as (

    select
        id as order_id,
        user_id as customer_id,
        order_date,
        lower(trim(status)) as status

    from `deka-506304.staging.orders`

),

transformed as (

    select
        order_id,
        customer_id,
        order_date,
        status,

        extract(year from order_date) as order_year,
        extract(month from order_date) as order_month,

        case
            when status = 'completed' then 'Completed'
            when status = 'shipped' then 'Shipped'
            when status = 'pending' then 'Pending'
            when status = 'cancelled' then 'Cancelled'
            else 'Unknown'
        end as order_status,

        case
            when status in ('completed', 'shipped') then true
            else false
        end as is_successful

    from source_data

)

select *
from transformed