Assignment:
Used gc_taxi_scheduled.yaml - Trigger - Backfill executions to upload yellow and green taxi data between 2021-01-01 and 2021-07-31 to Google Cloud Bucket and to BigQuery

#1
128.3 MB

GCP - Buckets - yellow_tripdata_2020-12.csv - Overview - Size

#2
green_tripdata_2020-04.csv

#3
24,648,499

SELECT COUNT(*) FROM `de-zoomcamp-448512.de_zoomcamp.yellow_tripdata`
WHERE filename LIKE 'yellow_tripdata_2020%';

#4
1,734,051

SELECT COUNT(*) FROM `de-zoomcamp-448512.de_zoomcamp.green_tripdata`
WHERE filename LIKE 'green_tripdata_2020%';


#5
1,925,152

SELECT COUNT(*) FROM `de-zoomcamp-448512.de_zoomcamp.yellow_tripdata_2021_03`;

#6
Add a timezone property set to America/New_York in the Schedule trigger configuration

triggers:
  - id: green_schedule
    type: io.kestra.plugin.core.trigger.Schedule
    cron: "0 9 1 * *"
    timezone: "America/New_York"
    inputs:
      taxi: green

  - id: yellow_schedule
    type: io.kestra.plugin.core.trigger.Schedule
    cron: "0 10 1 * *"
    timezone: "America/New_York"
    inputs:
      taxi: yellow
