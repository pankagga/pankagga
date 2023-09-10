DATABASE customer_service;
SELECT department_number,Sum(salary_amount)
FROM employee
WHERE department_number < 402
GROUP BY 1
ORDER BY 1;
SELECT department_number,Sum(salary_amount)
FROM employee
WHERE department_number < 402
GROUP BY ROLLUP (department_number)
ORDER BY 1;
SELECT manager_employee_number AS Mgr, department_number AS Dept
, Sum(salary_amount) AS SumSal
FROM employee
WHERE department_number < 402
GROUP BY ROLLUP (manager_employee_number, department_number)
ORDER BY 1,2;
ALTER TABLE employee RENAME mgr_emp_number TO manager_employee_number;
SELECT department_number AS Dept, manager_employee_number AS Mgr
, Sum(salary_amount) AS SumSal
FROM employee
WHERE department_number < 402
GROUP BY ROLLUP (department_number, manager_employee_number)
ORDER BY 1,2;
--Let's return to the earlier example when we looked simply at the one level of 'department'. 
--Recall that a ROW WITH a '?' represents the grand total OF ALL salaries across ALL qualifying departments.
--But what if there was a department number with a null? How would we distinguish between it and a 'total' row?
INSERT INTO employee VALUES (1050,801,NULL,NULL,'LaCoste','Jason',780415,480816,60000.00);

SELECT department_number,Sum(salary_amount)
FROM employee
GROUP BY ROLLUP (department_number)
ORDER BY 1;

SELECT CASE Grouping (department_number)
WHEN 1 THEN 'Total'
ELSE department_number
END AS Deptno
,Sum(salary_amount)
FROM employee
GROUP BY ROLLUP (department_number)
ORDER BY 1;

------------------------

SELECT department_number,job_code,Sum(salary_amount)
FROM employee
GROUP BY ROLLUP (department_number,job_code)
ORDER BY 1,2;

SELECT CASE Grouping (department_number) WHEN 1 THEN 'All Depts' ELSE department_number END AS Deptno
, CASE Grouping (job_code) WHEN 1 THEN 'All Job Codes' ELSE job_code END AS job_code
, Sum(salary_amount)
FROM employee
GROUP BY ROLLUP (department_number,job_code)
ORDER BY 1,2;

SELECT CASE Grouping (department_number) WHEN 1 THEN 'Total Depts' ELSE (Coalesce (department_number,'Null Dept') ) END AS Deptno
, CASE Grouping (job_code) WHEN 1 THEN 'All Job Codes' ELSE (Coalesce (job_code,'Null Job Code') ) END AS job_code
, Sum(salary_amount)
FROM employee
GROUP BY ROLLUP (department_number,job_code)
ORDER BY 1,2;

--Produce a report which rolls up the salaries of employees by job_code within manager. 
--Limit the output to department numbers less than 402
SELECT manager_employee_number,job_code,Sum(salary_amount)
FROM employee WHERE department_number < 402
GROUP BY ROLLUP (manager_employee_number,job_code)
ORDER BY 1,2;
--Produce the same report as #1, eliminating all '?'s representing aggregates in the output.
--USE the GROUPING FUNCTION TO accomplish this. Assume that there are NO NULL job codes OR managers.
SELECT CASE Grouping (manager_employee_number) WHEN 1 THEN 'ManagerTotals' ELSE (Coalesce (manager_employee_number,'Null Dept') ) END AS Manager
, CASE Grouping (job_code) WHEN 1 THEN 'All Job Codes' ELSE (Coalesce (job_code,'Null Job Code') ) END AS job_code
,Sum(salary_amount)
FROM employee WHERE department_number < 402
GROUP BY ROLLUP (manager_employee_number,job_code)
ORDER BY 1,2;
INSERT INTO employee VALUES (1051,801,401,NULL,'LaCoste','Jason',780415,480816,60000.00);
