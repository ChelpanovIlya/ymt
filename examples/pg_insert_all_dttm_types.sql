INSERT INTO all_dttm_types (
    id,
    tag,
    date_val, datetime_val, timestamp_val --interval_val,
) VALUES (
    'all_dttm_types',
    'PG',

    -- Date/Time
    '2025-12-25'::DATE,                         -- макс. для 32-битного дня
    '2025-12-25 09:12:34'::TIMESTAMP,           -- Unix timestamp limit
    '2025-12-25 09:12:34.123456'::TIMESTAMP
);
