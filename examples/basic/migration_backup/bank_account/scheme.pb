columns {
  name: "id"
  type {
    optional_type {
      item {
        type_id: UTF8
      }
    }
  }
}
columns {
  name: "client_id"
  type {
    optional_type {
      item {
        type_id: UTF8
      }
    }
  }
}
columns {
  name: "account_number"
  type {
    optional_type {
      item {
        type_id: UTF8
      }
    }
  }
}
columns {
  name: "currency"
  type {
    optional_type {
      item {
        type_id: UTF8
      }
    }
  }
}
columns {
  name: "balance"
  type {
    optional_type {
      item {
        decimal_type {
          precision: 22
          scale: 9
        }
      }
    }
  }
}
columns {
  name: "opened_at"
  type {
    optional_type {
      item {
        type_id: TIMESTAMP
      }
    }
  }
}
primary_key: "id"
storage_settings {
  store_external_blobs: DISABLED
}
column_families {
  name: "default"
  compression: COMPRESSION_NONE
}
partitioning_settings {
  partitioning_by_size: ENABLED
  partition_size_mb: 2048
  partitioning_by_load: DISABLED
  min_partitions_count: 1
}
