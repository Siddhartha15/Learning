terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  # credentials = file("/home/siddhartham/Downloads/total-casing-318218-778feb7d96ff.json ")

  project = "thunderstorm-development"
  region  = "us-central1"
  zone    = "us-central1-c"
}


resource "google_storage_notification" "notification" {
  bucket         = google_storage_bucket.bucket.name
  payload_format = "JSON_API_V1"
  topic          = google_pubsub_topic.topic.id
  event_types    = ["OBJECT_FINALIZE", "OBJECT_METADATA_UPDATE"]
  custom_attributes = {
    new-attribute = "new-attribute-value"
  }
  depends_on = [google_pubsub_topic_iam_binding.binding]
}

// Enable notifications by giving the correct IAM permission to the unique service account.

data "google_storage_project_service_account" "gcs_account" {
}

resource "google_pubsub_topic_iam_binding" "binding" {
  topic   = google_pubsub_topic.topic.id
  role    = "roles/pubsub.publisher"
  members = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}

// End enabling notifications

resource "google_storage_bucket" "bucket" {
  name = "default_bucket_dbi"
}

resource "google_pubsub_topic" "topic" {
  name = "default_topic_dbi"
}

resource "google_pubsub_subscription" "subscription" {
  name  = "default_subscription_dbi"
  topic = google_pubsub_topic.topic.name

  labels = {
    foo = "bar"
  }

  # 20 minutes
  message_retention_duration = "1200s"
  retain_acked_messages      = true

  ack_deadline_seconds = 20

  # expiration_policy {
  #   ttl = "300000.5s"
  # }
  # retry_policy {
  #   minimum_backoff = "10s"
  # }

  # enable_message_ordering    = false
}