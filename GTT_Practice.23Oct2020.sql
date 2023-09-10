CREATE GLOBAL TEMPORARY TABLE gt_deptsal 
(deptno SMALLINT ,avgsal DEC(9,2) ,maxsal DEC(9,2) ,minsal DEC(9,2) ,sumsal DEC(9,2) ,empcnt SMALLINT) 
UNIQUE PRIMARY INDEX (deptno);
SHOW TABLE gt_deptsal;
ALTER TABLE gt_deptsal, ON COMMIT PRESERVE ROWS;

CREATE VIEW emp AS 
SEL employee_number AS empno, dept_number AS deptno, first_name AS ename,salary_amount AS sal,
emp_mgr_number AS mgr,job_code AS job_code  FROM pd.employee;

SEL * FROM emp;

INS INTO gt_deptsal SEL dept,Avg(sal), Max(sal),Min(sal),Sum(sal),Count(emp)  FROM emp GROUP BY 1;

REPLACE VIEW emp AS 
SEL employee_number AS empno, dept_number AS dept, first_name AS ename,salary_amount AS sal,
emp_mgr_number AS mgr,job_code AS job_code  FROM pd.employee;

INS INTO gt_deptsal SEL dept,Avg(sal), Max(sal),Min(sal),Sum(sal),Count(empno)  FROM emp GROUP BY 1;
SEL * FROM gt_deptsal;
