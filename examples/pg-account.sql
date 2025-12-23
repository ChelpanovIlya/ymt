CREATE TABLE account (
    id              SERIAL PRIMARY KEY,
    client_id       INTEGER NOT NULL,
    account_number  VARCHAR(20) NOT NULL UNIQUE,
    currency        CHAR(3) NOT NULL DEFAULT 'RUB',
    balance         NUMERIC(19,2) NOT NULL DEFAULT 0,
    opened_at       TIMESTAMP NOT NULL DEFAULT NOW(),
    
    FOREIGN KEY (client_id) REFERENCES client(id) ON DELETE CASCADE
);
INSERT INTO account (client_id, account_number, currency, balance)
VALUES (1, '40702810123450000001', 'RUB', 150000.00);
INSERT INTO account (client_id, account_number, currency, balance)
VALUES (2, '40702810123450000002', 'RUB', 200000.00);
