/*The GROUPING SETS function permits you to customize your definition of groups for which 'group aggregations' should occur.
When either a single or multi-dimensional aggregations is desired and 
the CUBE or ROLLUP features do not provide the exact combinations that you require, 
the GROUPING SETS function can be used to customize the desired result.
With GROUPING SETS, each group or group combo must be identified explicitly, 
unlike ROLLUP and CUBE which form the grouping sets for you.
With the GROUPING SETS feature, we can explicitly define the groups we desire to be represented in the output.
*/

SELECT department_number AS Dept
, manager_employee_number AS Mgr
, Sum(salary_amount)
FROM employee
WHERE department_number < 402
GROUP BY ROLLUP (department_number, manager_employee_number)
ORDER BY 1,2;

SELECT department_number AS Dept
, manager_employee_number AS Mgr
, Sum(salary_amount)
FROM employee
WHERE department_number < 402
GROUP BY GROUPING SETS (department_number, manager_employee_number)
ORDER BY 1,2;

/*Suppose we wish take the report on the previous page, 
but add an additional line of output representing a grand total (all departments, all managers). 
We can explicitly add the empty set ( ), which will add the grand total to the report.

*/

SELECT department_number AS Dept
, manager_employee_number AS Mgr
, Sum(salary_amount)
FROM employee
WHERE department_number < 402
GROUP BY GROUPING SETS (department_number, manager_employee_number, ())
ORDER BY 1,2;

--If you take the last query but put parentheses around the combination of department and manager, the query would be as follows:
SELECT department_number AS Dept, manager_employee_number AS Mgr, Sum(salary_amount)
FROM employee
WHERE department_number < 402
GROUP BY GROUPING SETS ( (department_number, manager_employee_number) , ())
ORDER BY 1,2;

--Now let's add one last parameter (department_number) to the grouping set. 
--The resulting QUERY IS seen below. Note that the sequence OF parameters IN the GROUPING SETS IS NOT important.

SELECT department_number AS Dept
, manager_employee_number AS Mgr
, Sum(salary_amount)
FROM employee
WHERE department_number < 402
GROUP BY GROUPING SETS ( (department_number, manager_employee_number) , () , department_number)
ORDER BY 1,2;

/*We can see from the example on the previous page that these two expressions are functionally equivalent:
GROUP BY GROUPING SETS ((department_number,manager_employee_number), (), department_number)
GROUP BY ROLLUP (department_number, manager_employee_number)
*/

--You can put multiple GROUPING SETS clauses in a single GROUP BY clause.
SELECT department_number AS Dept
, manager_employee_number AS Mgr
, Sum(salary_amount)
FROM employee
WHERE department_number < 402
GROUP BY GROUPING SETS (department_number),
GROUPING SETS (manager_employee_number)
ORDER BY 1,2;

--GROUPING SETS(A), GROUPING SETS(B) = GROUPING SETS ((A,B))
/*
If we return to our employee table, we can say that:
GROUPING SETS (department_number),
GROUPING SETS ((manager_employee_number), () )
is equivalent to
GROUPING SETS ((department_number, manager_employee_number), (department_number))

So, because (A)(B) = (A,B) and (A)( ) = (A), we can say that:
GROUPING SETS(A), GROUPING SETS(B, () ) = GROUPING SETS ( (A,B), (A) )
*/
SELECT department_number AS Dept
, manager_employee_number AS Mgr
, Sum(salary_amount)
FROM employee
WHERE department_number < 402
GROUP BY GROUPING SETS (department_number),
GROUPING SETS (manager_employee_number, ())
ORDER BY 1,2;
--This is functionally the equivalent of a CUBE
SELECT department_number AS Dept
, manager_employee_number AS Mgr
, Sum(salary_amount)
FROM employee
WHERE department_number < 402
GROUP BY GROUPING SETS (department_number, ()),
GROUPING SETS (manager_employee_number, ())
ORDER BY 1,2;

/*
We have just seen that the following two GROUP BY constructs produce the same result sets:
GROUP BY GROUPING SETS (department_number,( )),
GROUPING SETS (manager_employee_number,( ))
GROUP BY CUBE (department_number,manager_employee_number)
There is at least one other equivalent syntax approach which can also produce this same result for a two-dimensional cube. 
Consider the following:*/
SELECT department_number
, manager_employee_number
, SUM(salary_amount)
FROM employee
WHERE department_number < 402
GROUP BY GROUPING SETS ((department_number,manager_employee_number),
department_number, manager_employee_number,())
ORDER BY 1,2;
/*In this case, all four grouping options are explicitly expressed in a single GROUPING SETS clause. 
This will produce the same result as the preceding two options.
*/

--Equivalent to Rollup
SELECT department_number, job_code, Sum(salary_amount)
FROM employee WHERE department_number < 402
GROUP BY ROLLUP (department_number, job_code)
ORDER BY 1,2;
SELECT department_number, job_code, Sum(salary_amount)
FROM employee WHERE department_number < 402
GROUP BY GROUPING SETS ((department_number, job_code), ( ), department_number)
ORDER BY 1,2;

----Equivalent to CUBE
SELECT department_number, job_code, Sum(salary_amount)
FROM employee WHERE department_number < 402
GROUP BY CUBE (department_number,job_code)
ORDER BY 1,2;
SELECT department_number, job_code, Sum(salary_amount)
FROM employee WHERE department_number < 402
GROUP BY GROUPING SETS (department_number,( ) ),
GROUPING SETS (job_code, ( ) )
ORDER BY 1,2;

----Equivalent Grouping Sets clause
GROUP BY GROUPING SETS (department_number),
GROUPING SETS (job_code, manager_employee_number),
GROUPING SETS (())

GROUP BY GROUPING SETS ((department_number, job_code ), (department_number, manager_employee_number))

