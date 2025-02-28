{{
    config(
        materialized='table'
    )
}}

with fhv_monthly_travel as (
    select 
    FORMAT_TIMESTAMP('%Y', pickup_datetime) AS year,
    FORMAT_TIMESTAMP('%m', pickup_datetime) AS month,
    TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND) AS trip_duration,
    pickup_zone,
    dropoff_zone,
    service_type
    from {{ ref('dim_fhv_trips') }} 
)

SELECT * FROM fhv_monthly_travel