DROP TABLE all_scalar_types;
CREATE TABLE all_scalar_types
 (
    -- Первичный ключ
    id              TEXT PRIMARY KEY,

    -- Логический тип
    bool_val        BOOLEAN,

    -- Целые со знаком
    int8_val        SMALLINT,    -- YDB Int8   → PG: -128..127
    int16_val       SMALLINT,    -- YDB Int16  → PG: -32768..32767
    int32_val       INTEGER,     -- YDB Int32  → PG: -2^31..2^31-1
    int64_val       BIGINT,      -- YDB Int64  → PG: -2^63..2^63-1

    -- Целые без знака (PostgreSQL не имеет native unsigned, используем больший signed)
    uint8_val       SMALLINT,    -- 0..255
    uint16_val      INTEGER,     -- 0..65535
    uint32_val      BIGINT,      -- 0..4294967295
    uint64_val      NUMERIC(20,0), -- 0..18446744073709551615

    -- Вещественные
    float_val       REAL,        -- 4 байта
    double_val      DOUBLE PRECISION, -- 8 байт

    -- Дата и время
    date_val        DATE,
    datetime_val    TIMESTAMP WITHOUT TIME ZONE,
    timestamp_val   TIMESTAMP WITHOUT TIME ZONE,
    --interval_val    INTERVAL,

    -- Бинарные и текстовые
    string_val      BYTEA,       -- произвольные байты
    utf8_val        TEXT,        -- UTF-8 текст

    -- JSON
    --json_val        JSON,

    -- Точные числа
    decimal_val     NUMERIC(22,9)
);
