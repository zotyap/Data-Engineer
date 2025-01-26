terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.17.0"
    }
  }
}

provider "google" {
# Credential used:
# export $GOOGLE_CREDENTIALS
  project     = "de-zoomcamp-448512"
  region      = "europe-west1"
  zone        = "europe-west1-b"
}



resource "google_storage_bucket" "data-lake-bucket" {
  name          = "homework-terra-bucket"
  location      = "EU"

  # Optional, but recommended settings:
  storage_class = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled     = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30  // days
    }
  }

  force_destroy = true
}


resource "google_bigquery_dataset" "dataset" {
  dataset_id = "<homework_dataset>"
  project    = "de-zoomcamp-448512"
  location   = "EU"
}