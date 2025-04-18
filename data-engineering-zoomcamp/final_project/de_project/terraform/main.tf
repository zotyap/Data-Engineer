terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.17.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials)
  project = var.project
  region  = var.region
  zone    = var.zone
}


resource "google_storage_bucket" "data-lake-bucket" {
  name = join("-", [tostring(var.gcs_bucket_name), tostring(var.project)])
  location      = var.location
}


resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = var.bq_dataset_name
  project                     = var.project
  location                    = var.location
  region                      = var.region
}
