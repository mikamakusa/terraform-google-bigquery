## BIGQUERY ##

resource "google_bigquery_dataset" "this" {
  count                           = length(var.dataset)
  project                         = data.google_project.this.id
  provider                        = google-beta
  dataset_id                      = lookup(var.dataset[count.index], "dataset_id")
  default_collation               = lookup(var.dataset[count.index], "default_collation")
  default_partition_expiration_ms = lookup(var.dataset[count.index], "default_partition_expiration_ms")
  default_table_expiration_ms     = lookup(var.dataset[count.index], "default_table_expiration_ms")
  delete_contents_on_destroy      = lookup(var.dataset[count.index], "delete_contents_on_destroy")
  description                     = lookup(var.dataset[count.index], "description")
  friendly_name                   = lookup(var.dataset[count.index], "friendly_name")
  is_case_insensitive             = lookup(var.dataset[count.index], "is_case_insensitive")
  labels                          = merge(var.labels, lookup(var.dataset[count.index], "labels"))
  max_time_travel_hours           = lookup(var.dataset[count.index], "max_time_travel_hours")
  storage_billing_model           = lookup(var.dataset[count.index], "storage_billing_model")

  dynamic "access" {
    for_each = lookup(var.dataset[count.index], "access") == null ? [] : ["access"]
    content {
      domain         = lookup(access.value, "domain")
      group_by_email = lookup(access.value, "group_by_email")
      role           = lookup(access.value, "role")
      special_group  = lookup(access.value, "special_group")
      iam_member     = lookup(access.value, "iam_member")
      user_by_email  = lookup(access.value, "user_by_email")

      dynamic "dataset" {
        for_each = lookup(access.value, "dataset") == null ? [] : ["dataset"]
        content {
          target_types = lookup(dataset.value, "target_types")

          dynamic "dataset" {
            for_each = lookup(access.value, "dataset") == null ? [] : ["datasset"]
            content {
              dataset_id = try(element(google_bigquery_dataset.this.*.dataset_id, lookup(dataset.value, "dataset_id")))
              project_id = try(element(google_bigquery_dataset.this.*.project, lookup(dataset.value, "dataset_id")))
            }
          }
        }
      }

      dynamic "routine" {
        for_each = lookup(access.value, "routine") == null ? [] : ["routine"]
        content {
          project_id = try(element(google_bigquery_routine.this.*.project, lookup(routine.value, "routine_id")))
          dataset_id = try(element(google_bigquery_routine.this.*.dataset_id, lookup(routine.value, "routine_id")))
          routine_id = try(element(google_bigquery_routine.this.*.routine_id, lookup(routine.value, "routine_id")))
        }
      }

      dynamic "view" {
        for_each = lookup(access.value, "view") == null ? [] : ["view"]
        content {
          table_id   = try(element(google_bigquery_table.this.*.table_id, lookup(view.value, "table_id")))
          dataset_id = try(element(google_bigquery_table.this.*.dataset_id, lookup(view.value, "table_id")))
          project_id = try(element(google_bigquery_table.this.*.project, lookup(view.value, "table_id")))
        }
      }
    }
  }

  dynamic "external_dataset_reference" {
    for_each = lookup(var.dataset[count.index], "external_dataset_reference") == null ? [] : ["external_dataset_reference"]
    iterator = external
    content {
      external_source = lookup(external.value, "external_source")
      connection      = lookup(external.value, "connection")
    }
  }

  dynamic "default_encryption_configuration" {
    for_each = lookup(var.dataset[count.index], "kms_key_id") == null ? [] : ["default_encryption_configuration"]
    content {
      kms_key_name = try(element(var.dataset_kms_key_name, lookup(var.dataset[count.index], "kms_key_id")))
    }
  }
}

resource "google_bigquery_dataset_access" "this" {
  count          = length(var.dataset) == 0 ? 0 : length(var.dataset_access)
  project        = data.google_project.this.id
  provider       = google-beta
  dataset_id     = try(element(google_bigquery_dataset.this.*.id, lookup(var.dataset_access[count.index], "dataset_id")))
  domain         = lookup(var.dataset_access[count.index], "domain")
  group_by_email = lookup(var.dataset_access[count.index], "group_by_email")
  iam_member     = lookup(var.dataset_access[count.index], "iam_member")
  role           = lookup(var.dataset_access[count.index], "role")
  special_group  = lookup(var.dataset_access[count.index], "special_group")
  user_by_email  = lookup(var.dataset_access[count.index], "user_by_email")

  dynamic "dataset" {
    for_each = lookup(var.dataset_access[count.index], "dataset") == null ? [] : ["dataset"]
    content {
      target_types = lookup(dataset.value, "target_types")

      dataset {
        dataset_id = try(element(google_bigquery_dataset.this.*.dataset_id, lookup(dataset.value, "dataset_id")))
        project_id = try(element(google_bigquery_dataset.this.*.project, lookup(dataset.value, "dataset_id")))
      }
    }
  }

  dynamic "view" {
    for_each = lookup(var.dataset_access[count.index], "view") == null ? [] : ["view"]
    content {
      dataset_id = try(element(google_bigquery_dataset.this.*.dataset_id, lookup(view.value, "table_id")))
      project_id = try(element(google_bigquery_table.this.*.project, lookup(view.value, "table_id")))
      table_id   = try(element(google_bigquery_table.this.*.table_id, lookup(view.value, "table_id")))
    }
  }
}

resource "google_bigquery_dataset_iam_member" "this" {
  count      = length(var.dataset) == 0 ? 0 : length(var.dataset_iam_member)
  project    = data.google_project.this.id
  dataset_id = try(element(google_bigquery_dataset.this.*.id, lookup(var.dataset_iam_member[count.index], "dataset_id")))
  member     = lookup(var.dataset_iam_member[count.index], "member")
  role       = lookup(var.dataset_iam_member[count.index], "role")

  dynamic "condition" {
    for_each = lookup(var.dataset_iam_member[count.index], "condition") == null ? [] : ["condition"]
    content {
      expression  = lookup(condition.value, "expression")
      title       = lookup(condition.value, "title")
      description = lookup(condition.value, "description")
    }
  }
}

resource "google_bigquery_job" "this" {
  count          = length(var.job)
  project        = data.google_project.this.id
  provider       = google-beta
  job_id         = lookup(var.job[count.index], "job_id")
  job_timeout_ms = lookup(var.job[count.index], "job_timeout_ms")
  labels         = merge(var.labels, lookup(var.job[count.index], "labels"))
  location       = lookup(var.job[count.index], "location")

  dynamic "copy" {
    for_each = lookup(var.job[count.index], "copy") == null ? [] : ["copy"]
    content {
      create_disposition = lookup(copy.value, "create_disposition")
      write_disposition  = lookup(copy.value, "write_disposition")

      dynamic "source_tables" {
        for_each = ""
        content {
          table_id   = ""
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
          table_id   = ""
          project_id = ""
          dataset_id = ""
        }
      }
    }
  }

  dynamic "extract" {
    for_each = lookup(var.job[count.index], "extract") == null ? [] : ["extract"]
    content {
      destination_uris   = []
      print_header       = true
      field_delimiter    = ""
      destination_format = ""
      compression        = ""

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
          table_id   = ""
          project_id = ""
          dataset_id = ""
        }
      }
    }
  }

  dynamic "load" {
    for_each = lookup(var.job[count.index], "load") == null ? [] : ["load"]
    content {
      source_uris           = lookup(load.value, "source_uris")
      allow_jagged_rows     = lookup(load.value, "allow_jagged_rows")
      allow_quoted_newlines = lookup(load.value, "allow_quoted_newlines")
      autodetect            = lookup(load.value, "autodetect")
      create_disposition    = lookup(load.value, "create_disposition")
      encoding              = lookup(load.value, "encoding")
      field_delimiter       = lookup(load.value, "field_delimiter")
      ignore_unknown_values = lookup(load.value, "ignore_unknown_values")
      max_bad_records       = lookup(load.value, "max_bad_records")
      null_marker           = lookup(load.value, "null_marker")
      projection_fields     = lookup(load.value, "projection_fields")
      quote                 = lookup(load.value, "quote")
      schema_update_options = lookup(load.value, "schema_update_options")
      skip_leading_rows     = lookup(load.value, "skip_leading_rows")
      source_format         = lookup(load.value, "source_format")
      write_disposition     = lookup(load.value, "write_disposition")

      dynamic "destination_encryption_configuration" {
        for_each = lookup(load.value, "kms_key_id") == null ? [] : ["destination_encryption_configuration"]
        content {
          kms_key_name = try(element(var.job_load_kms_key_name, lookup(load.value, "kms_key_id")))
        }
      }

      dynamic "destination_table" {
        for_each = lookup(load.value, "destination_table") == null ? [] : ["destination_table"]
        content {
          table_id   = try(element(google_bigquery_table.this.*.table_id, lookup(destination_table.value, "table_id")))
          project_id = try(element(google_bigquery_table.this.*.project, lookup(destination_table.value, "table_id")))
          dataset_id = try(element(google_bigquery_table.this.*.dataset_id, lookup(destination_table.value, "table_id")))
        }
      }

      dynamic "time_partitioning" {
        for_each = lookup(load.value, "time_partitioning") == null ? [] : ["time_partitioning"]
        content {
          type          = lookup(time_partitioning.value, "type")
          expiration_ms = lookup(time_partitioning.value, "expiration_ms")
          field         = lookup(time_partitioning.value, "field")
        }
      }

      dynamic "parquet_options" {
        for_each = lookup(load.value, "parquet_options") == null ? [] : ["parquet_options"]
        content {
          enum_as_string        = lookup(parquet_options.value, "enum_as_string")
          enable_list_inference = lookup(parquet_options.value, "enable_list_inference")
        }
      }
    }
  }

  dynamic "query" {
    for_each = lookup(var.job[count.index], "query") == null ? [] : ["query"]
    content {
      query                 = lookup(query.value, "query")
      create_disposition    = lookup(query.value, "create_disposition")
      allow_large_results   = lookup(query.value, "allow_large_results")
      flatten_results       = lookup(query.value, "flatten_results")
      maximum_billing_tier  = lookup(query.value, "maximum_billing_tier")
      maximum_bytes_billed  = lookup(query.value, "maximum_bytes_billed")
      parameter_mode        = lookup(query.value, "parameter_mode")
      priority              = lookup(query.value, "priority")
      schema_update_options = lookup(query.value, "schema_update_options")
      use_legacy_sql        = lookup(query.value, "use_legacy_sql")
      use_query_cache       = lookup(query.value, "use_query_cache")
      write_disposition     = lookup(query.value, "write_disposition")

      dynamic "default_dataset" {
        for_each = lookup(query.value, "default_dataset") == null ? [] : ["default_dataset"]
        content {
          dataset_id = try(element(google_bigquery_dataset.this.*.dataset_id, lookup(default_dataset.value, "dataset_id")))
          project_id = try(element(google_bigquery_dataset.this.*.project, lookup(default_dataset.value, "dataset_id")))
        }
      }

      dynamic "destination_encryption_configuration" {
        for_each = lookup(query.value, "kms_key_id") == null ? [] : ["destination_encryption_configuration"]
        content {
          kms_key_name = try(element(var.job_query_kms_key_name, lookup(query.value, "kms_key_id")))
        }
      }

      dynamic "destination_table" {
        for_each = lookup(query.value, "destination_table") == null ? [] : ["destination_table"]
        content {
          table_id   = try(element(google_bigquery_table.this.*.table_id, lookup(destination_table.value, "table_id")))
          dataset_id = try(element(google_bigquery_table.this.*.dataset_id, lookup(destination_table.value, "table_id")))
          project_id = try(element(google_bigquery_table.this.*.project, lookup(destination_table.value, "table_id")))
        }
      }

      dynamic "script_options" {
        for_each = lookup(query.value, "script_options") == null ? [] : ["script_options"]
        content {
          statement_byte_budget = lookup(script_options.value, "statement_byte_budget")
          statement_timeout_ms  = lookup(script_options.value, "statement_timeout_ms")
          key_result_statement  = lookup(script_options.value, "key_result_statement")
        }
      }

      dynamic "user_defined_function_resources" {
        for_each = lookup(query.value, "user_defined_function_resources ") == null ? [] : ["user_defined_function_resources "]
        content {
          resource_uri = lookup(user_defined_function_resources.value, "resource_uri")
          inline_code  = lookup(user_defined_function_resources.value, "inline_code")
        }
      }
    }
  }
}

resource "google_bigquery_routine" "this" {
  count                = length(var.dataset) == 0 ? 0 : length(var.routine)
  dataset_id           = try(element(google_bigquery_dataset.this.*.dataset_id, lookup(var.routine[count.index], "dataset_id")))
  definition_body      = lookup(var.routine[count.index], "definition_body")
  routine_id           = lookup(var.routine[count.index], "routine_id")
  routine_type         = lookup(var.routine[count.index], "routine_type")
  language             = lookup(var.routine[count.index], "language")
  return_type          = lookup(var.routine[count.index], "return_type")
  return_table_type    = jsonencode(lookup(var.routine[count.index], "return_table_type"))
  imported_libraries   = lookup(var.routine[count.index], "imported_libraries")
  description          = lookup(var.routine[count.index], "description")
  determinism_level    = lookup(var.routine[count.index], "determinism_level")
  data_governance_type = "DATA_MASKING"

  dynamic "arguments" {
    for_each = lookup(var.routine[count.index], "arguments") == null ? [] : ["arguments"]
    content {
      name          = lookup(arguments.value, "name")
      argument_kind = lookup(arguments.value, "argument_kind")
      mode          = lookup(arguments.value, "mode")
      data_type     = jsonencode(lookup(arguments.value, "data_type"))
    }
  }

  dynamic "remote_function_options" {
    for_each = lookup(var.routine[count.index], "remote_function_options") == null ? [] : ["remote_function_options"]
    content {
      endpoint             = lookup(remote_function_options.value, "endpoint")
      connection           = lookup(remote_function_options.value, "connection")
      user_defined_context = lookup(remote_function_options.value, "user_defined_context")
      max_batching_rows    = lookup(remote_function_options.value, "max_batching_rows")
    }
  }

  dynamic "spark_options" {
    for_each = lookup(var.routine[count.index], "spark_options") == null ? [] : ["spark_options"]
    content {
      connection      = lookup(spark_options.value, "connection")
      container_image = lookup(spark_options.value, "container_image")
      runtime_version = lookup(spark_options.value, "runtime_version")
      properties      = lookup(spark_options.value, "properties")
      main_file_uri   = lookup(spark_options.value, "main_file_uri")
      main_class      = lookup(spark_options.value, "main_class")
      py_file_uris    = lookup(spark_options.value, "py_file_uris")
      jar_uris        = lookup(spark_options.value, "jar_uris")
      file_uris       = lookup(spark_options.value, "file_uris")
      archive_uris    = lookup(spark_options.value, "archive_uris")
    }
  }
}

resource "google_bigquery_table" "this" {
  count                    = length(var.dataset) == 0 ? 0 : length(var.table)
  dataset_id               = try(element(google_bigquery_dataset.this.*.dataset_id, lookup(var.table[count.index], "dataset_id")))
  table_id                 = lookup(var.dataset[count.index], "table_id")
  description              = lookup(var.dataset[count.index], "description")
  deletion_protection      = lookup(var.dataset[count.index], "deletion_protection")
  expiration_time          = lookup(var.dataset[count.index], "expiration_time")
  friendly_name            = lookup(var.dataset[count.index], "friendly_name")
  labels                   = merge(var.labels, lookup(var.table[count.index], "labels"))
  max_staleness            = lookup(var.dataset[count.index], "max_staleness")
  require_partition_filter = lookup(var.dataset[count.index], "require_partition_filter")
  schema                   = lookup(var.dataset[count.index], "schema")

  dynamic "encryption_configuration" {
    for_each = lookup(var.table[count.index], "kms_key_id") == null ? [] : ["encryption_configuration"]
    content {
      kms_key_name = try(element(var.table_kms_key_name, lookup(var.table[count.index], "kms_key_id")))
    }
  }

  dynamic "external_data_configuration" {
    for_each = lookup(var.table[count.index], "external_data_configuration") == null ? [] : ["external_data_configuration"]
    iterator = external
    content {
      autodetect                = lookup(external.value, "autodetect")
      source_uris               = lookup(external.value, "source_uris")
      compression               = lookup(external.value, "compression")
      connection_id             = lookup(external.value, "connection_id")
      ignore_unknown_values     = lookup(external.value, "ignore_unknown_values")
      max_bad_records           = lookup(external.value, "max_bad_records")
      schema                    = lookup(external.value, "schema")
      source_format             = lookup(external.value, "source_format")
      file_set_spec_type        = lookup(external.value, "file_set_spec_type")
      reference_file_schema_uri = lookup(external.value, "reference_file_schema_uri")
      metadata_cache_mode       = lookup(external.value, "metadata_cache_mode")
      object_metadata           = lookup(external.value, "object_metadata")

      dynamic "avro_options" {
        for_each = lookup(external.value, "use_avro_logical_types") == null ? [] : ["avro_options"]
        content {
          use_avro_logical_types = lookup(external.value, "use_avro_logical_types")
        }
      }

      dynamic "bigtable_options" {
        for_each = lookup(external.value, "bigtable_options") == null ? [] : ["bigtable_options"]
        content {
          ignore_unspecified_column_families = lookup(bigtable_options.value, "ignore_unspecified_column_families")
          read_rowkey_as_string              = lookup(bigtable_options.value, "read_rowkey_as_string")
          output_column_families_as_json     = lookup(bigtable_options.value, "output_column_families_as_json")

          dynamic "column_family" {
            for_each = lookup(bigtable_options.value, "column_family") == null ? [] : ["column_family"]
            content {
              family_id        = lookup(column_family.value, "family_id")
              type             = lookup(column_family.value, "type")
              encoding         = lookup(column_family.value, "encoding")
              only_read_latest = lookup(column_family.value, "only_read_latest")

              dynamic "column" {
                for_each = lookup(column_family.value, "column") == null ? [] : ["column"]
                content {
                  qualifier_encoded = lookup(column.value, "qualifier_encoded")
                  qualifier_string  = lookup(column.value, "qualifier_string")
                  type              = lookup(column.value, "type")
                  encoding          = lookup(column.value, "encoding")
                  only_read_latest  = lookup(column.value, "only_read_latest")
                }
              }
            }
          }
        }
      }

      dynamic "csv_options" {
        for_each = lookup(external.value, "csv_options") == null ? [] : ["csv_options"]
        content {
          quote                 = lookup(csv_options.value, "quote")
          allow_jagged_rows     = lookup(csv_options.value, "allow_jagged_rows")
          allow_quoted_newlines = lookup(csv_options.value, "allow_quoted_newlines")
          skip_leading_rows     = lookup(csv_options.value, "skip_leading_rows")
          encoding              = lookup(csv_options.value, "encoding")
          field_delimiter       = lookup(csv_options.value, "field_delimiter")
        }
      }

      dynamic "google_sheets_options" {
        for_each = lookup(external.value, "google_sheets_options") == null ? [] : ["google_sheets_options"]
        iterator = google
        content {
          range             = lookup(google.value, "range")
          skip_leading_rows = lookup(google.value, "skip_leading_rows")
        }
      }

      dynamic "hive_partitioning_options" {
        for_each = lookup(external.value, "hive_partitioning_options") == null ? [] : ["hive_partitioning_options"]
        iterator = hive
        content {
          mode                     = lookup(hive.value, "mode")
          require_partition_filter = lookup(hive.value, "require_partition_filter")
          source_uri_prefix        = lookup(hive.value, "source_uri_prefix")
        }
      }

      dynamic "json_options" {
        for_each = lookup(external.value, "json_options_encoding") == null ? [] : ["json_options"]
        content {
          encoding = lookup(json_options.value, "json_options_encoding")
        }
      }

      dynamic "parquet_options" {
        for_each = (lookup(external.value, "enum_as_string") || lookup(external.value, "enable_list_inference")) == null ? [] : ["parquet_options"]
        content {
          enum_as_string        = lookup(external.value, "enum_as_string")
          enable_list_inference = lookup(external.value, "enable_list_inference")
        }
      }
    }
  }

  dynamic "materialized_view" {
    for_each = lookup(var.table[count.index], "materialized_view") == null ? [] : ["materialized_view"]
    content {
      query                            = lookup(materialized_view.value, "query")
      enable_refresh                   = lookup(materialized_view.value, "enable_refresh")
      refresh_interval_ms              = lookup(materialized_view.value, "refresh_interval_ms")
      allow_non_incremental_definition = lookup(materialized_view.value, "allow_non_incremental_definition")
    }
  }

  dynamic "range_partitioning" {
    for_each = lookup(var.table[count.index], "range_partitioning_field") == null ? [] : ["range_partitioning"]
    content {
      field = lookup(var.table[count.index], "range_partitioning_field")

      range {
        interval = lookup(var.table, "interval")
        end      = lookup(var.table, "end")
        start    = lookup(var.table, "start")
      }
    }
  }

  dynamic "table_constraints" {
    for_each = lookup(var.table[count.index], "table_constraints") == null ? [] : ["table_constraints"]
    content {
      dynamic "primary_key" {
        for_each = lookup(table_constraints.value, "primary_key_columns") == null ? [] : ["primary_key"]
        content {
          columns = lookup(table_constraints.value, "primary_key_columns")
        }
      }

      dynamic "foreign_keys" {
        for_each = lookup(table_constraints.value, "foreign_keys") == null ? [] : ["foreign_keys"]
        content {
          name = lookup(foreign_keys.value, "name")

          dynamic "column_references" {
            for_each = lookup(foreign_keys.value, "column_references")
            content {
              referenced_column  = lookup(column_references.value, "referenced_column")
              referencing_column = lookup(column_references.value, "referencing_column")
            }
          }

          dynamic "referenced_table" {
            for_each = lookup(foreign_keys.value, "referenced_table")
            content {
              table_id   = try(element(google_bigquery_table.this.*.table_id, lookup(referenced_table.value, "table_id")))
              dataset_id = try(element(google_bigquery_table.this.*.dataset_id, lookup(referenced_table.value, "table_id")))
              project_id = try(element(google_bigquery_table.this.*.project, lookup(referenced_table.value, "table_id")))
            }
          }
        }
      }
    }
  }

  dynamic "time_partitioning" {
    for_each = lookup(var.table[count.index], "time_partitioning") == null ? [] : ["time_partitioning"]
    content {
      type          = lookup(time_partitioning.value, "type")
      expiration_ms = lookup(time_partitioning.value, "expiration_ms")
      field         = lookup(time_partitioning.value, "field")
    }
  }

  dynamic "view" {
    for_each = (lookup(var.table[count.index], "view_query") || lookup(var.table[count.index], "view_use_legacy_sql")) == null ? [] : ["view"]
    content {
      query          = lookup(var.table, "view_query")
      use_legacy_sql = lookup(var.table, "view_use_legacy_sql")
    }
  }

  dynamic "table_replication_info" {
    for_each = lookup(var.table[count.index], "table_replication_info") == null ? [] : ["table_replication_info"]
    content {
      source_project_id       = lookup(table_replication_info.value, "source_project_id")
      source_dataset_id       = lookup(table_replication_info.value, "source_dataset_id")
      source_table_id         = lookup(table_replication_info.value, "source_table_id")
      replication_interval_ms = lookup(table_replication_info.value, "replication_interval_ms")
    }
  }
}

resource "google_bigquery_table_iam_member" "this" {
  count      = (length(var.dataset) && length(var.table)) == 0 ? 0 : length(var.table_iam_member)
  dataset_id = try(element(google_bigquery_dataset.this.*.dataset_id, lookup(var.table_iam_member[count.index], "dataset_id")))
  member     = lookup(var.table_iam_member[count.index], "member")
  role       = lookup(var.table_iam_member[count.index], "role")
  table_id   = try(element(google_bigquery_table.this.*.table_id, lookup(var.table_iam_member[count.index], "table_id")))

  dynamic "condition" {
    for_each = lookup(var.table_iam_member[count.index], "condition")
    content {
      expression  = lookup(condition.value, "expression")
      title       = lookup(condition.value, "title")
      description = lookup(condition.value, "description")
    }
  }
}

## CONNECTION ##

resource "google_bigquery_connection" "this" {
  count         = length(var.connection)
  project       = data.google_project.this.id
  provider      = google-beta
  connection_id = lookup(var.connection[count.index], "connection_id")
  location      = lookup(var.connection[count.index], "location")
  friendly_name = lookup(var.connection[count.index], "friendly_name")
  description   = lookup(var.connection[count.index], "description")
  kms_key_name  = try(element(var.connection_kms_key_name, lookup(var.connection[count.index], "kms_key_id")))

  dynamic "cloud_resource" {
    for_each = lookup(var.connection[count.index], "cloud_resource") != true ? [] : ["cloud_resource"]
    content {

    }
  }

  dynamic "aws" {
    for_each = lookup(var.connection[count.index], "iam_role_id") == null ? [] : ["aws"]
    content {
      access_role {
        iam_role_id = lookup(var.connection[count.index], "iam_role_id")
      }
    }
  }

  dynamic "azure" {
    for_each = lookup(var.connection[count.index], "azure") == null ? [] : ["azure"]
    content {
      customer_tenant_id              = sensitive(lookup(azure.value, "customer_tenant_id"))
      federated_application_client_id = sensitive(lookup(azure.value, "federated_application_client_id"))

    }
  }

  dynamic "cloud_spanner" {
    for_each = lookup(var.connection[count.index], "cloud_spanner") == null ? [] : ["cloud_spanner"]
    content {
      database        = lookup(cloud_spanner.value, "database")
      database_role   = lookup(cloud_spanner.value, "database_role")
      use_parallelism = lookup(cloud_spanner.value, "use_parallelism")
      use_data_boost  = lookup(cloud_spanner.value, "use_data_boost")
      max_parallelism = lookup(cloud_spanner.value, "max_parallelism")
    }
  }

  dynamic "cloud_sql" {
    for_each = lookup(var.connection[count.index], "cloud_sql") == null ? [] : ["cloud_sql"]
    content {
      database    = try(element(var.sql_database_name, lookup(cloud_sql.value, "database_id")))
      instance_id = try(element(var.sql_database_instance_name, lookup(cloud_sql.value, "instance_id")))
      type        = lookup(cloud_sql.value, "type")

      credential {
        username = try(element(var.sql_database_user, lookup(cloud_sql.value, "username")))
        password = try(element(var.sql_database_password, lookup(cloud_sql.value, "password")))
      }
    }
  }

  dynamic "spark" {
    for_each = lookup(var.connection[count.index], "spark") == null ? [] : ["spark"]
    content {
      spark_history_server_config {
        dataproc_cluster = lookup(spark.value, "dataproc_cluster")
      }

      metastore_service_config {
        metastore_service = lookup(spark.value, "metastore_service")
      }
    }
  }
}

resource "google_bigquery_connection_iam_member" "this" {
  count         = length(var.connection) == 0 ? 0 : length(var.connection_iam_member)
  connection_id = try(element(google_bigquery_connection.this.*.connection_id, ))
  member        = lookup(var.connection_iam_member[count.index], "member")
  role          = lookup(var.connection_iam_member[count.index], "role")
}

## DATA_POLICY ##

resource "google_bigquery_datapolicy_data_policy" "this" {
  count            = length(var.datapolicy_data_policy)
  project          = data.google_project.this.id
  provider         = google-beta
  data_policy_id   = lookup(var.datapolicy_data_policy[count.index], "data_policy_id")
  data_policy_type = lookup(var.datapolicy_data_policy[count.index], "data_policy_type")
  location         = lookup(var.datapolicy_data_policy[count.index], "location")
  policy_tag       = lookup(var.datapolicy_data_policy[count.index], "policy_tag")

  dynamic "data_masking_policy" {
    for_each = lookup(var.datapolicy_data_policy[count.index], "data_masking_policy") == null ? [] : ["data_masking_policy"]
    iterator = dmp
    content {
      predefined_expression = lookup(dmp.value, "predefined_expression")
      routine               = try(google_bigquery_routine.this.*.id, lookup(dmp.value, "routine_id"))
    }
  }
}

## DATA_TRANSFER ##

resource "google_bigquery_data_transfer_config" "this" {
  count                     = length(var.dataset) == 0 ? 0 : length(var.data_transfer)
  project                   = data.google_project.this.id
  provider                  = google-beta
  data_source_id            = lookup(var.data_transfer[count.index], "data_source_id")
  display_name              = lookup(var.data_transfer[count.index], "display_name")
  params                    = lookup(var.data_transfer[count.index], "params")
  destination_dataset_id    = try(element(google_bigquery_dataset.this.*.id, lookup(var.data_transfer[count.index], "destination_dataset_id")))
  schedule                  = lookup(var.data_transfer[count.index], "schedule")
  notification_pubsub_topic = lookup(var.data_transfer[count.index], "notification_pubsub_topic")
  data_refresh_window_days  = lookup(var.data_transfer[count.index], "data_refresh_window_days")
  disabled                  = lookup(var.data_transfer[count.index], "disabled")
  service_account_name      = lookup(var.data_transfer[count.index], "service_account_name")

  dynamic "schedule_options" {
    for_each = lookup(var.data_transfer[count.index], "schedule_options") == null ? [] : ["schedule_options"]
    content {
      disable_auto_scheduling = lookup(schedule_options.value, "disable_auto_scheduling")
      start_time              = lookup(schedule_options.value, "start_time")
      end_time                = lookup(schedule_options.value, "end_time")
    }
  }

  dynamic "email_preferences" {
    for_each = lookup(var.data_transfer[count.index], "enable_failure_email") == null ? [] : ["email_preferences"]
    content {
      enable_failure_email = lookup(var.data_transfer[count.index], "enable_failure_email")
    }
  }

  dynamic "sensitive_params" {
    for_each = lookup(var.data_transfer[count.index], "secret_access_key") == null ? [] : ["sensitive_params"]
    content {
      secret_access_key = lookup(var.data_transfer[count.index], "secret_access_key")
    }
  }
}