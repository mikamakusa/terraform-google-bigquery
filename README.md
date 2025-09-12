## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.40.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 7.2.0 |

## Modules

No modules.

## Examples
```hcl
module "bigquery" {
  source     = "."
  project_id = "bq-project-1"
  datasets = [{
    id                          = "example_dataset"
    friendly_name               = "test"
    description                 = "This is a test description"
    location                    = "EU"
    default_table_expiration_ms = 3600000
    dataset_accesses = [{
      role = "OWNER"
    }]
    routines = [{
      id           = "public_routine"
      routine_type = "TABLE_VALUED_FUNCTION"
      language     = "SQL"
    }]
    jobs = [{
      id = "job_q_1"
    }]
  }]
  arguments = {
    name          = "value"
    argument_kind = "FIXED_TYPE"
    data_type     = jsonencode({ "typeKind" = "INT64" })
  }
  query = {
    query               = "SELECT state FROM [lookerdata:cdc.project_tycho_reports]"
    allow_large_results = true
    flatten_results     = true
  }
}
```

## Resources

| Name | Type |
|------|------|
| [google_bigquery_dataset.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset) | resource |
| [google_bigquery_dataset_access.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset_access) | resource |
| [google_bigquery_dataset_iam_policy.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset_iam_policy) | resource |
| [google_bigquery_job.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_job) | resource |
| [google_bigquery_routine.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_routine) | resource |
| [google_bigquery_table.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_table) | resource |
| [google_project.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access"></a> [access](#input\_access) | n/a | <pre>object({<br/>    domain         = optional(string)<br/>    group_by_email = optional(string)<br/>    special_group  = optional(string)<br/>    user_by_email  = optional(string)<br/>    iam_member     = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_arguments"></a> [arguments](#input\_arguments) | n/a | <pre>object({<br/>    name          = optional(string)<br/>    argument_kind = optional(string)<br/>    data_type     = optional(string)<br/>    mode          = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_biglake_configuration"></a> [biglake\_configuration](#input\_biglake\_configuration) | n/a | <pre>object({<br/>    connection_id = string<br/>    file_format   = string<br/>    storage_uri   = string<br/>    table_format  = string<br/>  })</pre> | `null` | no |
| <a name="input_copy"></a> [copy](#input\_copy) | n/a | <pre>object({<br/>    create_disposition = optional(string)<br/>    write_disposition  = optional(string)<br/>    source_table_id    = string<br/>    source_project_id  = optional(string)<br/>    source_dataset_id  = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_datasets"></a> [datasets](#input\_datasets) | n/a | <pre>list(object({<br/>    id                              = string<br/>    max_time_travel_hours           = optional(string)<br/>    default_partition_expiration_ms = optional(number)<br/>    default_table_expiration_ms     = optional(number)<br/>    description                     = optional(string)<br/>    friendly_name                   = optional(string)<br/>    labels                          = optional(map(string))<br/>    location                        = optional(string)<br/>    is_case_insensitive             = optional(bool)<br/>    default_collation               = optional(string)<br/>    storage_billing_model           = optional(string)<br/>    resource_tags                   = optional(map(string))<br/>    delete_contents_on_destroy      = optional(bool)<br/>    policy_data                     = optional(string)<br/>    dataset_accesses = optional(list(object({<br/>      role           = optional(string)<br/>      user_by_email  = optional(string)<br/>      group_by_email = optional(string)<br/>      domain         = optional(string)<br/>      special_group  = optional(string)<br/>      iam_member     = optional(string)<br/>    })))<br/>    routines = optional(list(object({<br/>      definition_body      = string<br/>      routine_id           = string<br/>      routine_type         = string<br/>      language             = optional(string)<br/>      return_type          = optional(string)<br/>      return_table_type    = optional(string)<br/>      data_governance_type = optional(string)<br/>      description          = optional(string)<br/>      determinism_level    = optional(string)<br/>      security_mode        = optional(string)<br/>    })))<br/>    tables = optional(list(object({<br/>      id                       = string<br/>      deletion_protection      = optional(bool)<br/>      clustering               = optional(list(string))<br/>      description              = optional(string)<br/>      expiration_time          = optional(number)<br/>      friendly_name            = optional(string)<br/>      labels                   = optional(map(string))<br/>      max_staleness            = optional(string)<br/>      require_partition_filter = optional(bool)<br/>      resource_tags            = optional(map(string))<br/>      schema                   = optional(string)<br/>      table_metadata_view      = optional(string)<br/>    })))<br/>  }))</pre> | n/a | yes |
| <a name="input_default_encryption_configuration"></a> [default\_encryption\_configuration](#input\_default\_encryption\_configuration) | n/a | <pre>object({<br/>    kms_key_name = string<br/>  })</pre> | `null` | no |
| <a name="input_encryption_configuration"></a> [encryption\_configuration](#input\_encryption\_configuration) | n/a | <pre>object({<br/>    kms_key_name = string<br/>  })</pre> | `null` | no |
| <a name="input_external_catalog_dataset_options"></a> [external\_catalog\_dataset\_options](#input\_external\_catalog\_dataset\_options) | n/a | <pre>object({<br/>    parameters                   = optional(map(string))<br/>    default_storage_location_uri = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_external_catalog_table_options"></a> [external\_catalog\_table\_options](#input\_external\_catalog\_table\_options) | n/a | <pre>object({<br/>    parameters    = optional(map(string))<br/>    connection_id = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_external_data_configuration"></a> [external\_data\_configuration](#input\_external\_data\_configuration) | n/a | <pre>object({<br/>    autodetect                = bool<br/>    source_uris               = list(string)<br/>    compression               = optional(string)<br/>    connection_id             = optional(string)<br/>    file_set_spec_type        = optional(string)<br/>    ignore_unknown_values     = optional(bool)<br/>    json_extension            = optional(string)<br/>    max_bad_records           = optional(number)<br/>    metadata_cache_mode       = optional(string)<br/>    object_metadata           = optional(string)<br/>    reference_file_schema_uri = optional(string)<br/>    schema                    = optional(string)<br/>    source_format             = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_external_dataset_reference"></a> [external\_dataset\_reference](#input\_external\_dataset\_reference) | n/a | <pre>object({<br/>    connection      = string<br/>    external_source = string<br/>  })</pre> | `null` | no |
| <a name="input_extract"></a> [extract](#input\_extract) | n/a | <pre>object({<br/>    destination_uris       = list(string)<br/>    print_header           = optional(bool)<br/>    field_delimiter        = optional(string)<br/>    destination_format     = optional(string)<br/>    use_avro_logical_types = optional(bool)<br/>    compression            = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_jobs"></a> [jobs](#input\_jobs) | n/a | <pre>list(object({<br/>    id             = string<br/>    job_timeout_ms = optional(string)<br/>    project        = optional(string)<br/>    labels         = optional(map(string))<br/>    location       = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | n/a | `map(string)` | `{}` | no |
| <a name="input_load"></a> [load](#input\_load) | n/a | <pre>object({<br/>    source_uris            = list(string)<br/>    allow_jagged_rows      = optional(bool)<br/>    allow_quoted_newlines  = optional(bool)<br/>    autodetect             = optional(bool)<br/>    create_disposition     = optional(string)<br/>    encoding               = optional(string)<br/>    field_delimiter        = optional(string)<br/>    ignore_unknown_values  = optional(bool)<br/>    json_extension         = optional(string)<br/>    max_bad_records        = optional(number)<br/>    null_marker            = optional(string)<br/>    projection_fields      = optional(list(string))<br/>    quote                  = optional(string)<br/>    schema_update_options  = optional(list(string))<br/>    skip_leading_rows      = optional(number)<br/>    source_format          = optional(string)<br/>    write_disposition      = optional(string)<br/>    destination_table_id   = string<br/>    destination_project_id = optional(string)<br/>    destination_dataset_id = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_materialized_view"></a> [materialized\_view](#input\_materialized\_view) | n/a | <pre>object({<br/>    query                            = string<br/>    allow_non_incremental_definition = optional(bool)<br/>    enable_refresh                   = optional(bool)<br/>    refresh_interval_ms              = optional(number)<br/>  })</pre> | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | n/a | yes |
| <a name="input_query"></a> [query](#input\_query) | n/a | <pre>object({<br/>    query                 = string<br/>    create_disposition    = optional(string)<br/>    write_disposition     = optional(string)<br/>    allow_large_results   = optional(bool)<br/>    priority              = optional(string)<br/>    maximum_bytes_billed  = optional(string)<br/>    parameter_mode        = optional(string)<br/>    schema_update_options = optional(list(string))<br/>    use_legacy_sql        = optional(bool)<br/>    use_query_cache       = optional(bool)<br/>    flatten_results       = optional(bool)<br/>    maximum_billing_tier  = optional(number)<br/>  })</pre> | `null` | no |
| <a name="input_range_partitioning"></a> [range\_partitioning](#input\_range\_partitioning) | n/a | <pre>object({<br/>    field          = string<br/>    range_end      = number<br/>    range_interval = number<br/>    range_start    = number<br/>  })</pre> | `null` | no |
| <a name="input_remote_function_options"></a> [remote\_function\_options](#input\_remote\_function\_options) | n/a | <pre>object({<br/>    connection           = optional(string)<br/>    endpoint             = optional(string)<br/>    max_batching_rows    = optional(string)<br/>    user_defined_context = optional(map(string))<br/>  })</pre> | `null` | no |
| <a name="input_schema_foreign_type_info"></a> [schema\_foreign\_type\_info](#input\_schema\_foreign\_type\_info) | n/a | <pre>object({<br/>    type_system = string<br/>  })</pre> | `null` | no |
| <a name="input_spark_options"></a> [spark\_options](#input\_spark\_options) | n/a | <pre>object({<br/>    archive_uris    = optional(list(string))<br/>    connection      = optional(string)<br/>    container_image = optional(string)<br/>    file_uris       = optional(list(string))<br/>    jar_uris        = optional(list(string))<br/>    main_class      = optional(string)<br/>    main_file_uri   = optional(string)<br/>    properties      = optional(map(string))<br/>    py_file_uris    = optional(list(string))<br/>    runtime_version = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_table_replication_info"></a> [table\_replication\_info](#input\_table\_replication\_info) | n/a | <pre>object({<br/>    source_dataset_id       = string<br/>    source_project_id       = string<br/>    source_table_id         = string<br/>    replication_interval_ms = optional(number)<br/>  })</pre> | `null` | no |
| <a name="input_time_partitioning"></a> [time\_partitioning](#input\_time\_partitioning) | n/a | <pre>object({<br/>    type          = string<br/>    field         = optional(string)<br/>    expiration_ms = optional(number)<br/>  })</pre> | `null` | no |
| <a name="input_view"></a> [view](#input\_view) | n/a | <pre>object({<br/>    query          = string<br/>    use_legacy_sql = optional(bool)<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dataset_accesses"></a> [dataset\_accesses](#output\_dataset\_accesses) | n/a |
| <a name="output_dataset_iam_policies"></a> [dataset\_iam\_policies](#output\_dataset\_iam\_policies) | n/a |
| <a name="output_datasets"></a> [datasets](#output\_datasets) | n/a |
| <a name="output_jobs"></a> [jobs](#output\_jobs) | n/a |
| <a name="output_routines"></a> [routines](#output\_routines) | n/a |
| <a name="output_tables"></a> [tables](#output\_tables) | n/a |
