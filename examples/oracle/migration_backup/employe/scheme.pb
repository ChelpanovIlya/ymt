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
  name: "name"
  type {
    optional_type {
      item {
        type_id: UTF8
      }
    }
  }
}
columns {
  name: "job"
  type {
    optional_type {
      item {
        type_id: UTF8
      }
    }
  }
}
columns {
  name: "manager_id"
  type {
    optional_type {
      item {
        type_id: UTF8
      }
    }
  }
}
columns {
  name: "hire_dt"
  type {
    optional_type {
      item {
        type_id: DATE
      }
    }
  }
}
columns {
  name: "salary"
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
  name: "comission"
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
  name: "department_id"
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
