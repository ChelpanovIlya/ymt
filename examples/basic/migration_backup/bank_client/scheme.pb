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
  name: "inn"
  type {
    optional_type {
      item {
        type_id: UTF8
      }
    }
  }
}
columns {
  name: "name"
  type {
    optional_type {
      item {
        type_id: UTF8
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
