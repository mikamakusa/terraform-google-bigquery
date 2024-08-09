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
    id                              = optional(string)
    is_case_insensitive             = optional(bool)
    labels                          = optional(map(string))
    max_time_travel_hours           = optional(string)
    storage_billing_model           = optional(string)
    kms_key_name                    = optional(any)
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
        project_id   = any
      })))
      routine = optional(list(object({
        project_id = any
        dataset_id = any
        routine_id = any
      })))
      view = optional(list(object({
        table_id   = any
        dataset_id = any
        project_id = any
      })))
    })))
    external_dataset_reference = optional(list(object({
      external_source = string
      connection      = string
    })))
  }))
  default = []
}

variable "dataset_access" {
  type = list(object({
    id             = number
    dataset_id     = any
    domain         = optional(string)
    group_by_email = optional(string)
    iam_member     = optional(string)
    id             = optional(string)
    role           = optional(string)
    special_group  = optional(string)
    user_by_email  = optional(string)
    dataset = optional(list(object({
      target_types = optional(string)
      dataset_id   = optional(any)
      project_id   = optional(any)
    })))
    view = optional(list(object({
      dataset_id = any
      project_id = any
      table_id   = any
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
    copy           = optional(list(object({})))
    extract        = optional(list(object({})))
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
        table_id   = any
        project_id = optional(any)
        dataset_id = optional(any)
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
      default_dataset = optional(list(object({
        dataset_id = any
        project_id = any
      })))
      destination_table = optional(list(object({
        kms_key_name = optional(string)
        table_id     = any
        dataset_id   = optional(any)
        project_id   = optional(any)
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
}

variable "routine" {
  type = list(object({
    id              = number
    dataset_id      = any
    definition_body = string
    routine_id      = string
    routine_type    = string
  }))
  default = []
}

variable "table" {
  type = list(object({
    id         = number
    dataset_id = any
    table_id   = string
  }))
  default = []
}

variable "table_iam_member" {
  type = list(object({
    id         = number
    dataset_id = any
    member     = string
    role       = string
    table_id   = any
  }))
  default = []
}
