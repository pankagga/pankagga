--This CTE sample shows how to return rows in a single row format.
--https://forgetcode.com/teradata/1806-returning-multiple-rows-in-one-string-in-one-row

WITH RECURSIVE base (c_year,c_month,c_date,day_of_month,c_list)
AS
(
SELECT year_of_calendar AS c_year
       ,month_of_year AS c_month
       ,calendar_date AS c_date 
       ,day_of_month
       ,Trim(Cast(day_of_month!!':'!!calendar_date AS
VARCHAR(10000))) AS c_list
FROM sys_calendar.CALENDAR
WHERE day_of_month = 1
UNION ALL
SELECT c.year_of_calendar AS c_year
       ,c.month_of_year AS c_month
       ,c.calendar_date AS c_date 
       ,c.day_of_month
       ,b.c_list !! ',' !!
Trim(Cast(c.day_of_month!!':'!!c.calendar_date AS VARCHAR(10000))) AS 
c_list
FROM sys_calendar.CALENDAR c
     JOIN
     base b
        ON b.c_year = c.year_of_calendar
           AND b.c_month = c.month_of_year
           AND b.day_of_month + 1 = c.day_of_month
)
SELECT c_year,c_month,c_list
FROM base
WHERE Add_Months(c_date - Extract(DAY From c_date)+1,1)-1 = c_date 
AND c_year = 2011