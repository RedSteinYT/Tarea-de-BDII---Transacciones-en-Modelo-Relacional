-- Limpieza en caso ya existan las tablas
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Job_History CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Employees CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Departments CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Locations CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Countries CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Jobs CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Regions CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- Regions
CREATE TABLE Regions (
  region_id   NUMBER        NOT NULL,
  region_name VARCHAR2(25),
  CONSTRAINT pk_regions PRIMARY KEY (region_id)
);

-- Countries (FK -> Regions)
CREATE TABLE Countries (
  country_id   CHAR(2)       NOT NULL,
  country_name VARCHAR2(40),
  region_id    NUMBER,
  CONSTRAINT pk_countries PRIMARY KEY (country_id),
  CONSTRAINT fk_countries_region FOREIGN KEY (region_id)
    REFERENCES Regions(region_id)
);

-- Locations (FK -> Countries)
CREATE TABLE Locations (
  location_id    NUMBER(4)    NOT NULL,
  street_address VARCHAR2(40),
  postal_code    VARCHAR2(12),
  city           VARCHAR2(30) NOT NULL,
  state_province VARCHAR2(25),
  country_id     CHAR(2),
  CONSTRAINT pk_locations PRIMARY KEY (location_id),
  CONSTRAINT fk_locations_country FOREIGN KEY (country_id)
    REFERENCES Countries(country_id)
);

-- Departments (FK -> Locations)
CREATE TABLE Departments (
  department_id   NUMBER(4)    NOT NULL,
  department_name VARCHAR2(30) NOT NULL,
  manager_id      NUMBER(6),
  location_id     NUMBER(4),
  CONSTRAINT pk_departments PRIMARY KEY (department_id),
  CONSTRAINT fk_departments_location FOREIGN KEY (location_id)
    REFERENCES Locations(location_id)
);

-- Jobs
CREATE TABLE Jobs (
  job_id     VARCHAR2(10)  NOT NULL,
  job_title  VARCHAR2(35)  NOT NULL,
  min_salary NUMBER(6),
  max_salary NUMBER(6),
  CONSTRAINT pk_jobs PRIMARY KEY (job_id)
);

-- Employees (FK -> Jobs, Departments, self manager)
CREATE TABLE Employees (
  employee_id    NUMBER(6)     NOT NULL,
  first_name     VARCHAR2(20),
  last_name      VARCHAR2(25)  NOT NULL,
  email          VARCHAR2(25)  NOT NULL,
  phone_number   VARCHAR2(20),
  hire_date      DATE          NOT NULL,
  job_id         VARCHAR2(10)  NOT NULL,
  salary         NUMBER(8,2),
  commission_pct NUMBER(2,2),
  manager_id     NUMBER(6),
  department_id  NUMBER(4),
  CONSTRAINT pk_employees PRIMARY KEY (employee_id),
  CONSTRAINT uk_employees_email UNIQUE (email),
  CONSTRAINT fk_employees_job FOREIGN KEY (job_id)
    REFERENCES Jobs(job_id),
  CONSTRAINT fk_employees_dept FOREIGN KEY (department_id)
    REFERENCES Departments(department_id),
  CONSTRAINT fk_employees_manager FOREIGN KEY (manager_id)
    REFERENCES Employees(employee_id)
);

-- Job_History (FK -> Employees, Jobs, Departments; check end_date > start_date)
CREATE TABLE Job_History (
  employee_id   NUMBER(6)    NOT NULL,
  start_date    DATE         NOT NULL,
  end_date      DATE         NOT NULL,
  job_id        VARCHAR2(10) NOT NULL,
  department_id NUMBER(4),
  CONSTRAINT pk_job_history PRIMARY KEY (employee_id, start_date),
  CONSTRAINT fk_job_history_emp FOREIGN KEY (employee_id)
    REFERENCES Employees(employee_id),
  CONSTRAINT fk_job_history_job FOREIGN KEY (job_id)
    REFERENCES Jobs(job_id),
  CONSTRAINT fk_job_history_dept FOREIGN KEY (department_id)
    REFERENCES Departments(department_id),
  CONSTRAINT ck_job_history_dates CHECK (end_date > start_date)
);

-- Regions
INSERT INTO Regions VALUES (1, 'Europe');
INSERT INTO Regions VALUES (2, 'Americas');
INSERT INTO Regions VALUES (3, 'Asia');
INSERT INTO Regions VALUES (4, 'Middle East and Africa');
INSERT INTO Regions VALUES (5, 'Oceania');
INSERT INTO Regions VALUES (6, 'Central America');
INSERT INTO Regions VALUES (7, 'Caribbean');
INSERT INTO Regions VALUES (8, 'Eastern Europe');
INSERT INTO Regions VALUES (9, 'Scandinavia');
INSERT INTO Regions VALUES (10, 'North Africa');
INSERT INTO Regions VALUES (11, 'Sub-Saharan Africa');
INSERT INTO Regions VALUES (12, 'Middle Asia');
INSERT INTO Regions VALUES (13, 'South Asia');
INSERT INTO Regions VALUES (14, 'Antarctica');
INSERT INTO Regions VALUES (15, 'Other');

-- Countries
INSERT INTO Countries VALUES ('US', 'United States of America', 2);
INSERT INTO Countries VALUES ('CA', 'Canada', 2);
INSERT INTO Countries VALUES ('UK', 'United Kingdom', 1);
INSERT INTO Countries VALUES ('DE', 'Germany', 1);
INSERT INTO Countries VALUES ('BR', 'Brazil', 2);
INSERT INTO Countries VALUES ('IT', 'Italy', 1);
INSERT INTO Countries VALUES ('JP', 'Japan', 3);
INSERT INTO Countries VALUES ('FR', 'France', 1);
INSERT INTO Countries VALUES ('ES', 'Spain', 1);
INSERT INTO Countries VALUES ('MX', 'Mexico', 2);
INSERT INTO Countries VALUES ('AR', 'Argentina', 2);
INSERT INTO Countries VALUES ('CL', 'Chile', 2);
INSERT INTO Countries VALUES ('CN', 'China', 3);
INSERT INTO Countries VALUES ('IN', 'India', 3);
INSERT INTO Countries VALUES ('EG', 'Egypt', 4);

-- Locations
INSERT INTO Locations VALUES (1000, '1297 Via Cola di Rie', '00989', 'Roma', NULL, 'IT');
INSERT INTO Locations VALUES (1100, '93091 Calle della Testa', '10934', 'Venice', NULL, 'IT');
INSERT INTO Locations VALUES (1200, '2017 Shinjuku-ku', '1689', 'Tokyo', 'Tokyo Prefecture', 'JP');
INSERT INTO Locations VALUES (1300, '9450 Kamiya-cho', '6823', 'Hiroshima', NULL, 'JP');
INSERT INTO Locations VALUES (1400, '2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US');
INSERT INTO Locations VALUES (1500, '2011 Interiors Blvd', '99236', 'South San Francisco', 'California', 'US');
INSERT INTO Locations VALUES (1600, 'Avenida Paulista 1578', '01310', 'São Paulo', 'São Paulo', 'BR');
INSERT INTO Locations VALUES (1700, 'Calle Florida 450', '1005', 'Buenos Aires', 'Buenos Aires', 'AR');
INSERT INTO Locations VALUES (1800, 'Paseo de la Reforma 350', '06500', 'Ciudad de México', 'CDMX', 'MX');
INSERT INTO Locations VALUES (1900, 'Champs-Élysées 50', '75008', 'Paris', 'Île-de-France', 'FR');
INSERT INTO Locations VALUES (2000, 'Gran Vía 12', '28013', 'Madrid', 'Madrid', 'ES');
INSERT INTO Locations VALUES (2100, 'Alexanderplatz 1', '10178', 'Berlin', 'Berlin', 'DE');
INSERT INTO Locations VALUES (2200, 'Oxford Street 200', 'W1D', 'London', 'England', 'UK');
INSERT INTO Locations VALUES (2300, 'Nanjing Road 88', '200001', 'Shanghai', 'Shanghai', 'CN');
INSERT INTO Locations VALUES (2400, 'Connaught Place 10', '110001', 'New Delhi', 'Delhi', 'IN');

-- Departments
INSERT INTO Departments VALUES (10, 'Administration', 200, 1100);
INSERT INTO Departments VALUES (20, 'Marketing', 201, 1200);
INSERT INTO Departments VALUES (30, 'Purchasing', 114, 1400);
INSERT INTO Departments VALUES (40, 'Human Resources', 203, 1200);
INSERT INTO Departments VALUES (50, 'Shipping', 121, 1500);
INSERT INTO Departments VALUES (60, 'IT', 103, 1400);
INSERT INTO Departments VALUES (70, 'Public Relations', 204, 1800);
INSERT INTO Departments VALUES (80, 'Sales', 145, 2500);
INSERT INTO Departments VALUES (90, 'Executive', 100, 1700);
INSERT INTO Departments VALUES (100, 'Finance', 108, 1700);
INSERT INTO Departments VALUES (110, 'Accounting', 205, 1700);
INSERT INTO Departments VALUES (120, 'Legal', 206, 1900);
INSERT INTO Departments VALUES (130, 'Customer Service', 207, 2000);
INSERT INTO Departments VALUES (140, 'Research', 208, 2100);
INSERT INTO Departments VALUES (150, 'Training', 209, 2200);

-- Jobs
INSERT INTO Jobs VALUES ('AD_PRES', 'President', 20000, 40000);
INSERT INTO Jobs VALUES ('AD_VP', 'Administration Vice President', 15000, 30000);
INSERT INTO Jobs VALUES ('IT_PROG', 'Programmer', 4000, 10000);
INSERT INTO Jobs VALUES ('MK_MAN', 'Marketing Manager', 9000, 15000);
INSERT INTO Jobs VALUES ('MK_REP', 'Marketing Representative', 4000, 9000);
INSERT INTO Jobs VALUES ('ST_MAN', 'Stock Manager', 5500, 8500);
INSERT INTO Jobs VALUES ('ST_CLERK', 'Stock Clerk', 2000, 5000);
INSERT INTO Jobs VALUES ('SA_MAN', 'Sales Manager', 10000, 20000);
INSERT INTO Jobs VALUES ('SA_REP', 'Sales Representative', 6000, 12000);
INSERT INTO Jobs VALUES ('HR_REP', 'Human Resources Representative', 4000, 9000);
INSERT INTO Jobs VALUES ('PR_REP', 'Public Relations Representative', 4500, 10500);
INSERT INTO Jobs VALUES ('FI_MGR', 'Finance Manager', 12000, 20000);
INSERT INTO Jobs VALUES ('FI_ACCOUNT', 'Accountant', 4200, 9000);
INSERT INTO Jobs VALUES ('PU_MAN', 'Purchasing Manager', 8000, 15000);
INSERT INTO Jobs VALUES ('PU_CLERK', 'Purchasing Clerk', 2500, 5500);

-- Employees (cuida manager_id y dept FK)
INSERT INTO Employees VALUES (100, 'Steven',   'King',      'SKING',    '515.123.4567', DATE '1987-06-17', 'AD_PRES', 24000, NULL, NULL, 90);
INSERT INTO Employees VALUES (101, 'Neena',    'Kochhar',   'NKOCHHAR', '515.123.4568', DATE '1989-09-21', 'AD_VP',   17000, NULL, 100, 90);
INSERT INTO Employees VALUES (103, 'Alexander','Hunold',    'AHUNOLD',  '590.423.4567', DATE '1990-01-03', 'IT_PROG',  9000, NULL, 101, 60);
INSERT INTO Employees VALUES (201, 'Michael',  'Hartstein', 'MHARTSTE', '515.123.5555', DATE '1996-02-17', 'MK_MAN',  13000, NULL, 100, 20);
INSERT INTO Employees VALUES (202, 'Pat',      'Fay',       'PFAY',     '603.123.6666', DATE '1997-08-17', 'MK_REP',   6000, NULL, 201, 20);
INSERT INTO Employees VALUES (114, 'Den',      'Raphaely',  'DRAPHEAL', '515.127.4561', DATE '1994-12-07', 'PU_MAN',  11000, NULL, 100, 30);
INSERT INTO Employees VALUES (115, 'Alexander','Khoo',      'AKHOO',    '515.127.4562', DATE '1995-05-18', 'PU_CLERK', 3100, NULL, 114, 30);
INSERT INTO Employees VALUES (116, 'Shelli',   'Baida',     'SBAIDA',   '515.127.4563', DATE '1997-12-24', 'PU_CLERK', 2900, NULL, 114, 30);
INSERT INTO Employees VALUES (117, 'Sigal',    'Tobias',    'STOBIAS',  '515.127.4564', DATE '1997-07-24', 'PU_CLERK', 2800, NULL, 114, 30);
INSERT INTO Employees VALUES (118, 'Guy',      'Himuro',    'GHIMURO',  '515.127.4565', DATE '1998-11-15', 'PU_CLERK', 2600, NULL, 114, 30);
INSERT INTO Employees VALUES (119, 'Karen',    'Colmenares','KCOLMENA', '515.127.4566', DATE '1999-08-10', 'PU_CLERK', 2500, NULL, 114, 30);
INSERT INTO Employees VALUES (145, 'John',     'Russell',   'JRUSSEL',  '011.44.1344',  DATE '1996-10-01', 'SA_MAN',  14000, NULL, 100, 80);
INSERT INTO Employees VALUES (146, 'Karen',    'Partners',  'KPARTNER', '011.44.1345',  DATE '1997-01-05', 'SA_REP',   9000, NULL, 145, 80);
INSERT INTO Employees VALUES (147, 'Alberto',  'Errazuriz', 'AERRAZUR', '011.44.1346',  DATE '1997-03-10', 'SA_REP',   8500, NULL, 145, 80);
INSERT INTO Employees VALUES (148, 'Gerald',   'Cambrault', 'GCAMBRAU', '011.44.1347',  DATE '1997-05-15', 'SA_REP',   8000, NULL, 145, 80);

-- Job_History
INSERT INTO Job_History VALUES (101, DATE '1989-09-21', DATE '1993-10-27', 'AD_VP',   90);
INSERT INTO Job_History VALUES (103, DATE '1990-01-03', DATE '1993-01-03', 'IT_PROG', 60);
INSERT INTO Job_History VALUES (114, DATE '1994-12-07', DATE '1997-12-07', 'PU_MAN',  30);
INSERT INTO Job_History VALUES (115, DATE '1995-05-18', DATE '1998-05-18', 'PU_CLERK',30);
INSERT INTO Job_History VALUES (116, DATE '1997-12-24', DATE '2000-12-24', 'PU_CLERK',30);
INSERT INTO Job_History VALUES (117, DATE '1997-07-24', DATE '2000-07-24', 'PU_CLERK',30);
INSERT INTO Job_History VALUES (118, DATE '1998-11-15', DATE '2001-11-15', 'PU_CLERK',30);
INSERT INTO Job_History VALUES (119, DATE '1999-08-10', DATE '2002-08-10', 'PU_CLERK',30);
INSERT INTO Job_History VALUES (145, DATE '1996-10-01', DATE '2000-10-01', 'SA_MAN',  80);
INSERT INTO Job_History VALUES (146, DATE '1997-01-05', DATE '2001-01-05', 'SA_REP',  80);
INSERT INTO Job_History VALUES (147, DATE '1997-03-10', DATE '2001-03-10', 'SA_REP',  80);
INSERT INTO Job_History VALUES (148, DATE '1997-05-15', DATE '2001-05-15', 'SA_REP',  80);
INSERT INTO Job_History VALUES (201, DATE '1996-02-17', DATE '2000-02-17', 'MK_MAN',  20);
INSERT INTO Job_History VALUES (202, DATE '1997-08-17', DATE '2001-08-17', 'MK_REP',  20);
INSERT INTO Job_History VALUES (100, DATE '1987-06-17', DATE '1991-06-17', 'AD_PRES', 90);

-- EJERCICIO 1

BEGIN
  -- 1. Aumentar en un 10% el salario de los empleados del depto 90
  UPDATE Employees
     SET salary = salary * 1.10
   WHERE department_id = 90;

  -- 2. Guardar SAVEPOINT
  SAVEPOINT punto1;

  -- 3. Aumentar en un 5% el salario de los empleados del depto 60
  UPDATE Employees
     SET salary = salary * 1.05
   WHERE department_id = 60;

  -- 4. Rollback parcial al SAVEPOINT
  ROLLBACK TO punto1;

  -- 5. Confirmar cambios
  COMMIT;
END;
/

-- EJERCICIO 2

-- Sesión 1

UPDATE employees
SET salary = salary + 500
WHERE employee_id = 103;

ROLLBACK;

-- Sesión 2

UPDATE employees
SET salary = salary + 500
WHERE employee_id = 103;

-- EJERCICIO 3

SET SERVEROUTPUT ON;

DECLARE
   v_start_date DATE;
   v_job_id     employees.job_id%TYPE;
   v_dept_id    employees.department_id%TYPE;
BEGIN
   -- 1. Obtener datos actuales del empleado 104
   SELECT hire_date, job_id, department_id
     INTO v_start_date, v_job_id, v_dept_id
     FROM employees
    WHERE employee_id = 104;

   -- 2. Actualizar el departamento del empleado 104
   UPDATE employees
      SET department_id = 110
    WHERE employee_id = 104;

   -- 3. Insertar registro en JOB_HISTORY
   INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id)
   VALUES (104, v_start_date, SYSDATE, v_job_id, v_dept_id);

   -- 4. Confirmar cambios
   COMMIT;

   DBMS_OUTPUT.PUT_LINE('Transferencia realizada con éxito.');
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Error en la transferencia: ' || SQLERRM);
END;
/

-- EJERCICIO 4

SET SERVEROUTPUT ON;

BEGIN
   -- 1. Aumentar salario en 8% para depto 100
   UPDATE employees
      SET salary = salary * 1.08
    WHERE department_id = 100;

   SAVEPOINT A;

   -- 2. Aumentar salario en 5% para depto 80
   UPDATE employees
      SET salary = salary * 1.05
    WHERE department_id = 80;

   SAVEPOINT B;

   -- 3. Eliminar empleados del depto 50
   DELETE FROM employees
    WHERE department_id = 50;

   -- 4. Revertir hasta SAVEPOINT B
   ROLLBACK TO B;

   -- 5. Confirmar transacción
   COMMIT;

   DBMS_OUTPUT.PUT_LINE('Transacción completada con SAVEPOINT y ROLLBACK parcial.');
END;
/
