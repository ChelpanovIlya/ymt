CREATE TABLE all_dttm_types (
    -- Первичный ключ (обязателен в YDB)
    id              Utf8,
    tag             Utf8,

    -- Типы даты и времени
    date_val        Date,
    datetime_val    Datetime,
    timestamp_val   Timestamp,
    --interval_val    Interval,

    PRIMARY KEY (id)
);
