## DATASET ##

output "dataset_id" {
  value = try(
    google_bigquery_dataset.this.*.dataset_id
  )
}

output "dataset_labels" {
  value = try(
    google_bigquery_dataset.this.*.labels
  )
}

output "dataset_project" {
  value = try(
    google_bigquery_dataset.this.*.project
  )
}

## DATASET_ACCESS ##

output "dataset_access_dataset_id" {
  value = try(
    google_bigquery_dataset_access.this.*.dataset_id
  )
}

## JOB ##

output "job_id" {
  value = try(
    google_bigquery_job.this.*.job_id
  )
}

output "job_status" {
  value = try(
    google_bigquery_job.this.*.status
  )
}

## ROUTINE ##

output "routine_id" {
  value = try(
    google_bigquery_routine.this.*.routine_id
  )
}

output "routine_dataset_id" {
  value = try(
    google_bigquery_routine.this.*.dataset_id
  )
}

output "routine_project" {
  value = try(
    google_bigquery_routine.this.*.project
  )
}

## TABLE ##

output "table_project" {
  value = try(
    google_bigquery_table.this.*.project
  )
}

output "table_dataset_id" {
  value = try(
    google_bigquery_table.this.*.dataset_id
  )
}

output "table_id" {
  value = try(
    google_bigquery_table.this.*.table_id
  )
}

## CONNECTION ##

output "connection_id" {
  value = try(
    google_bigquery_connection.this.*.connection_id
  )
}

## DATA_POLICY ##

output "data_policy_id" {
  value = try(
    google_bigquery_datapolicy_data_policy.this.*.data_policy_id
  )
}

## DATA TRANSFER ##

output "data_transfer_id" {
  value = try(
    google_bigquery_data_transfer_config.this.*.id
  )
}