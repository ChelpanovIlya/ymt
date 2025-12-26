CREATE TABLE bank_account (
    id              Utf8,
    client_id       Utf8,
    account_number  Utf8,
    currency        Utf8,
    balance         Decimal(22, 9),
    opened_at       Timestamp,
    PRIMARY KEY (id)
);

