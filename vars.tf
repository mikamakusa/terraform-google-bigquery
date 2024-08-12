variable "labels" {
  type    = map(string)
  default = {}
}

variable "project_id" {
  type = string
}

variable "dataset_kms_key_name" {
  type    = string
  default = null
}

variable "job_copy_kms_key_name" {
  type    = string
  default = null
}

variable "job_query_kms_key_name" {
  type    = string
  default = null
}

variable "job_load_kms_key_name" {
  type    = string
  default = null
}

variable "table_kms_key_name" {
  type    = string
  default = null
}

variable "connection_kms_key_name" {
  type    = string
  default = null
}

variable "sql_database_instance_name" {
  type    = string
  default = null
}

variable "sql_database_name" {
  type    = string
  default = null
}

variable "sql_database_user" {
  type      = string
  default   = null
  sensitive = true
}

variable "sql_database_password" {
  type      = string
  default   = null
  sensitive = true
}

variable "dataset" {
  type = list(object({
    id                              = number
    dataset_id                      = string
    default_collation               = optional(string)
    default_partition_expiration_ms = optional(number)
    default_table_expiration_ms     = optional(number)
    delete_contents_on_destroy      = optional(bool)
    description                     = optional(string)
    friendly_name                   = optional(string)
    is_case_insensitive             = optional(bool)
    labels                          = optional(map(string))
    max_time_travel_hours           = optional(string)
    storage_billing_model           = optional(string)
    kms_key_id                      = optional(any)
    access = optional(list(object({
      domain         = optional(string)
      group_by_email = optional(string)
      role           = optional(string)
      special_group  = optional(string)
      iam_member     = optional(string)
      user_by_email  = optional(string)
      dataset = optional(list(object({
        target_types = optional(list(string))
        dataset_id   = any
      })))
      routine = optional(list(object({
        routine_id = any
      })))
      view = optional(list(object({
        table_id = any
      })))
    })))
    external_dataset_reference = optional(list(object({
      external_source = string
      connection      = string
    })))
  }))
  default = []

  validation {
    condition = length([
      for a in var.dataset : true if a.max_time_travel_hours >= 48 && a.max_time_travel_hours <= 168
    ]) == length(var.dataset)
    error_message = "The value can be from 48 to 168 hours (2 to 7 days)."
  }

  validation {
    condition = length([
      for b in var.dataset : true if contains(["LOGICAL", "PHYSICAL"], b.storage_billing_model)
    ]) == length(var.dataset)
    error_message = "Set this flag value to LOGICAL to use logical bytes for storage billing, or to PHYSICAL to use physical bytes instead. LOGICAL is the default if this flag isn't specified."
  }
}

variable "dataset_access" {
  type = list(object({
    id             = number
    dataset_id     = any
    domain         = optional(string)
    group_by_email = optional(string)
    iam_member     = optional(string)
    role           = optional(string)
    special_group  = optional(string)
    user_by_email  = optional(string)
    dataset = optional(list(object({
      target_types = optional(string)
      dataset_id   = optional(any)
    })))
    view = optional(list(object({
      table_id = any
    })))
  }))
  default = []
}

variable "dataset_iam_member" {
  type = list(object({
    id         = number
    dataset_id = any
    member     = string
    role       = string
    condition = optional(list(object({
      expression  = string
      title       = string
      description = optional(string)
    })))
  }))
  default = []
}

variable "job" {
  type = list(object({
    id             = number
    job_id         = string
    job_timeout_ms = optional(string)
    labels         = optional(map(string))
    location       = optional(string)
    copy = optional(list(object({
      create_disposition = optional(string)
      write_disposition  = optional(string)
      kms_key_id         = optional(any)
      source_tables = optional(list(object({
        table_id = string
      })))
      destination_table = optional(list(object({
        table_id = string
      })))
    })))
    extract = optional(list(object({
      destination_uris   = list(string)
      print_header       = optional(bool)
      field_delimiter    = optional(string)
      destination_format = optional(string)
      compression        = optional(string)
      source_model = optional(list(object({
        table_id = string
      })))
      source_table = optional(list(object({
        table_id = string
      })))
    })))
    load = optional(list(object({
      source_uris           = list(string)
      allow_jagged_rows     = optional(bool)
      allow_quoted_newlines = optional(bool)
      autodetect            = optional(bool)
      create_disposition    = optional(string)
      encoding              = optional(string)
      field_delimiter       = optional(string)
      ignore_unknown_values = optional(bool)
      max_bad_records       = optional(number)
      null_marker           = optional(string)
      projection_fields     = optional(list(string))
      quote                 = optional(string)
      schema_update_options = optional(list(string))
      skip_leading_rows     = optional(number)
      source_format         = optional(string)
      write_disposition     = optional(string)
      kms_key_id            = optional(any)
      destination_table = optional(list(object({
        table_id = any
      })))
      time_partitioning = optional(list(object({
        type          = string
        expiration_ms = optional(string)
        field         = optional(string)
      })))
      parquet_options = optional(list(object({
        enum_as_string        = optional(bool)
        enable_list_inference = optional(bool)
      })))
    })))
    query = optional(list(object({
      query                 = string
      create_disposition    = optional(string)
      allow_large_results   = optional(string)
      flatten_results       = optional(bool)
      maximum_billing_tier  = optional(number)
      maximum_bytes_billed  = optional(string)
      parameter_mode        = optional(string)
      priority              = optional(string)
      schema_update_options = optional(list(string))
      use_legacy_sql        = optional(bool)
      use_query_cache       = optional(bool)
      write_disposition     = optional(string)
      kms_key_id            = optional(any)
      default_dataset = optional(list(object({
        dataset_id = any
      })))
      destination_table = optional(list(object({
        table_id = any
      })))
      script_options = optional(list(object({
        statement_byte_budget = optional(string)
        statement_timeout_ms  = optional(string)
        key_result_statement  = optional(string)
      })))
      user_defined_function_resources = optional(list(object({
        resource_uri = optional(string)
        inline_code  = optional(string)
      })))
    })))
  }))
  default = []

  validation {
    condition = length([
      for a in var.job : true if contains(["DELETE", "UPDATE", "MERGE", "INSERT"], a.query.query)
    ]) == length(var.job)
    error_message = "The useLegacySql field can be used to indicate whether the query uses legacy SQL or standard SQL. NOTE: queries containing DML language (DELETE, UPDATE, MERGE, INSERT)."
  }

  validation {
    condition = length([
      for b in var.job : true if contains(["CREATE_IF_NEEDED", "CREATE_NEVER"], b.query.create_disposition)
    ]) == length(var.job)
    error_message = "Possible values are: CREATE_IF_NEEDED, CREATE_NEVER."
  }

  validation {
    condition = length([
      for c in var.job : true if contains(["WRITE_TRUNCATE", "WRITE_APPEND", "WRITE_EMPTY"], c.query.write_disposition)
    ]) == length(var.job)
    error_message = "Possible values are: WRITE_TRUNCATE, WRITE_APPEND, WRITE_EMPTY."
  }

  validation {
    condition = length([
      for d in var.job : true if contains(["INTERACTIVE", "BATCH"], d.query.priority)
    ]) == length(var.job)
    error_message = "Possible values are: INTERACTIVE, BATCH."
  }

  validation {
    condition = length([
      for e in var.job : true if contains(["POSITIONAL", "NAMED"], e.query.parameter_mode)
    ]) == length(var.job)
    error_message = "Set to POSITIONAL to use positional (?) query parameters or to NAMED to use named (@myparam) query parameters in this query."
  }

  validation {
    condition = length([
      for f in var.job : true if contains(["LAST", "FIRST_SELECT"], f.query.script_options.key_result_statement)
    ]) == length(var.job)
    error_message = "Possible values are: LAST, FIRST_SELECT."
  }

  validation {
    condition = length([
      for g in var.job : true if contains(["CREATE_IF_NEEDED", "CREATE_NEVER"], g.load.create_disposition)
    ]) == length(var.job)
    error_message = "Possible values are: CREATE_IF_NEEDED, CREATE_NEVER."
  }

  validation {
    condition = length([
      for h in var.job : true if contains(["WRITE_TRUNCATE", "WRITE_APPEND", "WRITE_EMPTY"], h.load.write_disposition)
    ]) == length(var.job)
    error_message = "Possible values are: WRITE_TRUNCATE, WRITE_APPEND, WRITE_EMPTY."
  }

  validation {
    condition = length([
      for i in var.job : true if contains(["CREATE_IF_NEEDED", "CREATE_NEVER"], i.copy.create_disposition)
    ]) == length(var.job)
    error_message = "Possible values are: CREATE_IF_NEEDED, CREATE_NEVER."
  }

  validation {
    condition = length([
      for j in var.job : true if contains(["WRITE_TRUNCATE", "WRITE_APPEND", "WRITE_EMPTY"], j.copy.write_disposition)
    ]) == length(var.job)
    error_message = "Possible values are: WRITE_TRUNCATE, WRITE_APPEND, WRITE_EMPTY."
  }
}

variable "routine" {
  type = list(object({
    id                 = number
    dataset_id         = any
    definition_body    = string
    routine_id         = string
    routine_type       = string
    language           = optional(string)
    return_type        = optional(string)
    return_table_type  = optional(string)
    imported_libraries = optional(list(string))
    description        = optional(string)
    determinism_level  = optional(string)
    arguments = optional(list(object({
      name          = optional(string)
      argument_kind = optional(string)
      mode          = optional(string)
      data_type     = optional(string)
    })))
    remote_function_options = optional(list(object({
      endpoint             = optional(string)
      connection           = optional(string)
      user_defined_context = optional(map(string))
      max_batching_rows    = optional(string)
    })))
    spark_options = optional(list(object({
      connection      = optional(string)
      container_image = optional(string)
      runtime_version = optional(string)
      properties      = optional(map(string))
      main_file_uri   = optional(string)
      main_class      = optional(string)
      py_file_uris    = optional(list(string))
      jar_uris        = optional(list(string))
      file_uris       = optional(list(string))
      archive_uris    = optional(list(string))
    })))
  }))
  default = []

  validation {
    condition = length([
      for a in var.routine : true if contains(["SCALAR_FUNCTION", "PROCEDURE", "TABLE_VALUED_FUNCTION"], a.routine_type)
    ]) == length(var.job)
    error_message = "Possible values are: SCALAR_FUNCTION, PROCEDURE, TABLE_VALUED_FUNCTION."
  }

  validation {
    condition = length([
      for b in var.routine : true if contains(["SQL", "JAVASCRIPT", "PYTHON", "JAVA", "SCALA"], b.language)
    ]) == length(var.job)
    error_message = "Possible values are: SQL, JAVASCRIPT, PYTHON, JAVA, SCALA."
  }

  validation {
    condition = length([
      for c in var.routine : true if contains(["DETERMINISM_LEVEL_UNSPECIFIED", "DETERMINISTIC", "NOT_DETERMINISTIC"], c.determinism_level)
    ]) == length(var.job)
    error_message = "Possible values are: DETERMINISM_LEVEL_UNSPECIFIED, DETERMINISTIC, NOT_DETERMINISTIC."
  }

  validation {
    condition = length([
      for d in var.routine : true if contains(["FIXED_TYPE", "ANY_TYPE"], d.arguments.argument_kind)
    ]) == length(var.job)
    error_message = "Default value is FIXED_TYPE. Possible values are: FIXED_TYPE, ANY_TYPE."
  }

  validation {
    condition = length([
      for e in var.routine : true if contains(["IN", "OUT", "INOUT"], e.arguments.argument_kind)
    ]) == length(var.job)
    error_message = "Possible values are: IN, OUT, INOUT."
  }
}

variable "table" {
  type = list(object({
    id                       = number
    dataset_id               = any
    table_id                 = string
    description              = optional(string)
    deletion_protection      = optional(bool)
    expiration_time          = optional(number)
    friendly_name            = optional(string)
    labels                   = optional(map(string))
    max_staleness            = optional(string)
    require_partition_filter = optional(bool)
    schema                   = optional(string)
    kms_key_id               = optional(any)
    view_query               = optional(string)
    view_use_legacy_sql      = optional(bool)
    range_partitioning_field = optional(string)
    type                     = optional(string)
    expiration_ms            = optional(number)
    field                    = optional(string)
    range = optional(list(object({
      interval = number
      end      = number
      start    = number
    })))
    external_data_configuration = optional(list(object({
      autodetect                = bool
      source_uris               = list(string)
      compression               = optional(string)
      connection_id             = optional(string)
      ignore_unknown_values     = optional(bool)
      max_bad_records           = optional(number)
      schema                    = optional(string)
      source_format             = optional(string)
      file_set_spec_type        = optional(string)
      reference_file_schema_uri = optional(string)
      metadata_cache_mode       = optional(string)
      object_metadata           = optional(string)
      json_options_encoding     = optional(string)
      use_avro_logical_types    = optional(bool)
      enum_as_string            = optional(bool)
      enable_list_inference     = optional(bool)
      bigtable_options = optional(list(object({
        ignore_unspecified_column_families = optional(bool)
        read_rowkey_as_string              = optional(bool)
        output_column_families_as_json     = optional(bool)
        column_family = optional(list(object({
          family_id        = optional(string)
          type             = optional(string)
          encoding         = optional(string)
          only_read_latest = optional(bool)
          column = optional(list(object({
            qualifier_encoded = optional(string)
            qualifier_string  = optional(string)
            type              = optional(string)
            encoding          = optional(string)
            only_read_latest  = optional(bool)
          })))
        })))
      })))
      csv_options = optional(list(object({
        quote                 = optional(string)
        allow_jagged_rows     = optional(bool)
        allow_quoted_newlines = optional(bool)
        skip_leading_rows     = optional(number)
        encoding              = optional(string)
        field_delimiter       = optional(string)
      })))
      google_sheets_options = optional(list(object({
        range             = optional(string)
        skip_leading_rows = optional(number)
      })))
      hive_partitioning_options = optional(list(object({
        mode                     = optional(string)
        require_partition_filter = optional(bool)
        source_uri_prefix        = optional(string)
      })))
    })))
    materialized_view = optional(list(object({
      query                            = string
      enable_refresh                   = optional(bool)
      refresh_interval_ms              = optional(number)
      allow_non_incremental_definition = optional(bool)
    })))
    table_constraints = optional(list(object({
      primary_key_columns = optional(list(string))
      foreign_keys = optional(list(object({
        name = optional(string)
        column_references = list(object({
          referenced_column  = string
          referencing_column = string
        }))
        referenced_table = list(object({
          table_id = any
        }))
      })))
    })))
    time_partitioning = optional(list(object({
      type          = string
      expiration_ms = optional(number)
      field         = optional(string)
    })))
    table_replication_info = optional(list(object({
      source_project_id       = string
      source_dataset_id       = string
      source_table_id         = string
      replication_interval_ms = optional(number)
    })))
  }))
  default = []

  validation {
    condition = length([
      for a in var.table : true if contains(["AUTOMATIC", "MANUAL"], a.external_data_configuration.metadata_cache_mode)
    ]) == length(var.job)
    error_message = "Valid values are AUTOMATIC and MANUAL."
  }

  validation {
    condition = length([
      for b in var.table : true if contains(["UTF-8", "UTF-16BE", "UTF-16LE", "UTF-32BE", "UTF-32LE"], b.external_data_configuration.json_options_encoding)
    ]) == length(var.job)
    error_message = "The supported values are UTF-8, UTF-16BE, UTF-16LE, UTF-32BE, and UTF-32LE. The default value is UTF-8."
  }

  validation {
    condition = length([
      for b in var.table : true if contains(["JSON", "CSV", "ORC", "Avro", "Parquet"], b.external_data_configuration.hive_partitioning_options.mode)
    ]) == length(var.job)
    error_message = "Currently supported formats are: JSON, CSV, ORC, Avro and Parquet."
  }
}

variable "table_iam_member" {
  type = list(object({
    id         = number
    dataset_id = any
    member     = string
    role       = string
    table_id   = any
    condition = optional(list(object({
      expression  = string
      title       = string
      description = optional(string)
    })))
  }))
  default = []
}

## CONNECTION ##

variable "connection" {
  type = list(object({
    id              = number
    connection_id   = optional(string)
    location        = optional(string)
    friendly_name   = optional(string)
    description     = optional(string)
    kms_key_id      = optional(any)
    aws_iam_role_id = optional(string)
    cloud_resource  = optional(bool)
    azure = optional(list(object({
      customer_tenant_id              = string
      federated_application_client_id = string
    })))
    cloud_spanner = optional(list(object({
      database        = string
      database_role   = optional(string)
      use_parallelism = optional(bool)
      use_data_boost  = optional(bool)
      max_parallelism = optional(number)
    })))
    cloud_sql = optional(list(object({
      database_id = any
      instance_id = any
      type        = string
      user_id     = any
    })))
    spark = optional(list(object({
      dataproc_cluster  = optional(string)
      metastore_service = optional(string)
    })))
  }))
  default = []

  validation {
    condition = length([
      for a in var.connection : true if contains(["DATABASE_TYPE_UNSPECIFIED", "POSTGRES", "MYSQL"], a.cloud_sql.type)
    ]) == length(var.datapolicy_data_policy)
    error_message = "Possible values are: DATABASE_TYPE_UNSPECIFIED, POSTGRES, MYSQL."
  }
}

variable "connection_iam_member" {
  type = list(object({
    id            = number
    connection_id = any
    member        = string
    role          = string
  }))
  default = []
}

variable "datapolicy_data_policy" {
  type = list(object({
    id                    = number
    data_policy_id        = string
    data_policy_type      = string
    location              = string
    policy_tag            = string
    predefined_expression = optional(string)
    routine_id            = any
  }))
  default = []

  validation {
    condition = length([
      for a in var.datapolicy_data_policy : true if contains(["COLUMN_LEVEL_SECURITY_POLICY", "DATA_MASKING_POLICY"], a.data_policy_type)
    ]) == length(var.datapolicy_data_policy)
    error_message = "Possible values are: COLUMN_LEVEL_SECURITY_POLICY, DATA_MASKING_POLICY."
  }

  validation {
    condition = length([
      for b in var.datapolicy_data_policy : true if contains(["SHA256", "ALWAYS_NULL", "DEFAULT_MASKING_VALUE", "LAST_FOUR_CHARACTERS", "FIRST_FOUR_CHARACTERS", "EMAIL_MASK", "DATE_YEAR_MASK"], b.predefined_expression)
    ]) == length(var.datapolicy_data_policy)
    error_message = "Possible values are: SHA256, ALWAYS_NULL, DEFAULT_MASKING_VALUE, LAST_FOUR_CHARACTERS, FIRST_FOUR_CHARACTERS, EMAIL_MASK, DATE_YEAR_MASK."
  }
}

variable "data_transfer" {
  type = list(object({
    id                        = number
    data_source_id            = string
    display_name              = string
    params                    = map(string)
    destination_dataset_id    = optional(any)
    schedule                  = optional(string)
    notification_pubsub_topic = optional(string)
    data_refresh_window_days  = optional(number)
    disabled                  = optional(bool)
    service_account_name      = optional(any)
    enable_failure_email      = optional(bool)
    secret_access_key         = optional(string)
    schedule_options = optional(list(object({
      disable_auto_scheduling = optional(bool)
      start_time              = optional(string)
      end_time                = optional(string)
    })))
  }))
  default = []
}

variable "bi_reservation" {
  type = list(object({
    id       = number
    location = string
    size     = optional(number)
    preferred_tables = optional(list(object({
      table_id = optional(any)
    })))
  }))
  default = []
}

variable "capacity_commitment" {
  type = list(object({
    id                                   = number
    plan                                 = string
    slot_count                           = number
    renewal_plan                         = optional(string)
    edition                              = optional(string)
    capacity_commitment_id               = optional(string)
    location                             = optional(string)
    enforce_single_admin_project_per_org = optional(string)
  }))
  default = []
}

variable "reservation" {
  type = list(object({
    id                     = number
    name                   = string
    slot_capacity          = number
    ignore_idle_slots      = optional(bool)
    concurrency            = optional(number)
    multi_region_auxiliary = optional(bool)
    edition                = optional(string)
    location               = optional(string)
    max_slots              = optional(string)
  }))
  default = []
}

variable "reservation_assignment" {
  type = list(object({
    id             = number
    assignee       = string
    job_type       = string
    reservation_id = any
    location       = optional(string)
  }))
  default = []
}