output "datasets" {
  value = {
    for a in google_bigquery_dataset.this : a => {
      id                 = a.id
      creation_time      = a.creation_time
      etag               = a.etag
      last_modified_time = a.last_modified_time
      terraform_labels   = a.terraform_labels
      effective_labels   = a.effective_labels
      self_link          = a.self_link
    }
  }
}

output "dataset_accesses" {
  value = {
    for a in google_bigquery_dataset_access.this : a => {
      id = a.id
    }
  }
}

output "dataset_iam_policies" {
  value = {
    for a in google_bigquery_dataset_iam_policy.this : a => {
      id   = a.id
      etag = a.etag
    }
  }
}

output "jobs" {
  value = {
    for a in google_bigquery_job.this : a => {
      id               = a.id
      user_email       = a.user_email
      job_type         = a.job_type
      terraform_labels = a.terraform_labels
      effective_labels = a.effective_labels
    }
  }
}

output "routines" {
  value = {
    for a in google_bigquery_routine.this : a => {
      id                 = a.id
      creation_time      = a.creation_time
      last_modified_time = a.last_modified_time
    }
  }
}

output "tables" {
  value = {
    for a in google_bigquery_table.this : a => {
      id                  = a.id
      creation_time       = a.creation_time
      etag                = a.etag
      last_modified_time  = a.last_modified_time
      location            = a.location
      num_bytes           = a.num_bytes
      num_long_term_bytes = a.num_long_term_bytes
      num_rows            = a.num_rows
      self_link           = a.self_link
      type                = a.type
    }
  }
}