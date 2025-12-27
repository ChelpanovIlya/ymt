--DROP TABLE employe;
CREATE TABLE employe (
    id    	Utf8,
    name    	Utf8,
    job   	Utf8,
    manager_id  Utf8,
    hire_dt 	Date,
    salary 	Decimal(22,9),
    comission 	Decimal(22,9),
    department_id Utf8,
    PRIMARY KEY (id)
);
