DROP TABLE all_dttm_types;
CREATE TABLE all_dttm_types
 (
    -- Первичный ключ
    id              TEXT PRIMARY KEY,
    tag             TEXT,

    -- Дата и время
    date_val        DATE,
    datetime_val    TIMESTAMP WITHOUT TIME ZONE,
    timestamp_val   TIMESTAMP WITHOUT TIME ZONE
    --interval_val    INTERVAL,
);
