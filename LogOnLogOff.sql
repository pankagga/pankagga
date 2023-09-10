Logon-Logoff
-------------------------

Users logged in for certain interval (Please see the argument you need to give to execute the macro.)
------------------------------------------------------

REPLACE MACRO USERCOUNT
(D1 DATE DEFAULT DATE
,T1 FLOAT DEFAULT 120000
,D2 DATE DEFAULT DATE
,T2 FLOAT DEFAULT 120000)
AS
(
SEL	 COUNT( A.SESSIONNO)(TITLE'NUMBER OF LOGONS/LOGOFFS')(FORMAT'ZZZZZZ9')
FROM	 DBC.LOGONOFF A, DBC.LOGONOFF B
WHERE	 A.EVENT='LOGON'
	AND	 B.EVENT<>'LOGON'
	AND	 A.SESSIONNO=B.SESSIONNO
	AND	 A.IFPNO=B.IFPNO
	AND	 A.LOGONDATE=B.LOGONDATE
	AND	 A.LOGONTIME=B.LOGONTIME
	AND	 ((A.LOGDATE=:D2 
	AND	 A.LOGTIME<=:T2)
	OR	 A.LOGDATE<:D2)
	AND	 ((B.LOGDATE=:D1 
	AND	 B.LOGTIME>=:T1)
	OR	 B.LOGDATE>:D1)
ORDER	 BY 1;
);


OUTPUT -
----------
exec usercount(date-20,120000,date-10,120000);

 *** Query completed. One row found. One column returned.
 *** Total elapsed time was 1 second.

NUMBER OF LOGONS/LOGOFFS
------------------------
                      34

------------------------------------------------------


Users which were logged on for less then a minute
------------------------------------------------------

SELECT A.USERNAME(TITLE'USER')(FORMAT'X(12)')
   ,A.SESSIONNO(TITLE'SESSION')(FORMAT'ZZZZZZ9')
   ,A.LOGTIME (NAMED LOGEND)(TITLE'')
   ,A.LOGDATE (TITLE'LOGON')
   ,A.LOGTIME (NAMED LOGEND)(TITLE'')
   ,B.LOGDATE(TITLE'LOGOFF')
   ,B.LOGTIME (NAMED LOGBEGIN)(TITLE'')
FROM	 DBC.LOGONOFF A, DBC.LOGONOFF B
WHERE	 A.EVENT='LOGON'
	AND	  B.EVENT<>'LOGON'
	AND	  A.SESSIONNO=B.SESSIONNO
	AND	  A.LOGONDATE=B.LOGONDATE
	AND	  A.LOGONTIME=B.LOGONTIME
/* ENDING DATE & TIME */
	AND	 ((A.LOGDATE= DATE 
	AND	 A.LOGTIME <= TIME)
	OR	 A.LOGDATE < DATE)
/* BEGINNING DATE & TIME  0 = MIDNIGHT, 120000 = NOON */
	AND	 ((B.LOGDATE = DATE-1 
	AND	 B.LOGTIME >= 0)
	OR	 B.LOGDATE > DATE-1)
	AND	 (LOGEND-LOGBEGIN > -1.0)
ORDER	 BY A.LOGONDATE,A.LOGONTIME;

Output -
--------

USER          SESSION                  LOGON                 LOGOFF
------------  -------               --------               --------
DBC              1062  08:01:33.49  13/10/23  08:01:33.49  13/10/23  08:01:34.43
DBC              1063  08:02:47.40  13/10/23  08:02:47.40  13/10/23  08:02:47.75
DBC              1064  08:05:40.33  13/10/23  08:05:40.33  13/10/23  08:05:40.96

------------------------------------------------------
Logon Count for Certain Time Period
------------------------------------------------------

Following is a query to display how many times each user logged into your Teradata System in a given time period. By default the query returns information for the current date. For different dates, substitute date with the actual date in single quotes (i.e. '2001/07/31' for July 31, 2001). You can also substitute date with expressions such as date-1 (yesterday), date-2 (two days ago), etc.

SELECT D.DATABASENAME (TITLE 'USERNAME'),
COUNT(*) (TITLE '# OF//LOGINS', FORMAT 'ZZZZZ9')
FROM	 DBC.LOGONOFF L , DBC.DATABASES D
WHERE	 L.USERNAME = D.DATABASENAME
	AND	 LOGONDATE=(DATE)
	AND	 EVENT = 'LOGON'
GROUP	 BY 1 
WITH	 SUM (1) (TITLE 'TOTAL                         ', FORMAT 'ZZZZZ9')
ORDER	 BY 2 DESC;

Output -
                                  # OF
USERNAME                        LOGINS
------------------------------  ------
DBC                                 12
PDCRTPCD                             4
                                ------
TOTAL                               16

------------------------------------------------------
Failed logon attempts during the last seven days
------------------------------------------------------

SELECT LOGDATE,LOGTIME,USERNAME (FORMAT 'X(10)'),EVENT
FROM	 DBC.LOGONOFF
WHERE	 EVENT NOT LIKE ('%LOGO%') 
	AND	 LOGDATE GT DATE - 7
ORDER	 BY LOGDATE, LOGTIME ;

Output-


 *** Query completed. One row found. 4 columns returned.
 *** Total elapsed time was 1 second.

 LogDate      LogTime  UserName    Event
--------  -----------  ----------  ------------
13/10/23  06:02:43.34  Non-existe  Bad User

------------------------------------------------------
