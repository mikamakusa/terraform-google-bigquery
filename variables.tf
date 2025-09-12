variable "labels" {
  type    = map(string)
  default = {}
}

variable "project_id" {
  type = string
}

variable "datasets" {
  type = list(object({
    id                              = string
    max_time_travel_hours           = optional(string)
    default_partition_expiration_ms = optional(number)
    default_table_expiration_ms     = optional(number)
    description                     = optional(string)
    friendly_name                   = optional(string)
    labels                          = optional(map(string))
    location                        = optional(string)
    is_case_insensitive             = optional(bool)
    default_collation               = optional(string)
    storage_billing_model           = optional(string)
    resource_tags                   = optional(map(string))
    delete_contents_on_destroy      = optional(bool)
    policy_data                     = optional(string)
    dataset_accesses = optional(list(object({
      role           = optional(string)
      user_by_email  = optional(string)
      group_by_email = optional(string)
      domain         = optional(string)
      special_group  = optional(string)
      iam_member     = optional(string)
    })))
    routines = optional(list(object({
      definition_body      = string
      routine_id           = string
      routine_type         = string
      language             = optional(string)
      return_type          = optional(string)
      return_table_type    = optional(string)
      data_governance_type = optional(string)
      description          = optional(string)
      determinism_level    = optional(string)
      security_mode        = optional(string)
    })))
    tables = optional(list(object({
      id                       = string
      deletion_protection      = optional(bool)
      clustering               = optional(list(string))
      description              = optional(string)
      expiration_time          = optional(number)
      friendly_name            = optional(string)
      labels                   = optional(map(string))
      max_staleness            = optional(string)
      require_partition_filter = optional(bool)
      resource_tags            = optional(map(string))
      schema                   = optional(string)
      table_metadata_view      = optional(string)
    })))
  }))
}

variable "jobs" {
  type = list(object({
    id             = string
    job_timeout_ms = optional(string)
    project        = optional(string)
    labels         = optional(map(string))
    location       = optional(string)
  }))
  default = []
}

variable "access" {
  type = object({
    domain         = optional(string)
    group_by_email = optional(string)
    special_group  = optional(string)
    user_by_email  = optional(string)
    iam_member     = optional(string)
  })
  default = null
}

variable "default_encryption_configuration" {
  type = object({
    kms_key_name = string
  })
  default = null
}

variable "external_catalog_dataset_options" {
  type = object({
    parameters                   = optional(map(string))
    default_storage_location_uri = optional(string)
  })
  default = null
}

variable "external_dataset_reference" {
  type = object({
    connection      = string
    external_source = string
  })
  default = null
}

variable "query" {
  type = object({
    query                 = string
    create_disposition    = optional(string)
    write_disposition     = optional(string)
    allow_large_results   = optional(bool)
    priority              = optional(string)
    maximum_bytes_billed  = optional(string)
    parameter_mode        = optional(string)
    schema_update_options = optional(list(string))
    use_legacy_sql        = optional(bool)
    use_query_cache       = optional(bool)
    flatten_results       = optional(bool)
    maximum_billing_tier  = optional(number)
  })
  default = null
}

variable "load" {
  type = object({
    source_uris            = list(string)
    allow_jagged_rows      = optional(bool)
    allow_quoted_newlines  = optional(bool)
    autodetect             = optional(bool)
    create_disposition     = optional(string)
    encoding               = optional(string)
    field_delimiter        = optional(string)
    ignore_unknown_values  = optional(bool)
    json_extension         = optional(string)
    max_bad_records        = optional(number)
    null_marker            = optional(string)
    projection_fields      = optional(list(string))
    quote                  = optional(string)
    schema_update_options  = optional(list(string))
    skip_leading_rows      = optional(number)
    source_format          = optional(string)
    write_disposition      = optional(string)
    destination_table_id   = string
    destination_project_id = optional(string)
    destination_dataset_id = optional(string)
  })
  default = null
}

variable "copy" {
  type = object({
    create_disposition = optional(string)
    write_disposition  = optional(string)
    source_table_id    = string
    source_project_id  = optional(string)
    source_dataset_id  = optional(string)
  })
  default = null
}

variable "extract" {
  type = object({
    destination_uris       = list(string)
    print_header           = optional(bool)
    field_delimiter        = optional(string)
    destination_format     = optional(string)
    use_avro_logical_types = optional(bool)
    compression            = optional(string)
  })
  default = null
}

variable "arguments" {
  type = object({
    name          = optional(string)
    argument_kind = optional(string)
    data_type     = optional(string)
    mode          = optional(string)
  })
  default = null
}

variable "remote_function_options" {
  type = object({
    connection           = optional(string)
    endpoint             = optional(string)
    max_batching_rows    = optional(string)
    user_defined_context = optional(map(string))
  })
  default = null
}

variable "spark_options" {
  type = object({
    archive_uris    = optional(list(string))
    connection      = optional(string)
    container_image = optional(string)
    file_uris       = optional(list(string))
    jar_uris        = optional(list(string))
    main_class      = optional(string)
    main_file_uri   = optional(string)
    properties      = optional(map(string))
    py_file_uris    = optional(list(string))
    runtime_version = optional(string)
  })
  default = null
}

variable "biglake_configuration" {
  type = object({
    connection_id = string
    file_format   = string
    storage_uri   = string
    table_format  = string
  })
  default = null
}

variable "encryption_configuration" {
  type = object({
    kms_key_name = string
  })
  default = null
}

variable "external_catalog_table_options" {
  type = object({
    parameters    = optional(map(string))
    connection_id = optional(string)
  })
  default = null
}

variable "external_data_configuration" {
  type = object({
    autodetect                = bool
    source_uris               = list(string)
    compression               = optional(string)
    connection_id             = optional(string)
    file_set_spec_type        = optional(string)
    ignore_unknown_values     = optional(bool)
    json_extension            = optional(string)
    max_bad_records           = optional(number)
    metadata_cache_mode       = optional(string)
    object_metadata           = optional(string)
    reference_file_schema_uri = optional(string)
    schema                    = optional(string)
    source_format             = optional(string)
  })
  default = null
}

variable "materialized_view" {
  type = object({
    query                            = string
    allow_non_incremental_definition = optional(bool)
    enable_refresh                   = optional(bool)
    refresh_interval_ms              = optional(number)
  })
  default = null
}

variable "range_partitioning" {
  type = object({
    field          = string
    range_end      = number
    range_interval = number
    range_start    = number
  })
  default = null
}

variable "schema_foreign_type_info" {
  type = object({
    type_system = string
  })
  default = null
}

/*variable "table_constraints" {
  type    = list(object({}))
  default = null
}*/

variable "table_replication_info" {
  type = object({
    source_dataset_id       = string
    source_project_id       = string
    source_table_id         = string
    replication_interval_ms = optional(number)
  })
  default = null
}

variable "time_partitioning" {
  type = object({
    type          = string
    field         = optional(string)
    expiration_ms = optional(number)
  })
  default = null
}

variable "view" {
  type = object({
    query          = string
    use_legacy_sql = optional(bool)
  })
  default = null
}
