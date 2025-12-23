CREATE TABLE all_scalar_types (
    -- Первичный ключ (обязателен в YDB)
    id              Utf8,

    -- Логический тип
    bool_val        Bool,

    -- Целые числа со знаком
    int8_val        Int8,
    int16_val       Int16,
    int32_val       Int32,
    int64_val       Int64,

    -- Целые числа без знака
    uint8_val       Uint8,
    uint16_val      Uint16,
    uint32_val      Uint32,
    uint64_val      Uint64,

    -- Числа с плавающей точкой
    float_val       Float,
    double_val      Double,

    -- Типы даты и времени
    date_val        Date,
    datetime_val    Datetime,
    timestamp_val   Timestamp,
    --interval_val    Interval,

    -- Строковые и бинарные типы
    string_val      String,   -- байтовая строка (произвольные байты)
    utf8_val        Utf8,     -- текст в UTF-8

    -- JSON (хранится как строка)
    --json_val        Json,

    -- Точный десятичный тип
    decimal_val     Decimal(22, 9),

    PRIMARY KEY (id)
);
