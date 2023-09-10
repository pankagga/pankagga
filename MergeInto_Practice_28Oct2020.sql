
DATABASE sysdba;
CREATE SET TABLE department
(department_number SMALLINT,
department_name CHAR(30) NOT NULL,
budget_amount DECIMAL(10,2),
manager_employee_number INTEGER)
UNIQUE PRIMARY INDEX ( department_number )
UNIQUE INDEX ( department_name );

INS INTO employee SEL * FROM customer_service.employee ;

SEL * FROM employee
SEL * FROM department;

INS INTO department VALUES(100,'president',400000.00,801);
INS INTO department VALUES(201,'technical operations',293800.00,1025);
INS INTO department VALUES(301,'research AND development',465600.00,1019);
INS INTO department VALUES(302,'Product planning',226000.00,1016);
INS INTO department VALUES(401,'customer support',982300.00,1003);
INS INTO department VALUES(402,'software support',308000.00,1011);
INS INTO department VALUES(403,'education',932000.00,1005);
INS INTO department VALUES(501,'marketing sales',308000.00,1017);
INS INTO department VALUES(600,'NONE',NULL,1099);

UPDATE department
SET budget_amount = 900000
WHERE department_number = 600
ELSE INSERT INTO department (department_number, department_name, budget_amount, manager_employee_number) 
VALUES (600, 'new dept', 900000, NULL);


UPDATE department
SET budget_amount = 900000
WHERE department_number = 601
ELSE INSERT INTO department (department_number, department_name, budget_amount, manager_employee_number) 
VALUES (601, 'new dept', 900000, NULL);


SELECT department_number AS Dept
, department_name AS DeptName
, budget_amount AS Budget
, manager_employee_number AS Mgr
FROM department
WHERE department_number IN (600, 601);

MERGE INTO department
USING VALUES (700, 'Shipping', 800000.00) AS Dept (deptnum, deptname, budgamt)
ON Dept.deptnum = department_number
WHEN MATCHED THEN UPDATE
SET budget_amount = Dept.budgamt
WHEN NOT MATCHED THEN INSERT
VALUES (Dept.deptnum, Dept.deptname, Dept.budgamt, NULL);

SELECT department_number AS Dept
, department_name AS DeptName
, budget_amount AS Budget
, manager_employee_number AS Mgr
FROM department
WHERE department_number = 700;

SEL * FROM department;

MERGE INTO department
USING VALUES (700, 'Shipping', 9900000.00) AS Dept (deptnum, deptname, budgamt)
ON Dept.deptnum = department_number
WHEN MATCHED THEN UPDATE
SET budget_amount = Dept.budgamt
WHEN NOT MATCHED THEN INSERT
VALUES (Dept.deptnum, Dept.deptname,Dept.budgamt,NULL);
SELECT department_number AS Dept
, department_name AS DeptName
, budget_amount AS Budget
, manager_employee_number AS Mgr
FROM department
WHERE department_number = 700;

CREATE MACRO dept_budget (deptno INT, budget DEC(10,2)) AS (
MERGE INTO department
USING VALUES (:deptno, :budget) AS Dept (deptnum, budgamt)
ON Dept.deptnum = department_number
WHEN MATCHED THEN UPDATE
SET budget_amount = Dept.budgamt
WHEN NOT MATCHED THEN INSERT
VALUES (Dept.deptnum, 'new dept1',Dept.budgamt,NULL);
SELECT department_number AS Dept
, department_name AS DeptName
, budget_amount AS Budget
, manager_employee_number AS Mgr
FROM department
WHERE department_number = :deptno;
);

EXEC dept_budget(600, 940000.00);

EXEC dept_budget(800, 975000.00);

DROP INDEX (department_name) ON department;

REPLACE MACRO dept_budget1 (deptno INT, dept_name VARCHAR(30), budgamt DEC(10,2)) AS (
MERGE INTO department
USING (SELECT :deptno, :dept_name, :budgamt
FROM department
WHERE department_number = :deptno) AS Dept (deptnum, deptname, budgamt)
ON Dept.deptnum = department_number
WHEN MATCHED THEN UPDATE
SET budget_amount = Dept.budgamt, department_name = Dept.deptname
WHEN NOT MATCHED THEN INSERT
VALUES (Dept.deptnum, Dept.deptname,Dept.budgamt,NULL);
);


CREATE SET TABLE customer_service.job
(job_code INTEGER,
description VARCHAR(40) NOT NULL,
hourly_billing_rate DECIMAL(6,2),
hourly_cost_rate DECIMAL(6,2))
UNIQUE PRIMARY INDEX ( job_code )
UNIQUE INDEX ( description );
DROP TABLE job;
CREATE TABLE job AS customer_service.job WITH DATA;
DROP INDEX (description) ON job;

CREATE MACRO job_merge (job INT, bill_rate DEC(6,2), cost_rate DEC(6,2)) AS (
MERGE INTO job
USING VALUES (:job, :bill_rate, :cost_rate) AS job_temp (job, bill, cost)
ON job.job_code = job_temp.job
WHEN MATCHED THEN UPDATE
SET hourly_billing_rate= job_temp.bill,
hourly_cost_rate = job_temp.cost
WHEN NOT MATCHED THEN INSERT
VALUES (job_temp.job, 'new job',job_temp.bill,job_temp.cost);
SELECT job_code AS Job
, description (CHAR(10))AS JobName
, hourly_billing_rate AS Bill_Rate
, hourly_cost_rate AS Cost_Rate
FROM job
WHERE job_code = :job;
);

EXEC job_merge (111100, 26.00, 13.00);

EXEC job_merge (211100, 24.00, 12.00);

SELECT * FROM customer_service.employee;