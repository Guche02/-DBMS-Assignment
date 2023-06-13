CREATE DATABASE db_Employee;

CREATE TABLE
    tbl_Employee (
        employee_name VARCHAR(255) NOT NULL,
        street VARCHAR(255) NOT NULL,
        city VARCHAR(255) NOT NULL,
        PRIMARY KEY(employee_name)
    );
 
 
CREATE TABLE
    tbl_Works (
        employee_name VARCHAR(255) NOT NULL,
        FOREIGN KEY (employee_name) REFERENCES tbl_Employee(employee_name),
        company_name VARCHAR(255),
        salary DECIMAL(10, 2)
    );
 
CREATE TABLE
    tbl_Company (
        company_name VARCHAR(255) NOT NULL,
        city VARCHAR(255),
        PRIMARY KEY(company_name)
    );
 
CREATE TABLE
    tbl_Manages (
        employee_name VARCHAR(255) NOT NULL,
        FOREIGN KEY (employee_name) REFERENCES tbl_Employee(employee_name),
        manager_name VARCHAR(255)
    );
 
INSERT INTO
    tbl_Employee (employee_name, street, city)
VALUES (
        'Alice Williams',
        '321 Maple St',
        'Houston'
    ), (
        'Sara Davis',
        '159 Broadway',
        'New York'
    ), (
        'Mark Thompson',
        '235 Fifth Ave',
        'New York'
    ), (
        'Ashley Johnson',
        '876 Market St',
        'Chicago'
    ), (
        'Emily Williams',
        '741 First St',
        'Los Angeles'
    ), (
        'Michael Brown',
        '902 Main St',
        'Houston'
    ), (
        'Samantha Smith',
        '111 Second St',
        'Chicago'
    );
 
INSERT INTO
    tbl_Employee (employee_name, street, city)
VALUES (
        'Patrick',
        '123 Main St',
        'New Mexico'
    );

INSERT INTO
    tbl_Employee (employee_name, street, city)
VALUES (
        'John Smith',
        '123 Main St',
        'New Mexico'
    );
 
INSERT INTO
    tbl_Works (
        employee_name,
        company_name,
        salary
    )
VALUES (
        'Patrick',
        'Pongyang Corporation',
        500000
    );
 
 
INSERT INTO
    tbl_Works (
        employee_name,
        company_name,
        salary
    )
VALUES (
        'John Smith',
        'First Bank Corporation',
        500000
    );

INSERT INTO
    tbl_Works (
        employee_name,
        company_name,
        salary
    )
VALUES (
        'Sara Davis',
        'First Bank Corporation',
        82500.00
    ), (
        'Mark Thompson',
        'Small Bank Corporation',
        78000.00
    ), (
        'Ashley Johnson',
        'Small Bank Corporation',
        92000.00
    ), (
        'Emily Williams',
        'Small Bank Corporation',
        86500.00
    ), (
        'Michael Brown',
        'Small Bank Corporation',
        81000.00
    ), (
        'Samantha Smith',
        'Small Bank Corporation',
        77000.00
    );
 
INSERT INTO
    tbl_Company (company_name, city)
VALUES (
        'Small Bank Corporation', 'Chicago'), 
        ('ABC Inc', 'Los Angeles'), 
        ('Def Co', 'Houston'), 
        ('First Bank Corporation','New York'), 
        ('456 Corp', 'Chicago'), 
        ('789 Inc', 'Los Angeles'), 
        ('321 Co', 'Houston'),
        ('Pongyang Corporation','Chicago'
    );
 
INSERT INTO
    tbl_Manages(employee_name, manager_name)
VALUES 
    ('Mark Thompson', 'Emily Williams'),
    ('Michael Brown', 'Jane Doe'),
    ('Alice Williams', 'Emily Williams'),
    ('Samantha Smith', 'Sara Davis'),
    ('Patrick', 'Jane Doe');
 
SELECT * FROM tbl_Employee;
SELECT * FROM tbl_Works;
SELECT * FROM tbl_Manages;
SELECT * FROM tbl_Company;
 
-- Update the value of salary to 1000 where employee name= John Smith and company_name = First Bank Corporation
UPDATE tbl_Works
SET salary = '1000'
WHERE
    employee_name = 'John Smith'
AND company_name = 'First Bank Corporation';


--2.a) Names of all employee who work for first bank corporation
SELECT employee_name FROM tbl_Works
WHERE company_name = 'First Bank Corporation';

--2.b) Names and Cities of residence of all employees who work for first bank corporation 
SELECT employee_name,city FROM tbl_Employee
WHERE employee_name IN (SELECT employee_name FROM tbl_Works 
WHERE company_name = 'First Bank Corporation');

--2.c) Names, Street Addresses and cities of residence of all employees who work for first bank corporation and earn more than $10,0000
SELECT employee_name,street,city FROM tbl_Employee
WHERE employee_name IN (SELECT employee_name FROM tbl_Works
WHERE company_name = 'First Bank Corporation' AND salary > 10000);

--2.d) Employees who live in the same cities as the companies for which they work.
SELECT tbl_employee.employee_name FROM tbl_Employee,tbl_Company,tbl_works
WHERE tbl_Employee.city = tbl_Company.city
AND  tbl_works.company_name = tbl_Company.company_name
AND  tbl_Employee.employee_name = tbl_Works.employee_name

--2.e) Employees who live in same cities and streets as do their managers
SELECT s.employee_name,s.city,s.street,e.employee_name AS manager,e.street AS manager street 
FROM tbl_employee s join tbl_Manages on 
s.employee_name =tbl_manages.employee_name
join tbl_employee e on e.employee_name =tbl_manages.manager_name
where s.city= e.city
and s.street=e.street

--2.f) Employees who do not work for first bank corporation
SELECT * FROM tbl_Employee
WHERE employee_name IN (SELECT employee_name FROM tbl_Works 
WHERE NOT company_name = 'First Bank Corporation');

--2.g) Employees who earn more than each employee of small bank corporation
SELECT employee_name FROM tbl_Works
WHERE salary > ALL (SELECT salary FROM tbl_Works
WHERE company_name = 'Small Bank Corporation') ;

--2.h) Companies located in every city where small bank is located.
SELECT company_name, city FROM tbl_Company
WHERE city IN (SELECT city FROM tbl_Company 
WHERE company_name = 'small bank corporation');

--2.i) Employees who earn more than average salary of all employees of their company
SELECT employee_name FROM tbl_Works
WHERE salary > (SELECT avg(salary) FROM tbl_Works);

--2.j) Company that has the most employees
SELECT  Top 1 company_name,COUNT(employee_name) AS counts FROM tbl_Works
GROUP BY company_name
ORDER BY counts DESC;

--2.k) Company that has the smallest payroll
SELECT company_name,salary FROM tbl_Works
WHERE salary IN (SELECT min(salary) FROM tbl_Works);

--2.l) Companies whose employees earn a higher salary on average than the 
--average salary at first bank corporation.

SELECT company_name FROM tbl_Works
GROUP BY company_name
HAVING avg(salary) > (SELECT avg (salary) FROM tbl_Works
WHERE company_name ='First Bank Corporation');

--3.a) Modify the database so that john smith now lives in Newtown

UPDATE tbl_Employee
SET city='Newtown'
WHERE employee_name='John Smith';

--3.b) Give all the employees of First Bank Corporation a 10% raise

UPDATE tbl_Works
SET salary = salary * 1.1
WHERE company_name = 'First Bank Corporation';

--3.c) Give all the managers of first bank Corporation a 10% raise
UPDATE tbl_Works
SET salary = salary * 1.1
WHERE employee_name IN (SELECT manager_name FROM tbl_Manages)
AND company_name = 'first bank corporation';

--3.d) ?

--3.e) Delete all tuples in the work relation for employees of small bank corporation
DELETE FROM tbl_Works
WHERE company_name = 'Small Bank Corporation';





