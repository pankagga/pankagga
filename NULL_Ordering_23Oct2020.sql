/*The FULL syntax TO support this feature IS AS follows:
ORDER BY column1 (ASC/DESC) NULLS (FIRST/LAST),
colunm2 (ASC/DESC) NULLS (FIRST/LAST), etc.

Example WITH NULL ORDERING
SELECT country, state, Sum(sales), Sum(cogs)
FROM market, fact
WHERE market.marketid = fact.marketid
GROUP BY ROLLUP (country, state)
ORDER BY 1 NULLS LAST, 2 NULLS LAST;

*/

SELECT manager_employee_number AS Mgr
, department_number AS Dept
, Sum(salary_amount) AS SumSal
FROM employee
WHERE department_number < 402
GROUP BY ROLLUP (manager_employee_number, department_number)
ORDER BY 1 NULLS LAST, 2 NULLS LAST;

SELECT CASE Grouping (manager_employee_number)
WHEN 1 THEN 'GRAND TOTAL'
ELSE manager_employee_number
END AS Manager
, CASE Grouping (department_number)
WHEN 1 THEN 'Dept Total'
ELSE department_number
END AS Deptno
, Sum(salary_amount) AS SumSal
FROM employee
WHERE department_number < 402
GROUP BY ROLLUP (manager_employee_number, department_number)
ORDER BY 1 NULLS LAST, 2 NULLS LAST;

SELECT CASE Grouping (manager_employee_number)
WHEN 1 THEN 'GRAND TOTAL'
ELSE manager_employee_number
END AS Manager
, CASE Grouping (department_number)
WHEN 1 THEN 'Dept Total'
ELSE department_number
END AS Deptno
, Sum(salary_amount) AS SumSal
FROM employee
WHERE department_number < 402
GROUP BY ROLLUP (manager_employee_number, department_number)
ORDER BY 1,2;