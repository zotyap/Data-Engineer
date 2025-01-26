variable "credentials" {
    description = "My Credentials"
    default = "/home/zotya/de_zoomcamp/keys/gc-cred.json"
}

variable "zone" {
    description = "Zone"
    default = "europe-west1-b"
}

variable "region" {
    description = "Region"
    default = "europe-west1"
}

variable "project" {
    description = "Project"
    default = "de-zoomcamp-448512"
}

variable "location" {
    description = "Project Location"
    default = "EU"
}

variable "bq_dataset_name" {
    description = "My BigQuery Dataset Name"
    default = "demo_dataset"
}

variable "gcs_bucket_name" {
    description = "My Storage Bucket Name"
    default = "de-zoomcamp-448512-terra-bucket"
}

variable "gcs_storage_class" {
    description = "Bucket Storage Class"
    default = "STANDARD"
}