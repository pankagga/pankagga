14.6	DBQL 

Table Accessed
----------------
SELECT OBJECTTABLENAME 
FROM	 DBC.QRYLOGOBJECTS 
WHERE	 CAST (COLLECTTIMESTAMP AS DATE) > DATE-7 
	AND	 OBJECTTYPE <> 'D';
--------------------------------------------------------------------------------------


Top CPU Consuming Statements from DBQL
-------------------------------------------
SELECT QueryText, TotalCPUTime, rank () over (
order	 by TotalCPUTime DESC) as ranking 
from	 DBC.QryLog 
where	 cast(CollectTimeStamp as date) = date 
qualify	 ranking <=10
--------------------------------------------------------------------------------------



Query executed more then certain Time Period
-------------------------------------------------
SELECT QUERYTEXT, TOTALCPUTIME, RANK () OVER (
ORDER	 BY TOTALCPUTIME DESC) AS RANKING 
FROM	 DBC.QRYLOG 
WHERE	 CAST(COLLECTTIMESTAMP AS DATE) = DATE 
QUALIFY	 RANKING <=10
--------------------------------------------------------------------------------------

Number of Queries by Users
------------------------------
SELECT 					
USERNAME UNAME,					
COUNT(*)					
FROM					
DBC.QRYLOG					
WHERE CAST(COLLECTTIMESTAMP AS DATE)  >DATE 
AND UNAME NOT IN 					
(					
'DBCMANAGER'        					
,'P_LOAD_H01'   					
,'P_BRIO_USER'      					
,'DBC'                                          					
)					
GROUP BY 1		
--------------------------------------------------------------------------------------

Top Applications accessing Teradata Node
-------------------------------------------
SELECT TOP 10 APPID ,COUNT(*) 
FROM  DBC.QRYLOG  
GROUP  BY 1;

Output-
------
AppID                              Count(*)
------------------------------  -----------
BTEQ                                      2

--------------------------------------------------------------------------------------

