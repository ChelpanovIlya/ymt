INSERT INTO all_scalar_types (
    id,
    bool_val,
    int8_val, int16_val, int32_val, int64_val,
    uint8_val, uint16_val, uint32_val, uint64_val,
    float_val, double_val,
    date_val, datetime_val, timestamp_val, --interval_val,
    string_val,
    utf8_val,
    --json_val,
    decimal_val
) VALUES (
    'max-values-row',

    -- Bool
    false,

    -- Signed integers (max)
    127,                          -- Int8
    32767,                        -- Int16
    2147483647,                   -- Int32
    9223372036854775807,          -- Int64

    -- Unsigned integers (max)
    255,                          -- Uint8
    65535,                        -- Uint16
    4294967295,                   -- Uint32
    18446744073709551615,         -- Uint64

    -- Float/Double
    --'Infinity'::REAL,             -- или 3.40282347e+38
    --'Infinity'::DOUBLE PRECISION, -- или 1.7976931348623157e+308
    3.40282346e+38,
    1.7976931348623156e+307,

    -- Date/Time
    '2105-12-31'::DATE,                         -- макс. для 32-битного дня
    '2038-01-19 03:14:07'::TIMESTAMP,           -- Unix timestamp limit
    '2038-01-19 03:14:07.999999'::TIMESTAMP,
    --'9223372036854775807 microseconds'::INTERVAL,

    -- String: все байты 0-255 → BYTEA
    '\x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff'::BYTEA,

    -- Utf8: ASCII 0-127 + русские буквы
    E'\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3a\x3b\x3c\x3d\x3e\x3f\x40\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5a\x5b\x5c\x5d\x5e\x5f\x60\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6a\x6b\x6c\x6d\x6e\x6f\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7a\x7b\x7c\x7d\x7e\x7fабвгдежзийклмнопрстуфхцчшщъыьэюяАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ',

    -- JSON
    --'{}'::JSON,

    -- Decimal
    '9999999999999.999999999'::NUMERIC(22,9)
);
