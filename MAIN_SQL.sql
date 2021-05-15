-----------------------------------------
HOW TO KNOW THE VERSION OF THE TD
----------------------------------------

sel * from dbc.dbcinfo

-------------------------------------------
Knowing DB Growth Weekwise - PDCR Data
---------------------------------------------

--Locking table sys_mgmt.databasespacehst for access
SELECT
    year_of_calendar
   ,Month_of_Year
   ,Week_of_year
   ,logdate
   ,SUM(CURRENTPERM)     AS CURRENT_PERM
   ,SUM(MAXPERM)         AS MAX_PERM
   ,(MAX_PERM - CURRENT_PERM) AS AVAILABLE_PERM
 FROM PDCRDATA.DATABASESPACE_HST a 
INNER JOIN PDCRINFO.Calendar c
 ON a.Logdate = c.Calendar_date
WHERE  a.LogDate BETWEEN cast('01/03/2013' as date format 'dd/mm/yyyy') and cast('31/07/2013' as date format 'dd/mm/yyyy')
 AND  c.Calendar_date BETWEEN cast('01/03/2013' as date format 'dd/mm/yyyy') and cast('31/07/2013' as date format 'dd/mm/yyyy')
 GROUP BY 1,2,3,4
 Order by 1,2,3,4  ;


select * from pdcrinfo.Calendar where Year_of_Calendar=2013
order by 1


select 
logdate
,DatabaseName
,CurrentPerm
,peakperm
,MaxPerm
 from pdcrdata.databasespace_hst a
 INNER JOIN PDCRINFO.Calendar c
 ON a.Logdate = c.Calendar_date
where logdate > cast('28/02/2013' as date format 'dd/mm/yyyy')
and databasename = 'SYS_MGMT'
order by DatabaseName,LogDate desc 

select 
logdate
,DatabaseName
,CurrentPerm
,peakperm
,MaxPerm
 from pdcrdata.databasespace_hst a
 INNER JOIN PDCRINFO.Calendar c
 ON a.Logdate = c.Calendar_date
where logdate > cast('28/02/2013' as date format 'dd/mm/yyyy')
--and day_of_month in (7,14,28,21)
and day_of_week=1
and month_of_year in (3,4,5)
order by DatabaseName,LogDate  


select distinct databaseName 
from pdcrdata.databasespace_hst 
where logdate > cast('28/02/2013' as date format 'dd/mm/yyyy')
order by 1

----------------------------------
Knowing Databasesize and FreeSpace
----------------------------------

select databaseName,sum(peakPerm)/1024/1024,sum(currentPerm)/1024/1024  from dbc.diskspace
group by databaseName
order by 2 desc

SELECT Databasename (format 'X(15)')
,SUM(maxperm)/(1024*1024*1024)(FORMAT 'zzzz9.99', TITLE 'Maxperm-GB')
,SUM(currentperm) /(1024*1024*1024)(FORMAT 'zzzz9.99', TITLE 'Currentperm-GB')
,(SUM(maxperm) - SUM(currentperm))/(1024*1024*1024)(FORMAT 'zzzz9.99', TITLE 'Free-GB')
,((SUM(currentperm))/ NULLIFZERO (SUM(maxperm)) * 100) (FORMAT 'zz9.99%', TITLE 'Percent // Used')
FROM DBC.DiskSpace
WHERE
MAXPERM <> 0 
--and databasename in (SELECT child FROM dbc.children WHERE parent='DBC')
GROUP BY 1
order by 3 desc


SELECT Databasename (format 'X(15)')
,SUM(maxperm)/(1024*1024)(FORMAT 'zzzz9.99', TITLE 'Maxperm-GB')
,SUM(currentperm) /(1024*1024)(FORMAT 'zzzz9.99', TITLE 'Currentperm-GB')
,SUM(peakperm) /(1024*1024)(FORMAT 'zzzz9.99', TITLE 'peakperm-GB')
,(SUM(maxperm) - SUM(currentperm))/(1024*1024)(FORMAT 'zzzz9.99', TITLE 'Free-GB')
,((SUM(currentperm))/ NULLIFZERO (SUM(maxperm)) * 100) (FORMAT 'zz9.99%', TITLE 'Percent // Used')
FROM DBC.DiskSpace
WHERE
MAXPERM <> 0 
--and databasename in (SELECT child FROM dbc.children WHERE parent='DBC')
GROUP BY 1
order by 3 desc

-----------------------
Knowing Tablesize
-----------------------

sel * from dbc.tablesize
where
currentperm > 100000
order by currentperm desc

sel databasename, tablename , sum(currentperm), sum(currentperm)/1024/1024/1024 Size_GB  from dbc.tablesize
group by databasename,tablename
order by  3 desc

sel 
count(*)
,aa.Size_GB 
from
(sel databasename, tablename , sum(currentperm) Size_Perm, sum(currentperm)/1024/1024/1024 Size_GB  from dbc.tablesize
group by databasename,tablename
)  aa
group by  aa.Size_GB
order by 2 desc

sel databasename, tablename , sum(currentperm) Size_Perm, sum(currentperm)/1024/1024/1024 Size_GB  from dbc.tablesize
group by databasename,tablename

-------------------------------------
Skewed Data
-------------------------------------

locking row for access
select count(*),LEAD_KEY_ID
from iCRM_STAGE_TBL.MAIL_CAMP_RSP_STG_R2
group by LEAD_KEY_ID
order by 1 desc;

PI is LEAD_KEY_ID

------------------------------------

------------------------------------
To get the information about any table/view/macro in the system
------------------------------------

select * from dbc.tablesv
where tablekind='V'
and tablename like '%Extarct1_INGHH%'

------------------------------------
Updating space for any DB in DBC
------------------------------------

PG1CP_1-6:~ # which cnsterm
/usr/pde/bin/cnsterm
PG1CP_1-6:~ # cnsterm 6
Attempting to connect to CNS...Completed.
Hello
stop 4
CNSSUPV 'stop': Screen 4 (updatespace) is stopped!! at Sat May 18 01:09:19 2013
Input Supervisor Command:
exit
^
71: Could not recognize command 'exit'
Input Supervisor Command:
start checktable
Started 'checktable' in window 4
 at Sat May 18 01:18:19 2013
Input Supervisor Command:
> start updatespace
start updatespace
Started 'updatespace' in window 4
 at Mon May 20 02:52:58 2013

Input Supervisor Command:
>
PG1CP_1-6:~ # cnsterm 4
Attempting to connect to CNS...Completed.
Hello
    Release 13.10.05.10 Version 13.10.05.11
    UPDATE SPACE Utility (Dec 94)

The Update Space program provides for recalculating the
permanent database space or temporary space or spool
space used by a single database or by all databases in
the system.
The format of the input command is:
UPDATE [SPOOL | TEMPORARY | ALL] SPACE FOR {ALL DATABASES | dbname} ;
Enter either ALL DATABASES or the name of the database for which space is to be recalculated.  The SPOOL parameter is only allowed with a single database.

Enter Command
> UPDATE ALL SPACE FOR PG_MONITOR;
UPDATE ALL SPACE FOR PG_MONITOR;

Updating space for PG_MONITOR
Space updated for PG_MONITOR
Enter QUIT or CONTINUE.
> quit
quit
Ctrl C

===================================================================
UNUSED OBJECTS
===================================================================
select count(*) cnt, tablekind from 
(select
databaseName, TableName, TableKind, ProtectionType, CreatorName,
createTimeStamp, LastAlterTimeStamp, LastAccessTimeStamp
from dbc.Tablesv
where LastAccessTimeStamp is not null ) a
group by 2

--where extract(year from Last AccessTimeStamp) < 2013



select
databaseName, TableName, TableKind, ProtectionType, CreatorName,
createTimeStamp, LastAlterTimeStamp, LastAccessTimeStamp
from dbc.Tablesv
where LastAccessTimeStamp is not null 
order by 8 

select 
databaseName, TableName, TableKind, ProtectionType, CreatorName,
createTimeStamp, LastAlterTimeStamp, LastAccessTimeStamp
from 
dbc.tablesv
where databasename = 'ETL_CTRL'

===================================================================
CREATING a TABLE from EXSTING TABLE

create table user_work.tabs
as (sel databasename,tablename from dbc.tables 
where 1=2)
with no data
===================================================================
EXTRACTING DATA FROM DBQL TABLE FOR A PARTICULAR QUERY

select * from DBC.DBQLogTbl 
where 
QueryText like '%SELECT%CNSMR_CNTCT_SNPSH%'
and clientID='PA186013'
and AppID='SQLA'
order by collecttimestamp desc

===================================================================
How to find tables that have a PPI
In teradata we use lot of data dictionary tables (dbc)  to find definition/details about anything related to data.

How to find the tables which have PPI(partitioned primary index) ?
We make use of DBC.indices view to find any details regrading index.

Query :


SEL * FROM dbc.indices
WHERE indextype = 'Q'          ---- 'Q' means Partitioned Primary Index
AND databasename = 'DATABASENAME' ;

SEL distinct databasename,tablename FROM DBC.INDEXSTATS
where indextype='Q'
and indexstatistics is null
and (databasename,tablename ) not in
(SEL distinct databasename,tablename FROM DBC.INDEXSTATS
where indextype='Q'
and indexstatistics is not null)


======================================================================

--EXTRACTING DATA FROM PDCR.DBQLogTbl_HST TABLE FOR A PARTICULAR QUERY

select * from PDCRDATA.DBQLogTbl_Hst
where 
QueryText like '%CREATE%'
and clientID='PA186013'
order by collecttimestamp desc

===========================================================================

----TO KNOW THE ACCESSRIGHTS OF ANY USER ON ANY TABLE / DATABASE

sel tab1.*,tab2.databasename, tab3.tvmnamei from 
(sel a.*,b.databasename from dbc.accessrights a,dbc.dbase b
where a.userid=b.databaseid
and b.databasename = 'KPI_TBL'
and accessright='R') tab1 , dbc.dbase tab2, dbc.tvm tab3
where tab1.databaseid=tab2.databaseid
and tab1.tvmid=tab3.tvmid

====================================================================

----Collect Stats
---Collect Statistics Syntax in Teradata
---The following are the Collect Statistics Syntaxes in Teradata.

“COLLECT STATISTICS ON tablename COLUMN columnname;” will collect statistics  on a column.

                .
“COLLECT STATISTICS ON tablename INDEX (columnname)” will collect statistics  on an index.
                    
“COLLECT STATISTICS ON tablename INDEX (col1, col2, ...)” will collect statistics  on multiple columns of an index.                      

“HELP STATISTICS tablename;” will display the number of distinct values of the columns. 
                        
“COLLECT STATISTICS tablename;” refreshes (recollects) the table statistics.

“DROP STATISTICS ON tablename ... ;" will drop the statistics.
 
---------- Read the following links
 
http://www.teradata-sql.com/2012/03/collect-statistics.html
http://www.teradata-sql.com/2012/06/list-of-interview-questions-on-collect.html
http://www.teradata-sql.com/2012/04/collect-statistics-syntax-in-teradata.html
 
========================================================================

---INSERT SELECT Syntax

INSERT SELECT and other values

The correct syntax could be insert into [column list] select [column list] from table;

========================================================================

RENAMING a TABLE

Teradata SQL to rename a table
November 23rd, 2009 1 Comment
If you need to rename a table in the Teradata database, use the general SQL below as a template for renaming your table:

rename table DATABASE.TABLECURRENT to DATABASE.TABLENEW;
where:

DATABASE = the database name where the table resides
TABLECURRENT = the current table name
TABLENEW = the new table name you would like.

===========================================================================
INSERTING BYTE DATA in TERADATA
Hi, 

I have a column in teradata table defined as byte(2). 
How can I insert Hex data (say for ex: 'D0C6') into this table in Datastage. 
Do i have to use a Modify stage and if so, what is the conversion function needed to convert data into byte format. 

P.S.: from command line this is how i insert data into teradata column 
insert into <table_name> values ('D0C6'XB); 
XB lets me insert byte data!!
===========================================================================
Method #2 (QueryID extracted) 
If the Query ID is not saved or captured, it may be extracted from DBC.DBQLogTbl if DBQL is enabled.
/* the following three lines are BTEQ commands to control the display of the result */
.sidetitles on
.foldline on
.width 240 
SELECT QueryText, StartTime, QueryId(FORMAT '-Z(17)9')
FROM DBC.DBQLogTbl
WHERE UserName='myusername' ORDER BY 1;  
*** Query completed. 2 rows found. 3 columns returned. 
*** Total elapsed time was 1 second. 
Results: 
QueryText MERGE INTO tgt USING src ON tgt.c1=src.c1 
WHEN MATCHED THEN UPDATE SET c5=src.c3 WHEN NOT MATCHED 
THEN INSERT(src.c1,src.c2,src.c3,src.c4,src.c5) LOGGING 
ALL ERRORS;
StartTime 2007-03-08 16:44:25.79 
QueryID 95051697889477917
QueryText SELECT ETC_ErrorCode, ETC_dbql_qid, 
ETC_DmlType, ETC_IdxErrType, ETC_RowId FROM ET_tgt ORDER 
BY 1; 
StartTime 2007-03-08 16:44:25.84 
QueryID 95051697889477918 
===========================================================================

Changing Password

Hi,how can I change the password of a Teradata login ?
MODIFY USER Myuserid AS PASSWORD = mypass;
i used "DBC" to do that, but failed, it says "3524: The user does not have DROP USER access to database xyz. "i couldn't understand why system needs to drop user access since it's just password change
You can use the Teradata Administrator to change your password. Go to -->Tool --> Modify Userand change your password over there
From Data definitions statements manual.To execute the MODIFY USER statementIF you are … | THEN you must have the DROP USER privilege on not the user being modified the referenced user. 
You should be able to do a GRANT DROP USER on userid TO DBC; from DBC and then execute the MODIFY USER statement.
===========================================================================
