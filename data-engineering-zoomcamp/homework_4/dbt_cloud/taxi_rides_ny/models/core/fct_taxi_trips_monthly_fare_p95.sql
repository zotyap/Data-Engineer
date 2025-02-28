{{
    config(
        materialized='table'
    )
}}

with green_fare_month as (
    select 
    FORMAT_TIMESTAMP('%Y', pickup_datetime) AS year,
    FORMAT_TIMESTAMP('%m', pickup_datetime) AS month,
    fare_amount,
    trip_distance,
    payment_type_description,
    'Green' as service_type
    from {{ ref('stg_green_tripdata') }} 
),
yellow_fare_month as (
    select 
    FORMAT_TIMESTAMP('%Y', pickup_datetime) AS year,
    FORMAT_TIMESTAMP('%m', pickup_datetime) AS month,
    fare_amount,
    trip_distance,
    payment_type_description,
    'Yellow' as service_type
    from {{ ref('stg_yellow_tripdata') }} 
),
union_fare_month as (
    SELECT * FROM green_fare_month
    union all
    SELECT * FROM yellow_fare_month
)

SELECT * FROM union_fare_month
WHERE fare_amount > 0
AND trip_distance > 0
AND lower(payment_type_description) in ('cash', 'credit card')