run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

run "create_dataset" {
  command = [plan,apply]

  variables {
    dataset = [
      {
        id                          = 0
        dataset_id                  = "example_dataset_1"
        friendly_name               = "test-1"
        description                 = "This is a test description"
        location                    = "EU"
        default_table_expiration_ms = 3600000
        labels = {
          env = "default"
        }
      },
      {
        id                          = 1
        dataset_id                  = "example_dataset_2"
        friendly_name               = "test-2"
        description                 = "This is a test description"
        location                    = "EU"
        default_table_expiration_ms = 3600000
        labels = {
          env = "secondary"
        }
      }
    ]
    table = [
      {
        id                  = 0
        deletion_protection = false
        dataset_id          = 0
        table_id            = "example_table"

        view = [
          {
            query          = "SELECT state FROM [lookerdata:cdc.project_tycho_reports]"
            use_legacy_sql = false
          }
        ]
      }
    ]
    dataset_access = [
      {
        id            = 0
        dataset_id    = 0
        view = [
          {
            dataset_id = 0
            table_id   = 0
          }
        ]
      }
    ]
    routine = [
      {
        id              = 0
        dataset_id      = 0
        routine_id      = "public_routine"
        routine_type    = "TABLE_VALUED_FUNCTION"
        language        = "SQL"
        arguments = [
          {
            name          = "value"
            argument_kind = "FIXED_TYPE"
          }
        ]
      }
    ]
    connection = [
      {
        id            = 0
        connection_id = "my-connection"
        location      = "aws-us-east-1"
        description   = "a riveting description"
        iam_role_id   = "arn:aws:iam::999999999999:role/omnirole"
      },
      {
        id            = 1
        connection_id = "my-connection"
        location      = "azure-eastus2"
        description   = "a riveting description"
        azure = [
          {
            customer_tenant_id              = "customer-tenant-id"
            federated_application_client_id = "b43eeeee-eeee-eeee-eeee-a480155501ce"
          }
        ]
      }
    ]
  }
}