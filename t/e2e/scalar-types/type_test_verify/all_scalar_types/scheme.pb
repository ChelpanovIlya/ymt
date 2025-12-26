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
  name: "bool_val"
  type {
    optional_type {
      item {
        type_id: BOOL
      }
    }
  }
}
columns {
  name: "int8_val"
  type {
    optional_type {
      item {
        type_id: INT8
      }
    }
  }
}
columns {
  name: "int16_val"
  type {
    optional_type {
      item {
        type_id: INT16
      }
    }
  }
}
columns {
  name: "int32_val"
  type {
    optional_type {
      item {
        type_id: INT32
      }
    }
  }
}
columns {
  name: "int64_val"
  type {
    optional_type {
      item {
        type_id: INT64
      }
    }
  }
}
columns {
  name: "uint8_val"
  type {
    optional_type {
      item {
        type_id: UINT8
      }
    }
  }
}
columns {
  name: "uint16_val"
  type {
    optional_type {
      item {
        type_id: UINT16
      }
    }
  }
}
columns {
  name: "uint32_val"
  type {
    optional_type {
      item {
        type_id: UINT32
      }
    }
  }
}
columns {
  name: "uint64_val"
  type {
    optional_type {
      item {
        type_id: UINT64
      }
    }
  }
}
columns {
  name: "float_val"
  type {
    optional_type {
      item {
        type_id: FLOAT
      }
    }
  }
}
columns {
  name: "double_val"
  type {
    optional_type {
      item {
        type_id: DOUBLE
      }
    }
  }
}
columns {
  name: "date_val"
  type {
    optional_type {
      item {
        type_id: DATE
      }
    }
  }
}
columns {
  name: "datetime_val"
  type {
    optional_type {
      item {
        type_id: DATETIME
      }
    }
  }
}
columns {
  name: "timestamp_val"
  type {
    optional_type {
      item {
        type_id: TIMESTAMP
      }
    }
  }
}
columns {
  name: "string_val"
  type {
    optional_type {
      item {
        type_id: STRING
      }
    }
  }
}
columns {
  name: "utf8_val"
  type {
    optional_type {
      item {
        type_id: UTF8
      }
    }
  }
}
columns {
  name: "decimal_val"
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
