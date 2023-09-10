DATABASE customer_service

SELECT last_name
, department_number AS deptno
, salary_amount
FROM employee ee
WHERE salary_amount =
(SELECT Max (salary_amount)
FROM employee em
WHERE em.department_number = ee.department_number)
;

SELECT last_name
,salary_amount
FROM employee ee
WHERE salary_amount >
(SELECT Avg (salary_amount)
FROM employee em
WHERE em.department_number = ee.department_number) ;
DATABASE pd;
SELECT job_code
FROM job
WHERE job_code NOT IN
(SELECT job_code
FROM employee) ;

SELECT job_code
FROM job
WHERE NOT EXISTS
(SELECT *
FROM employee ee
WHERE ee.job_code = job.job_code);

ALTER TABLE department RENAME dept_number AS department_number;

--Show the employee number, department number, and salary of all department managers who have the highest salary in their department.

SELECT d.Dept_Mgr_Number AS mgrEmp#,d.dept_number AS dept,e.salary_amount AS salary
FROM department d INNER JOIN employee e
ON e.employee_number = d.Dept_Mgr_Number

WHERE e.salary_amount = 
(
SELECT Max(salary_amount) FROM employee em 
WHERE em.department_number = d.dept_number) ;



/*
1.) Use a correlated subquery to produce a report showing 
employee last name, salary, and department number for all employees 
whose salary is greater than their department average. Sort by salary within department number.
*/
SEL last_name,salary_amount,department_number FROM employee em
WHERE salary_amount > (SELECT Avg(salary_amount) FROM employee ea
WHERE ea.department_number = em.department_number);
/*
2.) Using a derived table, produce the same report as in lab #1 but adding an additional 
column showing the department average after the employee's salary.
*/
SEL last_name,salary_amount,avg_sal,em.department_number FROM employee em,
(SELECT Avg(salary_amount) avg_sal,department_number FROM employee GROUP BY 2) ea
WHERE em.department_number=ea.department_number
AND salary_amount>avg_sal;

/*
3.) Produce a list of all department numbers which have no employees using NOT IN. 
Redesign the query using NOT EXISTS to get the same results.
*/

INSERT INTO department VALUES(2999,'PERSONAL',999999,98989898.00);

SEL  dept_number FROM department WHERE dept_number NOT IN 
(SELECT DISTINCT department_number FROM  employee);

SEL  dept_number FROM department de WHERE NOT EXISTS
(SELECT * FROM  employee ee WHERE ee.department_number=de.dept_number);

/*
4.) MODIFY lab #1 TO produce the same report BUT adding department NAME TO the listing. 
SHOW ONLY the FIRST 12 Characters OF department NAME AND GIVE the COLUMN a TITLE OF 'department'. 
Retain the sort BY department NUMBER AND salary FOR ease OF comparison.
*/
SEL --last_name,salary_amount,department_number,
de.dept_name (FORMAT 'X(12)') AS DEPARTMEnt
FROM employee em INNER JOIN department de
ON em.department_number=de.dept_number
WHERE salary_amount > (SELECT Avg(salary_amount) FROM employee ea
WHERE ea.department_number = em.department_number)
--ORDER BY 3,2 DESC
;


