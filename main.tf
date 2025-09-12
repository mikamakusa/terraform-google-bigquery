resource "google_bigquery_dataset" "this" {
  for_each                        = { for dataset in var.datasets : dataset.id => dataset }
  dataset_id                      = each.value.id
  max_time_travel_hours           = each.value.max_time_travel_hours
  default_partition_expiration_ms = each.value.default_partition_expiration_ms
  default_table_expiration_ms     = each.value.default_table_expiration_ms
  description                     = each.value.description
  friendly_name                   = each.value.friendly_name
  labels                          = merge(var.labels, each.value.labels)
  location                        = each.value.location
  is_case_insensitive             = each.value.is_case_insensitive
  default_collation               = each.value.default_collation
  storage_billing_model           = each.value.storage_billing_model
  resource_tags                   = each.value.resource_tags
  project                         = data.google_project.this.project_id
  delete_contents_on_destroy      = each.value.delete_contents_on_destroy

  dynamic "access" {
    for_each = var.access != null ? [""] : []
    content {
      domain         = var.access.domain
      group_by_email = var.access.group_by_email
      special_group  = var.access.special_group
      user_by_email  = var.access.user_by_email
      iam_member     = var.access.iam_member
    }
  }

  dynamic "default_encryption_configuration" {
    for_each = var.default_encryption_configuration != null ? [""] : []
    content {
      kms_key_name = var.default_encryption_configuration.kms_key_name
    }
  }

  dynamic "external_catalog_dataset_options" {
    for_each = length(var.external_catalog_dataset_options) != null ? [""] : []
    content {
      parameters                   = var.external_catalog_dataset_options.parameters
      default_storage_location_uri = var.external_catalog_dataset_options.default_storage_location_uri
    }
  }

  dynamic "external_dataset_reference" {
    for_each = var.external_dataset_reference != null ? [""] : []
    iterator = edr
    content {
      connection      = var.external_dataset_reference.connection
      external_source = var.external_dataset_reference.external_source
    }
  }
}

resource "google_bigquery_dataset_access" "this" {
  for_each       = { for dataset in var.datasets : dataset.id => dataset if contains(keys(dataset, "dataset_accesses")) && dataset.dataset_accesses != null }
  dataset_id     = google_bigquery_dataset.this[each.key].id
  role           = lookup(each.value, "role")
  user_by_email  = lookup(each.value, "user_by_email")
  group_by_email = lookup(each.value, "group_by_email")
  domain         = lookup(each.value, "domain")
  special_group  = lookup(each.value, "special_group")
  iam_member     = lookup(each.value, "iam_member")
  project        = google_bigquery_dataset.this[each.key].project
}

resource "google_bigquery_dataset_iam_policy" "this" {
  for_each    = { for dataset in var.datasets : dataset.id => dataset if contains(keys(dataset, "policy_data")) && dataset.policy_data != null }
  dataset_id  = google_bigquery_dataset.this[each.key].id
  policy_data = each.value.policy_data
}

resource "google_bigquery_job" "this" {
  for_each       = { for job in var.jobs : job.id => job }
  job_id         = each.value.id
  job_timeout_ms = each.value.job_timeout_ms
  project        = each.value.project
  labels         = data.google_project.this.project_id
  location       = each.value.location

  dynamic "query" {
    for_each = var.query != null ? [""] : []
    content {
      query                 = var.query.query
      create_disposition    = var.query.create_disposition
      write_disposition     = var.query.write_disposition
      allow_large_results   = var.query.allow_large_results
      priority              = var.query.priority
      maximum_bytes_billed  = var.query.maximum_bytes_billed
      parameter_mode        = var.query.parameter_mode
      schema_update_options = var.query.schema_update_options
      use_legacy_sql        = var.query.use_legacy_sql
      use_query_cache       = var.query.use_query_cache
      flatten_results       = var.query.flatten_results
      maximum_billing_tier  = var.query.maximum_billing_tier
    }
  }

  dynamic "load" {
    for_each = var.load != null ? [""] : []
    content {
      source_uris           = var.load.source_uris
      allow_jagged_rows     = var.load.allow_jagged_rows
      allow_quoted_newlines = var.load.allow_quoted_newlines
      autodetect            = var.load.autodetect
      create_disposition    = var.load.create_disposition
      encoding              = var.load.encoding
      field_delimiter       = var.load.field_delimiter
      ignore_unknown_values = var.load.ignore_unknown_values
      json_extension        = var.load.json_extension
      max_bad_records       = var.load.max_bad_records
      null_marker           = var.load.null_marker
      projection_fields     = var.load.projection_fields
      quote                 = var.load.quote
      schema_update_options = var.load.schema_update_options
      skip_leading_rows     = var.load.skip_leading_rows
      source_format         = var.load.source_format
      write_disposition     = var.load.write_disposition

      destination_table {
        table_id   = var.load.destination_table_id
        project_id = var.load.destination_project_id
        dataset_id = var.load.destination_dataset_id
      }
    }
  }

  dynamic "copy" {
    for_each = var.copy != null ? [""] : []
    content {
      create_disposition = var.copy.create_disposition
      write_disposition  = var.copy.write_disposition

      source_tables {
        table_id   = var.copy.source_table_id
        project_id = var.copy.source_project_id
        dataset_id = var.copy.source_dataset_id
      }
    }
  }

  dynamic "extract" {
    for_each = var.extract != null ? [""] : []
    content {
      destination_uris       = var.extract.destination_uris
      print_header           = var.extract.print_header
      field_delimiter        = var.extract.field_delimiter
      destination_format     = var.extract.destination_format
      use_avro_logical_types = var.extract.use_avro_logical_types
      compression            = var.extract.compression
    }
  }
}

resource "google_bigquery_routine" "this" {
  for_each             = { for dataset in var.datasets : dataset.id => dataset if contains(keys(dataset, "routines")) && dataset.routines != null }
  dataset_id           = google_bigquery_dataset.this[each.key].id
  definition_body      = lookup(each.value, "definition_body")
  routine_id           = lookup(each.value, "routine_id")
  routine_type         = lookup(each.value, "routine_type")
  language             = lookup(each.value, "language")
  return_type          = lookup(each.value, "return_type")
  return_table_type    = lookup(each.value, "return_table_type")
  data_governance_type = lookup(each.value, "data_governance_type")
  description          = lookup(each.value, "description")
  determinism_level    = lookup(each.value, "determinism_level")
  security_mode        = lookup(each.value, "security_mode")
  project              = google_bigquery_dataset.this[each.key].project

  dynamic "arguments" {
    for_each = var.arguments != null ? [""] : []
    content {
      name          = var.arguments.name
      argument_kind = var.arguments.argument_kind
      data_type     = var.arguments.data_type
      mode          = var.arguments.mode
    }
  }

  dynamic "remote_function_options" {
    for_each = var.remote_function_options != null ? [""] : []
    content {
      connection           = var.remote_function_options.connection
      endpoint             = var.remote_function_options.endpoint
      max_batching_rows    = var.remote_function_options.max_batching_rows
      user_defined_context = var.remote_function_options.user_defined_context
    }
  }

  dynamic "spark_options" {
    for_each = var.spark_options != null ? [""] : []
    content {
      archive_uris    = var.spark_options.archive_uris
      connection      = var.spark_options.connection
      container_image = var.spark_options.container_image
      file_uris       = var.spark_options.file_uris
      jar_uris        = var.spark_options.jar_uris
      main_class      = var.spark_options.main_class
      main_file_uri   = var.spark_options.main_file_uri
      properties      = var.spark_options.properties
      py_file_uris    = var.spark_options.py_file_uris
      runtime_version = var.spark_options.runtime_version
    }
  }
}

resource "google_bigquery_table" "this" {
  for_each                 = { for dataset in var.datasets : dataset.id => dataset if contains(keys(dataset, "tables")) && dataset.tables != null }
  dataset_id               = google_bigquery_dataset.this[each.key].id
  table_id                 = lookup(each.value, "id")
  project                  = google_bigquery_dataset.this[each.key].project
  deletion_protection      = lookup(each.value, "deletion_protection")
  clustering               = lookup(each.value, "clustering")
  description              = lookup(each.value, "description")
  expiration_time          = lookup(each.value, "expiration_time")
  friendly_name            = lookup(each.value, "friendly_name")
  labels                   = lookup(each.value, "labels")
  max_staleness            = lookup(each.value, "max_staleness")
  require_partition_filter = lookup(each.value, "require_partition_filter")
  resource_tags            = lookup(each.value, "resource_tags")
  schema                   = lookup(each.value, "schema")
  table_metadata_view      = lookup(each.value, "table_metadata_view")

  dynamic "biglake_configuration" {
    for_each = var.biglake_configuration != null ? [""] : []
    content {
      connection_id = var.biglake_configuration.connection_id
      file_format   = var.biglake_configuration.file_format
      storage_uri   = var.biglake_configuration.storage_uri
      table_format  = var.biglake_configuration.table_format
    }
  }

  dynamic "encryption_configuration" {
    for_each = var.encryption_configuration != null ? [""] : []
    content {
      kms_key_name = var.encryption_configuration.kms_key_name
    }
  }

  dynamic "external_catalog_table_options" {
    for_each = var.external_catalog_table_options != null ? [""] : []
    content {
      parameters    = var.external_catalog_table_options.parameters
      connection_id = var.external_catalog_table_options.connection_id
    }
  }

  dynamic "external_data_configuration" {
    for_each = var.external_data_configuration != null ? [""] : []
    content {
      autodetect                = var.external_data_configuration.autodetect
      source_uris               = var.external_data_configuration.source_uris
      compression               = var.external_data_configuration.compression
      connection_id             = var.external_data_configuration.connection_id
      file_set_spec_type        = var.external_data_configuration.file_set_spec_type
      ignore_unknown_values     = var.external_data_configuration.ignore_unknown_values
      json_extension            = var.external_data_configuration.json_extension
      max_bad_records           = var.external_data_configuration.max_bad_records
      metadata_cache_mode       = var.external_data_configuration.metadata_cache_mode
      object_metadata           = var.external_data_configuration.object_metadata
      reference_file_schema_uri = var.external_data_configuration.reference_file_schema_uri
      schema                    = var.external_data_configuration.schema
      source_format             = var.external_data_configuration.source_format
    }
  }

  dynamic "materialized_view" {
    for_each = var.materialized_view != null ? [""] : []
    content {
      query                            = var.materialized_view.query
      allow_non_incremental_definition = var.materialized_view.allow_non_incremental_definition
      enable_refresh                   = var.materialized_view.enable_refresh
      refresh_interval_ms              = var.materialized_view.refresh_interval_ms
    }
  }

  dynamic "range_partitioning" {
    for_each = var.range_partitioning != null ? [""] : []
    content {
      field = var.range_partitioning.field

      range {
        end      = var.range_partitioning.range_end
        interval = var.range_partitioning.range_interval
        start    = var.range_partitioning.range_start
      }
    }
  }

  dynamic "schema_foreign_type_info" {
    for_each = var.schema_foreign_type_info != null ? [""] : []
    content {
      type_system = var.schema_foreign_type_info.type_system
    }
  }

  /*  dynamic "table_constraints" {
    for_each = lookup(var.table_constraints) != null ? [""] : []
    iterator = tbl_const
    content {
      primary_key {
        columns = []
      }
      foreign_keys {
        name = ""
        column_references {
          referenced_column  = ""
          referencing_column = ""
        }
        referenced_table {
          dataset_id = ""
          project_id = ""
          table_id   = ""
        }
      }
    }
  }*/

  dynamic "table_replication_info" {
    for_each = var.table_replication_info != null ? [""] : []
    content {
      source_dataset_id       = var.table_replication_info.source_dataset_id
      source_project_id       = var.table_replication_info.source_project_id
      source_table_id         = var.table_replication_info.source_table_id
      replication_interval_ms = var.table_replication_info.replication_interval_ms
    }
  }

  dynamic "time_partitioning" {
    for_each = var.time_partitioning != null ? [""] : []
    content {
      type          = var.time_partitioning.type
      field         = var.time_partitioning.field
      expiration_ms = var.time_partitioning.expiration_ms
    }
  }

  dynamic "view" {
    for_each = var.view != null ? [""] : []
    content {
      query          = var.view.query
      use_legacy_sql = var.view.use_legacy_sql
    }
  }
}