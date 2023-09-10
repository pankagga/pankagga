--The CUBE FUNCTION can be thought OF AS a superset OF the ROLLUP FUNCTION. 
--INSTEAD producing a 'hierarchy' OF results, CUBE looks AT ALL permutations OF the specified dimensions. 
--It RETURNS the same RESULT SET AS ROLLUP, BUT it also provides additional information.

SELECT department_number AS Deptno, manager_employee_number AS Mgr, Sum(salary_amount) AS SumSal
FROM employee
WHERE department_number < 402
GROUP BY CUBE (department_number, manager_employee_number)
ORDER BY 1,2;
--What happens when we flip the sequence of the CUBE parameters? Consider the following:
--There IS NO difference. The output IS exactly the same. 
--Because the CUBE FUNCTION looks AT ALL permutations OF the specified parameters, 
--ORDER OF the arguments doesn't matter - unlike ROLLUP where it does matter.
SELECT department_number AS Deptno
, manager_employee_number AS Mgr
, Sum(salary_amount) AS SumSal
FROM employee
WHERE department_number < 402
GROUP BY CUBE (manager_employee_number, department_number)
ORDER BY 1,2;

SELECT CASE Grouping (department_number)
WHEN 1 THEN 'All Depts'
ELSE (Coalesce (department_number,'Null Dept') )
END AS Deptno
, CASE Grouping (manager_employee_number)
WHEN 1 THEN 'All Managers'
ELSE manager_employee_number
END AS Mgr
, Sum(salary_amount) AS SumSal
FROM employee
WHERE department_number < 402
GROUP BY CUBE (manager_employee_number, department_number)
ORDER BY 1,2;

SELECT CASE Grouping (department_number)
WHEN 1 THEN 'All Depts'
ELSE (Coalesce (department_number,'Null Dept') )
END AS Deptno
, CASE Grouping (manager_employee_number)
WHEN 1 THEN 'All Managers'
ELSE manager_employee_number
END AS Mgr
, CASE Grouping (job_code)
WHEN 1 THEN 'All Job Codes'
ELSE (Coalesce (job_code,'Null Job Code') )
END AS Job
, Sum(salary_amount) AS SumSal
FROM employee
WHERE department_number < 302
GROUP BY CUBE (manager_employee_number, department_number, job_code)
ORDER BY 1,2,3;

--Create a cube report showing employee salaries using the dimensions of manager and job code. 
--RESTRICT the report TO department numbers BETWEEN 302 AND 401 inclusive.

SELECT manager_employee_number
, job_code
, Sum(salary_amount)
FROM employee
WHERE department_number BETWEEN 302 AND 401
GROUP BY CUBE (manager_employee_number, job_code)
ORDER BY 1,2;

--Rerun the report again, this time adding appropriate GROUPING and COALESCE functions to eliminate all '?'s from the report. 
--Be sure to account for the null job code in the COALESCE processing.

SELECT CASE Grouping (manager_employee_number)
WHEN 1 THEN 'All Managers'
ELSE manager_employee_number
END AS manager_employee_number
, CASE Grouping (job_code)
WHEN 1 THEN 'All Job Codes'
ELSE (Coalesce (job_code,'Null Job Code') )
END AS job_code
, Sum(salary_amount)
FROM employee
WHERE department_number BETWEEN 302 AND 401
GROUP BY CUBE (manager_employee_number, job_code)
ORDER BY 1,2;