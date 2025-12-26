CREATE TABLE countries (
    alpha2    Utf8,
    alpha3    Utf8,
    numeric   Uint16,
    name_en   Utf8,
    name_ru   Utf8,
    is_active Bool DEFAULT true,
    PRIMARY KEY (alpha2)
);
