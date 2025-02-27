{{
    config(
        materialized='table'
    )
}}

with green_quater_year as (
    select 
    FORMAT_TIMESTAMP('%Y', pickup_datetime) AS year,
    FORMAT_TIMESTAMP('%m', pickup_datetime) AS month,
    CAST(EXTRACT(QUARTER FROM pickup_datetime) AS STRING) AS quarter,
    FORMAT_TIMESTAMP('%Y', pickup_datetime) || '-Q' || CAST(EXTRACT(QUARTER FROM pickup_datetime) AS STRING) AS year_quarter,
    total_amount,
    'Green' as service_type
    from {{ ref('stg_green_tripdata') }} 
),
yellow_quater_year as (
    select 
    FORMAT_TIMESTAMP('%Y', pickup_datetime) AS year,
    FORMAT_TIMESTAMP('%m', pickup_datetime) AS month,
    CAST(EXTRACT(QUARTER FROM pickup_datetime) AS STRING) AS quarter,
    FORMAT_TIMESTAMP('%Y', pickup_datetime) || '-Q' || CAST(EXTRACT(QUARTER FROM pickup_datetime) AS STRING) AS year_quarter,
    total_amount,
    'Yellow' as service_type
    from {{ ref('stg_green_tripdata') }} 
),
union_quater_year as (
    SELECT * FROM green_quater_year
    union all
    SELECT * FROM yellow_quater_year
)

SELECT * FROM union_quater_year