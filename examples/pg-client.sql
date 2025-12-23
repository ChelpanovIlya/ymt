CREATE TABLE IF NOT EXISTS client (
    id        SERIAL PRIMARY KEY,
    inn       VARCHAR(12),
    full_name TEXT
);

INSERT INTO client (inn, full_name) values('1111111111','ООО "Ромашка"');
INSERT INTO client (inn, full_name) values('2222222222','ООО "Гвоздика"');
