SPACE MANAGEMENT
=================
Total disk space
------------------------------
SELECT	SUM (MaxPerm) FROM DBC.DiskspaceV;

Percent of disk space in use
------------------------------
SELECT ((SUM(CURRENTPERM) / NULLIFZERO(SUM(MAXPERM)) * 100)) (TITLE '%PERM', FORMAT 'ZZ9.99') FROM DBC.DISKSPACE;

Percent of disk space free
------------------------------
SELECT (((SUM(MAXPERM) - (SUM(CURRENTPERM)) - SUM(CURRENTSPOOL)) / NULLIFZERO(SUM(MAXPERM))) * 100)(TITLE'% FREE', FORMAT'ZZ9.99') FROM  DBC.DISKSPACE;

Percent of disk avail for spool
----------------------------------
SELECT (((SUM(MAXPERM) - SUM(CURRENTPERM)) / NULLIFZERO(SUM(MAXPERM))) * 100) (TITLE'% AVAIL FOR SPOOL', FORMAT'ZZ9.99')  FROM  DBC.DISKSPACE;

Disk space for a given database
-----------------------------------
SELECT SUM(MAXPERM) 
FROM	 DBC.DISKSPACE 
WHERE	 DATABASENAME='DBC';

Disk space for a given table
------------------------------
SELECT SUM(CURRENTPERM)
FROM	 DBC.TABLESIZE
WHERE	 DATABASENAME='PD'
AND	 TABLENAME = 'EMPLOYEE';

What is the table distribution per amp
------------------------------------------------------------
SELECT TABLENAME (TITLE 'TABLE') ,CURRENTPERM (TITLE 'CURPERM') ,VPROC (TITLE 'AMP') 
FROM	 DBC.TABLESIZE 
WHERE	 DATABASENAME='PD'
	AND	 TABLENAME = 'EMPLOYEE' 
ORDER	 BY 2 DESC;

Amount of MaxPerm, currentperm & free perm for a given db
------------------------------------------------------------
SELECT DATABASENAME (FORMAT 'X(12)') ,SUM(MAXPERM) ,SUM(CURRENTPERM) ,(SUM(CURRENTPERM) / NULLIFZERO(SUM(MAXPERM))*100)(FORMAT 'ZZ9.99%', TITLE 'PERCENT // USED') 
FROM	 DBC.DISKSPACE 
WHERE	 DATABASENAME = 'DBC' 
GROUP	 BY 1;

Who is Running out of Perm Space 
----------------------------------
SELECT DATABASENAME (FORMAT 'X(12)')
,SUM(MAXPERM)
,SUM(CURRENTPERM)
,((SUM(CURRENTPERM))/
NULLIFZERO (SUM(MAXPERM)) * 100)
(FORMAT 'ZZ9.99%', TITLE 'PERCENT // USED')
FROM	 DBC.DISKSPACE
GROUP	 BY 1 
HAVING	 (SUM(CURRENTPERM) / NULLIFZERO(SUM(MAXPERM))) > 0.9
ORDER	 BY 4 DESC;

Who has a lot of perm space
------------------------------
SELECT DATABASENAME (FORMAT 'X(12)')
,SUM(MAXPERM)
,SUM(CURRENTPERM)
,((SUM(CURRENTPERM))/
NULLIFZERO (SUM(MAXPERM)) * 100)
(FORMAT 'ZZ9.99%', TITLE 'PERCENT // USED')
FROM DBC.DISKSPACE
GROUP BY 1 HAVING (SUM(CURRENTPERM) / NULLIFZERO(SUM(MAXPERM))) < 0.5
ORDER BY 4;

Who is using high spool
------------------------------
SELECT DATABASENAME
,SUM(PEAKSPOOL)
FROM	 DBC.DISKSPACE
GROUP  BY 1 
HAVING  SUM(PEAKSPOOL) > 5000000000
ORDER  BY 2 DESC;

=====================================================================================
