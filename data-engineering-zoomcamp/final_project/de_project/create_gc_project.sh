#!/bin/bash

# Variables
PROJECT_NAME="dezc-final-test"
PROJECT_ID="dezc-final-test-$(date +%s)"  # Unique project ID based on timestamp
SERVICE_ACCOUNT_NAME="final-project-runner"
KEY_FILE_PATH="$HOME/de_project/keys/gc-final-key.json"
TERRAFORM_PROJECT_DIR="$HOME/de_project/terraform"
KESTRA_PROJECT_DIR="$HOME/de_project/kestra/flows"
GCS_BUCKET_NAME="final-project-bucket-$PROJECT_ID"

# Step 1: Create a new Google Cloud project
gcloud projects create $PROJECT_ID --name=$PROJECT_NAME

# Step 2: Set the newly created project as active
gcloud config set project $PROJECT_ID

# Step 3: Create a new service account
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
  --display-name="Final Project Runner"

# Step 4: Assign roles to the service account
ROLES=(
  "roles/bigquery.admin"
  "roles/compute.admin"
  "roles/dataproc.admin"
  "roles/storage.admin"
  "roles/storage.objectAdmin"
  "roles/iam.serviceAccountUser"
  "roles/dataproc.worker"
  "roles/editor"
  "roles/owner"
)

for ROLE in "${ROLES[@]}"; do
  gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="$ROLE"
done

# Step 5: Generate a key for the service account and save it as a JSON file
mkdir -p "$(dirname "$KEY_FILE_PATH")"
gcloud iam service-accounts keys create $KEY_FILE_PATH \
  --iam-account="$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"
echo "Service account key saved to: $KEY_FILE_PATH"

# Step 6: Generate a Terraform `variables.tf` dynamically based on the script variables
mkdir -p "$TERRAFORM_PROJECT_DIR"

cat <<EOF > "$TERRAFORM_PROJECT_DIR/variables.tf"
variable "credentials" {
  description = "Path to the Google Cloud credentials JSON file"
  type        = string
  default     = "/opt/workspace/keys/gc-final-key.json"
}

variable "zone" {
  description = "Zone where the resources will be deployed"
  type        = string
  default     = "europe-west1-b"
}

variable "region" {
  description = "Region for the resources"
  type        = string
  default     = "europe-west1"
}

variable "project" {
  description = "Google Cloud Project ID"
  type        = string
  default     = "$PROJECT_ID"
}

variable "location" {
  description = "Google Cloud Location"
  type        = string
  default     = "EU"
}

variable "bq_dataset_name" {
  description = "BigQuery dataset name"
  type        = string
  default     = "final_dataset"
}

variable "gcs_bucket_name" {
  description = "Google Cloud Storage bucket name"
  type        = string
  default     = "final-project-bucket"
}

variable "gcs_storage_class" {
  description = "Storage class for the GCS bucket"
  type        = string
  default     = "STANDARD"
}
EOF

echo "Terraform variables.tf file generated at: $TERRAFORM_PROJECT_DIR/variables.tf"

# Step 7: Create gcp_kv.yaml for Kestra
mkdir -p "$KESTRA_PROJECT_DIR"

cat <<EOF > "$KESTRA_PROJECT_DIR/gcp_kv.yaml"
id: gcp_kv
namespace: de_project

tasks:
  - id: gcp_creeds
    type: io.kestra.plugin.core.kv.Set
    key: GCP_CREDS
    kvType: JSON
    value: |
$(sed 's/^/      /' "$KEY_FILE_PATH")

  - id: gcp_project_id
    type: io.kestra.plugin.core.kv.Set
    key: GCP_PROJECT_ID
    kvType: STRING
    value: $PROJECT_ID

  - id: gcp_location
    type: io.kestra.plugin.core.kv.Set
    key: GCP_LOCATION
    kvType: STRING
    value: europe-west1

  - id: gcp_bucket_name
    type: io.kestra.plugin.core.kv.Set
    key: GCP_BUCKET_NAME
    kvType: STRING
    value: $GCS_BUCKET_NAME

  - id: gcp_dataset
    type: io.kestra.plugin.core.kv.Set
    key: GCP_DATASET
    kvType: STRING
    value: final_dataset
EOF

echo "Kestra KV file generated at: $KESTRA_PROJECT_DIR/gcp_kv.yaml"

# Step 8: Unset the project ID after the script runs
gcloud config unset project
