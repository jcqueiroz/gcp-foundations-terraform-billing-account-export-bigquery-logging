provider "google" {
  project = "jcqueiroz-devops-iac"
  region  = "us-central1"
  zone    = "us-central1-c"
  credentials = "${file("serviceaccount.yaml")}"
}

resource "google_logging_billing_account_sink" "my-sink-jcqueiroz-labs" {
  name            = "my-sink-jcqueiroz-labs"
  description = "some explanation on what this is"
  billing_account = "011679-77322D-6BBCBE"

  # Can export to pubsub, cloud storage, or bigquery
    destination = "bigquery.googleapis.com/projects/jcqueiroz-sales-mobile-dev/datasets/jcqueiroz_sales_mobile_dev_data_billing"
}

resource "google_storage_bucket" "jcqueiroz-labs-bucket" {
  name     = "jcqueiroz-labs-bucket"
  location = "US"
}

resource "google_project_iam_binding" "log-writer" {
  project = "jcqueiroz-sales-mobile-dev"
  role = "roles/storage.objectCreator"

  members = [
    google_logging_billing_account_sink.my-sink-jcqueiroz-labs.writer_identity,
  ]
}