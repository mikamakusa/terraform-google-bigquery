## BIGQUERY ##

resource "google_bigquery_dataset" "this" {
  count                           = length(var.dataset)
  project                         = ""
  provider                        = google-beta
  dataset_id                      = ""
  default_collation               = ""
  default_partition_expiration_ms = 0
  default_table_expiration_ms     = 0
  delete_contents_on_destroy      = true
  description                     = ""
  friendly_name                   = ""
  id                              = ""
  is_case_insensitive             = true
  labels                          = {}
  max_time_travel_hours           = ""
  storage_billing_model           = ""

  dynamic "access" {
    for_each = ""
    content {
      domain         = ""
      group_by_email = ""
      role           = ""
      special_group  = ""
      iam_member     = ""
      user_by_email  = ""

      dynamic "dataset" {
        for_each = ""
        content {
          target_types = []

          dynamic "dataset" {
            for_each = ""
            content {
              dataset_id = ""
              project_id = ""
            }
          }
        }
      }

      dynamic "routine" {
        for_each = ""
        content {
          project_id = ""
          dataset_id = ""
          routine_id = ""
        }
      }

      dynamic "view" {
        for_each = ""
        content {
          table_id   = ""
          dataset_id = ""
          project_id = ""
        }
      }
    }
  }

  dynamic "external_dataset_reference" {
    for_each = ""
    content {
      external_source = ""
      connection      = ""
    }
  }

  dynamic "default_encryption_configuration" {
    for_each = ""
    content {
      kms_key_name = ""
    }
  }
}

resource "google_bigquery_dataset_access" "this" {
  count          = length(var.dataset) == 0 ? 0 : length(var.dataset_access)
  project        = ""
  provider       = google-beta
  dataset_id     = ""
  domain         = ""
  group_by_email = ""
  iam_member     = ""
  id             = ""
  role           = ""
  special_group  = ""
  user_by_email  = ""

  dynamic "dataset" {
    for_each = ""
    content {
      target_types = []
      dataset {
        dataset_id = ""
        project_id = ""
      }
    }
  }

  dynamic "view" {
    for_each = ""
    content {
      dataset_id = ""
      project_id = ""
      table_id   = ""
    }
  }
}

resource "google_bigquery_dataset_iam_member" "this" {
  count      = length(var.dataset) == 0 ? 0 : length(var.dataset_iam_member)
  project    = ""
  dataset_id = ""
  member     = ""
  role       = ""
}

resource "google_bigquery_job" "this2" {
  job_id = ""

  load {
    json_extension = ""
    source_uris    = []

    dynamic "destination_table" {
      for_each = ""
      content {
        table_id = ""
      }
    }

  }
}

resource "google_bigquery_job" "this" {
  count          = length(var.job)
  project        = ""
  provider       = ""
  job_id         = ""
  id             = ""
  job_timeout_ms = ""
  labels         = {}
  location       = ""

  dynamic "copy" {
    for_each = ""
    content {
      create_disposition = ""
      write_disposition = ""

      dynamic "source_tables" {
        for_each = ""
        content {
          table_id = ""
          project_id = ""
          dataset_id = ""
        }
      }

      dynamic "destination_encryption_configuration" {
        for_each = ""
        content {
          kms_key_name = ""
        }
      }

      dynamic "destination_table" {
        for_each = ""
        content {
          table_id = ""
          project_id = ""
          dataset_id = ""
        }
      }
    }
  }

  dynamic "extract" {
    for_each = ""
    content {
      destination_uris = []
      print_header = true
      field_delimiter = ""
      destination_format = ""
      compression = ""

      dynamic "source_model" {
        for_each = ""
        content {
          dataset_id = ""
          model_id   = ""
          project_id = ""
        }
      }

      dynamic "source_table" {
        for_each = ""
        content {
          table_id = ""
          project_id = ""
          dataset_id = ""
        }
      }
    }
  }

  dynamic "load" {
    for_each = ""
    content {
      source_uris           = []
      allow_jagged_rows     = true
      allow_quoted_newlines = true
      autodetect            = true
      create_disposition    = ""
      encoding              = ""
      field_delimiter       = ""
      ignore_unknown_values = true
      max_bad_records       = 0
      null_marker           = ""
      projection_fields     = []
      quote                 = ""
      schema_update_options = []
      skip_leading_rows     = 0
      source_format         = ""
      write_disposition     = ""

      dynamic "destination_encryption_configuration" {
        for_each = ""
        content {
          kms_key_name = ""
        }
      }

      dynamic "destination_table" {
        for_each = ""
        content {
          table_id   = ""
          project_id = ""
          dataset_id = ""
        }
      }

      dynamic "time_partitioning" {
        for_each = ""
        content {
          type          = ""
          expiration_ms = ""
          field         = ""
        }
      }

      dynamic "parquet_options" {
        for_each = ""
        content {
          enum_as_string        = true
          enable_list_inference = true
        }
      }
    }
  }

  dynamic "query" {
    for_each = ""
    content {
      query                 = ""
      create_disposition    = ""
      allow_large_results   = ""
      flatten_results       = true
      maximum_billing_tier  = 0
      maximum_bytes_billed  = ""
      parameter_mode        = ""
      priority              = ""
      schema_update_options = []
      use_legacy_sql        = true
      use_query_cache       = true
      write_disposition     = ""

      default_dataset {
        dataset_id = ""
        project_id = ""
      }

      destination_encryption_configuration {
        kms_key_name = ""
      }

      destination_table {
        table_id   = ""
        dataset_id = ""
        project_id = ""
      }

      script_options {
        statement_byte_budget = ""
        statement_timeout_ms  = ""
        key_result_statement  = ""
      }

      user_defined_function_resources {
        resource_uri = ""
        inline_code  = ""
      }
    }
  }
}

resource "google_bigquery_routine" "this" {
  count           = length(var.dataset) == 0 ? 0 : length(var.routine)
  dataset_id      = ""
  definition_body = ""
  routine_id      = ""
  routine_type    = ""
}

resource "google_bigquery_table" "this" {
  count      = length(var.dataset) == 0 ? 0 : length(var.table)
  dataset_id = ""
  table_id   = ""
}

resource "google_bigquery_table_iam_member" "this" {
  count      = (length(var.dataset) && length(var.table)) == 0 ? 0 : length(var.table_iam_member)
  dataset_id = ""
  member     = ""
  role       = ""
  table_id   = ""
}